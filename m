Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbaJDAQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:16:58 -0400
Received: from mout.perfora.net ([74.208.4.194]:60173 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758330AbaJDAQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 20:16:55 -0400
From: Marcel Ziswiler <marcel@ziswiler.com>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch, Marcel Ziswiler <marcel@ziswiler.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 2/3] ARM: tegra: apalis/colibri t30: integrate audio support
Date: Sat,  4 Oct 2014 02:15:44 +0200
Message-Id: <1202a8ec8e82b72399a3f8fdc25cbdda88302622.1412381377.git.marcel@ziswiler.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1412381377.git.marcel@ziswiler.com>
References: <cover.1412381377.git.marcel@ziswiler.com>
X-Provags-ID: V02:K0:RJO8z4uM/rt+APliGs5d0nOg+/4hi/cHpAEw6tGAIY9
 ZafI7eq71VatjCP/tsB4ki2eXkMD/hKvgI4nxpZTmxJ30S32Ji
 S0VDRY5GJojH90GXwcAJAGbxtHlwtfRgs+1DygyiF+t1VtC0Ko
 tKps2r7xbFFYmm4Uboxk1QNiCfc2B3dupm2PjtvKgNLSSkGUcU
 9zd02Hp6PtfJA+Lle8H6YB89fs9nb1POKFI2/BUwd+ToKE+Gew
 v3UPguFlpxsyf7/n4eYZzN7BezeSxpnRZmXHoXWk5t9Z1K7lM0
 X0XbO3ud8vSryMESb6Gtkbh3oI6KbhQraquwjHQsvpA6428Jfz
 nUXGjhBM0PEqx9SZICuKZtP3MkFez/n7ty3IHW2DI48N2WmeZJ
 vprbo9qC9a2C74r5RqfGR3a7/jxxvqa+zeQZ+4YiUugLL2D0O3
 53cEZ
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Integrate Freescale SGTL5000 analogue audio codec support.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3:
- Revert to not using simple-audio-card being incompatible with tegra.
- Rebased to for-next.

Changes in v2:
- Using simple-audio-card as suggested by Fabio.

 arch/arm/boot/dts/tegra30-apalis.dtsi  | 49 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra30-colibri.dtsi | 49 ++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi
index a5446cb..9fe3e4d 100644
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
@@ -404,6 +422,15 @@
 		status = "okay";
 		clock-frequency = <100000>;
 
+		/* SGTL5000 audio codec */
+		sgtl5000: codec@0a {
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
@@ -635,6 +662,12 @@
 		nvidia,sys-clock-req-active-high;
 	};
 
+	ahub@70080000 {
+		i2s@70080500 {
+			status = "okay";
+		};
+	};
+
 	sdhci@78000600 {
 		status = "okay";
 		bus-width = <8>;
@@ -684,4 +717,20 @@
 			regulator-always-on;
 		};
 	};
+
+	sound {
+		compatible = "toradex,tegra-audio-sgtl5000-apalis_t30",
+			     "nvidia,tegra-audio-sgtl5000";
+		nvidia,model = "Toradex Apalis T30";
+		nvidia,audio-routing =
+			"Headphone Jack", "HP_OUT",
+			"LINE_IN", "Line In Jack",
+			"MIC_IN", "Mic Jack";
+		nvidia,i2s-controller = <&tegra_i2s2>;
+		nvidia,audio-codec = <&sgtl5000>;
+		clocks = <&tegra_car TEGRA30_CLK_PLL_A>,
+			 <&tegra_car TEGRA30_CLK_PLL_A_OUT0>,
+			 <&tegra_car TEGRA30_CLK_EXTERN1>;
+		clock-names = "pll_a", "pll_a_out0", "mclk";
+	};
 };
diff --git a/arch/arm/boot/dts/tegra30-colibri.dtsi b/arch/arm/boot/dts/tegra30-colibri.dtsi
index c4ed1be..e8ac72e 100644
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
@@ -182,6 +200,15 @@
 		status = "okay";
 		clock-frequency = <100000>;
 
+		/* SGTL5000 audio codec */
+		sgtl5000: codec@0a {
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
@@ -331,6 +358,12 @@
 		nvidia,sys-clock-req-active-high;
 	};
 
+	ahub@70080000 {
+		i2s@70080500 {
+			status = "okay";
+		};
+	};
+
 	emmc: sdhci@78000600 {
 		status = "okay";
 		bus-width = <8>;
@@ -383,4 +416,20 @@
 			regulator-always-on;
 		};
 	};
+
+	sound {
+		compatible = "toradex,tegra-audio-sgtl5000-colibri_t30",
+			     "nvidia,tegra-audio-sgtl5000";
+		nvidia,model = "Toradex Colibri T30";
+		nvidia,audio-routing =
+			"Headphone Jack", "HP_OUT",
+			"LINE_IN", "Line In Jack",
+			"MIC_IN", "Mic Jack";
+		nvidia,i2s-controller = <&tegra_i2s2>;
+		nvidia,audio-codec = <&sgtl5000>;
+		clocks = <&tegra_car TEGRA30_CLK_PLL_A>,
+			 <&tegra_car TEGRA30_CLK_PLL_A_OUT0>,
+			 <&tegra_car TEGRA30_CLK_EXTERN1>;
+		clock-names = "pll_a", "pll_a_out0", "mclk";
+	};
 };
-- 
1.9.3

