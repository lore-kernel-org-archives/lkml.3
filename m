Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbaGCOkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:40:01 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:56116 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412AbaGCOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:39:24 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC v2 4/5] clk: per-user clock accounting for debug
Date: Thu,  3 Jul 2014 16:38:42 +0200
Message-Id: <1404398323-18934-5-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

When a clock has multiple users, the WARNING on imbalance of
enable/disable may not show the guilty party since although they may
have commited the error earlier, the warning is emitted later when some
other user, presumably innocent, disables the clock.

Provide per-user clock enable/disable accounting and disabler tracking
in order to help debug these problems.

NOTE: with this patch, clk_get_parent() behaves like clk_get(), i.e. it
needs to be matched with a clk_put().  Otherwise, memory will leak.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk-devres.c        |  3 ++-
 drivers/clk/clk-highbank.c      |  2 +-
 drivers/clk/clk.c               | 52 ++++++++++++++++++++++++++++++++++++++---
 drivers/clk/clk.h               |  2 +-
 drivers/clk/clkdev.c            | 26 +++++++++++++++++----
 drivers/clk/qcom/mmcc-msm8960.c |  9 ++++---
 drivers/clk/sunxi/clk-sunxi.c   |  2 +-
 drivers/clk/tegra/clk.c         |  2 +-
 drivers/clk/zynq/clkc.c         | 12 +++++-----
 include/linux/clk-private.h     |  4 ++++
 include/linux/clk-provider.h    |  3 ++-
 11 files changed, 94 insertions(+), 23 deletions(-)

diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index 5f2aba9..d6a5e59 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -37,7 +37,8 @@ EXPORT_SYMBOL(devm_clk_provider_get);
 
 struct clk *devm_clk_get(struct device *dev, const char *id)
 {
-	return clk_core_to_clk(devm_clk_provider_get(dev, id));
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+	return clk_core_to_clk(devm_clk_provider_get(dev, id), dev_id, id);
 }
 EXPORT_SYMBOL(devm_clk_get);
 
diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index cc1bae1..4e38856 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -331,7 +331,7 @@ CLK_OF_DECLARE(hb_a9periph, "calxeda,hb-a9periph-clock", hb_a9periph_init);
 static void __init hb_a9bus_init(struct device_node *node)
 {
 	struct clk_core *clk = hb_clk_init(node, &a9bclk_ops);
-	clk_prepare_enable(clk_core_to_clk(clk));
+	clk_prepare_enable(clk_core_to_clk(clk, node->full_name, NULL));
 }
 CLK_OF_DECLARE(hb_a9bus, "calxeda,hb-a9bus-clock", hb_a9bus_init);
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 644a824..b887c69 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -568,6 +568,28 @@ static int clk_disable_unused(void)
 }
 late_initcall_sync(clk_disable_unused);
 
+struct clk *clk_core_to_clk(struct clk_core *clk_core, const char *dev,
+			    const char *con)
+{
+	struct clk *clk;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		return ERR_PTR(-ENOMEM);
+
+	clk->core = clk_core;
+	clk->dev_id = dev;
+	clk->con_id = con;
+
+	return clk;
+}
+EXPORT_SYMBOL_GPL(clk_core_to_clk);
+
+struct clk_core *clk_to_clk_core(struct clk *clk)
+{
+	return clk->core;
+}
+
 /***    helper functions   ***/
 
 const char *__clk_get_name(struct clk_core *clk)
@@ -935,7 +957,20 @@ static void __clk_disable_internal(struct clk_core *clk)
  */
 void clk_disable(struct clk *clk_user)
 {
-	__clk_disable_internal(clk_to_clk_core(clk_user));
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	unsigned long flags;
+
+	flags = clk_enable_lock();
+	if (!WARN(clk_user->enable_count == 0,
+		  "incorrect disable clk dev %s con %s last disabler %pF\n",
+		  clk_user->dev_id, clk_user->con_id, clk_user->last_disable)) {
+
+		clk_user->last_disable = __builtin_return_address(0);
+		clk_user->enable_count--;
+
+		__clk_disable(clk);
+	}
+	clk_enable_unlock(flags);
 }
 EXPORT_SYMBOL_GPL(clk_disable);
 
@@ -995,7 +1030,17 @@ static int __clk_enable_internal(struct clk_core *clk)
  */
 int clk_enable(struct clk *clk_user)
 {
-	return __clk_enable_internal(clk_to_clk_core(clk_user));
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	unsigned long flags;
+	int ret;
+
+	flags = clk_enable_lock();
+	ret = __clk_enable(clk);
+	if (!ret)
+		clk_user->enable_count++;
+	clk_enable_unlock(flags);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_enable);
 
