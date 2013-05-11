Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3EKScT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 14:32:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3EKScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 14:32:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.12
Date: Sat, 11 May 2013 19:31:14 +0100
Message-Id: <1368297074-3578-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368297074-3578-1-git-send-email-luis.henriques@canonical.com>
References: <1368297074-3578-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index a9b08fa..4bcb440 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .11
+EXTRAVERSION = .12
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 41dc31f..cc5e50f 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -61,6 +61,15 @@ extern void __pgd_error(const char *file, int line, pgd_t);
 #define FIRST_USER_ADDRESS	PAGE_SIZE
 
 /*
+ * Use TASK_SIZE as the ceiling argument for free_pgtables() and
+ * free_pgd_range() to avoid freeing the modules pmd when LPAE is enabled (pmd
+ * page shared between user and kernel).
+ */
+#ifdef CONFIG_ARM_LPAE
+#define USER_PGTABLES_CEILING	TASK_SIZE
+#endif
+
+/*
  * The pgprot_* and protection_map entries will be fixed up in runtime
  * to include the cachable and bufferable bits based on memory policy,
  * as well as any architecture dependent bits like global/ASID and SMP
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index a02eada..952a5a7 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -319,7 +319,10 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
-	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
+	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
+		return 1;
+
+	if (event->state == PERF_EVENT_STATE_OFF && !event->attr.enable_on_exec)
 		return 1;
 
 	return armpmu->get_event_idx(hw_events, &fake_event) >= 0;
diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 6bbf936..926c98f 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -39,12 +39,12 @@ static u32 notrace jiffy_sched_clock_read(void)
 
 static u32 __read_mostly (*read_sched_clock)(void) = jiffy_sched_clock_read;
 
-static inline u64 cyc_to_ns(u64 cyc, u32 mult, u32 shift)
+static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
 	return (cyc * mult) >> shift;
 }
 
-static unsigned long long cyc_to_sched_clock(u32 cyc, u32 mask)
+static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
 {
 	u64 epoch_ns;
 	u32 epoch_cyc;
diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index 207bc1c..36f65a8 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -284,8 +284,9 @@ select_state:
 DEFINE_PER_CPU(struct cpuidle_device, omap3_idle_dev);
 
 struct cpuidle_driver omap3_idle_driver = {
-	.name = 	"omap3_idle",
-	.owner = 	THIS_MODULE,
+	.name             = "omap3_idle",
+	.owner            = THIS_MODULE,
+	.en_core_tk_irqen = 1,
 	.states = {
 		{
 			.enter		  = omap3_enter_idle,
diff --git a/arch/arm/mm/cache-feroceon-l2.c b/arch/arm/mm/cache-feroceon-l2.c
index dd3d591..48bc3c0 100644
--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -343,6 +343,7 @@ void __init feroceon_l2_init(int __l2_wt_override)
 	outer_cache.inv_range = feroceon_l2_inv_range;
 	outer_cache.clean_range = feroceon_l2_clean_range;
 	outer_cache.flush_range = feroceon_l2_flush_range;
+	outer_cache.inv_all = l2_inv_all;
 
 	enable_l2();
 
diff --git a/arch/ia64/include/asm/futex.h b/arch/ia64/include/asm/futex.h
index d2bf1fd..76acbcd 100644
--- a/arch/ia64/include/asm/futex.h
+++ b/arch/ia64/include/asm/futex.h
@@ -106,16 +106,15 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 		return -EFAULT;
 
 	{
-		register unsigned long r8 __asm ("r8");
+		register unsigned long r8 __asm ("r8") = 0;
 		unsigned long prev;
 		__asm__ __volatile__(
 			"	mf;;					\n"
-			"	mov %0=r0				\n"
 			"	mov ar.ccv=%4;;				\n"
 			"[1:]	cmpxchg4.acq %1=[%2],%3,ar.ccv		\n"
 			"	.xdata4 \"__ex_table\", 1b-., 2f-.	\n"
 			"[2:]"
-			: "=r" (r8), "=r" (prev)
+			: "+r" (r8), "=&r" (prev)
 			: "r" (uaddr), "r" (newval),
 			  "rO" ((long) (unsigned) oldval)
 			: "memory");
diff --git a/arch/ia64/include/asm/mca.h b/arch/ia64/include/asm/mca.h
index 43f96ab..8c70961 100644
--- a/arch/ia64/include/asm/mca.h
+++ b/arch/ia64/include/asm/mca.h
@@ -143,6 +143,7 @@ extern unsigned long __per_cpu_mca[NR_CPUS];
 extern int cpe_vector;
 extern int ia64_cpe_irq;
 extern void ia64_mca_init(void);
+extern void ia64_mca_irq_init(void);
 extern void ia64_mca_cpu_init(void *);
 extern void ia64_os_mca_dispatch(void);
 extern void ia64_os_mca_dispatch_end(void);
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index ad69606..f2c41828 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -23,6 +23,8 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 
+#include <asm/mca.h>
+
 /*
  * 'what should we do if we get a hw irq event on an illegal vector'.
  * each architecture has to answer this themselves.
@@ -83,6 +85,12 @@ bool is_affinity_mask_valid(const struct cpumask *cpumask)
 
 #endif /* CONFIG_SMP */
 
+int __init arch_early_irq_init(void)
+{
+	ia64_mca_irq_init();
+	return 0;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 unsigned int vectors_in_migration[NR_IRQS];
 
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 65bf9cd..d7396db 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -2074,22 +2074,16 @@ ia64_mca_init(void)
 	printk(KERN_INFO "MCA related initialization done\n");
 }
 
+
 /*
- * ia64_mca_late_init
- *
- *	Opportunity to setup things that require initialization later
- *	than ia64_mca_init.  Setup a timer to poll for CPEs if the
- *	platform doesn't support an interrupt driven mechanism.
- *
- *  Inputs  :   None
- *  Outputs :   Status
+ * These pieces cannot be done in ia64_mca_init() because it is called before
+ * early_irq_init() which would wipe out our percpu irq registrations. But we
+ * cannot leave them until ia64_mca_late_init() because by then all the other
+ * processors have been brought online and have set their own CMC vectors to
+ * point at a non-existant action. Called from arch_early_irq_init().
  */
-static int __init
-ia64_mca_late_init(void)
+void __init ia64_mca_irq_init(void)
 {
-	if (!mca_init)
-		return 0;
-
 	/*
 	 *  Configure the CMCI/P vector and handler. Interrupts for CMC are
 	 *  per-processor, so AP CMC interrupts are setup in smp_callin() (smpboot.c).
@@ -2108,6 +2102,23 @@ ia64_mca_late_init(void)
 	/* Setup the CPEI/P handler */
 	register_percpu_irq(IA64_CPEP_VECTOR, &mca_cpep_irqaction);
 #endif
+}
+
+/*
+ * ia64_mca_late_init
+ *
+ *	Opportunity to setup things that require initialization later
+ *	than ia64_mca_init.  Setup a timer to poll for CPEs if the
+ *	platform doesn't support an interrupt driven mechanism.
+ *
+ *  Inputs  :   None
+ *  Outputs :   Status
+ */
+static int __init
+ia64_mca_late_init(void)
+{
+	if (!mca_init)
+		return 0;
 
 	register_hotcpu_notifier(&mca_cpu_notifier);
 
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index 4332f7e..a7869f8 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -256,7 +256,7 @@ u64 guest_vhpt_lookup(u64 iha, u64 *pte)
 			"srlz.d;;"
 			"ssm psr.i;;"
 			"srlz.d;;"
-			: "=r"(ret) : "r"(iha), "r"(pte):"memory");
+			: "=&r"(ret) : "r"(iha), "r"(pte) : "memory");
 
 	return ret;
 }
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 61210db..d319489 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -776,6 +776,7 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
 }
 
+#include <asm/tlbflush.h>
 #include <asm-generic/pgtable.h>
 
 /* We provide our own get_unmapped_area to cope with VA holes and
diff --git a/arch/sparc/include/asm/switch_to_64.h b/arch/sparc/include/asm/switch_to_64.h
index 7923c4a..9c2a92d 100644
--- a/arch/sparc/include/asm/switch_to_64.h
+++ b/arch/sparc/include/asm/switch_to_64.h
@@ -18,8 +18,7 @@ do {						\
 	 * and 2 stores in this critical code path.  -DaveM
 	 */
 #define switch_to(prev, next, last)					\
-do {	flush_tlb_pending();						\
-	save_and_clear_fpu();						\
+do {	save_and_clear_fpu();						\
 	/* If you are tempted to conditionalize the following */	\
 	/* so that ASI is only written if it changes, think again. */	\
 	__asm__ __volatile__("wr %%g0, %0, %%asi"			\
diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index 2ef4634..f0d6a97 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -11,24 +11,40 @@
 struct tlb_batch {
 	struct mm_struct *mm;
 	unsigned long tlb_nr;
+	unsigned long active;
 	unsigned long vaddrs[TLB_BATCH_NR];
 };
 
 extern void flush_tsb_kernel_range(unsigned long start, unsigned long end);
 extern void flush_tsb_user(struct tlb_batch *tb);
+extern void flush_tsb_user_page(struct mm_struct *mm, unsigned long vaddr);
 
 /* TLB flush operations. */
 
-extern void flush_tlb_pending(void);
+static inline void flush_tlb_mm(struct mm_struct *mm)
+{
+}
+
+static inline void flush_tlb_page(struct vm_area_struct *vma,
+				  unsigned long vmaddr)
+{
+}
+
+static inline void flush_tlb_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+}
+
+#define __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 
-#define flush_tlb_range(vma,start,end)	\
-	do { (void)(start); flush_tlb_pending(); } while (0)
-#define flush_tlb_page(vma,addr)	flush_tlb_pending()
-#define flush_tlb_mm(mm)		flush_tlb_pending()
+extern void flush_tlb_pending(void);
+extern void arch_enter_lazy_mmu_mode(void);
+extern void arch_leave_lazy_mmu_mode(void);
+#define arch_flush_lazy_mmu_mode()      do {} while (0)
 
 /* Local cpu only.  */
 extern void __flush_tlb_all(void);
-
+extern void __flush_tlb_page(unsigned long context, unsigned long vaddr);
 extern void __flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 #ifndef CONFIG_SMP
@@ -38,15 +54,24 @@ do {	flush_tsb_kernel_range(start,end); \
 	__flush_tlb_kernel_range(start,end); \
 } while (0)
 
+static inline void global_flush_tlb_page(struct mm_struct *mm, unsigned long vaddr)
+{
+	__flush_tlb_page(CTX_HWBITS(mm->context), vaddr);
+}
+
 #else /* CONFIG_SMP */
 
 extern void smp_flush_tlb_kernel_range(unsigned long start, unsigned long end);
+extern void smp_flush_tlb_page(struct mm_struct *mm, unsigned long vaddr);
 
 #define flush_tlb_kernel_range(start, end) \
 do {	flush_tsb_kernel_range(start,end); \
 	smp_flush_tlb_kernel_range(start, end); \
 } while (0)
 
+#define global_flush_tlb_page(mm, vaddr) \
+	smp_flush_tlb_page(mm, vaddr)
+
 #endif /* ! CONFIG_SMP */
 
 #endif /* _SPARC64_TLBFLUSH_H */
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index f591598..b8870b6 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -852,7 +852,7 @@ void smp_tsb_sync(struct mm_struct *mm)
 }
 
 extern unsigned long xcall_flush_tlb_mm;
-extern unsigned long xcall_flush_tlb_pending;
+extern unsigned long xcall_flush_tlb_page;
 extern unsigned long xcall_flush_tlb_kernel_range;
 extern unsigned long xcall_fetch_glob_regs;
 extern unsigned long xcall_receive_signal;
@@ -1066,23 +1066,56 @@ local_flush_and_out:
 	put_cpu();
 }
 
+struct tlb_pending_info {
+	unsigned long ctx;
+	unsigned long nr;
+	unsigned long *vaddrs;
+};
+
+static void tlb_pending_func(void *info)
+{
+	struct tlb_pending_info *t = info;
+
+	__flush_tlb_pending(t->ctx, t->nr, t->vaddrs);
+}
+
 void smp_flush_tlb_pending(struct mm_struct *mm, unsigned long nr, unsigned long *vaddrs)
 {
 	u32 ctx = CTX_HWBITS(mm->context);
+	struct tlb_pending_info info;
 	int cpu = get_cpu();
 
+	info.ctx = ctx;
+	info.nr = nr;
+	info.vaddrs = vaddrs;
+
 	if (mm == current->mm && atomic_read(&mm->mm_users) == 1)
 		cpumask_copy(mm_cpumask(mm), cpumask_of(cpu));
 	else
-		smp_cross_call_masked(&xcall_flush_tlb_pending,
-				      ctx, nr, (unsigned long) vaddrs,
-				      mm_cpumask(mm));
+		smp_call_function_many(mm_cpumask(mm), tlb_pending_func,
+				       &info, 1);
 
 	__flush_tlb_pending(ctx, nr, vaddrs);
 
 	put_cpu();
 }
 
+void smp_flush_tlb_page(struct mm_struct *mm, unsigned long vaddr)
+{
+	unsigned long context = CTX_HWBITS(mm->context);
+	int cpu = get_cpu();
+
+	if (mm == current->mm && atomic_read(&mm->mm_users) == 1)
+		cpumask_copy(mm_cpumask(mm), cpumask_of(cpu));
+	else
+		smp_cross_call_masked(&xcall_flush_tlb_page,
+				      context, vaddr, 0,
+				      mm_cpumask(mm));
+	__flush_tlb_page(context, vaddr);
+
+	put_cpu();
+}
+
 void smp_flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
 	start &= PAGE_MASK;
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index b1f279c..afd021e 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -24,11 +24,17 @@ static DEFINE_PER_CPU(struct tlb_batch, tlb_batch);
 void flush_tlb_pending(void)
 {
 	struct tlb_batch *tb = &get_cpu_var(tlb_batch);
+	struct mm_struct *mm = tb->mm;
 
-	if (tb->tlb_nr) {
-		flush_tsb_user(tb);
+	if (!tb->tlb_nr)
+		goto out;
 
-		if (CTX_VALID(tb->mm->context)) {
+	flush_tsb_user(tb);
+
+	if (CTX_VALID(mm->context)) {
+		if (tb->tlb_nr == 1) {
+			global_flush_tlb_page(mm, tb->vaddrs[0]);
+		} else {
 #ifdef CONFIG_SMP
 			smp_flush_tlb_pending(tb->mm, tb->tlb_nr,
 					      &tb->vaddrs[0]);
@@ -37,12 +43,30 @@ void flush_tlb_pending(void)
 					    tb->tlb_nr, &tb->vaddrs[0]);
 #endif
 		}
-		tb->tlb_nr = 0;
 	}
 
+	tb->tlb_nr = 0;
+
+out:
 	put_cpu_var(tlb_batch);
 }
 
+void arch_enter_lazy_mmu_mode(void)
+{
+	struct tlb_batch *tb = &__get_cpu_var(tlb_batch);
+
+	tb->active = 1;
+}
+
+void arch_leave_lazy_mmu_mode(void)
+{
+	struct tlb_batch *tb = &__get_cpu_var(tlb_batch);
+
+	if (tb->tlb_nr)
+		flush_tlb_pending();
+	tb->active = 0;
+}
+
 void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
 		   pte_t *ptep, pte_t orig, int fullmm)
 {
@@ -90,6 +114,12 @@ no_cache_flush:
 		nr = 0;
 	}
 
