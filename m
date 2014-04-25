Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaDYWpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:45:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42933 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaDYWpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:45:30 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC/PATCH 4/4] clk: Use ww_mutexes for clk_prepare_{lock/unlock}
Date: Fri, 25 Apr 2014 15:44:48 -0700
Message-Id: <1398465888-12610-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1398465888-12610-1-git-send-email-sboyd@codeaurora.org>
References: <1398465888-12610-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the rate of a "slow" clock can take 10s of milliseconds
while changing the rate of a "fast" clock can be done in a few
microseconds. With one prepare mutex a task that's trying to
change the rate of a fast clock may have to wait for a slow
clock's rate to change before it can proceed. Consider the case
of a GPU driver which wants to scale up the GPU speed before
drawing a frame that gets stuck behind a PLL being reprogrammed.
In this case the thread performing the drawing may have to wait
for 10s of milliseconds while the PLL stabilizes. At 60 FPS
waiting for more than 16ms to grab the prepare mutex can lead to
missed frame updates and visible artifacts.

Furthermore, the recursive prepare mutex suffers from a deadlock
when a clock, say clock S, is controlled by a chip sitting on the
SPI bus and we need to enable the SPI master controller's clock
to send a message to enable clock S. The SPI core will use a
different thread to enable the SPI controller's clock causing the
recursion detection mechanism to fail.

Remedy these problems by introducing a per-clock wound/wait mutex
to replace the global prepare mutex. This should allow discreet
parts of the clock tree to change rates and prepare/unprepare in
parallel with each-other. Unfortunately we lose the recursive
feature of the prepare mutex with this change and lockdep
complains if the same thread tries to call any clk_* operations
from within a clock op even if that thread is only acquiring new
locks that aren't already held.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/clk.c           | 525 +++++++++++++++++++++++++++++++++++++-------
 include/linux/clk-private.h |   3 +
 2 files changed, 445 insertions(+), 83 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 48b3a5594839..6596f47927df 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -20,18 +20,18 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/ww_mutex.h>
 
 #include "clk.h"
 
 static DEFINE_SPINLOCK(enable_lock);
-static DEFINE_MUTEX(prepare_lock);
+static DEFINE_WW_CLASS(prepare_ww_class);
 
-static struct task_struct *prepare_owner;
 static struct task_struct *enable_owner;
-
-static int prepare_refcnt;
 static int enable_refcnt;
 
+static DEFINE_MUTEX(clk_list_lock);
+static DEFINE_MUTEX(clk_notifier_lock);
 static DEFINE_MUTEX(clk_lookup_lock);
 static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
@@ -39,30 +39,236 @@ static HLIST_HEAD(clk_lookup_list);
 static LIST_HEAD(clk_notifier_list);
 
 /***           locking             ***/
