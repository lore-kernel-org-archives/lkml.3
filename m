Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaJVJMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:12:36 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:48660 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaJVJMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:12:34 -0400
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Subject: [PATCH v4 RESEND 2/3] ARM: dts: pbab01: enable I2S audio on phyFLEX-i.MX6 boards
Date: Wed, 22 Oct 2014 12:12:27 +0300
Message-ID: <1413969147-14346-1-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413968914-13689-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1413968914-13689-1-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audio on phyFLEX boards is presented by tlv320aic3007 codec connected
over SSI interface.

Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
---
 arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi | 100 ++++++++++++++++++++++++++-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi |  15 ++++
 2 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
index f1bdcae5b97d..668714052103 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
@@ -9,10 +9,73 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
+#include <dt-bindings/sound/fsl-imx-audmux.h>
+
 / {
 	chosen {
 		linux,stdout-path = &uart4;
 	};
+
+	regulators {
+		sound_1v8: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name = "i2s-audio-1v8";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
+		sound_3v3: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "i2s-audio-3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
+	};
+
+	tlv320_mclk: oscillator {
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <19200000>;
+		clock-output-names = "tlv320-mclk";
+	};
+
+	sound {
+		compatible = "simple-audio-card";
+		simple-audio-card,name = "imx6-phyflex-tlv320aic3007";
+		simple-audio-card,format = "i2s";
+		simple-audio-card,bitclock-master = <&dailink_master>;
+		simple-audio-card,frame-master = <&dailink_master>;
+		simple-audio-card,widgets =
+			"Microphone", "Mic Jack",
+			"Line", "Line In",
+			"Line", "Line Out",
+			"Speaker", "Speaker",
+			"Headphone", "Headphone Jack";
+		simple-audio-card,routing =
+			"Line Out", "LLOUT",
+			"Line Out", "RLOUT",
+			"Speaker", "SPOP",
+			"Speaker", "SPOM",
+			"Headphone Jack", "HPLOUT",
+			"Headphone Jack", "HPROUT",
+			"MIC3L", "Mic Jack",
+			"MIC3R", "Mic Jack",
+			"Mic Jack", "Mic Bias",
+			"LINE1L", "Line In",
+			"LINE1R", "Line In";
+
+		simple-audio-card,cpu {
+			sound-dai = <&ssi2>;
+		};
+
+		dailink_master: simple-audio-card,codec {
+			sound-dai = <&codec>;
+			clocks = <&tlv320_mclk>;
+		};
+	};
+
 };
 
 &fec {
@@ -27,12 +90,45 @@
 	status = "okay";
 };
 
+&ssi2 {
+	status = "okay";
+};
+
+&audmux {
+	status = "okay";
+
+	ssi2 {
+		fsl,audmux-port = <1>;
+		fsl,port-config = <
+			(IMX_AUDMUX_V2_PTCR_TFSDIR |
+			IMX_AUDMUX_V2_PTCR_TFSEL(4) |
+			IMX_AUDMUX_V2_PTCR_TCLKDIR |
+			IMX_AUDMUX_V2_PTCR_TCSEL(4))
+	                IMX_AUDMUX_V2_PDCR_RXDSEL(4)
+		>;
+	};
+	pins5 {
+		fsl,audmux-port = <4>;
+		fsl,port-config = <
+			0x00000000
+			IMX_AUDMUX_V2_PDCR_RXDSEL(1)
+		>;
+	};
+};
+
 &i2c2 {
 	status = "okay";
 
-	tlv320@18 {
-		compatible = "ti,tlv320aic3x";
+	codec: tlv320@18 {
+		compatible = "ti,tlv320aic3007";
+		#sound-dai-cells = <0>;
 		reg = <0x18>;
+		ai3x-micbias-vg = <2>;
+
+		AVDD-supply = <&sound_3v3>;
+		IOVDD-supply = <&sound_3v3>;
+		DRVDD-supply = <&sound_3v3>;
+		DVDD-supply = <&sound_1v8>;
 	};
 
 	stmpe@41 {
diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
index aa2275671d2c..d7f34664e008 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi
@@ -58,6 +58,12 @@
 	};
 };
 
+&audmux {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_audmux>;
+	status = "disabled";
+};
+
 &ecspi3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_ecspi3>;
@@ -319,6 +325,15 @@
 				MX6QDL_PAD_ENET_TXD1__GPIO1_IO29 0x80000000
 			>;
 		};
+
+		pinctrl_audmux: audmuxgrp {
+			fsl,pins = <
+				MX6QDL_PAD_DISP0_DAT16__AUD5_TXC	0x130b0
+				MX6QDL_PAD_DISP0_DAT18__AUD5_TXFS	0x130b0
+				MX6QDL_PAD_DISP0_DAT17__AUD5_TXD	0x110b0
+				MX6QDL_PAD_DISP0_DAT19__AUD5_RXD	0x130b0
+			>;
+		};
 	};
 };
 
-- 
2.1.2

