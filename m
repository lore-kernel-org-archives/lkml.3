Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3JHLeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:34:25 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756179Ab3JHLeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:34:17 -0400
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
Subject: [PATCH 19/29] powerpc: Use get_signal() signal_setup_done()
Date: Tue,  8 Oct 2013 13:33:55 +0200
Message-Id: <1381232035-4240-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381232035-4240-1-git-send-email-richard@nod.at>
References: <1381232035-4240-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.
This inverts also the return codes of setup_*frame() to follow the
kernel convention.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/powerpc/kernel/signal.c    | 31 +++++++++++--------------------
 arch/powerpc/kernel/signal.h    | 12 ++++--------
 arch/powerpc/kernel/signal_32.c | 38 ++++++++++++++++----------------------
 arch/powerpc/kernel/signal_64.c | 27 ++++++++++++---------------
 4 files changed, 43 insertions(+), 65 deletions(-)

diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index 457e97a..1a28d1e 100644
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
+		if (ksig.ka.sa.sa_flags & SA_SIGINFO)
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
index c69b9ae..ff9cc48 100644
--- a/arch/powerpc/kernel/signal.h
+++ b/arch/powerpc/kernel/signal.h
@@ -15,12 +15,10 @@ extern void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_fla
 extern void __user * get_sigframe(struct k_sigaction *ka, unsigned long sp,
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
index bebdf1a..3278fed 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -965,9 +965,8 @@ int copy_siginfo_from_user32(siginfo_t *to, struct compat_siginfo __user *from)
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
@@ -979,13 +978,13 @@ int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
 
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
@@ -1040,11 +1039,11 @@ int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
 
 	/* Fill registers for signal handler */
 	regs->gpr[1] = newsp;
-	regs->gpr[3] = sig;
+	regs->gpr[3] = ksig->sig;
 	regs->gpr[4] = (unsigned long) &rt_sf->info;
 	regs->gpr[5] = (unsigned long) &rt_sf->uc;
 	regs->gpr[6] = (unsigned long) rt_sf;
-	regs->nip = (unsigned long) ka->sa.sa_handler;
+	regs->nip = (unsigned long) ksig->ka.sa.sa_handler;
 	/* enter the signal handler in big-endian mode */
 	regs->msr &= ~MSR_LE;
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
@@ -1054,7 +1053,7 @@ int handle_rt_signal32(unsigned long sig, struct k_sigaction *ka,
 	 */
 	regs->msr &= ~MSR_TS_MASK;
 #endif
-	return 1;
+	return 0;
 
 badframe:
 #ifdef DEBUG_SIG
@@ -1067,9 +1066,7 @@ badframe:
 				   "%p nip %08lx lr %08lx\n",
 				   current->comm, current->pid,
 				   addr, regs->nip, regs->link);
-
-	force_sigsegv(sig, current);
-	return 0;
+	return 1;
 }
 
 static int do_setcontext(struct ucontext __user *ucp, struct pt_regs *regs, int sig)
