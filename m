Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaJVQHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:07:54 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53988 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754367AbaJVPpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:24 -0400
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
Subject: [PATCH v3 18/59] dmaengine: dw: Split device_control
Date: Wed, 22 Oct 2014 17:43:32 +0200
Message-Id: <1413992653-21963-19-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the DesignWare DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dw/core.c | 82 +++++++++++++++++++++++++++------------------------
 1 file changed, 44 insertions(+), 38 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 244722170410..0bcf3f37fd5d 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -954,8 +954,7 @@ static inline void convert_burst(u32 *maxburst)
 		*maxburst = 0;
 }
 
-static int
-set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
+static int dwc_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 {
 	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 
@@ -972,16 +971,25 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 	return 0;
 }
 
-static inline void dwc_chan_pause(struct dw_dma_chan *dwc)
+static int dwc_pause(struct dma_chan *chan)
 {
-	u32 cfglo = channel_readl(dwc, CFG_LO);
-	unsigned int count = 20;	/* timeout iterations */
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	unsigned long		flags;
+	unsigned int		count = 20;	/* timeout iterations */
+	u32			cfglo;
+
+	spin_lock_irqsave(&dwc->lock, flags);
 
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
 
 static inline void dwc_chan_resume(struct dw_dma_chan *dwc)
@@ -993,53 +1001,48 @@ static inline void dwc_chan_resume(struct dw_dma_chan *dwc)
 	dwc->paused = false;
 }
 
-static int dwc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		       unsigned long arg)
+static int dwc_resume(struct dma_chan *chan)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
-	struct dw_dma		*dw = to_dw_dma(chan->device);
-	struct dw_desc		*desc, *_desc;
 	unsigned long		flags;
-	LIST_HEAD(list);
 
-	if (cmd == DMA_PAUSE) {
-		spin_lock_irqsave(&dwc->lock, flags);
+	if (!dwc->paused)
+		return 0;
 
-		dwc_chan_pause(dwc);
+	spin_lock_irqsave(&dwc->lock, flags);
 
-		spin_unlock_irqrestore(&dwc->lock, flags);
-	} else if (cmd == DMA_RESUME) {
-		if (!dwc->paused)
-			return 0;
+	dwc_chan_resume(dwc);
 
-		spin_lock_irqsave(&dwc->lock, flags);
+	spin_unlock_irqrestore(&dwc->lock, flags);
 
-		dwc_chan_resume(dwc);
+	return 0;
+}
 
-		spin_unlock_irqrestore(&dwc->lock, flags);
-	} else if (cmd == DMA_TERMINATE_ALL) {
-		spin_lock_irqsave(&dwc->lock, flags);
+static int dwc_terminate_all(struct dma_chan *chan)
+{
+	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma		*dw = to_dw_dma(chan->device);
+	struct dw_desc		*desc, *_desc;
+	unsigned long		flags;
+	LIST_HEAD(list);
+
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
@@ -1655,7 +1658,10 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
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