-static void clk_prepare_lock(void)
+static void __clk_unlock(struct list_head *list)
+{
+	struct clk *entry, *temp;
+
+	list_for_each_entry_safe (entry, temp, list, ww_list) {
+		list_del_init(&entry->ww_list);
+		ww_mutex_unlock(&entry->lock);
+	}
+}
+
+static void clk_unlock(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	__clk_unlock(list);
+	ww_acquire_fini(ctx);
+}
+
+static int clk_lock_one(struct clk *clk, struct list_head *list,
+			  struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	if (!clk)
+		return 0;
+
+	ret = ww_mutex_lock(&clk->lock, ctx);
+	if (ret == -EDEADLK) {
+		__clk_unlock(list);
+		ww_mutex_lock_slow(&clk->lock, ctx);
+		list_add(&clk->ww_list, list);
+	} else if (ret != -EALREADY) {
+		list_add_tail(&clk->ww_list, list);
+	}
+
+	return ret;
+}
+
+
+static int __clk_lock_subtree(struct clk *clk, struct list_head *list,
+			     struct ww_acquire_ctx *ctx)
+{
+	int ret;
+	struct clk *child;
+
+	lockdep_assert_held(&clk->lock.base);
+
+	hlist_for_each_entry(child, &clk->children, child_node) {
+		ret = clk_lock_one(child, list, ctx);
+		if (ret == -EDEADLK)
+			return ret;
+		ret = __clk_lock_subtree(child, list, ctx);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void clk_lock_subtree(struct clk *clk, struct list_head *list,
+			     struct ww_acquire_ctx *ctx)
 {
-	if (!mutex_trylock(&prepare_lock)) {
-		if (prepare_owner == current) {
-			prepare_refcnt++;
-			return;
+	int ret;
+
+	do {
+		ret = clk_lock_one(clk, list, ctx);
+		if (ret == -EDEADLK)
+			continue;
+		ret = __clk_lock_subtree(clk, list, ctx);
+	} while (ret == -EDEADLK);
+}
+
+/* Lock a clock, it's parent (and optionally a new parent),
+ * and all it's descendents
+ */
+static void clk_parent_lock(struct clk *clk, struct clk *new_parent,
+			    struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	ww_acquire_init(ctx, &prepare_ww_class);
+
+	do {
+		ret = clk_lock_one(clk, list, ctx);
+		if (ret == -EDEADLK)
+			continue;
+		ret = clk_lock_one(clk->parent, list, ctx);
+		if (ret == -EDEADLK)
+			continue;
+		if (new_parent && new_parent != clk->parent) {
+			ret = clk_lock_one(new_parent, list, ctx);
+			if (ret == -EDEADLK)
+				continue;
+		}
+		ret = __clk_lock_subtree(clk, list, ctx);
+	} while (ret == -EDEADLK);
+
+	ww_acquire_done(ctx);
+}
+
+static void clk_register_lock(struct clk *clk, struct list_head *list,
+			      struct ww_acquire_ctx *ctx)
+{
+	int ret, i;
+	struct clk *orphan;
+
+	lockdep_assert_held(&clk_list_lock);
+	ww_acquire_init(ctx, &prepare_ww_class);
+
+retry:
+	ret = clk_lock_one(clk, list, ctx);
+	if (ret == -EDEADLK)
+		goto retry;
+
+	ret = clk_lock_one(clk->parent, list, ctx);
+	if (ret == -EDEADLK)
+		goto retry;
+
+	hlist_for_each_entry(orphan, &clk_orphan_list, child_node) {
+		if (orphan->num_parents && orphan->ops->get_parent) {
+			i = orphan->ops->get_parent(orphan->hw);
+			if (!strcmp(clk->name, orphan->parent_names[i])) {
+				ret = clk_lock_one(orphan, list, ctx);
+				if (ret == -EDEADLK)
+					goto retry;
+				ret = __clk_lock_subtree(orphan, list, ctx);
+				if (ret == -EDEADLK)
+					goto retry;
+			}
+			continue;
+		}
+		for (i = 0; i < orphan->num_parents; i++) {
+			if (!strcmp(clk->name, orphan->parent_names[i])) {
+				ret = clk_lock_one(orphan, list, ctx);
+				if (ret == -EDEADLK)
+					goto retry;
+				ret = __clk_lock_subtree(orphan, list, ctx);
+				if (ret == -EDEADLK)
+					goto retry;
+				break;
+			}
 		}
-		mutex_lock(&prepare_lock);
 	}
-	WARN_ON_ONCE(prepare_owner != NULL);
-	WARN_ON_ONCE(prepare_refcnt != 0);
-	prepare_owner = current;
-	prepare_refcnt = 1;
+
+	ww_acquire_done(ctx);
 }
 
-static void clk_prepare_unlock(void)
+static void clk_lock_all(struct list_head *list, struct ww_acquire_ctx *ctx)
 {
-	WARN_ON_ONCE(prepare_owner != current);
-	WARN_ON_ONCE(prepare_refcnt == 0);
+	int ret;
+	struct clk *clk;
 
-	if (--prepare_refcnt)
-		return;
-	prepare_owner = NULL;
-	mutex_unlock(&prepare_lock);
+	lockdep_assert_held(&clk_list_lock);
+	ww_acquire_init(ctx, &prepare_ww_class);
+retry:
+	hlist_for_each_entry(clk, &clk_root_list, child_node) {
+		ret = clk_lock_one(clk, list, ctx);
+		if (ret == -EDEADLK)
+			goto retry;
+		ret = __clk_lock_subtree(clk, list, ctx);
+		if (ret == -EDEADLK)
+			goto retry;
+	}
+
+	hlist_for_each_entry(clk, &clk_orphan_list, child_node) {
+		ret = clk_lock_one(clk, list, ctx);
+		if (ret == -EDEADLK)
+			goto retry;
+		ret = __clk_lock_subtree(clk, list, ctx);
+		if (ret == -EDEADLK)
+			goto retry;
+	}
+
+	ww_acquire_done(ctx);
+}
+
+static int __clk_prepare_lock(struct clk *clk, struct list_head *list,
+			       struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	do {
+		ret = clk_lock_one(clk, list, ctx);
+		if (ret == -EDEADLK)
+			return ret;
+
+		if (clk->prepare_count > 0)
+			break;
+	} while ((clk = clk->parent));
+
+	return 0;
+}
+
+static void clk_prepare_lock(struct clk *clk, struct list_head *list,
+			     struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	ww_acquire_init(ctx, &prepare_ww_class);
+	do {
+		ret = __clk_prepare_lock(clk, list, ctx);
+	} while (ret == -EDEADLK);
+	ww_acquire_done(ctx);
+}
+
+static int __clk_unprepare_lock(struct clk *clk, struct list_head *list,
+			         struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	do {
+		ret = clk_lock_one(clk, list, ctx);
+		if (ret == -EDEADLK)
+			return ret;
+
+		if (clk->prepare_count > 1)
+			break;
+	} while ((clk = clk->parent));
+
+	return 0;
+}
+
+static void clk_unprepare_lock(struct clk *clk, struct list_head *list,
+			       struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	ww_acquire_init(ctx, &prepare_ww_class);
+	do {
+		ret = __clk_unprepare_lock(clk, list, ctx);
+	} while (ret == -EDEADLK);
+	ww_acquire_done(ctx);
 }
 
 static unsigned long clk_enable_lock(void)
@@ -132,20 +338,24 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
 
 static int clk_summary_show(struct seq_file *s, void *data)
 {
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 	struct clk *c;
 
+	mutex_lock(&clk_list_lock);
+	clk_lock_all(&list, &ctx);
+
 	seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate        accuracy\n");
 	seq_printf(s, "---------------------------------------------------------------------------------\n");
 
-	clk_prepare_lock();
-
 	hlist_for_each_entry(c, &clk_root_list, child_node)
 		clk_summary_show_subtree(s, c, 0);
 
 	hlist_for_each_entry(c, &clk_orphan_list, child_node)
 		clk_summary_show_subtree(s, c, 0);
 
-	clk_prepare_unlock();
+	clk_unlock(&list, &ctx);
+	mutex_unlock(&clk_list_lock);
 
 	return 0;
 }
@@ -194,12 +404,15 @@ static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
 
 static int clk_dump(struct seq_file *s, void *data)
 {
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 	struct clk *c;
 	bool first_node = true;
 
 	seq_printf(s, "{");
 
-	clk_prepare_lock();
+	mutex_lock(&clk_list_lock);
+	clk_lock_all(&list, &ctx);
 
 	hlist_for_each_entry(c, &clk_root_list, child_node) {
 		if (!first_node)
@@ -213,7 +426,8 @@ static int clk_dump(struct seq_file *s, void *data)
 		clk_dump_subtree(s, c, 0);
 	}
 
-	clk_prepare_unlock();
+	clk_unlock(&list, &ctx);
+	mutex_unlock(&clk_list_lock);
 
 	seq_printf(s, "}");
 	return 0;
@@ -422,6 +636,8 @@ static int __init clk_debug_init(void)
 {
 	struct clk *clk;
 	struct dentry *d;
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 
 	rootdir = debugfs_create_dir("clk", NULL);
 
@@ -443,7 +659,8 @@ static int __init clk_debug_init(void)
 	if (!orphandir)
 		return -ENOMEM;
 
-	clk_prepare_lock();
+	mutex_lock(&clk_list_lock);
+	clk_lock_all(&list, &ctx);
 
 	hlist_for_each_entry(clk, &clk_root_list, child_node)
 		clk_debug_create_subtree(clk, rootdir);
@@ -453,7 +670,8 @@ static int __init clk_debug_init(void)
 
 	inited = 1;
 
-	clk_prepare_unlock();
+	clk_unlock(&list, &ctx);
+	mutex_unlock(&clk_list_lock);
 
 	return 0;
 }
@@ -542,6 +760,8 @@ __setup("clk_ignore_unused", clk_ignore_unused_setup);
 
 static int clk_disable_unused(void)
 {
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 	struct clk *clk;
 
 	if (clk_ignore_unused) {
@@ -549,7 +769,8 @@ static int clk_disable_unused(void)
 		return 0;
 	}
 
-	clk_prepare_lock();
+	mutex_lock(&clk_list_lock);
+	clk_lock_all(&list, &ctx);
 
 	hlist_for_each_entry(clk, &clk_root_list, child_node)
 		clk_disable_unused_subtree(clk);
@@ -563,7 +784,8 @@ static int clk_disable_unused(void)
 	hlist_for_each_entry(clk, &clk_orphan_list, child_node)
 		clk_unprepare_unused_subtree(clk);
 
-	clk_prepare_unlock();
+	clk_unlock(&list, &ctx);
+	mutex_unlock(&clk_list_lock);
 
 	return 0;
 }
@@ -811,12 +1033,15 @@ void __clk_unprepare(struct clk *clk)
  */
 void clk_unprepare(struct clk *clk)
 {
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
+
 	if (IS_ERR_OR_NULL(clk))
 		return;
 
-	clk_prepare_lock();
+	clk_unprepare_lock(clk, &list, &ctx);
 	__clk_unprepare(clk);
-	clk_prepare_unlock();
+	clk_unlock(&list, &ctx);
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
 
@@ -861,10 +1086,15 @@ int __clk_prepare(struct clk *clk)
 int clk_prepare(struct clk *clk)
 {
 	int ret;
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 
-	clk_prepare_lock();
+	if (!clk)
+		return 0;
+
+	clk_prepare_lock(clk, &list, &ctx);
 	ret = __clk_prepare(clk);
-	clk_prepare_unlock();
+	clk_unlock(&list, &ctx);
 
 	return ret;
 }
@@ -1010,9 +1240,13 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 {
 	unsigned long ret;
 
-	clk_prepare_lock();
+	if (!clk)
+		return 0;
+
+	/* Protect against concurrent set_parent calls */
+	ww_mutex_lock(&clk->lock, NULL);
 	ret = __clk_round_rate(clk, rate);
-	clk_prepare_unlock();
+	ww_mutex_unlock(&clk->lock);
 
 	return ret;
 }
@@ -1043,6 +1277,7 @@ static int __clk_notify(struct clk *clk, unsigned long msg,
 	cnd.old_rate = old_rate;
 	cnd.new_rate = new_rate;
 
+	mutex_lock(&clk_notifier_lock);
 	list_for_each_entry(cn, &clk_notifier_list, node) {
 		if (cn->clk == clk) {
 			ret = srcu_notifier_call_chain(&cn->notifier_head, msg,
@@ -1050,6 +1285,7 @@ static int __clk_notify(struct clk *clk, unsigned long msg,
 			break;
 		}
 	}
+	mutex_unlock(&clk_notifier_lock);
 
 	return ret;
 }
@@ -1094,11 +1330,24 @@ static void __clk_recalc_accuracies(struct clk *clk)
  */
 long clk_get_accuracy(struct clk *clk)
 {
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 	unsigned long accuracy;
 
-	clk_prepare_lock();
+	if (clk && !(clk->flags & CLK_GET_ACCURACY_NOCACHE)) {
+		ww_mutex_lock(&clk->lock, NULL);
+	} else {
+		ww_acquire_init(&ctx, &prepare_ww_class);
+		clk_lock_subtree(clk, &list, &ctx);
+		ww_acquire_done(&ctx);
+	}
+
 	accuracy = __clk_get_accuracy(clk);
-	clk_prepare_unlock();
+
+	if (clk && !(clk->flags & CLK_GET_ACCURACY_NOCACHE))
+		ww_mutex_unlock(&clk->lock);
+	else
+		clk_unlock(&list, &ctx);
 
 	return accuracy;
 }
@@ -1159,11 +1408,24 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
  */
 unsigned long clk_get_rate(struct clk *clk)
 {
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 	unsigned long rate;
 
-	clk_prepare_lock();
+	if (clk && !(clk->flags & CLK_GET_RATE_NOCACHE)) {
+		ww_mutex_lock(&clk->lock, NULL);
+	} else {
+		ww_acquire_init(&ctx, &prepare_ww_class);
+		clk_lock_subtree(clk, &list, &ctx);
+		ww_acquire_done(&ctx);
+	}
+
 	rate = __clk_get_rate(clk);
-	clk_prepare_unlock();
+
+	if (clk && !(clk->flags & CLK_GET_RATE_NOCACHE))
+		ww_mutex_unlock(&clk->lock);
+	else
+		clk_unlock(&list, &ctx);
 
 	return rate;
 }
@@ -1345,9 +1607,11 @@ out:
 	return ret;
 }
 
-static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
-			     struct clk *new_parent, u8 p_index)
+static int clk_calc_subtree(struct clk *clk, unsigned long new_rate,
+			     struct clk *new_parent, u8 p_index,
+			     struct list_head *list, struct ww_acquire_ctx *ctx)
 {
+	int ret;
 	struct clk *child;
 
 	clk->new_rate = new_rate;
@@ -1359,27 +1623,43 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
 		new_parent->new_child = clk;
 
 	hlist_for_each_entry(child, &clk->children, child_node) {
+		ret = clk_lock_one(child, list, ctx);
+		if (ret == -EDEADLK)
+			return ret;
+
 		child->new_rate = clk_recalc(child, new_rate);
-		clk_calc_subtree(child, child->new_rate, NULL, 0);
+		ret = clk_calc_subtree(child, child->new_rate, NULL, 0, list,
+					ctx);
+		if (ret)
+			return ret;
 	}
+
+	return 0;
 }
 
 /*
  * calculate the new rates returning the topmost clock that has to be
  * changed.
  */
-static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
+static struct clk *
+clk_calc_new_rates(struct clk *clk, unsigned long rate, struct list_head *list,
+		   struct ww_acquire_ctx *ctx)
 {
 	struct clk *top = clk;
 	struct clk *old_parent, *parent;
 	unsigned long best_parent_rate = 0;
 	unsigned long new_rate;
 	int p_index = 0;
+	int ret;
 
 	/* sanity */
 	if (IS_ERR_OR_NULL(clk))
 		return NULL;
 
+	ret = clk_lock_one(clk, list, ctx);
+	if (ret == -EDEADLK)
+		return ERR_PTR(ret);
+
 	/* save parent rate, if it exists */
 	parent = old_parent = clk->parent;
 	if (parent)
@@ -1399,7 +1679,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 		return NULL;
 	} else {
 		/* pass-through clock with adjustable parent */
-		top = clk_calc_new_rates(parent, rate);
+		top = clk_calc_new_rates(parent, rate, list, ctx);
 		new_rate = parent->new_rate;
 		goto out;
 	}
@@ -1422,16 +1702,84 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 		}
 	}
 
+	/* Lock old and new parent if we're doing a parent switch */
+	if (parent != old_parent) {
+		/*
+		 * Lock any ancestor clocks that will be prepared/unprepared if
+		 * this clock is enabled
+		 */
+		if (clk->prepare_count) {
+			ret = __clk_unprepare_lock(old_parent, list, ctx);
+			if (ret == -EDEADLK)
+				return ERR_PTR(ret);
+			ret = __clk_prepare_lock(parent, list, ctx);
+			if (ret == -EDEADLK)
+				return ERR_PTR(ret);
+		} else {
+			ret = clk_lock_one(old_parent, list, ctx);
+			if (ret == -EDEADLK)
+				return ERR_PTR(ret);
+			ret = clk_lock_one(parent, list, ctx);
+			if (ret == -EDEADLK)
+				return ERR_PTR(ret);
+		}
+	}
+
 	if ((clk->flags & CLK_SET_RATE_PARENT) && parent &&
 	    best_parent_rate != parent->rate)
-		top = clk_calc_new_rates(parent, best_parent_rate);
+		top = clk_calc_new_rates(parent, best_parent_rate, list, ctx);
 
 out:
-	clk_calc_subtree(clk, new_rate, parent, p_index);
+	if (!IS_ERR(top)) {
+		ret = clk_calc_subtree(clk, new_rate, parent, p_index, list,
+					ctx);
+		if (ret)
+			top = ERR_PTR(ret);
+	}
 
 	return top;
 }
 
+static struct clk *clk_set_rate_lock(struct clk *clk, unsigned long rate,
+				     struct list_head *list,
+				     struct ww_acquire_ctx *ctx)
+{
+	int ret;
+	struct clk *top;
+
+	ww_acquire_init(ctx, &prepare_ww_class);
+retry:
+	ret = clk_lock_one(clk, list, ctx);
+	if (ret == -EDEADLK)
+		goto retry;
+
+	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
+		ret = -EBUSY;
+		goto err;
+	}
+
+	top = clk_calc_new_rates(clk, rate, list, ctx);
+	if (!top) {
+		ret = -EINVAL;
+		goto err;
+	}
+	if (IS_ERR(top)) {
+		if (PTR_ERR(top) == -EDEADLK) {
+			goto retry;
+		} else {
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+	ww_acquire_done(ctx);
+
+	return top;
+err:
+	ww_acquire_done(ctx);
+	clk_unlock(list, ctx);
+	return ERR_PTR(ret);
+}
+
 /*
  * Notify about rate changes in a subtree. Always walk down the whole tree
  * so that in case of an error we can walk down the whole tree again and
@@ -1549,28 +1897,23 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	struct clk *top, *fail_clk;
 	int ret = 0;
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 
 	if (!clk)
 		return 0;
 
-	/* prevent racing with updates to the clock topology */
-	clk_prepare_lock();
-
 	/* bail early if nothing to do */
 	if (rate == clk_get_rate(clk))
-		goto out;
-
-	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
-		ret = -EBUSY;
-		goto out;
-	}
+		return 0;
 
+	/* prevent racing with updates to the clock topology */
 	/* calculate new rates and get the topmost changed clock */
-	top = clk_calc_new_rates(clk, rate);
-	if (!top) {
-		ret = -EINVAL;
-		goto out;
-	}
+	top = clk_set_rate_lock(clk, rate, &list, &ctx);
+	if (IS_ERR(top))
+		return PTR_ERR(top);
+	if (!top)
+		return -EINVAL;
 
 	/* notify that we are about to change rates */
 	fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
@@ -1586,7 +1929,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	clk_change_rate(top);
 
 out:
-	clk_prepare_unlock();
+	clk_unlock(&list, &ctx);
 
 	return ret;
 }
@@ -1602,9 +1945,9 @@ struct clk *clk_get_parent(struct clk *clk)
 {
 	struct clk *parent;
 
-	clk_prepare_lock();
+	ww_mutex_lock(&clk->lock, NULL);
 	parent = __clk_get_parent(clk);
-	clk_prepare_unlock();
+	ww_mutex_unlock(&clk->lock);
 
 	return parent;
 }
@@ -1692,6 +2035,8 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	int ret = 0;
 	int p_index = 0;
 	unsigned long p_rate = 0;
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 
 	if (!clk)
 		return 0;
@@ -1701,7 +2046,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 		return -ENOSYS;
 
 	/* prevent racing with updates to the clock topology */
-	clk_prepare_lock();
+	clk_parent_lock(clk, parent, &list, &ctx);
 
 	if (clk->parent == parent)
 		goto out;
@@ -1743,7 +2088,7 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	}
 
 out:
-	clk_prepare_unlock();
+	clk_unlock(&list, &ctx);
 
 	return ret;
 }
