Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3JHLgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:36:47 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756684Ab3JHLgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:36:42 -0400
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
Subject: [PATCH 29/29] Clean up signal_delivered()
Date: Tue,  8 Oct 2013 13:36:19 +0200
Message-Id: <1381232179-4385-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381232179-4385-1-git-send-email-richard@nod.at>
References: <1381232179-4385-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Pass a ksignal struct to it
- Remove unused regs parameter
- Make it private as it's nowhere outside of kernel/signal.c is used

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/linux/signal.h |  1 -
 kernel/signal.c        | 21 ++++++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index 735e0a3..a66ac6c 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -287,7 +287,6 @@ struct ksignal {
 
 extern int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka);
 extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
-extern void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka, struct pt_regs *regs, int stepping);
 extern void exit_signals(struct task_struct *tsk);
 
 /*
diff --git a/kernel/signal.c b/kernel/signal.c
index 38d46e2..8c95fb9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2375,19 +2375,15 @@ relock:
 
 /**
  * signal_delivered - 
- * @sig:		number of signal being delivered
- * @info:		siginfo_t of signal being delivered
- * @ka:			sigaction setting that chose the handler
- * @regs:		user register state
+ * @ksig:		kernel signal struct
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
  * This function should be called when a signal has succesfully been
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
 
@@ -2397,9 +2393,9 @@ void signal_delivered(int sig, siginfo_t *info, struct k_sigaction *ka,
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
@@ -2409,8 +2405,7 @@ void signal_setup_done(int failed, struct ksignal *ksig, int stepping)
 	if (failed)
 		force_sigsegv(ksig->sig, current);
 	else
-		signal_delivered(ksig->sig, &ksig->info, &ksig->ka,
-			signal_pt_regs(), stepping);
+		signal_delivered(ksig, stepping);
 }
 
 /*
-- 
1.8.1.4

