Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaFKI5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:57:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33041 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbaFKI5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:47 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 09/36] mtd: nand: omap: Clean up device tree support
Date: Wed, 11 Jun 2014 11:56:14 +0300
Message-ID: <1402477001-31132-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move NAND specific device tree parsing to NAND driver.

The NAND controller node must have a compatible id, register space
resource and interrupt resource.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-nand.c              |   5 +-
 arch/arm/mach-omap2/gpmc.c                   | 128 ++++++---------------------
 drivers/mtd/nand/omap2.c                     | 125 ++++++++++++++++++++++----
 include/linux/platform_data/mtd-nand-omap2.h |   6 +-
 4 files changed, 139 insertions(+), 125 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 9649fd9..f7491d0 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -127,10 +127,7 @@ int gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data,
 		}
 	}
 
-	if (gpmc_nand_data->of_node)
-		gpmc_read_settings_dt(gpmc_nand_data->of_node, &s);
-	else
-		gpmc_set_legacy(gpmc_nand_data, &s);
+	gpmc_set_legacy(gpmc_nand_data, &s);
 
 	s.device_nand = true;
 
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index a0c2194..c713616 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -29,7 +29,6 @@
 #include <linux/of_address.h>
 #include <linux/of_mtd.h>
 #include <linux/of_device.h>
-#include <linux/mtd/nand.h>
 #include <linux/pm_runtime.h>
 
 #include <linux/platform_data/mtd-nand-omap2.h>
@@ -40,7 +39,6 @@
 #include "common.h"
 #include "omap_device.h"
 #include "gpmc.h"
-#include "gpmc-nand.h"
 #include "gpmc-onenand.h"
 
 #define	DEVICE_NAME		"omap-gpmc"
@@ -1168,96 +1166,6 @@ static void __maybe_unused gpmc_read_timings_dt(struct device_node *np,
 		of_property_read_bool(np, "gpmc,time-para-granularity");
 }
 
