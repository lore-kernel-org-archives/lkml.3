Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaJPK2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:28:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37343 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752573AbaJPKUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:20:18 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 27/53] dmaengine: mpc512x: Split device_control
Date: Thu, 16 Oct 2014 12:17:26 +0200
Message-Id: <1413454672-27400-28-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Freescale MPC512x DMA driver to make
use of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/mpc512x_dma.c | 111 +++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 60 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 881db2bcb48b..15f2b56359e6 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -800,79 +800,69 @@ err_prep:
 	return NULL;
 }
 
-static int mpc_dma_device_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-							unsigned long arg)
+static int mpc_dma_device_config(struct dma_chan *chan,
+				 struct dma_slave_config *cfg)
 {
-	struct mpc_dma_chan *mchan;
-	struct mpc_dma *mdma;
-	struct dma_slave_config *cfg;
+	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
 	unsigned long flags;
 
-	mchan = dma_chan_to_mpc_dma_chan(chan);
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		/* Disable channel requests */
-		mdma = dma_chan_to_mpc_dma(chan);
-
-		spin_lock_irqsave(&mchan->lock, flags);
-
-		out_8(&mdma->regs->dmacerq, chan->chan_id);
-		list_splice_tail_init(&mchan->prepared, &mchan->free);
-		list_splice_tail_init(&mchan->queued, &mchan->free);
-		list_splice_tail_init(&mchan->active, &mchan->free);
-
-		spin_unlock_irqrestore(&mchan->lock, flags);
+	/*
+	 * Software constraints:
+	 *  - only transfers between a peripheral device and
+	 *     memory are supported;
+	 *  - only peripheral devices with 4-byte FIFO access register
+	 *     are supported;
+	 *  - minimal transfer chunk is 4 bytes and consequently
+	 *     source and destination addresses must be 4-byte aligned
+	 *     and transfer size must be aligned on (4 * maxburst)
+	 *     boundary;
+	 *  - during the transfer RAM address is being incremented by
+	 *     the size of minimal transfer chunk;
+	 *  - peripheral port's address is constant during the transfer.
+	 */
 
-		return 0;
+	if (cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES ||
+	    cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES ||
+	    !IS_ALIGNED(cfg->src_addr, 4) ||
+	    !IS_ALIGNED(cfg->dst_addr, 4)) {
+		return -EINVAL;
+	}
 
-	case DMA_SLAVE_CONFIG:
-		/*
-		 * Software constraints:
-		 *  - only transfers between a peripheral device and
-		 *     memory are supported;
-		 *  - only peripheral devices with 4-byte FIFO access register
-		 *     are supported;
-		 *  - minimal transfer chunk is 4 bytes and consequently
-		 *     source and destination addresses must be 4-byte aligned
-		 *     and transfer size must be aligned on (4 * maxburst)
-		 *     boundary;
-		 *  - during the transfer RAM address is being incremented by
-		 *     the size of minimal transfer chunk;
-		 *  - peripheral port's address is constant during the transfer.
-		 */
+	spin_lock_irqsave(&mchan->lock, flags);
 
-		cfg = (void *)arg;
+	mchan->src_per_paddr = cfg->src_addr;
+	mchan->src_tcd_nunits = cfg->src_maxburst;
+	mchan->dst_per_paddr = cfg->dst_addr;
+	mchan->dst_tcd_nunits = cfg->dst_maxburst;
 
-		if (cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES ||
-		    cfg->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES ||
-		    !IS_ALIGNED(cfg->src_addr, 4) ||
-		    !IS_ALIGNED(cfg->dst_addr, 4)) {
-			return -EINVAL;
-		}
+	/* Apply defaults */
+	if (mchan->src_tcd_nunits == 0)
+		mchan->src_tcd_nunits = 1;
+	if (mchan->dst_tcd_nunits == 0)
+		mchan->dst_tcd_nunits = 1;
 
-		spin_lock_irqsave(&mchan->lock, flags);
+	spin_unlock_irqrestore(&mchan->lock, flags);
 
-		mchan->src_per_paddr = cfg->src_addr;
-		mchan->src_tcd_nunits = cfg->src_maxburst;
-		mchan->dst_per_paddr = cfg->dst_addr;
-		mchan->dst_tcd_nunits = cfg->dst_maxburst;
+	return 0;
+}
 
-		/* Apply defaults */
-		if (mchan->src_tcd_nunits == 0)
-			mchan->src_tcd_nunits = 1;
-		if (mchan->dst_tcd_nunits == 0)
-			mchan->dst_tcd_nunits = 1;
+static int mpc_dma_device_terminate_all(struct dma_chan *chan)
+{
+	struct mpc_dma_chan *mchan = dma_chan_to_mpc_dma_chan(chan);
+	struct mpc_dma *mdma = dma_chan_to_mpc_dma(chan);
+	unsigned long flags;
 
-		spin_unlock_irqrestore(&mchan->lock, flags);
+	/* Disable channel requests */
+	spin_lock_irqsave(&mchan->lock, flags);
 
-		return 0;
+	out_8(&mdma->regs->dmacerq, chan->chan_id);
+	list_splice_tail_init(&mchan->prepared, &mchan->free);
+	list_splice_tail_init(&mchan->queued, &mchan->free);
+	list_splice_tail_init(&mchan->active, &mchan->free);
 
-	default:
-		/* Unknown command */
-		break;
-	}
+	spin_unlock_irqrestore(&mchan->lock, flags);
 
-	return -ENXIO;
+	return 0;
 }
 
 static int mpc_dma_probe(struct platform_device *op)
@@ -966,7 +956,8 @@ static int mpc_dma_probe(struct platform_device *op)
 	dma->device_tx_status = mpc_dma_tx_status;
 	dma->device_prep_dma_memcpy = mpc_dma_prep_memcpy;
 	dma->device_prep_slave_sg = mpc_dma_prep_slave_sg;
-	dma->device_control = mpc_dma_device_control;
+	dma->device_config = mpc_dma_device_config;
+	dma->device_terminate_all = mpc_dma_device_terminate_all;
 
 	INIT_LIST_HEAD(&dma->channels);
 	dma_cap_set(DMA_MEMCPY, dma->cap_mask);
-- 
2.1.1

