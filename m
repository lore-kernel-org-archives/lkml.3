Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaHDODm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:03:42 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51990 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaHDODE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:03:04 -0400
From: Humberto Silva Naves <hsnaves@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Humberto Silva Naves <hsnaves@gmail.com>
Subject: [PATCH 1/2] clk: samsung: Add validation of rate tables for the PLL clocks
Date: Mon,  4 Aug 2014 16:02:47 +0200
Message-Id: <1407160968-12108-2-git-send-email-hsnaves@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1407160968-12108-1-git-send-email-hsnaves@gmail.com>
References: <1407160968-12108-1-git-send-email-hsnaves@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no mechanism for validation of the PLL rate tables
in the samsung clock driver. In addition, the implementation does not
allow the use ``heterogenous'' tables (i.e., tables whose entries can
correspond to different clock sources).
For instance, consider the VPLL clock from Exynos5410. Its input source
is the MUX mout_vpllsrc, which can generate either 24 MHz or 27 MHz.
The usual way to add rate tables for these two different clock sources
would be:

static const struct samsung_pll_rate_table vpll_24mhz_tbl[] = {
	PLL_36XX_RATE(880000000, 220, 3, 1, 0),
	{ }
};
static const struct samsung_pll_rate_table vpll_27mhz_tbl[] = {
	/* ... */
	{ }
};
static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
        [vpll] = PLL(pll_36xx, CLK_FOUT_VPLL, "fout_vpll", "mout_vpllsrc",
                VPLL_LOCK, VPLL_CON0, NULL),
};

and in the initialization function:

if (_get_rate("mout_vpllsrc") == 24 * MHZ)
        exynos5410_plls[vpll].rate_table = vpll_24mhz_tbl;
else if (_get_rate("mout_vpllsrc") == 27 * MHZ)
        exynos5410_plls[vpll].rate_table = vpll_27mhz_tbl;

There are many issues with this approach:
- Again, there is no validation for the parameters in the rate tables.
- It is cumbersome, and multiple tables must be defined.
- It adds an explicit dependency to the clock "mout_vpllsrc",
  which might not be ready at the time we register the tables.
  For instance, its rate might depend on an external clock such as "fin_pll", see:
  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35065.html
- The PLL tables are NOT const, hence cannot be marked as __initconst.

This patch adds a new scheme for validation and for the use of heterogenous
tables in the samsung_clk_register_pll function. Among other things, it also:
  o Adds support for automatic calculation of rates based on clock parameters
    such as mdiv, pdiv, sdiv.
  o Defines a new field in the structure samsung_pll_rate_table:
    instead of only the field rate, it now has ".brate" (base rate), which
    is the rate of the input clock source, and ".orate" (output rate), which
    is the actual rate of the PLL clock to be used in the set_rate function.
    The field .brate is used to differentiate the various input clock sources.
  o Automatically sorts the rate table according to the output rate. Hence it
    is no longer required that the entries should be in descending order.
  o Issues a warning if an entry is incorrect (usually due to round-off errors,
    such as in EPLL for exynos5410)

Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
---
 drivers/clk/samsung/clk-exynos3250.c |  99 +++++----
 drivers/clk/samsung/clk-exynos4.c    | 130 +++++-------
 drivers/clk/samsung/clk-exynos5250.c |  70 +++----
 drivers/clk/samsung/clk-exynos5260.c |  90 ++++----
 drivers/clk/samsung/clk-exynos5420.c |  48 ++---
 drivers/clk/samsung/clk-pll.c        | 387 ++++++++++++++++++++++++++---------
 drivers/clk/samsung/clk-pll.h        |  30 +--
 drivers/clk/samsung/clk-s3c2410.c    | 134 ++++++------
 8 files changed, 567 insertions(+), 421 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index dc85f8e..ede6742 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -704,66 +704,66 @@ static struct samsung_gate_clock gate_clks[] __initdata = {
 
 /* APLL & MPLL & BPLL & UPLL */
 static struct samsung_pll_rate_table exynos3250_pll_rates[] = {
-	PLL_35XX_RATE(1200000000, 400, 4, 1),
-	PLL_35XX_RATE(1100000000, 275, 3, 1),
-	PLL_35XX_RATE(1066000000, 533, 6, 1),
-	PLL_35XX_RATE(1000000000, 250, 3, 1),
-	PLL_35XX_RATE( 960000000, 320, 4, 1),
-	PLL_35XX_RATE( 900000000, 300, 4, 1),
-	PLL_35XX_RATE( 850000000, 425, 6, 1),
-	PLL_35XX_RATE( 800000000, 200, 3, 1),
-	PLL_35XX_RATE( 700000000, 175, 3, 1),
-	PLL_35XX_RATE( 667000000, 667, 12, 1),
-	PLL_35XX_RATE( 600000000, 400, 4, 2),
-	PLL_35XX_RATE( 533000000, 533, 6, 2),
-	PLL_35XX_RATE( 520000000, 260, 3, 2),
-	PLL_35XX_RATE( 500000000, 250, 3, 2),
-	PLL_35XX_RATE( 400000000, 200, 3, 2),
-	PLL_35XX_RATE( 200000000, 200, 3, 3),
-	PLL_35XX_RATE( 100000000, 200, 3, 4),
+	PLL_35XX_RATE(1200000000, 24000000, 400, 4, 1),
+	PLL_35XX_RATE(1100000000, 24000000, 275, 3, 1),
+	PLL_35XX_RATE(1066000000, 24000000, 533, 6, 1),
+	PLL_35XX_RATE(1000000000, 24000000, 250, 3, 1),
+	PLL_35XX_RATE( 960000000, 24000000, 320, 4, 1),
+	PLL_35XX_RATE( 900000000, 24000000, 300, 4, 1),
+	PLL_35XX_RATE( 850000000, 24000000, 425, 6, 1),
+	PLL_35XX_RATE( 800000000, 24000000, 200, 3, 1),
+	PLL_35XX_RATE( 700000000, 24000000, 175, 3, 1),
+	PLL_35XX_RATE( 667000000, 24000000, 667, 12, 1),
+	PLL_35XX_RATE( 600000000, 24000000, 400, 4, 2),
+	PLL_35XX_RATE( 533000000, 24000000, 533, 6, 2),
+	PLL_35XX_RATE( 520000000, 24000000, 260, 3, 2),
+	PLL_35XX_RATE( 500000000, 24000000, 250, 3, 2),
+	PLL_35XX_RATE( 400000000, 24000000, 200, 3, 2),
+	PLL_35XX_RATE( 200000000, 24000000, 200, 3, 3),
+	PLL_35XX_RATE( 100000000, 24000000, 200, 3, 4),
 	{ /* sentinel */ }
 };
 
 /* VPLL */
 static struct samsung_pll_rate_table exynos3250_vpll_rates[] = {
-	PLL_36XX_RATE(600000000, 100, 2, 1,     0),
-	PLL_36XX_RATE(533000000, 266, 3, 2, 32768),
-	PLL_36XX_RATE(519230987, 173, 2, 2,  5046),
-	PLL_36XX_RATE(500000000, 250, 3, 2,     0),
-	PLL_36XX_RATE(445500000, 148, 2, 2, 32768),
-	PLL_36XX_RATE(445055007, 148, 2, 2, 23047),
-	PLL_36XX_RATE(400000000, 200, 3, 2,     0),
-	PLL_36XX_RATE(371250000, 123, 2, 2, 49152),
-	PLL_36XX_RATE(370878997, 185, 3, 2, 28803),
-	PLL_36XX_RATE(340000000, 170, 3, 2,     0),
-	PLL_36XX_RATE(335000015, 111, 2, 2, 43691),
-	PLL_36XX_RATE(333000000, 111, 2, 2,     0),
-	PLL_36XX_RATE(330000000, 110, 2, 2,     0),
-	PLL_36XX_RATE(320000015, 106, 2, 2, 43691),
-	PLL_36XX_RATE(300000000, 100, 2, 2,     0),
-	PLL_36XX_RATE(275000000, 275, 3, 3,     0),
-	PLL_36XX_RATE(222750000, 148, 2, 3, 32768),
-	PLL_36XX_RATE(222528007, 148, 2, 3, 23069),
-	PLL_36XX_RATE(160000000, 160, 3, 3,     0),
-	PLL_36XX_RATE(148500000,  99, 2, 3,     0),
-	PLL_36XX_RATE(148352005,  98, 2, 3, 59070),
-	PLL_36XX_RATE(108000000, 144, 2, 4,     0),
-	PLL_36XX_RATE( 74250000,  99, 2, 4,     0),
-	PLL_36XX_RATE( 74176002,  98, 3, 4, 59070),
-	PLL_36XX_RATE( 54054000, 216, 3, 5, 14156),
-	PLL_36XX_RATE( 54000000, 144, 2, 5,     0),
+	PLL_36XX_RATE(600000000, 24000000, 100, 2, 1,     0),
+	PLL_36XX_RATE(533000000, 24000000, 266, 3, 2, 32768),
+	PLL_36XX_RATE(519230987, 24000000, 173, 2, 2,  5046),
+	PLL_36XX_RATE(500000000, 24000000, 250, 3, 2,     0),
+	PLL_36XX_RATE(445500000, 24000000, 148, 2, 2, 32768),
+	PLL_36XX_RATE(445055007, 24000000, 148, 2, 2, 23047),
+	PLL_36XX_RATE(400000000, 24000000, 200, 3, 2,     0),
+	PLL_36XX_RATE(371250000, 24000000, 123, 2, 2, 49152),
+	PLL_36XX_RATE(370878997, 24000000, 185, 3, 2, 28803),
+	PLL_36XX_RATE(340000000, 24000000, 170, 3, 2,     0),
+	PLL_36XX_RATE(335000015, 24000000, 111, 2, 2, 43691),
+	PLL_36XX_RATE(333000000, 24000000, 111, 2, 2,     0),
+	PLL_36XX_RATE(330000000, 24000000, 110, 2, 2,     0),
+	PLL_36XX_RATE(320000015, 24000000, 106, 2, 2, 43691),
+	PLL_36XX_RATE(300000000, 24000000, 100, 2, 2,     0),
+	PLL_36XX_RATE(275000000, 24000000, 275, 3, 3,     0),
+	PLL_36XX_RATE(222750000, 24000000, 148, 2, 3, 32768),
+	PLL_36XX_RATE(222528007, 24000000, 148, 2, 3, 23069),
+	PLL_36XX_RATE(160000000, 24000000, 160, 3, 3,     0),
+	PLL_36XX_RATE(148500000, 24000000,  99, 2, 3,     0),
+	PLL_36XX_RATE(148352005, 24000000,  98, 2, 3, 59070),
+	PLL_36XX_RATE(108000000, 24000000, 144, 2, 4,     0),
+	PLL_36XX_RATE( 74250000, 24000000,  99, 2, 4,     0),
+	PLL_36XX_RATE( 74176002, 24000000,  98, 3, 4, 59070),
+	PLL_36XX_RATE( 54054000, 24000000, 216, 3, 5, 14156),
+	PLL_36XX_RATE( 54000000, 24000000, 144, 2, 5,     0),
 	{ /* sentinel */ }
 };
 
 static struct samsung_pll_clock exynos3250_plls[nr_plls] __initdata = {
 	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
-			APLL_LOCK, APLL_CON0, NULL),
+			APLL_LOCK, APLL_CON0, exynos3250_pll_rates),
 	[mpll] = PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
