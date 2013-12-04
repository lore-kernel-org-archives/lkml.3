Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab3LDROD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:14:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13540 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118Ab3LDRNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:13:47 -0500
X-AuditID: cbfee61a-b7f796d000004313-b9-529f62cae7c7
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiada_wang@mentor.com,
        laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v7 5/5] clk: Implement clk_unregister
Date: Wed, 04 Dec 2013 18:12:07 +0100
Message-id: <1386177127-2894-6-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
References: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t9jAd1TSfODDJpaNC16/lRanG16w27R
	OXEJu8Wmx9dYLS7vmsNm0bNhK6vF7cu8Fk8nXGSzOPymndWB06OluYfNY3bHTFaPO9f2sHls
	XlLvsftrE6NH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZazc38BcsFi/YuGH+0wNjL1qXYyc
	HBICJhIz7zxlhrDFJC7cW8/WxcjFISSwiFHi0ffvjBBOB5PE9i2LGEGq2AQMJXqP9oHZIgL2
	Eu0tL8A6mAXuMko8P/cQLCEsYCNxdeIbNhCbRUBVYtWEy+wgNq+Aq8TCGztZuhg5gNYpSMyZ
	ZAMS5hRwk9g3YwsLiC0EVHJ+52P2CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIE
	B94zqR2MKxssDjEKcDAq8fC+SJwfJMSaWFZcmXuIUYKDWUmEd3IgUIg3JbGyKrUoP76oNCe1
	+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVAOj2jajtw8///v9piTy54V9DLOE4u2j
	V50+PYt5PcNjB4HXU/fyPX6bf/DBU80Vm10q+x7N/D+b45TG1fkRRnEHFm3+wmtkdeeP4XHT
	3bkmmeuezVr0/cO0Q5Ge626wn4xaFPVoyolTSziyYx70dfJdebPQ2jvfSnmd34w0ds+Xl5Jl
	czvrlzDcUFdiKc5INNRiLipOBACykQnIOAIAAA==
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
Changes since v6:
 - fixed NULL clk handling and replaced pr_err() with WARN_ON_ONCE().

Changes since v4:
 - none.

Changes since v3:
 - Use WARN_ON_ONCE() rather than WARN_ON() in clk_nodrv_disable_unprepare()
   callback.

Changes since v2:
 - none.

Changes since RFC v1:
 - renamed clk_dummy_* to clk_nodrv_*.
---
 drivers/clk/clk.c           |  121 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/clk-private.h |    2 +
 2 files changed, 120 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index baa2f66..da7b33e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -345,6 +345,21 @@ out:
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
@@ -435,6 +450,9 @@ static inline int clk_debug_register(struct clk *clk) { return 0; }
 static inline void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
 {
 }
+static inline void clk_debug_unregister(struct clk *clk)
+{
+}
 #endif
 
 /* caller must hold prepare_lock */
@@ -1778,6 +1796,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 
 	clk_debug_register(clk);
 
+	kref_init(&clk->ref);
 out:
 	clk_prepare_unlock();
 
@@ -1913,13 +1932,104 @@ fail_out:
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
+	WARN_ON_ONCE(1);
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
+       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
+               return;
+
+	clk_prepare_lock();
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
@@ -1987,6 +2097,7 @@ int __clk_get(struct clk *clk)
 	if (clk && !try_module_get(clk->owner))
 		return 0;
 
+	kref_get(&clk->ref);
 	return 1;
 }
 
@@ -1995,6 +2106,10 @@ void __clk_put(struct clk *clk)
 	if (WARN_ON_ONCE(IS_ERR(clk)))
 		return;
 
+	clk_prepare_lock();
+	kref_put(&clk->ref, __clk_release);
+	clk_prepare_unlock();
+
 	if (clk)
 		module_put(clk->owner);
 }
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

