Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaCCAH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:07:59 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62409 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbaCBX7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:33 -0500
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
Subject: [PATCH 24/44] xtensa: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:59:07 +0100
Message-Id: <1393804758-7916-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/xtensa/kernel/signal.c | 43 ++++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index 98b67d5..4612321 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -331,17 +331,17 @@ gen_return_code(unsigned char *codemem)
 }
 
 
-static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-		       sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+		       struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int signal;
 	unsigned long sp, ra, tp;
 
 	sp = regs->areg[1];
 
-	if ((ka->sa.sa_flags & SA_ONSTACK) != 0 && sas_ss_flags(sp) == 0) {
+	if ((ksig->ka.sa.sa_flags & SA_ONSTACK) != 0 && sas_ss_flags(sp) == 0) {
 		sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
@@ -351,7 +351,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		panic ("Double exception sys_sigreturn\n");
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame))) {
-		goto give_sigsegv;
+		return -EFAULT;
 	}
 
 	signal = current_thread_info()->exec_domain
@@ -360,8 +360,8 @@ static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		? current_thread_info()->exec_domain->signal_invmap[sig]
 		: sig;
 
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		err |= copy_siginfo_to_user(&frame->info, info);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
+		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 	}
 
 	/* Create the user context.  */
@@ -372,8 +372,8 @@ static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= setup_sigcontext(frame, regs);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		ra = (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		ra = (unsigned long)ksig->ka.sa.sa_restorer;
 	} else {
 
 		/* Create sys_rt_sigreturn syscall in stack frame */
@@ -381,7 +381,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		err |= gen_return_code(frame->retcode);
 
 		if (err) {
-			goto give_sigsegv;
+			return -EFAULT;
 		}
 		ra = (unsigned long) frame->retcode;
 	}
@@ -393,7 +393,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler; preserve the threadptr */
 	tp = regs->threadptr;
-	start_thread(regs, (unsigned long) ka->sa.sa_handler,
+	start_thread(regs, (unsigned long) ksig->ka.sa.sa_handler,
 		     (unsigned long) frame);
 
 	/* Set up a stack frame for a call4
@@ -416,10 +416,6 @@ static int setup_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
@@ -433,15 +429,11 @@ give_sigsegv:
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	task_pt_regs(current)->icountlevel = 0;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		int ret;
 
 		/* Are we from a system call? */
@@ -457,7 +449,7 @@ static void do_signal(struct pt_regs *regs)
 					break;
 
 				case -ERESTARTSYS:
-					if (!(ka.sa.sa_flags & SA_RESTART)) {
+					if (!(ksig.ka.sa.sa_flags & SA_RESTART)) {
 						regs->areg[2] = -EINTR;
 						break;
 					}
@@ -476,11 +468,8 @@ static void do_signal(struct pt_regs *regs)
 
 		/* Whee!  Actually deliver the signal.  */
 		/* Set up the stack frame */
-		ret = setup_frame(signr, &ka, &info, sigmask_to_save(), regs);
-		if (ret)
-			return;
-
-		signal_delivered(signr, &info, &ka, regs, 0);
+		ret = setup_frame(&ksig, sigmask_to_save(), regs);
+		signal_setup_done(ret, &ksig, 0);
 		if (current->ptrace & PT_SINGLESTEP)
 			task_pt_regs(current)->icountlevel = 1;
 
-- 
1.8.4.2

