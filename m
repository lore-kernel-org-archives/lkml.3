Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaIAP0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:26:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12592 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIAP0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:26:20 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-44-54049018fa2c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] clk: samsung: exynos3250: Register DMC clk provider
Date: Mon, 01 Sep 2014 17:26:00 +0200
Message-id: <1409585162-10523-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7oSE1hCDC48NbPYOGM9q8WkdQeY
	LOYfOcdq0f9mIavFuVcrGS1evzC06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWqw9
	cpfdYun1i0wWTydcZLOYMH0ti0Xr3iPsFofftLNarJ/xmsVi1a4/jA4iHmvmrWH0aGnuYfO4
	3NfL5PF31Qtmj52z7rJ7rFz+hc1j06pONo871/aweWxeUu/Rt2UVo8fnTXIB3FFcNimpOZll
	qUX6dglcGUuvP2ArOOFU0T7lB2MD43rzLkZODgkBE4lVs94wQ9hiEhfurWfrYuTiEBJYyiix
	5vwJFpCEkEAfk8Tf9wEgNpuAscTm5UvAikQEmlklPpyawQTiMAvMYJS4t3AXWIewgIfE1K5j
	7CA2i4CqxON128DivALuEis6jkCtk5M4eWwy6wRG7gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS
	9ZLzczcxQgL8yw7GxcesDjEKcDAq8fC+WMgcIsSaWFZcmXuIUYKDWUmENzWDJUSINyWxsiq1
	KD++qDQntfgQIxMHp1QDo7WUyqN3z7kyeucoBXz91ZTdUS7hMHvXgbh2Z750njVzzjOFmaWc
	suWwipia66rO/LlK8EmAW7zElUXK67kCwl6KVJamx1XvN8vptpOeIar5Vu/i3Neq9YZ/vbo4
	TK2ErD7cuFP//bV/9H/2SDWXhSf1lnqqGFWkZRxVZ622Kn/zTObRgadKLMUZiYZazEXFiQDB
	m7uDTgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock provider for clocks in DMC domain including EPLL and BPLL. The
DMC clocks are necessary for Exynos3 devfreq driver.

The DMC clock domain uses different address space (0x105C0000) than
standard clock domain (0x10030000 - 0x10050000). The difference is huge
enough to add new DT node for the clock provider, rather than extending
existing address space.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos3250.c   | 194 +++++++++++++++++++++++++++++++++
 include/dt-bindings/clock/exynos3250.h |  27 +++++
 2 files changed, 221 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index dc85f8e7a2d7..6cda52031b30 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -110,6 +110,12 @@ enum exynos3250_plls {
 	nr_plls
 };
 
+/* list of PLLs in DMC block to be registered */
+enum exynos3250_dmc_plls {
+	bpll, epll,
+	nr_dmc_plls
+};
+
 static void __iomem *reg_base;
 
 /*
@@ -724,6 +730,25 @@ static struct samsung_pll_rate_table exynos3250_pll_rates[] = {
 	{ /* sentinel */ }
 };
 
+/* EPLL */
+static struct samsung_pll_rate_table exynos3250_epll_rates[] = {
+	PLL_36XX_RATE(800000000, 200, 3, 1,     0),
+	PLL_36XX_RATE(288000000,  96, 2, 2,     0),
+	PLL_36XX_RATE(192000000, 128, 2, 3,     0),
+	PLL_36XX_RATE(144000000,  96, 2, 3,     0),
+	PLL_36XX_RATE( 96000000, 128, 2, 4,     0),
+	PLL_36XX_RATE( 84000000, 112, 2, 4,     0),
+	PLL_36XX_RATE( 80000004, 106, 2, 4, 43691),
+	PLL_36XX_RATE( 73728000,  98, 2, 4, 19923),
+	PLL_36XX_RATE( 67737598, 270, 3, 5, 62285),
+	PLL_36XX_RATE( 65535999, 174, 2, 5, 49982),
+	PLL_36XX_RATE( 50000000, 200, 3, 5,     0),
+	PLL_36XX_RATE( 49152002, 131, 2, 5,  4719),
+	PLL_36XX_RATE( 48000000, 128, 2, 5,     0),
+	PLL_36XX_RATE( 45158401, 180, 3, 5, 41524),
+	{ /* sentinel */ }
+};
+
 /* VPLL */
 static struct samsung_pll_rate_table exynos3250_vpll_rates[] = {
 	PLL_36XX_RATE(600000000, 100, 2, 1,     0),
@@ -821,3 +846,172 @@ static void __init exynos3250_cmu_init(struct device_node *np)
 	samsung_clk_of_add_provider(np, ctx);
 }
 CLK_OF_DECLARE(exynos3250_cmu, "samsung,exynos3250-cmu", exynos3250_cmu_init);
