Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3CBDZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:06 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48437 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3CBDYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:43 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/31] workqueue: add wokrqueue_struct->maydays list to replace mayday cpu iterators
Date: Fri,  1 Mar 2013 19:23:59 -0800
Message-Id: <1362194662-2344-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to how pool_workqueue iteration used to be, raising and
servicing mayday requests is based on CPU numbers.  It's hairy because
cpumask_t may not be able to handle WORK_CPU_UNBOUND and cpumasks are
assumed to be always set on UP.  This is ugly and can't handle
multiple unbound pools to be added for unbound workqueues w/ custom
attributes.

Add workqueue_struct->maydays.  When a pool_workqueue needs rescuing,
it gets chained on the list through pool_workqueue->mayday_node and
rescuer_thread() consumes the list until it's empty.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 77 ++++++++++++++++++++----------------------------------
 1 file changed, 28 insertions(+), 49 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f195aa..8b38d1c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -170,6 +170,7 @@ struct pool_workqueue {
 	int			max_active;	/* L: max active works */
 	struct list_head	delayed_works;	/* L: delayed works */
 	struct list_head	pwqs_node;	/* I: node on wq->pwqs */
+	struct list_head	mayday_node;	/* W: node on wq->maydays */
 } __aligned(1 << WORK_STRUCT_FLAG_BITS);
 
 /*
@@ -182,27 +183,6 @@ struct wq_flusher {
 };
 
 /*
- * All cpumasks are assumed to be always set on UP and thus can't be
- * used to determine whether there's something to be done.
- */
-#ifdef CONFIG_SMP
-typedef cpumask_var_t mayday_mask_t;
-#define mayday_test_and_set_cpu(cpu, mask)	\
-	cpumask_test_and_set_cpu((cpu), (mask))
-#define mayday_clear_cpu(cpu, mask)		cpumask_clear_cpu((cpu), (mask))
-#define for_each_mayday_cpu(cpu, mask)		for_each_cpu((cpu), (mask))
-#define alloc_mayday_mask(maskp, gfp)		zalloc_cpumask_var((maskp), (gfp))
-#define free_mayday_mask(mask)			free_cpumask_var((mask))
-#else
-typedef unsigned long mayday_mask_t;
-#define mayday_test_and_set_cpu(cpu, mask)	test_and_set_bit(0, &(mask))
-#define mayday_clear_cpu(cpu, mask)		clear_bit(0, &(mask))
-#define for_each_mayday_cpu(cpu, mask)		if ((cpu) = 0, (mask))
-#define alloc_mayday_mask(maskp, gfp)		true
-#define free_mayday_mask(mask)			do { } while (0)
-#endif
-
-/*
  * The externally visible workqueue abstraction is an array of
  * per-CPU workqueues:
  */
@@ -224,7 +204,7 @@ struct workqueue_struct {
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
 
-	mayday_mask_t		mayday_mask;	/* cpus requesting rescue */
+	struct list_head	maydays;	/* W: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
 	int			nr_drainers;	/* W: drain in progress */
@@ -1852,23 +1832,21 @@ static void idle_worker_timeout(unsigned long __pool)
 	spin_unlock_irq(&pool->lock);
 }
 
-static bool send_mayday(struct work_struct *work)
+static void send_mayday(struct work_struct *work)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct workqueue_struct *wq = pwq->wq;
-	unsigned int cpu;
+
+	lockdep_assert_held(&workqueue_lock);
 
 	if (!(wq->flags & WQ_RESCUER))
-		return false;
+		return;
 
 	/* mayday mayday mayday */
-	cpu = pwq->pool->cpu;
-	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
-	if (cpu == WORK_CPU_UNBOUND)
-		cpu = 0;
-	if (!mayday_test_and_set_cpu(cpu, wq->mayday_mask))
+	if (list_empty(&pwq->mayday_node)) {
+		list_add_tail(&pwq->mayday_node, &wq->maydays);
 		wake_up_process(wq->rescuer->task);
-	return true;
+	}
 }
 
 static void pool_mayday_timeout(unsigned long __pool)