-#if IS_ENABLED(CONFIG_MTD_NAND)
-
-static const char * const nand_xfer_types[] = {
-	[NAND_OMAP_PREFETCH_POLLED]		= "prefetch-polled",
-	[NAND_OMAP_POLLED]			= "polled",
-	[NAND_OMAP_PREFETCH_DMA]		= "prefetch-dma",
-	[NAND_OMAP_PREFETCH_IRQ]		= "prefetch-irq",
-};
-
-static int gpmc_probe_nand_child(struct platform_device *pdev,
-				 struct device_node *child)
-{
-	u32 val;
-	const char *s;
-	struct gpmc_timings gpmc_t;
-	struct omap_nand_platform_data *gpmc_nand_data;
-
-	if (of_property_read_u32(child, "reg", &val) < 0) {
-		dev_err(&pdev->dev, "%s has no 'reg' property\n",
-			child->full_name);
-		return -ENODEV;
-	}
-
-	gpmc_nand_data = devm_kzalloc(&pdev->dev, sizeof(*gpmc_nand_data),
-				      GFP_KERNEL);
-	if (!gpmc_nand_data)
-		return -ENOMEM;
-
-	gpmc_nand_data->cs = val;
-	gpmc_nand_data->of_node = child;
-
-	/* Detect availability of ELM module */
-	gpmc_nand_data->elm_of_node = of_parse_phandle(child, "ti,elm-id", 0);
-	if (gpmc_nand_data->elm_of_node == NULL)
-		gpmc_nand_data->elm_of_node =
-					of_parse_phandle(child, "elm_id", 0);
-	if (gpmc_nand_data->elm_of_node == NULL)
-		pr_warn("%s: ti,elm-id property not found\n", __func__);
-
-	/* select ecc-scheme for NAND */
-	if (of_property_read_string(child, "ti,nand-ecc-opt", &s)) {
-		pr_err("%s: ti,nand-ecc-opt not found\n", __func__);
-		return -ENODEV;
-	}
-	if (!strcmp(s, "ham1") || !strcmp(s, "sw") ||
-		!strcmp(s, "hw") || !strcmp(s, "hw-romcode"))
-		gpmc_nand_data->ecc_opt =
-				OMAP_ECC_HAM1_CODE_HW;
-	else if (!strcmp(s, "bch4"))
-		if (gpmc_nand_data->elm_of_node)
-			gpmc_nand_data->ecc_opt =
-				OMAP_ECC_BCH4_CODE_HW;
-		else
-			gpmc_nand_data->ecc_opt =
-				OMAP_ECC_BCH4_CODE_HW_DETECTION_SW;
-	else if (!strcmp(s, "bch8"))
-		if (gpmc_nand_data->elm_of_node)
-			gpmc_nand_data->ecc_opt =
-				OMAP_ECC_BCH8_CODE_HW;
-		else
-			gpmc_nand_data->ecc_opt =
-				OMAP_ECC_BCH8_CODE_HW_DETECTION_SW;
-	else
-		pr_err("%s: ti,nand-ecc-opt invalid value\n", __func__);
-
-	/* select data transfer mode for NAND controller */
-	if (!of_property_read_string(child, "ti,nand-xfer-type", &s))
-		for (val = 0; val < ARRAY_SIZE(nand_xfer_types); val++)
-			if (!strcasecmp(s, nand_xfer_types[val])) {
-				gpmc_nand_data->xfer_type = val;
-				break;
-			}
-
-	val = of_get_nand_bus_width(child);
-	if (val == 16)
-		gpmc_nand_data->devsize = NAND_BUSWIDTH_16;
-
-	gpmc_read_timings_dt(child, &gpmc_t);
-	gpmc_nand_init(gpmc_nand_data, &gpmc_t);
-
-	return 0;
-}
-#else
-static int gpmc_probe_nand_child(struct platform_device *pdev,
-				 struct device_node *child)
-{
-	return 0;
-}
-#endif
-
 #if IS_ENABLED(CONFIG_MTD_ONENAND)
 static int gpmc_probe_onenand_child(struct platform_device *pdev,
 				 struct device_node *child)
@@ -1363,9 +1271,32 @@ static int gpmc_probe_generic_child(struct platform_device *pdev,
 
 	gpmc_read_settings_dt(child, &gpmc_s);
 
-	ret = of_property_read_u32(child, "bank-width", &gpmc_s.device_width);
-	if (ret < 0)
-		goto err;
+	if (of_node_cmp(child->name, "nand") == 0) {
+		/* NAND specific setup */
+		u32 val;
+
+		val = of_get_nand_bus_width(child);
+		switch (val) {
+		case 8:
+			gpmc_s.device_width = GPMC_DEVWIDTH_8BIT;
+			break;
+		case 16:
+			gpmc_s.device_width = GPMC_DEVWIDTH_16BIT;
+			break;
+		default:
+			dev_err(&pdev->dev, "%s: invalid 'nand-bus-width'\n",
+				child->name);
+			ret = -EINVAL;
+			goto err;
+		}
+
+		gpmc_s.device_nand = true;
+	} else {
+		ret = of_property_read_u32(child, "bank-width",
+					   &gpmc_s.device_width);
+		if (ret < 0)
+			goto err;
+	}
 
 	ret = gpmc_cs_program_settings(cs, &gpmc_s);
 	if (ret < 0)
@@ -1423,13 +1354,12 @@ static int gpmc_probe_dt(struct platform_device *pdev)
 		if (!child->name)
 			continue;
 
-		if (of_node_cmp(child->name, "nand") == 0)
-			ret = gpmc_probe_nand_child(pdev, child);
-		else if (of_node_cmp(child->name, "onenand") == 0)
+		if (of_node_cmp(child->name, "onenand") == 0)
 			ret = gpmc_probe_onenand_child(pdev, child);
 		else if (of_node_cmp(child->name, "ethernet") == 0 ||
 			 of_node_cmp(child->name, "nor") == 0 ||
-			 of_node_cmp(child->name, "uart") == 0)
+			 of_node_cmp(child->name, "uart") == 0 ||
+			 of_node_cmp(child->name, "nand") == 0)
 			ret = gpmc_probe_generic_child(pdev, child);
 
 		if (WARN(ret < 0, "%s: probing gpmc child %s failed\n",
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index e205863..d343552 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_mtd.h>
 
 #include <linux/mtd/nand_bch.h>
 #include <linux/platform_data/elm.h>
@@ -1676,10 +1677,82 @@ static void gpmc_update_nand_reg(struct omap_nand_info *info)
 	}
 }
 
