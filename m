Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3LMBTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:19:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58316 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab3LMBTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:19:21 -0500
Date: Thu, 12 Dec 2013 19:18:49 -0600
From: Nishanth Menon <nm@ti.com>
To: =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH] ARM: dts: omap3: split pinctrl for core into two parts
Message-ID: <20131213011849.GA29839@kahuna>
References: <1386896559-24376-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386896559-24376-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:02-20131212, Nishanth Menon wrote:
> 3430 TRM(SWPU222W) states that control core module padconf
missed a typo in beagle-xm.dts which i failed to
commit --amend :( grr.. Apologies on the noise..
Fixed version below:

8< --------------------------------
>From f291c8f65e4bfe6c65eb5a485cec4cfb9fcb5e21 Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Mon, 9 Dec 2013 11:23:42 -0600
Subject: [PATCH v2] ARM: dts: omap3: split pinctrl for core into two parts

3430 TRM(SWPU222W) states that control core module padconf
registers have ranges:
0x48002030 to 0x48002264(CONTROL_PADCONF_SDRC_CKE1)
0x480025D8(CONTROL_PADCONF_ETK_CLK) to 0x480025F8.

AM3517 TRM(SPRUGR0C) states that control core module padconf
registers has a single range:
0x48002030 to 0x48002264(CONTROL_PADCONF_SDRC_CKE1)

3630 TRM(SWPU176AB) states that control core module padconf
registers have ranges:
0x48002030 to 0x48002264(CONTROL_PADCONF_SDRC_CKE1)
0x480025A0(CONTROL_PADCONF_SDRC_BA0) to 0x480025F8

We currently map 0x48002030 to 0x480025F8 resulting in the bug
reported in [1].

To fix this, we split this into a another pinctrl device region
specific to the SoC. update board files that get impacted with this
change to ensure bisectability is maintained.

[1] http://marc.info/?l=linux-omap&m=138689141531466&w=2

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
v2: fix typo in beagle-xm.dts which i missed to commit :(
v1: http://marc.info/?l=linux-omap&m=138689661332699&w=2

Applies on v3.13-rc3
Tested on the following platform:
Beagle-XM (OMAP3630): http://pastebin.mozilla.org/3764783
CraneBoard(AM3517): http://pastebin.mozilla.org/3764784
SDP3430 (OMAP3430): http://pastebin.mozilla.org/3764786

I have not been able to test function impacted by this, but I applied
the following delta for the impacted padconfs I could find:
3430: -0x5A8
3630: -0x570

 arch/arm/boot/dts/omap3-beagle-xm.dts |   24 +++++++++++++++-----
 arch/arm/boot/dts/omap3-beagle.dts    |   24 +++++++++++++++-----
 arch/arm/boot/dts/omap3-igep.dtsi     |    3 +++
 arch/arm/boot/dts/omap3-igep0020.dts  |   40 +++++++++++++++++++--------------
 arch/arm/boot/dts/omap3-igep0030.dts  |    2 +-
 arch/arm/boot/dts/omap3.dtsi          |    2 +-
 arch/arm/boot/dts/omap34xx.dtsi       |   13 +++++++++++
 arch/arm/boot/dts/omap36xx.dtsi       |   11 +++++++++
 8 files changed, 88 insertions(+), 31 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index df33a50..f5f349b 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -96,6 +96,24 @@
 	};
 };
 
