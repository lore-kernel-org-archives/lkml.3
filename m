Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3G2Voc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:44:32 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61732 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3G2Vo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:44:29 -0400
From: Julius Werner <jwerner@chromium.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, devicetree@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH v3] usb: phy-samsung-usb: Simplify PMU register handling
Date: Mon, 29 Jul 2013 14:44:13 -0700
Message-Id: <1375134253-18406-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the way the phy-samsung-usb code finds the correct
power management register to enable PHY clock gating. Previously, the
code would calculate the register address from a device tree supplied
base address and add an offset based on the PHY type.

Since every PHY has its own device tree entry and needs only one
register, we can just encode the address itself in the device tree and
remove the diffentiation in the code. The bitmask needed to specify the
bit within that register stays in place, allowing support for platforms
like s3c64xx that use different bits within the same register. Due to
this simplification, the whole complication of a Samsung-specific USB
PHY type can be removed from the PHY driver.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 arch/arm/boot/dts/exynos5250.dtsi  |  4 +--
 drivers/usb/phy/phy-samsung-usb.c  | 51 +++++++++-----------------------------
 drivers/usb/phy/phy-samsung-usb.h  | 34 ++++++-------------------
 drivers/usb/phy/phy-samsung-usb2.c | 34 +++++++------------------
 drivers/usb/phy/phy-samsung-usb3.c | 13 +++-------
 5 files changed, 34 insertions(+), 102 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index ef57277..5a754d7 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -473,7 +473,7 @@
 		ranges;
 
 		usbphy-sys {
-			reg = <0x10040704 0x8>;
+			reg = <0x10040704 0x4>;
 		};
 	};
 
@@ -505,7 +505,7 @@
 		ranges;
 
 		usbphy-sys {
-			reg = <0x10040704 0x8>,
+			reg = <0x10040708 0x4>,
 			      <0x10050230 0x4>;
 		};
 	};
diff --git a/drivers/usb/phy/phy-samsung-usb.c b/drivers/usb/phy/phy-samsung-usb.c
index ac025ca..32c5264 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -27,7 +27,6 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/usb/samsung_usb_phy.h>
 
 #include "phy-samsung-usb.h"
 
@@ -42,9 +41,9 @@ int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy)
 		return -ENODEV;
 	}
 
-	sphy->pmuregs = of_iomap(usbphy_sys, 0);
+	sphy->pmureg = of_iomap(usbphy_sys, 0);
 
-	if (sphy->pmuregs == NULL) {
+	if (sphy->pmureg == NULL) {
 		dev_err(sphy->dev, "Can't get usb-phy pmu control register\n");
 		goto err0;
 	}
@@ -75,35 +74,25 @@ EXPORT_SYMBOL_GPL(samsung_usbphy_parse_dt);
  */
 void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool on)
 {
-	void __iomem *reg = NULL;
 	u32 reg_val;
-	u32 en_mask = 0;
 
-	if (!sphy->pmuregs) {
+	if (!sphy->pmureg) {
 		dev_warn(sphy->dev, "Can't set pmu isolation\n");
 		return;
 	}
 
-	if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
-		reg = sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
-		en_mask = sphy->drv_data->devphy_en_mask;
-	} else if (sphy->phy_type == USB_PHY_TYPE_HOST) {
-		reg = sphy->pmuregs + sphy->drv_data->hostphy_reg_offset;
-		en_mask = sphy->drv_data->hostphy_en_mask;
-	}
-
-	reg_val = readl(reg);
+	reg_val = readl(sphy->pmureg);
 
 	if (on)
-		reg_val &= ~en_mask;
+		reg_val &= ~sphy->drv_data->phy_en_mask;
 	else
-		reg_val |= en_mask;
+		reg_val |= sphy->drv_data->phy_en_mask;
 
-	writel(reg_val, reg);
+	writel(reg_val, sphy->pmureg);
 
 	if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12) {
-		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL0);
-		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL1);
+		writel(reg_val, sphy->pmureg + EXYNOS4X12_PHY_HSIC_CTRL0);
+		writel(reg_val, sphy->pmureg + EXYNOS4X12_PHY_HSIC_CTRL1);
 	}
 }
 EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
@@ -111,7 +100,7 @@ EXPORT_SYMBOL_GPL(samsung_usbphy_set_isolation_4210);
 /*
  * Configure the mode of working of usb-phy here: HOST/DEVICE.
  */
-void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
+void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy, bool device_mode)
 {
 	u32 reg;
 
@@ -122,31 +111,15 @@ void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy)
 
 	reg = readl(sphy->sysreg);
 
-	if (sphy->phy_type == USB_PHY_TYPE_DEVICE)
+	if (device_mode)
 		reg &= ~EXYNOS_USB20PHY_CFG_HOST_LINK;
