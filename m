Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaCBX6E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:58:04 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62428 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaCBX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:58:00 -0500
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
Subject: [PATCH 20/44] sh: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:57:24 +0100
Message-Id: <1393804646-7797-10-git-send-email-richard@nod.at>
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
 arch/sh/kernel/signal_32.c | 79 ++++++++++++++++++--------------------------
 arch/sh/kernel/signal_64.c | 82 ++++++++++++++++++----------------------------
 2 files changed, 64 insertions(+), 97 deletions(-)

diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 6af6e7c..2ee67c5 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -266,17 +266,17 @@ get_sigframe(struct k_sigaction *ka, unsigned long sp, size_t frame_size)
 extern void __kernel_sigreturn(void);
 extern void __kernel_rt_sigreturn(void);
 
-static int setup_frame(int sig, struct k_sigaction *ka,
-			sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+		       struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int signal;
 
-	frame = get_sigframe(ka, regs->regs[15], sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs->regs[15], sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	signal = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -292,8 +292,8 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->pr = (unsigned long) ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		regs->pr = (unsigned long) ksig->ka.sa.sa_restorer;
 #ifdef CONFIG_VSYSCALL
 	} else if (likely(current->mm->context.vdso)) {
 		regs->pr = VDSO_SYM(&__kernel_sigreturn);
@@ -313,7 +313,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	}
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->regs[15] = (unsigned long) frame;
@@ -323,15 +323,15 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
-			(struct fdpic_func_descriptor __user *)ka->sa.sa_handler;
+			(struct fdpic_func_descriptor __user *)ksig->ka.sa.sa_handler;
 
 		err |= __get_user(regs->pc, &funcptr->text);
 		err |= __get_user(regs->regs[12], &funcptr->GOT);
 	} else
-		regs->pc = (unsigned long)ka->sa.sa_handler;
+		regs->pc = (unsigned long)ksig->ka.sa.sa_handler;
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	set_fs(USER_DS);
 
@@ -339,23 +339,19 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 		 current->comm, task_pid_nr(current), frame, regs->pc, regs->pr);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int signal;
 
-	frame = get_sigframe(ka, regs->regs[15], sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs->regs[15], sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	signal = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -363,7 +359,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		? current_thread_info()->exec_domain->signal_invmap[sig]
 		: sig;
 
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -375,8 +371,8 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->pr = (unsigned long) ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		regs->pr = (unsigned long) ksig->ka.sa.sa_restorer;
 #ifdef CONFIG_VSYSCALL
 	} else if (likely(current->mm->context.vdso)) {
 		regs->pr = VDSO_SYM(&__kernel_rt_sigreturn);
@@ -396,7 +392,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->regs[15] = (unsigned long) frame;
@@ -406,15 +402,15 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
-			(struct fdpic_func_descriptor __user *)ka->sa.sa_handler;
+			(struct fdpic_func_descriptor __user *)ksig->ka.sa.sa_handler;
 
 		err |= __get_user(regs->pc, &funcptr->text);
 		err |= __get_user(regs->regs[12], &funcptr->GOT);
 	} else
-		regs->pc = (unsigned long)ka->sa.sa_handler;
+		regs->pc = (unsigned long)ksig->ka.sa.sa_handler;
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	set_fs(USER_DS);
 
@@ -422,10 +418,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		 current->comm, task_pid_nr(current), frame, regs->pc, regs->pr);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 static inline void
@@ -459,22 +451,18 @@ handle_syscall_restart(unsigned long save_r0, struct pt_regs *regs,
  * OK, we're invoking a handler
  */
 static void
-handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	      struct pt_regs *regs, unsigned int save_r0)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs, unsigned int save_r0)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset, regs);
 	else
-		ret = setup_frame(sig, ka, oldset, regs);
+		ret = setup_frame(ksig, oldset, regs);
 
-	if (ret)
-		return;
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 /*
@@ -488,9 +476,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
  */
 static void do_signal(struct pt_regs *regs, unsigned int save_r0)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * We want the common case to go fast, which
@@ -501,12 +487,11 @@ static void do_signal(struct pt_regs *regs, unsigned int save_r0)
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		handle_syscall_restart(save_r0, regs, &ka.sa);
+	if (get_signal(&ksig)) {
+		handle_syscall_restart(save_r0, regs, &ksig.ka.sa);
 
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &ka, &info, regs, save_r0);
+		handle_signal(&ksig, regs, save_r0);
 		return;
 	}
 
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 23d4c71..897abe7 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -41,8 +41,7 @@
 #define DEBUG_SIG 0
 
 static void
-handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-		struct pt_regs * regs);
+handle_signal(struct ksignal *ksig, struct pt_regs *regs);
 
 static inline void
 handle_syscall_restart(struct pt_regs *regs, struct sigaction *sa)
@@ -82,9 +81,7 @@ handle_syscall_restart(struct pt_regs *regs, struct sigaction *sa)
  */
 static void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * We want the common case to go fast, which
@@ -95,12 +92,11 @@ static void do_signal(struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, 0);
-	if (signr > 0) {
-		handle_syscall_restart(regs, &ka.sa);
+	if (get_signal(&ksig)) {
+		handle_syscall_restart(regs, &ksig.ka.sa);
 
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
 
@@ -378,17 +374,16 @@ get_sigframe(struct k_sigaction *ka, unsigned long sp, size_t frame_size)
 void sa_default_restorer(void);		/* See comments below */
 void sa_default_rt_restorer(void);	/* See comments below */
 
-static int setup_frame(int sig, struct k_sigaction *ka,
-		       sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int signal;
 
-	frame = get_sigframe(ka, regs->regs[REG_SP], sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs->regs[REG_SP], sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	signal = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -400,7 +395,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 
 	/* Give up earlier as i386, in case */
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
 		err |= __copy_to_user(frame->extramask, &set->sig[1],
@@ -408,16 +403,16 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 
 	/* Give up earlier as i386, in case */
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
 		/*
 		 * On SH5 all edited pointers are subject to NEFF
 		 */
 		DEREF_REG_PR = neff_sign_extend((unsigned long)
-			ka->sa.sa_restorer | 0x1);
+			ksig->ka->sa.sa_restorer | 0x1);
 	} else {
 		/*
 		 * Different approach on SH5.
@@ -435,7 +430,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 
 		if (__copy_to_user(frame->retcode,
 			(void *)((unsigned long)sa_default_restorer & (~1)), 16) != 0)
-			goto give_sigsegv;
+			return -EFAULT;
 
 		/* Cohere the trampoline with the I-cache. */
 		flush_cache_sigtramp(DEREF_REG_PR-1);
@@ -460,7 +455,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	regs->regs[REG_ARG2] = (unsigned long long)(unsigned long)(signed long)&frame->sc;
 	regs->regs[REG_ARG3] = (unsigned long long)(unsigned long)(signed long)&frame->sc;
 
-	regs->pc = neff_sign_extend((unsigned long)ka->sa.sa_handler);
+	regs->pc = neff_sign_extend((unsigned long)ksig->ka.sa.sa_handler);
 
 	set_fs(USER_DS);
 
@@ -471,23 +466,19 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 		 DEREF_REG_PR >> 32, DEREF_REG_PR & 0xffffffff);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *kig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int signal;
 
-	frame = get_sigframe(ka, regs->regs[REG_SP], sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs->regs[REG_SP], sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	signal = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -497,11 +488,11 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Give up earlier as i386, in case */
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -513,16 +504,16 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Give up earlier as i386, in case */
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
 		/*
 		 * On SH5 all edited pointers are subject to NEFF
 		 */
 		DEREF_REG_PR = neff_sign_extend((unsigned long)
-			ka->sa.sa_restorer | 0x1);
+			ksig->ka.sa.sa_restorer | 0x1);
 	} else {
 		/*
 		 * Different approach on SH5.
@@ -540,7 +531,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 		if (__copy_to_user(frame->retcode,
 			(void *)((unsigned long)sa_default_rt_restorer & (~1)), 16) != 0)
-			goto give_sigsegv;
+			return -EFAULT;
 
 		/* Cohere the trampoline with the I-cache. */
 		flush_icache_range(DEREF_REG_PR-1, DEREF_REG_PR-1+15);
@@ -554,7 +545,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->regs[REG_ARG1] = signal; /* Arg for signal handler */
 	regs->regs[REG_ARG2] = (unsigned long long)(unsigned long)(signed long)&frame->info;
 	regs->regs[REG_ARG3] = (unsigned long long)(unsigned long)(signed long)&frame->uc.uc_mcontext;
-	regs->pc = neff_sign_extend((unsigned long)ka->sa.sa_handler);
+	regs->pc = neff_sign_extend((unsigned long)ksig->ka.sa.sa_handler);
 
 	set_fs(USER_DS);
 
@@ -564,33 +555,24 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		 DEREF_REG_PR >> 32, DEREF_REG_PR & 0xffffffff);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler
  */
 static void
-handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-		struct pt_regs * regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset, regs);
 	else
-		ret = setup_frame(sig, ka, oldset, regs);
-
-	if (ret)
-		return;
+		ret = setup_frame(ksig, oldset, regs);
 
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 asmlinkage void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
-- 
1.8.4.2

