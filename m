Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab3HGUkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:40:47 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60700 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3HGUko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:40:44 -0400
Message-ID: <201308072040.r77Kefa7016089@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 11:36:54 -0400
Subject: [PATCH] tile: support CONFIG_PREEMPT
To: <linux-kernel@vger.kernel.org>, <kpreempt-tech@lists.sourceforge.net>,
        Robert Love <rml@tech9.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds support for CONFIG_PREEMPT (full kernel preemption).
In addition to the core support, this change includes a number
of places where we fix up uses of smp_processor_id() and per-cpu
variables.  I also eliminate the PAGE_HOME_HERE and PAGE_HOME_UNKNOWN
values for page homing, as it turns out they weren't being used.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                 |  2 ++
 arch/tile/include/asm/homecache.h |  8 --------
 arch/tile/include/asm/irqflags.h  | 21 ++++++++++++++++++---
 arch/tile/kernel/asm-offsets.c    |  2 ++
 arch/tile/kernel/hardwall.c       | 18 +++++++++---------
 arch/tile/kernel/intvec_32.S      | 27 ++++++++++++++++++++-------
 arch/tile/kernel/intvec_64.S      | 30 ++++++++++++++++++++++++------
 arch/tile/kernel/irq.c            |  1 +
 arch/tile/kernel/smp.c            |  2 +-
 arch/tile/kernel/smpboot.c        |  8 +++++---
 arch/tile/kernel/stack.c          |  4 ++--
 arch/tile/kernel/sys.c            |  4 +++-
 arch/tile/lib/memcpy_tile64.c     | 12 ++++++++----
 arch/tile/mm/homecache.c          |  4 +++-
 14 files changed, 98 insertions(+), 45 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 0576e1d..1126b9d 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -301,6 +301,8 @@ config PAGE_OFFSET
 
 source "mm/Kconfig"
 
+source "kernel/Kconfig.preempt"
+
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
 	default n
diff --git a/arch/tile/include/asm/homecache.h b/arch/tile/include/asm/homecache.h
index 7b77713..49d19df 100644
--- a/arch/tile/include/asm/homecache.h
+++ b/arch/tile/include/asm/homecache.h
@@ -44,16 +44,8 @@ struct zone;
  */
 #define PAGE_HOME_INCOHERENT -3
 
-#if CHIP_HAS_CBOX_HOME_MAP()
 /* Home for the page is distributed via hash-for-home. */
 #define PAGE_HOME_HASH -4
-#endif
-
-/* Homing is unknown or unspecified.  Not valid for page_home(). */
-#define PAGE_HOME_UNKNOWN -5
-
-/* Home on the current cpu.  Not valid for page_home(). */
-#define PAGE_HOME_HERE -6
 
 /* Support wrapper to use instead of explicit hv_flush_remote(). */
 extern void flush_remote(unsigned long cache_pfn, unsigned long cache_length,
diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index c96f9bb..71af574 100644
--- a/arch/tile/include/asm/irqflags.h
+++ b/arch/tile/include/asm/irqflags.h
@@ -124,6 +124,12 @@
 DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 #define INITIAL_INTERRUPTS_ENABLED (1ULL << INT_MEM_ERROR)
 
+#ifdef CONFIG_DEBUG_PREEMPT
+/* Due to inclusion issues, we can't rely on <linux/smp.h> here. */
+extern unsigned int debug_smp_processor_id(void);
+# define smp_processor_id() debug_smp_processor_id()
+#endif
+
 /* Disable interrupts. */
 #define arch_local_irq_disable() \
 	interrupt_mask_set_mask(LINUX_MASKABLE_INTERRUPTS)
@@ -132,9 +138,18 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 #define arch_local_irq_disable_all() \
 	interrupt_mask_set_mask(-1ULL)
 
+/*
+ * Read the set of maskable interrupts.
+ * We avoid the preemption warning here via __this_cpu_ptr since even
+ * if irqs are already enabled, it's harmless to read the wrong cpu's
+ * enabled mask.
+ */
+#define arch_local_irqs_enabled() \
+	(*__this_cpu_ptr(&interrupts_enabled_mask))
+
 /* Re-enable all maskable interrupts. */
 #define arch_local_irq_enable() \
-	interrupt_mask_reset_mask(__get_cpu_var(interrupts_enabled_mask))
+	interrupt_mask_reset_mask(arch_local_irqs_enabled())
 
 /* Disable or enable interrupts based on flag argument. */
 #define arch_local_irq_restore(disabled) do { \
@@ -161,7 +176,7 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 
 /* Prevent the given interrupt from being enabled next time we enable irqs. */
 #define arch_local_irq_mask(interrupt) \
-	(__get_cpu_var(interrupts_enabled_mask) &= ~(1ULL << (interrupt)))
+	this_cpu_and(interrupts_enabled_mask, ~(1ULL << (interrupt)))
 
 /* Prevent the given interrupt from being enabled immediately. */
 #define arch_local_irq_mask_now(interrupt) do { \
@@ -171,7 +186,7 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 
 /* Allow the given interrupt to be enabled next time we enable irqs. */
 #define arch_local_irq_unmask(interrupt) \
-	(__get_cpu_var(interrupts_enabled_mask) |= (1ULL << (interrupt)))
+	this_cpu_or(interrupts_enabled_mask, (1ULL << (interrupt)))
 
 /* Allow the given interrupt to be enabled immediately, if !irqs_disabled. */
 #define arch_local_irq_unmask_now(interrupt) do { \
diff --git a/arch/tile/kernel/asm-offsets.c b/arch/tile/kernel/asm-offsets.c
index 8652b0b..97ea6ac 100644
--- a/arch/tile/kernel/asm-offsets.c
+++ b/arch/tile/kernel/asm-offsets.c
@@ -58,6 +58,8 @@ void foo(void)
 	       offsetof(struct thread_info, status));
 	DEFINE(THREAD_INFO_HOMECACHE_CPU_OFFSET,
 	       offsetof(struct thread_info, homecache_cpu));
