Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab3CVPpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:45:18 -0400
Received: from multi.imgtec.com ([194.200.65.239]:32808 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480Ab3CVPo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:44:57 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Chao Xie <xiechao.mail@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [RFC PATCH v1 2/3] clk: add support for clock remuxing
Date: Fri, 22 Mar 2013 15:43:50 +0000
Message-ID: <1363967031-22781-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com>
References: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_22_15_44_55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for automatic selection of the best parent for a mux, i.e.
the one which can provide the closest clock rate to that requested. This
is by way of adding a parameter to the round_rate clock op which allows
the clock to optionally select a different parent index. This is used in
clk_calc_new_rates to decide whether to initiate a set_parent operation.

This splits out the mutex protected portion of clk_set_parent() into a
separate __clk_set_parent_notify() which takes care of sending clock
change notifications.

A new clock flag is also added called CLK_SET_RATE_REMUX to indicate
that the clock can have it's parent changed automatically in response to
a set_rate. It isn't used yet, but will be used within clock mux
drivers.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/clk/clk.c            | 94 +++++++++++++++++++++++++++++++-------------
 include/linux/clk-provider.h |  6 ++-
 2 files changed, 71 insertions(+), 29 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 79d5deb..3886ccd 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -36,6 +36,8 @@ static struct dentry *rootdir;
 static struct dentry *orphandir;
 static int inited = 0;
 
+static int __clk_set_parent_notify(struct clk *clk, struct clk *parent);
+
 static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
 {
 	if (!c)
@@ -737,7 +739,7 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 	if (clk->parent)
 		parent_rate = clk->parent->rate;
 
-	return clk->ops->round_rate(clk->hw, rate, &parent_rate);
+	return clk->ops->round_rate(clk->hw, rate, &parent_rate, NULL);
 }
 
 /**
@@ -928,8 +930,10 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate)
 static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 {
 	struct clk *top = clk;
+	struct clk *parent;
 	unsigned long best_parent_rate = 0;
 	unsigned long new_rate;
+	u8 old_parent = 0, best_parent;
 
 	/* sanity */
 	if (IS_ERR_OR_NULL(clk))
@@ -939,13 +943,21 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 	if (clk->parent)
 		best_parent_rate = clk->parent->rate;
 
+	/* by default don't change the parent */
+	if (clk->ops->get_parent)
+		old_parent = clk->ops->get_parent(clk->hw);
+	best_parent = old_parent;
+	parent = clk->parent;
+
 	/* never propagate up to the parent */
 	if (!(clk->flags & CLK_SET_RATE_PARENT)) {
 		if (!clk->ops->round_rate) {
 			clk->new_rate = clk->rate;
 			return NULL;
 		}
-		new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
+		new_rate = clk->ops->round_rate(clk->hw, rate,
+						&best_parent_rate,
+						&best_parent);
 		goto out;
 	}
 
@@ -962,15 +974,36 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 		goto out;
 	}
 
-	new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
+	new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate,
+					&best_parent);
 
-	if (best_parent_rate != clk->parent->rate) {
-		top = clk_calc_new_rates(clk->parent, best_parent_rate);
+	if (best_parent != old_parent) {
+		parent = __clk_get_parent_by_index(clk, best_parent);
+		/* couldn't find requested parent */
+		if (!parent)
+			return NULL;
+	}
+
+	if (best_parent_rate != parent->rate) {
+		top = clk_calc_new_rates(parent, best_parent_rate);
 
 		goto out;
 	}
 
 out:
+	/* the parent may have changed */
+	if (best_parent != old_parent) {
+		parent = __clk_get_parent_by_index(clk, best_parent);
+		/* couldn't find requested parent */
+		if (!parent) {
+			parent = clk->parent;
+			best_parent = old_parent;
+		}
+		if (best_parent != old_parent)
+			if (__clk_set_parent_notify(clk, parent))
+				return NULL;
+	}
+
 	clk_calc_subtree(clk, new_rate);
 
 	return top;
@@ -1270,31 +1303,10 @@ out:
 	return ret;
 }
 
-/**
- * clk_set_parent - switch the parent of a mux clk
- * @clk: the mux clk whose input we are switching
- * @parent: the new input to clk
- *
- * Re-parent clk to use parent as it's new input source.  If clk has the
- * CLK_SET_PARENT_GATE flag set then clk must be gated for this
- * operation to succeed.  After successfully changing clk's parent
- * clk_set_parent will update the clk topology, sysfs topology and
- * propagate rate recalculation via __clk_recalc_rates.  Returns 0 on
- * success, -EERROR otherwise.
- */
-int clk_set_parent(struct clk *clk, struct clk *parent)
+static int __clk_set_parent_notify(struct clk *clk, struct clk *parent)
 {
 	int ret = 0;
 
-	if (!clk || !clk->ops)
-		return -EINVAL;
-
-	if (!clk->ops->set_parent)
-		return -ENOSYS;
-
-	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
-
 	if (clk->parent == parent)
 		goto out;
 
@@ -1322,6 +1334,34 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	__clk_reparent(clk, parent);
 
 out:
+	return ret;
+}
+
+/**
+ * clk_set_parent - switch the parent of a mux clk
+ * @clk: the mux clk whose input we are switching
+ * @parent: the new input to clk
+ *
+ * Re-parent clk to use parent as it's new input source.  If clk has the
+ * CLK_SET_PARENT_GATE flag set then clk must be gated for this
+ * operation to succeed.  After successfully changing clk's parent
+ * clk_set_parent will update the clk topology, sysfs topology and
+ * propagate rate recalculation via __clk_recalc_rates.  Returns 0 on
+ * success, -EERROR otherwise.
+ */
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	int ret;
+
+	if (!clk || !clk->ops)
+		return -EINVAL;
+
+	if (!clk->ops->set_parent)
+		return -ENOSYS;
+
+	/* prevent racing with updates to the clock topology */
+	mutex_lock(&prepare_lock);
+	ret = __clk_set_parent_notify(clk, parent);
 	mutex_unlock(&prepare_lock);
 
 	return ret;
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 4e0b634..cdad3ce 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -27,6 +27,7 @@
 #define CLK_IS_ROOT		BIT(4) /* root clk, has no parent */
 #define CLK_IS_BASIC		BIT(5) /* Basic clk, can't do a to_clk_foo() */
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
+#define CLK_SET_RATE_REMUX	BIT(7) /* find best parent for rate change */
 
 struct clk_hw;
 
@@ -69,7 +70,8 @@ struct clk_hw;
  * 		this op is not set then clock rate will be initialized to 0.
  *
  * @round_rate:	Given a target rate as input, returns the closest rate actually
- * 		supported by the clock.
+ *		supported by the clock, and optionally the index of the parent
+ *		that should be used to provide the clock rate.
  *
  * @get_parent:	Queries the hardware to determine the parent of a clock.  The
  * 		return value is a u8 which specifies the index corresponding to
@@ -115,7 +117,7 @@ struct clk_ops {
 	unsigned long	(*recalc_rate)(struct clk_hw *hw,
 					unsigned long parent_rate);
 	long		(*round_rate)(struct clk_hw *hw, unsigned long,
-					unsigned long *);
+					unsigned long *, u8 *index);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
 	u8		(*get_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long,
-- 
1.8.1.2