+	if (!tb->active) {
+		global_flush_tlb_page(mm, vaddr);
+		flush_tsb_user_page(mm, vaddr);
+		goto out;
+	}
+
 	if (nr == 0)
 		tb->mm = mm;
 
@@ -98,5 +128,6 @@ no_cache_flush:
 	if (nr >= TLB_BATCH_NR)
 		flush_tlb_pending();
 
+out:
 	put_cpu_var(tlb_batch);
 }
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 7c2d9ac..8adc660 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -7,11 +7,10 @@
 #include <linux/preempt.h>
 #include <linux/slab.h>
 #include <asm/page.h>
-#include <asm/tlbflush.h>
-#include <asm/tlb.h>
-#include <asm/mmu_context.h>
 #include <asm/pgtable.h>
+#include <asm/mmu_context.h>
 #include <asm/tsb.h>
+#include <asm/tlb.h>
 #include <asm/oplib.h>
 
 extern struct tsb swapper_tsb[KERNEL_TSB_NENTRIES];
@@ -46,23 +45,27 @@ void flush_tsb_kernel_range(unsigned long start, unsigned long end)
 	}
 }
 
-static void __flush_tsb_one(struct tlb_batch *tb, unsigned long hash_shift,
-			    unsigned long tsb, unsigned long nentries)
+static void __flush_tsb_one_entry(unsigned long tsb, unsigned long v,
+				  unsigned long hash_shift,
+				  unsigned long nentries)
 {
-	unsigned long i;
+	unsigned long tag, ent, hash;
 
-	for (i = 0; i < tb->tlb_nr; i++) {
-		unsigned long v = tb->vaddrs[i];
-		unsigned long tag, ent, hash;
+	v &= ~0x1UL;
+	hash = tsb_hash(v, hash_shift, nentries);
+	ent = tsb + (hash * sizeof(struct tsb));
+	tag = (v >> 22UL);
 
-		v &= ~0x1UL;
+	tsb_flush(ent, tag);
+}
 
-		hash = tsb_hash(v, hash_shift, nentries);
-		ent = tsb + (hash * sizeof(struct tsb));
-		tag = (v >> 22UL);
+static void __flush_tsb_one(struct tlb_batch *tb, unsigned long hash_shift,
+			    unsigned long tsb, unsigned long nentries)
+{
+	unsigned long i;
 
-		tsb_flush(ent, tag);
-	}
+	for (i = 0; i < tb->tlb_nr; i++)
+		__flush_tsb_one_entry(tsb, tb->vaddrs[i], hash_shift, nentries);
 }
 
 void flush_tsb_user(struct tlb_batch *tb)
@@ -90,6 +93,30 @@ void flush_tsb_user(struct tlb_batch *tb)
 	spin_unlock_irqrestore(&mm->context.lock, flags);
 }
 
+void flush_tsb_user_page(struct mm_struct *mm, unsigned long vaddr)
+{
+	unsigned long nentries, base, flags;
+
+	spin_lock_irqsave(&mm->context.lock, flags);
+
+	base = (unsigned long) mm->context.tsb_block[MM_TSB_BASE].tsb;
+	nentries = mm->context.tsb_block[MM_TSB_BASE].tsb_nentries;
+	if (tlb_type == cheetah_plus || tlb_type == hypervisor)
+		base = __pa(base);
+	__flush_tsb_one_entry(base, vaddr, PAGE_SHIFT, nentries);
+
+#if defined(CONFIG_HUGETLB_PAGE) || defined(CONFIG_TRANSPARENT_HUGEPAGE)
+	if (mm->context.tsb_block[MM_TSB_HUGE].tsb) {
+		base = (unsigned long) mm->context.tsb_block[MM_TSB_HUGE].tsb;
+		nentries = mm->context.tsb_block[MM_TSB_HUGE].tsb_nentries;
+		if (tlb_type == cheetah_plus || tlb_type == hypervisor)
+			base = __pa(base);
+		__flush_tsb_one_entry(base, vaddr, HPAGE_SHIFT, nentries);
+	}
+#endif
+	spin_unlock_irqrestore(&mm->context.lock, flags);
+}
+
 #if defined(CONFIG_SPARC64_PAGE_SIZE_8KB)
 #define HV_PGSZ_IDX_BASE	HV_PGSZ_IDX_8K
 #define HV_PGSZ_MASK_BASE	HV_PGSZ_MASK_8K
diff --git a/arch/sparc/mm/ultra.S b/arch/sparc/mm/ultra.S
index 874162a..dd10caa 100644
--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -53,6 +53,33 @@ __flush_tlb_mm:		/* 18 insns */
 	nop
 
 	.align		32
+	.globl		__flush_tlb_page
+__flush_tlb_page:	/* 22 insns */
+	/* %o0 = context, %o1 = vaddr */
+	rdpr		%pstate, %g7
+	andn		%g7, PSTATE_IE, %g2
+	wrpr		%g2, %pstate
+	mov		SECONDARY_CONTEXT, %o4
+	ldxa		[%o4] ASI_DMMU, %g2
+	stxa		%o0, [%o4] ASI_DMMU
+	andcc		%o1, 1, %g0
+	andn		%o1, 1, %o3
+	be,pn		%icc, 1f
+	 or		%o3, 0x10, %o3
+	stxa		%g0, [%o3] ASI_IMMU_DEMAP
+1:	stxa		%g0, [%o3] ASI_DMMU_DEMAP
+	membar		#Sync
+	stxa		%g2, [%o4] ASI_DMMU
+	sethi		%hi(KERNBASE), %o4
+	flush		%o4
+	retl
+	 wrpr		%g7, 0x0, %pstate
+	nop
+	nop
+	nop
+	nop
+
+	.align		32
 	.globl		__flush_tlb_pending
 __flush_tlb_pending:	/* 26 insns */
 	/* %o0 = context, %o1 = nr, %o2 = vaddrs[] */
@@ -203,6 +230,31 @@ __cheetah_flush_tlb_mm: /* 19 insns */
 	retl
 	 wrpr		%g7, 0x0, %pstate
 
+__cheetah_flush_tlb_page:	/* 22 insns */
+	/* %o0 = context, %o1 = vaddr */
+	rdpr		%pstate, %g7
+	andn		%g7, PSTATE_IE, %g2
+	wrpr		%g2, 0x0, %pstate
+	wrpr		%g0, 1, %tl
+	mov		PRIMARY_CONTEXT, %o4
+	ldxa		[%o4] ASI_DMMU, %g2
+	srlx		%g2, CTX_PGSZ1_NUC_SHIFT, %o3
+	sllx		%o3, CTX_PGSZ1_NUC_SHIFT, %o3
+	or		%o0, %o3, %o0	/* Preserve nucleus page size fields */
+	stxa		%o0, [%o4] ASI_DMMU
+	andcc		%o1, 1, %g0
+	be,pn		%icc, 1f
+	 andn		%o1, 1, %o3
+	stxa		%g0, [%o3] ASI_IMMU_DEMAP
+1:	stxa		%g0, [%o3] ASI_DMMU_DEMAP
+	membar		#Sync
+	stxa		%g2, [%o4] ASI_DMMU
+	sethi		%hi(KERNBASE), %o4
+	flush		%o4
+	wrpr		%g0, 0, %tl
+	retl
+	 wrpr		%g7, 0x0, %pstate
+
 __cheetah_flush_tlb_pending:	/* 27 insns */
 	/* %o0 = context, %o1 = nr, %o2 = vaddrs[] */
 	rdpr		%pstate, %g7
@@ -269,6 +321,20 @@ __hypervisor_flush_tlb_mm: /* 10 insns */
 	retl
 	 nop
 
+__hypervisor_flush_tlb_page: /* 11 insns */
+	/* %o0 = context, %o1 = vaddr */
+	mov		%o0, %g2
+	mov		%o1, %o0              /* ARG0: vaddr + IMMU-bit */
+	mov		%g2, %o1	      /* ARG1: mmu context */
+	mov		HV_MMU_ALL, %o2	      /* ARG2: flags */
+	srlx		%o0, PAGE_SHIFT, %o0
+	sllx		%o0, PAGE_SHIFT, %o0
+	ta		HV_MMU_UNMAP_ADDR_TRAP
+	brnz,pn		%o0, __hypervisor_tlb_tl0_error
+	 mov		HV_MMU_UNMAP_ADDR_TRAP, %o1
+	retl
+	 nop
+
 __hypervisor_flush_tlb_pending: /* 16 insns */
 	/* %o0 = context, %o1 = nr, %o2 = vaddrs[] */
 	sllx		%o1, 3, %g1
@@ -339,6 +405,13 @@ cheetah_patch_cachetlbops:
 	call		tlb_patch_one
 	 mov		19, %o2
 
+	sethi		%hi(__flush_tlb_page), %o0
+	or		%o0, %lo(__flush_tlb_page), %o0
+	sethi		%hi(__cheetah_flush_tlb_page), %o1
+	or		%o1, %lo(__cheetah_flush_tlb_page), %o1
+	call		tlb_patch_one
+	 mov		22, %o2
+
 	sethi		%hi(__flush_tlb_pending), %o0
 	or		%o0, %lo(__flush_tlb_pending), %o0
 	sethi		%hi(__cheetah_flush_tlb_pending), %o1
@@ -397,10 +470,9 @@ xcall_flush_tlb_mm:	/* 21 insns */
 	nop
 	nop
 
-	.globl		xcall_flush_tlb_pending
-xcall_flush_tlb_pending:	/* 21 insns */
-	/* %g5=context, %g1=nr, %g7=vaddrs[] */
-	sllx		%g1, 3, %g1
+	.globl		xcall_flush_tlb_page
+xcall_flush_tlb_page:	/* 17 insns */
+	/* %g5=context, %g1=vaddr */
 	mov		PRIMARY_CONTEXT, %g4
 	ldxa		[%g4] ASI_DMMU, %g2
 	srlx		%g2, CTX_PGSZ1_NUC_SHIFT, %g4
@@ -408,20 +480,16 @@ xcall_flush_tlb_pending:	/* 21 insns */
 	or		%g5, %g4, %g5
 	mov		PRIMARY_CONTEXT, %g4
 	stxa		%g5, [%g4] ASI_DMMU
-1:	sub		%g1, (1 << 3), %g1
-	ldx		[%g7 + %g1], %g5
-	andcc		%g5, 0x1, %g0
+	andcc		%g1, 0x1, %g0
 	be,pn		%icc, 2f
-
-	 andn		%g5, 0x1, %g5
+	 andn		%g1, 0x1, %g5
 	stxa		%g0, [%g5] ASI_IMMU_DEMAP
 2:	stxa		%g0, [%g5] ASI_DMMU_DEMAP
 	membar		#Sync
-	brnz,pt		%g1, 1b
-	 nop
 	stxa		%g2, [%g4] ASI_DMMU
 	retry
 	nop
+	nop
 
 	.globl		xcall_flush_tlb_kernel_range
 xcall_flush_tlb_kernel_range:	/* 25 insns */
@@ -596,15 +664,13 @@ __hypervisor_xcall_flush_tlb_mm: /* 21 insns */
 	membar		#Sync
 	retry
 
-	.globl		__hypervisor_xcall_flush_tlb_pending
-__hypervisor_xcall_flush_tlb_pending: /* 21 insns */
-	/* %g5=ctx, %g1=nr, %g7=vaddrs[], %g2,%g3,%g4,g6=scratch */
-	sllx		%g1, 3, %g1
+	.globl		__hypervisor_xcall_flush_tlb_page
+__hypervisor_xcall_flush_tlb_page: /* 17 insns */
+	/* %g5=ctx, %g1=vaddr */
 	mov		%o0, %g2
 	mov		%o1, %g3
 	mov		%o2, %g4
-1:	sub		%g1, (1 << 3), %g1
-	ldx		[%g7 + %g1], %o0	/* ARG0: virtual address */
+	mov		%g1, %o0	        /* ARG0: virtual address */
 	mov		%g5, %o1		/* ARG1: mmu context */
 	mov		HV_MMU_ALL, %o2		/* ARG2: flags */
 	srlx		%o0, PAGE_SHIFT, %o0
@@ -613,8 +679,6 @@ __hypervisor_xcall_flush_tlb_pending: /* 21 insns */
 	mov		HV_MMU_UNMAP_ADDR_TRAP, %g6
 	brnz,a,pn	%o0, __hypervisor_tlb_xcall_error
 	 mov		%o0, %g5
-	brnz,pt		%g1, 1b
-	 nop
 	mov		%g2, %o0
 	mov		%g3, %o1
 	mov		%g4, %o2
@@ -697,6 +761,13 @@ hypervisor_patch_cachetlbops:
 	call		tlb_patch_one
 	 mov		10, %o2
 
+	sethi		%hi(__flush_tlb_page), %o0
+	or		%o0, %lo(__flush_tlb_page), %o0
+	sethi		%hi(__hypervisor_flush_tlb_page), %o1
+	or		%o1, %lo(__hypervisor_flush_tlb_page), %o1
+	call		tlb_patch_one
+	 mov		11, %o2
+
 	sethi		%hi(__flush_tlb_pending), %o0
 	or		%o0, %lo(__flush_tlb_pending), %o0
 	sethi		%hi(__hypervisor_flush_tlb_pending), %o1
@@ -728,12 +799,12 @@ hypervisor_patch_cachetlbops:
 	call		tlb_patch_one
 	 mov		21, %o2
 
-	sethi		%hi(xcall_flush_tlb_pending), %o0
-	or		%o0, %lo(xcall_flush_tlb_pending), %o0
-	sethi		%hi(__hypervisor_xcall_flush_tlb_pending), %o1
-	or		%o1, %lo(__hypervisor_xcall_flush_tlb_pending), %o1
+	sethi		%hi(xcall_flush_tlb_page), %o0
+	or		%o0, %lo(xcall_flush_tlb_page), %o0
+	sethi		%hi(__hypervisor_xcall_flush_tlb_page), %o1
+	or		%o1, %lo(__hypervisor_xcall_flush_tlb_page), %o1
 	call		tlb_patch_one
-	 mov		21, %o2
+	 mov		17, %o2
 
 	sethi		%hi(xcall_flush_tlb_kernel_range), %o0
 	or		%o0, %lo(xcall_flush_tlb_kernel_range), %o0
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 187c294..54082f7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -126,8 +126,14 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 };
 
 static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
+	EVENT_EXTRA_END
+};
+
+static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
 	EVENT_EXTRA_END
 };
 
