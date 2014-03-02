Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaCBX5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:57:41 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62420 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaCBX5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:57:39 -0500
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
Subject: [PATCH 12/44] metag: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:57:16 +0100
Message-Id: <1393804646-7797-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804646-7797-1-git-send-email-richard@nod.at>
References: <1393804646-7797-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/metag/kernel/signal.c | 55 ++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/arch/metag/kernel/signal.c b/arch/metag/kernel/signal.c
index 3be61cf..9fa27c2 100644
--- a/arch/metag/kernel/signal.c
+++ b/arch/metag/kernel/signal.c
@@ -152,18 +152,18 @@ static void __user *get_sigframe(struct k_sigaction *ka, unsigned long sp,
 	return (void __user *)sp;
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err = -EFAULT;
+	int err;
 	unsigned long code;
 
-	frame = get_sigframe(ka, regs->REG_SP, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs->REG_SP, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto out;
+		return -EFAULT;
 
-	err = copy_siginfo_to_user(&frame->info, info);
+	err = copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -174,7 +174,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 
 	if (err)
-		goto out;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  */
 
@@ -187,15 +187,15 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __put_user(code, (unsigned long __user *)(&frame->retcode[1]));
 
 	if (err)
-		goto out;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->REG_RTP = (unsigned long) frame->retcode;
 	regs->REG_SP = (unsigned long) frame + sizeof(*frame);
-	regs->REG_ARG1 = sig;
+	regs->REG_ARG1 = ksig->sig;
 	regs->REG_ARG2 = (unsigned long) &frame->info;
 	regs->REG_ARG3 = (unsigned long) &frame->uc;
-	regs->REG_PC = (unsigned long) ka->sa.sa_handler;
+	regs->REG_PC = (unsigned long) ksig->ka.sa.sa_handler;
 
 	pr_debug("SIG deliver (%s:%d): sp=%p pc=%08x pr=%08x\n",
 		 current->comm, current->pid, frame, regs->REG_PC,
@@ -205,24 +205,19 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * effective cache flush - directed rather than 'full flush'.
 	 */
 	flush_cache_sigtramp(regs->REG_RTP, sizeof(frame->retcode));
-out:
-	if (err) {
-		force_sigsegv(sig, current);
-		return -EFAULT;
-	}
+
 	return 0;
 }
 
-static void handle_signal(unsigned long sig, siginfo_t *info,
-			  struct k_sigaction *ka, struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
+	int ret;
 
 	/* Set up the stack frame */
-	if (setup_rt_frame(sig, ka, info, oldset, regs))
-		return;
+	ret = setup_rt_frame(ksig, oldset, regs);
 
-	signal_delivered(sig, info, ka, regs, test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
  /*
@@ -235,10 +230,8 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
 static int do_signal(struct pt_regs *regs, int syscall)
 {
 	unsigned int retval = 0, continue_addr = 0, restart_addr = 0;
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
 	int restart = 0;
+	struct ksignal ksig;
 
 	/*
 	 * By the end of rt_sigreturn the context describes the point that the
@@ -272,30 +265,30 @@ static int do_signal(struct pt_regs *regs, int syscall)
 	}
 
 	/*
-	 * Get the signal to deliver. When running under ptrace, at this point
-	 * the debugger may change all our registers ...
-	 */
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	/*
 	 * Depending on the signal settings we may need to revert the decision
 	 * to restart the system call. But skip this if a debugger has chosen to
 	 * restart at a different PC.
 	 */
 	if (regs->REG_PC != restart_addr)
 		restart = 0;
-	if (signr > 0) {
+
+	/*
+	 * Get the signal to deliver. When running under ptrace, at this point
+	 * the debugger may change all our registers ...
+	 */
+	if (get_signal(&ksig)) {
 		if (unlikely(restart)) {
 			if (retval == -ERESTARTNOHAND
 			    || retval == -ERESTART_RESTARTBLOCK
 			    || (retval == -ERESTARTSYS
-				&& !(ka.sa.sa_flags & SA_RESTART))) {
+				&& !(ksig.ka.sa.sa_flags & SA_RESTART))) {
 				regs->REG_RETVAL = -EINTR;
 				regs->REG_PC = continue_addr;
 			}
 		}
 
 		/* Whee! Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return 0;
 	}
 
-- 
1.8.4.2

