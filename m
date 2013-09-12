Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3ILEjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 00:39:19 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37063 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3ILEjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 00:39:17 -0400
From: Olof Johansson <olof@lixom.net>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] dma: use %pa to print dma_addr_t
Date: Wed, 11 Sep 2013 21:38:30 -0700
Message-Id: <1378960710-15648-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resolves some warnings seen when building with CONFIG_ARM_LPAE=y, since
dma_addr_t might then be 64-bit:

  drivers/dma/imx-sdma.c:1092:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-sdma.c:1166:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-dma.c:579:3: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-dma.c:593:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-dma.c:603:4: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-dma.c:930:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/imx-dma.c:960:2: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat=]
  drivers/dma/ipu/ipu_idmac.c:1235:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/dma/imx-dma.c       |   20 ++++++++++----------
 drivers/dma/imx-sdma.c      |    8 ++++----
 drivers/dma/ipu/ipu_idmac.c |    6 ++++--
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 78f8ca5..fcc8a12 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -576,9 +576,9 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 
 		imx_dmav1_writel(imxdma, d->len, DMA_CNTR(imxdmac->channel));
 
-		dev_dbg(imxdma->dev, "%s channel: %d dest=0x%08x src=0x%08x "
+		dev_dbg(imxdma->dev, "%s channel: %d dest=%pa src=%pa "
 			"dma_length=%d\n", __func__, imxdmac->channel,
-			d->dest, d->src, d->len);
+			&d->dest, &d->src, d->len);
 
 		break;
 	/* Cyclic transfer is the same as slave_sg with special sg configuration. */
@@ -591,9 +591,9 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 					 DMA_CCR(imxdmac->channel));
 
 			dev_dbg(imxdma->dev, "%s channel: %d sg=%p sgcount=%d "
-				"total length=%d dev_addr=0x%08x (dev2mem)\n",
+				"total length=%d dev_addr=%pa (dev2mem)\n",
 				__func__, imxdmac->channel, d->sg, d->sgcount,
-				d->len, imxdmac->per_address);
+				d->len, &imxdmac->per_address);
 		} else if (d->direction == DMA_MEM_TO_DEV) {
 			imx_dmav1_writel(imxdma, imxdmac->per_address,
 					 DMA_DAR(imxdmac->channel));
@@ -601,9 +601,9 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 					 DMA_CCR(imxdmac->channel));
 
 			dev_dbg(imxdma->dev, "%s channel: %d sg=%p sgcount=%d "
-				"total length=%d dev_addr=0x%08x (mem2dev)\n",
+				"total length=%d dev_addr=%pa (mem2dev)\n",
 				__func__, imxdmac->channel, d->sg, d->sgcount,
-				d->len, imxdmac->per_address);
+				d->len, &imxdmac->per_address);
 		} else {
 			dev_err(imxdma->dev, "%s channel: %d bad dma mode\n",
 				__func__, imxdmac->channel);
@@ -927,8 +927,8 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct imxdma_desc *desc;
 
-	dev_dbg(imxdma->dev, "%s channel: %d src=0x%x dst=0x%x len=%d\n",
-			__func__, imxdmac->channel, src, dest, len);
+	dev_dbg(imxdma->dev, "%s channel: %d src=%pa dst=%pa len=%d\n",
+			__func__, imxdmac->channel, &src, &dest, len);
 
 	if (list_empty(&imxdmac->ld_free) ||
 	    imxdma_chan_is_doing_cyclic(imxdmac))
@@ -957,9 +957,9 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_interleaved(
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct imxdma_desc *desc;
 
-	dev_dbg(imxdma->dev, "%s channel: %d src_start=0x%x dst_start=0x%x\n"
+	dev_dbg(imxdma->dev, "%s channel: %d src_start=%pa dst_start=%pa\n"
 		"   src_sgl=%s dst_sgl=%s numf=%d frame_size=%d\n", __func__,
-		imxdmac->channel, xt->src_start, xt->dst_start,
+		imxdmac->channel, &xt->src_start, &xt->dst_start,
 		xt->src_sgl ? "true" : "false", xt->dst_sgl ? "true" : "false",
 		xt->numf, xt->frame_size);
 
diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index fc43603..b6946c5 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1089,8 +1089,8 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 			param &= ~BD_CONT;
 		}
 
-		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
-				i, count, sg->dma_address,
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: %pa %s%s\n",
+				i, count, &sg->dma_address,
 				param & BD_WRAP ? "wrap" : "",
 				param & BD_INTR ? " intr" : "");
 
@@ -1163,8 +1163,8 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 		if (i + 1 == num_periods)
 			param |= BD_WRAP;
 
-		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
-				i, period_len, dma_addr,
+		dev_dbg(sdma->dev, "entry %d: count: %d dma: %pa %s%s\n",
+				i, period_len, &dma_addr,
 				param & BD_WRAP ? "wrap" : "",
 				param & BD_INTR ? " intr" : "");
 
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index cb9c0bc..7d893c0 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1232,8 +1232,10 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
 	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
 	descnew = desc;
 
-	dev_dbg(dev, "IDMAC irq %d, dma 0x%08x, next dma 0x%08x, current %d, curbuf 0x%08x\n",
-		irq, sg_dma_address(*sg), sgnext ? sg_dma_address(sgnext) : 0, ichan->active_buffer, curbuf);
+	dev_dbg(dev, "IDMAC irq %d, dma %pa, next dma %pa, current %d, curbuf 0x%08x\n",
+		irq, &sg_dma_address(*sg),
+		sgnext ? &sg_dma_address(sgnext) : NULL, ichan->active_buffer,
+		curbuf);
 
 	/* Find the descriptor of sgnext */
 	sgnew = idmac_sg_next(ichan, &descnew, *sg);
-- 
1.7.10.4