@@ -1671,8 +1716,9 @@ EXPORT_SYMBOL_GPL(clk_provider_get_parent);
 struct clk *clk_get_parent(struct clk *clk_user)
 {
 	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct clk_core *parent = clk_provider_get_parent(clk);
 
-	return clk_core_to_clk(clk_provider_get_parent(clk));
+	return clk_core_to_clk(parent, clk_user->dev_id, clk_user->con_id);
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index c69f4fe..2f682bf 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -17,5 +17,5 @@ void of_clk_unlock(void);
 #endif
 
 #if defined(CONFIG_COMMON_CLK)
-#define clk_to_clk_core(clk)	(clk->core)
+struct clk_core *clk_to_clk_core(struct clk *clk);
 #endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 48811c0..5be6bb1 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -76,7 +76,9 @@ struct clk_core *of_clk_provider_get(struct device_node *np, int index)
 
 struct clk *of_clk_get(struct device_node *np, int index)
 {
-	return clk_core_to_clk(of_clk_provider_get(np, index));
+	struct clk_core *clk = of_clk_provider_get(np, index);
+
+	return clk_core_to_clk(clk, np->full_name, NULL);
 }
 EXPORT_SYMBOL(of_clk_get);
 
@@ -128,7 +130,9 @@ struct clk_core *of_clk_provider_get_by_name(struct device_node *np, const char
  */
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 {
-	return clk_core_to_clk(of_clk_provider_get_by_name(np, name));
+	struct clk_core *clk = of_clk_provider_get_by_name(np, name);
+
+	return clk_core_to_clk(clk, np->full_name, NULL);
 }
 EXPORT_SYMBOL(of_clk_get_by_name);
 #endif
@@ -195,7 +199,9 @@ EXPORT_SYMBOL_GPL(clk_provider_get_sys);
 
 struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 {
-	return clk_core_to_clk(clk_provider_get_sys(dev_id, con_id));
+	struct clk_core *clk = clk_provider_get_sys(dev_id, con_id);
+
+	return clk_core_to_clk(clk, dev_id, con_id);
 }
 EXPORT_SYMBOL(clk_get_sys);
 
@@ -218,13 +224,23 @@ EXPORT_SYMBOL(clk_provider_get);
 
 struct clk *clk_get(struct device *dev, const char *con_id)
 {
-	return clk_core_to_clk(clk_provider_get(dev, con_id));
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+
+	return clk_core_to_clk(clk_provider_get(dev, con_id), dev_id, con_id);
 }
 EXPORT_SYMBOL(clk_get);
 
+static void clk_free_clk(struct clk *clk)
+{
+	kfree(clk);
+}
+
 void clk_put(struct clk *clk)
 {
-	__clk_put(clk_to_clk_core(clk));
+	clk_core_t *core = clk_to_clk_core(clk);
+
+	clk_free_clk(clk);
+	__clk_put(core);
 }
 EXPORT_SYMBOL(clk_put);
 
diff --git a/drivers/clk/qcom/mmcc-msm8960.c b/drivers/clk/qcom/mmcc-msm8960.c
index 28a5d30..47f21ea 100644
--- a/drivers/clk/qcom/mmcc-msm8960.c
+++ b/drivers/clk/qcom/mmcc-msm8960.c
@@ -470,7 +470,8 @@ static int pix_rdi_set_parent(struct clk_hw *hw, u8 index)
 	 * needs to be on at what time.
 	 */
 	for (i = 0; i < num_parents; i++) {
-		ret = clk_prepare_enable(clk_core_to_clk(clk_get_parent_by_index(clk, i)));
+		struct clk_core *parent = clk_get_parent_by_index(clk, i);
+		ret = clk_prepare_enable(clk_core_to_clk(parent, NULL, __clk_get_name(parent)));
 		if (ret)
 			goto err;
 	}
@@ -498,8 +499,10 @@ static int pix_rdi_set_parent(struct clk_hw *hw, u8 index)
 	udelay(1);
 
 err:
-	for (i--; i >= 0; i--)
-		clk_disable_unprepare(clk_core_to_clk(clk_get_parent_by_index(clk, i)));
+	for (i--; i >= 0; i--) {
+		struct clk_core *parent = clk_get_parent_by_index(clk, i);
+		clk_disable_unprepare(clk_core_to_clk(parent, NULL, __clk_get_name(parent)));
+	}
 
 	return ret;
 }
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 5de44c1..550a691 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1196,7 +1196,7 @@ static void __init sunxi_init_clocks(const char *clocks[], int nclocks)
 		struct clk_core *clk = clk_provider_get(NULL, clocks[i]);
 
 		if (!IS_ERR(clk))
-			clk_prepare_enable(clk_core_to_clk(clk));
+			clk_prepare_enable(clk_core_to_clk(clk, NULL, clocks[i]));
 	}
 }
 
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 385d101..2a03d47 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -228,7 +228,7 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 			}
 
 		if (tbl->state)
