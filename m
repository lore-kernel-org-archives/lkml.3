Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaJVQIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:08:38 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53988 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754440AbaJVPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:20 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 13/59] dmaengine: hdmac: Split device_control
Date: Wed, 22 Oct 2014 17:43:27 +0200
Message-Id: <1413992653-21963-14-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Atmel HDMAC driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/at_hdmac.c | 121 +++++++++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 48 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index ca9dd2613283..86450b3442f2 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -972,11 +972,13 @@ err_out:
 	return NULL;
 }
 
-static int set_runtime_config(struct dma_chan *chan,
-			      struct dma_slave_config *sconfig)
+static int atc_config(struct dma_chan *chan,
+		      struct dma_slave_config *sconfig)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 
+	dev_vdbg(chan2dev(chan), "%s\n", __func__);
+
 	/* Check if it is chan is configured for slave transfers */
 	if (!chan->private)
 		return -EINVAL;
@@ -989,9 +991,28 @@ static int set_runtime_config(struct dma_chan *chan,
 	return 0;
 }
 
+static int atc_pause(struct dma_chan *chan)
+{
+	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma		*atdma = to_at_dma(chan->device);
+	int			chan_id = atchan->chan_common.chan_id;
+	unsigned long		flags;
 
-static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		       unsigned long arg)
+	LIST_HEAD(list);
+
+	dev_vdbg(chan2dev(chan), "%s\n", __func__);
+
+	spin_lock_irqsave(&atchan->lock, flags);
+
+	dma_writel(atdma, CHER, AT_DMA_SUSP(chan_id));
+	set_bit(ATC_IS_PAUSED, &atchan->status);
+
+	spin_unlock_irqrestore(&atchan->lock, flags);
+
+	return 0;
+}
+
+static int atc_resume(struct dma_chan *chan)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
 	struct at_dma		*atdma = to_at_dma(chan->device);
@@ -1000,60 +1021,61 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 
 	LIST_HEAD(list);
 
-	dev_vdbg(chan2dev(chan), "atc_control (%d)\n", cmd);
+	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
-	if (cmd == DMA_PAUSE) {
-		spin_lock_irqsave(&atchan->lock, flags);
+	if (!atc_chan_is_paused(atchan))
+		return 0;
 
-		dma_writel(atdma, CHER, AT_DMA_SUSP(chan_id));
-		set_bit(ATC_IS_PAUSED, &atchan->status);
+	spin_lock_irqsave(&atchan->lock, flags);
 
-		spin_unlock_irqrestore(&atchan->lock, flags);
-	} else if (cmd == DMA_RESUME) {
-		if (!atc_chan_is_paused(atchan))
-			return 0;
+	dma_writel(atdma, CHDR, AT_DMA_RES(chan_id));
+	clear_bit(ATC_IS_PAUSED, &atchan->status);
 
-		spin_lock_irqsave(&atchan->lock, flags);
+	spin_unlock_irqrestore(&atchan->lock, flags);
 
-		dma_writel(atdma, CHDR, AT_DMA_RES(chan_id));
-		clear_bit(ATC_IS_PAUSED, &atchan->status);
+	return 0;
+}
 
-		spin_unlock_irqrestore(&atchan->lock, flags);
-	} else if (cmd == DMA_TERMINATE_ALL) {
-		struct at_desc	*desc, *_desc;
-		/*
-		 * This is only called when something went wrong elsewhere, so
-		 * we don't really care about the data. Just disable the
-		 * channel. We still have to poll the channel enable bit due
-		 * to AHB/HSB limitations.
-		 */
-		spin_lock_irqsave(&atchan->lock, flags);
+static int atc_terminate_all(struct dma_chan *chan)
+{
+	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma		*atdma = to_at_dma(chan->device);
+	int			chan_id = atchan->chan_common.chan_id;
+	struct at_desc		*desc, *_desc;
+	unsigned long		flags;
 
-		/* disabling channel: must also remove suspend state */
-		dma_writel(atdma, CHDR, AT_DMA_RES(chan_id) | atchan->mask);
+	LIST_HEAD(list);
 
-		/* confirm that this channel is disabled */
-		while (dma_readl(atdma, CHSR) & atchan->mask)
-			cpu_relax();
+	dev_vdbg(chan2dev(chan), "%s\n", __func__);
 
-		/* active_list entries will end up before queued entries */
-		list_splice_init(&atchan->queue, &list);
-		list_splice_init(&atchan->active_list, &list);
+	/*
+	 * This is only called when something went wrong elsewhere, so
+	 * we don't really care about the data. Just disable the
+	 * channel. We still have to poll the channel enable bit due
+	 * to AHB/HSB limitations.
+	 */
+	spin_lock_irqsave(&atchan->lock, flags);
 
-		/* Flush all pending and queued descriptors */
-		list_for_each_entry_safe(desc, _desc, &list, desc_node)
-			atc_chain_complete(atchan, desc);
+	/* disabling channel: must also remove suspend state */
+	dma_writel(atdma, CHDR, AT_DMA_RES(chan_id) | atchan->mask);
 
-		clear_bit(ATC_IS_PAUSED, &atchan->status);
-		/* if channel dedicated to cyclic operations, free it */
-		clear_bit(ATC_IS_CYCLIC, &atchan->status);
+	/* confirm that this channel is disabled */
+	while (dma_readl(atdma, CHSR) & atchan->mask)
+		cpu_relax();
 
-		spin_unlock_irqrestore(&atchan->lock, flags);
-	} else if (cmd == DMA_SLAVE_CONFIG) {
-		return set_runtime_config(chan, (struct dma_slave_config *)arg);
-	} else {
-		return -ENXIO;
-	}
+	/* active_list entries will end up before queued entries */
+	list_splice_init(&atchan->queue, &list);
+	list_splice_init(&atchan->active_list, &list);
+
+	/* Flush all pending and queued descriptors */
+	list_for_each_entry_safe(desc, _desc, &list, desc_node)
+		atc_chain_complete(atchan, desc);
+
+	clear_bit(ATC_IS_PAUSED, &atchan->status);
+	/* if channel dedicated to cyclic operations, free it */
+	clear_bit(ATC_IS_CYCLIC, &atchan->status);
+
+	spin_unlock_irqrestore(&atchan->lock, flags);
 
 	return 0;
 }
@@ -1505,7 +1527,10 @@ static int __init at_dma_probe(struct platform_device *pdev)
 		/* controller can do slave DMA: can trigger cyclic transfers */
 		dma_cap_set(DMA_CYCLIC, atdma->dma_common.cap_mask);
 		atdma->dma_common.device_prep_dma_cyclic = atc_prep_dma_cyclic;
-		atdma->dma_common.device_control = atc_control;
+		atdma->dma_common.device_config = atc_config;
+		atdma->dma_common.device_pause = atc_pause;
+		atdma->dma_common.device_resume = atc_resume;
+		atdma->dma_common.device_terminate_all = atc_terminate_all;
 	}
 
 	dma_writel(atdma, EN, AT_DMA_ENABLE);
@@ -1622,7 +1647,7 @@ static void atc_suspend_cyclic(struct at_dma_chan *atchan)
 	if (!atc_chan_is_paused(atchan)) {
 		dev_warn(chan2dev(chan),
 		"cyclic channel not paused, should be done by channel user\n");
-		atc_control(chan, DMA_PAUSE, 0);
+		atc_pause(chan);
 	}
 
 	/* now preserve additional data for cyclic operations */
-- 
2.1.1

