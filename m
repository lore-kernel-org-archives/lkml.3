Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaBJX7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:59:13 -0500
Received: from smtprelay0237.hostedemail.com ([216.40.44.237]:57975 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753011AbaBJX7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:59:11 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3871:3872:5007:7652:10004:10026:10400:10848:11026:11232:11658:11914:12043:12291:12517:12519:12555:12683:13019:13141:13230:14093:14097:14110,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: club62_6d110878e0d31
X-Filterd-Recvd-Size: 3651
Message-ID: <1392076748.2507.29.camel@joe-AO722>
Subject: [PATCH] checkpatch: Don't warn on some function pointer return
 styles
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daeseok Youn <daeseok.youn@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 10 Feb 2014 15:59:08 -0800
In-Reply-To: <1392012424.3178.23.camel@joe-AO722>
References: <81912500.jvGoQpGOq5@daeseok-laptop.cloud.net>
	 <1392012424.3178.23.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for some function pointer return styles are too strict.  Fix them.

Multiple spaces after function pointer return types are allowed.
	int  (*foo)(int bar)

Spaces after function pointer returns of pointer types are not required.
	int *(*foo)(int bar)

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7d3bc2f..19591af 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2848,10 +2848,7 @@ sub process {
 # Function pointer declarations
 # check spacing between type, funcptr, and args
 # canonical declaration is "type (*funcptr)(args...)"
-#
-# the $Declare variable will capture all spaces after the type
-# so check it for trailing missing spaces or multiple spaces
-		if ($line =~ /^.\s*($Declare)\((\s*)\*(\s*)$Ident(\s*)\)(\s*)\(/) {
+		if ($line =~ /^.\s*($Declare)\((\s*)\*(\s*)($Ident)(\s*)\)(\s*)\(/) {
 			my $declare = $1;
 			my $pre_pointer_space = $2;
 			my $post_pointer_space = $3;
@@ -2859,16 +2856,30 @@ sub process {
 			my $post_funcname_space = $5;
 			my $pre_args_space = $6;
 
-			if ($declare !~ /\s$/) {
+# the $Declare variable will capture all spaces after the type
+# so check it for a missing trailing missing space but pointer return types
+# don't need a space so don't warn for those.
+			my $post_declare_space = "";
+			if ($declare =~ /(\s+)$/) {
+				$post_declare_space = $1;
+				$declare = rtrim($declare);
+			}
+			if ($declare !~ /\*$/ && $post_declare_space =~ /^$/) {
 				WARN("SPACING",
 				     "missing space after return type\n" . $herecurr);
+				$post_declare_space = " ";
 			}
 
 # unnecessary space "type  (*funcptr)(args...)"
-			elsif ($declare =~ /\s{2,}$/) {
-				WARN("SPACING",
-				     "Multiple spaces after return type\n" . $herecurr);
-			}
+# This test is not currently implemented because these declarations are
+# equivalent to
+#	int  foo(int bar, ...)
+# and this is form shouldn't/doesn't generate a checkpatch warning.
+#
+#			elsif ($declare =~ /\s{2,}$/) {
+#				WARN("SPACING",
+#				     "Multiple spaces after return type\n" . $herecurr);
+#			}
 
 # unnecessary space "type ( *funcptr)(args...)"
 			if (defined $pre_pointer_space &&
@@ -2900,7 +2911,7 @@ sub process {
 
 			if (show_type("SPACING") && $fix) {
 				$fixed[$linenr - 1] =~
-				    s/^(.\s*$Declare)\(\s*\*\s*($Ident)\s*\)\s*\(/rtrim($1) . " " . "\(\*$2\)\("/ex;
+				    s/^(.\s*)$Declare\s*\(\s*\*\s*$Ident\s*\)\s*\(/$1 . $declare . $post_declare_space . '(*' . $funcname . ')('/ex;
 			}
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty



