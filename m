Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaCCAB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:01:26 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62421 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaCCABX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:23 -0500
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
Subject: [PATCH 37/44] mn10300: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:37 +0100
Message-Id: <1393804844-8008-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804844-8008-1-git-send-email-richard@nod.at>
References: <1393804844-8008-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/mn10300/kernel/signal.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 0c97202..de75354 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -20,7 +20,6 @@
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/tty.h>
-#include <linux/personality.h>
 #include <linux/suspend.h>
 #include <linux/tracehook.h>
 #include <asm/cacheflush.h>
@@ -211,20 +210,13 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 		       struct pt_regs *regs)
 {
 	struct sigframe __user *frame;
-	int rsig, sig = ksig->sig;
 
 	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	rsig = sig;
-	if (sig < 32 &&
-	    current_thread_info()->exec_domain &&
-	    current_thread_info()->exec_domain->signal_invmap)
-		rsig = current_thread_info()->exec_domain->signal_invmap[sig];
-
-	if (__put_user(rsig, &frame->sig) < 0 ||
+	if (__put_user(translate_signal(ksig->sig), &frame->sig) < 0 ||
 	    __put_user(&frame->sc, &frame->psc) < 0)
 		return -EFAULT;
 
@@ -260,12 +252,12 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 	/* set up registers for signal handler */
 	regs->sp = (unsigned long) frame;
 	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
-	regs->d0 = sig;
+	regs->d0 = ksig->sig;
 	regs->d1 = (unsigned long) &frame->sc;
 
 #if DEBUG_SIG
 	printk(KERN_DEBUG "SIG deliver %d (%s:%d): sp=%p pc=%lx ra=%p\n",
-	       sig, current->comm, current->pid, frame, regs->pc,
+	       ksig->sig, current->comm, current->pid, frame, regs->pc,
 	       frame->pretcode);
 #endif
 
@@ -279,20 +271,13 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int rsig, sig = ksig->sig;
 
 	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	rsig = sig;
-	if (sig < 32 &&
-	    current_thread_info()->exec_domain &&
-	    current_thread_info()->exec_domain->signal_invmap)
-		rsig = current_thread_info()->exec_domain->signal_invmap[sig];
-
-	if (__put_user(rsig, &frame->sig) ||
+	if (__put_user(translate_signal(ksig->sig), &frame->sig) ||
 	    __put_user(&frame->info, &frame->pinfo) ||
 	    __put_user(&frame->uc, &frame->puc) ||
 	    copy_siginfo_to_user(&frame->info, &ksig->info))
@@ -332,12 +317,12 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	/* Set up registers for signal handler */
 	regs->sp = (unsigned long) frame;
 	regs->pc = (unsigned long) ksig->ka.sa.sa_handler;
-	regs->d0 = sig;
+	regs->d0 = ksig->sig;
 	regs->d1 = (long) &frame->info;
 
 #if DEBUG_SIG
 	printk(KERN_DEBUG "SIG deliver %d (%s:%d): sp=%p pc=%lx ra=%p\n",
-	       sig, current->comm, current->pid, frame, regs->pc,
+	       ksig->sig, current->comm, current->pid, frame, regs->pc,
 	       frame->pretcode);
 #endif
 
-- 
1.8.4.2

