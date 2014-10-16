Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaJPKeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:34:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37209 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752344AbaJPKTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:19:47 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 19/53] dmaengine: imx-sdma: Split device_control
Date: Thu, 16 Oct 2014 12:17:18 +0200
Message-Id: <1413454672-27400-20-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Freescale IMX SDMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/imx-sdma.c | 66 +++++++++++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index f7626e37d0b8..a52b173596e5 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -829,20 +829,29 @@ static int sdma_load_context(struct sdma_channel *sdmac)
 	return ret;
 }
 
-static void sdma_disable_channel(struct sdma_channel *sdmac)
+static struct sdma_channel *to_sdma_chan(struct dma_chan *chan)
+{
+	return container_of(chan, struct sdma_channel, chan);
+}
+
+static int sdma_disable_channel(struct dma_chan *chan)
 {
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct sdma_engine *sdma = sdmac->sdma;
 	int channel = sdmac->channel;
 
 	writel_relaxed(BIT(channel), sdma->regs + SDMA_H_STATSTOP);
 	sdmac->status = DMA_ERROR;
+
+	return 0;
 }
 
-static int sdma_config_channel(struct sdma_channel *sdmac)
+static int sdma_config_channel(struct dma_chan *chan)
 {
+	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	int ret;
 
-	sdma_disable_channel(sdmac);
+	sdma_disable_channel(chan);
 
 	sdmac->event_mask[0] = 0;
 	sdmac->event_mask[1] = 0;
@@ -934,11 +943,6 @@ out:
 	return ret;
 }
 
-static struct sdma_channel *to_sdma_chan(struct dma_chan *chan)
-{
-	return container_of(chan, struct sdma_channel, chan);
-}
-
 static dma_cookie_t sdma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	unsigned long flags;
@@ -1003,7 +1007,7 @@ static void sdma_free_chan_resources(struct dma_chan *chan)
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct sdma_engine *sdma = sdmac->sdma;
 
-	sdma_disable_channel(sdmac);
+	sdma_disable_channel(chan);
 
 	if (sdmac->event_id0)
 		sdma_event_disable(sdmac, sdmac->event_id0);
@@ -1202,35 +1206,24 @@ err_out:
 	return NULL;
 }
 
-static int sdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		unsigned long arg)
+static int sdma_config(struct dma_chan *chan,
+		       struct dma_slave_config *dmaengine_cfg)
 {
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
-	struct dma_slave_config *dmaengine_cfg = (void *)arg;
-
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		sdma_disable_channel(sdmac);
-		return 0;
-	case DMA_SLAVE_CONFIG:
-		if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
-			sdmac->per_address = dmaengine_cfg->src_addr;
-			sdmac->watermark_level = dmaengine_cfg->src_maxburst *
-						dmaengine_cfg->src_addr_width;
-			sdmac->word_size = dmaengine_cfg->src_addr_width;
-		} else {
-			sdmac->per_address = dmaengine_cfg->dst_addr;
-			sdmac->watermark_level = dmaengine_cfg->dst_maxburst *
-						dmaengine_cfg->dst_addr_width;
-			sdmac->word_size = dmaengine_cfg->dst_addr_width;
-		}
-		sdmac->direction = dmaengine_cfg->direction;
-		return sdma_config_channel(sdmac);
-	default:
-		return -ENOSYS;
-	}
 
-	return -EINVAL;
+	if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
+		sdmac->per_address = dmaengine_cfg->src_addr;
+		sdmac->watermark_level = dmaengine_cfg->src_maxburst *
+			dmaengine_cfg->src_addr_width;
+		sdmac->word_size = dmaengine_cfg->src_addr_width;
+	} else {
+		sdmac->per_address = dmaengine_cfg->dst_addr;
+		sdmac->watermark_level = dmaengine_cfg->dst_maxburst *
+			dmaengine_cfg->dst_addr_width;
+		sdmac->word_size = dmaengine_cfg->dst_addr_width;
+	}
+	sdmac->direction = dmaengine_cfg->direction;
+	return sdma_config_channel(chan);
 }
 
 static enum dma_status sdma_tx_status(struct dma_chan *chan,
@@ -1598,7 +1591,8 @@ static int __init sdma_probe(struct platform_device *pdev)
 	sdma->dma_device.device_tx_status = sdma_tx_status;
 	sdma->dma_device.device_prep_slave_sg = sdma_prep_slave_sg;
 	sdma->dma_device.device_prep_dma_cyclic = sdma_prep_dma_cyclic;
-	sdma->dma_device.device_control = sdma_control;
+	sdma->dma_device.device_config = sdma_config;
+	sdma->dma_device.device_terminate_all = sdma_disable_channel;
 	sdma->dma_device.device_issue_pending = sdma_issue_pending;
 	sdma->dma_device.dev->dma_parms = &sdma->dma_parms;
 	dma_set_max_seg_size(sdma->dma_device.dev, 65535);
-- 
2.1.1

