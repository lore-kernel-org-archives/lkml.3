Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762593AbaGROg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:36:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18496 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761773AbaGROgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:36:43 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-eb-53c930f73bb3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/2] clk: samsung: exynos3250: Enable ARMCLK down feature
Date: Fri, 18 Jul 2014 16:36:33 +0200
Message-id: <1405694193-29643-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405694193-29643-1-git-send-email-k.kozlowski@samsung.com>
References: <1405694193-29643-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t/xq7rfDU4GG0z8YWyxccZ6VovXLwwt
	ehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF2iN32S2eTrjIZrF+xmsWBy6PO9f2sHlsXlLv
	0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnNq0wKjkhWHD7Vz9TAOEW0i5GDQ0LAROL2zvou
	Rk4gU0ziwr31bF2MXBxCAksZJfa2LWYHSQgJ9DFJHPhgCWKzCRhLbF6+BKxIROA2o8TlIzfY
	QRxmgaOMEtN73zKBVAkL+Eg0zD8I1s0ioCrx79kvRhCbV8BdovXuIxaIdXISJ49NZgW5glPA
	Q+L3xRiIZe4Sxzb9Y5nAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkiIfdnBuPiY
	1SFGAQ5GJR5ejgkngoVYE8uKK3MPMUpwMCuJ8E7QOBksxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gdG0tdPtpnMff+2J3Z4mCSL1rWUrZ2afjbSzYznH6VPQY7bHo0eWKWS5/5a7yzV5/jAcF/Qr
	Yfnu4JV1mXuPu4ame2lB+P01p4tUi9kWMyUYMz4QOj9P1WzhdteKjCO+NytNdNadCInY9MRp
	wQ/m+TPttn+R6W54eits4nM3nnebflhlXm3zUmIpzkg01GIuKk4EALmkfKUPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ARMCLK down feature on Exynos3250 SoC. The frequency of
ARMCLK will be reduced upon entering idle mode (WFI or WFE).

The feature behaves like very fast cpufreq ondemand governor.

The patch uses simillar settings as Exynos5250 (clk-exynos5250.c),
except it disables clock up feature.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
1. Add PWR_CTRL registers to the list of saved clk registers on
   Exynos3250. Suggested by Tomasz Figa.
2. Disable the clock up feature. (sug. Tomasz Figa)
3. Use macros for setting clock down ratio. (sug. Tomasz Figa)
---
 drivers/clk/samsung/clk-exynos3250.c | 41 ++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index 7a17bd40d1dd..a50dc88f0e8f 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -87,6 +87,22 @@
 #define SRC_CPU			0x14200
 #define DIV_CPU0		0x14500
 #define DIV_CPU1		0x14504
+#define PWR_CTRL1		0x15020
+#define PWR_CTRL2		0x15024
+
+/* Below definitions are used for PWR_CTRL settings */
+#define PWR_CTRL1_CORE2_DOWN_RATIO(x)		(((x) & 0x7) << 28)
+#define PWR_CTRL1_CORE1_DOWN_RATIO(x)		(((x) & 0x7) << 16)
+#define PWR_CTRL1_DIV2_DOWN_EN			(1 << 9)
+#define PWR_CTRL1_DIV1_DOWN_EN			(1 << 8)
+#define PWR_CTRL1_USE_CORE3_WFE			(1 << 7)
+#define PWR_CTRL1_USE_CORE2_WFE			(1 << 6)
+#define PWR_CTRL1_USE_CORE1_WFE			(1 << 5)
+#define PWR_CTRL1_USE_CORE0_WFE			(1 << 4)
+#define PWR_CTRL1_USE_CORE3_WFI			(1 << 3)
+#define PWR_CTRL1_USE_CORE2_WFI			(1 << 2)
+#define PWR_CTRL1_USE_CORE1_WFI			(1 << 1)
+#define PWR_CTRL1_USE_CORE0_WFI			(1 << 0)
 
 /* list of PLLs to be registered */
 enum exynos3250_plls {
@@ -168,6 +184,8 @@ static unsigned long exynos3250_cmu_clk_regs[] __initdata = {
 	SRC_CPU,
 	DIV_CPU0,
 	DIV_CPU1,
+	PWR_CTRL1,
+	PWR_CTRL2,
 };
 
 static int exynos3250_clk_suspend(void)
@@ -748,6 +766,27 @@ static struct samsung_pll_clock exynos3250_plls[nr_plls] __initdata = {
 			UPLL_LOCK, UPLL_CON0, NULL),
 };
 
+static void __init exynos3_core_down_clock(void)
+{
+	unsigned int tmp;
+
+	/*
+	 * Enable arm clock down (in idle) and set arm divider
+	 * ratios in WFI/WFE state.
+	 */
+	tmp = (PWR_CTRL1_CORE2_DOWN_RATIO(7) | PWR_CTRL1_CORE1_DOWN_RATIO(7) |
+		PWR_CTRL1_DIV2_DOWN_EN | PWR_CTRL1_DIV1_DOWN_EN |
+		PWR_CTRL1_USE_CORE1_WFE | PWR_CTRL1_USE_CORE0_WFE |
+		PWR_CTRL1_USE_CORE1_WFI | PWR_CTRL1_USE_CORE0_WFI);
+	__raw_writel(tmp, reg_base + PWR_CTRL1);
+
+	/*
+	 * Disable the clock up feature on Exynos4x12, in case it was
+	 * enabled by bootloader.
+	 */
+	__raw_writel(0x0, reg_base + PWR_CTRL2);
+}
+
 static void __init exynos3250_cmu_init(struct device_node *np)
 {
 	struct samsung_clk_provider *ctx;
@@ -775,6 +814,8 @@ static void __init exynos3250_cmu_init(struct device_node *np)
 	samsung_clk_register_div(ctx, div_clks, ARRAY_SIZE(div_clks));
 	samsung_clk_register_gate(ctx, gate_clks, ARRAY_SIZE(gate_clks));
 
+	exynos3_core_down_clock();
+
 	exynos3250_clk_sleep_init();
 }
 CLK_OF_DECLARE(exynos3250_cmu, "samsung,exynos3250-cmu", exynos3250_cmu_init);
-- 
1.9.1