@@ -1408,8 +1405,7 @@ int sys_debug_setcontext(struct ucontext __user *ctx,
 /*
  * OK, we're invoking a handler
  */
-int handle_signal32(unsigned long sig, struct k_sigaction *ka,
-		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
+int handle_signal32(struct ksignal *ksig, sigset_t *oldset, struct pt_regs *regs)
 {
 	struct sigcontext __user *sc;
 	struct sigframe __user *frame;
@@ -1419,7 +1415,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 	unsigned long tramp;
 
 	/* Set up Signal Frame */
-	frame = get_sigframe(ka, get_tm_stackpointer(regs), sizeof(*frame), 1);
+	frame = get_sigframe(&ksig->ka, get_tm_stackpointer(regs), sizeof(*frame), 1);
 	if (unlikely(frame == NULL))
 		goto badframe;
 	sc = (struct sigcontext __user *) &frame->sctx;
@@ -1427,7 +1423,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 #if _NSIG != 64
 #error "Please adjust handle_signal()"
 #endif
-	if (__put_user(to_user_ptr(ka->sa.sa_handler), &sc->handler)
+	if (__put_user(to_user_ptr(ksig->ka.sa.sa_handler), &sc->handler)
 	    || __put_user(oldset->sig[0], &sc->oldmask)
 #ifdef CONFIG_PPC64
 	    || __put_user((oldset->sig[0] >> 32), &sc->_unused[3])
@@ -1435,7 +1431,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 	    || __put_user(oldset->sig[1], &sc->_unused[3])
 #endif
 	    || __put_user(to_user_ptr(&frame->mctx), &sc->regs)
-	    || __put_user(sig, &sc->signal))
+	    || __put_user(ksig->sig, &sc->signal))
 		goto badframe;
 
 	if (vdso32_sigtramp && current->mm->context.vdso_base) {
@@ -1470,9 +1466,9 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 		goto badframe;
 
 	regs->gpr[1] = newsp;
-	regs->gpr[3] = sig;
+	regs->gpr[3] = ksig->sig;
 	regs->gpr[4] = (unsigned long) sc;
-	regs->nip = (unsigned long) ka->sa.sa_handler;
+	regs->nip = (unsigned long)ksig->ka.sa.sa_handler;
 	/* enter the signal handler in big-endian mode */
 	regs->msr &= ~MSR_LE;
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
@@ -1482,7 +1478,7 @@ int handle_signal32(unsigned long sig, struct k_sigaction *ka,
 	 */
 	regs->msr &= ~MSR_TS_MASK;
 #endif
-	return 1;
+	return 0;
 
 badframe:
 #ifdef DEBUG_SIG
@@ -1495,9 +1491,7 @@ badframe:
 				   "%p nip %08lx lr %08lx\n",
 				   current->comm, current->pid,
 				   frame, regs->nip, regs->link);
-
-	force_sigsegv(sig, current);
-	return 0;
+	return 1;
 }
 
 /*
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index f93ec28..1d2c0bd 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -697,8 +697,7 @@ badframe:
 	return 0;
 }
 
-int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
-		sigset_t *set, struct pt_regs *regs)
+int handle_rt_signal64(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	/* Handler is *really* a pointer to the function descriptor for
 	 * the signal routine.  The first entry in the function
@@ -710,13 +709,13 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
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
 
@@ -731,15 +730,15 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
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
@@ -765,7 +764,7 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
 			goto badframe;
 		regs->link = (unsigned long) &frame->tramp[0];
 	}
-	funct_desc_ptr = (func_descr_t __user *) ka->sa.sa_handler;
+	funct_desc_ptr = (func_descr_t __user *)ksig->ka.sa.sa_handler;
 
 	/* Allocate a dummy caller frame for the signal handler. */
 	newsp = ((unsigned long)frame) - __SIGNAL_FRAMESIZE;
@@ -777,9 +776,9 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
 	regs->msr &= ~MSR_LE;
 	regs->gpr[1] = newsp;
 	err |= get_user(regs->gpr[2], &funct_desc_ptr->toc);
-	regs->gpr[3] = signr;
+	regs->gpr[3] = ksig->sig;
 	regs->result = 0;
-	if (ka->sa.sa_flags & SA_SIGINFO) {
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		err |= get_user(regs->gpr[4], (unsigned long __user *)&frame->pinfo);
 		err |= get_user(regs->gpr[5], (unsigned long __user *)&frame->puc);
 		regs->gpr[6] = (unsigned long) frame;
@@ -789,7 +788,7 @@ int handle_rt_signal64(int signr, struct k_sigaction *ka, siginfo_t *info,
 	if (err)
 		goto badframe;
 
-	return 1;
+	return 0;
 
 badframe:
 #if DEBUG_SIG
@@ -800,7 +799,5 @@ badframe:
 		printk_ratelimited(regs->msr & MSR_64BIT ? fmt64 : fmt32,
 				   current->comm, current->pid, "setup_rt_frame",
 				   (long)frame, regs->nip, regs->link);
-
-	force_sigsegv(signr, current);
-	return 0;
+	return 1;
 }
-- 
1.8.1.4

