Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3LPJP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:15:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:58369 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3LPJOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:14:33 -0500
Date: Mon, 16 Dec 2013 10:14:31 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.5-rt6
Message-ID: <20131216091431.GA13796@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.5-rt6 patch set.

Changes since v3.12.5-rt5
- A last fix for at91 from Sami Pietikäinen. Now at91 based boards
  should work again on RT.
- A fix for an ancient race (since we got sleeping spinlocks) where the
  TASK_TRACED state is temporary replaced while waiting on a rw lock and
  the task can't be traced anymore. It was initially reported by Alexander
  Fyodorov and he also provided a patch. Based on the patch and a
  testcase I was able to reproduce it and hopefully fix this. My
  testcase does no longer trigger. As a result of this,
  rfc-sched-rt-fix-wait_task_interactive-to-test-rt_spin_lock-state.patch
  was removed from the queue which partly did the same thing.
- A clean up from Nicholas Mc Guire to use spin_unlock_wait() instead of
  open coding it.
- A few migrate_disable() push downs from Nicholas Mc Guire in the
  "try lock" functions. Now migrate_disable() is only called if we got
  the lock so we avoid migrate_disable() + migrate_enable() dance if we
  did not get the lock.
- A patch from Nicholas Mc Guire to only invoke migrate_disable() on the
  first invocation of local_bh_disable(). That means in nested
  invocations of local_bh_disable() we invoke migrate_disable() only
  once.
- A few Sparc64 patches from Allen Pais. According to his email he
  tested it on UltraSparc T4 (Niagara4).
- Nicholas Mc Guire added a return value to a ww-mutex related function
  in the !RT case which should not be used but gcc complained anyway.

Known issues:

      - bcache is disabled.

      - Brian Silverman reported a BUG (via Debian BTS) where gdb's
        record command does something nasty and causes a double fault on
        x86-64 kernel with 32bit userland (the debugged application).
        32bit and 64bit setup are not kernels are not affected. As far
        as I understand the problem so far, it is limited to x86.

The delta patch against v3.12.5-rt5 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.5-rt5-rt6.patch.xz

The RT patch against 3.12.5 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.5-rt6.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.5-rt6.tar.xz

Sebastian

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 49d5f09..da51da9 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -26,6 +26,7 @@ config SPARC
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_API_DEBUG
 	select HAVE_ARCH_JUMP_LABEL
+	select IRQ_FORCED_THREADING
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select USE_GENERIC_SMP_HELPERS if SMP
@@ -177,12 +178,10 @@ config NR_CPUS
 source kernel/Kconfig.hz
 
 config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y if SPARC32
+	def_bool PREEMPT_RT_FULL
 
 config RWSEM_XCHGADD_ALGORITHM
-	bool
-	default y if SPARC64
+	def_bool !RWSEM_GENERIC_SPINLOCK && !PREEMPT_RT_FULL
 
 config GENERIC_HWEIGHT
 	bool
