Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaC2Aex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:34:53 -0400
Received: from ring0.de ([5.45.105.125]:43229 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaC2Aes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:34:48 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 13/14] DTS: ARM: OMAP3-N900: Add SSI support
Date: Sat, 29 Mar 2014 01:31:49 +0100
Message-Id: <1396053110-21639-14-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SSI device tree data for OMAP3 and Nokia N900.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 arch/arm/boot/dts/omap3-n900.dts | 24 ++++++++++++++++++
 arch/arm/boot/dts/omap3.dtsi     | 55 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap34xx.dtsi  | 11 ++++++++
 arch/arm/boot/dts/omap36xx.dtsi  | 11 ++++++++
 4 files changed, 101 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 0bf40c9..5bccd8c 100644
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
@@ -490,6 +503,17 @@
 	power = <50>;
 };
 
+&ssi_port1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&ssi_pins>;
+
+	ti,ssi-cawake-gpio = <&gpio5 23 GPIO_ACTIVE_HIGH>; /* 151 */
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
index a5fc83b..cb00ce6 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -669,6 +669,61 @@
 			num-eps = <16>;
 			ram-bits = <12>;
 		};
+
+		ssi: ssi-controller@48058000 {
+			compatible = "ti,omap3-ssi";
+			ti,hwmods = "ssi";
+
+			status = "disabled";
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
+				#address-cells = <1>;
+				#size-cells = <0>;
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
+				#address-cells = <1>;
+				#size-cells = <0>;
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
 
diff --git a/arch/arm/boot/dts/omap34xx.dtsi b/arch/arm/boot/dts/omap34xx.dtsi
index 2e92360..3819c1e 100644
--- a/arch/arm/boot/dts/omap34xx.dtsi
+++ b/arch/arm/boot/dts/omap34xx.dtsi
@@ -40,6 +40,17 @@
 	};
 };
 
+&ssi {
+	status = "ok";
+
+	clocks = <&ssi_ssr_fck>,
+		 <&ssi_sst_fck>,
+		 <&ssi_ick>;
+	clock-names = "ssi_ssr_fck",
+		      "ssi_sst_fck",
+		      "ssi_ick";
+};
+
 /include/ "omap34xx-omap36xx-clocks.dtsi"
 /include/ "omap36xx-omap3430es2plus-clocks.dtsi"
 /include/ "omap36xx-am35xx-omap3430es2plus-clocks.dtsi"
diff --git a/arch/arm/boot/dts/omap36xx.dtsi b/arch/arm/boot/dts/omap36xx.dtsi
index 7e8dee9..a634961 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -52,6 +52,17 @@
 	};
 };
 
+&ssi {
+	status = "ok";
+
+	clocks = <&ssi_ssr_fck>,
+		 <&ssi_sst_fck>,
+		 <&ssi_ick>;
+	clock-names = "ssi_ssr_fck",
+		      "ssi_sst_fck",
+		      "ssi_ick";
+};
+
 /include/ "omap36xx-clocks.dtsi"
 /include/ "omap34xx-omap36xx-clocks.dtsi"
 /include/ "omap36xx-omap3430es2plus-clocks.dtsi"
-- 
1.9.0

