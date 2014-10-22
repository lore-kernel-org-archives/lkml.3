Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbaJVQEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:04:07 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54089 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754659AbaJVPph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:37 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 27/59] dmaengine: mmp-pdma: Split device_control
Date: Wed, 22 Oct 2014 17:43:41 +0200
Message-Id: <1413992653-21963-28-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Marvell MMP PDMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/mmp_pdma.c | 109 +++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 53 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index a1a4db5721b8..75787b5009b5 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -683,68 +683,70 @@ fail:
 	return NULL;
 }
 
-static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
-			    unsigned long arg)
+static int mmp_pdma_config(struct dma_chan *dchan,
+			   struct dma_slave_config *cfg)
 {
 	struct mmp_pdma_chan *chan = to_mmp_pdma_chan(dchan);
-	struct dma_slave_config *cfg = (void *)arg;
-	unsigned long flags;
 	u32 maxburst = 0, addr = 0;
 	enum dma_slave_buswidth width = DMA_SLAVE_BUSWIDTH_UNDEFINED;
 
 	if (!dchan)
 		return -EINVAL;
 
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		disable_chan(chan->phy);
-		mmp_pdma_free_phy(chan);
-		spin_lock_irqsave(&chan->desc_lock, flags);
-		mmp_pdma_free_desc_list(chan, &chan->chain_pending);
-		mmp_pdma_free_desc_list(chan, &chan->chain_running);
-		spin_unlock_irqrestore(&chan->desc_lock, flags);
-		chan->idle = true;
-		break;
-	case DMA_SLAVE_CONFIG:
-		if (cfg->direction == DMA_DEV_TO_MEM) {
-			chan->dcmd = DCMD_INCTRGADDR | DCMD_FLOWSRC;
-			maxburst = cfg->src_maxburst;
-			width = cfg->src_addr_width;
-			addr = cfg->src_addr;
-		} else if (cfg->direction == DMA_MEM_TO_DEV) {
-			chan->dcmd = DCMD_INCSRCADDR | DCMD_FLOWTRG;
-			maxburst = cfg->dst_maxburst;
-			width = cfg->dst_addr_width;
-			addr = cfg->dst_addr;
-		}
-
-		if (width == DMA_SLAVE_BUSWIDTH_1_BYTE)
-			chan->dcmd |= DCMD_WIDTH1;
-		else if (width == DMA_SLAVE_BUSWIDTH_2_BYTES)
-			chan->dcmd |= DCMD_WIDTH2;
-		else if (width == DMA_SLAVE_BUSWIDTH_4_BYTES)
-			chan->dcmd |= DCMD_WIDTH4;
-
-		if (maxburst == 8)
-			chan->dcmd |= DCMD_BURST8;
-		else if (maxburst == 16)
-			chan->dcmd |= DCMD_BURST16;
-		else if (maxburst == 32)
-			chan->dcmd |= DCMD_BURST32;
-
-		chan->dir = cfg->direction;
-		chan->dev_addr = addr;
-		/* FIXME: drivers should be ported over to use the filter
-		 * function. Once that's done, the following two lines can
-		 * be removed.
-		 */
-		if (cfg->slave_id)
-			chan->drcmr = cfg->slave_id;
-		break;
-	default:
-		return -ENOSYS;
+	if (cfg->direction == DMA_DEV_TO_MEM) {
+		chan->dcmd = DCMD_INCTRGADDR | DCMD_FLOWSRC;
+		maxburst = cfg->src_maxburst;
+		width = cfg->src_addr_width;
+		addr = cfg->src_addr;
+	} else if (cfg->direction == DMA_MEM_TO_DEV) {
+		chan->dcmd = DCMD_INCSRCADDR | DCMD_FLOWTRG;
+		maxburst = cfg->dst_maxburst;
+		width = cfg->dst_addr_width;
+		addr = cfg->dst_addr;
 	}
 
+	if (width == DMA_SLAVE_BUSWIDTH_1_BYTE)
+		chan->dcmd |= DCMD_WIDTH1;
+	else if (width == DMA_SLAVE_BUSWIDTH_2_BYTES)
+		chan->dcmd |= DCMD_WIDTH2;
+	else if (width == DMA_SLAVE_BUSWIDTH_4_BYTES)
+		chan->dcmd |= DCMD_WIDTH4;
+
+	if (maxburst == 8)
+		chan->dcmd |= DCMD_BURST8;
+	else if (maxburst == 16)
+		chan->dcmd |= DCMD_BURST16;
+	else if (maxburst == 32)
+		chan->dcmd |= DCMD_BURST32;
+
+	chan->dir = cfg->direction;
+	chan->dev_addr = addr;
+	/* FIXME: drivers should be ported over to use the filter
+	 * function. Once that's done, the following two lines can
+	 * be removed.
+	 */
+	if (cfg->slave_id)
+		chan->drcmr = cfg->slave_id;
+
+	return 0;
+}
+
+static int mmp_pdma_terminate_all(struct dma_chan *dchan)
+{
+	struct mmp_pdma_chan *chan = to_mmp_pdma_chan(dchan);
+	unsigned long flags;
+
+	if (!dchan)
+		return -EINVAL;
+
+	disable_chan(chan->phy);
+	mmp_pdma_free_phy(chan);
+	spin_lock_irqsave(&chan->desc_lock, flags);
+	mmp_pdma_free_desc_list(chan, &chan->chain_pending);
+	mmp_pdma_free_desc_list(chan, &chan->chain_running);
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
+	chan->idle = true;
+
 	return 0;
 }
 
@@ -1061,7 +1063,8 @@ static int mmp_pdma_probe(struct platform_device *op)
 	pdev->device.device_prep_slave_sg = mmp_pdma_prep_slave_sg;
 	pdev->device.device_prep_dma_cyclic = mmp_pdma_prep_dma_cyclic;
 	pdev->device.device_issue_pending = mmp_pdma_issue_pending;
-	pdev->device.device_control = mmp_pdma_control;
+	pdev->device.device_config = mmp_pdma_config;
+	pdev->device.device_terminate_all = mmp_pdma_terminate_all;
 	pdev->device.copy_align = PDMA_ALIGNMENT;
 
 	if (pdev->dev->coherent_dma_mask)
-- 
2.1.1

