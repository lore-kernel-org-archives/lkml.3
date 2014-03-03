Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaCCADv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:03:51 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62422 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbaCCABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:24 -0500
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
Subject: [PATCH 35/44] m68k: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:35 +0100
Message-Id: <1393804844-8008-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/m68k/kernel/signal.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index c8e6fa8..b8a428b 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -39,7 +39,6 @@
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/highuid.h>
-#include <linux/personality.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
 #include <linux/module.h>
@@ -871,12 +870,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set,
 	if (fsize)
 		err |= copy_to_user (frame + 1, regs + 1, fsize);
 
-	err |= __put_user((current_thread_info()->exec_domain
-			   && current_thread_info()->exec_domain->signal_invmap
-			   && sig < 32
-			   ? current_thread_info()->exec_domain->signal_invmap[sig]
-			   : sig),
-			  &frame->sig);
+	err |= __put_user(translate_signal(sig), &frame->sig);
 
 	err |= __put_user(regs->vector, &frame->code);
 	err |= __put_user(&frame->sc, &frame->psc);
@@ -956,12 +950,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	if (fsize)
 		err |= copy_to_user (&frame->uc.uc_extra, regs + 1, fsize);
 
-	err |= __put_user((current_thread_info()->exec_domain
-			   && current_thread_info()->exec_domain->signal_invmap
-			   && sig < 32
-			   ? current_thread_info()->exec_domain->signal_invmap[sig]
-			   : sig),
-			  &frame->sig);
+	err |= __put_user(translate_signal(sig), &frame->sig);
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
 	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
-- 
1.8.4.2