@@ -1920,7 +1926,10 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 45)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 18b55fa..0b4f9c7 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1533,8 +1533,11 @@ static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
 	switch (action) {
 	case CPU_UP_PREPARE:
 		xen_vcpu_setup(cpu);
-		if (xen_have_vector_callback)
+		if (xen_have_vector_callback) {
 			xen_init_lock_cpu(cpu);
+			if (xen_feature(XENFEAT_hvm_safe_pvclock))
+				xen_setup_timer(cpu);
+		}
 		break;
 	default:
 		break;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index afb250d..caeff44 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -669,6 +669,8 @@ static void xen_hvm_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
+	xen_uninit_lock_cpu(cpu);
+	xen_teardown_timer(cpu);
 	native_cpu_die(cpu);
 }
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0296a95..054cc01 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -497,7 +497,11 @@ static void xen_hvm_setup_cpu_clockevents(void)
 {
 	int cpu = smp_processor_id();
 	xen_setup_runstate_info(cpu);
-	xen_setup_timer(cpu);
+	/*
+	 * xen_setup_timer(cpu) - snprintf is bad in atomic context. Hence
+	 * doing it xen_hvm_cpu_notify (which gets called by smp_init during
+	 * early bootup and also during CPU hotplug events).
+	 */
 	xen_setup_cpu_clockevents();
 }
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index ef5356c..0262210 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -161,6 +161,8 @@ static int hash_recvmsg(struct kiocb *unused, struct socket *sock,
 	else if (len < ds)
 		msg->msg_flags |= MSG_TRUNC;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	if (ctx->more) {
 		ctx->more = 0;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..a1c4f0a 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -432,6 +432,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 	long copied = 0;
 
 	lock_sock(sk);
+	msg->msg_namelen = 0;
 	for (iov = msg->msg_iov, iovlen = msg->msg_iovlen; iovlen > 0;
 	     iovlen--, iov++) {
 		unsigned long seglen = iov->iov_len;
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 7aff631..5b0f075 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -247,8 +247,8 @@ static acpi_status acpi_pci_query_osc(struct acpi_pci_root *root,
 		*control &= OSC_PCI_CONTROL_MASKS;
 		capbuf[OSC_CONTROL_TYPE] = *control | root->osc_control_set;
 	} else {
-		/* Run _OSC query for all possible controls. */
-		capbuf[OSC_CONTROL_TYPE] = OSC_PCI_CONTROL_MASKS;
+		/* Run _OSC query only with existing controls. */
+		capbuf[OSC_CONTROL_TYPE] = root->osc_control_set;
 	}
 
 	status = acpi_pci_run_osc(root->device->handle, capbuf, &result);
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index dfd7876..0ff5c2e 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -373,26 +373,14 @@ static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
 	struct hpet_dev *devp;
 	unsigned long addr;
 
-	if (((vma->vm_end - vma->vm_start) != PAGE_SIZE) || vma->vm_pgoff)
-		return -EINVAL;
-
 	devp = file->private_data;
 	addr = devp->hd_hpets->hp_hpet_phys;
 
 	if (addr & (PAGE_SIZE - 1))
 		return -ENOSYS;
 
-	vma->vm_flags |= VM_IO;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
-					PAGE_SIZE, vma->vm_page_prot)) {
-		printk(KERN_ERR "%s: io_remap_pfn_range failed\n",
-			__func__);
-		return -EAGAIN;
-	}
-
-	return 0;
+	return vm_iomap_memory(vma, addr, PAGE_SIZE);
 #else
 	return -ENOSYS;
 #endif
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index e75d794..78486c7 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -421,11 +421,6 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 	if (INTEL_INFO(dev)->gen >= 6)
 		I915_WRITE(MI_MODE, _MASKED_BIT_ENABLE(ASYNC_FLIP_PERF_DISABLE));
 
-	/* Required for the hardware to program scanline values for waiting */
-	if (INTEL_INFO(dev)->gen == 6)
-		I915_WRITE(GFX_MODE,
-			   _MASKED_BIT_ENABLE(GFX_TLB_INVALIDATE_ALWAYS));
-
 	if (IS_GEN7(dev))
 		I915_WRITE(GFX_MODE_GEN7,
 			   _MASKED_BIT_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8a6f63c..cc4d68d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1629,8 +1629,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 					     sector, count, 1) == 0)
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset == 0)
-		rdev->badblocks.shift = -1;
+	} else if (sb->bblog_offset != 0)
+		rdev->badblocks.shift = 0;
 
 	if (!refdev) {
 		ret = 1;
@@ -3280,7 +3280,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	 * be used - I wonder if that matters
 	 */
 	rdev->badblocks.count = 0;
-	rdev->badblocks.shift = 0;
+	rdev->badblocks.shift = -1; /* disabled until explicitly enabled */
 	rdev->badblocks.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	seqlock_init(&rdev->badblocks.lock);
 	if (rdev->badblocks.page == NULL)
@@ -3352,9 +3352,6 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 			goto abort_free;
 		}
 	}
-	if (super_format == -1)
-		/* hot-add for 0.90, or non-persistent: so no badblocks */
-		rdev->badblocks.shift = -1;
 
 	return rdev;
 
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 2cfb1a8..9e33653 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1132,36 +1132,17 @@ static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
 	struct map_info *map = mtd->priv;
-	unsigned long start;
-	unsigned long off;
-	u32 len;
 
         /* This is broken because it assumes the MTD device is map-based
 	   and that mtd->priv is a valid struct map_info.  It should be
 	   replaced with something that uses the mtd_get_unmapped_area()
 	   operation properly. */
 	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
-		off = vma->vm_pgoff << PAGE_SHIFT;
-		start = map->phys;
-		len = PAGE_ALIGN((start & ~PAGE_MASK) + map->size);
-		start &= PAGE_MASK;
-		if ((vma->vm_end - vma->vm_start + off) > len)
-			return -EINVAL;
-
-		off += start;
-		vma->vm_pgoff = off >> PAGE_SHIFT;
-		vma->vm_flags |= VM_IO | VM_RESERVED;
-
 #ifdef pgprot_noncached
-		if (file->f_flags & O_DSYNC || off >= __pa(high_memory))
+		if (file->f_flags & O_DSYNC || map->phys >= __pa(high_memory))
 			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 #endif
-		if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				       vma->vm_end - vma->vm_start,
-				       vma->vm_page_prot))
-			return -EAGAIN;
-
-		return 0;
+		return vm_iomap_memory(vma, map->phys, map->size);
 	}
 	return -ENOSYS;
 #else
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 1a6b118..1e1ae64 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1897,6 +1897,7 @@ err_detach:
 	write_unlock_bh(&bond->lock);
 
 err_close:
+	slave_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(slave_dev);
 
 err_unset_master:
@@ -4870,9 +4871,18 @@ static int __net_init bond_net_init(struct net *net)
 static void __net_exit bond_net_exit(struct net *net)
 {
 	struct bond_net *bn = net_generic(net, bond_net_id);
+	struct bonding *bond, *tmp_bond;
+	LIST_HEAD(list);
 
 	bond_destroy_sysfs(bn);
 	bond_destroy_proc_dir(bn);
+
+	/* Kill off any bonds created after unregistering bond rtnl ops */
+	rtnl_lock();
+	list_for_each_entry_safe(bond, tmp_bond, &bn->dev_list, bond_list)
+		unregister_netdevice_queue(bond->dev, &list);
+	unregister_netdevice_many(&list);
+	rtnl_unlock();
 }
 
 static struct pernet_operations bond_net_ops = {
diff --git a/drivers/net/can/mcp251x.c b/drivers/net/can/mcp251x.c
index 9d60742..a17c048 100644
--- a/drivers/net/can/mcp251x.c
+++ b/drivers/net/can/mcp251x.c
@@ -922,6 +922,7 @@ static int mcp251x_open(struct net_device *net)
 	struct mcp251x_priv *priv = netdev_priv(net);
 	struct spi_device *spi = priv->spi;
 	struct mcp251x_platform_data *pdata = spi->dev.platform_data;
+	unsigned long flags;
 	int ret;
 
 	ret = open_candev(net);
@@ -938,9 +939,14 @@ static int mcp251x_open(struct net_device *net)
 	priv->tx_skb = NULL;
 	priv->tx_len = 0;
 
+	flags = IRQF_ONESHOT;
+	if (pdata->irq_flags)
+		flags |= pdata->irq_flags;
+	else
+		flags |= IRQF_TRIGGER_FALLING;
+
 	ret = request_threaded_irq(spi->irq, NULL, mcp251x_can_ist,
-		  pdata->irq_flags ? pdata->irq_flags : IRQF_TRIGGER_FALLING,
-		  DEVICE_NAME, priv);
+				   flags, DEVICE_NAME, priv);
 	if (ret) {
 		dev_err(&spi->dev, "failed to acquire irq %d\n", spi->irq);
 		if (pdata->transceiver_enable)
diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index f2683eb..c505b55 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -94,8 +94,8 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 	struct net_device *dev;
 	struct sja1000_priv *priv;
 	struct resource res;
-	const u32 *prop;
-	int err, irq, res_size, prop_size;
+	u32 prop;
+	int err, irq, res_size;
 	void __iomem *base;
 
 	err = of_address_to_resource(np, 0, &res);
@@ -136,27 +136,27 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 	priv->read_reg = sja1000_ofp_read_reg;
 	priv->write_reg = sja1000_ofp_write_reg;
 
-	prop = of_get_property(np, "nxp,external-clock-frequency", &prop_size);
-	if (prop && (prop_size ==  sizeof(u32)))
-		priv->can.clock.freq = *prop / 2;
+	err = of_property_read_u32(np, "nxp,external-clock-frequency", &prop);
+	if (!err)
+		priv->can.clock.freq = prop / 2;
 	else
 		priv->can.clock.freq = SJA1000_OFP_CAN_CLOCK; /* default */
 
-	prop = of_get_property(np, "nxp,tx-output-mode", &prop_size);
-	if (prop && (prop_size == sizeof(u32)))
-		priv->ocr |= *prop & OCR_MODE_MASK;
+	err = of_property_read_u32(np, "nxp,tx-output-mode", &prop);
+	if (!err)
+		priv->ocr |= prop & OCR_MODE_MASK;
 	else
 		priv->ocr |= OCR_MODE_NORMAL; /* default */
 
-	prop = of_get_property(np, "nxp,tx-output-config", &prop_size);
-	if (prop && (prop_size == sizeof(u32)))
-		priv->ocr |= (*prop << OCR_TX_SHIFT) & OCR_TX_MASK;
+	err = of_property_read_u32(np, "nxp,tx-output-config", &prop);
+	if (!err)
+		priv->ocr |= (prop << OCR_TX_SHIFT) & OCR_TX_MASK;
 	else
 		priv->ocr |= OCR_TX0_PULLDOWN; /* default */
 
-	prop = of_get_property(np, "nxp,clock-out-frequency", &prop_size);
-	if (prop && (prop_size == sizeof(u32)) && *prop) {
-		u32 divider = priv->can.clock.freq * 2 / *prop;
+	err = of_property_read_u32(np, "nxp,clock-out-frequency", &prop);
+	if (!err && prop) {
+		u32 divider = priv->can.clock.freq * 2 / prop;
 
 		if (divider > 1)
 			priv->cdr |= divider / 2 - 1;
@@ -166,8 +166,7 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 		priv->cdr |= CDR_CLK_OFF; /* default */
 	}
 
-	prop = of_get_property(np, "nxp,no-comparator-bypass", NULL);
-	if (!prop)
+	if (!of_property_read_bool(np, "nxp,no-comparator-bypass"))
 		priv->cdr |= CDR_CBP; /* default */
 
 	priv->irq_flags = IRQF_SHARED;
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
index edfdf6b..b5fd934 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
@@ -186,7 +186,7 @@ struct atl1e_tpd_desc {
 /* how about 0x2000 */
 #define MAX_TX_BUF_LEN      0x2000
 #define MAX_TX_BUF_SHIFT    13
-/*#define MAX_TX_BUF_LEN  0x3000 */
+#define MAX_TSO_SEG_SIZE    0x3c00
 
 /* rrs word 1 bit 0:31 */
 #define RRS_RX_CSUM_MASK	0xFFFF
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 38f7093..56b04c4 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2352,6 +2352,7 @@ static int __devinit atl1e_probe(struct pci_dev *pdev,
 
 	INIT_WORK(&adapter->reset_task, atl1e_reset_task);
 	INIT_WORK(&adapter->link_chg_task, atl1e_link_chg_task);
+	netif_set_gso_max_size(netdev, MAX_TSO_SEG_SIZE);
 	err = register_netdev(netdev);
 	if (err) {
 		netdev_err(netdev, "register netdevice failed\n");
diff --git a/drivers/net/ethernet/freescale/gianfar_ptp.c b/drivers/net/ethernet/freescale/gianfar_ptp.c
index 0daa66b..d81c7af 100644
--- a/drivers/net/ethernet/freescale/gianfar_ptp.c
+++ b/drivers/net/ethernet/freescale/gianfar_ptp.c
@@ -127,7 +127,6 @@ struct gianfar_ptp_registers {
 
 #define DRIVER		"gianfar_ptp"
 #define DEFAULT_CKSEL	1
-#define N_ALARM		1 /* first alarm is used internally to reset fipers */
 #define N_EXT_TS	2
 #define REG_SIZE	sizeof(struct gianfar_ptp_registers)
 
@@ -410,7 +409,7 @@ static struct ptp_clock_info ptp_gianfar_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "gianfar clock",
 	.max_adj	= 512000,
-	.n_alarm	= N_ALARM,
+	.n_alarm	= 0,
 	.n_ext_ts	= N_EXT_TS,
 	.n_per_out	= 0,
 	.pps		= 1,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ab8d882..543659a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2293,6 +2293,16 @@ static irqreturn_t ixgbe_msix_other(int irq, void *data)
 	 * with the write to EICR.
 	 */
 	eicr = IXGBE_READ_REG(hw, IXGBE_EICS);
+
+	/* The lower 16bits of the EICR register are for the queue interrupts
+	 * which should be masked here in order to not accidently clear them if
+	 * the bits are high when ixgbe_msix_other is called. There is a race
+	 * condition otherwise which results in possible performance loss
+	 * especially if the ixgbe_msix_other interrupt is triggering
+	 * consistently (as it would when PPS is turned on for the X540 device)
+	 */
+	eicr &= 0xFFFF0000;
+
 	IXGBE_WRITE_REG(hw, IXGBE_EICR, eicr);
 
 	if (eicr & IXGBE_EICR_LSC)
diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index 06b3f0d..c16bea4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -648,7 +648,7 @@ static const u32 ar9580_1p0_mac_core[][2] = {
 	{0x00008258, 0x00000000},
 	{0x0000825c, 0x40000000},
 	{0x00008260, 0x00080922},
-	{0x00008264, 0x9bc00010},
+	{0x00008264, 0x9d400010},
 	{0x00008268, 0xffffffff},
 	{0x0000826c, 0x0000ffff},
 	{0x00008270, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 25213d5..21c280b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -774,7 +774,7 @@ static int ath9k_init_firmware_version(struct ath9k_htc_priv *priv)
 	 * required version.
 	 */
 	if (priv->fw_version_major != MAJOR_VERSION_REQ ||
-	    priv->fw_version_minor != MINOR_VERSION_REQ) {
+	    priv->fw_version_minor < MINOR_VERSION_REQ) {
 		dev_err(priv->dev, "ath9k_htc: Please upgrade to FW version %d.%d\n",
 			MAJOR_VERSION_REQ, MINOR_VERSION_REQ);
 		return -EINVAL;
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6be2f73..4ce3e1f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4582,7 +4582,8 @@ static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 #endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
-		/* FIXME */
+		ssb_pmu_spuravoid_pllupdate(&dev->dev->sdev->bus->chipco,
+					    avoid);
 		break;
 #endif
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 287fdd0..b4f0661 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -723,6 +723,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct iwl_addsta_cmd sta_cmd;
+	static const struct iwl_link_quality_cmd zero_lq = {};
 	struct iwl_link_quality_cmd lq;
 	int i;
 	bool found = false;
@@ -761,7 +762,9 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 				else
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
-				send_lq = true;
+
+				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);
 			ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 5000690..ba376ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2248,15 +2248,15 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	char *buf;
-	int pos = 0;
-	ssize_t ret = -ENOMEM;
+	char *buf = NULL;
+	ssize_t ret;
 
-	ret = pos = iwl_dump_nic_event_log(priv, true, &buf, true);
-	if (buf) {
-		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-		kfree(buf);
-	}
+	ret = iwl_dump_nic_event_log(priv, true, &buf, true);
+	if (ret < 0)
+		goto err;
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
+err:
+	kfree(buf);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 0bbea88..b7a5387 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1831,9 +1831,9 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	if (pdev) {
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
-
-		pci_release_regions(pdev);
 		pci_disable_device(pdev);
+		pci_release_region(pdev, 2);
+		pci_release_region(pdev, 0);
 		pci_set_drvdata(pdev, NULL);
 	}
 }
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 346af52..6d0c1ec 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3862,7 +3862,9 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
 
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-		!rt2x00_rt(rt2x00dev, RT5392)) {
+	    !rt2x00_rt(rt2x00dev, RT5392)) {
+		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
+
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -3873,8 +3875,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 				      &rt2x00dev->cap_flags))
 				rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
 		}
-		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
-				  drv_data->txmixer_gain_24g);
+		if (drv_data->txmixer_gain_24g >= min_gain) {
+			rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+					  drv_data->txmixer_gain_24g);
+		}
 		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 	}
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 447e834..fa7c0f0 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -674,15 +674,11 @@ static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
 		error = platform_pci_set_power_state(dev, state);
 		if (!error)
 			pci_update_current_state(dev, state);
-		/* Fall back to PCI_D0 if native PM is not supported */
-		if (!dev->pm_cap)
-			dev->current_state = PCI_D0;
-	} else {
+	} else
 		error = -ENODEV;
