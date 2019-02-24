%lex
%%

\n+                 return 'NEW_LINE'
\s+                 /* skip whitespace */
"__"                return 'ITALICS'
[a-zA-Z0-9\s]+\b    return 'TEXT'
[#]+                return 'HEADER'
"***"               return 'BOLD_ITALIC'
"**"                return 'BOLD'
"*"                 return 'BULLET'
"-"                 return 'BULLET'
"```"               return 'SNIPPET'
">"                 return 'QUOTE'
<<EOF>>             return 'EOF'
.                   return 'INVALID'

/lex

%start expressions
%% 

expressions
    : lines EOF
        {
            console.log($1);
            return $1;
        }
    ;

lines
    : line NEW_LINE lines
        {
            $$ = $1.concat($3);
        }
    | line NEW_LINE
        {$$ = $1;}
    | NEW_LINE line
        {$$ = $2;}
    | line
        {$$ = $1;}
;

line
    : HEADER line
        {
            if($1.length > 6){
                $$ = $1.concat(" ",$2);
            } else
                $$ = `<h${$1.length}>${$2}</h${$1.length}>`;
        }
    | ITALICS line ITALICS
        {
            $$ = `<i>${$2}</i>`;
        }
    | BOLD line BOLD
        {
            $$ = `<strong>${$2}</strong>`;
        }
    | BOLD_ITALIC line BOLD_ITALIC
        {
            $$ = `<i><strong>${$2}</strong></i>`;
        }
    | BULLET line
        {
            $$ = `<ul><li>${$2}</li></ul>`;
        }
    | QUOTE line
        {
            $$ = `<blockquote style='border-left:5px solid grey; padding: 10px;' >${$2}</blockquote>`;
        }
    | SNIPPET line SNIPPET
        {
            $$ = `<code style='padding: 10px;background-color: grey; border-radius:8px;' >${$2}</code>`;
        }
    | TEXT
        {$$ = $1;}
    | INVALID 
        {console.log('SYNTAX ERROR::: Check your syntax and try again!')}
;
