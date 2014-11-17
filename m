Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaKQN4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:56:14 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49096 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753322AbaKQNpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:31 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 36/61] dmaengine: bam-dma: Split device_control
Date: Mon, 17 Nov 2014 14:42:30 +0100
Message-Id: <1416231775-31252-37-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Qualcomm BAM DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/qcom_bam_dma.c | 85 +++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 42 deletions(-)

diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 3122a99ec06b..d7a33b3ac466 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -530,11 +530,18 @@ static void bam_free_chan(struct dma_chan *chan)
  * Sets slave configuration for channel
  *
  */
-static void bam_slave_config(struct bam_chan *bchan,
-		struct dma_slave_config *cfg)
+static int bam_slave_config(struct dma_chan *chan,
+			    struct dma_slave_config *cfg)
 {
+	struct bam_chan *bchan = to_bam_chan(chan);
+	unsigned long flag;
+
+	spin_lock_irqsave(&bchan->vc.lock, flag);
 	memcpy(&bchan->slave, cfg, sizeof(*cfg));
 	bchan->reconfigure = 1;
+	spin_unlock_irqrestore(&bchan->vc.lock, flag);
+
+	return 0;
 }
 
 /**
@@ -627,8 +634,9 @@ err_out:
  * No callbacks are done
  *
  */
-static void bam_dma_terminate_all(struct bam_chan *bchan)
+static int bam_dma_terminate_all(struct dma_chan *chan)
 {
+	struct bam_chan *bchan = to_bam_chan(chan);
 	unsigned long flag;
 	LIST_HEAD(head);
 
@@ -643,56 +651,46 @@ static void bam_dma_terminate_all(struct bam_chan *bchan)
 	spin_unlock_irqrestore(&bchan->vc.lock, flag);
 
 	vchan_dma_desc_free_list(&bchan->vc, &head);
+
+	return 0;
 }
 
 /**
- * bam_control - DMA device control
+ * bam_pause - Pause DMA channel
  * @chan: dma channel
- * @cmd: control cmd
- * @arg: cmd argument
  *
- * Perform DMA control command
+ */
+static int bam_pause(struct dma_chan *chan)
+{
+	struct bam_chan *bchan = to_bam_chan(chan);
+	struct bam_device *bdev = bchan->bdev;
+	unsigned long flag;
+
+	spin_lock_irqsave(&bchan->vc.lock, flag);
+	writel_relaxed(1, bam_addr(bdev, bchan->id, BAM_P_HALT));
+	bchan->paused = 1;
+	spin_unlock_irqrestore(&bchan->vc.lock, flag);
+
+	return 0;
+}
+
+/**
+ * bam_resume - Resume DMA channel operations
+ * @chan: dma channel
  *
  */
-static int bam_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-	unsigned long arg)
+static int bam_resume(struct dma_chan *chan)
 {
 	struct bam_chan *bchan = to_bam_chan(chan);
 	struct bam_device *bdev = bchan->bdev;
-	int ret = 0;
 	unsigned long flag;
 
-	switch (cmd) {
-	case DMA_PAUSE:
-		spin_lock_irqsave(&bchan->vc.lock, flag);
-		writel_relaxed(1, bam_addr(bdev, bchan->id, BAM_P_HALT));
-		bchan->paused = 1;
-		spin_unlock_irqrestore(&bchan->vc.lock, flag);
-		break;
-
-	case DMA_RESUME:
-		spin_lock_irqsave(&bchan->vc.lock, flag);
-		writel_relaxed(0, bam_addr(bdev, bchan->id, BAM_P_HALT));
-		bchan->paused = 0;
-		spin_unlock_irqrestore(&bchan->vc.lock, flag);
-		break;
-
-	case DMA_TERMINATE_ALL:
-		bam_dma_terminate_all(bchan);
-		break;
-
-	case DMA_SLAVE_CONFIG:
-		spin_lock_irqsave(&bchan->vc.lock, flag);
-		bam_slave_config(bchan, (struct dma_slave_config *)arg);
-		spin_unlock_irqrestore(&bchan->vc.lock, flag);
-		break;
-
-	default:
-		ret = -ENXIO;
-		break;
-	}
+	spin_lock_irqsave(&bchan->vc.lock, flag);
+	writel_relaxed(0, bam_addr(bdev, bchan->id, BAM_P_HALT));
+	bchan->paused = 0;
+	spin_unlock_irqrestore(&bchan->vc.lock, flag);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -1148,7 +1146,10 @@ static int bam_dma_probe(struct platform_device *pdev)
 	bdev->common.device_alloc_chan_resources = bam_alloc_chan;
 	bdev->common.device_free_chan_resources = bam_free_chan;
 	bdev->common.device_prep_slave_sg = bam_prep_slave_sg;
-	bdev->common.device_control = bam_control;
+	bdev->common.device_config = bam_slave_config;
+	bdev->common.device_pause = bam_pause;
+	bdev->common.device_resume = bam_resume;
+	bdev->common.device_terminate_all = bam_dma_terminate_all;
 	bdev->common.device_issue_pending = bam_issue_pending;
 	bdev->common.device_tx_status = bam_tx_status;
 	bdev->common.dev = bdev->dev;
@@ -1187,7 +1188,7 @@ static int bam_dma_remove(struct platform_device *pdev)
 	devm_free_irq(bdev->dev, bdev->irq, bdev);
 
 	for (i = 0; i < bdev->num_channels; i++) {
-		bam_dma_terminate_all(&bdev->channels[i]);
+		bam_dma_terminate_all(&bdev->channels[i].vc.chan);
 		tasklet_kill(&bdev->channels[i].vc.task);
 
 		dma_free_writecombine(bdev->dev, BAM_DESC_FIFO_SIZE,
-- 
2.1.1

