Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaB1Xf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:35:27 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:54819 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaB1XfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:35:24 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Gerhard Sittig <gsi@denx.de>
Cc: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 2/3] clk/i2c-div: Allow custom divider accessors
Date: Fri, 28 Feb 2014 15:34:54 -0800
Message-Id: <1393630495-29689-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to provide custom accessors to read/write the divider from/to HW
since some I2C dividers spread dividers across multiple registers.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/clk-i2c-divider.c | 64 ++++++++++++++++++++++++++++++++-----------
 include/linux/clk-provider.h  | 15 ++++++++--
 2 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/clk-i2c-divider.c b/drivers/clk/clk-i2c-divider.c
index 690eae191072..086fb7935ccb 100644
--- a/drivers/clk/clk-i2c-divider.c
+++ b/drivers/clk/clk-i2c-divider.c
@@ -99,14 +99,23 @@ static unsigned int _get_val(struct clk_i2c_divider *divider, u8 div)
 	return div - 1;
 }
 
+static unsigned int clk_i2c_divider_get_div(struct clk_i2c_divider *divider)
+{
+	unsigned int div;
+
+	div = clk_i2c_readb(divider->regmap, divider->reg) >> divider->shift;
+	div &= div_mask(divider);
+
+	return div;
+}
+
 static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 		unsigned long parent_rate)
 {
 	struct clk_i2c_divider *divider = to_clk_i2c_divider(hw);
 	unsigned int div, val;
 
-	val = clk_i2c_readb(divider->regmap, divider->reg) >> divider->shift;
-	val &= div_mask(divider);
+	val = divider->get_div(divider);
 
 	div = _get_div(divider, val);
 	if (!div) {
@@ -211,16 +220,10 @@ static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 	return *prate / div;
 }
 
-static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long parent_rate)
+static int clk_i2c_divider_set_div(unsigned int value,
+		struct clk_i2c_divider *divider)
 {
-	struct clk_i2c_divider *divider = to_clk_i2c_divider(hw);
-	unsigned int div, value;
-	unsigned long flags = 0;
-	u32 val;
-
-	div = parent_rate / rate;
-	value = _get_val(divider, div);
+	unsigned int val;
 
 	if (value > div_mask(divider))
 		value = div_mask(divider);
@@ -237,6 +240,18 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
+static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct clk_i2c_divider *divider = to_clk_i2c_divider(hw);
+	unsigned int div, value;
+
+	div = parent_rate / rate;
+	value = _get_val(divider, div);
+
+	return divider->set_div(value, divider);
+}
+
 const struct clk_ops clk_i2c_divider_ops = {
 	.recalc_rate = clk_divider_recalc_rate,
 	.round_rate = clk_divider_round_rate,
@@ -247,7 +262,9 @@ EXPORT_SYMBOL_GPL(clk_i2c_divider_ops);
 static struct clk *_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
-		u8 clk_divider_flags, const struct clk_div_table *table)
+		u8 clk_divider_flags, const struct clk_div_table *table,
+		unsigned int (*get_div)(struct clk_i2c_divider *),
+		int (*set_div)(unsigned int val, struct clk_i2c_divider *))
 {
 	struct clk_i2c_divider *div;
 	struct clk *clk;
@@ -286,6 +303,15 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 	div->flags = clk_divider_flags;
 	div->hw.init = &init;
 	div->table = table;
+	if (get_div)
+		div->get_div = get_div;
+	else
+		div->get_div = clk_i2c_divider_get_div;
+
+	if (set_div)
+		div->set_div = set_div;
+	else
+		div->set_div = clk_i2c_divider_set_div;
 
 	/* register the clock */
 	clk = devm_clk_register(dev, &div->hw);
@@ -311,10 +337,13 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 struct clk *clk_i2c_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
-		u8 clk_divider_flags)
+		u8 clk_divider_flags,
+		unsigned int (*get_div)(struct clk_i2c_divider *),
+		int (*set_div)(unsigned int val, struct clk_i2c_divider *))
 {
 	return _register_divider(dev, name, parent_name, flags, regmap, reg,
-			shift, width, clk_divider_flags, NULL);
+			shift, width, clk_divider_flags, NULL, get_div,
+			set_div);
 }
 EXPORT_SYMBOL_GPL(clk_i2c_register_divider);
 
@@ -335,9 +364,12 @@ EXPORT_SYMBOL_GPL(clk_i2c_register_divider);
 struct clk *clk_i2c_register_divider_table(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
-		u8 clk_divider_flags, const struct clk_div_table *table)
+		u8 clk_divider_flags, const struct clk_div_table *table,
+		unsigned int (*get_div)(struct clk_i2c_divider *),
+		int (*set_div)(unsigned int val, struct clk_i2c_divider *))
 {
 	return _register_divider(dev, name, parent_name, flags, regmap, reg,
-			shift, width, clk_divider_flags, table);
+			shift, width, clk_divider_flags, table, get_div,
+			set_div);
 }
 EXPORT_SYMBOL_GPL(clk_i2c_register_divider_table);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index d86bb6ec4232..bccb711b0ea1 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -353,6 +353,8 @@ struct clk_i2c_divider {
 	u8		width;
 	u8		flags;
 	const struct clk_div_table	*table;
+	unsigned int	(*get_div)(struct clk_i2c_divider *);
+	int		(*set_div)(unsigned int, struct clk_i2c_divider *);
 };
 
 #define CLK_DIVIDER_ONE_BASED		BIT(0)
@@ -655,14 +657,21 @@ struct clk *clk_i2c_register_mux_table(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		struct regmap *regmap, unsigned int reg, u8 shift, u32 mask,
 		u8 clk_mux_flags, u32 *table);
+
 struct clk *clk_i2c_register_divider(struct device *dev, const char *name,
                 const char *parent_name, unsigned long flags,
                 struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
-                u8 clk_divider_flags);
-struct clk *clk_i2c_register_divider_table(struct device *dev, const char *name, 
+                u8 clk_divider_flags, unsigned int (*get_div)(struct
+			clk_i2c_divider *), int (*set_div)(unsigned int val,
+				struct clk_i2c_divider *));
+
+struct clk *clk_i2c_register_divider_table(struct device *dev, const char *name,
                 const char *parent_name, unsigned long flags,
                 struct regmap *regmap, unsigned int reg, u8 shift, u8 width,
-                u8 clk_divider_flags, const struct clk_div_table *table);
+                u8 clk_divider_flags, const struct clk_div_table *table,
+		unsigned int (*get_div)(struct clk_i2c_divider *),
+		int (*set_div)(unsigned int val, struct clk_i2c_divider *));
+
 #endif /* CONFIG_COMMON_CLK_I2C */
 
 #endif /* CONFIG_COMMON_CLK */
-- 
1.9.0.1.g4196000

