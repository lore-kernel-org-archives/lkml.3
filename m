Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab3GMDT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 23:19:29 -0400
Received: from mx1.corp.phx1.mozilla.com ([63.245.216.69]:55363 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969Ab3GMDT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 23:19:28 -0400
From: Jed Davis <jld@mozilla.com>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <rric@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oprofile-list@lists.sf.net
Cc: Jed Davis <jld@mozilla.com>
Subject: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
Date: Fri, 12 Jul 2013 20:18:20 -0700
Message-Id: <1373685501-1620-1-git-send-email-jld@mozilla.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently some inconsistency about the "frame pointer" on ARM.
r11 is the register with assemblers recognize and disassemblers often
print as "fp", and which is sufficient for stack unwinding when using
the APCS frame pointer option; but when unwinding with the Exception
Handling ABI, the register GCC uses when a constant offset won't suffice
(or when -fno-omit-frame-pointer is used; see kernel/sched/Makefile in
particular) is r11 on ARM and r7 on Thumb.

Correspondingly, arch/arm/include/uapi/arm/ptrace.h defines ARM_fp to
refer to r11, but arch/arm/kernel/unwind.c uses "FP" to mean either r11
or r7 depending on Thumbness, and it is unclear what other cases such as
the "fp" in struct stackframe should be doing.

Effects of this are probably limited to failure of EHABI unwinding when
starting from a function that uses r7 to restore its stack pointer, but
the possibility for further breakage (which would be invisible on
non-Thumb kernels) is worrying.

With this change, it is hoped, r7 is consistently referred to as "r7",
and "fp" always means r11; this costs a few extra ifdefs, but it should
help prevent future issues.

Signed-off-by: Jed Davis <jld@mozilla.com>
---
 arch/arm/include/asm/stacktrace.h  |    4 ++++
 arch/arm/include/asm/thread_info.h |    2 ++
 arch/arm/kernel/perf_event.c       |    4 ++++
 arch/arm/kernel/process.c          |    4 ++++
 arch/arm/kernel/time.c             |    4 ++++
 arch/arm/kernel/unwind.c           |   27 ++++++++++++++++++++++++++-
 arch/arm/oprofile/common.c         |    4 ++++
 7 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/stacktrace.h b/arch/arm/include/asm/stacktrace.h
index 4d0a164..5e546bf 100644
--- a/arch/arm/include/asm/stacktrace.h
+++ b/arch/arm/include/asm/stacktrace.h
@@ -2,7 +2,11 @@
 #define __ASM_STACKTRACE_H
 
 struct stackframe {
+#ifdef CONFIG_THUMB2_KERNEL
+	unsigned long r7;
+#else
 	unsigned long fp;
+#endif
 	unsigned long sp;
 	unsigned long lr;
 	unsigned long pc;
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 214d415..ae3cd81 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -105,6 +105,8 @@ static inline struct thread_info *current_thread_info(void)
 	((unsigned long)(task_thread_info(tsk)->cpu_context.sp))
 #define thread_saved_fp(tsk)	\
 	((unsigned long)(task_thread_info(tsk)->cpu_context.fp))
+#define thread_saved_r7(tsk)	\
+	((unsigned long)(task_thread_info(tsk)->cpu_context.r7))
 
 extern void crunch_task_disable(struct thread_info *);
 extern void crunch_task_copy(struct thread_info *, void *);
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index d9f5cd4..55776d6 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -601,7 +601,11 @@ perf_callchain_kernel(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		return;
 	}
 
+#ifdef CONFIG_THUMB2_KERNEL
+	fr.r7 = regs->ARM_r7;
+#else
 	fr.fp = regs->ARM_fp;
+#endif
 	fr.sp = regs->ARM_sp;
 	fr.lr = regs->ARM_lr;
 	fr.pc = regs->ARM_pc;
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index d3ca4f6..aeb4c28 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -405,7 +405,11 @@ unsigned long get_wchan(struct task_struct *p)
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
 
+#ifdef CONFIG_THUMB2_KERNEL
+	frame.r7 = thread_saved_r7(p);
+#else
 	frame.fp = thread_saved_fp(p);
+#endif
 	frame.sp = thread_saved_sp(p);
 	frame.lr = 0;			/* recovered from the stack */
 	frame.pc = thread_saved_pc(p);
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 98aee32..80410d3 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -49,7 +49,11 @@ unsigned long profile_pc(struct pt_regs *regs)
 	if (!in_lock_functions(regs->ARM_pc))
 		return regs->ARM_pc;
 
+#ifdef CONFIG_THUMB2_KERNEL
+	frame.r7 = regs->ARM_r7;
+#else
 	frame.fp = regs->ARM_fp;
+#endif
 	frame.sp = regs->ARM_sp;
 	frame.lr = regs->ARM_lr;
 	frame.pc = regs->ARM_pc;
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..dec03ae 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -74,7 +74,7 @@ struct unwind_ctrl_block {
 
 enum regs {
 #ifdef CONFIG_THUMB2_KERNEL
-	FP = 7,
+	R7 = 7,
 #else
 	FP = 11,
 #endif
@@ -317,8 +317,13 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		return -URC_FAILURE;
 	}
 
+#ifdef CONFIG_THUMB2_KERNEL
+	pr_debug("%s: r7 = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
+		 ctrl->vrs[R7], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+#else
 	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
 		 ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+#endif
 
 	return URC_OK;
 }
@@ -349,7 +354,11 @@ int unwind_frame(struct stackframe *frame)
 		return -URC_FAILURE;
 	}
 
+#ifdef CONFIG_THUMB2_KERNEL
+	ctrl.vrs[R7] = frame->r7;
+#else
 	ctrl.vrs[FP] = frame->fp;
+#endif
 	ctrl.vrs[SP] = frame->sp;
 	ctrl.vrs[LR] = frame->lr;
 	ctrl.vrs[PC] = 0;
@@ -397,7 +406,11 @@ int unwind_frame(struct stackframe *frame)
 	if (frame->pc == ctrl.vrs[PC])
 		return -URC_FAILURE;
 
+#ifdef CONFIG_THUMB2_KERNEL
+	frame->r7 = ctrl.vrs[R7];
+#else
 	frame->fp = ctrl.vrs[FP];
+#endif
 	frame->sp = ctrl.vrs[SP];
 	frame->lr = ctrl.vrs[LR];
 	frame->pc = ctrl.vrs[PC];
@@ -416,20 +429,32 @@ void unwind_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 		tsk = current;
 
 	if (regs) {
+#ifdef CONFIG_THUMB2_KERNEL
+		frame.r7 = regs->ARM_r7;
+#else
 		frame.fp = regs->ARM_fp;
+#endif
 		frame.sp = regs->ARM_sp;
 		frame.lr = regs->ARM_lr;
 		/* PC might be corrupted, use LR in that case. */
 		frame.pc = kernel_text_address(regs->ARM_pc)
 			 ? regs->ARM_pc : regs->ARM_lr;
 	} else if (tsk == current) {
+#ifdef CONFIG_THUMB2_KERNEL
+		frame.r7 = (unsigned long)__builtin_frame_address(0);
+#else
 		frame.fp = (unsigned long)__builtin_frame_address(0);
+#endif
 		frame.sp = current_sp;
 		frame.lr = (unsigned long)__builtin_return_address(0);
 		frame.pc = (unsigned long)unwind_backtrace;
 	} else {
 		/* task blocked in __switch_to */
+#ifdef CONFIG_THUMB2_KERNEL
+		frame.r7 = thread_saved_r7(tsk);
+#else
 		frame.fp = thread_saved_fp(tsk);
+#endif
 		frame.sp = thread_saved_sp(tsk);
 		/*
 		 * The function calling __switch_to cannot be a leaf function
diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 99c63d4b..38cbfff 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -107,7 +107,11 @@ static void arm_backtrace(struct pt_regs * const regs, unsigned int depth)
 
 	if (!user_mode(regs)) {
 		struct stackframe frame;
+#ifdef CONFIG_THUMB2_KERNEL
+		frame.r7 = regs->ARM_r7;
+#else
 		frame.fp = regs->ARM_fp;
+#endif
 		frame.sp = regs->ARM_sp;
 		frame.lr = regs->ARM_lr;
 		frame.pc = regs->ARM_pc;
-- 
1.7.10.4

