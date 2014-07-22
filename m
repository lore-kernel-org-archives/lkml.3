Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaGVK53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56769 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbaGVK51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:27 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/28] drivers: phy: exynos-usb2: add support for Exynos 3250
Date: Tue, 22 Jul 2014 16:26:34 +0530
Message-ID: <1406026611-30493-12-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

This patch adds support for Exynos3250 SoC to Exynos2USB PHY driver.
Although Exynos3250 has only one device phy interface, the register
layout and all operations that are required to get it enabled are almost
same as on Exynos4x12. The only different is one more register
(REFCLKSEL) which need to be set and lack of MODE SWITCH register.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |    2 ++
 drivers/phy/Kconfig                                |   12 ++++++------
 drivers/phy/phy-exynos4x12-usb2.c                  |   17 +++++++++++++++--
 drivers/phy/phy-samsung-usb2.c                     |    6 ++++++
 drivers/phy/phy-samsung-usb2.h                     |    2 ++
 5 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 2049261..6099a5c 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -26,6 +26,7 @@ Samsung S5P/EXYNOS SoC series USB PHY
 
 Required properties:
 - compatible : should be one of the listed compatibles:
+	- "samsung,exynos3250-usb2-phy"
 	- "samsung,exynos4210-usb2-phy"
 	- "samsung,exynos4x12-usb2-phy"
 	- "samsung,exynos5250-usb2-phy"
@@ -46,6 +47,7 @@ and Exynos 4212) it is as follows:
   1 - USB host ("host"),
   2 - HSIC0 ("hsic0"),
   3 - HSIC1 ("hsic1"),
+Exynos3250 has only USB device phy available as phy 0.
 
 Exynos 4210 and Exynos 4212 use mode switching and require that mode switch
 register is supplied.
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 30c82fc..7c49c4c 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -151,14 +151,14 @@ config PHY_EXYNOS4210_USB2
 	  phys are available - device, host, HSIC0 and HSIC1.
 
 config PHY_EXYNOS4X12_USB2
-	bool "Support for Exynos 4x12"
+	bool "Support for Exynos 3250/4x12"
 	depends on PHY_SAMSUNG_USB2
-	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
+	depends on (SOC_EXYNOS3250 || SOC_EXYNOS4212 || SOC_EXYNOS4412)
 	help
-	  Enable USB PHY support for Exynos 4x12. This option requires that
-	  Samsung USB 2.0 PHY driver is enabled and means that support for this
-	  particular SoC is compiled in the driver. In case of Exynos 4x12 four
-	  phys are available - device, host, HSIC0 and HSIC1.
+	  Enable USB PHY support for Exynos 3250/4x12. This option requires
+	  that Samsung USB 2.0 PHY driver is enabled and means that support for
+	  this particular SoC is compiled in the driver. In case of Exynos 4x12
+	  four phys are available - device, host, HSIC0 and HSIC1.
 
 config PHY_EXYNOS5250_USB2
 	bool "Support for Exynos 5250"
diff --git a/drivers/phy/phy-exynos4x12-usb2.c b/drivers/phy/phy-exynos4x12-usb2.c
index 63134d8..0b9de88 100644
--- a/drivers/phy/phy-exynos4x12-usb2.c
+++ b/drivers/phy/phy-exynos4x12-usb2.c
@@ -67,6 +67,8 @@
 #define EXYNOS_4x12_UPHYCLK_PHYFSEL_24MHZ	(0x5 << 0)
 #define EXYNOS_4x12_UPHYCLK_PHYFSEL_50MHZ	(0x7 << 0)
 
+#define EXYNOS_3250_UPHYCLK_REFCLKSEL		(0x2 << 8)
+
 #define EXYNOS_4x12_UPHYCLK_PHY0_ID_PULLUP	BIT(3)
 #define EXYNOS_4x12_UPHYCLK_PHY0_COMMON_ON	BIT(4)
 #define EXYNOS_4x12_UPHYCLK_PHY1_COMMON_ON	BIT(7)
