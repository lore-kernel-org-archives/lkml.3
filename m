Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaDOLoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:44:20 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56604 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbaDOLoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:44:18 -0400
From: Mohit Kumar <mohit.kumar@st.com>
To: <arnd@arndb.de>
Cc: Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <spear-devel@list.st.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V8 5/9] phy: SPEAr1310/40-miphy: Add phy driver for PCIe and SATA
Date: Tue, 15 Apr 2014 17:13:31 +0530
Message-ID: <fdf0d926ad07b587af775cb65016c6787ed028a7.1397555158.git.mohit.kumar@st.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1397555158.git.mohit.kumar@st.com>
References: <cover.1397555158.git.mohit.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

SPEAr1310/40 uses miphy for PCIe and SATA phy. This driver adds
support for the same.

AHCI phy hookups from arch specific code has been cleaned up.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Tested-by: Mohit Kumar <mohit.kumar@st.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: spear-devel@list.st.com
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/spear1310-evb.dts |    4 +
 arch/arm/boot/dts/spear1310.dtsi    |   39 ++++-
 arch/arm/boot/dts/spear1340-evb.dts |    4 +
 arch/arm/boot/dts/spear1340.dtsi    |   12 ++-
 arch/arm/boot/dts/spear13xx.dtsi    |    5 +
 arch/arm/mach-spear/Kconfig         |    3 +
 arch/arm/mach-spear/spear1340.c     |  127 +---------------
 drivers/phy/Kconfig                 |   12 ++
 drivers/phy/Makefile                |    2 +
 drivers/phy/phy-spear1310-miphy.c   |  274 ++++++++++++++++++++++++++++++++
 drivers/phy/phy-spear1340-miphy.c   |  300 +++++++++++++++++++++++++++++++++++
 11 files changed, 652 insertions(+), 130 deletions(-)
 create mode 100644 drivers/phy/phy-spear1310-miphy.c
 create mode 100644 drivers/phy/phy-spear1340-miphy.c

diff --git a/arch/arm/boot/dts/spear1310-evb.dts b/arch/arm/boot/dts/spear1310-evb.dts
index b56a801..d42c84b 100644
--- a/arch/arm/boot/dts/spear1310-evb.dts
+++ b/arch/arm/boot/dts/spear1310-evb.dts
@@ -106,6 +106,10 @@
 			status = "okay";
 		};
 
+		miphy@eb800000 {
+			status = "okay";
+		};
+
 		cf@b2800000 {
 			status = "okay";
 		};
diff --git a/arch/arm/boot/dts/spear1310.dtsi b/arch/arm/boot/dts/spear1310.dtsi
index 122ae94..64e7dd5 100644
--- a/arch/arm/boot/dts/spear1310.dtsi
+++ b/arch/arm/boot/dts/spear1310.dtsi
@@ -29,24 +29,57 @@
 			#gpio-cells = <2>;
 		};
 
