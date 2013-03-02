Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3CBDYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:24:38 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57788 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3CBDYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:31 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/31] workqueue: make sanity checks less punshing using WARN_ON[_ONCE]()s
Date: Fri,  1 Mar 2013 19:23:52 -0800
Message-Id: <1362194662-2344-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue has been using mostly BUG_ON()s for sanity checks, which
fail unnecessarily harshly when the assertion doesn't hold.  Most
assertions can converted to be less drastic such that things can limp
along instead of dying completely.  Convert BUG_ON()s to
WARN_ON[_ONCE]()s with softer failure behaviors - e.g. if assertion
check fails in destroy_worker(), trigger WARN and silently ignore
destruction request.

Most conversions are trivial.  Note that sanity checks in
destroy_workqueue() are moved above removal from workqueues list so
that it can bail out without side-effects if assertion checks fail.

This patch doesn't introduce any visible behavior changes during
normal operation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 85 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0b1e6f2..a533e77 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -530,7 +530,7 @@ static int work_next_color(int color)
 static inline void set_work_data(struct work_struct *work, unsigned long data,
 				 unsigned long flags)
 {
-	BUG_ON(!work_pending(work));
+	WARN_ON_ONCE(!work_pending(work));
 	atomic_long_set(&work->data, data | flags | work_static(work));
 }
 
@@ -785,7 +785,8 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	pool = worker->pool;
 
 	/* this can only happen on the local cpu */
-	BUG_ON(cpu != raw_smp_processor_id());
+	if (WARN_ON_ONCE(cpu != raw_smp_processor_id()))
+		return NULL;
 
 	/*
 	 * The counterpart of the following dec_and_test, implied mb,
@@ -1459,9 +1460,10 @@ static void worker_enter_idle(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	BUG_ON(worker->flags & WORKER_IDLE);
-	BUG_ON(!list_empty(&worker->entry) &&
-	       (worker->hentry.next || worker->hentry.pprev));
+	if (WARN_ON_ONCE(worker->flags & WORKER_IDLE) ||
+	    WARN_ON_ONCE(!list_empty(&worker->entry) &&
+			 (worker->hentry.next || worker->hentry.pprev)))
+		return;
 
 	/* can't use worker_set_flags(), also called from start_worker() */
 	worker->flags |= WORKER_IDLE;
@@ -1498,7 +1500,8 @@ static void worker_leave_idle(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	BUG_ON(!(worker->flags & WORKER_IDLE));
+	if (WARN_ON_ONCE(!(worker->flags & WORKER_IDLE)))
+		return;
 	worker_clr_flags(worker, WORKER_IDLE);
 	pool->nr_idle--;
 	list_del_init(&worker->entry);
@@ -1795,8 +1798,9 @@ static void destroy_worker(struct worker *worker)
 	int id = worker->id;
 
 	/* sanity check frenzy */
-	BUG_ON(worker->current_work);
-	BUG_ON(!list_empty(&worker->scheduled));
+	if (WARN_ON(worker->current_work) ||
+	    WARN_ON(!list_empty(&worker->scheduled)))
+		return;
 
 	if (worker->flags & WORKER_STARTED)
 		pool->nr_workers--;
@@ -1925,7 +1929,8 @@ restart:
 			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&pool->lock);
 			start_worker(worker);
-			BUG_ON(need_to_create_worker(pool));
+			if (WARN_ON_ONCE(need_to_create_worker(pool)))
+				goto restart;
 			return true;
 		}
 
@@ -2258,7 +2263,7 @@ recheck:
 	 * preparing to process a work or actually processing it.
 	 * Make sure nobody diddled with it while I was sleeping.
 	 */
-	BUG_ON(!list_empty(&worker->scheduled));
+	WARN_ON_ONCE(!list_empty(&worker->scheduled));
 
 	/*
 	 * When control reaches this point, we're guaranteed to have
@@ -2366,7 +2371,7 @@ repeat:
 		 * Slurp in all works issued via this workqueue and
 		 * process'em.
 		 */
-		BUG_ON(!list_empty(&rescuer->scheduled));
+		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
 		list_for_each_entry_safe(work, n, &pool->worklist, entry)
 			if (get_work_pwq(work) == pwq)
 				move_linked_works(work, scheduled, &n);
@@ -2501,7 +2506,7 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 	unsigned int cpu;
 
 	if (flush_color >= 0) {
-		BUG_ON(atomic_read(&wq->nr_pwqs_to_flush));
+		WARN_ON_ONCE(atomic_read(&wq->nr_pwqs_to_flush));
 		atomic_set(&wq->nr_pwqs_to_flush, 1);
 	}
 
