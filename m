Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3AXLAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:00:09 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:42526 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3AXKzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:55:15 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rajeshwar Ranga <rajeshwar.ranga@gmail.com>,
        Noam Camus <noamc@ezchip.com>, Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 44/71] ARC: SMP support
Date: Thu, 24 Jan 2013 16:20:32 +0530
Message-ID: <1359024639-21915-19-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARC common code to enable a SMP system + ISS provided SMP extensions.

ARC700 natively lacks SMP support, hence some of the core features are
are only enabled if SoCs have the necessary h/w pixie-dust. This
includes:
-Inter Processor Interrupts (IPI)
-Cache coherency
-load-locked/store-conditional
...

The low level exception handling would be completely broken in SMP
because we don't have hardware assisted stack switching. Thus a fair bit
of this code is repurposing the MMU_SCRATCH reg for event handler
prologues to keep them re-entrant.

Many thanks to Rajeshwar Range for his initial "major" contributions to
SMP Port (back in 2008), and to Noam Camus and Gilad Ben-Yossef for help
with resurrecting that in 3.2 kernel (2012).

Note that this platform code is again singleton design pattern - so
multiple SMP platforms won't build at the moment - this deficiency is
addressed in subsequent patches within this series.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rajeshwar Ranga <rajeshwar.ranga@gmail.com>
Cc: Noam Camus <noamc@ezchip.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
---
 arch/arc/Kconfig                         |   39 ++++-
 arch/arc/Makefile                        |    3 +
 arch/arc/include/asm/entry.h             |   49 +++++
 arch/arc/include/asm/mmu_context.h       |    4 +
 arch/arc/include/asm/mutex.h             |    9 +
 arch/arc/include/asm/pgtable.h           |    4 +
 arch/arc/include/asm/processor.h         |    8 +
 arch/arc/include/asm/smp.h               |  107 ++++++++++
 arch/arc/kernel/Makefile                 |    1 +
 arch/arc/kernel/ctx_sw.c                 |   11 +
 arch/arc/kernel/entry.S                  |    4 +
 arch/arc/kernel/head.S                   |   33 +++
 arch/arc/kernel/irq.c                    |    5 +
 arch/arc/kernel/setup.c                  |    4 +
 arch/arc/kernel/smp.c                    |  320 ++++++++++++++++++++++++++++++
 arch/arc/mm/tlb.c                        |    6 +
 arch/arc/mm/tlbex.S                      |   38 ++++
 arch/arc/plat-arcfpga/Kconfig            |   14 ++
 arch/arc/plat-arcfpga/Makefile           |    1 +
 arch/arc/plat-arcfpga/include/plat/irq.h |   10 +-
 arch/arc/plat-arcfpga/include/plat/smp.h |  115 +++++++++++
 arch/arc/plat-arcfpga/irq.c              |   10 +
 arch/arc/plat-arcfpga/smp.c              |  167 ++++++++++++++++
 23 files changed, 960 insertions(+), 2 deletions(-)
 create mode 100644 arch/arc/kernel/smp.c
 create mode 100644 arch/arc/plat-arcfpga/include/plat/smp.h
 create mode 100644 arch/arc/plat-arcfpga/smp.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 68350aa..52f5c07 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -116,9 +116,42 @@ config CPU_BIG_ENDIAN
 	help
 	  Build kernel for Big Endian Mode of ARC CPU
 
+config SMP
+	bool "Symmetric Multi-Processing (Incomplete)"
+	default n
+	select USE_GENERIC_SMP_HELPERS
+	help
+	  This enables support for systems with more than one CPU. If you have
+	  a system with only one CPU, like most personal computers, say N. If
+	  you have a system with more than one CPU, say Y.
+
+if SMP
+
+config ARC_HAS_COH_CACHES
+	def_bool n
+
+config ARC_HAS_COH_LLSC
+	def_bool n
+
+config ARC_HAS_COH_RTSC
+	def_bool n
+
+config ARC_HAS_REENTRANT_IRQ_LV2
+	def_bool n
+
+endif
+
+config NR_CPUS
+	int "Maximum number of CPUs (2-32)"
+	range 2 32
+	depends on SMP
+	default "2"
+
 menuconfig ARC_CACHE
 	bool "Enable Cache Support"
 	default y
+	# if SMP, cache enabled ONLY if ARC implementation has cache coherency
+	depends on !SMP || ARC_HAS_COH_CACHES
 
 if ARC_CACHE
 
@@ -213,6 +246,8 @@ config ARC_COMPACT_IRQ_LEVELS
 	default n
 	# Timer HAS to be high priority, for any other high priority config
 	select ARC_IRQ3_LV2
+	# if SMP, LV2 enabled ONLY if ARC implementation has LV2 re-entrancy
+	depends on !SMP || ARC_HAS_REENTRANT_IRQ_LV2
 
 if ARC_COMPACT_IRQ_LEVELS
 
@@ -261,6 +296,8 @@ config ARC_HAS_RTSC
 	bool "Insn: RTSC (64-bit r/o cycle counter)"
 	default y
 	depends on ARC_CPU_REL_4_10
+	# if SMP, enable RTSC only if counter is coherent across cores
+	depends on !SMP || ARC_HAS_COH_RTSC
 
 endmenu   # "ARC CPU Configuration"
 
@@ -309,7 +346,7 @@ menuconfig ARC_DBG
 
 config ARC_DBG_TLB_PARANOIA
 	bool "Paranoia Checks in Low Level TLB Handlers"
-	depends on ARC_DBG
+	depends on ARC_DBG && !SMP
 	default n
 
 config ARC_DBG_TLB_MISS_COUNT
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 4f28f5b..ef54fed 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -133,3 +133,6 @@ archclean:
 # Thus forcing all exten calls in this file to be long calls
 export CFLAGS_decompress_inflate.o = -mmedium-calls
 export CFLAGS_initramfs.o = -mmedium-calls
+ifdef CONFIG_SMP
+export CFLAGS_core.o = -mmedium-calls
+endif
diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
index 23ef2de..23daa32 100644
--- a/arch/arc/include/asm/entry.h
+++ b/arch/arc/include/asm/entry.h
@@ -389,11 +389,19 @@
  * to be saved again on kernel mode stack, as part of ptregs.
  *-------------------------------------------------------------*/
 .macro EXCPN_PROLOG_FREEUP_REG	reg
