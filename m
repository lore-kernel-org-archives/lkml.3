Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab3GVSK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:10:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:41822 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab3GVSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:10:20 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: balbi@ti.com, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 08/16] usb: musb: dma: merge ->start/stop into create/destroy
Date: Mon, 22 Jul 2013 20:09:59 +0200
Message-Id: <1374516607-2705-9-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core code creates a controller and immediately after that it calls
the ->start() callback. This one might drop an error but nobody cares.
The same thing happens in the destroy corner: First ->stop() called
followed by destroy callback. So why not merge those two into the same
function since there is no difference.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/cppi_dma.c      | 18 +++++-------------
 drivers/usb/musb/musb_core.c     | 18 ++++--------------
 drivers/usb/musb/musb_dma.h      |  2 --
 drivers/usb/musb/musbhsdma.c     | 16 +++-------------
 drivers/usb/musb/tusb6010_omap.c | 24 ------------------------
 drivers/usb/musb/ux500_dma.c     | 19 ++++++++-----------
 6 files changed, 20 insertions(+), 77 deletions(-)

diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index 9db211e..904fb85 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -150,14 +150,11 @@ static void cppi_pool_free(struct cppi_channel *c)
 	c->last_processed = NULL;
 }
 
-static int cppi_controller_start(struct dma_controller *c)
+static void cppi_controller_start(struct cppi *controller)
 {
-	struct cppi	*controller;
 	void __iomem	*tibase;
 	int		i;
 
-	controller = container_of(c, struct cppi, controller);
-
 	/* do whatever is necessary to start controller */
 	for (i = 0; i < ARRAY_SIZE(controller->tx); i++) {
 		controller->tx[i].transmit = true;
@@ -212,8 +209,6 @@ static int cppi_controller_start(struct dma_controller *c)
 	/* disable RNDIS mode, also host rx RNDIS autorequest */
 	musb_writel(tibase, DAVINCI_RNDIS_REG, 0);
 	musb_writel(tibase, DAVINCI_AUTOREQ_REG, 0);
-
-	return 0;
 }
 
 /*
@@ -222,14 +217,12 @@ static int cppi_controller_start(struct dma_controller *c)
  *  De-Init the DMA controller as necessary.
  */
 
-static int cppi_controller_stop(struct dma_controller *c)
+static void cppi_controller_stop(struct cppi *controller)
 {
-	struct cppi		*controller;
 	void __iomem		*tibase;
 	int			i;
 	struct musb		*musb;
 
-	controller = container_of(c, struct cppi, controller);
 	musb = controller->musb;
 
 	tibase = controller->tibase;
@@ -255,8 +248,6 @@ static int cppi_controller_stop(struct dma_controller *c)
 	/*disable tx/rx cppi */
 	musb_writel(tibase, DAVINCI_TXCPPI_CTRL_REG, DAVINCI_DMA_CTRL_DISABLE);
 	musb_writel(tibase, DAVINCI_RXCPPI_CTRL_REG, DAVINCI_DMA_CTRL_DISABLE);
-
-	return 0;
 }
 
 /* While dma channel is allocated, we only want the core irqs active
@@ -1321,8 +1312,6 @@ struct dma_controller *dma_controller_create(struct musb *musb, void __iomem *mr
 	controller->tibase = mregs - DAVINCI_BASE_OFFSET;
 
 	controller->musb = musb;
-	controller->controller.start = cppi_controller_start;
-	controller->controller.stop = cppi_controller_stop;
 	controller->controller.channel_alloc = cppi_channel_allocate;
 	controller->controller.channel_release = cppi_channel_release;
 	controller->controller.channel_program = cppi_channel_program;
@@ -1351,6 +1340,7 @@ struct dma_controller *dma_controller_create(struct musb *musb, void __iomem *mr
 		controller->irq = irq;
 	}
 
+	cppi_controller_start(controller);
 	return &controller->controller;
 }
 
@@ -1363,6 +1353,8 @@ void dma_controller_destroy(struct dma_controller *c)
 
 	cppi = container_of(c, struct cppi, controller);
 
+	cppi_controller_stop(cppi);
+
 	if (cppi->irq)
 		free_irq(cppi->irq, cppi->musb);
 
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 29a24ce..a4434d2 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1764,12 +1764,8 @@ static void musb_free(struct musb *musb)
 			disable_irq_wake(musb->nIrq);
 		free_irq(musb->nIrq, musb);
 	}
-	if (is_dma_capable() && musb->dma_controller) {
-		struct dma_controller	*c = musb->dma_controller;
-
-		(void) c->stop(c);
-		dma_controller_destroy(c);
-	}
+	if (is_dma_capable() && musb->dma_controller)
+		dma_controller_destroy(musb->dma_controller);
 
 	musb_host_free(musb);
 }
@@ -1845,14 +1841,8 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	pm_runtime_get_sync(musb->controller);
 
 #ifndef CONFIG_MUSB_PIO_ONLY
-	if (use_dma && dev->dma_mask) {
-		struct dma_controller	*c;
-
-		c = dma_controller_create(musb, musb->mregs);
-		musb->dma_controller = c;
-		if (c)
-			(void) c->start(c);
-	}
+	if (use_dma && dev->dma_mask)
+		musb->dma_controller = dma_controller_create(musb, musb->mregs);
 #endif
 	/* ideally this would be abstracted in platform setup */
 	if (!is_dma_capable() || !musb->dma_controller)
diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
index 8919ce2..3603711 100644
--- a/drivers/usb/musb/musb_dma.h
+++ b/drivers/usb/musb/musb_dma.h
@@ -159,8 +159,6 @@ dma_channel_status(struct dma_channel *c)
  * Controllers manage dma channels.
  */
 struct dma_controller {
-	int			(*start)(struct dma_controller *);
-	int			(*stop)(struct dma_controller *);
 	struct dma_channel	*(*channel_alloc)(struct dma_controller *,
 					struct musb_hw_ep *, u8 is_tx);
 	void			(*channel_release)(struct dma_channel *);
diff --git a/drivers/usb/musb/musbhsdma.c b/drivers/usb/musb/musbhsdma.c
index 3d1fd52..092cedf 100644
--- a/drivers/usb/musb/musbhsdma.c
+++ b/drivers/usb/musb/musbhsdma.c
@@ -37,18 +37,10 @@
 #include "musb_core.h"
 #include "musbhsdma.h"
 
-static int dma_controller_start(struct dma_controller *c)
-{
-	/* nothing to do */
-	return 0;
-}
-
 static void dma_channel_release(struct dma_channel *channel);
 
-static int dma_controller_stop(struct dma_controller *c)
+static void dma_controller_stop(struct musb_dma_controller *controller)
 {
-	struct musb_dma_controller *controller = container_of(c,
-			struct musb_dma_controller, controller);
 	struct musb *musb = controller->private_data;
 	struct dma_channel *channel;
 	u8 bit;
@@ -67,8 +59,6 @@ static int dma_controller_stop(struct dma_controller *c)
 			}
 		}
 	}