@@ -1876,7 +1854,8 @@ static void pool_mayday_timeout(unsigned long __pool)
 	struct worker_pool *pool = (void *)__pool;
 	struct work_struct *work;
 
-	spin_lock_irq(&pool->lock);
+	spin_lock_irq(&workqueue_lock);		/* for wq->maydays */
+	spin_lock(&pool->lock);
 
 	if (need_to_create_worker(pool)) {
 		/*
@@ -1889,7 +1868,8 @@ static void pool_mayday_timeout(unsigned long __pool)
 			send_mayday(work);
 	}
 
-	spin_unlock_irq(&pool->lock);
+	spin_unlock(&pool->lock);
+	spin_unlock_irq(&workqueue_lock);
 
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
@@ -2338,8 +2318,6 @@ static int rescuer_thread(void *__rescuer)
 	struct worker *rescuer = __rescuer;
 	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
-	bool is_unbound = wq->flags & WQ_UNBOUND;
-	unsigned int cpu;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 
@@ -2357,18 +2335,19 @@ repeat:
 		return 0;
 	}
 
-	/*
-	 * See whether any cpu is asking for help.  Unbounded
-	 * workqueues use cpu 0 in mayday_mask for CPU_UNBOUND.
-	 */
-	for_each_mayday_cpu(cpu, wq->mayday_mask) {
-		unsigned int tcpu = is_unbound ? WORK_CPU_UNBOUND : cpu;
-		struct pool_workqueue *pwq = get_pwq(tcpu, wq);
+	/* see whether any pwq is asking for help */
+	spin_lock_irq(&workqueue_lock);
+
+	while (!list_empty(&wq->maydays)) {
+		struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
+					struct pool_workqueue, mayday_node);
 		struct worker_pool *pool = pwq->pool;
 		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
-		mayday_clear_cpu(cpu, wq->mayday_mask);
+		list_del_init(&pwq->mayday_node);
+
+		spin_unlock_irq(&workqueue_lock);
 
 		/* migrate to the target cpu if possible */
 		worker_maybe_bind_and_lock(pool);
@@ -2394,9 +2373,12 @@ repeat:
 			wake_up_worker(pool);
 
 		rescuer->pool = NULL;
-		spin_unlock_irq(&pool->lock);
+		spin_unlock(&pool->lock);
+		spin_lock(&workqueue_lock);
 	}
 
+	spin_unlock_irq(&workqueue_lock);
+
 	/* rescuers should never participate in concurrency management */
 	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
 	schedule();
@@ -3194,6 +3176,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	INIT_LIST_HEAD(&wq->pwqs);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
+	INIT_LIST_HEAD(&wq->maydays);
 
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
@@ -3207,14 +3190,12 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		pwq->flush_color = -1;
 		pwq->max_active = max_active;
 		INIT_LIST_HEAD(&pwq->delayed_works);
+		INIT_LIST_HEAD(&pwq->mayday_node);
 	}
 
 	if (flags & WQ_RESCUER) {
 		struct worker *rescuer;
 
-		if (!alloc_mayday_mask(&wq->mayday_mask, GFP_KERNEL))
-			goto err;
-
 		wq->rescuer = rescuer = alloc_worker();
 		if (!rescuer)
 			goto err;
@@ -3248,7 +3229,6 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 err:
 	if (wq) {
 		free_pwqs(wq);
-		free_mayday_mask(wq->mayday_mask);
 		kfree(wq->rescuer);
 		kfree(wq);
 	}
@@ -3291,7 +3271,6 @@ void destroy_workqueue(struct workqueue_struct *wq)
 
 	if (wq->flags & WQ_RESCUER) {
 		kthread_stop(wq->rescuer->task);
-		free_mayday_mask(wq->mayday_mask);
 		kfree(wq->rescuer);
 	}
 
-- 
1.8.1.2