@@ -2512,7 +2517,7 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 		spin_lock_irq(&pool->lock);
 
 		if (flush_color >= 0) {
-			BUG_ON(pwq->flush_color != -1);
+			WARN_ON_ONCE(pwq->flush_color != -1);
 
 			if (pwq->nr_in_flight[flush_color]) {
 				pwq->flush_color = flush_color;
@@ -2522,7 +2527,7 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 		}
 
 		if (work_color >= 0) {
-			BUG_ON(work_color != work_next_color(pwq->work_color));
+			WARN_ON_ONCE(work_color != work_next_color(pwq->work_color));
 			pwq->work_color = work_color;
 		}
 
@@ -2570,13 +2575,13 @@ void flush_workqueue(struct workqueue_struct *wq)
 		 * becomes our flush_color and work_color is advanced
 		 * by one.
 		 */
-		BUG_ON(!list_empty(&wq->flusher_overflow));
+		WARN_ON_ONCE(!list_empty(&wq->flusher_overflow));
 		this_flusher.flush_color = wq->work_color;
 		wq->work_color = next_color;
 
 		if (!wq->first_flusher) {
 			/* no flush in progress, become the first flusher */
-			BUG_ON(wq->flush_color != this_flusher.flush_color);
+			WARN_ON_ONCE(wq->flush_color != this_flusher.flush_color);
 
 			wq->first_flusher = &this_flusher;
 
@@ -2589,7 +2594,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 			}
 		} else {
 			/* wait in queue */
-			BUG_ON(wq->flush_color == this_flusher.flush_color);
+			WARN_ON_ONCE(wq->flush_color == this_flusher.flush_color);
 			list_add_tail(&this_flusher.list, &wq->flusher_queue);
 			flush_workqueue_prep_pwqs(wq, -1, wq->work_color);
 		}
@@ -2623,8 +2628,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 	wq->first_flusher = NULL;
 
-	BUG_ON(!list_empty(&this_flusher.list));
-	BUG_ON(wq->flush_color != this_flusher.flush_color);
+	WARN_ON_ONCE(!list_empty(&this_flusher.list));
+	WARN_ON_ONCE(wq->flush_color != this_flusher.flush_color);
 
 	while (true) {
 		struct wq_flusher *next, *tmp;
@@ -2637,8 +2642,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 			complete(&next->done);
 		}
 
-		BUG_ON(!list_empty(&wq->flusher_overflow) &&
-		       wq->flush_color != work_next_color(wq->work_color));
+		WARN_ON_ONCE(!list_empty(&wq->flusher_overflow) &&
+			     wq->flush_color != work_next_color(wq->work_color));
 
 		/* this flush_color is finished, advance by one */
 		wq->flush_color = work_next_color(wq->flush_color);
@@ -2662,7 +2667,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		}
 
 		if (list_empty(&wq->flusher_queue)) {
-			BUG_ON(wq->flush_color != wq->work_color);
+			WARN_ON_ONCE(wq->flush_color != wq->work_color);
 			break;
 		}
 
@@ -2670,8 +2675,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 		 * Need to flush more colors.  Make the next flusher
 		 * the new first flusher and arm pwqs.
 		 */
-		BUG_ON(wq->flush_color == wq->work_color);
-		BUG_ON(wq->flush_color != next->flush_color);
+		WARN_ON_ONCE(wq->flush_color == wq->work_color);
+		WARN_ON_ONCE(wq->flush_color != next->flush_color);
 
 		list_del_init(&next->list);
 		wq->first_flusher = next;
@@ -3265,6 +3270,19 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	/* drain it before proceeding with destruction */
 	drain_workqueue(wq);
 
+	/* sanity checks */
+	for_each_pwq_cpu(cpu, wq) {
+		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+		int i;
+
+		for (i = 0; i < WORK_NR_COLORS; i++)
+			if (WARN_ON(pwq->nr_in_flight[i]))
+				return;
+		if (WARN_ON(pwq->nr_active) ||
+		    WARN_ON(!list_empty(&pwq->delayed_works)))
+			return;
+	}
+
 	/*
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
@@ -3273,17 +3291,6 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	/* sanity check */
-	for_each_pwq_cpu(cpu, wq) {
-		struct pool_workqueue *pwq = get_pwq(cpu, wq);
-		int i;
-
-		for (i = 0; i < WORK_NR_COLORS; i++)
-			BUG_ON(pwq->nr_in_flight[i]);
-		BUG_ON(pwq->nr_active);
-		BUG_ON(!list_empty(&pwq->delayed_works));
-	}
-
 	if (wq->flags & WQ_RESCUER) {
 		kthread_stop(wq->rescuer->task);
 		free_mayday_mask(wq->mayday_mask);
@@ -3427,7 +3434,7 @@ static void wq_unbind_fn(struct work_struct *work)
 	int i;
 
 	for_each_std_worker_pool(pool, cpu) {
-		BUG_ON(cpu != smp_processor_id());
+		WARN_ON_ONCE(cpu != smp_processor_id());
 
 		mutex_lock(&pool->assoc_mutex);
 		spin_lock_irq(&pool->lock);
@@ -3597,7 +3604,7 @@ void freeze_workqueues_begin(void)
 
 	spin_lock(&workqueue_lock);
 
-	BUG_ON(workqueue_freezing);
+	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
 
 	for_each_wq_cpu(cpu) {
@@ -3645,7 +3652,7 @@ bool freeze_workqueues_busy(void)
 
 	spin_lock(&workqueue_lock);
 
-	BUG_ON(!workqueue_freezing);
+	WARN_ON_ONCE(!workqueue_freezing);
 
 	for_each_wq_cpu(cpu) {
 		struct workqueue_struct *wq;
@@ -3659,7 +3666,7 @@ bool freeze_workqueues_busy(void)
 			if (!pwq || !(wq->flags & WQ_FREEZABLE))
 				continue;
 
-			BUG_ON(pwq->nr_active < 0);
+			WARN_ON_ONCE(pwq->nr_active < 0);
 			if (pwq->nr_active) {
 				busy = true;
 				goto out_unlock;
-- 
1.8.1.2

