Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaAXNZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:25:41 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49399 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaAXNZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:25:40 -0500
From: taikyung yu <taikyung.yu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: taikyung yu <taikyung.yu@gmail.com>
Subject: [PATCH] clk: samsung: pll: bugfix about segmentation fault
Date: Fri, 24 Jan 2014 05:24:15 -0800
Message-Id: <1390569855-22386-1-git-send-email-taikyung.yu@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init has pll initialization information. but it has local variable.
so it is just valid in samsung_clk_register_pll2550x() function.

Signed-off-by: taikyung yu <taikyung.yu@gmail.com>
---
 drivers/clk/samsung/clk-pll.c |   61 +++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 529e11d..c90808c 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -679,7 +679,7 @@ struct clk * __init samsung_clk_register_pll2550x(const char *name,
 {
 	struct samsung_clk_pll2550x *pll;
 	struct clk *clk;
-	struct clk_init_data init;
+	struct clk_init_data *init;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
 	if (!pll) {
@@ -687,13 +687,19 @@ struct clk * __init samsung_clk_register_pll2550x(const char *name,
 		return NULL;
 	}
 
-	init.name = name;
-	init.ops = &samsung_pll2550x_clk_ops;
-	init.flags = CLK_GET_RATE_NOCACHE;
-	init.parent_names = &pname;
-	init.num_parents = 1;
+	init = kzalloc(sizeof(*init), GFP_KERNEL);
+	if (!init) {
+		pr_err("%s: could not allocate pll init clk %s\n", __func__, name);
+		return NULL;
+	}
 
-	pll->hw.init = &init;
+	init->name = name;
+	init->ops = &samsung_pll2550x_clk_ops;
+	init->flags = CLK_GET_RATE_NOCACHE;
+	init->parent_names = &pname;
+	init->num_parents = 1;
+
+	pll->hw.init = init;
 	pll->reg_base = reg_base;
 	pll->offset = offset;
 
@@ -715,7 +721,7 @@ static void __init _samsung_clk_register_pll(struct samsung_pll_clock *pll_clk,
 {
 	struct samsung_clk_pll *pll;
 	struct clk *clk;
-	struct clk_init_data init;
+	struct clk_init_data *init;
 	int ret, len;
 
 	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
@@ -725,10 +731,17 @@ static void __init _samsung_clk_register_pll(struct samsung_pll_clock *pll_clk,
 		return;
 	}
 
-	init.name = pll_clk->name;
-	init.flags = pll_clk->flags;
-	init.parent_names = &pll_clk->parent_name;
-	init.num_parents = 1;
+	init = kzalloc(sizeof(*init), GFP_KERNEL);
+	if (!init) {
+		pr_err("%s: could not allocate pll init clk %s\n",
+			__func__, pll_clk->name);
+		return;
+	}
+
+	init->name = pll_clk->name;
+	init->flags = pll_clk->flags;
+	init->parent_names = &pll_clk->parent_name;
+	init->num_parents = 1;
 
 	if (pll_clk->rate_table) {
 		/* find count of rates in rate_table */
@@ -750,48 +763,48 @@ static void __init _samsung_clk_register_pll(struct samsung_pll_clock *pll_clk,
 	case pll_35xx:
 	case pll_2550:
 		if (!pll->rate_table)
-			init.ops = &samsung_pll35xx_clk_min_ops;
+			init->ops = &samsung_pll35xx_clk_min_ops;
 		else
-			init.ops = &samsung_pll35xx_clk_ops;
+			init->ops = &samsung_pll35xx_clk_ops;
 		break;
 	case pll_4500:
-		init.ops = &samsung_pll45xx_clk_min_ops;
+		init->ops = &samsung_pll45xx_clk_min_ops;
 		break;
 	case pll_4502:
 	case pll_4508:
 		if (!pll->rate_table)
-			init.ops = &samsung_pll45xx_clk_min_ops;
+			init->ops = &samsung_pll45xx_clk_min_ops;
 		else
-			init.ops = &samsung_pll45xx_clk_ops;
+			init->ops = &samsung_pll45xx_clk_ops;
 		break;
 	/* clk_ops for 36xx and 2650 are similar */
 	case pll_36xx:
 	case pll_2650:
 		if (!pll->rate_table)
-			init.ops = &samsung_pll36xx_clk_min_ops;
+			init->ops = &samsung_pll36xx_clk_min_ops;
 		else
-			init.ops = &samsung_pll36xx_clk_ops;
+			init->ops = &samsung_pll36xx_clk_ops;
 		break;
 	case pll_6552:
-		init.ops = &samsung_pll6552_clk_ops;
+		init->ops = &samsung_pll6552_clk_ops;
 		break;
 	case pll_6553:
-		init.ops = &samsung_pll6553_clk_ops;
+		init->ops = &samsung_pll6553_clk_ops;
 		break;
 	case pll_4600:
 	case pll_4650:
 	case pll_4650c:
 		if (!pll->rate_table)
-			init.ops = &samsung_pll46xx_clk_min_ops;
+			init->ops = &samsung_pll46xx_clk_min_ops;
 		else
-			init.ops = &samsung_pll46xx_clk_ops;
+			init->ops = &samsung_pll46xx_clk_ops;
 		break;
 	default:
 		pr_warn("%s: Unknown pll type for pll clk %s\n",
 			__func__, pll_clk->name);
 	}
 
-	pll->hw.init = &init;
+	pll->hw.init = init;
 	pll->type = pll_clk->type;
 	pll->lock_reg = base + pll_clk->lock_offset;
 	pll->con_reg = base + pll_clk->con_offset;
-- 
1.7.9.5

