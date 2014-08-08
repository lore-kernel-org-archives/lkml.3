Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbaHHVhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:37:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619AbaHHVhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:37:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 11/17] tg3: Modify tg3_tso_bug() to handle multiple TX rings
Date: Fri,  8 Aug 2014 14:35:33 -0700
Message-Id: <20140808213457.977999010@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213457.511493898@linuxfoundation.org>
References: <20140808213457.511493898@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Sreedharan <prashant@broadcom.com>

[ Upstream commit 4d8fdc95c60e90d84c8257a0067ff4b1729a3757 ]

tg3_tso_bug() was originally designed to handle only HW TX ring 0, Commit
d3f6f3a1d818410c17445bce4f4caab52eb102f1 ("tg3: Prevent page allocation failure
during TSO workaround") changed the driver logic to use tg3_tso_bug() for all
HW TX rings that are enabled. This patch fixes the regression by modifying
tg3_tso_bug() to handle multiple HW TX rings.

Signed-off-by: Prashant Sreedharan <prashant@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7830,17 +7830,18 @@ static int tigon3_dma_hwbug_workaround(s
 
 static netdev_tx_t tg3_start_xmit(struct sk_buff *, struct net_device *);
 
-/* Use GSO to workaround a rare TSO bug that may be triggered when the
- * TSO header is greater than 80 bytes.
+/* Use GSO to workaround all TSO packets that meet HW bug conditions
+ * indicated in tg3_tx_frag_set()
  */
-static int tg3_tso_bug(struct tg3 *tp, struct sk_buff *skb)
+static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
+		       struct netdev_queue *txq, struct sk_buff *skb)
 {
 	struct sk_buff *segs, *nskb;
 	u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
 
 	/* Estimate the number of fragments in the worst case */
-	if (unlikely(tg3_tx_avail(&tp->napi[0]) <= frag_cnt_est)) {
-		netif_stop_queue(tp->dev);
+	if (unlikely(tg3_tx_avail(tnapi) <= frag_cnt_est)) {
+		netif_tx_stop_queue(txq);
 
 		/* netif_tx_stop_queue() must be done before checking
 		 * checking tx index in tg3_tx_avail() below, because in
@@ -7848,13 +7849,14 @@ static int tg3_tso_bug(struct tg3 *tp, s
 		 * netif_tx_queue_stopped().
 		 */
 		smp_mb();
-		if (tg3_tx_avail(&tp->napi[0]) <= frag_cnt_est)
+		if (tg3_tx_avail(tnapi) <= frag_cnt_est)
 			return NETDEV_TX_BUSY;
 
-		netif_wake_queue(tp->dev);
+		netif_tx_wake_queue(txq);
 	}
 
-	segs = skb_gso_segment(skb, tp->dev->features & ~(NETIF_F_TSO | NETIF_F_TSO6));
+	segs = skb_gso_segment(skb, tp->dev->features &
+				    ~(NETIF_F_TSO | NETIF_F_TSO6));
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
 
@@ -7930,7 +7932,7 @@ static netdev_tx_t tg3_start_xmit(struct
 		if (!skb_is_gso_v6(skb)) {
 			if (unlikely((ETH_HLEN + hdr_len) > 80) &&
 			    tg3_flag(tp, TSO_BUG))
-				return tg3_tso_bug(tp, skb);
+				return tg3_tso_bug(tp, tnapi, txq, skb);
 
 			ip_csum = iph->check;
 			ip_tot_len = iph->tot_len;
@@ -8061,7 +8063,7 @@ static netdev_tx_t tg3_start_xmit(struct
 				iph->tot_len = ip_tot_len;
 			}
 			tcph->check = tcp_csum;
-			return tg3_tso_bug(tp, skb);
+			return tg3_tso_bug(tp, tnapi, txq, skb);
 		}
 
 		/* If the workaround fails due to memory/mapping


