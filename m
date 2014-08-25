Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbaHYOWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:22:48 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44595 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaHYOWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:22:46 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        eric.dumazet@gmail.com, mirqus@gmail.com,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v6 4/4] net: moxa: continue loop on skb allocation failure
Date: Mon, 25 Aug 2014 16:22:40 +0200
Message-Id: <1408976560-15694-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If netdev_alloc_skb_ip_align() fails, subsequent code will
try to dereference an invalid pointer.

Continue to next descriptor on error.

While we're at it,

1. eliminate the chance of an endless loop, replace the main
   loop with while(rx < budget)

2. use napi_complete() and remove the explicit napi_gro_flush()

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20140825

 drivers/net/ethernet/moxa/moxart_ether.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 983d019..2f12c88 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -206,7 +206,7 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
 	int rx_head = priv->rx_head;
 	int rx = 0;
 
-	while (1) {
+	while (rx < budget) {
 		desc = priv->rx_desc_base + (RX_REG_DESC_SIZE * rx_head);
 		desc0 = readl(desc + RX_REG_OFFSET_DESC0);
 
@@ -218,7 +218,7 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
 			net_dbg_ratelimited("packet error\n");
 			priv->stats.rx_dropped++;
 			priv->stats.rx_errors++;
-			continue;
+			goto rx_next;
 		}
 
 		len = desc0 & RX_DESC0_FRAME_LEN_MASK;
@@ -235,6 +235,7 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
 			net_dbg_ratelimited("netdev_alloc_skb_ip_align failed\n");
 			priv->stats.rx_dropped++;
 			priv->stats.rx_errors++;
+			goto rx_next;
 		}
 
 		memcpy(skb->data, priv->rx_buf[rx_head], len);
@@ -249,18 +250,15 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
 		if (desc0 & RX_DESC0_MULTICAST)
 			priv->stats.multicast++;
 
+rx_next:
 		writel(RX_DESC0_DMA_OWN, desc + RX_REG_OFFSET_DESC0);
 
 		rx_head = RX_NEXT(rx_head);
 		priv->rx_head = rx_head;
-
-		if (rx >= budget)
-			break;
 	}
 
 	if (rx < budget) {
-		napi_gro_flush(napi, false);
-		__napi_complete(napi);
+		napi_complete(napi);
 	}
 
 	priv->reg_imr |= RPKT_FINISH_M;
-- 
1.8.2.1

