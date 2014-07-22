Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaGVFBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:01:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:19244 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751095AbaGVFBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:01:08 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33612898"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2 V2] workqueue: remove the argument @wakeup from worker_set_flags()
Date: Tue, 22 Jul 2014 13:02:00 +0800
Message-ID: <1406005330-11864-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1406005330-11864-1-git-send-email-laijs@cn.fujitsu.com>
References: <20140718225317.GC5739@htj.dyndns.org>
 <1406005330-11864-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_set_flags() doesn't necessarily wake next worker and the @wakeup
can be removed, the caller can use the following conbination instead
when needed:

	worker_set_flags();
	if (need_more_worker(pool))
 		wake_up_worker(pool);

It reduces the machine-code and footprint for the process_one_work()
if worker_set_flags() is really inlined.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   27 ++++++++-------------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cd75689..40b1f00 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -867,35 +867,22 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
  * worker_set_flags - set worker flags and adjust nr_running accordingly
  * @worker: self
  * @flags: flags to set
- * @wakeup: wakeup an idle worker if necessary
  *
- * Set @flags in @worker->flags and adjust nr_running accordingly.  If
- * nr_running becomes zero and @wakeup is %true, an idle worker is
- * woken up.
+ * Set @flags in @worker->flags and adjust nr_running accordingly.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock)
  */
-static inline void worker_set_flags(struct worker *worker, unsigned int flags,
-				    bool wakeup)
+static inline void worker_set_flags(struct worker *worker, unsigned int flags)
 {
 	struct worker_pool *pool = worker->pool;
 
 	WARN_ON_ONCE(worker->task != current);
 
-	/*
-	 * If transitioning into NOT_RUNNING, adjust nr_running and
-	 * wake up an idle worker as necessary if requested by
-	 * @wakeup.
-	 */
+	/* If transitioning into NOT_RUNNING, adjust nr_running. */
 	if ((flags & WORKER_NOT_RUNNING) &&
 	    !(worker->flags & WORKER_NOT_RUNNING)) {
-		if (wakeup) {
-			if (atomic_dec_and_test(&pool->nr_running) &&
-			    !list_empty(&pool->worklist))
-				wake_up_worker(pool);
-		} else
-			atomic_dec(&pool->nr_running);
+		atomic_dec(&pool->nr_running);
 	}
 
 	worker->flags |= flags;
@@ -2043,9 +2030,11 @@ __acquires(&pool->lock)
 	/*
 	 * CPU intensive works don't participate in concurrency
 	 * management.  They're the scheduler's responsibility.
+	 * Another worker should be woken up after WORKER_CPU_INTENSIVE
+	 * is set, see next code.
 	 */
 	if (unlikely(cpu_intensive))
-		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
+		worker_set_flags(worker, WORKER_CPU_INTENSIVE);
 
 	/*
 	 * Wake up another worker if necessary.  It is a no-op
@@ -2210,7 +2199,7 @@ recheck:
 		}
 	} while (keep_working(pool));
 
-	worker_set_flags(worker, WORKER_PREP, false);
+	worker_set_flags(worker, WORKER_PREP);
 sleep:
 	/*
 	 * pool->lock is held and there's no work to process and no need to
-- 
1.7.4.4

