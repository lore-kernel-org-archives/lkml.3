Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbaEPQSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:18:34 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33573 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaEPQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:17:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/5] workqueue: Allow changing attributions of ordered workqueues
Date: Fri, 16 May 2014 18:16:51 +0200
Message-Id: <1400257015-28222-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Changing the attributions of a workqueue imply the addition of new pwqs
to replace the old ones. But the current implementation doesn't handle
ordered workqueues because they can't carry multi-pwqs without breaking
ordering. Hence ordered workqueues currently aren't allowed to call
apply_workqueue_attrs().

This result in several special cases in the workqueue code to handle
ordered workqueues. And with the addition of global workqueue cpumask,
these special cases are going to spread out even further as the number
of callers of apply_workqueue_attrs() will be increasing.

So we want apply_workqueue_attrs() to be smarter and to be able to
handle all sort of unbound workqueues.

This solution propose to create new pwqs on ordered workqueues with
max_active initialized as zero. Then when the older pwq is finally
released, the new one becomes active and its max_active value is set to 1.
This way we make sure that a only a single pwq ever run at a given time
on an ordered workqueue.

This enforces ordering and non-reentrancy on higher level.
Note that ordered works then become exceptions and aren't subject to
previous pool requeue that usually guarantees reentrancy while works
requeue themselves back-to-back. Otherwise it could prevent a pool switch
from ever happening by delaying the release of the old pool forever and
never letting the new one in.

Now that we can change ordered workqueue attributes, lets allow them
to be registered as WQ_SYSFS and allow to change their nice and cpumask
values. Note that in order to preserve ordering guarantee, we still
disallow changing their max_active and no_numa values.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 69 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 27 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c3f076f..c68e84f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1355,8 +1355,16 @@ retry:
 	 * If @work was previously on a different pool, it might still be
 	 * running there, in which case the work needs to be queued on that
 	 * pool to guarantee non-reentrancy.
+	 *
+	 * We guarantee that only one pwq is active on an ordered workqueue.
+	 * That alone enforces non-reentrancy for works. So ordered works don't
+	 * need to be requeued to their previous pool. Not to mention that
+	 * an ordered work requeing itself over and over on the same pool may
+	 * prevent a pwq from being released in case of a pool switch. The
+	 * newest pool in that case couldn't switch in and its pending works
+	 * would starve.
 	 */
-	last_pool = get_work_pool(work);
+	last_pool = wq->flags & __WQ_ORDERED ? NULL : get_work_pool(work);
 	if (last_pool && last_pool != pwq->pool) {
 		struct worker *worker;
 
@@ -3319,6 +3327,10 @@ static ssize_t wq_numa_store(struct device *dev, struct device_attribute *attr,
 	struct workqueue_attrs *attrs;
 	int v, ret;
 
+	/* Creating per-node pwqs breaks ordering guarantee. Keep no_numa = 1 */
+	if (WARN_ON(wq->flags & __WQ_ORDERED))
+		return -EINVAL;
+
 	attrs = wq_sysfs_prep_attrs(wq);
 	if (!attrs)
 		return -ENOMEM;
@@ -3379,14 +3391,6 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 	struct wq_device *wq_dev;
 	int ret;
 
-	/*
-	 * Adjusting max_active or creating new pwqs by applyting
-	 * attributes breaks ordering guarantee.  Disallow exposing ordered
-	 * workqueues.
-	 */
-	if (WARN_ON(wq->flags & __WQ_ORDERED))
-		return -EINVAL;
-
 	wq->wq_dev = wq_dev = kzalloc(sizeof(*wq_dev), GFP_KERNEL);
 	if (!wq_dev)
 		return -ENOMEM;
@@ -3708,6 +3712,13 @@ static void rcu_free_pwq(struct rcu_head *rcu)
 			container_of(rcu, struct pool_workqueue, rcu));
 }
 
