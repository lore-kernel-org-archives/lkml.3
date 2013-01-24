Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3AXKzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:55:02 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:42502 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3AXKyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:38 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v3 20/71] ARC: Signal handling
Date: Thu, 24 Jan 2013 16:20:22 +0530
Message-ID: <1359024639-21915-9-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes following fixes courtesy review by Al-Viro

* Tracer poke to Callee-regs were lost

  Before going off into do_signal( ) we save the user-mode callee regs
  (as they are not saved by default as part of pt_regs). This is to make
  sure that that a Tracer (if tracing related signal) is able to do likes
  of PEEKUSR(callee-reg).

  However in return path we were simply discarding the user-mode callee
  regs, which would break a POKEUSR(callee-reg) from a tracer.

* Issue related to multiple syscall restarts are addressed in next patch

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 arch/arc/Kconfig                  |    1 +
 arch/arc/include/asm/entry.h      |   35 ++++
 arch/arc/include/asm/sigcontext.h |   23 +++
 arch/arc/include/asm/signal.h     |   27 +++
 arch/arc/kernel/entry.S           |   11 +-
 arch/arc/kernel/signal.c          |  359 +++++++++++++++++++++++++++++++++++++
 6 files changed, 453 insertions(+), 3 deletions(-)
 create mode 100644 arch/arc/include/asm/sigcontext.h
 create mode 100644 arch/arc/include/asm/signal.h
 create mode 100644 arch/arc/kernel/signal.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index a4e9806..756beff 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -20,6 +20,7 @@ config ARC
 	select GENERIC_KERNEL_EXECVE
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_PENDING_IRQ if SMP
+	select GENERIC_SIGALTSTACK
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_GENERIC_HARDIRQS
 	select MODULES_USE_ELF_RELA
diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
index 63705b1..6b42bf5 100644
--- a/arch/arc/include/asm/entry.h
+++ b/arch/arc/include/asm/entry.h
@@ -166,6 +166,41 @@
 .endm
 
 /*--------------------------------------------------------------
+ * RESTORE_CALLEE_SAVED_USER:
+ * This is called after do_signal where tracer might have changed callee regs
+ * thus we need to restore the reg file.
+ * Special case handling is required for r25 in case it is used by kernel
+ *  for caching task ptr. Ptrace would have modified on-kernel-stack value of
+ *  r25, which needs to be shoved back into task->thread.user_r25 where from
+ *  Low level exception/ISR return code will retrieve to populate with rest of
+ *  callee reg-file.
+ *-------------------------------------------------------------*/
+.macro RESTORE_CALLEE_SAVED_USER
+
+	add     sp, sp, 4   /* skip "callee_regs->stack_place_holder" */
+
+#ifdef CONFIG_ARC_CURR_IN_REG
+	ld.ab   r12, [sp, 4]
+	st      r12, [r25, TASK_THREAD + THREAD_USER_R25]
+#else
+	ld.ab   r25, [sp, 4]
+#endif
+
+	ld.ab   r24, [sp, 4]
+	ld.ab   r23, [sp, 4]
+	ld.ab   r22, [sp, 4]
+	ld.ab   r21, [sp, 4]
+	ld.ab   r20, [sp, 4]
+	ld.ab   r19, [sp, 4]
+	ld.ab   r18, [sp, 4]
+	ld.ab   r17, [sp, 4]
+	ld.ab   r16, [sp, 4]
+	ld.ab   r15, [sp, 4]
+	ld.ab   r14, [sp, 4]
+	ld.ab   r13, [sp, 4]
+.endm
+
+/*--------------------------------------------------------------
  * Super FAST Restore callee saved regs by simply re-adjusting SP
  *-------------------------------------------------------------*/
 .macro DISCARD_CALLEE_SAVED_USER
diff --git a/arch/arc/include/asm/sigcontext.h b/arch/arc/include/asm/sigcontext.h
new file mode 100644
index 0000000..f21b541
--- /dev/null
+++ b/arch/arc/include/asm/sigcontext.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_SIGCONTEXT_H
+#define _ASM_ARC_SIGCONTEXT_H
+
+#include <asm/ptrace.h>
+
+/*
+ * Signal context structure - contains all info to do with the state
+ * before the signal handler was invoked.  Note: only add new entries
+ * to the end of the structure.
+ */
+struct sigcontext {
+	struct pt_regs regs;
+};
+
+#endif /* _ASM_ARC_SIGCONTEXT_H */
diff --git a/arch/arc/include/asm/signal.h b/arch/arc/include/asm/signal.h
new file mode 100644
index 0000000..fad62f7
--- /dev/null
+++ b/arch/arc/include/asm/signal.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Amit Bhor, Sameer Dhavale: Codito Technologies 2004
+ */
+
+#ifndef _ASM_ARC_SIGNAL_H
+#define _ASM_ARC_SIGNAL_H
+
+/*
+ * This is much needed for ARC sigreturn optimization.
+ * This allows uClibc to piggback the addr of a sigreturn stub in sigaction,
+ * which allows sigreturn based re-entry into kernel after handling signal.
+ * W/o this kernel needs to "synthesize" the sigreturn trampoline on user
+ * mode stack which in turn forces the following:
+ * -TLB Flush (after making the stack page executable)
+ * -Cache line Flush (to make I/D Cache lines coherent)
+ */
+#define SA_RESTORER	0x04000000
+
+#include <asm-generic/signal.h>
+
+#endif /* _ASM_ARC_SIGNAL_H */
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index ed08ac1..d625b77 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -470,7 +470,11 @@ resume_user_mode_begin:
 
 	bbit0  r9, TIF_SIGPENDING, .Lchk_notify_resume
 
