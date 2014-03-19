Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbaCSDEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 23:04:05 -0400
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:39681 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752497AbaCSDED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 23:04:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3871:3872:3874:4321:4605:5007:7652:7903:8957:9592:10004:10400:10848:11026:11232:11473:11658:11914:12043:12291:12295:12438:12517:12519:12555:12683:13161:13229:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stem11_2303304d57b3c
X-Filterd-Recvd-Size: 3689
Message-ID: <1395198239.8649.16.camel@joe-AO722>
Subject: [PATCH] checkpatch: Improve octal permissions test speed
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 18 Mar 2014 20:03:59 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current octal permissions test is very slow.

When commit 3fc9249967
("checkpatch: add checks for constant non-octal permissions")
was added, processing time approximately tripled.

Regain almost all of the performance by not looping through all the
possible functions unless the line contains one of the functions.

Signed-off-by: Joe Perches <joe@perches.com>
---
There's probably some perl "join('|', foo)" that would
simplify and remove the initial foreach loop, but I don't
know what it might be off the top of my head.  Andy?

 scripts/checkpatch.pl | 51 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d44e440..ec65c54 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -388,6 +388,13 @@ our @mode_permission_funcs = (
 	["(?:CLASS|DEVICE|SENSOR)_ATTR", 2],
 );
 
+#Create a search pattern for all these functions to speed up a loop below
+our $mode_perms_search = "";
+foreach my $entry (@mode_permission_funcs) {
+	$mode_perms_search .= '|' if ($mode_perms_search ne "");
+	$mode_perms_search .= $entry->[0];
+}
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory
@@ -4540,26 +4547,30 @@ sub process {
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
 
-		foreach my $entry (@mode_permission_funcs) {
-			my $func = $entry->[0];
-			my $arg_pos = $entry->[1];
-
-			my $skip_args = "";
-			if ($arg_pos > 1) {
-				$arg_pos--;
-				$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
-			}
-			my $test = "\\b$func\\s*\\(${skip_args}([\\d]+)\\s*[,\\)]";
-			if ($^V && $^V ge 5.10.0 &&
-			    $line =~ /$test/) {
-				my $val = $1;
-				$val = $6 if ($skip_args ne "");
-
-				if ($val !~ /^0$/ &&
-				    (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
-				     length($val) ne 4)) {
-					ERROR("NON_OCTAL_PERMISSIONS",
-					      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
+# Mode permission misuses where it seems decimal should be octal
+# This uses a shortcut match to avoid unnecessary uses of a slow foreach loop
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /$mode_perms_search/) {
+			foreach my $entry (@mode_permission_funcs) {
+				my $func = $entry->[0];
+				my $arg_pos = $entry->[1];
+
+				my $skip_args = "";
+				if ($arg_pos > 1) {
+					$arg_pos--;
+					$skip_args = "(?:\\s*$FuncArg\\s*,\\s*){$arg_pos,$arg_pos}";
+				}
+				my $test = "\\b$func\\s*\\(${skip_args}([\\d]+)\\s*[,\\)]";
+				if ($line =~ /$test/) {
+					my $val = $1;
+					$val = $6 if ($skip_args ne "");
+
+					if ($val !~ /^0$/ &&
+					    (($val =~ /^$Int$/ && $val !~ /^$Octal$/) ||
+					     length($val) ne 4)) {
+						ERROR("NON_OCTAL_PERMISSIONS",
+						      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
+					}
 				}
 			}
 		}


