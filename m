Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbaFZP4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:56:40 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:42116 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbaFZP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:56:23 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v4 5/6] clk: sunxi: Add A23 clocks support
Date: Thu, 26 Jun 2014 23:55:43 +0800
Message-Id: <1403798144-32188-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403798144-32188-1-git-send-email-wens@csie.org>
References: <1403798144-32188-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock control unit on the A23 is similar to the one found on the A31.

The AHB1, APB1, APB2 gates on the A23 are almost identical to the ones
on the A31, but some outputs are missing.

The main CPU PLL (PLL1) however is like that on older Allwinner SoCs,
such as the A10 or A20, but the N factor starts from 1 instead of 0.

This patch adds support for PLL1 and all the basic clock muxes and gates.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/devicetree/bindings/clock/sunxi.txt |   5 ++
 drivers/clk/sunxi/clk-sunxi.c                     | 101 ++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
index b9ec668..18030ce 100644
--- a/Documentation/devicetree/bindings/clock/sunxi.txt
+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
@@ -9,11 +9,13 @@ Required properties:
 	"allwinner,sun4i-a10-osc-clk" - for a gatable oscillator
 	"allwinner,sun4i-a10-pll1-clk" - for the main PLL clock and PLL4
 	"allwinner,sun6i-a31-pll1-clk" - for the main PLL clock on A31
+	"allwinner,sun8i-a23-pll1-clk" - for the main PLL clock on A23
 	"allwinner,sun4i-a10-pll5-clk" - for the PLL5 clock
 	"allwinner,sun4i-a10-pll6-clk" - for the PLL6 clock
 	"allwinner,sun6i-a31-pll6-clk" - for the PLL6 clock on A31
 	"allwinner,sun4i-a10-cpu-clk" - for the CPU multiplexer clock
 	"allwinner,sun4i-a10-axi-clk" - for the AXI clock
+	"allwinner,sun8i-a23-axi-clk" - for the AXI clock on A23
 	"allwinner,sun4i-a10-axi-gates-clk" - for the AXI gates
 	"allwinner,sun4i-a10-ahb-clk" - for the AHB clock
 	"allwinner,sun4i-a10-ahb-gates-clk" - for the AHB gates on A10
@@ -23,6 +25,7 @@ Required properties:
 	"allwinner,sun6i-a31-ar100-clk" - for the AR100 on A31
 	"allwinner,sun6i-a31-ahb1-mux-clk" - for the AHB1 multiplexer on A31
 	"allwinner,sun6i-a31-ahb1-gates-clk" - for the AHB1 gates on A31
+	"allwinner,sun8i-a23-ahb1-gates-clk" - for the AHB1 gates on A23
 	"allwinner,sun4i-a10-apb0-clk" - for the APB0 clock
 	"allwinner,sun6i-a31-apb0-clk" - for the APB0 clock on A31
 	"allwinner,sun4i-a10-apb0-gates-clk" - for the APB0 gates on A10
@@ -37,8 +40,10 @@ Required properties:
 	"allwinner,sun5i-a10s-apb1-gates-clk" - for the APB1 gates on A10s
 	"allwinner,sun6i-a31-apb1-gates-clk" - for the APB1 gates on A31
 	"allwinner,sun7i-a20-apb1-gates-clk" - for the APB1 gates on A20
+	"allwinner,sun8i-a23-apb1-gates-clk" - for the APB1 gates on A23
 	"allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
 	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
