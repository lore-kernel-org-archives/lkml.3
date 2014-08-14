Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaHNOYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:24:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35239 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbaHNOYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:24:37 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, balbi@ti.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, jg1.han@samsung.com, s.nawrocki@samsung.com,
        k.debski@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH RFC 5/7] usb-phy: samsung-usb2: Clean up to leave only S3C64XX support
Date: Thu, 14 Aug 2014 19:53:58 +0530
Message-Id: <1408026240-28365-6-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
References: <1408026240-28365-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up the driver further to enable only S3C64XX phy support,
while the support for rest all SoCs is removed in previous patches.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 - In the changes that have been left for S3C64XX, we have added DT based
   pmu-isolation support for S3C64XX boards too, wherein they get system-controller
   register offset and update the PHY control bit using regmap.

 drivers/usb/phy/Kconfig            |    8 --
 drivers/usb/phy/Makefile           |    1 -
 drivers/usb/phy/phy-samsung-usb.c  |  157 ---------------------------------
 drivers/usb/phy/phy-samsung-usb.h  |  148 -------------------------------
 drivers/usb/phy/phy-samsung-usb2.c |  170 ++++++++++++++++++------------------
 drivers/usb/phy/phy-samsung-usb2.h |  121 +++++++++++++++++++++++++
 6 files changed, 205 insertions(+), 400 deletions(-)
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb.h
 create mode 100644 drivers/usb/phy/phy-samsung-usb2.h

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 751b594..415d0fb 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -71,16 +71,8 @@ config AM335X_PHY_USB
 	  This driver provides PHY support for that phy which part for the
 	  AM335x SoC.
 
-config SAMSUNG_USBPHY
-	tristate
-	help
-	  Enable this to support Samsung USB phy helper driver for Samsung SoCs.
-	  This driver provides common interface to interact, for Samsung USB 2.0 PHY
-	  driver and later for Samsung USB 3.0 PHY driver.
-
 config SAMSUNG_USB2PHY
 	tristate "Samsung USB 2.0 PHY controller Driver"
-	select SAMSUNG_USBPHY
 	select USB_PHY
 	help
 	  Enable this to support Samsung USB 2.0 (High Speed) PHY controller
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 9c984dd..0b9c734 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_TAHVO_USB)			+= phy-tahvo.o
 obj-$(CONFIG_AM335X_CONTROL_USB)	+= phy-am335x-control.o
 obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
 obj-$(CONFIG_OMAP_OTG)			+= phy-omap-otg.o
-obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
 obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
 obj-$(CONFIG_TWL6030_USB)		+= phy-twl6030-usb.o
 obj-$(CONFIG_USB_EHCI_TEGRA)		+= phy-tegra-usb.o
diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
deleted file mode 100644
index 51c4102..0000000
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ /dev/null
@@ -1,157 +0,0 @@
-/* linux/drivers/usb/phy/phy-samsung-usb.c
- *
- * Copyright (c) 2012 Samsung Electronics Co., Ltd.
- *              http://www.samsung.com
- *
- * Author: Praveen Paneri <p.paneri@samsung.com>
- *
- * Samsung USB-PHY helper driver with common function calls;
- * interacts with Samsung USB 2.0 PHY controller driver and later
- * with Samsung USB 3.0 PHY driver.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/usb/samsung_usb_phy.h>
-
-#include "phy-samsung-usb.h"
-
-int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
-{
-	struct device_node *usbphy_sys;
-
-	/* Getting node for system controller interface for usb-phy */
-	usbphy_sys = of_get_child_by_name(sphy->dev->of_node, "usbphy-sys");
-	if (!usbphy_sys) {
-		dev_err(sphy->dev, "No sys-controller interface for usb-phy\n");
-		return -ENODEV;
-	}
-
-	sphy->pmuregs = of_iomap(usbphy_sys, 0);
-
-	if (sphy->pmuregs == NULL) {
-		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
-		goto err0;
-	}
-
-	sphy->sysreg = of_iomap(usbphy_sys, 1);
-
-	/*
-	 * Not returning error code here, since this situation is not fatal.
-	 * Few SoCs may not have this switch available
-	 */
-	if (sphy->sysreg == NULL)
-		dev_warn(sphy->dev, "Can't get usb-phy sysreg cfg register\n");
-
-	of_node_put(usbphy_sys);
-
-	return 0;
-
-err0:
-	of_node_put(usbphy_sys);
-	return -ENXIO;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_parse_dt);
-
-/*
- * Configure the mode of working of usb-phy here: HOST/DEVICE.
- */
-void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
-{
-	u32 reg;
-
-	if (!sphy->sysreg) {
-		dev_warn(sphy->dev, "Can't configure specified phy mode\n");
-		return;
-	}
-
-	reg = readl(sphy->sysreg);
-
-	if (sphy->phy_type == USB_PHY_TYPE_DEVICE)
-		reg &= ~EXYNOS_USB20PHY_CFG_HOST_LINK;
-	else if (sphy->phy_type == USB_PHY_TYPE_HOST)
-		reg |= EXYNOS_USB20PHY_CFG_HOST_LINK;
-
-	writel(reg, sphy->sysreg);
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_cfg_sel);
-
-/*
- * PHYs are different for USB Device and USB Host.
- * This make sure that correct PHY type is selected before
- * any operation on PHY.
- */
-int samsung_usbphy_set_type(struct usb_phy *phy,
-				enum samsung_usb_phy_type phy_type)
-{
-	struct samsung_usbphy *sphy = phy_to_sphy(phy);
-
-	sphy->phy_type = phy_type;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_set_type);
-
-int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
-							unsigned long rate)
-{
-	unsigned int clksel;
-
-	switch (rate) {
-	case 12 * MHZ:
-		clksel = PHYCLK_CLKSEL_12M;
-		break;
-	case 24 * MHZ:
-		clksel = PHYCLK_CLKSEL_24M;
-		break;
-	case 48 * MHZ:
-		clksel = PHYCLK_CLKSEL_48M;
-		break;
-	default:
-		dev_err(sphy->dev,
-			"Invalid reference clock frequency: %lu\n", rate);
-		return -EINVAL;
-	}
-
-	return clksel;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_rate_to_clksel_64xx);
-
-/*
- * Returns reference clock frequency selection value
- */
-int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
-{
-	struct clk *ref_clk;
-	unsigned long rate;
-	int refclk_freq;
-
-	ref_clk = clk_get(sphy->dev, "xusbxti");
-	if (IS_ERR(ref_clk)) {
-		dev_err(sphy->dev, "Failed to get reference clock\n");
-		return PTR_ERR(ref_clk);
-	}
-
-	rate = clk_get_rate(ref_clk);
-	refclk_freq = sphy->drv_data->rate_to_clksel(sphy, rate);
-
-	clk_put(ref_clk);
-
-	return refclk_freq;
-}
-EXPORT_SYMBOL_GPL(samsung_usbphy_get_refclk_freq);
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
deleted file mode 100644
index b36fd88..0000000
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ /dev/null
@@ -1,148 +0,0 @@
-/* linux/drivers/usb/phy/phy-samsung-usb.h
- *
- * Copyright (c) 2012 Samsung Electronics Co., Ltd.
- *              http://www.samsung.com
- *
- * Samsung USB-PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
- * OHCI-EXYNOS controllers.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/usb/phy.h>
-
-/* Register definitions */
-
-#define SAMSUNG_PHYPWR				(0x00)
-
-#define PHYPWR_NORMAL_MASK			(0x19 << 0)
-#define PHYPWR_OTG_DISABLE			(0x1 << 4)
-#define PHYPWR_ANALOG_POWERDOWN			(0x1 << 3)
-#define PHYPWR_FORCE_SUSPEND			(0x1 << 1)
-/* For Exynos4 */
-#define PHYPWR_NORMAL_MASK_PHY0			(0x39 << 0)
-#define PHYPWR_SLEEP_PHY0			(0x1 << 5)
-
-#define SAMSUNG_PHYCLK				(0x04)
-
-#define PHYCLK_MODE_USB11			(0x1 << 6)
-#define PHYCLK_EXT_OSC				(0x1 << 5)
-#define PHYCLK_COMMON_ON_N			(0x1 << 4)
-#define PHYCLK_ID_PULL				(0x1 << 2)
-#define PHYCLK_CLKSEL_MASK			(0x3 << 0)
-#define PHYCLK_CLKSEL_48M			(0x0 << 0)
-#define PHYCLK_CLKSEL_12M			(0x2 << 0)
-#define PHYCLK_CLKSEL_24M			(0x3 << 0)
-
-#define SAMSUNG_RSTCON				(0x08)
-
-#define RSTCON_PHYLINK_SWRST			(0x1 << 2)
-#define RSTCON_HLINK_SWRST			(0x1 << 1)
-#define RSTCON_SWRST				(0x1 << 0)
-
-#ifndef MHZ
-#define MHZ (1000*1000)
-#endif
-
-#define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
-#define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
-
-enum samsung_cpu_type {
-	TYPE_S3C64XX,
-};
-
-struct samsung_usbphy;
-
-/*
- * struct samsung_usbphy_drvdata - driver data for various SoC variants
- * @cpu_type: machine identifier
- * @devphy_en_mask: device phy enable mask for PHY CONTROL register
- * @hostphy_en_mask: host phy enable mask for PHY CONTROL register
- * @devphy_reg_offset: offset to DEVICE PHY CONTROL register from
- *		       mapped address of system controller.
- * @hostphy_reg_offset: offset to HOST PHY CONTROL register from
- *		       mapped address of system controller.
- *
- *	Here we have a separate mask for device type phy.
- *	Having different masks for host and device type phy helps
- *	in setting independent masks in case of SoCs like S5PV210,
- *	in which PHY0 and PHY1 enable bits belong to same register
- *	placed at position 0 and 1 respectively.
- *	Although for newer SoCs like exynos these bits belong to
- *	different registers altogether placed at position 0.
- */
-struct samsung_usbphy_drvdata {
-	int cpu_type;
-	int devphy_en_mask;
-	int hostphy_en_mask;
-	u32 devphy_reg_offset;
-	u32 hostphy_reg_offset;
-	int (*rate_to_clksel)(struct samsung_usbphy *, unsigned long);
-	void (*set_isolation)(struct samsung_usbphy *, bool);
-	void (*phy_enable)(struct samsung_usbphy *);
-	void (*phy_disable)(struct samsung_usbphy *);
-};
-
-/*
- * struct samsung_usbphy - transceiver driver state
- * @phy: transceiver structure
- * @plat: platform data
- * @dev: The parent device supplied to the probe function
- * @clk: usb phy clock
- * @regs: usb phy controller registers memory base
- * @pmuregs: USB device PHY_CONTROL register memory base
- * @sysreg: USB2.0 PHY_CFG register memory base
- * @ref_clk_freq: reference clock frequency selection
- * @drv_data: driver data available for different SoCs
- * @phy_type: Samsung SoCs specific phy types:	#HOST
- *						#DEVICE
- * @phy_usage: usage count for phy
- * @lock: lock for phy operations
- */
-struct samsung_usbphy {
-	struct usb_phy	phy;
-	struct samsung_usbphy_data *plat;
-	struct device	*dev;
-	struct clk	*clk;
-	void __iomem	*regs;
-	void __iomem	*pmuregs;
-	void __iomem	*sysreg;
-	int		ref_clk_freq;
-	const struct samsung_usbphy_drvdata *drv_data;
-	enum samsung_usb_phy_type phy_type;
-	atomic_t	phy_usage;
-	spinlock_t	lock;
-};
-
-#define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
-
-static const struct of_device_id samsung_usbphy_dt_match[];
-
-static inline const struct samsung_usbphy_drvdata
-*samsung_usbphy_get_driver_data(struct platform_device *pdev)
-{
-	if (pdev->dev.of_node) {
-		const struct of_device_id *match;
-		match = of_match_node(samsung_usbphy_dt_match,
-							pdev->dev.of_node);
-		return match->data;
-	}
-
-	return (struct samsung_usbphy_drvdata *)
-				platform_get_device_id(pdev)->driver_data;
-}
-
-extern int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy);
-extern void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy);
-extern int samsung_usbphy_set_type(struct usb_phy *phy,
-					enum samsung_usb_phy_type phy_type);
-extern int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy);
-extern int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
-							unsigned long rate);
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 2bcc948..2395b92 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -25,71 +25,108 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/mfd/syscon.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
-#include "phy-samsung-usb.h"
+#include "phy-samsung-usb2.h"
 