+static const char * const nand_xfer_types[] = {
+	[NAND_OMAP_PREFETCH_POLLED] = "prefetch-polled",
+	[NAND_OMAP_POLLED] = "polled",
+	[NAND_OMAP_PREFETCH_DMA] = "prefetch-dma",
+	[NAND_OMAP_PREFETCH_IRQ] = "prefetch-irq",
+};
+
+static int omap_get_dt_info(struct device *dev, struct omap_nand_info *info)
+{
+	struct device_node *child = dev->of_node;
+	int i;
+	const char *s;
+
+	/* In old bindings, CS num is embedded in reg property */
+	if (of_property_read_u32(child, "reg", &info->gpmc_cs) < 0) {
+		dev_err(dev, "reg not found in DT\n");
+		return -EINVAL;
+	}
+
+	/* detect availability of ELM module. Won't be present pre-OMAP4 */
+	info->elm_of_node = of_parse_phandle(child, "ti,elm-id", 0);
+	if (info->elm_of_node == NULL)
+		dev_dbg(dev, "ti,elm-id not in DT\n");
+
+	/* select ecc-scheme */
+	if (of_property_read_string(child, "ti,nand-ecc-opt", &s)) {
+		/* default to HAM1 */
+		info->ecc_opt = OMAP_ECC_HAM1_CODE_HW;
+		goto ecc_done;
+	}
+
+	if (!strcmp(s, "ham1") || !strcmp(s, "sw") ||
+	    !strcmp(s, "hw") || !strcmp(s, "hw-romcode")) {
+		info->ecc_opt = OMAP_ECC_HAM1_CODE_HW;
+
+	} else if (!strcmp(s, "bch4")) {
+		if (info->elm_of_node)
+			info->ecc_opt = OMAP_ECC_BCH4_CODE_HW;
+		else
+			info->ecc_opt = OMAP_ECC_BCH4_CODE_HW_DETECTION_SW;
+
+	} else if (!strcmp(s, "bch8")) {
+		if (info->elm_of_node)
+			info->ecc_opt = OMAP_ECC_BCH8_CODE_HW;
+		else
+			info->ecc_opt = OMAP_ECC_BCH8_CODE_HW_DETECTION_SW;
+	} else {
+		dev_err(dev, "unrecognized value for ti,nand-ecc-opt\n");
+		return -EINVAL;
+	}
+
+ecc_done:
+	/* select data transfer mode */
+	if (!of_property_read_string(child, "ti,nand-xfer-type", &s)) {
+		for (i = 0; i < ARRAY_SIZE(nand_xfer_types); i++) {
+			if (!strcasecmp(s, nand_xfer_types[i])) {
+				info->xfer_type = i;
+				goto found;
+			}
+		}
+
+		dev_err(dev, "unrecognized value for ti,nand-xfer-type\n");
+		return -EINVAL;
+	}
+
+found:
+	if (of_get_nand_bus_width(child) == 16)
+		info->devsize = NAND_BUSWIDTH_16;
+
+	return 0;
+}
+
 static int omap_nand_probe(struct platform_device *pdev)
 {
 	struct omap_nand_info *info;
-	struct omap_nand_platform_data *pdata;
+	struct omap_nand_platform_data *pdata = NULL;
 	struct mtd_info	*mtd;
 	struct nand_chip *nand_chip;
 	struct nand_ecclayout *ecclayout;
@@ -1692,31 +1765,37 @@ static int omap_nand_probe(struct platform_device *pdev)
 	struct mtd_part_parser_data ppdata = {};
 	struct device *dev = &pdev->dev;
 
-	pdata = dev_get_platdata(&pdev->dev);
-	if (pdata == NULL) {
-		dev_err(&pdev->dev, "platform data missing\n");
-		return -ENODEV;
-	}
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct omap_nand_info),
 				GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
