Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab3H2Acz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:32:55 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:32905 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab3H2Acw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:32:52 -0400
Message-ID: <4c8483e9c1a4d42accb1900c769bf67bdca17c74.1377736306.git.cmetcalf@tilera.com>
In-Reply-To: <20130826120445.GD8218@redhat.com>
References: <20130826120445.GD8218@redhat.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 28 Aug 2013 16:57:20 -0400
Subject: [PATCH v3 2/3] tile: enable building as a paravirtualized KVM_GUEST
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit enables a special configure option to build the kernel to
run at PL1.  In this mode, the client can run under a KVM host kernel;
it can also run under the older Tilera hypervisor that ran the
operating system at PL1 by default.

The PL1 kernel runs with half the virtual address space and half the
physical address space of the PL2 kernel, so <asm/page.h> reflects
modifying those constants appropriately.  We make some things a little
more generic ("intrpt1" references from the old PL1 kernel
nomenclature have now been normalized to "intrpt"), and simplify some
other nomenclature (using MEM_SV_START instead of MEM_SV_INTRPT to
reflect the fact that where the supervisor starts is the fact of
interest, not that it happens to start with the interrupt vectors).

The simulator support for reflecting Elf binary data back out
associated with simulator backtrace information needs some additional
extension.  It currently will report backtrace information for the
guest kernel, but not for processes running within the guest kernel;
additional work in the simulator is required to be able to provide the
necessary path information for that to work.  For now we disable
simulator notifications within the guest kernel.

The timer interrupt for the guest uses the AUX_TILE_TIMER hardware,
leaving the regular TILE_TIMER for the host.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                  | 14 +++++++--
 arch/tile/include/asm/module.h     | 10 ++++--
 arch/tile/include/asm/page.h       | 63 +++++++++++++++++++-------------------
 arch/tile/include/asm/pgtable_32.h |  2 +-
 arch/tile/include/asm/pgtable_64.h |  3 +-
 arch/tile/include/asm/processor.h  |  2 +-
 arch/tile/include/asm/switch_to.h  | 25 ++++++++++++---
 arch/tile/include/asm/timex.h      |  8 +++++
 arch/tile/kernel/head_32.S         |  4 +--
 arch/tile/kernel/head_64.S         |  6 ++--
 arch/tile/kernel/intvec_32.S       |  6 ++--
 arch/tile/kernel/intvec_64.S       | 34 +++++++++++++++-----
 arch/tile/kernel/process.c         |  2 ++
 arch/tile/kernel/setup.c           |  8 ++---
 arch/tile/kernel/sysfs.c           |  4 +++
 arch/tile/kernel/time.c            | 14 ++++-----
 arch/tile/kernel/traps.c           |  2 +-
 arch/tile/kernel/vmlinux.lds.S     | 10 +++---
 arch/tile/mm/elf.c                 |  2 ++
 arch/tile/mm/init.c                |  8 ++---
 20 files changed, 145 insertions(+), 82 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 3bc8fb7..e89aae8 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -126,7 +126,7 @@ config TILEGX
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_KVM
+	select HAVE_KVM if !KVM_GUEST
 
 config TILEPRO
 	def_bool !TILEGX
@@ -366,11 +366,19 @@ config HARDWALL
 	bool "Hardwall support to allow access to user dynamic network"
 	default y
 
+config KVM_GUEST
+	bool "Build kernel as guest for KVM"
+	default n
+	depends on TILEGX
+	---help---
+	  This will build a kernel that runs at a lower protection level
+	  than the default kernel and is suitable to run under KVM.
+
 config KERNEL_PL
 	int "Processor protection level for kernel"
 	range 1 2
-	default 2 if TILEGX
-	default 1 if !TILEGX
+	default 2 if TILEGX && !KVM_GUEST
+	default 1 if !TILEGX || KVM_GUEST
 	---help---
 	  Since MDE 4.2, the Tilera hypervisor runs the kernel
 	  at PL2 by default.  If running under an older hypervisor,
