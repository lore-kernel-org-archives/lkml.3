Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3ARMau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:30:50 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:58770 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab3ARMaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:30:46 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v2 36/76] ARC: Switch to generic kernel_thread() - split ret_from_fork
Date: Fri, 18 Jan 2013 17:54:50 +0530
Message-ID: <1358511930-7424-37-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally the jump to kernel_thread "payload" or entry-point happened
via a return from exception (RTIE) using stuff from specially carved
pt_regs (pt_regs->status32 enabled Kernel mode, pt_regs->ret pointed to
a kernel thread helper to jump to entry point)

Now copy_thread() sets up __switch_to() to ret to a small asm trampoline
ret_from_kernel_thread() which simply jumps to thread entry point.

It also setsup thread entry point in callee regs (vs. pt_regs) which are
anyways unwound by __switch_to, keeping things ready-to-go for
ret_from_kernel_thread.

This eliminates any involvement of pt_regs altogether.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 arch/arc/Kconfig                 |    1 +
 arch/arc/include/asm/processor.h |    6 ----
 arch/arc/kernel/entry.S          |    7 ++++
 arch/arc/kernel/process.c        |   62 +++++++++++++------------------------
 4 files changed, 30 insertions(+), 46 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 548b89e..5588cee 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -17,6 +17,7 @@ config ARC
 	select GENERIC_FIND_FIRST_BIT
 	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_SHOW
+	select GENERIC_KERNEL_THREAD
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index 053a639..860252e 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -57,12 +57,6 @@ unsigned long thread_saved_pc(struct task_struct *t);
 
 #define cpu_relax()	do { } while (0)
 
-/*
- * Create a new kernel thread
- */
-
-extern int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags);
-
 #define copy_segments(tsk, mm)      do { } while (0)
 #define release_segments(mm)        do { } while (0)
 
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 0324ad1..e76b432 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -579,6 +579,13 @@ ARC_ENTRY ret_from_fork
 	b @ret_from_exception
 ARC_EXIT ret_from_fork
 
+ARC_ENTRY ret_from_kernel_thread
+	bl  @schedule_tail
+	jl.d [r14]		; kernel_thread "payload"
+	mov  r0, r13		; arg to payload
+	j   @sys_exit
+ARC_EXIT ret_from_kernel_thread
+
 ;################### Special Sys Call Wrappers ##########################
 
 ARC_ENTRY sys_execve_wrapper
diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
index 5c18ba8..a468205 100644
--- a/arch/arc/kernel/process.c
+++ b/arch/arc/kernel/process.c
@@ -142,34 +142,8 @@ void cpu_idle(void)
 	}
 }
 
-void kernel_thread_helper(void)
-{
-	__asm__ __volatile__(
-		"mov   r0, r2	\n\t"
-		"mov   r1, r3	\n\t"
-		"j     [r1]	\n\t");
-}
-
-int kernel_thread(int (*fn) (void *), void *arg, unsigned long flags)
-{
-	struct pt_regs regs;
-
-	memset(&regs, 0, sizeof(regs));
-
-	regs.r2 = (unsigned long)arg;
-	regs.r3 = (unsigned long)fn;
-	regs.blink = (unsigned long)do_exit;
-	regs.ret = (unsigned long)kernel_thread_helper;
-	regs.status32 = read_aux_reg(0xa);
-
-	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL,
-		       NULL);
-
-}
-EXPORT_SYMBOL(kernel_thread);
-
 asmlinkage void ret_from_fork(void);
+asmlinkage void ret_from_kernel_thread(void) __attribute__((noreturn));
 
 /* Layout of Child kernel mode stack as setup at the end of this function is
  *
@@ -202,7 +176,7 @@ asmlinkage void ret_from_fork(void);
  * ------------------  <===== END of PAGE
  */
 int copy_thread(unsigned long clone_flags,
-		unsigned long usp, unsigned long topstk,
+		unsigned long usp, unsigned long arg,
 		struct task_struct *p, struct pt_regs *regs)
 {
 	struct pt_regs *c_regs;        /* child's pt_regs */
@@ -216,28 +190,36 @@ int copy_thread(unsigned long clone_flags,
 	c_callee = ((struct callee_regs *)childksp) - 1;
 
 	/*
-	 * At the end of this function, kernel SP is all set for
-	 * switch_to to start unwinding.
-	 * For kernel threads we don't have callee regs, but the stack
-	 * layout nevertheless needs to remain the same
+	 * __switch_to() uses thread.ksp to start unwinding stack
+	 * For kernel threads we don't need to create callee regs, the
+	 * stack layout nevertheless needs to remain the same.
+	 * Also, since __switch_to anyways unwinds callee regs, we use
+	 * this to populate kernel thread entry-pt/args into callee regs,
+	 * so that ret_from_kernel_thread() becomes simpler.
 	 */
 	p->thread.ksp = (unsigned long)c_callee;	/* THREAD_KSP */
 
-	/* Copy parents pt regs on child's kernel mode stack */
-	*c_regs = *regs;
+	if (unlikely(p->flags & PF_KTHREAD)) {
+		memset(c_regs, 0, sizeof(struct pt_regs));
 
-	/* __switch_to expects FP(0), BLINK(return addr) at top of stack */
-	childksp[0] = 0;				/* for POP fp */
-	childksp[1] = (unsigned long)ret_from_fork;	/* for POP blink */
+		c_callee->r13 = arg; /* argument to kernel thread */
+		c_callee->r14 = usp;  /* function */
 
-	if (!(user_mode(regs))) {
-		c_regs->sp =
-		    (unsigned long)task_thread_info(p) + (THREAD_SIZE - 4);
+		/* __switch_to expects FP(0), BLINK(return addr) at top */
+		childksp[0] = 0;			/* fp */
+		childksp[1] = (unsigned long)ret_from_kernel_thread; /* blink */
 		return 0;
 	}
 
 	/*--------- User Task Only --------------*/
 
+	/* __switch_to expects FP(0), BLINK(return addr) at top of stack */
+	childksp[0] = 0;				/* for POP fp */
+	childksp[1] = (unsigned long)ret_from_fork;	/* for POP blink */
+
+	/* Copy parents pt regs on child's kernel mode stack */
+	*c_regs = *regs;
+
 	c_regs->sp = usp;
 	c_regs->r0 = 0;		/* fork returns 0 in child */
 
-- 
1.7.4.1

