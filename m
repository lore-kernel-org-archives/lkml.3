Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752Ab3CSTbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:31:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35922 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933672Ab3CST3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:29:00 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904510"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 15/21] workqueue: remove worker_maybe_bind_and_lock()
Date: Wed, 20 Mar 2013 03:28:15 +0800
Message-Id: <1363721306-2030-16-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:34,
	Serialize complete at 2013/03/20 03:27:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_maybe_bind_and_lock() is only used by rescuers.
but rescuer thread can fails when it do bind, so using
set_cpus_allowed_ptr() is enough.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   67 +--------------------------------------------------
 1 files changed, 2 insertions(+), 65 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index db08b63..12e3e3a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1545,70 +1545,6 @@ static void worker_leave_idle(struct worker *worker)
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
- * RETURNS:
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
@@ -2326,7 +2262,8 @@ repeat:
 		spin_unlock_irq(&wq_mayday_lock);
 
 		/* migrate to the target cpu if possible */
-		worker_maybe_bind_and_lock(pool);
+		set_cpus_allowed_ptr(current, pool->attrs->cpumask);
+		spin_lock_irq(&pool->lock);
 		rescuer->pool = pool;
 
 		/*
-- 
1.7.7.6

