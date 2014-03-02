Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaCCAGr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:06:47 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62414 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbaCBX7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:43 -0500
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
Subject: [PATCH 29/44] arc: Use translate_signal()
Date: Mon,  3 Mar 2014 00:59:12 +0100
Message-Id: <1393804758-7916-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arc/kernel/signal.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index c2031e2..bf11c8d 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -49,7 +49,6 @@
 
 #include <linux/signal.h>
 #include <linux/ptrace.h>
-#include <linux/personality.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
 #include <linux/tracehook.h>
@@ -166,18 +165,6 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
 	return frame;
 }
 
-/*
- * translate the signal
- */
-static inline int map_sig(int sig)
-{
-	struct thread_info *thread = current_thread_info();
-	if (thread->exec_domain && thread->exec_domain->signal_invmap
-	    && sig < 32)
-		sig = thread->exec_domain->signal_invmap[sig];
-	return sig;
-}
-
 static int
 setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 {
@@ -226,7 +213,7 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 		return err;
 
 	/* #1 arg to the user Signal handler */
-	regs->r0 = map_sig(ksig->sig);
+	regs->r0 = translate_signal(ksig->sig);
 
 	/* setup PC of user space signal handler */
 	regs->ret = (unsigned long)ksig->ka.sa.sa_handler;
-- 
1.8.4.2

