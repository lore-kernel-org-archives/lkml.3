Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaHKFm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:42:58 -0400
Received: from bes.se.axis.com ([195.60.68.10]:50086 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbaHKFmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:42:40 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Aug 2014 01:42:39 EDT
From: Mikael Starvik <mikael.starvik@axis.com>
To: Richard Weinberger <richard@sigma-star.at>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Date: Mon, 11 Aug 2014 07:35:44 +0200
Subject: RE: [PATCH 06/43] cris: Use get_signal() signal_setup_done()
Thread-Topic: [PATCH 06/43] cris: Use get_signal() signal_setup_done()
Thread-Index: Ac+k7KPpdQJdQp23TY+Lvg44df4qXQQOXOvg
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D0589EBFBC0FD@xmail3.se.axis.com>
References: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
 <1405951409-16953-7-git-send-email-richard@sigma-star.at>
In-Reply-To: <1405951409-16953-7-git-send-email-richard@sigma-star.at>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mikael Starvik <mikael.starvik@axis.com>

-----Original Message-----
From: Richard Weinberger [mailto:richard@sigma-star.at] 
Sent: den 21 juli 2014 16:03
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; Richard Weinberger; Mikael Starvik; Jesper Nilsson; linux-cris-kernel
Subject: [PATCH 06/43] cris: Use get_signal() signal_setup_done()

From: Richard Weinberger <richard@nod.at>

Use the more generic functions get_signal() signal_setup_done() for signal delivery.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/cris/arch-v10/kernel/signal.c | 79 ++++++++++++++++----------------------
 arch/cris/arch-v32/kernel/signal.c | 77 +++++++++++++++----------------------
 2 files changed, 63 insertions(+), 93 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/signal.c b/arch/cris/arch-v10/kernel/signal.c
index 61ce627..12aac1f 100644
--- a/arch/cris/arch-v10/kernel/signal.c
+++ b/arch/cris/arch-v10/kernel/signal.c
@@ -228,33 +228,33 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
  * user-mode trampoline.
  */
 
-static int setup_frame(int sig, struct k_sigaction *ka,
-		       sigset_t *set, struct pt_regs *regs)
+static int setup_frame(struct ksignal *ksig, sigset_t *set,
+		       struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
 	unsigned long return_ip;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= setup_sigcontext(&frame->sc, regs, set->sig[0]);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
 		err |= __copy_to_user(frame->extramask, &set->sig[1],
 				      sizeof(frame->extramask));
 	}
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		return_ip = (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		return_ip = (unsigned long)ksig->ka.sa.sa_restorer;
 	} else {
 		/* trampoline - the desired return ip is the retcode itself */
 		return_ip = (unsigned long)&frame->retcode; @@ -265,42 +265,38 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	}
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up registers for signal handler */
 
-	regs->irp = (unsigned long) ka->sa.sa_handler;  /* what we enter NOW   */
+	regs->irp = (unsigned long) ksig->ka.sa.sa_handler;  /* what we enter NOW   */
 	regs->srp = return_ip;                          /* what we enter LATER */
-	regs->r10 = sig;                                /* first argument is signo */
+	regs->r10 = ksig->sig;                                /* first argument is signo */
 
 	/* actually move the usp to reflect the stacked frame */
 
 	wrusp((unsigned long)frame);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
-static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	sigset_t *set, struct pt_regs *regs)
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
+			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
 	unsigned long return_ip;
 	int err = 0;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Clear all the bits of the ucontext we don't use.  */
         err |= __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext)); @@ -312,12 +308,12 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __save_altstack(&frame->uc.uc_stack, rdusp());
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Set up to return from userspace.  If provided, use a stub
 	   already in userspace.  */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		return_ip = (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		return_ip = (unsigned long)ksig->ka.sa.sa_restorer;
 	} else {
 		/* trampoline - the desired return ip is the retcode itself */
 		return_ip = (unsigned long)&frame->retcode; @@ -329,18 +325,18 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* TODO what is the current->exec_domain stuff and invmap ? */
 
 	/* Set up registers for signal handler */
 
 	/* What we enter NOW   */
-	regs->irp = (unsigned long) ka->sa.sa_handler;
+	regs->irp = (unsigned long) ksig->ka.sa.sa_handler;
 	/* What we enter LATER */
 	regs->srp = return_ip;
 	/* First argument is signo */
-	regs->r10 = sig;
+	regs->r10 = ksig->sig;
 	/* Second argument is (siginfo_t *) */
 	regs->r11 = (unsigned long)&frame->info;
 	/* Third argument is unused */
@@ -350,19 +346,14 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	wrusp((unsigned long)frame);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /*
  * OK, we're invoking a handler
  */
 
-static inline void handle_signal(int canrestart, unsigned long sig,
-	siginfo_t *info, struct k_sigaction *ka,
-	struct pt_regs *regs)
+static inline void handle_signal(int canrestart, struct ksignal *ksig,
+				 struct pt_regs *regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
@@ -383,7 +374,7 @@ static inline void handle_signal(int canrestart, unsigned long sig,
 			/* ERESTARTSYS means to restart the syscall if
 			 * there is no handler or the handler was
 			 * registered with SA_RESTART */
-			if (!(ka->sa.sa_flags & SA_RESTART)) {
+			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 				regs->r10 = -EINTR;
 				break;
 			}
@@ -396,13 +387,12 @@ static inline void handle_signal(int canrestart, unsigned long sig,
 	}
 
 	/* Set up the stack frame */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset, regs);
 	else
-		ret = setup_frame(sig, ka, oldset, regs);
+		ret = setup_frame(ksig, oldset, regs);
 
-	if (ret == 0)
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 /*
@@ -419,9 +409,7 @@ static inline void handle_signal(int canrestart, unsigned long sig,
 
 void do_signal(int canrestart, struct pt_regs *regs)  {
-	siginfo_t info;
-	int signr;
-        struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * We want the common case to go fast, which @@ -432,10 +420,9 @@ void do_signal(int canrestart, struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(canrestart, signr, &info, &ka, regs);
+		handle_signal(canrestart, &ksig, regs);
 		return;
 	}
 
diff --git a/arch/cris/arch-v32/kernel/signal.c b/arch/cris/arch-v32/kernel/signal.c
index 01d1375..cc7a39a 100644
--- a/arch/cris/arch-v32/kernel/signal.c
+++ b/arch/cris/arch-v32/kernel/signal.c
@@ -215,23 +215,22 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
  * trampoline.
   */
 static int
-setup_frame(int sig, struct k_sigaction *ka,  sigset_t *set,
-	    struct pt_regs * regs)
+setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	int err;
 	unsigned long return_ip;
 	struct signal_frame __user *frame;
 
 	err = 0;
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	err |= setup_sigcontext(&frame->sc, regs, set->sig[0]);
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	if (_NSIG_WORDS > 1) {
 		err |= __copy_to_user(frame->extramask, &set->sig[1], @@ -239,14 +238,14 @@ setup_frame(int sig, struct k_sigaction *ka,  sigset_t *set,
 	}
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Set up to return from user-space. If provided, use a stub
 	 * already located in user-space.
 	 */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		return_ip = (unsigned long)ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		return_ip = (unsigned long)ksig->ka.sa.sa_restorer;
 	} else {
 		/* Trampoline - the desired return ip is in the signal return page. */
 		return_ip = cris_signal_return_page;
@@ -264,7 +263,7 @@ setup_frame(int sig, struct k_sigaction *ka,  sigset_t *set,
 	}
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Set up registers for signal handler.
@@ -273,42 +272,37 @@ setup_frame(int sig, struct k_sigaction *ka,  sigset_t *set,
 	 * Where the code enter later.
 	 * First argument, signo.
 	 */
-	regs->erp = (unsigned long) ka->sa.sa_handler;
+	regs->erp = (unsigned long) ksig->ka.sa.sa_handler;
 	regs->srp = return_ip;
-	regs->r10 = sig;
+	regs->r10 = ksig->sig;
 
 	/* Actually move the USP to reflect the stacked frame. */
 	wrusp((unsigned long)frame);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 static int
-setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-	       sigset_t *set, struct pt_regs * regs)
+setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs 
+*regs)
 {
 	int err;
 	unsigned long return_ip;
 	struct rt_signal_frame __user *frame;
 
 	err = 0;
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* TODO: what is the current->exec_domain stuff and invmap ? */
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/* Clear all the bits of the ucontext we don't use.  */
 	err |= __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext)); @@ -317,14 +311,14 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	err |= __save_altstack(&frame->uc.uc_stack, rdusp());
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Set up to return from user-space. If provided, use a stub
 	 * already located in user-space.
 	 */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		return_ip = (unsigned long) ka->sa.sa_restorer;
+	if (ksig->ka.sa.sa_flags & SA_RESTORER) {
+		return_ip = (unsigned long) ksig->ka.sa.sa_restorer;
 	} else {
 		/* Trampoline - the desired return ip is in the signal return page. */
 		return_ip = cris_signal_return_page + 6; @@ -345,7 +339,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	}
 
 	if (err)
-		goto give_sigsegv;
+		return -EFAULT;
 
 	/*
 	 * Set up registers for signal handler.
@@ -356,9 +350,9 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * Second argument is (siginfo_t *).
 	 * Third argument is unused.
 	 */
-	regs->erp = (unsigned long) ka->sa.sa_handler;
+	regs->erp = (unsigned long) ksig->ka.sa.sa_handler;
 	regs->srp = return_ip;
-	regs->r10 = sig;
+	regs->r10 = ksig->sig;
 	regs->r11 = (unsigned long) &frame->info;
 	regs->r12 = 0;
 
@@ -366,17 +360,11 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	wrusp((unsigned long)frame);
 
 	return 0;
-
-give_sigsegv:
-	force_sigsegv(sig, current);
-	return -EFAULT;
 }
 
 /* Invoke a signal handler to, well, handle the signal. */  static inline void -handle_signal(int canrestart, unsigned long sig,
-	      siginfo_t *info, struct k_sigaction *ka,
-              struct pt_regs * regs)
+handle_signal(int canrestart, struct ksignal *ksig, struct pt_regs 
+*regs)
 {
 	sigset_t *oldset = sigmask_to_save();
 	int ret;
@@ -404,7 +392,7 @@ handle_signal(int canrestart, unsigned long sig,
                                  * there is no handler, or the handler
                                  * was registered with SA_RESTART.
 				 */
-				if (!(ka->sa.sa_flags & SA_RESTART)) {
+				if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
 					regs->r10 = -EINTR;
 					break;
 				}
@@ -423,13 +411,12 @@ handle_signal(int canrestart, unsigned long sig,
         }
 
 	/* Set up the stack frame. */
-	if (ka->sa.sa_flags & SA_SIGINFO)
-		ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
+		ret = setup_rt_frame(ksig, oldset, regs);
 	else
-		ret = setup_frame(sig, ka, oldset, regs);
+		ret = setup_frame(ksig, oldset, regs);
 
-	if (ret == 0)
-		signal_delivered(sig, info, ka, regs, 0);
+	signal_setup_done(ret, ksig, 0);
 }
 
 /*
@@ -446,9 +433,7 @@ handle_signal(int canrestart, unsigned long sig,  void  do_signal(int canrestart, struct pt_regs *regs)  {
-	int signr;
-	siginfo_t info;
-        struct k_sigaction ka;
+	struct ksignal ksig;
 
 	/*
 	 * The common case should go fast, which is why this point is @@ -458,11 +443,9 @@ do_signal(int canrestart, struct pt_regs *regs)
 	if (!user_mode(regs))
 		return;
 
-	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
-
-	if (signr > 0) {
+	if (get_signal(&ksig)) {
 		/* Whee!  Actually deliver the signal.  */
-		handle_signal(canrestart, signr, &info, &ka, regs);
+		handle_signal(canrestart, &ksig, regs);
 		return;
 	}
 
--
1.8.4.5

