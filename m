Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbaCBX6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:58:38 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62429 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbaCBX6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:58:03 -0500
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
Subject: [PATCH 21/44] tile: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:57:25 +0100
Message-Id: <1393804646-7797-11-git-send-email-richard@nod.at>
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
 arch/tile/include/asm/compat.h   |  3 +--
 arch/tile/kernel/compat_signal.c | 29 ++++++++++-----------
 arch/tile/kernel/signal.c        | 54 ++++++++++++++++++----------------------
 3 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index ffd4493..c14e36f 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -267,8 +267,7 @@ static inline int is_compat_task(void)
 	return current_thread_info()->status & TS_COMPAT;
 }
 
-extern int compat_setup_rt_frame(int sig, struct k_sigaction *ka,
-				 siginfo_t *info, sigset_t *set,
+extern int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 				 struct pt_regs *regs);
 
 /* Compat syscalls. */
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 19c04b5..8c5abf2 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -190,18 +190,18 @@ static inline void __user *compat_get_sigframe(struct k_sigaction *ka,
 	return (void __user *) sp;
 }
 
-int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	unsigned long restorer;
 	struct compat_rt_sigframe __user *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int usig;
 
-	frame = compat_get_sigframe(ka, regs, sizeof(*frame));
+	frame = compat_get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		goto err;
 
 	usig = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -210,12 +210,12 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		: sig;
 
 	/* Always write at least the signal number for the stack backtracer. */
-	if (ka->sa.sa_flags & SA_SIGINFO) {
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		/* At sigreturn time, restore the callee-save registers too. */
-		err |= copy_siginfo_to_user32(&frame->info, info);
+		err |= copy_siginfo_to_user32(&frame->info, &ksig->info);
 		regs->flags |= PT_FLAGS_RESTORE_REGS;
 	} else {
-		err |= __put_user(info->si_signo, &frame->info.si_signo);
+		err |= __put_user(ksig->info.si_signo, &frame->info.si_signo);
 	}
 
 	/* Create the ucontext.  */
@@ -226,11 +226,11 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		goto err;
 
 	restorer = VDSO_SYM(&__vdso_rt_sigreturn);
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer = ptr_to_compat_reg(ka->sa.sa_restorer);
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		restorer = ptr_to_compat_reg(ksig->ka.sa.sa_restorer);
 
 	/*
 	 * Set up registers for signal handler.
@@ -239,7 +239,7 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * We always pass siginfo and mcontext, regardless of SA_SIGINFO,
 	 * since some things rely on this (e.g. glibc's debug/segfault.c).
 	 */
-	regs->pc = ptr_to_compat_reg(ka->sa.sa_handler);
+	regs->pc = ptr_to_compat_reg(ksig->ka.sa.sa_handler);
 	regs->ex1 = PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp = ptr_to_compat_reg(frame);
 	regs->lr = restorer;
@@ -249,7 +249,8 @@ int compat_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->flags |= PT_FLAGS_CALLER_SAVES;
 	return 0;
 
-give_sigsegv:
-	signal_fault("bad setup frame", regs, frame, sig);
+err:
+	trace_unhandled_signal("bad sigreturn frame", regs,
+			      (unsigned long)frame, SIGSEGV);
 	return -EFAULT;
 }
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 2d1dbf3..27aba86 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -153,18 +153,18 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
 	return (void __user *) sp;
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	unsigned long restorer;
 	struct rt_sigframe __user *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int usig;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		goto err;
 
 	usig = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -173,12 +173,12 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		: sig;
 
 	/* Always write at least the signal number for the stack backtracer. */
-	if (ka->sa.sa_flags & SA_SIGINFO) {
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		/* At sigreturn time, restore the callee-save registers too. */
-		err |= copy_siginfo_to_user(&frame->info, info);
+		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 		regs->flags |= PT_FLAGS_RESTORE_REGS;
 	} else {
-		err |= __put_user(info->si_signo, &frame->info.si_signo);
+		err |= __put_user(ksig->info.si_signo, &frame->info.si_signo);
 	}
 
 	/* Create the ucontext.  */
@@ -189,11 +189,11 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= setup_sigcontext(&frame->uc.uc_mcontext, regs);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		goto err;
 
 	restorer = VDSO_SYM(&__vdso_rt_sigreturn);
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer = (unsigned long) ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		restorer = (unsigned long) ksig->ka.sa.sa_restorer;
 
 	/*
 	 * Set up registers for signal handler.
@@ -202,7 +202,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * We always pass siginfo and mcontext, regardless of SA_SIGINFO,
 	 * since some things rely on this (e.g. glibc's debug/segfault.c).
 	 */
-	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
 	regs->ex1 = PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp = (unsigned long) frame;
 	regs->lr = restorer;
@@ -212,8 +212,9 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->flags |= PT_FLAGS_CALLER_SAVES;
 	return 0;
 
-give_sigsegv:
-	signal_fault("bad setup frame", regs, frame, sig);
+err:
+	trace_unhandled_signal("bad sigreturn frame", regs,
+			      (unsigned long)frame, SIGSEGV);
 	return -EFAULT;
 }
 
@@ -221,9 +222,7 @@ give_sigsegv:
  * OK, we're invoking a handler
  */
 
-static void handle_signal(unsigned long sig, siginfo_t *info,
-			 struct k_sigaction *ka,
-			 struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
@@ -238,7 +237,7 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
 			break;
 
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->regs[0] = -EINTR;
 				break;
 			}
@@ -254,14 +253,12 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
 	/* Set up the stack frame */
 #ifdef CONFIG_COMPAT
 	if (is_compat_task())
-		ret = compat_setup_rt_frame(sig, ka, info, oldset, regs);
+		ret = compat_setup_rt_frame(ksig, oldset, regs);
 	else
 #endif
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
-	if (ret)
-		return;
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+		ret = setup_rt_frame(ksig, oldset, regs);
+
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 /*
@@ -271,9 +268,7 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
  */
 void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * i386 will check if we're coming from kernel mode and bail out
@@ -282,10 +277,9 @@ void do_signal(struct pt_regs *regs)
 	 * helpful, we can reinstate the check on "!user_mode(regs)".
 	 */
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		goto done;
 	}
 
-- 
1.8.4.2

