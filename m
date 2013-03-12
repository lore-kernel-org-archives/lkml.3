Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab3CLLpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:45:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44496 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3CLLoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:44:22 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 22/24] ARM: dts: omap3-beagle: Add USB Host support
Date: Tue, 12 Mar 2013 13:43:24 +0200
Message-ID: <1363088606-2692-23-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363088606-2692-1-git-send-email-rogerq@ti.com>
References: <1363088606-2692-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide RESET and Power regulators for the USB PHY,
the USB Host port mode and the PHY device.

Also provide pin multiplexer information for USB host
pins.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3-beagle.dts |   71 ++++++++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index f624dc8..02d23f1 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -38,6 +38,57 @@
 		};
 	};
 
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
+};
+
+&omap3_pmx_core {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+			&hsusbb2_pins
+	>;
+
+	hsusbb2_pins: pinmux_hsusbb2_pins {
+		pinctrl-single,pins = <
+			0x5c0 0x3  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_clk OUTPUT */
+			0x5c2 0x3  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_stp OUTPUT */
+			0x5c4 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dir INPUT | PULLDOWN */
+			0x5c6 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_nxt INPUT | PULLDOWN */
+			0x5c8 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat0 INPUT | PULLDOWN */
+			0x5cA 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat1 INPUT | PULLDOWN */
+			0x1a4 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat2 INPUT | PULLDOWN */
+			0x1a6 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat3 INPUT | PULLDOWN */
+			0x1a8 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat4 INPUT | PULLDOWN */
+			0x1aa 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat5 INPUT | PULLDOWN */
+			0x1ac 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat6 INPUT | PULLDOWN */
+			0x1ae 0x10b  /* USBB2_ULPITLL_CLK_MUXMODE.usbb1_ulpiphy_dat7 INPUT | PULLDOWN */
+		>;
+	};
 };
 
 &i2c1 {
@@ -65,3 +116,23 @@
 &mmc3 {
 	status = "disabled";
 };
+
+&usbhshost {
+	port2-mode = "ehci-phy";
+};
+
+&usbhsehci {
+	phys = <0 &hsusb2_phy>;
+};
+
+&twl_gpio {
+	ti,use-leds;
+	/* pullups: BIT(1) */
+	ti,pullups = <0x000002>;
+	/*
+	 * pulldowns:
+	 * BIT(2), BIT(6), BIT(7), BIT(8), BIT(13)
+	 * BIT(15), BIT(16), BIT(17)
+	 */
+	ti,pulldowns = <0x03a1c4>;
+};
-- 
1.7.4.1