+#ifdef CONFIG_SMP
+	sr  \reg, [ARC_REG_SCRATCH_DATA0]
+#else
 	st  \reg, [@ex_saved_reg1]
+#endif
 .endm
 
 .macro EXCPN_PROLOG_RESTORE_REG	reg
+#ifdef CONFIG_SMP
+	lr  \reg, [ARC_REG_SCRATCH_DATA0]
+#else
 	ld  \reg, [@ex_saved_reg1]
+#endif
 .endm
 
 /*--------------------------------------------------------------
@@ -508,7 +516,11 @@
 	/* restore original r9 , saved in int1_saved_reg
 	* It will be saved on stack in macro: SAVE_CALLER_SAVED
 	*/
+#ifdef CONFIG_SMP
+	lr  r9, [ARC_REG_SCRATCH_DATA0]
+#else
 	ld  r9, [@int1_saved_reg]
+#endif
 
 	/* now we are ready to save the remaining context :) */
 	st      orig_r8_IS_IRQ1, [sp, 8]    /* Event Type */
@@ -639,6 +651,41 @@
 	bmsk \reg, \reg, 7
 .endm
 
+#ifdef CONFIG_SMP
+
+/*-------------------------------------------------
+ * Retrieve the current running task on this CPU
+ * 1. Determine curr CPU id.
+ * 2. Use it to index into _current_task[ ]
+ */
+.macro  GET_CURR_TASK_ON_CPU   reg
+	GET_CPU_ID  \reg
+	ld.as  \reg, [@_current_task, \reg]
+.endm
+
+/*-------------------------------------------------
+ * Save a new task as the "current" task on this CPU
+ * 1. Determine curr CPU id.
+ * 2. Use it to index into _current_task[ ]
+ *
+ * Coded differently than GET_CURR_TASK_ON_CPU (which uses LD.AS)
+ * because ST r0, [r1, offset] can ONLY have s9 @offset
+ * while   LD can take s9 (4 byte insn) or LIMM (8 byte insn)
+ */
+
+.macro  SET_CURR_TASK_ON_CPU    tsk, tmp
+	GET_CPU_ID  \tmp
+	add2 \tmp, @_current_task, \tmp
+	st   \tsk, [\tmp]
+#ifdef CONFIG_ARC_CURR_IN_REG
+	mov r25, \tsk
+#endif
+
+.endm
+
+
+#else   /* Uniprocessor implementation of macros */
+
 .macro  GET_CURR_TASK_ON_CPU    reg
 	ld  \reg, [@_current_task]
 .endm
@@ -650,6 +697,8 @@
 #endif
 .endm
 
+#endif /* SMP / UNI */
+
 /* ------------------------------------------------------------------
  * Get the ptr to some field of Current Task at @off in task struct
  *  -Uses r25 for Current task ptr if that is enabled
diff --git a/arch/arc/include/asm/mmu_context.h b/arch/arc/include/asm/mmu_context.h
index d12f3de..0d71fb1 100644
--- a/arch/arc/include/asm/mmu_context.h
+++ b/arch/arc/include/asm/mmu_context.h
@@ -147,8 +147,10 @@ init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
 {
+#ifndef CONFIG_SMP
 	/* PGD cached in MMU reg to avoid 3 mem lookups: task->mm->pgd */
 	write_aux_reg(ARC_REG_SCRATCH_DATA0, next->pgd);
+#endif
 
 	/*
 	 * Get a new ASID if task doesn't have a valid one. Possible when
@@ -197,7 +199,9 @@ static inline void destroy_context(struct mm_struct *mm)
 
 static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
 {
+#ifndef CONFIG_SMP
 	write_aux_reg(ARC_REG_SCRATCH_DATA0, next->pgd);
+#endif
 
 	/* Unconditionally get a new ASID */
 	get_new_mmu_context(next);
diff --git a/arch/arc/include/asm/mutex.h b/arch/arc/include/asm/mutex.h
index 3be5e64..a2f88ff 100644
--- a/arch/arc/include/asm/mutex.h
+++ b/arch/arc/include/asm/mutex.h
@@ -6,4 +6,13 @@
  * published by the Free Software Foundation.
  */
 
+/*
+ * xchg() based mutex fast path maintains a state of 0 or 1, as opposed to
+ * atomic dec based which can "count" any number of lock contenders.
+ * This ideally needs to be fixed in core, but for now switching to dec ver.
+ */
+#if defined(CONFIG_SMP) && (CONFIG_NR_CPUS > 2)
+#include <asm-generic/mutex-dec.h>
+#else
 #include <asm-generic/mutex-xchg.h>
+#endif
diff --git a/arch/arc/include/asm/pgtable.h b/arch/arc/include/asm/pgtable.h
index dcb07015..b7e3668 100644
--- a/arch/arc/include/asm/pgtable.h
+++ b/arch/arc/include/asm/pgtable.h
@@ -354,11 +354,15 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
  * Thus use this macro only when you are certain that "current" is current
  * e.g. when dealing with signal frame setup code etc
  */
+#ifndef CONFIG_SMP
 #define pgd_offset_fast(mm, addr)	\
 ({					\
 	pgd_t *pgd_base = (pgd_t *) read_aux_reg(ARC_REG_SCRATCH_DATA0);  \
 	pgd_base + pgd_index(addr);	\
 })
+#else
+#define pgd_offset_fast(mm, addr)	pgd_offset(mm, addr)
+#endif
 
 extern void paging_init(void);
 extern pgd_t swapper_pg_dir[] __aligned(PAGE_SIZE);
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index b7b1556..5f26b2c 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -58,7 +58,15 @@ unsigned long thread_saved_pc(struct task_struct *t);
 /* Prepare to copy thread state - unlazy all lazy status */
 #define prepare_to_copy(tsk)    do { } while (0)
 
+/*
+ * A lot of busy-wait loops in SMP are based off of non-volatile data otherwise
+ * get optimised away by gcc
+ */
+#ifdef CONFIG_SMP
+#define cpu_relax()	__asm__ __volatile__ ("" : : : "memory")
+#else
 #define cpu_relax()	do { } while (0)
+#endif
 
 #define copy_segments(tsk, mm)      do { } while (0)
 #define release_segments(mm)        do { } while (0)
