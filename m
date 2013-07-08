Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3GHI0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:26:11 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:34493 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696Ab3GHIZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:25:40 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v1 3/4] ARM: STi: Add STiH415 ethernet support.
Date: Mon,  8 Jul 2013 09:18:13 +0100
Message-Id: <1373271493-11672-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds support to STiH415 SOC, which has two ethernet
snps,dwmac controllers version 3.610. With this patch B2000 and B2020
boards can boot with ethernet in MII and RGMII modes.

Tested on both B2020 and B2000.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/boot/dts/stih415-pinctrl.dtsi |   82 ++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi         |   34 +++++++
 arch/arm/boot/dts/stih41x-b2000.dtsi   |   21 ++++
 arch/arm/boot/dts/stih41x-b2020.dtsi   |   14 +++
 arch/arm/mach-sti/Makefile             |    2 +-
 arch/arm/mach-sti/board-dt.c           |    2 +
 arch/arm/mach-sti/stih41x.c            |  166 ++++++++++++++++++++++++++++++++
 arch/arm/mach-sti/stih41x.h            |    4 +
 8 files changed, 324 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-sti/stih41x.c
 create mode 100644 arch/arm/mach-sti/stih41x.h

diff --git a/arch/arm/boot/dts/stih415-pinctrl.dtsi b/arch/arm/boot/dts/stih415-pinctrl.dtsi
index 1d322b2..c087af8 100644
--- a/arch/arm/boot/dts/stih415-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stih415-pinctrl.dtsi
@@ -86,6 +86,57 @@
 					};
 				};
 			};
+
+			gmac1 {
+				pinctrl_mii1: mii1 {
+						st,pins {
+						 txd0   = <&PIO0 0 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txd1   = <&PIO0 1 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txd2   = <&PIO0 2 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txd3   = <&PIO0 3 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txer   = <&PIO0 4 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txen   = <&PIO0 5 ALT1 OUT  SE_NICLK_IO	0	CLK_A>;
+						 txclk  = <&PIO0 6 ALT1 IN   NICLK	0	CLK_A>;
+						 col    = <&PIO0 7 ALT1 IN   BYPASS	1000>;
+						 mdio   = <&PIO1 0 ALT1 OUT  BYPASS	0>;
+						 mdc    = <&PIO1 1 ALT1 OUT  NICLK	0	CLK_A>;
+						 crs    = <&PIO1 2 ALT1 IN   BYPASS	1000>;
+						 mdint  = <&PIO1 3 ALT1 IN   BYPASS	0>;
+						 rxd0   = <&PIO1 4 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxd1   = <&PIO1 5 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxd2   = <&PIO1 6 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxd3   = <&PIO1 7 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxdv   = <&PIO2 0 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rx_er  = <&PIO2 1 ALT1 IN   SE_NICLK_IO	0	CLK_A>;
+						 rxclk  = <&PIO2 2 ALT1 IN   NICLK	0	CLK_A>;
+						 phyclk = <&PIO2 3 ALT1 IN   NICLK	1000	CLK_A>;
+					};
+				};
+
+				pinctrl_rgmii1: rgmii1-0 {
+					st,pins {
+						 txd0 =	 <&PIO0 0 ALT1 OUT DE_IO	1000	CLK_A>;
+						 txd1 =	 <&PIO0 1 ALT1 OUT DE_IO	1000	CLK_A>;
+						 txd2 =	 <&PIO0 2 ALT1 OUT DE_IO	1000	CLK_A>;
+						 txd3 =	 <&PIO0 3 ALT1 OUT DE_IO	1000	CLK_A>;
+						 txen =	 <&PIO0 5 ALT1 OUT DE_IO	0	CLK_A>;
+						 txclk = <&PIO0 6 ALT1 IN	NICLK	0	CLK_A>;
+						 mdio =	 <&PIO1 0 ALT1 OUT	BYPASS	0>;
+						 mdc =	 <&PIO1 1 ALT1 OUT	NICLK	0	CLK_A>;
+						 rxd0 =	 <&PIO1 4 ALT1 IN DE_IO	0	CLK_A>;
+						 rxd1 =	 <&PIO1 5 ALT1 IN DE_IO	0	CLK_A>;
+						 rxd2 =	 <&PIO1 6 ALT1 IN DE_IO	0	CLK_A>;
+						 rxd3 =	 <&PIO1 7 ALT1 IN DE_IO	0	CLK_A>;
+
+						 rxdv =	  <&PIO2 0 ALT1 IN DE_IO	500	CLK_A>;
+						 rxclk =  <&PIO2 2 ALT1 IN	NICLK	0	CLK_A>;
+						 phyclk = <&PIO2 3 ALT4 OUT	NICLK	0	CLK_B>;
+
+						 clk125= <&PIO3 7 ALT4 IN 	NICLK	0	CLK_A>;
+					};
+				};
+			};
+
 		};
 
 		pin-controller-front {
@@ -197,6 +248,37 @@
 					};
 				};
 			};