@@ -1762,11 +2107,13 @@ int __clk_init(struct device *dev, struct clk *clk)
 	int i, ret = 0;
 	struct clk *orphan;
 	struct hlist_node *tmp2;
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 
 	if (!clk)
 		return -EINVAL;
 
-	clk_prepare_lock();
+	ww_mutex_init(&clk->lock, &prepare_ww_class);
 
 	/* check to see if a clock with this name is already registered */
 	if (__clk_lookup(clk->name)) {
@@ -1834,6 +2181,9 @@ int __clk_init(struct device *dev, struct clk *clk)
 
 	clk->parent = __clk_init_parent(clk);
 
+	mutex_lock(&clk_list_lock);
+	clk_register_lock(clk, &list, &ctx);
+
 	/* Insert into clock lookup list */
 	mutex_lock(&clk_lookup_lock);
 	hlist_add_head(&clk->lookup_node, &clk_lookup_list);
@@ -1918,9 +2268,9 @@ int __clk_init(struct device *dev, struct clk *clk)
 		clk->ops->init(clk->hw);
 
 	kref_init(&clk->ref);
+	clk_unlock(&list, &ctx);
+	mutex_unlock(&clk_list_lock);
 out:
-	clk_prepare_unlock();
-
 	return ret;
 }
 
