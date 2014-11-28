Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaK1B0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:26:22 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:47361 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaK1B0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:26:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,473,1413270000"; 
   d="scan'208";a="51978974"
From: Ray Jui <rjui@broadcom.com>
To: <linux-arm-kernel@lists.infradead.org>,
        Scott Branden <sbranden@broadcom.com>
CC: <linux-kernel@vger.kernel.org>, <bcm-kernel-feedback-list@broadcom.com>,
        Ray Jui <rjui@broadcom.com>
Subject: [PATCH 4/4] ARM: dts: enable clock support for Broadcom Cygnus
Date: Thu, 27 Nov 2014 17:27:46 -0800
Message-ID: <1417138066-17906-5-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417138066-17906-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1417138066-17906-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace current device tree dummy clocks with real clock support for
Broadcom Cygnus SoC

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: Scott Branden <sbraden@broadcom.com>
---
 arch/arm/boot/dts/bcm-cygnus-clock.dtsi |  110 ++++++++++++++++++++++++-------
 arch/arm/boot/dts/bcm-cygnus.dtsi       |    2 +-
 2 files changed, 86 insertions(+), 26 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-cygnus-clock.dtsi b/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
index 60d8389..f2da5e2 100644
--- a/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus-clock.dtsi
@@ -36,56 +36,116 @@ clocks {
 	ranges;
 
 	osc: oscillator {
+		#clock-cells = <0>;
 		compatible = "fixed-clock";
-		#clock-cells = <1>;
 		clock-frequency = <25000000>;
 	};
 
-	apb_clk: apb_clk {
-		compatible = "fixed-clock";
+	/* Cygnus ARM PLL */
+	armpll: armpll {
 		#clock-cells = <0>;
-		clock-frequency = <1000000000>;
+		compatible = "brcm,cygnus-armpll";
+		clocks = <&osc>;
+		reg = <0x19000000 0x1000>;
 	};
 
-	periph_clk: periph_clk {
-		compatible = "fixed-clock";
+	/* peripheral clock for system timer */
+	arm_periph_clk: arm_periph_clk {
 		#clock-cells = <0>;
-		clock-frequency = <500000000>;
+		compatible = "fixed-factor-clock";
+		clocks = <&armpll>;
+		clock-div = <2>;
+		clock-mult = <1>;
 	};
 
-	sdio_clk: lcpll_ch2 {
-		compatible = "fixed-clock";
+	/* APB bus clock */
+	apb_clk: apb_clk {
 		#clock-cells = <0>;
-		clock-frequency = <200000000>;
+		compatible = "fixed-factor-clock";
+		clocks = <&armpll>;
+		clock-div = <4>;
+		clock-mult = <1>;
 	};
 
-	axi81_clk: axi81_clk {
-		compatible = "fixed-clock";
+	genpll: genpll {
 		#clock-cells = <0>;
-		clock-frequency = <100000000>;
+		compatible = "brcm,cygnus-genpll";
+		reg = <0x0301d000 0x2c>,
+			<0x0301c020 0x4>;
+		clocks = <&osc>;
 	};
 
-	keypad_clk: keypad_clk {
-		compatible = "fixed-clock";
+	/* various clocks running off the GENPLL */
+	genpll_clks: genpll_clks {
+		#clock-cells = <1>;
+		compatible = "brcm,cygnus-genpll-clk";
+		reg = <0x0301d000 0x2c>;
+		clocks = <&genpll>;
+		clock-output-names = "axi21", "250mhz", "ihost_sys",
+			"enet_sw", "audio_125", "can";
+	};
+
+	/* always 1/2 of the axi21 clock */
+	axi41_clk: axi41_clk {
 		#clock-cells = <0>;
-		clock-frequency = <31806>;
+		compatible = "fixed-factor-clock";
+		clocks = <&genpll_clks 0>;
+		clock-div = <2>;
+		clock-mult = <1>;
 	};
 
-	adc_clk: adc_clk {
-		compatible = "fixed-clock";
+	/* always 1/4 of the axi21 clock */
+	axi81_clk: axi81_clk {
 		#clock-cells = <0>;
-		clock-frequency = <1562500>;
+		compatible = "fixed-factor-clock";
+		clocks = <&genpll_clks 0>;
+		clock-div = <4>;
+		clock-mult = <1>;
 	};
 
-	pwm_clk: pwm_clk {
-		compatible = "fixed-clock";
+	lcpll0: lcpll0 {
 		#clock-cells = <0>;
-		clock-frequency = <1000000>;
+		compatible = "brcm,cygnus-lcpll0";
+		reg = <0x0301d02c 0x1c>,
+			<0x0301c020 0x4>;
+		clocks = <&osc>;
 	};
 
-	lcd_clk: mipipll_ch1 {
-		compatible = "fixed-clock";
+	/* various clocks running off the LCPLL0 */
+	lcpll0_clks: lcpll0_clks {
+		#clock-cells = <1>;
+		compatible = "brcm,cygnus-lcpll0-clk";
+		reg = <0x0301d02c 0x1c>;
+		clocks = <&lcpll0>;
+		clock-output-names = "pcie_phy", "ddr_phy", "sdio",
+			"usb_phy", "smart_card", "ch5";
+	};
+
+	mipipll: mipipll {
 		#clock-cells = <0>;
-		clock-frequency = <100000000>;
+		compatible = "brcm,cygnus-mipipll";
+		reg = <0x180a9800 0x2c>,
+			<0x0301c020 0x4>,
+			<0x180aa024 0x4>;
+		clock-frequency = <1350000000>;
+		clocks = <&osc>;
+	};
+
+	mipipll_clks: mipipll_clks {
+		#clock-cells = <1>;
+		compatible = "brcm,cygnus-mipipll-clk";
+		reg = <0x180a9800 0x2c>;
+		clocks = <&mipipll>;
+		clock-output-names = "ch0_unused", "ch1_lcd", "ch2_unused",
+			"ch3_unused", "ch4_unused", "ch5_unused";
+	};
+
+	asiu_clks: asiu_clks {
+		#clock-cells = <1>;
+		compatible = "brcm,cygnus-asiu-clk";
+		reg = <0x0301d048 0xc>,
+			<0x180aa024 0x4>;
+		clocks = <&osc>;
+		clock-output-names = "keypad", "adc/touch", "pwm";
 	};
 };
diff --git a/arch/arm/boot/dts/bcm-cygnus.dtsi b/arch/arm/boot/dts/bcm-cygnus.dtsi
index 5126f9e..2b99e9c 100644
--- a/arch/arm/boot/dts/bcm-cygnus.dtsi
+++ b/arch/arm/boot/dts/bcm-cygnus.dtsi
@@ -134,7 +134,7 @@
 		compatible = "arm,cortex-a9-global-timer";
 		reg = <0x19020200 0x100>;
 		interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&periph_clk>;
+		clocks = <&arm_periph_clk>;
 	};
 
 };
-- 
1.7.9.5

