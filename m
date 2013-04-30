Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab3D3CUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:20:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33588 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3D3CUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:20:31 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=DfMNWbEOgJYA:10 a=VwQbUJbxAAAA:8 a=wvukd4qoe_apBucLiXwA:9 a=QEXdDO2ut3YA:10 a=ICWx1EM7JL0jsbt1:21 a=zz_PqXVrRDVna3As:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367288427.30667.54.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.2.43-rt63-feat2
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Mon, 29 Apr 2013 22:20:27 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.43-rt63-feat2 feature release.

Note, although this release adds the changes to use slub in -rt, I'm now
hitting a large latency using SLUB instead of SLAB. As this only seems
to happen in 3.2-rt and not 3.4-rt or 3.6-rt, I'm not really worried
about it. Although its strange that the long latency is in the
load_balance code. I'm not sure why the SLUB allocator affects that.
This kernel still does fine with latencies when compiled with SLAB.

Also special thanks goes out to Sebastian Andrzej Siewior for doing the
slub backport.

This also includes a compiler fix by Mike Galbraith.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.2-rt-features
  Head SHA1: c6b4fa5bc4518185c63da779f28a53c61598ccab


Or to build 3.2.43-rt63-feat2 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.43.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.43-rt63.patch.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/features/patch-3.2.43-rt63-feat2.patch.xz

Broken out patches are available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/features/patches-3.2.43-rt63-feat2.tar.xz




Enjoy,

-- Steve


Changes from v3.2.43-rt63-feat1:

---

Christoph Lameter (3):
      FIX [1/2] slub: Do not dereference NULL pointer in node_match
      FIX [2/2] slub: Tid must be retrieved from the percpu area of the current processor
      slub: Use correct cpu_slab on dead cpu

Gilad Ben-Yossef (3):
      smp: introduce a generic on_each_cpu_mask() function
      smp: add func to IPI cpus based on parameter func
      slub: only IPI CPUs that have per cpu obj to flush

Mike Galbraith (1):
      hrtimer: fix hrtimer free zone build bug

Steven Rostedt (Red Hat) (1):
      Linux 3.2.43-rt63-feat2

Thomas Gleixner (2):
      mm: Enable SLUB for RT
      slub: Enable irqs for __GFP_WAIT

----
 arch/arm/kernel/smp_tlb.c   |   20 ++----
 arch/tile/include/asm/smp.h |    7 --
 arch/tile/kernel/smp.c      |   19 ------
 include/linux/slub_def.h    |    2 +-
 include/linux/smp.h         |   46 +++++++++++++
 init/Kconfig                |    1 -
 kernel/hrtimer.c            |    2 +-
 kernel/smp.c                |   90 +++++++++++++++++++++++++
 localversion-rt-feat        |    2 +-
 mm/slub.c                   |  154 ++++++++++++++++++++++++++++++++-----------
 10 files changed, 260 insertions(+), 83 deletions(-)
---------------------------
diff --git a/arch/arm/kernel/smp_tlb.c b/arch/arm/kernel/smp_tlb.c
index 7dcb352..02c5d2c 100644
--- a/arch/arm/kernel/smp_tlb.c
+++ b/arch/arm/kernel/smp_tlb.c
@@ -13,18 +13,6 @@
 #include <asm/smp_plat.h>
 #include <asm/tlbflush.h>
 
-static void on_each_cpu_mask(void (*func)(void *), void *info, int wait,
-	const struct cpumask *mask)
-{
-	preempt_disable();
-
-	smp_call_function_many(mask, func, info, wait);
-	if (cpumask_test_cpu(smp_processor_id(), mask))
-		func(info);
-
-	preempt_enable();
-}
-
 /**********************************************************************/
 
 /*
@@ -87,7 +75,7 @@ void flush_tlb_all(void)
 void flush_tlb_mm(struct mm_struct *mm)
 {
 	if (tlb_ops_need_broadcast())
-		on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mm_cpumask(mm));
+		on_each_cpu_mask(mm_cpumask(mm), ipi_flush_tlb_mm, mm, 1);
 	else
 		local_flush_tlb_mm(mm);
 }
@@ -98,7 +86,8 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 		struct tlb_args ta;
 		ta.ta_vma = vma;
 		ta.ta_start = uaddr;
-		on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mm_cpumask(vma->vm_mm));
+		on_each_cpu_mask(mm_cpumask(vma->vm_mm), ipi_flush_tlb_page,
+					&ta, 1);
 	} else
 		local_flush_tlb_page(vma, uaddr);
 }
@@ -121,7 +110,8 @@ void flush_tlb_range(struct vm_area_struct *vma,
 		ta.ta_vma = vma;
 		ta.ta_start = start;
 		ta.ta_end = end;
-		on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mm_cpumask(vma->vm_mm));
+		on_each_cpu_mask(mm_cpumask(vma->vm_mm), ipi_flush_tlb_range,
+					&ta, 1);
 	} else
 		local_flush_tlb_range(vma, start, end);
 }
diff --git a/arch/tile/include/asm/smp.h b/arch/tile/include/asm/smp.h
index 532124a..1aa759a 100644
--- a/arch/tile/include/asm/smp.h
+++ b/arch/tile/include/asm/smp.h
@@ -43,10 +43,6 @@ void evaluate_message(int tag);
 /* Boot a secondary cpu */
 void online_secondary(void);
 
