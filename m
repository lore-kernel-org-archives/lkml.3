Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3LCS31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:29:27 -0500
Received: from smtprelay0161.hostedemail.com ([216.40.44.161]:45667 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753561Ab3LCS3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:29:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:69:355:379:541:800:960:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2693:2716:2737:2828:2901:3138:3139:3140:3141:3142:3353:3865:3866:3867:3872:3874:4225:4385:4419:5007:7652:9592:10004:10400:10481:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:12683:13141:13230:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: birds51_34980db914b1c
X-Filterd-Recvd-Size: 3024
Message-ID: <1386095360.15309.29.camel@joe-AO722>
Subject: [PATCH] mac80211: rx: Neaten ieee80211_deliver_skb, remove
 compare_ether_addr
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Dec 2013 10:29:20 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unnecessary duplicate test of "if (skb) {"
when !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.

Remove now unnecessary __maybe_unused, neaten comment
Remove unnecessary parenthesis around align cast.
Substitute reference to deprecated compare_ether_addr
with ether_addr_equal.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/mac80211/rx.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index caecef8..b178c8f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1937,20 +1937,17 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		}
 	}
 
-	if (skb) {
-		int align __maybe_unused;
-
 #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-		/*
-		 * 'align' will only take the values 0 or 2 here
-		 * since all frames are required to be aligned
-		 * to 2-byte boundaries when being passed to
-		 * mac80211; the code here works just as well if
-		 * that isn't true, but mac80211 assumes it can
-		 * access fields as 2-byte aligned (e.g. for
-		 * compare_ether_addr)
+	if (skb) {
+		/* 'align' will only take the values 0 or 2 here since all
+		 * frames are required to be aligned to 2-byte boundaries
+		 * when being passed to mac80211; the code here works just
+		 * as well if that isn't true, but mac80211 assumes it can
+		 * access fields as 2-byte aligned (e.g. for ether_addr_equal)
 		 */
-		align = ((unsigned long)(skb->data + sizeof(struct ethhdr))) & 3;
+		int align;
+
+		align = (unsigned long)(skb->data + sizeof(struct ethhdr)) & 3;
 		if (align) {
 			if (WARN_ON(skb_headroom(skb) < 3)) {
 				dev_kfree_skb(skb);
@@ -1963,14 +1960,14 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 				skb_set_tail_pointer(skb, len);
 			}
 		}
+	}
 #endif
 
-		if (skb) {
-			/* deliver to local stack */
-			skb->protocol = eth_type_trans(skb, dev);
-			memset(skb->cb, 0, sizeof(skb->cb));
-			netif_receive_skb(skb);
-		}
+	if (skb) {
+		/* deliver to local stack */
+		skb->protocol = eth_type_trans(skb, dev);
+		memset(skb->cb, 0, sizeof(skb->cb));
+		netif_receive_skb(skb);
 	}
 
 	if (xmit_skb) {