diff --git a/arch/tile/include/asm/module.h b/arch/tile/include/asm/module.h
index 44ed07c..a8b546b 100644
--- a/arch/tile/include/asm/module.h
+++ b/arch/tile/include/asm/module.h
@@ -16,7 +16,6 @@
 #define _ASM_TILE_MODULE_H
 
 #include <arch/chip.h>
-
 #include <asm-generic/module.h>
 
 /* We can't use modules built with different page sizes. */
@@ -28,6 +27,13 @@
 # define MODULE_PGSZ ""
 #endif
 
+/* Tag guest Linux, since it uses different SPRs, etc. */
+#if CONFIG_KERNEL_PL == 2
+#define MODULE_PL ""
+#else
+#define MODULE_PL " guest"
+#endif
+
 /* We don't really support no-SMP so tag if someone tries. */
 #ifdef CONFIG_SMP
 #define MODULE_NOSMP ""
@@ -35,6 +41,6 @@
 #define MODULE_NOSMP " nosmp"
 #endif
 
-#define MODULE_ARCH_VERMAGIC CHIP_ARCH_NAME MODULE_PGSZ MODULE_NOSMP
+#define MODULE_ARCH_VERMAGIC CHIP_ARCH_NAME MODULE_PGSZ MODULE_PL MODULE_NOSMP
 
 #endif /* _ASM_TILE_MODULE_H */
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index b4f96c0..2c991f2 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -148,8 +148,17 @@ static inline __attribute_const__ int get_order(unsigned long size)
 #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 #endif
 
+#ifdef CONFIG_KVM_GUEST
+/* Paravirtualized guests get half the VA, and thus half the PA. */
+#define MAX_PA_WIDTH (CHIP_PA_WIDTH() - 1)
+#define MAX_VA_WIDTH (CHIP_VA_WIDTH() - 1)
+#else
+#define MAX_PA_WIDTH CHIP_PA_WIDTH()
+#define MAX_VA_WIDTH CHIP_VA_WIDTH()
+#endif
+
 /* Each memory controller has PAs distinct in their high bits. */
-#define NR_PA_HIGHBIT_SHIFT (CHIP_PA_WIDTH() - CHIP_LOG_NUM_MSHIMS())
+#define NR_PA_HIGHBIT_SHIFT (MAX_PA_WIDTH - CHIP_LOG_NUM_MSHIMS())
 #define NR_PA_HIGHBIT_VALUES (1 << CHIP_LOG_NUM_MSHIMS())
 #define __pa_to_highbits(pa) ((phys_addr_t)(pa) >> NR_PA_HIGHBIT_SHIFT)
 #define __pfn_to_highbits(pfn) ((pfn) >> (NR_PA_HIGHBIT_SHIFT - PAGE_SHIFT))
@@ -160,7 +169,7 @@ static inline __attribute_const__ int get_order(unsigned long size)
  * We reserve the lower half of memory for user-space programs, and the
  * upper half for system code.  We re-map all of physical memory in the
  * upper half, which takes a quarter of our VA space.  Then we have
- * the vmalloc regions.  The supervisor code lives at 0xfffffff700000000,
+ * the vmalloc regions.  The supervisor code lives at the highest address,
  * with the hypervisor above that.
  *
  * Loadable kernel modules are placed immediately after the static
@@ -172,26 +181,25 @@ static inline __attribute_const__ int get_order(unsigned long size)
  * Similarly, for now we don't play any struct page mapping games.
  */
 
-#if CHIP_PA_WIDTH() + 2 > CHIP_VA_WIDTH()
+#if MAX_PA_WIDTH + 2 > MAX_VA_WIDTH
 # error Too much PA to map with the VA available!
 #endif
-#define HALF_VA_SPACE           (_AC(1, UL) << (CHIP_VA_WIDTH() - 1))
 