-
-	return 0;
 }
 
 static struct dma_channel *dma_channel_allocate(struct dma_controller *c,
@@ -374,6 +364,8 @@ void dma_controller_destroy(struct dma_controller *c)
 	if (!controller)
 		return;
 
+	dma_controller_stop(controller);
+
 	if (controller->irq)
 		free_irq(controller->irq, c);
 
@@ -400,8 +392,6 @@ struct dma_controller *dma_controller_create(struct musb *musb, void __iomem *ba
 	controller->private_data = musb;
 	controller->base = base;
 
-	controller->controller.start = dma_controller_start;
-	controller->controller.stop = dma_controller_stop;
 	controller->controller.channel_alloc = dma_channel_allocate;
 	controller->controller.channel_release = dma_channel_release;
 	controller->controller.channel_program = dma_channel_program;
diff --git a/drivers/usb/musb/tusb6010_omap.c b/drivers/usb/musb/tusb6010_omap.c
index 98df17c..b8794eb 100644
--- a/drivers/usb/musb/tusb6010_omap.c
+++ b/drivers/usb/musb/tusb6010_omap.c
@@ -66,28 +66,6 @@ struct tusb_omap_dma {
 	unsigned			multichannel:1;
 };
 
-static int tusb_omap_dma_start(struct dma_controller *c)
-{
-	struct tusb_omap_dma	*tusb_dma;
-
-	tusb_dma = container_of(c, struct tusb_omap_dma, controller);
-
-	/* dev_dbg(musb->controller, "ep%i ch: %i\n", chdat->epnum, chdat->ch); */
-
-	return 0;
-}
-
-static int tusb_omap_dma_stop(struct dma_controller *c)
-{
-	struct tusb_omap_dma	*tusb_dma;
-
-	tusb_dma = container_of(c, struct tusb_omap_dma, controller);
-
-	/* dev_dbg(musb->controller, "ep%i ch: %i\n", chdat->epnum, chdat->ch); */
-
-	return 0;
-}
-
 /*
  * Allocate dmareq0 to the current channel unless it's already taken
  */
@@ -695,8 +673,6 @@ struct dma_controller *dma_controller_create(struct musb *musb, void __iomem *ba
 	tusb_dma->dmareq = -1;
 	tusb_dma->sync_dev = -1;
 
-	tusb_dma->controller.start = tusb_omap_dma_start;
-	tusb_dma->controller.stop = tusb_omap_dma_stop;
 	tusb_dma->controller.channel_alloc = tusb_omap_dma_allocate;
 	tusb_dma->controller.channel_release = tusb_omap_dma_release;
 	tusb_dma->controller.channel_program = tusb_omap_dma_program;
diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index bfb7a65..1ce214e 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -254,10 +254,8 @@ static int ux500_dma_channel_abort(struct dma_channel *channel)
 	return 0;
 }
 
-static int ux500_dma_controller_stop(struct dma_controller *c)
+static void ux500_dma_controller_stop(struct ux500_dma_controller *controller)
 {
-	struct ux500_dma_controller *controller = container_of(c,
-			struct ux500_dma_controller, controller);
 	struct ux500_dma_channel *ux500_channel;
 	struct dma_channel *channel;
 	u8 ch_num;
@@ -281,14 +279,10 @@ static int ux500_dma_controller_stop(struct dma_controller *c)
 		if (ux500_channel->dma_chan)
 			dma_release_channel(ux500_channel->dma_chan);
 	}
-
-	return 0;
 }
 
-static int ux500_dma_controller_start(struct dma_controller *c)
+static int ux500_dma_controller_start(struct ux500_dma_controller *controller)
 {
-	struct ux500_dma_controller *controller = container_of(c,
-			struct ux500_dma_controller, controller);
 	struct ux500_dma_channel *ux500_channel = NULL;
 	struct musb *musb = controller->private_data;
 	struct device *dev = musb->controller;
@@ -347,7 +341,7 @@ static int ux500_dma_controller_start(struct dma_controller *c)
 					dir, ch_num);
 
 				/* Release already allocated channels */
-				ux500_dma_controller_stop(c);
+				ux500_dma_controller_stop(controller);
 
 				return -EBUSY;
 			}
