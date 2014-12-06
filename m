Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaLFFpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:45:42 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58698 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaLFFpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:45:41 -0500
Message-ID: <54829801.9000302@gmail.com>
Date: Fri, 05 Dec 2014 21:45:37 -0800
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        frowand.list@gmail.com
Subject: [PATCH] checkpatch: include text files in SPACE_BEFORE_TAB test
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>

git-am whined about a patch that I submitted for the Documentation
subtree, (https://lkml.org/lkml/2014/11/24/636) but checkpatch does
not.  Make checkpatch just as whiney.

This patch moves the SPACE_BEFORE_TAB test before the check that
excludes text files and also before the test that excludes
assembly files.  It seems to me that both CODE_INDENT and
SPACE_BEFORE_TAB are valid tests for assembly files, but I
added an if around the moved CODE_INDENT test to include only
source files, not including assembly files.  Thus this patch
does not change which files are subject to CODE_INDENT.

The CODE_INDENT test is moved along with the SPACE_BEFORE_TAB
test because the c76f4cb3d25e commit log says:

    This SPACE_BEFORE_TAB test is done after CODE_INDENT.
    
    If there are spaces used at the beginning of a line that should be
    converted to tabs, please make sure that the CODE_INDENT test and
    conversion is done before this SPACE_BEFORE_TAB test and conversion.

Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---


Andy, Joe,

Assembly files are still excluded from the CODE_INDENT test -- do you
want to make another change to include them?


---
 scripts/checkpatch.pl |   56 ++++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

Index: b/scripts/checkpatch.pl
===================================================================
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2389,6 +2389,36 @@ sub process {
 			}
 		}
 
+# at the beginning of a line any tabs must come first and anything
+# more than 8 must use tabs.
+# do CODE_INDENT test before SPACE_BEFORE_TAB test (c76f4cb3d25e)
+		if ($realfile =~ /\.(h|c|pl|dtsi|dts)$/) {
+			if ($rawline =~ /^\+\s* \t\s*\S/ ||
+			    $rawline =~ /^\+\s*        \s*/) {
+				my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+				$rpt_cleaners = 1;
+				if (ERROR("CODE_INDENT",
+					  "code indent should use tabs where possible\n" . $herevet) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
+				}
+			}
+		}
+
+# check for space before tabs.
+		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
+			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
+			if (WARN("SPACE_BEFORE_TAB",
+				"please, no space before tabs\n" . $herevet) &&
+			    $fix) {
+				while ($fixed[$fixlinenr] =~
+					   s/(^\+.*) {8,8}\t/$1\t\t/) {}
+				while ($fixed[$fixlinenr] =~
+					   s/(^\+.*) +\t/$1\t/) {}
+			}
+		}
+
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
 
@@ -2453,32 +2483,6 @@ sub process {
 # check we are in a valid source file C or perl if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|pl|dtsi|dts)$/);
 
-# at the beginning of a line any tabs must come first and anything
-# more than 8 must use tabs.
-		if ($rawline =~ /^\+\s* \t\s*\S/ ||
-		    $rawline =~ /^\+\s*        \s*/) {
-			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			$rpt_cleaners = 1;
-			if (ERROR("CODE_INDENT",
-				  "code indent should use tabs where possible\n" . $herevet) &&
-			    $fix) {
-				$fixed[$fixlinenr] =~ s/^\+([ \t]+)/"\+" . tabify($1)/e;
-			}
-		}
-
-# check for space before tabs.
-		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
-			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			if (WARN("SPACE_BEFORE_TAB",
-				"please, no space before tabs\n" . $herevet) &&
-			    $fix) {
-				while ($fixed[$fixlinenr] =~
-					   s/(^\+.*) {8,8}\t/$1\t\t/) {}
-				while ($fixed[$fixlinenr] =~
-					   s/(^\+.*) +\t/$1\t/) {}
-			}
-		}
-
 # check for && or || at the start of a line
 		if ($rawline =~ /^\+\s*(&&|\|\|)/) {
 			CHK("LOGICAL_CONTINUATIONS",
