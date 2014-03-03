Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaCCABl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:01:41 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62409 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaCCABi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:38 -0500
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
Subject: [PATCH 43/44] um/x86: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:43 +0100
Message-Id: <1393804844-8008-9-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804844-8008-1-git-send-email-richard@nod.at>
References: <1393804844-8008-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/um/signal.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/um/signal.c b/arch/x86/um/signal.c
index 79d8245..1ffafa1 100644
--- a/arch/x86/um/signal.c
+++ b/arch/x86/um/signal.c
@@ -5,7 +5,6 @@
  */
 
 
-#include <linux/personality.h>
 #include <linux/ptrace.h>
 #include <linux/kernel.h>
 #include <asm/unistd.h>
@@ -504,7 +503,7 @@ int setup_signal_stack_si(unsigned long stack_top, struct ksignal *ksig,
 			  struct pt_regs *regs, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
-	int err = 0, sig = ksig->sig;
+	int err = 0;
 
 	frame = (struct rt_sigframe __user *)
 		round_down(stack_top - sizeof(struct rt_sigframe), 16);
@@ -550,14 +549,8 @@ int setup_signal_stack_si(unsigned long stack_top, struct ksignal *ksig,
 		return err;
 
 	/* Set up registers for signal handler */
-	{
-		struct exec_domain *ed = current_thread_info()->exec_domain;
-		if (unlikely(ed && ed->signal_invmap && sig < 32))
-			sig = ed->signal_invmap[sig];
-	}
-
 	PT_REGS_SP(regs) = (unsigned long) frame;
-	PT_REGS_DI(regs) = sig;
+	PT_REGS_DI(regs) = translate_signal(ksig->sig);
 	/* In case the signal handler was declared without prototypes */
 	PT_REGS_AX(regs) = 0;
 
-- 
1.8.4.2

