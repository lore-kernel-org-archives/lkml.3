Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaJVPp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:45:56 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54159 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754827AbaJVPpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:53 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 42/59] dmaengine: d40: Split device_control
Date: Wed, 22 Oct 2014 17:43:56 +0200
Message-Id: <1413992653-21963-43-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the ST-Ericsson DMA 40 driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/ste_dma40.c | 60 +++++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 5fe59335e247..b781c988b592 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1429,11 +1429,17 @@ static bool d40_tx_is_linked(struct d40_chan *d40c)
 	return is_link;
 }
 
-static int d40_pause(struct d40_chan *d40c)
+static int d40_pause(struct dma_chan *chan)
 {
+	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
 	int res = 0;
 	unsigned long flags;
 
+	if (d40c->phy_chan == NULL) {
+		chan_err(d40c, "Channel is not allocated!\n");
+		return -EINVAL;
+	}
+
 	if (!d40c->busy)
 		return 0;
 
@@ -1448,11 +1454,17 @@ static int d40_pause(struct d40_chan *d40c)
 	return res;
 }
 
-static int d40_resume(struct d40_chan *d40c)
+static int d40_resume(struct dma_chan *chan)
 {
+	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
 	int res = 0;
 	unsigned long flags;
 
+	if (d40c->phy_chan == NULL) {
+		chan_err(d40c, "Channel is not allocated!\n");
+		return -EINVAL;
+	}
+
 	if (!d40c->busy)
 		return 0;
 
@@ -2610,6 +2622,11 @@ static void d40_terminate_all(struct dma_chan *chan)
 	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
 	int ret;
 
+	if (d40c->phy_chan == NULL) {
+		chan_err(d40c, "Channel is not allocated!\n");
+		return -EINVAL;
+	}
+
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	pm_runtime_get_sync(d40c->base->dev);
@@ -2673,6 +2690,11 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	u32 src_maxburst, dst_maxburst;
 	int ret;
 
+	if (d40c->phy_chan == NULL) {
+		chan_err(d40c, "Channel is not allocated!\n");
+		return -EINVAL;
+	}
+
 	src_addr_width = config->src_addr_width;
 	src_maxburst = config->src_maxburst;
 	dst_addr_width = config->dst_addr_width;
@@ -2781,35 +2803,6 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	return 0;
 }
 
-static int d40_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-		       unsigned long arg)
-{
-	struct d40_chan *d40c = container_of(chan, struct d40_chan, chan);
-
-	if (d40c->phy_chan == NULL) {
-		chan_err(d40c, "Channel is not allocated!\n");
-		return -EINVAL;
-	}
-
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		d40_terminate_all(chan);
-		return 0;
-	case DMA_PAUSE:
-		return d40_pause(d40c);
-	case DMA_RESUME:
-		return d40_resume(d40c);
-	case DMA_SLAVE_CONFIG:
-		return d40_set_runtime_config(chan,
-			(struct dma_slave_config *) arg);
-	default:
-		break;
-	}
-
-	/* Other commands are unimplemented */
-	return -ENXIO;
-}
-
 /* Initialization functions */
 
 static void __init d40_chan_init(struct d40_base *base, struct dma_device *dma,
@@ -2870,7 +2863,10 @@ static void d40_ops_init(struct d40_base *base, struct dma_device *dev)
 	dev->device_free_chan_resources = d40_free_chan_resources;
 	dev->device_issue_pending = d40_issue_pending;
 	dev->device_tx_status = d40_tx_status;
-	dev->device_control = d40_control;
+	dev->device_config = d40_set_runtime_config;
+	dev->device_pause = d40_pause;
+	dev->device_resume = d40_resume;
+	dev->device_terminate_all = d40_terminate_all;
 	dev->dev = base->dev;
 }
 
-- 
2.1.1