-		/* Fall back to PCI_D0 if native PM is not supported */
-		if (!dev->pm_cap)
-			dev->current_state = PCI_D0;
-	}
+
+	if (error && !dev->pm_cap) /* Fall back to PCI_D0 */
+		dev->current_state = PCI_D0;
 
 	return error;
 }
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8b4b382..4a4d12e 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2769,9 +2769,13 @@ int regulator_bulk_enable(int num_consumers,
 	return 0;
 
 err:
-	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
-	while (--i >= 0)
-		regulator_disable(consumers[i].consumer);
+	for (i = 0; i < num_consumers; i++) {
+		if (consumers[i].ret < 0)
+			pr_err("Failed to enable %s: %d\n", consumers[i].supply,
+			       consumers[i].ret);
+		else
+			regulator_disable(consumers[i].consumer);
+	}
 
 	return ret;
 }
diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index dc474bc..9f2762c 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -297,7 +297,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	if (ret) {
 		printk(KERN_ERR "at91_rtc: IRQ %d already in use.\n",
 				irq);
-		return ret;
+		goto err_unmap;
 	}
 
 	/* cpu init code should really have flagged this device as
@@ -309,13 +309,20 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&at91_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
-		free_irq(irq, pdev);
-		return PTR_ERR(rtc);
+		ret = PTR_ERR(rtc);
+		goto err_free_irq;
 	}
 	platform_set_drvdata(pdev, rtc);
 
 	printk(KERN_INFO "AT91 Real Time Clock driver.\n");
 	return 0;
+
+err_free_irq:
+	free_irq(irq, pdev);
+err_unmap:
+	iounmap(at91_rtc_regs);
+
+	return ret;
 }
 
 /*
@@ -332,6 +339,7 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	free_irq(irq, pdev);
 
 	rtc_device_unregister(rtc);
+	iounmap(at91_rtc_regs);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 4267789..6a4adf7 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -805,9 +805,8 @@ static int cmos_suspend(struct device *dev)
 			mask = RTC_IRQMASK;
 		tmp &= ~mask;
 		CMOS_WRITE(tmp, RTC_CONTROL);
+		hpet_mask_rtc_irq_bit(mask);
 
-		/* shut down hpet emulation - we don't need it for alarm */
-		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
 		cmos_checkintr(cmos, tmp);
 	}
 	spin_unlock_irq(&rtc_lock);
@@ -872,6 +871,7 @@ static int cmos_resume(struct device *dev)
 			rtc_update_irq(cmos->rtc, 1, mask);
 			tmp &= ~RTC_AIE;
 			hpet_mask_rtc_irq_bit(RTC_AIE);
+			hpet_rtc_timer_init();
 		} while (mask & RTC_AIE);
 		spin_unlock_irq(&rtc_lock);
 	}
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 766cb7b..1845ab5 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -529,6 +529,8 @@ static void __init sclp_add_standby_memory(void)
 	add_memory_merged(0);
 }
 
+#define MEM_SCT_SIZE (1UL << SECTION_SIZE_BITS)
+
 static void __init insert_increment(u16 rn, int standby, int assigned)
 {
 	struct memory_increment *incr, *new_incr;
@@ -541,7 +543,7 @@ static void __init insert_increment(u16 rn, int standby, int assigned)
 	new_incr->rn = rn;
 	new_incr->standby = standby;
 	if (!standby)
-		new_incr->usecount = 1;
+		new_incr->usecount = rzm > MEM_SCT_SIZE ? rzm/MEM_SCT_SIZE : 1;
 	last_rn = 0;
 	prev = &sclp_mem_list;
 	list_for_each_entry(incr, &sclp_mem_list, list) {
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index b58fef7..1fb9b22 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -645,3 +645,32 @@ u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc)
 		return 0;
 	}
 }
+
+void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid)
+{
+	u32 pmu_ctl = 0;
+
+	switch (cc->dev->bus->chip_id) {
+	case 0x4322:
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL0, 0x11100070);
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL1, 0x1014140a);
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL5, 0x88888854);
+		if (spuravoid == 1)
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x05201828);
+		else
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x05001828);
+		pmu_ctl = SSB_CHIPCO_PMU_CTL_PLL_UPD;
+		break;
+	case 43222:
+		/* TODO: BCM43222 requires updating PLLs too */
+		return;
+	default:
+		ssb_printk(KERN_ERR PFX
+			   "Unknown spuravoidance settings for chip 0x%04X, not changing PLL\n",
+			   cc->dev->bus->chip_id);
+		return;
+	}
+
+	chipco_set32(cc, SSB_CHIPCO_PMU_CTL, pmu_ctl);
+}
+EXPORT_SYMBOL_GPL(ssb_pmu_spuravoid_pllupdate);
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index ce53594..33b1526 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -616,6 +616,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	nonseekable_open(inode, filp);
 
+	/* We refuse fsnotify events on ptmx, since it's a shared resource */
+	filp->f_mode |= FMODE_NONOTIFY;
+
 	retval = tty_alloc_file(filp);
 	if (retval)
 		return retval;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 246b823..4185cc5 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1877,6 +1877,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
+	put_device(tty_dev);
+
 	if (console_suspend_enabled || !uart_console(uport))
 		uport->suspended = 1;
 
@@ -1942,9 +1944,11 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 			disable_irq_wake(uport->irq);
 			uport->irq_wake = 0;
 		}
+		put_device(tty_dev);
 		mutex_unlock(&port->mutex);
 		return 0;
 	}
+	put_device(tty_dev);
 	uport->suspended = 0;
 
 	/*
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..67ea9cf 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -939,6 +939,14 @@ void start_tty(struct tty_struct *tty)
 
 EXPORT_SYMBOL(start_tty);
 
+/* We limit tty time update visibility to every 8 seconds or so. */
+static void tty_update_time(struct timespec *time)
+{
+	unsigned long sec = get_seconds() & ~7;
+	if ((long)(sec - time->tv_sec) > 0)
+		time->tv_sec = sec;
+}
+
 /**
  *	tty_read	-	read method for tty device files
  *	@file: pointer to tty file
@@ -975,8 +983,10 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	else
 		i = -EIO;
 	tty_ldisc_deref(ld);
+
 	if (i > 0)
-		inode->i_atime = current_fs_time(inode->i_sb);
+		tty_update_time(&inode->i_atime);
+
 	return i;
 }
 
@@ -1079,7 +1089,7 @@ static inline ssize_t do_tty_write(
 	}
 	if (written) {
 		struct inode *inode = file->f_path.dentry->d_inode;
-		inode->i_mtime = current_fs_time(inode->i_sb);
+		tty_update_time(&inode->i_mtime);
 		ret = written;
 	}
 out:
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index ea271d7..113b4f1 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -439,6 +439,8 @@ static int _hardware_enqueue(struct ci13xxx_ep *mEp, struct ci13xxx_req *mReq)
 		mReq->ptr->page[i] =
 			(mReq->req.dma + i * CI13XXX_PAGE_SIZE) & ~TD_RESERVED_MASK;
 
+	wmb();
+
 	if (!list_empty(&mEp->qh.queue)) {
 		struct ci13xxx_req *mReqPrev;
 		int n = hw_ep_bit(mEp->num, mEp->dir);
@@ -539,6 +541,12 @@ __acquires(mEp->lock)
 		struct ci13xxx_req *mReq = \
 			list_entry(mEp->qh.queue.next,
 				   struct ci13xxx_req, queue);
+
+		if (mReq->zptr) {
+			dma_pool_free(mEp->td_pool, mReq->zptr, mReq->zdma);
+			mReq->zptr = NULL;
+		}
+
 		list_del_init(&mReq->queue);
 		mReq->req.status = -ESHUTDOWN;
 
diff --git a/drivers/usb/chipidea/udc.h b/drivers/usb/chipidea/udc.h
index 4ff2384d..d12e8b5 100644
--- a/drivers/usb/chipidea/udc.h
+++ b/drivers/usb/chipidea/udc.h
@@ -40,7 +40,7 @@ struct ci13xxx_td {
 #define TD_CURR_OFFSET        (0x0FFFUL <<  0)
 #define TD_FRAME_NUM          (0x07FFUL <<  0)
 #define TD_RESERVED_MASK      (0x0FFFUL <<  0)
-} __attribute__ ((packed));
+} __attribute__ ((packed, aligned(4)));
 
 /* DMA layout of queue heads */
 struct ci13xxx_qh {
@@ -57,7 +57,7 @@ struct ci13xxx_qh {
 	/* 9 */
 	u32 RESERVED;
 	struct usb_ctrlrequest   setup;
-} __attribute__ ((packed));
+} __attribute__ ((packed, aligned(4)));
 
 /**
  * struct ci13xxx_req - usb request representation
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 62679bc..f70b887 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -681,6 +681,8 @@ static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
 	index &= 0xff;
 	switch (requesttype & USB_RECIP_MASK) {
 	case USB_RECIP_ENDPOINT:
+		if ((index & ~USB_DIR_IN) == 0)
+			return 0;
 		ret = findintfep(ps->dev, index);
 		if (ret >= 0)
 			ret = checkintf(ps, ret);
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 0fc6e5f..ba6a5d6 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -63,6 +63,7 @@ static const struct usb_device_id appledisplay_table[] = {
 	{ APPLEDISPLAY_DEVICE(0x9219) },
 	{ APPLEDISPLAY_DEVICE(0x921c) },
 	{ APPLEDISPLAY_DEVICE(0x921d) },
+	{ APPLEDISPLAY_DEVICE(0x9236) },
 
 	/* Terminating entry */
 	{ }
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index a93f958..d5b9a74 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -195,6 +195,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_THROTTLE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GATEWAY_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_GBM_BOOST_PID) },
 	{ USB_DEVICE(NEWPORT_VID, NEWPORT_AGILIS_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
@@ -876,7 +877,9 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_DOTEC_PID) },
 	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
-	{ USB_DEVICE(ST_VID, ST_STMCLT1030_PID),
+	{ USB_DEVICE(ST_VID, ST_STMCLT_2232_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ST_VID, ST_STMCLT_4232_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_stmclite_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_RF_R106) },
 	{ USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
@@ -1796,20 +1799,24 @@ static int ftdi_8u2232c_probe(struct usb_serial *serial)
 }
 
 /*
- * First and second port on STMCLiteadaptors is reserved for JTAG interface
- * and the forth port for pio
+ * First two ports on JTAG adaptors using an FT4232 such as STMicroelectronics's
+ * ST Micro Connect Lite are reserved for JTAG or other non-UART interfaces and
+ * can be accessed from userspace.
+ * The next two ports are enabled as UARTs by default, where port 2 is
+ * a conventional RS-232 UART.
  */
 static int ftdi_stmclite_probe(struct usb_serial *serial)
 {
 	struct usb_device *udev = serial->dev;
 	struct usb_interface *interface = serial->interface;
 
-	if (interface == udev->actconfig->interface[2])
-		return 0;
-
-	dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+	if (interface == udev->actconfig->interface[0] ||
+	    interface == udev->actconfig->interface[1]) {
+		dev_info(&udev->dev, "Ignoring serial port reserved for JTAG\n");
+		return -ENODEV;
+	}
 
-	return -ENODEV;
+	return 0;
 }
 
 /*
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index e79861e..9852827 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -74,6 +74,7 @@
 #define FTDI_OPENDCC_THROTTLE_PID	0xBFDA
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
 #define FTDI_OPENDCC_GBM_PID	0xBFDC
+#define FTDI_OPENDCC_GBM_BOOST_PID	0xBFDD
 
 /* NZR SEM 16+ USB (http://www.nzr.de) */
 #define FTDI_NZR_SEM_USB_PID	0xC1E0	/* NZR SEM-LOG16+ */
@@ -1150,7 +1151,8 @@
  * STMicroelectonics
  */
 #define ST_VID			0x0483
-#define ST_STMCLT1030_PID	0x3747 /* ST Micro Connect Lite STMCLT1030 */
+#define ST_STMCLT_2232_PID	0x3746
+#define ST_STMCLT_4232_PID	0x3747
 
 /*
  * Papouch products (http://www.papouch.com/)
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index dd442c0..c5a50c9 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -347,6 +347,7 @@ static void option_instat_callback(struct urb *urb);
 /* Olivetti products */
 #define OLIVETTI_VENDOR_ID			0x0b3c
 #define OLIVETTI_PRODUCT_OLICARD100		0xc000
+#define OLIVETTI_PRODUCT_OLICARD145		0xc003
 
 /* Celot products */
 #define CELOT_VENDOR_ID				0x211f
@@ -1273,6 +1274,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, CINTERION_PRODUCT_HC28_MDMNET) },
 
 	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD100) },
+	{ USB_DEVICE(OLIVETTI_VENDOR_ID, OLIVETTI_PRODUCT_OLICARD145) },
 	{ USB_DEVICE(CELOT_VENDOR_ID, CELOT_PRODUCT_CT680M) }, /* CT-650 CDMA 450 1xEVDO modem */
 	{ USB_DEVICE(ONDA_VENDOR_ID, ONDA_MT825UP) }, /* ONDA MT825UP modem */
 	{ USB_DEVICE_AND_INTERFACE_INFO(SAMSUNG_VENDOR_ID, SAMSUNG_PRODUCT_GT_B3730, USB_CLASS_CDC_DATA, 0x00, 0x00) }, /* Samsung GT-B3730 LTE USB modem.*/
