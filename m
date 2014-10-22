Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbaJVQFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:05:51 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53988 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754568AbaJVPp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 22/59] dmaengine: imx: Split device_control
Date: Wed, 22 Oct 2014 17:43:36 +0200
Message-Id: <1413992653-21963-23-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Freescale IMX DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/imx-dma.c | 103 +++++++++++++++++++++++++-------------------------
 1 file changed, 51 insertions(+), 52 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 9d2c9e7374dc..dfd1557384ca 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -669,69 +669,67 @@ out:
 
 }
 
-static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		unsigned long arg)
+static int imxdma_terminate_all(struct dma_chan *chan)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
-	struct dma_slave_config *dmaengine_cfg = (void *)arg;
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	unsigned long flags;
-	unsigned int mode = 0;
-
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		imxdma_disable_hw(imxdmac);
 
-		spin_lock_irqsave(&imxdma->lock, flags);
-		list_splice_tail_init(&imxdmac->ld_active, &imxdmac->ld_free);
-		list_splice_tail_init(&imxdmac->ld_queue, &imxdmac->ld_free);
-		spin_unlock_irqrestore(&imxdma->lock, flags);
-		return 0;
-	case DMA_SLAVE_CONFIG:
-		if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
-			imxdmac->per_address = dmaengine_cfg->src_addr;
-			imxdmac->watermark_level = dmaengine_cfg->src_maxburst;
-			imxdmac->word_size = dmaengine_cfg->src_addr_width;
-		} else {
-			imxdmac->per_address = dmaengine_cfg->dst_addr;
-			imxdmac->watermark_level = dmaengine_cfg->dst_maxburst;
-			imxdmac->word_size = dmaengine_cfg->dst_addr_width;
-		}
-
-		switch (imxdmac->word_size) {
-		case DMA_SLAVE_BUSWIDTH_1_BYTE:
-			mode = IMX_DMA_MEMSIZE_8;
-			break;
-		case DMA_SLAVE_BUSWIDTH_2_BYTES:
-			mode = IMX_DMA_MEMSIZE_16;
-			break;
-		default:
-		case DMA_SLAVE_BUSWIDTH_4_BYTES:
-			mode = IMX_DMA_MEMSIZE_32;
-			break;
-		}
+	imxdma_disable_hw(imxdmac);
 
-		imxdmac->hw_chaining = 0;
+	spin_lock_irqsave(&imxdma->lock, flags);
+	list_splice_tail_init(&imxdmac->ld_active, &imxdmac->ld_free);
+	list_splice_tail_init(&imxdmac->ld_queue, &imxdmac->ld_free);
+	spin_unlock_irqrestore(&imxdma->lock, flags);
+	return 0;
+}
 
-		imxdmac->ccr_from_device = (mode | IMX_DMA_TYPE_FIFO) |
-			((IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) << 2) |
-			CCR_REN;
-		imxdmac->ccr_to_device =
-			(IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) |
-			((mode | IMX_DMA_TYPE_FIFO) << 2) | CCR_REN;
-		imx_dmav1_writel(imxdma, imxdmac->dma_request,
-				 DMA_RSSR(imxdmac->channel));
+static int imxdma_config(struct dma_chan *chan,
+			 struct dma_slave_config *dmaengine_cfg)
+{
+	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
+	unsigned int mode = 0;
 
-		/* Set burst length */
-		imx_dmav1_writel(imxdma, imxdmac->watermark_level *
-				imxdmac->word_size, DMA_BLR(imxdmac->channel));
+	if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
+		imxdmac->per_address = dmaengine_cfg->src_addr;
+		imxdmac->watermark_level = dmaengine_cfg->src_maxburst;
+		imxdmac->word_size = dmaengine_cfg->src_addr_width;
+	} else {
+		imxdmac->per_address = dmaengine_cfg->dst_addr;
+		imxdmac->watermark_level = dmaengine_cfg->dst_maxburst;
+		imxdmac->word_size = dmaengine_cfg->dst_addr_width;
+	}
 
-		return 0;
+	switch (imxdmac->word_size) {
+	case DMA_SLAVE_BUSWIDTH_1_BYTE:
+		mode = IMX_DMA_MEMSIZE_8;
+		break;
+	case DMA_SLAVE_BUSWIDTH_2_BYTES:
+		mode = IMX_DMA_MEMSIZE_16;
+		break;
 	default:
-		return -ENOSYS;
+	case DMA_SLAVE_BUSWIDTH_4_BYTES:
+		mode = IMX_DMA_MEMSIZE_32;
+		break;
 	}
 
-	return -EINVAL;
+	imxdmac->hw_chaining = 0;
+
+	imxdmac->ccr_from_device = (mode | IMX_DMA_TYPE_FIFO) |
+		((IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) << 2) |
+		CCR_REN;
+	imxdmac->ccr_to_device =
+		(IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) |
+		((mode | IMX_DMA_TYPE_FIFO) << 2) | CCR_REN;
+	imx_dmav1_writel(imxdma, imxdmac->dma_request,
+			 DMA_RSSR(imxdmac->channel));
+
+	/* Set burst length */
+	imx_dmav1_writel(imxdma, imxdmac->watermark_level *
+			 imxdmac->word_size, DMA_BLR(imxdmac->channel));
+
+	return 0;
 }
 
 static enum dma_status imxdma_tx_status(struct dma_chan *chan,
@@ -1184,7 +1182,8 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	imxdma->dma_device.device_prep_dma_cyclic = imxdma_prep_dma_cyclic;
 	imxdma->dma_device.device_prep_dma_memcpy = imxdma_prep_dma_memcpy;
 	imxdma->dma_device.device_prep_interleaved_dma = imxdma_prep_dma_interleaved;
-	imxdma->dma_device.device_control = imxdma_control;
+	imxdma->dma_device.device_config = imxdma_config;
+	imxdma->dma_device.device_terminate_all = imxdma_terminate_all;
 	imxdma->dma_device.device_issue_pending = imxdma_issue_pending;
 
 	platform_set_drvdata(pdev, imxdma);
-- 
2.1.1

