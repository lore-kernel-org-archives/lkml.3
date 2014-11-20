Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaKTVgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:36:23 -0500
Received: from smtprelay0172.hostedemail.com ([216.40.44.172]:32947 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751075AbaKTVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:36:22 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:2:41:69:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1730:1747:1777:1792:2197:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3653:3743:3865:3866:3867:3870:3871:3874:4049:4118:4321:4605:5007:6261:7903:9592:10004:10848:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:13019:13255:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: chain53_374f637777451
X-Filterd-Recvd-Size: 7536
Message-ID: <1416519378.6651.22.camel@perches.com>
Subject: [PATCH V2] checkpatch: Add ability to --fix (coalesce) string
 fragments on multiple lines
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 20 Nov 2014 13:36:18 -0800
In-Reply-To: <1416511002.6651.20.camel@perches.com>
References: <1416511002.6651.20.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --fix option to coalesce string fragments.

This does not coalesce string fragments that have
newline terminations or are otherwise exempted.

Other miscellanea:

o move all the string tests together.
o fix get_quoted_string function for tab characters
o fix concatination typo

Signed-off-by: Joe Perches <joe@perches.com>
---
V2: Don't fix/coalesce multiple consecutive lines.
    That makes a mess by repeating string fragments.

 scripts/checkpatch.pl | 115 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 69 insertions(+), 46 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6d85c7b..f0bb6d6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -946,7 +946,7 @@ sub sanitise_line {
 sub get_quoted_string {
 	my ($line, $rawline) = @_;
 
-	return "" if ($line !~ m/(\"[X]+\")/g);
+	return "" if ($line !~ m/(\"[X\t]+\")/g);
 	return substr($rawline, $-[0], $+[0] - $-[0]);
 }
 
@@ -1847,6 +1847,7 @@ sub process {
 	my $non_utf8_charset = 0;
 
 	my $last_blank_line = 0;
+	my $last_coalesced_string_linenr = -1;
 
 	our @report = ();
 	our $cnt_lines = 0;
@@ -2413,33 +2414,6 @@ sub process {
 			     "line over $max_line_length characters\n" . $herecurr);
 		}
 
-# Check for user-visible strings broken across lines, which breaks the ability
-# to grep for the string.  Make exceptions when the previous string ends in a
-# newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
-# (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
-		if ($line =~ /^\+\s*"/ &&
-		    $prevline =~ /"\s*$/ &&
-		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
-			WARN("SPLIT_STRING",
-			     "quoted string split across lines\n" . $hereprev);
-		}
-
-# check for missing a space in a string concatination
-		if ($prevrawline =~ /[^\\]\w"$/ && $rawline =~ /^\+[\t ]+"\w/) {
-			WARN('MISSING_SPACE',
-			     "break quoted strings at a space character\n" . $hereprev);
-		}
-
-# check for spaces before a quoted newline
-		if ($rawline =~ /^.*\".*\s\\n/) {
-			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
-				 "unnecessary whitespace before a quoted newline\n" . $herecurr) &&
-			    $fix) {
-				$fixed[$fixlinenr] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
-			}
-
-		}
-
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
 			WARN("MISSING_EOF_NEWLINE",
@@ -4458,6 +4432,55 @@ sub process {
 			     "Use of volatile is usually wrong: see Documentation/volatile-considered-harmful.txt\n" . $herecurr);
 		}
 
+# Check for user-visible strings broken across lines, which breaks the ability
+# to grep for the string.  Make exceptions when the previous string ends in a
+# newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
+# (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
+		if ($line =~ /^\+\s*"[X\t]*"/ &&
+		    $prevline =~ /"\s*$/ &&
+		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
+			if (WARN("SPLIT_STRING",
+				 "quoted string split across lines\n" . $hereprev) &&
+				     $fix &&
+				     $prevrawline =~ /^\+.*"\s*$/ &&
+				     $last_coalesced_string_linenr != $linenr - 1) {
+				my $extracted_string = get_quoted_string($line, $rawline);
+				my $comma_close = "";
+				if ($rawline =~ /\Q$extracted_string\E(\s*\)\s*;\s*$|\s*,\s*)/) {
+					$comma_close = $1;
+				}
+
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+				fix_delete_line($fixlinenr, $rawline);
+				my $fixedline = $prevrawline;
+				$fixedline =~ s/"\s*$//;
+				$fixedline .= substr($extracted_string, 1) . trim($comma_close);
+				fix_insert_line($fixlinenr - 1, $fixedline);
+				$fixedline = $rawline;
+				$fixedline =~ s/\Q$extracted_string\E\Q$comma_close\E//;
+				if ($fixedline !~ /\+\s*$/) {
+					fix_insert_line($fixlinenr, $fixedline);
+				}
+				$last_coalesced_string_linenr = $linenr;
+			}
+		}
+
+# check for missing a space in a string concatenation
+		if ($prevrawline =~ /[^\\]\w"$/ && $rawline =~ /^\+[\t ]+"\w/) {
+			WARN('MISSING_SPACE',
+			     "break quoted strings at a space character\n" . $hereprev);
+		}
+
+# check for spaces before a quoted newline
+		if ($rawline =~ /^.*\".*\s\\n/) {
+			if (WARN("QUOTED_WHITESPACE_BEFORE_NEWLINE",
+				 "unnecessary whitespace before a quoted newline\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/^(\+.*\".*)\s+\\n/$1\\n/;
+			}
+
+		}
+
 # concatenated string without spaces between elements
 		if ($line =~ /"X+"[A-Z_]+/ || $line =~ /[A-Z_]+"X+"/) {
 			CHK("CONCATENATED_STRING",
@@ -4470,6 +4493,24 @@ sub process {
 			     "Consecutive strings are generally better as a single string\n" . $herecurr);
 		}
 
+# check for %L{u,d,i} in strings
+		my $string;
+		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
+			$string = substr($rawline, $-[1], $+[1] - $-[1]);
+			$string =~ s/%%/__/g;
+			if ($string =~ /(?<!%)%L[udi]/) {
+				WARN("PRINTF_L",
+				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
+				last;
+			}
+		}
+
+# check for line continuations in quoted strings with odd counts of "
+		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
+			WARN("LINE_CONTINUATIONS",
+			     "Avoid line continuations in quoted strings\n" . $herecurr);
+		}
+
 # warn about #if 0
 		if ($line =~ /^.\s*\#\s*if\s+0\b/) {
 			CHK("REDUNDANT_CODE",
@@ -4754,12 +4795,6 @@ sub process {
 			}
 		}
 
-# check for line continuations in quoted strings with odd counts of "
-		if ($rawline =~ /\\$/ && $rawline =~ tr/"/"/ % 2) {
-			WARN("LINE_CONTINUATIONS",
-			     "Avoid line continuations in quoted strings\n" . $herecurr);
-		}
-
 # check for struct spinlock declarations
 		if ($line =~ /^.\s*\bstruct\s+spinlock\s+\w+\s*;/) {
 			WARN("USE_SPINLOCK_T",
@@ -5169,18 +5204,6 @@ sub process {
 			      "#define of '$1' is wrong - use Kconfig variables or standard guards instead\n" . $herecurr);
 		}
 
-# check for %L{u,d,i} in strings
-		my $string;
-		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
-			$string = substr($rawline, $-[1], $+[1] - $-[1]);
-			$string =~ s/%%/__/g;
-			if ($string =~ /(?<!%)%L[udi]/) {
-				WARN("PRINTF_L",
-				     "\%Ld/%Lu are not-standard C, use %lld/%llu\n" . $herecurr);
-				last;
-			}
-		}
-
 # whine mightly about in_atomic
 		if ($line =~ /\bin_atomic\s*\(/) {
 			if ($realfile =~ m@^drivers/@) {



