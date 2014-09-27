Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaI0I57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:57:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38687 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752861AbaI0I4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:56:52 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 9/9] dmaengine: sun6i: Convert to generic slave_caps
Date: Sat, 27 Sep 2014 10:54:45 +0200
Message-Id: <1411808085-27792-10-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the Allwinner A31 driver to the callbacks that have been introduced
before, in order to support calls to retrieve slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/sun6i-dma.c | 158 ++++++++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 72 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 1f92a56fd2b6..447de4d42251 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -358,38 +358,6 @@ static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
 	kfree(txd);
 }
 
-static int sun6i_dma_terminate_all(struct sun6i_vchan *vchan)
-{
-	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vchan->vc.chan.device);
-	struct sun6i_pchan *pchan = vchan->phy;
-	unsigned long flags;
-	LIST_HEAD(head);
-
-	spin_lock(&sdev->lock);
-	list_del_init(&vchan->node);
-	spin_unlock(&sdev->lock);
-
-	spin_lock_irqsave(&vchan->vc.lock, flags);
-
-	vchan_get_all_descriptors(&vchan->vc, &head);
-
-	if (pchan) {
-		writel(DMA_CHAN_ENABLE_STOP, pchan->base + DMA_CHAN_ENABLE);
-		writel(DMA_CHAN_PAUSE_RESUME, pchan->base + DMA_CHAN_PAUSE);
-
-		vchan->phy = NULL;
-		pchan->vchan = NULL;
-		pchan->desc = NULL;
-		pchan->done = NULL;
-	}
-
-	spin_unlock_irqrestore(&vchan->vc.lock, flags);
-
-	vchan_dma_desc_free_list(&vchan->vc, &head);
-
-	return 0;
-}
-
 static int sun6i_dma_start_desc(struct sun6i_vchan *vchan)
 {
 	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(vchan->vc.chan.device);
@@ -673,57 +641,92 @@ err_lli_free:
 	return NULL;
 }
 
