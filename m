Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaI3RVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:21:06 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:57816 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbaI3RVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:21:00 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: sboyd@codeaurora.org
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1] clk: qcom: Add support for regmap clock dividers
Date: Tue, 30 Sep 2014 20:20:55 +0300
Message-Id: <1412097655-10662-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch expands the regmap support to allow registration of clock
dividers. It just prepares for the introduction of a clkdiv driver,
that will be in a separate patch.
Such dividers are found in the Qualcomm PMIC chips such as PM8941,
PMA8084 and others.

Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
---
 drivers/clk/qcom/clk-regmap.c |   68 +++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/clk-regmap.h |   24 +++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/drivers/clk/qcom/clk-regmap.c b/drivers/clk/qcom/clk-regmap.c
index a58ba39..d63b8ca 100644
--- a/drivers/clk/qcom/clk-regmap.c
+++ b/drivers/clk/qcom/clk-regmap.c
@@ -112,3 +112,71 @@ struct clk *devm_clk_register_regmap(struct device *dev,
 	return devm_clk_register(dev, &rclk->hw);
 }
 EXPORT_SYMBOL_GPL(devm_clk_register_regmap);
+
+/**
+ * clkdiv_recalc_rate_regmap - Calculate clock divider output rate
+ */
+unsigned long clkdiv_recalc_rate_regmap(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	struct clk_regmap *rclk = to_clk_regmap(hw);
+	struct clkdiv_regmap *clkdiv = to_clkdiv_regmap(rclk);
+	unsigned int div, val;
+
+	regmap_read(rclk->regmap, clkdiv->reg, &val);
+	if (!val)
+		return parent_rate;
+
+	div = (val >> clkdiv->shift) & ((1 << clkdiv->width)-1);
+
+	return parent_rate / div;
+}
+EXPORT_SYMBOL_GPL(clkdiv_recalc_rate_regmap);
+
+static const struct clk_ops clkdiv_ops = {
+	.enable = clk_enable_regmap,
+	.disable = clk_disable_regmap,
+	.is_enabled = clk_is_enabled_regmap,
+	.recalc_rate = clkdiv_recalc_rate_regmap,
+};
+EXPORT_SYMBOL_GPL(clkdiv_ops);
+
+/**
+ * devm_clkdiv_register_regmap - register a clk_regmap clock divider
+ *
+ * @dev: device that is registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @clkdiv: clock divider to operate on
+ *
+ * Clocks that use regmap for their register I/O should register their
+ * clk_regmap struct via this function so that the regmap is initialized
+ * and so that the clock is registered with the common clock framework.
+ */
+struct clk *devm_clkdiv_register_regmap(struct device *dev, const char *name,
+					const char *parent_name,
+					unsigned long flags,
+					struct clkdiv_regmap *clkdiv)
+{
+	struct clk_init_data init;
+
+	if (!clkdiv)
+		return ERR_PTR(-ENODEV);
+
+	clkdiv->rclk.regmap = dev_get_regmap(dev->parent, NULL);
+
+	if (!clkdiv->rclk.regmap)
+		return ERR_PTR(-ENXIO);
+
+	init.name = name;
+	init.parent_names = (parent_name ? &parent_name : NULL);
+	init.num_parents = (parent_name ? 1 : 0);
+	init.flags = flags;
+	init.ops = &clkdiv_ops;
+
+	clkdiv->rclk.hw.init = &init;
+
+	return devm_clk_register(dev, &clkdiv->rclk.hw);
+}
+EXPORT_SYMBOL_GPL(devm_clkdiv_register_regmap);
diff --git a/drivers/clk/qcom/clk-regmap.h b/drivers/clk/qcom/clk-regmap.h
index 491a63d..02582cf 100644
--- a/drivers/clk/qcom/clk-regmap.h
+++ b/drivers/clk/qcom/clk-regmap.h
@@ -42,4 +42,28 @@ void clk_disable_regmap(struct clk_hw *hw);
 struct clk *
 devm_clk_register_regmap(struct device *dev, struct clk_regmap *rclk);
 
+/**
+ * struct clkdiv_regmap - regmap supporting clock divider
+ * @rclk:   regmap supporting clock struct
+ * @reg:    offset into regmap for the control register
+ * @shift:  bit position for divider value
+ * @width:  number of bits used for divider value
+ * @table:  pointer to table containing an array of divider/value pairs
+ */
+struct clkdiv_regmap {
+	struct clk_regmap rclk;
+	unsigned int reg;
+	unsigned int shift;
+	unsigned int width;
+	struct clk_div_table *table;
+};
+
+#define to_clkdiv_regmap(_rclk) container_of(_rclk, struct clkdiv_regmap, rclk)
+
+unsigned long
+clkdiv_recalc_rate_regmap(struct clk_hw *hw, unsigned long parent_rate);
+struct clk *
+devm_clkdiv_register_regmap(struct device *dev, const char *name,
+			    const char *parent_name, unsigned long flags,
+			    struct clkdiv_regmap *clkdiv);
 #endif
-- 
1.7.9.5