-#define MEM_LOW_END		(HALF_VA_SPACE - 1)         /* low half */
-#define MEM_HIGH_START		(-HALF_VA_SPACE)            /* high half */
-#define PAGE_OFFSET		MEM_HIGH_START
-#define FIXADDR_BASE		_AC(0xfffffff400000000, UL) /* 4 GB */
-#define FIXADDR_TOP		_AC(0xfffffff500000000, UL) /* 4 GB */
+#ifdef CONFIG_KVM_GUEST
+#define PAGE_OFFSET		(_AC(1, UL) << (MAX_VA_WIDTH - 1))
+#define KERNEL_HIGH_VADDR	(_AC(1, UL) << MAX_VA_WIDTH)
+#else
+#define PAGE_OFFSET		(-(_AC(1, UL) << (MAX_VA_WIDTH - 1)))
+#define KERNEL_HIGH_VADDR	_AC(0xfffffff800000000, UL)  /* high 32GB */
+#endif
+
+#define FIXADDR_BASE		(KERNEL_HIGH_VADDR - 0x400000000) /* 4 GB */
+#define FIXADDR_TOP		(KERNEL_HIGH_VADDR - 0x300000000) /* 4 GB */
 #define _VMALLOC_START		FIXADDR_TOP
-#define HUGE_VMAP_BASE		_AC(0xfffffff600000000, UL) /* 4 GB */
-#define MEM_SV_START		_AC(0xfffffff700000000, UL) /* 256 MB */
-#define MEM_SV_INTRPT		MEM_SV_START
-#define MEM_MODULE_START	_AC(0xfffffff710000000, UL) /* 256 MB */
+#define HUGE_VMAP_BASE		(KERNEL_HIGH_VADDR - 0x200000000) /* 4 GB */
+#define MEM_SV_START		(KERNEL_HIGH_VADDR - 0x100000000) /* 256 MB */
+#define MEM_MODULE_START	(MEM_SV_START + (256*1024*1024)) /* 256 MB */
 #define MEM_MODULE_END		(MEM_MODULE_START + (256*1024*1024))
-#define MEM_HV_START		_AC(0xfffffff800000000, UL) /* 32 GB */
-
-/* Highest DTLB address we will use */
-#define KERNEL_HIGH_VADDR	MEM_SV_START
 
 #else /* !__tilegx__ */
 
@@ -213,25 +221,18 @@ static inline __attribute_const__ int get_order(unsigned long size)
  * values, and after that, we show "typical" values, since the actual
  * addresses depend on kernel #defines.
  *
- * MEM_HV_INTRPT                   0xfe000000
- * MEM_SV_INTRPT (kernel code)     0xfd000000
+ * MEM_HV_START                    0xfe000000
+ * MEM_SV_START  (kernel code)     0xfd000000
  * MEM_USER_INTRPT (user vector)   0xfc000000
- * FIX_KMAP_xxx                    0xf8000000 (via NR_CPUS * KM_TYPE_NR)
- * PKMAP_BASE                      0xf7000000 (via LAST_PKMAP)
- * HUGE_VMAP                       0xf3000000 (via CONFIG_NR_HUGE_VMAPS)
- * VMALLOC_START                   0xf0000000 (via __VMALLOC_RESERVE)
+ * FIX_KMAP_xxx                    0xfa000000 (via NR_CPUS * KM_TYPE_NR)
+ * PKMAP_BASE                      0xf9000000 (via LAST_PKMAP)
+ * VMALLOC_START                   0xf7000000 (via VMALLOC_RESERVE)
  * mapped LOWMEM                   0xc0000000
  */
 
 #define MEM_USER_INTRPT		_AC(0xfc000000, UL)
-#if CONFIG_KERNEL_PL == 1
-#define MEM_SV_INTRPT		_AC(0xfd000000, UL)
-#define MEM_HV_INTRPT		_AC(0xfe000000, UL)
-#else
-#define MEM_GUEST_INTRPT	_AC(0xfd000000, UL)
-#define MEM_SV_INTRPT		_AC(0xfe000000, UL)
-#define MEM_HV_INTRPT		_AC(0xff000000, UL)
-#endif
+#define MEM_SV_START		_AC(0xfd000000, UL)
+#define MEM_HV_START		_AC(0xfe000000, UL)
 
 #define INTRPT_SIZE		0x4000
 