diff --git a/arch/arc/include/asm/smp.h b/arch/arc/include/asm/smp.h
index 4341f3b..f91f194 100644
--- a/arch/arc/include/asm/smp.h
+++ b/arch/arc/include/asm/smp.h
@@ -9,6 +9,69 @@
 #ifndef __ASM_ARC_SMP_H
 #define __ASM_ARC_SMP_H
 
+#ifdef CONFIG_SMP
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/threads.h>
+
+#define raw_smp_processor_id() (current_thread_info()->cpu)
+
+/* including cpumask.h leads to cyclic deps hence this Forward declaration */
+struct cpumask;
+
+/*
+ * APIs provided by arch SMP code to generic code
+ */
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+
+/*
+ * APIs provided by arch SMP code to rest of arch code
+ */
+extern void __init smp_init_cpus(void);
+extern void __init first_lines_of_secondary(void);
+
+/*
+ * API expected BY platform smp code (FROM arch smp code)
+ *
+ * smp_ipi_irq_setup:
+ *	Takes @cpu and @irq to which the arch-common ISR is hooked up
+ */
+extern int smp_ipi_irq_setup(int cpu, int irq);
+
+/*
+ * APIs expected FROM platform smp code
+ *
+ * arc_platform_smp_cpuinfo:
+ *	returns a string containing info for /proc/cpuinfo
+ *
+ * arc_platform_smp_init_cpu:
+ *	Called from start_kernel_secondary to do any CPU local setup
+ *	such as starting a timer, setting up IPI etc
+ *
+ * arc_platform_smp_wait_to_boot:
+ *	Called from early bootup code for non-Master CPUs to "park" them
+ *
+ * arc_platform_smp_wakeup_cpu:
+ *	Called from __cpu_up (Master CPU) to kick start another one
+ *
+ * arc_platform_ipi_send:
+ *	Takes @cpumask to which IPI(s) would be sent.
+ *	The actual msg-id/buffer is manager in arch-common code
+ *
+ * arc_platform_ipi_clear:
+ *	Takes @cpu which got IPI at @irq to do any IPI clearing
+ */
+extern const char *arc_platform_smp_cpuinfo(void);
+extern void arc_platform_smp_init_cpu(void);
+extern void arc_platform_smp_wait_to_boot(int cpu);
+extern void arc_platform_smp_wakeup_cpu(int cpu, unsigned long pc);
+extern void arc_platform_ipi_send(const struct cpumask *callmap);
+extern void arc_platform_ipi_clear(int cpu, int irq);
+
+#endif  /* CONFIG_SMP */
+
 /*
  * ARC700 doesn't support atomic Read-Modify-Write ops.
  * Originally Interrupts had to be disabled around code to gaurantee atomicity.
@@ -18,10 +81,52 @@
  *
  * (1) These insn were introduced only in 4.10 release. So for older released
  *	support needed.
+ *
+ * (2) In a SMP setup, the LLOCK/SCOND atomiticity across CPUs needs to be
+ *	gaurantted by the platform (not something which core handles).
+ *	Assuming a platform won't, SMP Linux needs to use spinlocks + local IRQ
+ *	disabling for atomicity.
+ *
+ *	However exported spinlock API is not usable due to cyclic hdr deps
+ *	(even after system.h disintegration upstream)
+ *	asm/bitops.h -> linux/spinlock.h -> linux/preempt.h
+ *		-> linux/thread_info.h -> linux/bitops.h -> asm/bitops.h
+ *
+ *	So the workaround is to use the lowest level arch spinlock API.
+ *	The exported spinlock API is smart enough to be NOP for !CONFIG_SMP,
+ *	but same is not true for ARCH backend, hence the need for 2 variants
  */
 #ifndef CONFIG_ARC_HAS_LLSC
 
 #include <linux/irqflags.h>
+#ifdef CONFIG_SMP
+
+#include <asm/spinlock.h>
+
+extern arch_spinlock_t smp_atomic_ops_lock;
+extern arch_spinlock_t smp_bitops_lock;
+
+#define atomic_ops_lock(flags)	do {		\
+	local_irq_save(flags);			\
+	arch_spin_lock(&smp_atomic_ops_lock);	\
+} while (0)
+
+#define atomic_ops_unlock(flags) do {		\
+	arch_spin_unlock(&smp_atomic_ops_lock);	\
+	local_irq_restore(flags);		\
+} while (0)
+
+#define bitops_lock(flags)	do {		\
+	local_irq_save(flags);			\
+	arch_spin_lock(&smp_bitops_lock);	\
+} while (0)
+
+#define bitops_unlock(flags) do {		\
+	arch_spin_unlock(&smp_bitops_lock);	\
+	local_irq_restore(flags);		\
+} while (0)
+
+#else /* !CONFIG_SMP */
 
 #define atomic_ops_lock(flags)		local_irq_save(flags)
 #define atomic_ops_unlock(flags)	local_irq_restore(flags)
@@ -29,6 +134,8 @@
 #define bitops_lock(flags)		local_irq_save(flags)
 #define bitops_unlock(flags)		local_irq_restore(flags)
 
+#endif /* !CONFIG_SMP */
+
 #endif	/* !CONFIG_ARC_HAS_LLSC */
 
 #endif
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index a24820f..cd2f882 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -13,6 +13,7 @@ obj-y	+= signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o
 
 obj-$(CONFIG_OF)			+= devtree.o
 obj-$(CONFIG_MODULES)			+= arcksyms.o module.o
+obj-$(CONFIG_SMP) 			+= smp.o
 
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
diff --git a/arch/arc/kernel/ctx_sw.c b/arch/arc/kernel/ctx_sw.c
index fbf739c..60844da 100644
--- a/arch/arc/kernel/ctx_sw.c
+++ b/arch/arc/kernel/ctx_sw.c
@@ -58,7 +58,18 @@ __switch_to(struct task_struct *prev_task, struct task_struct *next_task)
 		 * For SMP extra work to get to &_current_task[cpu]
 		 * (open coded SET_CURR_TASK_ON_CPU)
 		 */
+#ifndef CONFIG_SMP
 		"st  %2, [@_current_task]	\n\t"