diff --git a/arch/sparc/include/asm/mmu_64.h b/arch/sparc/include/asm/mmu_64.h
index 76092c4..e945ddb 100644
--- a/arch/sparc/include/asm/mmu_64.h
+++ b/arch/sparc/include/asm/mmu_64.h
@@ -90,7 +90,7 @@ struct tsb_config {
 #endif
 
 typedef struct {
-	spinlock_t		lock;
+	raw_spinlock_t		lock;
 	unsigned long		sparc64_ctx_val;
 	unsigned long		huge_pte_count;
 	struct page		*pgtable_page;
diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 3d528f0..44e393b 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -13,7 +13,7 @@ static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 }
 
-extern spinlock_t ctx_alloc_lock;
+extern raw_spinlock_t ctx_alloc_lock;
 extern unsigned long tlb_context_cache;
 extern unsigned long mmu_context_bmap[];
 
@@ -77,7 +77,7 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
 	if (unlikely(mm == &init_mm))
 		return;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 	ctx_valid = CTX_VALID(mm->context);
 	if (!ctx_valid)
 		get_new_mmu_context(mm);
@@ -125,7 +125,7 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
 		__flush_tlb_mm(CTX_HWBITS(mm->context),
 			       SECONDARY_CONTEXT);
 	}
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 #define deactivate_mm(tsk,mm)	do { } while (0)
@@ -136,7 +136,7 @@ static inline void activate_mm(struct mm_struct *active_mm, struct mm_struct *mm
 	unsigned long flags;
 	int cpu;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 	if (!CTX_VALID(mm->context))
 		get_new_mmu_context(mm);
 	cpu = smp_processor_id();
@@ -146,7 +146,7 @@ static inline void activate_mm(struct mm_struct *active_mm, struct mm_struct *mm
 	load_secondary_context(mm);
 	__flush_tlb_mm(CTX_HWBITS(mm->context), SECONDARY_CONTEXT);
 	tsb_context_switch(mm);
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 #endif /* !(__ASSEMBLY__) */
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index e142545..8c68424 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -976,12 +976,12 @@ void __irq_entry smp_new_mmu_context_version_client(int irq, struct pt_regs *reg
 	if (unlikely(!mm || (mm == &init_mm)))
 		return;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 	if (unlikely(!CTX_VALID(mm->context)))
 		get_new_mmu_context(mm);
 
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 
 	load_secondary_context(mm);
 	__flush_tlb_mm(CTX_HWBITS(mm->context),
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index ed82eda..ec995b0 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -350,7 +350,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
 
 	mm = vma->vm_mm;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 #if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
 	if (mm->context.huge_pte_count && is_hugetlb_pte(pte))
@@ -361,7 +361,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t *
 		__update_mmu_tsb_insert(mm, MM_TSB_BASE, PAGE_SHIFT,
 					address, pte_val(pte));
 
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 void flush_dcache_page(struct page *page)
@@ -661,7 +661,7 @@ void __flush_dcache_range(unsigned long start, unsigned long end)
 EXPORT_SYMBOL(__flush_dcache_range);
 
 /* get_new_mmu_context() uses "cache + 1".  */
-DEFINE_SPINLOCK(ctx_alloc_lock);
+DEFINE_RAW_SPINLOCK(ctx_alloc_lock);
 unsigned long tlb_context_cache = CTX_FIRST_VERSION - 1;
 #define MAX_CTX_NR	(1UL << CTX_NR_BITS)
 #define CTX_BMAP_SLOTS	BITS_TO_LONGS(MAX_CTX_NR)
@@ -683,7 +683,7 @@ void get_new_mmu_context(struct mm_struct *mm)
 	unsigned long orig_pgsz_bits;
 	int new_version;
 
-	spin_lock(&ctx_alloc_lock);
+	raw_spin_lock(&ctx_alloc_lock);
 	orig_pgsz_bits = (mm->context.sparc64_ctx_val & CTX_PGSZ_MASK);
 	ctx = (tlb_context_cache + 1) & CTX_NR_MASK;
 	new_ctx = find_next_zero_bit(mmu_context_bmap, 1 << CTX_NR_BITS, ctx);
@@ -719,7 +719,7 @@ void get_new_mmu_context(struct mm_struct *mm)
 out:
 	tlb_context_cache = new_ctx;
 	mm->context.sparc64_ctx_val = new_ctx | orig_pgsz_bits;
-	spin_unlock(&ctx_alloc_lock);
+	raw_spin_unlock(&ctx_alloc_lock);
 
 	if (unlikely(new_version))
 		smp_new_mmu_context_version();
@@ -2721,7 +2721,7 @@ void hugetlb_setup(struct pt_regs *regs)
 	if (tlb_type == cheetah_plus) {
 		unsigned long ctx;
 
-		spin_lock(&ctx_alloc_lock);
+		raw_spin_lock(&ctx_alloc_lock);
 		ctx = mm->context.sparc64_ctx_val;
 		ctx &= ~CTX_PGSZ_MASK;
 		ctx |= CTX_PGSZ_BASE << CTX_PGSZ0_SHIFT;
@@ -2742,7 +2742,7 @@ void hugetlb_setup(struct pt_regs *regs)
 			mm->context.sparc64_ctx_val = ctx;
 			on_each_cpu(context_reload, mm, 0);
 		}
-		spin_unlock(&ctx_alloc_lock);
+		raw_spin_unlock(&ctx_alloc_lock);
 	}
 }
 #endif
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 2cc3bce..9eb10b4 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -73,7 +73,7 @@ void flush_tsb_user(struct tlb_batch *tb)
 	struct mm_struct *mm = tb->mm;
 	unsigned long nentries, base, flags;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 	base = (unsigned long) mm->context.tsb_block[MM_TSB_BASE].tsb;
 	nentries = mm->context.tsb_block[MM_TSB_BASE].tsb_nentries;
@@ -90,14 +90,14 @@ void flush_tsb_user(struct tlb_batch *tb)
 		__flush_tsb_one(tb, HPAGE_SHIFT, base, nentries);
 	}
 #endif
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 void flush_tsb_user_page(struct mm_struct *mm, unsigned long vaddr)
 {
 	unsigned long nentries, base, flags;
 
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 	base = (unsigned long) mm->context.tsb_block[MM_TSB_BASE].tsb;
 	nentries = mm->context.tsb_block[MM_TSB_BASE].tsb_nentries;
@@ -114,7 +114,7 @@ void flush_tsb_user_page(struct mm_struct *mm, unsigned long vaddr)
 		__flush_tsb_one_entry(base, vaddr, HPAGE_SHIFT, nentries);
 	}
 #endif
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
 #define HV_PGSZ_IDX_BASE	HV_PGSZ_IDX_8K
@@ -392,7 +392,7 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
 	 * the lock and ask all other cpus running this address space
 	 * to run tsb_context_switch() to see the new TSB table.
 	 */
-	spin_lock_irqsave(&mm->context.lock, flags);
+	raw_spin_lock_irqsave(&mm->context.lock, flags);
 
 	old_tsb = mm->context.tsb_block[tsb_index].tsb;
 	old_cache_index =
@@ -407,7 +407,7 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
 	 */
 	if (unlikely(old_tsb &&
 		     (rss < mm->context.tsb_block[tsb_index].tsb_rss_limit))) {
-		spin_unlock_irqrestore(&mm->context.lock, flags);
+		raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 
 		kmem_cache_free(tsb_caches[new_cache_index], new_tsb);
 		return;
@@ -433,7 +433,7 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
 	mm->context.tsb_block[tsb_index].tsb = new_tsb;
 	setup_tsb_params(mm, tsb_index, new_size);
 
-	spin_unlock_irqrestore(&mm->context.lock, flags);
+	raw_spin_unlock_irqrestore(&mm->context.lock, flags);
 
 	/* If old_tsb is NULL, we're being invoked for the first time
 	 * from init_new_context().
@@ -459,7 +459,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 #endif
 	unsigned int i;
 
-	spin_lock_init(&mm->context.lock);
+	raw_spin_lock_init(&mm->context.lock);
 
 	mm->context.sparc64_ctx_val = 0UL;
 
@@ -523,12 +523,12 @@ void destroy_context(struct mm_struct *mm)
 		free_hot_cold_page(page, 0);
 	}
 
-	spin_lock_irqsave(&ctx_alloc_lock, flags);
+	raw_spin_lock_irqsave(&ctx_alloc_lock, flags);
 
 	if (CTX_VALID(mm->context)) {
 		unsigned long nr = CTX_NRBITS(mm->context);
 		mmu_context_bmap[nr>>6] &= ~(1UL << (nr & 63));
 	}
 
-	spin_unlock_irqrestore(&ctx_alloc_lock, flags);
+	raw_spin_unlock_irqrestore(&ctx_alloc_lock, flags);
 }
diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 74fe7f7..a00dfaf 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -182,10 +182,9 @@ static struct irqaction tc_irqaction = {
 	.handler	= ch2_irq,
 };
 
-static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
+static void __init setup_clkevents(struct atmel_tc *tc, int divisor_idx)
 {
-	unsigned divisor = atmel_tc_divisors[clk32k_divisor_idx];
-	u32 freq;
+	unsigned divisor = atmel_tc_divisors[divisor_idx];
 	struct clk *t2_clk = tc->clk[2];
 	int irq = tc->irq[2];
 
@@ -193,15 +192,15 @@ static void __init setup_clkevents(struct atmel_tc *tc, int clk32k_divisor_idx)
 	clkevt.clk = t2_clk;
 	tc_irqaction.dev_id = &clkevt;
 
-	timer_clock = clk32k_divisor_idx;
+	timer_clock = divisor_idx;
 	if (!divisor)
-		freq = 32768;
+		clkevt.freq = 32768;
 	else
-		freq = clk_get_rate(t2_clk) / divisor;
+		clkevt.freq = clk_get_rate(t2_clk) / divisor;
 
 	clkevt.clkevt.cpumask = cpumask_of(0);
 
-	clockevents_config_and_register(&clkevt.clkevt, freq, 1, 0xffff);
+	clockevents_config_and_register(&clkevt.clkevt, clkevt.freq, 1, 0xffff);
 
 	setup_irq(irq, &tc_irqaction);
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 10eaf4d..625a41f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -167,11 +167,8 @@ extern char ___assert_task_state[1 - 2*!!(
 				 TASK_UNINTERRUPTIBLE | __TASK_STOPPED | \
 				 __TASK_TRACED)
 
-#define task_is_traced(task)	((task->state & __TASK_TRACED) != 0)
 #define task_is_stopped(task)	((task->state & __TASK_STOPPED) != 0)
 #define task_is_dead(task)	((task)->exit_state != 0)
-#define task_is_stopped_or_traced(task)	\
-			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
 				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
 				 (task->flags & PF_FROZEN) == 0)
@@ -2531,6 +2528,51 @@ static inline int signal_pending_state(long state, struct task_struct *p)
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
 }
 
+static inline bool __task_is_stopped_or_traced(struct task_struct *task)
+{
+	if (task->state & (__TASK_STOPPED | __TASK_TRACED))
+		return true;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (task->saved_state & (__TASK_STOPPED | __TASK_TRACED))
+		return true;
+#endif
+	return false;
+}
+
+static inline bool task_is_stopped_or_traced(struct task_struct *task)
+{
+	bool traced_stopped;
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	traced_stopped = __task_is_stopped_or_traced(task);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+#else
+	traced_stopped = __task_is_stopped_or_traced(task);
+#endif
+	return traced_stopped;
+}
+
+static inline bool task_is_traced(struct task_struct *task)
+{
+	bool traced = false;
+
+	if (task->state & __TASK_TRACED)
+		return true;
+#ifdef CONFIG_PREEMPT_RT_FULL
+	/* in case the task is sleeping on tasklist_lock */
+	raw_spin_lock_irq(&task->pi_lock);
+	if (task->state & __TASK_TRACED)
+		traced = true;
+	else if (task->saved_state & __TASK_TRACED)
+		traced = true;
+	raw_spin_unlock_irq(&task->pi_lock);
+#endif
+	return traced;
+}
+
 /*
  * cond_resched() and cond_resched_lock(): latency reduction via
  * explicit rescheduling in places that are safe. The return
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 142c0f7..019a936 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -236,8 +236,7 @@ static inline unsigned read_seqbegin(seqlock_t *sl)
 		 * Take the lock and let the writer proceed (i.e. evtl
 		 * boost it), otherwise we could loop here forever.
 		 */
-		spin_lock(&sl->lock);
-		spin_unlock(&sl->lock);
+		spin_unlock_wait(&sl->lock);
 		goto repeat;
 	}
 	return ret;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1f4bcb3..fddaf65 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -135,7 +135,12 @@ static bool ptrace_freeze_traced(struct task_struct *task)
 
 	spin_lock_irq(&task->sighand->siglock);
 	if (task_is_traced(task) && !__fatal_signal_pending(task)) {
-		task->state = __TASK_TRACED;
+		raw_spin_lock_irq(&task->pi_lock);
+		if (task->state & __TASK_TRACED)
+			task->state = __TASK_TRACED;
+		else
+			task->saved_state = __TASK_TRACED;
+		raw_spin_unlock_irq(&task->pi_lock);
 		ret = true;
 	}
 	spin_unlock_irq(&task->sighand->siglock);
