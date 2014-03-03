Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaCCABb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:01:31 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62424 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523AbaCCAB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:27 -0500
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
Subject: [PATCH 39/44] sh: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:39 +0100
Message-Id: <1393804844-8008-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804844-8008-1-git-send-email-richard@nod.at>
References: <1393804844-8008-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/sh/kernel/signal_32.c | 23 ++++-------------------
 arch/sh/kernel/signal_64.c | 19 ++++---------------
 2 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 2ee67c5..9fe811b 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -20,7 +20,6 @@
 #include <linux/stddef.h>
 #include <linux/tty.h>
 #include <linux/elf.h>
-#include <linux/personality.h>
 #include <linux/binfmts.h>
 #include <linux/io.h>
 #include <linux/tracehook.h>
@@ -270,20 +269,13 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 		       struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int err = 0, sig = ksig->sig;
-	int signal;
+	int err = 0;
 
 	frame = get_sigframe(&ksig->ka, regs->regs[15], sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	signal = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
-
 	err |= setup_sigcontext(&frame->sc, regs, set->sig[0]);
 
 	if (_NSIG_WORDS > 1)
@@ -317,7 +309,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 
 	/* Set up registers for signal handler */
 	regs->regs[15] = (unsigned long) frame;
-	regs->regs[4] = signal; /* Arg for signal handler */
+	regs->regs[4] = translate_signal(ksig->sig); /* Arg for signal handler */
 	regs->regs[5] = 0;
 	regs->regs[6] = (unsigned long) &frame->sc;
 
@@ -345,20 +337,13 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err = 0, sig = ksig->sig;
-	int signal;
+	int err = 0;
 
 	frame = get_sigframe(&ksig->ka, regs->regs[15], sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	signal = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
-
 	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
 	/* Create the ucontext.  */
@@ -396,7 +381,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 
 	/* Set up registers for signal handler */
 	regs->regs[15] = (unsigned long) frame;
-	regs->regs[4] = signal; /* Arg for signal handler */
+	regs->regs[4] = translate_signal(ksig->sig); /* Arg for signal handler */
 	regs->regs[5] = (unsigned long) &frame->info;
 	regs->regs[6] = (unsigned long) &frame->uc;
 
diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 897abe7..693f450 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -17,7 +17,6 @@
 #include <linux/signal.h>
 #include <linux/errno.h>
 #include <linux/wait.h>
-#include <linux/personality.h>
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
@@ -377,19 +376,14 @@ void sa_default_rt_restorer(void);	/* See comments below */
 static int setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int err = 0, sig = ksig->sig;
-	int signal;
+	int err = 0, signal;
 
 	frame = get_sigframe(&ksig->ka, regs->regs[REG_SP], sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	signal = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
+	signal = translate_signal(ksig->sig);
 
 	err |= setup_sigcontext(&frame->sc, regs, set->sig[0]);
 
@@ -472,19 +466,14 @@ static int setup_rt_frame(struct ksignal *kig, sigset_t *set,
 			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err = 0, sig = ksig->sig;
-	int signal;
+	int err = 0, signal;
 
 	frame = get_sigframe(&ksig->ka, regs->regs[REG_SP], sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	signal = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
+	signal = translate_signal(ksig->sig);
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-- 
1.8.4.2

