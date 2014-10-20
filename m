Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaJTNmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:42:25 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60382 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaJTNmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:42:00 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/8] clk: Add floor and ceiling constraints to clock rates
Date: Mon, 20 Oct 2014 15:40:08 +0200
Message-Id: <1413812442-24956-9-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a way for clock consumers to set maximum and minimum rates. This can be
used for thermal drivers to set ceiling rates, or by misc. drivers to set
floor rates to assure a minimum performance level.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v4:	* Copy function docs from header
	* Move WARN out of critical section
	* Refresh rate after removing a per-user clk
	* Rename clk_core.per_user_clks to clk_core.clks
	* Store requested rate and re-apply it when constraints are updated
---
 drivers/clk/clk.c           | 139 +++++++++++++++++++++++++++++++++++---------
 include/linux/clk-private.h |   6 ++
 include/linux/clk.h         |  18 ++++++
 3 files changed, 135 insertions(+), 28 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9fae072..c849b3a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1599,30 +1599,11 @@ static void clk_change_rate(struct clk_core *clk)
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
+	struct clk *clk_user;
+	unsigned long rate = req_rate;
 	int ret = 0;
 
 	if (!clk)
@@ -1631,18 +1612,27 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	/* prevent racing with updates to the clock topology */
 	clk_prepare_lock();
 
+	hlist_for_each_entry(clk_user, &clk->clks, child_node) {
+		rate = max(rate, clk_user->floor_constraint);
+	}
+
+	hlist_for_each_entry(clk_user, &clk->clks, child_node) {
+		if (clk_user->ceiling_constraint > 0)
+			rate = min(rate, clk_user->ceiling_constraint);
+	}
+
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
@@ -1661,13 +1651,90 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
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
 
+/**
+ * clk_set_floor_rate - set a minimum clock rate for a clock source
+ * @clk: clock source
+ * @rate: desired minimum clock rate in Hz
+ *
+ * Returns success (0) or negative errno.
+ */
+int clk_set_floor_rate(struct clk *clk, unsigned long rate)
+{
+	int ret;
+
+	clk_prepare_lock();
+
+	clk->floor_constraint = rate;
+	ret = clk_set_rate(clk, clk->core->req_rate);
+
+	clk_prepare_unlock();
+
+	return ret;
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
+	int ret;
+
+	WARN(rate > 0 && rate < clk->floor_constraint,
+	     "clk %s dev %s con %s: new ceiling %lu lower than existing floor %lu\n",
+	     clk->core->name, clk->dev_id, clk->con_id, rate,
+	     clk->floor_constraint);
+
+	clk_prepare_lock();
+
+	clk->ceiling_constraint = rate;
+	ret = clk_set_rate(clk, clk->core->req_rate);
+
+	clk_prepare_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
+
 static struct clk_core *clk_core_get_parent(struct clk_core *core)
 {
 	struct clk_core *parent;
@@ -2084,6 +2151,8 @@ int __clk_init(struct device *dev, struct clk *clk_user)
 			}
 	 }
 
+	INIT_HLIST_HEAD(&clk->clks);
+
 	/*
 	 * optional platform-specific magic
 	 *
@@ -2145,6 +2214,16 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 }
 EXPORT_SYMBOL_GPL(__clk_register);
 
+static void __clk_free_clk(struct clk *clk)
+{
+	struct clk_core *core = clk->core;
+
+	hlist_del(&clk->child_node);
+	kfree(clk);
+
+	clk_core_set_rate(core, core->req_rate);
+}
+
 /**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
@@ -2209,7 +2288,7 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 	if (!ret)
 		return hw->clk;
 
-	kfree(hw->clk);
+	__clk_free_clk(hw->clk);
 fail_parent_names_copy:
 	while (--i >= 0)
 		kfree(clk->parent_names[i]);
@@ -2415,7 +2494,7 @@ int __clk_get(struct clk *clk)
 void __clk_put(struct clk *clk)
 {
 	clk_core_put(clk->core);
-	kfree(clk);
+	__clk_free_clk(clk);
 }
 
 /***        clk rate change notifiers        ***/
@@ -2543,6 +2622,10 @@ struct clk *__clk_create_clk(struct clk_hw *hw, const char *dev_id,
 	clk->dev_id = dev_id;
 	clk->con_id = con_id;
 
+	clk_prepare_lock();
+	hlist_add_head(&clk->child_node, &hw->core->clks);
+	clk_prepare_unlock();
+
 	return clk;
 }
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 1cdb727..d693db1 100644
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
+	unsigned long	floor_constraint;
+	unsigned long	ceiling_constraint;
+	struct hlist_node child_node;
 };
 
 /*
diff --git a/include/linux/clk.h b/include/linux/clk.h
index c7f258a..0d55570 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -302,6 +302,24 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
 int clk_set_rate(struct clk *clk, unsigned long rate);
 
 /**
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
-- 
1.9.3

