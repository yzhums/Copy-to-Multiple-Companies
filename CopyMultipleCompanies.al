pageextension 50123 ZYCompaniesExt extends Companies
{
    actions
    {
        addfirst(processing)
        {
            action(CopyMultipleCompanies)
            {
                Caption = 'Copy to Multiple Companies';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Copy;

                trigger OnAction()
                var
                    CopyMultiCompaniesPage: Page "Copy to Multiple Companies";
                begin
                    CopyMultiCompaniesPage.SetSourceName(Rec.Name);
                    if CopyMultiCompaniesPage.RunModal() = Action::OK then
                        CopyMultiCompaniesPage.CopytoMultipleCompanies();
                end;
            }
        }
    }
}

page 50100 "Copy to Multiple Companies"
{
    PageType = StandardDialog;
    Caption = 'Copy to Multiple Companies';
    layout
    {
        area(content)
        {
            field(SourceName; SourceName)
            {
                ApplicationArea = All;
                Caption = 'Source Name';
                Editable = false;
            }
            field(DestinationName; DestinationName)
            {
                ApplicationArea = All;
                Caption = 'Destination Name';
            }
            field(NumberOfCopies; NumberOfCopies)
            {
                ApplicationArea = All;
                Caption = 'Number of Copies';
            }
        }
    }
    var
        SourceName: Code[30];
        DestinationName: Code[30];
        NumberOfCopies: Integer;
        PictureURL: Text;

    procedure SetSourceName(NewSourceName: Code[30])
    begin
        SourceName := NewSourceName;
    end;

    procedure CopytoMultipleCompanies()
    var
        i: Integer;
        NewCompanyName: Text[30];
        ProgressWindow: Dialog;
        ProgressMsg: Label 'Creating new company %1.';
        CopySuccessMsg: Label 'Company %1 has been copied successfully.';
    begin
        if (NumberOfCopies <> 0) and (DestinationName <> '') then begin
            for i := 1 to NumberOfCopies do begin
                NewCompanyName := DestinationName + ' ' + Format(i);
                ProgressWindow.Open(StrSubstNo(ProgressMsg, NewCompanyName));
                CopyCompany(SourceName, NewCompanyName);
            end;
            ProgressWindow.Close();
            Message(CopySuccessMsg, SourceName);
        end;
    end;
}
