Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaCCADP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:03:15 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62425 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaCCAB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:28 -0500
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
Subject: [PATCH 40/44] tile: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:40 +0100
Message-Id: <1393804844-8008-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804844-8008-1-git-send-email-richard@nod.at>
References: <1393804844-8008-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/tile/kernel/compat_signal.c | 12 ++----------
 arch/tile/kernel/signal.c        | 12 ++----------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 8c5abf2..b14e5e9 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -21,7 +21,6 @@
 #include <linux/wait.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
-#include <linux/personality.h>
 #include <linux/suspend.h>
 #include <linux/ptrace.h>
 #include <linux/elf.h>
@@ -195,20 +194,13 @@ int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	unsigned long restorer;
 	struct compat_rt_sigframe __user *frame;
-	int err = 0, sig = ksig->sig;
-	int usig;
+	int err = 0;
 
 	frame = compat_get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto err;
 
-	usig = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
-
 	/* Always write at least the signal number for the stack backtracer. */
 	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		/* At sigreturn time, restore the callee-save registers too. */
@@ -243,7 +235,7 @@ int compat_setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	regs->ex1 = PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp = ptr_to_compat_reg(frame);
 	regs->lr = restorer;
-	regs->regs[0] = (unsigned long) usig;
+	regs->regs[0] = (unsigned long) translate_signal(ksig->sig);
 	regs->regs[1] = ptr_to_compat_reg(&frame->info);
 	regs->regs[2] = ptr_to_compat_reg(&frame->uc);
 	regs->flags |= PT_FLAGS_CALLER_SAVES;
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 27aba86..5837ccf 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -22,7 +22,6 @@
 #include <linux/wait.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
-#include <linux/personality.h>
 #include <linux/suspend.h>
 #include <linux/ptrace.h>
 #include <linux/elf.h>
@@ -158,20 +157,13 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	unsigned long restorer;
 	struct rt_sigframe __user *frame;
-	int err = 0, sig = ksig->sig;
-	int usig;
+	int err = 0;
 
 	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto err;
 
-	usig = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
-
 	/* Always write at least the signal number for the stack backtracer. */
 	if (ksig->ka.sa.sa_flags & SA_SIGINFO) {
 		/* At sigreturn time, restore the callee-save registers too. */
@@ -206,7 +198,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	regs->ex1 = PL_ICS_EX1(USER_PL, 1); /* set crit sec in handler */
 	regs->sp = (unsigned long) frame;
 	regs->lr = restorer;
-	regs->regs[0] = (unsigned long) usig;
+	regs->regs[0] = (unsigned long) translate_signal(ksig->sig);
 	regs->regs[1] = (unsigned long) &frame->info;
 	regs->regs[2] = (unsigned long) &frame->uc;
 	regs->flags |= PT_FLAGS_CALLER_SAVES;
-- 
1.8.4.2