-/* Call a function on a specified set of CPUs (may include this one). */
-extern void on_each_cpu_mask(const struct cpumask *mask,
-			     void (*func)(void *), void *info, bool wait);
-
 /* Topology of the supervisor tile grid, and coordinates of boot processor */
 extern HV_Topology smp_topology;
 
@@ -91,9 +87,6 @@ void print_disabled_cpus(void);
 
 #else /* !CONFIG_SMP */
 
-#define on_each_cpu_mask(mask, func, info, wait)		\
-  do { if (cpumask_test_cpu(0, (mask))) func(info); } while (0)
-
 #define smp_master_cpu		0
 #define smp_height		1
 #define smp_width		1
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index c52224d..a44e103 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -87,25 +87,6 @@ void send_IPI_allbutself(int tag)
 	send_IPI_many(&mask, tag);
 }
 
-
-/*
- * Provide smp_call_function_mask, but also run function locally
- * if specified in the mask.
- */
-void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
-		      void *info, bool wait)
-{
-	int cpu = get_cpu();
-	smp_call_function_many(mask, func, info, wait);
-	if (cpumask_test_cpu(cpu, mask)) {
-		local_irq_disable();
-		func(info);
-		local_irq_enable();
-	}
-	put_cpu();
-}
-
-
 /*
  * Functions related to starting/stopping cpus.
  */
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index a32bcfd..0c674f6 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -52,7 +52,7 @@ struct kmem_cache_cpu {
 };
 
 struct kmem_cache_node {
-	spinlock_t list_lock;	/* Protect partial list and nr_partial */
+	raw_spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
 	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 78fd0a2..3001ba5 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -101,6 +101,22 @@ static inline void call_function_init(void) { }
 int on_each_cpu(smp_call_func_t func, void *info, int wait);
 
 /*
+ * Call a function on processors specified by mask, which might include
+ * the local one.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
+		void *info, bool wait);
+
+/*
+ * Call a function on each processor for which the supplied function
+ * cond_func returns a positive value. This may include the local
+ * processor.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+		smp_call_func_t func, void *info, bool wait,
+		gfp_t gfp_flags);
+
+/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -131,6 +147,36 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
 		local_irq_enable();		\
 		0;				\
 	})
+/*
+ * Note we still need to test the mask even for UP
+ * because we actually can get an empty mask from
+ * code that on SMP might call us without the local
+ * CPU in the mask.
+ */
+#define on_each_cpu_mask(mask, func, info, wait) \
+	do {						\
+		if (cpumask_test_cpu(0, (mask))) {	\
+			local_irq_disable();		\
+			(func)(info);			\
+			local_irq_enable();		\
+		}					\
+	} while (0)
+/*
+ * Preemption is disabled here to make sure the cond_func is called under the
+ * same condtions in UP and SMP.
+ */
+#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
+	do {							\
+		void *__info = (info);				\
+		preempt_disable();				\
+		if ((cond_func)(0, __info)) {			\
+			local_irq_disable();			\
+			(func)(__info);				\
+			local_irq_enable();			\
+		}						\
+		preempt_enable();				\
+	} while (0)
+
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
diff --git a/init/Kconfig b/init/Kconfig
index aa6545f..cfb1668 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1240,7 +1240,6 @@ config SLAB
 
 config SLUB
 	bool "SLUB (Unqueued Allocator)"
-	depends on !PREEMPT_RT_FULL
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
 	   instead of managing queues of cached objects (SLAB approach).
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 7021e6d..1b40641 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1036,7 +1036,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 		&& hrtimer_enqueue_reprogram(timer, new_base)) {
 
 		if (wakeup
-#ifdef CONFIG_PREEMPT_RT_BASE
+#if defined(CONFIG_PREEMPT_RT_BASE) && defined(CONFIG_HIGH_RES_TIMERS)
 		    /*
 		     * Move softirq based timers away from the rbtree in
 		     * case it expired already. Otherwise we would have a
diff --git a/kernel/smp.c b/kernel/smp.c
index 9e800b2..d5f3238 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -712,3 +712,93 @@ int on_each_cpu(void (*func) (void *info), void *info, int wait)
 	return ret;
 }
 EXPORT_SYMBOL(on_each_cpu);
+
+/**
+ * on_each_cpu_mask(): Run a function on processors specified by
+ * cpumask, which may include the local processor.
+ * @mask: The set of cpus to run on (only runs on online subset).
+ * @func: The function to run. This must be fast and non-blocking.
+ * @info: An arbitrary pointer to pass to the function.
+ * @wait: If true, wait (atomically) until function has completed
+ *        on other CPUs.
+ *
+ * If @wait is true, then returns once @func has returned.
+ *
+ * You must not call this function with disabled interrupts or
+ * from a hardware interrupt handler or from a bottom half handler.
+ */
+void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
+			void *info, bool wait)
+{
+	int cpu = get_cpu();
+
+	smp_call_function_many(mask, func, info, wait);
+	if (cpumask_test_cpu(cpu, mask)) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
+	}
+	put_cpu();
+}
+EXPORT_SYMBOL(on_each_cpu_mask);
+
+/*
+ * on_each_cpu_cond(): Call a function on each processor for which
+ * the supplied function cond_func returns true, optionally waiting
+ * for all the required CPUs to finish. This may include the local
+ * processor.
+ * @cond_func:	A callback function that is passed a cpu id and
+ *		the the info parameter. The function is called
+ *		with preemption disabled. The function should
+ *		return a blooean value indicating whether to IPI
+ *		the specified CPU.
+ * @func:	The function to run on all applicable CPUs.
+ *		This must be fast and non-blocking.
+ * @info:	An arbitrary pointer to pass to both functions.
+ * @wait:	If true, wait (atomically) until function has
+ *		completed on other CPUs.
+ * @gfp_flags:	GFP flags to use when allocating the cpumask
+ *		used internally by the function.
+ *
+ * The function might sleep if the GFP flags indicates a non
+ * atomic allocation is allowed.
+ *
+ * Preemption is disabled to protect against CPUs going offline but not online.
+ * CPUs going online during the call will not be seen or sent an IPI.
+ *
+ * You must not call this function with disabled interrupts or
+ * from a hardware interrupt handler or from a bottom half handler.
+ */
+void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
+			smp_call_func_t func, void *info, bool wait,
+			gfp_t gfp_flags)
+{
+	cpumask_var_t cpus;
+	int cpu, ret;
+
+	might_sleep_if(gfp_flags & __GFP_WAIT);
+
+	if (likely(zalloc_cpumask_var(&cpus, (gfp_flags|__GFP_NOWARN)))) {
+		preempt_disable();
+		for_each_online_cpu(cpu)
+			if (cond_func(cpu, info))
+				cpumask_set_cpu(cpu, cpus);
+		on_each_cpu_mask(cpus, func, info, wait);
+		preempt_enable();
+		free_cpumask_var(cpus);
+	} else {
+		/*
+		 * No free cpumask, bother. No matter, we'll
+		 * just have to IPI them one by one.
+		 */
+		preempt_disable();
+		for_each_online_cpu(cpu)
+			if (cond_func(cpu, info)) {
+				ret = smp_call_function_single(cpu, func,
+								info, wait);
+				WARN_ON_ONCE(!ret);
+			}
+		preempt_enable();
+	}
+}
+EXPORT_SYMBOL(on_each_cpu_cond);
diff --git a/localversion-rt-feat b/localversion-rt-feat
index 14ee171..b349c49 100644
--- a/localversion-rt-feat
+++ b/localversion-rt-feat
@@ -1 +1 @@
--feat1
+-feat2
diff --git a/mm/slub.c b/mm/slub.c
index 5710788..4c62b7f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1258,6 +1258,12 @@ static inline void slab_free_hook(struct kmem_cache *s, void *x) {}
 
 #endif /* CONFIG_SLUB_DEBUG */
 