-		ahci@b1000000 {
+		miphy0: miphy@eb800000 {
+			compatible = "st,miphy", "st,spear1310-miphy";
+			reg = <0xeb800000 0x4000>;
+			misc = <&misc>;
+			phy-id = <0>;
+			#phy-cells = <1>;
+			status = "disabled";
+		};
+
+		miphy1: miphy@eb804000 {
+			compatible = "st,miphy", "st,spear1310-miphy";
+			reg = <0xeb804000 0x4000>;
+			misc = <&misc>;
+			phy-id = <1>;
+			#phy-cells = <1>;
+			status = "disabled";
+		};
+
+		miphy2: miphy@eb808000 {
+			compatible = "st,miphy", "st,spear1310-miphy";
+			reg = <0xeb808000 0x4000>;
+			misc = <&misc>;
+			phy-id = <2>;
+			#phy-cells = <1>;
+			status = "disabled";
+		};
+
+		ahci0: ahci@b1000000 {
 			compatible = "snps,spear-ahci";
 			reg = <0xb1000000 0x10000>;
 			interrupts = <0 68 0x4>;
+			phys = <&miphy0 0>;
+			phy-names = "sata-phy";
 			status = "disabled";
 		};
 
-		ahci@b1800000 {
+		ahci1: ahci@b1800000 {
 			compatible = "snps,spear-ahci";
 			reg = <0xb1800000 0x10000>;
 			interrupts = <0 69 0x4>;
+			phys = <&miphy1 0>;
+			phy-names = "sata-phy";
 			status = "disabled";
 		};
 
-		ahci@b4000000 {
+		ahci2: ahci@b4000000 {
 			compatible = "snps,spear-ahci";
 			reg = <0xb4000000 0x10000>;
 			interrupts = <0 70 0x4>;
+			phys = <&miphy2 0>;
+			phy-names = "sata-phy";
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/spear1340-evb.dts b/arch/arm/boot/dts/spear1340-evb.dts
index d6c30ae..b23e05e 100644
--- a/arch/arm/boot/dts/spear1340-evb.dts
+++ b/arch/arm/boot/dts/spear1340-evb.dts
@@ -122,6 +122,10 @@
 			status = "okay";
 		};
 
+		miphy@eb800000 {
+			status = "okay";
+		};
+
 		dma@ea800000 {
 			status = "okay";
 		};
diff --git a/arch/arm/boot/dts/spear1340.dtsi b/arch/arm/boot/dts/spear1340.dtsi
index 54d128d..b8b32c7 100644
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -31,10 +31,20 @@
 			status = "disabled";
 		};
 
-		ahci@b1000000 {
+		miphy0: miphy@eb800000 {
+			compatible = "st,miphy", "st,spear1340-miphy";
+			reg = <0xeb800000 0x4000>;
+			misc = <&misc>;
+			#phy-cells = <1>;
+			status = "disabled";
+		};
+
+		ahci0: ahci@b1000000 {
 			compatible = "snps,spear-ahci";
 			reg = <0xb1000000 0x10000>;
 			interrupts = <0 72 0x4>;
+			phys = <&miphy0 0>;
+			phy-names = "sata-phy";
 			status = "disabled";
 		};
 
diff --git a/arch/arm/boot/dts/spear13xx.dtsi b/arch/arm/boot/dts/spear13xx.dtsi
index 4382547..3a72508 100644
--- a/arch/arm/boot/dts/spear13xx.dtsi
+++ b/arch/arm/boot/dts/spear13xx.dtsi
@@ -220,6 +220,11 @@
 				  0xd8000000 0xd8000000 0x01000000
 				  0xe0000000 0xe0000000 0x10000000>;
 
+			misc: syscon@e0700000 {
+				compatible = "st,spear1340-misc", "syscon";
+				reg = <0xe0700000 0x1000>;
+			};
+
 			gpio0: gpio@e0600000 {
 				compatible = "arm,pl061", "arm,primecell";
 				reg = <0xe0600000 0x1000>;
diff --git a/arch/arm/mach-spear/Kconfig b/arch/arm/mach-spear/Kconfig
index 0786249..ce1e70f 100644
--- a/arch/arm/mach-spear/Kconfig
+++ b/arch/arm/mach-spear/Kconfig
@@ -20,6 +20,7 @@ config ARCH_SPEAR13XX
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select PINCTRL
+	select MFD_SYSCON
 	help
 	  Supports for ARM's SPEAR13XX family
 
@@ -28,12 +29,14 @@ if ARCH_SPEAR13XX
 config MACH_SPEAR1310
 	bool "SPEAr1310 Machine support with Device Tree"
 	select PINCTRL_SPEAR1310
+	select PHY_ST_SPEAR1310_MIPHY
 	help
 	  Supports ST SPEAr1310 machine configured via the device-tree
 
 config MACH_SPEAR1340
 	bool "SPEAr1340 Machine support with Device Tree"
 	select PINCTRL_SPEAR1340
+	select PHY_ST_SPEAR1340_MIPHY
 	help
 	  Supports ST SPEAr1340 machine configured via the device-tree
 
diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
index 7b6bff7..5f06166 100644
--- a/arch/arm/mach-spear/spear1340.c
+++ b/arch/arm/mach-spear/spear1340.c
@@ -11,138 +11,13 @@
  * warranty of any kind, whether express or implied.
  */
 
-#define pr_fmt(fmt) "SPEAr1340: " fmt
-
-#include <linux/ahci_platform.h>
-#include <linux/amba/serial.h>
-#include <linux/delay.h>
 #include <linux/of_platform.h>
 #include <asm/mach/arch.h>
 #include "generic.h"
-#include <mach/spear.h>
-
-/* FIXME: Move SATA PHY code into a standalone driver */
-
-/* Base addresses */
-#define SPEAR1340_SATA_BASE			UL(0xB1000000)
-
-/* Power Management Registers */
-#define SPEAR1340_PCM_CFG			(VA_MISC_BASE + 0x100)
-#define SPEAR1340_PCM_WKUP_CFG			(VA_MISC_BASE + 0x104)
-#define SPEAR1340_SWITCH_CTR			(VA_MISC_BASE + 0x108)
-
-#define SPEAR1340_PERIP1_SW_RST			(VA_MISC_BASE + 0x318)
-#define SPEAR1340_PERIP2_SW_RST			(VA_MISC_BASE + 0x31C)
-#define SPEAR1340_PERIP3_SW_RST			(VA_MISC_BASE + 0x320)
-
-/* PCIE - SATA configuration registers */
-#define SPEAR1340_PCIE_SATA_CFG			(VA_MISC_BASE + 0x424)
-	/* PCIE CFG MASks */
-	#define SPEAR1340_PCIE_CFG_DEVICE_PRESENT	(1 << 11)
-	#define SPEAR1340_PCIE_CFG_POWERUP_RESET	(1 << 10)
-	#define SPEAR1340_PCIE_CFG_CORE_CLK_EN		(1 << 9)
-	#define SPEAR1340_PCIE_CFG_AUX_CLK_EN		(1 << 8)
-	#define SPEAR1340_SATA_CFG_TX_CLK_EN		(1 << 4)
-	#define SPEAR1340_SATA_CFG_RX_CLK_EN		(1 << 3)
-	#define SPEAR1340_SATA_CFG_POWERUP_RESET	(1 << 2)
-	#define SPEAR1340_SATA_CFG_PM_CLK_EN		(1 << 1)
-	#define SPEAR1340_PCIE_SATA_SEL_PCIE		(0)
-	#define SPEAR1340_PCIE_SATA_SEL_SATA		(1)
-	#define SPEAR1340_SATA_PCIE_CFG_MASK		0xF1F
-	#define SPEAR1340_PCIE_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_PCIE | \
-			SPEAR1340_PCIE_CFG_AUX_CLK_EN | \
-			SPEAR1340_PCIE_CFG_CORE_CLK_EN | \
-			SPEAR1340_PCIE_CFG_POWERUP_RESET | \
-			SPEAR1340_PCIE_CFG_DEVICE_PRESENT)
-	#define SPEAR1340_SATA_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_SATA | \
-			SPEAR1340_SATA_CFG_PM_CLK_EN | \
-			SPEAR1340_SATA_CFG_POWERUP_RESET | \
-			SPEAR1340_SATA_CFG_RX_CLK_EN | \
-			SPEAR1340_SATA_CFG_TX_CLK_EN)
-
-#define SPEAR1340_PCIE_MIPHY_CFG		(VA_MISC_BASE + 0x428)
-	#define SPEAR1340_MIPHY_OSC_BYPASS_EXT		(1 << 31)
-	#define SPEAR1340_MIPHY_CLK_REF_DIV2		(1 << 27)
-	#define SPEAR1340_MIPHY_CLK_REF_DIV4		(2 << 27)
-	#define SPEAR1340_MIPHY_CLK_REF_DIV8		(3 << 27)
-	#define SPEAR1340_MIPHY_PLL_RATIO_TOP(x)	(x << 0)
-	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA \
-			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
-			SPEAR1340_MIPHY_CLK_REF_DIV2 | \
-			SPEAR1340_MIPHY_PLL_RATIO_TOP(60))
-	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
-			(SPEAR1340_MIPHY_PLL_RATIO_TOP(120))
-	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
-			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
-			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
-
-/* SATA device registration */
-static int sata_miphy_init(struct device *dev, void __iomem *addr)
-{
-	writel(SPEAR1340_SATA_CFG_VAL, SPEAR1340_PCIE_SATA_CFG);
-	writel(SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK,
-			SPEAR1340_PCIE_MIPHY_CFG);
-	/* Switch on sata power domain */
-	writel((readl(SPEAR1340_PCM_CFG) | (0x800)), SPEAR1340_PCM_CFG);
-	msleep(20);
-	/* Disable PCIE SATA Controller reset */
-	writel((readl(SPEAR1340_PERIP1_SW_RST) & (~0x1000)),
-			SPEAR1340_PERIP1_SW_RST);
-	msleep(20);
-
-	return 0;
-}
-
-void sata_miphy_exit(struct device *dev)
-{
-	writel(0, SPEAR1340_PCIE_SATA_CFG);
-	writel(0, SPEAR1340_PCIE_MIPHY_CFG);
-
-	/* Enable PCIE SATA Controller reset */
-	writel((readl(SPEAR1340_PERIP1_SW_RST) | (0x1000)),
-			SPEAR1340_PERIP1_SW_RST);
-	msleep(20);
-	/* Switch off sata power domain */
-	writel((readl(SPEAR1340_PCM_CFG) & (~0x800)), SPEAR1340_PCM_CFG);
-	msleep(20);
-}
-
-int sata_suspend(struct device *dev)
-{
-	if (dev->power.power_state.event == PM_EVENT_FREEZE)
-		return 0;
-
-	sata_miphy_exit(dev);
-
-	return 0;
-}
-
-int sata_resume(struct device *dev)
-{
-	if (dev->power.power_state.event == PM_EVENT_THAW)
-		return 0;
-
-	return sata_miphy_init(dev, NULL);
-}
-
-static struct ahci_platform_data sata_pdata = {
-	.init = sata_miphy_init,
-	.exit = sata_miphy_exit,
-	.suspend = sata_suspend,
-	.resume = sata_resume,
-};
-
-/* Add SPEAr1340 auxdata to pass platform data */
-static struct of_dev_auxdata spear1340_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("snps,spear-ahci", SPEAR1340_SATA_BASE, NULL,
-			&sata_pdata),
-	{}
-};
 
 static void __init spear1340_dt_init(void)
 {
-	of_platform_populate(NULL, of_default_bus_match_table,
-			spear1340_auxdata_lookup, NULL);
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 	platform_device_register_simple("spear-cpufreq", -1, NULL, 0);
 }
 
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 3bb05f1..0bc93a1 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -166,4 +166,16 @@ config PHY_XGENE
 	help
 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
 
