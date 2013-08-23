Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3HWPF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:05:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53925 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3HWPFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:05:23 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-cf-52177a329aa2
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        shawn.guo@linaro.org, sebastian.hesselbarth@gmail.com,
        LW@KARO-electronics.de, t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 5/5] clk: Implement clk_unregister
Date: Fri, 23 Aug 2013 17:03:47 +0200
Message-id: <1377270227-1030-6-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com>
References: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jAV2jKvEgg/bHIhZTHz5hs3i/cR6T
	Rc+fSouzTW/YLTonLmG32PT4GqvF5V1z2CwmTJ3EbjHnzxRmi9uXeS0OPFnOZvF0wkU2i9uN
	K9gsLu1RsTj8pp3V4v1PR4un65YwW6yf8ZrFYmHDF3aLmxN+MDuIeLQ097B5rJzu7XH5+xtm
	j52z7rJ7fPgY5zG7Yyarx/zpj5g9Nq3qZPO4c20Pm8fRlWuZPDYvqffY/bWJ0aNvyypGj8+b
	5AL4orhsUlJzMstSi/TtErgyFj64z1LQalTxaM8FxgbG3RpdjJwcEgImEn9+72aHsMUkLtxb
	z9bFyMUhJLCIUaLx0T0op4NJ4uG6LSwgVWwChhK9R/sYQWwRAQ2JKV2P2UGKmAV6WSSmTL4J
	ViQsYCrxomUXK4jNIqAq8a6ziQ3E5hVwldg67z5QDQfQOgWJOZNsQMKcAm4SzWvOMoGEhYBK
	/m7RnMDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcIw8k9rBuLLB4hCjAAejEg/v
	BGexICHWxLLiytxDjBIczEoivDvzxIOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhP
	LEnNTk0tSC2CyTJxcEo1MMYHHRa10diczHWhJa43/RF36saedt2YLeX52XkrvB7f5tu8T9jF
	bU9b1coXKySXrc5/e9jOLPHHPLcfq14z+Ux2fJbh7ys4+5x74vEaee+aw7e3KWrOnfvsWtnL
	6xxxu5eG54b6as/8u1VDTMEhpeeY+LIljgf/dB7e+WtDbfwV69VbZY+83KjEUpyRaKjFXFSc
	CADp5AbyjQIAAA==
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
 drivers/clk/clk.c           |  123 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/clk-private.h |    2 +
 2 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 272d68d..738c2cc 100644
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
@@ -1657,6 +1675,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 
 	clk_debug_register(clk);
 
+	kref_init(&clk->ref);
 out:
 	clk_prepare_unlock();
 
@@ -1792,13 +1811,106 @@ fail_out:
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
@@ -1866,6 +1978,7 @@ int __clk_get(struct clk *clk)
 	if (clk && !try_module_get(clk->owner))
 		return 0;
 
+	kref_get(&clk->ref);
 	return 1;
 }
 EXPORT_SYMBOL(__clk_get);
@@ -1875,6 +1988,10 @@ void __clk_put(struct clk *clk)
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
index b7c0b58..36c1fc8 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -12,6 +12,7 @@
 #define __LINUX_CLK_PRIVATE_H
 
 #include <linux/clk-provider.h>
+#include <linux/kref.h>
 #include <linux/list.h>
 
 /*
@@ -47,6 +48,7 @@ struct clk {
 #ifdef CONFIG_COMMON_CLK_DEBUG
 	struct dentry		*dentry;
 #endif
+	struct kref		ref;
 };
 
 /*
-- 
1.7.9.5

