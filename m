Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaHFNsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:48:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42984 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaHFNsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:48:19 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <mturquette@linaro.org>,
        <dri-devel@lists.freedesktop.org>, <airlied@linux.ie>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <bcousson@baylibre.com>
CC: <tony@atomide.com>, <broonie@kernel.org>,
        <liam.r.girdwood@linux.intel.com>, <peter.ujfalusi@ti.com>,
        <detheridge@ti.com>, <zonque@gmail.com>, <t-kristo@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 7/9] ARM: dts: am335x-boneblack: Add HDMI audio support
Date: Wed, 6 Aug 2014 16:47:22 +0300
Message-ID: <d4658f1184b0838ebc4b358333d9e303d0fda4b1.1407332062.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1407332062.git.jsarha@ti.com>
References: <cover.1407332062.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds mcasp0_pins, clk_mcasp0_fixed, clk_mcasp0, mcasp0, hdmi_audio,
and sound nodes.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
---
 arch/arm/boot/dts/am335x-boneblack.dts |   54 ++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
index 305975d..c3c4618 100644
--- a/arch/arm/boot/dts/am335x-boneblack.dts
+++ b/arch/arm/boot/dts/am335x-boneblack.dts
@@ -59,12 +59,50 @@
 			0x1b0 0x03      /* xdma_event_intr0, OMAP_MUX_MODE3 | AM33XX_PIN_OUTPUT */
 		>;
 	};
+
+	mcasp0_pins: mcasp0_pins {
+		pinctrl-single,pins = <
+			0x1ac (PIN_INPUT_PULLUP | MUX_MODE0)	/* mcasp0_ahclkx.mcasp0_ahclkx */
+			0x19c (PIN_OUTPUT_PULLDOWN | MUX_MODE2) /* mcasp0_ahclkr.mcasp0_axr2 */
+			0x194 (PIN_OUTPUT_PULLUP | MUX_MODE0)	/* mcasp0_fsx.mcasp0_fsx */
+			0x190 (PIN_OUTPUT_PULLDOWN | MUX_MODE0)	/* mcasp0_aclkx.mcasp0_aclkx */
+			0x06c (PIN_OUTPUT_PULLDOWN | MUX_MODE7)	/* gpmc_a11.GPIO1_27 */
+		>;
+	};
 };
 
 &lcdc {
 	status = "okay";
 };
 
+&mcasp0	{
+	pinctrl-names = "default";
+	pinctrl-0 = <&mcasp0_pins>;
+	status = "okay";
+	op-mode = <0>;	/* MCASP_IIS_MODE */
+	tdm-slots = <2>;
+	serial-dir = <	/* 0: INACTIVE, 1: TX, 2: RX */
+			0 0 1 0
+		>;
+	tx-num-evt = <1>;
+	rx-num-evt = <1>;
+};
+
+&ext_clocks {
+	clk_mcasp0_fixed: clk_mcasp0_fixed {
+	      #clock-cells = <0>;
+	      compatible = "fixed-clock";
+	      clock-frequency = <24576000>;
+	};
+
+	clk_mcasp0: clk_mcasp0 {
+	      #clock-cells = <0>;
+	      compatible = "gpio-clock";
+	      clocks = <&clk_mcasp0_fixed>;
+	      enable-gpios = <&gpio1 27 0>; /* BeagleBone Black Clk enable on GPIO1_27 */
+	};
+};
+
 / {
 	hdmi {
 		compatible = "ti,tilcdc,slave";
@@ -74,4 +112,20 @@
 		pinctrl-1 = <&nxp_hdmi_bonelt_off_pins>;
 		status = "okay";
 	};
+
+	hdmi_audio: hdmi_audio@0 {
+	       compatible = "linux,hdmi-audio";
+	       status = "okay";
+	};
+
+	sound {
+		compatible = "ti,am335x-beaglebone-black-audio";
+		ti,model = "TI BeagleBone Black";
+		ti,audio-codec = <&hdmi_audio>;
+		ti,mcasp-controller = <&mcasp0>;
+		ti,audio-routing =
+			"HDMI Out",	"TX";
+		clocks = <&clk_mcasp0>;
+		clock-names = "mclk";
+	};
 };
-- 
1.7.9.5

