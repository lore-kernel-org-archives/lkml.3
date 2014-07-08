Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbaGHRxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:53:48 -0400
Received: from smtprelay0151.hostedemail.com ([216.40.44.151]:52063 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754182AbaGHRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:53:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:4:41:69:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3653:3865:3866:3867:3868:3870:3871:3874:4321:4605:4823:5007:6119:6261:7903:8957:10004:10026:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13141:13230:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wax48_3167c3e9f13b
X-Filterd-Recvd-Size: 18281
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] checkpatch: Add an index variable for fixed lines
Date: Tue,  8 Jul 2014 10:53:35 -0700
Message-Id: <b7476a651d4820387c55839e944cd5c44819f857.1404840958.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404840958.git.joe@perches.com>
References: <cover.1404840958.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the fix code a bit easier to read.

This should also start to allow an easier mechanism to insert/delete
lines eventually too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 114 ++++++++++++++++++++++++++------------------------
 1 file changed, 60 insertions(+), 54 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 496f9ab..ecb8290 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -583,6 +583,8 @@ $chk_signoff = 0 if ($file);
 my @rawlines = ();
 my @lines = ();
 my @fixed = ();
+my $fixlinenr = -1;
+
 my $vname;
 for my $filename (@ARGV) {
 	my $FILE;
@@ -611,6 +613,7 @@ for my $filename (@ARGV) {
 	@rawlines = ();
 	@lines = ();
 	@fixed = ();
+	$fixlinenr = -1;
 }
 
 exit($exit);
@@ -1801,8 +1804,10 @@ sub process {
 
 	$realcnt = 0;
 	$linenr = 0;
+	$fixlinenr = -1;
 	foreach my $line (@lines) {
 		$linenr++;
+		$fixlinenr++;
 		my $sline = $line;	#copy of $line
 		$sline =~ s/$;/ /g;	#with comments as spaces
 
@@ -1933,7 +1938,7 @@ sub process {
 				if (WARN("BAD_SIGN_OFF",
 					 "Do not use whitespace before $ucfirst_sign_off\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =
+					$fixed[$fixlinenr] =
 					    "$ucfirst_sign_off $email";
 				}
 			}
@@ -1941,7 +1946,7 @@ sub process {
 				if (WARN("BAD_SIGN_OFF",
 					 "'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =
+					$fixed[$fixlinenr] =
 					    "$ucfirst_sign_off $email";
 				}
 
@@ -1950,7 +1955,7 @@ sub process {
 				if (WARN("BAD_SIGN_OFF",
 					 "Use a single space after $ucfirst_sign_off\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =
+					$fixed[$fixlinenr] =
 					    "$ucfirst_sign_off $email";
 				}
 			}
@@ -2078,14 +2083,14 @@ sub process {
 			if (ERROR("DOS_LINE_ENDINGS",
 				  "DOS line endings\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/[\s\015]+$//;
+				$fixed[$fixlinenr] =~ s/[\s\015]+$//;
 			}
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			if (ERROR("TRAILING_WHITESPACE",
 				  "trailing whitespace\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\s+$//;
+				$fixed[$fixlinenr] =~ s/\s+$//;
 			}
 
 			$rpt_cleaners = 1;
@@ -2224,7 +2229,7 @@ sub process {
 			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
 				 "unnecessary whitespace before a quoted newline\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
+				$fixed[$fixlinenr] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
 			}
 
 		}
@@ -2261,7 +2266,7 @@ sub process {
 			if (ERROR("CODE_INDENT",
 				  "code indent should use tabs where possible\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
+				$fixed[$fixlinenr] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
 			}
 		}
 
@@ -2271,9 +2276,9 @@ sub process {
 			if (WARN("SPACE_BEFORE_TAB",
 				"please, no space before tabs\n" . $herevet) &&
 			    $fix) {
-				while ($fixed[$linenr - 1] =~
+				while ($fixed[$fixlinenr] =~
 					   s/(^\+.*) {8,8}+\t/$1\t\t/) {}
-				while ($fixed[$linenr - 1] =~
+				while ($fixed[$fixlinenr] =~
 					   s/(^\+.*) +\t/$1\t/) {}
 			}
 		}
@@ -2307,7 +2312,7 @@ sub process {
 					if (CHK("PARENTHESIS_ALIGNMENT",
 						"Alignment should match open parenthesis\n" . $hereprev) &&
 					    $fix && $line =~ /^\+/) {
-						$fixed[$linenr - 1] =~
+						$fixed[$fixlinenr] =~
 						    s/^\+[ \t]*/\+$goodtabindent/;
 					}
 				}
@@ -2318,7 +2323,7 @@ sub process {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/(\(\s*$Type\s*\))[ \t]+/$1/;
 			}
 		}
@@ -2422,7 +2427,7 @@ sub process {
 			if (WARN("LEADING_SPACE",
 				 "please, no spaces at the start of a line\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
+				$fixed[$fixlinenr] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
 			}
 		}
 
@@ -2777,10 +2782,10 @@ sub process {
 			if (ERROR("C99_COMMENTS",
 				  "do not use C99 // comments\n" . $herecurr) &&
 			    $fix) {
-				my $line = $fixed[$linenr - 1];
+				my $line = $fixed[$fixlinenr];
 				if ($line =~ /\/\/(.*)$/) {
 					my $comment = trim($1);
-					$fixed[$linenr - 1] =~ s@\/\/(.*)$@/\* $comment \*/@;
+					$fixed[$fixlinenr] =~ s@\/\/(.*)$@/\* $comment \*/@;
 				}
 			}
 		}
@@ -2839,7 +2844,7 @@ sub process {
 				  "do not initialise globals to 0 or NULL\n" .
 				      $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/($Type\s*$Ident\s*(?:\s+$Modifier))*\s*=\s*(0|NULL|false)\s*;/$1;/;
+				$fixed[$fixlinenr] =~ s/($Type\s*$Ident\s*(?:\s+$Modifier))*\s*=\s*(0|NULL|false)\s*;/$1;/;
 			}
 		}
 # check for static initialisers.
@@ -2848,7 +2853,7 @@ sub process {
 				  "do not initialise statics to 0 or NULL\n" .
 				      $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/(\bstatic\s.*?)\s*=\s*(0|NULL|false)\s*;/$1;/;
+				$fixed[$fixlinenr] =~ s/(\bstatic\s.*?)\s*=\s*(0|NULL|false)\s*;/$1;/;
 			}
 		}
 
@@ -2878,7 +2883,7 @@ sub process {
 			if (ERROR("FUNCTION_WITHOUT_ARGS",
 				  "Bad function definition - $1() should probably be $1(void)\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/(\b($Type)\s+($Ident))\s*\(\s*\)/$2 $3(void)/;
+				$fixed[$fixlinenr] =~ s/(\b($Type)\s+($Ident))\s*\(\s*\)/$2 $3(void)/;
 			}
 		}
 
@@ -2887,7 +2892,7 @@ sub process {
 			if (WARN("DEFINE_PCI_DEVICE_TABLE",
 				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id $1\[\] = /;
+				$fixed[$fixlinenr] =~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id $1\[\] = /;
 			}
 		}
 
@@ -2924,7 +2929,7 @@ sub process {
 					my $sub_from = $ident;
 					my $sub_to = $ident;
 					$sub_to =~ s/\Q$from\E/$to/;
-					$fixed[$linenr - 1] =~
+					$fixed[$fixlinenr] =~
 					    s@\Q$sub_from\E@$sub_to@;
 				}
 			}
@@ -2952,7 +2957,7 @@ sub process {
 					my $sub_from = $match;
 					my $sub_to = $match;
 					$sub_to =~ s/\Q$from\E/$to/;
-					$fixed[$linenr - 1] =~
+					$fixed[$fixlinenr] =~
 					    s@\Q$sub_from\E@$sub_to@;
 				}
 			}
@@ -3014,7 +3019,7 @@ sub process {
 			if (WARN("PREFER_PR_LEVEL",
 				 "Prefer pr_warn(... to pr_warning(...\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\bpr_warning\b/pr_warn/;
 			}
 		}
@@ -3048,7 +3053,7 @@ sub process {
 			if (WARN("SPACING",
 				 "missing space after $1 definition\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/^(.\s*(?:typedef\s+)?(?:enum|union|struct)(?:\s+$Ident){1,2})([=\{])/$1 $2/;
 			}
 		}
@@ -3118,7 +3123,7 @@ sub process {
 			}
 
 			if (show_type("SPACING") && $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/^(.\s*)$Declare\s*\(\s*\*\s*$Ident\s*\)\s*\(/$1 . $declare . $post_declare_space . '(*' . $funcname . ')('/ex;
 			}
 		}
@@ -3135,7 +3140,7 @@ sub process {
 				if (ERROR("BRACKET_SPACE",
 					  "space prohibited before open square bracket '['\n" . $herecurr) &&
 				    $fix) {
-				    $fixed[$linenr - 1] =~
+				    $fixed[$fixlinenr] =~
 					s/^(\+.*?)\s+\[/$1\[/;
 				}
 			}
@@ -3170,7 +3175,7 @@ sub process {
 				if (WARN("SPACING",
 					 "space prohibited between function name and open parenthesis '('\n" . $herecurr) &&
 					     $fix) {
-					$fixed[$linenr - 1] =~
+					$fixed[$fixlinenr] =~
 					    s/\b$name\s+\(/$name\(/;
 				}
 			}
@@ -3438,8 +3443,8 @@ sub process {
 				$fixed_line = $fixed_line . $fix_elements[$#elements];
 			}
 
-			if ($fix && $line_fixed && $fixed_line ne $fixed[$linenr - 1]) {
-				$fixed[$linenr - 1] = $fixed_line;
+			if ($fix && $line_fixed && $fixed_line ne $fixed[$fixlinenr]) {
+				$fixed[$fixlinenr] = $fixed_line;
 			}
 
 
@@ -3450,7 +3455,7 @@ sub process {
 			if (WARN("SPACING",
 				 "space prohibited before semicolon\n" . $herecurr) &&
 			    $fix) {
-				1 while $fixed[$linenr - 1] =~
+				1 while $fixed[$fixlinenr] =~
 				    s/^(\+.*\S)\s+;/$1;/;
 			}
 		}
@@ -3483,7 +3488,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^(\+.*(?:do|\))){/$1 {/;
+				$fixed[$fixlinenr] =~ s/^(\+.*(?:do|\))){/$1 {/;
 			}
 		}
 
@@ -3501,7 +3506,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required after that close brace '}'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/}((?!(?:,|;|\)))\S)/} $1/;
 			}
 		}
@@ -3511,7 +3516,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited after that open square bracket '['\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\[\s+/\[/;
 			}
 		}
@@ -3519,7 +3524,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited before that close square bracket ']'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\s+\]/\]/;
 			}
 		}
@@ -3530,7 +3535,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited after that open parenthesis '('\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\(\s+/\(/;
 			}
 		}
@@ -3540,7 +3545,8 @@ sub process {
 			if (ERROR("SPACING",
 				  "space prohibited before that close parenthesis ')'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				print("fixlinenr: <$fixlinenr> fixed[fixlinenr]: <$fixed[$fixlinenr]>\n");
+				$fixed[$fixlinenr] =~
 				    s/\s+\)/\)/;
 			}
 		}
@@ -3559,7 +3565,7 @@ sub process {
 			if (WARN("INDENTED_LABEL",
 				 "labels should not be indented\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/^(.)\s+/$1/;
 			}
 		}
@@ -3621,7 +3627,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required before the open parenthesis '('\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/\b(if|while|for|switch)\(/$1 \(/;
 			}
 		}
@@ -3758,7 +3764,7 @@ sub process {
 					 "Avoid gcc v4.3+ binary constant extension: <$var>\n" . $herecurr) &&
 				    $fix) {
 					my $hexval = sprintf("0x%x", oct($var));
-					$fixed[$linenr - 1] =~
+					$fixed[$fixlinenr] =~
 					    s/\b$var\b/$hexval/;
 				}
 			}
@@ -3794,7 +3800,7 @@ sub process {
 			if (WARN("WHITESPACE_AFTER_LINE_CONTINUATION",
 				 "Whitespace after \\ makes next lines useless\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\s+$//;
+				$fixed[$fixlinenr] =~ s/\s+$//;
 			}
 		}
 
@@ -4149,7 +4155,7 @@ sub process {
 				      WARN("MISPLACED_INIT",
 					   "$attr should be placed after $var\n" . $herecurr))) &&
 				    $fix) {
-					$fixed[$linenr - 1] =~ s/(\bstatic\s+(?:const\s+)?)(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*([=;])\s*/"$1" . trim(string_find_replace($2, "\\s*$attr\\s*", " ")) . " " . trim(string_find_replace($3, "\\s*$attr\\s*", "")) . " $attr" . ("$4" eq ";" ? ";" : " = ")/e;
+					$fixed[$fixlinenr] =~ s/(\bstatic\s+(?:const\s+)?)(?:$attr\s+)?($NonptrTypeWithAttr)\s+(?:$attr\s+)?($Ident(?:\[[^]]*\])?)\s*([=;])\s*/"$1" . trim(string_find_replace($2, "\\s*$attr\\s*", " ")) . " " . trim(string_find_replace($3, "\\s*$attr\\s*", "")) . " $attr" . ("$4" eq ";" ? ";" : " = ")/e;
 				}
 			}
 		}
@@ -4163,7 +4169,7 @@ sub process {
 			if (ERROR("INIT_ATTRIBUTE",
 				  "Use of const init definition must use ${attr_prefix}initconst\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/$InitAttributeData/${attr_prefix}initconst/;
 			}
 		}
@@ -4174,12 +4180,12 @@ sub process {
 			if (ERROR("INIT_ATTRIBUTE",
 				  "Use of $attr requires a separate use of const\n" . $herecurr) &&
 			    $fix) {
-				my $lead = $fixed[$linenr - 1] =~
+				my $lead = $fixed[$fixlinenr] =~
 				    /(^\+\s*(?:static\s+))/;
 				$lead = rtrim($1);
 				$lead = "$lead " if ($lead !~ /^\+$/);
 				$lead = "${lead}const ";
-				$fixed[$linenr - 1] =~ s/(^\+\s*(?:static\s+))/$lead/;
+				$fixed[$fixlinenr] =~ s/(^\+\s*(?:static\s+))/$lead/;
 			}
 		}
 
@@ -4192,7 +4198,7 @@ sub process {
 			if (WARN("CONSTANT_CONVERSION",
 				 "$constant_func should be $func\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b$constant_func\b/$func/g;
+				$fixed[$fixlinenr] =~ s/\b$constant_func\b/$func/g;
 			}
 		}
 
@@ -4242,7 +4248,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "exactly one space required after that #$1\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
+				$fixed[$fixlinenr] =~
 				    s/^(.\s*\#\s*(ifdef|ifndef|elif))\s{2,}/$1 /;
 			}
 
@@ -4290,7 +4296,7 @@ sub process {
 			if (WARN("INLINE",
 				 "plain inline is preferred over $1\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b(__inline__|__inline)\b/inline/;
+				$fixed[$fixlinenr] =~ s/\b(__inline__|__inline)\b/inline/;
 
 			}
 		}
@@ -4315,7 +4321,7 @@ sub process {
 			if (WARN("PREFER_PRINTF",
 				 "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf\s*,\s*(.*)\)\s*\)\s*\)/"__printf(" . trim($1) . ")"/ex;
+				$fixed[$fixlinenr] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf\s*,\s*(.*)\)\s*\)\s*\)/"__printf(" . trim($1) . ")"/ex;
 
 			}
 		}
@@ -4326,7 +4332,7 @@ sub process {
 			if (WARN("PREFER_SCANF",
 				 "__scanf(string-index, first-to-check) is preferred over __attribute__((format(scanf, string-index, first-to-check)))\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\s*,\s*(.*)\)\s*\)\s*\)/"__scanf(" . trim($1) . ")"/ex;
+				$fixed[$fixlinenr] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\s*,\s*(.*)\)\s*\)\s*\)/"__scanf(" . trim($1) . ")"/ex;
 			}
 		}
 
@@ -4341,7 +4347,7 @@ sub process {
 			if (WARN("SIZEOF_PARENTHESIS",
 				 "sizeof $1 should be sizeof($1)\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/"sizeof(" . trim($1) . ")"/ex;
+				$fixed[$fixlinenr] =~ s/\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/"sizeof(" . trim($1) . ")"/ex;
 			}
 		}
 
@@ -4364,7 +4370,7 @@ sub process {
 				if (WARN("PREFER_SEQ_PUTS",
 					 "Prefer seq_puts to seq_printf\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =~ s/\bseq_printf\b/seq_puts/;
+					$fixed[$fixlinenr] =~ s/\bseq_printf\b/seq_puts/;
 				}
 			}
 		}
@@ -4393,7 +4399,7 @@ sub process {
 			if (WARN("PREFER_ETHER_ADDR_COPY",
 				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
+				$fixed[$fixlinenr] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
 			}
 		}
 
@@ -4481,7 +4487,7 @@ sub process {
 			if (CHK("AVOID_EXTERNS",
 				"extern prototypes should be avoided in .h files\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/(.*)\bextern\b\s*(.*)/$1$2/;
+				$fixed[$fixlinenr] =~ s/(.*)\bextern\b\s*(.*)/$1$2/;
 			}
 		}
 
@@ -4558,7 +4564,7 @@ sub process {
 				if (WARN("ALLOC_WITH_MULTIPLY",
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$linenr - 1] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
+					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
 
 				}
 			}
@@ -4582,7 +4588,7 @@ sub process {
 			if (WARN("ONE_SEMICOLON",
 				 "Statements terminations use 1 semicolon\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/(\s*;\s*){2,}$/;/g;
+				$fixed[$fixlinenr] =~ s/(\s*;\s*){2,}$/;/g;
 			}
 		}
 
@@ -4630,7 +4636,7 @@ sub process {
 			if (WARN("USE_FUNC",
 				 "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/\b__FUNCTION__\b/__func__/g;
+				$fixed[$fixlinenr] =~ s/\b__FUNCTION__\b/__func__/g;
 			}
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

