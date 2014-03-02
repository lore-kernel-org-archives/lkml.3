Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaCBX7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:59:47 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62415 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaCBX7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:45 -0500
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
Subject: [PATCH 30/44] arm: Use translate_signal()
Date: Mon,  3 Mar 2014 00:59:13 +0100
Message-Id: <1393804758-7916-8-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/arm/kernel/signal.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 04d6388..9c6a908 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/random.h>
 #include <linux/signal.h>
-#include <linux/personality.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
 
@@ -317,17 +316,6 @@ get_sigframe(struct ksignal *ksig, struct pt_regs *regs, int framesize)
 	return frame;
 }
 
-/*
- * translate the signal
- */
-static inline int map_sig(int sig)
-{
-	struct thread_info *thread = current_thread_info();
-	if (sig < 32 && thread->exec_domain && thread->exec_domain->signal_invmap)
-		sig = thread->exec_domain->signal_invmap[sig];
-	return sig;
-}
-
 static int
 setup_return(struct pt_regs *regs, struct ksignal *ksig,
 	     unsigned long __user *rc, void __user *frame)
@@ -411,7 +399,7 @@ setup_return(struct pt_regs *regs, struct ksignal *ksig,
 		}
 	}
 
-	regs->ARM_r0 = map_sig(ksig->sig);
+	regs->ARM_r0 = translate_signal(ksig->sig);
 	regs->ARM_sp = (unsigned long)frame;
 	regs->ARM_lr = retcode;
 	regs->ARM_pc = handler;
-- 
1.8.4.2

