Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaJGPXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:23:16 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56501 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbaJGPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:23:12 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Alex Elder <elder@linaro.org>, Matt Porter <mporter@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 6/8] clk: Change clk_ops->determine_rate to return a clk_hw as the best parent
Date: Tue,  7 Oct 2014 17:21:51 +0200
Message-Id: <1412695334-2608-7-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for clock providers to not have to deal with struct clk.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/at91/clk-programmable.c |  4 ++--
 drivers/clk/bcm/clk-kona.c          |  4 ++--
 drivers/clk/clk-composite.c         |  9 +++++----
 drivers/clk/clk.c                   | 11 +++++++----
 drivers/clk/hisilicon/clk-hi3620.c  |  2 +-
 drivers/clk/qcom/clk-rcg.c          | 20 ++++++++++++--------
 drivers/clk/qcom/clk-rcg2.c         | 28 +++++++++++++++++-----------
 drivers/clk/sunxi/clk-factors.c     |  4 ++--
 drivers/clk/sunxi/clk-sun6i-ar100.c |  4 ++--
 include/linux/clk-provider.h        |  4 ++--
 10 files changed, 52 insertions(+), 38 deletions(-)

diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index 62e2509..bbdb1b9 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -57,7 +57,7 @@ static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
 static long clk_programmable_determine_rate(struct clk_hw *hw,
 					    unsigned long rate,
 					    unsigned long *best_parent_rate,
-					    struct clk **best_parent_clk)
+					    struct clk_hw **best_parent_hw)
 {
 	struct clk *parent = NULL;
 	long best_rate = -EINVAL;
@@ -84,7 +84,7 @@ static long clk_programmable_determine_rate(struct clk_hw *hw,
 		if (best_rate < 0 || (rate - tmp_rate) < (rate - best_rate)) {
 			best_rate = tmp_rate;
 			*best_parent_rate = parent_rate;
-			*best_parent_clk = parent;
+			*best_parent_hw = __clk_get_hw(parent);
 		}
 
 		if (!best_rate)
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 95af2e6..1c06f6f 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1032,7 +1032,7 @@ static long kona_peri_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 static long kona_peri_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *best_parent_rate, struct clk **best_parent)
+		unsigned long *best_parent_rate, struct clk_hw **best_parent)
 {
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
 	struct clk *clk = hw->clk;
@@ -1075,7 +1075,7 @@ static long kona_peri_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
 		if (delta < best_delta) {
 			best_delta = delta;
 			best_rate = other_rate;
-			*best_parent = parent;
+			*best_parent = __clk_get_hw(parent);
 			*best_parent_rate = parent_rate;
 		}
 	}
diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
index b9355da..4386697 100644
--- a/drivers/clk/clk-composite.c
+++ b/drivers/clk/clk-composite.c
@@ -57,7 +57,7 @@ static unsigned long clk_composite_recalc_rate(struct clk_hw *hw,
 
 static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 					unsigned long *best_parent_rate,
-					struct clk **best_parent_p)
+					struct clk_hw **best_parent_p)
 {
 	struct clk_composite *composite = to_clk_composite(hw);
 	const struct clk_ops *rate_ops = composite->rate_ops;
@@ -80,8 +80,9 @@ static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 		*best_parent_p = NULL;
 
 		if (__clk_get_flags(hw->clk) & CLK_SET_RATE_NO_REPARENT) {
-			*best_parent_p = clk_get_parent(mux_hw->clk);
-			*best_parent_rate = __clk_get_rate(*best_parent_p);
+			parent = clk_get_parent(mux_hw->clk);
+			*best_parent_p = __clk_get_hw(parent);
+			*best_parent_rate = __clk_get_rate(parent);
 
 			return rate_ops->round_rate(rate_hw, rate,
 						    best_parent_rate);
@@ -103,7 +104,7 @@ static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 
 			if (!rate_diff || !*best_parent_p
 				       || best_rate_diff > rate_diff) {
-				*best_parent_p = parent;
+				*best_parent_p = __clk_get_hw(parent);
 				*best_parent_rate = parent_rate;
 				best_rate_diff = rate_diff;
 				best_rate = tmp_rate;
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index a344d3e..ae578ad 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -714,7 +714,7 @@ struct clk *__clk_lookup(const char *name)
  */
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
-			      struct clk **best_parent_p)
+			      struct clk_hw **best_parent_p)
 {
 	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
 	int i, num_parents;
@@ -750,7 +750,7 @@ long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 
 out:
 	if (best_parent)
-		*best_parent_p = best_parent;
+		*best_parent_p = best_parent->hw;
 	*best_parent_rate = best;
 
 	return best;
@@ -958,6 +958,7 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 {
 	unsigned long parent_rate = 0;
 	struct clk *parent;
+	struct clk_hw *parent_hw;
 
 	if (!clk)
 		return 0;
@@ -968,7 +969,7 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 
 	if (clk->ops->determine_rate)
 		return clk->ops->determine_rate(clk->hw, rate, &parent_rate,
-						&parent);
+						&parent_hw);
 	else if (clk->ops->round_rate)
 		return clk->ops->round_rate(clk->hw, rate, &parent_rate);
 	else if (clk->flags & CLK_SET_RATE_PARENT)
@@ -1357,6 +1358,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 {
 	struct clk *top = clk;
 	struct clk *old_parent, *parent;
+	struct clk_hw *parent_hw;
 	unsigned long best_parent_rate = 0;
 	unsigned long new_rate;
 	int p_index = 0;
@@ -1374,7 +1376,8 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 	if (clk->ops->determine_rate) {
 		new_rate = clk->ops->determine_rate(clk->hw, rate,
 						    &best_parent_rate,
-						    &parent);
+						    &parent_hw);
+		parent = parent_hw->clk;
 	} else if (clk->ops->round_rate) {
 		new_rate = clk->ops->round_rate(clk->hw, rate,
 						&best_parent_rate);
diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
index 339945d..480c24e 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -296,7 +296,7 @@ static unsigned long mmc_clk_recalc_rate(struct clk_hw *hw,
 
 static long mmc_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
-			      struct clk **best_parent_p)
+			      struct clk_hw **best_parent_p)
 {
 	struct clk_mmc *mclk = to_mmc(hw);
 	unsigned long best = 0;
diff --git a/drivers/clk/qcom/clk-rcg.c b/drivers/clk/qcom/clk-rcg.c
index b638c58..727cfca 100644
--- a/drivers/clk/qcom/clk-rcg.c
+++ b/drivers/clk/qcom/clk-rcg.c
@@ -375,16 +375,17 @@ struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
 
 static long _freq_tbl_determine_rate(struct clk_hw *hw,
 		const struct freq_tbl *f, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_hw **p_hw)
 {
 	unsigned long clk_flags;
+	struct clk *p;
 
 	f = find_freq(f, rate);
 	if (!f)
 		return -EINVAL;
 
 	clk_flags = __clk_get_flags(hw->clk);
-	*p = clk_get_parent_by_index(hw->clk, f->src);
+	p = clk_get_parent_by_index(hw->clk, f->src);
 	if (clk_flags & CLK_SET_RATE_PARENT) {
 		rate = rate * f->pre_div;
 		if (f->n) {
@@ -394,15 +395,16 @@ static long _freq_tbl_determine_rate(struct clk_hw *hw,
 			rate = tmp;
 		}
 	} else {
-		rate =  __clk_get_rate(*p);
+		rate =  __clk_get_rate(p);
 	}
+	*p_hw = __clk_get_hw(p);
 	*p_rate = rate;
 
 	return f->freq;
 }
 
 static long clk_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_rcg *rcg = to_clk_rcg(hw);
 
@@ -410,7 +412,7 @@ static long clk_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 static long clk_dyn_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
 
@@ -418,13 +420,15 @@ static long clk_dyn_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 static long clk_rcg_bypass_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_hw **p_hw)
 {
 	struct clk_rcg *rcg = to_clk_rcg(hw);
 	const struct freq_tbl *f = rcg->freq_tbl;
+	struct clk *p;
 
-	*p = clk_get_parent_by_index(hw->clk, f->src);
-	*p_rate = __clk_round_rate(*p, rate);
+	p = clk_get_parent_by_index(hw->clk, f->src);
+	*p_hw = __clk_get_hw(p);
+	*p_rate = __clk_round_rate(p, rate);
 
 	return *p_rate;
 }
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index cd185d5..368862d 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -188,16 +188,17 @@ struct freq_tbl *find_freq(const struct freq_tbl *f, unsigned long rate)
 
 static long _freq_tbl_determine_rate(struct clk_hw *hw,
 		const struct freq_tbl *f, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_hw **p_hw)
 {
 	unsigned long clk_flags;
+	struct clk *p;
 
 	f = find_freq(f, rate);
 	if (!f)
 		return -EINVAL;
 
 	clk_flags = __clk_get_flags(hw->clk);
-	*p = clk_get_parent_by_index(hw->clk, f->src);
+	p = clk_get_parent_by_index(hw->clk, f->src);
 	if (clk_flags & CLK_SET_RATE_PARENT) {
 		if (f->pre_div) {
 			rate /= 2;
@@ -211,15 +212,16 @@ static long _freq_tbl_determine_rate(struct clk_hw *hw,
 			rate = tmp;
 		}
 	} else {
-		rate =  __clk_get_rate(*p);
+		rate =  __clk_get_rate(p);
 	}
+	*p_hw = __clk_get_hw(p);
 	*p_rate = rate;
 
 	return f->freq;
 }
 
 static long clk_rcg2_determine_rate(struct clk_hw *hw, unsigned long rate,
-		unsigned long *p_rate, struct clk **p)
+		unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 
@@ -372,7 +374,7 @@ static int clk_edp_pixel_set_rate_and_parent(struct clk_hw *hw,
 }
 
 static long clk_edp_pixel_determine_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *p_rate, struct clk **p)
+				 unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	const struct freq_tbl *f = rcg->freq_tbl;
@@ -384,7 +386,7 @@ static long clk_edp_pixel_determine_rate(struct clk_hw *hw, unsigned long rate,
 	u32 hid_div;
 
 	/* Force the correct parent */
-	*p = clk_get_parent_by_index(hw->clk, f->src);
+	*p = __clk_get_hw(clk_get_parent_by_index(hw->clk, f->src));
 
 	if (src_rate == 810000000)
 		frac = frac_table_810m;
@@ -423,18 +425,20 @@ const struct clk_ops clk_edp_pixel_ops = {
 EXPORT_SYMBOL_GPL(clk_edp_pixel_ops);
 
 static long clk_byte_determine_rate(struct clk_hw *hw, unsigned long rate,
-			 unsigned long *p_rate, struct clk **p)
+			 unsigned long *p_rate, struct clk_hw **p_hw)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	const struct freq_tbl *f = rcg->freq_tbl;
 	unsigned long parent_rate, div;
 	u32 mask = BIT(rcg->hid_width) - 1;
+	struct clk *p;
 
 	if (rate == 0)
 		return -EINVAL;
 
-	*p = clk_get_parent_by_index(hw->clk, f->src);
-	*p_rate = parent_rate = __clk_round_rate(*p, rate);
+	p = clk_get_parent_by_index(hw->clk, f->src);
+	*p_hw = __clk_get_hw(p);
+	*p_rate = parent_rate = __clk_round_rate(p, rate);
 
 	div = DIV_ROUND_UP((2 * parent_rate), rate) - 1;
 	div = min_t(u32, div, mask);
@@ -485,14 +489,16 @@ static const struct frac_entry frac_table_pixel[] = {
 };
 
 static long clk_pixel_determine_rate(struct clk_hw *hw, unsigned long rate,
-				 unsigned long *p_rate, struct clk **p)
+				 unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
 	unsigned long request, src_rate;
 	int delta = 100000;
 	const struct freq_tbl *f = rcg->freq_tbl;
 	const struct frac_entry *frac = frac_table_pixel;
-	struct clk *parent = *p = clk_get_parent_by_index(hw->clk, f->src);
+	struct clk *parent = clk_get_parent_by_index(hw->clk, f->src);
+
+	*p = __clk_get_hw(parent);
 
 	for (; frac->num; frac++) {
 		request = (rate * frac->den) / frac->num;
diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
index 2057c8a..6296230 100644
--- a/drivers/clk/sunxi/clk-factors.c
+++ b/drivers/clk/sunxi/clk-factors.c
@@ -79,7 +79,7 @@ static long clk_factors_round_rate(struct clk_hw *hw, unsigned long rate,
 
 static long clk_factors_determine_rate(struct clk_hw *hw, unsigned long rate,
 				       unsigned long *best_parent_rate,
-				       struct clk **best_parent_p)
+				       struct clk_hw **best_parent_p)
 {
 	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
 	int i, num_parents;
@@ -106,7 +106,7 @@ static long clk_factors_determine_rate(struct clk_hw *hw, unsigned long rate,
 	}
 
 	if (best_parent)
-		*best_parent_p = best_parent;
+		*best_parent_p = __clk_get_hw(best_parent);
 	*best_parent_rate = best;
 
 	return best_child_rate;
diff --git a/drivers/clk/sunxi/clk-sun6i-ar100.c b/drivers/clk/sunxi/clk-sun6i-ar100.c
index eca8ca0..caa42d3 100644
--- a/drivers/clk/sunxi/clk-sun6i-ar100.c
+++ b/drivers/clk/sunxi/clk-sun6i-ar100.c
@@ -46,7 +46,7 @@ static unsigned long ar100_recalc_rate(struct clk_hw *hw,
 
 static long ar100_determine_rate(struct clk_hw *hw, unsigned long rate,
 				 unsigned long *best_parent_rate,
-				 struct clk **best_parent_clk)
+				 struct clk_hw **best_parent_clk)
 {
 	int nparents = __clk_get_num_parents(hw->clk);
 	long best_rate = -EINVAL;
@@ -100,7 +100,7 @@ static long ar100_determine_rate(struct clk_hw *hw, unsigned long rate,
 
 		tmp_rate = (parent_rate >> shift) / div;
 		if (!*best_parent_clk || tmp_rate > best_rate) {
-			*best_parent_clk = parent;
+			*best_parent_clk = __clk_get_hw(parent);
 			*best_parent_rate = parent_rate;
 			best_rate = tmp_rate;
 		}
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 37bd7a5..eec7316 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -167,7 +167,7 @@ struct clk_ops {
 					unsigned long *parent_rate);
 	long		(*determine_rate)(struct clk_hw *hw, unsigned long rate,
 					unsigned long *best_parent_rate,
-					struct clk **best_parent_clk);
+					struct clk_hw **best_parent_hw);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
 	u8		(*get_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long rate,
@@ -519,7 +519,7 @@ bool __clk_is_enabled(struct clk *clk);
 struct clk *__clk_lookup(const char *name);
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
-			      struct clk **best_parent_p);
+			      struct clk_hw **best_parent_p);
 
 /*
  * FIXME clock api without lock protection
-- 
1.9.3

