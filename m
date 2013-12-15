Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab3LOX2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:28:55 -0500
Received: from ring0.de ([91.143.88.219]:40123 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab3LOX2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:28:51 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv4 09/11] DTS: ARM: OMAP3-N900: Add SSI support
Date: Mon, 16 Dec 2013 00:28:02 +0100
Message-Id: <1387150085-23173-10-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387150085-23173-1-git-send-email-sre@debian.org>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SSI device tree data for OMAP3 and Nokia N900.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 28 ++++++++++++++++++++++++
 arch/arm/boot/dts/omap3.dtsi     | 47 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 6fc85f9..52f5099 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -145,6 +145,19 @@
 			0x0d4 (PIN_OUTPUT | MUX_MODE4)		/* RX51_LCD_RESET_GPIO */
 		>;
 	};
+
+	ssi_pins: pinmux_ssi {
+		pinctrl-single,pins = <
+			0x150 (PIN_INPUT_PULLUP | MUX_MODE1)	/* ssi1_rdy_tx */
+			0x14e (PIN_OUTPUT | MUX_MODE1)		/* ssi1_flag_tx */
+			0x152 (PIN_INPUT | WAKEUP_EN | MUX_MODE4) /* ssi1_wake_tx (cawake) */
+			0x14c (PIN_OUTPUT | MUX_MODE1)		/* ssi1_dat_tx */
+			0x154 (PIN_INPUT | MUX_MODE1)		/* ssi1_dat_rx */
+			0x156 (PIN_INPUT | MUX_MODE1)		/* ssi1_flag_rx */
+			0x158 (PIN_OUTPUT | MUX_MODE1)		/* ssi1_rdy_rx */
+			0x15a (PIN_OUTPUT | MUX_MODE1)		/* ssi1_wake */
+		>;
+	};
 };
 
 &i2c1 {
@@ -490,6 +503,21 @@
 	power = <50>;
 };
 
+&ssi_port1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ssi_pins>;
+
+	ti,ssi-cawake-gpio = <&gpio5 23 GPIO_ACTIVE_HIGH>; /* 151 */
+
+	ssi-char {
+		compatible = "ssi-char";
+	};
+};
+
+&ssi_port2 {
+	status = "disabled";
+};
+
 &uart1 {
 	status = "disabled";
 };
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index daabf99..b7e485c 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -630,5 +630,52 @@
 			num-eps = <16>;
 			ram-bits = <12>;
 		};
+
+		ssi: ssi-controller@48058000 {
+			compatible = "ti,omap3-ssi";
+			ti,hwmods = "ssi";
+
+			reg = <0x48058000 0x1000>,
+			      <0x48059000 0x1000>;
+			reg-names = "sys",
+				    "gdd";
+
+			interrupts = <71>;
+			interrupt-names = "gdd_mpu";
+
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+
+			ssi_port1: ssi-port@0 {
+				compatible = "ti,omap3-ssi-port";
+
+				reg = <0x4805a000 0x800>,
+				      <0x4805a800 0x800>;
+				reg-names = "tx",
+					    "rx";
+
+				interrupt-parent = <&intc>;
+				interrupts = <67>,
+					     <68>;
+				interrupt-names = "mpu_irq0",
+						  "mpu_irq1";
+			};
+
+			ssi_port2: ssi-port@1 {
+				compatible = "ti,omap3-ssi-port";
+
+				reg = <0x4805b000 0x800>,
+				      <0x4805b800 0x800>;
+				reg-names = "tx",
+					    "rx";
+
+				interrupt-parent = <&intc>;
+				interrupts = <69>,
+					     <70>;
+				interrupt-names = "mpu_irq0",
+						  "mpu_irq1";
+			};
+		};
 	};
 };
-- 
1.8.5.1

