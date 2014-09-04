Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaIDNYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:24:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34697 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaIDNYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:24:05 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <rogerq@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] ARM: dts: dra7-evm: Add vtt regulator support
Date: Thu, 4 Sep 2014 08:23:28 -0500
Message-ID: <1409837008-32144-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409837008-32144-1-git-send-email-nm@ti.com>
References: <1409837008-32144-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lokesh Vutla <lokeshvutla@ti.com>

DRA7 evm REV G and later boards uses a vtt regulator for DDR3
termination and this is controlled by gpio7_11. This gpio is
configured in boot loader. gpio7_11, which is only available only on
Pad A22, in previous boards, is connected only to an unused pad on
expansion connector EXP_P3 and is safe to be muxed as GPIO on all
DRA7-evm versions (without a need to spin off another dts file).

Since gpio7_11 is used to control VTT and should not be reset or kept
in idle state during boot up else VTT will be disconnected and DDR
gets corrupted. So, as part of this change, mark gpio7 as no-reset and
no-idle on init.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index e120fca..71f0f10 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -8,6 +8,7 @@
 /dts-v1/;
 
 #include "dra74x.dtsi"
+#include <dt-bindings/gpio/gpio.h>
 
 / {
 	model = "TI DRA742";
@@ -24,9 +25,29 @@
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 	};
+
+	vtt_fixed: fixedregulator-vtt {
+		compatible = "regulator-fixed";
+		regulator-name = "vtt_fixed";
+		regulator-min-microvolt = <1350000>;
+		regulator-max-microvolt = <1350000>;
+		regulator-always-on;
+		regulator-boot-on;
+		enable-active-high;
+		gpio = <&gpio7 11 GPIO_ACTIVE_HIGH>;
+	};
 };
 
 &dra7_pmx_core {
+	pinctrl-names = "default";
+	pinctrl-0 = <&vtt_pin>;
+
+	vtt_pin: pinmux_vtt_pin {
+		pinctrl-single,pins = <
+			0x3b4 (PIN_OUTPUT | MUX_MODE14) /* spi1_cs1.gpio7_11 */
+		>;
+	};
+
 	i2c1_pins: pinmux_i2c1_pins {
 		pinctrl-single,pins = <
 			0x400 (PIN_INPUT | MUX_MODE0) /* i2c1_sda */
@@ -54,7 +75,6 @@
 			0x3a8 (PIN_INPUT | MUX_MODE0) /* spi1_d1 */
 			0x3ac (PIN_INPUT | MUX_MODE0) /* spi1_d0 */
 			0x3b0 (PIN_INPUT_SLEW | MUX_MODE0) /* spi1_cs0 */
-			0x3b4 (PIN_INPUT_SLEW | MUX_MODE0) /* spi1_cs1 */
 			0x3b8 (PIN_INPUT_SLEW | MUX_MODE6) /* spi1_cs2.hdmi1_hpd */
 			0x3bc (PIN_INPUT_SLEW | MUX_MODE6) /* spi1_cs3.hdmi1_cec */
 		>;
@@ -504,3 +524,8 @@
 &usb2_phy2 {
 	phy-supply = <&ldousb_reg>;
 };
+
+&gpio7 {
+	ti,no-reset-on-init;
+	ti,no-idle-on-init;
+};
-- 
1.7.9.5