+struct slub_free_list {
+	raw_spinlock_t		lock;
+	struct list_head	list;
+};
+static DEFINE_PER_CPU(struct slub_free_list, slub_free_list);
+
 /*
  * Slab allocation and freeing
  */
@@ -1279,10 +1285,15 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	struct page *page;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
+	bool enableirqs;
 
 	flags &= gfp_allowed_mask;
 
-	if (flags & __GFP_WAIT)
+	enableirqs = (flags & __GFP_WAIT) != 0;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	enableirqs |= system_state == SYSTEM_RUNNING;
+#endif
+	if (enableirqs)
 		local_irq_enable();
 
 	flags |= s->allocflags;
@@ -1306,7 +1317,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 			stat(s, ORDER_FALLBACK);
 	}
 
-	if (flags & __GFP_WAIT)
+	if (enableirqs)
 		local_irq_disable();
 
 	if (!page)
@@ -1412,6 +1423,16 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 	__free_pages(page, order);
 }
 
+static void free_delayed(struct kmem_cache *s, struct list_head *h)
+{
+	while(!list_empty(h)) {
+		struct page *page = list_first_entry(h, struct page, lru);
+
+		list_del(&page->lru);
+		__free_slab(s, page);
+	}
+}
+
 #define need_reserve_slab_rcu						\
 	(sizeof(((struct page *)NULL)->lru) < sizeof(struct rcu_head))
 
@@ -1446,6 +1467,12 @@ static void free_slab(struct kmem_cache *s, struct page *page)
 		}
 
 		call_rcu(head, rcu_free_slab);
+	} else if (irqs_disabled()) {
+		struct slub_free_list *f = &__get_cpu_var(slub_free_list);
+
+		raw_spin_lock(&f->lock);
+		list_add(&page->lru, &f->list);
+		raw_spin_unlock(&f->lock);
 	} else
 		__free_slab(s, page);
 }
@@ -1545,7 +1572,7 @@ static void *get_partial_node(struct kmem_cache *s,
 	if (!n || !n->nr_partial)
 		return NULL;
 
-	spin_lock(&n->list_lock);
+	raw_spin_lock(&n->list_lock);
 	list_for_each_entry_safe(page, page2, &n->partial, lru) {
 		void *t = acquire_slab(s, n, page, object == NULL);
 		int available;
@@ -1566,7 +1593,7 @@ static void *get_partial_node(struct kmem_cache *s,
 			break;
 
 	}
-	spin_unlock(&n->list_lock);
+	raw_spin_unlock(&n->list_lock);
 	return object;
 }
 
@@ -1815,7 +1842,7 @@ redo:
 			 * that acquire_slab() will see a slab page that
 			 * is frozen
 			 */
-			spin_lock(&n->list_lock);
+			raw_spin_lock(&n->list_lock);
 		}
 	} else {
 		m = M_FULL;
@@ -1826,7 +1853,7 @@ redo:
 			 * slabs from diagnostic functions will not see
 			 * any frozen slabs.
 			 */
-			spin_lock(&n->list_lock);
+			raw_spin_lock(&n->list_lock);
 		}
 	}
 
@@ -1861,7 +1888,7 @@ redo:
 		goto redo;
 
 	if (lock)
-		spin_unlock(&n->list_lock);
+		raw_spin_unlock(&n->list_lock);
 
 	if (m == M_FREE) {
 		stat(s, DEACTIVATE_EMPTY);
@@ -1870,11 +1897,15 @@ redo:
 	}
 }
 
-/* Unfreeze all the cpu partial slabs */
-static void unfreeze_partials(struct kmem_cache *s)
+/*
+ * Unfreeze all the cpu partial slabs.
+ *
+ * This function must be called with interrupt disabled.
+ */
+static void unfreeze_partials(struct kmem_cache *s,
+		struct kmem_cache_cpu *c)
 {
 	struct kmem_cache_node *n = NULL;
-	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
 	struct page *page, *discard_page = NULL;
 
 	while ((page = c->partial)) {
@@ -1906,10 +1937,10 @@ static void unfreeze_partials(struct kmem_cache *s)
 				m = M_PARTIAL;
 				if (n != n2) {
 					if (n)
-						spin_unlock(&n->list_lock);
+						raw_spin_unlock(&n->list_lock);
 
 					n = n2;
-					spin_lock(&n->list_lock);
+					raw_spin_lock(&n->list_lock);
 				}
 			}
 
@@ -1935,7 +1966,7 @@ static void unfreeze_partials(struct kmem_cache *s)
 	}
 
 	if (n)
