Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaCCABj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:01:39 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62426 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaCCABc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:32 -0500
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
Subject: [PATCH 41/44] unicore32: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:41 +0100
Message-Id: <1393804844-8008-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804844-8008-1-git-send-email-richard@nod.at>
References: <1393804844-8008-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/unicore32/kernel/signal.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index 780d773..7b48572 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -11,7 +11,6 @@
  */
 #include <linux/errno.h>
 #include <linux/signal.h>
-#include <linux/personality.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
 #include <linux/elf.h>
@@ -211,13 +210,9 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
 	return frame;
 }
 
-static int setup_return(struct pt_regs *regs, struct k_sigaction *ka,
-	     unsigned long __user *rc, void __user *frame, int usig)
+static int setup_return(struct ksignal *ksig, struct pt_regs *regs,
+			unsigned long __user *rc, void __user *frame)
 {
-	unsigned long handler = (unsigned long)ka->sa.sa_handler;
-	unsigned long retcode;
-	unsigned long asr = regs->UCreg_asr & ~PSR_f;
-
 	unsigned int idx = 0;
 
 	if (ka->sa.sa_flags & SA_SIGINFO)
@@ -227,13 +222,11 @@ static int setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 	    __put_user(sigreturn_codes[idx+1], rc+1))
 		return 1;
 
-	retcode = KERN_SIGRETURN_CODE + (idx << 2);
-
-	regs->UCreg_00 = usig;
+	regs->UCreg_00 = translate_signal(ksig->sig);
 	regs->UCreg_sp = (unsigned long)frame;
-	regs->UCreg_lr = retcode;
-	regs->UCreg_pc = handler;
-	regs->UCreg_asr = asr;
+	regs->UCreg_lr = KERN_SIGRETURN_CODE + (idx << 2);
+	regs->UCreg_pc = (unsigned long)ksig->ka.sa.sa_handler;
+	regs->UCreg_asr = regs->UCreg_asr & ~PSR_f;
 
 	return 0;
 }
@@ -254,7 +247,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 
 	err |= setup_sigframe(frame, regs, set);
 	if (err == 0)
-		err |= setup_return(regs, &ksig->ka, frame->retcode, frame, usig);
+		err |= setup_return(ksig, regs, frame->retcode, frame);
 
 	return err;
 }
@@ -276,7 +269,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	err |= __save_altstack(&frame->sig.uc.uc_stack, regs->UCreg_sp);
 	err |= setup_sigframe(&frame->sig, regs, set);
 	if (err == 0)
-		err |= setup_return(regs, &ksig->ka, frame->sig.retcode, frame, usig);
+		err |= setup_return(ksig, regs, frame->sig.retcode, frame);
 
 	if (err == 0) {
 		/*
@@ -305,7 +298,6 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs,
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = current;
 	sigset_t *oldset = sigmask_to_save();
-	int usig = ksig->sig;
 	int ret;
 
 	/*
@@ -329,13 +321,6 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs,
 	}
 
 	/*
-	 * translate the signal
-	 */
-	if (usig < 32 && thread->exec_domain
-			&& thread->exec_domain->signal_invmap)
-		usig = thread->exec_domain->signal_invmap[usig];
-
-	/*
 	 * Set up the stack frame
 	 */
 	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
-- 
1.8.4.2

