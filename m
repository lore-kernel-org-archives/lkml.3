Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3A1PzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:55:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1934 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3A1PzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:55:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 28 Jan 2013 07:55:02 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] clk: add table lookup to mux
Date: Mon, 28 Jan 2013 17:54:21 +0200
Message-ID: <1359388467-32386-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1359388467-32386-1-git-send-email-pdeschrijver@nvidia.com>
References: <1359388467-32386-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a table lookup feature to the mux clock. Also allow arbitrary masks
instead of the width. This will be used by some clocks on Tegra114.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clk-mux.c        |   51 ++++++++++++++++++++++++++++++++---------
 include/linux/clk-private.h  |    3 +-
 include/linux/clk-provider.h |    9 ++++++-
 3 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
index 508c032..2c98744 100644
--- a/drivers/clk/clk-mux.c
+++ b/drivers/clk/clk-mux.c
@@ -32,6 +32,7 @@
 static u8 clk_mux_get_parent(struct clk_hw *hw)
 {
 	struct clk_mux *mux = to_clk_mux(hw);
+	int num_parents = __clk_get_num_parents(hw->clk);
 	u32 val;
 
 	/*
@@ -42,7 +43,17 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
 	 * val = 0x4 really means "bit 2, index starts at bit 0"
 	 */
 	val = readl(mux->reg) >> mux->shift;
-	val &= (1 << mux->width) - 1;
+	val &= mux->mask;
+
+	if (mux->table) {
+		int i;
+
+		for (i = 0; i < num_parents; i++)
+			if (mux->table[i] == val)
+				return i;
+		if (i == num_parents)
+			return -EINVAL;
+	}
 
 	if (val && (mux->flags & CLK_MUX_INDEX_BIT))
 		val = ffs(val) - 1;
@@ -50,7 +61,7 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
 	if (val && (mux->flags & CLK_MUX_INDEX_ONE))
 		val--;
 
-	if (val >= __clk_get_num_parents(hw->clk))
+	if (val >= num_parents)
 		return -EINVAL;
 
 	return val;
@@ -62,17 +73,22 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
 	u32 val;
 	unsigned long flags = 0;
 
-	if (mux->flags & CLK_MUX_INDEX_BIT)
-		index = (1 << ffs(index));
+	if (mux->table)
+		index = mux->table[index];
+
+	else {
+		if (mux->flags & CLK_MUX_INDEX_BIT)
+			index = (1 << ffs(index));
 
-	if (mux->flags & CLK_MUX_INDEX_ONE)
-		index++;
+		if (mux->flags & CLK_MUX_INDEX_ONE)
+			index++;
+	}
 
 	if (mux->lock)
 		spin_lock_irqsave(mux->lock, flags);
 
 	val = readl(mux->reg);
-	val &= ~(((1 << mux->width) - 1) << mux->shift);
+	val &= ~(mux->mask << mux->shift);
 	val |= index << mux->shift;
 	writel(val, mux->reg);
 
@@ -88,10 +104,10 @@ const struct clk_ops clk_mux_ops = {
 };
 EXPORT_SYMBOL_GPL(clk_mux_ops);
 
-struct clk *clk_register_mux(struct device *dev, const char *name,
+struct clk *clk_register_mux_table(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
-		void __iomem *reg, u8 shift, u8 width,
-		u8 clk_mux_flags, spinlock_t *lock)
+		void __iomem *reg, u8 shift, u32 mask,
+		u8 clk_mux_flags, u32 *table, spinlock_t *lock)
 {
 	struct clk_mux *mux;
 	struct clk *clk;
@@ -113,9 +129,10 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 	/* struct clk_mux assignments */
 	mux->reg = reg;
 	mux->shift = shift;
-	mux->width = width;
+	mux->mask = mask;
 	mux->flags = clk_mux_flags;
 	mux->lock = lock;
+	mux->table = table;
 	mux->hw.init = &init;
 
 	clk = clk_register(dev, &mux->hw);
@@ -125,3 +142,15 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
 
 	return clk;
 }
+
+struct clk *clk_register_mux(struct device *dev, const char *name,
+		const char **parent_names, u8 num_parents, unsigned long flags,
+		void __iomem *reg, u8 shift, u8 width,
+		u8 clk_mux_flags, spinlock_t *lock)
+{
+	u32 mask = BIT(width) - 1;
+
+	return clk_register_mux_table(dev, name, parent_names, num_parents,
+				      flags, reg, shift, mask, clk_mux_flags,
+				      NULL, lock);
+}
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 9c7f580..53d39c2 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -144,12 +144,13 @@ struct clk {
 
 #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
 				_reg, _shift, _width,		\
-				_mux_flags, _lock)		\
+				_mux_flags, _table, _lock)	\
 	static struct clk _name;				\
 	static struct clk_mux _name##_hw = {			\
 		.hw = {						\
 			.clk = &_name,				\
 		},						\
+		.table = _table,				\
 		.reg = _reg,					\
 		.shift = _shift,				\
 		.width = _width,				\
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 4989b8a..87a59ff 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -287,8 +287,9 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 struct clk_mux {
 	struct clk_hw	hw;
 	void __iomem	*reg;
+	u32		*table;
+	u32		mask;
 	u8		shift;
-	u8		width;
 	u8		flags;
 	spinlock_t	*lock;
 };
@@ -297,11 +298,17 @@ struct clk_mux {
 #define CLK_MUX_INDEX_BIT		BIT(1)
 
 extern const struct clk_ops clk_mux_ops;
+
 struct clk *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock);
 
+struct clk *clk_register_mux_table(struct device *dev, const char *name,
+		const char **parent_names, u8 num_parents, unsigned long flags,
+		void __iomem *reg, u8 shift, u32 mask,
+		u8 clk_mux_flags, u32 *table, spinlock_t *lock);
+
 /**
  * struct clk_fixed_factor - fixed multiplier and divider clock
  *
-- 
1.7.7.rc0.72.g4b5ea.dirty

