Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3DNQmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:42:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7156 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3DNQmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:42:35 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051542"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/8] workqueue: remove @cpu from wq_worker_sleeping()
Date: Mon, 15 Apr 2013 00:41:49 +0800
Message-Id: <1365957716-7631-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:02,
	Serialize complete at 2013/04/15 00:41:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN_ON_ONCE(cpu != raw_smp_processor_id()) in
wq_worker_sleeping() in useless, the caller ensures
cpu == raw_smp_processor_id().

We should use WARN_ON_ONCE(pool->cpu != raw_smp_processor_id())
to do the expected test.

It results @cpu removed from wq_worker_sleeping()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/sched/core.c         |    2 +-
 kernel/workqueue.c          |    7 +++----
 kernel/workqueue_internal.h |    2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 23606ee..ffc06ad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2907,7 +2907,7 @@ need_resched:
 			if (prev->flags & PF_WQ_WORKER) {
 				struct task_struct *to_wakeup;
 
-				to_wakeup = wq_worker_sleeping(prev, cpu);
+				to_wakeup = wq_worker_sleeping(prev);
 				if (to_wakeup)
 					try_to_wake_up_local(to_wakeup);
 			}
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c273376..b3095ad 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -807,7 +807,6 @@ void wq_worker_waking_up(struct task_struct *task, int cpu)
 /**
  * wq_worker_sleeping - a worker is going to sleep
  * @task: task going to sleep
- * @cpu: CPU in question, must be the current CPU number
  *
  * This function is called during schedule() when a busy worker is
  * going to sleep.  Worker on the same cpu can be woken up by
@@ -817,9 +816,9 @@ void wq_worker_waking_up(struct task_struct *task, int cpu)
  * spin_lock_irq(rq->lock)
  *
  * RETURNS:
- * Worker task on @cpu to wake up, %NULL if none.
+ * Worker task on the same pool to wake up, %NULL if none.
  */
-struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
+struct task_struct *wq_worker_sleeping(struct task_struct *task)
 {
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
 	struct worker_pool *pool;
@@ -835,7 +834,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
 	pool = worker->pool;
 
 	/* this can only happen on the local cpu */
-	if (WARN_ON_ONCE(cpu != raw_smp_processor_id()))
+	if (WARN_ON_ONCE(pool->cpu != raw_smp_processor_id()))
 		return NULL;
 
 	/*
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 84ab6e1..aec8df4 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -57,6 +57,6 @@ static inline struct worker *current_wq_worker(void)
  * sched.c and workqueue.c.
  */
 void wq_worker_waking_up(struct task_struct *task, int cpu);
-struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu);
+struct task_struct *wq_worker_sleeping(struct task_struct *task);
 
 #endif /* _KERNEL_WORKQUEUE_INTERNAL_H */
-- 
1.7.7.6

