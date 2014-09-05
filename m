Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaIEWrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:47:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43534 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaIEWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:47:40 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH v2 02/15] clk: mux: Split out register accessors for reuse
Date: Fri,  5 Sep 2014 15:47:21 -0700
Message-Id: <1409957256-23729-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.rc2.4.g1a517f0
In-Reply-To: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to reuse the logic in clk-mux.c for other clock drivers
that don't use readl as register accessors. Fortunately, there
really isn't much to the mux code besides the table indirection
and quirk flags if you assume any bit shifting and masking has
been done already. Pull that logic out into reusable functions
that operate on an optional table and some flags so that other
drivers can use the same logic.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk-mux.c        | 76 +++++++++++++++++++++++++++-----------------
 include/linux/clk-provider.h |  9 ++++--
 2 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index c0cf9db9effa..54217961ae8a 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -29,35 +29,24 @@
 
 #define to_clk_mux(_hw) container_of(_hw, struct clk_mux, hw)
 
-static u8 clk_mux_get_parent(struct clk_hw *hw)
+unsigned int clk_mux_get_parent(struct clk_hw *hw, unsigned int val,
+				unsigned int *table, unsigned long flags)
 {
-	struct clk_mux *mux = to_clk_mux(hw);
 	int num_parents = __clk_get_num_parents(hw->clk);
-	u32 val;
 
-	/*
-	 * FIXME need a mux-specific flag to determine if val is bitwise or numeric
-	 * e.g. sys_clkin_ck's clksel field is 3 bits wide, but ranges from 0x1
-	 * to 0x7 (index starts at one)
-	 * OTOH, pmd_trace_clk_mux_ck uses a separate bit for each clock, so
-	 * val = 0x4 really means "bit 2, index starts at bit 0"
-	 */
-	val = clk_readl(mux->reg) >> mux->shift;
-	val &= mux->mask;
-
-	if (mux->table) {
+	if (table) {
 		int i;
 
 		for (i = 0; i < num_parents; i++)
-			if (mux->table[i] == val)
+			if (table[i] == val)
 				return i;
 		return -EINVAL;
 	}
 
-	if (val && (mux->flags & CLK_MUX_INDEX_BIT))
+	if (val && (flags & CLK_MUX_INDEX_BIT))
 		val = ffs(val) - 1;
 
-	if (val && (mux->flags & CLK_MUX_INDEX_ONE))
+	if (val && (flags & CLK_MUX_INDEX_ONE))
 		val--;
 
 	if (val >= num_parents)
@@ -65,24 +54,53 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
 
 	return val;
 }
+EXPORT_SYMBOL_GPL(clk_mux_get_parent);
 
-static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
+static u8 _clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct clk_mux *mux = to_clk_mux(hw);
 	u32 val;
-	unsigned long flags = 0;
 
-	if (mux->table)
-		index = mux->table[index];
+	/*
+	 * FIXME need a mux-specific flag to determine if val is bitwise or numeric
+	 * e.g. sys_clkin_ck's clksel field is 3 bits wide, but ranges from 0x1
+	 * to 0x7 (index starts at one)
+	 * OTOH, pmd_trace_clk_mux_ck uses a separate bit for each clock, so
+	 * val = 0x4 really means "bit 2, index starts at bit 0"
+	 */
+	val = clk_readl(mux->reg) >> mux->shift;
+	val &= mux->mask;
+
+	return clk_mux_get_parent(hw, val, mux->table, mux->flags);
+}
 
-	else {
-		if (mux->flags & CLK_MUX_INDEX_BIT)
-			index = (1 << ffs(index));
+unsigned int clk_mux_reindex(u8 index, unsigned int *table,
+			     unsigned long flags)
+{
+	unsigned int val = index;
 
-		if (mux->flags & CLK_MUX_INDEX_ONE)
-			index++;
+	if (table) {
+		val = table[val];
+	} else {
+		if (flags & CLK_MUX_INDEX_BIT)
+			val = (1 << ffs(val));
+
+		if (flags & CLK_MUX_INDEX_ONE)
+			val++;
 	}
 
+	return val;
+}
+EXPORT_SYMBOL_GPL(clk_mux_reindex);
+
+static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_mux *mux = to_clk_mux(hw);
+	u32 val;
+	unsigned long flags = 0;
+
+	index = clk_mux_reindex(index, mux->table, mux->flags);
+
 	if (mux->lock)
 		spin_lock_irqsave(mux->lock, flags);
 
@@ -102,21 +120,21 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
 }
 
 const struct clk_ops clk_mux_ops = {
-	.get_parent = clk_mux_get_parent,
+	.get_parent = _clk_mux_get_parent,
 	.set_parent = clk_mux_set_parent,
 	.determine_rate = __clk_mux_determine_rate,
 };
 EXPORT_SYMBOL_GPL(clk_mux_ops);
 
 const struct clk_ops clk_mux_ro_ops = {
-	.get_parent = clk_mux_get_parent,
+	.get_parent = _clk_mux_get_parent,
 };
 EXPORT_SYMBOL_GPL(clk_mux_ro_ops);
 
 struct clk *clk_register_mux_table(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u32 mask,
-		u8 clk_mux_flags, u32 *table, spinlock_t *lock)
+		u8 clk_mux_flags, unsigned int *table, spinlock_t *lock)
 {
 	struct clk_mux *mux;
 	struct clk *clk;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index f0744b8de50a..48a92e318542 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -376,7 +376,7 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 struct clk_mux {
 	struct clk_hw	hw;
 	void __iomem	*reg;
-	u32		*table;
+	unsigned int	*table;
 	u32		mask;
 	u8		shift;
 	u8		flags;
@@ -391,6 +391,11 @@ struct clk_mux {
 extern const struct clk_ops clk_mux_ops;
 extern const struct clk_ops clk_mux_ro_ops;
 
+unsigned int clk_mux_get_parent(struct clk_hw *hw, unsigned int val,
+				unsigned int *table, unsigned long flags);
+unsigned int clk_mux_reindex(u8 index, unsigned int *table,
+			     unsigned long flags);
+
 struct clk *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
@@ -399,7 +404,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 struct clk *clk_register_mux_table(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u32 mask,
-		u8 clk_mux_flags, u32 *table, spinlock_t *lock);
+		u8 clk_mux_flags, unsigned int *table, spinlock_t *lock);
 
 void clk_unregister_mux(struct clk *clk);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

