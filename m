Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbaKSXQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:16:08 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39404 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaKSXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:01 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Tero Kristo <t-kristo@ti.com>, linux-omap@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH 01/15] clk: divider: replace bitfield width with mask
Date: Wed, 19 Nov 2014 23:15:29 +0000
Message-Id: <1416438943-11429-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Turquette <mturquette@linaro.org>

The forthcoming Device Tree binding for the divider clock type will use
a bitfield mask instead of bitfield width, which is what the current
basic divider implementation uses.

This patch replaces the u8 width in struct clk_divider with a u32 mask.
The divider code is updated to use the bit mask internally but the two
registration functions still accept the width to maintain compatibility
with existing users.

Also updated in this patch is the clk-private.h divider macro and
various clock divider implementations that are based on struct
clk_divider.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
[james.hogan@imgtec.com: forward port, fix new uses of width]
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Cc: "Emilio López" <emilio@elopez.com.ar>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org
---
Changes since original:
- Forward ported
- Adjust new div_mask from recent patch "clk-divider: Fix READ_ONLY when
  divider > 1"
- Updated assignment of clk_divider::width in imx, rockchip, st, sunxi,
  ti clock components to use mask instead (not tested), using the
  following semantic patch:

virtual context
virtual patch

@depends on context@
struct clk_divider clk;
expression e;
@@
*clk.width = e

@depends on patch@
struct clk_divider clk;
expression e;
@@
-clk.width = fls(e)
+clk.mask = e

@depends on patch@
struct clk_divider *clk;
expression e;
@@
-clk->width = fls(e)
+clk->mask = e

@depends on patch@
struct clk_divider clk;
expression e;
@@
-clk.width = e
+clk.mask = BIT(e) - 1

@depends on patch@
struct clk_divider *clk;
expression e;
@@
-clk->width = e
+clk->mask = BIT(e) - 1
---
 arch/arm/mach-imx/clk-busy.c      |  2 +-
 arch/arm/mach-imx/clk-fixup-div.c |  2 +-
 drivers/clk/clk-divider.c         | 33 ++++++++++++++++-----------------
 drivers/clk/mxs/clk-div.c         |  2 +-
 drivers/clk/rockchip/clk.c        |  2 +-
 drivers/clk/st/clk-flexgen.c      |  4 ++--
 drivers/clk/st/clkgen-mux.c       |  4 ++--
 drivers/clk/st/clkgen-pll.c       |  2 +-
 drivers/clk/sunxi/clk-sunxi.c     |  2 +-
 drivers/clk/ti/divider.c          |  2 +-
 include/linux/clk-private.h       |  2 +-
 include/linux/clk-provider.h      |  2 +-
 12 files changed, 29 insertions(+), 30 deletions(-)

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
 