-			if (clk_prepare_enable(clk_core_to_clk(clk))) {
+			if (clk_prepare_enable(clk_core_to_clk(clk, NULL, __clk_get_name(clk)))) {
 				pr_err("%s: Failed to enable %s\n", __func__,
 				       __clk_get_name(clk));
 				WARN_ON(1);
diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index c58c540..ed3e1cba 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -154,7 +154,7 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
 			0, CLK_GATE_SET_TO_DISABLE, fclk_gate_lock);
 	enable_reg = clk_readl(fclk_gate_reg) & 1;
 	if (enable && !enable_reg) {
-		if (clk_prepare_enable(clk_core_to_clk(clks[fclk])))
+		if (clk_prepare_enable(clk_core_to_clk(clks[fclk], NULL, clk_name)))
 			pr_warn("%s: FCLK%u enable failed\n", __func__,
 					fclk - fclk0);
 	}
@@ -333,13 +333,13 @@ static void __init zynq_clk_setup(struct device_node *np)
 			CLK_DIVIDER_ALLOW_ZERO, &ddrclk_lock);
 	clks[ddr2x] = clk_register_gate(NULL, clk_output_name[ddr2x],
 			"ddr2x_div", 0, SLCR_DDR_CLK_CTRL, 1, 0, &ddrclk_lock);
-	clk_prepare_enable(clk_core_to_clk(clks[ddr2x]));
+	clk_prepare_enable(clk_core_to_clk(clks[ddr2x], NULL, clk_output_name[ddr2x]));
 	clk = clk_register_divider(NULL, "ddr3x_div", "ddrpll", 0,
 			SLCR_DDR_CLK_CTRL, 20, 6, CLK_DIVIDER_ONE_BASED |
 			CLK_DIVIDER_ALLOW_ZERO, &ddrclk_lock);
 	clks[ddr3x] = clk_register_gate(NULL, clk_output_name[ddr3x],
 			"ddr3x_div", 0, SLCR_DDR_CLK_CTRL, 0, 0, &ddrclk_lock);
-	clk_prepare_enable(clk_core_to_clk(clks[ddr3x]));
+	clk_prepare_enable(clk_core_to_clk(clks[ddr3x], NULL, clk_output_name[ddr3x]));
 
 	clk = clk_register_divider(NULL, "dci_div0", "ddrpll", 0,
 			SLCR_DCI_CLK_CTRL, 8, 6, CLK_DIVIDER_ONE_BASED |
@@ -351,7 +351,7 @@ static void __init zynq_clk_setup(struct device_node *np)
 	clks[dci] = clk_register_gate(NULL, clk_output_name[dci], "dci_div1",
 			CLK_SET_RATE_PARENT, SLCR_DCI_CLK_CTRL, 0, 0,
 			&dciclk_lock);
-	clk_prepare_enable(clk_core_to_clk(clks[dci]));
+	clk_prepare_enable(clk_core_to_clk(clks[dci], NULL, clk_output_name[dci]));
 
 	/* Peripheral clocks */
 	for (i = fclk0; i <= fclk3; i++) {
@@ -505,10 +505,10 @@ static void __init zynq_clk_setup(struct device_node *np)
 	/* leave debug clocks in the state the bootloader set them up to */
 	tmp = clk_readl(SLCR_DBG_CLK_CTRL);
 	if (tmp & DBG_CLK_CTRL_CLKACT_TRC)
-		if (clk_prepare_enable(clk_core_to_clk(clks[dbg_trc])))
+		if (clk_prepare_enable(clk_core_to_clk(clks[dbg_trc], NULL, clk_output_name[dbg_trc])))
 			pr_warn("%s: trace clk enable failed\n", __func__);
 	if (tmp & DBG_CLK_CTRL_CPU_1XCLKACT)
-		if (clk_prepare_enable(clk_core_to_clk(clks[dbg_apb])))
+		if (clk_prepare_enable(clk_core_to_clk(clks[dbg_apb], NULL, clk_output_name[dbg_apb])))
 			pr_warn("%s: debug APB clk enable failed\n", __func__);
 
 	/* One gated clock for all APER clocks. */
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 2c1ece9..9657fc8 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -57,6 +57,10 @@ struct clk_core {
 
 struct clk {
 	struct clk_core	*core;
+	unsigned int	enable_count;
+	const char	*dev_id;
+	const char	*con_id;
+	void		*last_disable;
 };
 
 /*
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 87de32c..abfc31a 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -533,7 +533,8 @@ struct clk_core *clk_provider_get_sys(const char *dev_id, const char *con_id);
 struct clk_core *clk_provider_get(struct device *dev, const char *con_id);
 struct clk_core *devm_clk_provider_get(struct device *dev, const char *id);
 
-#define clk_core_to_clk(core)	((struct clk *)(core))
+struct clk *clk_core_to_clk(struct clk_core *clk_core, const char *dev,
+			    const char *con);
 
 /*
  * FIXME clock api without lock protection
-- 
1.9.3

