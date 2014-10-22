Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaJVQIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:08:39 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53981 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754431AbaJVPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:20 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 12/59] dmaengine: pl08x: Split device_control
Date: Wed, 22 Oct 2014 17:43:26 +0200
Message-Id: <1413992653-21963-13-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the AMBA PL08x DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/amba-pl08x.c | 156 +++++++++++++++++++++++++++--------------------
 1 file changed, 90 insertions(+), 66 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index e34024b000a4..aa99c13b5666 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1386,32 +1386,6 @@ static u32 pl08x_get_cctl(struct pl08x_dma_chan *plchan,
 	return pl08x_cctl(cctl);
 }
 
-static int dma_set_runtime_config(struct dma_chan *chan,
-				  struct dma_slave_config *config)
-{
-	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
-	struct pl08x_driver_data *pl08x = plchan->host;
-
-	if (!plchan->slave)
-		return -EINVAL;
-
-	/* Reject definitely invalid configurations */
-	if (config->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
-	    config->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
-		return -EINVAL;
-
-	if (config->device_fc && pl08x->vd->pl080s) {
-		dev_err(&pl08x->adev->dev,
-			"%s: PL080S does not support peripheral flow control\n",
-			__func__);
-		return -EINVAL;
-	}
-
-	plchan->cfg = *config;
-
-	return 0;
-}
-
 /*
  * Slave transactions callback to the slave device to allow
  * synchronization of slave DMA signals with the DMAC enable
@@ -1693,20 +1667,71 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_cyclic(
 	return vchan_tx_prep(&plchan->vc, &txd->vd, flags);
 }
 
-static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			 unsigned long arg)
+static int pl08x_config(struct dma_chan *chan,
+			struct dma_slave_config *config)
+{
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	struct pl08x_driver_data *pl08x = plchan->host;
+
+	if (!plchan->slave)
+		return -EINVAL;
+
+	/* Reject definitely invalid configurations */
+	if (config->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
+	    config->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
+		return -EINVAL;
+
+	if (config->device_fc && pl08x->vd->pl080s) {
+		dev_err(&pl08x->adev->dev,
+			"%s: PL080S does not support peripheral flow control\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	plchan->cfg = *config;
+
+	return 0;
+}
+
+static int pl08x_terminate_all(struct dma_chan *chan)
 {
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
 	unsigned long flags;
-	int ret = 0;
 
-	/* Controls applicable to inactive channels */
-	if (cmd == DMA_SLAVE_CONFIG) {
-		return dma_set_runtime_config(chan,
-					      (struct dma_slave_config *)arg);
+	spin_lock_irqsave(&plchan->vc.lock, flags);
+	if (!plchan->phychan && !plchan->at) {
+		spin_unlock_irqrestore(&plchan->vc.lock, flags);
+		return 0;
 	}
 
+	plchan->state = PL08X_CHAN_IDLE;
+
+	if (plchan->phychan) {
+		/*
+		 * Mark physical channel as free and free any slave
+		 * signal
+		 */
+		pl08x_phy_free(plchan);
+	}
+	/* Dequeue jobs and free LLIs */
+	if (plchan->at) {
+		pl08x_desc_free(&plchan->at->vd);
+		plchan->at = NULL;
+	}
+	/* Dequeue jobs not yet fired as well */
+	pl08x_free_txd_list(pl08x, plchan);
+
+	spin_unlock_irqrestore(&plchan->vc.lock, flags);
+
+	return 0;
+}
+
+static int pl08x_pause(struct dma_chan *chan)
+{
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	unsigned long flags;
+
 	/*
 	 * Anything succeeds on channels with no physical allocation and
 	 * no queued transfers.
@@ -1717,42 +1742,35 @@ static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		return 0;
 	}
 
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		plchan->state = PL08X_CHAN_IDLE;
+	pl08x_pause_phy_chan(plchan->phychan);
+	plchan->state = PL08X_CHAN_PAUSED;
 
-		if (plchan->phychan) {
-			/*
-			 * Mark physical channel as free and free any slave
-			 * signal
-			 */
-			pl08x_phy_free(plchan);
-		}
-		/* Dequeue jobs and free LLIs */
-		if (plchan->at) {
-			pl08x_desc_free(&plchan->at->vd);
-			plchan->at = NULL;
-		}
-		/* Dequeue jobs not yet fired as well */
-		pl08x_free_txd_list(pl08x, plchan);
-		break;
-	case DMA_PAUSE:
-		pl08x_pause_phy_chan(plchan->phychan);
-		plchan->state = PL08X_CHAN_PAUSED;
-		break;
-	case DMA_RESUME:
-		pl08x_resume_phy_chan(plchan->phychan);
-		plchan->state = PL08X_CHAN_RUNNING;
-		break;
-	default:
-		/* Unknown command */
-		ret = -ENXIO;
-		break;
+	spin_unlock_irqrestore(&plchan->vc.lock, flags);
+
+	return 0;
+}
+
+static int pl08x_resume(struct dma_chan *chan)
+{
+	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
+	unsigned long flags;
+
+	/*
+	 * Anything succeeds on channels with no physical allocation and
+	 * no queued transfers.
+	 */
+	spin_lock_irqsave(&plchan->vc.lock, flags);
+	if (!plchan->phychan && !plchan->at) {
+		spin_unlock_irqrestore(&plchan->vc.lock, flags);
+		return 0;
 	}
 
+	pl08x_resume_phy_chan(plchan->phychan);
+	plchan->state = PL08X_CHAN_RUNNING;
+
 	spin_unlock_irqrestore(&plchan->vc.lock, flags);
 
-	return ret;
+	return 0;
 }
 
 bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
@@ -2048,7 +2066,10 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	pl08x->memcpy.device_prep_dma_interrupt = pl08x_prep_dma_interrupt;
 	pl08x->memcpy.device_tx_status = pl08x_dma_tx_status;
 	pl08x->memcpy.device_issue_pending = pl08x_issue_pending;
-	pl08x->memcpy.device_control = pl08x_control;
+	pl08x->memcpy.device_config = pl08x_config;
+	pl08x->memcpy.device_pause = pl08x_pause;
+	pl08x->memcpy.device_resume = pl08x_resume;
+	pl08x->memcpy.device_terminate_all = pl08x_terminate_all;
 
 	/* Initialize slave engine */
 	dma_cap_set(DMA_SLAVE, pl08x->slave.cap_mask);
@@ -2061,7 +2082,10 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	pl08x->slave.device_issue_pending = pl08x_issue_pending;
 	pl08x->slave.device_prep_slave_sg = pl08x_prep_slave_sg;
 	pl08x->slave.device_prep_dma_cyclic = pl08x_prep_dma_cyclic;
-	pl08x->slave.device_control = pl08x_control;
+	pl08x->slave.device_config = pl08x_config;
+	pl08x->slave.device_pause = pl08x_pause;
+	pl08x->slave.device_resume = pl08x_resume;
+	pl08x->slave.device_terminate_all = pl08x_terminate_all;
 
 	/* Get the platform data */
 	pl08x->pd = dev_get_platdata(&adev->dev);
-- 
2.1.1