@@ -2112,16 +2462,21 @@ static const struct clk_ops clk_nodrv_ops = {
  */
 void clk_unregister(struct clk *clk)
 {
+	struct ww_acquire_ctx ctx;
+	LIST_HEAD(list);
 	unsigned long flags;
 
        if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
                return;
 
-	clk_prepare_lock();
+	mutex_lock(&clk_list_lock);
+	clk_parent_lock(clk, NULL, &list, &ctx);
 
 	if (clk->ops == &clk_nodrv_ops) {
 		pr_err("%s: unregistered clock: %s\n", __func__, clk->name);
-		goto out;
+		clk_unlock(&list, &ctx);
+		mutex_unlock(&clk_list_lock);
+		return;
 	}
 	/*
 	 * Assign empty clock ops for consumers that might still hold
@@ -2135,8 +2490,11 @@ void clk_unregister(struct clk *clk)
 		struct clk *child;
 
 		/* Reparent all children to the orphan list. */
-		hlist_for_each_entry(child, &clk->children, child_node)
-			clk_set_parent(child, NULL);
+		hlist_for_each_entry(child, &clk->children, child_node) {
+			__clk_set_parent(clk, NULL, 0);
+			__clk_recalc_rates(clk, 0);
+			__clk_recalc_accuracies(clk);
+		}
 	}
 
 	clk_debug_unregister(clk);
@@ -2150,10 +2508,10 @@ void clk_unregister(struct clk *clk)
 	if (clk->prepare_count)
 		pr_warn("%s: unregistering prepared clock: %s\n",
 					__func__, clk->name);
+	clk_unlock(&list, &ctx);
+	mutex_unlock(&clk_list_lock);
 
 	kref_put(&clk->ref, __clk_release);
-out:
-	clk_prepare_unlock();
 }
 EXPORT_SYMBOL_GPL(clk_unregister);
 
