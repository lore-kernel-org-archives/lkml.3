Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3CBPzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 10:55:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3CBPzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 10:55:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,768,1355068800"; 
   d="scan'208";a="6798301"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: fix possible bug which may silence the pool
Date: Sat, 2 Mar 2013 23:55:29 +0800
Message-Id: <1362239729-6753-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/02 23:54:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/02 23:54:47,
	Serialize complete at 2013/03/02 23:54:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we introduce multiple pools for cpu pools, a part of the comments
in wq_unbind_fn() becomes wrong.

It said that "current worker would trigger unbound chain execution".
It is wrong. current worker only belongs to one of the multiple pools.

If wq_unbind_fn() does unbind the normal_pri pool(not the pool of the current
worker), the current worker is not the available worker to trigger unbound
chain execution of the normal_pri pool, and if all the workers of
the normal_pri goto sleep after they were set %WORKER_UNBOUND but before
they finish their current work, unbound chain execution is not triggered
totally. The pool is stopped!

We can change wq_unbind_fn() only does unbind one pool and we launch multiple
wq_unbind_fn()s, one for each pool to solve the problem.
But this change will add much latency to hotplug path unnecessarily.

So we choice to wake up a worker directly to trigger unbound chain execution.

current worker may sleep on &second_pool->assoc_mutex, so we also move
the wakeup code into the loop to avoid second_pool silences the first_pool.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   45 ++++++++++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 81f2457..03159c2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3446,28 +3446,35 @@ static void wq_unbind_fn(struct work_struct *work)
 
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
+		 * and keep_working() are always true as long as the worklist
+		 * is not empty.  This pool now behave as unbound (in terms of
+		 * concurrency management) pool which are served by workers
+		 * tied to the pool.
+		 */
 		atomic_set(&pool->nr_running, 0);
+
+		/* The current busy workers of this pool may goto sleep without
+		 * wake up any other worker after they were set %WORKER_UNBOUND
+		 * flag. Here we wake up another possible worker to start
+		 * the unbound chain execution of pending work items in this
+		 * case.
+		 */
+		spin_lock_irq(&pool->lock);
+		wake_up_worker(pool);
+		spin_unlock_irq(&pool->lock);
+	}
 }
 
 /*
-- 
1.7.7.6

