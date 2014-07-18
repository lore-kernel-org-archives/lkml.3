Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbaGRUIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:08:38 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:55834 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761857AbaGRUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:08:37 -0400
Date: Fri, 18 Jul 2014 16:08:34 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH percpu/for-3.17 2/2] blk-throttle: replace custom async
 percpu alloc mechanism with percpu_pool
Message-ID: <20140718200834.GH13012@htj.dyndns.org>
References: <20140718200804.GG13012@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718200804.GG13012@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0a4bd997ba9725565883c688d7dcee8264abf71c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jul 2014 16:07:14 -0400

throtl_pd_init() is called under the queue lock but needs to allocate
the percpu stats area.  This is currently handled by queueing it on a
list and scheduling a work item to allocate and fill the percpu stats
area.  Now that perpcu_pool is available, this custom mechanism can be
replaced.

Add tg_stats_cpu_pool and implement tg_ensure_stats_cpu() which tries
to make sure that tg->stats_cpu is populated to replace the custom
async alloc mechanism.  As percpu_pool allocation can fail,
tg_ensure_stats_cpu() is invoked whenever ->stats_cpu is about to be
accessed.  This is similar to the way code was structured before as
the custom async alloc could take arbitrary amount of time and each
access should verify that ->stats_cpu is populated.

This simplifies the code.  There shouldn't be noticeable functional
difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-throttle.c | 116 +++++++++++++++++++--------------------------------
 1 file changed, 42 insertions(+), 74 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3fdb21a..9954fe8 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -144,9 +144,6 @@ struct throtl_grp {
 
 	/* Per cpu stats pointer */
 	struct tg_stats_cpu __percpu *stats_cpu;
-
-	/* List of tgs waiting for per cpu stats memory to be allocated */
-	struct list_head stats_alloc_node;
 };
 
 struct throtl_data
@@ -168,12 +165,12 @@ struct throtl_data
 	struct work_struct dispatch_work;
 };
 
-/* list and work item to allocate percpu group stats */
-static DEFINE_SPINLOCK(tg_stats_alloc_lock);
-static LIST_HEAD(tg_stats_alloc_list);
-
-static void tg_stats_alloc_fn(struct work_struct *);
-static DECLARE_DELAYED_WORK(tg_stats_alloc_work, tg_stats_alloc_fn);
+/*
+ * percpu_pool to allow allocating tg->stats_cpu under queue_lock.  The low
+ * and high numbers are somewhat arbitrary.  They should be okay, but if
+ * somebody can come up with better numbers and rationales, don't be shy.
+ */
+static DEFINE_PERCPU_POOL(tg_stats_cpu_pool, struct tg_stats_cpu, 16, 32);
 
 static void throtl_pending_timer_fn(unsigned long arg);
 
@@ -256,53 +253,6 @@ static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
 	}								\
 } while (0)
 
