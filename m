Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3BDO6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:58:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:44313 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BDO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:58:29 -0500
Date: Mon, 4 Feb 2013 15:58:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.11-rt26
Message-ID: <alpine.LFD.2.02.1302041537230.11905@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.11-rt26 release.

Changes since 3.6.11-rt25:

   1) Fix the RT highmem implementation on x86

   2) Support highmem + RT on ARM

   3) Fix an one off error in the generic highmem code (upstream fix
      did not make it into 3.6.stable)

   4) Upstream SLUB fixes (Christoph Lameter)

   5) Fix a few RT issues in mmc and amba drivers

   6) Initialize local locks in mm/swap.c early

   7) Use simple wait queues for completions. This is a performance
      improvement.

      Completions do not have complex callbacks and the wakeup path is
      disabling interrupts anyway. So using simple wait locks with the
      raw spinlock is not a latency problem, but the "sleeping lock"
      in the normal waitqueue is a source for lock bouncing:

      T1  	 	   T2
      lock(WQ)
      wakeup(T2)
      ---> preemption
			   lock(WQ)
			   pi_boost(T1)
			   wait_for_lock(WQ)
      unlock(WQ)
      deboost(T1)
      ---> preemption
			   ....

      The simple waitqueue reduces this to:
		   
      T1  	 	   T2
      raw_lock(WQ)
      wakeup(T2)
      raw_unlock(WQ)
      ---> preemption
			   raw_lock(WQ)	
			   ....

@Steven: Sorry, I forgot the stable tags on:
	 drivers-tty-pl011-irq-disable-madness.patch
	 mmci-remove-bogus-irq-save.patch
	 idle-state.patch
	 might-sleep-check-for-idle.patch
	 mm-swap-fix-initialization.patch

I'm still digging through my mail backlog, so I have not yet decided
whether this is the last RT release for 3.6.


The delta patch against 3.6.11-rt25 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11-rt25-rt26.patch.xz

The RT patch against 3.6.11 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-rt26.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11-rt26.tar.xz

Enjoy,

	tglx

------------->
Index: linux-stable/arch/arm/Kconfig
===================================================================
--- linux-stable.orig/arch/arm/Kconfig
+++ linux-stable/arch/arm/Kconfig
@@ -1749,7 +1749,7 @@ config HAVE_ARCH_PFN_VALID
 
 config HIGHMEM
 	bool "High Memory Support"
-	depends on MMU && !PREEMPT_RT_FULL
+	depends on MMU
 	help
 	  The address space of ARM processors is only 4 Gigabytes large
 	  and it has to accommodate user address space, kernel address
Index: linux-stable/arch/x86/mm/highmem_32.c
===================================================================
--- linux-stable.orig/arch/x86/mm/highmem_32.c
+++ linux-stable/arch/x86/mm/highmem_32.c
@@ -21,6 +21,7 @@ void kunmap(struct page *page)
 }
 EXPORT_SYMBOL(kunmap);
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * kmap_atomic/kunmap_atomic is significantly faster than kmap/kunmap because
  * no global lock is needed and because the kmap code must perform a global TLB
@@ -115,6 +116,7 @@ struct page *kmap_atomic_to_page(void *p
 	return pte_page(*pte);
 }
 EXPORT_SYMBOL(kmap_atomic_to_page);