+
+			gmac0{
+				pinctrl_mii0: mii0 {
+					st,pins {
+					 mdint =	<&PIO13 6 ALT2	IN	BYPASS		0>;
+					 txen =		<&PIO13 7 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
+
+					 txd0 =		<&PIO14 0 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
+					 txd1 =		<&PIO14 1 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
+					 txd2 =		<&PIO14 2 ALT2	OUT	SE_NICLK_IO	0	CLK_B>;
+					 txd3 =		<&PIO14 3 ALT2	OUT	SE_NICLK_IO	0	CLK_B>;
+
+					 txclk =	<&PIO15 0 ALT2	IN	NICLK		0	CLK_A>;
+					 txer =		<&PIO15 1 ALT2	OUT	SE_NICLK_IO	0	CLK_A>;
+					 crs =		<&PIO15 2 ALT2	IN	BYPASS		1000>;
+					 col =		<&PIO15 3 ALT2	IN	BYPASS		1000>;
+					 mdio  =        <&PIO15 4 ALT2	OUT	BYPASS 	3000>;
+					 mdc   =        <&PIO15 5 ALT2	OUT     NICLK  	0    	CLK_B>;
+
+					 rxd0 =		<&PIO16 0 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxd1 =		<&PIO16 1 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxd2 =		<&PIO16 2 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxd3 =		<&PIO16 3 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxdv =		<&PIO15 6 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rx_er =	<&PIO15 7 ALT2	IN	SE_NICLK_IO	0	CLK_A>;
+					 rxclk =	<&PIO17 0 ALT2	IN	NICLK		0	CLK_A>;
+					 phyclk =	<&PIO13 5 ALT2	OUT	NICLK	1000	CLK_A>;
+
+					};
+				};
+			};
 		};
 
 		pin-controller-left {
diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index 74ab8de..a77939d 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -83,5 +83,39 @@
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_sbc_serial1>;
 		};
+
+		ethernet0: ethernet@fe810000{
+			device_type 	= "network";
+			compatible	= "snps,dwmac", "snps,dwmac-3.610";
+			status 		= "disabled";
+			reg 		= <0xfe810000 0x8000>;
+			interrupts 	= <0 147 0>;
+			interrupt-names = "macirq";
+
+			snps,pbl 	= <32>;
+			snps,mixed-burst;
+
+			pinctrl-names 	= "default";
+			pinctrl-0	= <&pinctrl_mii0>;
+			clock-names	= "stmmaceth";
+			clocks		= <&CLKS_ICN_REG_0>;
+		};
+
+		ethernet1: ethernet@fef08000 {
+			device_type = "network";
+			compatible	= "snps,dwmac", "snps,dwmac-3.610";
+			status 		= "disabled";
+			reg		= <0xfef08000 0x8000>;
+			interrupts	= <0 150 0>;
+			interrupt-names = "macirq";
+
+			snps,pbl	= <32>;
+			snps,mixed-burst;
+
+			pinctrl-names 	= "default";
+			pinctrl-0	= <&pinctrl_mii1>;
+			clock-names	= "stmmaceth";
+			clocks		= <&CLKS_ICN_REG_0>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/stih41x-b2000.dtsi b/arch/arm/boot/dts/stih41x-b2000.dtsi
index 8e694d2..55e68d3 100644
--- a/arch/arm/boot/dts/stih41x-b2000.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2000.dtsi
@@ -20,6 +20,8 @@
 
 	aliases {
 		ttyAS0 = &serial2;
+		ethernet0 = &ethernet0;
+		ethernet1 = &ethernet1;
 	};
 
 	soc {
@@ -37,5 +39,24 @@
 			};
 		};
 
