Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3HFPxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:53:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8708 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3HFPxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:53:00 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-82-52011bda9eb3
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, mturquette@linaro.org, jiada_wang@mentor.com,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        lethal@linux-sh.org, kyungmin.park@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 2/2] clk: implement clk_unregister
Date: Tue, 06 Aug 2013 17:51:57 +0200
Message-id: <1375804317-10576-3-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375804317-10576-1-git-send-email-s.nawrocki@samsung.com>
References: <1375804317-10576-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+xoO4tacYgg+4uU4upD5+wWbzfOI/J
	oudPpcXZpjfsFp0Tl7Bb7H/7k9Vi0+NrrBaXd81hs5gwdRK7xZw/U5gtbl/mtTjwZDmbxdMJ
	F9ksLu1RsTj8pp3V4v1PR4un65YwW6yf8ZrFYmHDF3aLmxN+MDuIeLQ097B5rJzu7XH5+xtm
	j52z7rJ7fPgY5zG7Yyarx/zpj5g9Nq3qZPO4c20Pm8fRlWuZPE6/P8TqsXlJvcfur02MHn1b
	VjF6fN4kF8AfxWWTkpqTWZZapG+XwJWxacthtoJdhhX/r11lbWDs1+hi5OSQEDCRWHT2BCuE
	LSZx4d56ti5GLg4hgemMEp9XvmSGcDqYJN61LWUBqWITMJToPdrHCGKLCGhITOl6zA5SxCzQ
	wSLRMu0rWEJYwEziTOdSdhCbRUBV4mH7BbA4r4CbxNvbd4GmcgCtU5CYM8kGJMwp4C6xctp/
	sBIhoJIr96ewTmDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOF6eSe1gXNlgcYhR
	gINRiYe3QowxSIg1say4MvcQowQHs5IIr48EUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbr
	QCGB9MSS1OzU1ILUIpgsEwenVANjo4BlaLM912N3l10/tNeYMGU+5wp25vq36GPdVs+9tQd4
	7ptcnrHHxv/q4jfVU7tOe9Xf5LOt7bM6enh3aV3Qii0XqyXSShIL8vsiO9Pjowpt9okc7Sr8
	82qB3sO9J6L1ZaU27dsy29hVysRO0yp8gUL5d5fm9zcu63TH1u/c7bc9V5BfeLESS3FGoqEW
	c1FxIgAEnhgRkwIAAA==
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
callbacks from the module which just got its driver remove() callback
called on it.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---

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
index 4877bd6..327f83f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -342,6 +342,21 @@ out:
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
@@ -432,6 +447,9 @@ static inline int clk_debug_register(struct clk *clk) { return 0; }
 static inline void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
 {
 }
+static inline void clk_debug_unregister(struct clk *clk)
+{
+}
 #endif

 /* caller must hold prepare_lock */
@@ -1655,6 +1673,7 @@ int __clk_init(struct device *dev, struct clk *clk)

 	clk_debug_register(clk);

+	kref_init(&clk->ref);
 out:
 	clk_prepare_unlock();

@@ -1784,13 +1803,106 @@ fail_out:
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
+static int clk_dummy_prepare_enable(struct clk_hw *hw)
+{
+	return -ENXIO;
+}
+
+static void clk_dummy_disable_unprepare(struct clk_hw *hw)
+{
+	WARN_ON(1);
+}
+
+static int clk_dummy_set_rate(struct clk_hw *hw, unsigned long rate,
+					unsigned long parent_rate)
+{
+	return -ENXIO;
+}
+
+static int clk_dummy_set_parent(struct clk_hw *hw, u8 index)
+{
+	return -ENXIO;
+}
+
+static const struct clk_ops clk_dummy_ops = {
+	.enable		= clk_dummy_prepare_enable,
+	.disable	= clk_dummy_disable_unprepare,
+	.prepare	= clk_dummy_prepare_enable,
+	.unprepare	= clk_dummy_disable_unprepare,
+	.set_rate	= clk_dummy_set_rate,
+	.set_parent	= clk_dummy_set_parent,
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
+	if (clk->ops == &clk_dummy_ops) {
+		pr_err("%s: unregistered clock: %s\n", __func__, clk->name);
+		goto out;
+	}
+	/*
+	 * Assign dummy clock ops for consumers that might still hold
+	 * a reference to this clock.
+	 */
+	flags = clk_enable_lock();
+	clk->ops = &clk_dummy_ops;
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
@@ -1861,6 +1973,7 @@ int __clk_get(struct clk *clk)
 	if (!try_module_get(clk->owner))
 		return 0;

+	kref_get(&clk->ref);
 	return 1;
 }
 EXPORT_SYMBOL(__clk_get);
@@ -1870,6 +1983,10 @@ void __clk_put(struct clk *clk)
 	if (!clk || IS_ERR(clk))
 		return;

+	clk_prepare_lock();
+	kref_put(&clk->ref, __clk_release);
+	clk_prepare_unlock();
+
 	module_put(clk->owner);
 }
 EXPORT_SYMBOL(__clk_put);
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

