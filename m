Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaCCAKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:10:21 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62419 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaCBX5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:57:37 -0500
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
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org, hch@infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 11/44] m68k: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:57:15 +0100
Message-Id: <1393804646-7797-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/m68k/kernel/signal.c | 63 ++++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 39 deletions(-)

diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index 57fd286..c8e6fa8 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -850,23 +850,23 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 	return (void __user *)((usp - frame_size) & -8UL);
 }
 
-static int setup_frame (int sig, struct k_sigaction *ka,
-			 sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+			struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	int fsize = frame_extra_sizes(regs->format);
 	struct sigcontext context;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 
 	if (fsize < 0) {
 #ifdef DEBUG
 		printk ("setup_frame: Unknown frame format %#x\n",
 			regs->format);
 #endif
-		goto give_sigsegv;
+		return -EFAULT;
 	}
 
-	frame = get_sigframe(ka, regs, sizeof(*frame) + fsize);
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame) + fsize);
 
 	if (fsize)
 		err |= copy_to_user (frame + 1, regs + 1, fsize);
@@ -899,7 +899,7 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 #endif
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	push_cache ((unsigned long) &frame->retcode);
 
@@ -908,7 +908,7 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 	 * to destroy is successfully copied to sigframe.
 	 */
 	wrusp ((unsigned long) frame);
-	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
 	adjustformat(regs);
 
 	/*
@@ -934,28 +934,24 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 		tregs->sr = regs->sr;
 	}
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return err;
 }
 
-static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
-			    sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			   struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	int fsize = frame_extra_sizes(regs->format);
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 
 	if (fsize < 0) {
 #ifdef DEBUG
 		printk ("setup_frame: Unknown frame format %#x\n",
 			regs->format);
 #endif
-		goto give_sigsegv;
+		return -EFAULT;
 	}
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (fsize)
 		err |= copy_to_user (&frame->uc.uc_extra, regs + 1, fsize);
@@ -968,7 +964,7 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 			  &frame->sig);
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -996,7 +992,7 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif /* CONFIG_MMU */
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	push_cache ((unsigned long) &frame->retcode);
 
@@ -1005,7 +1001,7 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * to destroy is successfully copied to sigframe.
 	 */
 	wrusp ((unsigned long) frame);
-	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
 	adjustformat(regs);
 
 	/*
@@ -1031,10 +1027,6 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 		tregs->sr = regs->sr;
 	}
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return err;
 }
 
 static inline void
@@ -1074,26 +1066,22 @@ handle_restart(struct pt_regs *regs, struct k_sigaction *ka, int has_handler)
  * OK, we're invoking a handler
  */
 static void
-handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int err;
 	/* are we from a system call? */
 	if (regs->orig_d0 >= 0)
 		/* If so, check system call restarting.. */
-		handle_restart(regs, ka, 1);
+		handle_restart(regs, &ksig->ka, 1);
 
 	/* set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		err = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		err = setup_rt_frame(ksig, oldset, regs);
 	else
-		err = setup_frame(sig, ka, oldset, regs);
-
-	if (err)
-		return;
+		err = setup_frame(ksig, oldset, regs);
 
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(err, ksig, 0);
 
 	if (test_thread_flag(TIF_DELAYED_TRACE)) {
 		regs->sr &= ~0x8000;
@@ -1108,16 +1096,13 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	struct k_sigaction ka;
-	int signr;
+	struct ksignal ksig;
 
 	current->thread.esp0 = (unsigned long) regs;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &ka, &info, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
 
-- 
1.8.4.2

