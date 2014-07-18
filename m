Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbaGRJxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:53:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61267 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761249AbaGRJxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:53:18 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-28-53c8ee8bcad3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] clk: samsung: exynos3250: Enable ARMCLK down feature
Date: Fri, 18 Jul 2014 11:53:06 +0200
Message-id: <1405677186-18678-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405677186-18678-1-git-send-email-k.kozlowski@samsung.com>
References: <1405677186-18678-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e/4Vd3udyeCDS7slLbYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8li7ZG77BZPJ1xks1g/4zWLA5fHnWt72Dw2L6n3
	6NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxV/T1sBVclKw7+WcLewLhVtIuRk0NCwETiztq5
	rBC2mMSFe+vZuhi5OIQEljJKbH8ymRnC6WOSOPnnIxNIFZuAscTm5UvAqkQEbjNKXD5ygx3E
	YRY4yigxvfctWJWwgKfEjsXPmUFsFgFViR9b9oLZvALuEqfX3IDaJydx8thkMJtTwENi1+97
	YL1CQDXz3z1lnsDIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSKh92cG4+JjVIUYB
	DkYlHl6OCSeChVgTy4orcw8xSnAwK4nwZt8/HizEm5JYWZValB9fVJqTWnyIkYmDU6qB0XyS
	XFmh2LbciX4Kz/iuStaoplo4R3DPuCTMNUVv+ZEGlwqr29vOP9l0x5Nb5rH7lNVl30VCLI0f
	zA++N0ct4McTy5u3Tx/+vq/addr2eVIfbHfUxQRs3XTS/VKAgZ7j139r/r75zhvWp6eS0JG0
	47KrffDtln1vjh+d85vhYt/plzphOvt55JVYijMSDbWYi4oTAbrB/hoTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable ARMCLK down and up features on Exynos3250 SoC. The
frequency of ARMCLK will be reduced upon entering idle mode (WFI or
WFE).  Additionally upon exiting from idle mode the divider for ARMCLK
will be brought back to 1.

These are exactly the same settings as for Exynos5250
(clk-exynos5250.c).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos3250.c | 50 ++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos3250.c b/drivers/clk/samsung/clk-exynos3250.c
index 7a17bd40d1dd..c80140270931 100644
--- a/drivers/clk/samsung/clk-exynos3250.c
+++ b/drivers/clk/samsung/clk-exynos3250.c
@@ -87,6 +87,29 @@
 #define SRC_CPU			0x14200
 #define DIV_CPU0		0x14500
 #define DIV_CPU1		0x14504
+#define PWR_CTRL1		0x15020
+#define PWR_CTRL2		0x15024
+
+/* Below definitions are used for PWR_CTRL settings */
+#define PWR_CTRL1_CORE2_DOWN_RATIO		(7 << 28)
+#define PWR_CTRL1_CORE1_DOWN_RATIO		(7 << 16)
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
+#define PWR_CTRL2_DIV2_UP_EN			(1 << 25)
+#define PWR_CTRL2_DIV1_UP_EN			(1 << 24)
+#define PWR_CTRL2_DUR_STANDBY2_VAL		(1 << 16)
+#define PWR_CTRL2_DUR_STANDBY1_VAL		(1 << 8)
+#define PWR_CTRL2_CORE2_UP_RATIO		(1 << 4)
+#define PWR_CTRL2_CORE1_UP_RATIO		(1 << 0)
 
 /* list of PLLs to be registered */
 enum exynos3250_plls {
@@ -748,6 +771,31 @@ static struct samsung_pll_clock exynos3250_plls[nr_plls] __initdata = {
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
+	tmp = (PWR_CTRL1_CORE2_DOWN_RATIO | PWR_CTRL1_CORE1_DOWN_RATIO |
+		PWR_CTRL1_DIV2_DOWN_EN | PWR_CTRL1_DIV1_DOWN_EN |
+		PWR_CTRL1_USE_CORE1_WFE | PWR_CTRL1_USE_CORE0_WFE |
+		PWR_CTRL1_USE_CORE1_WFI | PWR_CTRL1_USE_CORE0_WFI);
+	__raw_writel(tmp, reg_base + PWR_CTRL1);
+
+	/*
+	 * Enable arm clock up (on exiting idle). Set arm divider
+	 * ratios when not in idle along with the standby duration
+	 * ratios.
+	 */
+	tmp = (PWR_CTRL2_DIV2_UP_EN | PWR_CTRL2_DIV1_UP_EN |
+		PWR_CTRL2_DUR_STANDBY2_VAL | PWR_CTRL2_DUR_STANDBY1_VAL |
+		PWR_CTRL2_CORE2_UP_RATIO | PWR_CTRL2_CORE1_UP_RATIO);
+	__raw_writel(tmp, reg_base + PWR_CTRL2);
+}
+
 static void __init exynos3250_cmu_init(struct device_node *np)
 {
 	struct samsung_clk_provider *ctx;
@@ -775,6 +823,8 @@ static void __init exynos3250_cmu_init(struct device_node *np)
 	samsung_clk_register_div(ctx, div_clks, ARRAY_SIZE(div_clks));
 	samsung_clk_register_gate(ctx, gate_clks, ARRAY_SIZE(gate_clks));
 
+	exynos3_core_down_clock();
+
 	exynos3250_clk_sleep_init();
 }
 CLK_OF_DECLARE(exynos3250_cmu, "samsung,exynos3250-cmu", exynos3250_cmu_init);
-- 
1.9.1