diff --git a/arch/tile/include/asm/pgtable_32.h b/arch/tile/include/asm/pgtable_32.h
index e5bdc0e..63142ab 100644
--- a/arch/tile/include/asm/pgtable_32.h
+++ b/arch/tile/include/asm/pgtable_32.h
@@ -89,7 +89,7 @@ static inline int pud_huge_page(pud_t pud)	{ return 0; }
 /* We don't define any pgds for these addresses. */
 static inline int pgd_addr_invalid(unsigned long addr)
 {
-	return addr >= MEM_HV_INTRPT;
+	return addr >= MEM_HV_START;
 }
 
 /*
diff --git a/arch/tile/include/asm/pgtable_64.h b/arch/tile/include/asm/pgtable_64.h
index 7cb8d35..3421177 100644
--- a/arch/tile/include/asm/pgtable_64.h
+++ b/arch/tile/include/asm/pgtable_64.h
@@ -140,8 +140,7 @@ static inline unsigned long pgd_addr_normalize(unsigned long addr)
 /* We don't define any pgds for these addresses. */
 static inline int pgd_addr_invalid(unsigned long addr)
 {
-	return addr >= MEM_HV_START ||
-		(addr > MEM_LOW_END && addr < MEM_HIGH_START);
+	return addr >= KERNEL_HIGH_VADDR || addr != pgd_addr_normalize(addr);
 }
 
 /*
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index c72fcba..5aa5431 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -168,7 +168,7 @@ struct thread_struct {
 #ifndef __ASSEMBLY__
 
 #ifdef __tilegx__
-#define TASK_SIZE_MAX		(MEM_LOW_END + 1)
+#define TASK_SIZE_MAX		(_AC(1, UL) << (MAX_VA_WIDTH - 1))
 #else
 #define TASK_SIZE_MAX		PAGE_OFFSET
 #endif
diff --git a/arch/tile/include/asm/switch_to.h b/arch/tile/include/asm/switch_to.h
index b8f888c..8e9150f 100644
--- a/arch/tile/include/asm/switch_to.h
+++ b/arch/tile/include/asm/switch_to.h
@@ -50,16 +50,31 @@ extern struct task_struct *__switch_to(struct task_struct *prev,
 extern unsigned long get_switch_to_pc(void);
 
 /*
+ * Normally we notify the simulator whenever we change from one pid
+ * to another, so it can track symbol files appropriately on the fly.
+ * For now, we don't do this for the guest Linux, since we don't
+ * have a way to tell the simulator that we are entering a separate
+ * pid space when we are in the guest.
+ */
+#ifdef CONFIG_KVM_GUEST
+#define notify_sim_task_change(prev) do { } while (0)
+#else
+#define notify_sim_task_change(prev) do {				\
+	if (unlikely((prev)->state == TASK_DEAD))			\
+		__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_EXIT |	\
+			     ((prev)->pid << _SIM_CONTROL_OPERATOR_BITS)); \
+	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_SWITCH |		\
+		     (current->pid << _SIM_CONTROL_OPERATOR_BITS));	\
+} while (0)
+#endif
+
+/*
  * Kernel threads can check to see if they need to migrate their
  * stack whenever they return from a context switch; for user
  * threads, we defer until they are returning to user-space.
  */
 #define finish_arch_switch(prev) do {                                     \
-	if (unlikely((prev)->state == TASK_DEAD))                         \
-		__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_EXIT |       \
-			((prev)->pid << _SIM_CONTROL_OPERATOR_BITS));     \
-	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_SWITCH |             \
-		(current->pid << _SIM_CONTROL_OPERATOR_BITS));            \
+	notify_sim_task_change(prev);                                     \
 	if (current->mm == NULL && !kstack_hash &&                        \
 	    current_thread_info()->homecache_cpu != smp_processor_id())   \
 		homecache_migrate_kthread();                              \
diff --git a/arch/tile/include/asm/timex.h b/arch/tile/include/asm/timex.h
index edbd7e4..0417617 100644
--- a/arch/tile/include/asm/timex.h
+++ b/arch/tile/include/asm/timex.h
@@ -27,6 +27,14 @@
 
 typedef unsigned long long cycles_t;
 
