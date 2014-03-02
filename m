Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaCBX5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:57:44 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62421 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaCBX5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:57:41 -0500
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
Subject: [PATCH 13/44] microblaze: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:57:17 +0100
Message-Id: <1393804646-7797-3-git-send-email-richard@nod.at>
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
 arch/microblaze/kernel/signal.c | 48 +++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index d26d7e7..a34da52 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -156,11 +156,11 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
 	return (void __user *)((sp - frame_size) & -8UL);
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err = 0;
+	int err = 0, sig = ksig->sig;
 	int signal;
 	unsigned long address = 0;
 #ifdef CONFIG_MMU
@@ -168,10 +168,10 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	pte_t *ptep;
 #endif
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	signal = current_thread_info()->exec_domain
 		&& current_thread_info()->exec_domain->signal_invmap
@@ -179,8 +179,8 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		? current_thread_info()->exec_domain->signal_invmap[sig]
 		: sig;
 
-	if (info)
-		err |= copy_siginfo_to_user(&frame->info, info);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Create the ucontext. */
 	err |= __put_user(0, &frame->uc.uc_flags);
@@ -227,7 +227,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	flush_dcache_range(address, address + 8);
 #endif
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 	regs->r1 = (unsigned long) frame;
@@ -237,7 +237,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	regs->r6 = (unsigned long) &frame->info; /* arg 1: siginfo */
 	regs->r7 = (unsigned long) &frame->uc; /* arg2: ucontext */
 	/* Offset to handle microblaze rtid r14, 0 */
-	regs->pc = (unsigned long)ka->sa.sa_handler;
+	regs->pc = (unsigned long)ksig->ka.sa.sa_handler;
 
 	set_fs(USER_DS);
 
@@ -247,10 +247,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /* Handle restarting system calls */
@@ -283,23 +279,15 @@ do_restart:
  */
 
 static void
-handle_signal(unsigned long sig, struct k_sigaction *ka,
-		siginfo_t *info, struct pt_regs *regs)
+handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
-	else
-		ret = setup_rt_frame(sig, ka, NULL, oldset, regs);
+	ret = setup_rt_frame(ksig, oldset, regs);
 
-	if (ret)
-		return;
-
-	signal_delivered(sig, info, ka, regs,
-			test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 /*
@@ -313,21 +301,19 @@ handle_signal(unsigned long sig, struct k_sigaction *ka,
  */
 static void do_signal(struct pt_regs *regs, int in_syscall)
 {
-	siginfo_t info;
-	int signr;
-	struct k_sigaction ka;
+	struct ksignal ksig;
+
 #ifdef DEBUG_SIG
 	pr_info("do signal: %p %d\n", regs, in_syscall);
 	pr_info("do signal2: %lx %lx %ld [%lx]\n", regs->pc, regs->r1,
 			regs->r12, current_thread_info()->flags);
 #endif
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal. */
 		if (in_syscall)
-			handle_restart(regs, &ka, 1);
-		handle_signal(signr, &ka, &info, regs);
+			handle_restart(regs, &ksig.ka, 1);
+		handle_signal(&ksig, regs);
 		return;
 	}
 
-- 
1.8.4.2

