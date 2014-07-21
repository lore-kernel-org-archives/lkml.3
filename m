Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbaGUOMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:12:10 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaGUOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:15 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 25/43] Clean up signal_delivered()
Date: Mon, 21 Jul 2014 16:03:11 +0200
Message-Id: <1405951409-16953-26-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

 - Pass a ksignal struct to it
 - Remove unused regs parameter
 - Make it private as it's nowhere outside of kernel/signal.c is used

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/signal.h |  1 -
 kernel/signal.c        | 21 ++++++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index c9e6536..b005cc3 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -282,7 +282,6 @@ struct ksignal {
 
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
-extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
 extern void kernel_sigaction(int, __sighandler_t);
 
diff --git a/kernel/signal.c b/kernel/signal.c
index c4d4766..0d75cf8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2353,19 +2353,15 @@ relock:
 
 /**
  * signal_delivered - 
- * @sig:		number of signal being delivered
- * @info:		siginfo_t of signal being delivered
- * @ka:			sigaction setting that chose the handler
- * @regs:		user register state
+ * @ksig:		kernel signal struct
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
  * This function should be called when a signal has successfully been
- * delivered. It updates the blocked signals accordingly (@ka->sa.sa_mask
+ * delivered. It updates the blocked signals accordingly (@ksig->ka.sa.sa_mask
  * is always blocked, and the signal itself is blocked unless %SA_NODEFER
- * is set in @ka->sa.sa_flags.  Tracing is notified.
+ * is set in @ksig->ka.sa.sa_flags.  Tracing is notified.
  */
-void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka,
-			struct pt_regs *regs, int stepping)
+static void signal_delivered(struct ksignal *ksig, int stepping)
 {
 	sigset_t blocked;
 
@@ -2375,9 +2371,9 @@ void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka,
 	   simply clear the restore sigmask flag.  */
 	clear_restore_sigmask();
 
-	sigorsets(&blocked, &current->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
+	sigorsets(&blocked, &current->blocked, &ksig->ka.sa.sa_mask);
+	if (!(ksig->ka.sa.sa_flags & SA_NODEFER))
+		sigaddset(&blocked, ksig->sig);
 	set_current_blocked(&blocked);
 	tracehook_signal_handler(stepping);
 }
@@ -2387,8 +2383,7 @@ void signal_setup_done(int failed, struct ksignal *ksig, int stepping)
 	if (failed)
 		force_sigsegv(ksig->sig, current);
 	else
-		signal_delivered(ksig->sig, &ksig->info, &ksig->ka,
-			signal_pt_regs(), stepping);
+		signal_delivered(ksig, stepping);
 }
 
 /*
-- 
1.8.4.5

