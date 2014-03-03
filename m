Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaCCLjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:39:43 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53499 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbaCCLjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:39:39 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>, <rogerq@ti.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v5 3/6] drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
Date: Mon, 3 Mar 2014 17:08:12 +0530
Message-ID: <1393846695-14644-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393846695-14644-1-git-send-email-kishon@ti.com>
References: <1393846695-14644-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapted omap-usb3 PHY driver to Generic PHY Framework and moved phy-omap-usb3
driver in drivers/usb/phy to drivers/phy and also renamed the file to
phy-ti-pipe3 since this same driver will be used for SATA PHY and
PCIE PHY.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 .../phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c}     |  240 ++++++++++++--------
 drivers/usb/phy/Kconfig                            |   11 -
 drivers/usb/phy/Makefile                           |    1 -
 5 files changed, 158 insertions(+), 106 deletions(-)
 rename drivers/{usb/phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c} (54%)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index c7a551c..e3ec7d1 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -40,6 +40,17 @@ config OMAP_USB2
 	  The USB OTG controller communicates with the comparator using this
 	  driver.
 
+config TI_PIPE3
+	tristate "TI PIPE3 PHY Driver"
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
+	select GENERIC_PHY
+	select OMAP_CONTROL_USB
+	help
+	  Enable this to support the PIPE3 PHY that is part of TI SOCs. This
+	  driver takes care of all the PHY functionality apart from comparator.
+	  This driver interacts with the "OMAP Control PHY Driver" to power
+	  on/off the PHY.
+
 config TWL4030_USB
 	tristate "TWL4030 USB Transceiver Driver"
 	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index b57c253..32e3f94 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -8,4 +8,5 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
+obj-$(CONFIG_TI_PIPE3)			+= phy-ti-pipe3.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
diff --git a/drivers/usb/phy/phy-omap-usb3.c b/drivers/phy/phy-ti-pipe3.c
similarity index 54%
rename from drivers/usb/phy/phy-omap-usb3.c
rename to drivers/phy/phy-ti-pipe3.c
index 0c6ba29..67b189d 100644
--- a/drivers/usb/phy/phy-omap-usb3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -1,5 +1,5 @@
 /*
- * omap-usb3 - USB PHY, talking to dwc3 controller in OMAP.
+ * phy-ti-pipe3 - PIPE3 PHY driver.
  *
  * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
  * This program is free software; you can redistribute it and/or modify
@@ -19,10 +19,11 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/usb/omap_usb.h>
+#include <linux/phy/phy.h>
 #include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/io.h>
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
 #include <linux/usb/omap_control_usb.h>
@@ -52,17 +53,34 @@
 
 /*
  * This is an Empirical value that works, need to confirm the actual
- * value required for the USB3PHY_PLL_CONFIGURATION2.PLL_IDLE status
- * to be correctly reflected in the USB3PHY_PLL_STATUS register.
+ * value required for the PIPE3PHY_PLL_CONFIGURATION2.PLL_IDLE status
+ * to be correctly reflected in the PIPE3PHY_PLL_STATUS register.
  */
 # define PLL_IDLE_TIME  100;
 
