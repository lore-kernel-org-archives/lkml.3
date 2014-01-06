Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaAFIWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:22:37 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:43581 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaAFIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:22:35 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, hpa@zytor.com, ak@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, mingo@redhat.com, nico@linaro.org,
        x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 6/8] arm64: defer reloading a task's FPSIMD state to userland resume
Date: Mon,  6 Jan 2014 09:22:14 +0100
Message-Id: <1388996536-27014-7-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1388996536-27014-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a task gets scheduled out and back in again and nothing has touched
its FPSIMD state in the mean time, there is really no reason to reload
it from memory. Similarly, repeated calls to kernel_neon_begin() and
kernel_neon_end() will preserve and restore the FPSIMD state every time.

This patch defers the FPSIMD state restore to the last possible moment,
i.e., right before the task re-enters userland. If a task does not enter
userland at all (for any reason), the existing FPSIMD state is preserved
and may be reused by the owning task if it gets scheduled in again on the
same CPU.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/fpsimd.h      |  3 ++
 arch/arm64/include/asm/thread_info.h |  4 +-
 arch/arm64/kernel/entry.S            |  2 +-
 arch/arm64/kernel/fpsimd.c           | 79 +++++++++++++++++++++++++++++++-----
 arch/arm64/kernel/process.c          |  3 +-
 arch/arm64/kernel/signal.c           |  3 ++
 6 files changed, 81 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index c43b4ac13008..609bc44ceb8d 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -37,6 +37,8 @@ struct fpsimd_state {
 			u32 fpcr;
 		};
 	};
+	/* the id of the last cpu to have restored this state */
+	unsigned int last_cpu;
 };
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
@@ -57,6 +59,7 @@ extern void fpsimd_load_state(struct fpsimd_state *state);
 
 extern void fpsimd_thread_switch(struct task_struct *next);
 extern void fpsimd_flush_thread(void);
