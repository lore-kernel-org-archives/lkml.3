Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaCSAIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:08:50 -0400
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:34537 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755163AbaCSAIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:08:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:2898:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3871:3874:4321:4605:5007:7652:7903:8957:10004:10026:10400:10848:11026:11232:11658:11914:12043:12291:12346:12438:12517:12519:12555:12683:13019:13255:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nest95_69e69f7d80634
X-Filterd-Recvd-Size: 4009
Message-ID: <1395187726.26549.15.camel@joe-AO722>
Subject: [PATCH V2] checkpatch: Reduce false positives for "Missing blank
 line after declarations" test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 18 Mar 2014 17:08:46 -0700
In-Reply-To: <1395086635.2556.28.camel@joe-AO722>
References: <1395081926.2556.27.camel@joe-AO722>
	 <1395086635.2556.28.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the false positives of this test by checking
previous lines for known macros that declare variables.

Add c90 keywords and test those too.

Comment the specific tests done a bit better.

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: I believe this one works better.
    Don't allow "else if" to be an $Ident $Ident match
    Skip bitfield continuations too

 scripts/checkpatch.pl | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d44e440..93beee8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -303,6 +303,7 @@ our $Operators	= qr{
 			=>|->|<<|>>|<|>|!|~|
 			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
 		  }x;
+our $c90_Keywords = qr{do|for|while|if|else|return|goto|continue|switch|default|case|break}x;
 
 our $NonptrType;
 our $NonptrTypeWithAttr;
@@ -388,6 +389,11 @@ our @mode_permission_funcs = (
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
@@ -2251,14 +2257,32 @@ sub process {
 		}
 
 # check for missing blank lines after declarations
-		if ($prevline =~ /^\+\s+$Declare\s+$Ident/ &&
-		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
-		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
-		    $sline =~ /^\+\s+/ &&			#Not at char 1
+		if ($sline =~ /^\+\s+\S/ &&			#Not at char 1
+			# actual declarations
+		    ($prevline =~ /^\+\s+$Declare\s+$Ident\s*[=,;\[]/ ||
+			# foo bar; where foo is some local typedef or #define
+		     $prevline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			# known declaration macros
+		     $prevline =~ /^\+\s+$declaration_macros/) &&
+			# for "else if" which can look like "$Ident $Ident"
+		    !($prevline =~ /^\+\s+$c90_Keywords\b/ ||
+			# other possible extensions of declaration lines
+		      $prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
+			# not starting a section or a macro "\" extended line
+		      $prevline =~ /(?:\{\s*|\\)$/) &&
+			# looks like a declaration
 		    !($sline =~ /^\+\s+$Declare/ ||
-		      $sline =~ /^\+\s+$Ident\s+$Ident/ ||	#eg: typedef foo
+			# foo bar; where foo is some local typedef or #define
+		      $sline =~ /^\+\s+$Ident(?:\s+|\s*\*\s*)$Ident\s*[=,;\[]/ ||
+			# known declaration macros
+		      $sline =~ /^\+\s+$declaration_macros/ ||
+			# start of struct or union or enum
 		      $sline =~ /^\+\s+(?:union|struct|enum|typedef)\b/ ||
-		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
+			# start or end of block or continuation of declaration
+		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(\[])/ ||
+			# bitfield continuation
+		      $sline =~ /^\+\s+$Ident\s*:\s*\d+\s*[,;]/ ||
+			# other possible extensions of declaration lines
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
 			WARN("SPACING",
 			     "Missing a blank line after declarations\n" . $hereprev);
-- 
1.8.1.2.459.gbcd45b4.dirty



