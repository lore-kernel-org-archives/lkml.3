Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaIJU40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:56:26 -0400
Received: from mout.perfora.net ([74.208.4.197]:65271 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaIJU4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:56:22 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v2 1/2] ARM: tegra: apalis/colibri t30: integrate audio support
Date: Wed, 10 Sep 2014 22:54:55 +0200
Message-Id: <00f249b3d648d3a8d550c5db0737f3aa6d93f07e.1410362950.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1410362950.git.marcel@ziswiler.com>
References: <cover.1410362950.git.marcel@ziswiler.com>
X-Provags-ID: V02:K0:D9axrhrHDYt7aiU/KVYgtFB0Ho8wJi6byXaLkNoYjNZ
 Lfjk5lm6TW/NLfWsT2ddH0EEBvUdApX8ZrByXl26cXvjs5V+bU
 G75RU2iwLY4h80SnkJyUO6Qx3X8m50Hs4HiSuJxOQWClXak6vs
 uu9uTPNCFf4hTGccb8a2OhMRK+qmwlvfoxP/k5nQxmfbUXmsNR
 6///PdHInhouSDgOKnNsMLceUmQDNRNq1VIxl6N+YwZlmz1viC
 PV2iFed08OSyXI8de1URgQN7s9pnwpLCXZr+f03cJ/YqaZqWfz
 cQJygDOGf0VE3kCp3GO6vvcz8B6VW2eQ6A/WN5uHbfICVTTr4E
 8pZ/YWxaBLX7y1gj+/+QuPKHnidpceRdQ/H17HCDpcoVyIeaKY
 GYOunF4GNCd4EdqdfZTCBXGwFSgykljI4sZHGoT/f07nkLADdt
 hwAOn
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate Freescale SGTL5000 analogue audio codec support.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v2:
- Using simple-audio-card as suggested by Fabio.

 arch/arm/boot/dts/tegra30-apalis.dtsi  | 65 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra30-colibri.dtsi | 65 ++++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+)

diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi
index a5446cb..fa3bc92 100644
--- a/arch/arm/boot/dts/tegra30-apalis.dtsi
+++ b/arch/arm/boot/dts/tegra30-apalis.dtsi
@@ -47,6 +47,24 @@
 		pinctrl-0 = <&state_default>;
 
 		state_default: pinmux {
+			/* Apalis Analogue Audio */
+			clk1_out_pw4 {
+				nvidia,pins = "clk1_out_pw4";
+				nvidia,function = "extperiph1";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			dap3_fs_pp0 {
+				nvidia,pins =	"dap3_fs_pp0",
+						"dap3_sclk_pp3",
+						"dap3_din_pp1",
+						"dap3_dout_pp2";
+				nvidia,function = "i2s2";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
+
 			/* Apalis BKL1_ON */
 			pv2 {
 				nvidia,pins = "pv2";
@@ -404,6 +422,16 @@
 		status = "okay";
 		clock-frequency = <100000>;
 
+		/* SGTL5000 audio codec */
+		sgtl5000: codec@0a {
+			#sound-dai-cells = <0>;
+			compatible = "fsl,sgtl5000";
+			reg = <0x0a>;
+			VDDA-supply = <&sys_3v3_reg>;
+			VDDIO-supply = <&sys_3v3_reg>;
+			clocks = <&tegra_car TEGRA30_CLK_EXTERN1>;
+		};
+
 		pmic: tps65911@2d {
 			compatible = "ti,tps65911";
 			reg = <0x2d>;
@@ -635,6 +663,13 @@
 		nvidia,sys-clock-req-active-high;
 	};
 
+	ahub@70080000 {
+		i2s@70080500 {
+			#sound-dai-cells = <0>;
+			status = "okay";
+		};
+	};
+
 	sdhci@78000600 {
 		status = "okay";
 		bus-width = <8>;
@@ -684,4 +719,34 @@
 			regulator-always-on;
 		};
 	};
+
+	sound {
+		compatible = "simple-audio-card";
+		simple-audio-card,format = "i2s";
+		simple-audio-card,name = "Toradex Apalis T30";
+		simple-audio-card,routing =
+			"Headphone Jack", "HP_OUT",
+			"LINE_IN", "Line In Jack",
+			"MIC_IN", "Microphone Jack";
+		simple-audio-card,widgets =
+			"Headphone", "Headphone Jack",
+			"Line In", "Line In Jack",
+			"Microphone", "Microphone Jack";
+
+		simple-audio-card,codec {
+			bitclock-master;
+			clocks = <&tegra_car TEGRA30_CLK_EXTERN1>;
+			frame-master;
+			sound-dai = <&sgtl5000>;
+		};
+
+		simple-audio-card,cpu {
+			bitclock-master;
+			clocks = <&tegra_car TEGRA30_CLK_PLL_A>,
+				 <&tegra_car TEGRA30_CLK_PLL_A_OUT0>;
+			frame-master;
+			master-clkdir-out;
+			sound-dai = <&tegra_i2s2>;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/tegra30-colibri.dtsi b/arch/arm/boot/dts/tegra30-colibri.dtsi
index c4ed1be..1f97348 100644
--- a/arch/arm/boot/dts/tegra30-colibri.dtsi
+++ b/arch/arm/boot/dts/tegra30-colibri.dtsi
@@ -29,6 +29,24 @@
 		pinctrl-0 = <&state_default>;
 
 		state_default: pinmux {
+			/* Colibri Analogue Audio */
+			clk1_out_pw4 {
+				nvidia,pins = "clk1_out_pw4";
+				nvidia,function = "extperiph1";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+			};
+			dap3_fs_pp0 {
+				nvidia,pins =	"dap3_fs_pp0",
+						"dap3_sclk_pp3",
+						"dap3_din_pp1",
+						"dap3_dout_pp2";
+				nvidia,function = "i2s2";
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+			};
+
 			/* Colibri BL_ON */
 			pv2 {
 				nvidia,pins = "pv2";
@@ -182,6 +200,16 @@
 		status = "okay";
 		clock-frequency = <100000>;
 
+		/* SGTL5000 audio codec */
+		sgtl5000: codec@0a {
+			#sound-dai-cells = <0>;
+			compatible = "fsl,sgtl5000";
+			reg = <0x0a>;
+			VDDA-supply = <&sys_3v3_reg>;
+			VDDIO-supply = <&sys_3v3_reg>;
+			clocks = <&tegra_car TEGRA30_CLK_EXTERN1>;
+		};
+
 		pmic: tps65911@2d {
 			compatible = "ti,tps65911";
 			reg = <0x2d>;
@@ -331,6 +359,13 @@
 		nvidia,sys-clock-req-active-high;
 	};
 
+	ahub@70080000 {
+		i2s@70080500 {
+			#sound-dai-cells = <0>;
+			status = "okay";
+		};
+	};
+
 	emmc: sdhci@78000600 {
 		status = "okay";
 		bus-width = <8>;
@@ -383,4 +418,34 @@
 			regulator-always-on;
 		};
 	};
+
+	sound {
+		compatible = "simple-audio-card";
+		simple-audio-card,format = "i2s";
+		simple-audio-card,name = "Toradex Colibri T30";
+		simple-audio-card,routing =
+			"Headphone Jack", "HP_OUT",
+			"LINE_IN", "Line In Jack",
+			"MIC_IN", "Microphone Jack";
+		simple-audio-card,widgets =
+			"Headphone", "Headphone Jack",
+			"Line In", "Line In Jack",
+			"Microphone", "Microphone Jack";
+
+		simple-audio-card,codec {
+			bitclock-master;
+			clocks = <&tegra_car TEGRA30_CLK_EXTERN1>;
+			frame-master;
+			sound-dai = <&sgtl5000>;
+		};
+
+		simple-audio-card,cpu {
+			bitclock-master;
+			clocks = <&tegra_car TEGRA30_CLK_PLL_A>,
+				 <&tegra_car TEGRA30_CLK_PLL_A_OUT0>;
+			frame-master;
+			master-clkdir-out;
+			sound-dai = <&tegra_i2s2>;
+		};
+	};
 };
-- 
1.9.3

