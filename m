Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbaGUOKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:10:13 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558AbaGUOES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:18 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 26/43] Rip out get_signal_to_deliver()
Date: Mon, 21 Jul 2014 16:03:12 +0200
Message-Id: <1405951409-16953-27-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Now we can turn get_signal() to the main function.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/signal.h | 14 +-------------
 kernel/signal.c        | 23 ++++++++++++-----------
 2 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index b005cc3..750196f 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -280,7 +280,7 @@ struct ksignal {
 	int sig;
 };
 
-extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern int get_signal(struct ksignal *ksig);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void exit_signals(struct task_struct *tsk);
 extern void kernel_sigaction(int, __sighandler_t);
@@ -300,18 +300,6 @@ static inline void disallow_signal(int sig)
 	kernel_sigaction(sig, SIG_IGN);
 }
 
-/*
- * Eventually that'll replace get_signal_to_deliver(); macro for now,
- * to avoid nastiness with include order.
- */
-#define get_signal(ksig)					\
-({								\
-	struct ksignal *p = (ksig);				\
-	p->sig = get_signal_to_deliver(&p->info, &p->ka,	\
-					signal_pt_regs(), NULL);\
-	p->sig > 0;						\
-})
-
 extern struct kmem_cache *sighand_cachep;
 
 int unhandled_signal(struct task_struct *tsk, int sig);
diff --git a/kernel/signal.c b/kernel/signal.c
index 0d75cf8..5c60200 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2166,8 +2166,7 @@ static int ptrace_signal(int signr, siginfo_t *info)
 	return signr;
 }
 
-int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
-			  struct pt_regs *regs, void *cookie)
+int get_signal(struct ksignal *ksig)
 {
 	struct sighand_struct *sighand = current->sighand;
 	struct signal_struct *signal = current->signal;
@@ -2237,13 +2236,13 @@ relock:
 			goto relock;
 		}
 
-		signr = dequeue_signal(current, &current->blocked, info);
+		signr = dequeue_signal(current, &current->blocked, &ksig->info);
 
 		if (!signr)
 			break; /* will return 0 */
 
 		if (unlikely(current->ptrace) && signr != SIGKILL) {
-			signr = ptrace_signal(signr, info);
+			signr = ptrace_signal(signr, &ksig->info);
 			if (!signr)
 				continue;
 		}
@@ -2251,13 +2250,13 @@ relock:
 		ka = &sighand->action[signr-1];
 
 		/* Trace actually delivered signals. */
-		trace_signal_deliver(signr, info, ka);
+		trace_signal_deliver(signr, &ksig->info, ka);
 
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {
 			/* Run the handler.  */
-			*return_ka = *ka;
+			ksig->ka = *ka;
 
 			if (ka->sa.sa_flags & SA_ONESHOT)
 				ka->sa.sa_handler = SIG_DFL;
@@ -2307,7 +2306,7 @@ relock:
 				spin_lock_irq(&sighand->siglock);
 			}
 
-			if (likely(do_signal_stop(info->si_signo))) {
+			if (likely(do_signal_stop(ksig->info.si_signo))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
@@ -2328,7 +2327,7 @@ relock:
 
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
-				print_fatal_signal(info->si_signo);
+				print_fatal_signal(ksig->info.si_signo);
 			proc_coredump_connector(current);
 			/*
 			 * If it was able to dump core, this kills all
@@ -2338,17 +2337,19 @@ relock:
 			 * first and our do_group_exit call below will use
 			 * that value and ignore the one we pass it.
 			 */
-			do_coredump(info);
+			do_coredump(&ksig->info);
 		}
 
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(info->si_signo);
+		do_group_exit(ksig->info.si_signo);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-	return signr;
+
+	ksig->sig = signr;
+	return ksig->sig > 0;
 }
 
 /**
-- 
1.8.4.5

