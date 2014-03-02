Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaCBX4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:56:40 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62410 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaCBX4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:56:32 -0500
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
Subject: [PATCH 02/44] arm64: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:55:51 +0100
Message-Id: <1393804559-7701-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804559-7701-1-git-send-email-richard@nod.at>
References: <1393804559-7701-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arm64/include/asm/signal32.h |  7 +++---
 arch/arm64/kernel/signal.c        | 48 ++++++++++++++++-----------------------
 arch/arm64/kernel/signal32.c      |  8 +++----
 3 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/signal32.h b/arch/arm64/include/asm/signal32.h
index 7c275e3..db544f1 100644
--- a/arch/arm64/include/asm/signal32.h
+++ b/arch/arm64/include/asm/signal32.h
@@ -26,8 +26,8 @@ extern const compat_ulong_t aarch32_sigret_code[6];
 
 int compat_setup_frame(int usig, struct k_sigaction *ka, sigset_t *set,
 		       struct pt_regs *regs);
-int compat_setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs);
+int compat_setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs);
 
 void compat_setup_restart_syscall(struct pt_regs *regs);
 #else
@@ -38,8 +38,7 @@ static inline int compat_setup_frame(int usid, struct k_sigaction *ka,
 	return -ENOSYS;
 }
 
-static inline int compat_setup_rt_frame(int usig, struct k_sigaction *ka,
-					siginfo_t *info, sigset_t *set,
+static inline int compat_setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
 					struct pt_regs *regs)
 {
 	return -ENOSYS;
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 890a591..f6f23dd 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -239,13 +239,13 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 	regs->regs[30] = (unsigned long)sigtramp;
 }
 
-static int setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs);
+	frame = get_sigframe(&ksig->ka, regs);
 	if (!frame)
 		return 1;
 
@@ -255,9 +255,9 @@ static int setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __save_altstack(&frame->uc.uc_stack, regs->sp);
 	err |= setup_sigframe(frame, regs, set);
 	if (err == 0) {
-		setup_return(regs, ka, frame, usig);
-		if (ka->sa.sa_flags & SA_SIGINFO) {
-			err |= copy_siginfo_to_user(&frame->info, info);
+		setup_return(regs, &ksig->ka, frame, usig);
+		if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
+			err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 			regs->regs[1] = (unsigned long)&frame->info;
 			regs->regs[2] = (unsigned long)&frame->uc;
 		}
@@ -277,13 +277,12 @@ static void setup_restart_syscall(struct pt_regs *regs)
 /*
  * OK, we're invoking a handler
  */
-static void handle_signal(unsigned long sig, struct k_sigaction *ka,
-			  siginfo_t *info, struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = current;
 	sigset_t *oldset = sigmask_to_save();
-	int usig = sig;
+	int usig = ksig->sig;
 	int ret;
 
 	/*
@@ -296,13 +295,12 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 	 * Set up the stack frame
 	 */
 	if (is_compat_task()) {
-		if (ka->sa.sa_flags & SA_SIGINFO)
-			ret = compat_setup_rt_frame(usig, ka, info, oldset,
-						    regs);
+		if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+			ret = compat_setup_rt_frame(usig, ksig, oldset, regs);
 		else
-			ret = compat_setup_frame(usig, ka, oldset, regs);
+			ret = compat_setup_frame(usig, &ksig->ka, oldset, regs);
 	} else {
-		ret = setup_rt_frame(usig, ka, info, oldset, regs);
+		ret = setup_rt_frame(usig, ksig, oldset, regs);
 	}
 
 	/*
@@ -310,18 +308,14 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 	 */
 	ret |= !valid_user_regs(&regs->user_regs);
 
-	if (ret != 0) {
-		force_sigsegv(sig, tsk);
-		return;
-	}
-
 	/*
 	 * Fast forward the stepping logic so we step into the signal
 	 * handler.
 	 */
-	user_fastforward_single_step(tsk);
+	if (!ret)
+		user_fastforward_single_step(tsk);
 
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 /*
@@ -336,10 +330,9 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 static void do_signal(struct pt_regs *regs)
 {
 	unsigned long continue_addr = 0, restart_addr = 0;
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr, retval = 0;
+	int retval = 0;
 	int syscall = (int)regs->syscallno;
+	struct ksignal ksig;
 
 	/*
 	 * If we were from a system call, check for system call restarting...
@@ -373,8 +366,7 @@ static void do_signal(struct pt_regs *regs)
 	 * Get the signal to deliver. When running under ptrace, at this point
 	 * the debugger may change all of our registers.
 	 */
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/*
 		 * Depending on the signal settings, we may need to revert the
 		 * decision to restart the system call, but skip this if a
@@ -384,12 +376,12 @@ static void do_signal(struct pt_regs *regs)
 		    (retval == -ERESTARTNOHAND ||
 		     retval == -ERESTART_RESTARTBLOCK ||
 		     (retval == -ERESTARTSYS &&
-		      !(ka.sa.sa_flags & SA_RESTART)))) {
+		      !(ksig.ka.sa.sa_flags & SA_RESTART)))) {
 			regs->regs[0] = -EINTR;
 			regs->pc = continue_addr;
 		}
 
-		handle_signal(signr, &ka, &info, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
 
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index b3fc9f5..cee5fd6 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -518,18 +518,18 @@ static int compat_setup_sigframe(struct compat_sigframe __user *sf,
 /*
  * 32-bit signal handling routines called from signal.c
  */
-int compat_setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
+int compat_setup_rt_frame(int usig, struct ksignal *ksig,
 			  sigset_t *set, struct pt_regs *regs)
 {
 	struct compat_rt_sigframe __user *frame;
 	int err = 0;
 
-	frame = compat_get_sigframe(ka, regs, sizeof(*frame));
+	frame = compat_get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!frame)
 		return 1;
 
-	err |= copy_siginfo_to_user32(&frame->info, info);
+	err |= copy_siginfo_to_user32(&frame->info, &ksig->info);
 
 	__put_user_error(0, &frame->sig.uc.uc_flags, err);
 	__put_user_error(0, &frame->sig.uc.uc_link, err);
@@ -539,7 +539,7 @@ int compat_setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
 	err |= compat_setup_sigframe(&frame->sig, regs, set);
 
 	if (err == 0) {
-		compat_setup_return(regs, ka, frame->sig.retcode, frame, usig);
+		compat_setup_return(regs, &ksig->ka, frame->sig.retcode, frame, usig);
 		regs->regs[1] = (compat_ulong_t)(unsigned long)&frame->info;
 		regs->regs[2] = (compat_ulong_t)(unsigned long)&frame->sig.uc;
 	}
-- 
1.8.4.2

