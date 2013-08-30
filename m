Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3H3Oz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:55:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37454 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab3H3OzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:55:25 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-57-5220b25b5203
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v6 5/5] clk: Implement clk_unregister
Date: Fri, 30 Aug 2013 16:53:22 +0200
Message-id: <1377874402-2944-6-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com>
References: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jAd3oTQpBBm/69S3eb5zHZNHzp9Li
	bNMbdovOiUvYLTY9vsZqcXnXHDaLCVMnsVvM+TOF2eL2ZV6LpxMuslncblzBZnH4TTurxfoZ
	r1kceD1amnvYPD58jPOY3TGT1ePOtT1sHkdXrmXy2Lyk3mP31yZGj74tqxg9Pm+SC+CM4rJJ
	Sc3JLEst0rdL4Mq4/VawYI9pxdN7rUwNjK3aXYwcHBICJhJb3gd3MXICmWISF+6tZ+ti5OIQ
	EljEKNG7sYsJwulgkji6s4MFpIpNwFCi92gfI4gtIqAhMaXrMTtIEbPAZSaJTV+62EESwgKm
	Ekd/9zOCbGARUJV4eVwYxOQVcJXY9U8JYq+CxJxJNiDFnAJuEhemgezlBFrlKjHnxCrGCYy8
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh+oz6R2MqxosDjEKcDAq8fDuXK4QJMSa
	WFZcmXuIUYKDWUmE9+NioBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWp
	RTBZJg5OqQZGfWY1jedVzw7s4DHY1xgSfWPOHRX1YM7cifkCtYoFuR1FBbNNk0N0N5sw7uKY
	tfRjKctd3tsXV+9pPdLWabNPb0FZ3wtntR4fsVX/WV6l9aquCt3cwyUXvnfvFUeHpWyrpx2I
	l7/I0RVQrmvl8yXBU2D+0f1ratenf9P/mSdc8fCX4Ko6rm4lluKMREMt5qLiRAC0rtaSUQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_unregister() is currently not implemented and it is required when
a clock provider module needs to be unloaded.

Normally the clock supplier module is prevented to be unloaded by
taking reference on the module in clk_get().

For cases when the clock supplier module deinitializes despite the
consumers of its clocks holding a reference on the module, e.g. when
the driver is unbound through "unbind" sysfs attribute, there are
empty clock ops added. These ops are assigned temporarily to struct
clk and used until all consumers release the clock, to avoid invoking
callbacks from the module which just got removed.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v5:
- ensure clk->kref is not referenced when the passed clk is NULL.

Changes since v4:
 - none.

Changes since v3:
 - Use WARN_ON_ONCE() rather than WARN_ON() in clk_nodrv_disable_unprepare()
   callback.

Changes since v2:
 - none.

Changes since RFC v1:
 - renamed clk_dummy_* to clk_nodrv_*.

Changes since v3 of the original patch [1]:
 - reparent all children to the orphan list instead of leaving
   the clock unregistered when it has child clocks,
 - removed unnecessary prerequisite checks in clk_debug_unregister(),
 - struct clk is now being freed only when the last clock consumer
   calls clk_put(),
 - empty clock ops are used after clk_unregister() has been called
   until all references to the clock are released and the clock
   object is freed.

[1] http://www.spinics.net/lists/arm-kernel/msg247548.html
---
 drivers/clk/clk.c           |  134 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/clk-private.h |    2 +
 2 files changed, 128 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ac80e13..27f8c42 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -344,6 +344,21 @@ out:
 	return ret;
 }
 
+ /**
+ * clk_debug_unregister - remove a clk node from the debugfs clk tree
+ * @clk: the clk being removed from the debugfs clk tree
+ *
+ * Dynamically removes a clk and all it's children clk nodes from the
+ * debugfs clk tree if clk->dentry points to debugfs created by
+ * clk_debug_register in __clk_init.
+ *
+ * Caller must hold prepare_lock.
+ */
+static void clk_debug_unregister(struct clk *clk)
+{
+	debugfs_remove_recursive(clk->dentry);
+}
+
 /**
  * clk_debug_reparent - reparent clk node in the debugfs clk tree
  * @clk: the clk being reparented
@@ -434,6 +449,9 @@ static inline int clk_debug_register(struct clk *clk) { return 0; }
 static inline void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
 {
 }
+static inline void clk_debug_unregister(struct clk *clk)
+{
+}
 #endif
 
 /* caller must hold prepare_lock */
@@ -1770,6 +1788,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 
 	clk_debug_register(clk);
 
+	kref_init(&clk->ref);
 out:
 	clk_prepare_unlock();
 
