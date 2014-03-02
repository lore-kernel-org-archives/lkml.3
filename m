Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaCBX5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:57:52 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62424 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaCBX5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:57:49 -0500
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
Subject: [PATCH 16/44] parisc: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:57:20 +0100
Message-Id: <1393804646-7797-6-git-send-email-richard@nod.at>
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
 arch/parisc/kernel/signal.c | 58 +++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 34 deletions(-)

diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 1cba8f2..012d4fa 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -227,8 +227,8 @@ setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs, int in_sysc
 }
 
 static long
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs, int in_syscall)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs,
+	       int in_syscall)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long rp, usp;
@@ -241,10 +241,10 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	
 	usp = (regs->gr[30] & ~(0x01UL));
 	/*FIXME: frame_size parameter is unused, remove it. */
-	frame = get_sigframe(ka, usp, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, usp, sizeof(*frame));
 
 	DBG(1,"SETUP_RT_FRAME: START\n");
-	DBG(1,"setup_rt_frame: frame %p info %p\n", frame, info);
+	DBG(1,"setup_rt_frame: frame %p info %p\n", frame, ksig->info);
 
 	
 #ifdef CONFIG_64BIT
@@ -253,7 +253,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	
 	if (is_compat_task()) {
 		DBG(1,"setup_rt_frame: frame->info = 0x%p\n", &compat_frame->info);
-		err |= copy_siginfo_to_user32(&compat_frame->info, info);
+		err |= copy_siginfo_to_user32(&compat_frame->info, &ksig->info);
 		err |= __compat_save_altstack( &compat_frame->uc.uc_stack, regs->gr[30]);
 		DBG(1,"setup_rt_frame: frame->uc = 0x%p\n", &compat_frame->uc);
 		DBG(1,"setup_rt_frame: frame->uc.uc_mcontext = 0x%p\n", &compat_frame->uc.uc_mcontext);
@@ -265,7 +265,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 	{	
 		DBG(1,"setup_rt_frame: frame->info = 0x%p\n", &frame->info);
-		err |= copy_siginfo_to_user(&frame->info, info);
+		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 		err |= __save_altstack(&frame->uc.uc_stack, regs->gr[30]);
 		DBG(1,"setup_rt_frame: frame->uc = 0x%p\n", &frame->uc);
 		DBG(1,"setup_rt_frame: frame->uc.uc_mcontext = 0x%p\n", &frame->uc.uc_mcontext);
@@ -275,7 +275,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 	
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace. The first words of tramp are used to
@@ -312,9 +312,9 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	rp = (unsigned long) &frame->tramp[SIGRESTARTBLOCK_TRAMP];
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
-	haddr = A(ka->sa.sa_handler);
+	haddr = A(ksig->ka.sa.sa_handler);
 	/* The sa_handler may be a pointer to a function descriptor */
 #ifdef CONFIG_64BIT
 	if (is_compat_task()) {
@@ -326,7 +326,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			err = __copy_from_user(&fdesc, ufdesc, sizeof(fdesc));
 
 			if (err)
-				goto give_sigsegv;
+				return -EFAULT;
 
 			haddr = fdesc.addr;
 			regs->gr[19] = fdesc.gp;
@@ -339,7 +339,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		err = __copy_from_user(&fdesc, ufdesc, sizeof(fdesc));
 		
 		if (err)
-			goto give_sigsegv;
+			return -EFAULT;
 		
 		haddr = fdesc.addr;
 		regs->gr[19] = fdesc.gp;
@@ -386,7 +386,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	regs->gr[2]  = rp;                /* userland return pointer */
-	regs->gr[26] = sig;               /* signal number */
+	regs->gr[26] = ksig->sig;               /* signal number */
 	
 #ifdef CONFIG_64BIT
 	if (is_compat_task()) {
@@ -410,11 +410,6 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       current->comm, current->pid, frame, regs->gr[30],
 	       regs->iaoq[0], regs->iaoq[1], rp);
 
-	return 1;
-
-give_sigsegv:
-	DBG(1,"setup_rt_frame: sending SIGSEGV\n");
-	force_sigsegv(sig, current);
 	return 0;
 }
 
@@ -423,20 +418,19 @@ give_sigsegv:
  */	
 
 static void
-handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
-		struct pt_regs *regs, int in_syscall)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs, int in_syscall)
 {
+	int ret;
 	sigset_t *oldset = sigmask_to_save();
+
 	DBG(1,"handle_signal: sig=%ld, ka=%p, info=%p, oldset=%p, regs=%p\n",
-	       sig, ka, info, oldset, regs);
+	       ksig->sig, ksig->ka, ksig->info, oldset, regs);
 	
 	/* Set up the stack frame */
-	if (!setup_rt_frame(sig, ka, info, oldset, regs, in_syscall))
-		return;
+	ret = setup_rt_frame(ksig, oldset, regs, in_syscall);
 
-	signal_delivered(sig, info, ka, regs, 
-		test_thread_flag(TIF_SINGLESTEP) ||
-		test_thread_flag(TIF_BLOCKSTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP) ||
+			  test_thread_flag(TIF_BLOCKSTEP));
 
 	DBG(1,KERN_DEBUG "do_signal: Exit (success), regs->gr[28] = %ld\n",
 		regs->gr[28]);
@@ -544,22 +538,18 @@ insert_restart_trampoline(struct pt_regs *regs)
 asmlinkage void
 do_signal(struct pt_regs *regs, long in_syscall)
 {
-	siginfo_t info;
-	struct k_sigaction ka;
-	int signr;
+	struct ksignal ksig;
 
 	DBG(1,"\ndo_signal: regs=0x%p, sr7 %#lx, in_syscall=%d\n",
 	       regs, regs->sr[7], in_syscall);
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	DBG(3,"do_signal: signr = %d, regs->gr[28] = %ld\n", signr, regs->gr[28]); 
-	
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
+		DBG(3,"do_signal: signr = %d, regs->gr[28] = %ld\n", signr, regs->gr[28]);
 		/* Restart a system call if necessary. */
 		if (in_syscall)
-			syscall_restart(regs, &ka);
+			syscall_restart(regs, &ksig.ka);
 
-		handle_signal(signr, &info, &ka, regs, in_syscall);
+		handle_signal(&ksig, regs, in_syscall);
 		return;
 	}
 
-- 
1.8.4.2

