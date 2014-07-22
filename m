Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaGVCVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:21:05 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33255 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaGVCVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:21:01 -0400
From: Charles Manning <cdhmanning@gmail.com>
To: linux-kernel@vger.kernel.org, s.trumtrar@pengutronix.de,
        dinguyen@altera.com, cslee@altera.com
Cc: Charles Manning <cdhmanning@gmail.com>
Subject: [PATCH 3/3] clk: socfpga Change name look-up to not use the init pointer
Date: Tue, 22 Jul 2014 14:20:34 +1200
Message-Id: <1405995634-3297-4-git-send-email-cdhmanning@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
References: <1405995634-3297-1-git-send-email-cdhmanning@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init pointer is not valid after clk_register so we store
the names with the socfpga clock structures so we can look them up.

Signed-off-by: Charles Manning <cdhmanning@gmail.com>
---
 drivers/clk/socfpga/clk-gate.c   | 44 ++++++++++++++++++++++++++--------------
 drivers/clk/socfpga/clk-periph.c | 16 ++++++++++-----
 drivers/clk/socfpga/clk-pll.c    | 13 ++++++++----
 drivers/clk/socfpga/clk.h        |  7 ++++---
 4 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/drivers/clk/socfpga/clk-gate.c b/drivers/clk/socfpga/clk-gate.c
index dd3a78c..a319f01 100644
--- a/drivers/clk/socfpga/clk-gate.c
+++ b/drivers/clk/socfpga/clk-gate.c
@@ -34,7 +34,10 @@
 
 #define streq(a, b) (strcmp((a), (b)) == 0)
 
-#define to_socfpga_gate_clk(p) container_of(p, struct socfpga_gate_clk, hw.hw)
+#define to_socfpga_gate_clk(p) \
+		container_of(p, struct socfpga_gate_clk, base.hw.hw)
+#define to_socfpga_base_clk(p) \
+		container_of(p, struct socfpga_base_clk, hw.hw)
 
 /* SDMMC Group for System Manager defines */
 #define SYSMGR_SDMMCGRP_CTRL_OFFSET    0x108
