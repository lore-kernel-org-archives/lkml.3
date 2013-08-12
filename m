Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3HLQQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:16:00 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:58859 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab3HLQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:15:49 -0400
Message-ID: <201308121615.r7CGFmPR024702@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 11:35:02 -0400
Subject: [PATCH] tilegx: change how we find the kernel stack
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, we used a special-purpose register (SPR_SYSTEM_SAVE_K_0)
to hold the CPU number and the top of the current kernel stack
by using the low bits to hold the CPU number, and using the high
bits to hold the address of the page just above where we'd want
the kernel stack to be.  That way we could initialize a new SP
when first entering the kernel by just masking the SPR value and
subtracting a couple of words.

However, it's actually more useful to be able to place an arbitrary
kernel-top value in the SPR.  This allows us to create a new stack
context (e.g. for virtualization) with an arbitrary top-of-stack VA.
To make this work, we now store the CPU number in the high bits,
above the highest legal VA bit (42 bits in the current tilegx
microarchitecture).  The full 42 bits are thus available to store the
top of stack value.  Getting the current cpu (a relatively common
operation) is still fast; it's now a shift rather than a mask.

We make this change only for tilegx, since tilepro has too few SPR
bits to do this, and we don't need this support on tilepro anyway.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/processor.h | 47 +++++++++++++++++++++++++++------------
 arch/tile/kernel/head_32.S        |  3 +--
 arch/tile/kernel/head_64.S        |  6 ++---
 arch/tile/kernel/intvec_32.S      |  7 ++++--
 arch/tile/kernel/intvec_64.S      | 23 +++++++++----------
 arch/tile/kernel/stack.c          | 10 ++++-----
 6 files changed, 58 insertions(+), 38 deletions(-)

diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index 461322b..230b830 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -148,9 +148,10 @@ struct thread_struct {
 
 /*
  * Start with "sp" this many bytes below the top of the kernel stack.
- * This preserves the invariant that a called function may write to *sp.
+ * This allows us to be cache-aware when handling the initial save
+ * of the pt_regs value to the stack.
  */
-#define STACK_TOP_DELTA 8
+#define STACK_TOP_DELTA 64
 
 /*
  * When entering the kernel via a fault, start with the top of the
@@ -234,15 +235,15 @@ extern int do_work_pending(struct pt_regs *regs, u32 flags);
 unsigned long get_wchan(struct task_struct *p);
 
 /* Return initial ksp value for given task. */
-#define task_ksp0(task) ((unsigned long)(task)->stack + THREAD_SIZE)
+#define task_ksp0(task) \
+	((unsigned long)(task)->stack + THREAD_SIZE - STACK_TOP_DELTA)
 
 /* Return some info about the user process TASK. */
-#define KSTK_TOP(task)	(task_ksp0(task) - STACK_TOP_DELTA)
 #define task_pt_regs(task) \
-  ((struct pt_regs *)(task_ksp0(task) - KSTK_PTREGS_GAP) - 1)
+	((struct pt_regs *)(task_ksp0(task) - KSTK_PTREGS_GAP) - 1)
 #define current_pt_regs()                                   \
-  ((struct pt_regs *)((stack_pointer | (THREAD_SIZE - 1)) - \
-                      (KSTK_PTREGS_GAP - 1)) - 1)
+	((struct pt_regs *)((stack_pointer | (THREAD_SIZE - 1)) - \
+			    STACK_TOP_DELTA - (KSTK_PTREGS_GAP - 1)) - 1)
 #define task_sp(task)	(task_pt_regs(task)->sp)
 #define task_pc(task)	(task_pt_regs(task)->pc)
 /* Aliases for pc and sp (used in fs/proc/array.c) */
@@ -355,20 +356,38 @@ extern int kdata_huge;
 #define KERNEL_PL CONFIG_KERNEL_PL
 
 /* SYSTEM_SAVE_K_0 holds the current cpu number ORed with ksp0. */
-#define CPU_LOG_MASK_VALUE 12
-#define CPU_MASK_VALUE ((1 << CPU_LOG_MASK_VALUE) - 1)
-#if CONFIG_NR_CPUS > CPU_MASK_VALUE
-# error Too many cpus!
+#ifdef __tilegx__
+#define CPU_SHIFT 48
+#if CHIP_VA_WIDTH() > CPU_SHIFT
+# error Too many VA bits!
 #endif
+#define MAX_CPU_ID ((1 << (64 - CPU_SHIFT)) - 1)
 #define raw_smp_processor_id() \
-	((int)__insn_mfspr(SPR_SYSTEM_SAVE_K_0) & CPU_MASK_VALUE)
+	((int)(__insn_mfspr(SPR_SYSTEM_SAVE_K_0) >> CPU_SHIFT))
 #define get_current_ksp0() \
-	(__insn_mfspr(SPR_SYSTEM_SAVE_K_0) & ~CPU_MASK_VALUE)
+	((unsigned long)(((long)__insn_mfspr(SPR_SYSTEM_SAVE_K_0) << \
+			  (64 - CPU_SHIFT)) >> (64 - CPU_SHIFT)))
+#define next_current_ksp0(task) ({ \
+	unsigned long __ksp0 = task_ksp0(task) & ((1UL << CPU_SHIFT) - 1); \
+	unsigned long __cpu = (long)raw_smp_processor_id() << CPU_SHIFT; \
+	__ksp0 | __cpu; \
+})
+#else
+#define LOG2_NR_CPU_IDS 6
+#define MAX_CPU_ID ((1 << LOG2_NR_CPU_IDS) - 1)
+#define raw_smp_processor_id() \
+	((int)__insn_mfspr(SPR_SYSTEM_SAVE_K_0) & MAX_CPU_ID)
+#define get_current_ksp0() \
+	(__insn_mfspr(SPR_SYSTEM_SAVE_K_0) & ~MAX_CPU_ID)
 #define next_current_ksp0(task) ({ \
 	unsigned long __ksp0 = task_ksp0(task); \
 	int __cpu = raw_smp_processor_id(); \
