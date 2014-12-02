Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaLBH5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:57:24 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37621 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbaLBH5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:57:21 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Jonathan Corbet <corbet@lwn.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Tero Kristo <t-kristo@ti.com>, Manuel Lauss <manuel.lauss@gmail.com>,
        Alex Elder <elder@linaro.org>, Matt Porter <mporter@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        Bintian Wang <bintian.wang@huawei.com>,
        Chao Xie <chao.xie@marvell.com>, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org
Subject: [PATCH v7 7/7] clk: Add floor and ceiling constraints to clock rates
Date: Tue,  2 Dec 2014 08:54:24 +0100
Message-Id: <1417506933-8915-8-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a way for clock consumers to set maximum and minimum rates. This can be
used for thermal drivers to set ceiling rates, or by misc. drivers to set
floor rates to assure a minimum performance level.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---
v7:	* Update a few more instances in new code

v6:	* Take the prepare lock before removing a per-user clk
	* Init per-user clks list before adding the first clk
	* Pass the constraints to determine_rate and let clk
	  implementations deal with constraints
	* Add clk_set_rate_range

v5:	* Initialize clk.ceiling_constraint to ULONG_MAX
	* Warn about inconsistent constraints

v4:	* Copy function docs from header
	* Move WARN out of critical section
	* Refresh rate after removing a per-user clk
	* Rename clk_core.per_user_clks to clk_core.clks
	* Store requested rate and re-apply it when constraints are updated
---
 Documentation/clk.txt               |   2 +
 arch/arm/mach-omap2/dpll3xxx.c      |   2 +
 arch/arm/mach-omap2/dpll44xx.c      |   2 +
 arch/mips/alchemy/common/clock.c    |   8 ++
 drivers/clk/at91/clk-programmable.c |   2 +
 drivers/clk/bcm/clk-kona.c          |   2 +
 drivers/clk/clk-composite.c         |   9 +-
 drivers/clk/clk.c                   | 160 +++++++++++++++++++++++++++++-------
 drivers/clk/hisilicon/clk-hi3620.c  |   2 +
 drivers/clk/mmp/clk-mix.c           |   2 +
 drivers/clk/qcom/clk-pll.c          |   1 +
 drivers/clk/qcom/clk-rcg.c          |  10 ++-
 drivers/clk/qcom/clk-rcg2.c         |   6 ++
 drivers/clk/sunxi/clk-factors.c     |   2 +
 drivers/clk/sunxi/clk-sun6i-ar100.c |   2 +
 include/linux/clk-private.h         |   6 ++
 include/linux/clk-provider.h        |  11 ++-
 include/linux/clk.h                 |  28 +++++++
 include/linux/clk/ti.h              |   4 +
 19 files changed, 224 insertions(+), 37 deletions(-)

diff --git a/Documentation/clk.txt b/Documentation/clk.txt
index 4ff8462..8ebd665 100644
--- a/Documentation/clk.txt
+++ b/Documentation/clk.txt
@@ -73,6 +73,8 @@ the operations defined in clk.h:
 						unsigned long *parent_rate);
 		long		(*determine_rate)(struct clk_hw *hw,
 						unsigned long rate,
+						unsigned long floor_rate,
+						unsigned long ceiling_rate,
 						unsigned long *best_parent_rate,
 						struct clk_hw **best_parent_clk);
 		int		(*set_parent)(struct clk_hw *hw, u8 index);
diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index c2da2a0..b25375c 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -473,6 +473,8 @@ void omap3_noncore_dpll_disable(struct clk_hw *hw)
  * in failure.
  */
 long omap3_noncore_dpll_determine_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long floor_rate,