-		spin_unlock(&n->list_lock);
+		raw_spin_unlock(&n->list_lock);
 
 	while (discard_page) {
 		page = discard_page;
@@ -1956,7 +1987,7 @@ static void unfreeze_partials(struct kmem_cache *s)
  * If we did not find a slot then simply move all the partials to the
  * per node partial list.
  */
-int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
+static int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 {
 	struct page *oldpage;
 	int pages;
@@ -1971,14 +2002,21 @@ int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 			pobjects = oldpage->pobjects;
 			pages = oldpage->pages;
 			if (drain && pobjects > s->cpu_partial) {
+				LIST_HEAD(tofree);
+				struct slub_free_list *f;
 				unsigned long flags;
 				/*
 				 * partial array is full. Move the existing
 				 * set to the per node partial list.
 				 */
 				local_irq_save(flags);
-				unfreeze_partials(s);
+				unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
+				f = &__get_cpu_var(slub_free_list);
+				raw_spin_lock(&f->lock);
+				list_splice_init(&f->list, &tofree);
+				raw_spin_unlock(&f->lock);
 				local_irq_restore(flags);
+				free_delayed(s, &tofree);
 				pobjects = 0;
 				pages = 0;
 			}
@@ -2015,7 +2053,7 @@ static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 		if (c->page)
 			flush_slab(s, c);
 
-		unfreeze_partials(s);
+		unfreeze_partials(s, c);
 	}
 }
 
@@ -2026,9 +2064,32 @@ static void flush_cpu_slab(void *d)
 	__flush_cpu_slab(s, smp_processor_id());
 }
 
+static bool has_cpu_slab(int cpu, void *info)
+{
+	struct kmem_cache *s = info;
+	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+
+	return !!(c->page);
+}
+
 static void flush_all(struct kmem_cache *s)
 {
-	on_each_cpu(flush_cpu_slab, s, 1);
+	LIST_HEAD(tofree);
+	int cpu;
+
+	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1, GFP_ATOMIC);
+	for_each_online_cpu(cpu) {
+		struct slub_free_list *f;
+
+		if (!has_cpu_slab(cpu, s))
+			continue;
+
+		f = &per_cpu(slub_free_list, cpu);
+		raw_spin_lock_irq(&f->lock);
+		list_splice_init(&f->list, &tofree);
+		raw_spin_unlock_irq(&f->lock);
+		free_delayed(s, &tofree);
+	}
 }
 
 /*
@@ -2038,7 +2099,7 @@ static void flush_all(struct kmem_cache *s)
 static inline int node_match(struct kmem_cache_cpu *c, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != NUMA_NO_NODE && c->node != node)
+	if (!c->page || (node != NUMA_NO_NODE && c->node != node))
 		return 0;
 #endif
 	return 1;
@@ -2056,10 +2117,10 @@ static unsigned long count_partial(struct kmem_cache_node *n,
 	unsigned long x = 0;
 	struct page *page;
 
-	spin_lock_irqsave(&n->list_lock, flags);
+	raw_spin_lock_irqsave(&n->list_lock, flags);
 	list_for_each_entry(page, &n->partial, lru)
 		x += get_count(page);
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
 
@@ -2155,6 +2216,8 @@ static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
 static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			  unsigned long addr, struct kmem_cache_cpu *c)
 {
+	struct slub_free_list *f;
+	LIST_HEAD(tofree);
 	void **object;
 	unsigned long flags;
 	struct page new;
@@ -2221,7 +2284,13 @@ redo:
 load_freelist:
 	c->freelist = get_freepointer(s, object);
 	c->tid = next_tid(c->tid);
+out:
+	f = &__get_cpu_var(slub_free_list);
+	raw_spin_lock(&f->lock);
+	list_splice_init(&f->list, &tofree);
+	raw_spin_unlock(&f->lock);
 	local_irq_restore(flags);
+	free_delayed(s, &tofree);
 	return object;
 
 new_slab:
@@ -2246,8 +2315,7 @@ new_slab:
 			if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
 				slab_out_of_memory(s, gfpflags, node);
 
-			local_irq_restore(flags);
-			return NULL;
+			goto out;
 		}
 	}
 
@@ -2261,8 +2329,7 @@ new_slab:
 	c->freelist = get_freepointer(s, object);
 	deactivate_slab(s, c);
 	c->node = NUMA_NO_NODE;
-	local_irq_restore(flags);
-	return object;
+	goto out;
 }
 
 /*
@@ -2286,13 +2353,18 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
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
@@ -2302,7 +2374,7 @@ redo:
 	 * linked list in between.
 	 */
 	tid = c->tid;
