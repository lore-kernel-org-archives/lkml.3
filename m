Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaKQNpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:45:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbaKQNpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:35 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 41/61] dmaengine: sun6i: Split device_control
Date: Mon, 17 Nov 2014 14:42:35 +0100
Message-Id: <1416231775-31252-42-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Allwinner A31 DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/sun6i-dma.c | 150 +++++++++++++++++++++++++-----------------------
 1 file changed, 78 insertions(+), 72 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 77fb124dad67..4ef76bc22da4 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -355,38 +355,6 @@ static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
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
@@ -675,57 +643,92 @@ err_lli_free:
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
-
-	case DMA_TERMINATE_ALL:
-		ret = sun6i_dma_terminate_all(vchan);
-		break;
-	case DMA_SLAVE_CONFIG:
-		memcpy(&vchan->cfg, (void *)arg, sizeof(struct dma_slave_config));
-		break;
-	default:
-		ret = -ENXIO;
-		break;
+static int sun6i_dma_terminate_all(struct dma_chan *chan)
+{
+	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
+	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
+	struct sun6i_pchan *pchan = vchan->phy;
+	unsigned long flags;
+	LIST_HEAD(head);
+
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
@@ -960,7 +963,10 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 	sdc->slave.device_issue_pending		= sun6i_dma_issue_pending;
 	sdc->slave.device_prep_slave_sg		= sun6i_dma_prep_slave_sg;
 	sdc->slave.device_prep_dma_memcpy	= sun6i_dma_prep_dma_memcpy;
-	sdc->slave.device_control		= sun6i_dma_control;
+	sdc->slave.device_config		= sun6i_dma_config;
+	sdc->slave.device_pause			= sun6i_dma_pause;
+	sdc->slave.device_resume		= sun6i_dma_resume;
+	sdc->slave.device_terminate_all		= sun6i_dma_terminate_all;
 	sdc->slave.copy_align			= 4;
 	sdc->slave.dev = &pdev->dev;
 
-- 
2.1.1