-	BUG_ON(__ksp0 & CPU_MASK_VALUE); \
+	BUG_ON(__ksp0 & MAX_CPU_ID); \
 	__ksp0 | __cpu; \
 })
+#endif
+#if CONFIG_NR_CPUS > (MAX_CPU_ID + 1)
+# error Too many cpus!
+#endif
 
 #endif /* _ASM_TILE_PROCESSOR_H */
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index d1527fc..f3f17b0 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -86,7 +86,7 @@ ENTRY(_start)
 	/*
 	 * Load up our per-cpu offset.  When the first (master) tile
 	 * boots, this value is still zero, so we will load boot_pc
-	 * with start_kernel, and boot_sp with init_stack + THREAD_SIZE.
+	 * with start_kernel, and boot_sp at the top of init_stack.
 	 * The master tile initializes the per-cpu offset array, so that
 	 * when subsequent (secondary) tiles boot, they will instead load
 	 * from their per-cpu versions of boot_sp and boot_pc.
@@ -126,7 +126,6 @@ ENTRY(_start)
 	lw sp, r1
 	or r4, sp, r4
 	mtspr SPR_SYSTEM_SAVE_K_0, r4  /* save ksp0 + cpu */
-	addi sp, sp, -STACK_TOP_DELTA
 	{
 	  move lr, zero   /* stop backtraces in the called function */
 	  jr r0
diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
index 969e4f8..652b814 100644
--- a/arch/tile/kernel/head_64.S
+++ b/arch/tile/kernel/head_64.S
@@ -158,7 +158,7 @@ ENTRY(_start)
 	/*
 	 * Load up our per-cpu offset.  When the first (master) tile
 	 * boots, this value is still zero, so we will load boot_pc
-	 * with start_kernel, and boot_sp with init_stack + THREAD_SIZE.
+	 * with start_kernel, and boot_sp with at the top of init_stack.
 	 * The master tile initializes the per-cpu offset array, so that
 	 * when subsequent (secondary) tiles boot, they will instead load
 	 * from their per-cpu versions of boot_sp and boot_pc.
@@ -202,9 +202,9 @@ ENTRY(_start)
 	}
 	ld r0, r0
 	ld sp, r1
-	or r4, sp, r4
+	shli r4, r4, CPU_SHIFT
+	bfins r4, sp, 0, CPU_SHIFT-1
 	mtspr SPR_SYSTEM_SAVE_K_0, r4  /* save ksp0 + cpu */
-	addi sp, sp, -STACK_TOP_DELTA
 	{
 	  move lr, zero   /* stop backtraces in the called function */
 	  jr r0
diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index 9c0c3cb..f3d26f4 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -185,7 +185,7 @@ intvec_\vecname:
 	 * point sp at the top aligned address on the actual stack page.
 	 */
 	mfspr   r0, SPR_SYSTEM_SAVE_K_0
-	mm      r0, r0, zero, LOG2_THREAD_SIZE, 31
+	mm      r0, r0, zero, LOG2_NR_CPU_IDS, 31
 
 0:
 	/*
@@ -203,6 +203,9 @@ intvec_\vecname:
 	 *    cache line 1: r14...r29
 	 *    cache line 0: 2 x frame, r0..r13
 	 */
+#if STACK_TOP_DELTA != 64
+#error STACK_TOP_DELTA must be 64 for assumptions here and in task_pt_regs()
+#endif
 	andi    r0, r0, -64
 
 	/*
@@ -464,7 +467,7 @@ intvec_\vecname:
 	}
 	{
 	 auli   r21, r21, ha16(__per_cpu_offset)
-	 mm     r20, r20, zero, 0, LOG2_THREAD_SIZE-1
+	 mm     r20, r20, zero, 0, LOG2_NR_CPU_IDS-1
 	}
 	s2a     r20, r20, r21
 	lw      tp, r20
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 99f8e9a..30d2d02 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -132,13 +132,9 @@ intvec_\vecname:
 	mfspr   r3, SPR_SYSTEM_SAVE_K_0
 
 	/* Get &thread_info->unalign_jit_tmp[0] in r3. */
-	mm      r3, zero, LOG2_THREAD_SIZE, 63
-#if THREAD_SIZE < 65536
-	addli   r3, r3, -(PAGE_SIZE - THREAD_INFO_UNALIGN_JIT_TMP_OFFSET)
-#else
-	addli   r3, r3, -(PAGE_SIZE/2)
-	addli   r3, r3, -(PAGE_SIZE/2 - THREAD_INFO_UNALIGN_JIT_TMP_OFFSET)
-#endif
+	bfexts  r3, r3, 0, CPU_SHIFT-1
+	mm      r3, zero, 0, LOG2_THREAD_SIZE-1
+	addli   r3, r3, THREAD_INFO_UNALIGN_JIT_TMP_OFFSET
 
 	/*
 	 * Save r0, r1, r2 into thread_info array r3 points to
@@ -358,13 +354,13 @@ intvec_\vecname:
 
 
 	/*
-	 * SYSTEM_SAVE_K_0 holds the cpu number in the low bits, and
-	 * the current stack top in the higher bits.  So we recover
-	 * our stack top by just masking off the low bits, then
+	 * SYSTEM_SAVE_K_0 holds the cpu number in the high bits, and
+	 * the current stack top in the lower bits.  So we recover
+	 * our starting stack value by sign-extending the low bits, then
 	 * point sp at the top aligned address on the actual stack page.
 	 */
 	mfspr   r0, SPR_SYSTEM_SAVE_K_0
-	mm      r0, zero, LOG2_THREAD_SIZE, 63
+	bfexts  r0, r0, 0, CPU_SHIFT-1
 
 0:
 	/*
@@ -386,6 +382,9 @@ intvec_\vecname:
 	 *    cache line 1: r6...r13
 	 *    cache line 0: 2 x frame, r0..r5
 	 */
+#if STACK_TOP_DELTA != 64
+#error STACK_TOP_DELTA must be 64 for assumptions here and in task_pt_regs()
+#endif
 	andi    r0, r0, -64
 
 	/*
@@ -683,7 +682,7 @@ intvec_\vecname:
 	}
 	{
 	 shl16insli r21, r21, hw1(__per_cpu_offset)
-	 bfextu r20, r20, 0, LOG2_THREAD_SIZE-1
+	 bfextu r20, r20, CPU_SHIFT, 63
 	}
 	shl16insli r21, r21, hw0(__per_cpu_offset)
 	shl3add r20, r20, r21
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index a9db923..24fd223 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -197,19 +197,19 @@ static void validate_stack(struct pt_regs *regs)
 {
 	int cpu = raw_smp_processor_id();
 	unsigned long ksp0 = get_current_ksp0();
-	unsigned long ksp0_base = ksp0 - THREAD_SIZE;
+	unsigned long ksp0_base = ksp0 & -THREAD_SIZE;
 	unsigned long sp = stack_pointer;
 
 	if (EX1_PL(regs->ex1) == KERNEL_PL && regs->sp >= ksp0) {
-		pr_err("WARNING: cpu %d: kernel stack page %#lx underrun!\n"
+		pr_err("WARNING: cpu %d: kernel stack %#lx..%#lx underrun!\n"
 		       "  sp %#lx (%#lx in caller), caller pc %#lx, lr %#lx\n",
-		       cpu, ksp0_base, sp, regs->sp, regs->pc, regs->lr);
+		       cpu, ksp0_base, ksp0, sp, regs->sp, regs->pc, regs->lr);
 	}
 
 	else if (sp < ksp0_base + sizeof(struct thread_info)) {
-		pr_err("WARNING: cpu %d: kernel stack page %#lx overrun!\n"
+		pr_err("WARNING: cpu %d: kernel stack %#lx..%#lx overrun!\n"
 		       "  sp %#lx (%#lx in caller), caller pc %#lx, lr %#lx\n",
-		       cpu, ksp0_base, sp, regs->sp, regs->pc, regs->lr);
+		       cpu, ksp0_base, ksp0, sp, regs->sp, regs->pc, regs->lr);
 	}
 }
 
-- 
1.8.3.1

