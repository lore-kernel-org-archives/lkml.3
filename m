Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbaJGPXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:23:54 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55592 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaJGPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:23:20 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] clk: Add floor and ceiling constraints to clock rates
Date: Tue,  7 Oct 2014 17:21:53 +0200
Message-Id: <1412695334-2608-9-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1412695334-2608-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a way for clock consumers to set maximum and minimum rates. This can be
used for thermal drivers to set ceiling rates, or by misc. drivers to set
floor rates to assure a minimum performance level.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c           | 118 +++++++++++++++++++++++++++++++++-----------
 include/linux/clk-private.h |   5 ++
 include/linux/clk.h         |  18 +++++++
 3 files changed, 113 insertions(+), 28 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 01c55d1..10942de 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1608,30 +1608,10 @@ static void clk_change_rate(struct clk_core *clk)
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
+static int clk_core_set_rate(struct clk_core *clk, unsigned long rate)
 {
 	struct clk_core *top, *fail_clk;
+	struct clk *clk_user;
 	int ret = 0;
 
 	if (!clk)
@@ -1640,18 +1620,27 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	/* prevent racing with updates to the clock topology */
 	clk_prepare_lock();
 
+	hlist_for_each_entry(clk_user, &clk->per_user_clks, child_node) {
+		rate = max(rate, clk_user->floor_constraint);
+	}
+
+	hlist_for_each_entry(clk_user, &clk->per_user_clks, child_node) {
+		if (clk_user->ceiling_constraint > 0)
+			rate = min(rate, clk_user->ceiling_constraint);
+	}
+
 	/* bail early if nothing to do */
-	if (rate == clk_get_rate(clk))
+	if (rate == clk_core_get_rate(clk))
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
@@ -1675,8 +1664,69 @@ out:
 
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
 
+int clk_set_floor_rate(struct clk *clk, unsigned long rate)
+{
+	int ret;
+
+	clk_prepare_lock();
+
+	clk->floor_constraint = rate;
+	ret = clk_set_rate(clk, clk_get_rate(clk));
+
+	clk_prepare_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_set_floor_rate);
+
+int clk_set_ceiling_rate(struct clk *clk, unsigned long rate)
+{
+	int ret;
+
+	clk_prepare_lock();
+
+	WARN(rate > 0 && rate < clk->floor_constraint,
+	     "clk %s dev %s con %s: new ceiling %lu lower than existing floor %lu\n",
+	     clk->core->name, clk->dev_id, clk->con_id, rate,
+	     clk->floor_constraint);
+
+	clk->ceiling_constraint = rate;
+	ret = clk_set_rate(clk, clk_get_rate(clk));
+
+	clk_prepare_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
+
 static struct clk_core *clk_core_get_parent(struct clk_core *clk)
 {
 	struct clk_core *parent;
@@ -2007,6 +2057,8 @@ int __clk_init(struct device *dev, struct clk *clk_user)
 			}
 	 }
 
+	INIT_HLIST_HEAD(&clk->per_user_clks);
+
 	/*
 	 * optional platform-specific magic
 	 *
@@ -2068,6 +2120,12 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 }
 EXPORT_SYMBOL_GPL(__clk_register);
 
+static void __clk_free_clk(struct clk *clk_user)
+{
+	hlist_del(&clk_user->child_node);
+	kfree(clk_user);
+}
+
 /**
  * clk_register - allocate a new clock, register it and return an opaque cookie
  * @dev: device that is registering this clock
@@ -2132,7 +2190,7 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 	if (!ret)
 		return hw->clk;
 
-	kfree(hw->clk);
+	__clk_free_clk(hw->clk);
 fail_parent_names_copy:
 	while (--i >= 0)
 		kfree(clk->parent_names[i]);
@@ -2336,7 +2394,7 @@ int __clk_get(struct clk *clk)
 void __clk_put(struct clk *clk)
 {
 	clk_core_put(clk->core);
-	kfree(clk);
+	__clk_free_clk(clk);
 }
 
 /***        clk rate change notifiers        ***/
@@ -2464,6 +2522,10 @@ struct clk *__clk_create_clk(struct clk_hw *hw, const char *dev_id,
 	clk->dev_id = dev_id;
 	clk->con_id = con_id;
 
+	clk_prepare_lock();
+	hlist_add_head(&clk->child_node, &hw->core->per_user_clks);
+	clk_prepare_unlock();
+
 	return clk;
 }
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index b45620f..4d25f2a 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -48,6 +48,7 @@ struct clk_core {
 	unsigned long		accuracy;
 	struct hlist_head	children;
 	struct hlist_node	child_node;
+	struct hlist_head	per_user_clks;
 	unsigned int		notifier_count;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry		*dentry;
@@ -59,6 +60,10 @@ struct clk {
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
index fb5e097..ad798a9 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -273,6 +273,24 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
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

