Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3HFSBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:01:47 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57596 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3HFSBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:01:44 -0400
From: Julius Werner <jwerner@chromium.org>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, devicetree@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register handling
Date: Tue,  6 Aug 2013 11:00:17 -0700
Message-Id: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
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
like s3c64xx that use different bits within the same register.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 .../devicetree/bindings/usb/samsung-usbphy.txt     | 26 +++++-----------------
 arch/arm/boot/dts/exynos5250.dtsi                  |  4 ++--
 drivers/usb/phy/phy-samsung-usb.c                  | 18 ++++-----------
 drivers/usb/phy/phy-samsung-usb.h                  | 23 +++++--------------
 drivers/usb/phy/phy-samsung-usb2.c                 | 11 ++++-----
 drivers/usb/phy/phy-samsung-usb3.c                 |  2 +-
 6 files changed, 22 insertions(+), 62 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
index 33fd354..1cf9b68 100644
--- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
+++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
@@ -34,14 +34,7 @@ Optional properties:
 - The child node 'usbphy-sys' to the node 'usbphy' is for the system controller
   interface for usb-phy. It should provide the following information required by
   usb-phy controller to control phy.
-  - reg : base physical address of PHY_CONTROL registers.
-	  The size of this register is the total sum of size of all PHY_CONTROL
-	  registers that the SoC has. For example, the size will be
-	  '0x4' in case we have only one PHY_CONTROL register (e.g.
-	  OTHERS register in S3C64XX or USB_PHY_CONTROL register in S5PV210)
-	  and, '0x8' in case we have two PHY_CONTROL registers (e.g.
-	  USBDEVICE_PHY_CONTROL and USBHOST_PHY_CONTROL registers in exynos4x).
-	  and so on.
+  - reg : address of PHY_CONTROL register for this PHY.
 
 Example:
  - Exynos4210
@@ -57,8 +50,8 @@ Example:
 		clock-names = "xusbxti", "otg";
 
 		usbphy-sys {
-			/* USB device and host PHY_CONTROL registers */
-			reg = <0x10020704 0x8>;
+			/* USB device PHY_CONTROL register */
+			reg = <0x10020704 0x4>;
 		};
 	};
 
@@ -90,14 +83,7 @@ Optional properties:
 - The child node 'usbphy-sys' to the node 'usbphy' is for the system controller
   interface for usb-phy. It should provide the following information required by
   usb-phy controller to control phy.