-			MPLL_LOCK, MPLL_CON0, NULL),
+			MPLL_LOCK, MPLL_CON0, exynos3250_pll_rates),
 	[vpll] = PLL(pll_36xx, CLK_FOUT_VPLL, "fout_vpll", "fin_pll",
-			VPLL_LOCK, VPLL_CON0, NULL),
+			VPLL_LOCK, VPLL_CON0, exynos3250_vpll_rates),
 	[upll] = PLL(pll_35xx, CLK_FOUT_UPLL, "fout_upll", "fin_pll",
-			UPLL_LOCK, UPLL_CON0, NULL),
+			UPLL_LOCK, UPLL_CON0, exynos3250_pll_rates),
 };
 
 static void __init exynos3_core_down_clock(void)
@@ -802,11 +802,6 @@ static void __init exynos3250_cmu_init(struct device_node *np)
 	samsung_clk_register_fixed_factor(ctx, fixed_factor_clks,
 					  ARRAY_SIZE(fixed_factor_clks));
 
-	exynos3250_plls[apll].rate_table = exynos3250_pll_rates;
-	exynos3250_plls[mpll].rate_table = exynos3250_pll_rates;
-	exynos3250_plls[vpll].rate_table = exynos3250_vpll_rates;
-	exynos3250_plls[upll].rate_table = exynos3250_pll_rates;
-
 	samsung_clk_register_pll(ctx, exynos3250_plls,
 					ARRAY_SIZE(exynos3250_plls), reg_base);
 
diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index ac163d7..ab690c8 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1262,98 +1262,98 @@ static const struct of_device_id ext_clk_match[] __initconst = {
 
 /* PLLs PMS values */
 static struct samsung_pll_rate_table exynos4210_apll_rates[] __initdata = {
-	PLL_45XX_RATE(1200000000, 150,  3, 1, 28),
-	PLL_45XX_RATE(1000000000, 250,  6, 1, 28),
-	PLL_45XX_RATE( 800000000, 200,  6, 1, 28),
-	PLL_45XX_RATE( 666857142, 389, 14, 1, 13),
-	PLL_45XX_RATE( 600000000, 100,  4, 1, 13),
-	PLL_45XX_RATE( 533000000, 533, 24, 1,  5),
-	PLL_45XX_RATE( 500000000, 250,  6, 2, 28),
-	PLL_45XX_RATE( 400000000, 200,  6, 2, 28),
-	PLL_45XX_RATE( 200000000, 200,  6, 3, 28),
+	PLL_45XX_RATE(1200000000, 24000000, 150,  3, 1, 28),
+	PLL_45XX_RATE(1000000000, 24000000, 250,  6, 1, 28),
+	PLL_45XX_RATE( 800000000, 24000000, 200,  6, 1, 28),
+	PLL_45XX_RATE( 666857142, 24000000, 389, 14, 1, 13),
+	PLL_45XX_RATE( 600000000, 24000000, 100,  4, 1, 13),
+	PLL_45XX_RATE( 533000000, 24000000, 533, 24, 1,  5),
+	PLL_45XX_RATE( 500000000, 24000000, 250,  6, 2, 28),
+	PLL_45XX_RATE( 400000000, 24000000, 200,  6, 2, 28),
+	PLL_45XX_RATE( 200000000, 24000000, 200,  6, 3, 28),
 	{ /* sentinel */ }
 };
 
 static struct samsung_pll_rate_table exynos4210_epll_rates[] __initdata = {
-	PLL_4600_RATE(192000000, 48, 3, 1,     0, 0),
-	PLL_4600_RATE(180633605, 45, 3, 1, 10381, 0),
-	PLL_4600_RATE(180000000, 45, 3, 1,     0, 0),
-	PLL_4600_RATE( 73727996, 73, 3, 3, 47710, 1),
-	PLL_4600_RATE( 67737602, 90, 4, 3, 20762, 1),
-	PLL_4600_RATE( 49151992, 49, 3, 3,  9961, 0),
-	PLL_4600_RATE( 45158401, 45, 3, 3, 10381, 0),
+	PLL_4600_RATE(192000000, 24000000, 48, 3, 1,     0, 0),
+	PLL_4600_RATE(180633605, 24000000, 45, 3, 1, 10381, 0),
+	PLL_4600_RATE(180000000, 24000000, 45, 3, 1,     0, 0),
+	PLL_4600_RATE( 73727996, 24000000, 73, 3, 3, 47710, 1),
+	PLL_4600_RATE( 67737602, 24000000, 90, 4, 3, 20762, 1),
+	PLL_4600_RATE( 49151992, 24000000, 49, 3, 3,  9961, 0),
+	PLL_4600_RATE( 45158401, 24000000, 45, 3, 3, 10381, 0),
 	{ /* sentinel */ }
 };
 
 static struct samsung_pll_rate_table exynos4210_vpll_rates[] __initdata = {
-	PLL_4650_RATE(360000000, 44, 3, 0, 1024, 0, 14, 0),
-	PLL_4650_RATE(324000000, 53, 2, 1, 1024, 1,  1, 1),
-	PLL_4650_RATE(259617187, 63, 3, 1, 1950, 0, 20, 1),
-	PLL_4650_RATE(110000000, 53, 3, 2, 2048, 0, 17, 0),
-	PLL_4650_RATE( 55360351, 53, 3, 3, 2417, 0, 17, 0),
+	PLL_4650_RATE(360000000, 24000000, 44, 3, 0, 1024, 0, 14, 0),
+	PLL_4650_RATE(324000000, 24000000, 53, 2, 1, 1024, 1,  1, 1),
+	PLL_4650_RATE(259617187, 24000000, 63, 3, 1, 1950, 0, 20, 1),
+	PLL_4650_RATE(110000000, 24000000, 53, 3, 2, 2048, 0, 17, 0),
+	PLL_4650_RATE( 55360351, 24000000, 53, 3, 3, 2417, 0, 17, 0),
 	{ /* sentinel */ }
 };
 
 static struct samsung_pll_rate_table exynos4x12_apll_rates[] __initdata = {
-	PLL_35XX_RATE(1500000000, 250, 4, 0),
-	PLL_35XX_RATE(1400000000, 175, 3, 0),
-	PLL_35XX_RATE(1300000000, 325, 6, 0),
-	PLL_35XX_RATE(1200000000, 200, 4, 0),
-	PLL_35XX_RATE(1100000000, 275, 6, 0),
-	PLL_35XX_RATE(1000000000, 125, 3, 0),
-	PLL_35XX_RATE( 900000000, 150, 4, 0),
-	PLL_35XX_RATE( 800000000, 100, 3, 0),
-	PLL_35XX_RATE( 700000000, 175, 3, 1),
-	PLL_35XX_RATE( 600000000, 200, 4, 1),
-	PLL_35XX_RATE( 500000000, 125, 3, 1),
-	PLL_35XX_RATE( 400000000, 100, 3, 1),
-	PLL_35XX_RATE( 300000000, 200, 4, 2),
-	PLL_35XX_RATE( 200000000, 100, 3, 2),
+	PLL_35XX_RATE(1500000000, 24000000, 250, 4, 0),
+	PLL_35XX_RATE(1400000000, 24000000, 175, 3, 0),
+	PLL_35XX_RATE(1300000000, 24000000, 325, 6, 0),
+	PLL_35XX_RATE(1200000000, 24000000, 200, 4, 0),
+	PLL_35XX_RATE(1100000000, 24000000, 275, 6, 0),
+	PLL_35XX_RATE(1000000000, 24000000, 125, 3, 0),
+	PLL_35XX_RATE( 900000000, 24000000, 150, 4, 0),
+	PLL_35XX_RATE( 800000000, 24000000, 100, 3, 0),
+	PLL_35XX_RATE( 700000000, 24000000, 175, 3, 1),
+	PLL_35XX_RATE( 600000000, 24000000, 200, 4, 1),
+	PLL_35XX_RATE( 500000000, 24000000, 125, 3, 1),
+	PLL_35XX_RATE( 400000000, 24000000, 100, 3, 1),
+	PLL_35XX_RATE( 300000000, 24000000, 200, 4, 2),
+	PLL_35XX_RATE( 200000000, 24000000, 100, 3, 2),
 	{ /* sentinel */ }
 };
 
 static struct samsung_pll_rate_table exynos4x12_epll_rates[] __initdata = {
-	PLL_36XX_RATE(192000000, 48, 3, 1,     0),
-	PLL_36XX_RATE(180633605, 45, 3, 1, 10381),
-	PLL_36XX_RATE(180000000, 45, 3, 1,     0),
-	PLL_36XX_RATE( 73727996, 73, 3, 3, 47710),
-	PLL_36XX_RATE( 67737602, 90, 4, 3, 20762),
-	PLL_36XX_RATE( 49151992, 49, 3, 3,  9961),
-	PLL_36XX_RATE( 45158401, 45, 3, 3, 10381),
+	PLL_36XX_RATE(192000000, 24000000, 48, 3, 1,     0),
+	PLL_36XX_RATE(180633605, 24000000, 45, 3, 1, 10381),
+	PLL_36XX_RATE(180000000, 24000000, 45, 3, 1,     0),
+	PLL_36XX_RATE( 73727996, 24000000, 73, 3, 3, 47710),
+	PLL_36XX_RATE( 67737602, 24000000, 90, 4, 3, 20762),
+	PLL_36XX_RATE( 49151992, 24000000, 49, 3, 3,  9961),
+	PLL_36XX_RATE( 45158401, 24000000, 45, 3, 3, 10381),
 	{ /* sentinel */ }
 };
 
 static struct samsung_pll_rate_table exynos4x12_vpll_rates[] __initdata = {
-	PLL_36XX_RATE(533000000, 133, 3, 1, 16384),
-	PLL_36XX_RATE(440000000, 110, 3, 1,     0),
-	PLL_36XX_RATE(350000000, 175, 3, 2,     0),
-	PLL_36XX_RATE(266000000, 133, 3, 2,     0),
-	PLL_36XX_RATE(160000000, 160, 3, 3,     0),
-	PLL_36XX_RATE(106031250,  53, 3, 2,  1024),
-	PLL_36XX_RATE( 53015625,  53, 3, 3,  1024),
+	PLL_36XX_RATE(533000000, 24000000, 133, 3, 1, 16384),
+	PLL_36XX_RATE(440000000, 24000000, 110, 3, 1,     0),
+	PLL_36XX_RATE(350000000, 24000000, 175, 3, 2,     0),
+	PLL_36XX_RATE(266000000, 24000000, 133, 3, 2,     0),
+	PLL_36XX_RATE(160000000, 24000000, 160, 3, 3,     0),
+	PLL_36XX_RATE(106031250, 24000000,  53, 3, 2,  1024),
+	PLL_36XX_RATE( 53015625, 24000000,  53, 3, 3,  1024),
 	{ /* sentinel */ }
 };
 
 static struct samsung_pll_clock exynos4210_plls[nr_plls] __initdata = {
 	[apll] = PLL_A(pll_4508, CLK_FOUT_APLL, "fout_apll", "fin_pll",
-		APLL_LOCK, APLL_CON0, "fout_apll", NULL),
+		APLL_LOCK, APLL_CON0, "fout_apll", exynos4210_apll_rates),
 	[mpll] = PLL_A(pll_4508, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
 		E4210_MPLL_LOCK, E4210_MPLL_CON0, "fout_mpll", NULL),
 	[epll] = PLL_A(pll_4600, CLK_FOUT_EPLL, "fout_epll", "fin_pll",
-		EPLL_LOCK, EPLL_CON0, "fout_epll", NULL),
+		EPLL_LOCK, EPLL_CON0, "fout_epll", exynos4210_epll_rates),
 	[vpll] = PLL_A(pll_4650c, CLK_FOUT_VPLL, "fout_vpll", "mout_vpllsrc",
-		VPLL_LOCK, VPLL_CON0, "fout_vpll", NULL),
+		VPLL_LOCK, VPLL_CON0, "fout_vpll", exynos4210_vpll_rates),
 };
 
 static struct samsung_pll_clock exynos4x12_plls[nr_plls] __initdata = {
 	[apll] = PLL(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
-			APLL_LOCK, APLL_CON0, NULL),
+			APLL_LOCK, APLL_CON0, exynos4x12_apll_rates),
 	[mpll] = PLL(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
 			E4X12_MPLL_LOCK, E4X12_MPLL_CON0, NULL),
 	[epll] = PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll",