+	DEFINE(THREAD_INFO_PREEMPT_COUNT_OFFSET,
+	       offsetof(struct thread_info, preempt_count));
 	DEFINE(THREAD_INFO_STEP_STATE_OFFSET,
 	       offsetof(struct thread_info, step_state));
 #ifdef __tilegx__
diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index 7db8893..df27a1f 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -272,9 +272,9 @@ static void hardwall_setup_func(void *info)
 	struct hardwall_info *r = info;
 	struct hardwall_type *hwt = r->type;
 
-	int cpu = smp_processor_id();
-	int x = cpu % smp_width;
-	int y = cpu / smp_width;
+	int cpu = smp_processor_id();  /* on_each_cpu disables preemption */
+	int x = cpu_x(cpu);
+	int y = cpu_y(cpu);
 	int bits = 0;
 	if (x == r->ulhc_x)
 		bits |= W_PROTECT;
@@ -317,6 +317,7 @@ static void hardwall_protect_rectangle(struct hardwall_info *r)
 	on_each_cpu_mask(&rect_cpus, hardwall_setup_func, r, 1);
 }
 
+/* Entered from INT_xDN_FIREWALL interrupt vector with irqs disabled. */
 void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 {
 	struct hardwall_info *rect;
@@ -325,7 +326,6 @@ void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 	struct siginfo info;
 	int cpu = smp_processor_id();
 	int found_processes;
-	unsigned long flags;
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
 	irq_enter();
@@ -346,7 +346,7 @@ void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 	BUG_ON(hwt->disabled);
 
 	/* This tile trapped a network access; find the rectangle. */
-	spin_lock_irqsave(&hwt->lock, flags);
+	spin_lock(&hwt->lock);
 	list_for_each_entry(rect, &hwt->list, list) {
 		if (cpumask_test_cpu(cpu, &rect->cpumask))
 			break;
@@ -401,7 +401,7 @@ void __kprobes do_hardwall_trap(struct pt_regs* regs, int fault_num)
 		pr_notice("hardwall: no associated processes!\n");
 
  done:
-	spin_unlock_irqrestore(&hwt->lock, flags);
+	spin_unlock(&hwt->lock);
 
 	/*
 	 * We have to disable firewall interrupts now, or else when we
@@ -661,7 +661,7 @@ static int hardwall_deactivate(struct hardwall_type *hwt,
 		return -EINVAL;
 
 	printk(KERN_DEBUG "Pid %d (%s) deactivated for %s hardwall: cpu %d\n",
-	       task->pid, task->comm, hwt->name, smp_processor_id());
+	       task->pid, task->comm, hwt->name, raw_smp_processor_id());
 	return 0;
 }
 
@@ -803,8 +803,8 @@ static void reset_xdn_network_state(struct hardwall_type *hwt)
 	/* Reset UDN coordinates to their standard value */
 	{
 		unsigned int cpu = smp_processor_id();
-		unsigned int x = cpu % smp_width;
-		unsigned int y = cpu / smp_width;
+		unsigned int x = cpu_x(cpu);
+		unsigned int y = cpu_y(cpu);
 		__insn_mtspr(SPR_UDN_TILE_COORD, (x << 18) | (y << 7));
 	}
 
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 3880613..1076765 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -28,10 +28,6 @@
 #include <arch/interrupts.h>
 #include <arch/spr_def.h>
 
-#ifdef CONFIG_PREEMPT
-# error "No support for kernel preemption currently"
-#endif
-
 #define PTREGS_PTR(reg, ptreg) addli reg, sp, C_ABI_SAVE_AREA_SIZE + (ptreg)
 
 #define PTREGS_OFFSET_SYSCALL PTREGS_OFFSET_REG(TREG_SYSCALL_NR)
@@ -812,17 +808,34 @@ STD_ENTRY(interrupt_return)
 	}
 	lw      r29, r29
 	andi    r29, r29, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	bzt     r29, .Lresume_userspace
+
+#ifdef CONFIG_PREEMPT
+	/* Returning to kernel space. Check if we need preemption. */
+	GET_THREAD_INFO(r29)
+	addli   r28, r29, THREAD_INFO_FLAGS_OFFSET
 	{
-	 bzt    r29, .Lresume_userspace
-	 PTREGS_PTR(r29, PTREGS_OFFSET_PC)
+	 lw     r28, r28
+	 addli  r29, r29, THREAD_INFO_PREEMPT_COUNT_OFFSET
+	}
+	{
+	 andi   r28, r28, _TIF_NEED_RESCHED
+	 lw     r29, r29
 	}
+	bzt     r28, 1f
+	bnz     r29, 1f
+	jal     preempt_schedule_irq
+	FEEDBACK_REENTER(interrupt_return)
+1:
+#endif
 
 	/* If we're resuming to _cpu_idle_nap, bump PC forward by 8. */
 	{
-	 lw     r28, r29
+	 PTREGS_PTR(r29, PTREGS_OFFSET_PC)
 	 moveli r27, lo16(_cpu_idle_nap)
 	}
 	{
+	 lw     r28, r29
 	 auli   r27, r27, ha16(_cpu_idle_nap)
 	}
 	{
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 0db068c..8e7d6b8 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -30,10 +30,6 @@
 #include <arch/interrupts.h>
 #include <arch/spr_def.h>
 
-#ifdef CONFIG_PREEMPT
-# error "No support for kernel preemption currently"
-#endif
-
 #define PTREGS_PTR(reg, ptreg) addli reg, sp, C_ABI_SAVE_AREA_SIZE + (ptreg)
 
 #define PTREGS_OFFSET_SYSCALL PTREGS_OFFSET_REG(TREG_SYSCALL_NR)
@@ -813,11 +809,33 @@ STD_ENTRY(interrupt_return)
 	andi    r29, r29, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
 	{
 	 beqzt  r29, .Lresume_userspace
-	 PTREGS_PTR(r29, PTREGS_OFFSET_PC)
+	 move   r29, sp
+	}
+
+#ifdef CONFIG_PREEMPT
+	/* Returning to kernel space. Check if we need preemption. */
+	EXTRACT_THREAD_INFO(r29)
+	addli   r28, r29, THREAD_INFO_FLAGS_OFFSET
+	{
+	 ld     r28, r28
+	 addli  r29, r29, THREAD_INFO_PREEMPT_COUNT_OFFSET
 	}
+	{
+	 andi   r28, r28, _TIF_NEED_RESCHED
+	 ld4s   r29, r29
+	}
+	beqzt   r28, 1f
+	bnez    r29, 1f
+	jal     preempt_schedule_irq
+	FEEDBACK_REENTER(interrupt_return)
+1:
+#endif
 
 	/* If we're resuming to _cpu_idle_nap, bump PC forward by 8. */
-	moveli  r27, hw2_last(_cpu_idle_nap)
+	{
+	 moveli r27, hw2_last(_cpu_idle_nap)
+	 PTREGS_PTR(r29, PTREGS_OFFSET_PC)
+	}
 	{
 	 ld     r28, r29
 	 shl16insli r27, r27, hw1(_cpu_idle_nap)
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 02e6280..c90de6c 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -74,6 +74,7 @@ static DEFINE_SPINLOCK(available_irqs_lock);
 /*
  * The interrupt handling path, implemented in terms of HV interrupt
  * emulation on TILE64 and TILEPro, and IPI hardware on TILE-Gx.
+ * Entered with interrupts disabled.
  */
 void tile_dev_intr(struct pt_regs *regs, int intnum)
 {
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index cbc73a8..6cc520d 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -100,8 +100,8 @@ static void smp_start_cpu_interrupt(void)
 /* Handler to stop the current cpu. */
 static void smp_stop_cpu_interrupt(void)
 {
-	set_cpu_online(smp_processor_id(), 0);
 	arch_local_irq_disable_all();
+	set_cpu_online(smp_processor_id(), 0);
 	for (;;)
 		asm("nap; nop");
 }
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index 44bab29..dee7f13 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -142,13 +142,15 @@ static struct cpumask cpu_started __cpuinitdata;
  */
 static void __cpuinit start_secondary(void)
 {
-	int cpuid = smp_processor_id();
+	int cpuid;
+
+	preempt_disable();
+
+	cpuid = smp_processor_id();
 
 	/* Set our thread pointer appropriately. */
 	set_my_cpu_offset(__per_cpu_offset[cpuid]);
 
-	preempt_disable();
-
 	/*
 	 * In large machines even this will slow us down, since we
 	 * will be contending for for the printk spinlock.
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index c972689..176ffe4 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -194,7 +194,7 @@ static int KBacktraceIterator_next_item_inclusive(
  */
 static void validate_stack(struct pt_regs *regs)
 {
-	int cpu = smp_processor_id();
+	int cpu = raw_smp_processor_id();
 	unsigned long ksp0 = get_current_ksp0();
 	unsigned long ksp0_base = ksp0 - THREAD_SIZE;
 	unsigned long sp = stack_pointer;
@@ -392,7 +392,7 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 		pr_err("Starting stack dump of tid %d, pid %d (%s)"
 		       " on cpu %d at cycle %lld\n",
 		       kbt->task->pid, kbt->task->tgid, kbt->task->comm,
-		       smp_processor_id(), get_cycles());
+		       raw_smp_processor_id(), get_cycles());
 	}
 	kbt->verbose = 1;
 	i = 0;
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index b881a7b..38debe7 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -38,8 +38,10 @@
 SYSCALL_DEFINE3(cacheflush, unsigned long, addr, unsigned long, len,
 		unsigned long, flags)
 {
+	/* DCACHE is not particularly effective if not bound to one cpu. */
 	if (flags & DCACHE)
-		homecache_evict(cpumask_of(smp_processor_id()));
+		homecache_evict(cpumask_of(raw_smp_processor_id()));
+
 	if (flags & ICACHE)
 		flush_remote(0, HV_FLUSH_EVICT_L1I, mm_cpumask(current->mm),
 			     0, 0, 0, NULL, NULL, 0);
diff --git a/arch/tile/lib/memcpy_tile64.c b/arch/tile/lib/memcpy_tile64.c
index 3bc4b4e..0290c22 100644
--- a/arch/tile/lib/memcpy_tile64.c
+++ b/arch/tile/lib/memcpy_tile64.c
@@ -65,7 +65,7 @@ static void memcpy_multicache(void *dest, const void *source,
 	pmd_t *pmdp;
 	pte_t *ptep;
 	int type0, type1;
-	int cpu = get_cpu();
+	int cpu = smp_processor_id();
 
 	/*
 	 * Disable interrupts so that we don't recurse into memcpy()
@@ -126,7 +126,6 @@ static void memcpy_multicache(void *dest, const void *source,
 	kmap_atomic_idx_pop();
 	sim_allow_multiple_caching(0);
 	local_irq_restore(flags);
-	put_cpu();
 }
 
 /*
@@ -137,6 +136,9 @@ static void memcpy_multicache(void *dest, const void *source,
 static unsigned long fast_copy(void *dest, const void *source, int len,
 			       memcpy_t func)
 {
+	int cpu = get_cpu();
+	unsigned long retval;
+
 	/*
 	 * Check if it's big enough to bother with.  We may end up doing a
 	 * small copy via TLB manipulation if we're near a page boundary,
@@ -158,7 +160,7 @@ retry_source:
 		    !hv_pte_get_readable(src_pte) ||
 		    hv_pte_get_mode(src_pte) != HV_PTE_MODE_CACHE_TILE_L3)
 			break;
-		if (get_remote_cache_cpu(src_pte) == smp_processor_id())
+		if (get_remote_cache_cpu(src_pte) == cpu)
 			break;
 		src_page = pfn_to_page(pte_pfn(src_pte));
 		get_page(src_page);
@@ -235,7 +237,9 @@ retry_dest:
 		len -= copy_size;
 	}
 
-	return func(dest, source, len);
+	retval = func(dest, source, len);
+	put_cpu();
+	return retval;
 }
 
 void *memcpy(void *to, const void *from, __kernel_size_t n)
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index 1ae9119..df46a2d 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -172,7 +172,8 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 
 static void homecache_finv_page_va(void* va, int home)
 {
-	if (home == smp_processor_id()) {
+	int cpu = get_cpu();
+	if (home == cpu) {
 		finv_buffer_local(va, PAGE_SIZE);
 	} else if (home == PAGE_HOME_HASH) {
 		finv_buffer_remote(va, PAGE_SIZE, 1);
@@ -180,6 +181,7 @@ static void homecache_finv_page_va(void* va, int home)
 		BUG_ON(home < 0 || home >= NR_CPUS);
 		finv_buffer_remote(va, PAGE_SIZE, 0);
 	}
+	put_cpu();
 }
 
 void homecache_finv_map_page(struct page *page, int home)
-- 
1.8.3.1

