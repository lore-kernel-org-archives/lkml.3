Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaEOX1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 19:27:32 -0400
Received: from smtprelay0026.hostedemail.com ([216.40.44.26]:60491 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753215AbaEOX1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 19:27:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:2897:3138:3139:3140:3141:3142:3353:3653:3867:3872:3874:4250:4321:5007:7652:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12049:12291:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mint44_40c407493cf18
X-Filterd-Recvd-Size: 2637
Message-ID: <1400196443.5058.30.camel@joe-AO725>
Subject: [PATCH V2] checkpatch: Add warning for kmalloc/kzalloc with multiply
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 May 2014 16:27:23 -0700
In-Reply-To: <20140515160728.aa401aa7b21c88ea098ddc60@linux-foundation.org>
References: <1400024929.24350.76.camel@joe-AO725>
	 <20140515155844.041ee0bc17aae5f3b8eacd70@linux-foundation.org>
	 <1400195086.5058.26.camel@joe-AO725>
	 <20140515160728.aa401aa7b21c88ea098ddc60@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect against sizeof overflows by preferring
kmalloc_array/kcalloc over kmalloc/kzalloc
with a sizeof multiply.

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: Make it a WARN instead.
    Add capability to --fix it too.

 scripts/checkpatch.pl | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e7ff52a..7774025 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4378,6 +4378,30 @@ sub process {
 			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
 		}
 
+# check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
+			my $oldfunc = $3;
+			my $a1 = $4;
+			my $a2 = $10;
+			my $newfunc = "kmalloc_array";
+			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
+			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
+				if (WARN("ALLOC_WITH_MULTIPLY",
+					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
+				    $fix) {
+					my $r1 = $a1;
+					my $r2 = $a2;
+					if ($a1 =~ /^sizeof\s*\S/) {
+						$r1 = $a2;
+						$r2 = $a1;
+					}
+					$fixed[$linenr - 1] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
+
+				}
+			}
+		}
+
 # check for krealloc arg reuse
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {


