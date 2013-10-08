Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3JHLcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:32:43 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1664 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755195Ab3JHLci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:32:38 -0400
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
Subject: [PATCH 08/29] h8300: Use get_signal() signal_setup_done()
Date: Tue,  8 Oct 2013 13:32:21 +0200
Message-Id: <1381231942-4145-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381231942-4145-1-git-send-email-richard@nod.at>
References: <1381231942-4145-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/h8300/kernel/signal.c | 81 +++++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 47 deletions(-)

diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index a65ff3b..f321b50 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -206,18 +206,18 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 	return (void *)((usp - frame_size) & -8UL);
 }
 
-static int setup_frame (int sig, struct k_sigaction *ka,
-			 sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+			struct pt_regs *regs)
 {
 	struct sigframe *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int usig;
 	unsigned char *ret;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	usig = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -227,22 +227,22 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 
 	err |= __put_user(usig, &frame->sig);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= setup_sigcontext(&frame->sc, regs, set->sig[0]);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
 		err |= copy_to_user(frame->extramask, &set->sig[1],
 				    sizeof(frame->extramask));
 		if (err)
-			goto give_sigsegv;
+			return -EFAULT;
 	}
 
 	ret = frame->retcode;
-	if (ka->sa.sa_flags & SA_RESTORER)
-		ret = (unsigned char *)(ka->sa.sa_restorer);
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		ret = (unsigned char *)(ksig->ka.sa.sa_restorer);
 	else {
 		/* sub.l er0,er0; mov.b #__NR_sigreturn,r0l; trapa #0 */
 		err |= __put_user(0x1a80f800 + (__NR_sigreturn & 0xff),
@@ -254,11 +254,11 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 	err |= __put_user(ret, &frame->pretcode);
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	wrusp ((unsigned long) frame);
-	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
 	regs->er0 = (current_thread_info()->exec_domain
 			   && current_thread_info()->exec_domain->signal_invmap
 			   && sig < 32
@@ -268,24 +268,20 @@ static int setup_frame (int sig, struct k_sigaction *ka,
 	regs->er5 = current->mm->start_data;	/* GOT base */
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
-static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
-			    sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			   struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int usig;
 	unsigned char *ret;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	usig = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -295,13 +291,13 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	err |= __put_user(usig, &frame->sig);
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
@@ -310,12 +306,12 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, set->sig[0]);
 	err |= copy_to_user (&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  */
 	ret = frame->retcode;
-	if (ka->sa.sa_flags & SA_RESTORER)
-		ret = (unsigned char *)(ka->sa.sa_restorer);
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		ret = (unsigned char *)(ksig->ka.sa.sa_restorer);
 	else {
 		/* sub.l er0,er0; mov.b #__NR_sigreturn,r0l; trapa #0 */
 		err |= __put_user(0x1a80f800 + (__NR_sigreturn & 0xff),
@@ -325,11 +321,11 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(ret, &frame->pretcode);
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	wrusp ((unsigned long) frame);
-	regs->pc  = (unsigned long) ka->sa.sa_handler;
+	regs->pc  = (unsigned long) ksig->ka.sa.sa_handler;
 	regs->er0 = (current_thread_info()->exec_domain
 		     && current_thread_info()->exec_domain->signal_invmap
 		     && sig < 32
@@ -340,18 +336,13 @@ static int setup_rt_frame (int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->er5 = current->mm->start_data;	/* GOT base */
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler
  */
 static void
-handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-	      struct pt_regs * regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
@@ -364,7 +355,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 				break;
 
 			case -ERESTARTSYS:
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
+				if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 					regs->er0 = -EINTR;
 					break;
 				}
@@ -376,13 +367,12 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	}
 
 	/* set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset, regs);
 	else
-		ret = setup_frame(sig, ka, oldset, regs);
+		ret = setup_frame(ksig, oldset, regs);
 
-	if (!ret)
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 /*
@@ -392,9 +382,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * We want the common case to go fast, which
@@ -407,10 +395,9 @@ static void do_signal(struct pt_regs *regs)
 
 	current->thread.esp0 = (unsigned long) regs;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
 	/* Did we come from a system call? */
-- 
1.8.1.4

