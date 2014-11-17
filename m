Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaKQNts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:49:48 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753052AbaKQNpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:53 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 14/61] dmaengine: bcm2835: Split device_control
Date: Mon, 17 Nov 2014 14:42:08 +0100
Message-Id: <1416231775-31252-15-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Broadcom BCM2835 DMA driver to make
use of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/dma/bcm2835-dma.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
index 3feba6c25836..13b05c1673b1 100644
--- a/drivers/dma/bcm2835-dma.c
+++ b/drivers/dma/bcm2835-dma.c
@@ -436,9 +436,11 @@ static struct dma_async_tx_descriptor *bcm2835_dma_prep_dma_cyclic(
 	return vchan_tx_prep(&c->vc, &d->vd, flags);
 }
 
-static int bcm2835_dma_slave_config(struct bcm2835_chan *c,
-		struct dma_slave_config *cfg)
+static int bcm2835_dma_slave_config(struct dma_chan *chan,
+				    struct dma_slave_config *cfg)
 {
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
+
 	if ((cfg->direction == DMA_DEV_TO_MEM &&
 	     cfg->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
 	    (cfg->direction == DMA_MEM_TO_DEV &&
@@ -452,8 +454,9 @@ static int bcm2835_dma_slave_config(struct bcm2835_chan *c,
 	return 0;
 }
 
-static int bcm2835_dma_terminate_all(struct bcm2835_chan *c)
+static int bcm2835_dma_terminate_all(struct dma_chan *chan)
 {
+	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
 	struct bcm2835_dmadev *d = to_bcm2835_dma_dev(c->vc.chan.device);
 	unsigned long flags;
 	int timeout = 10000;
@@ -495,24 +498,6 @@ static int bcm2835_dma_terminate_all(struct bcm2835_chan *c)
 	return 0;
 }
 
-static int bcm2835_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-	unsigned long arg)
-{
-	struct bcm2835_chan *c = to_bcm2835_dma_chan(chan);
-
-	switch (cmd) {
-	case DMA_SLAVE_CONFIG:
-		return bcm2835_dma_slave_config(c,
-				(struct dma_slave_config *)arg);
-
-	case DMA_TERMINATE_ALL:
-		return bcm2835_dma_terminate_all(c);
-
-	default:
-		return -ENXIO;
-	}
-}
-
 static int bcm2835_dma_chan_init(struct bcm2835_dmadev *d, int chan_id, int irq)
 {
 	struct bcm2835_chan *c;
@@ -615,9 +600,9 @@ static int bcm2835_dma_probe(struct platform_device *pdev)
 	od->ddev.device_free_chan_resources = bcm2835_dma_free_chan_resources;
 	od->ddev.device_tx_status = bcm2835_dma_tx_status;
 	od->ddev.device_issue_pending = bcm2835_dma_issue_pending;
-	od->ddev.device_slave_caps = bcm2835_dma_device_slave_caps;
 	od->ddev.device_prep_dma_cyclic = bcm2835_dma_prep_dma_cyclic;
-	od->ddev.device_control = bcm2835_dma_control;
+	od->ddev.device_config = bcm2835_dma_slave_config;
+	od->ddev.device_terminate_all = bcm2835_dma_terminate_all;
 	od->ddev.dev = &pdev->dev;
 	INIT_LIST_HEAD(&od->ddev.channels);
 	spin_lock_init(&od->lock);
-- 
2.1.1

