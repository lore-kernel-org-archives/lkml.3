Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaGUOEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:04:02 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbaGUOD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:03:59 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, hskinnemoen@gmail.com,
        egtvedt@samfundet.no
Subject: [PATCH 03/43] avr32: Use get_signal() signal_setup_done()
Date: Mon, 21 Jul 2014 16:02:49 +0200
Message-Id: <1405951409-16953-4-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/kernel/signal.c | 43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index b80c0b3..dda150f 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -138,13 +138,12 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, int framesize)
 }
 
 static int
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	err = -EFAULT;
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
 		goto out;
@@ -164,7 +163,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err = __put_user(0x3008d733 | (__NR_rt_sigreturn << 20),
 			 &frame->retcode);
 
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Set up the ucontext */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -176,12 +175,12 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		goto out;
 
-	regs->r12 = sig;
+	regs->r12 = ksig->sig;
 	regs->r11 = (unsigned long) &frame->info;
 	regs->r10 = (unsigned long) &frame->uc;
 	regs->sp = (unsigned long) frame;
-	if (ka->sa.sa_flags & SA_RESTORER)
-		regs->lr = (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		regs->lr = (unsigned long)ksig->ka.sa.sa_restorer;
 	else {
 		printk(KERN_NOTICE "[%s:%d] did not set SA_RESTORER\n",
 		       current->comm, current->pid);
@@ -189,10 +188,10 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	pr_debug("SIG deliver [%s:%d]: sig=%d sp=0x%lx pc=0x%lx->0x%p lr=0x%lx\n",
-		 current->comm, current->pid, sig, regs->sp,
-		 regs->pc, ka->sa.sa_handler, regs->lr);
+		 current->comm, current->pid, ksig->sig, regs->sp,
+		 regs->pc, ksig->ka.sa.sa_handler, regs->lr);
 
-	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->pc = (unsigned long)ksig->ka.sa.sa_handler;
 
 out:
 	return err;
@@ -208,15 +207,14 @@ static inline void setup_syscall_restart(struct pt_regs *regs)
 }
 
 static inline void
-handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs, int syscall)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs, int syscall)
 {
 	int ret;
 
 	/*
 	 * Set up the stack frame
 	 */
-	ret = setup_rt_frame(sig, ka, info, sigmask_to_save(), regs);
+	ret = setup_rt_frame(ksig, sigmask_to_save(), regs);
 
 	/*
 	 * Check that the resulting registers are sane
@@ -226,10 +224,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	/*
 	 * Block the signal if we were successful.
 	 */
-	if (ret != 0)
-		force_sigsegv(sig, current);
-	else
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 /*
@@ -239,9 +234,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
  */
 static void do_signal(struct pt_regs *regs, int syscall)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * We want the common case to go fast, which is why we may in
@@ -251,18 +244,18 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+	get_signal(&ksig);
 	if (syscall) {
 		switch (regs->r12) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
-			if (signr > 0) {
+			if (ksig.sig > 0) {
 				regs->r12 = -EINTR;
 				break;
 			}
 			/* fall through */
 		case -ERESTARTSYS:
-			if (signr > 0 && !(ka.sa.sa_flags & SA_RESTART)) {
+			if (ksig.sig > 0 && !(ksig.ka.sa.sa_flags & SA_RESTART)) {
 				regs->r12 = -EINTR;
 				break;
 			}
@@ -272,13 +265,13 @@ static void do_signal(struct pt_regs *regs, int syscall)
 		}
 	}
 
-	if (signr == 0) {
+	if (!ksig.sig) {
 		/* No signal to deliver -- put the saved sigmask back */
 		restore_saved_sigmask();
 		return;
 	}
 
-	handle_signal(signr, &ka, &info, regs, syscall);
+	handle_signal(&ksig, regs, syscall);
 }
 
 asmlinkage void do_notify_resume(struct pt_regs *regs, struct thread_info *ti)
-- 
1.8.4.5