@@ -1350,6 +1352,12 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(CHANGHONG_VENDOR_ID, CHANGHONG_PRODUCT_CH690) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d01, 0xff, 0x02, 0x01) },	/* D-Link DWM-156 (variant) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d01, 0xff, 0x00, 0x00) },	/* D-Link DWM-156 (variant) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d02, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d02, 0xff, 0x00, 0x00) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x02, 0x01) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x7d03, 0xff, 0x00, 0x00) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 5fe451d..c1f6751 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -248,14 +248,26 @@ static int cypress_probe(struct usb_interface *intf,
 {
 	struct us_data *us;
 	int result;
+	struct usb_device *device;
 
 	result = usb_stor_probe1(&us, intf, id,
 			(id - cypress_usb_ids) + cypress_unusual_dev_list);
 	if (result)
 		return result;
 
-	us->protocol_name = "Transparent SCSI with Cypress ATACB";
-	us->proto_handler = cypress_atacb_passthrough;
+	/* Among CY7C68300 chips, the A revision does not support Cypress ATACB
+	 * Filter out this revision from EEPROM default descriptor values
+	 */
+	device = interface_to_usbdev(intf);
+	if (device->descriptor.iManufacturer != 0x38 ||
+	    device->descriptor.iProduct != 0x4e ||
+	    device->descriptor.iSerialNumber != 0x64) {
+		us->protocol_name = "Transparent SCSI with Cypress ATACB";
+		us->proto_handler = cypress_atacb_passthrough;
+	} else {
+		us->protocol_name = "Transparent SCSI";
+		us->proto_handler = usb_stor_transparent_scsi_command;
+	}
 
 	result = usb_stor_probe2(us);
 	return result;
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index e4cc585..0a49456 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1373,15 +1373,12 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	struct fb_info *info = file_fb_info(file);
 	struct fb_ops *fb;
-	unsigned long off;
+	unsigned long mmio_pgoff;
 	unsigned long start;
 	u32 len;
 
 	if (!info)
 		return -ENODEV;
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
-		return -EINVAL;
-	off = vma->vm_pgoff << PAGE_SHIFT;
 	fb = info->fbops;
 	if (!fb)
 		return -ENODEV;
@@ -1393,33 +1390,24 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 		return res;
 	}
 
-	/* frame buffer memory */
+	/*
+	 * Ugh. This can be either the frame buffer mapping, or
+	 * if pgoff points past it, the mmio mapping.
+	 */
 	start = info->fix.smem_start;
-	len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.smem_len);
-	if (off >= len) {
-		/* memory mapped io */
-		off -= len;
-		if (info->var.accel_flags) {
-			mutex_unlock(&info->mm_lock);
-			return -EINVAL;
-		}
+	len = info->fix.smem_len;
+	mmio_pgoff = PAGE_ALIGN((start & ~PAGE_MASK) + len) >> PAGE_SHIFT;
+	if (vma->vm_pgoff >= mmio_pgoff) {
+		vma->vm_pgoff -= mmio_pgoff;
 		start = info->fix.mmio_start;
-		len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.mmio_len);
+		len = info->fix.mmio_len;
 	}
 	mutex_unlock(&info->mm_lock);
-	start &= PAGE_MASK;
-	if ((vma->vm_end - vma->vm_start + off) > len)
-		return -EINVAL;
-	off += start;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-	/* This is an IO map - tell maydump to skip this VMA */
-	vma->vm_flags |= VM_IO | VM_RESERVED;
+
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-	fb_pgprotect(file, vma, off);
-	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-			     vma->vm_end - vma->vm_start, vma->vm_page_prot))
-		return -EAGAIN;
-	return 0;
+	fb_pgprotect(file, vma, start);
+
+	return vm_iomap_memory(vma, start, len);
 }
 
 static int
diff --git a/fs/aio.c b/fs/aio.c
index 55c4c76..cf8e5a7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1094,9 +1094,9 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
+	kunmap_atomic(ring);
 	return ret;
 }
 
diff --git a/fs/dcache.c b/fs/dcache.c
index 458ec45..9b36632 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1254,8 +1254,10 @@ void shrink_dcache_parent(struct dentry * parent)
 	LIST_HEAD(dispose);
 	int found;
 
-	while ((found = select_parent(parent, &dispose)) != 0)
+	while ((found = select_parent(parent, &dispose)) != 0) {
 		shrink_dentry_list(&dispose);
+		cond_resched();
+	}
 }
 EXPORT_SYMBOL(shrink_dcache_parent);
 
diff --git a/fs/exec.c b/fs/exec.c
index 858423a..5a76464 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -623,7 +623,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		 * when the old and new regions overlap clear from new_end.
 		 */
 		free_pgd_range(&tlb, new_end, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	} else {
 		/*
 		 * otherwise, clean from old_start; this is done to not touch
@@ -632,7 +632,7 @@ static int shift_arg_pages(struct vm_area_struct *vma, unsigned long shift)
 		 * for the others its just a little faster.
 		 */
 		free_pgd_range(&tlb, old_start, old_end, new_end,
-			vma->vm_next ? vma->vm_next->vm_start : 0);
+			vma->vm_next ? vma->vm_next->vm_start : USER_PGTABLES_CEILING);
 	}
 	tlb_finish_mmu(&tlb, new_end, old_end);
 
@@ -905,11 +905,13 @@ static int de_thread(struct task_struct *tsk)
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
+			threadgroup_change_begin(tsk);
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			write_unlock_irq(&tasklist_lock);
+			threadgroup_change_end(tsk);
 			schedule();
 		}
 
@@ -965,6 +967,7 @@ static int de_thread(struct task_struct *tsk)
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
 		write_unlock_irq(&tasklist_lock);
+		threadgroup_change_end(tsk);
 
 		release_task(leader);
 	}
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index c22f170..e38370b 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -84,4 +84,5 @@ config EXT4_DEBUG
 	  Enables run-time debugging support for the ext4 filesystem.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-debug"
+	  with a command such as:
+		echo 1 > /sys/module/ext4/parameters/mballoc_debug
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index f440e8f1..d4253e1 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -164,16 +164,20 @@ static inline void ext4_journal_callback_add(handle_t *handle,
  * ext4_journal_callback_del: delete a registered callback
  * @handle: active journal transaction handle on which callback was registered
  * @jce: registered journal callback entry to unregister
+ * Return true if object was sucessfully removed
  */
-static inline void ext4_journal_callback_del(handle_t *handle,
+static inline bool ext4_journal_callback_try_del(handle_t *handle,
 					     struct ext4_journal_cb_entry *jce)
 {
+	bool deleted;
 	struct ext4_sb_info *sbi =
 			EXT4_SB(handle->h_transaction->t_journal->j_private);
 
 	spin_lock(&sbi->s_md_lock);
+	deleted = !list_empty(&jce->jce_list);
 	list_del_init(&jce->jce_list);
 	spin_unlock(&sbi->s_md_lock);
+	return deleted;
 }
 
 int
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index bb6c7d8..a8d03a4 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -260,8 +260,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
 		needs_barrier = true;
-	jbd2_log_start_commit(journal, commit_tid);
-	ret = jbd2_log_wait_commit(journal, commit_tid);
+	ret = jbd2_complete_transaction(journal, commit_tid);
 	if (needs_barrier)
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
  out:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c14b394..55006fa 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -55,21 +55,21 @@ static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
 	__u16 csum_hi = 0;
 	__u32 csum;
 
-	csum_lo = raw->i_checksum_lo;
+	csum_lo = le16_to_cpu(raw->i_checksum_lo);
 	raw->i_checksum_lo = 0;
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
-		csum_hi = raw->i_checksum_hi;
+		csum_hi = le16_to_cpu(raw->i_checksum_hi);
 		raw->i_checksum_hi = 0;
 	}
 
 	csum = ext4_chksum(sbi, ei->i_csum_seed, (__u8 *)raw,
 			   EXT4_INODE_SIZE(inode->i_sb));
 
-	raw->i_checksum_lo = csum_lo;
+	raw->i_checksum_lo = cpu_to_le16(csum_lo);
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
 	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
-		raw->i_checksum_hi = csum_hi;
+		raw->i_checksum_hi = cpu_to_le16(csum_hi);
 
 	return csum;
 }
@@ -216,8 +216,7 @@ void ext4_evict_inode(struct inode *inode)
 			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
 
-			jbd2_log_start_commit(journal, commit_tid);
-			jbd2_log_wait_commit(journal, commit_tid);
+			jbd2_complete_transaction(journal, commit_tid);
 			filemap_write_and_wait(&inode->i_data);
 		}
 		truncate_inode_pages(&inode->i_data, 0);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 18571ac..9777e2f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4433,11 +4433,11 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	node = rb_prev(new_node);
 	if (node) {
 		entry = rb_entry(node, struct ext4_free_data, efd_node);
-		if (can_merge(entry, new_entry)) {
+		if (can_merge(entry, new_entry) &&
+		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
 			new_entry->efd_start_cluster = entry->efd_start_cluster;
 			new_entry->efd_count += entry->efd_count;
 			rb_erase(node, &(db->bb_free_root));
-			ext4_journal_callback_del(handle, &entry->efd_jce);
 			kmem_cache_free(ext4_free_data_cachep, entry);
 		}
 	}
@@ -4445,10 +4445,10 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	node = rb_next(new_node);
 	if (node) {
 		entry = rb_entry(node, struct ext4_free_data, efd_node);
-		if (can_merge(new_entry, entry)) {
+		if (can_merge(new_entry, entry) &&
+		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
 			new_entry->efd_count += entry->efd_count;
 			rb_erase(node, &(db->bb_free_root));
-			ext4_journal_callback_del(handle, &entry->efd_jce);
 			kmem_cache_free(ext4_free_data_cachep, entry);
 		}
 	}
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index b4d5088..f0e2c96 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -7,7 +7,7 @@
 #include "ext4.h"
 
 /* Checksumming functions */
-static __u32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
+static __le32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int offset = offsetof(struct mmp_struct, mmp_checksum);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index a2289bf..097a7b0 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1255,6 +1255,8 @@ static void ext4_update_super(struct super_block *sb,
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count += flex_gd->count;
+	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
+			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 
 	/* Update the reserved block counts only once the new group is
 	 * active. */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 79881a6..df4b8db 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -480,10 +480,13 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 	struct super_block		*sb = journal->j_private;
 	struct ext4_sb_info		*sbi = EXT4_SB(sb);
 	int				error = is_journal_aborted(journal);
-	struct ext4_journal_cb_entry	*jce, *tmp;
+	struct ext4_journal_cb_entry	*jce;
 
+	BUG_ON(txn->t_state == T_FINISHED);
 	spin_lock(&sbi->s_md_lock);
-	list_for_each_entry_safe(jce, tmp, &txn->t_private_list, jce_list) {
+	while (!list_empty(&txn->t_private_list)) {
+		jce = list_entry(txn->t_private_list.next,
+				 struct ext4_journal_cb_entry, jce_list);
 		list_del_init(&jce->jce_list);
 		spin_unlock(&sbi->s_md_lock);
 		jce->jce_func(sb, jce, error);
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 4765190..73c0bd7 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -276,5 +276,5 @@ const struct file_operations fscache_stats_fops = {
 	.open		= fscache_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release        = single_release,
 };
diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index 5849e3e..32b12e5 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -517,7 +517,7 @@ void hfsplus_file_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		u32 size = inode->i_size;
+		loff_t size = inode->i_size;
 
 		res = pagecache_write_begin(NULL, mapping, size, 0,
 						AOP_FLAG_UNINTERRUPTIBLE,
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 216f429..a7826ec 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -382,7 +382,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int space_left = 0;
 	int first_tag = 0;
 	int tag_flag;
-	int i, to_free = 0;
+	int i;
 	int tag_bytes = journal_tag_bytes(journal);
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
@@ -1108,7 +1108,7 @@ restart_loop:
 	journal->j_stats.run.rs_blocks_logged += stats.run.rs_blocks_logged;
 	spin_unlock(&journal->j_history_lock);
 
-	commit_transaction->t_state = T_FINISHED;
+	commit_transaction->t_state = T_COMMIT_CALLBACK;
 	J_ASSERT(commit_transaction == journal->j_committing_transaction);
 	journal->j_commit_sequence = commit_transaction->t_tid;
 	journal->j_committing_transaction = NULL;
@@ -1123,38 +1123,44 @@ restart_loop:
 				journal->j_average_commit_time*3) / 4;
 	else
 		journal->j_average_commit_time = commit_time;
+
 	write_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL &&
-	    commit_transaction->t_checkpoint_io_list == NULL) {
-		__jbd2_journal_drop_transaction(journal, commit_transaction);
-		to_free = 1;
+	if (journal->j_checkpoint_transactions == NULL) {
+		journal->j_checkpoint_transactions = commit_transaction;
+		commit_transaction->t_cpnext = commit_transaction;
+		commit_transaction->t_cpprev = commit_transaction;
 	} else {
-		if (journal->j_checkpoint_transactions == NULL) {
-			journal->j_checkpoint_transactions = commit_transaction;
-			commit_transaction->t_cpnext = commit_transaction;
-			commit_transaction->t_cpprev = commit_transaction;
-		} else {
-			commit_transaction->t_cpnext =
-				journal->j_checkpoint_transactions;
-			commit_transaction->t_cpprev =
-				commit_transaction->t_cpnext->t_cpprev;
-			commit_transaction->t_cpnext->t_cpprev =
-				commit_transaction;
-			commit_transaction->t_cpprev->t_cpnext =
+		commit_transaction->t_cpnext =
+			journal->j_checkpoint_transactions;
+		commit_transaction->t_cpprev =
+			commit_transaction->t_cpnext->t_cpprev;
+		commit_transaction->t_cpnext->t_cpprev =
+			commit_transaction;
+		commit_transaction->t_cpprev->t_cpnext =
 				commit_transaction;
-		}
 	}
 	spin_unlock(&journal->j_list_lock);
-
+	/* Drop all spin_locks because commit_callback may be block.
+	 * __journal_remove_checkpoint() can not destroy transaction
+	 * under us because it is not marked as T_FINISHED yet */
 	if (journal->j_commit_callback)
 		journal->j_commit_callback(journal, commit_transaction);
 
 	trace_jbd2_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD2: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
-	if (to_free)
-		jbd2_journal_free_transaction(commit_transaction);
 
+	write_lock(&journal->j_state_lock);
+	spin_lock(&journal->j_list_lock);
+	commit_transaction->t_state = T_FINISHED;
+	/* Recheck checkpoint lists after j_list_lock was dropped */
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
+		__jbd2_journal_drop_transaction(journal, commit_transaction);
+		jbd2_journal_free_transaction(commit_transaction);
+	}
+	spin_unlock(&journal->j_list_lock);
+	write_unlock(&journal->j_state_lock);
 	wake_up(&journal->j_wait_done_commit);
 }
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0f16edd..dfb0e5b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -699,6 +699,37 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 }
 
 /*
+ * When this function returns the transaction corresponding to tid
+ * will be completed.  If the transaction has currently running, start
+ * committing that transaction before waiting for it to complete.  If
+ * the transaction id is stale, it is by definition already completed,
+ * so just return SUCCESS.
+ */
+int jbd2_complete_transaction(journal_t *journal, tid_t tid)
+{
+	int	need_to_wait = 1;
+
+	read_lock(&journal->j_state_lock);
+	if (journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == tid) {
+		if (journal->j_commit_request != tid) {
+			/* transaction not yet started, so request it */
+			read_unlock(&journal->j_state_lock);
+			jbd2_log_start_commit(journal, tid);
+			goto wait_commit;
+		}
+	} else if (!(journal->j_committing_transaction &&
+		     journal->j_committing_transaction->t_tid == tid))
+		need_to_wait = 0;
+	read_unlock(&journal->j_state_lock);
+	if (!need_to_wait)
+		return 0;
+wait_commit:
+	return jbd2_log_wait_commit(journal, tid);
+}
+EXPORT_SYMBOL(jbd2_complete_transaction);
+
+/*
  * Log buffer allocation routines:
  */
 
diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index ca0a080..193f04c 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -144,6 +144,9 @@ int nlmclnt_block(struct nlm_wait *block, struct nlm_rqst *req, long timeout)
 			timeout);
 	if (ret < 0)
 		return -ERESTARTSYS;
+	/* Reset the lock status after a server reboot so we resend */
+	if (block->b_status == nlm_lck_denied_grace_period)
+		block->b_status = nlm_lck_blocked;
 	req->a_res.status = block->b_status;
 	return 0;
 }
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index a3a0987..8392cb8 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -551,9 +551,6 @@ again:
 		status = nlmclnt_block(block, req, NLMCLNT_POLL_TIMEOUT);
 		if (status < 0)
 			break;
