Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab3JHLeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:34:07 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754955Ab3JHLeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:34:04 -0400
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
Subject: [PATCH 15/29] mips: Use get_signal() signal_setup_done()
Date: Tue,  8 Oct 2013 13:33:51 +0200
Message-Id: <1381232035-4240-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/mips/include/asm/abi.h   | 10 +++----
 arch/mips/kernel/signal.c     | 66 ++++++++++++++++---------------------------
 arch/mips/kernel/signal32.c   | 39 ++++++++++---------------
 arch/mips/kernel/signal_n32.c | 20 ++++++-------
 4 files changed, 52 insertions(+), 83 deletions(-)

diff --git a/arch/mips/include/asm/abi.h b/arch/mips/include/asm/abi.h
index 909bb69..7186bb5 100644
--- a/arch/mips/include/asm/abi.h
+++ b/arch/mips/include/asm/abi.h
@@ -13,13 +13,11 @@
 #include <asm/siginfo.h>
 
 struct mips_abi {
-	int (* const setup_frame)(void *sig_return, struct k_sigaction *ka,
-				  struct pt_regs *regs, int signr,
-				  sigset_t *set);
+	int (* const setup_frame)(void *sig_return, struct ksignal *ksig,
+				  struct pt_regs *regs, sigset_t *set);
 	const unsigned long	signal_return_offset;
-	int (* const setup_rt_frame)(void *sig_return, struct k_sigaction *ka,
-			       struct pt_regs *regs, int signr,
-			       sigset_t *set, siginfo_t *info);
+	int (* const setup_rt_frame)(void *sig_return, struct ksignal *ksig,
+				     struct pt_regs *regs, sigset_t *set);
 	const unsigned long	rt_signal_return_offset;
 	const unsigned long	restart;
 };
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index 2f285ab..969e681 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -370,20 +370,20 @@ badframe:
 }
 
 #ifdef CONFIG_TRAD_SIGNALS
-static int setup_frame(void *sig_return, struct k_sigaction *ka,
-		       struct pt_regs *regs, int signr, sigset_t *set)
+static int setup_frame(void *sig_return, struct ksignal *ksig,
+		       struct pt_regs *regs, sigset_t *set)
 {
 	struct sigframe __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= setup_sigcontext(regs, &frame->sf_sc);
 	err |= __copy_to_user(&frame->sf_mask, set, sizeof(*set));
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Arguments to signal handler:
@@ -395,37 +395,32 @@ static int setup_frame(void *sig_return, struct k_sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to the
 	 * struct sigframe.
 	 */
-	regs->regs[ 4] = signr;
+	regs->regs[ 4] = ksig->sig;
 	regs->regs[ 5] = 0;
 	regs->regs[ 6] = (unsigned long) &frame->sf_sc;
 	regs->regs[29] = (unsigned long) frame;
 	regs->regs[31] = (unsigned long) sig_return;
-	regs->cp0_epc = regs->regs[25] = (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc = regs->regs[25] = (unsigned long) ksig->ka.sa.sa_handler;
 
 	DEBUGP("SIG deliver (%s:%d): sp=0x%p pc=0x%lx ra=0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
 #endif
 
-static int setup_rt_frame(void *sig_return, struct k_sigaction *ka,
-			  struct pt_regs *regs, int signr, sigset_t *set,
-			  siginfo_t *info)
+static int setup_rt_frame(void *sig_return, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Create siginfo.  */
-	err |= copy_siginfo_to_user(&frame->rs_info, info);
+	err |= copy_siginfo_to_user(&frame->rs_info, &ksig->info);
 
 	/* Create the ucontext.	 */
 	err |= __put_user(0, &frame->rs_uc.uc_flags);
@@ -435,7 +430,7 @@ static int setup_rt_frame(void *sig_return, struct k_sigaction *ka,
 	err |= __copy_to_user(&frame->rs_uc.uc_sigmask, set, sizeof(*set));
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Arguments to signal handler:
@@ -447,22 +442,18 @@ static int setup_rt_frame(void *sig_return, struct k_sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to
 	 * the struct rt_sigframe.
 	 */
-	regs->regs[ 4] = signr;
+	regs->regs[ 4] = ksig->sig;
 	regs->regs[ 5] = (unsigned long) &frame->rs_info;
 	regs->regs[ 6] = (unsigned long) &frame->rs_uc;
 	regs->regs[29] = (unsigned long) frame;
 	regs->regs[31] = (unsigned long) sig_return;
-	regs->cp0_epc = regs->regs[25] = (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc = regs->regs[25] = (unsigned long) ksig->ka.sa.sa_handler;
 
 	DEBUGP("SIG deliver (%s:%d): sp=0x%p pc=0x%lx ra=0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
 
 struct mips_abi mips_abi = {
@@ -476,8 +467,7 @@ struct mips_abi mips_abi = {
 	.restart	= __NR_restart_syscall
 };
 
-static void handle_signal(unsigned long sig, siginfo_t *info,
-	struct k_sigaction *ka, struct pt_regs *regs)
+static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
@@ -499,7 +489,7 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
 			regs->regs[2] = EINTR;
 			break;
 		case ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->regs[2] = EINTR;
 				break;
 			}
@@ -513,29 +503,23 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
 		regs->regs[0] = 0;		/* Don't deal with this again.	*/
 	}
 
-	if (sig_uses_siginfo(ka))
+	if (sig_uses_siginfo(&ksig->ka))
 		ret = abi->setup_rt_frame(vdso + abi->rt_signal_return_offset,
-					  ka, regs, sig, oldset, info);
+					  ksig, regs, oldset);
 	else
-		ret = abi->setup_frame(vdso + abi->signal_return_offset,
-				       ka, regs, sig, oldset);
-
-	if (ret)
-		return;
+		ret = abi->setup_frame(vdso + abi->signal_return_offset, ksig,
+				       regs, oldset);
 
-	signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 static void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.	*/
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return;
 	}
 
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index 57de8b7..9e7ddc0 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -449,21 +449,21 @@ badframe:
 	force_sig(SIGSEGV, current);
 }
 
-static int setup_frame_32(void *sig_return, struct k_sigaction *ka,
-			  struct pt_regs *regs, int signr, sigset_t *set)
+static int setup_frame_32(void *sig_return, struct ksignal *ksig,
+			  struct pt_regs *regs, sigset_t *set)
 {
 	struct sigframe32 __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= setup_sigcontext32(regs, &frame->sf_sc);
 	err |= __copy_conv_sigset_to_user(&frame->sf_mask, set);
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Arguments to signal handler:
@@ -475,37 +475,32 @@ static int setup_frame_32(void *sig_return, struct k_sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to the
 	 * struct sigframe.
 	 */
-	regs->regs[ 4] = signr;
+	regs->regs[ 4] = ksig->sig;
 	regs->regs[ 5] = 0;
 	regs->regs[ 6] = (unsigned long) &frame->sf_sc;
 	regs->regs[29] = (unsigned long) frame;
 	regs->regs[31] = (unsigned long) sig_return;
-	regs->cp0_epc = regs->regs[25] = (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc = regs->regs[25] = (unsigned long) ksig->ka.sa.sa_handler;
 
 	DEBUGP("SIG deliver (%s:%d): sp=0x%p pc=0x%lx ra=0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
 
-static int setup_rt_frame_32(void *sig_return, struct k_sigaction *ka,
-			     struct pt_regs *regs, int signr, sigset_t *set,
-			     siginfo_t *info)
+static int setup_rt_frame_32(void *sig_return, struct ksignal *ksig,
+			     struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe32 __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Convert (siginfo_t -> compat_siginfo_t) and copy to user. */
-	err |= copy_siginfo_to_user32(&frame->rs_info, info);
+	err |= copy_siginfo_to_user32(&frame->rs_info, &ksig->info);
 
 	/* Create the ucontext.	 */
 	err |= __put_user(0, &frame->rs_uc.uc_flags);
@@ -515,7 +510,7 @@ static int setup_rt_frame_32(void *sig_return, struct k_sigaction *ka,
 	err |= __copy_conv_sigset_to_user(&frame->rs_uc.uc_sigmask, set);
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Arguments to signal handler:
@@ -527,22 +522,18 @@ static int setup_rt_frame_32(void *sig_return, struct k_sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to
 	 * the struct rt_sigframe32.
 	 */
-	regs->regs[ 4] = signr;
+	regs->regs[ 4] = ksig->sig;
 	regs->regs[ 5] = (unsigned long) &frame->rs_info;
 	regs->regs[ 6] = (unsigned long) &frame->rs_uc;
 	regs->regs[29] = (unsigned long) frame;
 	regs->regs[31] = (unsigned long) sig_return;
-	regs->cp0_epc = regs->regs[25] = (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc = regs->regs[25] = (unsigned long) ksig->ka.sa.sa_handler;
 
 	DEBUGP("SIG deliver (%s:%d): sp=0x%p pc=0x%lx ra=0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
 
 /*
diff --git a/arch/mips/kernel/signal_n32.c b/arch/mips/kernel/signal_n32.c
index b2241bb..7d04f28 100644
--- a/arch/mips/kernel/signal_n32.c
+++ b/arch/mips/kernel/signal_n32.c
@@ -102,18 +102,18 @@ badframe:
 	force_sig(SIGSEGV, current);
 }
 
-static int setup_rt_frame_n32(void *sig_return, struct k_sigaction *ka,
-	struct pt_regs *regs, int signr, sigset_t *set, siginfo_t *info)
+static int setup_rt_frame_n32(void *sig_return, struct ksignal *ksig,
+			      struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe_n32 __user *frame;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 	if (!access_ok(VERIFY_WRITE, frame, sizeof (*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Create siginfo.  */
-	err |= copy_siginfo_to_user32(&frame->rs_info, info);
+	err |= copy_siginfo_to_user32(&frame->rs_info, &ksig->info);
 
 	/* Create the ucontext.	 */
 	err |= __put_user(0, &frame->rs_uc.uc_flags);
@@ -123,7 +123,7 @@ static int setup_rt_frame_n32(void *sig_return, struct k_sigaction *ka,
 	err |= __copy_conv_sigset_to_user(&frame->rs_uc.uc_sigmask, set);
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Arguments to signal handler:
@@ -135,22 +135,18 @@ static int setup_rt_frame_n32(void *sig_return, struct k_sigaction *ka,
 	 * $25 and c0_epc point to the signal handler, $29 points to
 	 * the struct rt_sigframe.
 	 */
-	regs->regs[ 4] = signr;
+	regs->regs[ 4] = ksig->sig;
 	regs->regs[ 5] = (unsigned long) &frame->rs_info;
 	regs->regs[ 6] = (unsigned long) &frame->rs_uc;
 	regs->regs[29] = (unsigned long) frame;
 	regs->regs[31] = (unsigned long) sig_return;
-	regs->cp0_epc = regs->regs[25] = (unsigned long) ka->sa.sa_handler;
+	regs->cp0_epc = regs->regs[25] = (unsigned long) ksig->ka.sa.sa_handler;
 
 	DEBUGP("SIG deliver (%s:%d): sp=0x%p pc=0x%lx ra=0x%lx\n",
 	       current->comm, current->pid,
 	       frame, regs->cp0_epc, regs->regs[31]);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(signr, current);
-	return -EFAULT;
 }
 
 struct mips_abi mips_abi_n32 = {
-- 
1.8.1.4

