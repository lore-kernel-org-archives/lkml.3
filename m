Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934814AbaGRJwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:52:39 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:43903 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934416AbaGRJwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:52:35 -0400
Message-ID: <53C8EE60.8020707@gmail.com>
Date: Fri, 18 Jul 2014 11:52:32 +0200
From: Neil Armstrong <superna9999@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: macb: Separate rx and tx ring init function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A single method is called to initialize the TX and RX
rings. Separate the methods into distinct ones for
MACB and GEM context.

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
---
 drivers/net/ethernet/cadence/macb.c |   33 ++++++++++++++++++++++++---------
 drivers/net/ethernet/cadence/macb.h |    3 ++-
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index e9daa07..20ad483 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1219,7 +1219,14 @@ out_err:
 	return -ENOMEM;
 }
 
-static void gem_init_rings(struct macb *bp)
+static void gem_init_rx_rings(struct macb *bp)
+{
+	bp->rx_tail = bp->rx_prepared_head = 0;
+
+	gem_rx_refill(bp);
+}
+
+static void gem_init_tx_rings(struct macb *bp)
 {
 	int i;
 
@@ -1229,12 +1236,10 @@ static void gem_init_rings(struct macb *bp)
 	}
 	bp->tx_ring[TX_RING_SIZE - 1].ctrl |= MACB_BIT(TX_WRAP);
 
-	bp->rx_tail = bp->rx_prepared_head = bp->tx_head = bp->tx_tail = 0;
-
-	gem_rx_refill(bp);
+	bp->tx_head = bp->tx_tail = 0;
 }
 
-static void macb_init_rings(struct macb *bp)
+static void macb_init_rx_rings(struct macb *bp)
 {
 	int i;
 	dma_addr_t addr;
@@ -1247,13 +1252,20 @@ static void macb_init_rings(struct macb *bp)
 	}
 	bp->rx_ring[RX_RING_SIZE - 1].addr |= MACB_BIT(RX_WRAP);
 
+	bp->rx_tail = 0;
+}
+
+static void macb_init_tx_rings(struct macb *bp)
+{
+	int i;
+
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		bp->tx_ring[i].addr = 0;
 		bp->tx_ring[i].ctrl = MACB_BIT(TX_USED);
 	}
 	bp->tx_ring[TX_RING_SIZE - 1].ctrl |= MACB_BIT(TX_WRAP);
 
-	bp->rx_tail = bp->tx_head = bp->tx_tail = 0;
+	bp->tx_head = bp->tx_tail = 0;
 }
 
 static void macb_reset_hw(struct macb *bp)
@@ -1554,7 +1566,8 @@ static int macb_open(struct net_device *dev)
 
 	napi_enable(&bp->napi);
 
-	bp->macbgem_ops.mog_init_rings(bp);
+	bp->macbgem_ops.mog_init_rx_rings(bp);
+	bp->macbgem_ops.mog_init_tx_rings(bp);
 	macb_init_hw(bp);
 
 	/* schedule a link state check */
@@ -1901,12 +1914,14 @@ static int __init macb_probe(struct platform_device *pdev)
 	if (macb_is_gem(bp)) {
 		bp->macbgem_ops.mog_alloc_rx_buffers = gem_alloc_rx_buffers;
 		bp->macbgem_ops.mog_free_rx_buffers = gem_free_rx_buffers;
-		bp->macbgem_ops.mog_init_rings = gem_init_rings;
+		bp->macbgem_ops.mog_init_rx_rings = gem_init_rx_rings;
+		bp->macbgem_ops.mog_init_tx_rings = gem_init_tx_rings;
 		bp->macbgem_ops.mog_rx = gem_rx;
 	} else {
 		bp->macbgem_ops.mog_alloc_rx_buffers = macb_alloc_rx_buffers;
 		bp->macbgem_ops.mog_free_rx_buffers = macb_free_rx_buffers;
-		bp->macbgem_ops.mog_init_rings = macb_init_rings;
+		bp->macbgem_ops.mog_init_rx_rings = macb_init_rx_rings;
+		bp->macbgem_ops.mog_init_tx_rings = macb_init_tx_rings;
 		bp->macbgem_ops.mog_rx = macb_rx;
 	}
 
diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 51c0244..8016d08 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -550,7 +550,8 @@ struct macb;
 struct macb_or_gem_ops {
 	int	(*mog_alloc_rx_buffers)(struct macb *bp);
 	void	(*mog_free_rx_buffers)(struct macb *bp);
-	void	(*mog_init_rings)(struct macb *bp);
+	void	(*mog_init_rx_rings)(struct macb *bp);
+	void	(*mog_init_tx_rings)(struct macb *bp);
 	int	(*mog_rx)(struct macb *bp, int budget);
 };
 
-- 
1.7.0.4