+#endif
 
 void __init set_highmem_pages_init(void)
 {
Index: linux-stable/include/linux/wait-simple.h
===================================================================
--- linux-stable.orig/include/linux/wait-simple.h
+++ linux-stable/include/linux/wait-simple.h
@@ -22,12 +22,14 @@ struct swait_head {
 	struct list_head	list;
 };
 
-#define DEFINE_SWAIT_HEAD(name)					\
-	struct swait_head name = {				\
+#define SWAIT_HEAD_INITIALIZER(name) {				\
 		.lock	= __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
 		.list	= LIST_HEAD_INIT((name).list),		\
 	}
 
+#define DEFINE_SWAIT_HEAD(name)					\
+	struct swait_head name = SWAIT_HEAD_INITIALIZER(name)
+
 extern void __init_swait_head(struct swait_head *h, struct lock_class_key *key);
 
 #define init_swait_head(swh)					\
@@ -40,59 +42,25 @@ extern void __init_swait_head(struct swa
 /*
  * Waiter functions
  */
-static inline bool swaiter_enqueued(struct swaiter *w)
-{
-	return w->task != NULL;
-}
-
+extern void swait_prepare_locked(struct swait_head *head, struct swaiter *w);
 extern void swait_prepare(struct swait_head *head, struct swaiter *w, int state);
+extern void swait_finish_locked(struct swait_head *head, struct swaiter *w);
 extern void swait_finish(struct swait_head *head, struct swaiter *w);
 
 /*
- * Adds w to head->list. Must be called with head->lock locked.
- */
-static inline void __swait_enqueue(struct swait_head *head, struct swaiter *w)
-{
-	list_add(&w->node, &head->list);
-}
-
-/*
- * Removes w from head->list. Must be called with head->lock locked.
- */
-static inline void __swait_dequeue(struct swaiter *w)
-{
-	list_del_init(&w->node);
-}
-
-/*
- * Check whether a head has waiters enqueued
- */
-static inline bool swait_head_has_waiters(struct swait_head *h)
-{
-	return !list_empty(&h->list);
-}
-
-/*
  * Wakeup functions
  */
-extern int __swait_wake(struct swait_head *head, unsigned int state);
+extern unsigned int __swait_wake(struct swait_head *head, unsigned int state, unsigned int num);
+extern unsigned int __swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int num);
 
-static inline int swait_wake(struct swait_head *head)
-{
-	return swait_head_has_waiters(head) ?
-		__swait_wake(head, TASK_NORMAL) : 0;
-}
-
-static inline int swait_wake_interruptible(struct swait_head *head)
-{
-	return swait_head_has_waiters(head) ?
-		__swait_wake(head, TASK_INTERRUPTIBLE) : 0;
-}
+#define swait_wake(head)			__swait_wake(head, TASK_NORMAL, 1)
+#define swait_wake_interruptible(head)		__swait_wake(head, TASK_INTERRUPTIBLE, 1)
+#define swait_wake_all(head)			__swait_wake(head, TASK_NORMAL, 0)
+#define swait_wake_all_interruptible(head)	__swait_wake(head, TASK_INTERRUPTIBLE, 0)
 
 /*
  * Event API
  */
-
 #define __swait_event(wq, condition)					\
 do {									\
 	DEFINE_SWAITER(__wait);						\
Index: linux-stable/kernel/sched/core.c
===================================================================
--- linux-stable.orig/kernel/sched/core.c
+++ linux-stable/kernel/sched/core.c
@@ -3959,10 +3959,10 @@ void complete(struct completion *x)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
-	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	__swait_wake_locked(&x->wait, TASK_NORMAL, 1);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
 
@@ -3979,10 +3979,10 @@ void complete_all(struct completion *x)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
-	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	__swait_wake_locked(&x->wait, TASK_NORMAL, 0);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
 
@@ -3990,20 +3990,20 @@ static inline long __sched
 do_wait_for_common(struct completion *x, long timeout, int state)
 {
 	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
+		DEFINE_SWAITER(wait);
 
-		__add_wait_queue_tail_exclusive(&x->wait, &wait);
+		swait_prepare_locked(&x->wait, &wait);
 		do {
 			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
 				break;
 			}
 			__set_current_state(state);
-			spin_unlock_irq(&x->wait.lock);
+			raw_spin_unlock_irq(&x->wait.lock);
 			timeout = schedule_timeout(timeout);
-			spin_lock_irq(&x->wait.lock);
+			raw_spin_lock_irq(&x->wait.lock);
 		} while (!x->done && timeout);
-		__remove_wait_queue(&x->wait, &wait);
+		swait_finish_locked(&x->wait, &wait);
 		if (!x->done)
 			return timeout;
 	}
@@ -4016,9 +4016,9 @@ wait_for_common(struct completion *x, lo
 {
 	might_sleep();
 
-	spin_lock_irq(&x->wait.lock);
+	raw_spin_lock_irq(&x->wait.lock);
 	timeout = do_wait_for_common(x, timeout, state);
-	spin_unlock_irq(&x->wait.lock);
+	raw_spin_unlock_irq(&x->wait.lock);
 	return timeout;
 }
 
@@ -4149,12 +4149,12 @@ bool try_wait_for_completion(struct comp
 	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
 	else
 		x->done--;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(try_wait_for_completion);
@@ -4172,10 +4172,10 @@ bool completion_done(struct completion *
 	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irqsave(&x->wait.lock, flags);
+	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
+	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(completion_done);
@@ -5410,6 +5410,7 @@ void __cpuinit init_idle(struct task_str
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
+	idle->on_rq = 1;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
@@ -7782,7 +7783,8 @@ void __might_sleep(const char *file, int
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
-	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
+	     !is_idle_task(current)) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
Index: linux-stable/kernel/wait-simple.c
===================================================================
--- linux-stable.orig/kernel/wait-simple.c
+++ linux-stable/kernel/wait-simple.c
@@ -12,6 +12,24 @@
 #include <linux/sched.h>
 #include <linux/wait-simple.h>
 
+/* Adds w to head->list. Must be called with head->lock locked. */
+static inline void __swait_enqueue(struct swait_head *head, struct swaiter *w)
+{
+	list_add(&w->node, &head->list);
+}
+
+/* Removes w from head->list. Must be called with head->lock locked. */
+static inline void __swait_dequeue(struct swaiter *w)
+{
+	list_del_init(&w->node);
+}
+
+/* Check whether a head has waiters enqueued */
+static inline bool swait_head_has_waiters(struct swait_head *h)
+{
+	return !list_empty(&h->list);
+}
+
 void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
 {
 	raw_spin_lock_init(&head->lock);
@@ -20,19 +38,31 @@ void __init_swait_head(struct swait_head
 }
 EXPORT_SYMBOL_GPL(__init_swait_head);
 
+void swait_prepare_locked(struct swait_head *head, struct swaiter *w)
+{
+	w->task = current;
+	if (list_empty(&w->node))
+		__swait_enqueue(head, w);
+}
+
 void swait_prepare(struct swait_head *head, struct swaiter *w, int state)
 {
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&head->lock, flags);
-	w->task = current;
-	if (list_empty(&w->node))
-		__swait_enqueue(head, w);
-	set_current_state(state);
+	swait_prepare_locked(head, w);
+	__set_current_state(state);
 	raw_spin_unlock_irqrestore(&head->lock, flags);
 }
 EXPORT_SYMBOL_GPL(swait_prepare);
 
+void swait_finish_locked(struct swait_head *head, struct swaiter *w)
+{
+	__set_current_state(TASK_RUNNING);
+	if (w->task)
+		__swait_dequeue(w);
+}
+
 void swait_finish(struct swait_head *head, struct swaiter *w)
 {
 	unsigned long flags;
@@ -46,22 +76,43 @@ void swait_finish(struct swait_head *hea
 }
 EXPORT_SYMBOL_GPL(swait_finish);
 
-int __swait_wake(struct swait_head *head, unsigned int state)
+unsigned int
+__swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int num)
 {
 	struct swaiter *curr, *next;
-	unsigned long flags;
 	int woken = 0;
 
-	raw_spin_lock_irqsave(&head->lock, flags);
-
 	list_for_each_entry_safe(curr, next, &head->list, node) {
 		if (wake_up_state(curr->task, state)) {
 			__swait_dequeue(curr);
+			/*
+			 * The waiting task can free the waiter as
+			 * soon as curr->task = NULL is written,
+			 * without taking any locks. A memory barrier
+			 * is required here to prevent the following
+			 * store to curr->task from getting ahead of
+			 * the dequeue operation.
+			 */
+			smp_wmb();
 			curr->task = NULL;
-			woken++;
+			if (++woken == num)
+				break;
 		}
 	}
+	return woken;
+}
+
+unsigned int
+__swait_wake(struct swait_head *head, unsigned int state, unsigned int num)
+{
+	unsigned long flags;
+	int woken;
 
+	if (!swait_head_has_waiters(head))
+		return 0;
+
+	raw_spin_lock_irqsave(&head->lock, flags);
+	woken = __swait_wake_locked(head, state, num);
 	raw_spin_unlock_irqrestore(&head->lock, flags);
 	return woken;
 }
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt25
+-rt26
Index: linux-stable/mm/memory.c
===================================================================
--- linux-stable.orig/mm/memory.c
+++ linux-stable/mm/memory.c
@@ -3495,7 +3495,7 @@ void pagefault_disable(void)
 	 */
 	barrier();
 }
-EXPORT_SYMBOL_GPL(pagefault_disable);
+EXPORT_SYMBOL(pagefault_disable);
 
 void pagefault_enable(void)
 {
@@ -3507,7 +3507,7 @@ void pagefault_enable(void)
 	current->pagefault_disabled--;
 	migrate_enable();
 }
-EXPORT_SYMBOL_GPL(pagefault_enable);
+EXPORT_SYMBOL(pagefault_enable);
 #endif
 
 /*
Index: linux-stable/mm/slub.c
===================================================================
--- linux-stable.orig/mm/slub.c
+++ linux-stable/mm/slub.c
@@ -1280,14 +1280,15 @@ static struct page *allocate_slab(struct
 	struct page *page;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
+	bool enableirqs;
 
 	flags &= gfp_allowed_mask;
 
+	enableirqs = (flags & __GFP_WAIT) != 0;
 #ifdef CONFIG_PREEMPT_RT_FULL
-	if (system_state == SYSTEM_RUNNING)
-#else
-	if (flags & __GFP_WAIT)
+	enableirqs |= system_state == SYSTEM_RUNNING;
 #endif
+	if (enableirqs)
 		local_irq_enable();
 
 	flags |= s->allocflags;
@@ -1327,11 +1328,7 @@ static struct page *allocate_slab(struct
 			kmemcheck_mark_unallocated_pages(page, pages);
 	}
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-	if (system_state == SYSTEM_RUNNING)
-#else
-	if (flags & __GFP_WAIT)
-#endif
+	if (enableirqs)
 		local_irq_disable();
 	if (!page)
 		return NULL;
@@ -2085,7 +2082,7 @@ static void flush_all(struct kmem_cache 
 static inline int node_match(struct page *page, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && page_to_nid(page) != node)
+	if (!page || (node != NUMA_NO_NODE && page_to_nid(page) != node))
 		return 0;
 #endif
 	return 1;
@@ -2379,13 +2376,18 @@ static __always_inline void *slab_alloc(
 		return NULL;
 
 redo:
-
 	/*
 	 * Must read kmem_cache cpu data via this cpu ptr. Preemption is
 	 * enabled. We may switch back and forth between cpus while
 	 * reading from one cpu area. That does not matter as long
 	 * as we end up on the original cpu again when doing the cmpxchg.
+	 *
+	 * Preemption is disabled for the retrieval of the tid because that
+	 * must occur from the current processor. We cannot allow rescheduling
+	 * on a different processor between the determination of the pointer
+	 * and the retrieval of the tid.
 	 */
+	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	/*
@@ -2395,7 +2397,7 @@ redo:
 	 * linked list in between.
 	 */
 	tid = c->tid;
-	barrier();
+	preempt_enable();
 
 	object = c->freelist;
 	page = c->page;
@@ -2641,10 +2643,11 @@ redo:
 	 * data is retrieved via this pointer. If we are on the same cpu
 	 * during the cmpxchg then the free will succedd.
 	 */
+	preempt_disable();
 	c = __this_cpu_ptr(s->cpu_slab);
 
 	tid = c->tid;
-	barrier();
+	preempt_enable();
 
 	if (likely(page == c->page)) {
 		set_freepointer(s, object, c->freelist);
Index: linux-stable/mm/swap.c
===================================================================
--- linux-stable.orig/mm/swap.c
+++ linux-stable/mm/swap.c
@@ -846,6 +846,15 @@ unsigned pagevec_lookup_tag(struct pagev
 }
 EXPORT_SYMBOL(pagevec_lookup_tag);
 
+/* Early setup for the local locks */
+static int __init swap_init_locks(void)
+{
+	local_irq_lock_init(rotate_lock);
+	local_irq_lock_init(swap_lock);
+	return 1;
+}
+early_initcall(swap_init_locks);
+
 /*
  * Perform any setup for the swap system
  */
@@ -853,9 +862,6 @@ void __init swap_setup(void)
 {
 	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
 
-	local_irq_lock_init(rotate_lock);
-	local_irq_lock_init(swap_lock);
-
 #ifdef CONFIG_SWAP
 	bdi_init(swapper_space.backing_dev_info);
 #endif
Index: linux-stable/mm/highmem.c
===================================================================
--- linux-stable.orig/mm/highmem.c
+++ linux-stable/mm/highmem.c
@@ -98,7 +98,7 @@ struct page *kmap_to_page(void *vaddr)
 {
 	unsigned long addr = (unsigned long)vaddr;
 
-	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
 		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
 		return pte_page(pkmap_page_table[i]);
 	}
@@ -157,7 +157,7 @@ void kmap_flush_unused(void)
 	unlock_kmap();
 }
 
-static inline unsigned long map_new_virtual(struct page *page)
+static inline unsigned long map_new_virtual(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 	int count;
@@ -199,7 +199,7 @@ start:
 	}
 	vaddr = PKMAP_ADDR(last_pkmap_nr);
 	set_pte_at(&init_mm, vaddr,
-		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, kmap_prot));
+		   &(pkmap_page_table[last_pkmap_nr]), mk_pte(page, prot));
 
 	pkmap_count[last_pkmap_nr] = 1;
 	set_page_address(page, (void *)vaddr);
@@ -215,7 +215,7 @@ start:
  *
  * We cannot call this from interrupts, as it may block.
  */
-void *kmap_high(struct page *page)
+void *kmap_high_prot(struct page *page, pgprot_t prot)
 {
 	unsigned long vaddr;
 
@@ -226,13 +226,26 @@ void *kmap_high(struct page *page)
 	lock_kmap();
 	vaddr = (unsigned long)page_address(page);
 	if (!vaddr)
-		vaddr = map_new_virtual(page);
+		vaddr = map_new_virtual(page, prot);
 	pkmap_count[PKMAP_NR(vaddr)]++;
 	BUG_ON(pkmap_count[PKMAP_NR(vaddr)] < 2);
 	unlock_kmap();
 	return (void*) vaddr;
 }
+EXPORT_SYMBOL(kmap_high_prot);
 
+/**
+ * kmap_high - map a highmem page into memory
+ * @page: &struct page to map
+ *
+ * Returns the page's virtual memory address.
+ *
+ * We cannot call this from interrupts, as it may block.
+ */
+void *kmap_high(struct page *page)
+{
+	return kmap_high_prot(page, kmap_prot);
+}
 EXPORT_SYMBOL(kmap_high);
 
 #ifdef ARCH_NEEDS_KMAP_HIGH_GET
Index: linux-stable/drivers/tty/serial/amba-pl011.c
===================================================================
--- linux-stable.orig/drivers/tty/serial/amba-pl011.c
+++ linux-stable/drivers/tty/serial/amba-pl011.c
@@ -1737,13 +1737,19 @@ pl011_console_write(struct console *co, 
 
 	clk_enable(uap->clk);
 
-	local_irq_save(flags);
+	/*
+	 * local_irq_save(flags);
+	 *
+	 * This local_irq_save() is nonsense. If we come in via sysrq
+	 * handling then interrupts are already disabled. Aside of
+	 * that the port.sysrq check is racy on SMP regardless.
+	*/
 	if (uap->port.sysrq)
 		locked = 0;
 	else if (oops_in_progress)
-		locked = spin_trylock(&uap->port.lock);
+		locked = spin_trylock_irqsave(&uap->port.lock, flags);
 	else
-		spin_lock(&uap->port.lock);
+		spin_lock_irqsave(&uap->port.lock, flags);
 
 	/*
 	 *	First save the CR then disable the interrupts
@@ -1765,8 +1771,7 @@ pl011_console_write(struct console *co, 
 	writew(old_cr, uap->port.membase + UART011_CR);
 
 	if (locked)
-		spin_unlock(&uap->port.lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&uap->port.lock, flags);
 
 	clk_disable(uap->clk);
 }
Index: linux-stable/mm/bounce.c
===================================================================
--- linux-stable.orig/mm/bounce.c
+++ linux-stable/mm/bounce.c
@@ -51,11 +51,11 @@ static void bounce_copy_vec(struct bio_v
 	unsigned long flags;
 	unsigned char *vto;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 	vto = kmap_atomic(to->bv_page);
 	memcpy(vto + to->bv_offset, vfrom, to->bv_len);
 	kunmap_atomic(vto);
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 }
 
 #else /* CONFIG_HIGHMEM */
Index: linux-stable/drivers/mmc/host/mmci.c
===================================================================
--- linux-stable.orig/drivers/mmc/host/mmci.c
+++ linux-stable/drivers/mmc/host/mmci.c
@@ -923,15 +923,12 @@ static irqreturn_t mmci_pio_irq(int irq,
 	struct sg_mapping_iter *sg_miter = &host->sg_miter;
 	struct variant_data *variant = host->variant;
 	void __iomem *base = host->base;
-	unsigned long flags;
 	u32 status;
 
 	status = readl(base + MMCISTATUS);
 
 	dev_dbg(mmc_dev(host->mmc), "irq1 (pio) %08x\n", status);
 
-	local_irq_save(flags);
-
 	do {
 		unsigned int remain, len;
 		char *buffer;
@@ -971,8 +968,6 @@ static irqreturn_t mmci_pio_irq(int irq,
 
 	sg_miter_stop(sg_miter);
 
-	local_irq_restore(flags);
-
 	/*
 	 * If we have less than the fifo 'half-full' threshold to transfer,
 	 * trigger a PIO interrupt as soon as any data is available.
Index: linux-stable/include/linux/completion.h
===================================================================
--- linux-stable.orig/include/linux/completion.h
+++ linux-stable/include/linux/completion.h
@@ -8,7 +8,7 @@
  * See kernel/sched.c for details.
  */
 
-#include <linux/wait.h>
+#include <linux/wait-simple.h>
 
 /*
  * struct completion - structure used to maintain state for a "completion"
@@ -24,11 +24,11 @@
  */
 struct completion {
 	unsigned int done;
-	wait_queue_head_t wait;
+	struct swait_head wait;
 };
 
 #define COMPLETION_INITIALIZER(work) \
-	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
+	{ 0, SWAIT_HEAD_INITIALIZER((work).wait) }
 
 #define COMPLETION_INITIALIZER_ONSTACK(work) \
 	({ init_completion(&work); work; })
@@ -73,7 +73,7 @@ struct completion {
 static inline void init_completion(struct completion *x)
 {
 	x->done = 0;
-	init_waitqueue_head(&x->wait);
+	init_swait_head(&x->wait);
 }
 
 extern void wait_for_completion(struct completion *);
Index: linux-stable/arch/x86/include/asm/highmem.h
===================================================================
--- linux-stable.orig/arch/x86/include/asm/highmem.h
+++ linux-stable/arch/x86/include/asm/highmem.h
@@ -56,16 +56,39 @@ extern unsigned long highstart_pfn, high
 
 extern void *kmap_high(struct page *page);
 extern void kunmap_high(struct page *page);
+extern void *kmap_high_prot(struct page *page, pgprot_t prot);
 
 void *kmap(struct page *page);
 void kunmap(struct page *page);
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 void *kmap_atomic_prot(struct page *page, pgprot_t prot);
 void *kmap_atomic(struct page *page);
 void __kunmap_atomic(void *kvaddr);
 void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
+#else
+void *kmap_prot(struct page *page, pgprot_t prot);
+# define kmap_atomic(page)			\
+	({ pagefault_disable(); kmap(page); })
+
+# define kmap_atomic_pfn(pfn)			\
+	({ pagefault_disable(); kmap(pfn_to_page(pfn)) })
+
+# define __kunmap_atomic(kvaddr)		\
+	do { kunmap(kmap_to_page(kvaddr)); pagefault_enable(); } while(0)
+
+# define kmap_atomic_prot(page, prot)		\
+	({ pagefault_disable(); kmap_prot(page, prot); })
+
+# define kmap_atomic_prot_pfn(pfn, prot)	\
+	({ pagefault_disable(); kmap_prot(pfn_to_page(pfn), prot); })
+
+# define kmap_atomic_to_page(kvaddr)		\
+	kmap_to_page(kvaddr)
+
+#endif
 
 #define flush_cache_kmaps()	do { } while (0)
 
Index: linux-stable/include/linux/highmem.h
===================================================================
--- linux-stable.orig/include/linux/highmem.h
+++ linux-stable/include/linux/highmem.h
@@ -59,6 +59,8 @@ static inline void *kmap(struct page *pa
 	return page_address(page);
 }
 
+#define kmap_prot(page, prot)	kmap(page)
+
 static inline void kunmap(struct page *page)
 {
 }
Index: linux-stable/arch/arm/include/asm/highmem.h
===================================================================
--- linux-stable.orig/arch/arm/include/asm/highmem.h
+++ linux-stable/arch/arm/include/asm/highmem.h
@@ -57,10 +57,25 @@ static inline void *kmap_high_get(struct
 #ifdef CONFIG_HIGHMEM
 extern void *kmap(struct page *page);
 extern void kunmap(struct page *page);
+# ifndef CONFIG_PREEMPT_RT_FULL
 extern void *kmap_atomic(struct page *page);
 extern void __kunmap_atomic(void *kvaddr);
 extern void *kmap_atomic_pfn(unsigned long pfn);
 extern struct page *kmap_atomic_to_page(const void *ptr);
+# else
+#  define kmap_atomic(page)	\
+	({ pagefault_disable(); kmap(page); })
+
+#  define kmap_atomic_pfn(pfn)	\
+	({ pagefault_disable(); kmap(pfn_to_page(pfn)) })
+
+#  define __kunmap_atomic(kvaddr)	\
+	do { kunmap(kmap_to_page(kvaddr)); pagefault_enable(); } while(0)
+
+#  define kmap_atomic_to_page(kvaddr)	\
+	kmap_to_page(kvaddr)
+
+# endif
 #endif
 
 #endif
Index: linux-stable/arch/arm/mm/highmem.c
===================================================================
--- linux-stable.orig/arch/arm/mm/highmem.c
+++ linux-stable/arch/arm/mm/highmem.c
@@ -36,6 +36,7 @@ void kunmap(struct page *page)
 }
 EXPORT_SYMBOL(kunmap);
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 void *kmap_atomic(struct page *page)
 {
 	unsigned int idx;
@@ -135,3 +136,4 @@ struct page *kmap_atomic_to_page(const v
 
 	return pte_page(get_top_pte(vaddr));
 }
+#endif
