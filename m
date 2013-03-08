Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724Ab3CHXPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:15:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38544 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab3CHXPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:15:22 -0500
Date: Fri, 8 Mar 2013 15:15:17 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9-fixes] workqueue: fix possible pool stall bug in
 wq_unbind_fn()
Message-ID: <20130308231517.GS14556@mtj.dyndns.org>
References: <1362239729-6753-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362239729-6753-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Since multiple pools per cpu have been introduced, wq_unbind_fn() has
a subtle bug which may theoretically stall work item processing.  The
problem is two-fold.

* wq_unbind_fn() depends on the worker executing wq_unbind_fn() itself
  to start unbound chain execution, which works fine when there was
  only single pool.  With multiple pools, only the pool which is
  running wq_unbind_fn() - the highpri one - is guaranteed to have
  such kick-off.  The other pool could stall when its busy workers
  block.

* The current code is setting WORKER_UNBIND / POOL_DISASSOCIATED of
  the two pools in succession without initiating work execution
  inbetween.  Because setting the flags requires grabbing assoc_mutex
  which is held while new workers are created, this could lead to
  stalls if a pool's manager is waiting for the previous pool's work
  items to release memory.  This is almost purely theoretical tho.

Update wq_unbind_fn() such that it sets WORKER_UNBIND /
POOL_DISASSOCIATED, goes over schedule() and explicitly kicks off
execution for a pool and then moves on to the next one.

tj: Updated comments and description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
As you seemingly has disappeared, I just fixed up this patch and
applied it to wq/for-3.9-fixes.

Thanks.

 kernel/workqueue.c |   44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3446,28 +3446,34 @@ static void wq_unbind_fn(struct work_str
 
 		spin_unlock_irq(&pool->lock);
 		mutex_unlock(&pool->assoc_mutex);
-	}
 
-	/*
-	 * Call schedule() so that we cross rq->lock and thus can guarantee
-	 * sched callbacks see the %WORKER_UNBOUND flag.  This is necessary
-	 * as scheduler callbacks may be invoked from other cpus.
-	 */
-	schedule();
+		/*
+		 * Call schedule() so that we cross rq->lock and thus can
+		 * guarantee sched callbacks see the %WORKER_UNBOUND flag.
+		 * This is necessary as scheduler callbacks may be invoked
+		 * from other cpus.
+		 */
+		schedule();
 
-	/*
-	 * Sched callbacks are disabled now.  Zap nr_running.  After this,
-	 * nr_running stays zero and need_more_worker() and keep_working()
-	 * are always true as long as the worklist is not empty.  Pools on
-	 * @cpu now behave as unbound (in terms of concurrency management)
-	 * pools which are served by workers tied to the CPU.
-	 *
-	 * On return from this function, the current worker would trigger
-	 * unbound chain execution of pending work items if other workers
-	 * didn't already.
-	 */
-	for_each_std_worker_pool(pool, cpu)
+		/*
+		 * Sched callbacks are disabled now.  Zap nr_running.
+		 * After this, nr_running stays zero and need_more_worker()
+		 * and keep_working() are always true as long as the
+		 * worklist is not empty.  This pool now behaves as an
+		 * unbound (in terms of concurrency management) pool which
+		 * are served by workers tied to the pool.
+		 */
 		atomic_set(&pool->nr_running, 0);
+
+		/*
+		 * With concurrency management just turned off, a busy
+		 * worker blocking could lead to lengthy stalls.  Kick off
+		 * unbound chain execution of currently pending work items.
+		 */
+		spin_lock_irq(&pool->lock);
+		wake_up_worker(pool);
+		spin_unlock_irq(&pool->lock);
+	}
 }
 
 /*