-static int samsung_usbphy_set_host(struct usb_otg *otg, struct usb_bus *host)
+static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, bool on)
 {
-	if (!otg)
-		return -ENODEV;
+	unsigned int val;
 
-	if (!otg->host)
-		otg->host = host;
+	if (!sphy->syscon_reg)
+		return;
 
-	return 0;
+	val = on ? 0 : MISC_CTRL_USB_SIG_MASK;
+
+	regmap_update_bits(sphy->syscon_reg, sphy->drv_data->devphy_reg_offset,
+			   MISC_CTRL_USB_SIG_MASK, val);
+}
+
+static int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
+							unsigned long rate)
+{
+	unsigned int clksel;
+
+	switch (rate) {
+	case 12 * MHZ:
+		clksel = PHYCLK_CLKSEL_12M;
+		break;
+	case 24 * MHZ:
+		clksel = PHYCLK_CLKSEL_24M;
+		break;
+	case 48 * MHZ:
+		clksel = PHYCLK_CLKSEL_48M;
+		break;
+	default:
+		dev_err(sphy->dev,
+			"Invalid reference clock frequency: %lu\n", rate);
+		return -EINVAL;
+	}
+
+	return clksel;
+}
+
+/*
+ * Returns reference clock frequency selection value
+ */
+static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
+{
+	struct clk *ref_clk;
+	unsigned long rate;
+	int refclk_freq;
+
+	ref_clk = clk_get(sphy->dev, "xusbxti");
+	if (IS_ERR(ref_clk)) {
+		dev_err(sphy->dev, "Failed to get reference clock\n");
+		return PTR_ERR(ref_clk);
+	}
+
+	rate = clk_get_rate(ref_clk);
+	refclk_freq = sphy->drv_data->rate_to_clksel(sphy, rate);
+
+	clk_put(ref_clk);
+
+	return refclk_freq;
 }
 
 static void samsung_usb2phy_enable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
