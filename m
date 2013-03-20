Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab3CTAB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:01:58 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:61217 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097Ab3CTABH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:01:07 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] workqueue: implement NUMA affinity for unbound workqueues
Date: Tue, 19 Mar 2013 17:00:28 -0700
Message-Id: <1363737629-16745-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, an unbound workqueue has single current, or first, pwq
(pool_workqueue) to which all new work items are queued.  This often
isn't optimal on NUMA machines as workers may jump around across node
boundaries and work items get assigned to workers without any regard
to NUMA affinity.

This patch implements NUMA affinity for unbound workqueues.  Instead
of mapping all entries of numa_pwq_tbl[] to the same pwq,
apply_workqueue_attrs() now creates a separate pwq covering the
intersecting CPUs for each NUMA node which has possible CPUs in
@attrs->cpumask.  Nodes which don't have intersecting possible CPUs
are mapped to pwqs covering whole @attrs->cpumask.

This ensures that all work items issued on a NUMA node is executed on
the same node as long as the workqueue allows execution on the CPUs of
the node.

As this maps a workqueue to multiple pwqs and max_active is per-pwq,
this change the behavior of max_active.  The limit is now per NUMA
node instead of global.  While this is an actual change, max_active is
already per-cpu for per-cpu workqueues and primarily used as safety
mechanism rather than for active concurrency control.  Concurrency is
usually limited from workqueue users by the number of concurrently
active work items and this change shouldn't matter much.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 108 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 86 insertions(+), 22 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index bbbfc92..0c36327 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3658,13 +3658,13 @@ static void init_pwq(struct pool_workqueue *pwq, struct workqueue_struct *wq,
 	pwq->flush_color = -1;
 	pwq->refcnt = 1;
 	INIT_LIST_HEAD(&pwq->delayed_works);
+	INIT_LIST_HEAD(&pwq->pwqs_node);
 	INIT_LIST_HEAD(&pwq->mayday_node);
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 }
 
 /* sync @pwq with the current state of its associated wq and link it */
