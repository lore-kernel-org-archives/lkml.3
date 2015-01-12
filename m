Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbbALSaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:30:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbbALSau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 193/216] arm64: kernel: refactor the CPU suspend API for retention states
Date: Mon, 12 Jan 2015 18:29:31 +0000
Message-Id: <1421087394-2712-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

commit 714f59925595b9c2ea9c22b107b340d38e3b3bc9 upstream.

CPU suspend is the standard kernel interface to be used to enter
low-power states on ARM64 systems. Current cpu_suspend implementation
by default assumes that all low power states are losing the CPU context,
so the CPU registers must be saved and cleaned to DRAM upon state
entry. Furthermore, the current cpu_suspend() implementation assumes
that if the CPU suspend back-end method returns when called, this has
to be considered an error regardless of the return code (which can be
successful) since the CPU was not expected to return from a code path that
is different from cpu_resume code path - eg returning from the reset vector.

All in all this means that the current API does not cope well with low-power
states that preserve the CPU context when entered (ie retention states),
since first of all the context is saved for nothing on state entry for
those states and a successful state entry can return as a normal function
return, which is considered an error by the current CPU suspend
implementation.

This patch refactors the cpu_suspend() API so that it can be split in
two separate functionalities. The arm64 cpu_suspend API just provides
a wrapper around CPU suspend operation hook. A new function is
introduced (for architecture code use only) for states that require
context saving upon entry:

__cpu_suspend(unsigned long arg, int (*fn)(unsigned long))

__cpu_suspend() saves the context on function entry and calls the
so called suspend finisher (ie fn) to complete the suspend operation.
The finisher is not expected to return, unless it fails in which case
the error is propagated back to the __cpu_suspend caller.

The API refactoring results in the following pseudo code call sequence for a
suspending CPU, when triggered from a kernel subsystem:

/*
 * int cpu_suspend(unsigned long idx)
 * @idx: idle state index
 */
{
-> cpu_suspend(idx)
	|---> CPU operations suspend hook called, if present
		|--> if (retention_state)
			|--> direct suspend back-end call (eg PSCI suspend)
		     else
			|--> __cpu_suspend(idx, &back_end_finisher);
}

By refactoring the cpu_suspend API this way, the CPU operations back-end
has a chance to detect whether idle states require state saving or not
and can call the required suspend operations accordingly either through
simple function call or indirectly through __cpu_suspend() which carries out
state saving and suspend finisher dispatching to complete idle state entry.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ luis: 3.16-stable prereq for
  f43c27188a49 "arm64: kernel: fix __cpu_suspend mm switch on warm-boot" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/include/asm/suspend.h |  1 +
 arch/arm64/kernel/sleep.S        | 47 ++++++++++++++++++++++++++++-----------
 arch/arm64/kernel/suspend.c      | 48 ++++++++++++++++++++++++----------------
 3 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index e9c149c042e0..456d67c1f0fa 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -21,6 +21,7 @@ struct sleep_save_sp {
 	phys_addr_t save_ptr_stash_phys;
 };
 
+extern int __cpu_suspend(unsigned long arg, int (*fn)(unsigned long));
 extern void cpu_resume(void);
 extern int cpu_suspend(unsigned long);
 
diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index b1925729c692..a564b440416a 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -49,28 +49,39 @@
 	orr	\dst, \dst, \mask		// dst|=(aff3>>rs3)
 	.endm
 /*
- * Save CPU state for a suspend.  This saves callee registers, and allocates
- * space on the kernel stack to save the CPU specific registers + some
- * other data for resume.
+ * Save CPU state for a suspend and execute the suspend finisher.
+ * On success it will return 0 through cpu_resume - ie through a CPU
+ * soft/hard reboot from the reset vector.
+ * On failure it returns the suspend finisher return value or force
+ * -EOPNOTSUPP if the finisher erroneously returns 0 (the suspend finisher
+ * is not allowed to return, if it does this must be considered failure).
+ * It saves callee registers, and allocates space on the kernel stack
+ * to save the CPU specific registers + some other data for resume.
  *
  *  x0 = suspend finisher argument
+ *  x1 = suspend finisher function pointer
  */
