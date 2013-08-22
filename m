Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3HVFx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:53:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:65356 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3HVFxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:53:24 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Matt Sealey <neko@bakuhatsu.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v4 1/5] clk: divider: replace bitfield width with mask
Date: Wed, 21 Aug 2013 22:53:09 -0700
Message-Id: <1377150793-27864-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The forthcoming Device Tree binding for the divider clock type will use
a bitfield mask instead of bitfield width, which is what the current
basic divider implementation uses.

This patch replaces the u8 width in struct clk_divider with a u32 mask.
The divider code is updated to use the bit mask internally but the two
registration functions still accept the width to maintain compatibility
with existing users.

Also updated in this patch is the clk-private.h divider macro and two
Freescale clock divider implementations that are based on struct
clk_divider.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---
No change since v3

 arch/arm/mach-imx/clk-busy.c |  2 +-
 drivers/clk/clk-divider.c    | 31 +++++++++++++++----------------
 drivers/clk/mxs/clk-div.c    |  2 +-
 include/linux/clk-private.h  |  2 +-
 include/linux/clk-provider.h |  2 +-
 5 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-imx/clk-busy.c b/arch/arm/mach-imx/clk-busy.c
index 4bb1bc4..bc88e38 100644
--- a/arch/arm/mach-imx/clk-busy.c
+++ b/arch/arm/mach-imx/clk-busy.c
@@ -95,7 +95,7 @@ struct clk *imx_clk_busy_divider(const char *name, const char *parent_name,
 
 	busy->div.reg = reg;
 	busy->div.shift = shift;
-	busy->div.width = width;
+	busy->div.mask = BIT(width) - 1;
 	busy->div.lock = &imx_ccm_lock;
 	busy->div_ops = &clk_divider_ops;
 
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 749372f..2791a2b 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -30,8 +30,6 @@
 
 #define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
 
-#define div_mask(d)	((1 << ((d)->width)) - 1)
-
 static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
 {
 	unsigned int maxdiv = 0;
@@ -46,12 +44,12 @@ static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
 static unsigned int _get_maxdiv(struct clk_divider *divider)
 {
 	if (divider->flags & CLK_DIVIDER_ONE_BASED)
-		return div_mask(divider);
+		return divider->mask;
 	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
-		return 1 << div_mask(divider);
+		return 1 << divider->mask;
 	if (divider->table)
 		return _get_table_maxdiv(divider->table);
-	return div_mask(divider) + 1;
+	return divider->mask + 1;
 }
 
 static unsigned int _get_table_div(const struct clk_div_table *table,
@@ -105,7 +103,7 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 	unsigned int div, val;
 
 	val = readl(divider->reg) >> divider->shift;
-	val &= div_mask(divider);
+	val &= divider->mask;
 
 	div = _get_div(divider, val);
 	if (!div) {
@@ -221,17 +219,17 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	div = parent_rate / rate;
 	value = _get_val(divider, div);
 
-	if (value > div_mask(divider))
-		value = div_mask(divider);
+	if (value > divider->mask)
+		value = divider->mask;
 
 	if (divider->lock)
 		spin_lock_irqsave(divider->lock, flags);
 
 	if (divider->flags & CLK_DIVIDER_HIWORD_MASK) {
-		val = div_mask(divider) << (divider->shift + 16);
+		val = divider->mask << (divider->shift + 16);
 	} else {
 		val = readl(divider->reg);
-		val &= ~(div_mask(divider) << divider->shift);
+		val &= ~(divider->mask << divider->shift);
 	}
 	val |= value << divider->shift;
 	writel(val, divider->reg);
@@ -251,7 +249,7 @@ EXPORT_SYMBOL_GPL(clk_divider_ops);
 
 static struct clk *_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 shift, u8 width,
+		void __iomem *reg, u8 shift, u32 mask,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock)
 {
@@ -260,8 +258,9 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 	struct clk_init_data init;
 
 	if (clk_divider_flags & CLK_DIVIDER_HIWORD_MASK) {
-		if (width + shift > 16) {
-			pr_warn("divider value exceeds LOWORD field\n");
+		if ((mask << shift) & 0xffff0000) {
+			pr_warn("%s: divider value exceeds LOWORD field\n",
+					__func__);
 			return ERR_PTR(-EINVAL);
 		}
 	}
@@ -282,7 +281,7 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 	/* struct clk_divider assignments */
 	div->reg = reg;
 	div->shift = shift;
-	div->width = width;
+	div->mask = mask;
 	div->flags = clk_divider_flags;
 	div->lock = lock;
 	div->hw.init = &init;
@@ -315,7 +314,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 		u8 clk_divider_flags, spinlock_t *lock)
 {
 	return _register_divider(dev, name, parent_name, flags, reg, shift,
-			width, clk_divider_flags, NULL, lock);
+			((1 << width) - 1), clk_divider_flags, NULL, lock);
 }
 EXPORT_SYMBOL_GPL(clk_register_divider);
 
@@ -340,6 +339,6 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 		spinlock_t *lock)
 {
 	return _register_divider(dev, name, parent_name, flags, reg, shift,
-			width, clk_divider_flags, table, lock);
+			((1 << width) - 1), clk_divider_flags, table, lock);
 }
 EXPORT_SYMBOL_GPL(clk_register_divider_table);
diff --git a/drivers/clk/mxs/clk-div.c b/drivers/clk/mxs/clk-div.c
index 90e1da9..af2428e 100644
--- a/drivers/clk/mxs/clk-div.c
+++ b/drivers/clk/mxs/clk-div.c
@@ -96,7 +96,7 @@ struct clk *mxs_clk_div(const char *name, const char *parent_name,
 
 	div->divider.reg = reg;
 	div->divider.shift = shift;
-	div->divider.width = width;
+	div->divider.mask = BIT(width) - 1;
 	div->divider.flags = CLK_DIVIDER_ONE_BASED;
 	div->divider.lock = &mxs_lock;
 	div->divider.hw.init = &init;
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 8138c94..7bcd65d 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -122,7 +122,7 @@ struct clk {
 		},						\
 		.reg = _reg,					\
 		.shift = _shift,				\
-		.width = _width,				\
+		.mask = ((1 << _width) - 1),			\
 		.flags = _divider_flags,			\
 		.table = _table,				\
 		.lock = _lock,					\
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 1f0285b..015f18c 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -279,7 +279,7 @@ struct clk_divider {
 	struct clk_hw	hw;
 	void __iomem	*reg;
 	u8		shift;
-	u8		width;
+	u32		mask;
 	u8		flags;
 	const struct clk_div_table	*table;
 	spinlock_t	*lock;
-- 
1.8.1.2

