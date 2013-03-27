Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3C0HKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:10:45 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:32998 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3C0HKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:10:44 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Mike Turquette <mturquette@linaro.org>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v4] clk: allow reentrant calls into the clk framework
Date: Wed, 27 Mar 2013 00:09:43 -0700
Message-Id: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reentrancy into the clock framework from the clk.h api is necessary for
clocks that are prepared and unprepared via i2c_transfer (which includes
many PMICs and discrete audio chips) as well as for several other use
cases.

This patch implements reentrancy by adding two global atomic_t's which
track the context of the current caller.  Context in this case is the
return value from get_current().  One context variable is for slow
operations protected by the prepare_mutex and the other is for fast
operations protected by the enable_lock spinlock.

The clk.h api implementations are modified to first see if the relevant
global lock is already held and if so compare the global context (set by
whoever is holding the lock) against their own context (via a call to
get_current()).  If the two match then this function is a nested call
from the one already holding the lock and we procede.  If the context
does not match then procede to call mutex_lock and busy-wait for the
existing task to complete.

This patch does not increase concurrency for unrelated calls into the
clock framework.  Instead it simply allows reentrancy by the single task
which is currently holding the global clock framework lock.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/clk/clk.c |  255 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 186 insertions(+), 69 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 5e8ffff..17432a5 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -19,9 +19,12 @@
 #include <linux/of.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
+static atomic_t prepare_context;
+static atomic_t enable_context;
 
 static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
@@ -456,27 +459,6 @@ unsigned int __clk_get_prepare_count(struct clk *clk)
 	return !clk ? 0 : clk->prepare_count;
 }
 
-unsigned long __clk_get_rate(struct clk *clk)
-{
-	unsigned long ret;
-
-	if (!clk) {
-		ret = 0;
-		goto out;
-	}
-
-	ret = clk->rate;
-
-	if (clk->flags & CLK_IS_ROOT)
-		goto out;
-
-	if (!clk->parent)
-		ret = 0;
-
-out:
-	return ret;
-}
-
 unsigned long __clk_get_flags(struct clk *clk)
 {
 	return !clk ? 0 : clk->flags;
@@ -566,6 +548,35 @@ struct clk *__clk_lookup(const char *name)
 	return NULL;
 }
 
+/***  locking & reentrancy ***/
+
+static void clk_fwk_lock(void)
+{
+	/* hold the framework-wide lock, context == NULL */
+	mutex_lock(&prepare_lock);
+
+	/* set context for any reentrant calls */
+	atomic_set(&prepare_context, (int) get_current());
+}
+
+static void clk_fwk_unlock(void)
+{
+	/* clear the context */
+	atomic_set(&prepare_context, 0);
+
+	/* release the framework-wide lock, context == NULL */
+	mutex_unlock(&prepare_lock);
+}
+
+static bool clk_is_reentrant(void)
+{
+	if (mutex_is_locked(&prepare_lock))
+		if ((void *) atomic_read(&prepare_context) == get_current())
+			return true;
+
+	return false;
+}
+
 /***        clk api        ***/
 
 void __clk_unprepare(struct clk *clk)
@@ -600,9 +611,15 @@ void __clk_unprepare(struct clk *clk)
  */
 void clk_unprepare(struct clk *clk)
 {
-	mutex_lock(&prepare_lock);
+	/* re-enter if call is from the same context */
+	if (clk_is_reentrant()) {
+		__clk_unprepare(clk);
+		return;
+	}
+
+	clk_fwk_lock();
 	__clk_unprepare(clk);
-	mutex_unlock(&prepare_lock);
+	clk_fwk_unlock();
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
 
@@ -648,10 +665,16 @@ int clk_prepare(struct clk *clk)
 {
 	int ret;
 
-	mutex_lock(&prepare_lock);
-	ret = __clk_prepare(clk);
-	mutex_unlock(&prepare_lock);
+	/* re-enter if call is from the same context */
+	if (clk_is_reentrant()) {
+		ret = __clk_prepare(clk);
+		goto out;
+	}
 
+	clk_fwk_lock();
+	ret = __clk_prepare(clk);
+	clk_fwk_unlock();
+out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_prepare);
@@ -692,8 +715,27 @@ void clk_disable(struct clk *clk)
 {
 	unsigned long flags;
 
+	/* this call re-enters if it is from the same context */
+	if (spin_is_locked(&enable_lock)) {
+		if ((void *) atomic_read(&enable_context) == get_current()) {
+			__clk_disable(clk);
+			return;
+		}
+	}
+
+	/* hold the framework-wide lock, context == NULL */
 	spin_lock_irqsave(&enable_lock, flags);
+
+	/* set context for any reentrant calls */
+	atomic_set(&enable_context, (int) get_current());
+
+	/* disable the clock(s) */
 	__clk_disable(clk);
+
+	/* clear the context */
+	atomic_set(&enable_context, 0);
+
+	/* release the framework-wide lock, context == NULL */
 	spin_unlock_irqrestore(&enable_lock, flags);
 }
 EXPORT_SYMBOL_GPL(clk_disable);
@@ -745,10 +787,29 @@ int clk_enable(struct clk *clk)
 	unsigned long flags;
 	int ret;
 
+	/* this call re-enters if it is from the same context */
+	if (spin_is_locked(&enable_lock)) {
+		if ((void *) atomic_read(&enable_context) == get_current()) {
+			ret = __clk_enable(clk);
+			goto out;
+		}
+	}
+
+	/* hold the framework-wide lock, context == NULL */
 	spin_lock_irqsave(&enable_lock, flags);
+
+	/* set context for any reentrant calls */
+	atomic_set(&enable_context, (int) get_current());
+
+	/* enable the clock(s) */
 	ret = __clk_enable(clk);
-	spin_unlock_irqrestore(&enable_lock, flags);
 
+	/* clear the context */
+	atomic_set(&enable_context, 0);
+
+	/* release the framework-wide lock, context == NULL */
+	spin_unlock_irqrestore(&enable_lock, flags);
+out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_enable);
@@ -792,10 +853,17 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 {
 	unsigned long ret;
 
-	mutex_lock(&prepare_lock);
+	/* this call re-enters if it is from the same context */
+	if (clk_is_reentrant()) {
+		ret = __clk_round_rate(clk, rate);
+		goto out;
+	}
+
+	clk_fwk_lock();
 	ret = __clk_round_rate(clk, rate);
-	mutex_unlock(&prepare_lock);
+	clk_fwk_unlock();
 
+out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_round_rate);
@@ -877,6 +945,30 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
 		__clk_recalc_rates(child, msg);
 }
 