-	u32 phypwr;
-	u32 phyclk;
-	u32 rstcon;
+	u32 reg_val;
 
+	reg_val = sphy->ref_clk_freq;
 	/* set clock frequency for PLL */
-	phyclk = sphy->ref_clk_freq;
-	phypwr = readl(regs + SAMSUNG_PHYPWR);
-	rstcon = readl(regs + SAMSUNG_RSTCON);
-
-	switch (sphy->drv_data->cpu_type) {
-	case TYPE_S3C64XX:
-		phyclk &= ~PHYCLK_COMMON_ON_N;
-		phypwr &= ~PHYPWR_NORMAL_MASK;
-		rstcon |= RSTCON_SWRST;
-	default:
-		break;
-	}
+	reg_val &= ~PHYCLK_COMMON_ON_N;
+	writel(reg_val, regs + SAMSUNG_PHYCLK);
 
-	writel(phyclk, regs + SAMSUNG_PHYCLK);
+	reg_val = readl(regs + SAMSUNG_PHYPWR);
 	/* Configure PHY0 for normal operation*/
-	writel(phypwr, regs + SAMSUNG_PHYPWR);
+	reg_val &= ~PHYPWR_NORMAL_MASK;
+	writel(reg_val, regs + SAMSUNG_PHYPWR);
+
+	reg_val = readl(regs + SAMSUNG_RSTCON);
 	/* reset all ports of PHY and Link */
