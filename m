Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab3JHLeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:34:15 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1664 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754955Ab3JHLeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:34:10 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk, vgupta@synopsys.com,
        catalin.marinas@arm.com, will.deacon@arm.com, hskinnemoen@gmail.com,
        egtvedt@samfundet.no, vapier@gentoo.org, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, rkuo@codeaurora.org, tony.luck@intel.com,
        fenghua.yu@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        lethal@linux-sh.org, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 17/29] openrisc: Use get_signal() signal_setup_done()
Date: Tue,  8 Oct 2013 13:33:53 +0200
Message-Id: <1381232035-4240-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381232035-4240-1-git-send-email-richard@nod.at>
References: <1381232035-4240-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/openrisc/kernel/signal.c | 53 ++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index ae167f7..08ad302 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -173,25 +173,25 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
  * trampoline which performs the syscall sigreturn, or a provided
  * user-mode trampoline.
  */
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
 	unsigned long return_ip;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
 
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		err |= copy_siginfo_to_user(&frame->info, info);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Clear all the bits of the ucontext we don't use.  */
 	err |= __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext));
@@ -203,7 +203,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* trampoline - the desired return ip is the retcode itself */
 	return_ip = (unsigned long)&frame->retcode;
@@ -214,14 +214,14 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(0x15000000, (unsigned long *)(frame->retcode + 8));
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* TODO what is the current->exec_domain stuff and invmap ? */
 
 	/* Set up registers for signal handler */
-	regs->pc = (unsigned long)ka->sa.sa_handler; /* what we enter NOW */
+	regs->pc = (unsigned long)ksig->ka.sa.sa_handler; /* what we enter NOW */
 	regs->gpr[9] = (unsigned long)return_ip;     /* what we enter LATER */
-	regs->gpr[3] = (unsigned long)sig;           /* arg 1: signo */
+	regs->gpr[3] = (unsigned long)ksig->sig;           /* arg 1: signo */
 	regs->gpr[4] = (unsigned long)&frame->info;  /* arg 2: (siginfo_t*) */
 	regs->gpr[5] = (unsigned long)&frame->uc;    /* arg 3: ucontext */
 
@@ -229,25 +229,16 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->sp = (unsigned long)frame;
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 static inline void
-handle_signal(unsigned long sig,
-	      siginfo_t *info, struct k_sigaction *ka,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	int ret;
 
-	ret = setup_rt_frame(sig, ka, info, sigmask_to_save(), regs);
-	if (ret)
-		return;
+	ret = setup_rt_frame(ksig, sigmask_to_save(), regs);
 
-	signal_delivered(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 /*
@@ -264,9 +255,7 @@ handle_signal(unsigned long sig,
 
 void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * We want the common case to go fast, which
@@ -277,7 +266,7 @@ void do_signal(struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+	get_signal(&ksig);
 
 	/* If we are coming out of a syscall then we need
 	 * to check if the syscall was interrupted and wants to be
@@ -295,12 +284,12 @@ void do_signal(struct pt_regs *regs)
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
 			/* Restart if there is no signal handler */
-			restart = (signr <= 0);
+			restart = (ksig.sig <= 0);
 			break;
 		case -ERESTARTSYS:
 			/* Restart if there no signal handler or
 			 * SA_RESTART flag is set */
-			restart = (signr <= 0 || (ka.sa.sa_flags & SA_RESTART));
+			restart = (ksig.sig <= 0 || (ksig.ka.sa.sa_flags & SA_RESTART));
 			break;
 		case -ERESTARTNOINTR:
 			/* Always restart */
@@ -319,16 +308,14 @@ void do_signal(struct pt_regs *regs)
 		}
 	}
 
-	if (signr <= 0) {
+	if (ksig.sig <= 0) {
 		/* no signal to deliver so we just put the saved sigmask
 		 * back */
 		restore_saved_sigmask();
 	} else {		/* signr > 0 */
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 	}
-
-	return;
 }
 
 asmlinkage void do_notify_resume(struct pt_regs *regs)
-- 
1.8.1.4

