Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab3IJT0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:26:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51445 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3IJTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:25:52 -0400
From: Joel Fernandes <joelf@ti.com>
To: Benoit Cousson <bcousson@baylibre.com>
CC: Nishanth Menon <nm@ti.com>,
        Devicetree Discuss <devicetree@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 3/3] ARM: dts: add AM33XX MMC support and documentation
Date: Tue, 10 Sep 2013 14:24:39 -0500
Message-ID: <1378841079-15796-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378841079-15796-1-git-send-email-joelf@ti.com>
References: <1378841079-15796-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Porter <mporter@ti.com>

Adds AM33XX MMC support for am335x-bone, am335x-evm and am335x-evmsk boards.

Also added is the DMA binding definitions based on the generic DMA request
binding.

Additional changes made to DTS:
* Interrupt, reg and compatible properties added
* ti,needs-special-hs-handling added

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      | 26 ++++++++++++++-
 arch/arm/boot/dts/am335x-bone.dts                  | 11 +++++++
 arch/arm/boot/dts/am335x-evm.dts                   |  7 ++++
 arch/arm/boot/dts/am335x-evmsk.dts                 |  7 ++++
 arch/arm/boot/dts/am33xx.dtsi                      | 38 ++++++++++++++++++++++
 5 files changed, 88 insertions(+), 1 deletion(-)

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
index 7993c48..d5f43fe 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -9,3 +9,14 @@
 
 #include "am33xx.dtsi"
 #include "am335x-bone-common.dtsi"
+
+&ldo3_reg {
+	regulator-min-microvolt = <1800000>;
+	regulator-max-microvolt = <3300000>;
+	regulator-always-on;
+};
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&ldo3_reg>;
+};
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index e8ec875..bc4a69d 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -477,6 +477,8 @@
 		};
 
 		vmmc_reg: regulator@12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 	};
@@ -517,3 +519,8 @@
 		ti,adc-channels = <4 5 6 7>;
 	};
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&vmmc_reg>;
+};
diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index 4f339fa..55fd194 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -393,6 +393,8 @@
 		};
 
 		vmmc_reg: regulator@12 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 	};
@@ -419,3 +421,8 @@
 	phy_id = <&davinci_mdio>, <1>;
 	phy-mode = "rgmii-txid";
 };
+
+&mmc1 {
+	status = "okay";
+	vmmc-supply = <&vmmc_reg>;
+};
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 9ce85e5..0a82fca 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -240,6 +240,44 @@
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
1.8.1.2

