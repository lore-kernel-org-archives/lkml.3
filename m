Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaDOJy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:54:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:30709 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160AbaDOJyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:54:24 -0400
X-IronPort-AV: E=Sophos;i="4.97,862,1389715200"; 
   d="scan'208,223";a="29284063"
Message-ID: <534D02B0.1000801@cn.fujitsu.com>
Date: Tue, 15 Apr 2014 17:58:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: allow changing attributions of ordered workqueue
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 534f1df8a5a03427b0fc382150fbd34e05648a28 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 15 Apr 2014 17:52:19 +0800
Subject: [PATCH] workqueue: allow changing attributions of ordered workqueue

Allow changing ordered workqueue's cpumask
Allow changing ordered workqueue's nice value
Allow registering ordered workqueue to SYSFS

Still disallow changing ordered workqueue's max_active which breaks ordered guarantee
Still disallow changing ordered workqueue's no_numa which breaks ordered guarantee

Changing attributions will introduce new pwqs in a given workqueue, and
old implement doesn't have any solution to handle multi-pwqs on ordered workqueues,
so changing attributions for ordered workqueues is disallowed.

After I investigated several solutions which try to handle multi-pwqs on ordered workqueues,
I found the solution which reuse max_active are the simplest.
In this solution, the new introduced pwq's max_active is kept as *ZERO* until it become
the oldest pwq. Thus only one (the oldest) pwq is active, and ordered is guarantee.

This solution forces ordered on higher level while the non-reentrancy is also
forced. so we don't need to queue any work to its previous pool. And we shouldn't
do it. we must disallow any work repeatedly requeues itself back-to-back
which keeps the oldest pwq stay and make newest(if have) pwq starvation(non-active for ever).

Build test only.
This patch depends on previous patch:
workqueue: add __WQ_FREEZING and remove POOL_FREEZING

Frederic:
	You can pick this patch to your updated patchset before
	TJ apply it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   66 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 92c9ada..fadcc4a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1350,8 +1350,14 @@ retry:
 	 * If @work was previously on a different pool, it might still be
 	 * running there, in which case the work needs to be queued on that
 	 * pool to guarantee non-reentrancy.
+	 *
+	 * pwqs are guaranteed active orderly for ordered workqueue, and
+	 * it guarantees non-reentrancy for works. So any work doesn't need
+	 * to be queued on previous pool. And the works shouldn't be queued
+	 * on previous pool, since we need to guarantee the prevous pwq
+	 * releasable to avoid work-stavation on the newest pool.
 	 */
-	last_pool = get_work_pool(work);
+	last_pool = wq->flags & __WQ_ORDERED ? NULL : get_work_pool(work);
 	if (last_pool && last_pool != pwq->pool) {
 		struct worker *worker;
 
@@ -3179,6 +3185,10 @@ static ssize_t wq_numa_store(struct device *dev, struct device_attribute *attr,
 	struct workqueue_attrs *attrs;
 	int v, ret;
 
+	/* Creating per-node pwqs breaks ordering guarantee. Keep no_numa = 1 */
+	if (WARN_ON(wq->flags & __WQ_ORDERED))
+		return -EINVAL;
+
 	attrs = wq_sysfs_prep_attrs(wq);
 	if (!attrs)
 		return -ENOMEM;
@@ -3239,14 +3249,6 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
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
@@ -3568,6 +3570,13 @@ static void rcu_free_pwq(struct rcu_head *rcu)
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
@@ -3583,14 +3592,12 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
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
+	/* try to active the oldest pwq when needed */
+	if (!is_last && (wq->flags & __WQ_ORDERED))
+		pwq_adjust_max_active(oldest_pwq(wq));
 	mutex_unlock(&wq->mutex);
 
 	mutex_lock(&wq_pool_mutex);
@@ -3609,6 +3616,16 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
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
@@ -3626,7 +3643,7 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 
 	spin_lock_irq(&pwq->pool->lock);
 
-	if (!(wq->flags & __WQ_FREEZING)) {
+	if (!(wq->flags & __WQ_FREEZING) && pwq_active(pwq)) {
 		pwq->max_active = wq->saved_max_active;
 
 		while (!list_empty(&pwq->delayed_works) &&
@@ -3680,11 +3697,11 @@ static void link_pwq(struct pool_workqueue *pwq)
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
@@ -3810,8 +3827,8 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	if (WARN_ON(!(wq->flags & WQ_UNBOUND)))
 		return -EINVAL;
 
-	/* creating multiple pwqs breaks ordering guarantee */
-	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
+	/* creating multiple per-node pwqs breaks ordering guarantee */
+	if (WARN_ON((wq->flags & __WQ_ORDERED) && !attrs->no_numa))
 		return -EINVAL;
 
 	pwq_tbl = kzalloc(wq_numa_tbl_len * sizeof(pwq_tbl[0]), GFP_KERNEL);
@@ -4004,7 +4021,7 @@ out_unlock:
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
-	int cpu, ret;
+	int cpu;
 
 	if (!(wq->flags & WQ_UNBOUND)) {
 		wq->cpu_pwqs = alloc_percpu(struct pool_workqueue);
@@ -4025,12 +4042,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
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
1.7.4.4

