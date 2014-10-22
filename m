Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaJVQC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:02:29 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54089 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754620AbaJVPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:40 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 30/59] dmaengine: fsl-dma: Split device_control
Date: Wed, 22 Oct 2014 17:43:44 +0200
Message-Id: <1413992653-21963-31-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Freescale Elo DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

While we're at it, remove the useless prep_sg callback.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/fsldma.c | 91 ++++++++++++++++++----------------------------------
 1 file changed, 32 insertions(+), 59 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 994bcb2c6b92..4b557643a737 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -941,37 +941,8 @@ fail:
 	return NULL;
 }
 
-/**
- * fsl_dma_prep_slave_sg - prepare descriptors for a DMA_SLAVE transaction
- * @chan: DMA channel
- * @sgl: scatterlist to transfer to/from
- * @sg_len: number of entries in @scatterlist
- * @direction: DMA direction
- * @flags: DMAEngine flags
- * @context: transaction context (ignored)
- *
- * Prepare a set of descriptors for a DMA_SLAVE transaction. Following the
- * DMA_SLAVE API, this gets the device-specific information from the
- * chan->private variable.
- */
-static struct dma_async_tx_descriptor *fsl_dma_prep_slave_sg(
-	struct dma_chan *dchan, struct scatterlist *sgl, unsigned int sg_len,
-	enum dma_transfer_direction direction, unsigned long flags,
-	void *context)
-{
-	/*
-	 * This operation is not supported on the Freescale DMA controller
-	 *
-	 * However, we need to provide the function pointer to allow the
-	 * device_control() method to work.
-	 */
-	return NULL;
-}
-
-static int fsl_dma_device_control(struct dma_chan *dchan,
-				  enum dma_ctrl_cmd cmd, unsigned long arg)
+static int fsl_dma_device_terminate_all(struct dma_chan *dchan)
 {
-	struct dma_slave_config *config;
 	struct fsldma_chan *chan;
 	int size;
 
@@ -980,45 +951,47 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 
 	chan = to_fsl_chan(dchan);
 
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		spin_lock_bh(&chan->desc_lock);
-
-		/* Halt the DMA engine */
-		dma_halt(chan);
+	spin_lock_bh(&chan->desc_lock);
 
-		/* Remove and free all of the descriptors in the LD queue */
-		fsldma_free_desc_list(chan, &chan->ld_pending);
-		fsldma_free_desc_list(chan, &chan->ld_running);
-		fsldma_free_desc_list(chan, &chan->ld_completed);
-		chan->idle = true;
+	/* Halt the DMA engine */
+	dma_halt(chan);
 
-		spin_unlock_bh(&chan->desc_lock);
-		return 0;
+	/* Remove and free all of the descriptors in the LD queue */
+	fsldma_free_desc_list(chan, &chan->ld_pending);
+	fsldma_free_desc_list(chan, &chan->ld_running);
+	fsldma_free_desc_list(chan, &chan->ld_completed);
+	chan->idle = true;
 
-	case DMA_SLAVE_CONFIG:
-		config = (struct dma_slave_config *)arg;
+	spin_unlock_bh(&chan->desc_lock);
+	return 0;
+}
 
-		/* make sure the channel supports setting burst size */
-		if (!chan->set_request_count)
-			return -ENXIO;
+static int fsl_dma_device_config(struct dma_chan *dchan,
+				 struct dma_slave_config *config)
+{
+	struct fsldma_chan *chan;
+	int size;
 
-		/* we set the controller burst size depending on direction */
-		if (config->direction == DMA_MEM_TO_DEV)
-			size = config->dst_addr_width * config->dst_maxburst;
-		else
-			size = config->src_addr_width * config->src_maxburst;
+	if (!dchan)
+		return -EINVAL;
 
-		chan->set_request_count(chan, size);
-		return 0;
+	chan = to_fsl_chan(dchan);
 
-	default:
+	/* make sure the channel supports setting burst size */
+	if (!chan->set_request_count)
 		return -ENXIO;
-	}
 
+	/* we set the controller burst size depending on direction */
+	if (config->direction == DMA_MEM_TO_DEV)
+		size = config->dst_addr_width * config->dst_maxburst;
+	else
+		size = config->src_addr_width * config->src_maxburst;
+
+	chan->set_request_count(chan, size);
 	return 0;
 }
 
+
 /**
  * fsl_dma_memcpy_issue_pending - Issue the DMA start command
  * @chan : Freescale DMA channel
@@ -1396,8 +1369,8 @@ static int fsldma_of_probe(struct platform_device *op)
 	fdev->common.device_prep_dma_sg = fsl_dma_prep_sg;
 	fdev->common.device_tx_status = fsl_tx_status;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
-	fdev->common.device_prep_slave_sg = fsl_dma_prep_slave_sg;
-	fdev->common.device_control = fsl_dma_device_control;
+	fdev->common.device_config = fsl_dma_device_config;
+	fdev->common.device_terminate_all = fsl_dma_device_terminate_all;
 	fdev->common.dev = &op->dev;
 
 	dma_set_mask(&(op->dev), DMA_BIT_MASK(36));
-- 
2.1.1

