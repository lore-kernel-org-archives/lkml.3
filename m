Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbbATCFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:05:45 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41471 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbATCFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:05:39 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 2/8] clk: divider: Make generic for usage elsewhere
Date: Mon, 19 Jan 2015 18:05:29 -0800
Message-Id: <1421719535-28398-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
References: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices don't use mmio to interact with dividers. Split out the
logic from the register read/write parts so that we can reuse the
division logic elsewhere.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk-divider.c    | 212 ++++++++++++++++++++++++++-----------------
 include/linux/clk-provider.h |  11 +++
 2 files changed, 139 insertions(+), 84 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index c0a842b335c5..8dfe39086ee2 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -30,7 +30,7 @@
 
 #define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
 
-#define div_mask(d)	((1 << ((d)->width)) - 1)
+#define div_mask(width)	((1 << (width)) - 1)
 
 static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
 {
@@ -54,15 +54,16 @@ static unsigned int _get_table_mindiv(const struct clk_div_table *table)
 	return mindiv;
 }
 
-static unsigned int _get_maxdiv(struct clk_divider *divider)
+static unsigned int _get_maxdiv(const struct clk_div_table *table, u8 width,
+				unsigned long flags)
 {
-	if (divider->flags & CLK_DIVIDER_ONE_BASED)
-		return div_mask(divider);
-	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
-		return 1 << div_mask(divider);
-	if (divider->table)
-		return _get_table_maxdiv(divider->table);
-	return div_mask(divider) + 1;
+	if (flags & CLK_DIVIDER_ONE_BASED)
+		return div_mask(width);
+	if (flags & CLK_DIVIDER_POWER_OF_TWO)
+		return 1 << div_mask(width);
+	if (table)
+		return _get_table_maxdiv(table);
+	return div_mask(width) + 1;
 }
 
 static unsigned int _get_table_div(const struct clk_div_table *table,
@@ -76,14 +77,15 @@ static unsigned int _get_table_div(const struct clk_div_table *table,
 	return 0;
 }
 
-static unsigned int _get_div(struct clk_divider *divider, unsigned int val)
+static unsigned int _get_div(const struct clk_div_table *table,
+			     unsigned int val, unsigned long flags)
 {
-	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+	if (flags & CLK_DIVIDER_ONE_BASED)
 		return val;
-	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+	if (flags & CLK_DIVIDER_POWER_OF_TWO)
 		return 1 << val;
-	if (divider->table)
-		return _get_table_div(divider->table, val);
+	if (table)
+		return _get_table_div(table, val);
 	return val + 1;
 }
 
@@ -98,29 +100,28 @@ static unsigned int _get_table_val(const struct clk_div_table *table,
 	return 0;
 }
 
-static unsigned int _get_val(struct clk_divider *divider, unsigned int div)
+static unsigned int _get_val(const struct clk_div_table *table,
+			     unsigned int div, unsigned long flags)
 {
-	if (divider->flags & CLK_DIVIDER_ONE_BASED)
+	if (flags & CLK_DIVIDER_ONE_BASED)
 		return div;
-	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+	if (flags & CLK_DIVIDER_POWER_OF_TWO)
 		return __ffs(div);
-	if (divider->table)
-		return  _get_table_val(divider->table, div);
+	if (table)
+		return  _get_table_val(table, div);
 	return div - 1;
 }
 
-static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
-		unsigned long parent_rate)
+unsigned long divider_recalc_rate(struct clk_hw *hw, unsigned long parent_rate,
+				  unsigned int val,
+				  const struct clk_div_table *table,
+				  unsigned long flags)
 {
-	struct clk_divider *divider = to_clk_divider(hw);
-	unsigned int div, val;
+	unsigned int div;
 
-	val = clk_readl(divider->reg) >> divider->shift;
-	val &= div_mask(divider);
-
-	div = _get_div(divider, val);
+	div = _get_div(table, val, flags);
 	if (!div) {
-		WARN(!(divider->flags & CLK_DIVIDER_ALLOW_ZERO),
+		WARN(!(flags & CLK_DIVIDER_ALLOW_ZERO),
 			"%s: Zero divisor and CLK_DIVIDER_ALLOW_ZERO not set\n",
 			__clk_get_name(hw->clk));
 		return parent_rate;
@@ -128,6 +129,20 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 
 	return DIV_ROUND_UP(parent_rate, div);
 }
+EXPORT_SYMBOL_GPL(divider_recalc_rate);
+
+static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
+		unsigned long parent_rate)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	unsigned int val;
+
+	val = clk_readl(divider->reg) >> divider->shift;
+	val &= div_mask(divider->width);
+
+	return divider_recalc_rate(hw, parent_rate, val, divider->table,
+				   divider->flags);
+}
 
 /*
  * The reverse of DIV_ROUND_UP: The maximum number which
@@ -146,12 +161,13 @@ static bool _is_valid_table_div(const struct clk_div_table *table,
 	return false;
 }
 
-static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
+static bool _is_valid_div(const struct clk_div_table *table, unsigned int div,
+			  unsigned long flags)
 {
-	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+	if (flags & CLK_DIVIDER_POWER_OF_TWO)
 		return is_power_of_2(div);
-	if (divider->table)
-		return _is_valid_table_div(divider->table, div);
+	if (table)
+		return _is_valid_table_div(table, div);
 	return true;
 }
 
@@ -191,71 +207,76 @@ static int _round_down_table(const struct clk_div_table *table, int div)
 	return down;
 }
 
-static int _div_round_up(struct clk_divider *divider,
-		unsigned long parent_rate, unsigned long rate)
+static int _div_round_up(const struct clk_div_table *table,
+			 unsigned long parent_rate, unsigned long rate,
+			 unsigned long flags)
 {
 	int div = DIV_ROUND_UP(parent_rate, rate);
 
-	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+	if (flags & CLK_DIVIDER_POWER_OF_TWO)
 		div = __roundup_pow_of_two(div);
-	if (divider->table)
-		div = _round_up_table(divider->table, div);
+	if (table)
+		div = _round_up_table(table, div);
 
 	return div;
 }
 
-static int _div_round_closest(struct clk_divider *divider,
-		unsigned long parent_rate, unsigned long rate)
+static int _div_round_closest(const struct clk_div_table *table,
+			      unsigned long parent_rate, unsigned long rate,
+			      unsigned long flags)
 {
 	int up, down, div;
 
 	up = down = div = DIV_ROUND_CLOSEST(parent_rate, rate);
 
-	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO) {
+	if (flags & CLK_DIVIDER_POWER_OF_TWO) {
 		up = __roundup_pow_of_two(div);
 		down = __rounddown_pow_of_two(div);
-	} else if (divider->table) {
-		up = _round_up_table(divider->table, div);
-		down = _round_down_table(divider->table, div);
+	} else if (table) {
+		up = _round_up_table(table, div);
+		down = _round_down_table(table, div);
 	}
 
 	return (up - div) <= (div - down) ? up : down;
 }
 
-static int _div_round(struct clk_divider *divider, unsigned long parent_rate,
-		unsigned long rate)
+static int _div_round(const struct clk_div_table *table,
+		      unsigned long parent_rate, unsigned long rate,
+		      unsigned long flags)
 {
-	if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
-		return _div_round_closest(divider, parent_rate, rate);
+	if (flags & CLK_DIVIDER_ROUND_CLOSEST)
+		return _div_round_closest(table, parent_rate, rate, flags);
 
-	return _div_round_up(divider, parent_rate, rate);
+	return _div_round_up(table, parent_rate, rate, flags);
 }
 
-static bool _is_best_div(struct clk_divider *divider,
-		unsigned long rate, unsigned long now, unsigned long best)
+static bool _is_best_div(unsigned long rate, unsigned long now,
+			 unsigned long best, unsigned long flags)
 {
-	if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
+	if (flags & CLK_DIVIDER_ROUND_CLOSEST)
 		return abs(rate - now) < abs(rate - best);
 
 	return now <= rate && now > best;
 }
 
-static int _next_div(struct clk_divider *divider, int div)
+static int _next_div(const struct clk_div_table *table, int div,
+		     unsigned long flags)
 {
 	div++;
 
-	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
+	if (flags & CLK_DIVIDER_POWER_OF_TWO)
 		return __roundup_pow_of_two(div);
-	if (divider->table)
-		return _round_up_table(divider->table, div);
+	if (table)
+		return _round_up_table(table, div);
 
 	return div;
 }
 
 static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
-		unsigned long *best_parent_rate)
+			       unsigned long *best_parent_rate,
+			       const struct clk_div_table *table, u8 width,
+			       unsigned long flags)
 {
-	struct clk_divider *divider = to_clk_divider(hw);
 	int i, bestdiv = 0;
 	unsigned long parent_rate, best = 0, now, maxdiv;
 	unsigned long parent_rate_saved = *best_parent_rate;
@@ -263,19 +284,11 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	if (!rate)
 		rate = 1;
 
-	/* if read only, just return current value */
-	if (divider->flags & CLK_DIVIDER_READ_ONLY) {
-		bestdiv = readl(divider->reg) >> divider->shift;
-		bestdiv &= div_mask(divider);
-		bestdiv = _get_div(divider, bestdiv);
-		return bestdiv;
-	}
-
-	maxdiv = _get_maxdiv(divider);
+	maxdiv = _get_maxdiv(table, width, flags);
 
 	if (!(__clk_get_flags(hw->clk) & CLK_SET_RATE_PARENT)) {
 		parent_rate = *best_parent_rate;
-		bestdiv = _div_round(divider, parent_rate, rate);
+		bestdiv = _div_round(table, parent_rate, rate, flags);
 		bestdiv = bestdiv == 0 ? 1 : bestdiv;
 		bestdiv = bestdiv > maxdiv ? maxdiv : bestdiv;
 		return bestdiv;
@@ -287,8 +300,8 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	 */
 	maxdiv = min(ULONG_MAX / rate, maxdiv);
 
-	for (i = 1; i <= maxdiv; i = _next_div(divider, i)) {
-		if (!_is_valid_div(divider, i))
+	for (i = 1; i <= maxdiv; i = _next_div(table, i, flags)) {
+		if (!_is_valid_div(table, i, flags))
 			continue;
 		if (rate * i == parent_rate_saved) {
 			/*
@@ -302,7 +315,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 		parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
 				MULT_ROUND_UP(rate, i));
 		now = DIV_ROUND_UP(parent_rate, i);
-		if (_is_best_div(divider, rate, now, best)) {
+		if (_is_best_div(rate, now, best, flags)) {
 			bestdiv = i;
 			best = now;
 			*best_parent_rate = parent_rate;
@@ -310,48 +323,79 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	}
 
 	if (!bestdiv) {
-		bestdiv = _get_maxdiv(divider);
+		bestdiv = _get_maxdiv(table, width, flags);
 		*best_parent_rate = __clk_round_rate(__clk_get_parent(hw->clk), 1);
 	}
 
 	return bestdiv;
 }
 
-static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+long divider_round_rate(struct clk_hw *hw, unsigned long rate,
+			unsigned long *prate, const struct clk_div_table *table,
+			u8 width, unsigned long flags)
 {
 	int div;
-	div = clk_divider_bestdiv(hw, rate, prate);
+
+	div = clk_divider_bestdiv(hw, rate, prate, table, width, flags);
 
 	return DIV_ROUND_UP(*prate, div);
 }
+EXPORT_SYMBOL_GPL(divider_round_rate);
 
-static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long parent_rate)
+static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long *prate)
 {
 	struct clk_divider *divider = to_clk_divider(hw);
+	int bestdiv;
+
+	/* if read only, just return current value */
+	if (divider->flags & CLK_DIVIDER_READ_ONLY) {
+		bestdiv = readl(divider->reg) >> divider->shift;
+		bestdiv &= div_mask(divider->width);
+		bestdiv = _get_div(divider->table, bestdiv, divider->flags);
+		return bestdiv;
+	}
+
+	return divider_round_rate(hw, rate, prate, divider->table,
+				  divider->width, divider->flags);
+}
+
+int divider_get_val(unsigned long rate, unsigned long parent_rate,
+		    const struct clk_div_table *table, u8 width,
+		    unsigned long flags)
+{
 	unsigned int div, value;
-	unsigned long flags = 0;
-	u32 val;
 
 	div = DIV_ROUND_UP(parent_rate, rate);
 
-	if (!_is_valid_div(divider, div))
+	if (!_is_valid_div(table, div, flags))
 		return -EINVAL;
 
-	value = _get_val(divider, div);
+	value = _get_val(table, div, flags);
+
+	return min_t(unsigned int, value, div_mask(width));
+}
+EXPORT_SYMBOL_GPL(divider_get_val);
+
+static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct clk_divider *divider = to_clk_divider(hw);
+	unsigned int value;
+	unsigned long flags = 0;
+	u32 val;
 
-	if (value > div_mask(divider))
-		value = div_mask(divider);
+	value = divider_get_val(rate, parent_rate, divider->table,
+				divider->width, divider->flags);
 
 	if (divider->lock)
 		spin_lock_irqsave(divider->lock, flags);
 
 	if (divider->flags & CLK_DIVIDER_HIWORD_MASK) {
-		val = div_mask(divider) << (divider->shift + 16);
+		val = div_mask(divider->width) << (divider->shift + 16);
 	} else {
 		val = clk_readl(divider->reg);
-		val &= ~(div_mask(divider) << divider->shift);
+		val &= ~(div_mask(divider->width) << divider->shift);
 	}
 	val |= value << divider->shift;
 	clk_writel(val, divider->reg);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index d2523f42f4e4..b471c86f877f 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -352,6 +352,17 @@ struct clk_divider {
 #define CLK_DIVIDER_READ_ONLY		BIT(5)
 
 extern const struct clk_ops clk_divider_ops;
+
+unsigned long divider_recalc_rate(struct clk_hw *hw, unsigned long parent_rate,
+		unsigned int val, const struct clk_div_table *table,
+		unsigned long flags);
+long divider_round_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long *prate, const struct clk_div_table *table,
+		u8 width, unsigned long flags);
+int divider_get_val(unsigned long rate, unsigned long parent_rate,
+		const struct clk_div_table *table, u8 width,
+		unsigned long flags);
+
 struct clk *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

