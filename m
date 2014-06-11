Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaFKI6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:58:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56335 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaFKI6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:31 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 20/36] mtd: onenand: omap: Clean up device tree support
Date: Wed, 11 Jun 2014 11:56:25 +0300
Message-ID: <1402477001-31132-21-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move OneNAND specific device tree parsing to NAND driver.
The OneNAND device node must have its own compatible id.

Add a new property 'ti,onenand-sync-rw' to indicate
synchronous read + write support. Default mode would be
only synchronous reads.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/mtd/gpmc-onenand.txt       |  4 +
 arch/arm/mach-omap2/gpmc-onenand.c                 | 14 ----
 arch/arm/mach-omap2/gpmc.c                         | 55 +++----------
 drivers/mtd/onenand/omap2.c                        | 90 ++++++++++++++++------
 include/linux/platform_data/mtd-onenand-omap2.h    |  4 +-
 5 files changed, 84 insertions(+), 83 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/gpmc-onenand.txt b/Documentation/devicetree/bindings/mtd/gpmc-onenand.txt
index b752942..7fc9c13 100644
--- a/Documentation/devicetree/bindings/mtd/gpmc-onenand.txt
+++ b/Documentation/devicetree/bindings/mtd/gpmc-onenand.txt
@@ -9,9 +9,12 @@ Documentation/devicetree/bindings/bus/ti-gpmc.txt
 
 Required properties:
 
+ - compatible:		"ti,omap2-onenand"
  - reg:			The CS line the peripheral is connected to
  - gpmc,device-width	Width of the ONENAND device connected to the GPMC
 			in bytes. Must be 1 or 2.
+ - ti,onenand-sync-rw:	Bool. Enable synchronous Read and Write. If not
+			present, only Synchronous Read is enabled.
 
 Optional properties:
 
