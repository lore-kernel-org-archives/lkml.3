Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaGaLXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:23:09 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:38065 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbaGaLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:22:34 -0400
From: Humberto Silva Naves <hsnaves@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Humberto Silva Naves <hsnaves@gmail.com>
Subject: [PATCHv2 4/5] clk: samsung: exynos5410: Add fixed rate clocks
Date: Thu, 31 Jul 2014 13:22:11 +0200
Message-Id: <1406805732-17372-5-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the fixed rate clocks generated either inside or
outside the SoC. It also adds a dt-binding constant for the
sclk_hdmiphy clock, which shall be later used by other drivers,
such as the DRM.

Since the external fixed rate clock fin_pll is now registered by
the clk-exynos5410 file, the bindings with the device tree file have
changed. It is no longer needed to define fin_pll as a fixed clock,
such as in:

	fin_pll: xxti {
  		compatible = "fixed-clock";
	  	clock-frequency = <24000000>;
	  	clock-output-names = "fin_pll";
	  	#clock-cells = <0>;
	};

The above lines should be replaced by the following lines:

	fixed-rate-clocks {
		oscclk {
			compatible = "samsung,exynos5410-oscclk";
			clock-frequency = <24000000>;
		};
	};

This new form of binding was properly documented in the relevant
documentation file.

Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
---
 .../devicetree/bindings/clock/exynos5410-clock.txt |   17 ++++++++++---
 drivers/clk/samsung/clk-exynos5410.c               |   26 +++++++++++++++++++-
 include/dt-bindings/clock/exynos5410.h             |    1 +
 3 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/exynos5410-clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
index aeab635..9f4a286 100644
--- a/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
+++ b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
@@ -18,12 +18,21 @@ tree sources.
 
 External clock:
 
-There is clock that is generated outside the SoC. It
-is expected that it is defined using standard clock bindings
-with following clock-output-name:
-
+There is a clock that is generated outside the SoC, namely
  - "fin_pll" - PLL input clock from XXTI
 
+It is expected that a binding compatible with "samsung,exynos5410-oscclk"
+having a populated clock-frequency field such as follows to be used in
+order to define this external clock:
+
+	fixed-rate-clocks {
+		oscclk {
+			compatible = "samsung,exynos5410-oscclk";
+			clock-frequency = <24000000>;
+		};
+	};
+
+
 Example 1: An example of a clock controller node is listed below.
 
 	clock: clock-controller@0x10010000 {
diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
index a9c261c..efbe734 100644
--- a/drivers/clk/samsung/clk-exynos5410.c
+++ b/drivers/clk/samsung/clk-exynos5410.c
@@ -307,6 +307,20 @@ PNAME(group2_p)		= { "fin_pll", "fin_pll", "none", "none",
 			"none", "none", "sclk_mpll_bpll",
 			 "none", "none", "sclk_cpll" };
 
+/* fixed rate clocks generated outside the soc */
+static struct samsung_fixed_rate_clock exynos5410_fixed_rate_ext_clks[] __initdata = {
+	FRATE(CLK_FIN_PLL, "fin_pll", NULL, CLK_IS_ROOT, 0),
+};
+
+/* fixed rate clocks generated inside the soc */
+static struct samsung_fixed_rate_clock exynos5410_fixed_rate_clks[] __initdata = {
+	FRATE(CLK_SCLK_HDMIPHY, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 24000000),
+	FRATE(0, "sclk_hdmi24m", NULL, CLK_IS_ROOT, 24000000),
+	FRATE(0, "sclk_hdmi27m", NULL, CLK_IS_ROOT, 27000000),
+	FRATE(0, "sclk_dptxphy", NULL, CLK_IS_ROOT, 24000000),
+	FRATE(0, "sclk_uhostphy", NULL, CLK_IS_ROOT, 48000000),
+};
+
 static struct samsung_mux_clock exynos5410_mux_clks[] __initdata = {
 	MUX(0, "mout_apll", apll_p, SRC_CPU, 0, 1),
 	MUX(0, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1),
@@ -411,6 +425,11 @@ static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
 		KPLL_CON0, NULL),
 };
 
+static const struct of_device_id ext_clk_match[] __initconst = {
+	{ .compatible = "samsung,exynos5410-oscclk", .data = (void *)0, },
+	{ },
+};
+
 /* register exynos5410 clocks */
 static void __init exynos5410_clk_init(struct device_node *np)
 {
@@ -428,9 +447,14 @@ static void __init exynos5410_clk_init(struct device_node *np)
 	if (!ctx)
 		panic("%s: unable to allocate context.\n", __func__);
 
+	samsung_clk_of_register_fixed_ext(ctx, exynos5410_fixed_rate_ext_clks,
+			ARRAY_SIZE(exynos5410_fixed_rate_ext_clks),
+			ext_clk_match);
+
 	samsung_clk_register_pll(ctx, exynos5410_plls,
 			ARRAY_SIZE(exynos5410_plls), reg_base);
-
+	samsung_clk_register_fixed_rate(ctx, exynos5410_fixed_rate_clks,
+			ARRAY_SIZE(exynos5410_fixed_rate_clks));
 	samsung_clk_register_mux(ctx, exynos5410_mux_clks,
 			ARRAY_SIZE(exynos5410_mux_clks));
 	samsung_clk_register_div(ctx, exynos5410_div_clks,
diff --git a/include/dt-bindings/clock/exynos5410.h b/include/dt-bindings/clock/exynos5410.h
index 9b180f0..3a8da3c 100644
--- a/include/dt-bindings/clock/exynos5410.h
+++ b/include/dt-bindings/clock/exynos5410.h
@@ -17,6 +17,7 @@
 #define CLK_SCLK_MMC0 132
 #define CLK_SCLK_MMC1 133
 #define CLK_SCLK_MMC2 134
+#define CLK_SCLK_HDMIPHY 135
 
 /* gate clocks */
 #define CLK_UART0 257
-- 
1.7.10.4

