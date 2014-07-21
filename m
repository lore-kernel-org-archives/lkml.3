Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbaGUOEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:04:05 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351AbaGUOD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:03:59 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, vgupta@synopsys.com
Subject: [PATCH 01/43] arc: Use get_signal() signal_setup_done()
Date: Mon, 21 Jul 2014 16:02:47 +0200
Message-Id: <1405951409-16953-2-git-send-email-richard@sigma-star.at>
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
Acked-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/signal.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index 7e95e1a..c2031e2 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -179,14 +179,13 @@ static inline int map_sig(int sig)
 }
 
 static int
-setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *sf;
 	unsigned int magic = 0;
 	int err = 0;
 
-	sf = get_sigframe(ka, regs, sizeof(struct rt_sigframe));
+	sf = get_sigframe(&ksig->ka, regs, sizeof(struct rt_sigframe));
 	if (!sf)
 		return 1;
 
@@ -205,8 +204,8 @@ setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
 	 *  #2: struct siginfo
 	 *  #3: struct ucontext (completely populated)
 	 */
-	if (unlikely(ka->sa.sa_flags & SA_SIGINFO)) {
-		err |= copy_siginfo_to_user(&sf->info, info);
+	if (unlikely(ksig->ka.sa.sa_flags & SA_SIGINFO)) {
+		err |= copy_siginfo_to_user(&sf->info, &ksig->info);
 		err |= __put_user(0, &sf->uc.uc_flags);
 		err |= __put_user(NULL, &sf->uc.uc_link);
 		err |= __save_altstack(&sf->uc.uc_stack, regs->sp);
@@ -227,16 +226,16 @@ setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
 		return err;
 
 	/* #1 arg to the user Signal handler */
-	regs->r0 = map_sig(signo);
+	regs->r0 = map_sig(ksig->sig);
 
 	/* setup PC of user space signal handler */
-	regs->ret = (unsigned long)ka->sa.sa_handler;
+	regs->ret = (unsigned long)ksig->ka.sa.sa_handler;
 
 	/*
 	 * handler returns using sigreturn stub provided already by userpsace
 	 */
-	BUG_ON(!(ka->sa.sa_flags & SA_RESTORER));
-	regs->blink = (unsigned long)ka->sa.sa_restorer;
+	BUG_ON(!(ksig->ka.sa.sa_flags & SA_RESTORER));
+	regs->blink = (unsigned long)ksig->ka.sa.sa_restorer;
 
 	/* User Stack for signal handler will be above the frame just carved */
 	regs->sp = (unsigned long)sf;
@@ -298,38 +297,30 @@ static void arc_restart_syscall(struct k_sigaction *ka, struct pt_regs *regs)
  * OK, we're invoking a handler
  */
 static void
-handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
 
 	/* Set up the stack frame */
-	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	ret = setup_rt_frame(ksig, oldset, regs);
 
-	if (ret)
-		force_sigsegv(sig, current);
-	else
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
 	int restart_scall;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-
 	restart_scall = in_syscall(regs) && syscall_restartable(regs);
 
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		if (restart_scall) {
-			arc_restart_syscall(&ka, regs);
+			arc_restart_syscall(&ksig.ka, regs);
 			syscall_wont_restart(regs);	/* No more restarts */
 		}
-		handle_signal(signr, &ka, &info, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
 
-- 
1.8.4.5