+extern void fpsimd_reload_fpstate(void);
 
 #endif
 
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 720e70b66ffd..4a1ca1cfb2f8 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -100,6 +100,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
+#define TIF_FOREIGN_FPSTATE	3	/* CPU's FP state is not current's */
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	16
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -112,10 +113,11 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
+#define _TIF_FOREIGN_FPSTATE	(1 << TIF_FOREIGN_FPSTATE)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
-				 _TIF_NOTIFY_RESUME)
+				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_THREAD_INFO_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 7cfbb65f6aa9..24e91097013b 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -578,7 +578,7 @@ fast_work_pending:
 	str	x0, [sp, #S_X0]			// returned x0
 work_pending:
 	tbnz	x1, #TIF_NEED_RESCHED, work_resched
-	/* TIF_SIGPENDING or TIF_NOTIFY_RESUME case */
+	/* TIF_SIGPENDING, TIF_NOTIFY_RESUME or TIF_FOREIGN_FPSTATE case */
 	ldr	x2, [sp, #S_PSTATE]
 	mov	x0, sp				// 'regs'
 	tst	x2, #PSR_MODE_MASK		// user mode regs?
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index bb785d23dbde..5b13c17e799f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -34,6 +34,23 @@
 #define FPEXC_IDF	(1 << 7)
 
 /*
+ * In order to reduce the number of times the fpsimd state is frivolously saved
+ * and restored, keep track here of which task's userland owns the current state
+ * of the FPSIMD register file.
+ *
+ * This percpu variable points to the fpsimd_state.last_cpu field of the task
+ * whose FPSIMD state was most recently loaded onto this cpu. The last_cpu field
+ * itself contains the id of the cpu onto which the task's FPSIMD state was
+ * loaded most recently. So, to decide whether we can skip reloading the FPSIMD
+ * state, we need to check
+ * (a) whether this task was the last one to have its FPSIMD state loaded onto
+ *     this cpu
+ * (b) whether this task may have manipulated its FPSIMD state on another cpu in
+ *     the meantime
+ */
+static DEFINE_PER_CPU(unsigned int *, fpsimd_last_cpu);
+
+/*
  * Trapped FP/ASIMD access.
  */
 void do_fpsimd_acc(unsigned int esr, struct pt_regs *regs)
@@ -71,18 +88,56 @@ void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
 
 void fpsimd_thread_switch(struct task_struct *next)
 {
-	/* check if not kernel threads */
-	if (current->mm)
+	/*
+	 * The thread flag TIF_FOREIGN_FPSTATE conveys that the userland FPSIMD
+	 * state belonging to the current task is not present in the registers
+	 * but has (already) been saved to memory in order for the kernel to be
+	 * able to go off and use the registers for something else. Therefore,
+	 * we must not (re)save the register contents if this flag is set.
+	 */
+	if (current->mm && !test_thread_flag(TIF_FOREIGN_FPSTATE))
 		fpsimd_save_state(&current->thread.fpsimd_state);
-	if (next->mm)
-		fpsimd_load_state(&next->thread.fpsimd_state);
+
+	if (next->mm) {
+		/*
+		 * If we are switching to a task whose most recent userland NEON
+		 * contents are already in the registers of *this* cpu, we can
+		 * skip loading the state from memory. Otherwise, set the
+		 * TIF_FOREIGN_FPSTATE flag so the state will be loaded upon the
+		 * next entry of userland.
+		 */
+		struct fpsimd_state *st = &next->thread.fpsimd_state;
+
+		if (__get_cpu_var(fpsimd_last_cpu) == &st->last_cpu
+		    && st->last_cpu == smp_processor_id())
+			clear_ti_thread_flag(task_thread_info(next),
+					     TIF_FOREIGN_FPSTATE);
+		else
+			set_ti_thread_flag(task_thread_info(next),
+					   TIF_FOREIGN_FPSTATE);
+	}
 }
 
 void fpsimd_flush_thread(void)
 {
-	preempt_disable();
 	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
-	fpsimd_load_state(&current->thread.fpsimd_state);
+	set_thread_flag(TIF_FOREIGN_FPSTATE);
+}
+
+void fpsimd_reload_fpstate(void)
+{
+	preempt_disable();
+	if (test_and_clear_thread_flag(TIF_FOREIGN_FPSTATE)) {
+		/*
+		 * We are entering userland and the userland context is not yet
+		 * present in the registers.
+		 */
+		struct fpsimd_state *st = &current->thread.fpsimd_state;
+
+		fpsimd_load_state(st);
+		__get_cpu_var(fpsimd_last_cpu) = &st->last_cpu;
+		st->last_cpu = smp_processor_id();
+	}
 	preempt_enable();
 }
 
@@ -97,16 +152,20 @@ void kernel_neon_begin(void)
 	BUG_ON(in_interrupt());
 	preempt_disable();
 
-	if (current->mm)
+	/*
+	 * Save the userland FPSIMD state if we have one and if we haven't done
+	 * so already. Clear fpsimd_last_cpu to indicate that there is no
+	 * longer userland context in the registers.
+	 */
+	if (current->mm && !test_and_set_thread_flag(TIF_FOREIGN_FPSTATE))
 		fpsimd_save_state(&current->thread.fpsimd_state);
+	__get_cpu_var(fpsimd_last_cpu) = NULL;
+
 }
 EXPORT_SYMBOL(kernel_neon_begin);
 
 void kernel_neon_end(void)
 {
-	if (current->mm)
-		fpsimd_load_state(&current->thread.fpsimd_state);
-
 	preempt_enable();
 }
 EXPORT_SYMBOL(kernel_neon_end);
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 0adb8f0f4549..c45ee7038f5e 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -202,7 +202,8 @@ void release_thread(struct task_struct *dead_task)
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
-	fpsimd_save_state(&current->thread.fpsimd_state);
+	if (!test_thread_flag(TIF_FOREIGN_FPSTATE))
+		fpsimd_save_state(&current->thread.fpsimd_state);
 	*dst = *src;
 	return 0;
 }
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 890a591f75dd..0a9eccf4fc0f 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -416,4 +416,7 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 	}
+
+	if (thread_flags & _TIF_FOREIGN_FPSTATE)
+		fpsimd_reload_fpstate();
 }
-- 
1.8.3.2

