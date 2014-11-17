Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaKQN5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:57:42 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48985 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753082AbaKQNp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:28 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 34/61] dmaengine: omap: Split device_control
Date: Mon, 17 Nov 2014 14:42:28 +0100
Message-Id: <1416231775-31252-35-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the TI OMAP DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/omap-dma.c | 51 +++++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index a8aa5b6bb5e2..1cadf812f3b3 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -948,8 +948,10 @@ static struct dma_async_tx_descriptor *omap_dma_prep_dma_cyclic(
 	return vchan_tx_prep(&c->vc, &d->vd, flags);
 }
 
-static int omap_dma_slave_config(struct omap_chan *c, struct dma_slave_config *cfg)
+static int omap_dma_slave_config(struct dma_chan *chan, struct dma_slave_config *cfg)
 {
+	struct omap_chan *c = to_omap_dma_chan(chan);
+
 	if (cfg->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
 	    cfg->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
 		return -EINVAL;
@@ -959,8 +961,9 @@ static int omap_dma_slave_config(struct omap_chan *c, struct dma_slave_config *c
 	return 0;
 }
 
-static int omap_dma_terminate_all(struct omap_chan *c)
+static int omap_dma_terminate_all(struct dma_chan *chan)
 {
+	struct omap_chan *c = to_omap_dma_chan(chan);
 	struct omap_dmadev *d = to_omap_dma_dev(c->vc.chan.device);
 	unsigned long flags;
 	LIST_HEAD(head);
@@ -996,8 +999,10 @@ static int omap_dma_terminate_all(struct omap_chan *c)
 	return 0;
 }
 
-static int omap_dma_pause(struct omap_chan *c)
+static int omap_dma_pause(struct dma_chan *chan)
 {
+	struct omap_chan *c = to_omap_dma_chan(chan);
+
 	/* Pause/Resume only allowed with cyclic mode */
 	if (!c->cyclic)
 		return -EINVAL;
@@ -1010,8 +1015,10 @@ static int omap_dma_pause(struct omap_chan *c)
 	return 0;
 }
 
-static int omap_dma_resume(struct omap_chan *c)
+static int omap_dma_resume(struct dma_chan *chan)
 {
+	struct omap_chan *c = to_omap_dma_chan(chan);
+
 	/* Pause/Resume only allowed with cyclic mode */
 	if (!c->cyclic)
 		return -EINVAL;
@@ -1029,37 +1036,6 @@ static int omap_dma_resume(struct omap_chan *c)
 	return 0;
 }
 
-static int omap_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-	unsigned long arg)
-{
-	struct omap_chan *c = to_omap_dma_chan(chan);
-	int ret;
-
-	switch (cmd) {
-	case DMA_SLAVE_CONFIG:
-		ret = omap_dma_slave_config(c, (struct dma_slave_config *)arg);
-		break;
-
-	case DMA_TERMINATE_ALL:
-		ret = omap_dma_terminate_all(c);
-		break;
-
-	case DMA_PAUSE:
-		ret = omap_dma_pause(c);
-		break;
-
-	case DMA_RESUME:
-		ret = omap_dma_resume(c);
-		break;
-
-	default:
-		ret = -ENXIO;
-		break;
-	}
-
-	return ret;
-}
-
 static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
 {
 	struct omap_chan *c;
@@ -1136,7 +1112,10 @@ static int omap_dma_probe(struct platform_device *pdev)
 	od->ddev.device_issue_pending = omap_dma_issue_pending;
 	od->ddev.device_prep_slave_sg = omap_dma_prep_slave_sg;
 	od->ddev.device_prep_dma_cyclic = omap_dma_prep_dma_cyclic;
-	od->ddev.device_control = omap_dma_control;
+	od->ddev.device_config = omap_dma_config;
+	od->ddev.device_pause = omap_dma_pause;
+	od->ddev.device_resume = omap_dma_resume;
+	od->ddev.device_terminate_all = omap_dma_terminate_all;
 	od->ddev.device_slave_caps = omap_dma_device_slave_caps;
 	od->ddev.dev = &pdev->dev;
 	INIT_LIST_HEAD(&od->ddev.channels);
-- 
2.1.1