@@ -45,21 +48,24 @@ static u8 socfpga_clk_get_parent(struct clk_hw *hwclk)
 {
 	u32 l4_src;
 	u32 perpll_src;
+	struct socfpga_base_clk *base_clk;
 
-	if (streq(hwclk->init->name, SOCFPGA_L4_MP_CLK)) {
+	base_clk = to_socfpga_base_clk(hwclk);
+
+	if (streq(base_clk->name, SOCFPGA_L4_MP_CLK)) {
 		l4_src = readl(clk_mgr_base_addr + CLKMGR_L4SRC);
 		return l4_src &= 0x1;
 	}
-	if (streq(hwclk->init->name, SOCFPGA_L4_SP_CLK)) {
+	if (streq(base_clk->name, SOCFPGA_L4_SP_CLK)) {
 		l4_src = readl(clk_mgr_base_addr + CLKMGR_L4SRC);
 		return !!(l4_src & 2);
 	}
 
 	perpll_src = readl(clk_mgr_base_addr + CLKMGR_PERPLL_SRC);
-	if (streq(hwclk->init->name, SOCFPGA_MMC_CLK))
+	if (streq(base_clk->name, SOCFPGA_MMC_CLK))
 		return perpll_src &= 0x3;
-	if (streq(hwclk->init->name, SOCFPGA_NAND_CLK) ||
-			streq(hwclk->init->name, SOCFPGA_NAND_X_CLK))
+	if (streq(base_clk->name, SOCFPGA_NAND_CLK) ||
+			streq(base_clk->name, SOCFPGA_NAND_X_CLK))
 			return (perpll_src >> 2) & 3;
 
 	/* QSPI clock */
@@ -70,24 +76,27 @@ static u8 socfpga_clk_get_parent(struct clk_hw *hwclk)
 static int socfpga_clk_set_parent(struct clk_hw *hwclk, u8 parent)
 {
 	u32 src_reg;
+	struct socfpga_base_clk *base_clk;
+
+	base_clk = to_socfpga_base_clk(hwclk);
 
-	if (streq(hwclk->init->name, SOCFPGA_L4_MP_CLK)) {
+	if (streq(base_clk->name, SOCFPGA_L4_MP_CLK)) {
 		src_reg = readl(clk_mgr_base_addr + CLKMGR_L4SRC);
 		src_reg &= ~0x1;
 		src_reg |= parent;
 		writel(src_reg, clk_mgr_base_addr + CLKMGR_L4SRC);
-	} else if (streq(hwclk->init->name, SOCFPGA_L4_SP_CLK)) {
+	} else if (streq(base_clk->name, SOCFPGA_L4_SP_CLK)) {
 		src_reg = readl(clk_mgr_base_addr + CLKMGR_L4SRC);
 		src_reg &= ~0x2;
 		src_reg |= (parent << 1);
 		writel(src_reg, clk_mgr_base_addr + CLKMGR_L4SRC);
 	} else {
 		src_reg = readl(clk_mgr_base_addr + CLKMGR_PERPLL_SRC);
-		if (streq(hwclk->init->name, SOCFPGA_MMC_CLK)) {
+		if (streq(base_clk->name, SOCFPGA_MMC_CLK)) {
 			src_reg &= ~0x3;
 			src_reg |= parent;
-		} else if (streq(hwclk->init->name, SOCFPGA_NAND_CLK) ||
-			streq(hwclk->init->name, SOCFPGA_NAND_X_CLK)) {
+		} else if (streq(base_clk->name, SOCFPGA_NAND_CLK) ||
+			streq(base_clk->name, SOCFPGA_NAND_X_CLK)) {
 			src_reg &= ~0xC;
 			src_reg |= (parent << 2);
 		} else {/* QSPI clock */
@@ -205,8 +214,8 @@ static void __init __socfpga_gate_init(struct device_node *node,
 		clk_gate[0] = 0;
 
 	if (clk_gate[0]) {
-		socfpga_clk->hw.reg = clk_mgr_base_addr + clk_gate[0];
-		socfpga_clk->hw.bit_idx = clk_gate[1];
+		socfpga_clk->base.hw.reg = clk_mgr_base_addr + clk_gate[0];
+		socfpga_clk->base.hw.bit_idx = clk_gate[1];
 
 		gateclk_ops.enable = clk_gate_ops.enable;
 		gateclk_ops.disable = clk_gate_ops.disable;
@@ -244,9 +253,14 @@ static void __init __socfpga_gate_init(struct device_node *node,
 
 	init.parent_names = parent_name;
 	init.num_parents = i;
-	socfpga_clk->hw.hw.init = &init;
+	socfpga_clk->base.hw.hw.init = &init;
+	socfpga_clk->base.name = kstrdup(clk_name, GFP_KERNEL);
+	if (WARN_ON(!socfpga_clk->base.name)) {
+		kfree(socfpga_clk);
+		return;
+	}
 
-	clk = clk_register(NULL, &socfpga_clk->hw.hw);
+	clk = clk_register(NULL, &socfpga_clk->base.hw.hw);
 	if (WARN_ON(IS_ERR(clk))) {
 		kfree(socfpga_clk);
 		return;
diff --git a/drivers/clk/socfpga/clk-periph.c b/drivers/clk/socfpga/clk-periph.c
index 46531c3..df2fd2c 100644
--- a/drivers/clk/socfpga/clk-periph.c
+++ b/drivers/clk/socfpga/clk-periph.c
@@ -23,7 +23,8 @@
 
 #include "clk.h"
 
-#define to_socfpga_periph_clk(p) container_of(p, struct socfpga_periph_clk, hw.hw)
+#define to_socfpga_periph_clk(p) \
+		container_of(p, struct socfpga_periph_clk, base.hw.hw)
 
 static unsigned long clk_periclk_recalc_rate(struct clk_hw *hwclk,
 					     unsigned long parent_rate)
@@ -39,7 +40,7 @@ static unsigned long clk_periclk_recalc_rate(struct clk_hw *hwclk,
 			val &= div_mask(socfpgaclk->width);
 			parent_rate /= (val + 1);
 		}
-		div = ((readl(socfpgaclk->hw.reg) & 0x1ff) + 1);
+		div = ((readl(socfpgaclk->base.hw.reg) & 0x1ff) + 1);
 	}
 
 	return parent_rate / div;
@@ -68,7 +69,7 @@ static __init void __socfpga_periph_init(struct device_node *node,
 	if (WARN_ON(!periph_clk))
 		return;
 
-	periph_clk->hw.reg = clk_mgr_base_addr + reg;
+	periph_clk->base.hw.reg = clk_mgr_base_addr + reg;
 
 	rc = of_property_read_u32_array(node, "div-reg", div_reg, 3);
 	if (!rc) {
@@ -94,9 +95,14 @@ static __init void __socfpga_periph_init(struct device_node *node,
 	init.parent_names = &parent_name;
 	init.num_parents = 1;
 
-	periph_clk->hw.hw.init = &init;
+	periph_clk->base.hw.hw.init = &init;
+	periph_clk->base.name = kstrdup(clk_name, GFP_KERNEL);
+	if (WARN_ON(!periph_clk->base.name)) {
+		kfree(periph_clk);
+		return;
+	}
 
-	clk = clk_register(NULL, &periph_clk->hw.hw);
+	clk = clk_register(NULL, &periph_clk->base.hw.hw);
 	if (WARN_ON(IS_ERR(clk))) {
 		kfree(periph_clk);
 		return;
diff --git a/drivers/clk/socfpga/clk-pll.c b/drivers/clk/socfpga/clk-pll.c
index de6da95..d48f637 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -42,14 +42,14 @@
 #define CLK_MGR_PLL_CLK_SRC_SHIFT	22
 #define CLK_MGR_PLL_CLK_SRC_MASK	0x3
 
-#define to_socfpga_clk(p) container_of(p, struct socfpga_pll, hw.hw)
+#define to_socfpga_clk(p) container_of(p, struct socfpga_base_clk, hw.hw)
 
 void __iomem *clk_mgr_base_addr;
 
 static unsigned long clk_pll_recalc_rate(struct clk_hw *hwclk,
 					 unsigned long parent_rate)
 {
-	struct socfpga_pll *socfpgaclk = to_socfpga_clk(hwclk);
+	struct socfpga_base_clk *socfpgaclk = to_socfpga_clk(hwclk);
 	unsigned long divf, divq, reg;
 	unsigned long long vco_freq;
 	unsigned long bypass;
@@ -69,7 +69,7 @@ static unsigned long clk_pll_recalc_rate(struct clk_hw *hwclk,
 static u8 clk_pll_get_parent(struct clk_hw *hwclk)
 {
 	u32 pll_src;
-	struct socfpga_pll *socfpgaclk = to_socfpga_clk(hwclk);
+	struct socfpga_base_clk *socfpgaclk = to_socfpga_clk(hwclk);
 
 	pll_src = readl(socfpgaclk->hw.reg);
 	return (pll_src >> CLK_MGR_PLL_CLK_SRC_SHIFT) &
@@ -86,7 +86,7 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 {
 	u32 reg;
 	struct clk *clk;
-	struct socfpga_pll *pll_clk;
+	struct socfpga_base_clk *pll_clk;
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
 	struct clk_init_data init;
@@ -118,6 +118,11 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 	init.num_parents = i;
 	init.parent_names = parent_name;
 	pll_clk->hw.hw.init = &init;
+	pll_clk->name = kstrdup(clk_name, GFP_KERNEL);
+	if (WARN_ON(!pll_clk->name)) {
+		kfree(pll_clk);
+		return NULL;
+	}
 
 	pll_clk->hw.bit_idx = SOCFPGA_PLL_EXT_ENA;
 	clk_pll_ops.enable = clk_gate_ops.enable;
diff --git a/drivers/clk/socfpga/clk.h b/drivers/clk/socfpga/clk.h
index d291f60..c2d058c 100644
--- a/drivers/clk/socfpga/clk.h
+++ b/drivers/clk/socfpga/clk.h
@@ -35,12 +35,13 @@ void __init socfpga_pll_init(struct device_node *node);
 void __init socfpga_periph_init(struct device_node *node);
 void __init socfpga_gate_init(struct device_node *node);
 
-struct socfpga_pll {
+struct socfpga_base_clk {
+	const char *name;
 	struct clk_gate	hw;
 };
 
 struct socfpga_gate_clk {
-	struct clk_gate hw;
+	struct socfpga_base_clk base;
 	char *parent_name;
 	u32 fixed_div;
 	void __iomem *div_reg;
@@ -50,7 +51,7 @@ struct socfpga_gate_clk {
 };
 
 struct socfpga_periph_clk {
-	struct clk_gate hw;
+	struct socfpga_base_clk base;
 	char *parent_name;
 	u32 fixed_div;
 	void __iomem *div_reg;
-- 
1.9.1

