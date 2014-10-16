Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaJPK17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:27:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37349 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752576AbaJPKUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:20:19 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 32/53] dmaengine: bam-dma: Split device_control
Date: Thu, 16 Oct 2014 12:17:31 +0200
Message-Id: <1413454672-27400-33-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Qualcomm BAM DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/qcom_bam_dma.c | 83 +++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 7a4bbb0f80a5..7d80021e39bc 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -448,11 +448,18 @@ static void bam_free_chan(struct dma_chan *chan)
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
@@ -545,8 +552,9 @@ err_out:
  * No callbacks are done
  *
  */
-static void bam_dma_terminate_all(struct bam_chan *bchan)
+static int bam_dma_terminate_all(struct dma_chan *chan)
 {
+	struct bam_chan *bchan = to_bam_chan(chan);
 	unsigned long flag;
 	LIST_HEAD(head);
 
@@ -561,56 +569,46 @@ static void bam_dma_terminate_all(struct bam_chan *bchan)
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
+	writel_relaxed(1, bdev->regs + BAM_P_HALT(bchan->id));
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
-		writel_relaxed(1, bdev->regs + BAM_P_HALT(bchan->id));
-		bchan->paused = 1;
-		spin_unlock_irqrestore(&bchan->vc.lock, flag);
-		break;
-
-	case DMA_RESUME:
-		spin_lock_irqsave(&bchan->vc.lock, flag);
-		writel_relaxed(0, bdev->regs + BAM_P_HALT(bchan->id));
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
+	writel_relaxed(0, bdev->regs + BAM_P_HALT(bchan->id));
+	bchan->paused = 0;
+	spin_unlock_irqrestore(&bchan->vc.lock, flag);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -1050,7 +1048,10 @@ static int bam_dma_probe(struct platform_device *pdev)
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
-- 
2.1.1

