Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3HZWqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:46:06 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46597 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3HZWqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:46:02 -0400
From: Rob Herring <robherring2@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andreas Herrmann <andreas.herrmann@calxeda.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 10/11] net: calxedaxgmac: fix rx DMA mapping API size mismatches
Date: Mon, 26 Aug 2013 17:45:25 -0500
Message-Id: <1377557126-10716-10-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377557126-10716-1-git-send-email-robherring2@gmail.com>
References: <1377557126-10716-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Fix the mismatch in the DMA mapping and unmapping sizes for receive. The
unmap size must be equal to the map size and should not be the actual
received frame length. The map size should also be adjusted by the
NET_IP_ALIGN size since the h/w buffer size (dma_buf_sz) includes this
offset.

Also, add a missing dma_mapping_error check in xgmac_rx_refill.

Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index b206268..f149c08 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -695,9 +695,14 @@ static void xgmac_rx_refill(struct xgmac_priv *priv)
 			if (unlikely(skb == NULL))
 				break;
 
-			priv->rx_skbuff[entry] = skb;
 			paddr = dma_map_single(priv->device, skb->data,
-					       bufsz, DMA_FROM_DEVICE);
+					       priv->dma_buf_sz - NET_IP_ALIGN,
+					       DMA_FROM_DEVICE);
+			if (dma_mapping_error(priv->device, paddr)) {
+				dev_kfree_skb_any(skb);
+				break;
+			}
+			priv->rx_skbuff[entry] = skb;
 			desc_set_buf_addr(p, paddr, priv->dma_buf_sz);
 		}
 
@@ -794,13 +799,14 @@ static void xgmac_free_rx_skbufs(struct xgmac_priv *priv)
 		return;
 
 	for (i = 0; i < DMA_RX_RING_SZ; i++) {
-		if (priv->rx_skbuff[i] == NULL)
+		struct sk_buff *skb = priv->rx_skbuff[i];
+		if (skb == NULL)
 			continue;
 
 		p = priv->dma_rx + i;
 		dma_unmap_single(priv->device, desc_get_buf_addr(p),
-				 priv->dma_buf_sz, DMA_FROM_DEVICE);
-		dev_kfree_skb_any(priv->rx_skbuff[i]);
+				 priv->dma_buf_sz - NET_IP_ALIGN, DMA_FROM_DEVICE);
+		dev_kfree_skb_any(skb);
 		priv->rx_skbuff[i] = NULL;
 	}
 }
@@ -1190,7 +1196,7 @@ static int xgmac_rx(struct xgmac_priv *priv, int limit)
 
 		skb_put(skb, frame_len);
 		dma_unmap_single(priv->device, desc_get_buf_addr(p),
-				 frame_len, DMA_FROM_DEVICE);
+				 priv->dma_buf_sz - NET_IP_ALIGN, DMA_FROM_DEVICE);
 
 		skb->protocol = eth_type_trans(skb, priv->dev);
 		skb->ip_summed = ip_checksum;
-- 
1.8.1.2