@@ -35,6 +38,7 @@ Example for an OMAP3430 board:
 		#size-cells = <1>;
 
 		onenand@0 {
+			compatible = "ti,omap2-onenand"
 			reg = <0 0 0>; /* CS0, offset 0 */
 			gpmc,device-width = <2>;
 
diff --git a/arch/arm/mach-omap2/gpmc-onenand.c b/arch/arm/mach-omap2/gpmc-onenand.c
index d09c342..37ed4f1 100644
--- a/arch/arm/mach-omap2/gpmc-onenand.c
+++ b/arch/arm/mach-omap2/gpmc-onenand.c
@@ -75,20 +75,6 @@ static int omap2_onenand_setup_async(struct omap_onenand_platform_data
 	struct gpmc_device_timings dev_t;
 	int ret;
 
-	if (gpmc_onenand_data->of_node) {
-		gpmc_read_settings_dt(gpmc_onenand_data->of_node,
-				      &onenand_async);
-		if (onenand_async.sync_read || onenand_async.sync_write) {
-			if (onenand_async.sync_write)
-				gpmc_onenand_data->flags |=
-					ONENAND_SYNC_READWRITE;
-			else
-				gpmc_onenand_data->flags |= ONENAND_SYNC_READ;
-			onenand_async.sync_read = false;
-			onenand_async.sync_write = false;
-		}
-	}
-
 	ret = gpmc_cs_program_settings(gpmc_onenand_data->cs, &onenand_async);
 	if (ret < 0)
 		return ret;
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 50ef1a9..ee030cd 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -39,7 +39,6 @@
 #include "common.h"
 #include "omap_device.h"
 #include "gpmc.h"
-#include "gpmc-onenand.h"
 
 #define	DEVICE_NAME		"omap-gpmc"
 
@@ -1166,43 +1165,6 @@ static void __maybe_unused gpmc_read_timings_dt(struct device_node *np,
 		of_property_read_bool(np, "gpmc,time-para-granularity");
 }
 
-#if IS_ENABLED(CONFIG_MTD_ONENAND)
-static int gpmc_probe_onenand_child(struct platform_device *pdev,
-				 struct device_node *child)
-{
-	u32 val;
-	struct omap_onenand_platform_data *gpmc_onenand_data;
-
-	if (of_property_read_u32(child, "reg", &val) < 0) {
-		dev_err(&pdev->dev, "%s has no 'reg' property\n",
-			child->full_name);
-		return -ENODEV;
-	}
-
-	gpmc_onenand_data = devm_kzalloc(&pdev->dev, sizeof(*gpmc_onenand_data),
-					 GFP_KERNEL);
-	if (!gpmc_onenand_data)
-		return -ENOMEM;
-
-	gpmc_onenand_data->cs = val;
-	gpmc_onenand_data->of_node = child;
-	gpmc_onenand_data->dma_channel = -1;
-
-	if (!of_property_read_u32(child, "dma-channel", &val))
-		gpmc_onenand_data->dma_channel = val;
-
-	gpmc_onenand_init(gpmc_onenand_data);
-
-	return 0;
-}
-#else
-static int gpmc_probe_onenand_child(struct platform_device *pdev,
-				    struct device_node *child)
-{
-	return 0;
-}
-#endif
-
 /**
  * gpmc_probe_generic_child - configures the gpmc for a child device
  * @pdev:	pointer to gpmc platform device
@@ -1292,6 +1254,12 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
 		}
 
 		gpmc_s.device_nand = true;
+
+	} else if (of_node_cmp(child->name, "onenand") == 0) {
+		/* DT incorrectly sets sync modes, onenand default is async */
+		gpmc_s.sync_read = false;
+		gpmc_s.sync_write = false;
+
 	} else {
 		if (of_property_read_u32(child, "bank-width",
 					 &gpmc_s.device_width)) {
@@ -1363,12 +1331,11 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 		if (!child->name)
 			continue;
 
-		if (of_node_cmp(child->name, "onenand") == 0)
-			ret = gpmc_probe_onenand_child(pdev, child);
-		else if (of_node_cmp(child->name, "ethernet") == 0 ||
-			 of_node_cmp(child->name, "nor") == 0 ||
-			 of_node_cmp(child->name, "uart") == 0 ||
-			 of_node_cmp(child->name, "nand") == 0)
+		if (of_node_cmp(child->name, "ethernet") == 0 ||
+		    of_node_cmp(child->name, "nor") == 0 ||
+		    of_node_cmp(child->name, "uart") == 0 ||
+		    of_node_cmp(child->name, "nand") == 0 ||
+		    of_node_cmp(child->name, "onenand") == 0)
 			ret = gpmc_probe_generic_child(pdev, child);
 
 		if (WARN(ret < 0, "%s: probing gpmc child %s failed\n",
diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index b6a9ec0..35d2d39 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -40,6 +40,10 @@
 #include <linux/platform_data/gpmc-omap.h>
 #include <linux/gpio.h>
 #include <linux/omap-dma.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_mtd.h>
+#include <linux/of_gpio.h>
 
 #define DRIVER_NAME "omap2-onenand"
 
@@ -826,9 +830,33 @@ static void omap2_onenand_shutdown(struct platform_device *pdev)
 	memset((__force void *)c->onenand.base, 0, ONENAND_BUFRAM_SIZE);
 }
 
+static int omap2_onenand_get_dt_info(struct device *dev,
+				     struct omap2_onenand *c)
+{
+	struct device_node *node = dev->of_node;
+
+	/* Chip Select number */
+	if (of_property_read_u32(node, "reg", &c->gpmc_cs) < 0) {
+		dev_err(dev, "No 'reg' property\n");
+		return -EINVAL;
+	}
+
+	/* Enable synchronous read by default */
+	c->flags = ONENAND_SYNC_READ;
+	/* Enable synchronous write only if indicated by DT */
+	if (of_property_read_bool(node, "ti,onenand-sync-rw"))
+		c->flags = ONENAND_SYNC_READWRITE;
+
+	/* TODO: DMA channel, GPIO IRQ for wait */
+	c->dma_channel = -1;
+	c->gpio_irq = -EINVAL;
+
+	return 0;
+}
+
 static int omap2_onenand_probe(struct platform_device *pdev)
 {
-	struct omap_onenand_platform_data *pdata;
+	struct omap_onenand_platform_data *pdata = NULL;
 	struct omap2_onenand *c;
 	struct onenand_chip *this;
 	int r;
@@ -836,28 +864,40 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 	struct mtd_part_parser_data ppdata = {};
 	struct device *dev = &pdev->dev;
 
-	pdata = dev_get_platdata(&pdev->dev);
-	if (pdata == NULL) {
-		dev_err(&pdev->dev, "platform data missing\n");
-		return -ENODEV;
-	}
-
 	c = devm_kzalloc(dev, sizeof(struct omap2_onenand), GFP_KERNEL);
 	if (!c)
 		return -ENOMEM;
 
-	init_completion(&c->irq_done);
-	init_completion(&c->dma_done);
-	c->pdev = pdev;
-	c->flags = pdata->flags;
-	c->gpmc_cs = pdata->cs;
-	c->gpio_irq = pdata->gpio_irq;
-	c->dma_channel = pdata->dma_channel;
+	this = &c->onenand;
+
+	if (dev->of_node) {
+		if (omap2_onenand_get_dt_info(dev, c))
+			return -EINVAL;
+
+	} else {
+		pdata = dev_get_platdata(dev);
+		if (pdata == NULL) {
+			dev_err(dev, "platform data missing\n");
+			return -ENODEV;
+		}
+
+		c->flags = pdata->flags;
+		c->gpio_irq = pdata->gpio_irq;
+		c->dma_channel = pdata->dma_channel;
+
+		if (pdata->skip_initial_unlocking)
+			this->options |= ONENAND_SKIP_INITIAL_UNLOCKING;
+	}
+
 	if (c->dma_channel < 0) {
 		/* if -1, don't use DMA */
 		c->gpio_irq = -EINVAL;
 	}
 
+	init_completion(&c->irq_done);
+	init_completion(&c->dma_done);
+	c->pdev = pdev;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	c->onenand.base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(c->onenand.base))
@@ -921,7 +961,6 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 
 	c->mtd.dev.parent = &pdev->dev;
 
-	this = &c->onenand;
 	if (c->dma_channel >= 0) {
 		this->wait = omap2_onenand_wait;
 		if (c->flags & ONENAND_IN_OMAP34XX) {
@@ -933,19 +972,20 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (pdata->skip_initial_unlocking)
-		this->options |= ONENAND_SKIP_INITIAL_UNLOCKING;
-
 	r = onenand_scan(&c->mtd, 1);
 	if (r) {
 		dev_err(dev, "OneNAND scan failed :%d\n", r);
 		goto err_release_dma;
 	}
 
-	ppdata.of_node = pdata->of_node;
-	r = mtd_device_parse_register(&c->mtd, NULL, &ppdata,
-				      pdata ? pdata->parts : NULL,
-				      pdata ? pdata->nr_parts : 0);
+	if (dev->of_node) {
+		ppdata.of_node = dev->of_node;
+		r = mtd_device_parse_register(&c->mtd, NULL, &ppdata, NULL, 0);
+
+	} else {
+		r = mtd_device_register(&c->mtd, pdata->parts, pdata->nr_parts);
+	}
+
 	if (r)
 		goto err_release_onenand;
 
@@ -974,6 +1014,11 @@ static int omap2_onenand_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id omap2_onenand_ids[] = {
+	{ .compatible = "ti,omap2-onenand", },
+	{},
+};
+
 static struct platform_driver omap2_onenand_driver = {
 	.probe		= omap2_onenand_probe,
 	.remove		= omap2_onenand_remove,
@@ -981,6 +1026,7 @@ static struct platform_driver omap2_onenand_driver = {
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner  = THIS_MODULE,
+		.of_match_table = of_match_ptr(omap2_onenand_ids),
 	},
 };
 
diff --git a/include/linux/platform_data/mtd-onenand-omap2.h b/include/linux/platform_data/mtd-onenand-omap2.h
index ac1e6f3..99d8716 100644
--- a/include/linux/platform_data/mtd-onenand-omap2.h
+++ b/include/linux/platform_data/mtd-onenand-omap2.h
@@ -26,10 +26,8 @@ struct omap_onenand_platform_data {
 	u8			flags;
 	u8			skip_initial_unlocking;
 
-	/* for passing the partitions */
-	struct device_node	*of_node;
-
 	u8			regulator_can_sleep;	/* deprecated */
 	int (*onenand_setup)(void __iomem *, int *freq_ptr);	/* deprecated */
+	struct device_node	*of_node;		/* deprecated */
 };
 #endif
-- 
1.8.3.2

