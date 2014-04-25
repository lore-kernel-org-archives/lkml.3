Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaDYTIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:08:43 -0400
Received: from ring0.de ([5.45.105.125]:50643 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbaDYTIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:08:35 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
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
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv4 12/13] DTS: ARM: OMAP3-N900: Add SSI support
Date: Fri, 25 Apr 2014 21:06:15 +0200
Message-Id: <1398452776-28638-13-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398452776-28638-1-git-send-email-sre@kernel.org>
References: <1398452776-28638-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SSI device tree data for OMAP3 and Nokia N900.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
---
 arch/arm/boot/dts/omap3-n900.dts | 24 +++++++++++++++++++++
 arch/arm/boot/dts/omap3.dtsi     | 45 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap34xx.dtsi  | 11 ++++++++++
 arch/arm/boot/dts/omap36xx.dtsi  | 11 ++++++++++
 4 files changed, 91 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 1a57b61..ef8b241 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -173,6 +173,19 @@
 			0x0da (PIN_OUTPUT | MUX_MODE1)   /* dss_data23.sdi_clkn */
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
@@ -662,3 +675,14 @@
 		};
 	};
 };
+
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
\ No newline at end of file
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 5e5790f..2852b23 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -757,6 +757,51 @@
 				clock-names = "fck";
 			};
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
+			ssi_port1: ssi-port@4805a000 {
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
+			};
+
+			ssi_port2: ssi-port@4805b000 {
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
index 22cf464..541704a 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -78,6 +78,17 @@
 	clock-names = "fck", "tv_dac_clk";
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
-- 
1.9.2