+#else
+		"lr   r24, [identity]		\n\t"
+		"lsr  r24, r24, 8		\n\t"
+		"bmsk r24, r24, 7		\n\t"
+		"add2 r24, @_current_task, r24	\n\t"
+		"st   %2,  [r24]		\n\t"
+#endif
+#ifdef CONFIG_ARC_CURR_IN_REG
+		"mov r25, %2   \n\t"
+#endif
 
 		/* get ksp of incoming task from tsk->thread.ksp */
 		"ld.as  sp, [%2, %1]   \n\t"
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index e33a0bf..3f6ce98 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -232,7 +232,11 @@ ARC_EXIT handle_interrupt_level2
 ARC_ENTRY handle_interrupt_level1
 
 	/* free up r9 as scratchpad */
+#ifdef CONFIG_SMP
+	sr  r9, [ARC_REG_SCRATCH_DATA0]
+#else
 	st   r9, [@int1_saved_reg]
+#endif
 
 	;Which mode (user/kernel) was the system in when intr occured
 	lr  r9, [status32_l1]
diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
index e63f6a4..006dec3 100644
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -27,6 +27,15 @@ stext:
 	; Don't clobber r0-r4 yet. It might have bootloader provided info
 	;-------------------------------------------------------------------
 
+#ifdef CONFIG_SMP
+	; Only Boot (Master) proceeds. Others wait in platform dependent way
+	;	IDENTITY Reg [ 3  2  1  0 ]
+	;	(cpu-id)             ^^^	=> Zero for UP ARC700
+	;					=> #Core-ID if SMP (Master 0)
+	GET_CPU_ID  r5
+	cmp	r5, 0
+	jnz	arc_platform_smp_wait_to_boot
+#endif
 	; Clear BSS before updating any globals
 	; XXX: use ZOL here
 	mov	r5, __bss_start
@@ -76,3 +85,27 @@ stext:
 	GET_TSK_STACK_BASE r9, sp	; r9 = tsk, sp = stack base(output)
 
 	j	start_kernel	; "C" entry point
