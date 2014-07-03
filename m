Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbaGCOj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:39:27 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:46972 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458AbaGCOjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:39:22 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [RFC v2 3/5] clk: use struct clk only for external API
Date: Thu,  3 Jul 2014 16:38:41 +0200
Message-Id: <1404398323-18934-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

In order to provide per-user accounting, this separates the struct clk
used in the common clock framework into two structures 'struct clk_core'
and 'struct clk'.  struct clk_core will be used for internal
manipulation and struct clk will be used in the clock API
implementation.

In this patch, struct clk is simply renamed to struct clk_core and a new
struct clk is implemented which simply wraps it.  In the next patch, the
new struct clk will be used to implement per-user clock enable
accounting.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
---
 drivers/clk/clk-devres.c     |  13 +-
 drivers/clk/clk.c            | 539 ++++++++++++++++++++++++-------------------
 drivers/clk/clk.h            |   4 +
 drivers/clk/clkdev.c         |  90 +++++---
 include/linux/clk-private.h  |  38 +--
 include/linux/clk-provider.h | 127 +++++-----
 include/linux/clk.h          |  21 +-
 include/linux/clkdev.h       |  24 +-
 8 files changed, 494 insertions(+), 362 deletions(-)

diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index 8f57154..5f2aba9 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/device.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
@@ -14,15 +15,15 @@ static void devm_clk_release(struct device *dev, void *res)
 	clk_put(*(struct clk **)res);
 }
 