+unsigned long __clk_get_rate(struct clk *clk)
+{
+	unsigned long ret;
+
+	if (!clk) {
+		ret = 0;
+		goto out;
+	}
+
+	if (clk->flags & CLK_GET_RATE_NOCACHE)
+		__clk_recalc_rates(clk, 0);
+
+	ret = clk->rate;
+
+	if (clk->flags & CLK_IS_ROOT)
+		goto out;
+
+	if (!clk->parent)
+		ret = 0;
+
+out:
+	return ret;
+}
+
 /**
  * clk_get_rate - return the rate of clk
  * @clk: the clk whose rate is being returned
@@ -889,14 +981,22 @@ unsigned long clk_get_rate(struct clk *clk)
 {
 	unsigned long rate;
 
-	mutex_lock(&prepare_lock);
+	/*
+	 * FIXME - any locking here seems heavy weight
+	 * can clk->rate be replaced with an atomic_t?
+	 * same logic can likely be applied to prepare_count & enable_count
+	 */
 
-	if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
-		__clk_recalc_rates(clk, 0);
+	if (clk_is_reentrant()) {
+		rate = __clk_get_rate(clk);
+		goto out;
+	}
 
+	clk_fwk_lock();
 	rate = __clk_get_rate(clk);
-	mutex_unlock(&prepare_lock);
+	clk_fwk_unlock();
 
+out:
 	return rate;
 }
 EXPORT_SYMBOL_GPL(clk_get_rate);
@@ -1073,6 +1173,39 @@ static void clk_change_rate(struct clk *clk)
 		clk_change_rate(child);
 }
 
+int __clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	int ret = 0;
+	struct clk *top, *fail_clk;
+
+	/* bail early if nothing to do */
+	if (rate == clk->rate)
+		return 0;
+
+	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
+		return -EBUSY;
+	}
+
+	/* calculate new rates and get the topmost changed clock */
+	top = clk_calc_new_rates(clk, rate);
+	if (!top)
+		return -EINVAL;
+
+	/* notify that we are about to change rates */
+	fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
+	if (fail_clk) {
+		pr_warn("%s: failed to set %s rate\n", __func__,
+				fail_clk->name);
+		clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
+		return -EBUSY;
+	}
+
+	/* change the rates */
+	clk_change_rate(top);
+
+	return ret;
+}
+
 /**
  * clk_set_rate - specify a new rate for clk
  * @clk: the clk whose rate is being changed
@@ -1096,44 +1229,18 @@ static void clk_change_rate(struct clk *clk)
  */
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
-	struct clk *top, *fail_clk;
 	int ret = 0;
 
-	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
-
-	/* bail early if nothing to do */
-	if (rate == clk->rate)
-		goto out;
-
-	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	/* calculate new rates and get the topmost changed clock */
-	top = clk_calc_new_rates(clk, rate);
-	if (!top) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	/* notify that we are about to change rates */
-	fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
-	if (fail_clk) {
-		pr_warn("%s: failed to set %s rate\n", __func__,
-				fail_clk->name);
-		clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
-		ret = -EBUSY;
+	if (clk_is_reentrant()) {
+		ret = __clk_set_rate(clk, rate);
 		goto out;
 	}
 
-	/* change the rates */
-	clk_change_rate(top);
+	clk_fwk_lock();
+	ret = __clk_set_rate(clk, rate);
+	clk_fwk_unlock();
 
 out:
-	mutex_unlock(&prepare_lock);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clk_set_rate);
@@ -1148,10 +1255,16 @@ struct clk *clk_get_parent(struct clk *clk)
 {
 	struct clk *parent;
 
-	mutex_lock(&prepare_lock);
+	if (clk_is_reentrant()) {
+		parent = __clk_get_parent(clk);
+		goto out;
+	}
+
+	clk_fwk_lock();
 	parent = __clk_get_parent(clk);
-	mutex_unlock(&prepare_lock);
+	clk_fwk_unlock();
 
+out:
 	return parent;
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
@@ -1330,6 +1443,7 @@ out:
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	int ret = 0;
+	bool reenter;
 
 	if (!clk || !clk->ops)
 		return -EINVAL;
@@ -1337,8 +1451,10 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	if (!clk->ops->set_parent)
 		return -ENOSYS;
 
-	/* prevent racing with updates to the clock topology */
-	mutex_lock(&prepare_lock);
+	reenter = clk_is_reentrant();
+
+	if (!reenter)
+		clk_fwk_lock();
 
 	if (clk->parent == parent)
 		goto out;
@@ -1367,7 +1483,8 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
 	__clk_reparent(clk, parent);
 
 out:
-	mutex_unlock(&prepare_lock);
+	if (!reenter)
+		clk_fwk_unlock();
 
 	return ret;
 }
-- 
1.7.10.4

