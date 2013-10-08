Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3JHLd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:33:27 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755906Ab3JHLdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:33:24 -0400
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
Subject: [PATCH 10/29] ia64: Use get_signal() signal_setup_done()
Date: Tue,  8 Oct 2013 13:33:10 +0200
Message-Id: <1381231994-4192-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more generic functions get_signal() signal_setup_done()
for signal delivery.
This inverts also the return codes of force_sigsegv_info()
and setup_frame() to follow the kernel convention.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/ia64/kernel/signal.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 3637e03..b995dbf 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -309,12 +309,11 @@ force_sigsegv_info (int sig, void __user *addr)
 	si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
 	si.si_addr = addr;
 	force_sig_info(SIGSEGV, &si, current);
-	return 0;
+	return 1;
 }
 
 static long
-setup_frame (int sig, struct k_sigaction *ka, siginfo_t *info, sigset_t *set,
-	     struct sigscratch *scr)
+setup_frame(struct ksignal *ksig, sigset_t *set, struct sigscratch *scr)
 {
 	extern char __kernel_sigtramp[];
 	unsigned long tramp_addr, new_rbs = 0, new_sp;
@@ -323,7 +322,7 @@ setup_frame (int sig, struct k_sigaction *ka, siginfo_t *info, sigset_t *set,
 
 	new_sp = scr->pt.r12;
 	tramp_addr = (unsigned long) __kernel_sigtramp;
-	if (ka->sa.sa_flags & SA_ONSTACK) {
+	if (ksig->ka.sa.sa_flags & SA_ONSTACK) {
 		int onstack = sas_ss_flags(new_sp);
 
 		if (onstack == 0) {
@@ -347,7 +346,7 @@ setup_frame (int sig, struct k_sigaction *ka, siginfo_t *info, sigset_t *set,
 			 */
 			check_sp = (new_sp - sizeof(*frame)) & -STACK_ALIGN;
 			if (!likely(on_sig_stack(check_sp)))
-				return force_sigsegv_info(sig, (void __user *)
+				return force_sigsegv_info(ksig->sig, (void __user *)
 							  check_sp);
 		}
 	}
@@ -356,14 +355,14 @@ setup_frame (int sig, struct k_sigaction *ka, siginfo_t *info, sigset_t *set,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return force_sigsegv_info(sig, frame);
 
-	err  = __put_user(sig, &frame->arg0);
+	err  = __put_user(ksig->sig, &frame->arg0);
 	err |= __put_user(&frame->info, &frame->arg1);
 	err |= __put_user(&frame->sc, &frame->arg2);
 	err |= __put_user(new_rbs, &frame->sc.sc_rbs_base);
 	err |= __put_user(0, &frame->sc.sc_loadrs);	/* initialize to zero */
-	err |= __put_user(ka->sa.sa_handler, &frame->handler);
+	err |= __put_user(ksig->ka.sa.sa_handler, &frame->handler);
 
-	err |= copy_siginfo_to_user(&frame->info, info);
+	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	err |= __save_altstack(&frame->sc.sc_stack, scr->pt.r12);
 	err |= setup_sigcontext(&frame->sc, set, scr);
@@ -394,22 +393,20 @@ setup_frame (int sig, struct k_sigaction *ka, siginfo_t *info, sigset_t *set,
 
 #if DEBUG_SIG
 	printk("SIG deliver (%s:%d): sig=%d sp=%lx ip=%lx handler=%p\n",
-	       current->comm, current->pid, sig, scr->pt.r12, frame->sc.sc_ip, frame->handler);
+	       current->comm, current->pid, ksig->sig, scr->pt.r12, frame->sc.sc_ip, frame->handler);
 #endif
-	return 1;
+	return 0;
 }
 
 static long
-handle_signal (unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
-	       struct sigscratch *scr)
+handle_signal (struct ksignal *ksig, struct sigscratch *scr)
 {
-	if (!setup_frame(sig, ka, info, sigmask_to_save(), scr))
-		return 0;
+	int ret = setup_frame(ksig, sigmask_to_save(), scr);
 
-	signal_delivered(sig, info, ka, &scr->pt,
-				 test_thread_flag(TIF_SINGLESTEP));
+	if (!ret)
+		signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 
-	return 1;
+	return ret;
 }
 
 /*
@@ -419,17 +416,16 @@ handle_signal (unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 void
 ia64_do_signal (struct sigscratch *scr, long in_syscall)
 {
-	struct k_sigaction ka;
-	siginfo_t info;
 	long restart = in_syscall;
 	long errno = scr->pt.r8;
+	struct ksignal ksig;
 
 	/*
 	 * This only loops in the rare cases of handle_signal() failing, in which case we
 	 * need to push through a forced SIGSEGV.
 	 */
 	while (1) {
-		int signr = get_signal_to_deliver(&info, &ka, &scr->pt, NULL);
+		get_signal(&ksig);
 
 		/*
 		 * get_signal_to_deliver() may have run a debugger (via notify_parent())
@@ -446,7 +442,7 @@ ia64_do_signal (struct sigscratch *scr, long in_syscall)
 			 */
 			restart = 0;
 
-		if (signr <= 0)
+		if (ksig.sig <= 0)
 			break;
 
 		if (unlikely(restart)) {
@@ -458,7 +454,7 @@ ia64_do_signal (struct sigscratch *scr, long in_syscall)
 				break;
 
 			      case ERESTARTSYS:
-				if ((ka.sa.sa_flags & SA_RESTART) == 0) {
+				if ((ksig.ka.sa.sa_flags & SA_RESTART) == 0) {
 					scr->pt.r8 = EINTR;
 					/* note: scr->pt.r10 is already -1 */
 					break;
@@ -473,7 +469,7 @@ ia64_do_signal (struct sigscratch *scr, long in_syscall)
 		 * Whee!  Actually deliver the signal.  If the delivery failed, we need to
 		 * continue to iterate in this loop so we can deliver the SIGSEGV...
 		 */
-		if (handle_signal(signr, &ka, &info, scr))
+		if (handle_signal(&ksig, scr))
 			return;
 	}
 
-- 
1.8.1.4