+config PHY_ST_SPEAR1310_MIPHY
+	tristate "ST SPEAR1310-MIPHY driver"
+	select GENERIC_PHY
+	help
+	  Support for ST SPEAr1310 MIPHY which can be used for PCIe and SATA.
+
+config PHY_ST_SPEAR1340_MIPHY
+	tristate "ST SPEAR1340-MIPHY driver"
+	select GENERIC_PHY
+	help
+	  Support for ST SPEAr1340 MIPHY which can be used for PCIe and SATA.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 2faf78e..7b7886a 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -18,3 +18,5 @@ obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
 obj-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
 obj-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
+obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
+obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
diff --git a/drivers/phy/phy-spear1310-miphy.c b/drivers/phy/phy-spear1310-miphy.c
new file mode 100644
index 0000000..6136634
--- /dev/null
+++ b/drivers/phy/phy-spear1310-miphy.c
@@ -0,0 +1,274 @@
+/*
+ * ST SPEAr1310-miphy driver
+ *
+ * Copyright (C) 2014 ST Microelectronics
+ * Pratyush Anand <pratyush.anand@st.com>
+ * Mohit Kumar <mohit.kumar@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/phy/phy.h>
+#include <linux/regmap.h>
+
+/* SPEAr1310 Registers */
+#define SPEAR1310_PCIE_SATA_CFG			0x3A4
+	#define SPEAR1310_PCIE_SATA2_SEL_PCIE		(0 << 31)
+	#define SPEAR1310_PCIE_SATA1_SEL_PCIE		(0 << 30)
+	#define SPEAR1310_PCIE_SATA0_SEL_PCIE		(0 << 29)
+	#define SPEAR1310_PCIE_SATA2_SEL_SATA		BIT(31)
+	#define SPEAR1310_PCIE_SATA1_SEL_SATA		BIT(30)
+	#define SPEAR1310_PCIE_SATA0_SEL_SATA		BIT(29)
+	#define SPEAR1310_SATA2_CFG_TX_CLK_EN		BIT(27)
+	#define SPEAR1310_SATA2_CFG_RX_CLK_EN		BIT(26)
+	#define SPEAR1310_SATA2_CFG_POWERUP_RESET	BIT(25)
+	#define SPEAR1310_SATA2_CFG_PM_CLK_EN		BIT(24)
+	#define SPEAR1310_SATA1_CFG_TX_CLK_EN		BIT(23)
+	#define SPEAR1310_SATA1_CFG_RX_CLK_EN		BIT(22)
+	#define SPEAR1310_SATA1_CFG_POWERUP_RESET	BIT(21)
+	#define SPEAR1310_SATA1_CFG_PM_CLK_EN		BIT(20)
+	#define SPEAR1310_SATA0_CFG_TX_CLK_EN		BIT(19)
+	#define SPEAR1310_SATA0_CFG_RX_CLK_EN		BIT(18)
+	#define SPEAR1310_SATA0_CFG_POWERUP_RESET	BIT(17)
+	#define SPEAR1310_SATA0_CFG_PM_CLK_EN		BIT(16)
+	#define SPEAR1310_PCIE2_CFG_DEVICE_PRESENT	BIT(11)
+	#define SPEAR1310_PCIE2_CFG_POWERUP_RESET	BIT(10)
+	#define SPEAR1310_PCIE2_CFG_CORE_CLK_EN		BIT(9)
+	#define SPEAR1310_PCIE2_CFG_AUX_CLK_EN		BIT(8)
+	#define SPEAR1310_PCIE1_CFG_DEVICE_PRESENT	BIT(7)
+	#define SPEAR1310_PCIE1_CFG_POWERUP_RESET	BIT(6)
+	#define SPEAR1310_PCIE1_CFG_CORE_CLK_EN		BIT(5)
+	#define SPEAR1310_PCIE1_CFG_AUX_CLK_EN		BIT(4)
+	#define SPEAR1310_PCIE0_CFG_DEVICE_PRESENT	BIT(3)
+	#define SPEAR1310_PCIE0_CFG_POWERUP_RESET	BIT(2)
+	#define SPEAR1310_PCIE0_CFG_CORE_CLK_EN		BIT(1)
+	#define SPEAR1310_PCIE0_CFG_AUX_CLK_EN		BIT(0)
+
+	#define SPEAR1310_PCIE_CFG_MASK(x) ((0xF << (x * 4)) | BIT((x + 29)))
+	#define SPEAR1310_SATA_CFG_MASK(x) ((0xF << (x * 4 + 16)) | \
+			BIT((x + 29)))
+	#define SPEAR1310_PCIE_CFG_VAL(x) \
+			(SPEAR1310_PCIE_SATA##x##_SEL_PCIE | \
+			SPEAR1310_PCIE##x##_CFG_AUX_CLK_EN | \
+			SPEAR1310_PCIE##x##_CFG_CORE_CLK_EN | \
+			SPEAR1310_PCIE##x##_CFG_POWERUP_RESET | \
+			SPEAR1310_PCIE##x##_CFG_DEVICE_PRESENT)
+	#define SPEAR1310_SATA_CFG_VAL(x) \
+			(SPEAR1310_PCIE_SATA##x##_SEL_SATA | \
+			SPEAR1310_SATA##x##_CFG_PM_CLK_EN | \
+			SPEAR1310_SATA##x##_CFG_POWERUP_RESET | \
+			SPEAR1310_SATA##x##_CFG_RX_CLK_EN | \
+			SPEAR1310_SATA##x##_CFG_TX_CLK_EN)
+
+#define SPEAR1310_PCIE_MIPHY_CFG_1		0x3A8
+	#define SPEAR1310_MIPHY_DUAL_OSC_BYPASS_EXT	BIT(31)
+	#define SPEAR1310_MIPHY_DUAL_CLK_REF_DIV2	BIT(28)
+	#define SPEAR1310_MIPHY_DUAL_PLL_RATIO_TOP(x)	(x << 16)
+	#define SPEAR1310_MIPHY_SINGLE_OSC_BYPASS_EXT	BIT(15)
+	#define SPEAR1310_MIPHY_SINGLE_CLK_REF_DIV2	BIT(12)
+	#define SPEAR1310_MIPHY_SINGLE_PLL_RATIO_TOP(x)	(x << 0)
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_SATA_MASK (0xFFFF)
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK (0xFFFF << 16)
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_SATA \
+			(SPEAR1310_MIPHY_DUAL_OSC_BYPASS_EXT | \
+			SPEAR1310_MIPHY_DUAL_CLK_REF_DIV2 | \
+			SPEAR1310_MIPHY_DUAL_PLL_RATIO_TOP(60) | \
+			SPEAR1310_MIPHY_SINGLE_OSC_BYPASS_EXT | \
+			SPEAR1310_MIPHY_SINGLE_CLK_REF_DIV2 | \
+			SPEAR1310_MIPHY_SINGLE_PLL_RATIO_TOP(60))
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
+			(SPEAR1310_MIPHY_SINGLE_PLL_RATIO_TOP(120))
+	#define SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE \
+			(SPEAR1310_MIPHY_DUAL_OSC_BYPASS_EXT | \
+			SPEAR1310_MIPHY_DUAL_PLL_RATIO_TOP(25) | \
+			SPEAR1310_MIPHY_SINGLE_OSC_BYPASS_EXT | \
+			SPEAR1310_MIPHY_SINGLE_PLL_RATIO_TOP(25))
+
+#define SPEAR1310_PCIE_MIPHY_CFG_2		0x3AC
+
+enum spear1310_miphy_mode {
+	SATA,
+	PCIE,
+};
+
+struct spear1310_miphy_priv {
+	/* instance id of this phy */
+	u32				id;
+	/* phy mode: 0 for SATA 1 for PCIe */
+	enum spear1310_miphy_mode	mode;
+	/* regmap for any soc specific misc registers */
+	struct regmap			*misc;
+	/* phy struct pointer */
+	struct phy			*phy;
+};
+
+static int spear1310_miphy_pcie_init(struct spear1310_miphy_priv *priv)
+{
+	u32 val;
+
+	regmap_update_bits(priv->misc, SPEAR1310_PCIE_MIPHY_CFG_1,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE);
+
+	switch (priv->id) {
+	case 0:
+		val = SPEAR1310_PCIE_CFG_VAL(0);
+		break;
+	case 1:
+		val = SPEAR1310_PCIE_CFG_VAL(1);
+		break;
+	case 2:
+		val = SPEAR1310_PCIE_CFG_VAL(2);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	regmap_update_bits(priv->misc, SPEAR1310_PCIE_SATA_CFG,
+			SPEAR1310_PCIE_CFG_MASK(priv->id), val);
+
+	return 0;
+}
+
+static int spear1310_miphy_pcie_exit(struct spear1310_miphy_priv *priv)
+{
+	regmap_update_bits(priv->misc, SPEAR1310_PCIE_SATA_CFG,
+			SPEAR1310_PCIE_CFG_MASK(priv->id), 0);
+
+	regmap_update_bits(priv->misc, SPEAR1310_PCIE_MIPHY_CFG_1,
+			SPEAR1310_PCIE_SATA_MIPHY_CFG_PCIE_MASK, 0);
+
+	return 0;
+}
+
+static int spear1310_miphy_init(struct phy *phy)
+{
+	struct spear1310_miphy_priv *priv = phy_get_drvdata(phy);
+	int ret = 0;
+
+	if (priv->mode == PCIE)
+		ret = spear1310_miphy_pcie_init(priv);
+
+	return ret;
+}
+
+static int spear1310_miphy_exit(struct phy *phy)
+{
+	struct spear1310_miphy_priv *priv = phy_get_drvdata(phy);
+	int ret = 0;
+
+	if (priv->mode == PCIE)
+		ret = spear1310_miphy_pcie_exit(priv);
+
+	return ret;
+}
+
+static const struct of_device_id spear1310_miphy_of_match[] = {
+	{ .compatible = "st,spear1310-miphy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, spear1310_miphy_of_match);
+
+static struct phy_ops spear1310_miphy_ops = {
+	.init = spear1310_miphy_init,
+	.exit = spear1310_miphy_exit,
+	.owner = THIS_MODULE,
+};
+
+static struct phy *spear1310_miphy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct spear1310_miphy_priv *priv = dev_get_drvdata(dev);
+
+	if (args->args_count < 1) {
+		dev_err(dev, "DT did not pass correct no of args\n");
+		return NULL;
+	}
+
+	priv->mode = args->args[0];
+
+	if (priv->mode != SATA && priv->mode != PCIE) {
+		dev_err(dev, "DT did not pass correct phy mode\n");
+		return NULL;
+	}
+
+	return priv->phy;
+}
+
+static int __init spear1310_miphy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct spear1310_miphy_priv *priv;
+	struct phy_provider *phy_provider;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(dev, "can't alloc spear1310_miphy private date memory\n");
+		return -ENOMEM;
+	}
+
+	priv->misc =
+		syscon_regmap_lookup_by_phandle(dev->of_node, "misc");
+	if (IS_ERR(priv->misc)) {
+		dev_err(dev, "failed to find misc regmap\n");
+		return PTR_ERR(priv->misc);
+	}
+
+	if (of_property_read_u32(dev->of_node, "phy-id", &priv->id)) {
+		dev_err(dev, "failed to find phy id\n");
+		return -EINVAL;
+	}
+
+	priv->phy = devm_phy_create(dev, &spear1310_miphy_ops, NULL);
+	if (IS_ERR(priv->phy)) {
+		dev_err(dev, "failed to create SATA PCIe PHY\n");
+		return PTR_ERR(priv->phy);
+	}
+
+	dev_set_drvdata(dev, priv);
+	phy_set_drvdata(priv->phy, priv);
+
+	phy_provider =
+		devm_of_phy_provider_register(dev, spear1310_miphy_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(dev, "failed to register phy provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static struct platform_driver spear1310_miphy_driver = {
+	.probe		= spear1310_miphy_probe,
+	.driver = {
+		.name = "spear1310-miphy",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(spear1310_miphy_of_match),
+	},
+};
+
+static int __init spear1310_miphy_phy_init(void)
+{
+	return platform_driver_register(&spear1310_miphy_driver);
+}
+module_init(spear1310_miphy_phy_init);
+
+static void __exit spear1310_miphy_phy_exit(void)
+{
+	platform_driver_unregister(&spear1310_miphy_driver);
+}
+module_exit(spear1310_miphy_phy_exit);
+
+MODULE_DESCRIPTION("ST SPEAR1310-MIPHY driver");
+MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/phy-spear1340-miphy.c b/drivers/phy/phy-spear1340-miphy.c
new file mode 100644
index 0000000..cbaf284
--- /dev/null
+++ b/drivers/phy/phy-spear1340-miphy.c
@@ -0,0 +1,300 @@
+/*
+ * ST spear1340-miphy driver
+ *
+ * Copyright (C) 2014 ST Microelectronics
+ * Pratyush Anand <pratyush.anand@st.com>
+ * Mohit Kumar <mohit.kumar@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/phy/phy.h>
+#include <linux/regmap.h>
+
+/* SPEAr1340 Registers */
+/* Power Management Registers */
+#define SPEAR1340_PCM_CFG			0x100
+	#define SPEAR1340_PCM_CFG_SATA_POWER_EN		BIT(11)
+#define SPEAR1340_PCM_WKUP_CFG			0x104
+#define SPEAR1340_SWITCH_CTR			0x108
+
+#define SPEAR1340_PERIP1_SW_RST			0x318
+	#define SPEAR1340_PERIP1_SW_RSATA		BIT(12)
+#define SPEAR1340_PERIP2_SW_RST			0x31C
+#define SPEAR1340_PERIP3_SW_RST			0x320
+
+/* PCIE - SATA configuration registers */
+#define SPEAR1340_PCIE_SATA_CFG			0x424
+	/* PCIE CFG MASks */
+	#define SPEAR1340_PCIE_CFG_DEVICE_PRESENT	BIT(11)
+	#define SPEAR1340_PCIE_CFG_POWERUP_RESET	BIT(10)
+	#define SPEAR1340_PCIE_CFG_CORE_CLK_EN		BIT(9)
+	#define SPEAR1340_PCIE_CFG_AUX_CLK_EN		BIT(8)
+	#define SPEAR1340_SATA_CFG_TX_CLK_EN		BIT(4)
+	#define SPEAR1340_SATA_CFG_RX_CLK_EN		BIT(3)
+	#define SPEAR1340_SATA_CFG_POWERUP_RESET	BIT(2)
+	#define SPEAR1340_SATA_CFG_PM_CLK_EN		BIT(1)
+	#define SPEAR1340_PCIE_SATA_SEL_PCIE		(0)
+	#define SPEAR1340_PCIE_SATA_SEL_SATA		(1)
+	#define SPEAR1340_PCIE_SATA_CFG_MASK		0xF1F
+	#define SPEAR1340_PCIE_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_PCIE | \
+			SPEAR1340_PCIE_CFG_AUX_CLK_EN | \
+			SPEAR1340_PCIE_CFG_CORE_CLK_EN | \
+			SPEAR1340_PCIE_CFG_POWERUP_RESET | \
+			SPEAR1340_PCIE_CFG_DEVICE_PRESENT)
+	#define SPEAR1340_SATA_CFG_VAL	(SPEAR1340_PCIE_SATA_SEL_SATA | \
+			SPEAR1340_SATA_CFG_PM_CLK_EN | \
+			SPEAR1340_SATA_CFG_POWERUP_RESET | \
+			SPEAR1340_SATA_CFG_RX_CLK_EN | \
+			SPEAR1340_SATA_CFG_TX_CLK_EN)
+
+#define SPEAR1340_PCIE_MIPHY_CFG		0x428
+	#define SPEAR1340_MIPHY_OSC_BYPASS_EXT		BIT(31)
+	#define SPEAR1340_MIPHY_CLK_REF_DIV2		BIT(27)
+	#define SPEAR1340_MIPHY_CLK_REF_DIV4		(2 << 27)
+	#define SPEAR1340_MIPHY_CLK_REF_DIV8		(3 << 27)
+	#define SPEAR1340_MIPHY_PLL_RATIO_TOP(x)	(x << 0)
+	#define SPEAR1340_PCIE_MIPHY_CFG_MASK		0xF80000FF
+	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA \
+			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
+			SPEAR1340_MIPHY_CLK_REF_DIV2 | \
+			SPEAR1340_MIPHY_PLL_RATIO_TOP(60))
+	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK \
+			(SPEAR1340_MIPHY_PLL_RATIO_TOP(120))
+	#define SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE \
+			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
+			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
+
+enum spear1340_miphy_mode {
+	SATA,
+	PCIE,
+};
+
+struct spear1340_miphy_priv {
+	/* phy mode: 0 for SATA 1 for PCIe */
+	enum spear1340_miphy_mode	mode;
+	/* regmap for any soc specific misc registers */
+	struct regmap			*misc;
+	/* phy struct pointer */
+	struct phy			*phy;
+};
+
+static int spear1340_miphy_sata_init(struct spear1340_miphy_priv *priv)
+{
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, SPEAR1340_SATA_CFG_VAL);
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK,
+			SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK);
+	/* Switch on sata power domain */
+	regmap_update_bits(priv->misc, SPEAR1340_PCM_CFG,
+			SPEAR1340_PCM_CFG_SATA_POWER_EN,
+			SPEAR1340_PCM_CFG_SATA_POWER_EN);
+	msleep(20);
+	/* Disable PCIE SATA Controller reset */
+	regmap_update_bits(priv->misc, SPEAR1340_PERIP1_SW_RST,
+			SPEAR1340_PERIP1_SW_RSATA, 0);
+	msleep(20);
+
+	return 0;
+}
+
+static int spear1340_miphy_sata_exit(struct spear1340_miphy_priv *priv)
+{
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, 0);
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK, 0);
+
+	/* Enable PCIE SATA Controller reset */
+	regmap_update_bits(priv->misc, SPEAR1340_PERIP1_SW_RST,
+			SPEAR1340_PERIP1_SW_RSATA,
+			SPEAR1340_PERIP1_SW_RSATA);
+	msleep(20);
+	/* Switch off sata power domain */
+	regmap_update_bits(priv->misc, SPEAR1340_PCM_CFG,
+			SPEAR1340_PCM_CFG_SATA_POWER_EN, 0);
+	msleep(20);
+
+	return 0;
+}
+
+static int spear1340_miphy_pcie_init(struct spear1340_miphy_priv *priv)
+{
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK,
+			SPEAR1340_PCIE_SATA_MIPHY_CFG_PCIE);
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, SPEAR1340_PCIE_CFG_VAL);
+
+	return 0;
+}
+
+static int spear1340_miphy_pcie_exit(struct spear1340_miphy_priv *priv)
+{
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK, 0);
+	regmap_update_bits(priv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, 0);
+
+	return 0;
+}
+
+static int spear1340_miphy_init(struct phy *phy)
+{
+	struct spear1340_miphy_priv *priv = phy_get_drvdata(phy);
+	int ret = 0;
+
+	if (priv->mode == SATA)
+		ret = spear1340_miphy_sata_init(priv);
+	else if (priv->mode == PCIE)
+		ret = spear1340_miphy_pcie_init(priv);
+
+	return ret;
+}
+
+static int spear1340_miphy_exit(struct phy *phy)
+{
+	struct spear1340_miphy_priv *priv = phy_get_drvdata(phy);
+	int ret = 0;
+
+	if (priv->mode == SATA)
+		ret = spear1340_miphy_sata_exit(priv);
+	else if (priv->mode == PCIE)
+		ret = spear1340_miphy_pcie_exit(priv);
+
+	return ret;
+}
+
+static const struct of_device_id spear1340_miphy_of_match[] = {
+	{ .compatible = "st,spear1340-miphy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, spear1340_miphy_of_match);
+
+static struct phy_ops spear1340_miphy_ops = {
+	.init = spear1340_miphy_init,
+	.exit = spear1340_miphy_exit,
+	.owner = THIS_MODULE,
+};
+
+#ifdef CONFIG_PM_SLEEP
+static int spear1340_miphy_suspend(struct device *dev)
+{
+	struct spear1340_miphy_priv *priv = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (priv->mode == SATA)
+		ret = spear1340_miphy_sata_exit(priv);
+
+	return ret;
+}
+
+static int spear1340_miphy_resume(struct device *dev)
+{
+	struct spear1340_miphy_priv *priv = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (priv->mode == SATA)
+		ret = spear1340_miphy_sata_init(priv);
+
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(spear1340_miphy_pm_ops, spear1340_miphy_suspend,
+		spear1340_miphy_resume);
+
+static struct phy *spear1340_miphy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct spear1340_miphy_priv *priv = dev_get_drvdata(dev);
+
+	if (args->args_count < 1) {
+		dev_err(dev, "DT did not pass correct no of args\n");
+		return NULL;
+	}
+
+	priv->mode = args->args[0];
+
+	if (priv->mode != SATA && priv->mode != PCIE) {
+		dev_err(dev, "DT did not pass correct phy mode\n");
+		return NULL;
+	}
+
+	return priv->phy;
+}
+
+static int __init spear1340_miphy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct spear1340_miphy_priv *priv;
+	struct phy_provider *phy_provider;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(dev, "can't alloc spear1340_miphy private date memory\n");
+		return -ENOMEM;
+	}
+
+	priv->misc =
+		syscon_regmap_lookup_by_phandle(dev->of_node, "misc");
+	if (IS_ERR(priv->misc)) {
+		dev_err(dev, "failed to find misc regmap\n");
+		return PTR_ERR(priv->misc);
+	}
+
+	priv->phy = devm_phy_create(dev, &spear1340_miphy_ops, NULL);
+	if (IS_ERR(priv->phy)) {
+		dev_err(dev, "failed to create SATA PCIe PHY\n");
+		return PTR_ERR(priv->phy);
+	}
+
+	dev_set_drvdata(dev, priv);
+	phy_set_drvdata(priv->phy, priv);
+
+	phy_provider =
+		devm_of_phy_provider_register(dev, spear1340_miphy_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(dev, "failed to register phy provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static struct platform_driver spear1340_miphy_driver = {
+	.probe		= spear1340_miphy_probe,
+	.driver = {
+		.name = "spear1340-miphy",
+		.owner = THIS_MODULE,
+		.pm = &spear1340_miphy_pm_ops,
+		.of_match_table = of_match_ptr(spear1340_miphy_of_match),
+	},
+};
+
+static int __init spear1340_miphy_phy_init(void)
+{
+	return platform_driver_register(&spear1340_miphy_driver);
+}
+module_init(spear1340_miphy_phy_init);
+
+static void __exit spear1340_miphy_phy_exit(void)
+{
+	platform_driver_unregister(&spear1340_miphy_driver);
+}
+module_exit(spear1340_miphy_phy_exit);
+
+MODULE_DESCRIPTION("ST SPEAR1340-MIPHY driver");
+MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.0.1

