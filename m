Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab3GVSQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:16:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54571 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932264Ab3GVSQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:16:24 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] checkpatch: Add a few more --fix corrections
Date: Mon, 22 Jul 2013 11:16:20 -0700
Message-Id: <1374516981-23049-1-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggest a few more single-line corrections.

Remove DOS line endings
Simplify removing trailing whitespace
Remove global/static initializations to 0/NULL
Convert pr_warning to pr_warn
Add space after brace
Convert binary constants to hex
Remove whitespace after line continuation
Use inline not __inline or __inline__
Use __printf and __scanf
Use a single ; for statement terminations
Convert __FUNCTION__ to __func__

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 122 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 84 insertions(+), 38 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a220104..7dc00fd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1845,15 +1845,17 @@ sub process {
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("DOS_LINE_ENDINGS",
-			      "DOS line endings\n" . $herevet);
-
+			if (ERROR("DOS_LINE_ENDINGS",
+				  "DOS line endings\n" . $herevet) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/[\s\015]+$//;
+			}
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			if (ERROR("TRAILING_WHITESPACE",
 				  "trailing whitespace\n" . $herevet) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~ s/^(\+.*?)\s+$/$1/;
+				$fixed[$linenr - 1] =~ s/\s+$//;
 			}
 
 			$rpt_cleaners = 1;
@@ -2486,16 +2488,22 @@ sub process {
 		}
 
 # check for global initialisers.
-		if ($line =~ /^.$Type\s*$Ident\s*(?:\s+$Modifier)*\s*=\s*(0|NULL|false)\s*;/) {
-			ERROR("GLOBAL_INITIALISERS",
-			      "do not initialise globals to 0 or NULL\n" .
-				$herecurr);
+		if ($line =~ /^\+(\s*$Type\s*$Ident\s*(?:\s+$Modifier))*\s*=\s*(0|NULL|false)\s*;/) {
+			if (ERROR("GLOBAL_INITIALISERS",
+				  "do not initialise globals to 0 or NULL\n" .
+				      $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/($Type\s*$Ident\s*(?:\s+$Modifier))*\s*=\s*(0|NULL|false)\s*;/$1;/;
+			}
 		}
 # check for static initialisers.
-		if ($line =~ /\bstatic\s.*=\s*(0|NULL|false)\s*;/) {
-			ERROR("INITIALISED_STATIC",
-			      "do not initialise statics to 0 or NULL\n" .
-				$herecurr);
+		if ($line =~ /^\+.*\bstatic\s.*=\s*(0|NULL|false)\s*;/) {
+			if (ERROR("INITIALISED_STATIC",
+				  "do not initialise statics to 0 or NULL\n" .
+				      $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/(\bstatic\s.*?)\s*=\s*(0|NULL|false)\s*;/$1;/;
+			}
 		}
 
 # check for static const char * arrays.
@@ -2638,8 +2646,12 @@ sub process {
 		}
 
 		if ($line =~ /\bpr_warning\s*\(/) {
-			WARN("PREFER_PR_LEVEL",
-			     "Prefer pr_warn(... to pr_warning(...\n" . $herecurr);
+			if (WARN("PREFER_PR_LEVEL",
+				 "Prefer pr_warn(... to pr_warning(...\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/\bpr_warning\b/pr_warn/;
+			}
 		}
 
 		if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
@@ -3031,8 +3043,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$linenr - 1] =~
-				    s/^(\+.*(?:do|\))){/$1 {/;
+				$fixed[$linenr - 1] =~ s/^(\+.*(?:do|\))){/$1 {/;
 			}
 		}
 
@@ -3047,8 +3058,12 @@ sub process {
 # closing brace should have a space following it when it has anything
 # on the line
 		if ($line =~ /}(?!(?:,|;|\)))\S/) {
-			ERROR("SPACING",
-			      "space required after that close brace '}'\n" . $herecurr);
+			if (ERROR("SPACING",
+				  "space required after that close brace '}'\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~
+				    s/}((?!(?:,|;|\)))\S)/} $1/;
+			}
 		}
 
 # check spacing on square brackets
@@ -3271,8 +3286,13 @@ sub process {
 
 #gcc binary extension
 			if ($var =~ /^$Binary$/) {
-				WARN("GCC_BINARY_CONSTANT",
-				     "Avoid gcc v4.3+ binary constant extension: <$var>\n" . $herecurr);
+				if (WARN("GCC_BINARY_CONSTANT",
+					 "Avoid gcc v4.3+ binary constant extension: <$var>\n" . $herecurr) &&
+				    $fix) {
+					my $hexval = sprintf("0x%x", oct($var));
+					$fixed[$linenr - 1] =~
+					    s/\b$var\b/$hexval/;
+				}
 			}
 
 #CamelCase
@@ -3292,9 +3312,12 @@ sub process {
 		}
 
 #no spaces allowed after \ in define
-		if ($line=~/\#\s*define.*\\\s$/) {
-			WARN("WHITESPACE_AFTER_LINE_CONTINUATION",
-			     "Whitepspace after \\ makes next lines useless\n" . $herecurr);
+		if ($line =~ /\#\s*define.*\\\s+$/) {
+			if (WARN("WHITESPACE_AFTER_LINE_CONTINUATION",
+				 "Whitespace after \\ makes next lines useless\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\s+$//;
+			}
 		}
 
 #warn if <asm/foo.h> is #included and <linux/foo.h> is available (uses RAW line)
@@ -3691,8 +3714,12 @@ sub process {
 
 # Check for __inline__ and __inline, prefer inline
 		if ($line =~ /\b(__inline__|__inline)\b/) {
-			WARN("INLINE",
-			     "plain inline is preferred over $1\n" . $herecurr);
+			if (WARN("INLINE",
+				 "plain inline is preferred over $1\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\b(__inline__|__inline)\b/inline/;
+
+			}
 		}
 
 # Check for __attribute__ packed, prefer __packed
@@ -3709,14 +3736,21 @@ sub process {
 
 # Check for __attribute__ format(printf, prefer __printf
 		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf/) {
-			WARN("PREFER_PRINTF",
-			     "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr);
+			if (WARN("PREFER_PRINTF",
+				 "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf\s*,\s*(.*)\)\s*\)\s*\)/"__printf(" . trim($1) . ")"/ex;
+
+			}
 		}
 
 # Check for __attribute__ format(scanf, prefer __scanf
 		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\b/) {
-			WARN("PREFER_SCANF",
-			     "__scanf(string-index, first-to-check) is preferred over __attribute__((format(scanf, string-index, first-to-check)))\n" . $herecurr);
+			if (WARN("PREFER_SCANF",
+				 "__scanf(string-index, first-to-check) is preferred over __attribute__((format(scanf, string-index, first-to-check)))\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\s*,\s*(.*)\)\s*\)\s*\)/"__scanf(" . trim($1) . ")"/ex;
+			}
 		}
 
 # check for sizeof(&)
@@ -3727,8 +3761,11 @@ sub process {
 
 # check for sizeof without parenthesis
 		if ($line =~ /\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/) {
-			WARN("SIZEOF_PARENTHESIS",
-			     "sizeof $1 should be sizeof($1)\n" . $herecurr);
+			if (WARN("SIZEOF_PARENTHESIS",
+				 "sizeof $1 should be sizeof($1)\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\bsizeof\s+((?:\*\s*|)$Lval|$Type(?:\s+$Lval|))/"sizeof(" . trim($1) . ")"/ex;
+			}
 		}
 
 # check for line continuations in quoted strings with odd counts of "
@@ -3747,8 +3784,11 @@ sub process {
 		if ($line =~ /\bseq_printf\s*\(/) {
 			my $fmt = get_quoted_string($line, $rawline);
 			if ($fmt !~ /[^\\]\%/) {
-				WARN("PREFER_SEQ_PUTS",
-				     "Prefer seq_puts to seq_printf\n" . $herecurr);
+				if (WARN("PREFER_SEQ_PUTS",
+					 "Prefer seq_puts to seq_printf\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$linenr - 1] =~ s/\bseq_printf\b/seq_puts/;
+				}
 			}
 		}
 
@@ -3879,8 +3919,11 @@ sub process {
 
 # check for multiple semicolons
 		if ($line =~ /;\s*;\s*$/) {
-			WARN("ONE_SEMICOLON",
-			     "Statements terminations use 1 semicolon\n" . $herecurr);
+			if (WARN("ONE_SEMICOLON",
+				 "Statements terminations use 1 semicolon\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/(\s*;\s*){2,}$/;/g;
+			}
 		}
 
 # check for switch/default statements without a break;
@@ -3898,9 +3941,12 @@ sub process {
 		}
 
 # check for gcc specific __FUNCTION__
-		if ($line =~ /__FUNCTION__/) {
-			WARN("USE_FUNC",
-			     "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
+		if ($line =~ /\b__FUNCTION__\b/) {
+			if (WARN("USE_FUNC",
+				 "__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\b__FUNCTION__\b/__func__/g;
+			}
 		}
 
 # check for use of yield()
-- 
1.8.1.2.459.gbcd45b4.dirty