diff --git a/kernel/rt.c b/kernel/rt.c
index 4b2c4a9..29771e2 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -196,10 +196,9 @@ int __lockfunc rt_write_trylock_irqsave(rwlock_t *rwlock, unsigned long *flags)
 	int ret;
 
 	*flags = 0;
-	migrate_disable();
 	ret = rt_write_trylock(rwlock);
-	if (!ret)
-		migrate_enable();
+	if (ret)
+		migrate_disable();
 	return ret;
 }
 EXPORT_SYMBOL(rt_write_trylock_irqsave);
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 4e9691f..4057bc6 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -938,12 +938,11 @@ int __lockfunc rt_spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags)
 	int ret;
 
 	*flags = 0;
-	migrate_disable();
 	ret = rt_mutex_trylock(&lock->lock);
-	if (ret)
+	if (ret) {
+		migrate_disable();
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-	else
-		migrate_enable();
+	}
 	return ret;
 }
 EXPORT_SYMBOL(rt_spin_trylock_irqsave);
@@ -953,12 +952,12 @@ int atomic_dec_and_spin_lock(atomic_t *atomic, spinlock_t *lock)
 	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
 	if (atomic_add_unless(atomic, -1, 1))
 		return 0;
-	migrate_disable();
 	rt_spin_lock(lock);
