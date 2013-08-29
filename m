Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3H2OC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:02:28 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11618 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab3H2OCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:02:25 -0400
From: Libin <huawei.libin@huawei.com>
To: <akpm@linux-foundation.org>, <tj@kernel.org>, <viro@zeniv.linux.org.uk>,
        <eparis@redhat.com>, <tglx@linutronix.de>, <rusty@rustcorp.com.au>,
        <ebiederm@xmission.com>, <paulmck@linux.vnet.ibm.com>,
        <john.stultz@linaro.org>, <mingo@redhat.com>, <peterz@infradead.org>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <jovi.zhangwei@huawei.com>, <guohanjun@huawei.com>,
        <zhangdianfang@huawei.com>, <wangyijing@huawei.com>,
        <huawei.libin@huawei.com>
Subject: [PATCH 13/14] workqueue: Fix invalid wakeup in rescuer_thread
Date: Thu, 29 Aug 2013 21:57:48 +0800
Message-ID: <1377784669-28140-14-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If thread is preempted before calling set_current_state(TASK_INTERRUPTIBLE),
and the other thread set the condition followed with wake_up_process. After
that when this thread is re-scheduled, calling set_current_state to set itself
as state TASK_INTERRUPTIBLE, if it is preempted again after that and before
__set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 92 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 43 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7f5d4be..2dcdd30 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2358,63 +2358,69 @@ static int rescuer_thread(void *__rescuer)
 	 * doesn't participate in concurrency management.
 	 */
 	rescuer->task->flags |= PF_WQ_WORKER;
-repeat:
-	set_current_state(TASK_INTERRUPTIBLE);
+	for (;;) {
 
-	if (kthread_should_stop()) {
+		if (kthread_should_stop()) {
+			rescuer->task->flags &= ~PF_WQ_WORKER;
+			return 0;
+		}
+
+		preempt_disable();
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (list_empty(&wq->maydays)) {
+			preempt_enable();
+			schedule();
+			preempt_disable();
+		}
 		__set_current_state(TASK_RUNNING);
-		rescuer->task->flags &= ~PF_WQ_WORKER;
-		return 0;
-	}
+		preempt_enable();
 
-	/* see whether any pwq is asking for help */
-	spin_lock_irq(&wq_mayday_lock);
+		/* see whether any pwq is asking for help */
+		spin_lock_irq(&wq_mayday_lock);
 
-	while (!list_empty(&wq->maydays)) {
-		struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
+		while (!list_empty(&wq->maydays)) {
+			struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
 					struct pool_workqueue, mayday_node);
-		struct worker_pool *pool = pwq->pool;
-		struct work_struct *work, *n;
+			struct worker_pool *pool = pwq->pool;
+			struct work_struct *work, *n;
 
-		__set_current_state(TASK_RUNNING);
-		list_del_init(&pwq->mayday_node);
+			list_del_init(&pwq->mayday_node);
 
-		spin_unlock_irq(&wq_mayday_lock);
+			spin_unlock_irq(&wq_mayday_lock);
 
-		/* migrate to the target cpu if possible */
-		worker_maybe_bind_and_lock(pool);
-		rescuer->pool = pool;
+			/* migrate to the target cpu if possible */
+			worker_maybe_bind_and_lock(pool);
+			rescuer->pool = pool;
 
-		/*
-		 * Slurp in all works issued via this workqueue and
-		 * process'em.
-		 */
-		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
-		list_for_each_entry_safe(work, n, &pool->worklist, entry)
-			if (get_work_pwq(work) == pwq)
-				move_linked_works(work, scheduled, &n);
+			/*
+			 * Slurp in all works issued via this workqueue and
+			 * process'em.
+			 */
+			WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
+			list_for_each_entry_safe(work, n, &pool->worklist, entry)
+				if (get_work_pwq(work) == pwq)
+					move_linked_works(work, scheduled, &n);
 
-		process_scheduled_works(rescuer);
+			process_scheduled_works(rescuer);
 
-		/*
-		 * Leave this pool.  If keep_working() is %true, notify a
-		 * regular worker; otherwise, we end up with 0 concurrency
-		 * and stalling the execution.
-		 */
-		if (keep_working(pool))
-			wake_up_worker(pool);
+			/*
+			 * Leave this pool.  If keep_working() is %true, notify a
+			 * regular worker; otherwise, we end up with 0 concurrency
+			 * and stalling the execution.
+			 */
+			if (keep_working(pool))
+				wake_up_worker(pool);
 
-		rescuer->pool = NULL;
-		spin_unlock(&pool->lock);
-		spin_lock(&wq_mayday_lock);
-	}
+			rescuer->pool = NULL;
+			spin_unlock(&pool->lock);
+			spin_lock(&wq_mayday_lock);
+		}
 
-	spin_unlock_irq(&wq_mayday_lock);
+		spin_unlock_irq(&wq_mayday_lock);
 
-	/* rescuers should never participate in concurrency management */
-	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
-	schedule();
-	goto repeat;
+		/* rescuers should never participate in concurrency management */
+		WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
+	}
 }
 
 struct wq_barrier {
-- 
1.8.2.1


