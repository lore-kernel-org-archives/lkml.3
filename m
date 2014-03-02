Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaCBX7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:59:37 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62410 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaCBX7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:34 -0500
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
Subject: [PATCH 25/44] Rip out get_signal_to_deliver()
Date: Mon,  3 Mar 2014 00:59:08 +0100
Message-Id: <1393804758-7916-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we can turn get_signal() to the main function.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/signal.h | 14 +-------------
 kernel/signal.c        | 23 ++++++++++++-----------
 2 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 2ac423b..33177f5 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -285,23 +285,11 @@ struct ksignal {
 	int sig;
 };
 
-extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka, struct pt_regs *regs, void *cookie);
+extern int get_signal(struct ksignal *ksig);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
 
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
index 52f881d..bd649bd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2189,8 +2189,7 @@ static int ptrace_signal(int signr, siginfo_t *info)
 	return signr;
 }
 
-int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
-			  struct pt_regs *regs, void *cookie)
+int get_signal(struct ksignal *ksig)
 {
 	struct sighand_struct *sighand = current->sighand;
 	struct signal_struct *signal = current->signal;
@@ -2260,13 +2259,13 @@ relock:
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
@@ -2274,13 +2273,13 @@ relock:
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
@@ -2330,7 +2329,7 @@ relock:
 				spin_lock_irq(&sighand->siglock);
 			}
 
-			if (likely(do_signal_stop(info->si_signo))) {
+			if (likely(do_signal_stop(ksig->info.si_signo))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
@@ -2351,7 +2350,7 @@ relock:
 
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
-				print_fatal_signal(info->si_signo);
+				print_fatal_signal(ksig->info.si_signo);
 			proc_coredump_connector(current);
 			/*
 			 * If it was able to dump core, this kills all
@@ -2361,17 +2360,19 @@ relock:
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
1.8.4.2