+		ethernet0: ethernet@fe810000 {
+			status			= "okay";
+			phy-mode		= "mii";
+			snps,phy-addr 		= <0x1>;
+
+			snps,reset-gpio 	= <&PIO106 2>;
+			snps,reset-active-low;
+			snps,reset-delays-us 	= <0 10000 10000>;
+		};
+		ethernet1: ethernet@fef08000 {
+			status			= "okay";
+			phy-mode		= "mii";
+			snps,phy-addr 		= <0x1>;
+
+			snps,reset-gpio 	= <&PIO4 7>;
+			snps,reset-active-low;
+			snps,reset-delays-us 	= <0 10000 10000>;
+		};
+
 	};
 };
diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
index 133e181..bc5818d 100644
--- a/arch/arm/boot/dts/stih41x-b2020.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
@@ -19,6 +19,7 @@
 
 	aliases {
 		ttyAS0 = &sbc_serial1;
+		ethernet1 = &ethernet1;
 	};
 	soc {
 		sbc_serial1: serial@fe531000 {
@@ -38,5 +39,18 @@
 				default-state = "off";
 			};
 		};
+
+		ethernet1: ethernet@fef08000 {
+			status			= "okay";
+			phy-mode		= "rgmii-id";
+			snps,phy-addr 		= <0x1>;
+
+			snps,reset-gpio 	= <&PIO3 0>;
+			snps,reset-active-low;
+			snps,reset-delays-us 	= <0 10000 10000>;
+
+			pinctrl-0	= <&pinctrl_rgmii1>;
+		};
+
 	};
 };
diff --git a/arch/arm/mach-sti/Makefile b/arch/arm/mach-sti/Makefile
index acb3309..daffc49 100644
--- a/arch/arm/mach-sti/Makefile
+++ b/arch/arm/mach-sti/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
-obj-$(CONFIG_ARCH_STI) 		+= board-dt.o
+obj-$(CONFIG_ARCH_STI) 		+= board-dt.o stih41x.o
diff --git a/arch/arm/mach-sti/board-dt.c b/arch/arm/mach-sti/board-dt.c
index 8fe6f0c..80080e3 100644
--- a/arch/arm/mach-sti/board-dt.c
+++ b/arch/arm/mach-sti/board-dt.c
@@ -14,6 +14,7 @@
 #include <asm/mach/arch.h>
 
 #include "smp.h"
