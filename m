Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaIZM4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:56:01 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51356 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbaIZMz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:55:59 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH] clk: Add floor and ceiling rate constraints for clocks
Date: Fri, 26 Sep 2014 14:55:01 +0200
Message-Id: <1411736101-13178-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a way to attach constraints to a clock, for now only floor and
ceiling rate constraints.

This can be used by cooling devices and battery drivers to set a ceiling on the
clock of the memory bus, or by devfreq and memory controller drivers to set
floor rates at which a clock should run so a given performance level is
sustained.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

Because the 3.18 merge window is near and the per-user clk patchset isn't yet
in clk-next and Stephen Boyd voiced reasonable objections to the refactoring,
I'm sending this patch that adds API for setting clock constraints without any
invasive changes.

It has been built successfully in Fengguang's kbuild service and tested on the
Jetson TK1 with experimental code that sets a floor rate based on bandwidth
requirements and a ceiling rate based on thermal trip points.
---
 drivers/clk/clk.c           | 61 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-private.h |  1 +
 include/linux/clk.h         | 49 ++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b76fa69..37ad6f5 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1538,6 +1538,7 @@ static void clk_change_rate(struct clk *clk)
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	struct clk *top, *fail_clk;
+	struct clk_constraint *constraint;
 	int ret = 0;
 
 	if (!clk)
@@ -1546,6 +1547,17 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	/* prevent racing with updates to the clock topology */
 	clk_prepare_lock();
 
+	hlist_for_each_entry(constraint, &clk->constraints, node) {
+		if (constraint->type == CLK_CONSTRAINT_RATE_FLOOR)
+			rate = max(rate, constraint->value);
+	}
+
+	hlist_for_each_entry(constraint, &clk->constraints, node) {
+		if (constraint->type == CLK_CONSTRAINT_RATE_CEILING &&
+		    constraint->value > 0)
+			rate = min(rate, constraint->value);
+	}
+
 	/* bail early if nothing to do */
 	if (rate == clk_get_rate(clk))
 		goto out;
@@ -1890,6 +1902,8 @@ int __clk_init(struct device *dev, struct clk *clk)
 			}
 	 }
 
+	INIT_HLIST_HEAD(&clk->constraints);
+
 	/*
 	 * optional platform-specific magic
 	 *
@@ -2318,6 +2332,53 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(clk_notifier_unregister);
 
+void clk_add_constraint(struct clk *clk, struct clk_constraint *constraint,
+			int constraint_type, unsigned long value)
+{
+	clk_prepare_lock();
+
+	__clk_get(clk);
+
+	constraint->clk = clk;
+	constraint->type = constraint_type;
+	constraint->value = value;
+	hlist_add_head(&constraint->node, &clk->constraints);
+
+	clk_set_rate(constraint->clk, clk_get_rate(constraint->clk));
+
+	clk_prepare_unlock();
+}
+EXPORT_SYMBOL_GPL(clk_add_constraint);
+
+void clk_update_constraint(struct clk_constraint *constraint,
+			   unsigned long new_value)
+{
+	clk_prepare_lock();
+
+	constraint->value = new_value;
+
+	clk_set_rate(constraint->clk, clk_get_rate(constraint->clk));
+
+	clk_prepare_unlock();
+}
+EXPORT_SYMBOL_GPL(clk_update_constraint);
+
+void clk_remove_constraint(struct clk_constraint *constraint)
+{
+	clk_prepare_lock();
+
+	hlist_del(&constraint->node);
+
+	clk_set_rate(constraint->clk, clk_get_rate(constraint->clk));
+
+	__clk_put(constraint->clk);
+
+	memset(constraint, 0, sizeof(*constraint));
+
+	clk_prepare_unlock();
+}
+EXPORT_SYMBOL_GPL(clk_remove_constraint);
+
 #ifdef CONFIG_OF
 /**
  * struct of_clk_provider - Clock provider registration structure
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index efbf70b..562e1c5 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -53,6 +53,7 @@ struct clk {
 	struct dentry		*dentry;
 #endif
 	struct kref		ref;
+	struct hlist_head	constraints;
 };
 
 /*
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097..13eeb54 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -411,4 +411,53 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 }
 #endif
 
+enum {
+	CLK_CONSTRAINT_RATE_FLOOR,
+	CLK_CONSTRAINT_RATE_CEILING,
+
+	/* insert new constraint ID */
+	CLK_CONSTRAINT_NUM_TYPES,
+};
+
+struct clk_constraint {
+	struct clk		*clk;
+	int			type;
+	unsigned long		value;
+	struct hlist_node	node;
+};
+
+/**
+ * clk_add_constraint - add a new clock constraint
+ * @clk: clock to be constrained
+ * @constraint: pointer to a preallocated handle
+ * @constraint_type: identifies the kind of constraint
+ * @value: value associated to the constraint
+ *
+ * Allows adding a constraint to a clock. A numeric value is associated to
+ * it which can be updated with clk_update_constraint(). The state of the
+ * clock will be updated with all the constraints being taken into account.
+ */
+void clk_add_constraint(struct clk *clk, struct clk_constraint *constraint,
+			int constraint_type, unsigned long value);
+
+/**
+ * clk_update_constraint - update the value associated to a clock constraint
+ * @constraint: pointer to existing constraint handle
+ * @new_value: new value
+ *
+ * Update the numeric value associated to a clock constraint. The state of the
+ * clock will be updated with all the constraints being taken into account.
+ */
+void clk_update_constraint(struct clk_constraint *constraint,
+			   unsigned long new_value);
+
+/**
+ * clk_remove_constraint - remove a clock constraint
+ * @constraint: pointer to existing constraint handle
+ *
+ * Remove an existing clock constraint. The state of the clock will be updated
+ * with all the remaining constraints being taken into account.
+ */
+void clk_remove_constraint(struct clk_constraint *constraint);
+
 #endif
-- 
1.9.3

