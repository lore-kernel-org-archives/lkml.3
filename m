Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbaGUORa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:17:30 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbaGUOD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:03:59 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, realmz6@gmail.com,
        adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH 04/43] blackfin: Use get_signal() signal_setup_done()
Date: Mon, 21 Jul 2014 16:02:50 +0200
Message-Id: <1405951409-16953-5-git-send-email-richard@sigma-star.at>
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
---
 arch/blackfin/kernel/signal.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index b022af6..1389cd3 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -152,23 +152,22 @@ static inline void *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 }
 
 static int
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
-	       sigset_t * set, struct pt_regs *regs)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe *frame;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	err |= __put_user((current_thread_info()->exec_domain
 			   && current_thread_info()->exec_domain->signal_invmap
-			   && sig < 32
+			   && ksig->sig < 32
 			   ? current_thread_info()->exec_domain->
-			   signal_invmap[sig] : sig), &frame->sig);
+			   signal_invmap[ksig->sig] : ksig->sig), &frame->sig);
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -183,7 +182,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
 	/* Set up registers for signal handler */
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
-			(struct fdpic_func_descriptor *) ka->sa.sa_handler;
+			(struct fdpic_func_descriptor *) ksig->ka.sa.sa_handler;
 		u32 pc, p3;
 		err |= __get_user(pc, &funcptr->text);
 		err |= __get_user(p3, &funcptr->GOT);
@@ -192,7 +191,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t * info,
 		regs->pc = pc;
 		regs->p3 = p3;
 	} else
-		regs->pc = (unsigned long)ka->sa.sa_handler;
+		regs->pc = (unsigned long)ksig->ka.sa.sa_handler;
 	wrusp((unsigned long)frame);
 	regs->rets = SIGRETURN_STUB;
 
@@ -237,20 +236,19 @@ handle_restart(struct pt_regs *regs, struct k_sigaction *ka, int has_handler)
  * OK, we're invoking a handler
  */
 static void
-handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
-	      struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
+	int ret;
+
 	/* are we from a system call? to see pt_regs->orig_p0 */
 	if (regs->orig_p0 >= 0)
 		/* If so, check system call restarting.. */
-		handle_restart(regs, ka, 1);
+		handle_restart(regs, &ksig->ka, 1);
 
 	/* set up the stack frame */
-	if (setup_rt_frame(sig, ka, info, sigmask_to_save(), regs) < 0)
-		force_sigsegv(sig, current);
-	else 
-		signal_delivered(sig, info, ka, regs,
-				test_thread_flag(TIF_SINGLESTEP));
+	ret = setup_rt_frame(ksig, sigmask_to_save(), regs);
+
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 /*
@@ -264,16 +262,13 @@ handle_signal(int sig, siginfo_t *info, struct k_sigaction *ka,
  */
 asmlinkage void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	current->thread.esp0 = (unsigned long)regs;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
 
-- 
1.8.4.5