-static void link_pwq(struct pool_workqueue *pwq,
-		     struct pool_workqueue **p_last_pwq)
+static void link_pwq(struct pool_workqueue *pwq)
 {
 	struct workqueue_struct *wq = pwq->wq;
 
@@ -3675,8 +3675,6 @@ static void link_pwq(struct pool_workqueue *pwq,
 	 * Set the matching work_color.  This is synchronized with
 	 * flush_mutex to avoid confusing flush_workqueue().
 	 */
-	if (p_last_pwq)
-		*p_last_pwq = first_pwq(wq);
 	pwq->work_color = wq->work_color;
 
 	/* sync max_active to the current setting */
@@ -3712,11 +3710,12 @@ static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
  * @wq: the target workqueue
  * @attrs: the workqueue_attrs to apply, allocated with alloc_workqueue_attrs()
  *
- * Apply @attrs to an unbound workqueue @wq.  If @attrs doesn't match the
- * current attributes, a new pwq is created and made the first pwq which
- * will serve all new work items.  Older pwqs are released as in-flight
- * work items finish.  Note that a work item which repeatedly requeues
- * itself back-to-back will stay on its current pwq.
+ * Apply @attrs to an unbound workqueue @wq.  Unless disabled, on NUMA
+ * machines, this function maps a separate pwq to each NUMA node with
+ * possibles CPUs in @attrs->cpumask so that work items are affine to the
+ * NUMA node it was issued on.  Older pwqs are released as in-flight work
+ * items finish.  Note that a work item which repeatedly requeues itself
+ * back-to-back will stay on its current pwq.
  *
  * Performs GFP_KERNEL allocations.  Returns 0 on success and -errno on
  * failure.
@@ -3724,7 +3723,8 @@ static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
 int apply_workqueue_attrs(struct workqueue_struct *wq,
 			  const struct workqueue_attrs *attrs)
 {
-	struct pool_workqueue *pwq, *last_pwq;
+	struct pool_workqueue **pwq_tbl = NULL, *dfl_pwq = NULL;
+	struct workqueue_attrs *tmp_attrs = NULL;
 	int node;
 
 	/* only unbound workqueues can change attributes */
@@ -3735,29 +3735,93 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
 		return -EINVAL;
 
-	pwq = alloc_unbound_pwq(wq, attrs);
-	if (!pwq)
-		return -ENOMEM;
+	pwq_tbl = kzalloc(wq_numa_tbl_len * sizeof(pwq_tbl[0]), GFP_KERNEL);
+	tmp_attrs = alloc_workqueue_attrs(GFP_KERNEL);
+	if (!pwq_tbl || !tmp_attrs)
+		goto enomem;
+
+	copy_workqueue_attrs(tmp_attrs, attrs);
+
+	/*
+	 * We want NUMA affinity.  For each node with intersecting possible
+	 * CPUs with the requested cpumask, create a separate pwq covering
+	 * the instersection.  Nodes without intersection are covered by
+	 * the default pwq covering the whole requested cpumask.
+	 */
+	for_each_node(node) {
+		cpumask_t *cpumask = tmp_attrs->cpumask;
+
+		/*
+		 * Just fall through if NUMA affinity isn't enabled.  We'll
+		 * end up using the default pwq which is what we want.
+		 */
+		if (wq_numa_possible_cpumask) {
+			cpumask_and(cpumask, wq_numa_possible_cpumask[node],
+				    attrs->cpumask);
+			if (cpumask_empty(cpumask))
+				cpumask_copy(cpumask, attrs->cpumask);
+		}
+
+		if (cpumask_equal(cpumask, attrs->cpumask)) {
+			if (!dfl_pwq) {
+				dfl_pwq = alloc_unbound_pwq(wq, tmp_attrs);
+				if (!dfl_pwq)
+					goto enomem;
+			} else {
+				dfl_pwq->refcnt++;
+			}
+			pwq_tbl[node] = dfl_pwq;
+		} else {
+			pwq_tbl[node] = alloc_unbound_pwq(wq, tmp_attrs);
+			if (!pwq_tbl[node])
+				goto enomem;
+		}
+	}
 
+	/* all pwqs have been created successfully, let's install'em */
 	mutex_lock(&wq->flush_mutex);
 	spin_lock_irq(&pwq_lock);
 
-	link_pwq(pwq, &last_pwq);
+	/* @attrs is now current */
+	copy_workqueue_attrs(wq->unbound_attrs, attrs);
 
-	copy_workqueue_attrs(wq->unbound_attrs, pwq->pool->attrs);
-	for_each_node(node)
-		rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq);
+	for_each_node(node) {
+		struct pool_workqueue *pwq;
+
+		/* each new pwq should be linked once */
+		if (list_empty(&pwq_tbl[node]->pwqs_node))
+			link_pwq(pwq_tbl[node]);
+
+		/* save the previous pwq and install the new one */
+		pwq = rcu_access_pointer(wq->numa_pwq_tbl[node]);
+		rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq_tbl[node]);
+		pwq_tbl[node] = pwq;
+	}
 
 	spin_unlock_irq(&pwq_lock);
 	mutex_unlock(&wq->flush_mutex);
 
-	if (last_pwq) {
-		spin_lock_irq(&last_pwq->pool->lock);
-		put_pwq(last_pwq);
-		spin_unlock_irq(&last_pwq->pool->lock);
+	/* put the old pwqs */
+	for_each_node(node) {
+		struct pool_workqueue *pwq = pwq_tbl[node];
+
+		if (pwq) {
+			spin_lock_irq(&pwq->pool->lock);
+			put_pwq(pwq);
+			spin_unlock_irq(&pwq->pool->lock);
+		}
 	}
 
 	return 0;
+
+enomem:
+	free_workqueue_attrs(tmp_attrs);
+	if (pwq_tbl) {
+		for_each_node(node)
+			kfree(pwq_tbl[node]);
+		kfree(pwq_tbl);
+	}
+	return -ENOMEM;
 }
 
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
@@ -3781,7 +3845,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			mutex_lock(&wq->flush_mutex);
 			spin_lock_irq(&pwq_lock);
 
-			link_pwq(pwq, NULL);
+			link_pwq(pwq);
 
 			spin_unlock_irq(&pwq_lock);
 			mutex_unlock(&wq->flush_mutex);
-- 
1.8.1.4

