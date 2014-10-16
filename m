Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaJPKca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:32:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37249 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752430AbaJPKUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:20:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 24/53] dmaengine: mmp-tdma: Split device_control
Date: Thu, 16 Oct 2014 12:17:23 +0200
Message-Id: <1413454672-27400-25-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413454672-27400-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Marvell MMP TDMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/mmp_tdma.c | 71 +++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 6ad30e2c5038..9b4b18138940 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -158,8 +158,10 @@ static void mmp_tdma_enable_chan(struct mmp_tdma_chan *tdmac)
 	tdmac->status = DMA_IN_PROGRESS;
 }
 
-static void mmp_tdma_disable_chan(struct mmp_tdma_chan *tdmac)
+static int mmp_tdma_disable_chan(struct dma_chan *chan)
 {
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+
 	writel(readl(tdmac->reg_base + TDCR) & ~TDCR_CHANEN,
 					tdmac->reg_base + TDCR);
 
@@ -167,27 +169,38 @@ static void mmp_tdma_disable_chan(struct mmp_tdma_chan *tdmac)
 	writel(0, tdmac->reg_base + TDIMR);
 
 	tdmac->status = DMA_COMPLETE;
+
+	return 0;
 }
 
-static void mmp_tdma_resume_chan(struct mmp_tdma_chan *tdmac)
+static int mmp_tdma_resume_chan(struct dma_chan *chan)
 {
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+
 	writel(readl(tdmac->reg_base + TDCR) | TDCR_CHANEN,
 					tdmac->reg_base + TDCR);
 	tdmac->status = DMA_IN_PROGRESS;
+
+	return 0;
 }
 
-static void mmp_tdma_pause_chan(struct mmp_tdma_chan *tdmac)
+static int mmp_tdma_pause_chan(struct dma_chan *chan)
 {
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
+
 	writel(readl(tdmac->reg_base + TDCR) & ~TDCR_CHANEN,
 					tdmac->reg_base + TDCR);
 	tdmac->status = DMA_PAUSED;
+
+	return 0;
 }
 
-static int mmp_tdma_config_chan(struct mmp_tdma_chan *tdmac)
+static int mmp_tdma_config_chan(struct dma_chan *chan)
 {
+	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
 	unsigned int tdcr = 0;
 
-	mmp_tdma_disable_chan(tdmac);
+	mmp_tdma_disable_chan(chan);
 
 	if (tdmac->dir == DMA_MEM_TO_DEV)
 		tdcr = TDCR_DSTDIR_ADDR_HOLD | TDCR_SRCDIR_ADDR_INC;
@@ -445,40 +458,23 @@ err_out:
 	return NULL;
 }
 
-static int mmp_tdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		unsigned long arg)
+static int mmp_tdma_config(struct dma_chan *chan,
+			   struct dma_slave_config *dmaengine_cfg)
 {
 	struct mmp_tdma_chan *tdmac = to_mmp_tdma_chan(chan);
-	struct dma_slave_config *dmaengine_cfg = (void *)arg;
-	int ret = 0;
-
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		mmp_tdma_disable_chan(tdmac);
-		break;
-	case DMA_PAUSE:
-		mmp_tdma_pause_chan(tdmac);
-		break;
-	case DMA_RESUME:
-		mmp_tdma_resume_chan(tdmac);
-		break;
-	case DMA_SLAVE_CONFIG:
-		if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
-			tdmac->dev_addr = dmaengine_cfg->src_addr;
-			tdmac->burst_sz = dmaengine_cfg->src_maxburst;
-			tdmac->buswidth = dmaengine_cfg->src_addr_width;
-		} else {
-			tdmac->dev_addr = dmaengine_cfg->dst_addr;
-			tdmac->burst_sz = dmaengine_cfg->dst_maxburst;
-			tdmac->buswidth = dmaengine_cfg->dst_addr_width;
-		}
-		tdmac->dir = dmaengine_cfg->direction;
-		return mmp_tdma_config_chan(tdmac);
-	default:
-		ret = -ENOSYS;
+
+	if (dmaengine_cfg->direction == DMA_DEV_TO_MEM) {
+		tdmac->dev_addr = dmaengine_cfg->src_addr;
+		tdmac->burst_sz = dmaengine_cfg->src_maxburst;
+		tdmac->buswidth = dmaengine_cfg->src_addr_width;
+	} else {
+		tdmac->dev_addr = dmaengine_cfg->dst_addr;
+		tdmac->burst_sz = dmaengine_cfg->dst_maxburst;
+		tdmac->buswidth = dmaengine_cfg->dst_addr_width;
 	}
+	tdmac->dir = dmaengine_cfg->direction;
 
-	return ret;
+	return mmp_tdma_config_chan(chan);
 }
 
 static enum dma_status mmp_tdma_tx_status(struct dma_chan *chan,
@@ -659,7 +655,10 @@ static int mmp_tdma_probe(struct platform_device *pdev)
 	tdev->device.device_prep_dma_cyclic = mmp_tdma_prep_dma_cyclic;
 	tdev->device.device_tx_status = mmp_tdma_tx_status;
 	tdev->device.device_issue_pending = mmp_tdma_issue_pending;
-	tdev->device.device_control = mmp_tdma_control;
+	tdev->device.device_config = mmp_tdma_config;
+	tdev->device.device_pause = mmp_tdma_pause_chan;
+	tdev->device.device_resume = mmp_tdma_resume_chan;
+	tdev->device.device_terminate_all = mmp_tdma_disable_chan;
 	tdev->device.copy_align = TDMA_ALIGNMENT;
 
 	dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
-- 
2.1.1

