Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaCBX7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:59:33 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaCBX7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:31 -0500
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
Subject: [PATCH 23/44] unicore32: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:59:06 +0100
Message-Id: <1393804758-7916-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/unicore32/kernel/signal.c | 48 ++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index 6905f0e..780d773 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -238,10 +238,10 @@ static int setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 	return 0;
 }
 
-static int setup_frame(int usig, struct k_sigaction *ka,
-		sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+		       struct pt_regs *regs)
 {
-	struct sigframe __user *frame = get_sigframe(ka, regs, sizeof(*frame));
+	struct sigframe __user *frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	int err = 0;
 
 	if (!frame)
@@ -254,29 +254,29 @@ static int setup_frame(int usig, struct k_sigaction *ka,
 
 	err |= setup_sigframe(frame, regs, set);
 	if (err == 0)
-		err |= setup_return(regs, ka, frame->retcode, frame, usig);
+		err |= setup_return(regs, &ksig->ka, frame->retcode, frame, usig);
 
 	return err;
 }
 
-static int setup_rt_frame(int usig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame =
-			get_sigframe(ka, regs, sizeof(*frame));
+			get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	int err = 0;
 
 	if (!frame)
 		return 1;
 
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	err |= __put_user(0, &frame->sig.uc.uc_flags);
 	err |= __put_user(NULL, &frame->sig.uc.uc_link);
 	err |= __save_altstack(&frame->sig.uc.uc_stack, regs->UCreg_sp);
 	err |= setup_sigframe(&frame->sig, regs, set);
 	if (err == 0)
-		err |= setup_return(regs, ka, frame->sig.retcode, frame, usig);
+		err |= setup_return(regs, &ksig->ka, frame->sig.retcode, frame, usig);
 
 	if (err == 0) {
 		/*
@@ -299,13 +299,13 @@ static inline void setup_syscall_restart(struct pt_regs *regs)
 /*
  * OK, we're invoking a handler
  */
-static void handle_signal(unsigned long sig, struct k_sigaction *ka,
-	      siginfo_t *info, struct pt_regs *regs, int syscall)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs,
+			  int syscall)
 {
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = current;
 	sigset_t *oldset = sigmask_to_save();
-	int usig = sig;
+	int usig = ksig->sig;
 	int ret;
 
 	/*
@@ -318,7 +318,7 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 			regs->UCreg_00 = -EINTR;
 			break;
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->UCreg_00 = -EINTR;
 				break;
 			}
@@ -338,22 +338,17 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
 	/*
 	 * Set up the stack frame
 	 */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(usig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset, regs);
 	else
-		ret = setup_frame(usig, ka, oldset, regs);
+		ret = setup_frame(ksig, oldset, regs);
 
 	/*
 	 * Check that the resulting registers are actually sane.
 	 */
 	ret |= !valid_user_regs(regs);
 
-	if (ret != 0) {
-		force_sigsegv(sig, tsk);
-		return;
-	}
-
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 /*
@@ -367,9 +362,7 @@ static void handle_signal(unsigned long sig, struct k_sigaction *ka,
  */
 static void do_signal(struct pt_regs *regs, int syscall)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
 
 	/*
 	 * We want the common case to go fast, which
@@ -380,9 +373,8 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		handle_signal(signr, &ka, &info, regs, syscall);
+	if (get_signsl(&ksig)) {
+		handle_signal(&ksig, regs, syscall);
 		return;
 	}
 
-- 
1.8.4.2