+#ifdef CONFIG_KVM_GUEST
+#define INT_LINUX_TIMER INT_AUX_TILE_TIMER
+#define SPR_LINUX_TIMER_CONTROL SPR_AUX_TILE_TIMER_CONTROL
+#else
+#define INT_LINUX_TIMER INT_TILE_TIMER
+#define SPR_LINUX_TIMER_CONTROL SPR_TILE_TIMER_CONTROL
+#endif
+
 #if CHIP_HAS_SPLIT_CYCLE()
 cycles_t get_cycles(void);
 #define get_cycles_low() __insn_mfspr(SPR_CYCLE_LOW)
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index f3f17b0..8d5b40f 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -162,8 +162,8 @@ ENTRY(swapper_pg_dir)
 	.set addr, addr + PGDIR_SIZE
 	.endr
 
-	/* The true text VAs are mapped as VA = PA + MEM_SV_INTRPT */
-	PTE MEM_SV_INTRPT, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
+	/* The true text VAs are mapped as VA = PA + MEM_SV_START */
+	PTE MEM_SV_START, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
 			      (1 << (HV_PTE_INDEX_EXECUTABLE - 32))
 	.org swapper_pg_dir + PGDIR_SIZE
 	END(swapper_pg_dir)
diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
index 652b814..bd0e12f 100644
--- a/arch/tile/kernel/head_64.S
+++ b/arch/tile/kernel/head_64.S
@@ -135,9 +135,9 @@ ENTRY(_start)
 1:
 
 	/* Install the interrupt base. */
-	moveli r0, hw2_last(MEM_SV_START)
-	shl16insli r0, r0, hw1(MEM_SV_START)
-	shl16insli r0, r0, hw0(MEM_SV_START)
+	moveli r0, hw2_last(intrpt_start)
+	shl16insli r0, r0, hw1(intrpt_start)
+	shl16insli r0, r0, hw0(intrpt_start)
 	mtspr SPR_INTERRUPT_VECTOR_BASE_K, r0
 
 	/* Get our processor number and save it away in SAVE_K_0. */
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 8ac6072..2ce69a5 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -353,7 +353,7 @@ intvec_\vecname:
 #ifdef __COLLECT_LINKER_FEEDBACK__
 	.pushsection .text.intvec_feedback,"ax"
 	.org    (\vecnum << 5)
-	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt1, 1 << 8)
+	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt, 1 << 8)
 	jrp     lr
 	.popsection
 #endif
@@ -1892,8 +1892,8 @@ int_unalign:
 	push_extra_callee_saves r0
 	j       do_trap
 
-/* Include .intrpt1 array of interrupt vectors */
-	.section ".intrpt1", "ax"
+/* Include .intrpt array of interrupt vectors */
+	.section ".intrpt", "ax"
 
 #define op_handle_perf_interrupt bad_intr
 #define op_handle_aux_perf_interrupt bad_intr
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 45647a4..ccb0e65 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -38,6 +38,16 @@
 
 #define PTREGS_OFFSET_SYSCALL PTREGS_OFFSET_REG(TREG_SYSCALL_NR)
 
+#if CONFIG_KERNEL_PL == 1 || CONFIG_KERNEL_PL == 2
+/*
+ * Set "result" non-zero if ex1 holds the PL of the kernel
+ * (with or without ICS being set).  Note this works only
+ * because we never find the PL at level 3.
+ */
+# define IS_KERNEL_EX1(result, ex1) andi result, ex1, CONFIG_KERNEL_PL
+#else
+# error Recode IS_KERNEL_EX1 for CONFIG_KERNEL_PL
+#endif
 
 	.macro  push_reg reg, ptr=sp, delta=-8
 	{
@@ -312,7 +322,7 @@ intvec_\vecname:
 	 */
 	{
 	 blbs   sp, 2f
-	 andi   r0, r0, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	 IS_KERNEL_EX1(r0, r0)
 	}
 
 	.ifc    \vecnum, INT_DOUBLE_FAULT
@@ -530,7 +540,7 @@ intvec_\vecname:
 #ifdef __COLLECT_LINKER_FEEDBACK__
 	.pushsection .text.intvec_feedback,"ax"
 	.org    (\vecnum << 5)
-	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt1, 1 << 8)
+	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt, 1 << 8)
 	jrp     lr
 	.popsection
 #endif