diff --git a/arch/arm/mach-imx/clk-fixup-div.c b/arch/arm/mach-imx/clk-fixup-div.c
index 21db020..af33b7a 100644
--- a/arch/arm/mach-imx/clk-fixup-div.c
+++ b/arch/arm/mach-imx/clk-fixup-div.c
@@ -115,7 +115,7 @@ struct clk *imx_clk_fixup_divider(const char *name, const char *parent,
 
 	fixup_div->divider.reg = reg;
 	fixup_div->divider.shift = shift;
-	fixup_div->divider.width = width;
+	fixup_div->divider.mask = BIT(width) - 1;
 	fixup_div->divider.lock = &imx_ccm_lock;
 	fixup_div->divider.hw.init = &init;
 	fixup_div->ops = &clk_divider_ops;
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index c0a842b..a432cf8 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -30,8 +30,6 @@
 
 #define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
 
-#define div_mask(d)	((1 << ((d)->width)) - 1)
-
 static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
 {
 	unsigned int maxdiv = 0;
@@ -57,12 +55,12 @@ static unsigned int _get_table_mindiv(const struct clk_div_table *table)
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
@@ -116,7 +114,7 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 	unsigned int div, val;
 
 	val = clk_readl(divider->reg) >> divider->shift;
-	val &= div_mask(divider);
+	val &= divider->mask;
 
 	div = _get_div(divider, val);
 	if (!div) {
@@ -266,7 +264,7 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	/* if read only, just return current value */
 	if (divider->flags & CLK_DIVIDER_READ_ONLY) {
 		bestdiv = readl(divider->reg) >> divider->shift;
-		bestdiv &= div_mask(divider);
+		bestdiv &= divider->mask;
 		bestdiv = _get_div(divider, bestdiv);
 		return bestdiv;
 	}
@@ -341,17 +339,17 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 
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
 		val = clk_readl(divider->reg);
-		val &= ~(div_mask(divider) << divider->shift);
+		val &= ~(divider->mask << divider->shift);
 	}
 	val |= value << divider->shift;
 	clk_writel(val, divider->reg);
@@ -371,7 +369,7 @@ EXPORT_SYMBOL_GPL(clk_divider_ops);
 
 static struct clk *_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 shift, u8 width,
+		void __iomem *reg, u8 shift, u32 mask,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock)
 {
@@ -380,8 +378,9 @@ static struct clk *_register_divider(struct device *dev, const char *name,
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
@@ -402,7 +401,7 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 	/* struct clk_divider assignments */
 	div->reg = reg;
 	div->shift = shift;
-	div->width = width;
+	div->mask = mask;
 	div->flags = clk_divider_flags;
 	div->lock = lock;
 	div->hw.init = &init;
@@ -435,7 +434,7 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
 		u8 clk_divider_flags, spinlock_t *lock)
 {
 	return _register_divider(dev, name, parent_name, flags, reg, shift,
-			width, clk_divider_flags, NULL, lock);
+			((1 << width) - 1), clk_divider_flags, NULL, lock);
 }
 EXPORT_SYMBOL_GPL(clk_register_divider);
 
@@ -460,6 +459,6 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
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
diff --git a/drivers/clk/rockchip/clk.c b/drivers/clk/rockchip/clk.c
index 880a266..9024a0e 100644
--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -87,7 +87,7 @@ static struct clk *rockchip_clk_register_branch(const char *name,
 		div->flags = div_flags;
 		div->reg = base + muxdiv_offset;
 		div->shift = div_shift;
-		div->width = div_width;
+		div->mask = BIT(div_width) - 1;
 		div->lock = lock;
 		div->table = div_table;
 		div_ops = &clk_divider_ops;
diff --git a/drivers/clk/st/clk-flexgen.c b/drivers/clk/st/clk-flexgen.c
index 2282cef..603d5d6 100644
--- a/drivers/clk/st/clk-flexgen.c
+++ b/drivers/clk/st/clk-flexgen.c
@@ -203,7 +203,7 @@ struct clk *clk_register_flexgen(const char *name,
 	/* Pre-divider config */
 	fgxbar->pdiv.lock = lock;
 	fgxbar->pdiv.reg = reg + 0x58 + idx * 4;
-	fgxbar->pdiv.width = 10;
+	fgxbar->pdiv.mask = BIT(10) - 1;
 
 	/* Final divider's gate config */
 	fgxbar->fgate.lock = lock;
@@ -213,7 +213,7 @@ struct clk *clk_register_flexgen(const char *name,
 	/* Final divider config */
 	fgxbar->fdiv.lock = lock;
 	fgxbar->fdiv.reg = fdiv_reg;
-	fgxbar->fdiv.width = 6;
+	fgxbar->fdiv.mask = BIT(6) - 1;
 
 	fgxbar->hw.init = &init;
 
diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
index 79dc40b..85a1165 100644
--- a/drivers/clk/st/clkgen-mux.c
+++ b/drivers/clk/st/clkgen-mux.c
@@ -260,7 +260,7 @@ struct clk *clk_register_genamux(const char *name,
 		 * Divider config for each input
 		 */
 		void __iomem *divbase = reg + muxdata->div_offsets[i];
-		genamux->div[i].width = divider_width;
+		genamux->div[i].mask = BIT(divider_width) - 1;
 		genamux->div[i].reg = divbase + (idx * sizeof(u32));
 
 		/*
@@ -773,7 +773,7 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
 
 		div->reg = reg + VCC_DIV_OFFSET;
 		div->shift = 2 * i;
-		div->width = 2;
+		div->mask = BIT(2) - 1;
 		div->flags = CLK_DIVIDER_POWER_OF_TWO |
 			CLK_DIVIDER_ROUND_CLOSEST;
 
diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
index 29769d7..0d76278 100644
--- a/drivers/clk/st/clkgen-pll.c
+++ b/drivers/clk/st/clkgen-pll.c
@@ -575,7 +575,7 @@ static struct clk * __init clkgen_odf_register(const char *parent_name,
 	div->flags = CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO;
 	div->reg = reg + pll_data->odf[odf].offset;
 	div->shift = pll_data->odf[odf].shift;
-	div->width = fls(pll_data->odf[odf].mask);
+	div->mask = pll_data->odf[odf].mask;
 	div->lock = odf_lock;
 
 	clk = clk_register_composite(NULL, odf_name, &parent_name, 1,
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index d5dc951..a23d393 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1015,7 +1015,7 @@ static void __init sunxi_divs_clk_setup(struct device_node *node,
 
 			divider->reg = reg;
 			divider->shift = data->div[i].shift;
-			divider->width = SUNXI_DIVISOR_WIDTH;
+			divider->mask = BIT(SUNXI_DIVISOR_WIDTH) - 1;
 			divider->flags = flags;
 			divider->lock = &clk_lock;
 			divider->table = data->div[i].table;
diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index bff2b5b..c27e01e 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -285,7 +285,7 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 	/* struct clk_divider assignments */
 	div->reg = reg;
 	div->shift = shift;
-	div->width = width;
+	div->mask = BIT(width) - 1;
 	div->flags = clk_divider_flags;
 	div->lock = lock;
 	div->hw.init = &init;
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 0ca5f60..40bc1b2 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -130,7 +130,7 @@ struct clk {
 		},						\
 		.reg = _reg,					\
 		.shift = _shift,				\
-		.width = _width,				\
+		.mask = ((1 << _width) - 1),			\
 		.flags = _divider_flags,			\
 		.table = _table,				\
 		.lock = _lock,					\
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 2839c63..2c00215 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -338,7 +338,7 @@ struct clk_divider {
 	struct clk_hw	hw;
 	void __iomem	*reg;
 	u8		shift;
-	u8		width;
+	u32		mask;
 	u8		flags;
 	const struct clk_div_table	*table;
 	spinlock_t	*lock;
-- 
2.0.4

