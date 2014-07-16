Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbaGPKJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:09:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:17412 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757551AbaGPKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:09:11 -0400
X-IronPort-AV: E=Sophos;i="5.00,902,1396972800"; 
   d="scan'208";a="33350986"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2] workqueue: remove the argument @wakeup from worker_set_flags()
Date: Wed, 16 Jul 2014 18:09:59 +0800
Message-ID: <1405505409-12058-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1405505409-12058-1-git-send-email-laijs@cn.fujitsu.com>
References: <1405505409-12058-1-git-send-email-laijs@cn.fujitsu.com>
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
	

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   25 ++++++-------------------
 1 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6d11b9a..1a14f18 100644
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
@@ -2045,7 +2032,7 @@ __acquires(&pool->lock)
 	 * management.  They're the scheduler's responsibility.
 	 */
 	if (unlikely(cpu_intensive))
-		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
+		worker_set_flags(worker, WORKER_CPU_INTENSIVE);
 
 	/* Wake up another worker if necessary. */
 	if (need_more_worker(pool))
@@ -2204,7 +2191,7 @@ recheck:
 		}
 	} while (keep_working(pool));
 
-	worker_set_flags(worker, WORKER_PREP, false);
+	worker_set_flags(worker, WORKER_PREP);
 sleep:
 	/*
 	 * pool->lock is held and there's no work to process and no need to
-- 
1.7.4.4

