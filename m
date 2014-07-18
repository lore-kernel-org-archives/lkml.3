Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762571AbaGROgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:36:44 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18496 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033AbaGROgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:36:42 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e9-53c930f7a721
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/2] clk: samsung: exynos4: Enable ARMCLK down feature
Date: Fri, 18 Jul 2014 16:36:32 +0200
Message-id: <1405694193-29643-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xq7rfDU4GG+ztlLDYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8li7ZG77BZPJ1xks1g/4zWLA5fHnWt72Dw2L6n3
	6NuyitHj8ya5AJYoLpuU1JzMstQifbsErozZTw8yFRxXqvjwoIGxgXGxTBcjJ4eEgInEo6Xv
	2SBsMYkL99YD2VwcQgJLGSXWf1gOlhAS6GOSOPDBEsRmEzCW2Lx8CViRiMBtRonLR26wgzjM
	AkcZJab3vmUCqRIW8JRo+/GMGcRmEVCVmHzpC9gkXgF3iWmP2lgh1slJnDw2mXUCI/cCRoZV
	jKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGB82UH4+JjVocYBTgYlXh4OSacCBZiTSwrrsw9
	xCjBwawkwjtB42SwEG9KYmVValF+fFFpTmrxIUYmDk6pBsaa0oL5725l/9b8Jal37M3XhIZc
	mbtdomW39dQnp0wMOu3uEW9uHM5nepXtMPv27T+l5yk8un7WzV2jb6n5yysdP7ZtMfiiryCq
	mxnFnXKX/7/o7aOfXRN3/52RwLGs40N+9wmFI2VtVhcynUX7Nm4y8ZV7flj6b9sX431a3Jdf
	8jOy7Oi4KqnEUpyRaKjFXFScCADQKFJU+gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ARMCLK down feature on all Exynos4 SoCs. The frequency of
ARMCLK will be reduced upon entering idle mode (WFI or WFE).

The feature behaves like very fast cpufreq ondemand governor. In idle
mode this reduces energy consumption on full frequency chosen by
cpufreq governor by approximately:
 - Trats2:  6.5% (153 mA -> 143 mA)
 - Trats:  33.0% (180 mA -> 120 mA)
 - Gear1:  27.0% (180 mA -> 130 mA)

The patch uses simillar settings as Exynos5250 (clk-exynos5250.c),
except it disables clock up feature and on Exynos4412 ARMCLK down is
enabled for all 4 cores.

Tested on Trats board (Exynos4210), Trats2 board (Exynos4412) and
Samsung Gear 1 (Exynos4212).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
1. Add PWR_CTRL registers to the list of saved clk registers on
   Exynos4x12. Suggested by Tomasz Figa.
2. Disable the clock up feature. (sug. Tomasz Figa)
3. Use macros for setting clock down ratio. (sug. Tomasz Figa)
4. Use num_possible_cpus() for exception on Exynos4x12. (sug. Tomasz
   Figa)
5. Enable the clock down feature also on Exynos4210 Trats board.
---
 drivers/clk/samsung/clk-exynos4.c | 46 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 7f4a473a7ad7..86c7709dc6d6 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -114,11 +114,27 @@
 #define DIV_CPU1		0x14504
 #define GATE_SCLK_CPU		0x14800
 #define GATE_IP_CPU		0x14900
+#define PWR_CTRL1		0x15020
+#define E4X12_PWR_CTRL2		0x15024
 #define E4X12_DIV_ISP0		0x18300
 #define E4X12_DIV_ISP1		0x18304
 #define E4X12_GATE_ISP0		0x18800
 #define E4X12_GATE_ISP1		0x18804
 
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
+
 /* the exynos4 soc type */
 enum exynos4_soc {
 	EXYNOS4210,
@@ -155,6 +171,7 @@ static unsigned long exynos4210_clk_save[] __initdata = {
 	E4210_GATE_IP_LCD1,
 	E4210_GATE_IP_PERIR,
 	E4210_MPLL_CON0,
+	PWR_CTRL1,
 };
 
 static unsigned long exynos4x12_clk_save[] __initdata = {
@@ -164,6 +181,8 @@ static unsigned long exynos4x12_clk_save[] __initdata = {
 	E4X12_DIV_ISP,
 	E4X12_DIV_CAM1,
 	E4X12_MPLL_CON0,
+	PWR_CTRL1,
+	E4X12_PWR_CTRL2,
 };
 
 static unsigned long exynos4_clk_pll_regs[] __initdata = {
@@ -1164,6 +1183,32 @@ static struct samsung_pll_clock exynos4x12_plls[nr_plls] __initdata = {
 			VPLL_LOCK, VPLL_CON0, NULL),
 };
 
+static void __init exynos4_core_down_clock(enum exynos4_soc soc)
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
+	/* On Exynos4412 enable it also on core 2 and 3 */
+	if (num_possible_cpus() == 4)
+		tmp |= PWR_CTRL1_USE_CORE3_WFE | PWR_CTRL1_USE_CORE2_WFE |
+		       PWR_CTRL1_USE_CORE3_WFI | PWR_CTRL1_USE_CORE2_WFI;
+	__raw_writel(tmp, reg_base + PWR_CTRL1);
+
+	/*
+	 * Disable the clock up feature on Exynos4x12, in case it was
+	 * enabled by bootloader.
+	 */
+	if (exynos4_soc == EXYNOS4X12)
+		__raw_writel(0x0, reg_base + E4X12_PWR_CTRL2);
+}
+
 /* register exynos4 clocks */
 static void __init exynos4_clk_init(struct device_node *np,
 				    enum exynos4_soc soc)
@@ -1250,6 +1295,7 @@ static void __init exynos4_clk_init(struct device_node *np,
 	samsung_clk_register_alias(ctx, exynos4_aliases,
 			ARRAY_SIZE(exynos4_aliases));
 
+	exynos4_core_down_clock(soc);
 	exynos4_clk_sleep_init();
 
 	pr_info("%s clocks: sclk_apll = %ld, sclk_mpll = %ld\n"
-- 
1.9.1