@@ -651,7 +661,7 @@ intvec_\vecname:
 	 */
 	mfspr   r22, SPR_EX_CONTEXT_K_1
 	{
-	 andi   r32, r32, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	 IS_KERNEL_EX1(r22, r22)
 	 PTREGS_PTR(r21, PTREGS_OFFSET_FLAGS)
 	}
 	beqzt  r22, 1f        /* zero if from user space */
@@ -818,7 +828,7 @@ STD_ENTRY(interrupt_return)
 	 PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
 	}
 	ld      r29, r29
-	andi    r29, r29, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	IS_KERNEL_EX1(r29, r29)
 	{
 	 beqzt  r29, .Lresume_userspace
 	 move   r29, sp
@@ -955,7 +965,7 @@ restore_all:
 	 PTREGS_PTR(r32, PTREGS_OFFSET_FLAGS)
 	}
 	{
-	 andi   r0, r0, SPR_EX_CONTEXT_1_1__PL_MASK
+	 IS_KERNEL_EX1(r0, r0)
 	 ld     r32, r32
 	}
 	bnez    r0, 1f
@@ -1026,7 +1036,7 @@ restore_all:
 	pop_reg r21, sp, PTREGS_OFFSET_REG(31) - PTREGS_OFFSET_PC
 	{
 	 mtspr  SPR_EX_CONTEXT_K_1, lr
-	 andi   lr, lr, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
+	 IS_KERNEL_EX1(lr, lr)
 	}
 	{
 	 mtspr  SPR_EX_CONTEXT_K_0, r21
@@ -1555,8 +1565,10 @@ handle_downcall_dispatch:
 		__int_hand   \vecnum, \vecname, \c_routine, \processing
 	.endm
 
-/* Include .intrpt1 array of interrupt vectors */
-	.section ".intrpt1", "ax"
+/* Include .intrpt array of interrupt vectors */
+	.section ".intrpt", "ax"
+	.global intrpt_start
+intrpt_start:
 
 #define op_handle_perf_interrupt bad_intr
 #define op_handle_aux_perf_interrupt bad_intr
@@ -1601,7 +1613,13 @@ handle_downcall_dispatch:
 	int_hand     INT_DTLB_ACCESS, DTLB_ACCESS, do_page_fault
 	int_hand     INT_IDN_FIREWALL, IDN_FIREWALL, do_hardwall_trap
 	int_hand     INT_UDN_FIREWALL, UDN_FIREWALL, do_hardwall_trap
+#ifndef CONFIG_KVM_GUEST
 	int_hand     INT_TILE_TIMER, TILE_TIMER, do_timer_interrupt
+	int_hand     INT_AUX_TILE_TIMER, AUX_TILE_TIMER, bad_intr
+#else
+	int_hand     INT_TILE_TIMER, TILE_TIMER, bad_intr
+	int_hand     INT_AUX_TILE_TIMER, AUX_TILE_TIMER, do_timer_interrupt
+#endif
 	int_hand     INT_IDN_TIMER, IDN_TIMER, bad_intr
 	int_hand     INT_UDN_TIMER, UDN_TIMER, bad_intr
 	int_hand     INT_IDN_AVAIL, IDN_AVAIL, bad_intr
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 7040490..2629ff1 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -248,11 +248,13 @@ struct task_struct *validate_current(void)
 /* Take and return the pointer to the previous task, for schedule_tail(). */
 struct task_struct *sim_notify_fork(struct task_struct *prev)
 {
+#ifndef CONFIG_KVM_GUEST   /* see notify_sim_task_change() */
 	struct task_struct *tsk = current;
 	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_FORK_PARENT |
 		     (tsk->thread.creator_pid << _SIM_CONTROL_OPERATOR_BITS));
 	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_FORK |
 		     (tsk->pid << _SIM_CONTROL_OPERATOR_BITS));
