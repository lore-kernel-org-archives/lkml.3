Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3ARWJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:09:05 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39373 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab3ARWJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:09:02 -0500
Date: Fri, 18 Jan 2013 14:08:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/5] workqueue: set PF_WQ_WORKER on rescuers
Message-ID: <20130118220855.GC24579@htj.dyndns.org>
References: <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
 <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130118012503.GH16568@mtj.dyndns.org>
 <CA+55aFyCihvZqOo=83UwWq3AgJEfVqpNjsY2iCFOEm8o6Un-YA@mail.gmail.com>
 <20130118025936.GJ16568@mtj.dyndns.org>
 <20130118030407.GK16568@mtj.dyndns.org>
 <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 111c225a5f8d872bc9327ada18d13b75edaa34be Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 17 Jan 2013 17:16:24 -0800

PF_WQ_WORKER is used to tell scheduler that the task is a workqueue
worker and needs wq_worker_sleeping/waking_up() invoked on it for
concurrency management.  As rescuers never participate in concurrency
management, PF_WQ_WORKER wasn't set on them.

There's a need for an interface which can query whether %current is
executing a work item and if so which.  Such interface requires a way
to identify all tasks which may execute work items and PF_WQ_WORKER
will be used for that.  As all normal workers always have PF_WQ_WORKER
set, we only need to add it to rescuers.

As rescuers start with WORKER_PREP but never clear it, it's always
NOT_RUNNING and there's no need to worry about it interfering with
concurrency management even if PF_WQ_WORKER is set; however, unlike
normal workers, rescuers currently don't have its worker struct as
kthread_data().  It uses the associated workqueue_struct instead.
This is problematic as wq_worker_sleeping/waking_up() expect struct
worker at kthread_data().

This patch adds worker->rescue_wq and start rescuer kthreads with
worker struct as kthread_data and sets PF_WQ_WORKER on rescuers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
This one is the same as last time.

 kernel/workqueue.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7967f34..6b99ac7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -149,6 +149,9 @@ struct worker {
 
 	/* for rebinding worker to CPU */
 	struct work_struct	rebind_work;	/* L: for busy worker */
+
+	/* used only by rescuers to point to the target workqueue */
+	struct workqueue_struct	*rescue_wq;	/* I: the workqueue to rescue */
 };
 
 struct worker_pool {
@@ -763,12 +766,20 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 				       unsigned int cpu)
 {
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
-	struct worker_pool *pool = worker->pool;
-	atomic_t *nr_running = get_pool_nr_running(pool);
+	struct worker_pool *pool;
+	atomic_t *nr_running;
 
+	/*
+	 * Rescuers, which may not have all the fields set up like normal
+	 * workers, also reach here, let's not access anything before
+	 * checking NOT_RUNNING.
+	 */
 	if (worker->flags & WORKER_NOT_RUNNING)
 		return NULL;
 
+	pool = worker->pool;
+	nr_running = get_pool_nr_running(pool);
+
 	/* this can only happen on the local cpu */
 	BUG_ON(cpu != raw_smp_processor_id());
 
@@ -2357,7 +2368,7 @@ sleep:
 
 /**
  * rescuer_thread - the rescuer thread function
- * @__wq: the associated workqueue
+ * @__rescuer: self
  *
  * Workqueue rescuer thread function.  There's one rescuer for each
  * workqueue which has WQ_RESCUER set.
@@ -2374,20 +2385,27 @@ sleep:
  *
  * This should happen rarely.
  */
-static int rescuer_thread(void *__wq)
+static int rescuer_thread(void *__rescuer)
 {
-	struct workqueue_struct *wq = __wq;
-	struct worker *rescuer = wq->rescuer;
+	struct worker *rescuer = __rescuer;
+	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
 	bool is_unbound = wq->flags & WQ_UNBOUND;
 	unsigned int cpu;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
+
+	/*
+	 * Mark rescuer as worker too.  As WORKER_PREP is never cleared, it
+	 * doesn't participate in concurrency management.
+	 */
+	rescuer->task->flags |= PF_WQ_WORKER;
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	if (kthread_should_stop()) {
 		__set_current_state(TASK_RUNNING);
+		rescuer->task->flags &= ~PF_WQ_WORKER;
 		return 0;
 	}
 
@@ -2431,6 +2449,8 @@ repeat:
 		spin_unlock_irq(&gcwq->lock);
 	}
 
+	/* rescuers should never participate in concurrency management */
+	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
 	schedule();
 	goto repeat;
 }
@@ -3266,7 +3286,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		if (!rescuer)
 			goto err;
 
-		rescuer->task = kthread_create(rescuer_thread, wq, "%s",
+		rescuer->rescue_wq = wq;
+		rescuer->task = kthread_create(rescuer_thread, rescuer, "%s",
 					       wq->name);
 		if (IS_ERR(rescuer->task))
 			goto err;
-- 
1.8.0.2