-			EPLL_LOCK, EPLL_CON0, NULL),
+			EPLL_LOCK, EPLL_CON0, exynos4x12_epll_rates),
 	[vpll] = PLL(pll_36xx, CLK_FOUT_VPLL, "fout_vpll", "fin_pll",
-			VPLL_LOCK, VPLL_CON0, NULL),
+			VPLL_LOCK, VPLL_CON0, exynos4x12_vpll_rates),
 };
 
 static void __init exynos4_core_down_clock(enum exynos4_soc soc)
@@ -1407,29 +1407,9 @@ static void __init exynos4_clk_init(struct device_node *np,
 		samsung_clk_register_mux(ctx, exynos4210_mux_early,
 					ARRAY_SIZE(exynos4210_mux_early));
 
-		if (_get_rate("fin_pll") == 24000000) {
-			exynos4210_plls[apll].rate_table =
-							exynos4210_apll_rates;
-			exynos4210_plls[epll].rate_table =
-							exynos4210_epll_rates;
-		}
-
-		if (_get_rate("mout_vpllsrc") == 24000000)
-			exynos4210_plls[vpll].rate_table =
-							exynos4210_vpll_rates;
-
 		samsung_clk_register_pll(ctx, exynos4210_plls,
 					ARRAY_SIZE(exynos4210_plls), reg_base);
 	} else {
-		if (_get_rate("fin_pll") == 24000000) {
-			exynos4x12_plls[apll].rate_table =
-							exynos4x12_apll_rates;
-			exynos4x12_plls[epll].rate_table =
-							exynos4x12_epll_rates;
-			exynos4x12_plls[vpll].rate_table =
-							exynos4x12_vpll_rates;
-		}
-
 		samsung_clk_register_pll(ctx, exynos4x12_plls,
 					ARRAY_SIZE(exynos4x12_plls), reg_base);
 	}