-	barrier();
+	preempt_enable();
 
 	object = c->freelist;
 	if (unlikely(!object || !node_match(c, node)))
@@ -2449,7 +2521,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 				 * Otherwise the list_lock will synchronize with
 				 * other processors updating the list of slabs.
 				 */
-				spin_lock_irqsave(&n->list_lock, flags);
+				raw_spin_lock_irqsave(&n->list_lock, flags);
 
 			}
 		}
@@ -2498,7 +2570,7 @@ static void __slab_free(struct kmem_cache *s, struct page *page,
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return;
 
 slab_empty:
@@ -2512,7 +2584,7 @@ slab_empty:
 		/* Slab must be on the full list */
 		remove_full(s, page);
 
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 }
@@ -2544,10 +2616,11 @@ redo:
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
@@ -2741,7 +2814,7 @@ static void
 init_kmem_cache_node(struct kmem_cache_node *n, struct kmem_cache *s)
 {
 	n->nr_partial = 0;
-	spin_lock_init(&n->list_lock);
+	raw_spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->nr_slabs, 0);
@@ -3481,7 +3554,7 @@ int kmem_cache_shrink(struct kmem_cache *s)
 		for (i = 0; i < objects; i++)
 			INIT_LIST_HEAD(slabs_by_inuse + i);
 
-		spin_lock_irqsave(&n->list_lock, flags);
+		raw_spin_lock_irqsave(&n->list_lock, flags);
 
 		/*
 		 * Build lists indexed by the items in use in each slab.
@@ -3502,7 +3575,7 @@ int kmem_cache_shrink(struct kmem_cache *s)
 		for (i = objects - 1; i > 0; i--)
 			list_splice(slabs_by_inuse + i, n->partial.prev);
 
-		spin_unlock_irqrestore(&n->list_lock, flags);
+		raw_spin_unlock_irqrestore(&n->list_lock, flags);
 
 		/* Release empty slabs */
 		list_for_each_entry_safe(page, t, slabs_by_inuse, lru)
@@ -3668,10 +3741,15 @@ void __init kmem_cache_init(void)
 	int i;
 	int caches = 0;
 	struct kmem_cache *temp_kmem_cache;
-	int order;
+	int order, cpu;
 	struct kmem_cache *temp_kmem_cache_node;
 	unsigned long kmalloc_size;
 
+	for_each_possible_cpu(cpu) {
+		raw_spin_lock_init(&per_cpu(slub_free_list, cpu).lock);
+		INIT_LIST_HEAD(&per_cpu(slub_free_list, cpu).list);
+	}
+
 	kmem_size = offsetof(struct kmem_cache, node) +
 				nr_node_ids * sizeof(struct kmem_cache_node *);
 
@@ -4092,7 +4170,7 @@ static int validate_slab_node(struct kmem_cache *s,
 	struct page *page;
 	unsigned long flags;
 
-	spin_lock_irqsave(&n->list_lock, flags);
+	raw_spin_lock_irqsave(&n->list_lock, flags);
 
 	list_for_each_entry(page, &n->partial, lru) {
 		validate_slab_slab(s, page, map);
@@ -4115,7 +4193,7 @@ static int validate_slab_node(struct kmem_cache *s,
 			atomic_long_read(&n->nr_slabs));
 
 out:
-	spin_unlock_irqrestore(&n->list_lock, flags);
+	raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	return count;
 }
 
@@ -4305,12 +4383,12 @@ static int list_locations(struct kmem_cache *s, char *buf,
 		if (!atomic_long_read(&n->nr_slabs))
 			continue;
 
-		spin_lock_irqsave(&n->list_lock, flags);
+		raw_spin_lock_irqsave(&n->list_lock, flags);
 		list_for_each_entry(page, &n->partial, lru)
 			process_slab(&t, s, page, alloc, map);
 		list_for_each_entry(page, &n->full, lru)
 			process_slab(&t, s, page, alloc, map);
-		spin_unlock_irqrestore(&n->list_lock, flags);
+		raw_spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
 	for (i = 0; i < t.count; i++) {


