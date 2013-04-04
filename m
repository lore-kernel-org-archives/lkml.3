Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763024Ab3DDAEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:04:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4834 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762220Ab3DDADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:03:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="35720033"
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: Richard Kuo <rkuo@codeaurora.org>
Subject: [PATCH 1/6] Hexagon: Signal and return path fixes
Date: Wed,  3 Apr 2013 19:02:51 -0500
Message-Id: <1365033776-21804-2-git-send-email-rkuo@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
References: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the return value of sigreturn and moves the work pending check
into a c routine for readability and fixes the loop for multiple pending
signals.  Based on feedback from Al Viro.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/include/uapi/asm/signal.h |    2 +
 arch/hexagon/kernel/process.c          |   41 +++++++++++++++
 arch/hexagon/kernel/signal.c           |   29 ++---------
 arch/hexagon/kernel/traps.c            |   13 +----
 arch/hexagon/kernel/vm_entry.S         |   87 +++++++++++++-------------------
 5 files changed, 84 insertions(+), 88 deletions(-)

diff --git a/arch/hexagon/include/uapi/asm/signal.h b/arch/hexagon/include/uapi/asm/signal.h
index 9395568..24b9988 100644
--- a/arch/hexagon/include/uapi/asm/signal.h
+++ b/arch/hexagon/include/uapi/asm/signal.h
@@ -21,6 +21,8 @@
 
 extern unsigned long __rt_sigtramp_template[2];
 
+void do_signal(struct pt_regs *regs);
+
 #include <asm-generic/signal.h>
 
 #endif
diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
index 06ae9ff..dc72ed5 100644
--- a/arch/hexagon/kernel/process.c
+++ b/arch/hexagon/kernel/process.c
@@ -24,6 +24,7 @@
 #include <linux/tick.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
+#include <linux/tracehook.h>
 
 /*
  * Program thread launch.  Often defined as a macro in processor.h,
@@ -202,3 +203,43 @@ int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpu)
 {
 	return 0;
 }
+
+
+/*
+ * Called on the exit path of event entry; see vm_entry.S
+ *
+ * Interrupts will already be disabled.
+ *
+ * Returns 0 if there's no need to re-check for more work.
+ */
+
+int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
+{
+	if (!(thread_info_flags & _TIF_ALLWORK_MASK)) {
+		return 0;
+	}  /* shortcut -- no work to be done */
+
+	local_irq_enable();
+
+	if (thread_info_flags & _TIF_NEED_RESCHED) {
+		schedule();
+		return 1;
+	}
+
+	if (thread_info_flags & _TIF_SIGPENDING) {
+		do_signal(regs);
+		return 1;
+	}
+
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+		if (current->replacement_session_keyring)
+			key_replace_session_keyring();
+		return 1;
+	}
+
+	/* Should not even reach here */
+	panic("%s: bad thread_info flags 0x%08x\n", __func__,
+		thread_info_flags);
+}
diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index a1492a6..8a20e8e 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -199,7 +199,7 @@ static void handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
 /*
  * Called from return-from-event code.
  */
-static void do_signal(struct pt_regs *regs)
+void do_signal(struct pt_regs *regs)
 {
 	struct k_sigaction sigact;
 	siginfo_t info;
@@ -216,8 +216,9 @@ static void do_signal(struct pt_regs *regs)
 	}
 
 	/*
-	 * If we came from a system call, handle the restart.
+	 * No (more) signals; if we came from a system call, handle the restart.
 	 */
+
 	if (regs->syscall_nr >= 0) {
 		switch (regs->r00) {
 		case -ERESTARTNOHAND:
@@ -240,17 +241,6 @@ no_restart:
 	restore_saved_sigmask();
 }
 
-void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
-{
-	if (thread_info_flags & _TIF_SIGPENDING)
-		do_signal(regs);
-
-	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
-		clear_thread_flag(TIF_NOTIFY_RESUME);
-		tracehook_notify_resume(regs);
-	}
-}
-
 /*
  * Architecture-specific wrappers for signal-related system calls
  */
@@ -278,21 +268,12 @@ asmlinkage int sys_rt_sigreturn(void)
 	/* Restore the user's stack as well */
 	pt_psp(regs) = regs->r29;
 
-	/*
-	 * Leave a trace in the stack frame that this was a sigreturn.
-	 * If the system call is to replay, we've already restored the
-	 * number in the GPR slot and it will be regenerated on the
-	 * new system call trap entry. Note that if restore_sigcontext()
-	 * did something other than a bulk copy of the pt_regs struct,
-	 * we could avoid this assignment by simply not overwriting
-	 * regs->syscall_nr.
-	 */
-	regs->syscall_nr = __NR_rt_sigreturn;
+	regs->syscall_nr = -1;
 
 	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
-	return 0;
+	return regs->r00;
 
 badframe:
 	force_sig(SIGSEGV, current);
diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index be5e2dd..d59ee62 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -356,7 +356,6 @@ long sys_syscall(void)
 
 void do_trap0(struct pt_regs *regs)
 {
-	unsigned long syscallret = 0;
 	syscall_fn syscall;
 
 	switch (pt_cause(regs)) {
@@ -396,21 +395,11 @@ void do_trap0(struct pt_regs *regs)
 		} else {
 			syscall = (syscall_fn)
 				  (sys_call_table[regs->syscall_nr]);
-			syscallret = syscall(regs->r00, regs->r01,
+			regs->r00 = syscall(regs->r00, regs->r01,
 				   regs->r02, regs->r03,
 				   regs->r04, regs->r05);
 		}
 
-		/*
-		 * If it was a sigreturn system call, don't overwrite
-		 * r0 value in stack frame with return value.
-		 *
-		 * __NR_sigreturn doesn't seem to exist in new unistd.h
-		 */
-
-		if (regs->syscall_nr != __NR_rt_sigreturn)
-			regs->r00 = syscallret;
-
 		/* allow strace to get the syscall return state  */
 		if (unlikely(test_thread_flag(TIF_SYSCALL_TRACE)))
 			tracehook_report_syscall_exit(regs, 0);
diff --git a/arch/hexagon/kernel/vm_entry.S b/arch/hexagon/kernel/vm_entry.S
index ffe4a42..053551e 100644
--- a/arch/hexagon/kernel/vm_entry.S
+++ b/arch/hexagon/kernel/vm_entry.S
@@ -274,6 +274,9 @@ event_dispatch:
 	callr	r1
 
 	/*
+	 * Coming back from the C-world, our thread info pointer
+	 * should be in the designated register (usually R19)
+	 *
 	 * If we were in kernel mode, we don't need to check scheduler
 	 * or signals if CONFIG_PREEMPT is not set.  If set, then it has
 	 * to jump to a need_resched kind of block.
@@ -286,67 +289,43 @@ event_dispatch:
 #endif
 
 	/*  "Nested control path" -- if the previous mode was kernel  */
-	R0 = memw(R29 + #_PT_ER_VMEST);
 	{
-		P0 = tstbit(R0, #HVM_VMEST_UM_SFT);
-		if (!P0.new) jump:nt restore_all;
+		R0 = memw(R29 + #_PT_ER_VMEST);
+		R16.L = #LO(do_work_pending);
 	}
-	/*
-	 * Returning from system call, normally coming back from user mode
-	 */
-return_from_syscall:
-	/*  Disable interrupts while checking TIF  */
-	R0 = #VM_INT_DISABLE
-	trap1(#HVM_TRAP1_VMSETIE)
-
-	/*
-	 * Coming back from the C-world, our thread info pointer
-	 * should be in the designated register (usually R19)
-	 */
-#if CONFIG_HEXAGON_ARCH_VERSION < 4
-	R1.L = #LO(_TIF_ALLWORK_MASK)
 	{
-		R1.H = #HI(_TIF_ALLWORK_MASK);
-		R0 = memw(THREADINFO_REG + #_THREAD_INFO_FLAGS);
-	}
-#else
-	{
-		R1 = ##_TIF_ALLWORK_MASK;
-		R0 = memw(THREADINFO_REG + #_THREAD_INFO_FLAGS);
+		P0 = tstbit(R0, #HVM_VMEST_UM_SFT);
+		if (!P0.new) jump:nt restore_all;
+		R16.H = #HI(do_work_pending);
+		R0 = #VM_INT_DISABLE;
 	}
-#endif
 
 	/*
-	 * Compare against the "return to userspace" _TIF_WORK_MASK
+	 * Check also the return from fork/system call, normally coming back from
+	 * user mode
+	 *
+	 * R16 needs to have do_work_pending, and R0 should have VM_INT_DISABLE
 	 */
-	R1 = and(R1,R0);
-	{ P0 = cmp.eq(R1,#0); if (!P0.new) jump:t work_pending;}
-	jump restore_all;  /*  we're outta here!  */
 
-work_pending:
+check_work_pending:
+	/*  Disable interrupts while checking TIF  */
+	trap1(#HVM_TRAP1_VMSETIE)
 	{
-		P0 = tstbit(R1, #TIF_NEED_RESCHED);
-		if (!P0.new) jump:nt work_notifysig;
+		R0 = R29;  /*  regs should still be at top of stack  */
+		R1 = memw(THREADINFO_REG + #_THREAD_INFO_FLAGS);
+		callr R16;
 	}
-	call schedule
-	jump return_from_syscall;  /*  check for more work  */
 
-work_notifysig:
-	/*  this is the part that's kind of fuzzy.  */
-	R1 = and(R0, #(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME));
-	{
-		P0 = cmp.eq(R1, #0);
-		if P0.new jump:t restore_all;
-	}
 	{
-		R1 = R0; 	/* unsigned long thread_info_flags */
-		R0 = R29;	/* regs should still be at top of stack  */
+		P0 = cmp.eq(R0, #0); if (!P0.new) jump:nt check_work_pending;
+		R0 = #VM_INT_DISABLE;
 	}
-	call do_notify_resume
 
 restore_all:
-	/* Disable interrupts, if they weren't already, before reg restore.  */
-	R0 = #VM_INT_DISABLE
+	/*
+	 * Disable interrupts, if they weren't already, before reg restore.
+	 * R0 gets preloaded with #VM_INT_DISABLE before we get here.
+	 */
 	trap1(#HVM_TRAP1_VMSETIE)
 
 	/*  do the setregs here for VM 0.5  */
@@ -371,6 +350,7 @@ restore_all:
 	trap1(#HVM_TRAP1_VMRTE)
 	/* Notreached */
 
+
 	.globl _K_enter_genex
 _K_enter_genex:
 	vm_event_entry(do_genex)
@@ -390,9 +370,12 @@ _K_enter_machcheck:
 
 	.globl ret_from_fork
 ret_from_fork:
-	call schedule_tail
-	P0 = cmp.eq(R24, #0);
-	if P0 jump return_from_syscall
-	R0 = R25;
-	callr R24
-	jump return_from_syscall
+	{
+		call schedule_tail;
+		R16.H = #HI(do_work_pending);
+	}
+	{
+		R16.L = #LO(do_work_pending);
+		R0 = #VM_INT_DISABLE;
+		jump check_work_pending;
+	}
-- 
1.7.9.5

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
