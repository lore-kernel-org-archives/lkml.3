Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaIKO0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:26:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32945 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaIKO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:26:41 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, tomasz.figa@gmail.com,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v11 3/9] clk: use struct clk only for external API
Date: Thu, 11 Sep 2014 16:26:17 +0200
Message-Id: <1410445583-18626-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410445421-18362-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1410445421-18362-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to provide per-user accounting, this separates the struct clk
used in the common clock framework into two structures 'struct clk_core'
and 'struct clk'. struct clk_core will be used for internal
manipulation and struct clk will be used in the clock API
implementation.

In this patch, struct clk is simply renamed to struct clk_core and a new
struct clk is implemented which simply wraps it. In the next patch, the
new struct clk will be used to implement per-user clock enable
accounting.

Based on previous work by Rabin Vincent <rabin@rab.in>.

NOTE: with this patch, clk_get_parent() behaves like clk_get(), i.e. it
needs to be matched with a clk_put().  Otherwise, memory will leak.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>

---

v9: * Removed superfluous variable

v7: * convert clk_is_enabled to clk_core
    * add clk_provider_notifier_[un]register

v4: * export clk_to_clk_core so mach-msm can use it for clk_reset
    * add clk_provider_round_rate, for mach-imx
    * fix build with !CONFIG_COMMON_CLK
    * keep handling NULL struct clk gracefully as before

v3: * Allocate and release the per-user struct clk
    * Have clk_core_to_clk return any error it's passed, so calls to it can be chained
    * Add provider API for enable and disable
    * Remove clk_free_clk for now
    * Have clk_to_clk_core be an inline function to benefit of type-checking
    * Have devres wrap the clk struct instead of clk_core
    * Rename clk_core_to_clk to __clk_create_clk to make more clear that it allocates
---
 arch/arm/mach-msm/clock.c    |   2 +-
 drivers/clk/clk-devres.c     |  31 ++
 drivers/clk/clk.c            | 669 ++++++++++++++++++++++++++-----------------
 drivers/clk/clk.h            |   6 +
 drivers/clk/clkdev.c         | 123 ++++++--
 include/linux/clk-private.h  |  38 +--
 include/linux/clk-provider.h | 164 ++++++-----
 include/linux/clk.h          |  32 ++-
 include/linux/clkdev.h       |  24 +-
 9 files changed, 701 insertions(+), 388 deletions(-)

diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index 35ea02b5..1de0b5a 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -21,7 +21,7 @@
 
 int clk_reset(struct clk *clk, enum clk_reset_action action)
 {
-	struct clk_hw *hw = __clk_get_hw(clk);
+	struct clk_hw *hw = __clk_get_hw(clk_to_clk_core(clk));
 	struct msm_clk *m = to_msm_clk(hw);
 	return m->reset(hw, action);
 }
diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index 8f57154..79cd4d3 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -5,10 +5,14 @@
  */
 
 #include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
 #include <linux/device.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
 
+#include "clk.h"
+
 static void devm_clk_release(struct device *dev, void *res)
 {
 	clk_put(*(struct clk **)res);
@@ -34,6 +38,33 @@ struct clk *devm_clk_get(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL(devm_clk_get);
 
+#if defined(CONFIG_COMMON_CLK)
+static void devm_clk_core_release(struct device *dev, void *res)
+{
+	__clk_put(*(struct clk_core **)res);
+}
+
+struct clk_core *devm_clk_provider_get(struct device *dev, const char *id)
+{
+	struct clk_core **ptr, *clk;
+
+	ptr = devres_alloc(devm_clk_core_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	clk = clk_provider_get(dev, id);
+	if (!IS_ERR(clk)) {
+		*ptr = clk;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return clk;
+}
+EXPORT_SYMBOL(devm_clk_provider_get);
+#endif
+
 static int devm_clk_match(struct device *dev, void *res, void *data)
 {
 	struct clk **c = res;
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b76fa69..ce84b1f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -37,6 +37,8 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
+static long __clk_get_accuracy_internal(struct clk_core *clk);
+
 /***           locking             ***/
 static void clk_prepare_lock(void)
 {
@@ -112,7 +114,7 @@ static struct hlist_head *orphan_list[] = {
 	NULL,
 };
 
-static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
+static void clk_summary_show_one(struct seq_file *s, struct clk_core *c, int level)
 {
 	if (!c)
 		return;
@@ -120,14 +122,14 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
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
@@ -140,7 +142,7 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
 
 static int clk_summary_show(struct seq_file *s, void *data)
 {
-	struct clk *c;
+	struct clk_core *c;
 	struct hlist_head **lists = (struct hlist_head **)s->private;
 
 	seq_puts(s, "   clock                         enable_cnt  prepare_cnt        rate   accuracy\n");
@@ -170,7 +172,7 @@ static const struct file_operations clk_summary_fops = {
 	.release	= single_release,
 };
 
-static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
+static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
 {
 	if (!c)
 		return;
@@ -178,13 +180,13 @@ static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
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
@@ -201,7 +203,7 @@ static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
 
 static int clk_dump(struct seq_file *s, void *data)
 {
-	struct clk *c;
+	struct clk_core *c;
 	bool first_node = true;
 	struct hlist_head **lists = (struct hlist_head **)s->private;
 
@@ -238,7 +240,7 @@ static const struct file_operations clk_dump_fops = {
 };
 
 /* caller must hold prepare_lock */
-static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
+static int clk_debug_create_one(struct clk_core *clk, struct dentry *pdentry)
 {
 	struct dentry *d;
 	int ret = -ENOMEM;
@@ -301,9 +303,9 @@ out:
 }
 
 /* caller must hold prepare_lock */
-static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
+static int clk_debug_create_subtree(struct clk_core *clk, struct dentry *pdentry)
 {
-	struct clk *child;
+	struct clk_core *child;
 	int ret = -EINVAL;;
 
 	if (!clk || !pdentry)
@@ -333,7 +335,7 @@ out:
  * Caller must hold prepare_lock.  Only clk_init calls this function (so
  * far) so this is taken care.
  */
-static int clk_debug_register(struct clk *clk)
+static int clk_debug_register(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -356,12 +358,12 @@ out:
  *
  * Caller must hold prepare_lock.
  */
-static void clk_debug_unregister(struct clk *clk)
+static void clk_debug_unregister(struct clk_core *clk)
 {
 	debugfs_remove_recursive(clk->dentry);
 }
 
-struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
+struct dentry *clk_debugfs_add_file(struct clk_core *clk, char *name, umode_t mode,
 				void *data, const struct file_operations *fops)
 {
 	struct dentry *d = NULL;
@@ -387,7 +389,7 @@ EXPORT_SYMBOL_GPL(clk_debugfs_add_file);
  */
 static int __init clk_debug_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct dentry *d;
 
 	rootdir = debugfs_create_dir("clk", NULL);
@@ -431,19 +433,19 @@ static int __init clk_debug_init(void)
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
@@ -466,9 +468,9 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
 }
 
 /* caller must hold prepare_lock */
-static void clk_disable_unused_subtree(struct clk *clk)
+static void clk_disable_unused_subtree(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 	unsigned long flags;
 
 	if (!clk)
@@ -514,7 +516,7 @@ __setup("clk_ignore_unused", clk_ignore_unused_setup);
 
 static int clk_disable_unused(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (clk_ignore_unused) {
 		pr_warn("clk: Not disabling unused clocks\n");
@@ -541,33 +543,50 @@ static int clk_disable_unused(void)
 }
 late_initcall_sync(clk_disable_unused);
 
+struct clk *__clk_create_clk(struct clk_core *clk_core)
+{
+	struct clk *clk;
+
+	/* This is to allow this function to be chained to others */
+	if (!clk_core || IS_ERR(clk_core))
+		return (struct clk *) clk_core;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		return ERR_PTR(-ENOMEM);
+
+	clk->core = clk_core;
+
+	return clk;
+}
+
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
@@ -581,17 +600,17 @@ struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
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
 
@@ -613,7 +632,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(__clk_get_rate);
 
-unsigned long __clk_get_accuracy(struct clk *clk)
+unsigned long __clk_get_accuracy(struct clk_core *clk)
 {
 	if (!clk)
 		return 0;
@@ -621,13 +640,13 @@ unsigned long __clk_get_accuracy(struct clk *clk)
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
 
@@ -648,7 +667,7 @@ out:
 	return !!ret;
 }
 
-bool __clk_is_enabled(struct clk *clk)
+bool __clk_is_enabled(struct clk_core *clk)
 {
 	int ret;
 
@@ -670,10 +689,10 @@ out:
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
@@ -687,10 +706,10 @@ static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
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
@@ -719,9 +738,9 @@ struct clk *__clk_lookup(const char *name)
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
 
@@ -764,7 +783,7 @@ EXPORT_SYMBOL_GPL(__clk_mux_determine_rate);
 
 /***        clk api        ***/
 
-void __clk_unprepare(struct clk *clk)
+void __clk_unprepare(struct clk_core *clk)
 {
 	if (!clk)
 		return;
@@ -783,9 +802,20 @@ void __clk_unprepare(struct clk *clk)
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
+EXPORT_SYMBOL_GPL(clk_provider_unprepare);
+
 /**
  * clk_unprepare - undo preparation of a clock source
- * @clk: the clk being unprepared
+ * @clk_user: the clk being unprepared
  *
  * clk_unprepare may sleep, which differentiates it from clk_disable.  In a
  * simple case, clk_unprepare can be used instead of clk_disable to gate a clk
@@ -794,18 +824,16 @@ void __clk_unprepare(struct clk *clk)
  * part.  It is this reason that clk_unprepare and clk_disable are not mutually
  * exclusive.  In fact clk_disable must be called before clk_unprepare.
  */
-void clk_unprepare(struct clk *clk)
+void clk_unprepare(struct clk *clk_user)
 {
-	if (IS_ERR_OR_NULL(clk))
+	if (IS_ERR_OR_NULL(clk_user))
 		return;
 
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
 
@@ -831,9 +859,21 @@ int __clk_prepare(struct clk *clk)
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
+EXPORT_SYMBOL_GPL(clk_provider_prepare);
+
 /**
  * clk_prepare - prepare a clock source
- * @clk: the clk being prepared
+ * @clk_user: the clk being prepared
  *
  * clk_prepare may sleep, which differentiates it from clk_enable.  In a simple
  * case, clk_prepare can be used instead of clk_enable to ungate a clk if the
@@ -843,19 +883,16 @@ int __clk_prepare(struct clk *clk)
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
+	if (!clk_user)
+		return 0;
 
-	return ret;
+	return clk_provider_prepare(clk_to_clk_core(clk_user));
 }
 EXPORT_SYMBOL_GPL(clk_prepare);
 
-static void __clk_disable(struct clk *clk)
+static void __clk_disable(struct clk_core *clk)
 {
 	if (!clk)
 		return;
@@ -872,9 +909,22 @@ static void __clk_disable(struct clk *clk)
 	__clk_disable(clk->parent);
 }
 
+void clk_provider_disable(struct clk_core *clk)
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
+EXPORT_SYMBOL_GPL(clk_provider_disable);
+
 /**
  * clk_disable - gate a clock
- * @clk: the clk being gated
+ * @clk_user: the clk being gated
  *
  * clk_disable must not sleep, which differentiates it from clk_unprepare.  In
  * a simple case, clk_disable can be used instead of clk_unprepare to gate a
@@ -884,20 +934,16 @@ static void __clk_disable(struct clk *clk)
  * this reason that clk_unprepare and clk_disable are not mutually exclusive.
  * In fact clk_disable must be called before clk_unprepare.
  */
-void clk_disable(struct clk *clk)
+void clk_disable(struct clk *clk_user)
 {
-	unsigned long flags;
-
-	if (IS_ERR_OR_NULL(clk))
+	if (IS_ERR_OR_NULL(clk_user))
 		return;
 
-	flags = clk_enable_lock();
-	__clk_disable(clk);
-	clk_enable_unlock(flags);
+	clk_provider_disable(clk_to_clk_core(clk_user));
 }
 EXPORT_SYMBOL_GPL(clk_disable);
 
-static int __clk_enable(struct clk *clk)
+static int __clk_enable(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -926,9 +972,22 @@ static int __clk_enable(struct clk *clk)
 	return 0;
 }
 
+int clk_provider_enable(struct clk_core *clk)
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
+EXPORT_SYMBOL_GPL(clk_provider_enable);
+
 /**
  * clk_enable - ungate a clock
- * @clk: the clk being ungated
+ * @clk_user: the clk being ungated
  *
  * clk_enable must not sleep, which differentiates it from clk_prepare.  In a
  * simple case, clk_enable can be used instead of clk_prepare to ungate a clk
@@ -939,16 +998,12 @@ static int __clk_enable(struct clk *clk)
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
+	if (!clk_user)
+		return 0;
 
-	return ret;
+	return clk_provider_enable(clk_to_clk_core(clk_user));
 }
 EXPORT_SYMBOL_GPL(clk_enable);
 
@@ -959,10 +1014,10 @@ EXPORT_SYMBOL_GPL(clk_enable);
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
@@ -983,42 +1038,51 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 }
 EXPORT_SYMBOL_GPL(__clk_round_rate);
 
+long clk_provider_round_rate(struct clk_core *clk, unsigned long rate)
+{
+	unsigned long ret;
+
+	clk_prepare_lock();
+	ret = __clk_round_rate(clk, rate);
+	clk_prepare_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(clk_provider_round_rate);
+
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
-	unsigned long ret;
-
-	clk_prepare_lock();
-	ret = __clk_round_rate(clk, rate);
-	clk_prepare_unlock();
+	if (!clk_user)
+		return 0;
 
-	return ret;
+	return clk_provider_round_rate(clk_to_clk_core(clk_user), rate);
 }
 EXPORT_SYMBOL_GPL(clk_round_rate);
 
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
@@ -1051,10 +1115,10 @@ static int __clk_notify(struct clk *clk, unsigned long msg,
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
@@ -1069,16 +1133,7 @@ static void __clk_recalc_accuracies(struct clk *clk)
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
 
@@ -1091,9 +1146,23 @@ long clk_get_accuracy(struct clk *clk)
 
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
@@ -1114,11 +1183,11 @@ static unsigned long clk_recalc(struct clk *clk, unsigned long parent_rate)
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
 
@@ -1138,15 +1207,7 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
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
 
@@ -1160,15 +1221,32 @@ unsigned long clk_get_rate(struct clk *clk)
 
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
+	if (!clk_user)
+		return 0;
+
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
@@ -1194,7 +1272,7 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
 	return -EINVAL;
 }
 
-static void clk_reparent(struct clk *clk, struct clk *new_parent)
+static void clk_reparent(struct clk_core *clk, struct clk_core *new_parent)
 {
 	hlist_del(&clk->child_node);
 
@@ -1211,10 +1289,10 @@ static void clk_reparent(struct clk *clk, struct clk *new_parent)
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
@@ -1235,8 +1313,8 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 	 */
 	if (clk->prepare_count) {
 		__clk_prepare(parent);
-		clk_enable(parent);
-		clk_enable(clk);
+		clk_provider_enable(parent);
+		clk_provider_enable(clk);
 	}
 
 	/* update the clk tree topology */
@@ -1247,25 +1325,25 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
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
+		clk_provider_disable(clk);
+		clk_provider_disable(old_parent);
 		__clk_unprepare(old_parent);
 	}
 }
 
-static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
+static int __clk_set_parent(struct clk_core *clk, struct clk_core *parent, u8 p_index)
 {
 	unsigned long flags;
 	int ret = 0;
-	struct clk *old_parent;
+	struct clk_core *old_parent;
 
 	old_parent = __clk_set_parent_before(clk, parent);
 
@@ -1279,8 +1357,8 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
 		clk_enable_unlock(flags);
 
 		if (clk->prepare_count) {
-			clk_disable(clk);
-			clk_disable(parent);
+			clk_provider_disable(clk);
+			clk_provider_disable(parent);
 			__clk_unprepare(parent);
 		}
 		return ret;
@@ -1307,9 +1385,9 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
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
 
@@ -1335,10 +1413,10 @@ out:
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
@@ -1358,10 +1436,10 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
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
@@ -1427,9 +1505,9 @@ out:
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
@@ -1464,13 +1542,13 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
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
 
@@ -1514,30 +1592,9 @@ static void clk_change_rate(struct clk *clk)
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
@@ -1547,7 +1604,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	clk_prepare_lock();
 
 	/* bail early if nothing to do */
-	if (rate == clk_get_rate(clk))
+	if (rate == clk_provider_get_rate(clk))
 		goto out;
 
 	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
@@ -1580,17 +1637,41 @@ out:
 
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
 {
-	struct clk *parent;
+	if (!clk_user)
+		return 0;
+
+	return clk_provider_set_rate(clk_to_clk_core(clk_user), rate);
+}
+EXPORT_SYMBOL_GPL(clk_set_rate);
+
+struct clk_core *clk_provider_get_parent(struct clk_core *clk)
+{
+	struct clk_core *parent;
 
 	clk_prepare_lock();
 	parent = __clk_get_parent(clk);
@@ -1598,8 +1679,35 @@ struct clk *clk_get_parent(struct clk *clk)
 
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
+	struct clk_core *clk;
+	struct clk_core *parent;
+
+	if (!clk_user)
+		return NULL;
+
+	clk = clk_to_clk_core(clk_user);
+	parent = clk_provider_get_parent(clk);
+
+	return __clk_create_clk(parent);
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
@@ -1609,9 +1717,9 @@ EXPORT_SYMBOL_GPL(clk_get_parent);
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
@@ -1643,7 +1751,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
 
 	if (!clk->parents)
 		clk->parents =
-			kcalloc(clk->num_parents, sizeof(struct clk *),
+			kcalloc(clk->num_parents, sizeof(struct clk_core *),
 					GFP_KERNEL);
 
 	ret = clk_get_parent_by_index(clk, index);
@@ -1652,31 +1760,14 @@ out:
 	return ret;
 }
 
-void __clk_reparent(struct clk *clk, struct clk *new_parent)
+void __clk_reparent(struct clk_core *clk, struct clk_core *new_parent)
 {
 	clk_reparent(clk, new_parent);
 	__clk_recalc_accuracies(clk);
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
@@ -1736,6 +1827,38 @@ out:
 
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
+	struct clk_core *clk;
+	struct clk_core *parent;
+
+	if (!clk_user)
+		return 0;
+
+	clk = clk_to_clk_core(clk_user);
+	parent = clk_to_clk_core(parent_user);
+
+	return clk_provider_set_parent(clk, parent);
+}
 EXPORT_SYMBOL_GPL(clk_set_parent);
 
 /**
@@ -1746,10 +1869,10 @@ EXPORT_SYMBOL_GPL(clk_set_parent);
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
@@ -1797,7 +1920,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 				__func__, clk->name);
 
 	/*
-	 * Allocate an array of struct clk *'s to avoid unnecessary string
+	 * Allocate an array of struct clk_core *'s to avoid unnecessary string
 	 * look-ups of clk's possible parents.  This can fail for clocks passed
 	 * in to clk_init during early boot; thus any access to clk->parents[]
 	 * must always check for a NULL pointer and try to populate it if
@@ -1807,7 +1930,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 * for clock drivers to statically initialize clk->parents.
 	 */
 	if (clk->num_parents > 1 && !clk->parents) {
-		clk->parents = kcalloc(clk->num_parents, sizeof(struct clk *),
+		clk->parents = kcalloc(clk->num_parents, sizeof(struct clk_core *),
 					GFP_KERNEL);
 		/*
 		 * __clk_lookup returns NULL for parents that have not been
@@ -1913,7 +2036,7 @@ out:
  *
  * Same as clk_register, except that the .clk field inside hw shall point to a
  * preallocated (generally statically allocated) struct clk. None of the fields
- * of the struct clk need to be initialized.
+ * of the struct clk_core need to be initialized.
  *
  * The data pointed to by .init and .clk field shall NOT be marked as init
  * data.
@@ -1925,10 +2048,10 @@ out:
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
@@ -1956,15 +2079,15 @@ EXPORT_SYMBOL_GPL(__clk_register);
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
@@ -2032,7 +2155,7 @@ EXPORT_SYMBOL_GPL(clk_register);
  */
 static void __clk_release(struct kref *ref)
 {
-	struct clk *clk = container_of(ref, struct clk, ref);
+	struct clk_core *clk = container_of(ref, struct clk_core, ref);
 	int i = clk->num_parents;
 
 	kfree(clk->parents);
@@ -2083,7 +2206,7 @@ static const struct clk_ops clk_nodrv_ops = {
  * clk_unregister - unregister a currently registered clock
  * @clk: clock to unregister
  */
-void clk_unregister(struct clk *clk)
+void clk_unregister(struct clk_core *clk)
 {
 	unsigned long flags;
 
@@ -2105,12 +2228,12 @@ void clk_unregister(struct clk *clk)
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
@@ -2129,9 +2252,15 @@ EXPORT_SYMBOL_GPL(clk_unregister);
 
 static void devm_clk_release(struct device *dev, void *res)
 {
-	clk_unregister(*(struct clk **)res);
+	clk_unregister(*(struct clk_core **)res);
 }
 
+struct clk_core *clk_to_clk_core(struct clk *clk)
+{
+	return clk->core;
+}
+EXPORT_SYMBOL_GPL(clk_to_clk_core);
+
 /**
  * devm_clk_register - resource managed clk_register()
  * @dev: device that is registering this clock
@@ -2141,10 +2270,10 @@ static void devm_clk_release(struct device *dev, void *res)
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
@@ -2164,7 +2293,7 @@ EXPORT_SYMBOL_GPL(devm_clk_register);
 
 static int devm_clk_match(struct device *dev, void *res, void *data)
 {
-	struct clk *c = res;
+	struct clk_core *c = res;
 	if (WARN_ON(!c))
 		return 0;
 	return c == data;
@@ -2178,7 +2307,7 @@ static int devm_clk_match(struct device *dev, void *res, void *data)
  * this function will not need to be called and the resource management
  * code will ensure that the resource is freed.
  */
-void devm_clk_unregister(struct device *dev, struct clk *clk)
+void devm_clk_unregister(struct device *dev, struct clk_core *clk)
 {
 	WARN_ON(devres_release(dev, devm_clk_release, devm_clk_match, clk));
 }
@@ -2187,7 +2316,7 @@ EXPORT_SYMBOL_GPL(devm_clk_unregister);
 /*
  * clkdev helpers
  */
-int __clk_get(struct clk *clk)
+int __clk_get(struct clk_core *clk)
 {
 	if (clk) {
 		if (!try_module_get(clk->owner))
@@ -2198,7 +2327,7 @@ int __clk_get(struct clk *clk)
 	return 1;
 }
 
-void __clk_put(struct clk *clk)
+void __clk_put(struct clk_core *clk)
 {
 	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
 		return;
@@ -2212,28 +2341,7 @@ void __clk_put(struct clk *clk)
 
 /***        clk rate change notifiers        ***/
 
-/**
- * clk_notifier_register - add a clk rate change notifier
- * @clk: struct clk * to watch
- * @nb: struct notifier_block * with callback info
- *
- * Request notification when clk's rate changes.  This uses an SRCU
- * notifier because we want it to block and notifier unregistrations are
- * uncommon.  The callbacks associated with the notifier must not
- * re-enter into the clk framework by calling any top-level clk APIs;
- * this will cause a nested prepare_lock mutex.
- *
- * In all notification cases cases (pre, post and abort rate change) the
- * original clock rate is passed to the callback via struct
- * clk_notifier_data.old_rate and the new frequency is passed via struct
- * clk_notifier_data.new_rate.
- *
- * clk_notifier_register() must be called from non-atomic context.
- * Returns -EINVAL if called with null arguments, -ENOMEM upon
- * allocation failure; otherwise, passes along the return value of
- * srcu_notifier_chain_register().
- */
-int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
+int clk_provider_notifier_register(struct clk_core *clk, struct notifier_block *nb)
 {
 	struct clk_notifier *cn;
 	int ret = -ENOMEM;
@@ -2269,20 +2377,38 @@ out:
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(clk_notifier_register);
+EXPORT_SYMBOL_GPL(clk_provider_notifier_register);
 
 /**
- * clk_notifier_unregister - remove a clk rate change notifier
- * @clk: struct clk *
+ * clk_notifier_register - add a clk rate change notifier
+ * @clk_user: struct clk * to watch
  * @nb: struct notifier_block * with callback info
  *
- * Request no further notification for changes to 'clk' and frees memory
- * allocated in clk_notifier_register.
+ * Request notification when clk's rate changes.  This uses an SRCU
+ * notifier because we want it to block and notifier unregistrations are
+ * uncommon.  The callbacks associated with the notifier must not
+ * re-enter into the clk framework by calling any top-level clk APIs;
+ * this will cause a nested prepare_lock mutex.
  *
- * Returns -EINVAL if called with null arguments; otherwise, passes
- * along the return value of srcu_notifier_chain_unregister().
+ * In all notification cases cases (pre, post and abort rate change) the
+ * original clock rate is passed to the callback via struct
+ * clk_notifier_data.old_rate and the new frequency is passed via struct
+ * clk_notifier_data.new_rate.
+ *
+ * clk_notifier_register() must be called from non-atomic context.
+ * Returns -EINVAL if called with null arguments, -ENOMEM upon
+ * allocation failure; otherwise, passes along the return value of
+ * srcu_notifier_chain_register().
  */
-int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
+int clk_notifier_register(struct clk *clk_user, struct notifier_block *nb)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+
+	return clk_provider_notifier_register(clk, nb);
+}
+EXPORT_SYMBOL_GPL(clk_notifier_register);
+
+int clk_provider_notifier_unregister(struct clk_core *clk, struct notifier_block *nb)
 {
 	struct clk_notifier *cn = NULL;
 	int ret = -EINVAL;
@@ -2316,6 +2442,25 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(clk_provider_notifier_unregister);
+
+/**
+ * clk_notifier_unregister - remove a clk rate change notifier
+ * @clk_user: struct clk_core *
+ * @nb: struct notifier_block * with callback info
+ *
+ * Request no further notification for changes to 'clk' and frees memory
+ * allocated in clk_notifier_register.
+ *
+ * Returns -EINVAL if called with null arguments; otherwise, passes
+ * along the return value of srcu_notifier_chain_unregister().
+ */
+int clk_notifier_unregister(struct clk *clk_user, struct notifier_block *nb)
+{
+	struct clk_core *clk = clk_to_clk_core(clk_user);
+
+	return clk_provider_notifier_unregister(clk, nb);
+}
 EXPORT_SYMBOL_GPL(clk_notifier_unregister);
 
 #ifdef CONFIG_OF
@@ -2323,7 +2468,7 @@ EXPORT_SYMBOL_GPL(clk_notifier_unregister);
  * struct of_clk_provider - Clock provider registration structure
  * @link: Entry in global list of clock providers
  * @node: Pointer to device tree node of clock provider
- * @get: Get clock callback.  Returns NULL or a struct clk for the
+ * @get: Get clock callback.  Returns NULL or a struct clk_core for the
  *       given clock specifier
  * @data: context pointer to be passed into @get callback
  */
@@ -2331,7 +2476,7 @@ struct of_clk_provider {
 	struct list_head link;
 
 	struct device_node *node;
-	struct clk *(*get)(struct of_phandle_args *clkspec, void *data);
+	struct clk_core *(*get)(struct of_phandle_args *clkspec, void *data);
 	void *data;
 };
 
@@ -2352,14 +2497,14 @@ void of_clk_unlock(void)
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
@@ -2380,7 +2525,7 @@ EXPORT_SYMBOL_GPL(of_clk_src_onecell_get);
  * @data: context pointer for @clk_src_get callback.
  */
 int of_clk_add_provider(struct device_node *np,
-			struct clk *(*clk_src_get)(struct of_phandle_args *clkspec,
+			struct clk_core *(*clk_src_get)(struct of_phandle_args *clkspec,
 						   void *data),
 			void *data)
 {
@@ -2429,10 +2574,10 @@ void of_clk_del_provider(struct device_node *np)
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
@@ -2445,9 +2590,9 @@ struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec)
 	return clk;
 }
 
-struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec)
+struct clk_core *of_clk_get_from_provider(struct of_phandle_args *clkspec)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	mutex_lock(&of_clk_mutex);
 	clk = __of_clk_get_from_provider(clkspec);
@@ -2522,11 +2667,11 @@ static int parent_ready(struct device_node *np)
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
index d278572..3b3068b 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -9,9 +9,15 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/clk-private.h>
+
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk_core *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
 struct clk_core *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
 void of_clk_lock(void);
 void of_clk_unlock(void);
 #endif
+
+#if defined(CONFIG_COMMON_CLK)
+struct clk *__clk_create_clk(struct clk_core *clk_core);
+#endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index c751d0c..080b3df 100644
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
+	return __clk_create_clk(of_clk_provider_get(np, index));
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
@@ -120,11 +117,25 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 
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
+	return __clk_create_clk(of_clk_provider_get_by_name(np, name));
+}
 EXPORT_SYMBOL(of_clk_get_by_name);
 #endif
 
 /*
- * Find the correct struct clk for the device and connection ID.
+ * Find the correct clock for the device and connection ID.
  * We do slightly fuzzy matching here:
  *  An entry with a NULL ID is assumed to be a wildcard.
  *  If an entry has a device ID, it must match
@@ -166,8 +177,32 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
 	return cl;
 }
 
+#if defined(CONFIG_COMMON_CLK)
+struct clk_core *clk_provider_get_sys(const char *dev_id, const char *con_id)
+{
+	struct clk_lookup *cl;
+
+	mutex_lock(&clocks_mutex);
+	cl = clk_find(dev_id, con_id);
+	if (cl && !__clk_get(cl->clk))
+		cl = NULL;
+	mutex_unlock(&clocks_mutex);
+
+	if (!cl)
+		return ERR_PTR(-ENOENT);
+
+	return cl->clk;
+}
+EXPORT_SYMBOL_GPL(clk_provider_get_sys);
+#endif
+
 struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 {
+#if defined(CONFIG_COMMON_CLK)
+	struct clk_core *clk = clk_provider_get_sys(dev_id, con_id);
+
+	return __clk_create_clk(clk);
+#else
 	struct clk_lookup *cl;
 
 	mutex_lock(&clocks_mutex);
@@ -176,12 +211,38 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 		cl = NULL;
 	mutex_unlock(&clocks_mutex);
 
-	return cl ? cl->clk : ERR_PTR(-ENOENT);
+	if (!cl)
+		return ERR_PTR(-ENOENT);
+
+	return cl->clk;
+#endif
 }
 EXPORT_SYMBOL(clk_get_sys);
 
+#if defined(CONFIG_COMMON_CLK)
+struct clk_core *clk_provider_get(struct device *dev, const char *con_id)
+{
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+	struct clk_core *clk;
+
+	if (dev) {
+		clk = of_clk_provider_get_by_name(dev->of_node, con_id);
+		if (!IS_ERR(clk))
+			return clk;
+		if (PTR_ERR(clk) == -EPROBE_DEFER)
+			return clk;
+	}
+
+	return clk_provider_get_sys(dev_id, con_id);
+}
+EXPORT_SYMBOL(clk_provider_get);
+#endif
+
 struct clk *clk_get(struct device *dev, const char *con_id)
 {
+#if defined(CONFIG_COMMON_CLK)
+	return __clk_create_clk(clk_provider_get(dev, con_id));
+#else
 	const char *dev_id = dev ? dev_name(dev) : NULL;
 	struct clk *clk;
 
@@ -194,12 +255,20 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 	}
 
 	return clk_get_sys(dev_id, con_id);
+#endif
 }
 EXPORT_SYMBOL(clk_get);
 
 void clk_put(struct clk *clk)
 {
+#if defined(CONFIG_COMMON_CLK)
+	clk_core_t *core = clk_to_clk_core(clk);
+
+	kfree(clk);
+	__clk_put(core);
+#else
 	__clk_put(clk);
+#endif
 }
 EXPORT_SYMBOL(clk_put);
 
@@ -231,7 +300,7 @@ struct clk_lookup_alloc {
 };
 
 static struct clk_lookup * __init_refok
-vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
+vclkdev_alloc(clk_core_t *clk, const char *con_id, const char *dev_fmt,
 	va_list ap)
 {
 	struct clk_lookup_alloc *cla;
@@ -255,7 +324,7 @@ vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
 }
 
 struct clk_lookup * __init_refok
-clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
+clkdev_alloc(clk_core_t *clk, const char *con_id, const char *dev_fmt, ...)
 {
 	struct clk_lookup *cl;
 	va_list ap;
@@ -277,7 +346,11 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
 	if (IS_ERR(r))
 		return PTR_ERR(r);
 
+#ifdef CONFIG_COMMON_CLK
+	l = clkdev_alloc(clk_to_clk_core(r), alias, alias_dev_name);
+#else
 	l = clkdev_alloc(r, alias, alias_dev_name);
+#endif
 	clk_put(r);
 	if (!l)
 		return -ENODEV;
@@ -300,7 +373,7 @@ EXPORT_SYMBOL(clkdev_drop);
 
 /**
  * clk_register_clkdev - register one clock lookup for a struct clk
- * @clk: struct clk to associate with all clk_lookups
+ * @clk: clock to associate with all clk_lookups
  * @con_id: connection ID string on device
  * @dev_id: format string describing device name
  *
@@ -312,7 +385,7 @@ EXPORT_SYMBOL(clkdev_drop);
  * those.  This is to permit this function to be called immediately
  * after clk_register().
  */
-int clk_register_clkdev(struct clk *clk, const char *con_id,
+int clk_register_clkdev(clk_core_t *clk, const char *con_id,
 	const char *dev_fmt, ...)
 {
 	struct clk_lookup *cl;
@@ -335,7 +408,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
 
 /**
  * clk_register_clkdevs - register a set of clk_lookup for a struct clk
- * @clk: struct clk to associate with all clk_lookups
+ * @clk: clock to associate with all clk_lookups
  * @cl: array of clk_lookup structures with con_id and dev_id pre-initialized
  * @num: number of clk_lookup structures to register
  *
@@ -344,7 +417,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
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
index 99b906f..edf1beb 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -16,35 +16,8 @@
 
 #ifdef CONFIG_COMMON_CLK
 
-/* Temporarily map the to-be-added API to the old API, just so stuff compiles */
-#define clk_core			clk
-
-#define __clk_create_clk
-
-#define clk_provider_get			clk_get
-#define clk_provider_get_sys			clk_get_sys
-#define devm_clk_provider_get			devm_clk_get
-#define of_clk_provider_get			of_clk_get
-#define of_clk_provider_get_by_name		of_clk_get_by_name
-
-#define clk_provider_set_rate			clk_set_rate
-#define clk_provider_get_rate			clk_get_rate
-#define clk_provider_round_rate			clk_round_rate
-#define clk_provider_set_parent			clk_set_parent
-#define clk_provider_get_parent			clk_get_parent
-#define clk_provider_prepare			clk_prepare
-#define clk_provider_unprepare			clk_unprepare
-#define clk_provider_enable			clk_enable
-#define clk_provider_disable			clk_disable
-#define clk_provider_prepare_enable		clk_prepare_enable
-#define clk_provider_disable_unprepare		clk_unprepare
-#define clk_provider_notifier_register		clk_notifier_register
-#define clk_provider_notifier_unregister	clk_notifier_unregister
-
-#define clk_get_name				__clk_get_name
-
 /*
- * flags used across common struct clk.  these flags should only affect the
+ * flags used across common struct clk_core.  these flags should only affect the
  * top-level framework.  custom flags for dealing with hardware specifics
  * belong in struct clk_foo
  */
@@ -194,7 +167,7 @@ struct clk_ops {
 					unsigned long *parent_rate);
 	long		(*determine_rate)(struct clk_hw *hw, unsigned long rate,
 					unsigned long *best_parent_rate,
-					struct clk **best_parent_clk);
+					struct clk_core **best_parent_clk);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
 	u8		(*get_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long rate,
@@ -227,19 +200,19 @@ struct clk_init_data {
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
 
@@ -265,10 +238,10 @@ struct clk_fixed_rate {
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
 
@@ -306,7 +279,7 @@ struct clk_gate {
 #define CLK_GATE_HIWORD_MASK		BIT(1)
 
 extern const struct clk_ops clk_gate_ops;
-struct clk *clk_register_gate(struct device *dev, const char *name,
+struct clk_core *clk_register_gate(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 bit_idx,
 		u8 clk_gate_flags, spinlock_t *lock);
@@ -369,11 +342,11 @@ struct clk_divider {
 
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
@@ -418,12 +391,12 @@ struct clk_mux {
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
@@ -449,7 +422,7 @@ struct clk_fixed_factor {
 };
 
 extern struct clk_ops clk_fixed_factor_ops;
-struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
+struct clk_core *clk_register_fixed_factor(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
 		unsigned int mult, unsigned int div);
 
@@ -479,7 +452,7 @@ struct clk_fractional_divider {
 };
 
 extern const struct clk_ops clk_fractional_divider_ops;
-struct clk *clk_register_fractional_divider(struct device *dev,
+struct clk_core *clk_register_fractional_divider(struct device *dev,
 		const char *name, const char *parent_name, unsigned long flags,
 		void __iomem *reg, u8 mshift, u8 mwidth, u8 nshift, u8 nwidth,
 		u8 clk_divider_flags, spinlock_t *lock);
@@ -508,7 +481,7 @@ struct clk_composite {
 	const struct clk_ops	*gate_ops;
 };
 
-struct clk *clk_register_composite(struct device *dev, const char *name,
+struct clk_core *clk_register_composite(struct device *dev, const char *name,
 		const char **parent_names, int num_parents,
 		struct clk_hw *mux_hw, const struct clk_ops *mux_ops,
 		struct clk_hw *rate_hw, const struct clk_ops *rate_ops,
@@ -521,49 +494,87 @@ struct clk *clk_register_composite(struct device *dev, const char *name,
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
+int clk_provider_enable(struct clk_core *clk);
+void clk_provider_disable(struct clk_core *clk);
+int clk_provider_set_parent(struct clk_core *clk, struct clk_core *parent);
+int clk_provider_set_rate(struct clk_core *clk, unsigned long rate);
+struct clk_core *clk_provider_get_parent(struct clk_core *clk);
+unsigned long clk_provider_get_rate(struct clk_core *clk);
+long clk_provider_round_rate(struct clk_core *clk, unsigned long rate);
+struct clk_core *clk_provider_get_sys(const char *dev_id, const char *con_id);
+struct clk_core *clk_provider_get(struct device *dev, const char *con_id);
+struct clk_core *devm_clk_provider_get(struct device *dev, const char *id);
+int clk_provider_notifier_register(struct clk_core *clk, struct notifier_block *nb);
+int clk_provider_notifier_unregister(struct clk_core *clk, struct notifier_block *nb);
+struct clk_core *clk_to_clk_core(struct clk *clk);
+
+/* clk_provider_prepare_enable helps cases using clk_enable in non-atomic context. */
+static inline int clk_provider_prepare_enable(struct clk_core *clk)
+{
+	int ret;
+
+	ret = clk_provider_prepare(clk);
+	if (ret)
+		return ret;
+	ret = clk_provider_enable(clk);
+	if (ret)
+		clk_provider_unprepare(clk);
+
+	return ret;
+}
+
+/* clk_provider_disable_unprepare helps cases using clk_disable in non-atomic context. */
+static inline void clk_provider_disable_unprepare(struct clk_core *clk)
+{
+	clk_provider_disable(clk);
+	clk_provider_unprepare(clk);
+}
 
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
 
@@ -573,22 +584,23 @@ extern struct of_device_id __clk_of_table;
 
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
@@ -596,12 +608,12 @@ static inline int of_clk_add_provider(struct device_node *np,
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
@@ -611,6 +623,10 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
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
@@ -647,7 +663,7 @@ static inline void clk_writel(u32 val, u32 __iomem *reg)
 #endif	/* platform dependent I/O accessors */
 
 #ifdef CONFIG_DEBUG_FS
-struct dentry *clk_debugfs_add_file(struct clk *clk, char *name, umode_t mode,
+struct dentry *clk_debugfs_add_file(struct clk_core *clk, char *name, umode_t mode,
 				void *data, const struct file_operations *fops);
 #endif
 
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097..f46a2eb 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -22,6 +22,8 @@ struct clk;
 
 #ifdef CONFIG_COMMON_CLK
 
+struct clk_core;
+
 /**
  * DOC: clk notifier callback types
  *
@@ -56,7 +58,7 @@ struct clk;
  * @notifier_head.
  */
 struct clk_notifier {
-	struct clk			*clk;
+	struct clk_core			*clk;
 	struct srcu_notifier_head	notifier_head;
 	struct list_head		node;
 };
@@ -73,7 +75,7 @@ struct clk_notifier {
  * current rate (this was done to optimize the implementation).
  */
 struct clk_notifier_data {
-	struct clk		*clk;
+	struct clk_core		*clk;
 	unsigned long		old_rate;
 	unsigned long		new_rate;
 };
@@ -307,6 +309,14 @@ struct clk *clk_get_parent(struct clk *clk);
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
@@ -398,7 +408,8 @@ struct of_phandle_args;
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
-struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
+struct clk_core *of_clk_provider_get_by_name(struct device_node *np, const char *name);
+struct clk_core *of_clk_get_from_provider(struct of_phandle_args *clkspec);
 #else
 static inline struct clk *of_clk_get(struct device_node *np, int index)
 {
@@ -409,6 +420,21 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return ERR_PTR(-ENOENT);
 }
+
+#if defined(CONFIG_COMMON_CLK)
+static inline struct clk_core *of_clk_provider_get_by_name(struct device_node *np,
+							   const char *name)
+{
+	return ERR_PTR(-ENOENT);
+}
+#else
+static inline struct clk *of_clk_provider_get_by_name(struct device_node *np,
+						      const char *name)
+{
+	return ERR_PTR(-ENOENT);
+}
+#endif /* CONFIG_COMMON_CLK */
+
 #endif
 
 #endif
diff --git a/include/linux/clkdev.h b/include/linux/clkdev.h
index 94bad77..a6c5d67 100644
--- a/include/linux/clkdev.h
+++ b/include/linux/clkdev.h
@@ -17,11 +17,23 @@
 struct clk;
 struct device;
 
+/*
+ * To avoid a mass-rename of all non-common clock implementations (spread out
+ * in arch-specific code), we let them use struct clk for both the internal and
+ * external view.
+ */
+#ifdef CONFIG_COMMON_CLK
+struct clk_core;
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

