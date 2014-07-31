Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaGaLWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:22:42 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37456 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaGaLWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:22:37 -0400
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
Subject: [PATCHv2 5/5] clk: samsung: exynos5410: Added clocks DPLL, EPLL, IPLL, and VPLL
Date: Thu, 31 Jul 2014 13:22:12 +0200
Message-Id: <1406805732-17372-6-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the remaining PLL clocks, and also added the configuration
tables with the PLL coefficients for the supported frequencies.
These frequency tables are only installed when a 24MHz clock is
supplied as the input clock source. To reflect these changes, new
constants were added to the dt-bindings file.

Furthermore, the definition of the clock "mout_vpllsrc" was added,
as it is required for the VPLL.

Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
---
 drivers/clk/samsung/clk-exynos5410.c   |  130 +++++++++++++++++++++++++++++++-
 include/dt-bindings/clock/exynos5410.h |    4 +
 2 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos5410.c b/drivers/clk/samsung/clk-exynos5410.c
index efbe734..9a6a371 100644
--- a/drivers/clk/samsung/clk-exynos5410.c
+++ b/drivers/clk/samsung/clk-exynos5410.c
@@ -157,7 +157,8 @@
 /* list of PLLs */
 enum exynos5410_plls {
 	apll, cpll, mpll,
-	bpll, kpll,
+	bpll, kpll, dpll,
+	epll, ipll, vpll,
 	nr_plls                 /* number of PLLs */
 };
 
@@ -302,6 +303,7 @@ PNAME(mout_kfc_p)	= { "mout_kpll", "sclk_mpll", };
 PNAME(mpll_user_p)	= { "fin_pll", "sclk_mpll", };
 PNAME(bpll_user_p)	= { "fin_pll", "sclk_bpll", };
 PNAME(mpll_bpll_p)	= { "sclk_mpll_muxed", "sclk_bpll_muxed", };
+PNAME(mout_vpllsrc_p)	= { "fin_pll", "sclk_hdmi27m" };
 
 PNAME(group2_p)		= { "fin_pll", "fin_pll", "none", "none",
 			"none", "none", "sclk_mpll_bpll",
@@ -321,6 +323,10 @@ static struct samsung_fixed_rate_clock exynos5410_fixed_rate_clks[] __initdata =
 	FRATE(0, "sclk_uhostphy", NULL, CLK_IS_ROOT, 48000000),
 };
 
+static struct samsung_mux_clock exynos5410_pll_pmux_clks[] __initdata = {
+	MUX(0, "mout_vpllsrc", mout_vpllsrc_p, SRC_TOP2, 0, 1),
+};
+
 static struct samsung_mux_clock exynos5410_mux_clks[] __initdata = {
 	MUX(0, "mout_apll", apll_p, SRC_CPU, 0, 1),
 	MUX(0, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1),
@@ -412,6 +418,107 @@ static struct samsung_gate_clock exynos5410_gate_clks[] __initdata = {
 			SRC_MASK_PERIC0, 8, CLK_SET_RATE_PARENT, 0),
 };
 
