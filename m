Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaCBNf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 08:35:26 -0500
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:53044 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753232AbaCBNfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 08:35:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2198:2199:2200:2332:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3871:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bike66_2ebbe73a8a008
X-Filterd-Recvd-Size: 2334
Message-ID: <1393767319.13719.23.camel@joe-AO722>
Subject: Re: [iio:togreg 3/3] WARNING: Reusing the krealloc arg is almost
 always a bug
From: Joe Perches <joe@perches.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andy Whitcroft <apw@shadowen.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 02 Mar 2014 05:35:19 -0800
In-Reply-To: <1393762005.13719.13.camel@joe-AO722>
References: <53124ca5.kw+3caZ7enyrhSmq%fengguang.wu@intel.com>
	 <20140302022404.GA16141@localhost> <5312F5BC.7080607@metafoo.de>
	 <1393762005.13719.13.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That last one doesn't work if the krealloc has a cast like
	foo = (struct bar *)krealloc(foo, 1, GFP_KERNEL)
Maybe this one is better...
---
 scripts/checkpatch.pl | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 91308be..43914c3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4275,9 +4275,20 @@ sub process {
 
 # check for krealloc arg reuse
 		if ($^V && $^V ge 5.10.0 &&
-		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {
-			WARN("KREALLOC_ARG_REUSE",
-			     "Reusing the krealloc arg is almost always a bug\n" . $herecurr);
+		    $line =~ /($Lval)\s*\=\s*($balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {
+			my $cast = $2;
+			my $cast_count = 0;
+			my @line_lvals = $line =~ m/$Lval/g;
+			if (defined $cast) {
+				$cast_count++ while ($cast =~ /$Lval/g);
+			}
+			for my $index (1 + $cast_count .. $#line_lvals - 1) {
+				if ($line_lvals[$index] eq "krealloc" &&
+				    $line_lvals[$index - 1 - $cast_count] eq $line_lvals[$index + 1]) {
+					WARN("KREALLOC_ARG_REUSE",
+					     "Reusing the krealloc arg is almost always a bug\n" . $herecurr);
+				}
+			}
 		}
 
 # check for alloc argument mismatch


