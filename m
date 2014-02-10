Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaBJXRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:17:50 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:36385 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaBJXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:17:48 -0500
Date: Mon, 10 Feb 2014 18:17:42 -0500
From: Tejun Heo <tj@kernel.org>
To: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: Subject: Warning in workqueue.c
Message-ID: <20140210231742.GK25350@mtj.dyndns.org>
References: <52F4F01C.1070800@linux.vnet.ibm.com>
 <20140207165113.GD3304@htj.dyndns.org>
 <52F51E10.8050208@linux.vnet.ibm.com>
 <20140207193604.GA8833@htj.dyndns.org>
 <52F8F0FB.3080206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F8F0FB.3080206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 10, 2014 at 10:32:11AM -0500, Jason J. Herne wrote:
> [  950.778485] XXX: worker->flags=0x1 pool->flags=0x0 cpu=6
> pool->cpu=2 rescue_wq=          (null)
> [  950.778488] XXX: last_unbind=-7 last_rebind=0
> last_rebound_clear=0 nr_exected_after_rebound_clear=0
> [  950.778492] XXX: cpus_allowed=2
> [  950.778495] XXX: cpus_allowed_after_rebinding=2

So, everything looks kosher from workqueue side.  Weird.  cpus_allowed
is properly set and everything.  The worker just isn't running on the
cpu it's supposed to be on.  Can you please try the following?

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..f71ee11 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2151,9 +2151,31 @@ __acquires(&pool->lock)
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
+		pr_warning("XXX: worker->flags=0x%x pool->flags=0x%x cpu=%d pool->cpu=%d(%d) rescue_wq=%p\n",
+			   worker->flags, pool->flags, raw_smp_processor_id(),
+			   pool->cpu, cpu_online(pool->cpu), worker->rescue_wq);
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
+
+		schedule();
+
+		pr_warning("XXX: after schedule(), cpu=%d\n", raw_smp_processor_id());
+	}
 
 	/*
 	 * A single work shouldn't be executed concurrently by
@@ -2199,6 +2221,8 @@ __acquires(&pool->lock)
 	 */
 	set_work_pool_and_clear_pending(work, pool->id);
 
+	worker->nr_executed_after_rebound_clear++;
+
 	spin_unlock_irq(&pool->lock);
 
 	lock_map_acquire_read(&pwq->wq->lockdep_map);
@@ -2321,6 +2345,10 @@ recheck:
 	 * management if applicable and concurrency management is restored
 	 * after being rebound.  See rebind_workers() for details.
 	 */
+	if (worker->flags & WORKER_REBOUND) {
+		worker->last_rebound_clear = jiffies;
+		worker->nr_executed_after_rebound_clear = 0;
+	}
 	worker_clr_flags(worker, WORKER_PREP | WORKER_REBOUND);
 
 	do {
@@ -4576,8 +4604,10 @@ static void wq_unbind_fn(struct work_struct *work)
 		 * before the last CPU down must be on the cpu.  After
 		 * this, they may become diasporas.
 		 */
-		for_each_pool_worker(worker, wi, pool)
+		for_each_pool_worker(worker, wi, pool) {
 			worker->flags |= WORKER_UNBOUND;
+			worker->last_unbind = jiffies;
+		}
 
 		pool->flags |= POOL_DISASSOCIATED;
 
@@ -4633,9 +4663,13 @@ static void rebind_workers(struct worker_pool *pool)
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