-	writel(rstcon, regs + SAMSUNG_RSTCON);
+	reg_val |= RSTCON_SWRST;
+	writel(reg_val, regs + SAMSUNG_RSTCON);
 	udelay(10);
-	rstcon &= ~RSTCON_SWRST;
-	writel(rstcon, regs + SAMSUNG_RSTCON);
+	reg_val &= ~RSTCON_SWRST;
+	writel(reg_val, regs + SAMSUNG_RSTCON);
 }
 
 static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
 {
 	void __iomem *regs = sphy->regs;
-	u32 phypwr;
-
-	phypwr = readl(regs + SAMSUNG_PHYPWR);
-
-	switch (sphy->drv_data->cpu_type) {
-	case TYPE_S3C64XX:
-		phypwr |= PHYPWR_NORMAL_MASK;
-	default:
-		break;
-	}
+	u32 reg_val;
 
+	reg_val = readl(regs + SAMSUNG_PHYPWR);
 	/* Disable analog and otg block power */
-	writel(phypwr, regs + SAMSUNG_PHYPWR);
+	reg_val |= PHYPWR_NORMAL_MASK;
+	writel(reg_val, regs + SAMSUNG_PHYPWR);
 }
 
 /*
@@ -98,14 +135,11 @@ static void samsung_usb2phy_disable(struct samsung_usbphy *sphy)
 static int samsung_usb2phy_init(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
-	struct usb_bus *host = NULL;
 	unsigned long flags;
 	int ret = 0;
 
 	sphy = phy_to_sphy(phy);
 
-	host = phy->otg->host;
-
 	/* Enable the phy clock */
 	ret = clk_prepare_enable(sphy->clk);
 	if (ret) {
@@ -115,24 +149,12 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
-	if (host) {
-		/* setting default phy-type for USB 2.0 */
-		if (!strstr(dev_name(host->controller), "ehci") ||
-				!strstr(dev_name(host->controller), "ohci"))
-			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
-	} else {
-		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-	}
-
 	/* Disable phy isolation */
 	if (sphy->plat && sphy->plat->pmu_isolation)
 		sphy->plat->pmu_isolation(false);
 	else if (sphy->drv_data->set_isolation)
 		sphy->drv_data->set_isolation(sphy, false);
 
-	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
-	samsung_usbphy_cfg_sel(sphy);
-
 	/* Initialize usb phy registers */
 	sphy->drv_data->phy_enable(sphy);
 
@@ -150,13 +172,10 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 static void samsung_usb2phy_shutdown(struct usb_phy *phy)
 {
 	struct samsung_usbphy *sphy;
-	struct usb_bus *host = NULL;
 	unsigned long flags;
 
 	sphy = phy_to_sphy(phy);
 
-	host = phy->otg->host;
-
 	if (clk_prepare_enable(sphy->clk)) {
 		dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
 		return;
@@ -164,15 +183,6 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
-	if (host) {
-		/* setting default phy-type for USB 2.0 */
-		if (!strstr(dev_name(host->controller), "ehci") ||
-				!strstr(dev_name(host->controller), "ohci"))
-			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
-	} else {
-		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-	}
-
 	/* De-initialize usb phy registers */
 	sphy->drv_data->phy_disable(sphy);
 
@@ -190,14 +200,12 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
 static int samsung_usb2phy_probe(struct platform_device *pdev)
 {
 	struct samsung_usbphy *sphy;
-	struct usb_otg *otg;
 	struct samsung_usbphy_data *pdata = dev_get_platdata(&pdev->dev);
 	const struct samsung_usbphy_drvdata *drv_data;
 	struct device *dev = &pdev->dev;
 	struct resource *phy_mem;
 	void __iomem	*phy_base;
 	struct clk *clk;
-	int ret;
 
 	phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	phy_base = devm_ioremap_resource(dev, phy_mem);
@@ -208,25 +216,24 @@ static int samsung_usb2phy_probe(struct platform_device *pdev)
 	if (!sphy)
 		return -ENOMEM;
 
-	otg = devm_kzalloc(dev, sizeof(*otg), GFP_KERNEL);
-	if (!otg)
-		return -ENOMEM;
-
 	drv_data = samsung_usbphy_get_driver_data(pdev);
 
 	clk = devm_clk_get(dev, "otg");
 
 	if (IS_ERR(clk)) {
-		dev_err(dev, "Failed to get usbhost/otg clock\n");
+		dev_err(dev, "Failed to get otg clock\n");
 		return PTR_ERR(clk);
 	}
 
 	sphy->dev = dev;
 
 	if (dev->of_node) {
-		ret = samsung_usbphy_parse_dt(sphy);
-		if (ret < 0)
-			return ret;
+		sphy->syscon_reg = syscon_regmap_lookup_by_phandle(dev->of_node,
+						"samsung,syscon-phandle");
+		if (IS_ERR(sphy->syscon_reg)) {
+			dev_err(dev, "Failed to lookup Control regmap\n");
+			return PTR_ERR(sphy->syscon_reg);
+		}
 	} else {
 		if (!pdata) {
 			dev_err(dev, "no platform data specified\n");
@@ -248,10 +255,6 @@ static int samsung_usb2phy_probe(struct platform_device *pdev)
 	if (sphy->ref_clk_freq < 0)
 		return -EINVAL;
 
-	sphy->phy.otg		= otg;
-	sphy->phy.otg->phy	= &sphy->phy;
-	sphy->phy.otg->set_host = samsung_usbphy_set_host;
-
 	spin_lock_init(&sphy->lock);
 
 	platform_set_drvdata(pdev, sphy);
@@ -265,19 +268,14 @@ static int samsung_usb2phy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
-	if (sphy->pmuregs)
-		iounmap(sphy->pmuregs);
-	if (sphy->sysreg)
-		iounmap(sphy->sysreg);
-
 	return 0;
 }
 
 static const struct samsung_usbphy_drvdata usb2phy_s3c64xx = {
 	.cpu_type		= TYPE_S3C64XX,
-	.devphy_en_mask		= S3C64XX_USBPHY_ENABLE,
+	.devphy_reg_offset	= S3C64XX_MISC_CTRL,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_64xx,
-	.set_isolation		= NULL, /* TODO */
+	.set_isolation		= samsung_usbphy_set_isolation,
 	.phy_enable		= samsung_usb2phy_enable,
 	.phy_disable		= samsung_usb2phy_disable,
 };
diff --git a/drivers/usb/phy/phy-samsung-usb2.h b/drivers/usb/phy/phy-samsung-usb2.h
new file mode 100644
index 0000000..5543a99
--- /dev/null
+++ b/drivers/usb/phy/phy-samsung-usb2.h
@@ -0,0 +1,121 @@
+/* linux/drivers/usb/phy/phy-samsung-usb.h
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Samsung USB-PHY transceiver; talks to S3C HS OTG controller, EHCI-S5P and
+ * OHCI-EXYNOS controllers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/usb/phy.h>
+#include <linux/regmap.h>
+
+/* Register definitions */
+
+#define SAMSUNG_PHYPWR				(0x00)
+#define PHYPWR_NORMAL_MASK			(0x19 << 0)
+#define PHYPWR_OTG_DISABLE			BIT(4)
+#define PHYPWR_ANALOG_POWERDOWN			BIT(3)
+#define PHYPWR_FORCE_SUSPEND			BIT(1)
+/* For Exynos4 */
+#define PHYPWR_NORMAL_MASK_PHY0			(0x39 << 0)
+#define PHYPWR_SLEEP_PHY0			BIT(5)
+
+#define SAMSUNG_PHYCLK				(0x04)
+#define PHYCLK_MODE_USB11			BIT(6)
+#define PHYCLK_EXT_OSC				BIT(5)
+#define PHYCLK_COMMON_ON_N			BIT(4)
+#define PHYCLK_ID_PULL				BIT(2)
+#define PHYCLK_CLKSEL_MASK			(0x3 << 0)
+#define PHYCLK_CLKSEL_48M			(0x0 << 0)
+#define PHYCLK_CLKSEL_12M			(0x2 << 0)
+#define PHYCLK_CLKSEL_24M			(0x3 << 0)
+
+#define SAMSUNG_RSTCON				(0x08)
+#define RSTCON_PHYLINK_SWRST			BIT(2)
+#define RSTCON_HLINK_SWRST			BIT(1)
+#define RSTCON_SWRST				BIT(0)
+
+#ifndef MHZ
+#define MHZ (1000*1000)
+#endif
+
+#define S3C64XX_MISC_CTRL			(0x800)	/* Aka: OTHERS */
+#define MISC_CTRL_USB_SIG_MASK			BIT(16)
+
+enum samsung_cpu_type {
+	TYPE_S3C64XX,
+};
+
+struct samsung_usbphy;
+
+/*
+ * struct samsung_usbphy_drvdata - driver data for various SoC variants
+ * @cpu_type: machine identifier
+ * @devphy_reg_offset: offset to DEVICE PHY CONTROL register from
+ *		       mapped address of system controller.
+ */
+struct samsung_usbphy_drvdata {
+	int cpu_type;
+	u32 devphy_reg_offset;
+	int (*rate_to_clksel)(struct samsung_usbphy *, unsigned long);
+	void (*set_isolation)(struct samsung_usbphy *, bool);
+	void (*phy_enable)(struct samsung_usbphy *);
+	void (*phy_disable)(struct samsung_usbphy *);
+};
+
+/*
+ * struct samsung_usbphy - transceiver driver state
+ * @phy: transceiver structure
+ * @plat: platform data
+ * @dev: The parent device supplied to the probe function
+ * @clk: usb phy clock
+ * @regs: usb phy controller registers memory base
+ * @syscon_reg: register map for controlling 'OTHER SFRs' @ 0xE0100100,
+ *		present as a part of clock controller, but instead
+ *		they serve purpose of system controlling.
+ * @ref_clk_freq: reference clock frequency selection
+ * @drv_data: driver data available for different SoCs
+ * @phy_usage: usage count for phy
+ * @lock: lock for phy operations
+ */
+struct samsung_usbphy {
+	struct usb_phy	phy;
+	struct samsung_usbphy_data *plat;
+	struct device	*dev;
+	struct clk	*clk;
+	void __iomem	*regs;
+	struct regmap	*syscon_reg;
+	int		ref_clk_freq;
+	const struct samsung_usbphy_drvdata *drv_data;
+	atomic_t	phy_usage;
+	spinlock_t	lock;
+};
+
+#define phy_to_sphy(x)		container_of((x), struct samsung_usbphy, phy)
+
+static const struct of_device_id samsung_usbphy_dt_match[];
+
+static inline const struct samsung_usbphy_drvdata
+*samsung_usbphy_get_driver_data(struct platform_device *pdev)
+{
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(samsung_usbphy_dt_match,
+							pdev->dev.of_node);
+		return match->data;
+	}
+
+	return (struct samsung_usbphy_drvdata *)
+				platform_get_device_id(pdev)->driver_data;
+}
-- 
1.7.10.4

