Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3FTMqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:46:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37388 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844Ab3FTMqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:46:52 -0400
From: Roger Quadros <rogerq@ti.com>
To: <b-cousson@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v5 1/2] ARM: dts: omap3-beagle-xm: Add USB Host support
Date: Thu, 20 Jun 2013 15:46:13 +0300
Message-ID: <1371732374-27191-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371732374-27191-1-git-send-email-rogerq@ti.com>
References: <1371732374-27191-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide RESET and Power regulators for the USB PHY,
the USB Host port mode and the PHY device. Provide
pin multiplexer information for USB host pins.

We also relocate omap3_pmx_core pin definations so that they
are close to omap3_pmx_wkup pin definations.

NOTE: The reset control will be replaced with the proper
gpio-controlled reset driver as soon it will be merged [1].
[1] http://thread.gmane.org/gmane.linux.drivers.devicetree/36830

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle-xm.dts |   81 +++++++++++++++++++++++++++++----
 1 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index afdb164..371b1e2 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -69,6 +69,39 @@
 		};
 
 	};
+
+	/*
+	 * Temp hack: Need to be replaced with the proper gpio-controlled
+	 * reset driver as soon it will be merged.
+	 * http://thread.gmane.org/gmane.linux.drivers.devicetree/36830
+	 */
+	/* HS USB Port 2 RESET */
+	hsusb2_reset: hsusb2_reset_reg {
+		compatible = "regulator-fixed";
+		regulator-name = "hsusb2_reset";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio5 19 0>;	/* gpio_147 */
+		startup-delay-us = <70000>;
+		enable-active-high;
+	};
+
+	/* HS USB Port 2 Power */
+	hsusb2_power: hsusb2_power_reg {
+		compatible = "regulator-fixed";
+		regulator-name = "hsusb2_vbus";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&twl_gpio 18 0>;	/* GPIO LEDA */
+		startup-delay-us = <70000>;
+	};
+
+	/* HS USB Host PHY on PORT 2 */
+	hsusb2_phy: hsusb2_phy {
+		compatible = "usb-nop-xceiv";
+		reset-supply = <&hsusb2_reset>;
+		vcc-supply = <&hsusb2_power>;
+	};
 };
 
 &omap3_pmx_wkup {
@@ -79,6 +112,37 @@
 	};
 };
 
+&omap3_pmx_core {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+			&hsusbb2_pins
+	>;
+
+	uart3_pins: pinmux_uart3_pins {
+		pinctrl-single,pins = <
+			0x16e (PIN_INPUT | PIN_OFF_WAKEUPENABLE | MUX_MODE0) /* uart3_rx_irrx.uart3_rx_irrx */
+			0x170 (PIN_OUTPUT | MUX_MODE0) /* uart3_tx_irtx.uart3_tx_irtx OUTPUT | MODE0 */
+		>;
+	};
+
+	hsusbb2_pins: pinmux_hsusbb2_pins {
+		pinctrl-single,pins = <
+			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			0x5c4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
+			0x5c8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			0x5cA (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
+			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
+			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
+			0x1aa (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_somi.hsusb2_data5 */
+			0x1ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs0.hsusb2_data6 */
+			0x1ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_cs1.hsusb2_data3 */
+		>;
+	};
+};
+
 &i2c1 {
 	clock-frequency = <2600000>;
 
@@ -148,15 +212,6 @@
 	power = <50>;
 };
 
-&omap3_pmx_core {
-	uart3_pins: pinmux_uart3_pins {
-		pinctrl-single,pins = <
-			0x16e (PIN_INPUT | PIN_OFF_WAKEUPENABLE | MUX_MODE0) /* uart3_rx_irrx.uart3_rx_irrx */
-			0x170 (PIN_OUTPUT | MUX_MODE0) /* uart3_tx_irtx.uart3_tx_irtx OUTPUT | MODE0 */
-		>;
-	};
-};
-
 &uart3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart3_pins>;
@@ -166,3 +221,11 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&gpio1_pins>;
 };
+
+&usbhshost {
+	port2-mode = "ehci-phy";
+};
+
+&usbhsehci {
+	phys = <0 &hsusb2_phy>;
+};
-- 
1.7.4.1

