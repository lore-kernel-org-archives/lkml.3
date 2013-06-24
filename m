Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3FXSnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:43:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46162 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3FXSnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:43:16 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-6b-51c89342e076
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] clk: exynos4: Add CLK_GET_RATE_NOCACHE flag for the Exynos4x12
 ISP clocks
Date: Mon, 24 Jun 2013 20:42:54 +0200
Message-id: <1372099374-21008-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t9jQV2nyScCDSZ1aVqcbXrDbrHp8TVW
	i8u75rBZzDi/j8ni6YSLbBaH37SzOrB53Lm2h81j85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo4evE8c8E2nYp5d+YzNTCeVO1i5OCQEDCRuHHCvIuRE8gUk7hwbz1bFyMXh5DAdEaJ
	j49a2CGcDiaJRV/XsYBUsQkYSvQe7WMEsUUEJCUefJ7OAlLELLCVUaKz5yc7SEJYIEbi8LqV
	bCA2i4CqxJfFq8BsXgE3idP7O9ghNitIzJlkM4GRewEjwypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4HB4JrWDcWWDxSFGAQ5GJR7eGTEnAoVYE8uKK3MPMUpwMCuJ8IaKAIV4UxIrq1KL
	8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwnt6S5u18IO52coJK/at/
	ejfSDm1m+XL0dWy0iPxltc3v6hf9PcDtdt3t51Umsa47L7/6eQbueGdoND3pjopgZeGzudWz
	fNy3yyrsVav2qZQIkj3fcyTGZqb9ndurV97W/OFw7WUPT3ZwOxuP9YVds2/26jiXdv6Lln74
	b0PApxXR7x9FdbCtVWIpzkg01GIuKk4EABURfA0DAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISP clock registers belong to the ISP power domain and may change
their values if this power domain is switched off/on. Add
CLK_GET_RATE_NOCACHE flags to ensure we do not rely on invalid cached
data when setting or getting frequency of those clocks.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/clk/samsung/clk-exynos4.c |   64 ++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 94c5e1a..a5d72f5 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -578,11 +578,15 @@ struct samsung_div_clock exynos4x12_div_clks[] __initdata = {
 	DIV(none, "div_spi1_isp", "mout_spi1_isp", E4X12_DIV_ISP, 16, 4),
 	DIV(none, "div_spi1_isp_pre", "div_spi1_isp", E4X12_DIV_ISP, 20, 8),
 	DIV(none, "div_uart_isp", "mout_uart_isp", E4X12_DIV_ISP, 28, 4),
-	DIV(div_isp0, "div_isp0", "aclk200", E4X12_DIV_ISP0, 0, 3),
-	DIV(div_isp1, "div_isp1", "aclk200", E4X12_DIV_ISP0, 4, 3),
+	DIV_F(div_isp0, "div_isp0", "aclk200", E4X12_DIV_ISP0, 0, 3,
+						CLK_GET_RATE_NOCACHE, 0),
+	DIV_F(div_isp1, "div_isp1", "aclk200", E4X12_DIV_ISP0, 4, 3,
+						CLK_GET_RATE_NOCACHE, 0),
 	DIV(none, "div_mpwm", "div_isp1", E4X12_DIV_ISP1, 0, 3),
-	DIV(div_mcuisp0, "div_mcuisp0", "aclk400_mcuisp", E4X12_DIV_ISP1, 4, 3),
-	DIV(div_mcuisp1, "div_mcuisp1", "div_mcuisp0", E4X12_DIV_ISP1, 8, 3),
+	DIV_F(div_mcuisp0, "div_mcuisp0", "aclk400_mcuisp", E4X12_DIV_ISP1,
+						4, 3, CLK_GET_RATE_NOCACHE, 0),
+	DIV_F(div_mcuisp1, "div_mcuisp1", "div_mcuisp0", E4X12_DIV_ISP1,
+						8, 3, CLK_GET_RATE_NOCACHE, 0),
 };
 
 /* list of gate clocks supported in all exynos4 soc's */
@@ -857,57 +861,57 @@ struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE_DA(i2s0, "samsung-i2s.0", "i2s0", "aclk100",
 			E4X12_GATE_IP_MAUDIO, 3, 0, 0, "iis"),
 	GATE(fimc_isp, "isp", "aclk200", E4X12_GATE_ISP0, 0,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(fimc_drc, "drc", "aclk200", E4X12_GATE_ISP0, 1,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(fimc_fd, "fd", "aclk200", E4X12_GATE_ISP0, 2,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(fimc_lite0, "lite0", "aclk200", E4X12_GATE_ISP0, 3,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(fimc_lite1, "lite1", "aclk200", E4X12_GATE_ISP0, 4,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(mcuisp, "mcuisp", "aclk200", E4X12_GATE_ISP0, 5,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(gicisp, "gicisp", "aclk200", E4X12_GATE_ISP0, 7,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_isp, "smmu_isp", "aclk200", E4X12_GATE_ISP0, 8,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_drc, "smmu_drc", "aclk200", E4X12_GATE_ISP0, 9,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_fd, "smmu_fd", "aclk200", E4X12_GATE_ISP0, 10,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_lite0, "smmu_lite0", "aclk200", E4X12_GATE_ISP0, 11,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_lite1, "smmu_lite1", "aclk200", E4X12_GATE_ISP0, 12,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(ppmuispmx, "ppmuispmx", "aclk200", E4X12_GATE_ISP0, 20,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(ppmuispx, "ppmuispx", "aclk200", E4X12_GATE_ISP0, 21,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(mcuctl_isp, "mcuctl_isp", "aclk200", E4X12_GATE_ISP0, 23,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(mpwm_isp, "mpwm_isp", "aclk200", E4X12_GATE_ISP0, 24,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(i2c0_isp, "i2c0_isp", "aclk200", E4X12_GATE_ISP0, 25,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(i2c1_isp, "i2c1_isp", "aclk200", E4X12_GATE_ISP0, 26,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(mtcadc_isp, "mtcadc_isp", "aclk200", E4X12_GATE_ISP0, 27,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(pwm_isp, "pwm_isp", "aclk200", E4X12_GATE_ISP0, 28,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(wdt_isp, "wdt_isp", "aclk200", E4X12_GATE_ISP0, 30,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(uart_isp, "uart_isp", "aclk200", E4X12_GATE_ISP0, 31,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(asyncaxim, "asyncaxim", "aclk200", E4X12_GATE_ISP1, 0,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(smmu_ispcx, "smmu_ispcx", "aclk200", E4X12_GATE_ISP1, 4,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(spi0_isp, "spi0_isp", "aclk200", E4X12_GATE_ISP1, 12,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 	GATE(spi1_isp, "spi1_isp", "aclk200", E4X12_GATE_ISP1, 13,
-			CLK_IGNORE_UNUSED, 0),
+			CLK_IGNORE_UNUSED | CLK_GET_RATE_NOCACHE, 0),
 };
 
 /*
-- 
1.7.9.5

