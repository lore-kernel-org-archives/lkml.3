Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaF0H6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 03:58:54 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:59024 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaF0H6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 03:58:33 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC 5/5] clk: Add floor and ceiling constraints to clock rates
Date: Fri, 27 Jun 2014 09:57:52 +0200
Message-Id: <1403855872-14749-6-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a way for clock consumers to set maximum and minimum rates. This can be
used for thermal drivers to set ceiling rates, or by misc. drivers to set
floor rates to assure a minimum performance level.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk.c           | 105 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clk.h           |   1 +
 drivers/clk/clkdev.c        |   7 +--
 include/linux/clk-private.h |   1 +
 include/linux/clk.h         |  18 ++++++++
 5 files changed, 126 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 7fc1937..4d93066 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -23,6 +23,19 @@
 
 #include "clk.h"
 
+enum constraint_type {
+	CONSTRAINT_FLOOR,
+	CONSTRAINT_CEILING,
+};
+
+struct rate_constraint {
+	struct hlist_node	node;
+	const char		*dev_id;
+	const char		*con_id;
+	enum constraint_type	type;
+	unsigned long		rate;
+};
+
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
 
@@ -1624,6 +1637,7 @@ static void clk_change_rate(struct clk_core *clk)
 int __clk_set_rate_internal(struct clk_core *clk, unsigned long rate)
 {
 	struct clk_core *top, *fail_clk;
+	struct rate_constraint *constraint;
 	int ret = 0;
 
 	if (!clk)
@@ -1632,6 +1646,17 @@ int __clk_set_rate_internal(struct clk_core *clk, unsigned long rate)
 	/* prevent racing with updates to the clock topology */
 	clk_prepare_lock();
 
+	hlist_for_each_entry(constraint, &clk->rate_constraints, node) {
+		switch(constraint->type) {
+		case CONSTRAINT_FLOOR:
+			rate = max(rate, constraint->rate);
+			break;
+		case CONSTRAINT_CEILING:
+			rate = min(rate, constraint->rate);
+			break;
+		}
+	}
+
 	/* bail early if nothing to do */
 	if (rate == __clk_get_rate_internal(clk))
 		goto out;
@@ -1695,6 +1720,67 @@ int clk_set_rate(struct clk *clk_user, unsigned long rate)
 }
 EXPORT_SYMBOL_GPL(clk_set_rate);
 
+static struct rate_constraint *__ensure_constraint(struct clk *clk_user,
+						   enum constraint_type type)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct rate_constraint *constraint = NULL;
+	bool found = false;
+
+	hlist_for_each_entry(constraint, &clk->rate_constraints, node) {
+		if (constraint->dev_id == clk_user->dev_id &&
+		    constraint->con_id == clk_user->con_id &&
+		    constraint->type == type)
+			found = true;
+	}
+
+	if (!found) {
+		constraint = kzalloc(sizeof(*constraint), GFP_KERNEL);
+		if (!constraint) {
+			pr_err("%s: could not allocate constraint\n", __func__);
+			return NULL;
+		}
+		hlist_add_head(&constraint->node, &clk->rate_constraints);
+	}
+
+	return constraint;
+}
+
+static int __clk_set_constraint(struct clk *clk_user, unsigned long rate,
+				enum constraint_type type)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct rate_constraint *constraint;
+	int ret;
+
+	clk_prepare_lock();
+
+	constraint = __ensure_constraint(clk_user, type);
+	if (!constraint)
+		return -ENOMEM;
+
+	constraint->rate = rate;
+
+	/* Update the rate so the new constraint is taken into account */
+	ret = __clk_set_rate_internal(clk, __clk_get_rate_internal(clk));
+
+	clk_prepare_unlock();
+
+	return ret;
+}
+
+int clk_set_floor_rate(struct clk *clk_user, unsigned long rate)
+{
+	return __clk_set_constraint(clk_user, rate, CONSTRAINT_FLOOR);
+}
+EXPORT_SYMBOL_GPL(clk_set_floor_rate);
+
+int clk_set_ceiling_rate(struct clk *clk_user, unsigned long rate)
+{
+	return __clk_set_constraint(clk_user, rate, CONSTRAINT_CEILING);
+}
+EXPORT_SYMBOL_GPL(clk_set_ceiling_rate);
+
 struct clk_core *__clk_get_parent_internal(struct clk_core *clk)
 {
 	struct clk_core *parent;
@@ -2028,6 +2114,8 @@ int __clk_init(struct device *dev, struct clk_core *clk)
 			}
 	 }
 
+	INIT_HLIST_HEAD(&clk->rate_constraints);
+
 	/*
 	 * optional platform-specific magic
 	 *
@@ -2458,6 +2546,23 @@ int clk_notifier_unregister(struct clk *clk_user, struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(clk_notifier_unregister);
 
+void __clk_free_clk(struct clk *clk_user)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct rate_constraint *constraint;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(constraint, tmp, &clk->rate_constraints, node) {
+		if (constraint->dev_id == clk_user->dev_id &&
+		    constraint->con_id == clk_user->con_id) {
+			hlist_del(&constraint->node);
+			kfree(constraint);
+		}
+	}
+
+	kfree(clk);
+}
+
 #ifdef CONFIG_OF
 /**
  * struct of_clk_provider - Clock provider registration structure
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index 2f682bf..ea84797 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -18,4 +18,5 @@ void of_clk_unlock(void);
 
 #if defined(CONFIG_COMMON_CLK)
 struct clk_core *clk_to_clk_core(struct clk *clk);
+void __clk_free_clk(struct clk *clk_user);
 #endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index bf1a2d7..88448b7 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -230,16 +230,11 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 }
 EXPORT_SYMBOL(clk_get);
 
-static void clk_free_clk(struct clk *clk)
-{
-	kfree(clk);
-}
-
 void clk_put(struct clk *clk)
 {
 	clk_core_t *core = clk_to_clk_core(clk);
 
-	clk_free_clk(clk);
+	__clk_free_clk(clk);
 	__clk_put(core);
 }
 EXPORT_SYMBOL(clk_put);
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 9657fc8..a8279e1 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -48,6 +48,7 @@ struct clk_core {
 	unsigned long		accuracy;
 	struct hlist_head	children;
 	struct hlist_node	child_node;
+	struct hlist_head	rate_constraints;
 	unsigned int		notifier_count;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry		*dentry;
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b8938e4..d6234bd 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -274,6 +274,24 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
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

