Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaBGTgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:36:10 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:48538 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaBGTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:36:08 -0500
Date: Fri, 7 Feb 2014 14:36:04 -0500
From: Tejun Heo <tj@kernel.org>
To: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140207193604.GA8833@htj.dyndns.org>
References: <52F4F01C.1070800@linux.vnet.ibm.com>
 <20140207165113.GD3304@htj.dyndns.org>
 <52F51E10.8050208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F51E10.8050208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 07, 2014 at 12:55:28PM -0500, Jason J. Herne wrote:
> [  644.517710] XXX: worker->flags=0x1 pool->flags=0x0 cpu=6 pool->cpu=4
> [  731.367023] XXX: worker->flags=0x1 pool->flags=0x0 cpu=1 pool->cpu=7

Sorry, still no idea how this can happen.  Can you please try the
following?

Thanks!

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..1b11ec0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2151,9 +2151,27 @@ __acquires(&pool->lock)
 	 * necessary to avoid spurious warnings from rescuers servicing the
 	 * unbound or a disassociated pool.
 	 */
-	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
-		     !(pool->flags & POOL_DISASSOCIATED) &&
-		     raw_smp_processor_id() != pool->cpu);
+	if (WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
+			 !(pool->flags & POOL_DISASSOCIATED) &&
+			 raw_smp_processor_id() != pool->cpu)) {
+		static char buf[PAGE_SIZE];
+		unsigned long now = jiffies;
+
+		pr_warning("XXX: worker->flags=0x%x pool->flags=0x%x cpu=%d pool->cpu=%d rescue_wq=%p\n",
+			   worker->flags, pool->flags, raw_smp_processor_id(),
+			   pool->cpu, worker->rescue_wq);
+		pr_warning("XXX: last_unbind=%ld last_rebind=%ld last_rebound_clear=%ld nr_exected_after_rebound_clear=%d\n",
+			   worker->last_unbind ? worker->last_unbind - now : 999,
+			   worker->last_rebind ? worker->last_rebind - now : 999,
+			   worker->last_rebound_clear ? worker->last_rebound_clear - now : 999,
+			   worker->nr_executed_after_rebound_clear);
+
+		cpulist_scnprintf(buf, sizeof(buf), &current->cpus_allowed);
+		pr_warning("XXX: cpus_allowed=%s\n", buf);
+
+		cpulist_scnprintf(buf, sizeof(buf), &worker->cpus_allowed_after_rebinding);
+		pr_warning("XXX: cpus_allowed_after_rebinding=%s\n", buf);
+	}
 
 	/*
 	 * A single work shouldn't be executed concurrently by
@@ -2199,6 +2217,8 @@ __acquires(&pool->lock)
 	 */
 	set_work_pool_and_clear_pending(work, pool->id);
 
+	worker->nr_executed_after_rebound_clear++;
+
 	spin_unlock_irq(&pool->lock);
 
 	lock_map_acquire_read(&pwq->wq->lockdep_map);
@@ -2321,6 +2341,10 @@ recheck:
 	 * management if applicable and concurrency management is restored
 	 * after being rebound.  See rebind_workers() for details.
 	 */
+	if (worker->flags & WORKER_REBOUND) {
+		worker->last_rebound_clear = jiffies;
+		worker->nr_executed_after_rebound_clear = 0;
+	}
 	worker_clr_flags(worker, WORKER_PREP | WORKER_REBOUND);
 
 	do {
@@ -4576,8 +4600,10 @@ static void wq_unbind_fn(struct work_struct *work)
 		 * before the last CPU down must be on the cpu.  After
 		 * this, they may become diasporas.
 		 */
-		for_each_pool_worker(worker, wi, pool)
+		for_each_pool_worker(worker, wi, pool) {
 			worker->flags |= WORKER_UNBOUND;
+			worker->last_unbind = jiffies;
+		}
 
 		pool->flags |= POOL_DISASSOCIATED;
 
@@ -4633,9 +4659,13 @@ static void rebind_workers(struct worker_pool *pool)
 	 * of all workers first and then clear UNBOUND.  As we're called
 	 * from CPU_ONLINE, the following shouldn't fail.
 	 */
-	for_each_pool_worker(worker, wi, pool)
+	for_each_pool_worker(worker, wi, pool) {
 		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
 						  pool->attrs->cpumask) < 0);
+		worker->last_rebind = jiffies;
+		cpumask_copy(&worker->cpus_allowed_after_rebinding,
+			     &worker->task->cpus_allowed);
+	}
 
 	spin_lock_irq(&pool->lock);
 
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 7e2204d..95d68c4 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -50,6 +50,11 @@ struct worker {
 
 	/* used only by rescuers to point to the target workqueue */
 	struct workqueue_struct	*rescue_wq;	/* I: the workqueue to rescue */
+	unsigned long		last_unbind;
+	unsigned long		last_rebind;
+	unsigned long		last_rebound_clear;
+	int			nr_executed_after_rebound_clear;
+	cpumask_t		cpus_allowed_after_rebinding;
 };
 
 /**