-		/* Resend the blocking lock request after a server reboot */
-		if (resp->status ==  nlm_lck_denied_grace_period)
-			continue;
 		if (resp->status != nlm_lck_blocked)
 			break;
 	}
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b96aa12..480918e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1381,6 +1381,12 @@ int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state
 			case -ENOMEM:
 				err = 0;
 				goto out;
+			case -NFS4ERR_DELAY:
+			case -NFS4ERR_GRACE:
+				set_bit(NFS_DELEGATED_STATE, &state->flags);
+				ssleep(1);
+				err = -EAGAIN;
+				goto out;
 		}
 		err = nfs4_handle_exception(server, err, &exception);
 	} while (exception.retry);
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 6f292dd..f255d37 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -577,7 +577,6 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 	int add = (arg & IN_MASK_ADD);
 	int ret;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 
 	fsn_mark = fsnotify_find_inode_mark(group, inode);
@@ -628,7 +627,6 @@ static int inotify_new_watch(struct fsnotify_group *group,
 	struct idr *idr = &group->inotify_data.idr;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
 
-	/* don't allow invalid bits: we don't want flags set */
 	mask = inotify_arg_to_mask(arg);
 
 	tmp_i_mark = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
@@ -757,6 +755,10 @@ SYSCALL_DEFINE3(inotify_add_watch, int, fd, const char __user *, pathname,
 	int ret, fput_needed;
 	unsigned flags = 0;
 
+	/* don't allow invalid bits: we don't want flags set */
+	if (unlikely(!(mask & ALL_INOTIFY_BITS)))
+		return -EINVAL;
+
 	filp = fget_light(fd, &fput_needed);
 	if (unlikely(!filp))
 		return -EBADF;
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8777436..1a32e0f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1013,6 +1013,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	enum kobj_ns_type type;
 	const void *ns;
 	ino_t ino;
+	loff_t off;
 
 	type = sysfs_ns_type(parent_sd);
 	ns = sysfs_info(dentry->d_sb)->ns[type];
@@ -1035,6 +1036,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
+	off = filp->f_pos;
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
 	     pos;
 	     pos = sysfs_dir_next_pos(ns, parent_sd, filp->f_pos, pos)) {
@@ -1046,19 +1048,24 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		len = strlen(name);
 		ino = pos->s_ino;
 		type = dt_type(pos);
-		filp->f_pos = pos->s_hash;
+		off = filp->f_pos = pos->s_hash;
 		filp->private_data = sysfs_get(pos);
 
 		mutex_unlock(&sysfs_mutex);
-		ret = filldir(dirent, name, len, filp->f_pos, ino, type);
+		ret = filldir(dirent, name, len, off, ino, type);
 		mutex_lock(&sysfs_mutex);
 		if (ret < 0)
 			break;
 	}
 	mutex_unlock(&sysfs_mutex);
-	if ((filp->f_pos > 1) && !pos) { /* EOF */
-		filp->f_pos = INT_MAX;
+
+	/* don't reference last entry if its refcount is dropped */
+	if (!pos) {
 		filp->private_data = NULL;
+
+		/* EOF and not changed as 0 or 1 in read/write path */
+		if (off == filp->f_pos && off > 1)
+			filp->f_pos = INT_MAX;
 	}
 	return 0;
 }
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index ff4947b..0084135 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -7,6 +7,16 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 
+/*
+ * On almost all architectures and configurations, 0 can be used as the
+ * upper ceiling to free_pgtables(): on many architectures it has the same
+ * effect as using TASK_SIZE.  However, there is one configuration which
+ * must impose a more careful limit, to avoid freeing kernel pgtables.
+ */
+#ifndef USER_PGTABLES_CEILING
+#define USER_PGTABLES_CEILING	0UL
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pte_t *ptep,
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 5499c92..c731973 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -42,8 +42,8 @@ struct ipc_namespace {
 
 	size_t		shm_ctlmax;
 	size_t		shm_ctlall;
+	unsigned long	shm_tot;
 	int		shm_ctlmni;
-	int		shm_tot;
 	/*
 	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
 	 * of shmctl()
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3efc43f..ade60e7 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -498,6 +498,7 @@ struct transaction_s
 		T_COMMIT,
 		T_COMMIT_DFLUSH,
 		T_COMMIT_JFLUSH,
+		T_COMMIT_CALLBACK,
 		T_FINISHED
 	}			t_state;
 
@@ -1211,6 +1212,7 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
 int jbd2_journal_force_commit_nested(journal_t *journal);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
+int jbd2_complete_transaction(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
 int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f9f279c..920beba 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1503,6 +1503,8 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
+
 
 struct page *follow_page(struct vm_area_struct *, unsigned long address,
 			unsigned int foll_flags);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b52070a..735cb59 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -233,9 +233,9 @@ struct netdev_hw_addr {
 #define NETDEV_HW_ADDR_T_SLAVE		3
 #define NETDEV_HW_ADDR_T_UNICAST	4
 #define NETDEV_HW_ADDR_T_MULTICAST	5
-	bool			synced;
 	bool			global_use;
 	int			refcount;
+	int			synced;
 	struct rcu_head		rcu_head;
 };
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3a9e314..ebd15f9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2445,27 +2445,18 @@ static inline void threadgroup_change_end(struct task_struct *tsk)
  *
  * Lock the threadgroup @tsk belongs to.  No new task is allowed to enter
  * and member tasks aren't allowed to exit (as indicated by PF_EXITING) or
- * perform exec.  This is useful for cases where the threadgroup needs to
- * stay stable across blockable operations.
+ * change ->group_leader/pid.  This is useful for cases where the threadgroup
+ * needs to stay stable across blockable operations.
  *
  * fork and exit paths explicitly call threadgroup_change_{begin|end}() for
  * synchronization.  While held, no new task will be added to threadgroup
  * and no existing live task will have its PF_EXITING set.
  *
- * During exec, a task goes and puts its thread group through unusual
- * changes.  After de-threading, exclusive access is assumed to resources
- * which are usually shared by tasks in the same group - e.g. sighand may
- * be replaced with a new one.  Also, the exec'ing task takes over group
- * leader role including its pid.  Exclude these changes while locked by
- * grabbing cred_guard_mutex which is used to synchronize exec path.
+ * de_thread() does threadgroup_change_{begin|end}() when a non-leader
+ * sub-thread becomes a new leader.
  */
 static inline void threadgroup_lock(struct task_struct *tsk)
 {
-	/*
-	 * exec uses exit for de-threading nesting group_rwsem inside
-	 * cred_guard_mutex. Grab cred_guard_mutex first.
-	 */
-	mutex_lock(&tsk->signal->cred_guard_mutex);
 	down_write(&tsk->signal->group_rwsem);
 }
 
@@ -2478,7 +2469,6 @@ static inline void threadgroup_lock(struct task_struct *tsk)
 static inline void threadgroup_unlock(struct task_struct *tsk)
 {
 	up_write(&tsk->signal->group_rwsem);
-	mutex_unlock(&tsk->signal->cred_guard_mutex);
 }
 #else
 static inline void threadgroup_change_begin(struct task_struct *tsk) {}
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5af4bef..e1c1e64 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2404,6 +2404,13 @@ static inline void nf_reset(struct sk_buff *skb)
 #endif
 }
 
+static inline void nf_reset_trace(struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
+	skb->nf_trace = 0;
+#endif
+}
+
 /* Note: This doesn't put any conntrack and bridge info in dst. */
 static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src)
 {
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 25d6322..2a32b9d 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -316,7 +316,8 @@ struct ucred {
 /* IPX options */
 #define IPX_TYPE	1
 
-extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
+extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred,
+			  bool use_effective);
 
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
 extern int memcpy_fromiovecend(unsigned char *kdata, const struct iovec *iov,
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index 1a6b004..29ce7e4 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -219,6 +219,7 @@
 #define SSB_CHIPCO_PMU_CTL			0x0600 /* PMU control */
 #define  SSB_CHIPCO_PMU_CTL_ILP_DIV		0xFFFF0000 /* ILP div mask */
 #define  SSB_CHIPCO_PMU_CTL_ILP_DIV_SHIFT	16
+#define  SSB_CHIPCO_PMU_CTL_PLL_UPD		0x00000400
 #define  SSB_CHIPCO_PMU_CTL_NOILPONW		0x00000200 /* No ILP on wait */
 #define  SSB_CHIPCO_PMU_CTL_HTREQEN		0x00000100 /* HT req enable */
 #define  SSB_CHIPCO_PMU_CTL_ALPREQEN		0x00000080 /* ALP req enable */
@@ -661,5 +662,6 @@ enum ssb_pmu_ldo_volt_id {
 void ssb_pmu_set_ldo_voltage(struct ssb_chipcommon *cc,
 			     enum ssb_pmu_ldo_volt_id id, u32 voltage);
 void ssb_pmu_set_ldo_paref(struct ssb_chipcommon *cc, bool on);
+void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid);
 
 #endif /* LINUX_SSB_CHIPCO_H_ */
diff --git a/include/net/scm.h b/include/net/scm.h
index 0c0017c..9f211cf 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -50,7 +50,7 @@ static __inline__ void scm_set_cred(struct scm_cookie *scm,
 {
 	scm->pid  = get_pid(pid);
 	scm->cred = cred ? get_cred(cred) : NULL;
-	cred_to_ucred(pid, cred, &scm->creds);
+	cred_to_ucred(pid, cred, &scm->creds, false);
 }
 
 static __inline__ void scm_destroy_cred(struct scm_cookie *scm)
diff --git a/ipc/shm.c b/ipc/shm.c
index 41c1285..f5ba6ac 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -462,7 +462,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	size_t size = params->u.size;
 	int error;
 	struct shmid_kernel *shp;
-	int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct file * file;
 	char name[13];
 	int id;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 87fbb45..5168e37 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2079,7 +2079,7 @@ static int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (!group)
 		return -ENOMEM;
 	/* pre-allocate to guarantee space while iterating in rcu read-side. */
-	retval = flex_array_prealloc(group, 0, group_size - 1, GFP_KERNEL);
+	retval = flex_array_prealloc(group, 0, group_size, GFP_KERNEL);
 	if (retval)
 		goto out_free_group_list;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 11409af..1a6deb7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5129,7 +5129,7 @@ static void sw_perf_event_destroy(struct perf_event *event)
 
 static int perf_swevent_init(struct perf_event *event)
 {
-	int event_id = event->attr.config;
+	u64 event_id = event->attr.config;
 
 	if (event->attr.type != PERF_TYPE_SOFTWARE)
 		return -ENOENT;
@@ -5763,6 +5763,7 @@ skip_type:
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
+	ret = -ENOMEM;
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_dev;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e4cee8d..60f7e32 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -298,6 +298,10 @@ ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 
@@ -1308,6 +1312,8 @@ retry:
 
 				expires = ktime_sub(hrtimer_get_expires(timer),
 						    base->offset);
+				if (expires.tv64 < 0)
+					expires.tv64 = KTIME_MAX;
 				if (expires.tv64 < expires_next.tv64)
 					expires_next = expires;
 				break;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3231df8..473cac3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1651,8 +1651,10 @@ static void try_to_wake_up_local(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
 
-	BUG_ON(rq != this_rq());
-	BUG_ON(p == current);
+	if (WARN_ON_ONCE(rq != this_rq()) ||
+	    WARN_ON_ONCE(p == current))
+		return;
+
 	lockdep_assert_held(&rq->lock);
 
 	if (!raw_spin_trylock(&p->pi_lock)) {
diff --git a/kernel/signal.c b/kernel/signal.c
index 0e9b729..c0356f9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2885,7 +2885,7 @@ do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 
 static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
-	struct siginfo info;
+	struct siginfo info = {};
 
 	info.si_signo = sig;
 	info.si_errno = 0;
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index a13987a..239a323 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,6 +66,8 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
+	struct clock_event_device *cur = tick_broadcast_device.evtdev;
+
 	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
 	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
@@ -73,6 +75,8 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 		return 0;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
+	if (cur)
+		cur->event_handler = clockevents_handle_noop;
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index da6c9ec..ead79bc 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -323,6 +323,7 @@ static void tick_shutdown(unsigned int *cpup)
 		 */
 		dev->mode = CLOCK_EVT_MODE_UNUSED;
 		clockevents_exchange_device(dev, NULL);
+		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 38353bf..36759bf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -624,7 +624,7 @@ int ftrace_profile_pages_init(struct ftrace_profile_stat *stat)
 
 	pages = DIV_ROUND_UP(functions, PROFILES_PER_PAGE);
 
-	for (i = 0; i < pages; i++) {
+	for (i = 1; i < pages; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
 		if (!pg->next)
 			goto out_free;
@@ -3579,7 +3579,8 @@ out:
 	if (fail)
 		return -EINVAL;
 
-	ftrace_graph_filter_enabled = 1;
+	ftrace_graph_filter_enabled = !!(*idx);
+
 	return 0;
 }
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 34c61b2..0ae8b32 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4832,6 +4832,8 @@ static __init int tracer_init_debugfs(void)
 	trace_access_lock_init();
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("tracing_enabled", 0644, d_tracer,
 			&global_trace, &tracing_ctrl_fops);
@@ -4968,36 +4970,32 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	iter->cpu_file = TRACE_PIPE_ALL_CPU;
 }
 
-static void
-__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
+void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 {
-	static arch_spinlock_t ftrace_dump_lock =
-		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
+	static atomic_t dump_running;
 	unsigned int old_userobj;
-	static int dump_ran;
 	unsigned long flags;
 	int cnt = 0, cpu;
 
-	/* only one dump */
-	local_irq_save(flags);
-	arch_spin_lock(&ftrace_dump_lock);
-	if (dump_ran)
-		goto out;
-
-	dump_ran = 1;
+	/* Only allow one dump user at a time. */
+	if (atomic_inc_return(&dump_running) != 1) {
+		atomic_dec(&dump_running);
+		return;
+	}
 
+	/*
+	 * Always turn off tracing when we dump.
+	 * We don't need to show trace output of what happens
+	 * between multiple crashes.
+	 *
+	 * If the user does a sysrq-z, then they can re-enable
+	 * tracing with echo 1 > tracing_on.
+	 */
 	tracing_off();
 
-	/* Did function tracer already get disabled? */
-	if (ftrace_is_dead()) {
-		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
-		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
-	}
-
-	if (disable_tracing)
-		ftrace_kill();
+	local_irq_save(flags);
 
 	trace_init_global_iter(&iter);
 
@@ -5030,6 +5028,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
+	/* Did function tracer already get disabled? */
+	if (ftrace_is_dead()) {
+		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
+	}
+
 	/*
 	 * We need to stop all tracing on all CPUS to read the
 	 * the next buffer. This is a bit expensive, but is
@@ -5069,26 +5073,14 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		printk(KERN_TRACE "---------------------------------\n");
 
  out_enable:
-	/* Re-enable tracing if requested */
-	if (!disable_tracing) {
-		trace_flags |= old_userobj;
+	trace_flags |= old_userobj;
 
-		for_each_tracing_cpu(cpu) {
-			atomic_dec(&iter.tr->data[cpu]->disabled);
-		}
-		tracing_on();
+	for_each_tracing_cpu(cpu) {
+		atomic_dec(&iter.tr->data[cpu]->disabled);
 	}
-
- out:
-	arch_spin_unlock(&ftrace_dump_lock);
+ 	atomic_dec(&dump_running);
 	local_irq_restore(flags);
 }
-
-/* By default: disable tracing after the dump */
-void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
-{
-	__ftrace_dump(true, oops_dump_mode);
-}
 EXPORT_SYMBOL_GPL(ftrace_dump);
 
 __init static int tracer_alloc_buffers(void)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 288541f..09fd98a 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -461,8 +461,6 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 /* Maximum number of functions to trace before diagnosing a hang */
 #define GRAPH_MAX_FUNC_TEST	100000000
 
-static void
-__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode);
 static unsigned int graph_hang_thresh;
 
 /* Wrap the real function entry probe to avoid possible hanging */
@@ -472,8 +470,11 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
 	if (unlikely(++graph_hang_thresh > GRAPH_MAX_FUNC_TEST)) {
 		ftrace_graph_stop();
 		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
-		if (ftrace_dump_on_oops)
-			__ftrace_dump(false, DUMP_ALL);
+		if (ftrace_dump_on_oops) {
+			ftrace_dump(DUMP_ALL);
+			/* ftrace_dump() disables tracing */
+			tracing_on();
+		}
 		return 0;
 	}
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index aa4270a..8298997 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -20,13 +20,24 @@
 
 #define STACK_TRACE_ENTRIES 500
 
+#ifdef CC_USING_FENTRY
+# define fentry		1
+#else
+# define fentry		0
+#endif
+
 static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES+1] =
 	 { [0 ... (STACK_TRACE_ENTRIES)] = ULONG_MAX };
 static unsigned stack_dump_index[STACK_TRACE_ENTRIES];
 
+/*
+ * Reserve one entry for the passed in ip. This will allow
+ * us to remove most or all of the stack size overhead
+ * added by the stack tracer itself.
+ */
 static struct stack_trace max_stack_trace = {
-	.max_entries		= STACK_TRACE_ENTRIES,
-	.entries		= stack_dump_trace,
+	.max_entries		= STACK_TRACE_ENTRIES - 1,
+	.entries		= &stack_dump_trace[1],
 };
 
 static unsigned long max_stack_size;
@@ -40,25 +51,34 @@ static DEFINE_MUTEX(stack_sysctl_mutex);
 int stack_tracer_enabled;
 static int last_stack_tracer_enabled;
 
-static inline void check_stack(void)
+static inline void
+check_stack(unsigned long ip, unsigned long *stack)
 {
 	unsigned long this_size, flags;
 	unsigned long *p, *top, *start;
+	static int tracer_frame;
+	int frame_size = ACCESS_ONCE(tracer_frame);
 	int i;
 
-	this_size = ((unsigned long)&this_size) & (THREAD_SIZE-1);
+	this_size = ((unsigned long)stack) & (THREAD_SIZE-1);
 	this_size = THREAD_SIZE - this_size;
+	/* Remove the frame of the tracer */
+	this_size -= frame_size;
 
 	if (this_size <= max_stack_size)
 		return;
 
 	/* we do not handle interrupt stacks yet */
-	if (!object_is_on_stack(&this_size))
+	if (!object_is_on_stack(stack))
 		return;
 
 	local_irq_save(flags);
 	arch_spin_lock(&max_stack_lock);
 
+	/* In case another CPU set the tracer_frame on us */
+	if (unlikely(!frame_size))
+		this_size -= tracer_frame;
+
 	/* a race could have already updated it */
 	if (this_size <= max_stack_size)
 		goto out;
@@ -71,10 +91,18 @@ static inline void check_stack(void)
 	save_stack_trace(&max_stack_trace);
 
 	/*
+	 * Add the passed in ip from the function tracer.
+	 * Searching for this on the stack will skip over
+	 * most of the overhead from the stack tracer itself.
+	 */
+	stack_dump_trace[0] = ip;
+	max_stack_trace.nr_entries++;
+
+	/*
 	 * Now find where in the stack these are.
 	 */
 	i = 0;
-	start = &this_size;
+	start = stack;
 	top = (unsigned long *)
 		(((unsigned long)start & ~(THREAD_SIZE-1)) + THREAD_SIZE);
 
@@ -98,6 +126,18 @@ static inline void check_stack(void)
 				found = 1;
 				/* Start the search from here */
 				start = p + 1;
+				/*
+				 * We do not want to show the overhead
+				 * of the stack tracer stack in the
+				 * max stack. If we haven't figured
+				 * out what that is, then figure it out
+				 * now.
+				 */
+				if (unlikely(!tracer_frame) && i == 1) {
+					tracer_frame = (p - stack) *
+						sizeof(unsigned long);
+					max_stack_size -= tracer_frame;
+				}
 			}
 		}
 
@@ -113,6 +153,7 @@ static inline void check_stack(void)
 static void
 stack_trace_call(unsigned long ip, unsigned long parent_ip)
 {
+	unsigned long stack;
 	int cpu;
 
 	if (unlikely(!ftrace_enabled || stack_trace_disabled))
@@ -125,7 +166,26 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	if (per_cpu(trace_active, cpu)++ != 0)
 		goto out;
 
-	check_stack();
+	/*
+	 * When fentry is used, the traced function does not get
+	 * its stack frame set up, and we lose the parent.
+	 * The ip is pretty useless because the function tracer
+	 * was called before that function set up its stack frame.
+	 * In this case, we use the parent ip.
+	 *
+	 * By adding the return address of either the parent ip
+	 * or the current ip we can disregard most of the stack usage
+	 * caused by the stack tracer itself.
+	 *
+	 * The function tracer always reports the address of where the
+	 * mcount call was, but the stack will hold the return address.
+	 */
+	if (fentry)
+		ip = parent_ip;
+	else
+		ip += MCOUNT_INSN_SIZE;
+
+	check_stack(ip, &stack);
 
  out:
 	per_cpu(trace_active, cpu)--;
@@ -373,6 +433,8 @@ static __init int stack_trace_init(void)
 	struct dentry *d_tracer;
 
 	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
 
 	trace_create_file("stack_max_size", 0644, d_tracer,
 			&max_stack_size, &stack_max_size_fops);
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 96cffb2..847f88a 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -307,6 +307,8 @@ static int tracing_stat_init(void)
 	struct dentry *d_tracing;
 
 	d_tracing = tracing_init_dentry();
+	if (!d_tracing)
+		return 0;
 
 	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
 	if (!stat_dir)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f30e463..74b8327 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2907,7 +2907,17 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			break;
 		}
 
-		if (absent ||
+		/*
+		 * We need call hugetlb_fault for both hugepages under migration
+		 * (in which case hugetlb_fault waits for the migration,) and
+		 * hwpoisoned hugepages (in which case we need to prevent the
+		 * caller from accessing to them.) In order to do this, we use
+		 * here is_swap_pte instead of is_hugetlb_entry_migration and
+		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
+		 * both cases, and because we can't follow correct pages
+		 * directly from any kind of swap entries.
+		 */
+		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
 		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
diff --git a/mm/memory.c b/mm/memory.c
index b1014bf..05414ef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2334,6 +2334,53 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(remap_pfn_range);
 
+/**
+ * vm_iomap_memory - remap memory to userspace
+ * @vma: user vma to map to
+ * @start: start of area
+ * @len: size of area
+ *
+ * This is a simplified io_remap_pfn_range() for common driver use. The
+ * driver just needs to give us the physical memory range to be mapped,
+ * we'll figure out the rest from the vma information.
+ *
+ * NOTE! Some drivers might want to tweak vma->vm_page_prot first to get
+ * whatever write-combining details or similar.
+ */
+int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len)
+{
+	unsigned long vm_len, pfn, pages;
+
+	/* Check that the physical memory area passed in looks valid */
+	if (start + len < start)
+		return -EINVAL;
+	/*
+	 * You *really* shouldn't map things that aren't page-aligned,
+	 * but we've historically allowed it because IO memory might
+	 * just have smaller alignment.
+	 */
+	len += start & ~PAGE_MASK;
+	pfn = start >> PAGE_SHIFT;
+	pages = (len + ~PAGE_MASK) >> PAGE_SHIFT;
+	if (pfn + pages < pfn)
+		return -EINVAL;
+
+	/* We start the mapping 'vm_pgoff' pages into the area */
+	if (vma->vm_pgoff > pages)
+		return -EINVAL;
+	pfn += vma->vm_pgoff;
+	pages -= vma->vm_pgoff;
+
+	/* Can we fit all of the mapping? */
+	vm_len = vma->vm_end - vma->vm_start;
+	if (vm_len >> PAGE_SHIFT > pages)
+		return -EINVAL;
+
+	/* Ok, let it rip */
+	return io_remap_pfn_range(vma, vma->vm_start, pfn, vm_len, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_iomap_memory);
+
 static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     unsigned long addr, unsigned long end,
 				     pte_fn_t fn, void *data)
diff --git a/mm/mmap.c b/mm/mmap.c
index 5603d88..76b70c9 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1913,7 +1913,7 @@ static void unmap_region(struct mm_struct *mm,
 	update_hiwater_rss(mm);
 	unmap_vmas(&tlb, vma, start, end);
 	free_pgtables(&tlb, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
-				 next ? next->vm_start : 0);
+				 next ? next->vm_start : USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, start, end);
 }
 
@@ -2295,7 +2295,7 @@ void exit_mmap(struct mm_struct *mm)
 	/* Use -1 here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, vma, 0, -1);
 
-	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, 0);
+	free_pgtables(&tlb, vma, FIRST_USER_ADDRESS, USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb, 0, -1);
 
 	/*
diff --git a/net/atm/common.c b/net/atm/common.c
index 0c0ad93..f0a9b7e 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -520,6 +520,8 @@ int vcc_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 	struct sk_buff *skb;
 	int copied, error = -EINVAL;
 
+	msg->msg_namelen = 0;
+
 	if (sock->state != SS_CONNECTED)
 		return -ENOTCONN;
 
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 779095d..d53a123 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1647,6 +1647,7 @@ static int ax25_recvmsg(struct kiocb *iocb, struct socket *sock,
 		ax25_address src;
 		const unsigned char *mac = skb_mac_header(skb);
 
+		memset(sax, 0, sizeof(struct full_sockaddr_ax25));
 		ax25_addr_parse(mac + 1, skb->data - mac - 1, &src, NULL,
 				&digi, NULL, NULL);
 		sax->sax25_family = AF_AX25;
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 3e18af4..821e9d3 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -240,6 +240,8 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
+	msg->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
@@ -247,8 +249,6 @@ int bt_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 		return err;
 	}
 
-	msg->msg_namelen = 0;
-
 	copied = skb->len;
 	if (len < copied) {
 		msg->msg_flags |= MSG_TRUNC;
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 20bd148..514bead 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -629,6 +629,7 @@ static int rfcomm_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
 		rfcomm_dlc_accept(d);
+		msg->msg_namelen = 0;
 		return 0;
 	}
 
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 78f1cda..21a1840 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -286,6 +286,8 @@ static int caif_seqpkt_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (m->msg_flags&MSG_OOB)
 		goto read_error;
 
+	m->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags, 0 , &ret);
 	if (!skb)
 		goto read_error;
diff --git a/net/core/dev.c b/net/core/dev.c
index 845a83a..ba9d7a7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1627,6 +1627,7 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 	skb->mark = 0;
 	secpath_reset(skb);
 	nf_reset(skb);
+	nf_reset_trace(skb);
 	return netif_rx(skb);
 }
 EXPORT_SYMBOL_GPL(dev_forward_skb);
@@ -1892,6 +1893,9 @@ static void skb_warn_bad_offload(const struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	const char *driver = "";
 
+	if (!net_ratelimit())
+		return;
+
 	if (dev && dev->dev.parent)
 		driver = dev_driver_string(dev->dev.parent);
 
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 716f363..fb898d7 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -38,7 +38,7 @@ static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
 	ha->type = addr_type;
 	ha->refcount = 1;
 	ha->global_use = global;
-	ha->synced = false;
+	ha->synced = 0;
 	list_add_tail_rcu(&ha->list, &list->list);
 	list->count++;
 
@@ -164,7 +164,7 @@ int __hw_addr_sync(struct netdev_hw_addr_list *to_list,
 					    addr_len, ha->type);
 			if (err)
 				break;
-			ha->synced = true;
+			ha->synced++;
 			ha->refcount++;
 		} else if (ha->refcount == 1) {
 			__hw_addr_del(to_list, ha->addr, addr_len, ha->type);
@@ -185,7 +185,7 @@ void __hw_addr_unsync(struct netdev_hw_addr_list *to_list,
 		if (ha->synced) {
 			__hw_addr_del(to_list, ha->addr,
 				      addr_len, ha->type);
-			ha->synced = false;
+			ha->synced--;
 			__hw_addr_del(from_list, ha->addr,
 				      addr_len, ha->type);
 		}
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 844ccc6..ef7f0ab 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1073,7 +1073,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	cb->seq = net->dev_base_seq;
 
-	if (nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+	if (nlmsg_parse(cb->nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
 			ifla_policy) >= 0) {
 
 		if (tb[IFLA_EXT_MASK])
@@ -1916,7 +1916,7 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 	u32 ext_filter_mask = 0;
 	u16 min_ifinfo_dump_size = 0;
 
-	if (nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+	if (nlmsg_parse(nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
 			ifla_policy) >= 0) {
 		if (tb[IFLA_EXT_MASK])
 			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
diff --git a/net/core/sock.c b/net/core/sock.c
index c5f765c..5d30122 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -807,15 +807,20 @@ EXPORT_SYMBOL(sock_setsockopt);
 
 
 void cred_to_ucred(struct pid *pid, const struct cred *cred,
-		   struct ucred *ucred)
+		   struct ucred *ucred, bool use_effective)
 {
 	ucred->pid = pid_vnr(pid);
 	ucred->uid = ucred->gid = -1;
 	if (cred) {
 		struct user_namespace *current_ns = current_user_ns();
 
-		ucred->uid = from_kuid(current_ns, cred->euid);
-		ucred->gid = from_kgid(current_ns, cred->egid);
+		if (use_effective) {
+			ucred->uid = from_kuid(current_ns, cred->euid);
+			ucred->gid = from_kgid(current_ns, cred->egid);
+		} else {
+			ucred->uid = from_kuid(current_ns, cred->uid);
+			ucred->gid = from_kgid(current_ns, cred->gid);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(cred_to_ucred);
@@ -976,7 +981,8 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
-		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred,
+			      &peercred, true);
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index cb982a6..e814e2a 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -139,8 +139,6 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 
 	/* skb is pure payload to encrypt */
 
-	err = -ENOMEM;
-
 	esp = x->data;
 	aead = esp->aead;
 	alen = crypto_aead_authsize(aead);
@@ -176,8 +174,10 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 	}
 
 	tmp = esp_alloc_tmp(aead, nfrags + sglists, seqhilen);
-	if (!tmp)
+	if (!tmp) {
+		err = -ENOMEM;
 		goto error;
+	}
 
 	seqhi = esp_tmp_seqhi(tmp);
 	iv = esp_tmp_iv(aead, tmp, seqhilen);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index d513c62..3599757 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -251,8 +251,7 @@ static void ip_expire(unsigned long arg)
 		if (!head->dev)
 			goto out_rcu_unlock;
 
-		/* skb dst is stale, drop it, and perform route lookup again */
-		skb_dst_drop(head);
+		/* skb has no dst, perform route lookup again */
 		iph = ip_hdr(head);
 		err = ip_route_input_noref(head, iph->daddr, iph->saddr,
 					   iph->tos, head->dev);
@@ -517,8 +516,16 @@ found:
 		qp->q.last_in |= INET_FRAG_FIRST_IN;
 
 	if (qp->q.last_in == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
-	    qp->q.meat == qp->q.len)
-		return ip_frag_reasm(qp, prev, dev);
+	    qp->q.meat == qp->q.len) {
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		err = ip_frag_reasm(qp, prev, dev);
+		skb->_skb_refdst = orefdst;
+		return err;
+	}
+
+	skb_dst_drop(skb);
 
 	write_lock(&ip4_frags.lock);
 	list_move_tail(&qp->q.lru_list, &qp->q.net->lru_list);
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index eab2a7f..550aa2a 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -347,8 +347,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
 	 * hasn't changed since we received the original syn, but I see
 	 * no easy way to do this.
 	 */
-	flowi4_init_output(&fl4, 0, sk->sk_mark, RT_CONN_FLAGS(sk),
-			   RT_SCOPE_UNIVERSE, IPPROTO_TCP,
+	flowi4_init_output(&fl4, sk->sk_bound_dev_if, sk->sk_mark,
+			   RT_CONN_FLAGS(sk), RT_SCOPE_UNIVERSE, IPPROTO_TCP,
 			   inet_sk_flowi_flags(sk),
 			   (opt && opt->srr) ? opt->faddr : ireq->rmt_addr,
 			   ireq->loc_addr, th->source, th->dest);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e75e4fb..e8139f8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -117,6 +117,7 @@ int sysctl_tcp_early_retrans __read_mostly = 2;
 #define FLAG_DSACKING_ACK	0x800 /* SACK blocks contained D-SACK info */
 #define FLAG_NONHEAD_RETRANS_ACKED	0x1000 /* Non-head rexmitted data was ACKed */
 #define FLAG_SACK_RENEGING	0x2000 /* snd_una advanced to a sacked seq */
+#define FLAG_UPDATE_TS_RECENT	0x4000 /* tcp_replace_ts_recent() */
 
 #define FLAG_ACKED		(FLAG_DATA_ACKED|FLAG_SYN_ACKED)
 #define FLAG_NOT_DUP		(FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
@@ -3783,6 +3784,27 @@ static void tcp_send_challenge_ack(struct sock *sk)
 	}
 }
 
