Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3AXKxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:53:04 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:33765 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3AXKwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:52:38 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v3 22/71] ARC: [Review] Prevent incorrect syscall restarts
Date: Thu, 24 Jan 2013 16:20:24 +0530
Message-ID: <1359024639-21915-11-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per Al Viro's "signals for dummies" https://lkml.org/lkml/2012/12/6/366
there are 3 golden rules for (not) restarting syscalls:

"	What we need to guarantee is
* restarts do not happen on signals caught in interrupts or exceptions
* restarts do not happen on signals caught in sigreturn()
* restart should happen only once, even if we get through do_signal()
  many times."

ARC Port already handled #1, this patch fixes #2 and #3.

We use the additional state in pt_regs->orig_r8 to ckh if restarting
has already been done once.

Thanks to Al Viro for spotting this.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 arch/arc/include/asm/ptrace.h |    3 +++
 arch/arc/kernel/signal.c      |   12 ++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arc/include/asm/ptrace.h b/arch/arc/include/asm/ptrace.h
index 1711d56..8bf7ff4 100644
--- a/arch/arc/include/asm/ptrace.h
+++ b/arch/arc/include/asm/ptrace.h
@@ -135,6 +135,9 @@ struct user_regs_struct {
 #define in_syscall(regs)    (regs->event & orig_r8_IS_SCALL)
 #define in_brkpt_trap(regs) (regs->event & orig_r8_IS_BRKPT)
 
+#define syscall_wont_restart(regs) (regs->event |= orig_r8_IS_SCALL_RESTARTED)
+#define syscall_restartable(regs) !(regs->event &  orig_r8_IS_SCALL_RESTARTED)
+
 #define current_pt_regs()					\
 ({								\
 	/* open-coded current_thread_info() */			\
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index 887a383..9a1ea2b 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -131,6 +131,9 @@ SYSCALL_DEFINE0(rt_sigreturn)
 		if (restore_altstack(&sf->uc.uc_stack))
 			goto badframe;
 
+	/* Don't restart from sigreturn */
+	syscall_wont_restart(regs);
+
 	return regs->r0;
 
 badframe:
@@ -321,13 +324,13 @@ void do_signal(struct pt_regs *regs)
 
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 
-	/* Are we from a system call? */
-	restart_scall = in_syscall(regs);
+	restart_scall = in_syscall(regs) && syscall_restartable(regs);
 
 	if (signr > 0) {
-		if (restart_scall)
+		if (restart_scall) {
 			arc_restart_syscall(&ka, regs);
-
+			syscall_wont_restart(regs);	/* No more restarts */
+		}
 		handle_signal(signr, &ka, &info, regs);
 		return;
 	}
@@ -342,6 +345,7 @@ void do_signal(struct pt_regs *regs)
 			regs->r8 = __NR_restart_syscall;
 			regs->ret -= 4;
 		}
+		syscall_wont_restart(regs);	/* No more restarts */
 	}
 
 	/* If there's no signal to deliver, restore the saved sigmask back */
-- 
1.7.4.1

