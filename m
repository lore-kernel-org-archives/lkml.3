Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaCCAJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:09:17 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62423 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbaCBX5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:57:47 -0500
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
Subject: [PATCH 15/44] mn10300: Use get_signal() signal_setup_done()
Date: Mon,  3 Mar 2014 00:57:19 +0100
Message-Id: <1393804646-7797-5-git-send-email-richard@nod.at>
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
 arch/mn10300/kernel/signal.c | 89 ++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 53 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 9dfac5c..0c97202 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -207,16 +207,16 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
 /*
  * set up a normal signal frame
  */
-static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
 		       struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int rsig;
+	int rsig, sig = ksig->sig;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	rsig = sig;
 	if (sig < 32 &&
@@ -226,40 +226,40 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 
 	if (__put_user(rsig, &frame->sig) < 0 ||
 	    __put_user(&frame->sc, &frame->psc) < 0)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (setup_sigcontext(&frame->sc, &frame->fpuctx, regs, set->sig[0]))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
 		if (__copy_to_user(frame->extramask, &set->sig[1],
 				   sizeof(frame->extramask)))
-			goto give_sigsegv;
+			return -EFAULT;
 	}
 
 	/* set up to return from userspace.  If provided, use a stub already in
 	 * userspace */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		if (__put_user(ka->sa.sa_restorer, &frame->pretcode))
-			goto give_sigsegv;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ksig->ka.sa.sa_restorer, &frame->pretcode))
+			return -EFAULT;
 	} else {
 		if (__put_user((void (*)(void))frame->retcode,
 			       &frame->pretcode))
-			goto give_sigsegv;
+			return -EFAULT;
 		/* this is mov $,d0; syscall 0 */
 		if (__put_user(0x2c, (char *)(frame->retcode + 0)) ||
 		    __put_user(__NR_sigreturn, (char *)(frame->retcode + 1)) ||
 		    __put_user(0x00, (char *)(frame->retcode + 2)) ||
 		    __put_user(0xf0, (char *)(frame->retcode + 3)) ||
 		    __put_user(0xe0, (char *)(frame->retcode + 4)))
-			goto give_sigsegv;
+			return -EFAULT;
 		flush_icache_range((unsigned long) frame->retcode,
 				   (unsigned long) frame->retcode + 5);
 	}
 
 	/* set up registers for signal handler */
 	regs->sp = (unsigned long) frame;
-	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
 	regs->d0 = sig;
 	regs->d1 = (unsigned long) &frame->sc;
 
@@ -270,25 +270,21 @@ static int setup_frame(int sig, struct k_sigaction *ka, sigset_t *set,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
  * set up a realtime signal frame
  */
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-			  sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int rsig;
+	int rsig, sig = ksig->sig;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	rsig = sig;
 	if (sig < 32 &&
@@ -299,8 +295,8 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (__put_user(rsig, &frame->sig) ||
 	    __put_user(&frame->info, &frame->pinfo) ||
 	    __put_user(&frame->uc, &frame->puc) ||
-	    copy_siginfo_to_user(&frame->info, info))
-		goto give_sigsegv;
+	    copy_siginfo_to_user(&frame->info, &ksig->info))
+		return -EFAULT;
 
 	/* create the ucontext.  */
 	if (__put_user(0, &frame->uc.uc_flags) ||
@@ -309,13 +305,14 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	    setup_sigcontext(&frame->uc.uc_mcontext,
 			     &frame->fpuctx, regs, set->sig[0]) ||
 	    __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* set up to return from userspace.  If provided, use a stub already in
 	 * userspace */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		if (__put_user(ka->sa.sa_restorer, &frame->pretcode))
-			goto give_sigsegv;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		if (__put_user(ksig->ka.sa.sa_restorer, &frame->pretcode))
+			return -EFAULT;
+
 	} else {
 		if (__put_user((void(*)(void))frame->retcode,
 			       &frame->pretcode) ||
@@ -326,7 +323,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		    __put_user(0x00, (char *)(frame->retcode + 2)) ||
 		    __put_user(0xf0, (char *)(frame->retcode + 3)) ||
 		    __put_user(0xe0, (char *)(frame->retcode + 4)))
-			goto give_sigsegv;
+			return -EFAULT;
 
 		flush_icache_range((u_long) frame->retcode,
 				   (u_long) frame->retcode + 5);
@@ -334,7 +331,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long) frame;
-	regs->pc = (unsigned long) ka->sa.sa_handler;
+	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
 	regs->d0 = sig;
 	regs->d1 = (long) &frame->info;
 
@@ -345,10 +342,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 #endif
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 static inline void stepback(struct pt_regs *regs)
@@ -360,9 +353,7 @@ static inline void stepback(struct pt_regs *regs)
 /*
  * handle the actual delivery of a signal to userspace
  */
-static int handle_signal(int sig,
-			 siginfo_t *info, struct k_sigaction *ka,
-			 struct pt_regs *regs)
+static int handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
@@ -377,7 +368,7 @@ static int handle_signal(int sig,
 			break;
 
 		case -ERESTARTSYS:
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->d0 = -EINTR;
 				break;
 			}
@@ -390,15 +381,12 @@ static int handle_signal(int sig,
 	}
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset, regs);
 	else
-		ret = setup_frame(sig, ka, oldset, regs);
-	if (ret)
-		return ret;
+		ret = setup_frame(ksig, oldset, regs);
 
-	signal_delivered(sig, info, ka, regs,
-			 test_thread_flag(TIF_SINGLESTEP));
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 	return 0;
 }
 
@@ -407,15 +395,10 @@ static int handle_signal(int sig,
  */
 static void do_signal(struct pt_regs *regs)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
-	int signr;
-
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
-		if (handle_signal(signr, &info, &ka, regs) == 0) {
-		}
+	struct ksignal ksig;
 
+	if (get_signal(&ksig)) {
+		handle_signal(&ksig, regs);
 		return;
 	}
 
-- 
1.8.4.2

