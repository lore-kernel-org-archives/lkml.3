Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaIJOUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:20:14 -0400
Received: from s250.sam-solutions.net ([217.21.49.219]:35902 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaIJOUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:20:10 -0400
X-Greylist: delayed 1932 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 10:20:10 EDT
From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>,
        <linux@arm.linux.org.uk>, <perex@perex.cz>, <tiwai@suse.de>,
        <timur@tabi.org>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <grant.likely@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>,
        "Dmitry Lavnikevich" <d.lavnikevich@sam-solutions.com>
Subject: [PATCH 4/5] ARM: dts: pbab01: enable I2S audio on phyFLEX-i.MX6 boards
Date: Wed, 10 Sep 2014 16:46:48 +0300
Message-ID: <1410356809-26179-5-git-send-email-d.lavnikevich@sam-solutions.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.117.165]
X-ClientProxiedBy: S326.sam-solutions.net (217.21.35.11) To
 S326.sam-solutions.net (217.21.35.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audio on phyFLEX boards is presented by tlv320aic3007 codec connected over SSI
interface.

Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
---
 arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi | 59 +++++++++++++++++++++++++++-
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi | 15 +++++++
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi b/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
index f1bdcae5b97d..8f778fe8c0b7 100644
--- a/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-pbab01.dtsi
@@ -13,6 +13,46 @@
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
+			regulator-always-on;
+		};
+		sound_3v3: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "i2s-audio-3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+	};
+
+	sound {
+		compatible = "fsl,imx-audio-tlv320aic3x";
+		model = "imx6q-phyflex-tlv320aic3007";
+		ssi-controller = <&ssi2>;
+		audio-codec = <&codec>;
+		audio-routing =
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
+		mux-int-port = <2>;
+		mux-ext-port = <5>;
+	};
 };
 
 &fec {
@@ -27,12 +67,27 @@
 	status = "okay";
 };
 
+&ssi2 {
+	fsl,mode = "i2s-slave";
+	status = "okay";
+};
+
+&audmux {
+	status = "okay";
+};
+
 &i2c2 {
 	status = "okay";
 
-	tlv320@18 {
-		compatible = "ti,tlv320aic3x";
+	codec: tlv320@18 {
+		compatible = "ti,tlv320aic3007";
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
index a927e88ccc98..1c4464dcb497 100644
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
2.1.0