+
+/*
+ * CMU DMC
+ */
+
+#define BPLL_LOCK		0x0118
+#define BPLL_CON0		0x0218
+#define BPLL_CON1		0x021c
+#define BPLL_CON2		0x0220
+#define SRC_DMC			0x0300
+#define DIV_DMC1		0x0504
+#define GATE_BUS_DMC0		0x0700
+#define GATE_BUS_DMC1		0x0704
+#define GATE_BUS_DMC2		0x0708
+#define GATE_BUS_DMC3		0x070c
+#define GATE_SCLK_DMC		0x0800
+#define GATE_IP_DMC0		0x0900
+#define GATE_IP_DMC1		0x0904
+#define EPLL_LOCK		0x1110
+#define EPLL_CON0		0x1114
+#define EPLL_CON1		0x1118
+#define EPLL_CON2		0x111c
+#define SRC_EPLL		0x1120
+
+/*
+ * Support for CMU save/restore across system suspends
+ */
+#ifdef CONFIG_PM_SLEEP
+static struct samsung_clk_reg_dump *exynos3250_dmc_clk_regs;
+
+static unsigned long exynos3250_cmu_dmc_clk_regs[] __initdata = {
+	BPLL_LOCK,
+	BPLL_CON0,
+	BPLL_CON1,
+	BPLL_CON2,
+	SRC_DMC,
+	DIV_DMC1,
+	GATE_BUS_DMC0,
+	GATE_BUS_DMC1,
+	GATE_BUS_DMC2,
+	GATE_BUS_DMC3,
+	GATE_SCLK_DMC,
+	GATE_IP_DMC0,
+	GATE_IP_DMC1,
+	EPLL_LOCK,
+	EPLL_CON0,
+	EPLL_CON1,
+	EPLL_CON2,
+	SRC_EPLL,
+};
+
+static int exynos3250_dmc_clk_suspend(void)
+{
+	samsung_clk_save(reg_base, exynos3250_dmc_clk_regs,
+				ARRAY_SIZE(exynos3250_cmu_dmc_clk_regs));
+	return 0;
+}
+
+static void exynos3250_dmc_clk_resume(void)
+{
+	samsung_clk_restore(reg_base, exynos3250_dmc_clk_regs,
+				ARRAY_SIZE(exynos3250_cmu_dmc_clk_regs));
+}
+
+static struct syscore_ops exynos3250_dmc_clk_syscore_ops = {
+	.suspend = exynos3250_dmc_clk_suspend,
+	.resume = exynos3250_dmc_clk_resume,
+};
+
+static void exynos3250_dmc_clk_sleep_init(void)
+{
+	exynos3250_dmc_clk_regs =
+		samsung_clk_alloc_reg_dump(exynos3250_cmu_dmc_clk_regs,
+				   ARRAY_SIZE(exynos3250_cmu_dmc_clk_regs));
+	if (!exynos3250_dmc_clk_regs) {
+		pr_warn("%s: Failed to allocate sleep save data\n", __func__);
+		goto err;
+	}
+
+	register_syscore_ops(&exynos3250_dmc_clk_syscore_ops);
+	return;
+err:
+	kfree(exynos3250_dmc_clk_regs);
+}
+#else
+static inline void exynos3250_dmc_clk_sleep_init(void) { }
+#endif
+
+PNAME(mout_epll_p)	= { "fin_pll", "fout_epll", };
+PNAME(mout_bpll_p)	= { "fin_pll", "fout_bpll", };
+PNAME(mout_mpll_mif_p)	= { "fin_pll", "sclk_mpll_mif", };
+PNAME(mout_dphy_p)	= { "mout_mpll_mif", "mout_bpll", };
+
+static struct samsung_mux_clock dmc_mux_clks[] __initdata = {
+	/*
+	 * NOTE: Following table is sorted by register address in ascending
+	 * order and then bitfield shift in descending order, as it is done
+	 * in the User's Manual. When adding new entries, please make sure
+	 * that the order is preserved, to avoid merge conflicts and make
+	 * further work with defined data easier.
+	 */
+
+	/* SRC_DMC */
+	MUX(CLK_MOUT_MPLL_MIF, "mout_mpll_mif", mout_mpll_mif_p, SRC_DMC, 12, 1),
+	MUX(CLK_MOUT_BPLL, "mout_bpll", mout_bpll_p, SRC_DMC, 10, 1),
+	MUX(CLK_MOUT_DPHY, "mout_dphy", mout_dphy_p, SRC_DMC, 8, 1),
+	MUX(CLK_MOUT_DMC_BUS, "mout_dmc_bus", mout_dphy_p, SRC_DMC,  4, 1),
+
+	/* SRC_EPLL */
+	MUX(CLK_MOUT_EPLL, "mout_epll", mout_epll_p, SRC_EPLL, 4, 1),
+};
+
+static struct samsung_div_clock dmc_div_clks[] __initdata = {
+	/*
+	 * NOTE: Following table is sorted by register address in ascending
+	 * order and then bitfield shift in descending order, as it is done
+	 * in the User's Manual. When adding new entries, please make sure
+	 * that the order is preserved, to avoid merge conflicts and make
+	 * further work with defined data easier.
+	 */
+
+	/* DIV_DMC1 */
+	DIV(CLK_DIV_DMC, "div_dmc", "div_dmc_pre", DIV_DMC1, 27, 3),
+	DIV(CLK_DIV_DPHY, "div_dphy", "mout_dphy", DIV_DMC1, 23, 3),
+	DIV(CLK_DIV_DMC_PRE, "div_dmc_pre", "mout_dmc_bus", DIV_DMC1, 19, 2),
+	DIV(CLK_DIV_DMCP, "div_dmcp", "div_dmcd", DIV_DMC1, 15, 3),
+	DIV(CLK_DIV_DMCD, "div_dmcd", "div_dmc", DIV_DMC1, 11, 3),
+};
+
+static struct samsung_pll_clock exynos3250_dmc_plls[nr_dmc_plls] __initdata = {
+	[bpll] = PLL(pll_35xx, CLK_FOUT_BPLL, "fout_bpll", "fin_pll",
+			BPLL_LOCK, BPLL_CON0, NULL),
+	[epll] = PLL(pll_36xx, CLK_FOUT_EPLL, "fout_epll", "fin_pll",
+			EPLL_LOCK, EPLL_CON0, NULL),
+};
+
+static void __init exynos3250_cmu_dmc_init(struct device_node *np)
+{
+	struct samsung_clk_provider *ctx;
+
+	reg_base = of_iomap(np, 0);
+	if (!reg_base)
+		panic("%s: failed to map registers\n", __func__);
+
+	ctx = samsung_clk_init(np, reg_base, NR_CLKS_DMC);
+	if (!ctx)
+		panic("%s: unable to allocate context.\n", __func__);
+
+	exynos3250_dmc_plls[bpll].rate_table = exynos3250_pll_rates;
+	exynos3250_dmc_plls[epll].rate_table = exynos3250_epll_rates;
+
+	pr_err("CLK registering epll bpll: %d, %d, %d, %d\n",
+			exynos3250_dmc_plls[bpll].rate_table[0].rate,
+			exynos3250_dmc_plls[bpll].rate_table[0].mdiv,
+			exynos3250_dmc_plls[bpll].rate_table[0].pdiv,
+			exynos3250_dmc_plls[bpll].rate_table[0].sdiv
+	      );
+	samsung_clk_register_pll(ctx, exynos3250_dmc_plls,
+				ARRAY_SIZE(exynos3250_dmc_plls), reg_base);
+
+	samsung_clk_register_mux(ctx, dmc_mux_clks, ARRAY_SIZE(dmc_mux_clks));
+	samsung_clk_register_div(ctx, dmc_div_clks, ARRAY_SIZE(dmc_div_clks));
+
+	exynos3250_dmc_clk_sleep_init();
+
+	samsung_clk_of_add_provider(np, ctx);
+}
+CLK_OF_DECLARE(exynos3250_cmu_dmc, "samsung,exynos3250-cmu-dmc",
+		exynos3250_cmu_dmc_init);
diff --git a/include/dt-bindings/clock/exynos3250.h b/include/dt-bindings/clock/exynos3250.h
index b535e9da7de6..961b9c130ea9 100644
--- a/include/dt-bindings/clock/exynos3250.h
+++ b/include/dt-bindings/clock/exynos3250.h
@@ -255,4 +255,31 @@
  */
 #define CLK_NR_CLKS			248
 
+/*
+ * CMU DMC
+ */
+
+#define CLK_FOUT_BPLL			1
+#define CLK_FOUT_EPLL			2
+
+/* Muxes */
+#define CLK_MOUT_MPLL_MIF		8
+#define CLK_MOUT_BPLL			9
+#define CLK_MOUT_DPHY			10
+#define CLK_MOUT_DMC_BUS		11
+#define CLK_MOUT_EPLL			12
+
+/* Dividers */
+#define CLK_DIV_DMC			16
+#define CLK_DIV_DPHY			17
+#define CLK_DIV_DMC_PRE			18
+#define CLK_DIV_DMCP			19
+#define CLK_DIV_DMCD			20
+
+/*
+ * Total number of clocks of main CMU.
+ * NOTE: Must be equal to last clock ID increased by one.
+ */
+#define NR_CLKS_DMC			21
+
 #endif /* _DT_BINDINGS_CLOCK_SAMSUNG_EXYNOS3250_CLOCK_H */
-- 
1.9.1