@@ -369,6 +363,7 @@ void dma_controller_destroy(struct dma_controller *c)
 	struct ux500_dma_controller *controller = container_of(c,
 			struct ux500_dma_controller, controller);
 
+	ux500_dma_controller_stop(controller);
 	kfree(controller);
 }
 
@@ -378,6 +373,7 @@ struct dma_controller *dma_controller_create(struct musb *musb,
 	struct ux500_dma_controller *controller;
 	struct platform_device *pdev = to_platform_device(musb->controller);
 	struct resource	*iomem;
+	int ret;
 
 	controller = kzalloc(sizeof(*controller), GFP_KERNEL);
 	if (!controller)
@@ -394,14 +390,15 @@ struct dma_controller *dma_controller_create(struct musb *musb,
 
 	controller->phy_base = (dma_addr_t) iomem->start;
 
-	controller->controller.start = ux500_dma_controller_start;
-	controller->controller.stop = ux500_dma_controller_stop;
 	controller->controller.channel_alloc = ux500_dma_channel_allocate;
 	controller->controller.channel_release = ux500_dma_channel_release;
 	controller->controller.channel_program = ux500_dma_channel_program;
 	controller->controller.channel_abort = ux500_dma_channel_abort;
 	controller->controller.is_compatible = ux500_dma_is_compatible;
 
+	ret = ux500_dma_controller_start(controller);
+	if (ret)
+		goto plat_get_fail;
 	return &controller->controller;
 
 plat_get_fail:
-- 
1.8.3.2