-struct usb_dpll_map {
+struct pipe3_dpll_params {
+	u16	m;
+	u8	n;
+	u8	freq:3;
+	u8	sd;
+	u32	mf;
+};
+
+struct ti_pipe3 {
+	void __iomem		*pll_ctrl_base;
+	struct device		*dev;
+	struct device		*control_dev;
+	struct clk		*wkupclk;
+	struct clk		*sys_clk;
+	struct clk		*optclk;
+};
+
+struct pipe3_dpll_map {
 	unsigned long rate;
-	struct usb_dpll_params params;
+	struct pipe3_dpll_params params;
 };
 
-static struct usb_dpll_map dpll_map[] = {
+static struct pipe3_dpll_map dpll_map[] = {
 	{12000000, {1250, 5, 4, 20, 0} },	/* 12 MHz */
 	{16800000, {3125, 20, 4, 20, 0} },	/* 16.8 MHz */
 	{19200000, {1172, 8, 4, 20, 65537} },	/* 19.2 MHz */
@@ -71,7 +89,18 @@ static struct usb_dpll_map dpll_map[] = {
 	{38400000, {3125, 47, 4, 20, 92843} },	/* 38.4 MHz */
 };
 
-static struct usb_dpll_params *omap_usb3_get_dpll_params(unsigned long rate)
+static inline u32 ti_pipe3_readl(void __iomem *addr, unsigned offset)
+{
+	return __raw_readl(addr + offset);
+}
+
+static inline void ti_pipe3_writel(void __iomem *addr, unsigned offset,
+	u32 data)
+{
+	__raw_writel(data, addr + offset);
+}
+
+static struct pipe3_dpll_params *ti_pipe3_get_dpll_params(unsigned long rate)
 {
 	int i;
 
@@ -83,110 +112,123 @@ static struct usb_dpll_params *omap_usb3_get_dpll_params(unsigned long rate)
 	return NULL;
 }
 
-static int omap_usb3_suspend(struct usb_phy *x, int suspend)
+static int ti_pipe3_power_off(struct phy *x)
+{
+	struct ti_pipe3 *phy = phy_get_drvdata(x);
+	int val;
+	int timeout = PLL_IDLE_TIME;
+
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
+	val |= PLL_IDLE;
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
+
+	do {
+		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
+		if (val & PLL_TICOPWDN)
+			break;
+		udelay(5);
+	} while (--timeout);
+
+	if (!timeout) {
+		dev_err(phy->dev, "power off failed\n");
+		return -EBUSY;
+	}
+
+	omap_control_usb_phy_power(phy->control_dev, 0);
+
+	return 0;
+}
+
+static int ti_pipe3_power_on(struct phy *x)
 {
-	struct omap_usb *phy = phy_to_omapusb(x);
-	int	val;
+	struct ti_pipe3 *phy = phy_get_drvdata(x);
+	int val;
 	int timeout = PLL_IDLE_TIME;
 
-	if (suspend && !phy->is_suspended) {
-		val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
-		val |= PLL_IDLE;
-		omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
-
-		do {
-			val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
-			if (val & PLL_TICOPWDN)
-				break;
-			udelay(1);
-		} while (--timeout);
-
-		omap_control_usb_phy_power(phy->control_dev, 0);
-
-		phy->is_suspended	= 1;
-	} else if (!suspend && phy->is_suspended) {
-		phy->is_suspended	= 0;
-
-		val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
-		val &= ~PLL_IDLE;
-		omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
-
-		do {
-			val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
-			if (!(val & PLL_TICOPWDN))
-				break;
-			udelay(1);
-		} while (--timeout);
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
+	val &= ~PLL_IDLE;
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
+
+	do {
+		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
+		if (!(val & PLL_TICOPWDN))
+			break;
+		udelay(5);
+	} while (--timeout);
+
+	if (!timeout) {
+		dev_err(phy->dev, "power on failed\n");
+		return -EBUSY;
 	}
 
 	return 0;
 }
 
-static void omap_usb_dpll_relock(struct omap_usb *phy)
+static void ti_pipe3_dpll_relock(struct ti_pipe3 *phy)
 {
 	u32		val;
 	unsigned long	timeout;
 
-	omap_usb_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
 
 	timeout = jiffies + msecs_to_jiffies(20);
 	do {
-		val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
+		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
 		if (val & PLL_LOCK)
 			break;
 	} while (!WARN_ON(time_after(jiffies, timeout)));
 }
 
-static int omap_usb_dpll_lock(struct omap_usb *phy)
+static int ti_pipe3_dpll_lock(struct ti_pipe3 *phy)
 {
 	u32			val;
 	unsigned long		rate;
-	struct usb_dpll_params *dpll_params;
+	struct pipe3_dpll_params *dpll_params;
 
 	rate = clk_get_rate(phy->sys_clk);
-	dpll_params = omap_usb3_get_dpll_params(rate);
+	dpll_params = ti_pipe3_get_dpll_params(rate);
 	if (!dpll_params) {
 		dev_err(phy->dev,
 			  "No DPLL configuration for %lu Hz SYS CLK\n", rate);
 		return -EINVAL;
 	}
 
-	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
 	val &= ~PLL_REGN_MASK;
 	val |= dpll_params->n << PLL_REGN_SHIFT;
-	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
 
-	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
 	val &= ~PLL_SELFREQDCO_MASK;
 	val |= dpll_params->freq << PLL_SELFREQDCO_SHIFT;
-	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
 
-	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
 	val &= ~PLL_REGM_MASK;
 	val |= dpll_params->m << PLL_REGM_SHIFT;
-	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
 
-	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
 	val &= ~PLL_REGM_F_MASK;
 	val |= dpll_params->mf << PLL_REGM_F_SHIFT;
-	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);
 
-	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
 	val &= ~PLL_SD_MASK;
 	val |= dpll_params->sd << PLL_SD_SHIFT;
-	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
 
-	omap_usb_dpll_relock(phy);
+	ti_pipe3_dpll_relock(phy);
 
 	return 0;
 }
 
-static int omap_usb3_init(struct usb_phy *x)
+static int ti_pipe3_init(struct phy *x)
 {
-	struct omap_usb	*phy = phy_to_omapusb(x);
+	struct ti_pipe3 *phy = phy_get_drvdata(x);
 	int ret;
 
-	ret = omap_usb_dpll_lock(phy);
+	ret = ti_pipe3_dpll_lock(phy);
 	if (ret)
 		return ret;
 
@@ -195,9 +237,18 @@ static int omap_usb3_init(struct usb_phy *x)
 	return 0;
 }
 
-static int omap_usb3_probe(struct platform_device *pdev)
+static struct phy_ops ops = {
+	.init		= ti_pipe3_init,
+	.power_on	= ti_pipe3_power_on,
+	.power_off	= ti_pipe3_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static int ti_pipe3_probe(struct platform_device *pdev)
 {
-	struct omap_usb *phy;
+	struct ti_pipe3 *phy;
+	struct phy *generic_phy;
+	struct phy_provider *phy_provider;
 	struct resource *res;
 	struct device_node *node = pdev->dev.of_node;
 	struct device_node *control_node;
@@ -208,7 +259,7 @@ static int omap_usb3_probe(struct platform_device *pdev)
 
 	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
 	if (!phy) {
-		dev_err(&pdev->dev, "unable to alloc mem for OMAP USB3 PHY\n");
+		dev_err(&pdev->dev, "unable to alloc mem for TI PIPE3 PHY\n");
 		return -ENOMEM;
 	}
 
@@ -219,13 +270,6 @@ static int omap_usb3_probe(struct platform_device *pdev)
 
 	phy->dev		= &pdev->dev;
 
-	phy->phy.dev		= phy->dev;
-	phy->phy.label		= "omap-usb3";
-	phy->phy.init		= omap_usb3_init;
-	phy->phy.set_suspend	= omap_usb3_suspend;
-	phy->phy.type		= USB_PHY_TYPE_USB3;
-
-	phy->is_suspended	= 1;
 	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
 	if (IS_ERR(phy->wkupclk)) {
 		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
@@ -251,6 +295,7 @@ static int omap_usb3_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to get control device phandle\n");
 		return -EINVAL;
 	}
+
 	control_pdev = of_find_device_by_node(control_node);
 	if (!control_pdev) {
 		dev_err(&pdev->dev, "Failed to get control device\n");
@@ -260,23 +305,31 @@ static int omap_usb3_probe(struct platform_device *pdev)
 	phy->control_dev = &control_pdev->dev;
 
 	omap_control_usb_phy_power(phy->control_dev, 0);
-	usb_add_phy_dev(&phy->phy);
 
 	platform_set_drvdata(pdev, phy);
-
 	pm_runtime_enable(phy->dev);
+
+	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
+	if (IS_ERR(generic_phy))
+		return PTR_ERR(generic_phy);
+
+	phy_set_drvdata(generic_phy, phy);
+	phy_provider = devm_of_phy_provider_register(phy->dev,
+			of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
 	pm_runtime_get(&pdev->dev);
 
 	return 0;
 }
 
-static int omap_usb3_remove(struct platform_device *pdev)
+static int ti_pipe3_remove(struct platform_device *pdev)
 {
-	struct omap_usb *phy = platform_get_drvdata(pdev);
+	struct ti_pipe3 *phy = platform_get_drvdata(pdev);
 
 	clk_unprepare(phy->wkupclk);
 	clk_unprepare(phy->optclk);
-	usb_remove_phy(&phy->phy);
 	if (!pm_runtime_suspended(&pdev->dev))
 		pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -286,10 +339,9 @@ static int omap_usb3_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_PM_RUNTIME
 
-static int omap_usb3_runtime_suspend(struct device *dev)
+static int ti_pipe3_runtime_suspend(struct device *dev)
 {
-	struct platform_device	*pdev = to_platform_device(dev);
-	struct omap_usb	*phy = platform_get_drvdata(pdev);
+	struct ti_pipe3	*phy = dev_get_drvdata(dev);
 
 	clk_disable(phy->wkupclk);
 	clk_disable(phy->optclk);
@@ -297,11 +349,10 @@ static int omap_usb3_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int omap_usb3_runtime_resume(struct device *dev)
+static int ti_pipe3_runtime_resume(struct device *dev)
 {
 	u32 ret = 0;
-	struct platform_device	*pdev = to_platform_device(dev);
-	struct omap_usb	*phy = platform_get_drvdata(pdev);
+	struct ti_pipe3	*phy = dev_get_drvdata(dev);
 
 	ret = clk_enable(phy->optclk);
 	if (ret) {
@@ -324,38 +375,39 @@ err1:
 	return ret;
 }
 
-static const struct dev_pm_ops omap_usb3_pm_ops = {
-	SET_RUNTIME_PM_OPS(omap_usb3_runtime_suspend, omap_usb3_runtime_resume,
-		NULL)
+static const struct dev_pm_ops ti_pipe3_pm_ops = {
+	SET_RUNTIME_PM_OPS(ti_pipe3_runtime_suspend,
+		ti_pipe3_runtime_resume, NULL)
 };
 
-#define DEV_PM_OPS     (&omap_usb3_pm_ops)
+#define DEV_PM_OPS     (&ti_pipe3_pm_ops)
 #else
 #define DEV_PM_OPS     NULL
 #endif
 
 #ifdef CONFIG_OF
-static const struct of_device_id omap_usb3_id_table[] = {
+static const struct of_device_id ti_pipe3_id_table[] = {
+	{ .compatible = "ti,phy-usb3" },
 	{ .compatible = "ti,omap-usb3" },
 	{}
 };
-MODULE_DEVICE_TABLE(of, omap_usb3_id_table);
+MODULE_DEVICE_TABLE(of, ti_pipe3_id_table);
 #endif
 
-static struct platform_driver omap_usb3_driver = {
-	.probe		= omap_usb3_probe,
-	.remove		= omap_usb3_remove,
+static struct platform_driver ti_pipe3_driver = {
+	.probe		= ti_pipe3_probe,
+	.remove		= ti_pipe3_remove,
 	.driver		= {
-		.name	= "omap-usb3",
+		.name	= "ti-pipe3",
 		.owner	= THIS_MODULE,
 		.pm	= DEV_PM_OPS,
-		.of_match_table = of_match_ptr(omap_usb3_id_table),
+		.of_match_table = of_match_ptr(ti_pipe3_id_table),
 	},
 };
 
-module_platform_driver(omap_usb3_driver);
+module_platform_driver(ti_pipe3_driver);
 
-MODULE_ALIAS("platform: omap_usb3");
+MODULE_ALIAS("platform: ti_pipe3");
 MODULE_AUTHOR("Texas Instruments Inc.");
-MODULE_DESCRIPTION("OMAP USB3 phy driver");
+MODULE_DESCRIPTION("TI PIPE3 phy driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 7d1451d..c337ba2 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -85,17 +85,6 @@ config OMAP_CONTROL_USB
 	  power on the USB2 PHY is present in OMAP4 and OMAP5. OMAP5 has an
 	  additional register to power on USB3 PHY.
 
-config OMAP_USB3
-	tristate "OMAP USB3 PHY Driver"
-	depends on ARCH_OMAP2PLUS || COMPILE_TEST
-	select OMAP_CONTROL_USB
-	select USB_PHY
-	help
-	  Enable this to support the USB3 PHY that is part of SOC. This
-	  driver takes care of all the PHY functionality apart from comparator.
-	  This driver interacts with the "OMAP Control USB Driver" to power
-	  on/off the PHY.
-
 config AM335X_CONTROL_USB
 	tristate
 
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index be58ada..15f1878 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
 obj-$(CONFIG_AM335X_CONTROL_USB)	+= phy-am335x-control.o
 obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
 obj-$(CONFIG_OMAP_OTG)			+= phy-omap-otg.o
-obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
 obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
 obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
 obj-$(CONFIG_SAMSUNG_USB3PHY)		+= phy-samsung-usb3.o
-- 
1.7.9.5