+static struct samsung_pll_rate_table apll_24mhz_tbl[] __initdata = {
+	/* sorted in descending order */
+	/* PLL_35XX_RATE(rate, m, p, s) */
+	PLL_35XX_RATE(2100000000, 175, 2, 0),
+	PLL_35XX_RATE(2000000000, 250, 3, 0),
+	PLL_35XX_RATE(1900000000, 475, 6, 0),
+	PLL_35XX_RATE(1800000000, 225, 3, 0),
+	PLL_35XX_RATE(1700000000, 425, 6, 0),
+	PLL_35XX_RATE(1600000000, 200, 3, 0),
+	PLL_35XX_RATE(1500000000, 250, 4, 0),
+	PLL_35XX_RATE(1400000000, 175, 3, 0),
+	PLL_35XX_RATE(1300000000, 325, 6, 0),
+	PLL_35XX_RATE(1200000000, 100, 2, 0),
+	PLL_35XX_RATE(1100000000, 275, 3, 1),
+	PLL_35XX_RATE(1000000000, 250, 3, 1),
+	PLL_35XX_RATE(900000000, 150, 2, 1),
+	PLL_35XX_RATE(800000000, 200, 3, 1),
+	PLL_35XX_RATE(700000000, 175, 3, 1),
+	PLL_35XX_RATE(600000000, 100, 2, 1),
+	PLL_35XX_RATE(500000000, 250, 3, 2),
+	PLL_35XX_RATE(400000000, 200, 3, 2),
+	PLL_35XX_RATE(300000000, 100, 2, 2),
+	PLL_35XX_RATE(200000000, 200, 3, 3),
+	{ },
+};
+
+static struct samsung_pll_rate_table cpll_24mhz_tbl[] __initdata = {
+	/* sorted in descending order */
+	/* PLL_35XX_RATE(rate, m, p, s) */
+	PLL_35XX_RATE(666000000, 222, 4, 1),
+	PLL_35XX_RATE(640000000, 160, 3, 1),
+	PLL_35XX_RATE(320000000, 160, 3, 2),
+	{ },
+};
+
+static struct samsung_pll_rate_table dpll_24mhz_tbl[] __initdata = {
+	/* sorted in descending order */
+	/* PLL_35XX_RATE(rate, m, p, s) */
+	PLL_35XX_RATE(600000000, 200, 4, 1),
+	{ },
+};
+
+static struct samsung_pll_rate_table epll_24mhz_tbl[] __initdata = {
+	/* sorted in descending order */
+	/* PLL_36XX_RATE(rate, m, p, s, k) */
+	PLL_36XX_RATE(600000000, 100, 2, 1,      0),
+	PLL_36XX_RATE(400000000, 200, 3, 2,      0),
+	PLL_36XX_RATE(200000000, 200, 3, 3,      0),
+	PLL_36XX_RATE(180633600, 301, 5, 3,  -3670),
+	PLL_36XX_RATE( 67737600, 452, 5, 5, -27263),
+	PLL_36XX_RATE( 49152000, 197, 3, 5, -25690),
+	PLL_36XX_RATE( 45158401, 181, 3, 5, -24012),
+	{ },
+};
+
+static struct samsung_pll_rate_table ipll_24mhz_tbl[] __initdata = {
+	/* sorted in descending order */
+	/* PLL_35XX_RATE(rate, m, p, s, k) */
+	PLL_35XX_RATE(864000000, 288, 4, 1),
+	PLL_35XX_RATE(666000000, 222, 4, 1),
+	PLL_35XX_RATE(432000000, 288, 4, 2),
+	{ },
+};
+
+static struct samsung_pll_rate_table kpll_24mhz_tbl[] __initdata = {
+	/* sorted in descending order */
+	/* PLL_35XX_RATE(rate, m, p, s) */
+	PLL_35XX_RATE(1500000000, 250, 4, 0),
+	PLL_35XX_RATE(1400000000, 175, 3, 0),
+	PLL_35XX_RATE(1300000000, 325, 6, 0),
+	PLL_35XX_RATE(1200000000, 100, 2, 0),
+	PLL_35XX_RATE(1100000000, 275, 3, 1),
+	PLL_35XX_RATE(1000000000, 250, 3, 1),
+	PLL_35XX_RATE(900000000, 150, 2, 1),
+	PLL_35XX_RATE(800000000, 200, 3, 1),
+	PLL_35XX_RATE(700000000, 175, 3, 1),
+	PLL_35XX_RATE(600000000, 100, 2, 1),
+	PLL_35XX_RATE(500000000, 250, 3, 2),
+	PLL_35XX_RATE(400000000, 200, 3, 2),
+	PLL_35XX_RATE(300000000, 100, 2, 2),
+	PLL_35XX_RATE(200000000, 200, 3, 3),
+	{ },
+};
+
+static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
+	/* sorted in descending order */
+	/* PLL_36XX_RATE(rate, m, p, s, k) */
+	PLL_36XX_RATE(880000000, 220, 3, 1, 0),
+	PLL_36XX_RATE(640000000, 160, 3, 1, 0),
+	PLL_36XX_RATE(532000000, 133, 3, 1, 0),
+	PLL_36XX_RATE(480000000, 240, 3, 2, 0),
+	PLL_36XX_RATE(440000000, 220, 3, 2, 0),
+	PLL_36XX_RATE(350000000, 175, 3, 2, 0),
+	PLL_36XX_RATE(333000000, 111, 2, 2, 0),
+	PLL_36XX_RATE(266000000, 133, 3, 2, 0),
+	PLL_36XX_RATE(177000000, 118, 2, 3, 0),
+	PLL_36XX_RATE(123500000, 330, 4, 4, 0),
+	PLL_36XX_RATE( 89000000, 178, 3, 4, 0),
+	{ },
+};
+
 static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
 	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll", APLL_LOCK,
 		APLL_CON0, NULL),
