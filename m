Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaCBX6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:58:08 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62430 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbaCBX6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:58:05 -0500
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
Subject: [PATCH 22/44] um: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:57:26 +0100
Message-Id: <1393804646-7797-12-git-send-email-richard@nod.at>
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
 arch/um/include/shared/frame_kern.h | 12 ++++------
 arch/um/kernel/signal.c             | 27 +++++++++-------------
 arch/x86/um/signal.c                | 45 +++++++++++++++++--------------------
 3 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/arch/um/include/shared/frame_kern.h b/arch/um/include/shared/frame_kern.h
index f2ca570..a5cde5c 100644
--- a/arch/um/include/shared/frame_kern.h
+++ b/arch/um/include/shared/frame_kern.h
@@ -6,14 +6,10 @@
 #ifndef __FRAME_KERN_H_
 #define __FRAME_KERN_H_
 
-extern int setup_signal_stack_sc(unsigned long stack_top, int sig,
-				 struct k_sigaction *ka,
-				 struct pt_regs *regs,
-				 sigset_t *mask);
-extern int setup_signal_stack_si(unsigned long stack_top, int sig,
-				 struct k_sigaction *ka,
-				 struct pt_regs *regs, struct siginfo *info,
-				 sigset_t *mask);
+extern int setup_signal_stack_sc(unsigned long stack_top, struct ksignal *ksig,
+				 struct pt_regs *regs, sigset_t *mask);
+extern int setup_signal_stack_si(unsigned long stack_top, struct ksignal *ksig,
+				 struct pt_regs *regs, sigset_t *mask);
 
 #endif
 
diff --git a/arch/um/kernel/signal.c b/arch/um/kernel/signal.c
index f57e02e..4f60e4a 100644
--- a/arch/um/kernel/signal.c
+++ b/arch/um/kernel/signal.c
@@ -18,8 +18,7 @@ EXPORT_SYMBOL(unblock_signals);
 /*
  * OK, we're invoking a handler
  */
-static void handle_signal(struct pt_regs *regs, unsigned long signr,
-			 struct k_sigaction *ka, struct siginfo *info)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int singlestep = 0;
@@ -39,7 +38,7 @@ static void handle_signal(struct pt_regs *regs, unsigned long signr,
 			break;
 
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				PT_REGS_SYSCALL_RET(regs) = -EINTR;
 				break;
 			}
@@ -52,32 +51,28 @@ static void handle_signal(struct pt_regs *regs, unsigned long signr,
 	}
 
 	sp = PT_REGS_SP(regs);
-	if ((ka->sa.sa_flags & SA_ONSTACK) && (sas_ss_flags(sp) == 0))
+	if ((ksig->ka.sa.sa_flags & SA_ONSTACK) && (sas_ss_flags(sp) == 0))
 		sp = current->sas_ss_sp + current->sas_ss_size;
 
 #ifdef CONFIG_ARCH_HAS_SC_SIGNALS
-	if (!(ka->sa.sa_flags & SA_SIGINFO))
-		err = setup_signal_stack_sc(sp, signr, ka, regs, oldset);
+	if (!(ksig->ka.sa.sa_flags & SA_SIGINFO))
+		err = setup_signal_stack_sc(sp, ksig, regs, oldset);
 	else
 #endif
-		err = setup_signal_stack_si(sp, signr, ka, regs, info, oldset);
+		err = setup_signal_stack_si(sp, ksig, regs, oldset);
 
-	if (err)
-		force_sigsegv(signr, current);
-	else
-		signal_delivered(signr, info, ka, regs, singlestep);
+	signal_setup_done(err, ksig, singlestep);
 }
 
 static int kern_do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka_copy;
-	struct siginfo info;
-	int sig, handled_sig = 0;
+	struct ksignal ksig;
+	int handled_sig = 0;
 
-	while ((sig = get_signal_to_deliver(&info, &ka_copy, regs, NULL)) > 0) {
+	while (get_signal(&ksig)) {
 		handled_sig = 1;
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(regs, sig, &ka_copy, &info);
+		handle_signal(&ksig, regs);
 	}
 
 	/* Did we come from a system call? */
diff --git a/arch/x86/um/signal.c b/arch/x86/um/signal.c
index 5e04a1c..79d8245 100644
--- a/arch/x86/um/signal.c
+++ b/arch/x86/um/signal.c
@@ -370,13 +370,12 @@ struct rt_sigframe
 	char retcode[8];
 };
 
-int setup_signal_stack_sc(unsigned long stack_top, int sig,
-			  struct k_sigaction *ka, struct pt_regs *regs,
-			  sigset_t *mask)
+int setup_signal_stack_sc(unsigned long stack_top, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *mask)
 {
 	struct sigframe __user *frame;
 	void __user *restorer;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 
 	/* This is the same calculation as i386 - ((sp + 4) & 15) == 0 */
 	stack_top = ((stack_top + 4) & -16UL) - 4;
@@ -385,8 +384,8 @@ int setup_signal_stack_sc(unsigned long stack_top, int sig,
 		return 1;
 
 	restorer = frame->retcode;
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer = ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		restorer = ksig->ka.sa.sa_restorer;
 
 	err |= __put_user(restorer, &frame->pretcode);
 	err |= __put_user(sig, &frame->sig);
@@ -410,20 +409,19 @@ int setup_signal_stack_sc(unsigned long stack_top, int sig,
 		return err;
 
 	PT_REGS_SP(regs) = (unsigned long) frame;
-	PT_REGS_IP(regs) = (unsigned long) ka->sa.sa_handler;
+	PT_REGS_IP(regs) = (unsigned long) ksig->ka.sa.sa_handler;
 	PT_REGS_AX(regs) = (unsigned long) sig;
 	PT_REGS_DX(regs) = (unsigned long) 0;
 	PT_REGS_CX(regs) = (unsigned long) 0;
 	return 0;
 }
 
-int setup_signal_stack_si(unsigned long stack_top, int sig,
-			  struct k_sigaction *ka, struct pt_regs *regs,
-			  siginfo_t *info, sigset_t *mask)
+int setup_signal_stack_si(unsigned long stack_top, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *mask)
 {
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 
 	stack_top &= -8UL;
 	frame = (struct rt_sigframe __user *) stack_top - 1;
@@ -431,14 +429,14 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 		return 1;
 
 	restorer = frame->retcode;
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer = ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		restorer = ksig->ka.sa.sa_restorer;
 
 	err |= __put_user(restorer, &frame->pretcode);
 	err |= __put_user(sig, &frame->sig);
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 	err |= copy_ucontext_to_user(&frame->uc, &frame->fpstate, mask,
 					PT_REGS_SP(regs));
 
@@ -457,7 +455,7 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 		return err;
 
 	PT_REGS_SP(regs) = (unsigned long) frame;
-	PT_REGS_IP(regs) = (unsigned long) ka->sa.sa_handler;
+	PT_REGS_IP(regs) = (unsigned long) ksig->ka.sa.sa_handler;
 	PT_REGS_AX(regs) = (unsigned long) sig;
 	PT_REGS_DX(regs) = (unsigned long) &frame->info;
 	PT_REGS_CX(regs) = (unsigned long) &frame->uc;
@@ -502,12 +500,11 @@ struct rt_sigframe
 	struct _fpstate fpstate;
 };
 
-int setup_signal_stack_si(unsigned long stack_top, int sig,
-			  struct k_sigaction *ka, struct pt_regs * regs,
-			  siginfo_t *info, sigset_t *set)
+int setup_signal_stack_si(unsigned long stack_top, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 
 	frame = (struct rt_sigframe __user *)
 		round_down(stack_top - sizeof(struct rt_sigframe), 16);
@@ -517,8 +514,8 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto out;
 
-	if (ka->sa.sa_flags & SA_SIGINFO) {
-		err |= copy_siginfo_to_user(&frame->info, info);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
+		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 		if (err)
 			goto out;
 	}
@@ -543,8 +540,8 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 	 * already in userspace.
 	 */
 	/* x86-64 should always use SA_RESTORER. */
-	if (ka->sa.sa_flags & SA_RESTORER)
-		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
+	if (ksig->ka.sa.sa_flags & SA_RESTORER)
+		err |= __put_user(ksig->ka.sa.sa_restorer, &frame->pretcode);
 	else
 		/* could use a vstub here */
 		return err;
@@ -570,7 +567,7 @@ int setup_signal_stack_si(unsigned long stack_top, int sig,
 	 */
 	PT_REGS_SI(regs) = (unsigned long) &frame->info;
 	PT_REGS_DX(regs) = (unsigned long) &frame->uc;
-	PT_REGS_IP(regs) = (unsigned long) ka->sa.sa_handler;
+	PT_REGS_IP(regs) = (unsigned long) ksig->ka.sa.sa_handler;
  out:
 	return err;
 }
-- 
1.8.4.2

