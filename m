Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaBOMAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:00:39 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40577 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaBOMAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:00:37 -0500
From: Srikanth Thokala <sthokal@xilinx.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: levex@linux.com, lars@metafoo.de, andriy.shevchenko@linux.intel.com,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: [PATCH v3 1/3] dma: Support multiple interleaved frames with non-contiguous memory
Date: Sat, 15 Feb 2014 17:30:17 +0530
Message-Id: <1392465619-27614-2-git-send-email-sthokal@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392465619-27614-1-git-send-email-sthokal@xilinx.com>
References: <1392465619-27614-1-git-send-email-sthokal@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of interleaved DMA API support multiple
frames only when the memory is contiguous by incrementing src_start/
dst_start members of interleaved template.

But, when the memory is non-contiguous it will restrict slave device
to not submit multiple frames in a batch.  This patch handles this
issue by allowing the slave device to send array of interleaved dma
templates each having a different memory location.

Signed-off-by: Srikanth Thokala <sthokal@xilinx.com>
---
 Documentation/dmaengine.txt              |    2 +-
 drivers/dma/imx-dma.c                    |    3 ++-
 drivers/dma/sirf-dma.c                   |    3 ++-
 drivers/media/platform/m2m-deinterlace.c |    2 +-
 include/linux/dmaengine.h                |    6 +++---
 5 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
index 879b6e3..c642614 100644
--- a/Documentation/dmaengine.txt
+++ b/Documentation/dmaengine.txt
@@ -94,7 +94,7 @@ The slave DMA usage consists of following steps:
 		size_t period_len, enum dma_data_direction direction);
 
 	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
-		struct dma_chan *chan, struct dma_interleaved_template *xt,
+		struct dma_chan *chan, struct dma_interleaved_template **xts,
 		unsigned long flags);
 
    The peripheral driver is expected to have mapped the scatterlist for
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 6f9ac20..e2c52ce 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -954,12 +954,13 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
 }
 
 static struct dma_async_tx_descriptor *imxdma_prep_dma_interleaved(
-	struct dma_chan *chan, struct dma_interleaved_template *xt,
+	struct dma_chan *chan, struct dma_interleaved_template **xts,
 	unsigned long flags)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct imxdma_desc *desc;
+	struct dma_interleaved_template *xt = *xts;
 
 	dev_dbg(imxdma->dev, "%s channel: %d src_start=0x%llx dst_start=0x%llx\n"
 		"   src_sgl=%s dst_sgl=%s numf=%zu frame_size=%zu\n", __func__,
diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index d4d3a31..b6a150b 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -509,12 +509,13 @@ sirfsoc_dma_tx_status(struct dma_chan *chan, dma_cookie_t cookie,
 }
 
 static struct dma_async_tx_descriptor *sirfsoc_dma_prep_interleaved(
-	struct dma_chan *chan, struct dma_interleaved_template *xt,
+	struct dma_chan *chan, struct dma_interleaved_template **xts,
 	unsigned long flags)
 {
 	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(chan);
 	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
 	struct sirfsoc_dma_desc *sdesc = NULL;
+	struct dma_interleaved_template *xt = *xts;
 	unsigned long iflags;
 	int ret;
 
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 6bb86b5..468110a 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -343,7 +343,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	ctx->xt->dst_sgl = true;
 	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
-	tx = dmadev->device_prep_interleaved_dma(chan, ctx->xt, flags);
+	tx = dmadev->device_prep_interleaved_dma(chan, &ctx->xt, flags);
 	if (tx == NULL) {
 		v4l2_warn(&pcdev->v4l2_dev, "DMA interleaved prep error\n");
 		return;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c5c92d5..2f77a9a 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -675,7 +675,7 @@ struct dma_device {
 		size_t period_len, enum dma_transfer_direction direction,
 		unsigned long flags, void *context);
 	struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
-		struct dma_chan *chan, struct dma_interleaved_template *xt,
+		struct dma_chan *chan, struct dma_interleaved_template **xts,
 		unsigned long flags);
 	int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		unsigned long arg);
@@ -752,10 +752,10 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_dma_cyclic(
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_interleaved_dma(
-		struct dma_chan *chan, struct dma_interleaved_template *xt,
+		struct dma_chan *chan, struct dma_interleaved_template **xts,
 		unsigned long flags)
 {
-	return chan->device->device_prep_interleaved_dma(chan, xt, flags);
+	return chan->device->device_prep_interleaved_dma(chan, xts, flags);
 }
 
 static inline int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps)
-- 
1.7.9.5

