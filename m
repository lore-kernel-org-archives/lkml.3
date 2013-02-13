Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285Ab3BMXWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:22:04 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:61534 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965136Ab3BMXWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:22:01 -0500
Date: Wed, 13 Feb 2013 15:21:43 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH wq/for-3.9] workqueue: rename cpu_workqueue to pool_workqueue
Message-ID: <20130213232143.GE9057@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8fd328f56c3a2fcd1b6070879bf11dd265be33bb Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 13 Feb 2013 15:18:28 -0800

workqueue has moved away from global_cwqs to worker_pools and with the
scheduled custom worker pools, workqueues will be associated with
pools which don't have anything to do with CPUs.  The workqueue code
went through significant amount of changes recently and mass renaming
isn't likely to hurt much additionally.  Let's replace 'cpu' with
'pool' so that it reflects the current design.

* s/struct cpu_workqueue_struct/struct pool_workqueue/
* s/cpu_wq/pool_wq/
* s/cwq/pwq/

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h        |  12 +-
 include/trace/events/workqueue.h |  10 +-
 kernel/workqueue.c               | 437 +++++++++++++++++++--------------------
 kernel/workqueue_internal.h      |   2 +-
 4 files changed, 230 insertions(+), 231 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index a3d7556..8afab27 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -27,7 +27,7 @@ void delayed_work_timer_fn(unsigned long __data);
 enum {
 	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
 	WORK_STRUCT_DELAYED_BIT	= 1,	/* work item is delayed */
-	WORK_STRUCT_CWQ_BIT	= 2,	/* data points to cwq */
+	WORK_STRUCT_PWQ_BIT	= 2,	/* data points to pwq */
 	WORK_STRUCT_LINKED_BIT	= 3,	/* next work is linked to this one */
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 	WORK_STRUCT_STATIC_BIT	= 4,	/* static initializer (debugobjects) */
@@ -40,7 +40,7 @@ enum {
 
 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
 	WORK_STRUCT_DELAYED	= 1 << WORK_STRUCT_DELAYED_BIT,
-	WORK_STRUCT_CWQ		= 1 << WORK_STRUCT_CWQ_BIT,
+	WORK_STRUCT_PWQ		= 1 << WORK_STRUCT_PWQ_BIT,
 	WORK_STRUCT_LINKED	= 1 << WORK_STRUCT_LINKED_BIT,
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 	WORK_STRUCT_STATIC	= 1 << WORK_STRUCT_STATIC_BIT,
@@ -60,14 +60,14 @@ enum {
 	WORK_CPU_END		= NR_CPUS + 1,
 
 	/*
-	 * Reserve 7 bits off of cwq pointer w/ debugobjects turned
-	 * off.  This makes cwqs aligned to 256 bytes and allows 15
-	 * workqueue flush colors.
+	 * Reserve 7 bits off of pwq pointer w/ debugobjects turned off.
+	 * This makes pwqs aligned to 256 bytes and allows 15 workqueue
+	 * flush colors.
 	 */
 	WORK_STRUCT_FLAG_BITS	= WORK_STRUCT_COLOR_SHIFT +
 				  WORK_STRUCT_COLOR_BITS,
 
-	/* data contains off-queue information when !WORK_STRUCT_CWQ */
+	/* data contains off-queue information when !WORK_STRUCT_PWQ */
 	WORK_OFFQ_FLAG_BASE	= WORK_STRUCT_FLAG_BITS,
 
 	WORK_OFFQ_CANCELING	= (1 << WORK_OFFQ_FLAG_BASE),
diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 4e798e3..bf0e18b 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -27,7 +27,7 @@ DECLARE_EVENT_CLASS(workqueue_work,
 /**
  * workqueue_queue_work - called when a work gets queued
  * @req_cpu:	the requested cpu
- * @cwq:	pointer to struct cpu_workqueue_struct
+ * @pwq:	pointer to struct pool_workqueue
  * @work:	pointer to struct work_struct
  *
  * This event occurs when a work is queued immediately or once a
@@ -36,10 +36,10 @@ DECLARE_EVENT_CLASS(workqueue_work,
  */
 TRACE_EVENT(workqueue_queue_work,
 
-	TP_PROTO(unsigned int req_cpu, struct cpu_workqueue_struct *cwq,
+	TP_PROTO(unsigned int req_cpu, struct pool_workqueue *pwq,
 		 struct work_struct *work),
 
-	TP_ARGS(req_cpu, cwq, work),
+	TP_ARGS(req_cpu, pwq, work),
 
 	TP_STRUCT__entry(
 		__field( void *,	work	)
@@ -52,9 +52,9 @@ TRACE_EVENT(workqueue_queue_work,
 	TP_fast_assign(
 		__entry->work		= work;
 		__entry->function	= work->func;
-		__entry->workqueue	= cwq->wq;
+		__entry->workqueue	= pwq->wq;
 		__entry->req_cpu	= req_cpu;
-		__entry->cpu		= cwq->pool->cpu;
+		__entry->cpu		= pwq->pool->cpu;
 	),
 
 	TP_printk("work struct=%p function=%pf workqueue=%p req_cpu=%u cpu=%u",
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d6fdce1..32348c6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -154,11 +154,12 @@ struct worker_pool {
 } ____cacheline_aligned_in_smp;
 
 /*
- * The per-CPU workqueue.  The lower WORK_STRUCT_FLAG_BITS of
- * work_struct->data are used for flags and thus cwqs need to be
- * aligned at two's power of the number of flag bits.
+ * The per-pool workqueue.  While queued, the lower WORK_STRUCT_FLAG_BITS
+ * of work_struct->data are used for flags and the remaining high bits
+ * point to the pwq; thus, pwqs need to be aligned at two's power of the
+ * number of flag bits.
  */
-struct cpu_workqueue_struct {
+struct pool_workqueue {
 	struct worker_pool	*pool;		/* I: the associated pool */
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
@@ -207,16 +208,16 @@ typedef unsigned long mayday_mask_t;
 struct workqueue_struct {
 	unsigned int		flags;		/* W: WQ_* flags */
 	union {
-		struct cpu_workqueue_struct __percpu	*pcpu;
-		struct cpu_workqueue_struct		*single;
+		struct pool_workqueue __percpu		*pcpu;
+		struct pool_workqueue			*single;
 		unsigned long				v;
-	} cpu_wq;				/* I: cwq's */
+	} pool_wq;				/* I: pwq's */
 	struct list_head	list;		/* W: list of all workqueues */
 
 	struct mutex		flush_mutex;	/* protects wq flushing */
 	int			work_color;	/* F: current work color */
 	int			flush_color;	/* F: current flush color */
-	atomic_t		nr_cwqs_to_flush; /* flush in progress */
+	atomic_t		nr_pwqs_to_flush; /* flush in progress */
 	struct wq_flusher	*first_flusher;	/* F: first flusher */
 	struct list_head	flusher_queue;	/* F: flush waiters */
 	struct list_head	flusher_overflow; /* F: flush overflow list */
@@ -225,7 +226,7 @@ struct workqueue_struct {
 	struct worker		*rescuer;	/* I: rescue worker */
 
 	int			nr_drainers;	/* W: drain in progress */
-	int			saved_max_active; /* W: saved cwq max_active */
+	int			saved_max_active; /* W: saved pwq max_active */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
@@ -268,7 +269,7 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 	return WORK_CPU_END;
 }
 
-static inline int __next_cwq_cpu(int cpu, const struct cpumask *mask,
+static inline int __next_pwq_cpu(int cpu, const struct cpumask *mask,
 				 struct workqueue_struct *wq)
 {
 	return __next_wq_cpu(cpu, mask, !(wq->flags & WQ_UNBOUND) ? 1 : 2);
@@ -284,7 +285,7 @@ static inline int __next_cwq_cpu(int cpu, const struct cpumask *mask,
  *
  * for_each_wq_cpu()		: possible CPUs + WORK_CPU_UNBOUND
  * for_each_online_wq_cpu()	: online CPUs + WORK_CPU_UNBOUND
- * for_each_cwq_cpu()		: possible CPUs for bound workqueues,
+ * for_each_pwq_cpu()		: possible CPUs for bound workqueues,
  *				  WORK_CPU_UNBOUND for unbound workqueues
  */
 #define for_each_wq_cpu(cpu)						\
@@ -297,10 +298,10 @@ static inline int __next_cwq_cpu(int cpu, const struct cpumask *mask,
 	     (cpu) < WORK_CPU_END;					\
 	     (cpu) = __next_wq_cpu((cpu), cpu_online_mask, 3))
 
-#define for_each_cwq_cpu(cpu, wq)					\
-	for ((cpu) = __next_cwq_cpu(-1, cpu_possible_mask, (wq));	\
+#define for_each_pwq_cpu(cpu, wq)					\
+	for ((cpu) = __next_pwq_cpu(-1, cpu_possible_mask, (wq));	\
 	     (cpu) < WORK_CPU_END;					\
-	     (cpu) = __next_cwq_cpu((cpu), cpu_possible_mask, (wq)))
+	     (cpu) = __next_pwq_cpu((cpu), cpu_possible_mask, (wq)))
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
@@ -479,14 +480,14 @@ static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
 	return &pools[highpri];
 }
 
-static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
-					    struct workqueue_struct *wq)
+static struct pool_workqueue *get_pwq(unsigned int cpu,
+				      struct workqueue_struct *wq)
 {
 	if (!(wq->flags & WQ_UNBOUND)) {
 		if (likely(cpu < nr_cpu_ids))
-			return per_cpu_ptr(wq->cpu_wq.pcpu, cpu);
+			return per_cpu_ptr(wq->pool_wq.pcpu, cpu);
 	} else if (likely(cpu == WORK_CPU_UNBOUND))
-		return wq->cpu_wq.single;
+		return wq->pool_wq.single;
 	return NULL;
 }
 
@@ -507,18 +508,18 @@ static int work_next_color(int color)
 }
 
 /*
- * While queued, %WORK_STRUCT_CWQ is set and non flag bits of a work's data
- * contain the pointer to the queued cwq.  Once execution starts, the flag
+ * While queued, %WORK_STRUCT_PWQ is set and non flag bits of a work's data
+ * contain the pointer to the queued pwq.  Once execution starts, the flag
  * is cleared and the high bits contain OFFQ flags and pool ID.
  *
- * set_work_cwq(), set_work_pool_and_clear_pending(), mark_work_canceling()
- * and clear_work_data() can be used to set the cwq, pool or clear
+ * set_work_pwq(), set_work_pool_and_clear_pending(), mark_work_canceling()
+ * and clear_work_data() can be used to set the pwq, pool or clear
  * work->data.  These functions should only be called while the work is
  * owned - ie. while the PENDING bit is set.
  *
- * get_work_pool() and get_work_cwq() can be used to obtain the pool or cwq
+ * get_work_pool() and get_work_pwq() can be used to obtain the pool or pwq
  * corresponding to a work.  Pool is available once the work has been
- * queued anywhere after initialization until it is sync canceled.  cwq is
+ * queued anywhere after initialization until it is sync canceled.  pwq is
  * available only while the work item is queued.
  *
  * %WORK_OFFQ_CANCELING is used to mark a work item which is being
@@ -533,12 +534,11 @@ static inline void set_work_data(struct work_struct *work, unsigned long data,
 	atomic_long_set(&work->data, data | flags | work_static(work));
 }
 
-static void set_work_cwq(struct work_struct *work,
-			 struct cpu_workqueue_struct *cwq,
+static void set_work_pwq(struct work_struct *work, struct pool_workqueue *pwq,
 			 unsigned long extra_flags)
 {
-	set_work_data(work, (unsigned long)cwq,
-		      WORK_STRUCT_PENDING | WORK_STRUCT_CWQ | extra_flags);
+	set_work_data(work, (unsigned long)pwq,
+		      WORK_STRUCT_PENDING | WORK_STRUCT_PWQ | extra_flags);
 }
 
 static void set_work_pool_and_keep_pending(struct work_struct *work,
@@ -567,11 +567,11 @@ static void clear_work_data(struct work_struct *work)
 	set_work_data(work, WORK_STRUCT_NO_POOL, 0);
 }
 
-static struct cpu_workqueue_struct *get_work_cwq(struct work_struct *work)
+static struct pool_workqueue *get_work_pwq(struct work_struct *work)
 {
 	unsigned long data = atomic_long_read(&work->data);
 
-	if (data & WORK_STRUCT_CWQ)
+	if (data & WORK_STRUCT_PWQ)
 		return (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
 	else
 		return NULL;
@@ -589,8 +589,8 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
 	struct worker_pool *pool;
 	int pool_id;
 
-	if (data & WORK_STRUCT_CWQ)
-		return ((struct cpu_workqueue_struct *)
+	if (data & WORK_STRUCT_PWQ)
+		return ((struct pool_workqueue *)
 			(data & WORK_STRUCT_WQ_DATA_MASK))->pool;
 
 	pool_id = data >> WORK_OFFQ_POOL_SHIFT;
@@ -613,8 +613,8 @@ static int get_work_pool_id(struct work_struct *work)
 {
 	unsigned long data = atomic_long_read(&work->data);
 
-	if (data & WORK_STRUCT_CWQ)
-		return ((struct cpu_workqueue_struct *)
+	if (data & WORK_STRUCT_PWQ)
+		return ((struct pool_workqueue *)
 			(data & WORK_STRUCT_WQ_DATA_MASK))->pool->id;
 
 	return data >> WORK_OFFQ_POOL_SHIFT;
@@ -632,7 +632,7 @@ static bool work_is_canceling(struct work_struct *work)
 {
 	unsigned long data = atomic_long_read(&work->data);
 
-	return !(data & WORK_STRUCT_CWQ) && (data & WORK_OFFQ_CANCELING);
+	return !(data & WORK_STRUCT_PWQ) && (data & WORK_OFFQ_CANCELING);
 }
 
 /*
@@ -961,67 +961,67 @@ static void move_linked_works(struct work_struct *work, struct list_head *head,
 		*nextp = n;
 }
 
-static void cwq_activate_delayed_work(struct work_struct *work)
+static void pwq_activate_delayed_work(struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
+	struct pool_workqueue *pwq = get_work_pwq(work);
 
 	trace_workqueue_activate_work(work);
-	move_linked_works(work, &cwq->pool->worklist, NULL);
+	move_linked_works(work, &pwq->pool->worklist, NULL);
 	__clear_bit(WORK_STRUCT_DELAYED_BIT, work_data_bits(work));
-	cwq->nr_active++;
+	pwq->nr_active++;
 }
 
-static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+static void pwq_activate_first_delayed(struct pool_workqueue *pwq)
 {
-	struct work_struct *work = list_first_entry(&cwq->delayed_works,
+	struct work_struct *work = list_first_entry(&pwq->delayed_works,
 						    struct work_struct, entry);
 
-	cwq_activate_delayed_work(work);
+	pwq_activate_delayed_work(work);
 }
 
 /**
- * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
- * @cwq: cwq of interest
+ * pwq_dec_nr_in_flight - decrement pwq's nr_in_flight
+ * @pwq: pwq of interest
  * @color: color of work which left the queue
  *
  * A work either has completed or is removed from pending queue,
- * decrement nr_in_flight of its cwq and handle workqueue flushing.
+ * decrement nr_in_flight of its pwq and handle workqueue flushing.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock).
  */
-static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
+static void pwq_dec_nr_in_flight(struct pool_workqueue *pwq, int color)
 {
 	/* ignore uncolored works */
 	if (color == WORK_NO_COLOR)
 		return;
 
-	cwq->nr_in_flight[color]--;
+	pwq->nr_in_flight[color]--;
 
-	cwq->nr_active--;
-	if (!list_empty(&cwq->delayed_works)) {
+	pwq->nr_active--;
+	if (!list_empty(&pwq->delayed_works)) {
 		/* one down, submit a delayed one */
-		if (cwq->nr_active < cwq->max_active)
-			cwq_activate_first_delayed(cwq);
+		if (pwq->nr_active < pwq->max_active)
+			pwq_activate_first_delayed(pwq);
 	}
 
 	/* is flush in progress and are we at the flushing tip? */
-	if (likely(cwq->flush_color != color))
+	if (likely(pwq->flush_color != color))
 		return;
 
 	/* are there still in-flight works? */
-	if (cwq->nr_in_flight[color])
+	if (pwq->nr_in_flight[color])
 		return;
 
-	/* this cwq is done, clear flush_color */
-	cwq->flush_color = -1;
+	/* this pwq is done, clear flush_color */
+	pwq->flush_color = -1;
 
 	/*
-	 * If this was the last cwq, wake up the first flusher.  It
+	 * If this was the last pwq, wake up the first flusher.  It
 	 * will handle the rest.
 	 */
-	if (atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush))
-		complete(&cwq->wq->first_flusher->done);
+	if (atomic_dec_and_test(&pwq->wq->nr_pwqs_to_flush))
+		complete(&pwq->wq->first_flusher->done);
 }
 
 /**
@@ -1053,7 +1053,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			       unsigned long *flags)
 {
 	struct worker_pool *pool;
-	struct cpu_workqueue_struct *cwq;
+	struct pool_workqueue *pwq;
 
 	local_irq_save(*flags);
 
@@ -1084,31 +1084,31 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 
 	spin_lock(&pool->lock);
 	/*
-	 * work->data is guaranteed to point to cwq only while the work
-	 * item is queued on cwq->wq, and both updating work->data to point
-	 * to cwq on queueing and to pool on dequeueing are done under
-	 * cwq->pool->lock.  This in turn guarantees that, if work->data
-	 * points to cwq which is associated with a locked pool, the work
+	 * work->data is guaranteed to point to pwq only while the work
+	 * item is queued on pwq->wq, and both updating work->data to point
+	 * to pwq on queueing and to pool on dequeueing are done under
+	 * pwq->pool->lock.  This in turn guarantees that, if work->data
+	 * points to pwq which is associated with a locked pool, the work
 	 * item is currently queued on that pool.
 	 */
-	cwq = get_work_cwq(work);
-	if (cwq && cwq->pool == pool) {
+	pwq = get_work_pwq(work);
+	if (pwq && pwq->pool == pool) {
 		debug_work_deactivate(work);
 
 		/*
 		 * A delayed work item cannot be grabbed directly because
 		 * it might have linked NO_COLOR work items which, if left
-		 * on the delayed_list, will confuse cwq->nr_active
+		 * on the delayed_list, will confuse pwq->nr_active
 		 * management later on and cause stall.  Make sure the work
 		 * item is activated before grabbing.
 		 */
 		if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
-			cwq_activate_delayed_work(work);
+			pwq_activate_delayed_work(work);
 
 		list_del_init(&work->entry);
-		cwq_dec_nr_in_flight(get_work_cwq(work), get_work_color(work));
+		pwq_dec_nr_in_flight(get_work_pwq(work), get_work_color(work));
 
-		/* work->data points to cwq iff queued, point to pool */
+		/* work->data points to pwq iff queued, point to pool */
 		set_work_pool_and_keep_pending(work, pool->id);
 
 		spin_unlock(&pool->lock);
@@ -1125,25 +1125,24 @@ fail:
 
 /**
  * insert_work - insert a work into a pool
- * @cwq: cwq @work belongs to
+ * @pwq: pwq @work belongs to
  * @work: work to insert
  * @head: insertion point
  * @extra_flags: extra WORK_STRUCT_* flags to set
  *
- * Insert @work which belongs to @cwq after @head.  @extra_flags is or'd to
+ * Insert @work which belongs to @pwq after @head.  @extra_flags is or'd to
  * work_struct flags.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock).
  */
-static void insert_work(struct cpu_workqueue_struct *cwq,
-			struct work_struct *work, struct list_head *head,
-			unsigned int extra_flags)
+static void insert_work(struct pool_workqueue *pwq, struct work_struct *work,
+			struct list_head *head, unsigned int extra_flags)
 {
-	struct worker_pool *pool = cwq->pool;
+	struct worker_pool *pool = pwq->pool;
 
 	/* we own @work, set data and link */
-	set_work_cwq(work, cwq, extra_flags);
+	set_work_pwq(work, pwq, extra_flags);
 	list_add_tail(&work->entry, head);
 
 	/*
@@ -1168,8 +1167,8 @@ static bool is_chained_work(struct workqueue_struct *wq)
 	unsigned int cpu;
 
 	for_each_wq_cpu(cpu) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct worker_pool *pool = cwq->pool;
+		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+		struct worker_pool *pool = pwq->pool;
 		struct worker *worker;
 		struct hlist_node *pos;
 		int i;
@@ -1183,7 +1182,7 @@ static bool is_chained_work(struct workqueue_struct *wq)
 			 * I'm @worker, no locking necessary.  See if @work
 			 * is headed to the same workqueue.
 			 */
-			return worker->current_cwq->wq == wq;
+			return worker->current_pwq->wq == wq;
 		}
 		spin_unlock_irqrestore(&pool->lock, flags);
 	}
@@ -1193,7 +1192,7 @@ static bool is_chained_work(struct workqueue_struct *wq)
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq;
+	struct pool_workqueue *pwq;
 	struct list_head *worklist;
 	unsigned int work_flags;
 	unsigned int req_cpu = cpu;
@@ -1213,7 +1212,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
 
-	/* determine the cwq to use */
+	/* determine the pwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct worker_pool *last_pool;
 
@@ -1226,54 +1225,54 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		 * work needs to be queued on that cpu to guarantee
 		 * non-reentrancy.
 		 */
-		cwq = get_cwq(cpu, wq);
+		pwq = get_pwq(cpu, wq);
 		last_pool = get_work_pool(work);
 
-		if (last_pool && last_pool != cwq->pool) {
+		if (last_pool && last_pool != pwq->pool) {
 			struct worker *worker;
 
 			spin_lock(&last_pool->lock);
 
 			worker = find_worker_executing_work(last_pool, work);
 
-			if (worker && worker->current_cwq->wq == wq) {
-				cwq = get_cwq(last_pool->cpu, wq);
+			if (worker && worker->current_pwq->wq == wq) {
+				pwq = get_pwq(last_pool->cpu, wq);
 			} else {
 				/* meh... not running there, queue here */
 				spin_unlock(&last_pool->lock);
-				spin_lock(&cwq->pool->lock);
+				spin_lock(&pwq->pool->lock);
 			}
 		} else {
-			spin_lock(&cwq->pool->lock);
+			spin_lock(&pwq->pool->lock);
 		}
 	} else {
-		cwq = get_cwq(WORK_CPU_UNBOUND, wq);
-		spin_lock(&cwq->pool->lock);
+		pwq = get_pwq(WORK_CPU_UNBOUND, wq);
+		spin_lock(&pwq->pool->lock);
 	}
 
-	/* cwq determined, queue */
-	trace_workqueue_queue_work(req_cpu, cwq, work);
+	/* pwq determined, queue */
+	trace_workqueue_queue_work(req_cpu, pwq, work);
 
 	if (WARN_ON(!list_empty(&work->entry))) {
-		spin_unlock(&cwq->pool->lock);
+		spin_unlock(&pwq->pool->lock);
 		return;
 	}
 
-	cwq->nr_in_flight[cwq->work_color]++;
-	work_flags = work_color_to_flags(cwq->work_color);
+	pwq->nr_in_flight[pwq->work_color]++;
+	work_flags = work_color_to_flags(pwq->work_color);
 
-	if (likely(cwq->nr_active < cwq->max_active)) {
+	if (likely(pwq->nr_active < pwq->max_active)) {
 		trace_workqueue_activate_work(work);
-		cwq->nr_active++;
-		worklist = &cwq->pool->worklist;
+		pwq->nr_active++;
+		worklist = &pwq->pool->worklist;
 	} else {
 		work_flags |= WORK_STRUCT_DELAYED;
-		worklist = &cwq->delayed_works;
+		worklist = &pwq->delayed_works;
 	}
 
-	insert_work(cwq, work, worklist, work_flags);
+	insert_work(pwq, work, worklist, work_flags);
 
-	spin_unlock(&cwq->pool->lock);
+	spin_unlock(&pwq->pool->lock);
 }
 
 /**
@@ -1678,14 +1677,14 @@ static void rebind_workers(struct worker_pool *pool)
 
 		/*
 		 * wq doesn't really matter but let's keep @worker->pool
-		 * and @cwq->pool consistent for sanity.
+		 * and @pwq->pool consistent for sanity.
 		 */
 		if (std_worker_pool_pri(worker->pool))
 			wq = system_highpri_wq;
 		else
 			wq = system_wq;
 
-		insert_work(get_cwq(pool->cpu, wq), rebind_work,
+		insert_work(get_pwq(pool->cpu, wq), rebind_work,
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
@@ -1862,15 +1861,15 @@ static void idle_worker_timeout(unsigned long __pool)
 
 static bool send_mayday(struct work_struct *work)
 {
-	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
-	struct workqueue_struct *wq = cwq->wq;
+	struct pool_workqueue *pwq = get_work_pwq(work);
+	struct workqueue_struct *wq = pwq->wq;
 	unsigned int cpu;
 
 	if (!(wq->flags & WQ_RESCUER))
 		return false;
 
 	/* mayday mayday mayday */
-	cpu = cwq->pool->cpu;
+	cpu = pwq->pool->cpu;
 	/* WORK_CPU_UNBOUND can't be set in cpumask, use cpu 0 instead */
 	if (cpu == WORK_CPU_UNBOUND)
 		cpu = 0;
@@ -2099,9 +2098,9 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 __releases(&pool->lock)
 __acquires(&pool->lock)
 {
-	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
+	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct worker_pool *pool = worker->pool;
-	bool cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
+	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
 	int work_color;
 	struct worker *collision;
 #ifdef CONFIG_LOCKDEP
@@ -2142,7 +2141,7 @@ __acquires(&pool->lock)
 	hash_add(pool->busy_hash, &worker->hentry, (unsigned long)work);
 	worker->current_work = work;
 	worker->current_func = work->func;
-	worker->current_cwq = cwq;
+	worker->current_pwq = pwq;
 	work_color = get_work_color(work);
 
 	list_del_init(&work->entry);
@@ -2171,7 +2170,7 @@ __acquires(&pool->lock)
 
 	spin_unlock_irq(&pool->lock);
 
-	lock_map_acquire_read(&cwq->wq->lockdep_map);
+	lock_map_acquire_read(&pwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);
 	worker->current_func(work);
@@ -2181,7 +2180,7 @@ __acquires(&pool->lock)
 	 */
 	trace_workqueue_execute_end(work);
 	lock_map_release(&lockdep_map);
-	lock_map_release(&cwq->wq->lockdep_map);
+	lock_map_release(&pwq->wq->lockdep_map);
 
 	if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 		pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d\n"
@@ -2202,8 +2201,8 @@ __acquires(&pool->lock)
 	hash_del(&worker->hentry);
 	worker->current_work = NULL;
 	worker->current_func = NULL;
-	worker->current_cwq = NULL;
-	cwq_dec_nr_in_flight(cwq, work_color);
+	worker->current_pwq = NULL;
+	pwq_dec_nr_in_flight(pwq, work_color);
 }
 
 /**
@@ -2370,8 +2369,8 @@ repeat:
 	 */
 	for_each_mayday_cpu(cpu, wq->mayday_mask) {
 		unsigned int tcpu = is_unbound ? WORK_CPU_UNBOUND : cpu;
-		struct cpu_workqueue_struct *cwq = get_cwq(tcpu, wq);
-		struct worker_pool *pool = cwq->pool;
+		struct pool_workqueue *pwq = get_pwq(tcpu, wq);
+		struct worker_pool *pool = pwq->pool;
 		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
@@ -2387,7 +2386,7 @@ repeat:
 		 */
 		BUG_ON(!list_empty(&rescuer->scheduled));
 		list_for_each_entry_safe(work, n, &pool->worklist, entry)
-			if (get_work_cwq(work) == cwq)
+			if (get_work_pwq(work) == pwq)
 				move_linked_works(work, scheduled, &n);
 
 		process_scheduled_works(rescuer);
@@ -2422,7 +2421,7 @@ static void wq_barrier_func(struct work_struct *work)
 
 /**
  * insert_wq_barrier - insert a barrier work
- * @cwq: cwq to insert barrier into
+ * @pwq: pwq to insert barrier into
  * @barr: wq_barrier to insert
  * @target: target work to attach @barr to
  * @worker: worker currently executing @target, NULL if @target is not executing
@@ -2439,12 +2438,12 @@ static void wq_barrier_func(struct work_struct *work)
  * after a work with LINKED flag set.
  *
  * Note that when @worker is non-NULL, @target may be modified
- * underneath us, so we can't reliably determine cwq from @target.
+ * underneath us, so we can't reliably determine pwq from @target.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock).
  */
-static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
+static void insert_wq_barrier(struct pool_workqueue *pwq,
 			      struct wq_barrier *barr,
 			      struct work_struct *target, struct worker *worker)
 {
@@ -2477,23 +2476,23 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	}
 
 	debug_work_activate(&barr->work);
-	insert_work(cwq, &barr->work, head,
+	insert_work(pwq, &barr->work, head,
 		    work_color_to_flags(WORK_NO_COLOR) | linked);
 }
 
 /**
- * flush_workqueue_prep_cwqs - prepare cwqs for workqueue flushing
+ * flush_workqueue_prep_pwqs - prepare pwqs for workqueue flushing
  * @wq: workqueue being flushed
  * @flush_color: new flush color, < 0 for no-op
  * @work_color: new work color, < 0 for no-op
  *
- * Prepare cwqs for workqueue flushing.
+ * Prepare pwqs for workqueue flushing.
  *
- * If @flush_color is non-negative, flush_color on all cwqs should be
- * -1.  If no cwq has in-flight commands at the specified color, all
- * cwq->flush_color's stay at -1 and %false is returned.  If any cwq
- * has in flight commands, its cwq->flush_color is set to
- * @flush_color, @wq->nr_cwqs_to_flush is updated accordingly, cwq
+ * If @flush_color is non-negative, flush_color on all pwqs should be
+ * -1.  If no pwq has in-flight commands at the specified color, all
+ * pwq->flush_color's stay at -1 and %false is returned.  If any pwq
+ * has in flight commands, its pwq->flush_color is set to
+ * @flush_color, @wq->nr_pwqs_to_flush is updated accordingly, pwq
  * wakeup logic is armed and %true is returned.
  *
  * The caller should have initialized @wq->first_flusher prior to
@@ -2501,7 +2500,7 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
  * @flush_color is negative, no flush color update is done and %false
  * is returned.
  *
- * If @work_color is non-negative, all cwqs should have the same
+ * If @work_color is non-negative, all pwqs should have the same
  * work_color which is previous to @work_color and all will be
  * advanced to @work_color.
  *
@@ -2512,42 +2511,42 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
  * %true if @flush_color >= 0 and there's something to flush.  %false
  * otherwise.
  */
-static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
+static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
 				      int flush_color, int work_color)
 {
 	bool wait = false;
 	unsigned int cpu;
 
 	if (flush_color >= 0) {
-		BUG_ON(atomic_read(&wq->nr_cwqs_to_flush));
-		atomic_set(&wq->nr_cwqs_to_flush, 1);
+		BUG_ON(atomic_read(&wq->nr_pwqs_to_flush));
+		atomic_set(&wq->nr_pwqs_to_flush, 1);
 	}
 
-	for_each_cwq_cpu(cpu, wq) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct worker_pool *pool = cwq->pool;
+	for_each_pwq_cpu(cpu, wq) {
+		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+		struct worker_pool *pool = pwq->pool;
 
 		spin_lock_irq(&pool->lock);
 
 		if (flush_color >= 0) {
-			BUG_ON(cwq->flush_color != -1);
+			BUG_ON(pwq->flush_color != -1);
 
-			if (cwq->nr_in_flight[flush_color]) {
-				cwq->flush_color = flush_color;
-				atomic_inc(&wq->nr_cwqs_to_flush);
+			if (pwq->nr_in_flight[flush_color]) {
+				pwq->flush_color = flush_color;
+				atomic_inc(&wq->nr_pwqs_to_flush);
 				wait = true;
 			}
 		}
 
 		if (work_color >= 0) {
-			BUG_ON(work_color != work_next_color(cwq->work_color));
-			cwq->work_color = work_color;
+			BUG_ON(work_color != work_next_color(pwq->work_color));
+			pwq->work_color = work_color;
 		}
 
 		spin_unlock_irq(&pool->lock);
 	}
 
-	if (flush_color >= 0 && atomic_dec_and_test(&wq->nr_cwqs_to_flush))
+	if (flush_color >= 0 && atomic_dec_and_test(&wq->nr_pwqs_to_flush))
 		complete(&wq->first_flusher->done);
 
 	return wait;
@@ -2598,7 +2597,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 			wq->first_flusher = &this_flusher;
 
-			if (!flush_workqueue_prep_cwqs(wq, wq->flush_color,
+			if (!flush_workqueue_prep_pwqs(wq, wq->flush_color,
 						       wq->work_color)) {
 				/* nothing to flush, done */
 				wq->flush_color = next_color;
@@ -2609,7 +2608,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 			/* wait in queue */
 			BUG_ON(wq->flush_color == this_flusher.flush_color);
 			list_add_tail(&this_flusher.list, &wq->flusher_queue);
-			flush_workqueue_prep_cwqs(wq, -1, wq->work_color);
+			flush_workqueue_prep_pwqs(wq, -1, wq->work_color);
 		}
 	} else {
 		/*
@@ -2676,7 +2675,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 			list_splice_tail_init(&wq->flusher_overflow,
 					      &wq->flusher_queue);
-			flush_workqueue_prep_cwqs(wq, -1, wq->work_color);
+			flush_workqueue_prep_pwqs(wq, -1, wq->work_color);
 		}
 
 		if (list_empty(&wq->flusher_queue)) {
@@ -2686,7 +2685,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 
 		/*
 		 * Need to flush more colors.  Make the next flusher
-		 * the new first flusher and arm cwqs.
+		 * the new first flusher and arm pwqs.
 		 */
 		BUG_ON(wq->flush_color == wq->work_color);
 		BUG_ON(wq->flush_color != next->flush_color);
@@ -2694,7 +2693,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 		list_del_init(&next->list);
 		wq->first_flusher = next;
 
-		if (flush_workqueue_prep_cwqs(wq, wq->flush_color, -1))
+		if (flush_workqueue_prep_pwqs(wq, wq->flush_color, -1))
 			break;
 
 		/*
@@ -2737,13 +2736,13 @@ void drain_workqueue(struct workqueue_struct *wq)
 reflush:
 	flush_workqueue(wq);
 
-	for_each_cwq_cpu(cpu, wq) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+	for_each_pwq_cpu(cpu, wq) {
+		struct pool_workqueue *pwq = get_pwq(cpu, wq);
 		bool drained;
 
-		spin_lock_irq(&cwq->pool->lock);
-		drained = !cwq->nr_active && list_empty(&cwq->delayed_works);
-		spin_unlock_irq(&cwq->pool->lock);
+		spin_lock_irq(&pwq->pool->lock);
+		drained = !pwq->nr_active && list_empty(&pwq->delayed_works);
+		spin_unlock_irq(&pwq->pool->lock);
 
 		if (drained)
 			continue;
@@ -2766,7 +2765,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 {
 	struct worker *worker = NULL;
 	struct worker_pool *pool;
-	struct cpu_workqueue_struct *cwq;
+	struct pool_workqueue *pwq;
 
 	might_sleep();
 	pool = get_work_pool(work);
@@ -2775,18 +2774,18 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 
 	spin_lock_irq(&pool->lock);
 	/* see the comment in try_to_grab_pending() with the same code */
-	cwq = get_work_cwq(work);
-	if (cwq) {
-		if (unlikely(cwq->pool != pool))
+	pwq = get_work_pwq(work);
+	if (pwq) {
+		if (unlikely(pwq->pool != pool))
 			goto already_gone;
 	} else {
 		worker = find_worker_executing_work(pool, work);
 		if (!worker)
 			goto already_gone;
-		cwq = worker->current_cwq;
+		pwq = worker->current_pwq;
 	}
 
-	insert_wq_barrier(cwq, barr, work, worker);
+	insert_wq_barrier(pwq, barr, work, worker);
 	spin_unlock_irq(&pool->lock);
 
 	/*
@@ -2795,11 +2794,11 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 	 * flusher is not running on the same workqueue by verifying write
 	 * access.
 	 */
-	if (cwq->wq->saved_max_active == 1 || cwq->wq->flags & WQ_RESCUER)
-		lock_map_acquire(&cwq->wq->lockdep_map);
+	if (pwq->wq->saved_max_active == 1 || pwq->wq->flags & WQ_RESCUER)
+		lock_map_acquire(&pwq->wq->lockdep_map);
 	else
-		lock_map_acquire_read(&cwq->wq->lockdep_map);
-	lock_map_release(&cwq->wq->lockdep_map);
+		lock_map_acquire_read(&pwq->wq->lockdep_map);
+	lock_map_release(&pwq->wq->lockdep_map);
 
 	return true;
 already_gone:
@@ -3109,46 +3108,46 @@ int keventd_up(void)
 	return system_wq != NULL;
 }
 
-static int alloc_cwqs(struct workqueue_struct *wq)
+static int alloc_pwqs(struct workqueue_struct *wq)
 {
 	/*
-	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
+	 * pwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
 	 * Make sure that the alignment isn't lower than that of
 	 * unsigned long long.
 	 */
-	const size_t size = sizeof(struct cpu_workqueue_struct);
+	const size_t size = sizeof(struct pool_workqueue);
 	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
 				   __alignof__(unsigned long long));
 
 	if (!(wq->flags & WQ_UNBOUND))
-		wq->cpu_wq.pcpu = __alloc_percpu(size, align);
+		wq->pool_wq.pcpu = __alloc_percpu(size, align);
 	else {
 		void *ptr;
 
 		/*
-		 * Allocate enough room to align cwq and put an extra
+		 * Allocate enough room to align pwq and put an extra
 		 * pointer at the end pointing back to the originally
 		 * allocated pointer which will be used for free.
 		 */
 		ptr = kzalloc(size + align + sizeof(void *), GFP_KERNEL);
 		if (ptr) {
-			wq->cpu_wq.single = PTR_ALIGN(ptr, align);
-			*(void **)(wq->cpu_wq.single + 1) = ptr;
+			wq->pool_wq.single = PTR_ALIGN(ptr, align);
+			*(void **)(wq->pool_wq.single + 1) = ptr;
 		}
 	}
 
 	/* just in case, make sure it's actually aligned */
-	BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
-	return wq->cpu_wq.v ? 0 : -ENOMEM;
+	BUG_ON(!IS_ALIGNED(wq->pool_wq.v, align));
+	return wq->pool_wq.v ? 0 : -ENOMEM;
 }
 
-static void free_cwqs(struct workqueue_struct *wq)
+static void free_pwqs(struct workqueue_struct *wq)
 {
 	if (!(wq->flags & WQ_UNBOUND))
-		free_percpu(wq->cpu_wq.pcpu);
-	else if (wq->cpu_wq.single) {
-		/* the pointer to free is stored right after the cwq */
-		kfree(*(void **)(wq->cpu_wq.single + 1));
+		free_percpu(wq->pool_wq.pcpu);
+	else if (wq->pool_wq.single) {
+		/* the pointer to free is stored right after the pwq */
+		kfree(*(void **)(wq->pool_wq.single + 1));
 	}
 }
 
@@ -3202,25 +3201,25 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	wq->flags = flags;
 	wq->saved_max_active = max_active;
 	mutex_init(&wq->flush_mutex);
-	atomic_set(&wq->nr_cwqs_to_flush, 0);
+	atomic_set(&wq->nr_pwqs_to_flush, 0);
 	INIT_LIST_HEAD(&wq->flusher_queue);
 	INIT_LIST_HEAD(&wq->flusher_overflow);
 
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
 
-	if (alloc_cwqs(wq) < 0)
+	if (alloc_pwqs(wq) < 0)
 		goto err;
 
-	for_each_cwq_cpu(cpu, wq) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+	for_each_pwq_cpu(cpu, wq) {
+		struct pool_workqueue *pwq = get_pwq(cpu, wq);
 
-		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
-		cwq->pool = get_std_worker_pool(cpu, flags & WQ_HIGHPRI);
-		cwq->wq = wq;
-		cwq->flush_color = -1;
-		cwq->max_active = max_active;
-		INIT_LIST_HEAD(&cwq->delayed_works);
+		BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
+		pwq->pool = get_std_worker_pool(cpu, flags & WQ_HIGHPRI);
+		pwq->wq = wq;
+		pwq->flush_color = -1;
+		pwq->max_active = max_active;
+		INIT_LIST_HEAD(&pwq->delayed_works);
 	}
 
 	if (flags & WQ_RESCUER) {
@@ -3251,8 +3250,8 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	spin_lock(&workqueue_lock);
 
 	if (workqueue_freezing && wq->flags & WQ_FREEZABLE)
-		for_each_cwq_cpu(cpu, wq)
-			get_cwq(cpu, wq)->max_active = 0;
+		for_each_pwq_cpu(cpu, wq)
+			get_pwq(cpu, wq)->max_active = 0;
 
 	list_add(&wq->list, &workqueues);
 
@@ -3261,7 +3260,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	return wq;
 err:
 	if (wq) {
-		free_cwqs(wq);
+		free_pwqs(wq);
 		free_mayday_mask(wq->mayday_mask);
 		kfree(wq->rescuer);
 		kfree(wq);
@@ -3292,14 +3291,14 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	spin_unlock(&workqueue_lock);
 
 	/* sanity check */
-	for_each_cwq_cpu(cpu, wq) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+	for_each_pwq_cpu(cpu, wq) {
+		struct pool_workqueue *pwq = get_pwq(cpu, wq);
 		int i;
 
 		for (i = 0; i < WORK_NR_COLORS; i++)
-			BUG_ON(cwq->nr_in_flight[i]);
-		BUG_ON(cwq->nr_active);
-		BUG_ON(!list_empty(&cwq->delayed_works));
+			BUG_ON(pwq->nr_in_flight[i]);
+		BUG_ON(pwq->nr_active);
+		BUG_ON(!list_empty(&pwq->delayed_works));
 	}
 
 	if (wq->flags & WQ_RESCUER) {
@@ -3308,29 +3307,29 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		kfree(wq->rescuer);
 	}
 
-	free_cwqs(wq);
+	free_pwqs(wq);
 	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
 /**
- * cwq_set_max_active - adjust max_active of a cwq
- * @cwq: target cpu_workqueue_struct
+ * pwq_set_max_active - adjust max_active of a pwq
+ * @pwq: target pool_workqueue
  * @max_active: new max_active value.
  *
- * Set @cwq->max_active to @max_active and activate delayed works if
+ * Set @pwq->max_active to @max_active and activate delayed works if
  * increased.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock).
  */
-static void cwq_set_max_active(struct cpu_workqueue_struct *cwq, int max_active)
+static void pwq_set_max_active(struct pool_workqueue *pwq, int max_active)
 {
-	cwq->max_active = max_active;
+	pwq->max_active = max_active;
 
-	while (!list_empty(&cwq->delayed_works) &&
-	       cwq->nr_active < cwq->max_active)
-		cwq_activate_first_delayed(cwq);
+	while (!list_empty(&pwq->delayed_works) &&
+	       pwq->nr_active < pwq->max_active)
+		pwq_activate_first_delayed(pwq);
 }
 
 /**
@@ -3353,15 +3352,15 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 
 	wq->saved_max_active = max_active;
 
-	for_each_cwq_cpu(cpu, wq) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct worker_pool *pool = cwq->pool;
+	for_each_pwq_cpu(cpu, wq) {
+		struct pool_workqueue *pwq = get_pwq(cpu, wq);
+		struct worker_pool *pool = pwq->pool;
 
 		spin_lock_irq(&pool->lock);
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
 		    !(pool->flags & POOL_FREEZING))
-			cwq_set_max_active(cwq, max_active);
+			pwq_set_max_active(pwq, max_active);
 
 		spin_unlock_irq(&pool->lock);
 	}
@@ -3384,9 +3383,9 @@ EXPORT_SYMBOL_GPL(workqueue_set_max_active);
  */
 bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq)
 {
-	struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+	struct pool_workqueue *pwq = get_pwq(cpu, wq);
 
-	return !list_empty(&cwq->delayed_works);
+	return !list_empty(&pwq->delayed_works);
 }
 EXPORT_SYMBOL_GPL(workqueue_congested);
 
@@ -3425,7 +3424,7 @@ EXPORT_SYMBOL_GPL(work_busy);
  * CPU hotplug.
  *
  * There are two challenges in supporting CPU hotplug.  Firstly, there
- * are a lot of assumptions on strong associations among work, cwq and
+ * are a lot of assumptions on strong associations among work, pwq and
  * pool which make migrating pending and scheduled works very
  * difficult to implement without impacting hot paths.  Secondly,
  * worker pools serve mix of short, long and very long running works making
@@ -3629,11 +3628,11 @@ void freeze_workqueues_begin(void)
 			pool->flags |= POOL_FREEZING;
 
 			list_for_each_entry(wq, &workqueues, list) {
-				struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+				struct pool_workqueue *pwq = get_pwq(cpu, wq);
 
-				if (cwq && cwq->pool == pool &&
+				if (pwq && pwq->pool == pool &&
 				    (wq->flags & WQ_FREEZABLE))
-					cwq->max_active = 0;
+					pwq->max_active = 0;
 			}
 
 			spin_unlock_irq(&pool->lock);
@@ -3672,13 +3671,13 @@ bool freeze_workqueues_busy(void)
 		 * to peek without lock.
 		 */
 		list_for_each_entry(wq, &workqueues, list) {
-			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+			struct pool_workqueue *pwq = get_pwq(cpu, wq);
 
-			if (!cwq || !(wq->flags & WQ_FREEZABLE))
+			if (!pwq || !(wq->flags & WQ_FREEZABLE))
 				continue;
 
-			BUG_ON(cwq->nr_active < 0);
-			if (cwq->nr_active) {
+			BUG_ON(pwq->nr_active < 0);
+			if (pwq->nr_active) {
 				busy = true;
 				goto out_unlock;
 			}
@@ -3718,14 +3717,14 @@ void thaw_workqueues(void)
 			pool->flags &= ~POOL_FREEZING;
 
 			list_for_each_entry(wq, &workqueues, list) {
-				struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+				struct pool_workqueue *pwq = get_pwq(cpu, wq);
 
-				if (!cwq || cwq->pool != pool ||
+				if (!pwq || pwq->pool != pool ||
 				    !(wq->flags & WQ_FREEZABLE))
 					continue;
 
 				/* restore max_active and repopulate worklist */
-				cwq_set_max_active(cwq, wq->saved_max_active);
+				pwq_set_max_active(pwq, wq->saved_max_active);
 			}
 
 			wake_up_worker(pool);
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 328be4a..0765026 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -28,7 +28,7 @@ struct worker {
 
 	struct work_struct	*current_work;	/* L: work being processed */
 	work_func_t		current_func;	/* L: current_work's fn */
-	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
+	struct pool_workqueue	*current_pwq; /* L: current_work's pwq */
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
-- 
1.8.1