diff --git a/drivers/clk/samsung/clk-exynos5250.c b/drivers/clk/samsung/clk-exynos5250.c
index 70ec3d2..af3a660 100644
--- a/drivers/clk/samsung/clk-exynos5250.c
+++ b/drivers/clk/samsung/clk-exynos5250.c
@@ -688,52 +688,50 @@ static struct samsung_gate_clock exynos5250_gate_clks[] __initdata = {
 };
 
 static struct samsung_pll_rate_table vpll_24mhz_tbl[] __initdata = {
-	/* sorted in descending order */
 	/* PLL_36XX_RATE(rate, m, p, s, k) */
-	PLL_36XX_RATE(266000000, 266, 3, 3, 0),
+	PLL_36XX_RATE(266000000, 24000000, 266, 3, 3, 0),
 	/* Not in UM, but need for eDP on snow */
-	PLL_36XX_RATE(70500000, 94, 2, 4, 0),
+	PLL_36XX_RATE( 70500000, 24000000,  94, 2, 4, 0),
 	{ },
 };
 
 static struct samsung_pll_rate_table epll_24mhz_tbl[] __initdata = {
-	/* sorted in descending order */
 	/* PLL_36XX_RATE(rate, m, p, s, k) */
-	PLL_36XX_RATE(192000000, 64, 2, 2, 0),
-	PLL_36XX_RATE(180633600, 90, 3, 2, 20762),
-	PLL_36XX_RATE(180000000, 90, 3, 2, 0),
-	PLL_36XX_RATE(73728000, 98, 2, 4, 19923),
-	PLL_36XX_RATE(67737600, 90, 2, 4, 20762),
-	PLL_36XX_RATE(49152000, 98, 3, 4, 19923),
-	PLL_36XX_RATE(45158400, 90, 3, 4, 20762),
-	PLL_36XX_RATE(32768000, 131, 3, 5, 4719),
+	PLL_36XX_RATE(192000000, 24000000,  64, 2, 2,     0),
+	PLL_36XX_RATE(180633600, 24000000,  90, 3, 2, 20762),
+	PLL_36XX_RATE(180000000, 24000000,  90, 3, 2,     0),
+	PLL_36XX_RATE( 73728000, 24000000,  98, 2, 4, 19923),
+	PLL_36XX_RATE( 67737600, 24000000,  90, 2, 4, 20762),
+	PLL_36XX_RATE( 49152000, 24000000,  98, 3, 4, 19923),
+	PLL_36XX_RATE( 45158400, 24000000,  90, 3, 4, 20762),
+	PLL_36XX_RATE( 32768000, 24000000, 131, 3, 5,  4719),
 	{ },
 };
 
 static struct samsung_pll_rate_table apll_24mhz_tbl[] __initdata = {
-	/* sorted in descending order */
 	/* PLL_35XX_RATE(rate, m, p, s) */
-	PLL_35XX_RATE(1700000000, 425, 6, 0),
-	PLL_35XX_RATE(1600000000, 200, 3, 0),
-	PLL_35XX_RATE(1500000000, 250, 4, 0),
-	PLL_35XX_RATE(1400000000, 175, 3, 0),
-	PLL_35XX_RATE(1300000000, 325, 6, 0),
-	PLL_35XX_RATE(1200000000, 200, 4, 0),
-	PLL_35XX_RATE(1100000000, 275, 6, 0),
-	PLL_35XX_RATE(1000000000, 125, 3, 0),
-	PLL_35XX_RATE(900000000, 150, 4, 0),
-	PLL_35XX_RATE(800000000, 100, 3, 0),
-	PLL_35XX_RATE(700000000, 175, 3, 1),
-	PLL_35XX_RATE(600000000, 200, 4, 1),
-	PLL_35XX_RATE(500000000, 125, 3, 1),
-	PLL_35XX_RATE(400000000, 100, 3, 1),
-	PLL_35XX_RATE(300000000, 200, 4, 2),
-	PLL_35XX_RATE(200000000, 100, 3, 2),
+	PLL_35XX_RATE(1700000000, 24000000, 425, 6, 0),
+	PLL_35XX_RATE(1600000000, 24000000, 200, 3, 0),
+	PLL_35XX_RATE(1500000000, 24000000, 250, 4, 0),
+	PLL_35XX_RATE(1400000000, 24000000, 175, 3, 0),
+	PLL_35XX_RATE(1300000000, 24000000, 325, 6, 0),
+	PLL_35XX_RATE(1200000000, 24000000, 200, 4, 0),
+	PLL_35XX_RATE(1100000000, 24000000, 275, 6, 0),
+	PLL_35XX_RATE(1000000000, 24000000, 125, 3, 0),
+	PLL_35XX_RATE( 900000000, 24000000, 150, 4, 0),
+	PLL_35XX_RATE( 800000000, 24000000, 100, 3, 0),
+	PLL_35XX_RATE( 700000000, 24000000, 175, 3, 1),
+	PLL_35XX_RATE( 600000000, 24000000, 200, 4, 1),
+	PLL_35XX_RATE( 500000000, 24000000, 125, 3, 1),
+	PLL_35XX_RATE( 400000000, 24000000, 100, 3, 1),
+	PLL_35XX_RATE( 300000000, 24000000, 200, 4, 2),
+	PLL_35XX_RATE( 200000000, 24000000, 100, 3, 2),
+	{ },
 };
 
 static struct samsung_pll_clock exynos5250_plls[nr_plls] __initdata = {
 	[apll] = PLL_A(pll_35xx, CLK_FOUT_APLL, "fout_apll", "fin_pll",
-		APLL_LOCK, APLL_CON0, "fout_apll", NULL),
+		APLL_LOCK, APLL_CON0, "fout_apll", apll_24mhz_tbl),
 	[mpll] = PLL_A(pll_35xx, CLK_FOUT_MPLL, "fout_mpll", "fin_pll",
 		MPLL_LOCK, MPLL_CON0, "fout_mpll", NULL),
 	[bpll] = PLL(pll_35xx, CLK_FOUT_BPLL, "fout_bpll", "fin_pll", BPLL_LOCK,
@@ -743,9 +741,9 @@ static struct samsung_pll_clock exynos5250_plls[nr_plls] __initdata = {
 	[cpll] = PLL(pll_35xx, CLK_FOUT_CPLL, "fout_cpll", "fin_pll", CPLL_LOCK,
 		CPLL_CON0, NULL),
 	[epll] = PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll", EPLL_LOCK,
-		EPLL_CON0, NULL),
+		EPLL_CON0, epll_24mhz_tbl),
 	[vpll] = PLL(pll_36xx, CLK_FOUT_VPLL, "fout_vpll", "mout_vpllsrc",
-		VPLL_LOCK, VPLL_CON0, NULL),
+		VPLL_LOCK, VPLL_CON0, vpll_24mhz_tbl),
 };
 
 static const struct of_device_id ext_clk_match[] __initconst = {
@@ -776,14 +774,6 @@ static void __init exynos5250_clk_init(struct device_node *np)
 	samsung_clk_register_mux(ctx, exynos5250_pll_pmux_clks,
 				ARRAY_SIZE(exynos5250_pll_pmux_clks));
 
-	if (_get_rate("fin_pll") == 24 * MHZ) {
-		exynos5250_plls[epll].rate_table = epll_24mhz_tbl;
-		exynos5250_plls[apll].rate_table = apll_24mhz_tbl;
-	}
-
-	if (_get_rate("mout_vpllsrc") == 24 * MHZ)
-		exynos5250_plls[vpll].rate_table =  vpll_24mhz_tbl;
-
 	samsung_clk_register_pll(ctx, exynos5250_plls,
 			ARRAY_SIZE(exynos5250_plls),
 			reg_base);
diff --git a/drivers/clk/samsung/clk-exynos5260.c b/drivers/clk/samsung/clk-exynos5260.c
index ce3de97..0a9016a 100644
--- a/drivers/clk/samsung/clk-exynos5260.c
+++ b/drivers/clk/samsung/clk-exynos5260.c
@@ -60,57 +60,57 @@ struct exynos5260_cmu_info {
  * DISP_PLL, EGL_PLL, KFC_PLL, MEM_PLL, BUS_PLL, MEDIA_PLL, G3D_PLL.
  */
 static struct samsung_pll_rate_table pll2550_24mhz_tbl[] __initdata = {
-	PLL_35XX_RATE(1700000000, 425, 6, 0),
-	PLL_35XX_RATE(1600000000, 200, 3, 0),
-	PLL_35XX_RATE(1500000000, 250, 4, 0),
-	PLL_35XX_RATE(1400000000, 175, 3, 0),
-	PLL_35XX_RATE(1300000000, 325, 6, 0),
-	PLL_35XX_RATE(1200000000, 400, 4, 1),
-	PLL_35XX_RATE(1100000000, 275, 3, 1),
-	PLL_35XX_RATE(1000000000, 250, 3, 1),
-	PLL_35XX_RATE(933000000, 311, 4, 1),
-	PLL_35XX_RATE(900000000, 300, 4, 1),
-	PLL_35XX_RATE(800000000, 200, 3, 1),
-	PLL_35XX_RATE(733000000, 733, 12, 1),
-	PLL_35XX_RATE(700000000, 175, 3, 1),
-	PLL_35XX_RATE(667000000, 667, 12, 1),
-	PLL_35XX_RATE(633000000, 211, 4, 1),
-	PLL_35XX_RATE(620000000, 310, 3, 2),
-	PLL_35XX_RATE(600000000, 400, 4, 2),
-	PLL_35XX_RATE(543000000, 362, 4, 2),
-	PLL_35XX_RATE(533000000, 533, 6, 2),
-	PLL_35XX_RATE(500000000, 250, 3, 2),
-	PLL_35XX_RATE(450000000, 300, 4, 2),
-	PLL_35XX_RATE(400000000, 200, 3, 2),
-	PLL_35XX_RATE(350000000, 175, 3, 2),
-	PLL_35XX_RATE(300000000, 400, 4, 3),
-	PLL_35XX_RATE(266000000, 266, 3, 3),
-	PLL_35XX_RATE(200000000, 200, 3, 3),
-	PLL_35XX_RATE(160000000, 160, 3, 3),
+	PLL_35XX_RATE(1700000000, 24000000, 425,  6, 0),
+	PLL_35XX_RATE(1600000000, 24000000, 200,  3, 0),
+	PLL_35XX_RATE(1500000000, 24000000, 250,  4, 0),
+	PLL_35XX_RATE(1400000000, 24000000, 175,  3, 0),
+	PLL_35XX_RATE(1300000000, 24000000, 325,  6, 0),
+	PLL_35XX_RATE(1200000000, 24000000, 400,  4, 1),
+	PLL_35XX_RATE(1100000000, 24000000, 275,  3, 1),
+	PLL_35XX_RATE(1000000000, 24000000, 250,  3, 1),
+	PLL_35XX_RATE( 933000000, 24000000, 311,  4, 1),
+	PLL_35XX_RATE( 900000000, 24000000, 300,  4, 1),
+	PLL_35XX_RATE( 800000000, 24000000, 200,  3, 1),
+	PLL_35XX_RATE( 733000000, 24000000, 733, 12, 1),
+	PLL_35XX_RATE( 700000000, 24000000, 175,  3, 1),
+	PLL_35XX_RATE( 667000000, 24000000, 667, 12, 1),
+	PLL_35XX_RATE( 633000000, 24000000, 211,  4, 1),
+	PLL_35XX_RATE( 620000000, 24000000, 310,  3, 2),
+	PLL_35XX_RATE( 600000000, 24000000, 400,  4, 2),
+	PLL_35XX_RATE( 543000000, 24000000, 362,  4, 2),
+	PLL_35XX_RATE( 533000000, 24000000, 533,  6, 2),
+	PLL_35XX_RATE( 500000000, 24000000, 250,  3, 2),
+	PLL_35XX_RATE( 450000000, 24000000, 300,  4, 2),
+	PLL_35XX_RATE( 400000000, 24000000, 200,  3, 2),
+	PLL_35XX_RATE( 350000000, 24000000, 175,  3, 2),
+	PLL_35XX_RATE( 300000000, 24000000, 400,  4, 3),
+	PLL_35XX_RATE( 266000000, 24000000, 266,  3, 3),
+	PLL_35XX_RATE( 200000000, 24000000, 200,  3, 3),
+	PLL_35XX_RATE( 160000000, 24000000, 160,  3, 3),
 };
 
 /*
  * Applicable for 2650 Type PLL for AUD_PLL.
  */
 static struct samsung_pll_rate_table pll2650_24mhz_tbl[] __initdata = {
-	PLL_36XX_RATE(1600000000, 200, 3, 0, 0),
-	PLL_36XX_RATE(1200000000, 100, 2, 0, 0),
-	PLL_36XX_RATE(1000000000, 250, 3, 1, 0),
-	PLL_36XX_RATE(800000000, 200, 3, 1, 0),
-	PLL_36XX_RATE(600000000, 100, 2, 1, 0),
-	PLL_36XX_RATE(532000000, 266, 3, 2, 0),
-	PLL_36XX_RATE(480000000, 160, 2, 2, 0),
-	PLL_36XX_RATE(432000000, 144, 2, 2, 0),
-	PLL_36XX_RATE(400000000, 200, 3, 2, 0),
-	PLL_36XX_RATE(394073130, 459, 7, 2, 49282),
-	PLL_36XX_RATE(333000000, 111, 2, 2, 0),
-	PLL_36XX_RATE(300000000, 100, 2, 2, 0),
-	PLL_36XX_RATE(266000000, 266, 3, 3, 0),
-	PLL_36XX_RATE(200000000, 200, 3, 3, 0),
-	PLL_36XX_RATE(166000000, 166, 3, 3, 0),
-	PLL_36XX_RATE(133000000, 266, 3, 4, 0),
-	PLL_36XX_RATE(100000000, 200, 3, 4, 0),
-	PLL_36XX_RATE(66000000, 176, 2, 5, 0),
+	PLL_36XX_RATE(1600000000, 24000000, 200, 3, 0, 0),
+	PLL_36XX_RATE(1200000000, 24000000, 100, 2, 0, 0),
+	PLL_36XX_RATE(1000000000, 24000000, 250, 3, 1, 0),
+	PLL_36XX_RATE( 800000000, 24000000, 200, 3, 1, 0),
+	PLL_36XX_RATE( 600000000, 24000000, 100, 2, 1, 0),
+	PLL_36XX_RATE( 532000000, 24000000, 266, 3, 2, 0),
+	PLL_36XX_RATE( 480000000, 24000000, 160, 2, 2, 0),
+	PLL_36XX_RATE( 432000000, 24000000, 144, 2, 2, 0),
+	PLL_36XX_RATE( 400000000, 24000000, 200, 3, 2, 0),
+	PLL_36XX_RATE( 394073130, 24000000, 459, 7, 2, 49282),
+	PLL_36XX_RATE( 333000000, 24000000, 111, 2, 2, 0),
+	PLL_36XX_RATE( 300000000, 24000000, 100, 2, 2, 0),
+	PLL_36XX_RATE( 266000000, 24000000, 266, 3, 3, 0),
+	PLL_36XX_RATE( 200000000, 24000000, 200, 3, 3, 0),
+	PLL_36XX_RATE( 166000000, 24000000, 166, 3, 3, 0),
+	PLL_36XX_RATE( 133000000, 24000000, 266, 3, 4, 0),
+	PLL_36XX_RATE( 100000000, 24000000, 200, 3, 4, 0),
+	PLL_36XX_RATE(  66000000, 24000000, 176, 2, 5, 0),
 };
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index bc772f8..87e9c11 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -1197,30 +1197,31 @@ static struct samsung_gate_clock exynos5x_gate_clks[] __initdata = {
 };
 
 static const struct samsung_pll_rate_table exynos5420_pll2550x_24mhz_tbl[] = {
-	PLL_35XX_RATE(2000000000, 250, 3, 0),
-	PLL_35XX_RATE(1900000000, 475, 6, 0),
-	PLL_35XX_RATE(1800000000, 225, 3, 0),
-	PLL_35XX_RATE(1700000000, 425, 6, 0),
-	PLL_35XX_RATE(1600000000, 200, 3, 0),
-	PLL_35XX_RATE(1500000000, 250, 4, 0),
-	PLL_35XX_RATE(1400000000, 175, 3, 0),
-	PLL_35XX_RATE(1300000000, 325, 6, 0),
-	PLL_35XX_RATE(1200000000, 200, 2, 1),
-	PLL_35XX_RATE(1100000000, 275, 3, 1),
-	PLL_35XX_RATE(1000000000, 250, 3, 1),
-	PLL_35XX_RATE(900000000,  150, 2, 1),
-	PLL_35XX_RATE(800000000,  200, 3, 1),
-	PLL_35XX_RATE(700000000,  175, 3, 1),
-	PLL_35XX_RATE(600000000,  200, 2, 2),
-	PLL_35XX_RATE(500000000,  250, 3, 2),
-	PLL_35XX_RATE(400000000,  200, 3, 2),
-	PLL_35XX_RATE(300000000,  200, 2, 3),
-	PLL_35XX_RATE(200000000,  200, 3, 3),
+	PLL_35XX_RATE(2000000000, 24000000, 250, 3, 0),
+	PLL_35XX_RATE(1900000000, 24000000, 475, 6, 0),
+	PLL_35XX_RATE(1800000000, 24000000, 225, 3, 0),
+	PLL_35XX_RATE(1700000000, 24000000, 425, 6, 0),
+	PLL_35XX_RATE(1600000000, 24000000, 200, 3, 0),
+	PLL_35XX_RATE(1500000000, 24000000, 250, 4, 0),
+	PLL_35XX_RATE(1400000000, 24000000, 175, 3, 0),
+	PLL_35XX_RATE(1300000000, 24000000, 325, 6, 0),
+	PLL_35XX_RATE(1200000000, 24000000, 200, 2, 1),
+	PLL_35XX_RATE(1100000000, 24000000, 275, 3, 1),
+	PLL_35XX_RATE(1000000000, 24000000, 250, 3, 1),
+	PLL_35XX_RATE( 900000000, 24000000, 150, 2, 1),
+	PLL_35XX_RATE( 800000000, 24000000, 200, 3, 1),
+	PLL_35XX_RATE( 700000000, 24000000, 175, 3, 1),
+	PLL_35XX_RATE( 600000000, 24000000, 200, 2, 2),
+	PLL_35XX_RATE( 500000000, 24000000, 250, 3, 2),
+	PLL_35XX_RATE( 400000000, 24000000, 200, 3, 2),
+	PLL_35XX_RATE( 300000000, 24000000, 200, 2, 3),
+	PLL_35XX_RATE( 200000000, 24000000, 200, 3, 3),
+	{ },
 };
 
 static struct samsung_pll_clock exynos5x_plls[nr_plls] __initdata = {
 	[apll] = PLL(pll_2550, CLK_FOUT_APLL, "fout_apll", "fin_pll", APLL_LOCK,
-		APLL_CON0, NULL),
+		APLL_CON0, exynos5420_pll2550x_24mhz_tbl),
 	[cpll] = PLL(pll_2550, CLK_FOUT_CPLL, "fout_cpll", "fin_pll", CPLL_LOCK,
 		CPLL_CON0, NULL),
 	[dpll] = PLL(pll_2550, CLK_FOUT_DPLL, "fout_dpll", "fin_pll", DPLL_LOCK,
@@ -1240,7 +1241,7 @@ static struct samsung_pll_clock exynos5x_plls[nr_plls] __initdata = {
 	[bpll] = PLL(pll_2550, CLK_FOUT_BPLL, "fout_bpll", "fin_pll", BPLL_LOCK,
 		BPLL_CON0, NULL),
 	[kpll] = PLL(pll_2550, CLK_FOUT_KPLL, "fout_kpll", "fin_pll", KPLL_LOCK,
-		KPLL_CON0, NULL),
+		KPLL_CON0, exynos5420_pll2550x_24mhz_tbl),
 };
 
 static const struct of_device_id ext_clk_match[] __initconst = {
@@ -1272,11 +1273,6 @@ static void __init exynos5x_clk_init(struct device_node *np,
 			ARRAY_SIZE(exynos5x_fixed_rate_ext_clks),
 			ext_clk_match);
 
-	if (_get_rate("fin_pll") == 24 * MHZ) {
-		exynos5x_plls[apll].rate_table = exynos5420_pll2550x_24mhz_tbl;
-		exynos5x_plls[kpll].rate_table = exynos5420_pll2550x_24mhz_tbl;
-	}
-
 	samsung_clk_register_pll(ctx, exynos5x_plls, ARRAY_SIZE(exynos5x_plls),
 					reg_base);
 	samsung_clk_register_fixed_rate(ctx, exynos5x_fixed_rate_clks,
diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index b07fad2..fc1e387 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/hrtimer.h>
 #include <linux/delay.h>
+#include <linux/sort.h>
 #include "clk.h"
 #include "clk-pll.h"
 
@@ -29,13 +30,17 @@ struct samsung_clk_pll {
 #define to_clk_pll(_hw) container_of(_hw, struct samsung_clk_pll, hw)
 
 static const struct samsung_pll_rate_table *samsung_get_pll_settings(
-				struct samsung_clk_pll *pll, unsigned long rate)
+				struct samsung_clk_pll *pll, unsigned long rate,
+				unsigned long prate)
 {
-	const struct samsung_pll_rate_table  *rate_table = pll->rate_table;
+	const struct samsung_pll_rate_table *rate_table = pll->rate_table;
 	int i;
 
 	for (i = 0; i < pll->rate_count; i++) {
-		if (rate == rate_table[i].rate)
+		if (rate_table[i].brate != prate)
+			continue;
+
+		if (rate == rate_table[i].orate)
 			return &rate_table[i];
 	}
 
@@ -47,16 +52,21 @@ static long samsung_pll_round_rate(struct clk_hw *hw,
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	const struct samsung_pll_rate_table *rate_table = pll->rate_table;
+	long min_rate = 0;
 	int i;
 
-	/* Assumming rate_table is in descending order */
+	/* Since rate_table is in descending order */
 	for (i = 0; i < pll->rate_count; i++) {
-		if (drate >= rate_table[i].rate)
-			return rate_table[i].rate;
+		if (rate_table[i].brate != *prate)
+			continue;
+
+		min_rate = rate_table[i].orate;
+		if (drate >= min_rate)
+			return min_rate;
 	}
 
 	/* return minimum supported value */
-	return rate_table[i - 1].rate;
+	return min_rate;
 }
 
 /*
@@ -70,22 +80,29 @@ static long samsung_pll_round_rate(struct clk_hw *hw,
 #define PLL2126_PDIV_SHIFT	(8)
 #define PLL2126_SDIV_SHIFT	(0)
 
+static unsigned long _samsung_pll2126_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= (mdiv + 8);
+	do_div(fvco, (pdiv + 2) << sdiv);
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll2126_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 pll_con, mdiv, pdiv, sdiv;
-	u64 fvco = parent_rate;
 
 	pll_con = __raw_readl(pll->con_reg);
 	mdiv = (pll_con >> PLL2126_MDIV_SHIFT) & PLL2126_MDIV_MASK;
 	pdiv = (pll_con >> PLL2126_PDIV_SHIFT) & PLL2126_PDIV_MASK;
 	sdiv = (pll_con >> PLL2126_SDIV_SHIFT) & PLL2126_SDIV_MASK;
 
-	fvco *= (mdiv + 8);
-	do_div(fvco, (pdiv + 2) << sdiv);
-
-	return (unsigned long)fvco;
+	return _samsung_pll2126_rate(parent_rate, mdiv, pdiv, sdiv);
 }
 
 static const struct clk_ops samsung_pll2126_clk_ops = {
@@ -103,22 +120,29 @@ static const struct clk_ops samsung_pll2126_clk_ops = {
 #define PLL3000_PDIV_SHIFT	(8)
 #define PLL3000_SDIV_SHIFT	(0)
 
+static unsigned long _samsung_pll3000_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= (2 * (mdiv + 8));
+	do_div(fvco, pdiv << sdiv);
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll3000_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 pll_con, mdiv, pdiv, sdiv;
-	u64 fvco = parent_rate;
 
 	pll_con = __raw_readl(pll->con_reg);
 	mdiv = (pll_con >> PLL3000_MDIV_SHIFT) & PLL3000_MDIV_MASK;
 	pdiv = (pll_con >> PLL3000_PDIV_SHIFT) & PLL3000_PDIV_MASK;
 	sdiv = (pll_con >> PLL3000_SDIV_SHIFT) & PLL3000_SDIV_MASK;
 
-	fvco *= (2 * (mdiv + 8));
-	do_div(fvco, pdiv << sdiv);
-
-	return (unsigned long)fvco;
+	return _samsung_pll3000_rate(parent_rate, mdiv, pdiv, sdiv);
 }
 
 static const struct clk_ops samsung_pll3000_clk_ops = {
@@ -131,31 +155,38 @@ static const struct clk_ops samsung_pll3000_clk_ops = {
 /* Maximum lock time can be 270 * PDIV cycles */
 #define PLL35XX_LOCK_FACTOR	(270)
 
-#define PLL35XX_MDIV_MASK       (0x3FF)
-#define PLL35XX_PDIV_MASK       (0x3F)
-#define PLL35XX_SDIV_MASK       (0x7)
+#define PLL35XX_MDIV_MASK	(0x3FF)
+#define PLL35XX_PDIV_MASK	(0x3F)
+#define PLL35XX_SDIV_MASK	(0x7)
 #define PLL35XX_LOCK_STAT_MASK	(0x1)
-#define PLL35XX_MDIV_SHIFT      (16)
-#define PLL35XX_PDIV_SHIFT      (8)
-#define PLL35XX_SDIV_SHIFT      (0)
+#define PLL35XX_MDIV_SHIFT	(16)
+#define PLL35XX_PDIV_SHIFT	(8)
+#define PLL35XX_SDIV_SHIFT	(0)
 #define PLL35XX_LOCK_STAT_SHIFT	(29)
 
+static unsigned long _samsung_pll35xx_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= mdiv;
+	do_div(fvco, (pdiv << sdiv));
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll35xx_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 mdiv, pdiv, sdiv, pll_con;
-	u64 fvco = parent_rate;
 
 	pll_con = __raw_readl(pll->con_reg);
 	mdiv = (pll_con >> PLL35XX_MDIV_SHIFT) & PLL35XX_MDIV_MASK;
 	pdiv = (pll_con >> PLL35XX_PDIV_SHIFT) & PLL35XX_PDIV_MASK;
 	sdiv = (pll_con >> PLL35XX_SDIV_SHIFT) & PLL35XX_SDIV_MASK;
 
-	fvco *= mdiv;
-	do_div(fvco, (pdiv << sdiv));
-
-	return (unsigned long)fvco;
+	return _samsung_pll35xx_rate(parent_rate, mdiv, pdiv, sdiv);
 }
 
 static inline bool samsung_pll35xx_mp_change(
@@ -177,7 +208,7 @@ static int samsung_pll35xx_set_rate(struct clk_hw *hw, unsigned long drate,
 	u32 tmp;
 
 	/* Get required rate settings from table */
-	rate = samsung_get_pll_settings(pll, drate);
+	rate = samsung_get_pll_settings(pll, drate, prate);
 	if (!rate) {
 		pr_err("%s: Invalid rate : %lu for pll clk %s\n", __func__,
 			drate, __clk_get_name(hw->clk));
@@ -243,13 +274,24 @@ static const struct clk_ops samsung_pll35xx_clk_min_ops = {
 #define PLL36XX_KDIV_SHIFT	(0)
 #define PLL36XX_LOCK_STAT_SHIFT	(29)
 
+static unsigned long _samsung_pll36xx_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv, s16 kdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= (mdiv << 16) + kdiv;
+	do_div(fvco, (pdiv << sdiv));
+	fvco >>= 16;
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll36xx_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 mdiv, pdiv, sdiv, pll_con0, pll_con1;
 	s16 kdiv;
-	u64 fvco = parent_rate;
 
 	pll_con0 = __raw_readl(pll->con_reg);
 	pll_con1 = __raw_readl(pll->con_reg + 4);
@@ -258,11 +300,7 @@ static unsigned long samsung_pll36xx_recalc_rate(struct clk_hw *hw,
 	sdiv = (pll_con0 >> PLL36XX_SDIV_SHIFT) & PLL36XX_SDIV_MASK;
 	kdiv = (s16)(pll_con1 & PLL36XX_KDIV_MASK);
 
-	fvco *= (mdiv << 16) + kdiv;
-	do_div(fvco, (pdiv << sdiv));
-	fvco >>= 16;
-
-	return (unsigned long)fvco;
+	return _samsung_pll36xx_rate(parent_rate, mdiv, pdiv, sdiv, kdiv);
 }
 
 static inline bool samsung_pll36xx_mpk_change(
@@ -285,7 +323,7 @@ static int samsung_pll36xx_set_rate(struct clk_hw *hw, unsigned long drate,
 	u32 tmp, pll_con0, pll_con1;
 	const struct samsung_pll_rate_table *rate;
 
-	rate = samsung_get_pll_settings(pll, drate);
+	rate = samsung_get_pll_settings(pll, drate, parent_rate);
 	if (!rate) {
 		pr_err("%s: Invalid rate : %lu for pll clk %s\n", __func__,
 			drate, __clk_get_name(hw->clk));
@@ -357,25 +395,33 @@ static const struct clk_ops samsung_pll36xx_clk_min_ops = {
 #define PLL45XX_ENABLE		BIT(31)
 #define PLL45XX_LOCKED		BIT(29)
 
+static unsigned long _samsung_pll45xx_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv,
+					enum samsung_pll_type type)
+{
+	u64 fvco = parent_rate;
+
+	if (type == pll_4508)
+		sdiv = sdiv - 1;
+	fvco *= mdiv;
+	do_div(fvco, (pdiv << sdiv));
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll45xx_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 mdiv, pdiv, sdiv, pll_con;
-	u64 fvco = parent_rate;
 
 	pll_con = __raw_readl(pll->con_reg);
 	mdiv = (pll_con >> PLL45XX_MDIV_SHIFT) & PLL45XX_MDIV_MASK;
 	pdiv = (pll_con >> PLL45XX_PDIV_SHIFT) & PLL45XX_PDIV_MASK;
 	sdiv = (pll_con >> PLL45XX_SDIV_SHIFT) & PLL45XX_SDIV_MASK;
 
-	if (pll->type == pll_4508)
-		sdiv = sdiv - 1;
-
-	fvco *= mdiv;
-	do_div(fvco, (pdiv << sdiv));
-
-	return (unsigned long)fvco;
+	return _samsung_pll45xx_rate(parent_rate, mdiv, pdiv, sdiv,
+				pll->type);
 }
 
 static bool samsung_pll45xx_mp_change(u32 pll_con0, u32 pll_con1,
@@ -400,7 +446,7 @@ static int samsung_pll45xx_set_rate(struct clk_hw *hw, unsigned long drate,
 	ktime_t start;
 
 	/* Get required rate settings from table */
-	rate = samsung_get_pll_settings(pll, drate);
+	rate = samsung_get_pll_settings(pll, drate, prate);
 	if (!rate) {
 		pr_err("%s: Invalid rate : %lu for pll clk %s\n", __func__,
 			drate, __clk_get_name(hw->clk));
@@ -502,12 +548,26 @@ static const struct clk_ops samsung_pll45xx_clk_min_ops = {
 #define PLL46XX_LOCKED		BIT(29)
 #define PLL46XX_VSEL		BIT(27)
 
+static unsigned long _samsung_pll46xx_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv, u32 kdiv,
+					enum samsung_pll_type type)
+{
+	u64 fvco = parent_rate;
+	u32 shift;
+
+	shift = type == pll_4600 ? 16 : 10;
+	fvco *= (mdiv << shift) + kdiv;
+	do_div(fvco, (pdiv << sdiv));
+	fvco >>= shift;
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll46xx_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
-	u32 mdiv, pdiv, sdiv, kdiv, pll_con0, pll_con1, shift;
-	u64 fvco = parent_rate;
+	u32 mdiv, pdiv, sdiv, kdiv, pll_con0, pll_con1;
 
 	pll_con0 = __raw_readl(pll->con_reg);
 	pll_con1 = __raw_readl(pll->con_reg + 4);
@@ -517,12 +577,8 @@ static unsigned long samsung_pll46xx_recalc_rate(struct clk_hw *hw,
 	kdiv = pll->type == pll_4650c ? pll_con1 & PLL4650C_KDIV_MASK :
 					pll_con1 & PLL46XX_KDIV_MASK;
 
-	shift = pll->type == pll_4600 ? 16 : 10;
-	fvco *= (mdiv << shift) + kdiv;
-	do_div(fvco, (pdiv << sdiv));
-	fvco >>= shift;
-
-	return (unsigned long)fvco;
+	return _samsung_pll46xx_rate(parent_rate, mdiv, pdiv, sdiv, kdiv,
+				pll->type);
 }
 
 static bool samsung_pll46xx_mpk_change(u32 pll_con0, u32 pll_con1,
@@ -547,7 +603,7 @@ static int samsung_pll46xx_set_rate(struct clk_hw *hw, unsigned long drate,
 	ktime_t start;
 
 	/* Get required rate settings from table */
-	rate = samsung_get_pll_settings(pll, drate);
+	rate = samsung_get_pll_settings(pll, drate, prate);
 	if (!rate) {
 		pr_err("%s: Invalid rate : %lu for pll clk %s\n", __func__,
 			drate, __clk_get_name(hw->clk));
@@ -636,12 +692,22 @@ static const struct clk_ops samsung_pll46xx_clk_min_ops = {
 #define PLL6552_PDIV_SHIFT_2416	5
 #define PLL6552_SDIV_SHIFT	0
 
+static unsigned long _samsung_pll6552_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= mdiv;
+	do_div(fvco, (pdiv << sdiv));
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll6552_recalc_rate(struct clk_hw *hw,
 						unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 mdiv, pdiv, sdiv, pll_con;
-	u64 fvco = parent_rate;
 
 	pll_con = __raw_readl(pll->con_reg);
 	if (pll->type == pll_6552_s3c2416) {
@@ -653,10 +719,7 @@ static unsigned long samsung_pll6552_recalc_rate(struct clk_hw *hw,
 	}
 	sdiv = (pll_con >> PLL6552_SDIV_SHIFT) & PLL6552_SDIV_MASK;
 
-	fvco *= mdiv;
-	do_div(fvco, (pdiv << sdiv));
-
-	return (unsigned long)fvco;
+	return _samsung_pll6552_rate(parent_rate, mdiv, pdiv, sdiv);
 }
 
 static const struct clk_ops samsung_pll6552_clk_ops = {
@@ -676,12 +739,23 @@ static const struct clk_ops samsung_pll6552_clk_ops = {
 #define PLL6553_SDIV_SHIFT	0
 #define PLL6553_KDIV_SHIFT	0
 
+static unsigned long _samsung_pll6553_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv, u32 kdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= (mdiv << 16) + kdiv;
+	do_div(fvco, (pdiv << sdiv));
+	fvco >>= 16;
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll6553_recalc_rate(struct clk_hw *hw,
 						unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 mdiv, pdiv, sdiv, kdiv, pll_con0, pll_con1;
-	u64 fvco = parent_rate;
 
 	pll_con0 = __raw_readl(pll->con_reg);
 	pll_con1 = __raw_readl(pll->con_reg + 0x4);
@@ -690,11 +764,7 @@ static unsigned long samsung_pll6553_recalc_rate(struct clk_hw *hw,
 	sdiv = (pll_con0 >> PLL6553_SDIV_SHIFT) & PLL6553_SDIV_MASK;
 	kdiv = (pll_con1 >> PLL6553_KDIV_SHIFT) & PLL6553_KDIV_MASK;
 
-	fvco *= (mdiv << 16) + kdiv;
-	do_div(fvco, (pdiv << sdiv));
-	fvco >>= 16;
-
-	return (unsigned long)fvco;
+	return _samsung_pll6553_rate(parent_rate, mdiv, pdiv, sdiv, kdiv);
 }
 
 static const struct clk_ops samsung_pll6553_clk_ops = {
@@ -714,22 +784,29 @@ static const struct clk_ops samsung_pll6553_clk_ops = {
 
 #define PLLS3C2410_ENABLE_REG_OFFSET	0x10
 
+static unsigned long _samsung_s3c2410_pll_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= (mdiv + 8);
+	do_div(fvco, (pdiv + 2) << sdiv);
+
+	return (unsigned int)fvco;
+}
+
 static unsigned long samsung_s3c2410_pll_recalc_rate(struct clk_hw *hw,
 					unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 pll_con, mdiv, pdiv, sdiv;
-	u64 fvco = parent_rate;
 
 	pll_con = __raw_readl(pll->con_reg);
 	mdiv = (pll_con >> PLLS3C2410_MDIV_SHIFT) & PLLS3C2410_MDIV_MASK;
 	pdiv = (pll_con >> PLLS3C2410_PDIV_SHIFT) & PLLS3C2410_PDIV_MASK;
 	sdiv = (pll_con >> PLLS3C2410_SDIV_SHIFT) & PLLS3C2410_SDIV_MASK;
 
-	fvco *= (mdiv + 8);
-	do_div(fvco, (pdiv + 2) << sdiv);
-
-	return (unsigned int)fvco;
+	return _samsung_s3c2410_pll_rate(parent_rate, mdiv, pdiv, sdiv);
 }
 
 static unsigned long samsung_s3c2440_mpll_recalc_rate(struct clk_hw *hw,
@@ -758,7 +835,7 @@ static int samsung_s3c2410_pll_set_rate(struct clk_hw *hw, unsigned long drate,
 	u32 tmp;
 
 	/* Get required rate settings from table */
-	rate = samsung_get_pll_settings(pll, drate);
+	rate = samsung_get_pll_settings(pll, drate, prate);
 	if (!rate) {
 		pr_err("%s: Invalid rate : %lu for pll clk %s\n", __func__,
 			drate, __clk_get_name(hw->clk));
@@ -963,22 +1040,29 @@ struct clk * __init samsung_clk_register_pll2550x(const char *name,
 #define PLL2550XX_S_SHIFT		0
 #define PLL2550XX_LOCK_STAT_SHIFT	21
 
+static unsigned long _samsung_pll2550xx_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= mdiv;
+	do_div(fvco, (pdiv << sdiv));
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll2550xx_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 mdiv, pdiv, sdiv, pll_con;
-	u64 fvco = parent_rate;
 
 	pll_con = __raw_readl(pll->con_reg);
 	mdiv = (pll_con >> PLL2550XX_M_SHIFT) & PLL2550XX_M_MASK;
 	pdiv = (pll_con >> PLL2550XX_P_SHIFT) & PLL2550XX_P_MASK;
 	sdiv = (pll_con >> PLL2550XX_S_SHIFT) & PLL2550XX_S_MASK;
 
-	fvco *= mdiv;
-	do_div(fvco, (pdiv << sdiv));
-
-	return (unsigned long)fvco;
+	return _samsung_pll2550xx_rate(parent_rate, mdiv, pdiv, sdiv);
 }
 
 static inline bool samsung_pll2550xx_mp_change(u32 mdiv, u32 pdiv, u32 pll_con)
@@ -999,7 +1083,7 @@ static int samsung_pll2550xx_set_rate(struct clk_hw *hw, unsigned long drate,
 	u32 tmp;
 
 	/* Get required rate settings from table */
-	rate = samsung_get_pll_settings(pll, drate);
+	rate = samsung_get_pll_settings(pll, drate, prate);
 	if (!rate) {
 		pr_err("%s: Invalid rate : %lu for pll clk %s\n", __func__,
 			drate, __clk_get_name(hw->clk));
@@ -1068,13 +1152,24 @@ static const struct clk_ops samsung_pll2550xx_clk_min_ops = {
 #define PLL2650XX_PLL_LOCKTIME_SHIFT	21
 #define PLL2650XX_PLL_FOUTMASK_SHIFT	31
 
+static unsigned long _samsung_pll2650xx_rate(unsigned long parent_rate,
+					u32 mdiv, u32 pdiv, u32 sdiv, s16 kdiv)
+{
+	u64 fvco = parent_rate;
+
+	fvco *= (mdiv << 16) + kdiv;
+	do_div(fvco, (pdiv << sdiv));
+	fvco >>= 16;
+
+	return (unsigned long)fvco;
+}
+
 static unsigned long samsung_pll2650xx_recalc_rate(struct clk_hw *hw,
 				unsigned long parent_rate)
 {
 	struct samsung_clk_pll *pll = to_clk_pll(hw);
 	u32 mdiv, pdiv, sdiv, pll_con0, pll_con2;
 	s16 kdiv;
-	u64 fvco = parent_rate;
 
 	pll_con0 = __raw_readl(pll->con_reg);
 	pll_con2 = __raw_readl(pll->con_reg + 8);
@@ -1083,11 +1178,7 @@ static unsigned long samsung_pll2650xx_recalc_rate(struct clk_hw *hw,
 	sdiv = (pll_con0 >> PLL2650XX_SDIV_SHIFT) & PLL2650XX_SDIV_MASK;
 	kdiv = (s16)(pll_con2 & PLL2650XX_KDIV_MASK);
 
-	fvco *= (mdiv << 16) + kdiv;
-	do_div(fvco, (pdiv << sdiv));
-	fvco >>= 16;
-
-	return (unsigned long)fvco;
+	return _samsung_pll2650xx_rate(parent_rate, mdiv, pdiv, sdiv, kdiv);
 }
 
 static int samsung_pll2650xx_set_rate(struct clk_hw *hw, unsigned long drate,
@@ -1097,7 +1188,7 @@ static int samsung_pll2650xx_set_rate(struct clk_hw *hw, unsigned long drate,
 	u32 tmp, pll_con0, pll_con2;
 	const struct samsung_pll_rate_table *rate;
 
-	rate = samsung_get_pll_settings(pll, drate);
+	rate = samsung_get_pll_settings(pll, drate, parent_rate);
 	if (!rate) {
 		pr_err("%s: Invalid rate : %lu for pll clk %s\n", __func__,
 			drate, __clk_get_name(hw->clk));
@@ -1144,6 +1235,121 @@ static const struct clk_ops samsung_pll2650xx_clk_min_ops = {
 	.recalc_rate = samsung_pll2650xx_recalc_rate,
 };
 
+static unsigned long __init
+_samsung_clk_rate_from_table(struct samsung_pll_rate_table *entry,
+				enum samsung_pll_type type)
+{
+	unsigned long parent_rate;
+	u32 pdiv, mdiv, sdiv;
+
+	parent_rate = (unsigned long) entry->brate;
+	pdiv = (u32) entry->pdiv;
+	mdiv = (u32) entry->mdiv;
+	sdiv = (u32) entry->sdiv;
+
+	switch (type) {
+	case pll_2126:
+		return _samsung_pll2126_rate(parent_rate, mdiv, pdiv, sdiv);
+	case pll_3000:
+		return _samsung_pll3000_rate(parent_rate, mdiv, pdiv, sdiv);
+	/* 35xx and 2550 are similar */
+	case pll_35xx:
+	case pll_2550:
+		return _samsung_pll35xx_rate(parent_rate, mdiv, pdiv, sdiv);
+	case pll_4500:
+	case pll_4502:
+	case pll_4508:
+		return _samsung_pll45xx_rate(parent_rate, mdiv, pdiv, sdiv,
+					type);
+	/* 36xx and 2650 are similar */
+	case pll_36xx:
+	case pll_2650:
+		return _samsung_pll36xx_rate(parent_rate, mdiv, pdiv, sdiv,
+					(s16) entry->kdiv);
+	case pll_6552:
+	case pll_6552_s3c2416:
+		return _samsung_pll6552_rate(parent_rate, mdiv, pdiv, sdiv);
+	case pll_6553:
+		return _samsung_pll6553_rate(parent_rate, mdiv, pdiv, sdiv,
+					(u32) entry->kdiv);
+	case pll_4600:
+	case pll_4650:
+	case pll_4650c:
+		return _samsung_pll46xx_rate(parent_rate, mdiv, pdiv, sdiv,
+					(u32) entry->kdiv, type);
+	case pll_s3c2410_mpll:
+	case pll_s3c2410_upll:
+	case pll_s3c2440_mpll:
+		return _samsung_s3c2410_pll_rate(parent_rate, mdiv, pdiv, sdiv);
+	case pll_2550xx:
+		return _samsung_pll2550xx_rate(parent_rate, mdiv, pdiv, sdiv);
+	case pll_2650xx:
+		return _samsung_pll2650xx_rate(parent_rate, mdiv, pdiv, sdiv,
+					(s16) entry->kdiv);
+	default:
+		pr_warn("%s: cannot compute rate for pll type %d\n",
+			__func__, type);
+		return 0;
+	}
+}
+
+/* used for sorting the pll rate table */
+static int __init _samsung_clk_cmp_rates(const void *p1, const void *p2)
+{
+	const struct samsung_pll_rate_table *e1 = p1;
+	const struct samsung_pll_rate_table *e2 = p2;
+
+	/* sorting in descending order */
+	if (e1->orate > e2->orate)
+		return -1;
+	else if (e1->orate == e2->orate)
+		return 0;
+	else
+		return 1;
+}
+
+static const struct samsung_pll_rate_table * __init
+_samsung_clk_copy_rate_table(struct samsung_pll_clock *pll_clk,
+			unsigned int *rate_count)
+{
+	struct samsung_pll_rate_table *tbl;
+	unsigned int i, len;
+
+	/* find count of rates in rate_table (at last entry, brate = 0) */
+	for (len = 0; pll_clk->rate_table[len].brate != 0; )
+		len++;
+
+	tbl = kmemdup(pll_clk->rate_table, len *
+			sizeof(struct samsung_pll_rate_table), GFP_KERNEL);
+	if (!tbl)
+		return NULL;
+
+	/* validate the entries in the table */
+	for (i = 0; i < len; i++) {
+		unsigned long orate;
+		orate = _samsung_clk_rate_from_table(&tbl[i], pll_clk->type);
+		if ((unsigned int) orate != tbl[i].orate) {
+			pr_warn("%s: invalid entry in table: out_rate=%u"
+				" base_rate=%u, replacing with out_rate=$u\n",
+				__func__, tbl[i].orate, tbl[i].brate);
+			tbl[i].orate = orate;
+		}
+	}
+
+	/* sort in descending order according to output_rate */
+	sort(tbl, len, sizeof(*tbl), &_samsung_clk_cmp_rates, NULL);
+
+	/* discard invalid entries */
+	while (len > 0)
+		if (tbl[len - 1].orate == 0)
+			len--;
+
+	if (rate_count)
+		*rate_count = len;
+
+	return tbl;
+}
+
 static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 				struct samsung_pll_clock *pll_clk,
 				void __iomem *base)
@@ -1151,7 +1357,7 @@ static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 	struct samsung_clk_pll *pll;
 	struct clk *clk;
 	struct clk_init_data init;
-	int ret, len;
+	int ret;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
 	if (!pll) {
@@ -1166,15 +1372,8 @@ static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 	init.num_parents = 1;
 
 	if (pll_clk->rate_table) {
-		/* find count of rates in rate_table */
-		for (len = 0; pll_clk->rate_table[len].rate != 0; )
-			len++;
-
-		pll->rate_count = len;
-		pll->rate_table = kmemdup(pll_clk->rate_table,
-					pll->rate_count *
-					sizeof(struct samsung_pll_rate_table),
-					GFP_KERNEL);
+		pll->rate_table = _samsung_clk_copy_rate_table(pll_clk,
+							&pll->rate_count);
 		WARN(!pll->rate_table,
 			"%s: could not allocate rate table for %s\n",
 			__func__, pll_clk->name);
diff --git a/drivers/clk/samsung/clk-pll.h b/drivers/clk/samsung/clk-pll.h
index c0ed4d4..a29159d 100644
--- a/drivers/clk/samsung/clk-pll.h
+++ b/drivers/clk/samsung/clk-pll.h
@@ -35,35 +35,39 @@ enum samsung_pll_type {
 	pll_2650xx,
 };
 
-#define PLL_35XX_RATE(_rate, _m, _p, _s)			\
+#define PLL_35XX_RATE(_orate, _brate, _m, _p, _s)		\
 	{							\
-		.rate	=	(_rate),				\
+		.orate	=	(_orate),			\
+		.brate	=	(_brate),			\
 		.mdiv	=	(_m),				\
 		.pdiv	=	(_p),				\
 		.sdiv	=	(_s),				\
 	}
 
-#define PLL_36XX_RATE(_rate, _m, _p, _s, _k)			\
+#define PLL_36XX_RATE(_orate, _brate, _m, _p, _s, _k)		\
 	{							\
-		.rate	=	(_rate),				\
+		.orate	=	(_orate),			\
+		.brate	=	(_brate),			\
 		.mdiv	=	(_m),				\
 		.pdiv	=	(_p),				\
 		.sdiv	=	(_s),				\
 		.kdiv	=	(_k),				\
 	}
 
-#define PLL_45XX_RATE(_rate, _m, _p, _s, _afc)			\
+#define PLL_45XX_RATE(_orate, _brate, _m, _p, _s, _afc)		\
 	{							\
-		.rate	=	(_rate),			\
+		.orate	=	(_orate),			\
+		.brate	=	(_brate),			\
 		.mdiv	=	(_m),				\
 		.pdiv	=	(_p),				\
 		.sdiv	=	(_s),				\
 		.afc	=	(_afc),				\
 	}
 
-#define PLL_4600_RATE(_rate, _m, _p, _s, _k, _vsel)		\
+#define PLL_4600_RATE(_orate, _brate, _m, _p, _s, _k, _vsel)	\
 	{							\
-		.rate	=	(_rate),			\
+		.orate	=	(_orate),			\
+		.brate	=	(_brate),			\
 		.mdiv	=	(_m),				\
 		.pdiv	=	(_p),				\
 		.sdiv	=	(_s),				\
@@ -71,9 +75,10 @@ enum samsung_pll_type {
 		.vsel	=	(_vsel),			\
 	}
 
-#define PLL_4650_RATE(_rate, _m, _p, _s, _k, _mfr, _mrr, _vsel)	\
+#define PLL_4650_RATE(_orate, _brate, _m, _p, _s, _k, _mfr, _mrr, _vsel) \
 	{							\
-		.rate	=	(_rate),			\
+		.orate	=	(_orate),			\
+		.brate	=	(_brate),			\
 		.mdiv	=	(_m),				\
 		.pdiv	=	(_p),				\
 		.sdiv	=	(_s),				\
@@ -83,10 +88,9 @@ enum samsung_pll_type {
 		.vsel	=	(_vsel),			\
 	}
 
-/* NOTE: Rate table should be kept sorted in descending order. */
-
 struct samsung_pll_rate_table {
-	unsigned int rate;
+	unsigned int orate;		/* output rate */
+	unsigned int brate;		/* the base rate */
 	unsigned int pdiv;
 	unsigned int mdiv;
 	unsigned int sdiv;
diff --git a/drivers/clk/samsung/clk-s3c2410.c b/drivers/clk/samsung/clk-s3c2410.c
index 5d2f034..4cff9a1 100644
--- a/drivers/clk/samsung/clk-s3c2410.c
+++ b/drivers/clk/samsung/clk-s3c2410.c
@@ -162,44 +162,43 @@ struct samsung_clock_alias s3c2410_common_aliases[] __initdata = {
 /* S3C2410 specific clocks */
 
 static struct samsung_pll_rate_table pll_s3c2410_12mhz_tbl[] __initdata = {
-	/* sorted in descending order */
 	/* 2410A extras */
-	PLL_35XX_RATE(270000000, 127, 1, 1),
-	PLL_35XX_RATE(268000000, 126, 1, 1),
-	PLL_35XX_RATE(266000000, 125, 1, 1),
-	PLL_35XX_RATE(226000000, 105, 1, 1),
-	PLL_35XX_RATE(210000000, 132, 2, 1),
+	PLL_35XX_RATE(270000000, 12000000, 127, 1, 1),
+	PLL_35XX_RATE(268000000, 12000000, 126, 1, 1),
+	PLL_35XX_RATE(266000000, 12000000, 125, 1, 1),
+	PLL_35XX_RATE(226000000, 12000000, 105, 1, 1),
+	PLL_35XX_RATE(210000000, 12000000, 132, 2, 1),
 	/* 2410 common */
-	PLL_35XX_RATE(203000000, 161, 3, 1),
-	PLL_35XX_RATE(192000000, 88, 1, 1),
-	PLL_35XX_RATE(186000000, 85, 1, 1),
-	PLL_35XX_RATE(180000000, 82, 1, 1),
-	PLL_35XX_RATE(170000000, 77, 1, 1),
-	PLL_35XX_RATE(158000000, 71, 1, 1),
-	PLL_35XX_RATE(152000000, 68, 1, 1),
-	PLL_35XX_RATE(147000000, 90, 2, 1),
-	PLL_35XX_RATE(135000000, 82, 2, 1),
-	PLL_35XX_RATE(124000000, 116, 1, 2),
-	PLL_35XX_RATE(118000000, 150, 2, 2),
-	PLL_35XX_RATE(113000000, 105, 1, 2),
-	PLL_35XX_RATE(101000000, 127, 2, 2),
-	PLL_35XX_RATE(90000000, 112, 2, 2),
-	PLL_35XX_RATE(85000000, 105, 2, 2),
-	PLL_35XX_RATE(79000000, 71, 1, 2),
-	PLL_35XX_RATE(68000000, 82, 2, 2),
-	PLL_35XX_RATE(56000000, 142, 2, 3),
-	PLL_35XX_RATE(48000000, 120, 2, 3),
-	PLL_35XX_RATE(51000000, 161, 3, 3),
-	PLL_35XX_RATE(45000000, 82, 1, 3),
-	PLL_35XX_RATE(34000000, 82, 2, 3),
+	PLL_35XX_RATE(203000000, 12000000, 161, 3, 1),
+	PLL_35XX_RATE(192000000, 12000000,  88, 1, 1),
+	PLL_35XX_RATE(186000000, 12000000,  85, 1, 1),
+	PLL_35XX_RATE(180000000, 12000000,  82, 1, 1),
+	PLL_35XX_RATE(170000000, 12000000,  77, 1, 1),
+	PLL_35XX_RATE(158000000, 12000000,  71, 1, 1),
+	PLL_35XX_RATE(152000000, 12000000,  68, 1, 1),
+	PLL_35XX_RATE(147000000, 12000000,  90, 2, 1),
+	PLL_35XX_RATE(135000000, 12000000,  82, 2, 1),
+	PLL_35XX_RATE(124000000, 12000000, 116, 1, 2),
+	PLL_35XX_RATE(118000000, 12000000, 150, 2, 2),
+	PLL_35XX_RATE(113000000, 12000000, 105, 1, 2),
+	PLL_35XX_RATE(101000000, 12000000, 127, 2, 2),
+	PLL_35XX_RATE(90000000,  12000000, 112, 2, 2),
+	PLL_35XX_RATE(85000000,  12000000, 105, 2, 2),
+	PLL_35XX_RATE(79000000,  12000000,  71, 1, 2),
+	PLL_35XX_RATE(68000000,  12000000,  82, 2, 2),
+	PLL_35XX_RATE(56000000,  12000000, 142, 2, 3),
+	PLL_35XX_RATE(48000000,  12000000, 120, 2, 3),
+	PLL_35XX_RATE(51000000,  12000000, 161, 3, 3),
+	PLL_35XX_RATE(45000000,  12000000,  82, 1, 3),
+	PLL_35XX_RATE(34000000,  12000000,  82, 2, 3),
 	{ /* sentinel */ },
 };
 
 static struct samsung_pll_clock s3c2410_plls[] __initdata = {
 	[mpll] = PLL(pll_s3c2410_mpll, MPLL, "mpll", "xti",
-						LOCKTIME, MPLLCON, NULL),
+			LOCKTIME, MPLLCON, pll_s3c2410_12mhz_tbl),
 	[upll] = PLL(pll_s3c2410_upll, UPLL, "upll", "xti",
-						LOCKTIME, UPLLCON, NULL),
+			LOCKTIME, UPLLCON, pll_s3c2410_12mhz_tbl),
 };
 
 struct samsung_div_clock s3c2410_dividers[] __initdata = {
@@ -230,42 +229,41 @@ struct samsung_clock_alias s3c2410_aliases[] __initdata = {
 /* S3C244x specific clocks */
 
 static struct samsung_pll_rate_table pll_s3c244x_12mhz_tbl[] __initdata = {
-	/* sorted in descending order */
-	PLL_35XX_RATE(400000000, 0x5c, 1, 1),
-	PLL_35XX_RATE(390000000, 0x7a, 2, 1),
-	PLL_35XX_RATE(380000000, 0x57, 1, 1),
-	PLL_35XX_RATE(370000000, 0xb1, 4, 1),
-	PLL_35XX_RATE(360000000, 0x70, 2, 1),
-	PLL_35XX_RATE(350000000, 0xa7, 4, 1),
-	PLL_35XX_RATE(340000000, 0x4d, 1, 1),
-	PLL_35XX_RATE(330000000, 0x66, 2, 1),
-	PLL_35XX_RATE(320000000, 0x98, 4, 1),
-	PLL_35XX_RATE(310000000, 0x93, 4, 1),
-	PLL_35XX_RATE(300000000, 0x75, 3, 1),
-	PLL_35XX_RATE(240000000, 0x70, 1, 2),
-	PLL_35XX_RATE(230000000, 0x6b, 1, 2),
-	PLL_35XX_RATE(220000000, 0x66, 1, 2),
-	PLL_35XX_RATE(210000000, 0x84, 2, 2),
-	PLL_35XX_RATE(200000000, 0x5c, 1, 2),
-	PLL_35XX_RATE(190000000, 0x57, 1, 2),
-	PLL_35XX_RATE(180000000, 0x70, 2, 2),
-	PLL_35XX_RATE(170000000, 0x4d, 1, 2),
-	PLL_35XX_RATE(160000000, 0x98, 4, 2),
-	PLL_35XX_RATE(150000000, 0x75, 3, 2),
-	PLL_35XX_RATE(120000000, 0x70, 1, 3),
-	PLL_35XX_RATE(110000000, 0x66, 1, 3),
-	PLL_35XX_RATE(100000000, 0x5c, 1, 3),
-	PLL_35XX_RATE(90000000, 0x70, 2, 3),
-	PLL_35XX_RATE(80000000, 0x98, 4, 3),
-	PLL_35XX_RATE(75000000, 0x75, 3, 3),
+	PLL_35XX_RATE(400000000, 12000000, 0x5c, 1, 1),
+	PLL_35XX_RATE(390000000, 12000000, 0x7a, 2, 1),
+	PLL_35XX_RATE(380000000, 12000000, 0x57, 1, 1),
+	PLL_35XX_RATE(370000000, 12000000, 0xb1, 4, 1),
+	PLL_35XX_RATE(360000000, 12000000, 0x70, 2, 1),
+	PLL_35XX_RATE(350000000, 12000000, 0xa7, 4, 1),
+	PLL_35XX_RATE(340000000, 12000000, 0x4d, 1, 1),
+	PLL_35XX_RATE(330000000, 12000000, 0x66, 2, 1),
+	PLL_35XX_RATE(320000000, 12000000, 0x98, 4, 1),
+	PLL_35XX_RATE(310000000, 12000000, 0x93, 4, 1),
+	PLL_35XX_RATE(300000000, 12000000, 0x75, 3, 1),
+	PLL_35XX_RATE(240000000, 12000000, 0x70, 1, 2),
+	PLL_35XX_RATE(230000000, 12000000, 0x6b, 1, 2),
+	PLL_35XX_RATE(220000000, 12000000, 0x66, 1, 2),
+	PLL_35XX_RATE(210000000, 12000000, 0x84, 2, 2),
+	PLL_35XX_RATE(200000000, 12000000, 0x5c, 1, 2),
+	PLL_35XX_RATE(190000000, 12000000, 0x57, 1, 2),
+	PLL_35XX_RATE(180000000, 12000000, 0x70, 2, 2),
+	PLL_35XX_RATE(170000000, 12000000, 0x4d, 1, 2),
+	PLL_35XX_RATE(160000000, 12000000, 0x98, 4, 2),
+	PLL_35XX_RATE(150000000, 12000000, 0x75, 3, 2),
+	PLL_35XX_RATE(120000000, 12000000, 0x70, 1, 3),
+	PLL_35XX_RATE(110000000, 12000000, 0x66, 1, 3),
+	PLL_35XX_RATE(100000000, 12000000, 0x5c, 1, 3),
+	PLL_35XX_RATE(90000000, 12000000, 0x70, 2, 3),
+	PLL_35XX_RATE(80000000, 12000000, 0x98, 4, 3),
+	PLL_35XX_RATE(75000000, 12000000, 0x75, 3, 3),
 	{ /* sentinel */ },
 };
 
 static struct samsung_pll_clock s3c244x_common_plls[] __initdata = {
 	[mpll] = PLL(pll_s3c2440_mpll, MPLL, "mpll", "xti",
-						LOCKTIME, MPLLCON, NULL),
+			LOCKTIME, MPLLCON, pll_s3c244x_12mhz_tbl),
 	[upll] = PLL(pll_s3c2410_upll, UPLL, "upll", "xti",
-						LOCKTIME, UPLLCON, NULL),
+			LOCKTIME, UPLLCON, pll_s3c244x_12mhz_tbl),
 };
 
 PNAME(hclk_p) = { "fclk", "div_hclk_2", "div_hclk_4", "div_hclk_3" };
@@ -384,27 +382,11 @@ void __init s3c2410_common_clk_init(struct device_node *np, unsigned long xti_f,
 		s3c2410_common_clk_register_fixed_ext(ctx, xti_f);
 
 	if (current_soc == S3C2410) {
-		if (_get_rate("xti") == 12 * MHZ) {
-			s3c2410_plls[mpll].rate_table = pll_s3c2410_12mhz_tbl;
-			s3c2410_plls[upll].rate_table = pll_s3c2410_12mhz_tbl;
-		}
-
 		/* Register PLLs. */
 		samsung_clk_register_pll(ctx, s3c2410_plls,
 				ARRAY_SIZE(s3c2410_plls), reg_base);
 
 	} else { /* S3C2440, S3C2442 */
-		if (_get_rate("xti") == 12 * MHZ) {
-			/*
-			 * plls follow different calculation schemes, with the
-			 * upll following the same scheme as the s3c2410 plls
-			 */
-			s3c244x_common_plls[mpll].rate_table =
-							pll_s3c244x_12mhz_tbl;
-			s3c244x_common_plls[upll].rate_table =
-							pll_s3c2410_12mhz_tbl;
-		}
-
 		/* Register PLLs. */
 		samsung_clk_register_pll(ctx, s3c244x_common_plls,
 				ARRAY_SIZE(s3c244x_common_plls), reg_base);
-- 
2.0.1

