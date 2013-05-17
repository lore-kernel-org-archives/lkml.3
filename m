Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3EQNWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:22:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33419 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3EQNWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:22:01 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v5] ARM:dts:omap4-panda: Update the LED support for the panda DTS
Date: Fri, 17 May 2013 08:21:23 -0500
Message-ID: <1368796883-5501-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
are different.

A1-A3 = gpio_wk7
ES = gpio_110

There is no change to LED D2

Abstract away the pinmux and the LED definitions for the two boards into
the respective DTS files.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v5 - Provide pincrtl phandle to the gpio-led driver

 arch/arm/boot/dts/omap4-panda-common.dtsi |   16 ++++++++++++-
 arch/arm/boot/dts/omap4-panda-es.dts      |   34 +++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 03bd60d..5fd59b3 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -16,8 +16,13 @@
 		reg = <0x80000000 0x40000000>; /* 1 GB */
 	};
 
-	leds {
+	leds: leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <
+			&led_wkgpio_pins
+		>;
+
 		heartbeat {
 			label = "pandaboard::status1";
 			gpios = <&gpio1 7 0>;
@@ -137,6 +142,15 @@
 	};
 };
 
+&omap4_pmx_wkup {
+	led_wkgpio_pins: pinmux_leds_wkpins {
+		pinctrl-single,pins = <
+			0x1a 0x3	/* gpio_wk7 OUTPUT | MODE 3 */
+			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
+		>;
+	};
+};
+
 &i2c1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c1_pins>;
diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index f1d8c21..08d2e38 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -34,3 +34,37 @@
 		0x5e 0x100	/* hdmi_sda.hdmi_sda INPUT | MODE 0 */
 		>;
 };
+
+&omap4_pmx_core {
+	led_gpio_pins: gpio_led_pmx {
+		pinctrl-single,pins = <
+			0xb6 0x3	/* gpio_110 OUTPUT | MODE 3 */
+		>;
+	};
+};
+
+&led_wkgpio_pins {
+	pinctrl-single,pins = <
+		0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
+	>;
+};
+
+&leds {
+	compatible = "gpio-leds";
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&led_gpio_pins
+		&led_wkgpio_pins
+	>;
+
+	heartbeat {
+		label = "pandaboard::status1";
+		gpios = <&gpio4 14 0>;
+		linux,default-trigger = "heartbeat";
+	};
+	mmc {
+		label = "pandaboard::status2";
+		gpios = <&gpio1 8 0>;
+		linux,default-trigger = "mmc0";
+	};
+};
-- 
1.7.5.4

