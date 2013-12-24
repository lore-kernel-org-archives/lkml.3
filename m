Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab3LXBRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:17:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49669 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab3LXBMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:12:43 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 03/15] clk: Add regmap core helpers for enable/disable/is_enabled
Date: Mon, 23 Dec 2013 17:12:27 -0800
Message-Id: <1387847559-18330-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
References: <1387847559-18330-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock framework already has support for simple gate clocks
but if drivers want to use the gate clock functionality they need
to wrap the gate clock in another struct and chain the ops by
calling the gate ops from their own custom ops. Plus the gate
clock implementation only supports MMIO accessors so other bus
type clocks don't benefit from the potential code reuse. Add some
simple regmap helpers for enable/disable/is_enabled that drivers
can use as drop in replacements for their clock ops or as simple
functions they call from their own custom ops. This is based on 
similar helps in the regulator framework.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c            | 70 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h | 13 ++++++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 5e71f5c..8b40170 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -742,6 +742,76 @@ out:
 	return best;
 }
 
+/**
+ * clk_is_enabled_regmap - standard is_enabled() for regmap users
+ *
+ * @hw: clk to operate on
+ *
+ * Clocks that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their struct clk_hw and then use
+ * this as their is_enabled operation, saving some code.
+ */
+int clk_is_enabled_regmap(struct clk_hw *hw)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(hw->regmap, hw->enable_reg, &val);
+	if (ret != 0)
+		return ret;
+
+	if (hw->enable_is_inverted)
+		return (val & hw->enable_mask) == 0;
+	else
+		return (val & hw->enable_mask) != 0;
+}
+EXPORT_SYMBOL_GPL(clk_is_enabled_regmap);
+
+/**
+ * clk_enable_regmap - standard enable() for regmap users
+ *
+ * @hw: clk to operate on
+ *
+ * Clocks that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their struct clk_hw and then use
+ * this as their enable() operation, saving some code.
+ */
+int clk_enable_regmap(struct clk_hw *hw)
+{
+	unsigned int val;
+
+	if (hw->enable_is_inverted)
+		val = 0;
+	else
+		val = hw->enable_mask;
+
+	return regmap_update_bits(hw->regmap, hw->enable_reg,
+				  hw->enable_mask, val);
+}
+EXPORT_SYMBOL_GPL(clk_enable_regmap);
+
+/**
+ * clk_disable_regmap - standard disable() for regmap users
+ *
+ * @hw: clk to operate on
+ *
+ * Clocks that use regmap for their register I/O can set the
+ * enable_reg and enable_mask fields in their struct clk_hw and then use
+ * this as their disable() operation, saving some code.
+ */
+void clk_disable_regmap(struct clk_hw *hw)
+{
+	unsigned int val;
+
+	if (hw->enable_is_inverted)
+		val = hw->enable_mask;
+	else
+		val = 0;
+
+	regmap_update_bits(hw->regmap, hw->enable_reg, hw->enable_mask, val);
+}
+EXPORT_SYMBOL_GPL(clk_disable_regmap);
+
 /***        clk api        ***/
 
 void __clk_unprepare(struct clk *clk)
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 31f2890..61507fb 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -177,11 +177,21 @@ struct clk_init_data {
  * with the common clock framework.
  *
  * @regmap: regmap to use for regmap helpers and/or by providers
+ *
+ * @enable_reg: register when using regmap enable/disable ops
+ *
+ * @enable_mask: mask when using regmap enable/disable ops
+ *
+ * @enable_is_inverted: flag to indicate set enable_mask bits to disable
+ *                      when using clock_enable_regmap and friends APIs.
  */
 struct clk_hw {
 	struct clk *clk;
 	const struct clk_init_data *init;
 	struct regmap *regmap;
+	unsigned int enable_reg;
+	unsigned int enable_mask;
+	bool enable_is_inverted;
 };
 
 /*
@@ -447,6 +457,9 @@ struct clk *__clk_lookup(const char *name);
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
 			      struct clk **best_parent_p);
+int clk_is_enabled_regmap(struct clk_hw *hw);
+int clk_enable_regmap(struct clk_hw *hw);
+void clk_disable_regmap(struct clk_hw *hw);
 
 /*
  * FIXME clock api without lock protection
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

