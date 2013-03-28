Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3C1Gom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:42 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59660 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3C1Goj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:39 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] workqueue: map an unbound workqueues to multiple per-node pool_workqueues
Date: Wed, 27 Mar 2013 23:43:34 -0700
Message-Id: <1364453020-2829-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, an unbound workqueue has only one "current" pool_workqueue
associated with it.  It may have multple pool_workqueues but only the
first pool_workqueue servies new work items.  For NUMA affinity, we
want to change this so that there are multiple current pool_workqueues
serving different NUMA nodes.

Introduce workqueue->numa_pwq_tbl[] which is indexed by NUMA node and
points to the pool_workqueue to use for each possible node.  This
replaces first_pwq() in __queue_work() and workqueue_congested().

numa_pwq_tbl[] is currently initialized to point to the same
pool_workqueue as first_pwq() so this patch doesn't make any behavior
changes.

v2: Use rcu_dereference_raw() in unbound_pwq_by_node() as the function
    may be called only with wq->mutex held.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 48 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9297ea3..5b53705 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -257,6 +257,7 @@ struct workqueue_struct {
 	/* hot fields used during command issue, aligned to cacheline */
 	unsigned int		flags ____cacheline_aligned; /* WQ: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwqs */
+	struct pool_workqueue __rcu *numa_pwq_tbl[]; /* FR: unbound pwqs indexed by node */
 };
 
 static struct kmem_cache *pwq_cache;
@@ -525,6 +526,22 @@ static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
 				      pwqs_node);
 }
 
+/**
+ * unbound_pwq_by_node - return the unbound pool_workqueue for the given node
+ * @wq: the target workqueue
+ * @node: the node ID
+ *
+ * This must be called either with pwq_lock held or sched RCU read locked.
+ * If the pwq needs to be used beyond the locking in effect, the caller is
+ * responsible for guaranteeing that the pwq stays online.
+ */
+static struct pool_workqueue *unbound_pwq_by_node(struct workqueue_struct *wq,
+						  int node)
+{
+	assert_rcu_or_wq_mutex(wq);
+	return rcu_dereference_raw(wq->numa_pwq_tbl[node]);
+}
+
 static unsigned int work_color_to_flags(int color)
 {
 	return color << WORK_STRUCT_COLOR_SHIFT;
@@ -1278,14 +1295,14 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
 retry:
+	if (req_cpu == WORK_CPU_UNBOUND)
+		cpu = raw_smp_processor_id();
+
 	/* pwq which will be used unless @work is executing elsewhere */
-	if (!(wq->flags & WQ_UNBOUND)) {
-		if (cpu == WORK_CPU_UNBOUND)
-			cpu = raw_smp_processor_id();
+	if (!(wq->flags & WQ_UNBOUND))
 		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
-	} else {
-		pwq = first_pwq(wq);
-	}
+	else
+		pwq = unbound_pwq_by_node(wq, cpu_to_node(cpu));
 
 	/*
 	 * If @work was previously on a different pool, it might still be
@@ -1315,8 +1332,8 @@ retry:
 	 * pwq is determined and locked.  For unbound pools, we could have
 	 * raced with pwq release and it could already be dead.  If its
 	 * refcnt is zero, repeat pwq selection.  Note that pwqs never die
-	 * without another pwq replacing it as the first pwq or while a
-	 * work item is executing on it, so the retying is guaranteed to
+	 * without another pwq replacing it in the numa_pwq_tbl or while
+	 * work items are executing on it, so the retrying is guaranteed to
 	 * make forward-progress.
 	 */
 	if (unlikely(!pwq->refcnt)) {
@@ -3614,6 +3631,8 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 			      struct worker_pool *pool,
 			      struct pool_workqueue **p_last_pwq)
 {
+	int node;
+
 	BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
 
 	pwq->pool = pool;
@@ -3640,8 +3659,11 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	/* link in @pwq */
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 
-	if (wq->flags & WQ_UNBOUND)
+	if (wq->flags & WQ_UNBOUND) {
 		copy_workqueue_attrs(wq->unbound_attrs, pool->attrs);
+		for_each_node(node)
+			rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq);
+	}
 
 	mutex_unlock(&wq->mutex);
 }
@@ -3756,12 +3778,16 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 					       struct lock_class_key *key,
 					       const char *lock_name, ...)
 {
+	size_t tbl_size = 0;
 	va_list args;
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
 
 	/* allocate wq and format name */
-	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
+	if (flags & WQ_UNBOUND)
+		tbl_size = wq_numa_tbl_len * sizeof(wq->numa_pwq_tbl[0]);
+
+	wq = kzalloc(sizeof(*wq) + tbl_size, GFP_KERNEL);
 	if (!wq)
 		return NULL;
 
@@ -3989,7 +4015,7 @@ bool workqueue_congested(int cpu, struct workqueue_struct *wq)
 	if (!(wq->flags & WQ_UNBOUND))
 		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
 	else
-		pwq = first_pwq(wq);
+		pwq = unbound_pwq_by_node(wq, cpu_to_node(cpu));
 
 	ret = !list_empty(&pwq->delayed_works);
 	rcu_read_unlock_sched();
-- 
1.8.1.4

