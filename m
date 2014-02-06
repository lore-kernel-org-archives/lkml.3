Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaBFEqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 23:46:09 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:36971 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbaBFEp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 23:45:59 -0500
From: Pratyush Anand <pratyush.anand@st.com>
To: <arnd@arndb.de>
Cc: Pratyush Anand <pratyush.anand@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>, Tejun Heo <tj@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>, <spear-devel@list.st.com>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V4 5/8] SPEAr13xx: Fixup: Move SPEAr1340 SATA platform code to phy driver
Date: Thu, 6 Feb 2014 10:14:52 +0530
Message-ID: <ab13bc3c8147974e58425604667737723c3aa3a6.1391661589.git.pratyush.anand@st.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1391661589.git.pratyush.anand@st.com>
References: <cover.1391661589.git.pratyush.anand@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ahci driver needs some platform specific functions which are called at
init, exit, suspend and resume conditions. Till now these functions were
present in a platform driver with a fixme notes.

Similar functions modifying same set of registers will also be needed in
case of PCIe phy init/exit.

So move all these SATA platform code to phy-miphy40lp driver.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Tested-by: Mohit Kumar <mohit.kumar@st.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: spear-devel@list.st.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/arm/spear-misc.txt         |   4 +
 arch/arm/boot/dts/spear1310-evb.dts                |   4 +
 arch/arm/boot/dts/spear1310.dtsi                   |  39 +++-
 arch/arm/boot/dts/spear1340-evb.dts                |   4 +
 arch/arm/boot/dts/spear1340.dtsi                   |  13 +-
 arch/arm/boot/dts/spear13xx.dtsi                   |   5 +
 arch/arm/mach-spear/Kconfig                        |   2 +
 arch/arm/mach-spear/spear1340.c                    | 127 +------------
 drivers/phy/phy-miphy40lp.c                        | 204 ++++++++++++++++++++-
 9 files changed, 266 insertions(+), 136 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/spear-misc.txt

diff --git a/Documentation/devicetree/bindings/arm/spear-misc.txt b/Documentation/devicetree/bindings/arm/spear-misc.txt
new file mode 100644
index 0000000..aacd36a
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/spear-misc.txt
@@ -0,0 +1,4 @@
+* SPEAr Misc configuration
+** misc node required properties:
+- compatible Should be	"st,spear1340-misc", "syscon".
+- reg: Address range of misc space
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
index 54d128d..7e3a04b 100644
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -31,10 +31,21 @@
 			status = "disabled";
 		};
 