-	else if (sphy->phy_type == USB_PHY_TYPE_HOST)
+	else
 		reg |= EXYNOS_USB20PHY_CFG_HOST_LINK;
 
 	writel(reg, sphy->sysreg);
 }
 EXPORT_SYMBOL_GPL(samsung_usbphy_cfg_sel);
 
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
 int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
 							unsigned long rate)
 {
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index 68771bf..0c0d7d1 100644
--- a/drivers/usb/phy/phy-samsung-usb.h
+++ b/drivers/usb/phy/phy-samsung-usb.h
@@ -243,7 +243,6 @@
 #define KHZ (1000)
 #endif
 
-#define EXYNOS_USBHOST_PHY_CTRL_OFFSET		(0x4)
 #define S3C64XX_USBPHY_ENABLE			(0x1 << 16)
 #define EXYNOS_USBPHY_ENABLE			(0x1 << 0)
 #define EXYNOS_USB20PHY_CFG_HOST_LINK		(0x1 << 0)
@@ -260,27 +259,15 @@ struct samsung_usbphy;
 /*
  * struct samsung_usbphy_drvdata - driver data for various SoC variants
  * @cpu_type: machine identifier
- * @devphy_en_mask: device phy enable mask for PHY CONTROL register
- * @hostphy_en_mask: host phy enable mask for PHY CONTROL register
- * @devphy_reg_offset: offset to DEVICE PHY CONTROL register from
- *		       mapped address of system controller.
- * @hostphy_reg_offset: offset to HOST PHY CONTROL register from
- *		       mapped address of system controller.
+ * @phy_en_mask: phy enable mask for PHY CONTROL register
  *
- *	Here we have a separate mask for device type phy.
- *	Having different masks for host and device type phy helps
- *	in setting independent masks in case of SoCs like S5PV210,
- *	in which PHY0 and PHY1 enable bits belong to same register
- *	placed at position 0 and 1 respectively.
- *	Although for newer SoCs like exynos these bits belong to
- *	different registers altogether placed at position 0.
+ *	Here we have a mask for the phy control bit. This is required for SoCs
+ *	like S5PV210, in which different PHYs use different bits in the same
+ *	register.
  */
 struct samsung_usbphy_drvdata {
 	int cpu_type;
-	int devphy_en_mask;
-	int hostphy_en_mask;
-	u32 devphy_reg_offset;
-	u32 hostphy_reg_offset;
+	int phy_en_mask;
 	int (*rate_to_clksel)(struct samsung_usbphy *, unsigned long);
 	void (*set_isolation)(struct samsung_usbphy *, bool);
 	void (*phy_enable)(struct samsung_usbphy *);
@@ -294,12 +281,10 @@ struct samsung_usbphy_drvdata {
  * @dev: The parent device supplied to the probe function
  * @clk: usb phy clock
  * @regs: usb phy controller registers memory base
- * @pmuregs: USB device PHY_CONTROL register memory base
+ * @pmureg: USB device PHY_CONTROL register address
  * @sysreg: USB2.0 PHY_CFG register memory base
  * @ref_clk_freq: reference clock frequency selection
  * @drv_data: driver data available for different SoCs
- * @phy_type: Samsung SoCs specific phy types:	#HOST
- *						#DEVICE
  * @phy_usage: usage count for phy
  * @lock: lock for phy operations
  */
@@ -309,11 +294,10 @@ struct samsung_usbphy {
 	struct device	*dev;
 	struct clk	*clk;
 	void __iomem	*regs;
-	void __iomem	*pmuregs;
+	void __iomem	*pmureg;
 	void __iomem	*sysreg;
 	int		ref_clk_freq;
 	const struct samsung_usbphy_drvdata *drv_data;
-	enum samsung_usb_phy_type phy_type;
 	atomic_t	phy_usage;
 	spinlock_t	lock;
 };
@@ -339,9 +323,7 @@ static inline const struct samsung_usbphy_drvdata
 extern int samsung_usbphy_parse_dt(struct samsung_usbphy *sphy);
 extern void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy,
 								bool on);
-extern void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy);
-extern int samsung_usbphy_set_type(struct usb_phy *phy,
-					enum samsung_usb_phy_type phy_type);
+extern void samsung_usbphy_cfg_sel(struct samsung_usbphy *sphy, bool dev_mode);
 extern int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy);
 extern int samsung_usbphy_rate_to_clksel_64xx(struct samsung_usbphy *sphy,
 							unsigned long rate);
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 758b86d..eb215a1 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -27,7 +27,6 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/usb/otg.h>
-#include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
 #include "phy-samsung-usb.h"
@@ -283,13 +282,13 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
+	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
 	if (host) {
-		/* setting default phy-type for USB 2.0 */
 		if (!strstr(dev_name(host->controller), "ehci") ||
 				!strstr(dev_name(host->controller), "ohci"))
-			samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_HOST);
+			samsung_usbphy_cfg_sel(sphy, false);
 	} else {
-		samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
+		samsung_usbphy_cfg_sel(sphy, true);
 	}
 
 	/* Disable phy isolation */
