Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaFKI6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:58:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56333 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbaFKI6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:31 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 19/36] mtd: onenand: omap: Use devres managed resources
Date: Wed, 11 Jun 2014 11:56:24 +0300
Message-ID: <1402477001-31132-20-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devres managed resources for Memory, GPIO and Interrupt
resources.

0 is a valid gpio, so use gpio_is_valid() to check for
valid gpio number.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/onenand/omap2.c | 92 ++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 59 deletions(-)

diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index 238dd7a..b6a9ec0 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -38,8 +38,7 @@
 #include <asm/mach/flash.h>
 #include <linux/platform_data/mtd-onenand-omap2.h>
 #include <linux/platform_data/gpmc-omap.h>
-#include <asm/gpio.h>
-
+#include <linux/gpio.h>
 #include <linux/omap-dma.h>
 
 #define DRIVER_NAME "omap2-onenand"
@@ -835,6 +834,7 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 	int r;
 	struct resource *res;
 	struct mtd_part_parser_data ppdata = {};
+	struct device *dev = &pdev->dev;
 
 	pdata = dev_get_platdata(&pdev->dev);
 	if (pdata == NULL) {
@@ -842,7 +842,7 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	c = kzalloc(sizeof(struct omap2_onenand), GFP_KERNEL);
+	c = devm_kzalloc(dev, sizeof(struct omap2_onenand), GFP_KERNEL);
 	if (!c)
 		return -ENOMEM;
 
@@ -855,50 +855,40 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 	c->dma_channel = pdata->dma_channel;
 	if (c->dma_channel < 0) {
 		/* if -1, don't use DMA */
-		c->gpio_irq = 0;
+		c->gpio_irq = -EINVAL;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		r = -EINVAL;
-		dev_err(&pdev->dev, "error getting memory resource\n");
-		goto err_kfree;
-	}
+	c->onenand.base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(c->onenand.base))
+		return PTR_ERR(c->onenand.base);
 
 	c->phys_base = res->start;
 	c->mem_size = resource_size(res);
 
-	if (request_mem_region(c->phys_base, c->mem_size,
-			       pdev->dev.driver->name) == NULL) {
-		dev_err(&pdev->dev, "Cannot reserve memory region at 0x%08lx, size: 0x%x\n",
-						c->phys_base, c->mem_size);
-		r = -EBUSY;
-		goto err_kfree;
-	}
-	c->onenand.base = ioremap(c->phys_base, c->mem_size);
-	if (c->onenand.base == NULL) {
-		r = -ENOMEM;
-		goto err_release_mem_region;
-	}
-
 	r = omap2_onenand_setup(c);
-	if (r < 0) {
-		dev_err(&pdev->dev, "setup failed:%d\n", r);
-		goto err_iounmap;
-	}
+	if (r)
+		return -ENODEV;
 
-	if (c->gpio_irq) {
-		if ((r = gpio_request(c->gpio_irq, "OneNAND irq")) < 0) {
-			dev_err(&pdev->dev,  "Failed to request GPIO%d for "
-				"OneNAND\n", c->gpio_irq);
-			goto err_iounmap;
-	}
-	gpio_direction_input(c->gpio_irq);
+	if (gpio_is_valid(c->gpio_irq)) {
+		r = devm_gpio_request(dev, c->gpio_irq, "OneNAND irq");
+		if (r) {
+			dev_err(dev, "Failed to request GPIO %d",
+				c->gpio_irq);
+			return r;
+		}
+
+		gpio_direction_input(c->gpio_irq);
 
-	if ((r = request_irq(gpio_to_irq(c->gpio_irq),
-			     omap2_onenand_interrupt, IRQF_TRIGGER_RISING,
-			     pdev->dev.driver->name, c)) < 0)
-		goto err_release_gpio;
+		r = devm_request_irq(dev, gpio_to_irq(c->gpio_irq),
+				     omap2_onenand_interrupt,
+				     IRQF_TRIGGER_RISING,
+				     pdev->dev.driver->name, c);
+		if (r) {
+			dev_err(dev, "failed to request IRQ %d:%d\n",
+				c->gpio_irq, r);
+			return r;
+		}
 	}
 
 	if (c->dma_channel >= 0) {
@@ -915,9 +905,8 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 			omap_set_dma_dest_burst_mode(c->dma_channel,
 						     OMAP_DMA_DATA_BURST_8);
 		} else {
-			dev_info(&pdev->dev,
-				 "failed to allocate DMA for OneNAND, "
-				 "using PIO instead\n");
+			dev_info(dev,
+				 "failed to allocate DMA for OneNAND, using PIO instead\n");
 			c->dma_channel = -1;
 		}
 	}
@@ -947,8 +936,11 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 	if (pdata->skip_initial_unlocking)
 		this->options |= ONENAND_SKIP_INITIAL_UNLOCKING;
 
-	if ((r = onenand_scan(&c->mtd, 1)) < 0)
+	r = onenand_scan(&c->mtd, 1);
+	if (r) {
+		dev_err(dev, "OneNAND scan failed :%d\n", r);
 		goto err_release_dma;
+	}
 
 	ppdata.of_node = pdata->of_node;
 	r = mtd_device_parse_register(&c->mtd, NULL, &ppdata,
@@ -966,17 +958,6 @@ err_release_onenand:
 err_release_dma:
 	if (c->dma_channel != -1)
 		omap_free_dma(c->dma_channel);
-	if (c->gpio_irq)
-		free_irq(gpio_to_irq(c->gpio_irq), c);
-err_release_gpio:
-	if (c->gpio_irq)
-		gpio_free(c->gpio_irq);
-err_iounmap:
-	iounmap(c->onenand.base);
-err_release_mem_region:
-	release_mem_region(c->phys_base, c->mem_size);
-err_kfree:
-	kfree(c);
 
 	return r;
 }
@@ -989,13 +970,6 @@ static int omap2_onenand_remove(struct platform_device *pdev)
 	if (c->dma_channel != -1)
 		omap_free_dma(c->dma_channel);
 	omap2_onenand_shutdown(pdev);
-	if (c->gpio_irq) {
-		free_irq(gpio_to_irq(c->gpio_irq), c);
-		gpio_free(c->gpio_irq);
-	}
-	iounmap(c->onenand.base);
-	release_mem_region(c->phys_base, c->mem_size);
-	kfree(c);
 
 	return 0;
 }
-- 
1.8.3.2