-static void tg_stats_init(struct tg_stats_cpu *tg_stats)
-{
-	blkg_rwstat_init(&tg_stats->service_bytes);
-	blkg_rwstat_init(&tg_stats->serviced);
-}
-
-/*
- * Worker for allocating per cpu stat for tgs. This is scheduled on the
- * system_wq once there are some groups on the alloc_list waiting for
- * allocation.
- */
-static void tg_stats_alloc_fn(struct work_struct *work)
-{
-	static struct tg_stats_cpu *stats_cpu;	/* this fn is non-reentrant */
-	struct delayed_work *dwork = to_delayed_work(work);
-	bool empty = false;
-
-alloc_stats:
-	if (!stats_cpu) {
-		int cpu;
-
-		stats_cpu = alloc_percpu(struct tg_stats_cpu);
-		if (!stats_cpu) {
-			/* allocation failed, try again after some time */
-			schedule_delayed_work(dwork, msecs_to_jiffies(10));
-			return;
-		}
-		for_each_possible_cpu(cpu)
-			tg_stats_init(per_cpu_ptr(stats_cpu, cpu));
-	}
-
-	spin_lock_irq(&tg_stats_alloc_lock);
-
-	if (!list_empty(&tg_stats_alloc_list)) {
-		struct throtl_grp *tg = list_first_entry(&tg_stats_alloc_list,
-							 struct throtl_grp,
-							 stats_alloc_node);
-		swap(tg->stats_cpu, stats_cpu);
-		list_del_init(&tg->stats_alloc_node);
-	}
-
-	empty = list_empty(&tg_stats_alloc_list);
-	spin_unlock_irq(&tg_stats_alloc_lock);
-	if (!empty)
-		goto alloc_stats;
-}
-
 static void throtl_qnode_init(struct throtl_qnode *qn, struct throtl_grp *tg)
 {
 	INIT_LIST_HEAD(&qn->node);
@@ -386,6 +336,37 @@ static struct bio *throtl_pop_queued(struct list_head *queued,
 	return bio;
 }
 
+static bool tg_ensure_stats_cpu(struct throtl_grp *tg)
+{
+	struct tg_stats_cpu __percpu *stats_cpu;
+	int cpu;
+
+	if (likely(tg->stats_cpu))
+		return true;
+
+	stats_cpu = percpu_pool_alloc(&tg_stats_cpu_pool);
+	if (!stats_cpu)
+		return false;
+
+	for_each_possible_cpu(cpu) {
+		struct tg_stats_cpu *tg_stats = per_cpu_ptr(stats_cpu, cpu);
+
+		blkg_rwstat_init(&tg_stats->service_bytes);
+		blkg_rwstat_init(&tg_stats->serviced);
+	}
+
+	/*
+	 * Try to install @stats_cpu.  There may be multiple competing
+	 * instances of this function.  Use cmpxchg() so that only the
+	 * first one gets installed.
+	 */
+	if (cmpxchg(&tg->stats_cpu, (struct tg_stats_cpu __percpu *)NULL,
+		    stats_cpu))
+		free_percpu(stats_cpu);
+
+	return true;
+}
+
 /* init a service_queue, assumes the caller zeroed it */
 static void throtl_service_queue_init(struct throtl_service_queue *sq,
 				      struct throtl_service_queue *parent_sq)
@@ -408,7 +389,6 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct throtl_data *td = blkg->q->td;
 	struct throtl_service_queue *parent_sq;
-	unsigned long flags;
 	int rw;
 
 	/*
@@ -444,15 +424,7 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 	tg->iops[READ] = -1;
 	tg->iops[WRITE] = -1;
 
-	/*
-	 * Ugh... We need to perform per-cpu allocation for tg->stats_cpu
-	 * but percpu allocator can't be called from IO path.  Queue tg on
-	 * tg_stats_alloc_list and allocate from work item.
-	 */
-	spin_lock_irqsave(&tg_stats_alloc_lock, flags);
-	list_add(&tg->stats_alloc_node, &tg_stats_alloc_list);
-	schedule_delayed_work(&tg_stats_alloc_work, 0);
-	spin_unlock_irqrestore(&tg_stats_alloc_lock, flags);
+	tg_ensure_stats_cpu(tg);
 }
 
 /*
@@ -482,11 +454,6 @@ static void throtl_pd_online(struct blkcg_gq *blkg)
 static void throtl_pd_exit(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
-	unsigned long flags;
-
-	spin_lock_irqsave(&tg_stats_alloc_lock, flags);
-	list_del_init(&tg->stats_alloc_node);
-	spin_unlock_irqrestore(&tg_stats_alloc_lock, flags);
 
 	free_percpu(tg->stats_cpu);
 
@@ -498,7 +465,7 @@ static void throtl_pd_reset_stats(struct blkcg_gq *blkg)
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	int cpu;
 
-	if (tg->stats_cpu == NULL)
+	if (!tg_ensure_stats_cpu(tg))
 		return;
 
 	for_each_possible_cpu(cpu) {
@@ -963,8 +930,7 @@ static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
 	struct tg_stats_cpu *stats_cpu;
 	unsigned long flags;
 
-	/* If per cpu stats are not allocated yet, don't do any accounting. */
-	if (tg->stats_cpu == NULL)
+	if (!tg_ensure_stats_cpu(tg))
 		return;
 
 	/*
@@ -1690,6 +1656,8 @@ static int __init throtl_init(void)
 	if (!kthrotld_workqueue)
 		panic("Failed to create kthrotld\n");
 
+	percpu_pool_fill(&tg_stats_cpu_pool, 0);
+
 	return blkcg_policy_register(&blkcg_policy_throtl);
 }
 
-- 
1.9.3

