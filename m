Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaJVPqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:46:06 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54095 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754954AbaJVPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:59 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 37/59] dmaengine: s3c24xx: Split device_control
Date: Wed, 22 Oct 2014 17:43:51 +0200
Message-Id: <1413992653-21963-38-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Samsung S3C24xxx DMA driver to make
use of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/s3c24xx-dma.c | 75 +++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/dma/s3c24xx-dma.c b/drivers/dma/s3c24xx-dma.c
index 7416572d1e40..2177bf5a742c 100644
--- a/drivers/dma/s3c24xx-dma.c
+++ b/drivers/dma/s3c24xx-dma.c
@@ -384,20 +384,30 @@ static u32 s3c24xx_dma_getbytes_chan(struct s3c24xx_dma_chan *s3cchan)
 	return tc * txd->width;
 }
 
-static int s3c24xx_dma_set_runtime_config(struct s3c24xx_dma_chan *s3cchan,
+static int s3c24xx_dma_set_runtime_config(struct dma_chan *chan,
 				  struct dma_slave_config *config)
 {
-	if (!s3cchan->slave)
-		return -EINVAL;
+	struct s3c24xx_dma_chan *s3cchan = to_s3c24xx_dma_chan(chan);
+	unsigned long flags;
+	int ret = 0;
 
 	/* Reject definitely invalid configurations */
 	if (config->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
 	    config->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
 		return -EINVAL;
 
+	spin_lock_irqsave(&s3cchan->vc.lock, flags);
+
+	if (!s3cchan->slave) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	s3cchan->cfg = *config;
 
-	return 0;
+out:
+	spin_lock_irqrestore(&s3cchan->vc.lock, flags);
+	return ret;
 }
 
 /*
@@ -703,53 +713,38 @@ static irqreturn_t s3c24xx_dma_irq(int irq, void *data)
  * The DMA ENGINE API
  */
 
-static int s3c24xx_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			 unsigned long arg)
+static int s3c24xx_dma_terminate_all(struct dma_chan *chan)
 {
 	struct s3c24xx_dma_chan *s3cchan = to_s3c24xx_dma_chan(chan);
 	struct s3c24xx_dma_engine *s3cdma = s3cchan->host;
 	unsigned long flags;
-	int ret = 0;
 
 	spin_lock_irqsave(&s3cchan->vc.lock, flags);
 
-	switch (cmd) {
-	case DMA_SLAVE_CONFIG:
-		ret = s3c24xx_dma_set_runtime_config(s3cchan,
-					      (struct dma_slave_config *)arg);
-		break;
-	case DMA_TERMINATE_ALL:
-		if (!s3cchan->phy && !s3cchan->at) {
-			dev_err(&s3cdma->pdev->dev, "trying to terminate already stopped channel %d\n",
-				s3cchan->id);
-			ret = -EINVAL;
-			break;
-		}
-
-		s3cchan->state = S3C24XX_DMA_CHAN_IDLE;
+	if (!s3cchan->phy && !s3cchan->at) {
+		dev_err(&s3cdma->pdev->dev, "trying to terminate already stopped channel %d\n",
+			s3cchan->id);
+		return -EINVAL;
+	}
 
-		 /* Mark physical channel as free */
-		if (s3cchan->phy)
-			s3c24xx_dma_phy_free(s3cchan);
+	s3cchan->state = S3C24XX_DMA_CHAN_IDLE;
 
-		/* Dequeue current job */
-		if (s3cchan->at) {
-			s3c24xx_dma_desc_free(&s3cchan->at->vd);
-			s3cchan->at = NULL;
-		}
+	/* Mark physical channel as free */
+	if (s3cchan->phy)
+		s3c24xx_dma_phy_free(s3cchan);
 
-		/* Dequeue jobs not yet fired as well */
-		s3c24xx_dma_free_txd_list(s3cdma, s3cchan);
-		break;
-	default:
-		/* Unknown command */
-		ret = -ENXIO;
-		break;
+	/* Dequeue current job */
+	if (s3cchan->at) {
+		s3c24xx_dma_desc_free(&s3cchan->at->vd);
+		s3cchan->at = NULL;
 	}
 
+	/* Dequeue jobs not yet fired as well */
+	s3c24xx_dma_free_txd_list(s3cdma, s3cchan);
+
 	spin_unlock_irqrestore(&s3cchan->vc.lock, flags);
 
-	return ret;
+	return 0;
 }
 
 static int s3c24xx_dma_alloc_chan_resources(struct dma_chan *chan)
@@ -1300,7 +1295,8 @@ static int s3c24xx_dma_probe(struct platform_device *pdev)
 	s3cdma->memcpy.device_prep_dma_memcpy = s3c24xx_dma_prep_memcpy;
 	s3cdma->memcpy.device_tx_status = s3c24xx_dma_tx_status;
 	s3cdma->memcpy.device_issue_pending = s3c24xx_dma_issue_pending;
-	s3cdma->memcpy.device_control = s3c24xx_dma_control;
+	s3cdma->memcpy.device_config = s3c24xx_dma_set_runtime_config;
+	s3cdma->memcpy.device_terminate_all = s3c24xx_dma_terminate_all;
 
 	/* Initialize slave engine for SoC internal dedicated peripherals */
 	dma_cap_set(DMA_SLAVE, s3cdma->slave.cap_mask);
@@ -1315,7 +1311,8 @@ static int s3c24xx_dma_probe(struct platform_device *pdev)
 	s3cdma->slave.device_issue_pending = s3c24xx_dma_issue_pending;
 	s3cdma->slave.device_prep_slave_sg = s3c24xx_dma_prep_slave_sg;
 	s3cdma->slave.device_prep_dma_cyclic = s3c24xx_dma_prep_dma_cyclic;
-	s3cdma->slave.device_control = s3c24xx_dma_control;
+	s3cdma->slave.device_config = s3c24xx_dma_set_runtime_config;
+	s3cdma->slave.device_terminate_all = s3c24xx_dma_terminate_all;
 
 	/* Register as many memcpy channels as there are physical channels */
 	ret = s3c24xx_dma_init_virtual_channels(s3cdma, &s3cdma->memcpy,
-- 
2.1.1

