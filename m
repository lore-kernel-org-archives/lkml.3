Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750781AbaCQSpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:45:30 -0400
Received: from smtprelay0003.hostedemail.com ([216.40.44.3]:40303 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750706AbaCQSp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:45:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2332:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3868:3874:4321:4605:5007:7652:7903:8784:10004:10400:10848:11026:11658:11914:12043:12438:12517:12519:12555:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sock29_86fe44923a333
X-Filterd-Recvd-Size: 2773
Message-ID: <1395081926.2556.27.camel@joe-AO722>
Subject: [PATCH] checkpatch: Reduce false positives for "Missing blank line
 after declarations" test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 17 Mar 2014 11:45:26 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid some false positives for this test by adding
a few common macro types that declare variables.

	DECLARE_<FOO>
	DEFINE_<BAR>
	LIST_HEAD

Also allow extended bitfield declarations like

	int a:5,
	    b:2,
	    c:1;

and avoid emitting this warning on declarations like

	int foo[bar]
	       [baz];

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d44e440..98e0be7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -388,6 +388,11 @@ our @mode_permission_funcs = (
 	["(?:CLASS|DEVICE|SENSOR)_ATTR", 2],
 );
 
+our $declaration_macros = qr{(?x:
+	(?:$Storage\s+)?(?:DECLARE|DEFINE)_[A-Z]+\s*\(|
+	(?:$Storage\s+)?LIST_HEAD\s*\(
+)};
+
 our $allowed_asm_includes = qr{(?x:
 	irq|
 	memory
@@ -2251,14 +2256,18 @@ sub process {
 		}
 
 # check for missing blank lines after declarations
-		if ($prevline =~ /^\+\s+$Declare\s+$Ident/ &&
+		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
+		    ($prevline =~ /^\+\s+$Declare\s+$Ident/ ||
+		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident/ ||
+		     $prevline =~ /^\+\s+$declaration_macros/) &&
 		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
 		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
-		    $sline =~ /^\+\s+/ &&			#Not at char 1
 		    !($sline =~ /^\+\s+$Declare/ ||
-		      $sline =~ /^\+\s+$Ident\s+$Ident/ ||	#eg: typedef foo
+		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident/ ||	#eg: typedef foo
+		      $sline =~ /^\+\s+$declaration_macros/ ||
 		      $sline =~ /^\+\s+(?:union|struct|enum|typedef)\b/ ||
-		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
+		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(\[])/ ||
+		      $sline =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||	#bitfield
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
 			WARN("SPACING",
 			     "Missing a blank line after declarations\n" . $hereprev);