-static int sun6i_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		       unsigned long arg)
+static int sun6i_dma_config(struct dma_chan *chan,
+			    struct dma_slave_config *config)
+{
+	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
+
+	memcpy(&vchan->cfg, config, sizeof(*config));
+
+	return 0;
+}
+
+static int sun6i_dma_pause(struct dma_chan *chan)
+{
+	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
+	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
+	struct sun6i_pchan *pchan = vchan->phy;
+
+	dev_dbg(chan2dev(chan), "vchan %p: pause\n", &vchan->vc);
+
+	if (pchan) {
+		writel(DMA_CHAN_PAUSE_PAUSE,
+		       pchan->base + DMA_CHAN_PAUSE);
+	} else {
+		spin_lock(&sdev->lock);
+		list_del_init(&vchan->node);
+		spin_unlock(&sdev->lock);
+	}
+
+	return 0;
+}
+
+static int sun6i_dma_resume(struct dma_chan *chan)
 {
 	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
 	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
 	struct sun6i_pchan *pchan = vchan->phy;
 	unsigned long flags;
-	int ret = 0;
 
-	switch (cmd) {
-	case DMA_RESUME:
-		dev_dbg(chan2dev(chan), "vchan %p: resume\n", &vchan->vc);
+	dev_dbg(chan2dev(chan), "vchan %p: resume\n", &vchan->vc);
 
-		spin_lock_irqsave(&vchan->vc.lock, flags);
+	spin_lock_irqsave(&vchan->vc.lock, flags);
 
-		if (pchan) {
-			writel(DMA_CHAN_PAUSE_RESUME,
-			       pchan->base + DMA_CHAN_PAUSE);
-		} else if (!list_empty(&vchan->vc.desc_issued)) {
-			spin_lock(&sdev->lock);
-			list_add_tail(&vchan->node, &sdev->pending);
-			spin_unlock(&sdev->lock);
-		}
+	if (pchan) {
+		writel(DMA_CHAN_PAUSE_RESUME,
+		       pchan->base + DMA_CHAN_PAUSE);
+	} else if (!list_empty(&vchan->vc.desc_issued)) {
+		spin_lock(&sdev->lock);
+		list_add_tail(&vchan->node, &sdev->pending);
+		spin_unlock(&sdev->lock);
+	}
 
-		spin_unlock_irqrestore(&vchan->vc.lock, flags);
-		break;
+	spin_unlock_irqrestore(&vchan->vc.lock, flags);
 
-	case DMA_PAUSE:
-		dev_dbg(chan2dev(chan), "vchan %p: pause\n", &vchan->vc);
+	return 0;
+}
 
-		if (pchan) {
-			writel(DMA_CHAN_PAUSE_PAUSE,
-			       pchan->base + DMA_CHAN_PAUSE);
-		} else {
-			spin_lock(&sdev->lock);
-			list_del_init(&vchan->node);
-			spin_unlock(&sdev->lock);
-		}
-		break;
+static int sun6i_dma_terminate_all(struct dma_chan *chan)
+{
+	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
+	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
+	struct sun6i_pchan *pchan = vchan->phy;
+	unsigned long flags;
+	LIST_HEAD(head);
 
-	case DMA_TERMINATE_ALL:
-		ret = sun6i_dma_terminate_all(vchan);
-		break;
-	case DMA_SLAVE_CONFIG:
-		memcpy(&vchan->cfg, (void *)arg, sizeof(struct dma_slave_config));
-		break;
-	default:
-		ret = -ENXIO;
-		break;
+	spin_lock(&sdev->lock);
+	list_del_init(&vchan->node);
+	spin_unlock(&sdev->lock);
+
+	spin_lock_irqsave(&vchan->vc.lock, flags);
+
+	vchan_get_all_descriptors(&vchan->vc, &head);
+
+	if (pchan) {
+		writel(DMA_CHAN_ENABLE_STOP, pchan->base + DMA_CHAN_ENABLE);
+		writel(DMA_CHAN_PAUSE_RESUME, pchan->base + DMA_CHAN_PAUSE);
+
+		vchan->phy = NULL;
+		pchan->vchan = NULL;
+		pchan->desc = NULL;
+		pchan->done = NULL;
 	}
-	return ret;
+
+	spin_unlock_irqrestore(&vchan->vc.lock, flags);
+
+	vchan_dma_desc_free_list(&vchan->vc, &head);
+
+	return 0;
 }
 
 static enum dma_status sun6i_dma_tx_status(struct dma_chan *chan,
@@ -936,9 +939,20 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 	sdc->slave.device_issue_pending		= sun6i_dma_issue_pending;
 	sdc->slave.device_prep_slave_sg		= sun6i_dma_prep_slave_sg;
 	sdc->slave.device_prep_dma_memcpy	= sun6i_dma_prep_dma_memcpy;
-	sdc->slave.device_control		= sun6i_dma_control;
+	sdc->slave.device_config		= sun6i_dma_config;
+	sdc->slave.device_pause			= sun6i_dma_pause;
+	sdc->slave.device_resume		= sun6i_dma_resume;
+	sdc->slave.device_terminate_all		= sun6i_dma_terminate_all;
 	sdc->slave.chancnt			= NR_MAX_VCHANS;
-
+	sdc->slave.src_addr_widths		= BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
+						  BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
+						  BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	sdc->slave.dst_addr_widths		= BIT(DMA_SLAVE_BUSWIDTH_1_BYTE) |
+						  BIT(DMA_SLAVE_BUSWIDTH_2_BYTES) |
+						  BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
+	sdc->slave.directions			= BIT(DMA_DEV_TO_MEM) |
+						  BIT(DMA_MEM_TO_DEV);
+	sdc->slave.residue_granularity		= DMA_RESIDUE_GRANULARITY_BURST;
 	sdc->slave.dev = &pdev->dev;
 
 	sdc->pchans = devm_kcalloc(&pdev->dev, NR_MAX_CHANNELS,
-- 
2.1.0

