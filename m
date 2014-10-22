Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaJVPpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:45:52 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54089 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754827AbaJVPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:49 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 39/59] dmaengine: sh: Split device_control
Date: Wed, 22 Oct 2014 17:43:53 +0200
Message-Id: <1413992653-21963-40-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Super-H DMA driver to make use of the
newly introduced callbacks, that will eventually be used to retrieve slave
capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/dma/sh/shdma-base.c | 72 +++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 42d497416196..706cb2611e4d 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -727,57 +727,50 @@ static struct dma_async_tx_descriptor *shdma_prep_dma_cyclic(
 	return desc;
 }
 
-static int shdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			  unsigned long arg)
+static int shdma_terminate_all(struct dma_chan *chan)
 {
 	struct shdma_chan *schan = to_shdma_chan(chan);
 	struct shdma_dev *sdev = to_shdma_dev(chan->device);
 	const struct shdma_ops *ops = sdev->ops;
-	struct dma_slave_config *config;
 	unsigned long flags;
-	int ret;
 
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		spin_lock_irqsave(&schan->chan_lock, flags);
-		ops->halt_channel(schan);
+	spin_lock_irqsave(&schan->chan_lock, flags);
+	ops->halt_channel(schan);
 
-		if (ops->get_partial && !list_empty(&schan->ld_queue)) {
-			/* Record partial transfer */
-			struct shdma_desc *desc = list_first_entry(&schan->ld_queue,
-						struct shdma_desc, node);
-			desc->partial = ops->get_partial(schan, desc);
-		}
+	if (ops->get_partial && !list_empty(&schan->ld_queue)) {
+		/* Record partial transfer */
+		struct shdma_desc *desc = list_first_entry(&schan->ld_queue,
+							   struct shdma_desc, node);
+		desc->partial = ops->get_partial(schan, desc);
+	}
 
-		spin_unlock_irqrestore(&schan->chan_lock, flags);
+	spin_unlock_irqrestore(&schan->chan_lock, flags);
 
-		shdma_chan_ld_cleanup(schan, true);
-		break;
-	case DMA_SLAVE_CONFIG:
-		/*
-		 * So far only .slave_id is used, but the slave drivers are
-		 * encouraged to also set a transfer direction and an address.
-		 */
-		if (!arg)
-			return -EINVAL;
-		/*
-		 * We could lock this, but you shouldn't be configuring the
-		 * channel, while using it...
-		 */
-		config = (struct dma_slave_config *)arg;
-		ret = shdma_setup_slave(schan, config->slave_id,
-					config->direction == DMA_DEV_TO_MEM ?
-					config->src_addr : config->dst_addr);
-		if (ret < 0)
-			return ret;
-		break;
-	default:
-		return -ENXIO;
-	}
+	shdma_chan_ld_cleanup(schan, true);
 
 	return 0;
 }
 
+static int shdma_config(struct dma_chan *chan,
+			struct dma_slave_config *config)
+{
+	struct shdma_chan *schan = to_shdma_chan(chan);
+
+	/*
+	 * So far only .slave_id is used, but the slave drivers are
+	 * encouraged to also set a transfer direction and an address.
+	 */
+	if (!config)
+		return -EINVAL;
+	/*
+	 * We could lock this, but you shouldn't be configuring the
+	 * channel, while using it...
+	 */
+	return shdma_setup_slave(schan, config->slave_id,
+				 config->direction == DMA_DEV_TO_MEM ?
+				 config->src_addr : config->dst_addr);
+}
+
 static void shdma_issue_pending(struct dma_chan *chan)
 {
 	struct shdma_chan *schan = to_shdma_chan(chan);
@@ -1000,7 +993,8 @@ int shdma_init(struct device *dev, struct shdma_dev *sdev,
 	/* Compulsory for DMA_SLAVE fields */
 	dma_dev->device_prep_slave_sg = shdma_prep_slave_sg;
 	dma_dev->device_prep_dma_cyclic = shdma_prep_dma_cyclic;
-	dma_dev->device_control = shdma_control;
+	dma_dev->device_config = shdma_config;
+	dma_dev->device_terminate_all = shdma_terminate_all;
 
 	dma_dev->dev = dev;
 
-- 
2.1.1