+	"allwinner,sun8i-a23-apb2-gates-clk" - for the APB2 gates on A23
 	"allwinner,sun4i-a10-mod0-clk" - for the module 0 family of clocks
 	"allwinner,sun7i-a20-out-clk" - for the external output clocks
 	"allwinner,sun7i-a20-gmac-clk" - for the GMAC clock module on A20/A31
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 6fe9492..8975972 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -164,6 +164,54 @@ static void sun6i_a31_get_pll1_factors(u32 *freq, u32 parent_rate,
 }
 
 /**
+ * sun8i_a23_get_pll1_factors() - calculates n, k, m, p factors for PLL1
+ * PLL1 rate is calculated as follows
+ * rate = (parent_rate * (n + 1) * (k + 1) >> p) / (m + 1);
+ * parent_rate is always 24Mhz
+ */
+
+static void sun8i_a23_get_pll1_factors(u32 *freq, u32 parent_rate,
+				   u8 *n, u8 *k, u8 *m, u8 *p)
+{
+	u8 div;
+
+	/* Normalize value to a 6M multiple */
+	div = *freq / 6000000;
+	*freq = 6000000 * div;
+
+	/* we were called to round the frequency, we can now return */
+	if (n == NULL)
+		return;
+
+	/* m is always zero for pll1 */
+	*m = 0;
+
+	/* k is 1 only on these cases */
+	if (*freq >= 768000000 || *freq == 42000000 || *freq == 54000000)
+		*k = 1;
+	else
+		*k = 0;
+
+	/* p will be 2 for divs under 20 and odd divs under 32 */
+	if (div < 20 || (div < 32 && (div & 1)))
+		*p = 2;
+
+	/* p will be 1 for even divs under 32, divs under 40 and odd pairs
+	 * of divs between 40-62 */
+	else if (div < 40 || (div < 64 && (div & 2)))
+		*p = 1;
+
+	/* any other entries have p = 0 */
+	else
+		*p = 0;
+
+	/* calculate a suitable n based on k and p */
+	div <<= *p;
+	div /= (*k + 1);
+	*n = div / 4 - 1;
+}
+
+/**
  * sun4i_get_pll5_factors() - calculates n, k factors for PLL5
  * PLL5 rate is calculated as follows
  * rate = parent_rate * n * (k + 1)
@@ -422,6 +470,18 @@ static struct clk_factors_config sun6i_a31_pll1_config = {
 	.mwidth = 2,
 };
 
+static struct clk_factors_config sun8i_a23_pll1_config = {
+	.nshift = 8,
+	.nwidth = 5,
+	.kshift = 4,
+	.kwidth = 2,
+	.mshift = 0,
+	.mwidth = 2,
+	.pshift = 16,
+	.pwidth = 2,
+	.n_start = 1,
+};
+
 static struct clk_factors_config sun4i_pll5_config = {
 	.nshift = 8,
 	.nwidth = 5,
@@ -471,6 +531,12 @@ static const struct factors_data sun6i_a31_pll1_data __initconst = {
 	.getter = sun6i_a31_get_pll1_factors,
 };
 
+static const struct factors_data sun8i_a23_pll1_data __initconst = {
+	.enable = 31,
+	.table = &sun8i_a23_pll1_config,
+	.getter = sun8i_a23_get_pll1_factors,
+};
+
 static const struct factors_data sun7i_a20_pll4_data __initconst = {
 	.enable = 31,
 	.table = &sun4i_pll5_config,
@@ -673,6 +739,23 @@ static const struct div_data sun4i_axi_data __initconst = {
 	.width	= 2,
 };
 
+static const struct clk_div_table sun8i_a23_axi_table[] __initconst = {
+	{ .val = 0, .div = 1 },
+	{ .val = 1, .div = 2 },
+	{ .val = 2, .div = 3 },
+	{ .val = 3, .div = 4 },
+	{ .val = 4, .div = 4 },
+	{ .val = 5, .div = 4 },
+	{ .val = 6, .div = 4 },
+	{ .val = 7, .div = 4 },
+	{ } /* sentinel */
+};
+
+static const struct div_data sun8i_a23_axi_data __initconst = {
+	.width	= 3,
+	.table	= sun8i_a23_axi_table,
+};
+
 static const struct div_data sun4i_ahb_data __initconst = {
 	.shift	= 4,
 	.pow	= 1,
@@ -805,6 +888,10 @@ static const struct gates_data sun7i_a20_ahb_gates_data __initconst = {
 	.mask = { 0x12f77fff, 0x16ff3f },
 };
 
+static const struct gates_data sun8i_a23_ahb1_gates_data __initconst = {
+	.mask = {0x25386742, 0x2505111},
+};
+
 static const struct gates_data sun4i_apb0_gates_data __initconst = {
 	.mask = {0x4EF},
 };
@@ -837,6 +924,10 @@ static const struct gates_data sun6i_a31_apb1_gates_data __initconst = {
 	.mask = {0x3031},
 };
 
+static const struct gates_data sun8i_a23_apb1_gates_data __initconst = {
+	.mask = {0x3021},
+};
+
 static const struct gates_data sun6i_a31_apb2_gates_data __initconst = {
 	.mask = {0x3F000F},
 };
@@ -845,6 +936,10 @@ static const struct gates_data sun7i_a20_apb1_gates_data __initconst = {
 	.mask = { 0xff80ff },
 };
 
+static const struct gates_data sun8i_a23_apb2_gates_data __initconst = {
+	.mask = {0x1F0007},
+};
+
 static const struct gates_data sun4i_a10_usb_gates_data __initconst = {
 	.mask = {0x1C0},
 	.reset_mask = 0x07,
@@ -1100,6 +1195,7 @@ free_clkdata:
 static const struct of_device_id clk_factors_match[] __initconst = {
 	{.compatible = "allwinner,sun4i-a10-pll1-clk", .data = &sun4i_pll1_data,},
 	{.compatible = "allwinner,sun6i-a31-pll1-clk", .data = &sun6i_a31_pll1_data,},
+	{.compatible = "allwinner,sun8i-a23-pll1-clk", .data = &sun8i_a23_pll1_data,},
 	{.compatible = "allwinner,sun7i-a20-pll4-clk", .data = &sun7i_a20_pll4_data,},
 	{.compatible = "allwinner,sun6i-a31-pll6-clk", .data = &sun6i_a31_pll6_data,},
 	{.compatible = "allwinner,sun4i-a10-apb1-clk", .data = &sun4i_apb1_data,},
@@ -1111,6 +1207,7 @@ static const struct of_device_id clk_factors_match[] __initconst = {
 /* Matches for divider clocks */
 static const struct of_device_id clk_div_match[] __initconst = {
 	{.compatible = "allwinner,sun4i-a10-axi-clk", .data = &sun4i_axi_data,},
+	{.compatible = "allwinner,sun8i-a23-axi-clk", .data = &sun8i_a23_axi_data,},
 	{.compatible = "allwinner,sun4i-a10-ahb-clk", .data = &sun4i_ahb_data,},
 	{.compatible = "allwinner,sun4i-a10-apb0-clk", .data = &sun4i_apb0_data,},
 	{.compatible = "allwinner,sun6i-a31-apb2-div-clk", .data = &sun6i_a31_apb2_div_data,},
@@ -1140,6 +1237,7 @@ static const struct of_device_id clk_gates_match[] __initconst = {
 	{.compatible = "allwinner,sun5i-a13-ahb-gates-clk", .data = &sun5i_a13_ahb_gates_data,},
 	{.compatible = "allwinner,sun6i-a31-ahb1-gates-clk", .data = &sun6i_a31_ahb1_gates_data,},
 	{.compatible = "allwinner,sun7i-a20-ahb-gates-clk", .data = &sun7i_a20_ahb_gates_data,},
+	{.compatible = "allwinner,sun8i-a23-ahb1-gates-clk", .data = &sun8i_a23_ahb1_gates_data,},
 	{.compatible = "allwinner,sun4i-a10-apb0-gates-clk", .data = &sun4i_apb0_gates_data,},
 	{.compatible = "allwinner,sun5i-a10s-apb0-gates-clk", .data = &sun5i_a10s_apb0_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-apb0-gates-clk", .data = &sun5i_a13_apb0_gates_data,},
@@ -1149,7 +1247,9 @@ static const struct of_device_id clk_gates_match[] __initconst = {
 	{.compatible = "allwinner,sun5i-a13-apb1-gates-clk", .data = &sun5i_a13_apb1_gates_data,},
 	{.compatible = "allwinner,sun6i-a31-apb1-gates-clk", .data = &sun6i_a31_apb1_gates_data,},
 	{.compatible = "allwinner,sun7i-a20-apb1-gates-clk", .data = &sun7i_a20_apb1_gates_data,},
+	{.compatible = "allwinner,sun8i-a23-apb1-gates-clk", .data = &sun8i_a23_apb1_gates_data,},
 	{.compatible = "allwinner,sun6i-a31-apb2-gates-clk", .data = &sun6i_a31_apb2_gates_data,},
+	{.compatible = "allwinner,sun8i-a23-apb2-gates-clk", .data = &sun8i_a23_apb2_gates_data,},
 	{.compatible = "allwinner,sun4i-a10-usb-clk", .data = &sun4i_a10_usb_gates_data,},
 	{.compatible = "allwinner,sun5i-a13-usb-clk", .data = &sun5i_a13_usb_gates_data,},
 	{.compatible = "allwinner,sun6i-a31-usb-clk", .data = &sun6i_a31_usb_gates_data,},
@@ -1236,3 +1336,4 @@ static void __init sun6i_init_clocks(struct device_node *node)
 			  ARRAY_SIZE(sun6i_critical_clocks));
 }
 CLK_OF_DECLARE(sun6i_a31_clk_init, "allwinner,sun6i-a31", sun6i_init_clocks);
+CLK_OF_DECLARE(sun8i_a23_clk_init, "allwinner,sun8i-a23", sun6i_init_clocks);
-- 
2.0.0