+	info->pdev = pdev;
+
+	if (dev->of_node) {
+		if (omap_get_dt_info(dev, info))
+			return -EINVAL;
+	} else {
+		pdata = dev_get_platdata(&pdev->dev);
+		if (pdata == NULL) {
+			dev_err(&pdev->dev, "platform data missing\n");
+			return -EINVAL;
+		}
+
+		info->gpmc_cs = pdata->cs;
+		info->of_node = pdata->of_node;
+		info->ecc_opt = pdata->ecc_opt;
+		info->dev_ready	= pdata->dev_ready;
+		info->xfer_type = pdata->xfer_type;
+		info->devsize = pdata->devsize;
+	}
+
 	platform_set_drvdata(pdev, info);
 
 	spin_lock_init(&info->controller.lock);
 	init_waitqueue_head(&info->controller.wq);
 
-	info->pdev		= pdev;
-	info->gpmc_cs		= pdata->cs;
-	info->of_node		= pdata->of_node;
-	info->ecc_opt		= pdata->ecc_opt;
-	info->dev_ready	= pdata->dev_ready;
-	info->xfer_type = pdata->xfer_type;
-	info->devsize = pdata->devsize;
-	info->elm_of_node = pdata->elm_of_node;
-
 	mtd			= &info->mtd;
 	mtd->priv		= &info->nand;
 	mtd->name		= dev_name(&pdev->dev);
@@ -2067,9 +2146,13 @@ static int omap_nand_probe(struct platform_device *pdev)
 		goto return_error;
 	}
 
-	ppdata.of_node = pdata->of_node;
-	mtd_device_parse_register(mtd, NULL, &ppdata, pdata->parts,
-				  pdata->nr_parts);
+	if (dev->of_node) {
+		ppdata.of_node = dev->of_node;
+		mtd_device_parse_register(mtd, NULL, &ppdata, NULL, 0);
+
+	} else {
+		mtd_device_register(mtd, pdata->parts, pdata->nr_parts);
+	}
 
 	platform_set_drvdata(pdev, mtd);
 
@@ -2101,12 +2184,18 @@ static int omap_nand_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id omap_nand_ids[] = {
+	{ .compatible = "ti,omap2-nand", },
+	{},
+};
+
 static struct platform_driver omap_nand_driver = {
 	.probe		= omap_nand_probe,
 	.remove		= omap_nand_remove,
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(omap_nand_ids),
 	},
 };
 
diff --git a/include/linux/platform_data/mtd-nand-omap2.h b/include/linux/platform_data/mtd-nand-omap2.h
index 62a855e..45203a5 100644
--- a/include/linux/platform_data/mtd-nand-omap2.h
+++ b/include/linux/platform_data/mtd-nand-omap2.h
@@ -64,10 +64,8 @@ struct omap_nand_platform_data {
 	int			devsize;
 	enum omap_ecc           ecc_opt;
 
-	/* for passing the partitions */
-	struct device_node	*of_node;
-	struct device_node	*elm_of_node;
-
 	struct gpmc_nand_regs	reg;		/* deprecated */
+	struct device_node	*elm_of_node;	/* deprecated */
+	struct device_node	*of_node;	/* deprecated */
 };
 #endif
-- 
1.8.3.2

