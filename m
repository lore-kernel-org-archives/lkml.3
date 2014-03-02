Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaCBX5A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:57:00 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62413 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbaCBX4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:56:38 -0500
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
Subject: [PATCH 05/44] c6x: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:55:54 +0100
Message-Id: <1393804559-7701-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804559-7701-1-git-send-email-richard@nod.at>
References: <1393804559-7701-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Tested-by: Mark Salter <msalter@redhat.com>
Acked-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/c6x/kernel/signal.c | 43 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 25 deletions(-)

diff --git a/arch/c6x/kernel/signal.c b/arch/c6x/kernel/signal.c
index 3998b24..8bf9aad 100644
--- a/arch/c6x/kernel/signal.c
+++ b/arch/c6x/kernel/signal.c
@@ -146,21 +146,21 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
 	return (void __user *)((sp - framesize) & ~7);
 }
 
-static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long __user *retcode;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto segv_and_exit;
+		return -EFAULT;
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Clear all the bits of the ucontext we don't use.  */
 	err |= __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext));
@@ -188,7 +188,7 @@ static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
 #undef COPY
 
 	if (err)
-		goto segv_and_exit;
+		return -EFAULT;
 
 	flush_icache_range((unsigned long) &frame->retcode,
 			   (unsigned long) &frame->retcode + RETCODE_SIZE);
@@ -198,10 +198,10 @@ static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
 	/* Change user context to branch to signal handler */
 	regs->sp = (unsigned long) frame - 8;
 	regs->b3 = (unsigned long) retcode;
-	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
 
 	/* Give the signal number to the handler */
-	regs->a4 = signr;
+	regs->a4 = ksig->sig;
 
 	/*
 	 * For realtime signals we must also set the second and third
@@ -212,10 +212,6 @@ static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
 	regs->a6 = (unsigned long)&frame->uc;
 
 	return 0;
-
-segv_and_exit:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
 
 static inline void
@@ -245,10 +241,11 @@ do_restart:
 /*
  * handle the actual delivery of a signal to userspace
  */
-static void handle_signal(int sig,
-			 siginfo_t *info, struct k_sigaction *ka,
-			 struct pt_regs *regs, int syscall)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs,
+			  int syscall)
 {
+	int ret;
+
 	/* Are we from a system call? */
 	if (syscall) {
 		/* If so, check system call restarting.. */
@@ -259,7 +256,7 @@ static void handle_signal(int sig,
 			break;
 
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->a4 = -EINTR;
 				break;
 			}
@@ -272,9 +269,8 @@ static void handle_signal(int sig,
 	}
 
 	/* Set up the stack frame */
-	if (setup_rt_frame(sig, ka, info, sigmask_to_save(), regs) < 0)
-		return;
-	signal_delivered(sig, info, ka, regs, 0);
+	ret = setup_rt_frame(ksig, sigmask_to_save(), regs);
+	signal_setup_done(ret, ksig, 0);
 }
 
 /*
@@ -282,18 +278,15 @@ static void handle_signal(int sig,
  */
 static void do_signal(struct pt_regs *regs, int syscall)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
 
 	/* we want the common case to go fast, which is why we may in certain
 	 * cases get here from kernel mode */
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		handle_signal(signr, &info, &ka, regs, syscall);
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig, regs, syscall);
 		return;
 	}
 
-- 
1.8.4.2