+				       unsigned long ceiling_rate,
 				       unsigned long *best_parent_rate,
 				       struct clk_hw **best_parent_clk)
 {
diff --git a/arch/arm/mach-omap2/dpll44xx.c b/arch/arm/mach-omap2/dpll44xx.c
index 0e58e5a..579fa18 100644
--- a/arch/arm/mach-omap2/dpll44xx.c
+++ b/arch/arm/mach-omap2/dpll44xx.c
@@ -222,6 +222,8 @@ out:
  * in failure.
  */
 long omap4_dpll_regm4xen_determine_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long floor_rate,
+					unsigned long ceiling_rate,
 					unsigned long *best_parent_rate,
 					struct clk_hw **best_parent_clk)
 {
diff --git a/arch/mips/alchemy/common/clock.c b/arch/mips/alchemy/common/clock.c
index 48a9dfc..731bedd 100644
--- a/arch/mips/alchemy/common/clock.c
+++ b/arch/mips/alchemy/common/clock.c
@@ -373,6 +373,8 @@ static long alchemy_calc_div(unsigned long rate, unsigned long prate,
 }
 
 static long alchemy_clk_fgcs_detr(struct clk_hw *hw, unsigned long rate,
+					unsigned long floor_rate,
+					unsigned long ceiling_rate,
 					unsigned long *best_parent_rate,
 					struct clk_hw **best_parent_clk,
 					int scale, int maxdiv)
@@ -546,6 +548,8 @@ static unsigned long alchemy_clk_fgv1_recalc(struct clk_hw *hw,
 }
 
 static long alchemy_clk_fgv1_detr(struct clk_hw *hw, unsigned long rate,
+					unsigned long floor_rate,
+					unsigned long ceiling_rate,
 					unsigned long *best_parent_rate,
 					struct clk_hw **best_parent_clk)
 {
@@ -678,6 +682,8 @@ static unsigned long alchemy_clk_fgv2_recalc(struct clk_hw *hw,
 }
 
 static long alchemy_clk_fgv2_detr(struct clk_hw *hw, unsigned long rate,
+					unsigned long floor_rate,
+					unsigned long ceiling_rate,
 					unsigned long *best_parent_rate,
 					struct clk_hw **best_parent_clk)
 {
@@ -897,6 +903,8 @@ static int alchemy_clk_csrc_setr(struct clk_hw *hw, unsigned long rate,
 }
 
 static long alchemy_clk_csrc_detr(struct clk_hw *hw, unsigned long rate,
+					unsigned long floor_rate,
+					unsigned long ceiling_rate,
 					unsigned long *best_parent_rate,
 					struct clk_hw **best_parent_clk)
 {
diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index bbdb1b9..e0b0f34 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -56,6 +56,8 @@ static unsigned long clk_programmable_recalc_rate(struct clk_hw *hw,
 
 static long clk_programmable_determine_rate(struct clk_hw *hw,
 					    unsigned long rate,
+					    unsigned long floor_rate,
+					    unsigned long ceiling_rate,
 					    unsigned long *best_parent_rate,
 					    struct clk_hw **best_parent_hw)
 {
diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
index 1c06f6f..40bbdd6 100644
--- a/drivers/clk/bcm/clk-kona.c
+++ b/drivers/clk/bcm/clk-kona.c
@@ -1032,6 +1032,8 @@ static long kona_peri_clk_round_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 static long kona_peri_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long floor_rate,
+		unsigned long ceiling_rate,
 		unsigned long *best_parent_rate, struct clk_hw **best_parent)
 {
 	struct kona_clk *bcm_clk = to_kona_clk(hw);
diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
index 4386697..3390aac 100644
--- a/drivers/clk/clk-composite.c
+++ b/drivers/clk/clk-composite.c
@@ -56,6 +56,8 @@ static unsigned long clk_composite_recalc_rate(struct clk_hw *hw,
 }
 
 static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long floor_rate,
+					unsigned long ceiling_rate,
 					unsigned long *best_parent_rate,
 					struct clk_hw **best_parent_p)
 {
@@ -73,7 +75,9 @@ static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (rate_hw && rate_ops && rate_ops->determine_rate) {
 		rate_hw->clk = hw->clk;
-		return rate_ops->determine_rate(rate_hw, rate, best_parent_rate,
+		return rate_ops->determine_rate(rate_hw, rate, floor_rate,
+						ceiling_rate,
+						best_parent_rate,
 						best_parent_p);
 	} else if (rate_hw && rate_ops && rate_ops->round_rate &&
 		   mux_hw && mux_ops && mux_ops->set_parent) {
@@ -117,7 +121,8 @@ static long clk_composite_determine_rate(struct clk_hw *hw, unsigned long rate,
 		return best_rate;
 	} else if (mux_hw && mux_ops && mux_ops->determine_rate) {
 		mux_hw->clk = hw->clk;
-		return mux_ops->determine_rate(mux_hw, rate, best_parent_rate,
+		return mux_ops->determine_rate(mux_hw, rate, floor_rate,
+					       ceiling_rate, best_parent_rate,
 					       best_parent_p);
 	} else {
 		pr_err("clk: clk_composite_determine_rate function called, but no mux or rate callback set!\n");
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 57ae17f..0f5c51f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -744,6 +744,8 @@ struct clk *__clk_lookup(const char *name)
  * complex clock that may combine a mux with other operations.
  */
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long floor_rate,
+			      unsigned long ceiling_rate,
 			      unsigned long *best_parent_rate,
 			      struct clk_hw **best_parent_p)
 {
@@ -1014,8 +1016,8 @@ static unsigned long clk_core_round_rate_nolock(struct clk_core *clk,
 
 	if (clk->ops->determine_rate) {
 		parent_hw = parent ? parent->hw : NULL;
-		return clk->ops->determine_rate(clk->hw, rate, &parent_rate,
-						&parent_hw);
+		return clk->ops->determine_rate(clk->hw, rate, 0, ULONG_MAX,
+						&parent_rate, &parent_hw);
 	} else if (clk->ops->round_rate)
 		return clk->ops->round_rate(clk->hw, rate, &parent_rate);
 	else if (clk->flags & CLK_SET_RATE_PARENT)
@@ -1439,8 +1441,11 @@ static struct clk_core *clk_calc_new_rates(struct clk_core *clk,
 	struct clk_core *top = clk;
 	struct clk_core *old_parent, *parent;
 	struct clk_hw *parent_hw;
+	struct clk *clk_user;
 	unsigned long best_parent_rate = 0;
 	unsigned long new_rate;
+	unsigned long floor_rate = 0;
+	unsigned long ceiling_rate = ULONG_MAX;
 	int p_index = 0;
 
 	/* sanity */
@@ -1454,8 +1459,20 @@ static struct clk_core *clk_calc_new_rates(struct clk_core *clk,
 
 	/* find the closest rate and parent clk/rate */
 	if (clk->ops->determine_rate) {
+		hlist_for_each_entry(clk_user, &clk->clks, child_node) {
+			floor_rate = max(floor_rate,
+					 clk_user->floor_constraint);
+		}
+
+		hlist_for_each_entry(clk_user, &clk->clks, child_node) {
+			ceiling_rate = min(ceiling_rate,
+					   clk_user->ceiling_constraint);
+		}
+
 		parent_hw = parent ? parent->hw : NULL;
 		new_rate = clk->ops->determine_rate(clk->hw, rate,
+						    floor_rate,
+						    ceiling_rate,
 						    &best_parent_rate,
 						    &parent_hw);
 		parent = parent_hw ? parent_hw->core : NULL;
@@ -1599,30 +1616,10 @@ static void clk_change_rate(struct clk_core *clk)
 		clk_change_rate(clk->new_child);
 }
 
-/**
- * clk_set_rate - specify a new rate for clk
- * @clk: the clk whose rate is being changed
- * @rate: the new rate for clk
- *
- * In the simplest case clk_set_rate will only adjust the rate of clk.
- *
- * Setting the CLK_SET_RATE_PARENT flag allows the rate change operation to
- * propagate up to clk's parent; whether or not this happens depends on the
- * outcome of clk's .round_rate implementation.  If *parent_rate is unchanged
- * after calling .round_rate then upstream parent propagation is ignored.  If
- * *parent_rate comes back with a new rate for clk's parent then we propagate
- * up to clk's parent and set its rate.  Upward propagation will continue
- * until either a clk does not support the CLK_SET_RATE_PARENT flag or
- * .round_rate stops requesting changes to clk's parent_rate.
- *
- * Rate changes are accomplished via tree traversal that also recalculates the
- * rates for the clocks and fires off POST_RATE_CHANGE notifiers.
- *
- * Returns 0 on success, -EERROR otherwise.
- */
-int clk_set_rate(struct clk *clk, unsigned long rate)
+static int clk_core_set_rate(struct clk_core *clk, unsigned long req_rate)
 {
 	struct clk_core *top, *fail_clk;
+	unsigned long rate = req_rate;
 	int ret = 0;
 
 	if (!clk)
@@ -1632,17 +1629,17 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	clk_prepare_lock();
 
 	/* bail early if nothing to do */
-	if (rate == clk_get_rate(clk))
+	if (rate == clk_core_get_rate_nolock(clk))
 		goto out;
 
-	if ((clk->core->flags & CLK_SET_RATE_GATE) &&
-	    clk->core->prepare_count) {
+	if ((clk->flags & CLK_SET_RATE_GATE) &&
+	    clk->prepare_count) {
 		ret = -EBUSY;
 		goto out;
 	}
 
 	/* calculate new rates and get the topmost changed clock */
-	top = clk_calc_new_rates(clk->core, rate);
+	top = clk_calc_new_rates(clk, rate);
 	if (!top) {
 		ret = -EINVAL;
 		goto out;
@@ -1661,13 +1658,92 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	/* change the rates */
 	clk_change_rate(top);
 
+	clk->req_rate = req_rate;
+
 out:
 	clk_prepare_unlock();
 
 	return ret;
 }
+
+/**
+ * clk_set_rate - specify a new rate for clk
+ * @clk: the clk whose rate is being changed
+ * @rate: the new rate for clk
+ *
+ * In the simplest case clk_set_rate will only adjust the rate of clk.
+ *
+ * Setting the CLK_SET_RATE_PARENT flag allows the rate change operation to
+ * propagate up to clk's parent; whether or not this happens depends on the
+ * outcome of clk's .round_rate implementation.  If *parent_rate is unchanged
+ * after calling .round_rate then upstream parent propagation is ignored.  If
+ * *parent_rate comes back with a new rate for clk's parent then we propagate
+ * up to clk's parent and set its rate.  Upward propagation will continue
+ * until either a clk does not support the CLK_SET_RATE_PARENT flag or
+ * .round_rate stops requesting changes to clk's parent_rate.
+ *
+ * Rate changes are accomplished via tree traversal that also recalculates the
+ * rates for the clocks and fires off POST_RATE_CHANGE notifiers.
+ *
+ * Returns 0 on success, -EERROR otherwise.
+ */
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	return clk_core_set_rate(clk->core, rate);
+}
 EXPORT_SYMBOL_GPL(clk_set_rate);
 
+int clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max)
+{
+	int ret = 0;
+
+	if (min > max) {
+		pr_err("%s: clk %s dev %s con %s: invalid range [%lu, %lu]\n",
+		       __func__, clk->core->name, clk->dev_id, clk->con_id,
+		       min, max);
+		return -EINVAL;
+	}
+
+	clk_prepare_lock();
+
+	if (min != clk->floor_constraint || max != clk->ceiling_constraint) {
+		clk->floor_constraint = min;
+		clk->ceiling_constraint = max;
+		ret = clk_set_rate(clk, clk->core->req_rate);
+	}
+
+	clk_prepare_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_set_rate_range);
+
+/**
+ * clk_set_floor_rate - set a minimum clock rate for a clock source
+ * @clk: clock source
+ * @rate: desired minimum clock rate in Hz
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_floor_rate(struct clk *clk, unsigned long rate)
+{
+	return clk_set_rate_range(clk, rate, clk->ceiling_constraint);
+}
+EXPORT_SYMBOL_GPL(clk_set_floor_rate);
+
+/**
+ * clk_set_ceiling_rate - set a maximum clock rate for a clock source
+ * @clk: clock source
+ * @rate: desired maximum clock rate in Hz
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_ceiling_rate(struct clk *clk, unsigned long rate)
+{
+	return clk_set_rate_range(clk, clk->floor_constraint, rate);
+}
+EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
+
 static struct clk_core *clk_core_get_parent(struct clk_core *core)
 {
 	struct clk_core *parent;
@@ -2137,6 +2213,10 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 	else
 		clk->owner = NULL;
 
+	INIT_HLIST_HEAD(&clk->clks);
+
+	hw->clk = __clk_create_clk(hw, NULL, NULL);
+
 	ret = __clk_init(dev, hw->clk);
 	if (ret)
 		return ERR_PTR(ret);
@@ -2145,6 +2225,19 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 }
 EXPORT_SYMBOL_GPL(__clk_register);
 
+static void __clk_free_clk(struct clk *clk)
+{
+	struct clk_core *core = clk->core;
+
+	clk_prepare_lock();
+	hlist_del(&clk->child_node);
+	clk_prepare_unlock();
+
+	kfree(clk);
+
+	clk_core_set_rate(core, core->req_rate);
+}
+
 /**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
@@ -2204,12 +2297,14 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 		}
 	}
 
+	INIT_HLIST_HEAD(&clk->clks);
+
 	hw->clk = __clk_create_clk(hw, NULL, NULL);
 	ret = __clk_init(dev, hw->clk);
 	if (!ret)
 		return hw->clk;
 
-	kfree(hw->clk);
+	__clk_free_clk(hw->clk);
 fail_parent_names_copy:
 	while (--i >= 0)
 		kfree(clk->parent_names[i]);
@@ -2415,7 +2510,7 @@ int __clk_get(struct clk *clk)
 void __clk_put(struct clk *clk)
 {
 	clk_core_put(clk->core);
-	kfree(clk);
+	__clk_free_clk(clk);
 }
 
 /***        clk rate change notifiers        ***/
@@ -2542,6 +2637,11 @@ struct clk *__clk_create_clk(struct clk_hw *hw, const char *dev_id,
 	clk->core = hw->core;
 	clk->dev_id = dev_id;
 	clk->con_id = con_id;
+	clk->ceiling_constraint = ULONG_MAX;
+
+	clk_prepare_lock();
+	hlist_add_head(&clk->child_node, &hw->core->clks);
+	clk_prepare_unlock();
 
 	return clk;
 }
diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
index 007144f..bf1d663 100644
--- a/drivers/clk/hisilicon/clk-hi3620.c
+++ b/drivers/clk/hisilicon/clk-hi3620.c
@@ -295,6 +295,8 @@ static unsigned long mmc_clk_recalc_rate(struct clk_hw *hw,
 }
 
 static long mmc_clk_determine_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long floor_rate,
+			      unsigned long ceiling_rate,
 			      unsigned long *best_parent_rate,
 			      struct clk_hw **best_parent_p)
 {
diff --git a/drivers/clk/mmp/clk-mix.c b/drivers/clk/mmp/clk-mix.c
index 48fa53c..447c29e 100644
--- a/drivers/clk/mmp/clk-mix.c
+++ b/drivers/clk/mmp/clk-mix.c
@@ -202,6 +202,8 @@ error:
 }
 
 static long mmp_clk_mix_determine_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long floor_rate,
+					unsigned long ceiling_rate,
 					unsigned long *best_parent_rate,
 					struct clk_hw **best_parent_clk)
 {
diff --git a/drivers/clk/qcom/clk-pll.c b/drivers/clk/qcom/clk-pll.c
index 60873a7..acee033 100644
--- a/drivers/clk/qcom/clk-pll.c
+++ b/drivers/clk/qcom/clk-pll.c
@@ -141,6 +141,7 @@ struct pll_freq_tbl *find_freq(const struct pll_freq_tbl *f, unsigned long rate)
 
 static long
 clk_pll_determine_rate(struct clk_hw *hw, unsigned long rate,
+		       unsigned long floor_rate, unsigned long ceiling_rate,
 		       unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_pll *pll = to_clk_pll(hw);
diff --git a/drivers/clk/qcom/clk-rcg.c b/drivers/clk/qcom/clk-rcg.c
index 0b93972..b7b464a 100644
--- a/drivers/clk/qcom/clk-rcg.c
+++ b/drivers/clk/qcom/clk-rcg.c
@@ -368,6 +368,7 @@ clk_dyn_rcg_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
 
 static long _freq_tbl_determine_rate(struct clk_hw *hw,
 		const struct freq_tbl *f, unsigned long rate,
+		unsigned long floor_rate, unsigned long ceiling_rate,
 		unsigned long *p_rate, struct clk_hw **p_hw)
 {
 	unsigned long clk_flags;
@@ -397,22 +398,27 @@ static long _freq_tbl_determine_rate(struct clk_hw *hw,
 }
 
 static long clk_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long floor_rate, unsigned long ceiling_rate,
 		unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_rcg *rcg = to_clk_rcg(hw);
 
-	return _freq_tbl_determine_rate(hw, rcg->freq_tbl, rate, p_rate, p);
+	return _freq_tbl_determine_rate(hw, rcg->freq_tbl, rate, floor_rate,
+			ceiling_rate, p_rate, p);
 }
 
 static long clk_dyn_rcg_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long floor_rate, unsigned long ceiling_rate,
 		unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_dyn_rcg *rcg = to_clk_dyn_rcg(hw);
 
-	return _freq_tbl_determine_rate(hw, rcg->freq_tbl, rate, p_rate, p);
+	return _freq_tbl_determine_rate(hw, rcg->freq_tbl, rate, floor_rate,
+			ceiling_rate, p_rate, p);
 }
 
 static long clk_rcg_bypass_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long floor_rate, unsigned long ceiling_rate,
 		unsigned long *p_rate, struct clk_hw **p_hw)
 {
 	struct clk_rcg *rcg = to_clk_rcg(hw);
diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 08b8b37..4e4ebb7 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -208,6 +208,7 @@ static long _freq_tbl_determine_rate(struct clk_hw *hw,
 }
 
 static long clk_rcg2_determine_rate(struct clk_hw *hw, unsigned long rate,
+		unsigned long floor_rate, unsigned long ceiling_rate,
 		unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
@@ -361,6 +362,8 @@ static int clk_edp_pixel_set_rate_and_parent(struct clk_hw *hw,
 }
 
 static long clk_edp_pixel_determine_rate(struct clk_hw *hw, unsigned long rate,
+				 unsigned long floor_rate,
+				 unsigned long ceiling_rate,
 				 unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
@@ -412,6 +415,7 @@ const struct clk_ops clk_edp_pixel_ops = {
 EXPORT_SYMBOL_GPL(clk_edp_pixel_ops);
 
 static long clk_byte_determine_rate(struct clk_hw *hw, unsigned long rate,
+			 unsigned long floor_rate, unsigned long ceiling_rate,
 			 unsigned long *p_rate, struct clk_hw **p_hw)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
@@ -476,6 +480,8 @@ static const struct frac_entry frac_table_pixel[] = {
 };
 
 static long clk_pixel_determine_rate(struct clk_hw *hw, unsigned long rate,
+				 unsigned long floor_rate,
+				 unsigned long ceiling_rate,
 				 unsigned long *p_rate, struct clk_hw **p)
 {
 	struct clk_rcg2 *rcg = to_clk_rcg2(hw);
diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
index 62e08fb..c1a2c8f 100644
--- a/drivers/clk/sunxi/clk-factors.c
+++ b/drivers/clk/sunxi/clk-factors.c
@@ -80,6 +80,8 @@ static long clk_factors_round_rate(struct clk_hw *hw, unsigned long rate,
 }
 
 static long clk_factors_determine_rate(struct clk_hw *hw, unsigned long rate,
+				       unsigned long floor_rate,
+				       unsigned long ceiling_rate,
 				       unsigned long *best_parent_rate,
 				       struct clk_hw **best_parent_p)
 {
diff --git a/drivers/clk/sunxi/clk-sun6i-ar100.c b/drivers/clk/sunxi/clk-sun6i-ar100.c
index 3d282fb..417728e 100644
--- a/drivers/clk/sunxi/clk-sun6i-ar100.c
+++ b/drivers/clk/sunxi/clk-sun6i-ar100.c
@@ -45,6 +45,8 @@ static unsigned long ar100_recalc_rate(struct clk_hw *hw,
 }
 
 static long ar100_determine_rate(struct clk_hw *hw, unsigned long rate,
+				 unsigned long floor_rate,
+				 unsigned long ceiling_rate,
 				 unsigned long *best_parent_rate,
 				 struct clk_hw **best_parent_clk)
 {
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 1cdb727..8479d81 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -39,6 +39,7 @@ struct clk_core {
 	u8			num_parents;
 	u8			new_parent_index;
 	unsigned long		rate;
+	unsigned long		req_rate;
 	unsigned long		new_rate;
 	struct clk_core		*new_parent;
 	struct clk_core		*new_child;
@@ -50,6 +51,7 @@ struct clk_core {
 	struct hlist_head	children;
 	struct hlist_node	child_node;
 	struct hlist_node	debug_node;
+	struct hlist_head	clks;
 	unsigned int		notifier_count;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry		*dentry;
@@ -61,6 +63,10 @@ struct clk {
 	struct clk_core	*core;
 	const char *dev_id;
 	const char *con_id;
+
+	unsigned long floor_constraint;
+	unsigned long ceiling_constraint;
+	struct hlist_node child_node;
 };
 
 /*
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 2e65419..ae5c800 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -175,9 +175,12 @@ struct clk_ops {
 					unsigned long parent_rate);
 	long		(*round_rate)(struct clk_hw *hw, unsigned long rate,
 					unsigned long *parent_rate);
-	long		(*determine_rate)(struct clk_hw *hw, unsigned long rate,
-					unsigned long *best_parent_rate,
-					struct clk_hw **best_parent_hw);
+	long		(*determine_rate)(struct clk_hw *hw,
+					  unsigned long rate,
+					  unsigned long floor_rate,
+					  unsigned long ceiling_rate,
+					  unsigned long *best_parent_rate,
+					  struct clk_hw **best_parent_hw);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
 	u8		(*get_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long rate,
@@ -555,6 +558,8 @@ bool __clk_is_prepared(struct clk *clk);
 bool __clk_is_enabled(struct clk *clk);
 struct clk *__clk_lookup(const char *name);
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+			      unsigned long floor_rate,
+			      unsigned long ceiling_rate,
 			      unsigned long *best_parent_rate,
 			      struct clk_hw **best_parent_p);
 
diff --git a/include/linux/clk.h b/include/linux/clk.h
index c7f258a..f99ae67 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -302,6 +302,34 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
 int clk_set_rate(struct clk *clk, unsigned long rate);
 
 /**
+ * clk_set_rate_range - set a rate range for a clock source
+ * @clk: clock source
+ * @min: desired minimum clock rate in Hz
+ * @max: desired maximum clock rate in Hz
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max);
+
+/**
+ * clk_set_floor_rate - set a minimum clock rate for a clock source
+ * @clk: clock source
+ * @rate: desired minimum clock rate in Hz
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_floor_rate(struct clk *clk, unsigned long rate);
+
+/**
+ * clk_set_ceiling_rate - set a maximum clock rate for a clock source
+ * @clk: clock source
+ * @rate: desired maximum clock rate in Hz
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_ceiling_rate(struct clk *clk, unsigned long rate);
+
+/**
  * clk_set_parent - set the parent clock source for this clock
  * @clk: clock source
  * @parent: parent clock source
diff --git a/include/linux/clk/ti.h b/include/linux/clk/ti.h
index 55ef529..52c1f4b 100644
--- a/include/linux/clk/ti.h
+++ b/include/linux/clk/ti.h
@@ -263,6 +263,8 @@ int omap3_noncore_dpll_set_rate_and_parent(struct clk_hw *hw,
 					   u8 index);
 long omap3_noncore_dpll_determine_rate(struct clk_hw *hw,
 				       unsigned long rate,
+				       unsigned long floor_rate,
+				       unsigned long ceiling_rate,
 				       unsigned long *best_parent_rate,
 				       struct clk_hw **best_parent_clk);
 unsigned long omap4_dpll_regm4xen_recalc(struct clk_hw *hw,
@@ -272,6 +274,8 @@ long omap4_dpll_regm4xen_round_rate(struct clk_hw *hw,
 				    unsigned long *parent_rate);
 long omap4_dpll_regm4xen_determine_rate(struct clk_hw *hw,
 					unsigned long rate,
+					unsigned long floor_rate,
+					unsigned long ceiling_rate,
 					unsigned long *best_parent_rate,
 					struct clk_hw **best_parent_clk);
 u8 omap2_init_dpll_parent(struct clk_hw *hw);
-- 
1.9.3

