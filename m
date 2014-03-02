Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaCBX5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:57:10 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62418 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaCBX4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:56:49 -0500
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
Subject: [PATCH 10/44] m32r: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:55:59 +0100
Message-Id: <1393804559-7701-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804559-7701-1-git-send-email-richard@nod.at>
References: <1393804559-7701-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/m32r/kernel/signal.c | 47 ++++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index d503568..cce3fd3 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -173,17 +173,17 @@ get_sigframe(struct k_sigaction *ka, unsigned long sp, size_t frame_size)
 	return (void __user *)((sp - frame_size) & -8ul);
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	int err = 0;
-	int signal;
+	int signal, sig = ksig->sig;
 
-	frame = get_sigframe(ka, regs->spu, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs->spu, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	signal = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -193,13 +193,13 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	err |= __put_user(signal, &frame->sig);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -208,17 +208,17 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  */
-	regs->lr = (unsigned long)ka->sa.sa_restorer;
+	regs->lr = (unsigned long)ksig->ka.sa.sa_restorer;
 
 	/* Set up registers for signal handler */
 	regs->spu = (unsigned long)frame;
 	regs->r0 = signal;	/* Arg for signal handler */
 	regs->r1 = (unsigned long)&frame->info;
 	regs->r2 = (unsigned long)&frame->uc;
-	regs->bpc = (unsigned long)ka->sa.sa_handler;
+	regs->bpc = (unsigned long)ksig->ka.sa.sa_handler;
 
 	set_fs(USER_DS);
 
@@ -228,10 +228,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 static int prev_insn(struct pt_regs *regs)
@@ -252,9 +248,10 @@ static int prev_insn(struct pt_regs *regs)
  */
 
 static void
-handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
+	int ret;
+
 	/* Are we from a system call? */
 	if (regs->syscall_nr >= 0) {
 		/* If so, check system call restarting.. */
@@ -265,7 +262,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 				break;
 
 			case -ERESTARTSYS:
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
+				if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 					regs->r0 = -EINTR;
 					break;
 				}
@@ -278,10 +275,9 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	/* Set up the stack frame */
-	if (setup_rt_frame(sig, ka, info, sigmask_to_save(), regs))
-		return;
+	ret = setup_rt_frame(ksig, sigmask_to_save(), regs);
 
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 /*
@@ -291,9 +287,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * We want the common case to go fast, which
@@ -304,8 +298,7 @@ static void do_signal(struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Re-enable any watchpoints before delivering the
 		 * signal to user space. The processor register will
 		 * have been cleared if the watchpoint triggered
@@ -313,7 +306,7 @@ static void do_signal(struct pt_regs *regs)
 		 */
 
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &ka, &info, regs);
+		handle_signal(&ksig, regs);
 
 		return;
 	}
-- 
1.8.4.2

