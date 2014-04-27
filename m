Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaD0EG1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:06:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:51862 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753061AbaD0EGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:06:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778327"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 10/10] workqueue: use generic pool-bind/unbind routine for rescuers
Date: Sun, 27 Apr 2014 12:09:05 +0800
Message-ID: <1398571754-12443-11-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several problems with the code that rescuers bind itself to the pool'
cpumask
  1) It uses a way different from the normal workers to bind to the cpumask
     So we can't maintain the normal/rescuer workers under the same framework.
  2) The the code of cpu-binding for rescuer is complicated
  3) If one or more cpuhotplugs happen while the rescuer processes the
     scheduled works, the rescuer may not be correctly bound to the cpumask of
     the pool. This is allowed behavior, but is not good. It will be better
     if the cpumask of the rescuer is always kept coordination with the pool
     across any cpuhotplugs.

Using generic pool-bind/unbind routine will solve the above problems,
and result much more simple code.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   74 +++++----------------------------------------------
 1 files changed, 8 insertions(+), 66 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0c575b1..4f90a58 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1588,70 +1588,6 @@ static void worker_leave_idle(struct worker *worker)
 	list_del_init(&worker->entry);
 }
 
-/**
- * worker_maybe_bind_and_lock - try to bind %current to worker_pool and lock it
- * @pool: target worker_pool
- *
- * Bind %current to the cpu of @pool if it is associated and lock @pool.
- *
- * Works which are scheduled while the cpu is online must at least be
- * scheduled to a worker which is bound to the cpu so that if they are
- * flushed from cpu callbacks while cpu is going down, they are
- * guaranteed to execute on the cpu.
- *
- * This function is to be used by unbound workers and rescuers to bind
- * themselves to the target cpu and may race with cpu going down or
- * coming online.  kthread_bind() can't be used because it may put the
- * worker to already dead cpu and set_cpus_allowed_ptr() can't be used
- * verbatim as it's best effort and blocking and pool may be
- * [dis]associated in the meantime.
- *
- * This function tries set_cpus_allowed() and locks pool and verifies the
- * binding against %POOL_DISASSOCIATED which is set during
- * %CPU_DOWN_PREPARE and cleared during %CPU_ONLINE, so if the worker
- * enters idle state or fetches works without dropping lock, it can
- * guarantee the scheduling requirement described in the first paragraph.
- *
- * CONTEXT:
- * Might sleep.  Called without any lock but returns with pool->lock
- * held.
- *
- * Return:
- * %true if the associated pool is online (@worker is successfully
- * bound), %false if offline.
- */
-static bool worker_maybe_bind_and_lock(struct worker_pool *pool)
-__acquires(&pool->lock)
-{
-	while (true) {
-		/*
-		 * The following call may fail, succeed or succeed
-		 * without actually migrating the task to the cpu if
-		 * it races with cpu hotunplug operation.  Verify
-		 * against POOL_DISASSOCIATED.
-		 */
-		if (!(pool->flags & POOL_DISASSOCIATED))
-			set_cpus_allowed_ptr(current, pool->attrs->cpumask);
-
-		spin_lock_irq(&pool->lock);
-		if (pool->flags & POOL_DISASSOCIATED)
-			return false;
-		if (task_cpu(current) == pool->cpu &&
-		    cpumask_equal(&current->cpus_allowed, pool->attrs->cpumask))
-			return true;
-		spin_unlock_irq(&pool->lock);
-
-		/*
-		 * We've raced with CPU hot[un]plug.  Give it a breather
-		 * and retry migration.  cond_resched() is required here;
-		 * otherwise, we might deadlock against cpu_stop trying to
-		 * bring down the CPU on non-preemptive kernel.
-		 */
-		cpu_relax();
-		cond_resched();
-	}
-}
-
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -2336,8 +2272,9 @@ repeat:
 
 		spin_unlock_irq(&wq_mayday_lock);
 
-		/* migrate to the target cpu if possible */
-		worker_maybe_bind_and_lock(pool);
+		worker_bind_pool(rescuer, pool);
+
+		spin_lock_irq(&pool->lock);
 		rescuer->pool = pool;
 
 		/*
@@ -2350,6 +2287,11 @@ repeat:
 				move_linked_works(work, scheduled, &n);
 
 		process_scheduled_works(rescuer);
+		spin_unlock_irq(&pool->lock);
+
+		worker_unbind_pool(rescuer);
+
+		spin_lock_irq(&pool->lock);
 
 		/*
 		 * Put the reference grabbed by send_mayday().  @pool won't
-- 
1.7.4.4

