Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaGAVdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:33:13 -0400
Received: from smtprelay0219.hostedemail.com ([216.40.44.219]:46742 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751611AbaGAVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:33:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2332:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3870:3874:5007:6119:7652:7903:8957:10004:10400:10848:11026:11473:11658:11914:12043:12049:12517:12519:12555:13019:13069:13208:13229:13311:13357:21063:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: food42_38a2d6f4f9a1b
X-Filterd-Recvd-Size: 3034
Message-ID: <1404250387.14624.42.camel@joe-AO725>
Subject: [PATCH] checkpatch: Emit fewer kmalloc_array/kcalloc conversion
 warnings
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org
Date: Tue, 01 Jul 2014 14:33:07 -0700
In-Reply-To: <268827901.224510.1404245225814.open-xchange@webmail.nmp.skynet.be>
References: <1403899823-4461-1-git-send-email-fabf@skynet.be>
	 <1403905024.9064.16.camel@joe-AO725>
	 <20140629112156.6a14ad3599a016a1c05c4771@skynet.be>
	 <1404034438.9064.55.camel@joe-AO725>
	 <268827901.224510.1404245225814.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid matching allocs that appear to be known
small multiplications of a sizeof with a constant
because gcc as of 4.8 cannot optimize the code in
a calloc() exactly the same way as an alloc().

Look for numeric constants or what appear to be
upper case only macro #defines.

Signed-off-by: Joe Perches <joe@perches.com>
Noticed-by: Theodore Ts'o <tytso@mit.edu>
Original-patch-by: Fabian Frederick <fabf@skynet.be>
---
 scripts/checkpatch.pl | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6c7cbaf..e0d0ead 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4486,22 +4486,23 @@ sub process {
 
 # check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
 		if ($^V && $^V ge 5.10.0 &&
-		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
+		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
 			my $oldfunc = $3;
 			my $a1 = $4;
 			my $a2 = $10;
 			my $newfunc = "kmalloc_array";
 			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
-			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
+			my $r1 = $a1;
+			my $r2 = $a2;
+			if ($a1 =~ /^sizeof\s*\S/) {
+				$r1 = $a2;
+				$r2 = $a1;
+			}
+			if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
+			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_][A-Z0-9_]*$/)) {
 				if (WARN("ALLOC_WITH_MULTIPLY",
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
 				    $fix) {
-					my $r1 = $a1;
-					my $r2 = $a2;
-					if ($a1 =~ /^sizeof\s*\S/) {
-						$r1 = $a2;
-						$r2 = $a1;
-					}
 					$fixed[$linenr - 1] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
 
 				}



