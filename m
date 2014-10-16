Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaJPKTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:19:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37188 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752299AbaJPKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:19:37 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 14/53] dmaengine: dw: Split device_control
Date: Thu, 16 Oct 2014 12:17:13 +0200
Message-Id: <1413454672-27400-15-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the DesignWare DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dw/core.c | 92 +++++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 1af731b83b3f..a3d3a51387c6 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -955,8 +955,7 @@ static inline void convert_burst(u32 *maxburst)
 		*maxburst = 0;
 }
 
-static int
-set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
+static int dwc_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 
@@ -977,29 +976,54 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 	return 0;
 }
 
-static inline void dwc_chan_pause(struct dw_dma_chan *dwc)
+static inline void dwc_chan_resume(struct dw_dma_chan *dwc)
 {
 	u32 cfglo = channel_readl(dwc, CFG_LO);
-	unsigned int count = 20;	/* timeout iterations */
 
+	channel_writel(dwc, CFG_LO, cfglo & ~DWC_CFGL_CH_SUSP);
+
+	dwc->paused = false;
+}
+
+static int dwc_pause(struct dma_chan *chan)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	unsigned long		flags;
+	unsigned int		count = 20;	/* timeout iterations */
+	u32			cfglo;
+
+	spin_lock_irqsave(&dwc->lock, flags);
+
+	cfglo = channel_readl(dwc, CFG_LO);
 	channel_writel(dwc, CFG_LO, cfglo | DWC_CFGL_CH_SUSP);
 	while (!(channel_readl(dwc, CFG_LO) & DWC_CFGL_FIFO_EMPTY) && count--)
 		udelay(2);
 
 	dwc->paused = true;
+
+	spin_unlock_irqrestore(&dwc->lock, flags);
+
+	return 0;
 }
 
-static inline void dwc_chan_resume(struct dw_dma_chan *dwc)
+static int dwc_resume(struct dma_chan *chan)
 {
-	u32 cfglo = channel_readl(dwc, CFG_LO);
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	unsigned long		flags;
 
-	channel_writel(dwc, CFG_LO, cfglo & ~DWC_CFGL_CH_SUSP);
+	if (!dwc->paused)
+		return 0;
 
-	dwc->paused = false;
+	spin_lock_irqsave(&dwc->lock, flags);
+
+	dwc_chan_resume(dwc);
+
+	spin_unlock_irqrestore(&dwc->lock, flags);
+
+	return 0;
 }
 
-static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		       unsigned long arg)
+static int dwc_terminate_all(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
 	struct dw_dma		*dw = to_dw_dma(chan->device);
@@ -1007,44 +1031,23 @@ static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	unsigned long		flags;
 	LIST_HEAD(list);
 
-	if (cmd == DMA_PAUSE) {
-		spin_lock_irqsave(&dwc->lock, flags);
-
-		dwc_chan_pause(dwc);
-
-		spin_unlock_irqrestore(&dwc->lock, flags);
-	} else if (cmd == DMA_RESUME) {
-		if (!dwc->paused)
-			return 0;
-
-		spin_lock_irqsave(&dwc->lock, flags);
-
-		dwc_chan_resume(dwc);
-
-		spin_unlock_irqrestore(&dwc->lock, flags);
-	} else if (cmd == DMA_TERMINATE_ALL) {
-		spin_lock_irqsave(&dwc->lock, flags);
+	spin_lock_irqsave(&dwc->lock, flags);
 
-		clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
+	clear_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags);
 
-		dwc_chan_disable(dw, dwc);
+	dwc_chan_disable(dw, dwc);
 
-		dwc_chan_resume(dwc);
+	dwc_chan_resume(dwc);
 
-		/* active_list entries will end up before queued entries */
-		list_splice_init(&dwc->queue, &list);
-		list_splice_init(&dwc->active_list, &list);
+	/* active_list entries will end up before queued entries */
+	list_splice_init(&dwc->queue, &list);
+	list_splice_init(&dwc->active_list, &list);
 
-		spin_unlock_irqrestore(&dwc->lock, flags);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
-		/* Flush all pending and queued descriptors */
-		list_for_each_entry_safe(desc, _desc, &list, desc_node)
-			dwc_descriptor_complete(dwc, desc, false);
-	} else if (cmd == DMA_SLAVE_CONFIG) {
-		return set_runtime_config(chan, (struct dma_slave_config *)arg);
-	} else {
-		return -ENXIO;
-	}
+	/* Flush all pending and queued descriptors */
+	list_for_each_entry_safe(desc, _desc, &list, desc_node)
+		dwc_descriptor_complete(dwc, desc, false);
 
 	return 0;
 }
@@ -1654,7 +1657,10 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 	dw->dma.device_prep_dma_memcpy = dwc_prep_dma_memcpy;
 
 	dw->dma.device_prep_slave_sg = dwc_prep_slave_sg;
-	dw->dma.device_control = dwc_control;
+	dw->dma.device_config = dwc_config;
+	dw->dma.device_pause = dwc_pause;
+	dw->dma.device_resume = dwc_resume;
+	dw->dma.device_terminate_all = dwc_terminate_all;
 
 	dw->dma.device_tx_status = dwc_tx_status;
 	dw->dma.device_issue_pending = dwc_issue_pending;
-- 
2.1.1