-	; save CALLEE Regs.
+	; Normal Trap/IRQ entry only saves Scratch (caller-saved) regs
+	; in pt_reg since the "C" ABI (kernel code) will automatically
+	; save/restore callee-saved regs.
+	;
+	; However, here we need to explicitly save callee regs because
 	; (i)  If this signal causes coredump - full regfile needed
 	; (ii) If signal is SIGTRAP/SIGSTOP, task is being traced thus
 	;      tracer might call PEEKUSR(CALLEE reg)
@@ -484,8 +488,9 @@ resume_user_mode_begin:
 
 	bl  @do_signal
 
-	; unwind SP for cheap discard of Callee saved Regs
-	DISCARD_CALLEE_SAVED_USER
+	; Ideally we want to discard the Callee reg above, however if this was
+	; a tracing signal, tracer could have done a POKEUSR(CALLEE reg)
+	RESTORE_CALLEE_SAVED_USER
 
 	b      resume_user_mode_begin	; loop back to start of U mode ret
 
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
new file mode 100644
index 0000000..887a383
--- /dev/null
+++ b/arch/arc/kernel/signal.c
@@ -0,0 +1,359 @@
+/*
+ * Signal Handling for ARC
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: Jan 2010 (Restarting of timer related syscalls)
+ *
+ * vineetg: Nov 2009 (Everything needed for TIF_RESTORE_SIGMASK)
+ *  -do_signal() supports TIF_RESTORE_SIGMASK
+ *  -do_signal() no loner needs oldset, required by OLD sys_sigsuspend
+ *  -sys_rt_sigsuspend() now comes from generic code, so discard arch implemen
+ *  -sys_sigsuspend() no longer needs to fudge ptregs, hence that arg removed
+ *  -sys_sigsuspend() no longer loops for do_signal(), sets TIF_xxx and leaves
+ *   the job to do_signal()
+ *
+ * vineetg: July 2009
+ *  -Modified Code to support the uClibc provided userland sigreturn stub
+ *   to avoid kernel synthesing it on user stack at runtime, costing TLB
+ *   probes and Cache line flushes.
+ *
+ * vineetg: July 2009
+ *  -In stash_usr_regs( ) and restore_usr_regs( ), save/restore of user regs
+ *   in done in block copy rather than one word at a time.
+ *   This saves around 2K of code and improves LMBench lat_sig <catch>
+ *
+ * rajeshwarr: Feb 2009
+ *  - Support for Realtime Signals
+ *
+ * vineetg: Aug 11th 2008: Bug #94183
+ *  -ViXS were still seeing crashes when using insmod to load drivers.
+ *   It turned out that the code to change Execute permssions for TLB entries
+ *   of user was not guarded for interrupts (mod_tlb_permission)
+ *   This was cauing TLB entries to be overwritten on unrelated indexes
+ *
+ * Vineetg: July 15th 2008: Bug #94183
+ *  -Exception happens in Delay slot of a JMP, and before user space resumes,
+ *   Signal is delivered (Ctrl + C) = >SIGINT.
+ *   setup_frame( ) sets up PC,SP,BLINK to enable user space signal handler
+ *   to run, but doesn't clear the Delay slot bit from status32. As a result,
+ *   on resuming user mode, signal handler branches off to BTA of orig JMP
+ *  -FIX: clear the DE bit from status32 in setup_frame( )
+ *
+ * Rahul Trivedi, Kanika Nema: Codito Technologies 2004
+ */
+
+#include <linux/signal.h>
+#include <linux/ptrace.h>
+#include <linux/personality.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/tracehook.h>
+#include <asm/ucontext.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+struct rt_sigframe {
+	struct siginfo info;
+	struct ucontext uc;
+#define MAGIC_SIGALTSTK		0x07302004
+	unsigned int sigret_magic;
+};
+
+static int
+stash_usr_regs(struct rt_sigframe __user *sf, struct pt_regs *regs,
+	       sigset_t *set)
+{
+	int err;
+	err = __copy_to_user(&(sf->uc.uc_mcontext.regs), regs, sizeof(*regs));
+	err |= __copy_to_user(&sf->uc.uc_sigmask, set, sizeof(sigset_t));
+
+	return err;
+}
+
+static int restore_usr_regs(struct pt_regs *regs, struct rt_sigframe __user *sf)
+{
+	sigset_t set;
+	int err;
+
+	err = __copy_from_user(&set, &sf->uc.uc_sigmask, sizeof(set));
+	if (err == 0) {
+		sigdelsetmask(&set, ~_BLOCKABLE);
+		set_current_blocked(&set);
+	}
+
+	err |= __copy_from_user(regs, &(sf->uc.uc_mcontext.regs),
+				sizeof(*regs));
+
+	return err;
+}
+
+static inline int is_do_ss_needed(unsigned int magic)
+{
+	if (MAGIC_SIGALTSTK == magic)
+		return 1;
+	else
+		return 0;
+}
+
+SYSCALL_DEFINE0(rt_sigreturn)
+{
+	struct rt_sigframe __user *sf;
+	unsigned int magic;
+	int err;
+	struct pt_regs *regs = current_pt_regs();
+
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
+	/* Since we stacked the signal on a word boundary,
+	 * then 'sp' should be word aligned here.  If it's
+	 * not, then the user is trying to mess with us.
+	 */
+	if (regs->sp & 3)
+		goto badframe;
+
+	sf = (struct rt_sigframe __force __user *)(regs->sp);
+
+	if (!access_ok(VERIFY_READ, sf, sizeof(*sf)))
+		goto badframe;
+
+	err = restore_usr_regs(regs, sf);
+	err |= __get_user(magic, &sf->sigret_magic);
+	if (err)
+		goto badframe;
+
+	if (unlikely(is_do_ss_needed(magic)))
+		if (restore_altstack(&sf->uc.uc_stack))
+			goto badframe;
+
+	return regs->r0;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+/*
+ * Determine which stack to use..
+ */
+static inline void __user *get_sigframe(struct k_sigaction *ka,
+					struct pt_regs *regs,
+					unsigned long framesize)
+{
+	unsigned long sp = regs->sp;
+	void __user *frame;
+
+	/* This is the X/Open sanctioned signal stack switching */
+	if ((ka->sa.sa_flags & SA_ONSTACK) && !sas_ss_flags(sp))
+		sp = current->sas_ss_sp + current->sas_ss_size;
+
+	/* No matter what happens, 'sp' must be word
+	 * aligned otherwise nasty things could happen
+	 */
+
+	/* ATPCS B01 mandates 8-byte alignment */
+	frame = (void __user *)((sp - framesize) & ~7);
+
+	/* Check that we can actually write to the signal frame */
+	if (!access_ok(VERIFY_WRITE, frame, framesize))
+		frame = NULL;
+
+	return frame;
+}
+
+/*
+ * translate the signal
+ */
+static inline int map_sig(int sig)
+{
+	struct thread_info *thread = current_thread_info();
+	if (thread->exec_domain && thread->exec_domain->signal_invmap
+	    && sig < 32)
+		sig = thread->exec_domain->signal_invmap[sig];
+	return sig;
+}
+
+static int
+setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
+	       sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe __user *sf;
+	unsigned int magic = 0;
+	int err = 0;
+
+	sf = get_sigframe(ka, regs, sizeof(struct rt_sigframe));
+	if (!sf)
+		return 1;
+
+	/*
+	 * SA_SIGINFO requires 3 args to signal handler:
+	 *  #1: sig-no (common to any handler)
+	 *  #2: struct siginfo
+	 *  #3: struct ucontext (completely populated)
+	 */
+	if (unlikely(ka->sa.sa_flags & SA_SIGINFO)) {
+		err |= copy_siginfo_to_user(&sf->info, info);
+		err |= __put_user(0, &sf->uc.uc_flags);
+		err |= __put_user(NULL, &sf->uc.uc_link);
+		err |= __save_altstack(&sf->uc.uc_stack, regs->sp);
+
+		/* setup args 2 and 3 fo ruse rmode handler */
+		regs->r1 = (unsigned long)&sf->info;
+		regs->r2 = (unsigned long)&sf->uc;
+
+		/*
+		 * small optim to avoid unconditonally calling do_sigaltstack
+		 * in sigreturn path, now that we only have rt_sigreturn
+		 */
+		magic = MAGIC_SIGALTSTK;
+	}
+
+	/*
+	 * w/o SA_SIGINFO, struct ucontext is partially populated (only
+	 * uc_mcontext/uc_sigmask) for kernel's normal user state preservation
+	 * during signal handler execution. This works for SA_SIGINFO as well
+	 * although the semantics are now overloaded (the same reg state can be
+	 * inspected by userland: but are they allowed to fiddle with it ?
+	 */
+	err |= stash_usr_regs(sf, regs, set);
+	err |= __put_user(magic, &sf->sigret_magic);
+	if (err)
+		return err;
+
+	/* #1 arg to the user Signal handler */
+	regs->r0 = map_sig(signo);
+
+	/* setup PC of user space signal handler */
+	regs->ret = (unsigned long)ka->sa.sa_handler;
+
+	/*
+	 * handler returns using sigreturn stub provided already by userpsace
+	 */
+	BUG_ON(!(ka->sa.sa_flags & SA_RESTORER));
+	regs->blink = (unsigned long)ka->sa.sa_restorer;
+
+	/* User Stack for signal handler will be above the frame just carved */
+	regs->sp = (unsigned long)sf;
+
+	/*
+	 * Bug 94183, Clear the DE bit, so that when signal handler
+	 * starts to run, it doesn't use BTA
+	 */
+	regs->status32 &= ~STATUS_DE_MASK;
+	regs->status32 |= STATUS_L_MASK;
+
+	return err;
+}
+
+static void arc_restart_syscall(struct k_sigaction *ka, struct pt_regs *regs)
+{
+	switch (regs->r0) {
+	case -ERESTART_RESTARTBLOCK:
+	case -ERESTARTNOHAND:
+		/*
+		 * ERESTARTNOHAND means that the syscall should
+		 * only be restarted if there was no handler for
+		 * the signal, and since we only get here if there
+		 * is a handler, we don't restart
+		 */
+		regs->r0 = -EINTR;   /* ERESTART_xxx is internal */
+		break;
+
+	case -ERESTARTSYS:
+		/*
+		 * ERESTARTSYS means to restart the syscall if
+		 * there is no handler or the handler was
+		 * registered with SA_RESTART
+		 */
+		if (!(ka->sa.sa_flags & SA_RESTART)) {
+			regs->r0 = -EINTR;
+			break;
+		}
+		/* fallthrough */
+
+	case -ERESTARTNOINTR:
+		/*
+		 * ERESTARTNOINTR means that the syscall should
+		 * be called again after the signal handler returns.
+		 * Setup reg state just as it was before doing the trap
+		 * r0 has been clobbered with sys call ret code thus it
+		 * needs to be reloaded with orig first arg to syscall
+		 * in orig_r0. Rest of relevant reg-file:
+		 * r8 (syscall num) and (r1 - r7) will be reset to
+		 * their orig user space value when we ret from kernel
+		 */
+		regs->r0 = regs->orig_r0;
+		regs->ret -= 4;
+		break;
+	}
+}
+
+/*
+ * OK, we're invoking a handler
+ */
+static void
+handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
+	      struct pt_regs *regs)
+{
+	sigset_t *oldset = sigmask_to_save();
+	int ret;
+
+	/* Set up the stack frame */
+	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+
+	if (ret)
+		force_sigsegv(sig, current);
+	else
+		signal_delivered(sig, info, ka, regs, 0);
+}
+
+void do_signal(struct pt_regs *regs)
+{
+	struct k_sigaction ka;
+	siginfo_t info;
+	int signr;
+	int restart_scall;
+
+	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+
+	/* Are we from a system call? */
+	restart_scall = in_syscall(regs);
+
+	if (signr > 0) {
+		if (restart_scall)
+			arc_restart_syscall(&ka, regs);
+
+		handle_signal(signr, &ka, &info, regs);
+		return;
+	}
+
+	if (restart_scall) {
+		/* No handler for syscall: restart it */
+		if (regs->r0 == -ERESTARTNOHAND ||
+		    regs->r0 == -ERESTARTSYS || regs->r0 == -ERESTARTNOINTR) {
+			regs->r0 = regs->orig_r0;
+			regs->ret -= 4;
+		} else if (regs->r0 == -ERESTART_RESTARTBLOCK) {
+			regs->r8 = __NR_restart_syscall;
+			regs->ret -= 4;
+		}
+	}
+
+	/* If there's no signal to deliver, restore the saved sigmask back */
+	restore_saved_sigmask();
+}
+
+void do_notify_resume(struct pt_regs *regs)
+{
+	/*
+	 * ASM glue gaurantees that this is only called when returning to
+	 * user mode
+	 */
+	if (test_and_clear_thread_flag(TIF_NOTIFY_RESUME))
+		tracehook_notify_resume(regs);
+}
-- 
1.7.4.1

