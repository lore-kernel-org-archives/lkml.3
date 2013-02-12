Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab3BLMWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 07:22:15 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41455 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab3BLMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 07:22:14 -0500
From: Anil Kumar <anilk4.v@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, tony@atomide.com,
        grant.likely@secretlab.ca, peter.ujfalusi@ti.com, thomas@tomweber.eu,
        anilk4.v@gmail.com
Subject: [PATCH] ARM: dts: omap3-devkit8000: Enable audio support
Date: Tue, 12 Feb 2013 17:51:57 +0530
Message-Id: <1360671717-32050-1-git-send-email-anilk4.v@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the needed sections to enable audio support and related pin mux on
Devkit8000 when booted with DT blob.

Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
---
This patch is based on top of kernel 3.8-rc5 and
the following patches.

Peter Ujfalusi:-
ASoC: twl4030: Correct the support for Voice port
ASoC: twl4030: Convert MICBIAS to SUPPLY widget
ASoC: omap-twl4030: Add support for routing, voice port and jack detect

Anil Kumar:-
ARM: dts: add minimal DT support for DevKit8000
https://patchwork.kernel.org/patch/2122461/

-Tested for playback and capture on Devkit8000.

 Test process:-

 #amixer set 'PredriveR Mixer AudioR2' on
 #amixer set 'PredriveL Mixer AudioL2' on
 #amixer set PreDriv 100 unmute
 #amixer set 'DAC2 Digital Fine' 100
 #amixer cset numid=27 1
 #arecord | aplay

:100644 100644 dc59272... 1e2c931... M	arch/arm/boot/dts/omap3-devkit8000.dts
 arch/arm/boot/dts/omap3-devkit8000.dts |   43 ++++++++++++++++++++++++++++---
 1 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
index dc59272..1e2c931 100644
--- a/arch/arm/boot/dts/omap3-devkit8000.dts
+++ b/arch/arm/boot/dts/omap3-devkit8000.dts
@@ -44,11 +44,27 @@
                 };
 
 	};
+
+	sound {
+		compatible = "ti,omap-twl4030";
+		ti,model = "devkit8000";
+
+		ti,mcbsp = <&mcbsp2>;
+		ti,codec = <&twl_audio>;
+		ti,audio-routing =
+			"Ext Spk", "PREDRIVEL",
+			"Ext Spk", "PREDRIVER",
+			"MAINMIC", "Main Mic",
+			"Main Mic", "Mic Bias 1";
+	};
 };
 
 &omap3_pmx_core {
 	pinctrl-names = "default";
-	pinctrl-0 = <&i2c1_pins>;
+	pinctrl-0 = <
+			&i2c1_pins
+			&mcbsp2_pins
+		>;
 
 	leds_pins: pinmux_led_pins {
 		pinctrl-single,pins = <
@@ -65,6 +81,21 @@
 			0x18c 0x118	/* I2C1_SDA */
                 >;
 	};
+
+	mcbsp2_pins: pinmux_mcbsp2_pins {
+                pinctrl-single,pins = <
+			/*
+			 * MCBSP2_FSX, OMAP_MUX_MODE0 | OMAP_PIN_INPUT,
+			 * MCBSP2_CLKX, OMAP_MUX_MODE0 | OMAP_PIN_INPUT
+			 */
+			0x10c 0x01000100
+			/*
+			 * MCBSP2_DR, OMAP_MUX_MODE0 | OMAP_PIN_INPUT,
+			 * MCBSP2_DX, OMAP_MUX_MODE0 | OMAP_PIN_OUTPUT
+			 */
+			0x110 0x00000100
+		>;
+	};
 };
 
 &i2c1 {
@@ -74,6 +105,12 @@
 		reg = <0x48>;
 		interrupts = <7>;	/* SYS_NIRQ cascaded to intc */
 		interrupt-parent = <&intc>;
+
+		twl_audio: audio {
+			compatible = "ti,twl4030-audio";
+			codec {
+			};
+		};
 	};
 };
 
@@ -109,10 +146,6 @@
 	status = "disabled";
 };
 
-&mcbsp2 {
-	status = "disabled";
-};
-
 &mcbsp3 {
 	status = "disabled";
 };
-- 
1.7.0.4

