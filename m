Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3JaXMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:12:48 -0400
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:45193 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751574Ab3JaXMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:12:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3868:3870:3871:4321:4605:5007:7652:9592:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12555:12679:13019:13069:13095:13141:13161:13229:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: soda34_181f416bd044c
X-Filterd-Recvd-Size: 2964
Message-ID: <1383261164.2769.6.camel@joe-AO722>
Subject: [PATCH V2] checkpatch: Improve "return is not a function" test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Thu, 31 Oct 2013 16:12:44 -0700
In-Reply-To: <1383075490.12439.26.camel@joe-AO722>
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
	 <1383070766.12439.13.camel@joe-AO722> <526FFED4.4070902@linux.intel.com>
	 <1383071755.12439.17.camel@joe-AO722> <52700D4C.10008@linux.intel.com>
	 <1383075490.12439.26.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find a few more cases where parentheses are used around
the value of a return statement.

This now uses the "$balanced_parens" test and also makes
the test depend on perl v5.10 and higher.

This now finds return with parenthesis uses the old code
did not find like:

ERROR: return is not a function, parentheses are not required
#211: FILE: arch/m68k/include/asm/sun3xflop.h:211:
+		return ((error == 0) ? 0 : -1);

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Add example to commit message.
    No change in patch itself.

 scripts/checkpatch.pl | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 23d55bf..957ba04 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3221,21 +3221,10 @@ sub process {
 		}
 
 # Return is not a function.
-		if (defined($stat) && $stat =~ /^.\s*return(\s*)(\(.*);/s) {
+		if (defined($stat) && $stat =~ /^.\s*return(\s*)\(/s) {
 			my $spacing = $1;
-			my $value = $2;
-
-			# Flatten any parentheses
-			$value =~ s/\(/ \(/g;
-			$value =~ s/\)/\) /g;
-			while ($value =~ s/\[[^\[\]]*\]/1/ ||
-			       $value !~ /(?:$Ident|-?$Constant)\s*
-					     $Compare\s*
-					     (?:$Ident|-?$Constant)/x &&
-			       $value =~ s/\([^\(\)]*\)/1/) {
-			}
-#print "value<$value>\n";
-			if ($value =~ /^\s*(?:$Ident|-?$Constant)\s*$/) {
+			if ($^V && $^V ge 5.10.0 &&
+			    $stat =~ /^.\s*return\s*$balanced_parens\s*;\s*$/) {
 				ERROR("RETURN_PARENTHESES",
 				      "return is not a function, parentheses are not required\n" . $herecurr);
 
@@ -3244,6 +3233,7 @@ sub process {
 				      "space required before the open parenthesis '('\n" . $herecurr);
 			}
 		}
+
 # Return of what appears to be an errno should normally be -'ve
 		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
 			my $name = $1;