-  - reg : base physical address of PHY_CONTROL registers.
-	  The size of this register is the total sum of size of all PHY_CONTROL
-	  registers that the SoC has. For example, the size will be
-	  '0x4' in case we have only one PHY_CONTROL register (e.g.
-	  OTHERS register in S3C64XX or USB_PHY_CONTROL register in S5PV210)
-	  and, '0x8' in case we have two PHY_CONTROL registers (e.g.
-	  USBDEVICE_PHY_CONTROL and USBHOST_PHY_CONTROL registers in exynos4x).
-	  and so on.
+  - reg : address of PHY_CONTROL register for this PHY.
 
 Example:
 	usbphy@12100000 {
@@ -111,7 +97,7 @@ Example:
 		clock-names = "ext_xtal", "usbdrd30";
 
 		usbphy-sys {
-			/* USB device and host PHY_CONTROL registers */
-			reg = <0x10040704 0x8>;
+			/* USB DRD PHY_CONTROL register */
+			reg = <0x10040704 0x4>;
 		};
 	};
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
index ac025ca..51cad19 100644
--- a/drivers/usb/phy/phy-samsung-usb.c
+++ b/drivers/usb/phy/phy-samsung-usb.c
@@ -75,31 +75,21 @@ EXPORT_SYMBOL_GPL(samsung_usbphy_parse_dt);
  */
 void samsung_usbphy_set_isolation_4210(struct samsung_usbphy *sphy, bool on)
 {
-	void __iomem *reg = NULL;
 	u32 reg_val;
-	u32 en_mask = 0;
 
 	if (!sphy->pmuregs) {
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
+	reg_val = readl(sphy->pmuregs);
 
 	if (on)
-		reg_val &= ~en_mask;
+		reg_val &= ~sphy->drv_data->phy_en_mask;
 	else
-		reg_val |= en_mask;
+		reg_val |= sphy->drv_data->phy_en_mask;
 
-	writel(reg_val, reg);
+	writel(reg_val, sphy->pmuregs);
 
 	if (sphy->drv_data->cpu_type == TYPE_EXYNOS4X12) {
 		writel(reg_val, sphy->pmuregs + EXYNOS4X12_PHY_HSIC_CTRL0);
diff --git a/drivers/usb/phy/phy-samsung-usb.h b/drivers/usb/phy/phy-samsung-usb.h
index 68771bf..a817af5 100644
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
diff --git a/drivers/usb/phy/phy-samsung-usb2.c b/drivers/usb/phy/phy-samsung-usb2.c
index 758b86d..adbaa8c 100644
--- a/drivers/usb/phy/phy-samsung-usb2.c
+++ b/drivers/usb/phy/phy-samsung-usb2.c
@@ -445,7 +445,7 @@ static int samsung_usb2phy_remove(struct platform_device *pdev)
 
 static const struct samsung_usbphy_drvdata usb2phy_s3c64xx = {
 	.cpu_type		= TYPE_S3C64XX,
-	.devphy_en_mask		= S3C64XX_USBPHY_ENABLE,
+	.phy_en_mask		= S3C64XX_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_64xx,
 	.set_isolation		= NULL, /* TODO */
 	.phy_enable		= samsung_usb2phy_enable,
@@ -454,8 +454,7 @@ static const struct samsung_usbphy_drvdata usb2phy_s3c64xx = {
 
 static const struct samsung_usbphy_drvdata usb2phy_exynos4 = {
 	.cpu_type		= TYPE_EXYNOS4210,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
+	.phy_en_mask		= EXYNOS_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_64xx,
 	.set_isolation		= samsung_usbphy_set_isolation_4210,
 	.phy_enable		= samsung_usb2phy_enable,
@@ -464,8 +463,7 @@ static const struct samsung_usbphy_drvdata usb2phy_exynos4 = {
 
 static const struct samsung_usbphy_drvdata usb2phy_exynos4x12 = {
 	.cpu_type		= TYPE_EXYNOS4X12,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
+	.phy_en_mask		= EXYNOS_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
 	.set_isolation		= samsung_usbphy_set_isolation_4210,
 	.phy_enable		= samsung_usb2phy_enable,
@@ -474,8 +472,7 @@ static const struct samsung_usbphy_drvdata usb2phy_exynos4x12 = {
 
 static struct samsung_usbphy_drvdata usb2phy_exynos5 = {
 	.cpu_type		= TYPE_EXYNOS5250,
-	.hostphy_en_mask	= EXYNOS_USBPHY_ENABLE,
-	.hostphy_reg_offset	= EXYNOS_USBHOST_PHY_CTRL_OFFSET,
+	.phy_en_mask		= EXYNOS_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
 	.set_isolation		= samsung_usbphy_set_isolation_4210,
 	.phy_enable		= samsung_exynos5_usb2phy_enable,
diff --git a/drivers/usb/phy/phy-samsung-usb3.c b/drivers/usb/phy/phy-samsung-usb3.c
index 300e0cf..3ad9579 100644
--- a/drivers/usb/phy/phy-samsung-usb3.c
+++ b/drivers/usb/phy/phy-samsung-usb3.c
@@ -302,7 +302,7 @@ static int samsung_usb3phy_remove(struct platform_device *pdev)
 
 static struct samsung_usbphy_drvdata usb3phy_exynos5 = {
 	.cpu_type		= TYPE_EXYNOS5250,
-	.devphy_en_mask		= EXYNOS_USBPHY_ENABLE,
+	.phy_en_mask		= EXYNOS_USBPHY_ENABLE,
 	.rate_to_clksel		= samsung_usbphy_rate_to_clksel_4x12,
 	.set_isolation		= samsung_usbphy_set_isolation_4210,
 	.phy_enable		= samsung_exynos5_usb3phy_enable,
-- 
1.7.12.4