-struct clk *devm_clk_get(struct device *dev, const char *id)
+struct clk_core *devm_clk_provider_get(struct device *dev, const char *id)
 {
-	struct clk **ptr, *clk;
+	struct clk_core **ptr, *clk;
 
 	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	clk = clk_get(dev, id);
+	clk = clk_provider_get(dev, id);
 	if (!IS_ERR(clk)) {
 		*ptr = clk;
 		devres_add(dev, ptr);
@@ -32,6 +33,12 @@ struct clk *devm_clk_get(struct device *dev, const char *id)
 
 	return clk;
 }
+EXPORT_SYMBOL(devm_clk_provider_get);
+
+struct clk *devm_clk_get(struct device *dev, const char *id)
+{
+	return clk_core_to_clk(devm_clk_provider_get(dev, id));
+}
 EXPORT_SYMBOL(devm_clk_get);
 
 static int devm_clk_match(struct device *dev, void *res, void *data)
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8b73ede..644a824 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -36,6 +36,8 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
+static long __clk_get_accuracy_internal(struct clk_core *clk);
+
 /***           locking             ***/
 static void clk_prepare_lock(void)
 {
@@ -101,7 +103,7 @@ static struct dentry *rootdir;
 static struct dentry *orphandir;
 static int inited = 0;
 
-static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
+static void clk_summary_show_one(struct seq_file *s, struct clk_core *c, int level)
 {
 	if (!c)
 		return;
@@ -109,14 +111,14 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
 	seq_printf(s, "%*s%-*s %11d %12d %11lu %10lu\n",
 		   level * 3 + 1, "",
 		   30 - level * 3, c->name,
-		   c->enable_count, c->prepare_count, clk_get_rate(c),
-		   clk_get_accuracy(c));
+		   c->enable_count, c->prepare_count, clk_provider_get_rate(c),
+		   __clk_get_accuracy_internal(c));
 }
 
-static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
+static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
 				     int level)
 {
-	struct clk *child;
+	struct clk_core *child;
 
 	if (!c)
 		return;
@@ -129,7 +131,7 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
 
 static int clk_summary_show(struct seq_file *s, void *data)
 {
-	struct clk *c;
+	struct clk_core *c;
 
 	seq_puts(s, "   clock                         enable_cnt  prepare_cnt        rate   accuracy\n");
 	seq_puts(s, "--------------------------------------------------------------------------------\n");
@@ -160,7 +162,7 @@ static const struct file_operations clk_summary_fops = {
 	.release	= single_release,
 };
 
-static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
+static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
 {
 	if (!c)
 		return;
@@ -168,13 +170,13 @@ static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
 	seq_printf(s, "\"%s\": { ", c->name);
 	seq_printf(s, "\"enable_count\": %d,", c->enable_count);
 	seq_printf(s, "\"prepare_count\": %d,", c->prepare_count);
-	seq_printf(s, "\"rate\": %lu", clk_get_rate(c));
-	seq_printf(s, "\"accuracy\": %lu", clk_get_accuracy(c));
+	seq_printf(s, "\"rate\": %lu", clk_provider_get_rate(c));
+	seq_printf(s, "\"accuracy\": %lu", __clk_get_accuracy_internal(c));
 }
 
-static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
+static void clk_dump_subtree(struct seq_file *s, struct clk_core *c, int level)
 {
-	struct clk *child;
+	struct clk_core *child;
 
 	if (!c)
 		return;
@@ -191,7 +193,7 @@ static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
 
 static int clk_dump(struct seq_file *s, void *data)
 {
-	struct clk *c;
+	struct clk_core *c;
 	bool first_node = true;
 
 	seq_printf(s, "{");
@@ -230,7 +232,7 @@ static const struct file_operations clk_dump_fops = {
 };
 
 /* caller must hold prepare_lock */
-static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
+static int clk_debug_create_one(struct clk_core *clk, struct dentry *pdentry)
 {
 	struct dentry *d;
 	int ret = -ENOMEM;
@@ -291,9 +293,9 @@ out:
 }
 
 /* caller must hold prepare_lock */
-static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
+static int clk_debug_create_subtree(struct clk_core *clk, struct dentry *pdentry)
 {
-	struct clk *child;
+	struct clk_core *child;
 	int ret = -EINVAL;;
 
 	if (!clk || !pdentry)
@@ -323,9 +325,9 @@ out:
  * Caller must hold prepare_lock.  Only clk_init calls this function (so
  * far) so this is taken care.
  */
-static int clk_debug_register(struct clk *clk)
+static int clk_debug_register(struct clk_core *clk)
 {
-	struct clk *parent;
+	struct clk_core *parent;
 	struct dentry *pdentry;
 	int ret = 0;
 
@@ -365,7 +367,7 @@ out:
  *
  * Caller must hold prepare_lock.
  */
-static void clk_debug_unregister(struct clk *clk)
+static void clk_debug_unregister(struct clk_core *clk)
 {
 	debugfs_remove_recursive(clk->dentry);
 }
@@ -381,7 +383,7 @@ static void clk_debug_unregister(struct clk *clk)
  *
  * Caller must hold prepare_lock.
  */
-static void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
+static void clk_debug_reparent(struct clk_core *clk, struct clk_core *new_parent)
 {
 	struct dentry *d;
 	struct dentry *new_parent_d;
@@ -417,7 +419,7 @@ static void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
  */
 static int __init clk_debug_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct dentry *d;
 
 	rootdir = debugfs_create_dir("clk", NULL);
@@ -456,19 +458,19 @@ static int __init clk_debug_init(void)
 }
 late_initcall(clk_debug_init);
 #else
-static inline int clk_debug_register(struct clk *clk) { return 0; }
-static inline void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
+static inline int clk_debug_register(struct clk_core *clk) { return 0; }
+static inline void clk_debug_reparent(struct clk_core *clk, struct clk_core *new_parent)
 {
 }
-static inline void clk_debug_unregister(struct clk *clk)
+static inline void clk_debug_unregister(struct clk_core *clk)
 {
 }
 #endif
 
 /* caller must hold prepare_lock */
-static void clk_unprepare_unused_subtree(struct clk *clk)
+static void clk_unprepare_unused_subtree(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 
 	if (!clk)
 		return;
@@ -491,9 +493,9 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
 }
 
 /* caller must hold prepare_lock */
-static void clk_disable_unused_subtree(struct clk *clk)
+static void clk_disable_unused_subtree(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 	unsigned long flags;
 
 	if (!clk)
@@ -539,7 +541,7 @@ __setup("clk_ignore_unused", clk_ignore_unused_setup);
 
 static int clk_disable_unused(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (clk_ignore_unused) {
 		pr_warn("clk: Not disabling unused clocks\n");
@@ -568,31 +570,31 @@ late_initcall_sync(clk_disable_unused);
 
 /***    helper functions   ***/
 
-const char *__clk_get_name(struct clk *clk)
+const char *__clk_get_name(struct clk_core *clk)
 {
 	return !clk ? NULL : clk->name;
 }
 EXPORT_SYMBOL_GPL(__clk_get_name);
 
-struct clk_hw *__clk_get_hw(struct clk *clk)
+struct clk_hw *__clk_get_hw(struct clk_core *clk)
 {
 	return !clk ? NULL : clk->hw;
 }
 EXPORT_SYMBOL_GPL(__clk_get_hw);
 
-u8 __clk_get_num_parents(struct clk *clk)
+u8 __clk_get_num_parents(struct clk_core *clk)
 {
 	return !clk ? 0 : clk->num_parents;
 }
 EXPORT_SYMBOL_GPL(__clk_get_num_parents);
 
-struct clk *__clk_get_parent(struct clk *clk)
+struct clk_core *__clk_get_parent(struct clk_core *clk)
 {
 	return !clk ? NULL : clk->parent;
 }
 EXPORT_SYMBOL_GPL(__clk_get_parent);
 
-struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
+struct clk_core *clk_get_parent_by_index(struct clk_core *clk, u8 index)
 {
 	if (!clk || index >= clk->num_parents)
 		return NULL;
@@ -606,17 +608,17 @@ struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
 }
 EXPORT_SYMBOL_GPL(clk_get_parent_by_index);
 
-unsigned int __clk_get_enable_count(struct clk *clk)
+unsigned int __clk_get_enable_count(struct clk_core *clk)
 {
 	return !clk ? 0 : clk->enable_count;
 }
 
-unsigned int __clk_get_prepare_count(struct clk *clk)
+unsigned int __clk_get_prepare_count(struct clk_core *clk)
 {
 	return !clk ? 0 : clk->prepare_count;
 }
 
-unsigned long __clk_get_rate(struct clk *clk)
+unsigned long __clk_get_rate(struct clk_core *clk)
 {
 	unsigned long ret;
 
@@ -638,7 +640,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(__clk_get_rate);
 
-unsigned long __clk_get_accuracy(struct clk *clk)
+unsigned long __clk_get_accuracy(struct clk_core *clk)
 {
 	if (!clk)
 		return 0;
@@ -646,13 +648,13 @@ unsigned long __clk_get_accuracy(struct clk *clk)
 	return clk->accuracy;
 }
 
-unsigned long __clk_get_flags(struct clk *clk)
+unsigned long __clk_get_flags(struct clk_core *clk)
 {
 	return !clk ? 0 : clk->flags;
 }
 EXPORT_SYMBOL_GPL(__clk_get_flags);
 
-bool __clk_is_prepared(struct clk *clk)
+bool __clk_is_prepared(struct clk_core *clk)
 {
 	int ret;
 
@@ -673,7 +675,7 @@ out:
 	return !!ret;
 }
 
-bool __clk_is_enabled(struct clk *clk)
+bool __clk_is_enabled(struct clk_core *clk)
 {
 	int ret;
 
@@ -695,10 +697,10 @@ out:
 }
 EXPORT_SYMBOL_GPL(__clk_is_enabled);
 
-static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
+static struct clk_core *__clk_lookup_subtree(const char *name, struct clk_core *clk)
 {
-	struct clk *child;
-	struct clk *ret;
+	struct clk_core *child;
+	struct clk_core *ret;
 
 	if (!strcmp(clk->name, name))
 		return clk;
@@ -712,10 +714,10 @@ static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
 	return NULL;
 }
 
-struct clk *__clk_lookup(const char *name)
+struct clk_core *__clk_lookup(const char *name)
 {
-	struct clk *root_clk;
-	struct clk *ret;
+	struct clk_core *root_clk;
+	struct clk_core *ret;
 
 	if (!name)
 		return NULL;
@@ -744,9 +746,9 @@ struct clk *__clk_lookup(const char *name)
  */
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
-			      struct clk **best_parent_p)
+			      struct clk_core **best_parent_p)
 {
-	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
+	struct clk_core *clk = hw->clk, *parent, *best_parent = NULL;
 	int i, num_parents;
 	unsigned long parent_rate, best = 0;
 
@@ -789,7 +791,7 @@ EXPORT_SYMBOL_GPL(__clk_mux_determine_rate);
 
 /***        clk api        ***/
 
-void __clk_unprepare(struct clk *clk)
+void __clk_unprepare(struct clk_core *clk)
 {
 	if (!clk)
 		return;
@@ -808,9 +810,19 @@ void __clk_unprepare(struct clk *clk)
 	__clk_unprepare(clk->parent);
 }
 
+void clk_provider_unprepare(struct clk_core *clk)
+{
+	if (IS_ERR_OR_NULL(clk))
+		return;
+
+	clk_prepare_lock();
+	__clk_unprepare(clk);
+	clk_prepare_unlock();
+}
+
 /**
  * clk_unprepare - undo preparation of a clock source
- * @clk: the clk being unprepared
+ * @clk_user: the clk being unprepared
  *
  * clk_unprepare may sleep, which differentiates it from clk_disable.  In a
  * simple case, clk_unprepare can be used instead of clk_disable to gate a clk
@@ -819,18 +831,13 @@ void __clk_unprepare(struct clk *clk)
  * part.  It is this reason that clk_unprepare and clk_disable are not mutually
  * exclusive.  In fact clk_disable must be called before clk_unprepare.
  */
-void clk_unprepare(struct clk *clk)
+void clk_unprepare(struct clk *clk_user)
 {
-	if (IS_ERR_OR_NULL(clk))
-		return;
-
-	clk_prepare_lock();
-	__clk_unprepare(clk);
-	clk_prepare_unlock();
+	clk_provider_unprepare(clk_to_clk_core(clk_user));
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
 
-int __clk_prepare(struct clk *clk)
+int __clk_prepare(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -856,9 +863,20 @@ int __clk_prepare(struct clk *clk)
 	return 0;
 }
 
+int clk_provider_prepare(struct clk_core *clk)
+{
+	int ret;
+
+	clk_prepare_lock();
+	ret = __clk_prepare(clk);
+	clk_prepare_unlock();
+
+	return ret;
+}
+
 /**
  * clk_prepare - prepare a clock source
- * @clk: the clk being prepared
+ * @clk_user: the clk being prepared
  *
  * clk_prepare may sleep, which differentiates it from clk_enable.  In a simple
  * case, clk_prepare can be used instead of clk_enable to ungate a clk if the
@@ -868,19 +886,13 @@ int __clk_prepare(struct clk *clk)
  * exclusive.  In fact clk_prepare must be called before clk_enable.
  * Returns 0 on success, -EERROR otherwise.
  */
-int clk_prepare(struct clk *clk)
+int clk_prepare(struct clk *clk_user)
 {
-	int ret;
-
-	clk_prepare_lock();
-	ret = __clk_prepare(clk);
-	clk_prepare_unlock();
-
-	return ret;
+	return clk_provider_prepare(clk_to_clk_core(clk_user));
 }
 EXPORT_SYMBOL_GPL(clk_prepare);
 
-static void __clk_disable(struct clk *clk)
+static void __clk_disable(struct clk_core *clk)
 {
 	if (!clk)
 		return;
@@ -897,9 +909,21 @@ static void __clk_disable(struct clk *clk)
 	__clk_disable(clk->parent);
 }
 
+static void __clk_disable_internal(struct clk_core *clk)
+{
+	unsigned long flags;
+
+	if (IS_ERR_OR_NULL(clk))
+		return;
+
+	flags = clk_enable_lock();
+	__clk_disable(clk);
+	clk_enable_unlock(flags);
+}
+
 /**
  * clk_disable - gate a clock
- * @clk: the clk being gated
+ * @clk_user: the clk being gated
  *
  * clk_disable must not sleep, which differentiates it from clk_unprepare.  In
  * a simple case, clk_disable can be used instead of clk_unprepare to gate a
@@ -909,20 +933,13 @@ static void __clk_disable(struct clk *clk)
  * this reason that clk_unprepare and clk_disable are not mutually exclusive.
  * In fact clk_disable must be called before clk_unprepare.
  */
-void clk_disable(struct clk *clk)
+void clk_disable(struct clk *clk_user)
 {
-	unsigned long flags;
-
-	if (IS_ERR_OR_NULL(clk))
-		return;
-
-	flags = clk_enable_lock();
-	__clk_disable(clk);
-	clk_enable_unlock(flags);
+	__clk_disable_internal(clk_to_clk_core(clk_user));
 }
 EXPORT_SYMBOL_GPL(clk_disable);
 
-static int __clk_enable(struct clk *clk)
+static int __clk_enable(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -951,9 +968,21 @@ static int __clk_enable(struct clk *clk)
 	return 0;
 }
 
+static int __clk_enable_internal(struct clk_core *clk)
+{
+	unsigned long flags;
+	int ret;
+
+	flags = clk_enable_lock();
+	ret = __clk_enable(clk);
+	clk_enable_unlock(flags);
+
+	return ret;
+}
+
 /**
  * clk_enable - ungate a clock
- * @clk: the clk being ungated
+ * @clk_user: the clk being ungated
  *
  * clk_enable must not sleep, which differentiates it from clk_prepare.  In a
  * simple case, clk_enable can be used instead of clk_prepare to ungate a clk
@@ -964,16 +993,9 @@ static int __clk_enable(struct clk *clk)
  * must be called before clk_enable.  Returns 0 on success, -EERROR
  * otherwise.
  */
-int clk_enable(struct clk *clk)
+int clk_enable(struct clk *clk_user)
 {
-	unsigned long flags;
-	int ret;
-
-	flags = clk_enable_lock();
-	ret = __clk_enable(clk);
-	clk_enable_unlock(flags);
-
-	return ret;
+	return __clk_enable_internal(clk_to_clk_core(clk_user));
 }
 EXPORT_SYMBOL_GPL(clk_enable);
 
@@ -984,10 +1006,10 @@ EXPORT_SYMBOL_GPL(clk_enable);
  *
  * Caller must hold prepare_lock.  Useful for clk_ops such as .set_rate
  */
-unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
+unsigned long __clk_round_rate(struct clk_core *clk, unsigned long rate)
 {
 	unsigned long parent_rate = 0;
-	struct clk *parent;
+	struct clk_core *parent;
 
 	if (!clk)
 		return 0;
@@ -1010,15 +1032,16 @@ EXPORT_SYMBOL_GPL(__clk_round_rate);
 
 /**
  * clk_round_rate - round the given rate for a clk
- * @clk: the clk for which we are rounding a rate
+ * @clk_user: the clk for which we are rounding a rate
  * @rate: the rate which is to be rounded
  *
  * Takes in a rate as input and rounds it to a rate that the clk can actually
  * use which is then returned.  If clk doesn't support round_rate operation
  * then the parent rate is returned.
  */
-long clk_round_rate(struct clk *clk, unsigned long rate)
+long clk_round_rate(struct clk *clk_user, unsigned long rate)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	unsigned long ret;
 
 	clk_prepare_lock();
@@ -1031,19 +1054,19 @@ EXPORT_SYMBOL_GPL(clk_round_rate);
 
 /**
  * __clk_notify - call clk notifier chain
- * @clk: struct clk * that is changing rate
+ * @clk: struct clk_core * that is changing rate
  * @msg: clk notifier type (see include/linux/clk.h)
  * @old_rate: old clk rate
  * @new_rate: new clk rate
  *
  * Triggers a notifier call chain on the clk rate-change notification
- * for 'clk'.  Passes a pointer to the struct clk and the previous
+ * for 'clk'.  Passes a pointer to the struct clk_core and the previous
  * and current rates to the notifier callback.  Intended to be called by
  * internal clock code only.  Returns NOTIFY_DONE from the last driver
  * called if all went well, or NOTIFY_STOP or NOTIFY_BAD immediately if
  * a driver returns that.
  */
-static int __clk_notify(struct clk *clk, unsigned long msg,
+static int __clk_notify(struct clk_core *clk, unsigned long msg,
 		unsigned long old_rate, unsigned long new_rate)
 {
 	struct clk_notifier *cn;
@@ -1076,10 +1099,10 @@ static int __clk_notify(struct clk *clk, unsigned long msg,
  *
  * Caller must hold prepare_lock.
  */
-static void __clk_recalc_accuracies(struct clk *clk)
+static void __clk_recalc_accuracies(struct clk_core *clk)
 {
 	unsigned long parent_accuracy = 0;
-	struct clk *child;
+	struct clk_core *child;
 
 	if (clk->parent)
 		parent_accuracy = clk->parent->accuracy;
@@ -1094,16 +1117,7 @@ static void __clk_recalc_accuracies(struct clk *clk)
 		__clk_recalc_accuracies(child);
 }
 
-/**
- * clk_get_accuracy - return the accuracy of clk
- * @clk: the clk whose accuracy is being returned
- *
- * Simply returns the cached accuracy of the clk, unless
- * CLK_GET_ACCURACY_NOCACHE flag is set, which means a recalc_rate will be
- * issued.
- * If clk is NULL then returns 0.
- */
-long clk_get_accuracy(struct clk *clk)
+static long __clk_get_accuracy_internal(struct clk_core *clk)
 {
 	unsigned long accuracy;
 
@@ -1116,9 +1130,23 @@ long clk_get_accuracy(struct clk *clk)
 
 	return accuracy;
 }
+
+/**
+ * clk_get_accuracy - return the accuracy of clk
+ * @clk_user: the clk whose accuracy is being returned
+ *
+ * Simply returns the cached accuracy of the clk, unless
+ * CLK_GET_ACCURACY_NOCACHE flag is set, which means a recalc_rate will be
+ * issued.
+ * If clk is NULL then returns 0.
+ */
+long clk_get_accuracy(struct clk *clk_user)
+{
+	return __clk_get_accuracy_internal(clk_to_clk_core(clk_user));
+}
 EXPORT_SYMBOL_GPL(clk_get_accuracy);
 
-static unsigned long clk_recalc(struct clk *clk, unsigned long parent_rate)
+static unsigned long clk_recalc(struct clk_core *clk, unsigned long parent_rate)
 {
 	if (clk->ops->recalc_rate)
 		return clk->ops->recalc_rate(clk->hw, parent_rate);
@@ -1139,11 +1167,11 @@ static unsigned long clk_recalc(struct clk *clk, unsigned long parent_rate)
  *
  * Caller must hold prepare_lock.
  */
-static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
+static void __clk_recalc_rates(struct clk_core *clk, unsigned long msg)
 {
 	unsigned long old_rate;
 	unsigned long parent_rate = 0;
-	struct clk *child;
+	struct clk_core *child;
 
 	old_rate = clk->rate;
 
@@ -1163,15 +1191,7 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
 		__clk_recalc_rates(child, msg);
 }
 
-/**
- * clk_get_rate - return the rate of clk
- * @clk: the clk whose rate is being returned
- *
- * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
- * is set, which means a recalc_rate will be issued.
- * If clk is NULL then returns 0.
- */
-unsigned long clk_get_rate(struct clk *clk)
+unsigned long clk_provider_get_rate(struct clk_core *clk)
 {
 	unsigned long rate;
 
@@ -1185,15 +1205,29 @@ unsigned long clk_get_rate(struct clk *clk)
 
 	return rate;
 }
+EXPORT_SYMBOL_GPL(clk_provider_get_rate);
+
+/**
+ * clk_get_rate - return the rate of clk
+ * @clk_user: the clk whose rate is being returned
+ *
+ * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
+ * is set, which means a recalc_rate will be issued.
+ * If clk is NULL then returns 0.
+ */
+unsigned long clk_get_rate(struct clk *clk_user)
+{
+	return clk_provider_get_rate(clk_to_clk_core(clk_user));
+}
 EXPORT_SYMBOL_GPL(clk_get_rate);
 
-static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
+static int clk_fetch_parent_index(struct clk_core *clk, struct clk_core *parent)
 {
 	int i;
 
 	if (!clk->parents) {
 		clk->parents = kcalloc(clk->num_parents,
-					sizeof(struct clk *), GFP_KERNEL);
+					sizeof(struct clk_core *), GFP_KERNEL);
 		if (!clk->parents)
 			return -ENOMEM;
 	}
@@ -1219,7 +1253,7 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
 	return -EINVAL;
 }
 
-static void clk_reparent(struct clk *clk, struct clk *new_parent)
+static void clk_reparent(struct clk_core *clk, struct clk_core *new_parent)
 {
 	hlist_del(&clk->child_node);
 
@@ -1236,10 +1270,10 @@ static void clk_reparent(struct clk *clk, struct clk *new_parent)
 	clk->parent = new_parent;
 }
 
-static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
+static struct clk_core *__clk_set_parent_before(struct clk_core *clk, struct clk_core *parent)
 {
 	unsigned long flags;
-	struct clk *old_parent = clk->parent;
+	struct clk_core *old_parent = clk->parent;
 
 	/*
 	 * Migrate prepare state between parents and prevent race with
@@ -1260,8 +1294,8 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 	 */
 	if (clk->prepare_count) {
 		__clk_prepare(parent);
-		clk_enable(parent);
-		clk_enable(clk);
+		__clk_enable_internal(parent);
+		__clk_enable_internal(clk);
 	}
 
 	/* update the clk tree topology */
@@ -1272,16 +1306,16 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 	return old_parent;
 }
 
-static void __clk_set_parent_after(struct clk *clk, struct clk *parent,
-		struct clk *old_parent)
+static void __clk_set_parent_after(struct clk_core *clk, struct clk_core *parent,
+		struct clk_core *old_parent)
 {
 	/*
 	 * Finish the migration of prepare state and undo the changes done
 	 * for preventing a race with clk_enable().
 	 */
 	if (clk->prepare_count) {
-		clk_disable(clk);
-		clk_disable(old_parent);
+		__clk_disable_internal(clk);
+		__clk_disable_internal(old_parent);
 		__clk_unprepare(old_parent);
 	}
 
@@ -1289,11 +1323,11 @@ static void __clk_set_parent_after(struct clk *clk, struct clk *parent,
 	clk_debug_reparent(clk, parent);
 }
 
-static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
+static int __clk_set_parent(struct clk_core *clk, struct clk_core *parent, u8 p_index)
 {
 	unsigned long flags;
 	int ret = 0;
-	struct clk *old_parent;
+	struct clk_core *old_parent;
 
 	old_parent = __clk_set_parent_before(clk, parent);
 
@@ -1307,8 +1341,8 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
 		clk_enable_unlock(flags);
 
 		if (clk->prepare_count) {
-			clk_disable(clk);
-			clk_disable(parent);
+			__clk_disable_internal(clk);
+			__clk_disable_internal(parent);
 			__clk_unprepare(parent);
 		}
 		return ret;
@@ -1335,9 +1369,9 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
  *
  * Caller must hold prepare_lock.
  */
-static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
+static int __clk_speculate_rates(struct clk_core *clk, unsigned long parent_rate)
 {
-	struct clk *child;
+	struct clk_core *child;
 	unsigned long new_rate;
 	int ret = NOTIFY_DONE;
 
@@ -1363,10 +1397,10 @@ out:
 	return ret;
 }
 
-static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
-			     struct clk *new_parent, u8 p_index)
+static void clk_calc_subtree(struct clk_core *clk, unsigned long new_rate,
+			     struct clk_core *new_parent, u8 p_index)
 {
-	struct clk *child;
+	struct clk_core *child;
 
 	clk->new_rate = new_rate;
 	clk->new_parent = new_parent;
@@ -1386,10 +1420,10 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
  * calculate the new rates returning the topmost clock that has to be
  * changed.
  */
-static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
+static struct clk_core *clk_calc_new_rates(struct clk_core *clk, unsigned long rate)
 {
-	struct clk *top = clk;
-	struct clk *old_parent, *parent;
+	struct clk_core *top = clk;
+	struct clk_core *old_parent, *parent;
 	unsigned long best_parent_rate = 0;
 	unsigned long new_rate;
 	int p_index = 0;
@@ -1455,9 +1489,9 @@ out:
  * so that in case of an error we can walk down the whole tree again and
  * abort the change.
  */
-static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
+static struct clk_core *clk_propagate_rate_change(struct clk_core *clk, unsigned long event)
 {
-	struct clk *child, *tmp_clk, *fail_clk = NULL;
+	struct clk_core *child, *tmp_clk, *fail_clk = NULL;
 	int ret = NOTIFY_DONE;
 
 	if (clk->rate == clk->new_rate)
@@ -1492,13 +1526,13 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
  * walk down a subtree and set the new rates notifying the rate
  * change on the way
  */
-static void clk_change_rate(struct clk *clk)
+static void clk_change_rate(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 	unsigned long old_rate;
 	unsigned long best_parent_rate = 0;
 	bool skip_set_rate = false;
-	struct clk *old_parent;
+	struct clk_core *old_parent;
 
 	old_rate = clk->rate;
 
@@ -1542,30 +1576,9 @@ static void clk_change_rate(struct clk *clk)
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
+int clk_provider_set_rate(struct clk_core *clk, unsigned long rate)
 {
-	struct clk *top, *fail_clk;
+	struct clk_core *top, *fail_clk;
 	int ret = 0;
 
 	if (!clk)
@@ -1575,7 +1588,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	clk_prepare_lock();
 
 	/* bail early if nothing to do */
-	if (rate == clk_get_rate(clk))
+	if (rate == clk_provider_get_rate(clk))
 		goto out;
 
 	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
@@ -1608,17 +1621,38 @@ out:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(clk_set_rate);
+EXPORT_SYMBOL_GPL(clk_provider_set_rate);
 
 /**
- * clk_get_parent - return the parent of a clk
- * @clk: the clk whose parent gets returned
+ * clk_set_rate - specify a new rate for clk
+ * @clk_user: the clk whose rate is being changed
+ * @rate: the new rate for clk
  *
- * Simply returns clk->parent.  Returns NULL if clk is NULL.
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
  */
-struct clk *clk_get_parent(struct clk *clk)
+int clk_set_rate(struct clk *clk_user, unsigned long rate)
+{
+	return clk_provider_set_rate(clk_to_clk_core(clk_user), rate);
+}
+EXPORT_SYMBOL_GPL(clk_set_rate);
+
+struct clk_core *clk_provider_get_parent(struct clk_core *clk)
 {
-	struct clk *parent;
+	struct clk_core *parent;
 
 	clk_prepare_lock();
 	parent = __clk_get_parent(clk);
@@ -1626,8 +1660,28 @@ struct clk *clk_get_parent(struct clk *clk)
 
 	return parent;
 }
+EXPORT_SYMBOL_GPL(clk_provider_get_parent);
+
+/**
+ * clk_get_parent - return the parent of a clk
+ * @clk_user: the clk whose parent gets returned
+ *
+ * Simply returns clk->parent.  Returns NULL if clk is NULL.
+ */
+struct clk *clk_get_parent(struct clk *clk_user)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+
+	return clk_core_to_clk(clk_provider_get_parent(clk));
+}
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
+const char *clk_get_name(struct clk *clk_user)
+{
+	return __clk_get_name(clk_to_clk_core(clk_user));
+}
+EXPORT_SYMBOL_GPL(clk_get_name);
+
 /*
  * .get_parent is mandatory for clocks with multiple possible parents.  It is
  * optional for single-parent clocks.  Always call .get_parent if it is
@@ -1637,9 +1691,9 @@ EXPORT_SYMBOL_GPL(clk_get_parent);
  * .parents array exists, and if so use it to avoid an expensive tree
  * traversal.  If .parents does not exist then walk the tree with __clk_lookup.
  */
-static struct clk *__clk_init_parent(struct clk *clk)
+static struct clk_core *__clk_init_parent(struct clk_core *clk)
 {
-	struct clk *ret = NULL;
+	struct clk_core *ret = NULL;
 	u8 index;
 
 	/* handle the trivial cases */
@@ -1671,7 +1725,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
 
 	if (!clk->parents)
 		clk->parents =
-			kcalloc(clk->num_parents, sizeof(struct clk *),
+			kcalloc(clk->num_parents, sizeof(struct clk_core *),
 					GFP_KERNEL);
 
 	ret = clk_get_parent_by_index(clk, index);
@@ -1680,7 +1734,7 @@ out:
 	return ret;
 }
 
-void __clk_reparent(struct clk *clk, struct clk *new_parent)
+void __clk_reparent(struct clk_core *clk, struct clk_core *new_parent)
 {
 	clk_reparent(clk, new_parent);
 	clk_debug_reparent(clk, new_parent);
@@ -1688,24 +1742,7 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
 	__clk_recalc_rates(clk, POST_RATE_CHANGE);
 }
 
-/**
- * clk_set_parent - switch the parent of a mux clk
- * @clk: the mux clk whose input we are switching
- * @parent: the new input to clk
- *
- * Re-parent clk to use parent as its new input source.  If clk is in
- * prepared state, the clk will get enabled for the duration of this call. If
- * that's not acceptable for a specific clk (Eg: the consumer can't handle
- * that, the reparenting is glitchy in hardware, etc), use the
- * CLK_SET_PARENT_GATE flag to allow reparenting only when clk is unprepared.
- *
- * After successfully changing clk's parent clk_set_parent will update the
- * clk topology, sysfs topology and propagate rate recalculation via
- * __clk_recalc_rates.
- *
- * Returns 0 on success, -EERROR otherwise.
- */
-int clk_set_parent(struct clk *clk, struct clk *parent)
+int clk_provider_set_parent(struct clk_core *clk, struct clk_core *parent)
 {
 	int ret = 0;
 	int p_index = 0;
@@ -1765,6 +1802,32 @@ out:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(clk_provider_set_parent);
+
+/**
+ * clk_set_parent - switch the parent of a mux clk
+ * @clk_user: the mux clk whose input we are switching
+ * @parent_user: the new input to clk
+ *
+ * Re-parent clk to use parent as its new input source.  If clk is in
+ * prepared state, the clk will get enabled for the duration of this call. If
+ * that's not acceptable for a specific clk (Eg: the consumer can't handle
+ * that, the reparenting is glitchy in hardware, etc), use the
+ * CLK_SET_PARENT_GATE flag to allow reparenting only when clk is unprepared.
+ *
+ * After successfully changing clk's parent clk_set_parent will update the
+ * clk topology, sysfs topology and propagate rate recalculation via
+ * __clk_recalc_rates.
+ *
+ * Returns 0 on success, -EERROR otherwise.
+ */
+int clk_set_parent(struct clk *clk_user, struct clk *parent_user)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+	struct clk_core *parent = clk_to_clk_core(parent_user);
+
+	return clk_provider_set_parent(clk, parent);
+}
 EXPORT_SYMBOL_GPL(clk_set_parent);
 
 /**
@@ -1775,10 +1838,10 @@ EXPORT_SYMBOL_GPL(clk_set_parent);
  * Initializes the lists in struct clk, queries the hardware for the
  * parent and rate and sets them both.
  */
-int __clk_init(struct device *dev, struct clk *clk)
+int __clk_init(struct device *dev, struct clk_core *clk)
 {
 	int i, ret = 0;
-	struct clk *orphan;
+	struct clk_core *orphan;
 	struct hlist_node *tmp2;
 
 	if (!clk)
@@ -1826,7 +1889,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 				__func__, clk->name);
 
 	/*
-	 * Allocate an array of struct clk *'s to avoid unnecessary string
+	 * Allocate an array of struct clk_core *'s to avoid unnecessary string
 	 * look-ups of clk's possible parents.  This can fail for clocks passed
 	 * in to clk_init during early boot; thus any access to clk->parents[]
 	 * must always check for a NULL pointer and try to populate it if
@@ -1836,7 +1899,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 * for clock drivers to statically initialize clk->parents.
 	 */
 	if (clk->num_parents > 1 && !clk->parents) {
-		clk->parents = kcalloc(clk->num_parents, sizeof(struct clk *),
+		clk->parents = kcalloc(clk->num_parents, sizeof(struct clk_core *),
 					GFP_KERNEL);
 		/*
 		 * __clk_lookup returns NULL for parents that have not been
@@ -1942,7 +2005,7 @@ out:
  *
  * Same as clk_register, except that the .clk field inside hw shall point to a
  * preallocated (generally statically allocated) struct clk. None of the fields
- * of the struct clk need to be initialized.
+ * of the struct clk_core need to be initialized.
  *
  * The data pointed to by .init and .clk field shall NOT be marked as init
  * data.
@@ -1954,10 +2017,10 @@ out:
  * separate C file from the logic that implements its operations.  Returns 0
  * on success, otherwise an error code.
  */
-struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
+struct clk_core *__clk_register(struct device *dev, struct clk_hw *hw)
 {
 	int ret;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = hw->clk;
 	clk->name = hw->init->name;
@@ -1985,15 +2048,15 @@ EXPORT_SYMBOL_GPL(__clk_register);
  * @hw: link to hardware-specific clock data
  *
  * clk_register is the primary interface for populating the clock tree with new
- * clock nodes.  It returns a pointer to the newly allocated struct clk which
+ * clock nodes.  It returns a pointer to the newly allocated struct clk_core which
  * cannot be dereferenced by driver code but may be used in conjuction with the
  * rest of the clock API.  In the event of an error clk_register will return an
  * error code; drivers must test for an error code after calling clk_register.
  */
-struct clk *clk_register(struct device *dev, struct clk_hw *hw)
+struct clk_core *clk_register(struct device *dev, struct clk_hw *hw)
 {
 	int i, ret;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
 	if (!clk) {
@@ -2061,7 +2124,7 @@ EXPORT_SYMBOL_GPL(clk_register);
  */
 static void __clk_release(struct kref *ref)
 {
-	struct clk *clk = container_of(ref, struct clk, ref);
+	struct clk_core *clk = container_of(ref, struct clk_core, ref);
 	int i = clk->num_parents;
 
 	kfree(clk->parents);
@@ -2112,7 +2175,7 @@ static const struct clk_ops clk_nodrv_ops = {
  * clk_unregister - unregister a currently registered clock
  * @clk: clock to unregister
  */
-void clk_unregister(struct clk *clk)
+void clk_unregister(struct clk_core *clk)
 {
 	unsigned long flags;
 
@@ -2134,12 +2197,12 @@ void clk_unregister(struct clk *clk)
 	clk_enable_unlock(flags);
 
 	if (!hlist_empty(&clk->children)) {
-		struct clk *child;
+		struct clk_core *child;
 		struct hlist_node *t;
 
 		/* Reparent all children to the orphan list. */
 		hlist_for_each_entry_safe(child, t, &clk->children, child_node)
-			clk_set_parent(child, NULL);
+			clk_provider_set_parent(child, NULL);
 	}
 
 	clk_debug_unregister(clk);
@@ -2158,7 +2221,7 @@ EXPORT_SYMBOL_GPL(clk_unregister);
 
 static void devm_clk_release(struct device *dev, void *res)
 {
-	clk_unregister(*(struct clk **)res);
+	clk_unregister(*(struct clk_core **)res);
 }
 
 /**
@@ -2170,10 +2233,10 @@ static void devm_clk_release(struct device *dev, void *res)
  * automatically clk_unregister()ed on driver detach. See clk_register() for
  * more information.
  */
-struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw)
+struct clk_core *devm_clk_register(struct device *dev, struct clk_hw *hw)
 {
-	struct clk *clk;
-	struct clk **clkp;
+	struct clk_core *clk;
+	struct clk_core **clkp;
 
 	clkp = devres_alloc(devm_clk_release, sizeof(*clkp), GFP_KERNEL);
 	if (!clkp)
@@ -2193,7 +2256,7 @@ EXPORT_SYMBOL_GPL(devm_clk_register);
 
 static int devm_clk_match(struct device *dev, void *res, void *data)
 {
-	struct clk *c = res;
+	struct clk_core *c = res;
 	if (WARN_ON(!c))
 		return 0;
 	return c == data;
@@ -2207,7 +2270,7 @@ static int devm_clk_match(struct device *dev, void *res, void *data)
  * this function will not need to be called and the resource management
  * code will ensure that the resource is freed.
  */
-void devm_clk_unregister(struct device *dev, struct clk *clk)
+void devm_clk_unregister(struct device *dev, struct clk_core *clk)
 {
 	WARN_ON(devres_release(dev, devm_clk_release, devm_clk_match, clk));
 }
@@ -2216,7 +2279,7 @@ EXPORT_SYMBOL_GPL(devm_clk_unregister);
 /*
  * clkdev helpers
  */
-int __clk_get(struct clk *clk)
+int __clk_get(struct clk_core *clk)
 {
 	if (clk) {
 		if (!try_module_get(clk->owner))
@@ -2227,7 +2290,7 @@ int __clk_get(struct clk *clk)
 	return 1;
 }
 
-void __clk_put(struct clk *clk)
+void __clk_put(struct clk_core *clk)
 {
 	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
 		return;
@@ -2243,7 +2306,7 @@ void __clk_put(struct clk *clk)
 
 /**
  * clk_notifier_register - add a clk rate change notifier
- * @clk: struct clk * to watch
+ * @clk_user: struct clk * to watch
  * @nb: struct notifier_block * with callback info
  *
  * Request notification when clk's rate changes.  This uses an SRCU
@@ -2262,8 +2325,9 @@ void __clk_put(struct clk *clk)
  * allocation failure; otherwise, passes along the return value of
  * srcu_notifier_chain_register().
  */
-int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
+int clk_notifier_register(struct clk *clk_user, struct notifier_block *nb)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	struct clk_notifier *cn;
 	int ret = -ENOMEM;
 
@@ -2302,7 +2366,7 @@ EXPORT_SYMBOL_GPL(clk_notifier_register);
 
 /**
  * clk_notifier_unregister - remove a clk rate change notifier
- * @clk: struct clk *
+ * @clk_user: struct clk_core *
  * @nb: struct notifier_block * with callback info
  *
  * Request no further notification for changes to 'clk' and frees memory
@@ -2311,8 +2375,9 @@ EXPORT_SYMBOL_GPL(clk_notifier_register);
  * Returns -EINVAL if called with null arguments; otherwise, passes
  * along the return value of srcu_notifier_chain_unregister().
  */
-int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
+int clk_notifier_unregister(struct clk *clk_user, struct notifier_block *nb)
 {
+	struct clk_core *clk = clk_to_clk_core(clk_user);
 	struct clk_notifier *cn = NULL;
 	int ret = -EINVAL;
 
@@ -2352,7 +2417,7 @@ EXPORT_SYMBOL_GPL(clk_notifier_unregister);
  * struct of_clk_provider - Clock provider registration structure
  * @link: Entry in global list of clock providers
  * @node: Pointer to device tree node of clock provider
- * @get: Get clock callback.  Returns NULL or a struct clk for the
+ * @get: Get clock callback.  Returns NULL or a struct clk_core for the
  *       given clock specifier
  * @data: context pointer to be passed into @get callback
  */
@@ -2360,7 +2425,7 @@ struct of_clk_provider {
 	struct list_head link;
 
 	struct device_node *node;
-	struct clk *(*get)(struct of_phandle_args *clkspec, void *data);
+	struct clk_core *(*get)(struct of_phandle_args *clkspec, void *data);
 	void *data;
 };
 
@@ -2381,14 +2446,14 @@ void of_clk_unlock(void)
 	mutex_unlock(&of_clk_mutex);
 }
 
-struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
+struct clk_core *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 				     void *data)
 {
 	return data;
 }
 EXPORT_SYMBOL_GPL(of_clk_src_simple_get);
 
-struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data)
+struct clk_core *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data)
 {
 	struct clk_onecell_data *clk_data = data;
 	unsigned int idx = clkspec->args[0];
@@ -2409,7 +2474,7 @@ EXPORT_SYMBOL_GPL(of_clk_src_onecell_get);
  * @data: context pointer for @clk_src_get callback.
  */
 int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *clkspec,
+			struct clk_core *(*clk_src_get)(struct of_phandle_args *clkspec,
 						   void *data),
 			void *data)
 {
@@ -2453,10 +2518,10 @@ void of_clk_del_provider(struct device_node *np)
 }
 EXPORT_SYMBOL_GPL(of_clk_del_provider);
 
-struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec)
+struct clk_core *__of_clk_get_from_provider(struct of_phandle_args *clkspec)
 {
 	struct of_clk_provider *provider;
-	struct clk *clk = ERR_PTR(-EPROBE_DEFER);
+	struct clk_core *clk = ERR_PTR(-EPROBE_DEFER);
 
 	/* Check if we have such a provider in our array */
 	list_for_each_entry(provider, &of_clk_providers, link) {
@@ -2469,9 +2534,9 @@ struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec)
 	return clk;
 }
 
-struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
+struct clk_core *of_clk_get_from_provider(struct of_phandle_args *clkspec)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	mutex_lock(&of_clk_mutex);
 	clk = __of_clk_get_from_provider(clkspec);
@@ -2546,11 +2611,11 @@ static int parent_ready(struct device_node *np)
 	int i = 0;
 
 	while (true) {
-		struct clk *clk = of_clk_get(np, i);
+		struct clk_core *clk = of_clk_provider_get(np, i);
 
 		/* this parent is ready we can check the next one */
 		if (!IS_ERR(clk)) {
-			clk_put(clk);
+			__clk_put(clk);
 			i++;
 			continue;
 		}
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index d278572..c69f4fe 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -15,3 +15,7 @@ struct clk_core *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
 void of_clk_lock(void);
 void of_clk_unlock(void);
 #endif
+
+#if defined(CONFIG_COMMON_CLK)
+#define clk_to_clk_core(clk)	(clk->core)
+#endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 000c1ae..48811c0 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/clk.h>
+#include <linux/clk-private.h>
 #include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/of.h>
@@ -33,13 +34,13 @@ static DEFINE_MUTEX(clocks_mutex);
  * of_clk_get_by_clkspec() - Lookup a clock form a clock provider
  * @clkspec: pointer to a clock specifier data structure
  *
- * This function looks up a struct clk from the registered list of clock
+ * This function looks up a struct clk_core from the registered list of clock
  * providers, an input is a clock specifier data structure as returned
  * from the of_parse_phandle_with_args() function call.
  */
-struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec)
+struct clk_core *of_clk_get_by_clkspec(struct of_phandle_args *clkspec)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (!clkspec)
 		return ERR_PTR(-EINVAL);
@@ -54,10 +55,10 @@ struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec)
 	return clk;
 }
 
-struct clk *of_clk_get(struct device_node *np, int index)
+struct clk_core *of_clk_provider_get(struct device_node *np, int index)
 {
 	struct of_phandle_args clkspec;
-	struct clk *clk;
+	clk_core_t *clk;
 	int rc;
 
 	if (index < 0)
@@ -72,20 +73,16 @@ struct clk *of_clk_get(struct device_node *np, int index)
 	of_node_put(clkspec.np);
 	return clk;
 }
+
+struct clk *of_clk_get(struct device_node *np, int index)
+{
+	return clk_core_to_clk(of_clk_provider_get(np, index));
+}
 EXPORT_SYMBOL(of_clk_get);
 
-/**
- * of_clk_get_by_name() - Parse and lookup a clock referenced by a device node
- * @np: pointer to clock consumer node
- * @name: name of consumer's clock input, or NULL for the first clock reference
- *
- * This function parses the clocks and clock-names properties,
- * and uses them to look up the struct clk from the registered list of clock
- * providers.
- */
-struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
+struct clk_core *of_clk_provider_get_by_name(struct device_node *np, const char *name)
 {
-	struct clk *clk = ERR_PTR(-ENOENT);
+	struct clk_core *clk = ERR_PTR(-ENOENT);
 
 	/* Walk up the tree of devices looking for a clock that matches */
 	while (np) {
@@ -98,7 +95,7 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 		 */
 		if (name)
 			index = of_property_match_string(np, "clock-names", name);
-		clk = of_clk_get(np, index);
+		clk = of_clk_provider_get(np, index);
 		if (!IS_ERR(clk))
 			break;
 		else if (name && index >= 0) {
@@ -119,11 +116,25 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 
 	return clk;
 }
+
+/**
+ * of_clk_get_by_name() - Parse and lookup a clock referenced by a device node
+ * @np: pointer to clock consumer node
+ * @name: name of consumer's clock input, or NULL for the first clock reference
+ *
+ * This function parses the clocks and clock-names properties,
+ * and uses them to look up the clock from the registered list of clock
+ * providers.
+ */
+struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
+{
+	return clk_core_to_clk(of_clk_provider_get_by_name(np, name));
+}
 EXPORT_SYMBOL(of_clk_get_by_name);
 #endif
 
 /*
- * Find the correct struct clk for the device and connection ID.
+ * Find the correct clock for the device and connection ID.
  * We do slightly fuzzy matching here:
  *  An entry with a NULL ID is assumed to be a wildcard.
  *  If an entry has a device ID, it must match
@@ -165,7 +176,7 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
 	return cl;
 }
 
-struct clk *clk_get_sys(const char *dev_id, const char *con_id)
+struct clk_core *clk_provider_get_sys(const char *dev_id, const char *con_id)
 {
 	struct clk_lookup *cl;
 
@@ -175,30 +186,45 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 		cl = NULL;
 	mutex_unlock(&clocks_mutex);
 
-	return cl ? cl->clk : ERR_PTR(-ENOENT);
+	if (!cl)
+		return ERR_PTR(-ENOENT);
+
+	return cl->clk;
+}
+EXPORT_SYMBOL_GPL(clk_provider_get_sys);
+
+struct clk *clk_get_sys(const char *dev_id, const char *con_id)
+{
+	return clk_core_to_clk(clk_provider_get_sys(dev_id, con_id));
 }
 EXPORT_SYMBOL(clk_get_sys);
 
-struct clk *clk_get(struct device *dev, const char *con_id)
+struct clk_core *clk_provider_get(struct device *dev, const char *con_id)
 {
 	const char *dev_id = dev ? dev_name(dev) : NULL;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (dev) {
-		clk = of_clk_get_by_name(dev->of_node, con_id);
+		clk = of_clk_provider_get_by_name(dev->of_node, con_id);
 		if (!IS_ERR(clk))
 			return clk;
 		if (PTR_ERR(clk) == -EPROBE_DEFER)
 			return clk;
 	}
 
-	return clk_get_sys(dev_id, con_id);
+	return clk_provider_get_sys(dev_id, con_id);
+}
+EXPORT_SYMBOL(clk_provider_get);
+
+struct clk *clk_get(struct device *dev, const char *con_id)
+{
+	return clk_core_to_clk(clk_provider_get(dev, con_id));
 }
 EXPORT_SYMBOL(clk_get);
 
 void clk_put(struct clk *clk)
 {
-	__clk_put(clk);
+	__clk_put(clk_to_clk_core(clk));
 }
 EXPORT_SYMBOL(clk_put);
 
@@ -230,7 +256,7 @@ struct clk_lookup_alloc {
 };
 
 static struct clk_lookup * __init_refok
-vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
+vclkdev_alloc(clk_core_t *clk, const char *con_id, const char *dev_fmt,
 	va_list ap)
 {
 	struct clk_lookup_alloc *cla;
@@ -254,7 +280,7 @@ vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
 }
 
 struct clk_lookup * __init_refok
-clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
+clkdev_alloc(clk_core_t *clk, const char *con_id, const char *dev_fmt, ...)
 {
 	struct clk_lookup *cl;
 	va_list ap;
@@ -276,7 +302,7 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
 	if (IS_ERR(r))
 		return PTR_ERR(r);
 
-	l = clkdev_alloc(r, alias, alias_dev_name);
+	l = clkdev_alloc(clk_to_clk_core(r), alias, alias_dev_name);
 	clk_put(r);
 	if (!l)
 		return -ENODEV;
@@ -299,7 +325,7 @@ EXPORT_SYMBOL(clkdev_drop);
 
 /**
  * clk_register_clkdev - register one clock lookup for a struct clk
- * @clk: struct clk to associate with all clk_lookups
+ * @clk: clock to associate with all clk_lookups
  * @con_id: connection ID string on device
  * @dev_id: format string describing device name
  *
@@ -311,7 +337,7 @@ EXPORT_SYMBOL(clkdev_drop);
  * those.  This is to permit this function to be called immediately
  * after clk_register().
  */
-int clk_register_clkdev(struct clk *clk, const char *con_id,
+int clk_register_clkdev(clk_core_t *clk, const char *con_id,
 	const char *dev_fmt, ...)
 {
 	struct clk_lookup *cl;
@@ -334,7 +360,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
 
 /**
  * clk_register_clkdevs - register a set of clk_lookup for a struct clk
- * @clk: struct clk to associate with all clk_lookups
+ * @clk: clock to associate with all clk_lookups
  * @cl: array of clk_lookup structures with con_id and dev_id pre-initialized
  * @num: number of clk_lookup structures to register
  *
@@ -343,7 +369,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
  * those.  This is to permit this function to be called immediately
  * after clk_register().
  */
-int clk_register_clkdevs(struct clk *clk, struct clk_lookup *cl, size_t num)
+int clk_register_clkdevs(clk_core_t *clk, struct clk_lookup *cl, size_t num)
 {
 	unsigned i;
 
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index efbf70b..2c1ece9 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -28,20 +28,20 @@
 
 struct module;
 
-struct clk {
+struct clk_core {
 	const char		*name;
 	const struct clk_ops	*ops;
 	struct clk_hw		*hw;
 	struct module		*owner;
-	struct clk		*parent;
+	struct clk_core		*parent;
 	const char		**parent_names;
-	struct clk		**parents;
+	struct clk_core		**parents;
 	u8			num_parents;
 	u8			new_parent_index;
 	unsigned long		rate;
 	unsigned long		new_rate;
-	struct clk		*new_parent;
-	struct clk		*new_child;
+	struct clk_core		*new_parent;
+	struct clk_core		*new_child;
 	unsigned long		flags;
 	unsigned int		enable_count;
 	unsigned int		prepare_count;
@@ -55,6 +55,10 @@ struct clk {
 	struct kref		ref;
 };
 
+struct clk {
+	struct clk_core	*core;
+};
+
 /*
  * DOC: Basic clock implementations common to many platforms
  *
@@ -66,7 +70,7 @@ struct clk {
 
 #define DEFINE_CLK(_name, _ops, _flags, _parent_names,		\
 		_parents)					\
-	static struct clk _name = {				\
+	static struct clk_core _name = {				\
 		.name = #_name,					\
 		.ops = &_ops,					\
 		.hw = &_name##_hw.hw,				\
@@ -78,7 +82,7 @@ struct clk {
 
 #define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,		\
 				_fixed_rate_flags)		\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static const char *_name##_parent_names[] = {};		\
 	static struct clk_fixed_rate _name##_hw = {		\
 		.hw = {						\
@@ -93,11 +97,11 @@ struct clk {
 #define DEFINE_CLK_GATE(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _bit_idx,		\
 				_gate_flags, _lock)		\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_gate _name##_hw = {			\
@@ -115,11 +119,11 @@ struct clk {
 #define _DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _shift, _width,	\
 				_divider_flags, _table, _lock)	\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_divider _name##_hw = {		\
@@ -154,7 +158,7 @@ struct clk {
 #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
 				_reg, _shift, _width,		\
 				_mux_flags, _lock)		\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static struct clk_mux _name##_hw = {			\
 		.hw = {						\
 			.clk = &_name,				\
@@ -171,11 +175,11 @@ struct clk {
 #define DEFINE_CLK_FIXED_FACTOR(_name, _parent_name,		\
 				_parent_ptr, _flags,		\
 				_mult, _div)			\
-	static struct clk _name;				\
+	static struct clk_core _name;				\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_fixed_factor _name##_hw = {		\
@@ -196,7 +200,7 @@ struct clk {
  * Initializes the lists in struct clk, queries the hardware for the
  * parent and rate and sets them both.
  *
- * Any struct clk passed into __clk_init must have the following members
+ * Any struct clk_core passed into __clk_init must have the following members
  * populated:
  * 	.name
  * 	.ops
@@ -210,9 +214,9 @@ struct clk {
  *
  * Returns 0 on success, otherwise an error code.
  */
-int __clk_init(struct device *dev, struct clk *clk);
+int __clk_init(struct device *dev, struct clk_core *clk);
 
-struct clk *__clk_register(struct device *dev, struct clk_hw *hw);
+struct clk_core *__clk_register(struct device *dev, struct clk_hw *hw);
 
 #endif /* CONFIG_COMMON_CLK */
 #endif /* CLK_PRIVATE_H */
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index f359f3e..87de32c 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -16,26 +16,8 @@
 
 #ifdef CONFIG_COMMON_CLK
 
-/* Temporarily map the to-be-added API to the old API, just so stuff compiles */
-#define clk_core			clk
-
-#define clk_core_to_clk
-
-#define clk_provider_get		clk_get
-#define clk_provider_get_sys		clk_get_sys
-#define devm_clk_provider_get		devm_clk_get
-#define of_clk_provider_get		of_clk_get
-#define of_clk_provider_get_by_name	of_clk_get_by_name
-
-#define clk_provider_set_rate		clk_set_rate
-#define clk_provider_get_rate		clk_get_rate
-#define clk_provider_set_parent		clk_set_parent
-#define clk_provider_get_parent		clk_get_parent
-#define clk_provider_prepare		clk_prepare
-#define clk_provider_unprepare		clk_unprepare
-
 /*
- * flags used across common struct clk.  these flags should only affect the
+ * flags used across common struct clk_core.  these flags should only affect the
  * top-level framework.  custom flags for dealing with hardware specifics
  * belong in struct clk_foo
  */
@@ -185,7 +167,7 @@ struct clk_ops {
 					unsigned long *parent_rate);
 	long		(*determine_rate)(struct clk_hw *hw, unsigned long rate,
 					unsigned long *best_parent_rate,
-					struct clk **best_parent_clk);
+					struct clk_core **best_parent_clk);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
 	u8		(*get_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long rate,
@@ -218,19 +200,19 @@ struct clk_init_data {
 };
 
 /**
- * struct clk_hw - handle for traversing from a struct clk to its corresponding
+ * struct clk_hw - handle for traversing from a struct clk_core to its corresponding
  * hardware-specific structure.  struct clk_hw should be declared within struct
- * clk_foo and then referenced by the struct clk instance that uses struct
+ * clk_foo and then referenced by the struct clk_core instance that uses struct
  * clk_foo's clk_ops
  *
- * @clk: pointer to the struct clk instance that points back to this struct
+ * @clk: pointer to the struct clk_core instance that points back to this struct
  * clk_hw instance
  *
  * @init: pointer to struct clk_init_data that contains the init data shared
  * with the common clock framework.
  */
 struct clk_hw {
-	struct clk *clk;
+	struct clk_core *clk;
 	const struct clk_init_data *init;
 };
 
@@ -256,10 +238,10 @@ struct clk_fixed_rate {
 };
 
 extern const struct clk_ops clk_fixed_rate_ops;
-struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_rate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate);
-struct clk *clk_register_fixed_rate_with_accuracy(struct device *dev,
+struct clk_core *clk_register_fixed_rate_with_accuracy(struct device *dev,
 		const char *name, const char *parent_name, unsigned long flags,
 		unsigned long fixed_rate, unsigned long fixed_accuracy);
 
@@ -297,7 +279,7 @@ struct clk_gate {
 #define CLK_GATE_HIWORD_MASK		BIT(1)
 
 extern const struct clk_ops clk_gate_ops;
-struct clk *clk_register_gate(struct device *dev, const char *name,
+struct clk_core *clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock);
@@ -360,11 +342,11 @@ struct clk_divider {
 
 extern const struct clk_ops clk_divider_ops;
 extern const struct clk_ops clk_divider_ro_ops;
-struct clk *clk_register_divider(struct device *dev, const char *name,
+struct clk_core *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, spinlock_t *lock);
-struct clk *clk_register_divider_table(struct device *dev, const char *name,
+struct clk_core *clk_register_divider_table(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
@@ -409,12 +391,12 @@ struct clk_mux {
 extern const struct clk_ops clk_mux_ops;
 extern const struct clk_ops clk_mux_ro_ops;
 
-struct clk *clk_register_mux(struct device *dev, const char *name,
+struct clk_core *clk_register_mux(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_mux_flags, spinlock_t *lock);
 
-struct clk *clk_register_mux_table(struct device *dev, const char *name,
+struct clk_core *clk_register_mux_table(struct device *dev, const char *name,
 		const char **parent_names, u8 num_parents, unsigned long flags,
 		void __iomem *reg, u8 shift, u32 mask,
 		u8 clk_mux_flags, u32 *table, spinlock_t *lock);
@@ -440,7 +422,7 @@ struct clk_fixed_factor {
 };
 
 extern struct clk_ops clk_fixed_factor_ops;
-struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_factor(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned int mult, unsigned int div);
 
@@ -470,7 +452,7 @@ struct clk_fractional_divider {
 };
 
 extern const struct clk_ops clk_fractional_divider_ops;
-struct clk *clk_register_fractional_divider(struct device *dev,
+struct clk_core *clk_register_fractional_divider(struct device *dev,
 		const char *name, const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 mshift, u8 mwidth, u8 nshift, u8 nwidth,
 		u8 clk_divider_flags, spinlock_t *lock);
@@ -499,7 +481,7 @@ struct clk_composite {
 	const struct clk_ops	*gate_ops;
 };
 
-struct clk *clk_register_composite(struct device *dev, const char *name,
+struct clk_core *clk_register_composite(struct device *dev, const char *name,
 		const char **parent_names, int num_parents,
 		struct clk_hw *mux_hw, const struct clk_ops *mux_ops,
 		struct clk_hw *rate_hw, const struct clk_ops *rate_ops,
@@ -512,49 +494,61 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
  * @hw: link to hardware-specific clock data
  *
  * clk_register is the primary interface for populating the clock tree with new
- * clock nodes.  It returns a pointer to the newly allocated struct clk which
+ * clock nodes.  It returns a pointer to the newly allocated struct clk_core which
  * cannot be dereferenced by driver code but may be used in conjuction with the
  * rest of the clock API.  In the event of an error clk_register will return an
  * error code; drivers must test for an error code after calling clk_register.
  */
-struct clk *clk_register(struct device *dev, struct clk_hw *hw);
-struct clk *devm_clk_register(struct device *dev, struct clk_hw *hw);
+struct clk_core *clk_register(struct device *dev, struct clk_hw *hw);
+struct clk_core *devm_clk_register(struct device *dev, struct clk_hw *hw);
 
-void clk_unregister(struct clk *clk);
-void devm_clk_unregister(struct device *dev, struct clk *clk);
+void clk_unregister(struct clk_core *clk);
+void devm_clk_unregister(struct device *dev, struct clk_core *clk);
 
 /* helper functions */
-const char *__clk_get_name(struct clk *clk);
-struct clk_hw *__clk_get_hw(struct clk *clk);
-u8 __clk_get_num_parents(struct clk *clk);
-struct clk *__clk_get_parent(struct clk *clk);
-struct clk *clk_get_parent_by_index(struct clk *clk, u8 index);
-unsigned int __clk_get_enable_count(struct clk *clk);
-unsigned int __clk_get_prepare_count(struct clk *clk);
-unsigned long __clk_get_rate(struct clk *clk);
-unsigned long __clk_get_accuracy(struct clk *clk);
-unsigned long __clk_get_flags(struct clk *clk);
-bool __clk_is_prepared(struct clk *clk);
-bool __clk_is_enabled(struct clk *clk);
-struct clk *__clk_lookup(const char *name);
+const char *__clk_get_name(struct clk_core *clk);
+struct clk_hw *__clk_get_hw(struct clk_core *clk);
+u8 __clk_get_num_parents(struct clk_core *clk);
+struct clk_core *__clk_get_parent(struct clk_core *clk);
+struct clk_core *clk_get_parent_by_index(struct clk_core *clk, u8 index);
+unsigned int __clk_get_enable_count(struct clk_core *clk);
+unsigned int __clk_get_prepare_count(struct clk_core *clk);
+unsigned long __clk_get_rate(struct clk_core *clk);
+unsigned long __clk_get_accuracy(struct clk_core *clk);
+unsigned long __clk_get_flags(struct clk_core *clk);
+bool __clk_is_prepared(struct clk_core *clk);
+bool __clk_is_enabled(struct clk_core *clk);
+struct clk_core *__clk_lookup(const char *name);
 long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
-			      struct clk **best_parent_p);
+			      struct clk_core **best_parent_p);
+
+int clk_provider_prepare(struct clk_core *clk);
+void clk_provider_unprepare(struct clk_core *clk);
+int clk_provider_set_parent(struct clk_core *clk, struct clk_core *parent);
+int clk_provider_set_rate(struct clk_core *clk, unsigned long rate);
+struct clk_core *clk_provider_get_parent(struct clk_core *clk);
+unsigned long clk_provider_get_rate(struct clk_core *clk);
+struct clk_core *clk_provider_get_sys(const char *dev_id, const char *con_id);
+struct clk_core *clk_provider_get(struct device *dev, const char *con_id);
+struct clk_core *devm_clk_provider_get(struct device *dev, const char *id);
+
+#define clk_core_to_clk(core)	((struct clk *)(core))
 
 /*
  * FIXME clock api without lock protection
  */
-int __clk_prepare(struct clk *clk);
-void __clk_unprepare(struct clk *clk);
-void __clk_reparent(struct clk *clk, struct clk *new_parent);
-unsigned long __clk_round_rate(struct clk *clk, unsigned long rate);
+int __clk_prepare(struct clk_core *clk);
+void __clk_unprepare(struct clk_core *clk);
+void __clk_reparent(struct clk_core *clk, struct clk_core *new_parent);
+unsigned long __clk_round_rate(struct clk_core *clk, unsigned long rate);
 
 struct of_device_id;
 
 typedef void (*of_clk_init_cb_t)(struct device_node *);
 
 struct clk_onecell_data {
-	struct clk **clks;
+	struct clk_core **clks;
 	unsigned int clk_num;
 };
 
@@ -564,22 +558,23 @@ extern struct of_device_id __clk_of_table;
 
 #ifdef CONFIG_OF
 int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *args,
+			struct clk_core *(*clk_src_get)(struct of_phandle_args *args,
 						   void *data),
 			void *data);
 void of_clk_del_provider(struct device_node *np);
-struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
+struct clk_core *of_clk_src_simple_get(struct of_phandle_args *clkspec,
 				  void *data);
-struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
+struct clk_core *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
 int of_clk_get_parent_count(struct device_node *np);
 const char *of_clk_get_parent_name(struct device_node *np, int index);
+struct clk_core *of_clk_provider_get(struct device_node *np, int index);
 
 void of_clk_init(const struct of_device_id *matches);
 
 #else /* !CONFIG_OF */
 
 static inline int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *args,
+			struct clk_core *(*clk_src_get)(struct of_phandle_args *args,
 						   void *data),
 			void *data)
 {
@@ -587,12 +582,12 @@ static inline int of_clk_add_provider(struct device_node *np,
 }
 #define of_clk_del_provider(np) \
 	{ while (0); }
-static inline struct clk *of_clk_src_simple_get(
+static inline struct clk_core *of_clk_src_simple_get(
 	struct of_phandle_args *clkspec, void *data)
 {
 	return ERR_PTR(-ENOENT);
 }
-static inline struct clk *of_clk_src_onecell_get(
+static inline struct clk_core *of_clk_src_onecell_get(
 	struct of_phandle_args *clkspec, void *data)
 {
 	return ERR_PTR(-ENOENT);
@@ -602,6 +597,10 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
 {
 	return NULL;
 }
+static inline struct clk_core *of_clk_provider_get(struct device_node *np, int index)
+{
+	return NULL;
+}
 #define of_clk_init(matches) \
 	{ while (0); }
 #endif /* CONFIG_OF */
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097..9633459 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -18,6 +18,7 @@
 
 struct device;
 
+struct clk_core;
 struct clk;
 
 #ifdef CONFIG_COMMON_CLK
@@ -56,7 +57,7 @@ struct clk;
  * @notifier_head.
  */
 struct clk_notifier {
-	struct clk			*clk;
+	struct clk_core			*clk;
 	struct srcu_notifier_head	notifier_head;
 	struct list_head		node;
 };
@@ -73,7 +74,7 @@ struct clk_notifier {
  * current rate (this was done to optimize the implementation).
  */
 struct clk_notifier_data {
-	struct clk		*clk;
+	struct clk_core		*clk;
 	unsigned long		old_rate;
 	unsigned long		new_rate;
 };
@@ -307,6 +308,14 @@ struct clk *clk_get_parent(struct clk *clk);
  */
 struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
+/**
+ * clk_get_name - get a clock's name
+ * @clk: clock source
+ *
+ * Returns the name of the provided clock.
+ */
+const char *clk_get_name(struct clk *clk);
+
 #else /* !CONFIG_HAVE_CLK */
 
 static inline struct clk *clk_get(struct device *dev, const char *id)
@@ -398,7 +407,8 @@ struct of_phandle_args;
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
-struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
+struct clk_core *of_clk_provider_get_by_name(struct device_node *np, const char *name);
+struct clk_core *of_clk_get_from_provider(struct of_phandle_args *clkspec);
 #else
 static inline struct clk *of_clk_get(struct device_node *np, int index)
 {
@@ -409,6 +419,11 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return ERR_PTR(-ENOENT);
 }
+static inline struct clk_core *of_clk_provider_get_by_name(struct device_node *np,
+						    const char *name)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif
 
 #endif
diff --git a/include/linux/clkdev.h b/include/linux/clkdev.h
index 94bad77..4eb9a34 100644
--- a/include/linux/clkdev.h
+++ b/include/linux/clkdev.h
@@ -15,13 +15,25 @@
 #include <asm/clkdev.h>
 
 struct clk;
+struct clk_core;
 struct device;
 
+/*
+ * To avoid a mass-rename of all non-common clock implementations (spread out
+ * in arch-specific code), we let them use struct clk for both the internal and
+ * external view.
+ */
+#ifdef CONFIG_COMMON_CLK
+#define clk_core_t struct clk_core
+#else
+#define clk_core_t struct clk
+#endif
+
 struct clk_lookup {
 	struct list_head	node;
 	const char		*dev_id;
 	const char		*con_id;
-	struct clk		*clk;
+	clk_core_t		*clk;
 };
 
 #define CLKDEV_INIT(d, n, c)	\
@@ -31,7 +43,7 @@ struct clk_lookup {
 		.clk = c,	\
 	}
 
-struct clk_lookup *clkdev_alloc(struct clk *clk, const char *con_id,
+struct clk_lookup *clkdev_alloc(clk_core_t *clk, const char *con_id,
 	const char *dev_fmt, ...);
 
 void clkdev_add(struct clk_lookup *cl);
@@ -40,12 +52,12 @@ void clkdev_drop(struct clk_lookup *cl);
 void clkdev_add_table(struct clk_lookup *, size_t);
 int clk_add_alias(const char *, const char *, char *, struct device *);
 
-int clk_register_clkdev(struct clk *, const char *, const char *, ...);
-int clk_register_clkdevs(struct clk *, struct clk_lookup *, size_t);
+int clk_register_clkdev(clk_core_t *, const char *, const char *, ...);
+int clk_register_clkdevs(clk_core_t *, struct clk_lookup *, size_t);
 
 #ifdef CONFIG_COMMON_CLK
-int __clk_get(struct clk *clk);
-void __clk_put(struct clk *clk);
+int __clk_get(struct clk_core *clk);
+void __clk_put(struct clk_core *clk);
 #endif
 
 #endif
-- 
1.9.3

