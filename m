Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbaGUOEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:04:22 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14401 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbaGUOEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:04:11 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, benh@kernel.crashing.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 16/43] powerpc: Use get_signal() signal_setup_done()
Date: Mon, 21 Jul 2014 16:03:02 +0200
Message-Id: <1405951409-16953-17-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.
This inverts also the return codes of setup_*frame() to follow the
kernel convention.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/powerpc/kernel/signal.c    | 31 +++++++++++--------------------
 arch/powerpc/kernel/signal.h    | 14 +++++---------
 arch/powerpc/kernel/signal_32.c | 36 ++++++++++++++++--------------------
 arch/powerpc/kernel/signal_64.c | 28 +++++++++++++---------------
 4 files changed, 45 insertions(+), 64 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 1c794ce..aa9b048 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -105,25 +105,23 @@ static void check_syscall_restart(struct pt_regs *regs, struct k_sigaction *ka,
 	}
 }
 
-static int do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 	int ret;
 	int is32 = is_32bit_task();
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+	get_signal(&ksig);
 
 	/* Is there any syscall restart business here ? */
-	check_syscall_restart(regs, &ka, signr > 0);
+	check_syscall_restart(regs, &ksig.ka, ksig.sig > 0);
 
-	if (signr <= 0) {
+	if (ksig.sig <= 0) {
 		/* No signal to deliver -- put the saved sigmask back */
 		restore_saved_sigmask();
 		regs->trap = 0;
-		return 0;               /* no signals delivered */
+		return;               /* no signals delivered */
 	}
 
 #ifndef CONFIG_PPC_ADV_DEBUG_REGS
@@ -140,23 +138,16 @@ static int do_signal(struct pt_regs *regs)
 	thread_change_pc(current, regs);
 
 	if (is32) {
-        	if (ka.sa.sa_flags & SA_SIGINFO)
-			ret = handle_rt_signal32(signr, &ka, &info, oldset,
-					regs);
+        	if (ksig.ka.sa.sa_flags & SA_SIGINFO)
+			ret = handle_rt_signal32(&ksig, oldset, regs);
 		else
-			ret = handle_signal32(signr, &ka, &info, oldset,
-					regs);
+			ret = handle_signal32(&ksig, oldset, regs);
 	} else {
-		ret = handle_rt_signal64(signr, &ka, &info, oldset, regs);
+		ret = handle_rt_signal64(&ksig, oldset, regs);
 	}
 
 	regs->trap = 0;
-	if (ret) {
-		signal_delivered(signr, &info, &ka, regs,
-					 test_thread_flag(TIF_SINGLESTEP));
-	}
-
-	return ret;
+	signal_setup_done(ret, &ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
diff --git a/arch/powerpc/kernel/signal.h b/arch/powerpc/kernel/signal.h
index c69b9ae..51b2741 100644
--- a/arch/powerpc/kernel/signal.h
+++ b/arch/powerpc/kernel/signal.h
@@ -12,15 +12,13 @@
 
 extern void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags);
 
-extern void __user * get_sigframe(struct k_sigaction *ka, unsigned long sp,
+extern void __user *get_sigframe(struct ksignal *ksig, unsigned long sp,
 				  size_t frame_size, int is_32);
 
-extern int handle_signal32(unsigned long sig, struct k_sigaction *ka,
-			   siginfo_t *info, sigset_t *oldset,
+extern int handle_signal32(struct ksignal *ksig, sigset_t *oldset,
 			   struct pt_regs *regs);
 
-extern int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
-			      siginfo_t *info, sigset_t *oldset,
+extern int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
 			      struct pt_regs *regs);
 
 extern unsigned long copy_fpr_to_user(void __user *to,
@@ -44,14 +42,12 @@ extern unsigned long copy_transact_vsx_from_user(struct task_struct *task,
 
 #ifdef CONFIG_PPC64
 
-extern int handle_rt_signal64(int signr, struct k_sigaction *ka,
-			      siginfo_t *info, sigset_t *set,
+extern int handle_rt_signal64(struct ksignal *ksig, sigset_t *set,
 			      struct pt_regs *regs);
 
 #else /* CONFIG_PPC64 */
 
-static inline int handle_rt_signal64(int signr, struct k_sigaction *ka,
-				     siginfo_t *info, sigset_t *set,
+static inline int handle_rt_signal64(struct ksignal *ksig, sigset_t *set,
 				     struct pt_regs *regs)
 {
 	return -EFAULT;
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 1bc5a17..aa0af88 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -981,9 +981,8 @@ int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from)
  * Set up a signal frame for a "real-time" signal handler
  * (one which gets siginfo).
  */
-int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
-		siginfo_t *info, sigset_t *oldset,
-		struct pt_regs *regs)
+int handle_rt_signal32(struct ksignal *ksig, sigset_t *oldset,
+		       struct pt_regs *regs)
 {
 	struct rt_sigframe __user *rt_sf;
 	struct mcontext __user *frame;
@@ -995,13 +994,13 @@ int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
 
 	/* Set up Signal Frame */
 	/* Put a Real Time Context onto stack */
-	rt_sf = get_sigframe(ka, get_tm_stackpointer(regs), sizeof(*rt_sf), 1);
+	rt_sf = get_sigframe(&ksig->ka, get_tm_stackpointer(regs), sizeof(*rt_sf), 1);
 	addr = rt_sf;
 	if (unlikely(rt_sf == NULL))
 		goto badframe;
 
 	/* Put the siginfo & fill in most of the ucontext */
-	if (copy_siginfo_to_user(&rt_sf->info, info)
+	if (copy_siginfo_to_user(&rt_sf->info, &ksig->info)
 	    || __put_user(0, &rt_sf->uc.uc_flags)
 	    || __save_altstack(&rt_sf->uc.uc_stack, regs->gpr[1])
 	    || __put_user(to_user_ptr(&rt_sf->uc.uc_mcontext),
@@ -1051,15 +1050,15 @@ int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
 
 	/* Fill registers for signal handler */
 	regs->gpr[1] = newsp;
-	regs->gpr[3] = sig;
+	regs->gpr[3] = ksig->sig;
 	regs->gpr[4] = (unsigned long) &rt_sf->info;
 	regs->gpr[5] = (unsigned long) &rt_sf->uc;
 	regs->gpr[6] = (unsigned long) rt_sf;
-	regs->nip = (unsigned long) ka->sa.sa_handler;
+	regs->nip = (unsigned long) ksig->ka.sa.sa_handler;
 	/* enter the signal handler in native-endian mode */
 	regs->msr &= ~MSR_LE;
 	regs->msr |= (MSR_KERNEL & MSR_LE);
-	return 1;
+	return 0;
 
 badframe:
 	if (show_unhandled_signals)
@@ -1069,8 +1068,7 @@ badframe:
 				   current->comm, current->pid,
 				   addr, regs->nip, regs->link);
 
-	force_sigsegv(sig, current);
-	return 0;
+	return 1;
 }
 
 static int do_setcontext(struct ucontext __user *ucp, struct pt_regs *regs, int sig)
@@ -1409,8 +1407,7 @@ int sys_debug_setcontext(struct ucontext __user *ctx,
 /*
  * OK, we're invoking a handler
  */
-int handle_signal32(unsigned long sig, struct k_sigaction *ka,
-		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
+int handle_signal32(struct ksignal *ksig, sigset_t *oldset, struct pt_regs *regs)
 {
 	struct sigcontext __user *sc;
 	struct sigframe __user *frame;
@@ -1420,7 +1417,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 	unsigned long tramp;
 
 	/* Set up Signal Frame */
-	frame = get_sigframe(ka, get_tm_stackpointer(regs), sizeof(*frame), 1);
+	frame = get_sigframe(&ksig->ka, get_tm_stackpointer(regs), sizeof(*frame), 1);
 	if (unlikely(frame == NULL))
 		goto badframe;
 	sc = (struct sigcontext __user *) &frame->sctx;
@@ -1428,7 +1425,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 #if _NSIG != 64
 #error "Please adjust handle_signal()"
 #endif
-	if (__put_user(to_user_ptr(ka->sa.sa_handler), &sc->handler)
+	if (__put_user(to_user_ptr(ksig->ka.sa.sa_handler), &sc->handler)
 	    || __put_user(oldset->sig[0], &sc->oldmask)
 #ifdef CONFIG_PPC64
 	    || __put_user((oldset->sig[0] >> 32), &sc->_unused[3])
@@ -1436,7 +1433,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 	    || __put_user(oldset->sig[1], &sc->_unused[3])
 #endif
 	    || __put_user(to_user_ptr(&frame->mctx), &sc->regs)
-	    || __put_user(sig, &sc->signal))
+	    || __put_user(ksig->sig, &sc->signal))
 		goto badframe;
 
 	if (vdso32_sigtramp && current->mm->context.vdso_base) {
@@ -1471,12 +1468,12 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 		goto badframe;
 
 	regs->gpr[1] = newsp;
-	regs->gpr[3] = sig;
+	regs->gpr[3] = ksig->sig;
 	regs->gpr[4] = (unsigned long) sc;
-	regs->nip = (unsigned long) ka->sa.sa_handler;
+	regs->nip = (unsigned long) (unsigned long)ksig->ka.sa.sa_handler;
 	/* enter the signal handler in big-endian mode */
 	regs->msr &= ~MSR_LE;
-	return 1;
+	return 0;
 
 badframe:
 	if (show_unhandled_signals)
@@ -1486,8 +1483,7 @@ badframe:
 				   current->comm, current->pid,
 				   frame, regs->nip, regs->link);
 
-	force_sigsegv(sig, current);
-	return 0;
+	return 1;
 }
 
 /*
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index 97c1e4b..115d110 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -708,20 +708,19 @@ badframe:
 	return 0;
 }
 
-int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
-		sigset_t *set, struct pt_regs *regs)
+int handle_rt_signal64(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long newsp = 0;
 	long err = 0;
 
-	frame = get_sigframe(ka, get_tm_stackpointer(regs), sizeof(*frame), 0);
+	frame = get_sigframe(&ksig->ka, get_tm_stackpointer(regs), sizeof(*frame), 0);
 	if (unlikely(frame == NULL))
 		goto badframe;
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 	if (err)
 		goto badframe;
 
@@ -736,15 +735,15 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
 		err |= __put_user(&frame->uc_transact, &frame->uc.uc_link);
 		err |= setup_tm_sigcontexts(&frame->uc.uc_mcontext,
 					    &frame->uc_transact.uc_mcontext,
-					    regs, signr,
+					    regs, ksig->sig,
 					    NULL,
-					    (unsigned long)ka->sa.sa_handler);
+					    (unsigned long)ksig->ka.sa.sa_handler);
 	} else
 #endif
 	{
 		err |= __put_user(0, &frame->uc.uc_link);
-		err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, signr,
-					NULL, (unsigned long)ka->sa.sa_handler,
+		err |= setup_sigcontext(&frame->uc.uc_mcontext, regs, ksig->sig,
+					NULL, (unsigned long)ksig->ka.sa.sa_handler,
 					1);
 	}
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
@@ -770,7 +769,7 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up "regs" so we "return" to the signal handler. */
 	if (is_elf2_task()) {
-		regs->nip = (unsigned long) ka->sa.sa_handler;
+		regs->nip = (unsigned long) ksig->ka.sa.sa_handler;
 		regs->gpr[12] = regs->nip;
 	} else {
 		/* Handler is *really* a pointer to the function descriptor for
@@ -779,7 +778,7 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
 		 * entry is the TOC value we need to use.
 		 */
 		func_descr_t __user *funct_desc_ptr =
-			(func_descr_t __user *) ka->sa.sa_handler;
+			(func_descr_t __user *) ksig->ka.sa.sa_handler;
 
 		err |= get_user(regs->nip, &funct_desc_ptr->entry);
 		err |= get_user(regs->gpr[2], &funct_desc_ptr->toc);
@@ -789,9 +788,9 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
 	regs->msr &= ~MSR_LE;
 	regs->msr |= (MSR_KERNEL & MSR_LE);
 	regs->gpr[1] = newsp;
-	regs->gpr[3] = signr;
+	regs->gpr[3] = ksig->sig;
 	regs->result = 0;
-	if (ka->sa.sa_flags & SA_SIGINFO) {
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		err |= get_user(regs->gpr[4], (unsigned long __user *)&frame->pinfo);
 		err |= get_user(regs->gpr[5], (unsigned long __user *)&frame->puc);
 		regs->gpr[6] = (unsigned long) frame;
@@ -801,7 +800,7 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		goto badframe;
 
-	return 1;
+	return 0;
 
 badframe:
 	if (show_unhandled_signals)
@@ -809,6 +808,5 @@ badframe:
 				   current->comm, current->pid, "setup_rt_frame",
 				   (long)frame, regs->nip, regs->link);
 
-	force_sigsegv(signr, current);
-	return 0;
+	return 1;
 }
-- 
1.8.4.5