@@ -2233,9 +2591,7 @@ void __clk_put(struct clk *clk)
 	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
 		return;
 
-	clk_prepare_lock();
 	kref_put(&clk->ref, __clk_release);
-	clk_prepare_unlock();
 
 	module_put(clk->owner);
 }
@@ -2271,7 +2627,8 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
 	if (!clk || !nb)
 		return -EINVAL;
 
-	clk_prepare_lock();
+	ww_mutex_lock(&clk->lock, NULL);
+	mutex_lock(&clk_notifier_lock);
 
 	/* search the list of notifiers for this clk */
 	list_for_each_entry(cn, &clk_notifier_list, node)
@@ -2290,12 +2647,14 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
 		list_add(&cn->node, &clk_notifier_list);
 	}
 
+
 	ret = srcu_notifier_chain_register(&cn->notifier_head, nb);
 
 	clk->notifier_count++;
 
 out:
-	clk_prepare_unlock();
+	mutex_unlock(&clk_notifier_lock);
+	ww_mutex_unlock(&clk->lock);
 
 	return ret;
 }
@@ -2320,8 +2679,8 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 	if (!clk || !nb)
 		return -EINVAL;
 
-	clk_prepare_lock();
-
+	ww_mutex_lock(&clk->lock, NULL);
+	mutex_lock(&clk_notifier_lock);
 	list_for_each_entry(cn, &clk_notifier_list, node)
 		if (cn->clk == clk)
 			break;
@@ -2341,8 +2700,8 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 	} else {
 		ret = -ENOENT;
 	}
-
-	clk_prepare_unlock();
+	mutex_unlock(&clk_notifier_lock);
+	ww_mutex_unlock(&clk->lock);
 
 	return ret;
 }
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 3cd98a930006..b1ccfb19308c 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -14,6 +14,7 @@
 #include <linux/clk-provider.h>
 #include <linux/kref.h>
 #include <linux/list.h>
+#include <linux/ww_mutex.h>
 
 /*
  * WARNING: Do not include clk-private.h from any file that implements struct
@@ -54,6 +55,8 @@ struct clk {
 	struct dentry		*dentry;
 #endif
 	struct kref		ref;
+	struct ww_mutex		lock;
+	struct list_head	ww_list;
 };
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