-	if (atomic_dec_and_test(atomic))
+	if (atomic_dec_and_test(atomic)){
+		migrate_disable();
 		return 1;
+	}
 	rt_spin_unlock(lock);
-	migrate_enable();
 	return 0;
 }
 EXPORT_SYMBOL(atomic_dec_and_spin_lock);
@@ -1007,6 +1006,7 @@ static inline int __sched
 __mutex_lock_check_stamp(struct rt_mutex *lock, struct ww_acquire_ctx *ctx)
 {
 	BUG();
+	return 0;
 }
 
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 22fa2e2..9c87a17 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1071,6 +1071,20 @@ struct migration_arg {
 
 static int migration_cpu_stop(void *data);
 
+static bool check_task_state(struct task_struct *p, long match_state)
+{
+	bool match = false;
+
+	raw_spin_lock_irq(&p->pi_lock);
+	if (p->state == match_state)
+		match = true;
+	else if (p->saved_state == match_state)
+		match = true;
+	raw_spin_unlock_irq(&p->pi_lock);
+
+	return match;
+}
+
 /*
  * wait_task_inactive - wait for a thread to unschedule.
  *
@@ -1115,9 +1129,11 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state && unlikely(p->state != match_state)
-			    && unlikely(p->saved_state != match_state))
+			if (match_state) {
+				if (!unlikely(check_task_state(p, match_state)))
+					return 0;
 				return 0;
+			}
 			cpu_relax();
 		}
 
@@ -1613,7 +1629,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
  */
 int wake_up_process(struct task_struct *p)
 {
-	WARN_ON(task_is_stopped_or_traced(p));
+	WARN_ON(__task_is_stopped_or_traced(p));
 	return try_to_wake_up(p, TASK_NORMAL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 9a7268f..2da729b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -569,8 +569,8 @@ static void do_current_softirqs(int need_rcu_bh_qs)
 
 void local_bh_disable(void)
 {
-	migrate_disable();
-	current->softirq_nestcnt++;
+	if (++current->softirq_nestcnt == 1)
+		migrate_disable();
 }
 EXPORT_SYMBOL(local_bh_disable);
 
@@ -584,8 +584,8 @@ void local_bh_enable(void)
 		do_current_softirqs(1);
 	local_irq_enable();
 
-	current->softirq_nestcnt--;
-	migrate_enable();
+	if (--current->softirq_nestcnt == 0)
+		migrate_enable();
 }
 EXPORT_SYMBOL(local_bh_enable);
 
@@ -597,8 +597,10 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 
 void _local_bh_enable(void)
 {
-	current->softirq_nestcnt--;
-	migrate_enable();
+	if (WARN_ON(current->softirq_nestcnt == 0))
+		return;
+	if (--current->softirq_nestcnt == 0)
+		migrate_enable();
 }
 EXPORT_SYMBOL(_local_bh_enable);
 
diff --git a/localversion-rt b/localversion-rt
index 0efe7ba..8fc605d 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt5
+-rt6