+
+#ifdef CONFIG_SMP
+;----------------------------------------------------------------
+;     First lines of code run by secondary before jumping to 'C'
+;----------------------------------------------------------------
+	.section .init.text, "ax",@progbits
+	.type first_lines_of_secondary, @function
+	.globl first_lines_of_secondary
+
+first_lines_of_secondary:
+
+	; setup per-cpu idle task as "current" on this CPU
+	ld	r0, [@secondary_idle_tsk]
+	SET_CURR_TASK_ON_CPU  r0, r1
+
+	; setup stack (fp, sp)
+	mov	fp, 0
+
+	; set it's stack base to tsk->thread_info bottom
+	GET_TSK_STACK_BASE r0, sp
+
+	j	start_kernel_secondary
+
+#endif
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index ca70894..df7da2b 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -124,6 +124,11 @@ void __init init_IRQ(void)
 {
 	init_onchip_IRQ();
 	plat_init_IRQ();
+
+#ifdef CONFIG_SMP
+	/* Master CPU can initialize it's side of IPI */
+	arc_platform_smp_init_cpu();
+#endif
 }
 
 /*
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 27aebd6..4026b5a 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -86,6 +86,10 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_processor();
 
+#ifdef CONFIG_SMP
+	smp_init_cpus();
+#endif
+
 	setup_arch_memory();
 
 	unflatten_device_tree();
diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
new file mode 100644
index 0000000..1f762ad
--- /dev/null
+++ b/arch/arc/kernel/smp.c
@@ -0,0 +1,320 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * RajeshwarR: Dec 11, 2007
+ *   -- Added support for Inter Processor Interrupts
+ *
+ * Vineetg: Nov 1st, 2007
+ *    -- Initial Write (Borrowed heavily from ARM)
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/profile.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/atomic.h>
+#include <linux/percpu.h>
+#include <linux/cpumask.h>
+#include <linux/spinlock_types.h>
+#include <linux/reboot.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+
+arch_spinlock_t smp_atomic_ops_lock = __ARCH_SPIN_LOCK_UNLOCKED;
+arch_spinlock_t smp_bitops_lock = __ARCH_SPIN_LOCK_UNLOCKED;
+
+/* XXX: per cpu ? Only needed once in early seconday boot */
+struct task_struct *secondary_idle_tsk;
+
+/* Called from start_kernel */
+void __init smp_prepare_boot_cpu(void)
+{
+}
+
+/*
+ * Initialise the CPU possible map early - this describes the CPUs
+ * which may be present or become present in the system.
+ */
+void __init smp_init_cpus(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < NR_CPUS; i++)
+		set_cpu_possible(i, true);
+}
+
+/* called from init ( ) =>  process 1 */
+void __init smp_prepare_cpus(unsigned int max_cpus)
+{
+	int i;
+
+	/*
+	 * Initialise the present map, which describes the set of CPUs
+	 * actually populated at the present time.
+	 */
+	for (i = 0; i < max_cpus; i++)
+		set_cpu_present(i, true);
+}
+
+void __init smp_cpus_done(unsigned int max_cpus)
+{
+
+}
+
+/*
+ * After power-up, a non Master CPU needs to wait for Master to kick start it
+ *
+ * The default implementation halts
+ *
+ * This relies on platform specific support allowing Master to directly set
+ * this CPU's PC (to be @first_lines_of_secondary() and kick start it.
+ *
+ * In lack of such h/w assist, platforms can override this function
+ *   - make this function busy-spin on a token, eventually set by Master
+ *     (from arc_platform_smp_wakeup_cpu())
+ *   - Once token is available, jump to @first_lines_of_secondary
+ *     (using inline asm).
+ *
+ * Alert: can NOT use stack here as it has not been determined/setup for CPU.
+ *        If it turns out to be elaborate, it's better to code it in assembly
+ *
+ */
+void __attribute__((weak)) arc_platform_smp_wait_to_boot(int cpu)
+{
+	/*
+	 * As a hack for debugging - since debugger will single-step over the
+	 * FLAG insn - wrap the halt itself it in a self loop
+	 */
+	__asm__ __volatile__(
+	"1:		\n"
+	"	flag 1	\n"
+	"	b 1b	\n");
+}
+
+/*
+ * The very first "C" code executed by secondary
+ * Called from asm stub in head.S
+ * "current"/R25 already setup by low level boot code
+ */
+void __cpuinit start_kernel_secondary(void)
+{
+	struct mm_struct *mm = &init_mm;
+	unsigned int cpu = smp_processor_id();
+
+	/* MMU, Caches, Vector Table, Interrupts etc */
+	setup_processor();
+
+	atomic_inc(&mm->mm_users);
+	atomic_inc(&mm->mm_count);
+	current->active_mm = mm;
+
+	notify_cpu_starting(cpu);
+	set_cpu_online(cpu, true);
+
+	pr_info("## CPU%u LIVE ##: Executing Code...\n", cpu);
+
+	arc_platform_smp_init_cpu();
+
+	arc_local_timer_setup(cpu);
+
+	local_irq_enable();
+	preempt_disable();
+	cpu_idle();
+}
+
+/*
+ * Called from kernel_init( ) -> smp_init( ) - for each CPU
+ *
+ * At this point, Secondary Processor  is "HALT"ed:
+ *  -It booted, but was halted in head.S
+ *  -It was configured to halt-on-reset
+ *  So need to wake it up.
+ *
+ * Essential requirements being where to run from (PC) and stack (SP)
+*/
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
+{
+	unsigned long wait_till;
+
+	secondary_idle_tsk = idle;
+
+	pr_info("Idle Task [%d] %p", cpu, idle);
+	pr_info("Trying to bring up CPU%u ...\n", cpu);
+
+	arc_platform_smp_wakeup_cpu(cpu,
+				(unsigned long)first_lines_of_secondary);
+
+	/* wait for 1 sec after kicking the secondary */
+	wait_till = jiffies + HZ;
+	while (time_before(jiffies, wait_till)) {
+		if (cpu_online(cpu))
+			break;
+	}
+
+	if (!cpu_online(cpu)) {
+		pr_info("Timeout: CPU%u FAILED to comeup !!!\n", cpu);
+		return -1;
+	}
+
+	secondary_idle_tsk = NULL;
+
+	return 0;
+}
+
+/*
+ * not supported here
+ */
+int __init setup_profiling_timer(unsigned int multiplier)
+{
+	return -EINVAL;
+}
+
+/*****************************************************************************/
+/*              Inter Processor Interrupt Handling                           */
+/*****************************************************************************/
+
+/*
+ * structures for inter-processor calls
+ * A Collection of single bit ipi messages
+ *
+ */
+
+/*
+ * TODO_rajesh investigate tlb message types.
+ * IPI Timer not needed because each ARC has an individual Interrupting Timer
+ */
+enum ipi_msg_type {
+	IPI_NOP = 0,
+	IPI_RESCHEDULE = 1,
+	IPI_CALL_FUNC,
+	IPI_CALL_FUNC_SINGLE,
+	IPI_CPU_STOP
+};
+
+struct ipi_data {
+	unsigned long bits;
+};
+
+static DEFINE_PER_CPU(struct ipi_data, ipi_data);
+
+static void ipi_send_msg(const struct cpumask *callmap, enum ipi_msg_type msg)
+{
+	unsigned long flags;
+	unsigned int cpu;
+
+	local_irq_save(flags);
+
+	for_each_cpu(cpu, callmap) {
+		struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
+		set_bit(msg, &ipi->bits);
+	}
+
+	/* Call the platform specific cross-CPU call function  */
+	arc_platform_ipi_send(callmap);
+
+	local_irq_restore(flags);
+}
+
+void smp_send_reschedule(int cpu)
+{
+	ipi_send_msg(cpumask_of(cpu), IPI_RESCHEDULE);
+}
+
+void smp_send_stop(void)
+{
+	struct cpumask targets;
+	cpumask_copy(&targets, cpu_online_mask);
+	cpumask_clear_cpu(smp_processor_id(), &targets);
+	ipi_send_msg(&targets, IPI_CPU_STOP);
+}
+
+void arch_send_call_function_single_ipi(int cpu)
+{
+	ipi_send_msg(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
+}
+
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
+{
+	ipi_send_msg(mask, IPI_CALL_FUNC);
+}
+
+/*
+ * ipi_cpu_stop - handle IPI from smp_send_stop()
+ */
+static void ipi_cpu_stop(unsigned int cpu)
+{
+	machine_halt();
+}
+
+static inline void __do_IPI(unsigned long *ops, struct ipi_data *ipi, int cpu)
+{
+	unsigned long msg = 0;
+
+	do {
+		msg = find_next_bit(ops, BITS_PER_LONG, msg+1);
+
+		switch (msg) {
+		case IPI_RESCHEDULE:
+			scheduler_ipi();
+			break;
+
+		case IPI_CALL_FUNC:
+			generic_smp_call_function_interrupt();
+			break;
+
+		case IPI_CALL_FUNC_SINGLE:
+			generic_smp_call_function_single_interrupt();
+			break;
+
+		case IPI_CPU_STOP:
+			ipi_cpu_stop(cpu);
+			break;
+		}
+	} while (msg < BITS_PER_LONG);
+
+}
+
+/*
+ * arch-common ISR to handle for inter-processor interrupts
+ * Has hooks for platform specific IPI
+ */
+irqreturn_t do_IPI(int irq, void *dev_id)
+{
+	int cpu = smp_processor_id();
+	struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
+	unsigned long ops;
+
+	arc_platform_ipi_clear(cpu, irq);
+
+	/*
+	 * XXX: is this loop really needed
+	 * And do we need to move ipi_clean inside
+	 */
+	while ((ops = xchg(&ipi->bits, 0)) != 0)
+		__do_IPI(&ops, ipi, cpu);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * API called by platform code to hookup arch-common ISR to their IPI IRQ
+ */
+static DEFINE_PER_CPU(int, ipi_dev);
+int smp_ipi_irq_setup(int cpu, int irq)
+{
+	int *dev_id = &per_cpu(ipi_dev, smp_processor_id());
+	return request_percpu_irq(irq, do_IPI, "IPI Interrupt", dev_id);
+}
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index 232a0ff..e96030c 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -474,6 +474,12 @@ void __init arc_mmu_init(void)
 
 	/* Enable the MMU */
 	write_aux_reg(ARC_REG_PID, MMU_ENABLE);
+
+	/* In smp we use this reg for interrupt 1 scratch */
+#ifndef CONFIG_SMP
+	/* swapper_pg_dir is the pgd for the kernel, used by vmalloc */
+	write_aux_reg(ARC_REG_SCRATCH_DATA0, swapper_pg_dir);
+#endif
 }
 
 /*
diff --git a/arch/arc/mm/tlbex.S b/arch/arc/mm/tlbex.S
index 164b021..4b1ad2d 100644
--- a/arch/arc/mm/tlbex.S
+++ b/arch/arc/mm/tlbex.S
@@ -57,9 +57,15 @@
 	.global ex_saved_reg1
 	.align 1 << L1_CACHE_SHIFT	; IMP: Must be Cache Line aligned
 	.type   ex_saved_reg1, @object
+#ifdef CONFIG_SMP
+	.size   ex_saved_reg1, (CONFIG_NR_CPUS << L1_CACHE_SHIFT)
+ex_saved_reg1:
+	.zero (CONFIG_NR_CPUS << L1_CACHE_SHIFT)
+#else
 	.size   ex_saved_reg1, 16
 ex_saved_reg1:
 	.zero 16
+#endif
 
 ;============================================================================
 ;  Troubleshooting Stuff
@@ -116,7 +122,13 @@ ex_saved_reg1:
 
 	lr  r2, [efa]
 
+#ifndef CONFIG_SMP
 	lr  r1, [ARC_REG_SCRATCH_DATA0] ; current pgd
+#else
+	GET_CURR_TASK_ON_CPU  r1
+	ld  r1, [r1, TASK_ACT_MM]
+	ld  r1, [r1, MM_PGD]
+#endif
 
 	lsr     r0, r2, PGDIR_SHIFT     ; Bits for indexing into PGD
 	ld.as   r1, [r1, r0]            ; PGD entry corresp to faulting addr
@@ -192,12 +204,28 @@ ex_saved_reg1:
 ;	".size   ex_saved_reg1, 16"
 ; [All of this dance is to avoid stack switching for each TLB Miss, since we
 ; only need to save only a handful of regs, as opposed to complete reg file]
+;
+; For ARC700 SMP, the "global" obviously can't be used for free up the FIRST
+; core reg as it will not be SMP safe.
+; Thus scratch AUX reg is used (and no longer used to cache task PGD).
+; To save the rest of 3 regs - per cpu, the global is made "per-cpu".
+; Epilogue thus has to locate the "per-cpu" storage for regs.
+; To avoid cache line bouncing the per-cpu global is aligned/sized per
+; L1_CACHE_SHIFT, despite fundamentally needing to be 12 bytes only. Hence
+;	".size   ex_saved_reg1, (CONFIG_NR_CPUS << L1_CACHE_SHIFT)"
 
 ; As simple as that....
 
 .macro TLBMISS_FREEUP_REGS
+#ifdef CONFIG_SMP
+	sr  r0, [ARC_REG_SCRATCH_DATA0]	; freeup r0 to code with
+	GET_CPU_ID  r0			; get to per cpu scratch mem,
+	lsl r0, r0, L1_CACHE_SHIFT	; cache line wide per cpu
+	add r0, @ex_saved_reg1, r0
+#else
 	st    r0, [@ex_saved_reg1]
 	mov_s r0, @ex_saved_reg1
+#endif
 	st_s  r1, [r0, 4]
 	st_s  r2, [r0, 8]
 	st_s  r3, [r0, 12]
@@ -210,11 +238,21 @@ ex_saved_reg1:
 
 ;-----------------------------------------------------------------
 .macro TLBMISS_RESTORE_REGS
+#ifdef CONFIG_SMP
+	GET_CPU_ID  r0			; get to per cpu scratch mem
+	lsl r0, r0, L1_CACHE_SHIFT	; each is cache line wide
+	add r0, @ex_saved_reg1, r0
+	ld_s  r3, [r0,12]
+	ld_s  r2, [r0, 8]
+	ld_s  r1, [r0, 4]
+	lr    r0, [ARC_REG_SCRATCH_DATA0]
+#else
 	mov_s r0, @ex_saved_reg1
 	ld_s  r3, [r0,12]
 	ld_s  r2, [r0, 8]
 	ld_s  r1, [r0, 4]
 	ld_s  r0, [r0]
+#endif
 .endm
 
 .section .text, "ax",@progbits	;Fast Path Code, candidate for ICCM
diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
index 7af3a4e..38752bf 100644
--- a/arch/arc/plat-arcfpga/Kconfig
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -13,6 +13,7 @@ choice
 
 config ARC_BOARD_ANGEL4
 	bool "ARC Angel4"
+	select ISS_SMP_EXTN if SMP
 	help
 	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
 
@@ -21,6 +22,19 @@ config ARC_BOARD_ML509
 	help
 	  ARC ML509 FPGA Ref Platform (Xilinx Virtex-5 Based)
 
+config ISS_SMP_EXTN
+	bool "ARC SMP Extensions (ISS Models only)"
+	default n
+	depends on SMP
+	select ARC_HAS_COH_RTSC
+	help
+	  SMP Extensions to ARC700, in a "simulation only" Model, supported in
+	  ARC ISS (Instruction Set Simulator).
+	  The SMP extensions include:
+	  -IDU (Interrupt Distribution Unit)
+	  -XTL (To enable CPU start/stop/set-PC for another CPU)
+	  It doesn't provide coherent Caches and/or Atomic Ops (LLOCK/SCOND)
+
 endchoice
 
 config ARC_SERIAL_BAUD
diff --git a/arch/arc/plat-arcfpga/Makefile b/arch/arc/plat-arcfpga/Makefile
index 385eb9d..2a828be 100644
--- a/arch/arc/plat-arcfpga/Makefile
+++ b/arch/arc/plat-arcfpga/Makefile
@@ -7,3 +7,4 @@
 #
 
 obj-y := platform.o irq.o
+obj-$(CONFIG_SMP)		+= smp.o
diff --git a/arch/arc/plat-arcfpga/include/plat/irq.h b/arch/arc/plat-arcfpga/include/plat/irq.h
index b34e087..255b90e 100644
--- a/arch/arc/plat-arcfpga/include/plat/irq.h
+++ b/arch/arc/plat-arcfpga/include/plat/irq.h
@@ -12,7 +12,11 @@
 #ifndef __PLAT_IRQ_H
 #define __PLAT_IRQ_H
 
-#define NR_IRQS		16
+#ifdef CONFIG_SMP
+#define NR_IRQS 32
+#else
+#define NR_IRQS 16
+#endif
 
 #define UART0_IRQ	5
 #define UART1_IRQ	10
@@ -24,4 +28,8 @@
 #define PCI_IRQ		14
 #define PS2_IRQ		15
 
+#ifdef CONFIG_SMP
+#define IDU_INTERRUPT_0 16
+#endif
+
 #endif
diff --git a/arch/arc/plat-arcfpga/include/plat/smp.h b/arch/arc/plat-arcfpga/include/plat/smp.h
new file mode 100644
index 0000000..8c5e46c
--- /dev/null
+++ b/arch/arc/plat-arcfpga/include/plat/smp.h
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  Rajeshwar Ranga: Interrupt Distribution Unit API's
+ */
+
+#ifndef __PLAT_ARCFPGA_SMP_H
+#define __PLAT_ARCFPGA_SMP_H
+
+#ifdef CONFIG_SMP
+
+#include <linux/types.h>
+#include <asm/arcregs.h>
+
+#define ARC_AUX_IDU_REG_CMD		0x2000
+#define ARC_AUX_IDU_REG_PARAM		0x2001
+
+#define ARC_AUX_XTL_REG_CMD		0x2002
+#define ARC_AUX_XTL_REG_PARAM		0x2003
+
+#define ARC_REG_MP_BCR			0x2021
+
+#define ARC_XTL_CMD_WRITE_PC		0x04
+#define ARC_XTL_CMD_CLEAR_HALT		0x02
+
+/*
+ * Build Configuration Register which identifies the sub-components
+ */
+struct bcr_mp {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int mp_arch:16, pad:5, sdu:1, idu:1, scu:1, ver:8;
+#else
+	unsigned int ver:8, scu:1, idu:1, sdu:1, pad:5, mp_arch:16;
+#endif
+};
+
+/* IDU supports 256 common interrupts */
+#define NR_IDU_IRQS			256
+
+/*
+ * The Aux Regs layout is same bit-by-bit in both BE/LE modes.
+ * However when casted as a bitfield encoded "C" struct, gcc treats it as
+ * memory, generating different code for BE/LE, requiring strcture adj (see
+ * include/asm/arcregs.h)
+ *
+ * However when manually "carving" the value for a Aux, no special handling
+ * of BE is needed because of the property discribed above
+ */
+#define IDU_SET_COMMAND(irq, cmd)			\
+do {							\
+	uint32_t __val;					\
+	__val = (((irq & 0xFF) << 8) | (cmd & 0xFF));	\
+	write_aux_reg(ARC_AUX_IDU_REG_CMD, __val);	\
+} while (0)
+
+#define IDU_SET_PARAM(par)  write_aux_reg(ARC_AUX_IDU_REG_PARAM, par)
+#define IDU_GET_PARAM()     read_aux_reg(ARC_AUX_IDU_REG_PARAM)
+
+/* IDU Commands */
+#define IDU_DISABLE			0x00
+#define IDU_ENABLE			0x01
+#define IDU_IRQ_CLEAR			0x02
+#define IDU_IRQ_ASSERT			0x03
+#define IDU_IRQ_WMODE			0x04
+#define IDU_IRQ_STATUS			0x05
+#define IDU_IRQ_ACK			0x06
+#define IDU_IRQ_PEND			0x07
+#define IDU_IRQ_RMODE			0x08
+#define IDU_IRQ_WBITMASK		0x09
+#define IDU_IRQ_RBITMASK		0x0A
+
+#define idu_enable()		IDU_SET_COMMAND(0, IDU_ENABLE)
+#define idu_disable()		IDU_SET_COMMAND(0, IDU_DISABLE)
+
+#define idu_irq_assert(irq)	IDU_SET_COMMAND((irq), IDU_IRQ_ASSERT)
+#define idu_irq_clear(irq)	IDU_SET_COMMAND((irq), IDU_IRQ_CLEAR)
+
+/* IDU Interrupt Mode - Destination Encoding */
+#define IDU_IRQ_MOD_DISABLE		0x00
+#define IDU_IRQ_MOD_ROUND_RECP		0x01
+#define IDU_IRQ_MOD_TCPU_FIRSTRECP	0x02
+#define IDU_IRQ_MOD_TCPU_ALLRECP	0x03
+
+/* IDU Interrupt Mode  - Triggering Mode */
+#define IDU_IRQ_MODE_LEVEL_TRIG		0x00
+#define IDU_IRQ_MODE_PULSE_TRIG		0x01
+
+#define IDU_IRQ_MODE_PARAM(dest_mode, trig_mode)   \
+	(((trig_mode & 0x01) << 15) | (dest_mode & 0xFF))
+
+struct idu_irq_config {
+	uint8_t irq;
+	uint8_t dest_mode;
+	uint8_t trig_mode;
+};
+
+struct idu_irq_status {
+	uint8_t irq;
+	bool enabled;
+	bool status;
+	bool ack;
+	bool pend;
+	uint8_t next_rr;
+};
+
+extern void idu_irq_set_tgtcpu(uint8_t irq, uint32_t mask);
+extern void idu_irq_set_mode(uint8_t irq, uint8_t dest_mode, uint8_t trig_mode);
+
+#endif	/* CONFIG_SMP */
+
+#endif
diff --git a/arch/arc/plat-arcfpga/irq.c b/arch/arc/plat-arcfpga/irq.c
index ed72636..590edd1 100644
--- a/arch/arc/plat-arcfpga/irq.c
+++ b/arch/arc/plat-arcfpga/irq.c
@@ -9,7 +9,17 @@
  */
 
 #include <linux/interrupt.h>
+#include <asm/irq.h>
 
 void __init plat_init_IRQ(void)
 {
+	/*
+	 * SMP Hack because UART IRQ hardwired to cpu0 (boot-cpu) but if the
+	 * request_irq() comes from any other CPU, the low level IRQ unamsking
+	 * essential for getting Interrupts won't be enabled on cpu0, locking
+	 * up the UART state machine.
+	 */
+#ifdef CONFIG_SMP
+	arch_unmask_irq(UART0_IRQ);
+#endif
 }
diff --git a/arch/arc/plat-arcfpga/smp.c b/arch/arc/plat-arcfpga/smp.c
new file mode 100644
index 0000000..a95fcdb
--- /dev/null
+++ b/arch/arc/plat-arcfpga/smp.c
@@ -0,0 +1,167 @@
+/*
+ * ARC700 Simulation-only Extensions for SMP
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  Vineet Gupta    - 2012 : split off arch common and plat specific SMP
+ *  Rajeshwar Ranga - 2007 : Interrupt Distribution Unit API's
+ */
+
+#include <linux/smp.h>
+#include <asm/irq.h>
+#include <plat/smp.h>
+
+static char smp_cpuinfo_buf[128];
+
+/*
+ *-------------------------------------------------------------------
+ * Platform specific callbacks expected by arch SMP code
+ *-------------------------------------------------------------------
+ */
+
+const char *arc_platform_smp_cpuinfo(void)
+{
+#define IS_AVAIL1(var, str)    ((var) ? str : "")
+
+	struct bcr_mp mp;
+
+	READ_BCR(ARC_REG_MP_BCR, mp);
+
+	sprintf(smp_cpuinfo_buf, "Extn [700-SMP]: v%d, arch(%d) %s %s %s\n",
+		mp.ver, mp.mp_arch, IS_AVAIL1(mp.scu, "SCU"),
+		IS_AVAIL1(mp.idu, "IDU"), IS_AVAIL1(mp.sdu, "SDU"));
+
+	return smp_cpuinfo_buf;
+}
+
+/*
+ * Master kick starting another CPU
+ */
+void arc_platform_smp_wakeup_cpu(int cpu, unsigned long pc)
+{
+	/* setup the start PC */
+	write_aux_reg(ARC_AUX_XTL_REG_PARAM, pc);
+
+	/* Trigger WRITE_PC cmd for this cpu */
+	write_aux_reg(ARC_AUX_XTL_REG_CMD,
+			(ARC_XTL_CMD_WRITE_PC | (cpu << 8)));
+
+	/* Take the cpu out of Halt */
+	write_aux_reg(ARC_AUX_XTL_REG_CMD,
+			(ARC_XTL_CMD_CLEAR_HALT | (cpu << 8)));
+
+}
+
+/*
+ * Any SMP specific init any CPU does when it comes up.
+ * Here we setup the CPU to enable Inter-Processor-Interrupts
+ * Called for each CPU
+ * -Master      : init_IRQ()
+ * -Other(s)    : start_kernel_secondary()
+ */
+void arc_platform_smp_init_cpu(void)
+{
+	int cpu = smp_processor_id();
+
+	/* Check if CPU is configured for more than 16 interrupts */
+	if (NR_IRQS <= 16 || get_hw_config_num_irq() <= 16)
+		panic("[arcfpga] IRQ system can't support IDU IPI\n");
+
+	idu_disable();
+
+	/****************************************************************
+	 * IDU provides a set of Common IRQs, each of which can be dynamically
+	 * attached to (1|many|all) CPUs.
+	 * The Common IRQs [0-15] are mapped as CPU pvt [16-31]
+	 *
+	 * Here we use a simple 1:1 mapping:
+	 * A CPU 'x' is wired to Common IRQ 'x'.
+	 * So an IDU ASSERT on IRQ 'x' will trigger Interupt on CPU 'x', which
+	 * makes up for our simple IPI plumbing.
+	 *
+	 * TBD: Have a dedicated multicast IRQ for sending IPIs to all CPUs
+	 *      w/o having to do one-at-a-time
+	 ******************************************************************/
+
+	/*
+	 * Claim an IRQ which would trigger IPI on this CPU.
+	 * In IDU parlance it involves setting up a cpu bitmask for the IRQ
+	 * The bitmap here contains only 1 CPU (self).
+	 */
+	idu_irq_set_tgtcpu(cpu, 0x1 << cpu);
+
+	/* Set the IRQ destination to use the bitmask above */
+	idu_irq_set_mode(cpu, 7, /* XXX: IDU_IRQ_MOD_TCPU_ALLRECP: ISS bug */
+			 IDU_IRQ_MODE_PULSE_TRIG);
+
+	idu_enable();
+
+	/* Attach the arch-common IPI ISR to our IDU IRQ */
+	smp_ipi_irq_setup(cpu, IDU_INTERRUPT_0 + cpu);
+}
+
+void arc_platform_ipi_send(const struct cpumask *callmap)
+{
+	unsigned int cpu;
+
+	for_each_cpu(cpu, callmap)
+		idu_irq_assert(cpu);
+}
+
+void arc_platform_ipi_clear(int cpu, int irq)
+{
+	idu_irq_clear(IDU_INTERRUPT_0 + cpu);
+}
+
+/*
+ *-------------------------------------------------------------------
+ * Low level Platform IPI Providers
+ *-------------------------------------------------------------------
+ */
+
+/* Set the Mode for the Common IRQ */
+void idu_irq_set_mode(uint8_t irq, uint8_t dest_mode, uint8_t trig_mode)
+{
+	uint32_t par = IDU_IRQ_MODE_PARAM(dest_mode, trig_mode);
+
+	IDU_SET_PARAM(par);
+	IDU_SET_COMMAND(irq, IDU_IRQ_WMODE);
+}
+
+/* Set the target cpu Bitmask for Common IRQ */
+void idu_irq_set_tgtcpu(uint8_t irq, uint32_t mask)
+{
+	IDU_SET_PARAM(mask);
+	IDU_SET_COMMAND(irq, IDU_IRQ_WBITMASK);
+}
+
+/* Get the Interrupt Acknowledged status for IRQ (as CPU Bitmask) */
+bool idu_irq_get_ack(uint8_t irq)
+{
+	uint32_t val;
+
+	IDU_SET_COMMAND(irq, IDU_IRQ_ACK);
+	val = IDU_GET_PARAM();
+
+	return val & (1 << irq);
+}
+
+/*
+ * Get the Interrupt Pending status for IRQ (as CPU Bitmask)
+ * -Pending means CPU has not yet noticed the IRQ (e.g. disabled)
+ * -After Interrupt has been taken, the IPI expcitily needs to be
+ *  cleared, to be acknowledged.
+ */
+bool idu_irq_get_pend(uint8_t irq)
+{
+	uint32_t val;
+
+	IDU_SET_COMMAND(irq, IDU_IRQ_PEND);
+	val = IDU_GET_PARAM();
+
+	return val & (1 << irq);
+}
-- 
1.7.4.1