-ENTRY(__cpu_suspend)
+ENTRY(__cpu_suspend_enter)
 	stp	x29, lr, [sp, #-96]!
 	stp	x19, x20, [sp,#16]
 	stp	x21, x22, [sp,#32]
 	stp	x23, x24, [sp,#48]
 	stp	x25, x26, [sp,#64]
 	stp	x27, x28, [sp,#80]
+	/*
+	 * Stash suspend finisher and its argument in x20 and x19
+	 */
+	mov	x19, x0
+	mov	x20, x1
 	mov	x2, sp
 	sub	sp, sp, #CPU_SUSPEND_SZ	// allocate cpu_suspend_ctx
-	mov	x1, sp
+	mov	x0, sp
 	/*
-	 * x1 now points to struct cpu_suspend_ctx allocated on the stack
+	 * x0 now points to struct cpu_suspend_ctx allocated on the stack
 	 */
-	str	x2, [x1, #CPU_CTX_SP]
-	ldr	x2, =sleep_save_sp
-	ldr	x2, [x2, #SLEEP_SAVE_SP_VIRT]
+	str	x2, [x0, #CPU_CTX_SP]
+	ldr	x1, =sleep_save_sp
+	ldr	x1, [x1, #SLEEP_SAVE_SP_VIRT]
 #ifdef CONFIG_SMP
 	mrs	x7, mpidr_el1
 	ldr	x9, =mpidr_hash
@@ -82,11 +93,21 @@ ENTRY(__cpu_suspend)
 	ldp	w3, w4, [x9, #MPIDR_HASH_SHIFTS]
 	ldp	w5, w6, [x9, #(MPIDR_HASH_SHIFTS + 8)]
 	compute_mpidr_hash x8, x3, x4, x5, x6, x7, x10
-	add	x2, x2, x8, lsl #3
+	add	x1, x1, x8, lsl #3
 #endif
-	bl	__cpu_suspend_finisher
+	bl	__cpu_suspend_save
+	/*
+	 * Grab suspend finisher in x20 and its argument in x19
+	 */
+	mov	x0, x19
+	mov	x1, x20
+	/*
+	 * We are ready for power down, fire off the suspend finisher
+	 * in x1, with argument in x0
+	 */
+	blr	x1
         /*
-	 * Never gets here, unless suspend fails.
+	 * Never gets here, unless suspend finisher fails.
 	 * Successful cpu_suspend should return from cpu_resume, returning
 	 * through this code path is considered an error
 	 * If the return value is set to 0 force x0 = -EOPNOTSUPP
@@ -103,7 +124,7 @@ ENTRY(__cpu_suspend)
 	ldp	x27, x28, [sp, #80]
 	ldp	x29, lr, [sp], #96
 	ret
-ENDPROC(__cpu_suspend)
+ENDPROC(__cpu_suspend_enter)
 	.ltorg
 
 /*
diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 55a99b9a97e0..13ad4dbb1615 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -9,22 +9,19 @@
 #include <asm/suspend.h>
 #include <asm/tlbflush.h>
 
-extern int __cpu_suspend(unsigned long);
+extern int __cpu_suspend_enter(unsigned long arg, int (*fn)(unsigned long));
 /*
- * This is called by __cpu_suspend() to save the state, and do whatever
+ * This is called by __cpu_suspend_enter() to save the state, and do whatever
  * flushing is required to ensure that when the CPU goes to sleep we have
  * the necessary data available when the caches are not searched.
  *
- * @arg: Argument to pass to suspend operations
- * @ptr: CPU context virtual address
- * @save_ptr: address of the location where the context physical address
- *            must be saved
+ * ptr: CPU context virtual address
+ * save_ptr: address of the location where the context physical address
+ *           must be saved
  */
-int __cpu_suspend_finisher(unsigned long arg, struct cpu_suspend_ctx *ptr,
-			   phys_addr_t *save_ptr)
+void notrace __cpu_suspend_save(struct cpu_suspend_ctx *ptr,
+				phys_addr_t *save_ptr)
 {
-	int cpu = smp_processor_id();
-
 	*save_ptr = virt_to_phys(ptr);
 
 	cpu_do_suspend(ptr);
@@ -35,8 +32,6 @@ int __cpu_suspend_finisher(unsigned long arg, struct cpu_suspend_ctx *ptr,
 	 */
 	__flush_dcache_area(ptr, sizeof(*ptr));
 	__flush_dcache_area(save_ptr, sizeof(*save_ptr));
-
-	return cpu_ops[cpu]->cpu_suspend(arg);
 }
 
 /*
@@ -56,15 +51,15 @@ void __init cpu_suspend_set_dbg_restorer(void (*hw_bp_restore)(void *))
 }
 
 /**
- * cpu_suspend
+ * cpu_suspend() - function to enter a low-power state
+ * @arg: argument to pass to CPU suspend operations
  *
- * @arg: argument to pass to the finisher function
+ * Return: 0 on success, -EOPNOTSUPP if CPU suspend hook not initialized, CPU
+ * operations back-end error code otherwise.
  */
 int cpu_suspend(unsigned long arg)
 {
-	struct mm_struct *mm = current->active_mm;
-	int ret, cpu = smp_processor_id();
-	unsigned long flags;
+	int cpu = smp_processor_id();
 
 	/*
 	 * If cpu_ops have not been registered or suspend
@@ -72,6 +67,21 @@ int cpu_suspend(unsigned long arg)
 	 */
 	if (!cpu_ops[cpu] || !cpu_ops[cpu]->cpu_suspend)
 		return -EOPNOTSUPP;
+	return cpu_ops[cpu]->cpu_suspend(arg);
+}
+
+/*
+ * __cpu_suspend
+ *
+ * arg: argument to pass to the finisher function
+ * fn: finisher function pointer
+ *
+ */
+int __cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
+{
+	struct mm_struct *mm = current->active_mm;
+	int ret;
+	unsigned long flags;
 
 	/*
 	 * From this point debug exceptions are disabled to prevent
@@ -86,7 +96,7 @@ int cpu_suspend(unsigned long arg)
 	 * page tables, so that the thread address space is properly
 	 * set-up on function return.
 	 */
-	ret = __cpu_suspend(arg);
+	ret = __cpu_suspend_enter(arg, fn);
 	if (ret == 0) {
 		cpu_switch_mm(mm->pgd, mm);
 		flush_tlb_all();
@@ -95,7 +105,7 @@ int cpu_suspend(unsigned long arg)
 		 * Restore per-cpu offset before any kernel
 		 * subsystem relying on it has a chance to run.
 		 */
-		set_my_cpu_offset(per_cpu_offset(cpu));
+		set_my_cpu_offset(per_cpu_offset(smp_processor_id()));
 
 		/*
 		 * Restore HW breakpoint registers to sane values
-- 
2.1.4

