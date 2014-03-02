Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaCBX5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:57:04 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62415 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaCBX4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:56:43 -0500
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
Subject: [PATCH 07/44] frv: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:55:56 +0100
Message-Id: <1393804559-7701-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804559-7701-1-git-send-email-richard@nod.at>
References: <1393804559-7701-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/frv/kernel/signal.c | 99 +++++++++++++++++++-----------------------------
 1 file changed, 40 insertions(+), 59 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index d822700..8e37cf2 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -180,17 +180,17 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
 /*
  *
  */
-static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
+static int setup_frame(struct ksignal *ksig, sigset_t *set)
 {
 	struct sigframe __user *frame;
-	int rsig;
+	int rsig, sig = ksig->sig;
 
 	set_fs(USER_DS);
 
-	frame = get_sigframe(ka, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	rsig = sig;
 	if (sig < 32 &&
@@ -199,22 +199,22 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 		rsig = __current_thread_info->exec_domain->signal_invmap[sig];
 
 	if (__put_user(rsig, &frame->sig) < 0)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (setup_sigcontext(&frame->sc, set->sig[0]))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
 		if (__copy_to_user(frame->extramask, &set->sig[1],
 				   sizeof(frame->extramask)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
 
 	/* Set up to return from userspace.  If provided, use a stub
 	 * already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		if (__put_user(ka->sa.sa_restorer, &frame->pretcode) < 0)
-			goto give_sigsegv;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ksig->ka.sa.sa_restorer, &frame->pretcode) < 0)
+			return -EFAULT;
 	}
 	else {
 		/* Set up the following code on the stack:
@@ -224,7 +224,7 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 		if (__put_user((__sigrestore_t)frame->retcode, &frame->pretcode) ||
 		    __put_user(0x8efc0000|__NR_sigreturn, &frame->retcode[0]) ||
 		    __put_user(0xc0700000, &frame->retcode[1]))
-			goto give_sigsegv;
+			return -EFAULT;
 
 		flush_icache_range((unsigned long) frame->retcode,
 				   (unsigned long) (frame->retcode + 2));
@@ -233,14 +233,14 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 	/* Set up registers for the signal handler */
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
-			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
+			(struct fdpic_func_descriptor __user *) ksig->ka.sa.sa_handler;
 		struct fdpic_func_descriptor desc;
 		if (copy_from_user(&desc, funcptr, sizeof(desc)))
-			goto give_sigsegv;
+			return -EFAULT;
 		__frame->pc = desc.text;
 		__frame->gr15 = desc.GOT;
 	} else {
-		__frame->pc   = (unsigned long) ka->sa.sa_handler;
+		__frame->pc   = (unsigned long) ksig->ka.sa.sa_handler;
 		__frame->gr15 = 0;
 	}
 
@@ -255,29 +255,23 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set)
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
-
 } /* end setup_frame() */
 
 /*****************************************************************************/
 /*
  *
  */
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
-	int rsig;
+	int rsig, sig = ksig->sig;
 
 	set_fs(USER_DS);
 
-	frame = get_sigframe(ka, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	rsig = sig;
 	if (sig < 32 &&
@@ -288,28 +282,28 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (__put_user(rsig,		&frame->sig) ||
 	    __put_user(&frame->info,	&frame->pinfo) ||
 	    __put_user(&frame->uc,	&frame->puc))
-		goto give_sigsegv;
+		return -EFAULT;
 
-	if (copy_siginfo_to_user(&frame->info, info))
-		goto give_sigsegv;
+	if (copy_siginfo_to_user(&frame->info, &ksig->info))
+		return -EFAULT;
 
 	/* Create the ucontext.  */
 	if (__put_user(0, &frame->uc.uc_flags) ||
 	    __put_user(NULL, &frame->uc.uc_link) ||
 	    __save_altstack(&frame->uc.uc_stack, __frame->sp))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (setup_sigcontext(&frame->uc.uc_mcontext, set->sig[0]))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (__copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	 * already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		if (__put_user(ka->sa.sa_restorer, &frame->pretcode))
-			goto give_sigsegv;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ksig->ka.sa.sa_restorer, &frame->pretcode))
+			return -EFAULT;
 	}
 	else {
 		/* Set up the following code on the stack:
@@ -319,7 +313,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		if (__put_user((__sigrestore_t)frame->retcode, &frame->pretcode) ||
 		    __put_user(0x8efc0000|__NR_rt_sigreturn, &frame->retcode[0]) ||
 		    __put_user(0xc0700000, &frame->retcode[1]))
-			goto give_sigsegv;
+			return -EFAULT;
 
 		flush_icache_range((unsigned long) frame->retcode,
 				   (unsigned long) (frame->retcode + 2));
@@ -328,14 +322,14 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	/* Set up registers for signal handler */
 	if (current->personality & FDPIC_FUNCPTRS) {
 		struct fdpic_func_descriptor __user *funcptr =
-			(struct fdpic_func_descriptor __user *) ka->sa.sa_handler;
+			(struct fdpic_func_descriptor __user *) ksig->ka.sa.sa_handler;
 		struct fdpic_func_descriptor desc;
 		if (copy_from_user(&desc, funcptr, sizeof(desc)))
-			goto give_sigsegv;
+			return -EFAULT;
 		__frame->pc = desc.text;
 		__frame->gr15 = desc.GOT;
 	} else {
-		__frame->pc   = (unsigned long) ka->sa.sa_handler;
+		__frame->pc   = (unsigned long) ksig->ka.sa.sa_handler;
 		__frame->gr15 = 0;
 	}
 
@@ -349,21 +343,15 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sig, current->comm, current->pid, frame, __frame->pc,
 	       frame->pretcode);
 #endif
-
 	return 0;
 
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
-
 } /* end setup_rt_frame() */
 
 /*****************************************************************************/
 /*
  * OK, we're invoking a handler
  */
-static void handle_signal(unsigned long sig, siginfo_t *info,
-			 struct k_sigaction *ka)
+static void handle_signal(struct ksignal *ksig)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
@@ -378,7 +366,7 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
 			break;
 
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				__frame->gr8 = -EINTR;
 				break;
 			}
@@ -392,16 +380,12 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
 	}
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset);
 	else
-		ret = setup_frame(sig, ka, oldset);
-
-	if (ret)
-		return;
+		ret = setup_frame(ksig, oldset);
 
-	signal_delivered(sig, info, ka, __frame,
-				 test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 } /* end handle_signal() */
 
 /*****************************************************************************/
@@ -412,13 +396,10 @@ static void handle_signal(unsigned long sig, siginfo_t *info,
  */
 static void do_signal(void)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
+	struct ksignal ksig;
 
-	signr = get_signal_to_deliver(&info, &ka, __frame, NULL);
-	if (signr > 0) {
-		handle_signal(signr, &info, &ka);
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig);
 		return;
 	}
 
-- 
1.8.4.2