+#endif
 	return prev;
 }
 
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 7918cf1..2352a81 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -268,7 +268,7 @@ early_param("vmalloc", parse_vmalloc);
 /*
  * Determine for each controller where its lowmem is mapped and how much of
  * it is mapped there.  On controller zero, the first few megabytes are
- * already mapped in as code at MEM_SV_INTRPT, so in principle we could
+ * already mapped in as code at MEM_SV_START, so in principle we could
  * start our data mappings higher up, but for now we don't bother, to avoid
  * additional confusion.
  *
@@ -1255,7 +1255,7 @@ static void __init validate_va(void)
 #ifndef __tilegx__   /* FIXME: GX: probably some validation relevant here */
 	/*
 	 * Similarly, make sure we're only using allowed VAs.
-	 * We assume we can contiguously use MEM_USER_INTRPT .. MEM_HV_INTRPT,
+	 * We assume we can contiguously use MEM_USER_INTRPT .. MEM_HV_START,
 	 * and 0 .. KERNEL_HIGH_VADDR.
 	 * In addition, make sure we CAN'T use the end of memory, since
 	 * we use the last chunk of each pgd for the pgd_list.
@@ -1270,7 +1270,7 @@ static void __init validate_va(void)
 		if (range.size == 0)
 			break;
 		if (range.start <= MEM_USER_INTRPT &&
-		    range.start + range.size >= MEM_HV_INTRPT)
+		    range.start + range.size >= MEM_HV_START)
 			user_kernel_ok = 1;
 		if (range.start == 0)
 			max_va = range.size;
@@ -1706,7 +1706,7 @@ insert_ram_resource(u64 start_pfn, u64 end_pfn, bool reserved)
 static int __init request_standard_resources(void)
 {
 	int i;
-	enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
+	enum { CODE_DELTA = MEM_SV_START - PAGE_OFFSET };
 
 #if defined(CONFIG_PCI) && !defined(__tilegx__)
 	insert_non_bus_resource();
diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
index e25b0a8..024b978 100644
--- a/arch/tile/kernel/sysfs.c
+++ b/arch/tile/kernel/sysfs.c
@@ -69,7 +69,11 @@ static ssize_t type_show(struct device *dev,
 			    struct device_attribute *attr,
 			    char *page)
 {
+#ifdef CONFIG_KVM_GUEST
+	return sprintf(page, "KVM\n");
+#else
 	return sprintf(page, "tilera\n");
+#endif
 }
 static DEVICE_ATTR(type, 0444, type_show, NULL);
 
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 3c2dc87..b0b7264 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -117,9 +117,9 @@ void __init time_init(void)
 
 /*
  * Define the tile timer clock event device.  The timer is driven by
- * the TILE_TIMER_CONTROL register, which consists of a 31-bit down
+ * the TILE_[AUX_]TIMER_CONTROL register, which consists of a 31-bit down
  * counter, plus bit 31, which signifies that the counter has wrapped
- * from zero to (2**31) - 1.  The INT_TILE_TIMER interrupt will be
+ * from zero to (2**31) - 1.  The INT_[AUX_]TILE_TIMER interrupt will be
  * raised as long as bit 31 is set.
  */
 
@@ -129,8 +129,8 @@ static int tile_timer_set_next_event(unsigned long ticks,
 				     struct clock_event_device *evt)
 {
 	BUG_ON(ticks > MAX_TICK);
-	__insn_mtspr(SPR_TILE_TIMER_CONTROL, ticks);
-	arch_local_irq_unmask_now(INT_TILE_TIMER);
+	__insn_mtspr(SPR_LINUX_TIMER_CONTROL, ticks);
+	arch_local_irq_unmask_now(INT_LINUX_TIMER);
 	return 0;
 }
 
