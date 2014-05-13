Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaEMXs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:48:56 -0400
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:52410 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751409AbaEMXsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:48:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:2897:3138:3139:3140:3141:3142:3352:3653:3867:3868:3874:5007:7652:7903:8957:10004:10400:10848:11026:11473:11658:11914:12043:12049:12296:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stone07_87816f9da5e26
X-Filterd-Recvd-Size: 1925
Message-ID: <1400024929.24350.76.camel@joe-AO725>
Subject: [PATCH] checkpatch: Add --strict test for kmalloc/kzalloc with
 multiply
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 May 2014 16:48:49 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect against sizeof overflows by preferring
kmalloc_array and kcalloc to kmalloc/kzalloc
with a sizeof multiply.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e7ff52a..33eb71f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4378,6 +4378,20 @@ sub process {
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
+				CHK("ALLOC_WITH_MULTIPLY",
+				    "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr);
+			}
+		}
+
 # check for krealloc arg reuse
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {


