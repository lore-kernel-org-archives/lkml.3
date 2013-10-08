Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab3JHLe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:34:58 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754570Ab3JHLez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:34:55 -0400
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
Subject: [PATCH 20/29] s390: Use get_signal() signal_setup_done()
Date: Tue,  8 Oct 2013 13:34:40 +0200
Message-Id: <1381232085-4288-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/s390/kernel/compat_signal.c | 77 +++++++++++++++++----------------------
 arch/s390/kernel/entry.h         |  4 +-
 arch/s390/kernel/signal.c        | 79 ++++++++++++++++------------------------
 3 files changed, 68 insertions(+), 92 deletions(-)

diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 1389b63..1768910 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -311,38 +311,39 @@ static inline int map_signal(int sig)
 		return sig;
 }
 
-static int setup_frame32(int sig, struct k_sigaction *ka,
-			sigset_t *set, struct pt_regs * regs)
+static int setup_frame32(struct ksignal *ksig, sigset_t *set,
+			 struct pt_regs *regs)
 {
-	sigframe32 __user *frame = get_sigframe(ka, regs, sizeof(sigframe32));
+	int sig = ksig->sig;
+	sigframe32 __user *frame = get_sigframe(&ksig->ka, regs, sizeof(sigframe32));
 
 	if (frame == (void __user *) -1UL)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (__copy_to_user(&frame->sc.oldmask, &set->sig, _SIGMASK_COPY_SIZE32))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (save_sigregs32(regs, &frame->sregs))
-		goto give_sigsegv;
+		return -EFAULT;
 	if (save_sigregs_gprs_high(regs, frame->gprs_high))
-		goto give_sigsegv;
+		return -EFAULT;
 	if (__put_user((unsigned long) &frame->sregs, &frame->sc.sregs))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->gprs[14] = (__u64 __force) ka->sa.sa_restorer | PSW32_ADDR_AMODE;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		regs->gprs[14] = (__u64 __force) ksig->ka.sa.sa_restorer | PSW32_ADDR_AMODE;
 	} else {
 		regs->gprs[14] = (__u64 __force) frame->retcode | PSW32_ADDR_AMODE;
 		if (__put_user(S390_SYSCALL_OPCODE | __NR_sigreturn,
 			       (u16 __force __user *)(frame->retcode)))
-			goto give_sigsegv;
+			return -EFAULT;
         }
 
 	/* Set up backchain. */
 	if (__put_user(regs->gprs[15], (unsigned int __user *) frame))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
@@ -350,7 +351,7 @@ static int setup_frame32(int sig, struct k_sigaction *ka,
 	regs->psw.mask = PSW_MASK_BA |
 		(psw_user_bits & PSW_MASK_ASC) |
 		(regs->psw.mask & ~PSW_MASK_ASC);
-	regs->psw.addr = (__force __u64) ka->sa.sa_handler;
+	regs->psw.addr = (__force __u64) ksig->ka.sa.sa_handler;
 
 	regs->gprs[2] = map_signal(sig);
 	regs->gprs[3] = (__force __u64) &frame->sc;
@@ -367,25 +368,21 @@ static int setup_frame32(int sig, struct k_sigaction *ka,
 
 	/* Place signal number on stack to allow backtrace from handler.  */
 	if (__put_user(regs->gprs[2], (int __force __user *) &frame->signo))
-		goto give_sigsegv;
+		return -EFAULT;
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
-static int setup_rt_frame32(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs * regs)
+static int setup_rt_frame32(struct ksignal *ksig, sigset_t *set,
+			    struct pt_regs *regs)
 {
 	int err = 0;
-	rt_sigframe32 __user *frame = get_sigframe(ka, regs, sizeof(rt_sigframe32));
+	rt_sigframe32 __user *frame = get_sigframe(&ksig->ka, regs, sizeof(rt_sigframe32));
 
 	if (frame == (void __user *) -1UL)
-		goto give_sigsegv;
+		return -EFAULT;
 
-	if (copy_siginfo_to_user32(&frame->info, info))
-		goto give_sigsegv;
+	if (copy_siginfo_to_user32(&frame->info, &ksig->info))
+		return -EFAULT;
 
 	/* Create the ucontext.  */
 	err |= __put_user(UC_EXTENDED, &frame->uc.uc_flags);
@@ -395,12 +392,12 @@ static int setup_rt_frame32(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= save_sigregs_gprs_high(regs, frame->gprs_high);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		regs->gprs[14] = (__u64 __force) ka->sa.sa_restorer | PSW32_ADDR_AMODE;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		regs->gprs[14] = (__u64 __force) ksig->ka.sa.sa_restorer | PSW32_ADDR_AMODE;
 	} else {
 		regs->gprs[14] = (__u64 __force) frame->retcode | PSW32_ADDR_AMODE;
 		err |= __put_user(S390_SYSCALL_OPCODE | __NR_rt_sigreturn,
@@ -409,7 +406,7 @@ static int setup_rt_frame32(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up backchain. */
 	if (__put_user(regs->gprs[15], (unsigned int __force __user *) frame))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (__force __u64) frame;
@@ -417,36 +414,30 @@ static int setup_rt_frame32(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->psw.mask = PSW_MASK_BA |
 		(psw_user_bits & PSW_MASK_ASC) |
 		(regs->psw.mask & ~PSW_MASK_ASC);
-	regs->psw.addr = (__u64 __force) ka->sa.sa_handler;
+	regs->psw.addr = (__u64 __force) ksig->ka.sa.sa_handler;
 
-	regs->gprs[2] = map_signal(sig);
+	regs->gprs[2] = map_signal(ksig->sig);
 	regs->gprs[3] = (__force __u64) &frame->info;
 	regs->gprs[4] = (__force __u64) &frame->uc;
 	regs->gprs[5] = task_thread_info(current)->last_break;
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler
  */	
 
-void handle_signal32(unsigned long sig, struct k_sigaction *ka,
-		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs)
+void handle_signal32(struct ksignal *ksig, sigset_t *oldset,
+		     struct pt_regs *regs)
 {
 	int ret;
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame32(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame32(ksig, oldset, regs);
 	else
-		ret = setup_frame32(sig, ka, oldset, regs);
-	if (ret)
-		return;
-	signal_delivered(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLE_STEP));
+		ret = setup_frame32(ksig, oldset, regs);
+
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLE_STEP));
 }
 
diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index e9b04c3..c2a2a9d 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -49,8 +49,8 @@ void do_per_trap(struct pt_regs *regs);
 void syscall_trace(struct pt_regs *regs, int entryexit);
 void kernel_stack_overflow(struct pt_regs * regs);
 void do_signal(struct pt_regs *regs);
-void handle_signal32(unsigned long sig, struct k_sigaction *ka,
-		    siginfo_t *info, sigset_t *oldset, struct pt_regs *regs);
+void handle_signal32(struct ksignal *ksig, sigset_t *oldset,
+		     struct pt_regs *regs);
 void do_notify_resume(struct pt_regs *regs);
 
 void __init init_IRQ(void);
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index c45becf..8f169eb 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -193,15 +193,15 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	frame = get_sigframe(ka, regs, sizeof(sigframe));
 
 	if (frame == (void __user *) -1UL)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (__copy_to_user(&frame->sc.oldmask, &set->sig, _SIGMASK_COPY_SIZE))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (save_sigregs(regs, &frame->sregs))
-		goto give_sigsegv;
+		return -EFAULT;
 	if (__put_user(&frame->sregs, &frame->sc.sregs))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
@@ -213,12 +213,12 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 			frame->retcode | PSW_ADDR_AMODE;
 		if (__put_user(S390_SYSCALL_OPCODE | __NR_sigreturn,
 	                       (u16 __user *)(frame->retcode)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
 
 	/* Set up backchain. */
 	if (__put_user(regs->gprs[15], (addr_t __user *) frame))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
@@ -243,27 +243,23 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 
 	/* Place signal number on stack to allow backtrace from handler.  */
 	if (__put_user(regs->gprs[2], (int __user *) &frame->signo))
-		goto give_sigsegv;
+		return -EFAULT;
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			   sigset_t *set, struct pt_regs * regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	int err = 0;
 	rt_sigframe __user *frame;
 
-	frame = get_sigframe(ka, regs, sizeof(rt_sigframe));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(rt_sigframe));
 
 	if (frame == (void __user *) -1UL)
-		goto give_sigsegv;
+		return -EFAULT;
 
-	if (copy_siginfo_to_user(&frame->info, info))
-		goto give_sigsegv;
+	if (copy_siginfo_to_user(&frame->info, &ksig->info))
+		return -EFAULT;
 
 	/* Create the ucontext.  */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -272,24 +268,24 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= save_sigregs(regs, &frame->uc.uc_mcontext);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
                 regs->gprs[14] = (unsigned long)
-			ka->sa.sa_restorer | PSW_ADDR_AMODE;
+			ksig->ka.sa.sa_restorer | PSW_ADDR_AMODE;
 	} else {
                 regs->gprs[14] = (unsigned long)
 			frame->retcode | PSW_ADDR_AMODE;
 		if (__put_user(S390_SYSCALL_OPCODE | __NR_rt_sigreturn,
 			       (u16 __user *)(frame->retcode)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
 
 	/* Set up backchain. */
 	if (__put_user(regs->gprs[15], (addr_t __user *) frame))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->gprs[15] = (unsigned long) frame;
@@ -297,34 +293,27 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->psw.mask = PSW_MASK_EA | PSW_MASK_BA |
 		(psw_user_bits & PSW_MASK_ASC) |
 		(regs->psw.mask & ~PSW_MASK_ASC);
-	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
+	regs->psw.addr = (unsigned long) ksig->ka.sa.sa_handler | PSW_ADDR_AMODE;
 
-	regs->gprs[2] = map_signal(sig);
+	regs->gprs[2] = map_signal(ksig->sig);
 	regs->gprs[3] = (unsigned long) &frame->info;
 	regs->gprs[4] = (unsigned long) &frame->uc;
 	regs->gprs[5] = task_thread_info(current)->last_break;
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
-static void handle_signal(unsigned long sig, struct k_sigaction *ka,
-			 siginfo_t *info, sigset_t *oldset,
-			 struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, sigset_t *oldset,
+			  struct pt_regs *regs)
 {
 	int ret;
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset, regs);
 	else
-		ret = setup_frame(sig, ka, oldset, regs);
-	if (ret)
-		return;
-	signal_delivered(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLE_STEP));
+		ret = setup_frame(ksig->sig, &ksig->ka, oldset, regs);
+
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLE_STEP));
 }
 
 /*
@@ -338,9 +327,7 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
  */
 void do_signal(struct pt_regs *regs)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
 	sigset_t *oldset = sigmask_to_save();
 
 	/*
@@ -350,9 +337,7 @@ void do_signal(struct pt_regs *regs)
 	 */
 	current_thread_info()->system_call =
 		test_thread_flag(TIF_SYSCALL) ? regs->int_code : 0;
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
 		if (current_thread_info()->system_call) {
 			regs->int_code = current_thread_info()->system_call;
@@ -363,7 +348,7 @@ void do_signal(struct pt_regs *regs)
 				regs->gprs[2] = -EINTR;
 				break;
 			case -ERESTARTSYS:
-				if (!(ka.sa.sa_flags & SA_RESTART)) {
+				if (!(ksig.ka.sa.sa_flags & SA_RESTART)) {
 					regs->gprs[2] = -EINTR;
 					break;
 				}
@@ -380,9 +365,9 @@ void do_signal(struct pt_regs *regs)
 		clear_thread_flag(TIF_SYSCALL);
 
 		if (is_compat_task())
-			handle_signal32(signr, &ka, &info, oldset, regs);
+			handle_signal32(&ksig, oldset, regs);
 		else
-			handle_signal(signr, &ka, &info, oldset, regs);
+			handle_signal(&ksig, oldset, regs);
 		return;
 	}
 
-- 
1.8.1.4

