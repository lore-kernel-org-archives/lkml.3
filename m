Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3F0Ddp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:33:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46816 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3F0Ddn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:33:43 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2] ARM: dts: add AM33XX MMC support
Date: Wed, 26 Jun 2013 22:32:36 -0500
Message-ID: <1372303956-30208-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Adds AM33XX MMC support for am335x-bone, am335x-evm, and am335x-evmsk.
Also added is the DMA binding definitions based on the generic DMA
request binding.

The HWMOD data removal was breaking MMC so some new properties like reg,
interrupt etc were added.

Changes to DTS:
Interrupt and reg added by: Joel Fernandes <joelf@ti.com>
Compatible added by Balaji TK <balajitk@ti.com>
ti,needs-special-hs-handling added by Gururaja Hebbar <gururaja.hebbar@ti.com>

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |   26 +++++++++++++-
 arch/arm/boot/dts/am335x-bone.dts                  |    7 ++++
 arch/arm/boot/dts/am335x-evm.dts                   |    7 ++++
 arch/arm/boot/dts/am335x-evmsk.dts                 |    7 ++++
 arch/arm/boot/dts/am33xx.dtsi                      |   38 ++++++++++++++++++++
 5 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
index ed271fc..8c8908a 100644
--- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
+++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
@@ -20,8 +20,29 @@ ti,dual-volt: boolean, supports dual voltage cards
 ti,non-removable: non-removable slot (like eMMC)
 ti,needs-special-reset: Requires a special softreset sequence
 ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
+dmas: List of DMA specifiers with the controller specific format
+as described in the generic DMA client binding. A tx and rx
+specifier is required.
+dma-names: List of DMA request names. These strings correspond
+1:1 with the DMA specifiers listed in dmas. The string naming is
+to be "rx" and "tx" for RX and TX DMA requests, respectively.
+
+Examples:
+
+[hwmod populated DMA resources]
+
+	mmc1: mmc@0x4809c000 {
+		compatible = "ti,omap4-hsmmc";
+		reg = <0x4809c000 0x400>;
+		ti,hwmods = "mmc1";
+		ti,dual-volt;
+		bus-width = <4>;
+		vmmc-supply = <&vmmc>; /* phandle to regulator node */
+		ti,non-removable;
+	};
+
+[generic DMA request binding]
 
-Example:
 	mmc1: mmc@0x4809c000 {
 		compatible = "ti,omap4-hsmmc";
 		reg = <0x4809c000 0x400>;
@@ -30,4 +51,7 @@ Example:
 		bus-width = <4>;
 		vmmc-supply = <&vmmc>; /* phandle to regulator node */
 		ti,non-removable;
+		dmas = <&edma 24
+			&edma 25>;
+		dma-names = "tx", "rx";
 	};
diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index 5302f79..80bff9c 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -120,6 +120,8 @@
 		};
 
 		ldo3_reg: regulator@5 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 
@@ -136,3 +138,8 @@
 &cpsw_emac1 {
 	phy_id = <&davinci_mdio>, <1>;
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&ldo3_reg>;
+};
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 0423298..62af561 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -232,6 +232,8 @@
 		};
 
 		vmmc_reg: regulator@12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 	};
@@ -244,3 +246,8 @@
 &cpsw_emac1 {
 	phy_id = <&davinci_mdio>, <1>;
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&vmmc_reg>;
+};
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index f67c360..8904b88 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -244,7 +244,14 @@
 		};
 
 		vmmc_reg: regulator@12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 	};
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&vmmc_reg>;
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index b4fda12..8ab566f 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -229,6 +229,44 @@
 			status = "disabled";
 		};
 
+		mmc1: mmc@48060000 {
+			compatible = "ti,omap4-hsmmc";
+			ti,hwmods = "mmc1";
+			ti,dual-volt;
+			ti,needs-special-reset;
+			ti,needs-special-hs-handling;
+			dmas = <&edma 24
+				&edma 25>;
+			dma-names = "tx", "rx";
+			interrupts = <64>;
+			interrupt-parent = <&intc>;
+			reg = <0x48060000 0x1000>;
+			status = "disabled";
+		};
+
+		mmc2: mmc@481d8000 {
+			compatible = "ti,omap4-hsmmc";
+			ti,hwmods = "mmc2";
+			ti,needs-special-reset;
+			dmas = <&edma 2
+				&edma 3>;
+			dma-names = "tx", "rx";
+			interrupts = <28>;
+			interrupt-parent = <&intc>;
+			reg = <0x481d8000 0x1000>;
+			status = "disabled";
+		};
+
+		mmc3: mmc@47810000 {
+			compatible = "ti,omap4-hsmmc";
+			ti,hwmods = "mmc3";
+			ti,needs-special-reset;
+			interrupts = <29>;
+			interrupt-parent = <&intc>;
+			reg = <0x47810000 0x1000>;
+			status = "disabled";
+		};
+
 		wdt2: wdt@44e35000 {
 			compatible = "ti,omap3-wdt";
 			ti,hwmods = "wd_timer2";
-- 
1.7.9.5