+#include "stih41x.h"
 
 void __init stih41x_l2x0_init(void)
 {
@@ -43,6 +44,7 @@ static const char *stih41x_dt_match[] __initdata = {
 
 DT_MACHINE_START(STM, "STiH415/416 SoC with Flattened Device Tree")
 	.init_time	= stih41x_timer_init,
+	.init_machine	= stih41x_init_machine,
 	.smp		= smp_ops(sti_smp_ops),
 	.dt_compat	= stih41x_dt_match,
 MACHINE_END
diff --git a/arch/arm/mach-sti/stih41x.c b/arch/arm/mach-sti/stih41x.c
new file mode 100644
index 0000000..c32ac40
--- /dev/null
+++ b/arch/arm/mach-sti/stih41x.c
@@ -0,0 +1,166 @@
+/*
+ * Copyright (C) 2013 STMicroelectronics Limited
+ * Author: Srinivas Kandagatla <srinivas.kandagatla@st.com>
+ *
+ * May be copied or modified under the terms of the GNU General Public
+ * License.  See linux/COPYING for more information.
+ */
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/syscon.h>
+#include <linux/stmmac.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/regmap.h>
+#include <linux/phy.h>
+
+#define STIH415_SYSCFG_SBC(num)			(num*4)
+#define STIH415_SYSCFG_REAR(num)		((num - 300)*4)
+#define STIH415_SYSCFG_FRONT(num)		((num - 100)*4)
+
+#define STIH415_SYSCFG_ETH0_CONFIG_REG		STIH415_SYSCFG_REAR(382)
+#define STIH415_SYSCFG_EN_GMAC0_REG		STIH415_SYSCFG_FRONT(166)
+#define STIH415_SYSCFG_ETH1_CONFIG_REG		STIH415_SYSCFG_SBC(29)
+#define STIH415_SYSCFG_EN_GMAC1_REG		STIH415_SYSCFG_SBC(31)
+
+/* STiH416 */
+#define STIH416_SYSCFG_SBC(num)			(num*4)
+#define STIH416_SYSCFG_REAR(num)		((num - 2000)*4)
+#define STIH416_SYSCFG_FRONT(num)		((num - 1000)*4)
+
+#define STIH416_SYSCFG_EN_GMAC0_REG		STIH416_SYSCFG_FRONT(1539)
+#define STIH416_SYSCFG_ETH0_CONFIG_REG		STIH416_SYSCFG_REAR(2559)
+#define STIH416_SYSCFG_EN_GMAC1_REG		STIH416_SYSCFG_SBC(510)
+#define STIH416_SYSCFG_ETH1_CONFIG_REG		STIH416_SYSCFG_SBC(508)
+
+#define MAX_ETHS		2
+
+struct eth_syscfg {
+	const char *en_syscfg;
+	const char *cfg_syscfg;
+	u32 en_reg;
+	u32 cfg_reg;
+};
+
+struct eth_syscfg stih415_eth_config[MAX_ETHS] = {
+	[0] = {
+		.en_syscfg	= "st,stih415-front-syscfg",
+		.en_reg		= STIH415_SYSCFG_EN_GMAC0_REG,
+		.cfg_syscfg	= "st,stih415-rear-syscfg",
+		.cfg_reg	= STIH415_SYSCFG_ETH0_CONFIG_REG,
+	},
+	[1] = {
+		.en_syscfg	= "st,stih415-sbc-syscfg",
+		.en_reg		= STIH415_SYSCFG_EN_GMAC1_REG,
+		.cfg_syscfg	= "st,stih415-sbc-syscfg",
+		.cfg_reg	= STIH415_SYSCFG_ETH1_CONFIG_REG,
+	}
+};
+
+struct eth_syscfg stih416_eth_config[MAX_ETHS] = {
+	[0] = {
+		.en_syscfg	= "st,stih416-front-syscfg",
+		.en_reg		= STIH416_SYSCFG_EN_GMAC0_REG,
+		.cfg_syscfg	= "st,stih416-rear-syscfg",
+		.cfg_reg	= STIH416_SYSCFG_ETH0_CONFIG_REG,
+	},
+	[1] = {
+		.en_syscfg	= "st,stih416-sbc-syscfg",
+		.en_reg		= STIH416_SYSCFG_EN_GMAC1_REG,
+		.cfg_syscfg	= "st,stih416-sbc-syscfg",
+		.cfg_reg	= STIH416_SYSCFG_ETH1_CONFIG_REG,
+	}
+};
+
+static struct eth_syscfg *stih41x_eth_syscfg;
+
+static u32 eth_configs[] = {
+	[PHY_INTERFACE_MODE_MII]	= 0x060,
+	[PHY_INTERFACE_MODE_GMII]	= 0x020,
+	[PHY_INTERFACE_MODE_RMII]	= 0x1b0,
+	[PHY_INTERFACE_MODE_RGMII]	= 0x024,
+	[PHY_INTERFACE_MODE_RGMII_ID]	= 0x024,
+};
+
+static int stih41x_setup_ethernet(struct plat_stmmacenet_data *plat_data,
+				int ext_phyclk)
+{
+	int phy_mode  = plat_data->interface;
+	int bus_id = plat_data->bus_id;
+	struct regmap *regmap_en, *regmap_cfg;
+	u32 eth_config;
+	struct eth_syscfg *syscfg;
+
+	if (bus_id < 0 || bus_id > MAX_ETHS)
+		return -EINVAL;
+
+	syscfg = &stih41x_eth_syscfg[bus_id];
+
+	if (!syscfg)
+		return -EINVAL;
+
+	regmap_en = syscon_regmap_lookup_by_compatible(syscfg->en_syscfg);
+	regmap_cfg = syscon_regmap_lookup_by_compatible(syscfg->cfg_syscfg);
+
+	if (IS_ERR(regmap_en) || IS_ERR(regmap_cfg))
+		return -EINVAL;
+
+	eth_config = eth_configs[phy_mode];
+	if (!ext_phyclk) /* internal clock */
+		eth_config |= 0x180;
+
+	regmap_write(regmap_en, syscfg->en_reg, 1);
+	regmap_write(regmap_cfg, syscfg->cfg_reg, eth_config);
+	return 0;
+}
+
+static int stih41x_init_ethernet(struct platform_device *pdev)
+{
+	struct plat_stmmacenet_data *plat_data = pdev->dev.platform_data;
+
+	if (stih41x_setup_ethernet(plat_data, 1))
+		return -EINVAL;
+
+	/* Will be used in speed selection */
+	plat_data->bsp_priv = pdev;
+
+	return 0;
+}
+
+static void stih41x_fix_mac_speed(void *priv, unsigned int spd)
+{
+	struct platform_device *pdev = priv;
+	struct plat_stmmacenet_data *plat_data = pdev->dev.platform_data;
+
+	/* On B2020 use internal clock at 25MHz for 100 link in RGMII mode */
+	if (plat_data->interface != PHY_INTERFACE_MODE_MII)
+		stih41x_setup_ethernet(plat_data, (spd == SPEED_1000) ? 1 : 0);
+}
+
+static struct plat_stmmacenet_data stih41x_eth0_pdata = {
+	.init = &stih41x_init_ethernet,
+	.fix_mac_speed = &stih41x_fix_mac_speed,
+};
+
+static struct plat_stmmacenet_data stih41x_eth1_pdata = {
+	.init = &stih41x_init_ethernet,
+	.fix_mac_speed = &stih41x_fix_mac_speed,
+};
+
+struct of_dev_auxdata stih41x_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("snps,dwmac", 0xfe810000, NULL, &stih41x_eth0_pdata),
+	OF_DEV_AUXDATA("snps,dwmac", 0xfef08000, NULL, &stih41x_eth1_pdata),
+	{}
+};
+
+void __init stih41x_init_machine(void)
+{
+	if (of_machine_is_compatible("st,stih415"))
+		stih41x_eth_syscfg = stih415_eth_config;
+	else if (of_machine_is_compatible("st,stih416"))
+		stih41x_eth_syscfg = stih416_eth_config;
+
+	of_platform_populate(NULL, of_default_bus_match_table,
+			stih41x_auxdata_lookup, NULL);
+}
diff --git a/arch/arm/mach-sti/stih41x.h b/arch/arm/mach-sti/stih41x.h
new file mode 100644
index 0000000..cf2df32
--- /dev/null
+++ b/arch/arm/mach-sti/stih41x.h
@@ -0,0 +1,4 @@
+#ifndef __MACH_STIH41X_H
+#define __MACH_STIH41X_H
+extern void stih41x_init_machine(void);
+#endif /* __MACH_STIH41X_H */
-- 
1.7.6.5