@@ -298,9 +297,6 @@ static int samsung_usb2phy_init(struct usb_phy *phy)
 	else if (sphy->drv_data->set_isolation)
 		sphy->drv_data->set_isolation(sphy, false);
 
-	/* Selecting Host/OTG mode; After reset USB2.0PHY_CFG: HOST */
-	samsung_usbphy_cfg_sel(sphy);
-
 	/* Initialize usb phy registers */
 	sphy->drv_data->phy_enable(sphy);
 
@@ -332,15 +328,6 @@ static void samsung_usb2phy_shutdown(struct usb_phy *phy)
 
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
 
@@ -435,8 +422,8 @@ static int samsung_usb2phy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
-	if (sphy->pmuregs)
-		iounmap(sphy->pmuregs);
+	if (sphy->pmureg)
+		iounmap(sphy->pmureg);
 	if (sphy->sysreg)
 		iounmap(sphy->sysreg);
 
@@ -445,7 +432,7 @@ static int samsung_usb2phy_remove(struct platform_device *pdev)
 
 static const struct samsung_usbphy_drvdata usb2phy_s3c64xx = {
 	.cpu_type		= TYPE_S3C64XX,
-	.devphy_en_mask		= S3C64XX_USBPHY_ENABLE,
+	.phy_en_mask		= S3C64XX_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_64xx,
 	.set_isolation		= NULL, /* TODO */
 	.phy_enable		= samsung_usb2phy_enable,
@@ -454,8 +441,7 @@ static const struct samsung_usbphy_drvdata usb2phy_s3c64xx = {
 
 static const struct samsung_usbphy_drvdata usb2phy_exynos4 = {
 	.cpu_type		= TYPE_EXYNOS4210,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
+	.phy_en_mask		= EXYNOS_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_64xx,
 	.set_isolation		= samsung_usbphy_set_isolation_4210,
 	.phy_enable		= samsung_usb2phy_enable,
@@ -464,8 +450,7 @@ static const struct samsung_usbphy_drvdata usb2phy_exynos4 = {
 
 static const struct samsung_usbphy_drvdata usb2phy_exynos4x12 = {
 	.cpu_type		= TYPE_EXYNOS4X12,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
+	.phy_en_mask		= EXYNOS_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
 	.set_isolation		= samsung_usbphy_set_isolation_4210,
 	.phy_enable		= samsung_usb2phy_enable,
@@ -474,8 +459,7 @@ static const struct samsung_usbphy_drvdata usb2phy_exynos4x12 = {
 
 static struct samsung_usbphy_drvdata usb2phy_exynos5 = {
 	.cpu_type		= TYPE_EXYNOS5250,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
-	.hostphy_reg_offset	= EXYNOS_USBHOST_PHY_CTRL_OFFSET,
+	.phy_en_mask		= EXYNOS_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
 	.set_isolation		= samsung_usbphy_set_isolation_4210,
 	.phy_enable		= samsung_exynos5_usb2phy_enable,
diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
index 300e0cf..ac05d91 100644
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ b/drivers/usb/phy/phy-samsung-usb3.c
@@ -24,7 +24,6 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
-#include <linux/usb/samsung_usb_phy.h>
 #include <linux/platform_data/samsung-usbphy.h>
 
 #include "phy-samsung-usb.h"
@@ -178,9 +177,6 @@ static int samsung_usb3phy_init(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
-	/* setting default phy-type for USB 3.0 */
-	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-
 	/* Disable phy isolation */
 	if (sphy->drv_data->set_isolation)
 		sphy->drv_data->set_isolation(sphy, false);
@@ -213,9 +209,6 @@ static void samsung_usb3phy_shutdown(struct usb_phy *phy)
 
 	spin_lock_irqsave(&sphy->lock, flags);
 
-	/* setting default phy-type for USB 3.0 */
-	samsung_usbphy_set_type(&sphy->phy, USB_PHY_TYPE_DEVICE);
-
 	/* De-initialize usb phy registers */
 	sphy->drv_data->phy_disable(sphy);
 
@@ -292,8 +285,8 @@ static int samsung_usb3phy_remove(struct platform_device *pdev)
 
 	usb_remove_phy(&sphy->phy);
 
-	if (sphy->pmuregs)
-		iounmap(sphy->pmuregs);
+	if (sphy->pmureg)
+		iounmap(sphy->pmureg);
 	if (sphy->sysreg)
 		iounmap(sphy->sysreg);
 
@@ -302,7 +295,7 @@ static int samsung_usb3phy_remove(struct platform_device *pdev)
 
 static struct samsung_usbphy_drvdata usb3phy_exynos5 = {
 	.cpu_type		= TYPE_EXYNOS5250,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
+	.phy_en_mask		= EXYNOS_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
 	.set_isolation		= samsung_usbphy_set_isolation_4210,
 	.phy_enable		= samsung_exynos5_usb3phy_enable,
-- 
1.7.12.4

