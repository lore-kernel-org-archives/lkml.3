Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3EQVUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:20:41 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:64823 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3EQVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:18:55 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/4] clk: vt8500: Add support for clocks on the WM8850 SoCs
Date: Sat, 18 May 2013 09:18:50 +1200
Message-Id: <1368825532-30917-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
References: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8850 has a different PLL clock to the previous versions. This
patch adds support for the WM8850-style PLL clocks.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 Documentation/devicetree/bindings/clock/vt8500.txt |    2 +
 drivers/clk/clk-vt8500.c                           |   71 ++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/vt8500.txt b/Documentation/devicetree/bindings/clock/vt8500.txt
index a880c70..91d71cc 100644
--- a/Documentation/devicetree/bindings/clock/vt8500.txt
+++ b/Documentation/devicetree/bindings/clock/vt8500.txt
@@ -8,6 +8,8 @@ Required properties:
 - compatible : shall be one of the following:
 	"via,vt8500-pll-clock" - for a VT8500/WM8505 PLL clock
 	"wm,wm8650-pll-clock" - for a WM8650 PLL clock
+	"wm,wm8750-pll-clock" - for a WM8750 PLL clock
+	"wm,wm8850-pll-clock" - for a WM8850 PLL clock
 	"via,vt8500-device-clock" - for a VT/WM device clock
 
 Required properties for PLL clocks:
diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 553ac35..ce401cf 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -42,6 +42,7 @@ struct clk_device {
 #define PLL_TYPE_VT8500		0
 #define PLL_TYPE_WM8650		1
 #define PLL_TYPE_WM8750		2
+#define PLL_TYPE_WM8850		3
 
 struct clk_pll {
 	struct clk_hw	hw;
@@ -327,6 +328,15 @@ CLK_OF_DECLARE(vt8500_device, "via,vt8500-device-clock", vtwm_device_clk_init);
 #define WM8750_BITS_TO_VAL(f, m, d1, d2)				\
 		((f << 24) | ((m - 1) << 16) | ((d1 - 1) << 8) | d2)
 
+/* Helper macros for PLL_WM8850 */
+#define WM8850_PLL_MUL(x)	((((x >> 16) & 0x7F) + 1) * 2)
+#define WM8850_PLL_DIV(x)	((((x >> 8) & 1) + 1) * (1 << (x & 3)))
+
+#define WM8850_BITS_TO_FREQ(r, m, d1, d2)				\
+				(r * ((m + 1) * 2) / ((d1+1) * (1 << d2)))
+
+#define WM8850_BITS_TO_VAL(m, d1, d2)					\
+		((((m / 2) - 1) << 16) | ((d1 - 1) << 8) | d2)
 
 static void vt8500_find_pll_bits(unsigned long rate, unsigned long parent_rate,
 				u32 *multiplier, u32 *prediv)
@@ -466,6 +476,49 @@ static void wm8750_find_pll_bits(unsigned long rate, unsigned long parent_rate,
 	*divisor2 = best_div2;
 }
 
+static void wm8850_find_pll_bits(unsigned long rate, unsigned long parent_rate,
+				u32 *multiplier, u32 *divisor1, u32 *divisor2)
+{
+	u32 mul, div1, div2;
+	u32 best_mul, best_div1, best_div2;
+	unsigned long tclk, rate_err, best_err;
+
+	best_err = (unsigned long)-1;
+
+	/* Find the closest match (lower or equal to requested) */
+	for (div1 = 1; div1 >= 0; div1--)
+		for (div2 = 3; div2 >= 0; div2--)
+			for (mul = 0; mul <= 127; mul++) {
+				tclk = parent_rate * ((mul + 1) * 2) /
+						((div1 + 1) * (1 << div2));
+				if (tclk > rate)
+					continue;
+				/* error will always be +ve */
+				rate_err = rate - tclk;
+				if (rate_err == 0) {
+					*multiplier = mul;
+					*divisor1 = div1;
+					*divisor2 = div2;
+					return;
+				}
+
+				if (rate_err < best_err) {
+					best_err = rate_err;
+					best_mul = mul;
+					best_div1 = div1;
+					best_div2 = div2;
+				}
+			}
+
+	/* if we got here, it wasn't an exact match */
+	pr_warn("%s: requested rate %lu, found rate %lu\n", __func__, rate,
+							rate - best_err);
+
+	*multiplier = best_mul;
+	*divisor1 = best_div1;
+	*divisor2 = best_div2;
+}
+
 static int vtwm_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
@@ -489,6 +542,10 @@ static int vtwm_pll_set_rate(struct clk_hw *hw, unsigned long rate,
 		wm8750_find_pll_bits(rate, parent_rate, &filter, &mul, &div1, &div2);
 		pll_val = WM8750_BITS_TO_VAL(filter, mul, div1, div2);
 		break;
+	case PLL_TYPE_WM8850:
+		wm8850_find_pll_bits(rate, parent_rate, &mul, &div1, &div2);
+		pll_val = WM8850_BITS_TO_VAL(mul, div1, div2);
+		break;
 	default:
 		pr_err("%s: invalid pll type\n", __func__);
 		return 0;
@@ -525,6 +582,10 @@ static long vtwm_pll_round_rate(struct clk_hw *hw, unsigned long rate,
 		wm8750_find_pll_bits(rate, *prate, &filter, &mul, &div1, &div2);
 		round_rate = WM8750_BITS_TO_FREQ(*prate, mul, div1, div2);
 		break;
+	case PLL_TYPE_WM8850:
+		wm8850_find_pll_bits(rate, *prate, &mul, &div1, &div2);
+		round_rate = WM8850_BITS_TO_FREQ(*prate, mul, div1, div2);
+		break;
 	default:
 		round_rate = 0;
 	}
@@ -552,6 +613,10 @@ static unsigned long vtwm_pll_recalc_rate(struct clk_hw *hw,
 		pll_freq = parent_rate * WM8750_PLL_MUL(pll_val);
 		pll_freq /= WM8750_PLL_DIV(pll_val);
 		break;
+	case PLL_TYPE_WM8850:
+		pll_freq = parent_rate * WM8850_PLL_MUL(pll_val);
+		pll_freq /= WM8850_PLL_DIV(pll_val);
+		break;
 	default:
 		pll_freq = 0;
 	}
@@ -628,6 +693,12 @@ static void __init wm8750_pll_init(struct device_node *node)
 }
 CLK_OF_DECLARE(wm8750_pll, "wm,wm8750-pll-clock", wm8750_pll_init);
 
+static void __init wm8850_pll_init(struct device_node *node)
+{
+	vtwm_pll_clk_init(node, PLL_TYPE_WM8850);
+}
+CLK_OF_DECLARE(wm8850_pll, "wm,wm8850-pll-clock", wm8850_pll_init);
+
 void __init vtwm_clk_init(void __iomem *base)
 {
 	if (!base)
-- 
1.7.9.5