@@ -1905,13 +1924,106 @@ fail_out:
 }
 EXPORT_SYMBOL_GPL(clk_register);
 
+/*
+ * Free memory allocated for a clock.
+ * Caller must hold prepare_lock.
+ */
+static void __clk_release(struct kref *ref)
+{
+	struct clk *clk = container_of(ref, struct clk, ref);
+	int i = clk->num_parents;
+
+	kfree(clk->parents);
+	while (--i >= 0)
+		kfree(clk->parent_names[i]);
+
+	kfree(clk->parent_names);
+	kfree(clk->name);
+	kfree(clk);
+}
+
+/*
+ * Empty clk_ops for unregistered clocks. These are used temporarily
+ * after clk_unregister() was called on a clock and until last clock
+ * consumer calls clk_put() and the struct clk object is freed.
+ */
+static int clk_nodrv_prepare_enable(struct clk_hw *hw)
+{
+	return -ENXIO;
+}
+
+static void clk_nodrv_disable_unprepare(struct clk_hw *hw)
+{
+	WARN_ON(1);
+}
+
+static int clk_nodrv_set_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long parent_rate)
+{
+	return -ENXIO;
+}
+
+static int clk_nodrv_set_parent(struct clk_hw *hw, u8 index)
+{
+	return -ENXIO;
+}
+
+static const struct clk_ops clk_nodrv_ops = {
+	.enable		= clk_nodrv_prepare_enable,
+	.disable	= clk_nodrv_disable_unprepare,
+	.prepare	= clk_nodrv_prepare_enable,
+	.unprepare	= clk_nodrv_disable_unprepare,
+	.set_rate	= clk_nodrv_set_rate,
+	.set_parent	= clk_nodrv_set_parent,
+};
+
 /**
  * clk_unregister - unregister a currently registered clock
  * @clk: clock to unregister
- *
- * Currently unimplemented.
  */
-void clk_unregister(struct clk *clk) {}
+void clk_unregister(struct clk *clk)
+{
+	unsigned long flags;
+
+	clk_prepare_lock();
+
+	if (!clk || IS_ERR(clk)) {
+		pr_err("%s: invalid clock: %p\n", __func__, clk);
+		goto out;
+	}
+
+	if (clk->ops == &clk_nodrv_ops) {
+		pr_err("%s: unregistered clock: %s\n", __func__, clk->name);
+		goto out;
+	}
+	/*
+	 * Assign empty clock ops for consumers that might still hold
+	 * a reference to this clock.
+	 */
+	flags = clk_enable_lock();
+	clk->ops = &clk_nodrv_ops;
+	clk_enable_unlock(flags);
+
+	if (!hlist_empty(&clk->children)) {
+		struct clk *child;
+
+		/* Reparent all children to the orphan list. */
+		hlist_for_each_entry(child, &clk->children, child_node)
+			clk_set_parent(child, NULL);
+	}
+
+	clk_debug_unregister(clk);
+
+	hlist_del_init(&clk->child_node);
+
+	if (clk->prepare_count)
+		pr_warn("%s: unregistering prepared clock: %s\n",
+					__func__, clk->name);
+
+	kref_put(&clk->ref, __clk_release);
+out:
+	clk_prepare_unlock();
+}
 EXPORT_SYMBOL_GPL(clk_unregister);
 
 static void devm_clk_release(struct device *dev, void *res)
@@ -1976,19 +2088,25 @@ EXPORT_SYMBOL_GPL(devm_clk_unregister);
  */
 int __clk_get(struct clk *clk)
 {
-	if (clk && !try_module_get(clk->owner))
-		return 0;
+	if (clk) {
+		if (!try_module_get(clk->owner))
+			return 0;
 
+		kref_get(&clk->ref);
+	}
 	return 1;
 }
 
 void __clk_put(struct clk *clk)
 {
-	if (WARN_ON_ONCE(IS_ERR(clk)))
+	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
 		return;
 
-	if (clk)
-		module_put(clk->owner);
+	clk_prepare_lock();
+	kref_put(&clk->ref, __clk_release);
+	clk_prepare_unlock();
+
+	module_put(clk->owner);
 }
 
 /***        clk rate change notifiers        ***/
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 8cb1865..72c65e0 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -12,6 +12,7 @@
 #define __LINUX_CLK_PRIVATE_H
 
 #include <linux/clk-provider.h>
+#include <linux/kref.h>
 #include <linux/list.h>
 
 /*
@@ -50,6 +51,7 @@ struct clk {
 #ifdef CONFIG_COMMON_CLK_DEBUG
 	struct dentry		*dentry;
 #endif
+	struct kref		ref;
 };
 
 /*
-- 
1.7.9.5