@@ -423,6 +530,14 @@ static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
 		BPLL_CON0, NULL),
 	[kpll] = PLL(pll_35xx, CLK_FOUT_KPLL, "fout_kpll", "fin_pll", KPLL_LOCK,
 		KPLL_CON0, NULL),
+	[dpll] = PLL(pll_35xx, CLK_FOUT_DPLL, "fout_dpll", "fin_pll", DPLL_LOCK,
+		DPLL_CON0, NULL),
+	[epll] = PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll", EPLL_LOCK,
+		EPLL_CON0, NULL),
+	[ipll] = PLL(pll_35xx, CLK_FOUT_IPLL, "fout_ipll", "fin_pll", IPLL_LOCK,
+		IPLL_CON0, NULL),
+	[vpll] = PLL(pll_36xx, CLK_FOUT_VPLL, "fout_vpll", "mout_vpllsrc",
+		VPLL_LOCK, VPLL_CON0, NULL),
 };
 
 static const struct of_device_id ext_clk_match[] __initconst = {
@@ -450,6 +565,19 @@ static void __init exynos5410_clk_init(struct device_node *np)
 	samsung_clk_of_register_fixed_ext(ctx, exynos5410_fixed_rate_ext_clks,
 			ARRAY_SIZE(exynos5410_fixed_rate_ext_clks),
 			ext_clk_match);
+	samsung_clk_register_mux(ctx, exynos5410_pll_pmux_clks,
+				ARRAY_SIZE(exynos5410_pll_pmux_clks));
+
+	if (_get_rate("fin_pll") == 24 * MHZ) {
+		exynos5410_plls[apll].rate_table = apll_24mhz_tbl;
+		exynos5410_plls[cpll].rate_table = cpll_24mhz_tbl;
+		exynos5410_plls[kpll].rate_table = kpll_24mhz_tbl;
+		exynos5410_plls[dpll].rate_table = dpll_24mhz_tbl;
+		exynos5410_plls[epll].rate_table = epll_24mhz_tbl;
+		exynos5410_plls[ipll].rate_table = ipll_24mhz_tbl;
+	}
+	if (_get_rate("mout_vpllsrc") == 24 * MHZ)
+		exynos5410_plls[vpll].rate_table = vpll_24mhz_tbl;
 
 	samsung_clk_register_pll(ctx, exynos5410_plls,
 			ARRAY_SIZE(exynos5410_plls), reg_base);
diff --git a/include/dt-bindings/clock/exynos5410.h b/include/dt-bindings/clock/exynos5410.h
index 3a8da3c..7da296c 100644
--- a/include/dt-bindings/clock/exynos5410.h
+++ b/include/dt-bindings/clock/exynos5410.h
@@ -8,6 +8,10 @@
 #define CLK_FOUT_MPLL 4
 #define CLK_FOUT_BPLL 5
 #define CLK_FOUT_KPLL 6
+#define CLK_FOUT_DPLL 7
+#define CLK_FOUT_EPLL 8
+#define CLK_FOUT_IPLL 9
+#define CLK_FOUT_VPLL 10
 
 /* gate for special clocks (sclk) */
 #define CLK_SCLK_UART0 128
-- 
1.7.10.4