-		ahci@b1000000 {
+		miphy0: miphy@eb800000 {
+			compatible = "st,miphy", "st,spear1340-miphy";
+			reg = <0xeb800000 0x4000>;
+			misc = <&misc>;
+			phy-id = <0>;
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
index ac1710e6..7e7f1b0 100644
--- a/arch/arm/mach-spear/Kconfig
+++ b/arch/arm/mach-spear/Kconfig
@@ -26,6 +26,8 @@ config ARCH_SPEAR13XX
 	select MIGHT_HAVE_CACHE_L2X0
 	select PINCTRL
 	select USE_OF
+	select MFD_SYSCON
+	select PHY_ST_MIPHY40LP
 	help
 	  Supports for ARM's SPEAR13XX family
 
diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
index 3fb6834..8e27093 100644
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
 }
 
 static const char * const spear1340_dt_board_compat[] = {
diff --git a/drivers/phy/phy-miphy40lp.c b/drivers/phy/phy-miphy40lp.c
index d478c14..cc7f45d 100644
--- a/drivers/phy/phy-miphy40lp.c
+++ b/drivers/phy/phy-miphy40lp.c
@@ -8,6 +8,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
+ * 04/02/2014: Adding support of SATA mode for SPEAr1340.
  */
 
 #include <linux/delay.h>
@@ -19,6 +20,60 @@
 #include <linux/phy/phy.h>
 #include <linux/regmap.h>
 
+/* SPEAr1340 Registers */
+/* Power Management Registers */
+#define SPEAR1340_PCM_CFG			0x100
+	#define SPEAR1340_PCM_CFG_SATA_POWER_EN	0x800
+#define SPEAR1340_PCM_WKUP_CFG			0x104
+#define SPEAR1340_SWITCH_CTR			0x108
+
+#define SPEAR1340_PERIP1_SW_RST			0x318
+	#define SPEAR1340_PERIP1_SW_RST_SATA	0x1000
+#define SPEAR1340_PERIP2_SW_RST			0x31C
+#define SPEAR1340_PERIP3_SW_RST			0x320
+
+/* PCIE - SATA configuration registers */
+#define SPEAR1340_PCIE_SATA_CFG			0x424
+	/* PCIE CFG MASks */
+	#define SPEAR1340_PCIE_CFG_DEVICE_PRESENT	(1 << 11)
+	#define SPEAR1340_PCIE_CFG_POWERUP_RESET	(1 << 10)
+	#define SPEAR1340_PCIE_CFG_CORE_CLK_EN		(1 << 9)
+	#define SPEAR1340_PCIE_CFG_AUX_CLK_EN		(1 << 8)
+	#define SPEAR1340_SATA_CFG_TX_CLK_EN		(1 << 4)
+	#define SPEAR1340_SATA_CFG_RX_CLK_EN		(1 << 3)
+	#define SPEAR1340_SATA_CFG_POWERUP_RESET	(1 << 2)
+	#define SPEAR1340_SATA_CFG_PM_CLK_EN		(1 << 1)
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
+	#define SPEAR1340_MIPHY_OSC_BYPASS_EXT		(1 << 31)
+	#define SPEAR1340_MIPHY_CLK_REF_DIV2		(1 << 27)
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
 enum phy_mode {
 	SATA,
 	PCIE,
@@ -38,28 +93,145 @@ struct st_miphy40lp_priv {
 	u32			id;
 };
 
+static int spear1340_sata_miphy_init(struct st_miphy40lp_priv *phypriv)
+{
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, SPEAR1340_SATA_CFG_VAL);
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK,
+			SPEAR1340_PCIE_SATA_MIPHY_CFG_SATA_25M_CRYSTAL_CLK);
+	/* Switch on sata power domain */
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCM_CFG,
+			SPEAR1340_PCM_CFG_SATA_POWER_EN,
+			SPEAR1340_PCM_CFG_SATA_POWER_EN);
+	msleep(20);
+	/* Disable PCIE SATA Controller reset */
+	regmap_update_bits(phypriv->misc, SPEAR1340_PERIP1_SW_RST,
+			SPEAR1340_PERIP1_SW_RST_SATA, 0);
+	msleep(20);
+
+	return 0;
+}
+
+static int spear1340_sata_miphy_exit(struct st_miphy40lp_priv *phypriv)
+{
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_SATA_CFG,
+			SPEAR1340_PCIE_SATA_CFG_MASK, 0);
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCIE_MIPHY_CFG,
+			SPEAR1340_PCIE_MIPHY_CFG_MASK, 0);
+
+	/* Enable PCIE SATA Controller reset */
+	regmap_update_bits(phypriv->misc, SPEAR1340_PERIP1_SW_RST,
+			SPEAR1340_PERIP1_SW_RST_SATA,
+			SPEAR1340_PERIP1_SW_RST_SATA);
+	msleep(20);
+	/* Switch off sata power domain */
+	regmap_update_bits(phypriv->misc, SPEAR1340_PCM_CFG,
+			SPEAR1340_PCM_CFG_SATA_POWER_EN, 0);
+	msleep(20);
+
+	return 0;
+}
+
+static int sata_miphy_init(struct st_miphy40lp_priv *phypriv)
+{
+	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
+		return spear1340_sata_miphy_init(phypriv);
+	else
+		return -EINVAL;
+}
+
+static int sata_miphy_exit(struct st_miphy40lp_priv *phypriv)
+{
+	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
+		return spear1340_sata_miphy_exit(phypriv);
+	else
+		return -EINVAL;
+}
+
+static int sata_miphy_power_off(struct st_miphy40lp_priv *phypriv)
+{
+	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
+		return 0;
+	else
+		return -EINVAL;
+}
+
+static int sata_miphy_power_on(struct st_miphy40lp_priv *phypriv)
+{
+	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
+		return 0;
+	else
+		return -EINVAL;
+}
+
+static int sata_miphy_suspend(struct st_miphy40lp_priv *phypriv)
+{
+	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
+		return spear1340_sata_miphy_exit(phypriv);
+	else
+		return -EINVAL;
+}
+
+static int sata_miphy_resume(struct st_miphy40lp_priv *phypriv)
+{
+	if (of_device_is_compatible(phypriv->np, "st,spear1340-miphy"))
+		return spear1340_sata_miphy_init(phypriv);
+	else
+		return -EINVAL;
+}
+
 static int miphy40lp_init(struct phy *phy)
 {
-	return -EINVAL;
+	struct st_miphy40lp_priv *phypriv = phy_get_drvdata(phy);
+
+	switch (phypriv->mode) {
+	case SATA:
+		return sata_miphy_init(phypriv);
+	default:
+		return -EINVAL;
+	}
 }
 
 static int miphy40lp_exit(struct phy *phy)
 {
-	return -EINVAL;
+	struct st_miphy40lp_priv *phypriv = phy_get_drvdata(phy);
+
+	switch (phypriv->mode) {
+	case SATA:
+		return sata_miphy_exit(phypriv);
+	default:
+		return -EINVAL;
+	}
 }
 
 static int miphy40lp_power_off(struct phy *phy)
 {
-	return -EINVAL;
+	struct st_miphy40lp_priv *phypriv = phy_get_drvdata(phy);
+
+	switch (phypriv->mode) {
+	case SATA:
+		return sata_miphy_power_off(phypriv);
+	default:
+		return -EINVAL;
+	}
 }
 
 static int miphy40lp_power_on(struct phy *phy)
 {
-	return -EINVAL;
+	struct st_miphy40lp_priv *phypriv = phy_get_drvdata(phy);
+
+	switch (phypriv->mode) {
+	case SATA:
+		return sata_miphy_power_on(phypriv);
+	default:
+		return -EINVAL;
+	}
 }
 
 static const struct of_device_id st_miphy40lp_of_match[] = {
 	{ .compatible = "st,miphy40lp-phy" },
+	{ .compatible = "st,spear1340-miphy" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, st_miphy40lp_of_match);
@@ -75,12 +247,32 @@ static struct phy_ops st_miphy40lp_ops = {
 #ifdef CONFIG_PM_SLEEP
 static int miphy40lp_suspend(struct device *dev)
 {
-	return -EINVAL;
+	struct st_miphy40lp_priv *phypriv = dev_get_drvdata(dev);
+
+	if (dev->power.power_state.event == PM_EVENT_FREEZE)
+		return 0;
+
+	switch (phypriv->mode) {
+	case SATA:
+		return sata_miphy_suspend(phypriv);
+	default:
+		return -EINVAL;
+	}
 }
 
 static int miphy40lp_resume(struct device *dev)
 {
-	return -EINVAL;
+	struct st_miphy40lp_priv *phypriv = dev_get_drvdata(dev);
+
+	if (dev->power.power_state.event == PM_EVENT_THAW)
+		return 0;
+
+	switch (phypriv->mode) {
+	case SATA:
+		return sata_miphy_resume(phypriv);
+	default:
+		return -EINVAL;
+	}
 }
 #endif
 
-- 
1.8.1.2

