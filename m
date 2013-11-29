Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab3K2QK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:10:27 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:56300 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab3K2QKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:10:25 -0500
Date: Fri, 29 Nov 2013 11:10:21 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue fixes for v3.13-rc1
Message-ID: <20131129161021.GI3717@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains one important fix.  The NUMA supported
added a while back broke ordering guarantee on ordered workqueues.  It
was enforced by having single frontend interface with @max_active == 1
but the NUMA support puts multiple interfaces on unbound workqueues on
NUMA machines thus breaking the ordered guarantee.  This is fixed by
disabling NUMA support on ordered workqueues.

The above and a couple other patches were sitting in for-3.12-fixes
but I forgot to push that out, so they ended up waiting a bit too
long.  My aplogies.

Other fixes are minor.

The patches are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.13-fixes

for you to fetch changes up to 4e8b22bd1a37447712f1b1d96352fc53b463c6b3:

  workqueue: fix pool ID allocation leakage and remove BUILD_BUG_ON() in init_workqueues (2013-11-22 18:14:47 -0500)

Thanks.

----------------------------------------------------------------
Li Bin (2):
      workqueue: fix comment typo for __queue_work()
      workqueue: fix pool ID allocation leakage and remove BUILD_BUG_ON() in init_workqueues

Oleg Nesterov (1):
      workqueue: swap set_cpus_allowed_ptr() and PF_NO_SETAFFINITY

Tejun Heo (1):
      workqueue: fix ordered workqueues in NUMA setups

 kernel/workqueue.c | 50 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..c66912be 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -305,6 +305,9 @@ static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 /* I: attributes used when instantiating standard unbound pools on demand */
 static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
 
+/* I: attributes used when instantiating ordered pools on demand */
+static struct workqueue_attrs *ordered_wq_attrs[NR_STD_WORKER_POOLS];
+
 struct workqueue_struct *system_wq __read_mostly;
 EXPORT_SYMBOL(system_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
@@ -518,14 +521,21 @@ static inline void debug_work_activate(struct work_struct *work) { }
 static inline void debug_work_deactivate(struct work_struct *work) { }
 #endif
 
-/* allocate ID and assign it to @pool */
+/**
+ * worker_pool_assign_id - allocate ID and assing it to @pool
+ * @pool: the pool pointer of interest
+ *
+ * Returns 0 if ID in [0, WORK_OFFQ_POOL_NONE) is allocated and assigned
+ * successfully, -errno on failure.
+ */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
 	int ret;
 
 	lockdep_assert_held(&wq_pool_mutex);
 
-	ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
+	ret = idr_alloc(&worker_pool_idr, pool, 0, WORK_OFFQ_POOL_NONE,
+			GFP_KERNEL);
 	if (ret >= 0) {
 		pool->id = ret;
 		return 0;
@@ -1320,7 +1330,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 
 	debug_work_activate(work);
 
-	/* if dying, only works from the same workqueue are allowed */
+	/* if draining, only works from the same workqueue are allowed */
 	if (unlikely(wq->flags & __WQ_DRAINING) &&
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
@@ -1736,16 +1746,17 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	set_user_nice(worker->task, pool->attrs->nice);
+
+	/* prevent userland from meddling with cpumask of workqueue workers */
+	worker->task->flags |= PF_NO_SETAFFINITY;
+
 	/*
 	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
 	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
 	 */
-	set_user_nice(worker->task, pool->attrs->nice);
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
-	/* prevent userland from meddling with cpumask of workqueue workers */
-	worker->task->flags |= PF_NO_SETAFFINITY;
-
 	/*
 	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
 	 * remains stable across this function.  See the comments above the
@@ -4106,7 +4117,7 @@ out_unlock:
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
-	int cpu;
+	int cpu, ret;
 
 	if (!(wq->flags & WQ_UNBOUND)) {
 		wq->cpu_pwqs = alloc_percpu(struct pool_workqueue);
@@ -4126,6 +4137,13 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			mutex_unlock(&wq->mutex);
 		}
 		return 0;
+	} else if (wq->flags & __WQ_ORDERED) {
+		ret = apply_workqueue_attrs(wq, ordered_wq_attrs[highpri]);
+		/* there should only be single pwq for ordering guarantee */
+		WARN(!ret && (wq->pwqs.next != &wq->dfl_pwq->pwqs_node ||
+			      wq->pwqs.prev != &wq->dfl_pwq->pwqs_node),
+		     "ordering guarantee broken for workqueue %s\n", wq->name);
+		return ret;
 	} else {
 		return apply_workqueue_attrs(wq, unbound_std_wq_attrs[highpri]);
 	}
@@ -5009,10 +5027,6 @@ static int __init init_workqueues(void)
 	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
 	int i, cpu;
 
-	/* make sure we have enough bits for OFFQ pool ID */
-	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
-		     WORK_CPU_END * NR_STD_WORKER_POOLS);
-
 	WARN_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
 
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
@@ -5051,13 +5065,23 @@ static int __init init_workqueues(void)
 		}
 	}
 
-	/* create default unbound wq attrs */
+	/* create default unbound and ordered wq attrs */
 	for (i = 0; i < NR_STD_WORKER_POOLS; i++) {
 		struct workqueue_attrs *attrs;
 
 		BUG_ON(!(attrs = alloc_workqueue_attrs(GFP_KERNEL)));
 		attrs->nice = std_nice[i];
 		unbound_std_wq_attrs[i] = attrs;
+
+		/*
+		 * An ordered wq should have only one pwq as ordering is
+		 * guaranteed by max_active which is enforced by pwqs.
+		 * Turn off NUMA so that dfl_pwq is used for all nodes.
+		 */
+		BUG_ON(!(attrs = alloc_workqueue_attrs(GFP_KERNEL)));
+		attrs->nice = std_nice[i];
+		attrs->no_numa = true;
+		ordered_wq_attrs[i] = attrs;
 	}
 
 	system_wq = alloc_workqueue("events", 0, 0);