+static void tcp_store_ts_recent(struct tcp_sock *tp)
+{
+	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
+	tp->rx_opt.ts_recent_stamp = get_seconds();
+}
+
+static void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
+{
+	if (tp->rx_opt.saw_tstamp && !after(seq, tp->rcv_wup)) {
+		/* PAWS bug workaround wrt. ACK frames, the PAWS discard
+		 * extra check below makes sure this can only happen
+		 * for pure ACK frames.  -DaveM
+		 *
+		 * Not only, also it occurs for expired timestamps.
+		 */
+
+		if (tcp_paws_check(&tp->rx_opt, 0))
+			tcp_store_ts_recent(tp);
+	}
+}
+
 /* This routine deals with incoming acks, but not outgoing ones. */
 static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 {
@@ -3835,6 +3857,12 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	prior_fackets = tp->fackets_out;
 	prior_in_flight = tcp_packets_in_flight(tp);
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	if (flag & FLAG_UPDATE_TS_RECENT)
+		tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	if (!(flag & FLAG_SLOWPATH) && after(ack, prior_snd_una)) {
 		/* Window is constant, pure forward advance.
 		 * No more checks are required.
@@ -4131,27 +4159,6 @@ const u8 *tcp_parse_md5sig_option(const struct tcphdr *th)
 EXPORT_SYMBOL(tcp_parse_md5sig_option);
 #endif
 
-static inline void tcp_store_ts_recent(struct tcp_sock *tp)
-{
-	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
-	tp->rx_opt.ts_recent_stamp = get_seconds();
-}
-
-static inline void tcp_replace_ts_recent(struct tcp_sock *tp, u32 seq)
-{
-	if (tp->rx_opt.saw_tstamp && !after(seq, tp->rcv_wup)) {
-		/* PAWS bug workaround wrt. ACK frames, the PAWS discard
-		 * extra check below makes sure this can only happen
-		 * for pure ACK frames.  -DaveM
-		 *
-		 * Not only, also it occurs for expired timestamps.
-		 */
-
-		if (tcp_paws_check(&tp->rx_opt, 0))
-			tcp_store_ts_recent(tp);
-	}
-}
-
 /* Sorry, PAWS as specified is broken wrt. pure-ACKs -DaveM
  *
  * It is not fatal. If this ACK does _not_ change critical state (seqs, window)
@@ -5738,14 +5745,9 @@ slow_path:
 		return 0;
 
 step5:
-	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
+	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT) < 0)
 		goto discard;
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
@@ -6117,7 +6119,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 
 	/* step 5: check the ACK field */
 	if (th->ack) {
-		int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH) > 0;
+		int acceptable = tcp_ack(sk, skb, FLAG_SLOWPATH |
+						  FLAG_UPDATE_TS_RECENT) > 0;
 
 		switch (sk->sk_state) {
 		case TCP_SYN_RECV:
@@ -6224,11 +6227,6 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	} else
 		goto discard;
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	/* step 6: check the URG bit */
 	tcp_urg(sk, skb, th);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e0cd660..ae12c92 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2175,8 +2175,12 @@ int tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb)
 	 */
 	TCP_SKB_CB(skb)->when = tcp_time_stamp;
 