@@ -141,7 +141,7 @@ static int tile_timer_set_next_event(unsigned long ticks,
 static void tile_timer_set_mode(enum clock_event_mode mode,
 				struct clock_event_device *evt)
 {
-	arch_local_irq_mask_now(INT_TILE_TIMER);
+	arch_local_irq_mask_now(INT_LINUX_TIMER);
 }
 
 static DEFINE_PER_CPU(struct clock_event_device, tile_timer) = {
@@ -161,7 +161,7 @@ void __cpuinit setup_tile_timer(void)
 	evt->cpumask = cpumask_of(smp_processor_id());
 
 	/* Start out with timer not firing. */
-	arch_local_irq_mask_now(INT_TILE_TIMER);
+	arch_local_irq_mask_now(INT_LINUX_TIMER);
 
 	/*
 	 * Register tile timer.  Set min_delta to 1 microsecond, since
@@ -181,7 +181,7 @@ void do_timer_interrupt(struct pt_regs *regs, int fault_num)
 	 * Mask the timer interrupt here, since we are a oneshot timer
 	 * and there are now by definition no events pending.
 	 */
-	arch_local_irq_mask(INT_TILE_TIMER);
+	arch_local_irq_mask(INT_LINUX_TIMER);
 
 	/* Track time spent here in an interrupt context */
 	irq_enter();
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index f110785..19d465c 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -30,7 +30,7 @@
 
 void __init trap_init(void)
 {
-	/* Nothing needed here since we link code at .intrpt1 */
+	/* Nothing needed here since we link code at .intrpt */
 }
 
 int unaligned_fixup = 1;
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index c7ae53d..8b20163 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -5,7 +5,7 @@
 #include <hv/hypervisor.h>
 
 /* Text loads starting from the supervisor interrupt vector address. */
-#define TEXT_OFFSET MEM_SV_INTRPT
+#define TEXT_OFFSET MEM_SV_START
 
 OUTPUT_ARCH(tile)
 ENTRY(_start)
@@ -13,7 +13,7 @@ jiffies = jiffies_64;
 
 PHDRS
 {
-  intrpt1 PT_LOAD ;
+  intrpt PT_LOAD ;
   text PT_LOAD ;
   data PT_LOAD ;
 }
@@ -24,11 +24,11 @@ SECTIONS
   #define LOAD_OFFSET TEXT_OFFSET
 
   /* Interrupt vectors */
-  .intrpt1 (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
+  .intrpt (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
   {
     _text = .;
-    *(.intrpt1)
-  } :intrpt1 =0
+    *(.intrpt)
+  } :intrpt =0
 
   /* Hypervisor call vectors */
   . = ALIGN(0x10000);
diff --git a/arch/tile/mm/elf.c b/arch/tile/mm/elf.c
index 23f044e..86cff48 100644
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -42,7 +42,9 @@ static int notify_exec(struct mm_struct *mm)
 	char *buf, *path;
 	struct vm_area_struct *vma;
 
+#ifndef CONFIG_KVM_GUEST   /* see notify_sim_task_change() */
 	if (!sim_is_simulator())
+#endif
 		return 1;
 
 	if (mm->exe_file == NULL)
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 3bfa127..c6d2160 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -234,7 +234,7 @@ static pgprot_t __init init_pgprot(ulong address)
 {
 	int cpu;
 	unsigned long page;
-	enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
+	enum { CODE_DELTA = MEM_SV_START - PAGE_OFFSET };
 
 #if CHIP_HAS_CBOX_HOME_MAP()
 	/* For kdata=huge, everything is just hash-for-home. */
@@ -538,7 +538,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 		}
 	}
 
-	address = MEM_SV_INTRPT;
+	address = MEM_SV_START;
 	pmd = get_pmd(pgtables, address);
 	pfn = 0;  /* code starts at PA 0 */
 	if (ktext_small) {
@@ -1021,7 +1021,7 @@ static void free_init_pages(char *what, unsigned long begin, unsigned long end)
 
 void free_initmem(void)
 {
-	const unsigned long text_delta = MEM_SV_INTRPT - PAGE_OFFSET;
+	const unsigned long text_delta = MEM_SV_START - PAGE_OFFSET;
 
 	/*
 	 * Evict the dirty initdata on the boot cpu, evict the w1data
@@ -1040,7 +1040,7 @@ void free_initmem(void)
 
 	/*
 	 * Free the pages mapped from 0xc0000000 that correspond to code
-	 * pages from MEM_SV_INTRPT that we won't use again after init.
+	 * pages from MEM_SV_START that we won't use again after init.
 	 */
 	free_init_pages("unused kernel text",
 			(unsigned long)_sinittext - text_delta,
-- 
1.8.3.1

