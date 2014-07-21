Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbaGUOQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:16:09 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14393 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaGUOEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:02 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, rkuo@codeaurora.org,
        linux-hexagon@vger.kernel.org
Subject: [PATCH 08/43] hexagon: Use get_signal() signal_setup_done()
Date: Mon, 21 Jul 2014 16:02:54 +0200
Message-Id: <1405951409-16953-9-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Acked-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/hexagon/kernel/signal.c | 45 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
index d7c7387..6525358 100644
--- a/arch/hexagon/kernel/signal.c
+++ b/arch/hexagon/kernel/signal.c
@@ -112,20 +112,20 @@ static int restore_sigcontext(struct pt_regs *regs,
 /*
  * Setup signal stack frame with siginfo structure
  */
-static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set,  struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	int err = 0;
 	struct rt_sigframe __user *frame;
 	struct hexagon_vdso *vdso = current->mm->context.vdso;
 
-	frame = get_sigframe(ka, regs, sizeof(struct rt_sigframe));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(struct rt_sigframe)))
-		goto	sigsegv;
+		return -EFAULT;
 
-	if (copy_siginfo_to_user(&frame->info, info))
-		goto	sigsegv;
+	if (copy_siginfo_to_user(&frame->info, &ksig->info))
+		return -EFAULT;
 
 	/* The on-stack signal trampoline is no longer executed;
 	 * however, the libgcc signal frame unwinding code checks for
@@ -137,29 +137,26 @@ static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	err |= __save_altstack(&frame->uc.uc_stack, user_stack_pointer(regs));
 	if (err)
-		goto sigsegv;
+		return -EFAULT;
 
 	/* Load r0/r1 pair with signumber/siginfo pointer... */
 	regs->r0100 = ((unsigned long long)((unsigned long)&frame->info) << 32)
-		| (unsigned long long)signr;
+		| (unsigned long long)ksig->sig;
 	regs->r02 = (unsigned long) &frame->uc;
 	regs->r31 = (unsigned long) vdso->rt_signal_trampoline;
 	pt_psp(regs) = (unsigned long) frame;
-	pt_set_elr(regs, (unsigned long)ka->sa.sa_handler);
+	pt_set_elr(regs, (unsigned long)ksig->ka.sa.sa_handler);
 
 	return 0;
-
-sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
 
 /*
  * Setup invocation of signal handler
  */
-static void handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
-			 struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
+	int ret;
+
 	/*
 	 * If we're handling a signal that aborted a system call,
 	 * set up the error return value before adding the signal
@@ -173,7 +170,7 @@ static void handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
 			regs->r00 = -EINTR;
 			break;
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->r00 = -EINTR;
 				break;
 			}
@@ -193,11 +190,9 @@ static void handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
 	 * only set up the rt_frame flavor.
 	 */
 	/* If there was an error on setup, no signal was delivered. */
-	if (setup_rt_frame(sig, ka, info, sigmask_to_save(), regs) < 0)
-		return;
+	ret = setup_rt_frame(ksig, sigmask_to_save(), regs);
 
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 /*
@@ -205,17 +200,13 @@ static void handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
  */
 void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction sigact;
-	siginfo_t info;
-	int signo;
+	struct ksignal ksig;
 
 	if (!user_mode(regs))
 		return;
 
-	signo = get_signal_to_deliver(&info, &sigact, regs, NULL);
-
-	if (signo > 0) {
-		handle_signal(signo, &info, &sigact, regs);
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig, regs);
 		return;
 	}
 
-- 
1.8.4.5

