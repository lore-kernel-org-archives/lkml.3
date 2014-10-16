Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaJPKbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:31:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37262 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440AbaJPKUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:20:07 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 26/53] dmaengine: fsl-dma: Split device_control
Date: Thu, 16 Oct 2014 12:17:25 +0200
Message-Id: <1413454672-27400-27-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Freescale Elo DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

While we're at it, remove the useless prep_sg callback.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/fsldma.c | 100 ++++++++++++++++++++++++---------------------------
 1 file changed, 46 insertions(+), 54 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index d5d6885ab341..4da5b4dcb45c 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -927,35 +927,7 @@ fail:
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
 	struct dma_slave_config *config;
 	struct fsldma_chan *chan;
@@ -966,38 +938,57 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 
 	chan = to_fsl_chan(dchan);
 
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		spin_lock_bh(&chan->desc_lock);
+	spin_lock_bh(&chan->desc_lock);
+
+	/* Halt the DMA engine */
+	dma_halt(chan);
 
-		/* Halt the DMA engine */
-		dma_halt(chan);
+	/* Remove and free all of the descriptors in the LD queue */
+	fsldma_free_desc_list(chan, &chan->ld_pending);
+	fsldma_free_desc_list(chan, &chan->ld_running);
+	fsldma_free_desc_list(chan, &chan->ld_completed);
+	chan->idle = true;
 
-		/* Remove and free all of the descriptors in the LD queue */
-		fsldma_free_desc_list(chan, &chan->ld_pending);
-		fsldma_free_desc_list(chan, &chan->ld_running);
-		fsldma_free_desc_list(chan, &chan->ld_completed);
-		chan->idle = true;
+	spin_unlock_bh(&chan->desc_lock);
+	return 0;
+}
 
-		spin_unlock_bh(&chan->desc_lock);
-		return 0;
+static int fsl_dma_device_config(struct dma_chan *dchan,
+				 struct dma_slave_config *config)
+{
+	struct fsldma_chan *chan;
+	int size;
 
-	case DMA_SLAVE_CONFIG:
-		config = (struct dma_slave_config *)arg;
+	if (!dchan)
+		return -EINVAL;
 
-		/* make sure the channel supports setting burst size */
-		if (!chan->set_request_count)
-			return -ENXIO;
+	chan = to_fsl_chan(dchan);
 
-		/* we set the controller burst size depending on direction */
-		if (config->direction == DMA_MEM_TO_DEV)
-			size = config->dst_addr_width * config->dst_maxburst;
-		else
-			size = config->src_addr_width * config->src_maxburst;
+	/* make sure the channel supports setting burst size */
+	if (!chan->set_request_count)
+		return -ENXIO;
 
-		chan->set_request_count(chan, size);
-		return 0;
+	/* we set the controller burst size depending on direction */
+	if (config->direction == DMA_MEM_TO_DEV)
+		size = config->dst_addr_width * config->dst_maxburst;
+	else
+		size = config->src_addr_width * config->src_maxburst;
 
+	chan->set_request_count(chan, size);
+	return 0;
+}
+
+static int fsl_dma_device_control(struct dma_chan *dchan,
+				  enum dma_ctrl_cmd cmd, unsigned long arg)
+{
+	struct fsldma_chan *chan;
+
+	if (!dchan)
+		return -EINVAL;
+
+	chan = to_fsl_chan(dchan);
+
+	switch (cmd) {
 	case FSLDMA_EXTERNAL_START:
 
 		/* make sure the channel supports external start */
@@ -1391,8 +1382,9 @@ static int fsldma_of_probe(struct platform_device *op)
 	fdev->common.device_prep_dma_sg = fsl_dma_prep_sg;
 	fdev->common.device_tx_status = fsl_tx_status;
 	fdev->common.device_issue_pending = fsl_dma_memcpy_issue_pending;
-	fdev->common.device_prep_slave_sg = fsl_dma_prep_slave_sg;
+	fdev->common.device_config = fsl_dma_device_config;
 	fdev->common.device_control = fsl_dma_device_control;
+	fdev->common.device_terminate_all = fsl_dma_device_terminate_all;
 	fdev->common.dev = &op->dev;
 
 	dma_set_mask(&(op->dev), DMA_BIT_MASK(36));
-- 
2.1.1