@@ -197,6 +199,10 @@ static void exynos4x12_setup_clk(struct samsung_usb2_phy_instance *inst)
 
 	clk = readl(drv->reg_phy + EXYNOS_4x12_UPHYCLK);
 	clk &= ~EXYNOS_4x12_UPHYCLK_PHYFSEL_MASK;
+
+	if (drv->cfg->has_refclk_sel)
+		clk = EXYNOS_3250_UPHYCLK_REFCLKSEL;
+
 	clk |= drv->ref_reg_val << EXYNOS_4x12_UPHYCLK_PHYFSEL_OFFSET;
 	clk |= EXYNOS_4x12_UPHYCLK_PHY1_COMMON_ON;
 	writel(clk, drv->reg_phy + EXYNOS_4x12_UPHYCLK);
@@ -278,7 +284,7 @@ static int exynos4x12_power_on(struct samsung_usb2_phy_instance *inst)
 		exynos4x12_power_on_int(&drv->instances[EXYNOS4x12_DEVICE]);
 	}
 
-	if (inst->cfg->id == EXYNOS4x12_DEVICE)
+	if (inst->cfg->id == EXYNOS4x12_DEVICE && drv->cfg->has_mode_switch)
 		regmap_update_bits(drv->reg_sys, EXYNOS_4x12_MODE_SWITCH_OFFSET,
 						EXYNOS_4x12_MODE_SWITCH_MASK,
 						EXYNOS_4x12_MODE_SWITCH_DEVICE);
@@ -310,7 +316,7 @@ static int exynos4x12_power_off(struct samsung_usb2_phy_instance *inst)
 	if (inst->ext_cnt-- > 1)
 		return 0;
 
-	if (inst->cfg->id == EXYNOS4x12_DEVICE)
+	if (inst->cfg->id == EXYNOS4x12_DEVICE && drv->cfg->has_mode_switch)
 		regmap_update_bits(drv->reg_sys, EXYNOS_4x12_MODE_SWITCH_OFFSET,
 						EXYNOS_4x12_MODE_SWITCH_MASK,
 						EXYNOS_4x12_MODE_SWITCH_HOST);
@@ -358,6 +364,13 @@ static const struct samsung_usb2_common_phy exynos4x12_phys[] = {
 	{},
 };
 
+const struct samsung_usb2_phy_config exynos3250_usb2_phy_config = {
+	.has_refclk_sel		= 1,
+	.num_phys		= 1,
+	.phys			= exynos4x12_phys,
+	.rate_to_clk		= exynos4x12_rate_to_clk,
+};
+
 const struct samsung_usb2_phy_config exynos4x12_usb2_phy_config = {
 	.has_mode_switch	= 1,
 	.num_phys		= EXYNOS4x12_NUM_PHYS,
diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 1e69a32..16aae7a 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -87,6 +87,12 @@ static struct phy *samsung_usb2_phy_xlate(struct device *dev,
 }
 
 static const struct of_device_id samsung_usb2_phy_of_match[] = {
+#ifdef CONFIG_PHY_EXYNOS4X12_USB2
+	{
+		.compatible = "samsung,exynos3250-usb2-phy",
+		.data = &exynos3250_usb2_phy_config,
+	},
+#endif
 #ifdef CONFIG_PHY_EXYNOS4210_USB2
 	{
 		.compatible = "samsung,exynos4210-usb2-phy",
diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
index 9188478..b03da0e 100644
--- a/drivers/phy/phy-samsung-usb2.h
+++ b/drivers/phy/phy-samsung-usb2.h
@@ -60,8 +60,10 @@ struct samsung_usb2_phy_config {
 	int (*rate_to_clk)(unsigned long, u32 *);
 	unsigned int num_phys;
 	bool has_mode_switch;
+	bool has_refclk_sel;
 };
 
+extern const struct samsung_usb2_phy_config exynos3250_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos4210_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos4x12_usb2_phy_config;
 extern const struct samsung_usb2_phy_config exynos5250_usb2_phy_config;
-- 
1.7.9.5

