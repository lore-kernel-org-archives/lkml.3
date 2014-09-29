Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaI2SCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:02:40 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:55025 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754054AbaI2SCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:02:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:3874:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: snake52_6e0e68051c019
X-Filterd-Recvd-Size: 2260
Message-ID: <1412013755.4302.45.camel@joe-AO725>
Subject: Re: checkpatch: CHECK: No space is necessary after a cast
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dan Carpenter <error27@gmail.com>
Date: Mon, 29 Sep 2014 11:02:35 -0700
In-Reply-To: <874mvq1w9v.fsf@kamboji.qca.qualcomm.com>
References: <874mvq1w9v.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 14:49 +0300, Kalle Valo wrote:
> Hi Joe,
> 
> I have a problem with checkpatch. On ath10k we have this function:
> 
> static inline struct ath10k_skb_cb *ATH10K_SKB_CB(struct sk_buff *skb)
> {
> 	BUILD_BUG_ON(sizeof(struct ath10k_skb_cb) >
> 		     IEEE80211_TX_INFO_DRIVER_DATA_SIZE);
> 	return (struct ath10k_skb_cb *)&IEEE80211_SKB_CB(skb)->driver_data;
> }
> 
> And the BUILD_BUG_ON triggers this warning:
> 
> drivers/net/wireless/ath/ath10k/core.h:85: CHECK: No space is necessary after a cast
> 
> Any advice how to handle that?

It's a checkpatch false positive that could be fixed.

It needs something like another test to look for
sizeof(type) as not a cast and more arithmetic/comparison
uses.

Maybe you can test this?
---
 scripts/checkpatch.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 52a223e..6132329 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2515,7 +2515,8 @@ sub process {
 			}
 		}
 
-		if ($line =~ /^\+.*\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|{)/) {
+		if ($line =~ /^\+.*(\w+\s*)?\(\s*$Type\s*\)[ \t]+(?!$Assignment|$Arithmetic|[,;\({\[\<\>])/ &&
+		    (!defined($1) || $1 !~ /sizeof\s*/)) {
 			if (CHK("SPACING",
 				"No space is necessary after a cast\n" . $herecurr) &&
 			    $fix) {


