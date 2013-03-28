Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3C1Vc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 17:32:58 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34712 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3C1Vc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 17:32:56 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/2] net: calxedaxgmac: fix rx ring handling when OOM
Date: Thu, 28 Mar 2013 16:32:44 -0500
Message-Id: <1364506365-13689-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

If skb allocation for the rx ring fails repeatedly, we can reach a point
were the ring is empty. In this condition, the driver is out of sync with
the h/w. While this has always been possible, the removal of the skb
recycling seems to have made triggering this problem easier.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index a170065..bb1e80b 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1141,6 +1141,9 @@ static int xgmac_rx(struct xgmac_priv *priv, int limit)
 		struct sk_buff *skb;
 		int frame_len;
 
+		if (!dma_ring_cnt(priv->rx_head, priv->rx_tail, DMA_RX_RING_SZ))
+			break;
+
 		entry = priv->rx_tail;
 		p = priv->dma_rx + entry;
 		if (desc_get_owner(p))
-- 
1.7.10.4