+static struct pool_workqueue *oldest_pwq(struct workqueue_struct *wq)
+{
+	return list_last_entry(&wq->pwqs, struct pool_workqueue, pwqs_node);
+}
+
+static void pwq_adjust_max_active(struct pool_workqueue *pwq);
+
 /*
  * Scheduled on system_wq by put_pwq() when an unbound pwq hits zero refcnt
  * and needs to be destroyed.
@@ -3723,14 +3734,12 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	if (WARN_ON_ONCE(!(wq->flags & WQ_UNBOUND)))
 		return;
 
-	/*
-	 * Unlink @pwq.  Synchronization against wq->mutex isn't strictly
-	 * necessary on release but do it anyway.  It's easier to verify
-	 * and consistent with the linking path.
-	 */
 	mutex_lock(&wq->mutex);
 	list_del_rcu(&pwq->pwqs_node);
 	is_last = list_empty(&wq->pwqs);
+	/* try to activate the oldest pwq when needed */
+	if (!is_last && (wq->flags & __WQ_ORDERED))
+		pwq_adjust_max_active(oldest_pwq(wq));
 	mutex_unlock(&wq->mutex);
 
 	mutex_lock(&wq_pool_mutex);
@@ -3749,6 +3758,16 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	}
 }
 
+static bool pwq_active(struct pool_workqueue *pwq)
+{
+	/* Only the oldest pwq is active in the ordered wq */
+	if (pwq->wq->flags & __WQ_ORDERED)
+		return pwq == oldest_pwq(pwq->wq);
+
+	/* All pwqs in the non-ordered wq are active */
+	return true;
+}
+
 /**
  * pwq_adjust_max_active - update a pwq's max_active to the current setting
  * @pwq: target pool_workqueue
@@ -3771,7 +3790,8 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!freezable || !(pwq->pool->flags & POOL_FREEZING)) {
+	if ((!freezable || !(pwq->pool->flags & POOL_FREEZING)) &&
+	     pwq_active(pwq)) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -3825,11 +3845,11 @@ static void link_pwq(struct pool_workqueue *pwq)
 	 */
 	pwq->work_color = wq->work_color;
 
+	/* link in @pwq on the head of &wq->pwqs */
+	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
+
 	/* sync max_active to the current setting */
 	pwq_adjust_max_active(pwq);
-
-	/* link in @pwq */
-	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 }
 
 /* obtain a pool matching @attr and create a pwq associating the pool and @wq */
@@ -3955,8 +3975,8 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	if (WARN_ON(!(wq->flags & WQ_UNBOUND)))
 		return -EINVAL;
 
-	/* creating multiple pwqs breaks ordering guarantee */
-	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
+	/* creating multiple per-node pwqs breaks ordering guarantee */
+	if (WARN_ON((wq->flags & __WQ_ORDERED) && !attrs->no_numa))
 		return -EINVAL;
 
 	pwq_tbl = kzalloc(wq_numa_tbl_len * sizeof(pwq_tbl[0]), GFP_KERNEL);
@@ -4146,7 +4166,7 @@ out_unlock:
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
-	int cpu, ret;
+	int cpu;
 
 	if (!(wq->flags & WQ_UNBOUND)) {
 		wq->cpu_pwqs = alloc_percpu(struct pool_workqueue);
@@ -4167,12 +4187,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 		}
 		return 0;
 	} else if (wq->flags & __WQ_ORDERED) {
-		ret = apply_workqueue_attrs(wq, ordered_wq_attrs[highpri]);
-		/* there should only be single pwq for ordering guarantee */
-		WARN(!ret && (wq->pwqs.next != &wq->dfl_pwq->pwqs_node ||
-			      wq->pwqs.prev != &wq->dfl_pwq->pwqs_node),
-		     "ordering guarantee broken for workqueue %s\n", wq->name);
-		return ret;
+		return apply_workqueue_attrs(wq, ordered_wq_attrs[highpri]);
 	} else {
 		return apply_workqueue_attrs(wq, unbound_std_wq_attrs[highpri]);
 	}
-- 
1.8.3.1