+&omap3_pmx_core2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+			&hsusbb2_pins2
+	>;
+
+	hsusbb2_pins2: pinmux_hsusbb2_pins {
+		pinctrl-single,pins = <
+			0x050 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			0x052 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			0x054 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			0x056 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
+			0x058 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			0x05a (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+		>;
+	};
+};
+
 &omap3_pmx_core {
 	pinctrl-names = "default";
 	pinctrl-0 = <
@@ -111,12 +129,6 @@
 
 	hsusbb2_pins: pinmux_hsusbb2_pins {
 		pinctrl-single,pins = <
-			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
-			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
-			0x5c4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
-			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
-			0x5c8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
-			0x5cA (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
 			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
 			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
 			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
index 3ba4a62..7b9e418 100644
--- a/arch/arm/boot/dts/omap3-beagle.dts
+++ b/arch/arm/boot/dts/omap3-beagle.dts
@@ -90,6 +90,24 @@
 	};
 };
 
+&omap3_pmx_core2 {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+			&hsusbb2_pins2
+	>;
+
+	hsusbb2_pins2: pinmux_hsusbb2_pins2 {
+		pinctrl-single,pins = <
+			0x018 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
+			0x01a (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
+			0x01c (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
+			0x01e (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
+			0x020 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
+			0x022 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
+		>;
+	};
+};
+
 &omap3_pmx_core {
 	pinctrl-names = "default";
 	pinctrl-0 = <
@@ -98,12 +116,6 @@
 
 	hsusbb2_pins: pinmux_hsusbb2_pins {
 		pinctrl-single,pins = <
-			0x5c0 (PIN_OUTPUT | MUX_MODE3)		/* etk_d10.hsusb2_clk */
-			0x5c2 (PIN_OUTPUT | MUX_MODE3)		/* etk_d11.hsusb2_stp */
-			0x5c4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d12.hsusb2_dir */
-			0x5c6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d13.hsusb2_nxt */
-			0x5c8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d14.hsusb2_data0 */
-			0x5cA (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d15.hsusb2_data1 */
 			0x1a4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi1_cs3.hsusb2_data2 */
 			0x1a6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_clk.hsusb2_data7 */
 			0x1a8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* mcspi2_simo.hsusb2_data4 */
diff --git a/arch/arm/boot/dts/omap3-igep.dtsi b/arch/arm/boot/dts/omap3-igep.dtsi
index 165aaf7..e608b46 100644
--- a/arch/arm/boot/dts/omap3-igep.dtsi
+++ b/arch/arm/boot/dts/omap3-igep.dtsi
@@ -134,6 +134,9 @@
 		>;
 	};
 
+};
+
+&omap3_pmx_core2 {
 	leds_pins: pinmux_leds_pins { };
 };
 
diff --git a/arch/arm/boot/dts/omap3-igep0020.dts b/arch/arm/boot/dts/omap3-igep0020.dts
index 1c7e74d..e6723c5 100644
--- a/arch/arm/boot/dts/omap3-igep0020.dts
+++ b/arch/arm/boot/dts/omap3-igep0020.dts
@@ -67,26 +67,32 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <
 		&hsusbb1_pins
-		&tfp410_pins
-		&dss_pins
 	>;
 
 	hsusbb1_pins: pinmux_hsusbb1_pins {
 		pinctrl-single,pins = <
-			0x5aa (PIN_OUTPUT | MUX_MODE3)		/* etk_ctl.hsusb1_clk */
-			0x5a8 (PIN_OUTPUT | MUX_MODE3)		/* etk_clk.hsusb1_stp */
-			0x5bc (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d8.hsusb1_dir */
-			0x5be (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d9.hsusb1_nxt */
-			0x5ac (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d0.hsusb1_data0 */
-			0x5ae (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d1.hsusb1_data1 */
-			0x5b0 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d2.hsusb1_data2 */
-			0x5b2 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d3.hsusb1_data7 */
-			0x5b4 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d4.hsusb1_data4 */
-			0x5b6 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d5.hsusb1_data5 */
-			0x5b8 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d6.hsusb1_data6 */
-			0x5ba (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d7.hsusb1_data3 */
+			0x03a (PIN_OUTPUT | MUX_MODE3)		/* etk_ctl.hsusb1_clk */
+			0x038 (PIN_OUTPUT | MUX_MODE3)		/* etk_clk.hsusb1_stp */
+			0x04c (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d8.hsusb1_dir */
+			0x04e (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d9.hsusb1_nxt */
+			0x03c (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d0.hsusb1_data0 */
+			0x03e (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d1.hsusb1_data1 */
+			0x040 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d2.hsusb1_data2 */
+			0x042 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d3.hsusb1_data7 */
+			0x044 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d4.hsusb1_data4 */
+			0x046 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d5.hsusb1_data5 */
+			0x048 (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d6.hsusb1_data6 */
+			0x04a (PIN_INPUT_PULLDOWN | MUX_MODE3)	/* etk_d7.hsusb1_data3 */
 		>;
 	};
+};
+
+&omap3_pmx_core {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&tfp410_pins
+		&dss_pins
+	>;
 
 	tfp410_pins: tfp410_dvi_pins {
 		pinctrl-single,pins = <
@@ -130,9 +136,9 @@
 
 &leds_pins {
 	pinctrl-single,pins = <
-		0x5c4 (PIN_OUTPUT | MUX_MODE4) /* etk_d12.gpio_26 */
-		0x5c6 (PIN_OUTPUT | MUX_MODE4) /* etk_d13.gpio_27 */
-		0x5c8 (PIN_OUTPUT | MUX_MODE4) /* etk_d14.gpio_28 */
+		0x054 (PIN_OUTPUT | MUX_MODE4) /* etk_d12.gpio_26 */
+		0x056 (PIN_OUTPUT | MUX_MODE4) /* etk_d13.gpio_27 */
+		0x058 (PIN_OUTPUT | MUX_MODE4) /* etk_d14.gpio_28 */
 	>;
 };
 
diff --git a/arch/arm/boot/dts/omap3-igep0030.dts b/arch/arm/boot/dts/omap3-igep0030.dts
index 02a23f8..e9372f3 100644
--- a/arch/arm/boot/dts/omap3-igep0030.dts
+++ b/arch/arm/boot/dts/omap3-igep0030.dts
@@ -48,7 +48,7 @@
 
 &leds_pins {
 	pinctrl-single,pins = <
-		0x5b0 (PIN_OUTPUT | MUX_MODE4) /* etk_d2.gpio_16 */
+		0x040 (PIN_OUTPUT | MUX_MODE4) /* etk_d2.gpio_16 */
 	>;
 };
 
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index daabf99..427395c 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -117,7 +117,7 @@
 
 		omap3_pmx_core: pinmux@48002030 {
 			compatible = "ti,omap3-padconf", "pinctrl-single";
-			reg = <0x48002030 0x05cc>;
+			reg = <0x48002030 0x0238>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			#interrupt-cells = <1>;
diff --git a/arch/arm/boot/dts/omap34xx.dtsi b/arch/arm/boot/dts/omap34xx.dtsi
index 5355d61..77d1246 100644
--- a/arch/arm/boot/dts/omap34xx.dtsi
+++ b/arch/arm/boot/dts/omap34xx.dtsi
@@ -25,4 +25,17 @@
 			clock-latency = <300000>; /* From legacy driver */
 		};
 	};
+
+	ocp {
+		omap3_pmx_core2: pinmux@480025d8 {
+			compatible = "ti,omap3-padconf", "pinctrl-single";
+			reg = <0x480025d8 0x24>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#interrupt-cells = <1>;
+			interrupt-controller;
+			pinctrl-single,register-width = <16>;
+			pinctrl-single,function-mask = <0xff1f>;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/omap36xx.dtsi b/arch/arm/boot/dts/omap36xx.dtsi
index 380c22e..b7c7bd9 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -38,5 +38,16 @@
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
 		};
+
+		omap3_pmx_core2: pinmux@480025a0 {
+			compatible = "ti,omap3-padconf", "pinctrl-single";
+			reg = <0x480025a0 0x5c>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#interrupt-cells = <1>;
+			interrupt-controller;
+			pinctrl-single,register-width = <16>;
+			pinctrl-single,function-mask = <0xff1f>;
+		};
 	};
 };
-- 
1.7.9.5

-- 
Regards,
Nishanth Menon