-	/* make sure skb->data is aligned on arches that require it */
-	if (unlikely(NET_IP_ALIGN && ((unsigned long)skb->data & 3))) {
+	/* make sure skb->data is aligned on arches that require it
+	 * and check if ack-trimming & collapsing extended the headroom
+	 * beyond what csum_start can cover.
+	 */
+	if (unlikely((NET_IP_ALIGN && ((unsigned long)skb->data & 3)) ||
+		     skb_headroom(skb) >= 0xFFFF)) {
 		struct sk_buff *nskb = __pskb_copy(skb, MAX_TCP_HEADER,
 						   GFP_ATOMIC);
 		err = nskb ? tcp_transmit_skb(sk, nskb, 0, GFP_ATOMIC) :
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 00188b3..2078f4e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2402,6 +2402,9 @@ static void sit_add_v4_addrs(struct inet6_dev *idev)
 static void init_loopback(struct net_device *dev)
 {
 	struct inet6_dev  *idev;
+	struct net_device *sp_dev;
+	struct inet6_ifaddr *sp_ifa;
+	struct rt6_info *sp_rt;
 
 	/* ::1 */
 
@@ -2413,6 +2416,30 @@ static void init_loopback(struct net_device *dev)
 	}
 
 	add_addr(idev, &in6addr_loopback, 128, IFA_HOST);
+
+	/* Add routes to other interface's IPv6 addresses */
+	for_each_netdev(dev_net(dev), sp_dev) {
+		if (!strcmp(sp_dev->name, dev->name))
+			continue;
+
+		idev = __in6_dev_get(sp_dev);
+		if (!idev)
+			continue;
+
+		read_lock_bh(&idev->lock);
+		list_for_each_entry(sp_ifa, &idev->addr_list, if_list) {
+
+			if (sp_ifa->flags & (IFA_F_DADFAILED | IFA_F_TENTATIVE))
+				continue;
+
+			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
+
+			/* Failure cases are ignored */
+			if (!IS_ERR(sp_rt))
+				ip6_ins_rt(sp_rt);
+		}
+		read_unlock_bh(&idev->lock);
+	}
 }
 
 static void addrconf_add_linklocal(struct inet6_dev *idev, const struct in6_addr *addr)
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 66d2096..3673b8f 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -386,8 +386,17 @@ found:
 	}
 
 	if (fq->q.last_in == (INET_FRAG_FIRST_IN | INET_FRAG_LAST_IN) &&
-	    fq->q.meat == fq->q.len)
-		return ip6_frag_reasm(fq, prev, dev);
+	    fq->q.meat == fq->q.len) {
+		int res;
+		unsigned long orefdst = skb->_skb_refdst;
+
+		skb->_skb_refdst = 0UL;
+		res = ip6_frag_reasm(fq, prev, dev);
+		skb->_skb_refdst = orefdst;
+		return res;
+	}
+
+	skb_dst_drop(skb);
 
 	write_lock(&ip6_frags.lock);
 	list_move_tail(&fq->q.lru_list, &fq->q.net->lru_list);
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index d6c291c..bd25678 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -1386,6 +1386,8 @@ static int irda_recvmsg_dgram(struct kiocb *iocb, struct socket *sock,
 
 	IRDA_DEBUG(4, "%s()\n", __func__);
 
+	msg->msg_namelen = 0;
+
 	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
 				flags & MSG_DONTWAIT, &err);
 	if (!skb)
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index cd6f7a9..625bc50 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1331,6 +1331,8 @@ static int iucv_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 	struct sk_buff *skb, *rskb, *cskb;
 	int err = 0;
 
+	msg->msg_namelen = 0;
+
 	if ((sk->sk_state == IUCV_DISCONN) &&
 	    skb_queue_empty(&iucv->backlog_skb_q) &&
 	    skb_queue_empty(&sk->sk_receive_queue) &&
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 9275471..2c9ccce 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -684,6 +684,7 @@ static int l2tp_ip6_recvmsg(struct kiocb *iocb, struct sock *sk,
 		lsa->l2tp_addr = ipv6_hdr(skb)->saddr;
 		lsa->l2tp_flowinfo = 0;
 		lsa->l2tp_scope_id = 0;
+		lsa->l2tp_conn_id = 0;
 		if (ipv6_addr_type(&lsa->l2tp_addr) & IPV6_ADDR_LINKLOCAL)
 			lsa->l2tp_scope_id = IP6CB(skb)->iif;
 	}
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index a13c3e2..445882cb 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -720,6 +720,8 @@ static int llc_ui_recvmsg(struct kiocb *iocb, struct socket *sock,
 	int target;	/* Read at least this many bytes */
 	long timeo;
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 	copied = -ENOTCONN;
 	if (unlikely(sk->sk_type == SOCK_STREAM && sk->sk_state == TCP_LISTEN))
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 1b9024e..7ed9b1d 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1177,6 +1177,7 @@ static int nr_recvmsg(struct kiocb *iocb, struct socket *sock,
 	}
 
 	if (sax != NULL) {
+		memset(sax, 0, sizeof(*sax));
 		sax->sax25_family = AF_NETROM;
 		skb_copy_from_linear_data_offset(skb, 7, sax->sax25_call.ax25_call,
 			      AX25_ADDR_LEN);
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index e06d458..80200ac 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -570,6 +570,8 @@ static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 
 	pr_debug("%p %zu\n", sk, len);
 
+	msg->msg_namelen = 0;
+
 	lock_sock(sk);
 
 	if (sk->sk_state == LLCP_CLOSED &&
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index c4719ce..7f645d1 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1257,6 +1257,7 @@ static int rose_recvmsg(struct kiocb *iocb, struct socket *sock,
 	skb_copy_datagram_iovec(skb, 0, msg->msg_iov, copied);
 
 	if (srose != NULL) {
+		memset(srose, 0, msg->msg_namelen);
 		srose->srose_family = AF_ROSE;
 		srose->srose_addr   = rose->dest_addr;
 		srose->srose_call   = rose->dest_call;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 564b9fc..611d5e9 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -963,8 +963,11 @@ cbq_dequeue(struct Qdisc *sch)
 		cbq_update(q);
 		if ((incr -= incr2) < 0)
 			incr = 0;
+		q->now += incr;
+	} else {
+		if (now > q->now)
+			q->now = now;
 	}
-	q->now += incr;
 	q->now_rt = now;
 
 	for (;;) {
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index bf81204..333926d 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -71,7 +71,7 @@ void sctp_auth_key_put(struct sctp_auth_bytes *key)
 		return;
 
 	if (atomic_dec_and_test(&key->refcnt)) {
-		kfree(key);
+		kzfree(key);
 		SCTP_DBG_OBJCNT_DEC(keys);
 	}
 }
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 5577a44..91fd130 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -802,6 +802,7 @@ static void set_orig_addr(struct msghdr *m, struct tipc_msg *msg)
 	if (addr) {
 		addr->family = AF_TIPC;
 		addr->addrtype = TIPC_ADDR_ID;
+		memset(&addr->addr, 0, sizeof(addr->addr));
 		addr->addr.id.ref = msg_origport(msg);
 		addr->addr.id.node = msg_orignode(msg);
 		addr->addr.name.domain = 0;	/* could leave uninitialized */
@@ -916,6 +917,9 @@ static int recv_msg(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 restart:
 
@@ -1032,6 +1036,9 @@ static int recv_stream(struct kiocb *iocb, struct socket *sock,
 		goto exit;
 	}
 
+	/* will be updated in set_orig_addr() if needed */
+	m->msg_namelen = 0;
+
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, buf_len);
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 023db69..ce7db4b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1996,7 +1996,7 @@ again:
 			if ((UNIXCB(skb).pid  != siocb->scm->pid) ||
 			    (UNIXCB(skb).cred != siocb->scm->cred))
 				break;
-		} else {
+		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
 			/* Copy credentials */
 			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
 			check_creds = 1;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4dc8347..796a0ee 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -862,7 +862,7 @@ static void handle_channel(struct wiphy *wiphy,
 			return;
 
 		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
-		chan->flags = IEEE80211_CHAN_DISABLED;
+		chan->flags |= IEEE80211_CHAN_DISABLED;
 		return;
 	}
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index bf3bf43..7203c9a 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3219,18 +3219,10 @@ EXPORT_SYMBOL_GPL(snd_pcm_lib_default_mmap);
 int snd_pcm_lib_mmap_iomem(struct snd_pcm_substream *substream,
 			   struct vm_area_struct *area)
 {
-	long size;
-	unsigned long offset;
+	struct snd_pcm_runtime *runtime = substream->runtime;;
 
 	area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
-	area->vm_flags |= VM_IO;
-	size = area->vm_end - area->vm_start;
-	offset = area->vm_pgoff << PAGE_SHIFT;
-	if (io_remap_pfn_range(area, area->vm_start,
-				(substream->runtime->dma_addr + offset) >> PAGE_SHIFT,
-				size, area->vm_page_prot))
-		return -EAGAIN;
-	return 0;
+	return vm_iomap_memory(area, runtime->dma_addr, runtime->dma_bytes);
 }
 
 EXPORT_SYMBOL(snd_pcm_lib_mmap_iomem);
