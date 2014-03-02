Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaCCAFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:05:09 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62417 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbaCBX7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:49 -0500
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
Subject: [PATCH 32/44] blackfin: Use translate_signal()
Date: Mon,  3 Mar 2014 00:59:15 +0100
Message-Id: <1393804758-7916-10-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/blackfin/kernel/signal.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/blackfin/kernel/signal.c b/arch/blackfin/kernel/signal.c
index 1389cd3..707165a 100644
--- a/arch/blackfin/kernel/signal.c
+++ b/arch/blackfin/kernel/signal.c
@@ -8,7 +8,6 @@
 #include <linux/syscalls.h>
 #include <linux/ptrace.h>
 #include <linux/tty.h>
-#include <linux/personality.h>
 #include <linux/binfmts.h>
 #include <linux/uaccess.h>
 #include <linux/tracehook.h>
@@ -159,11 +158,7 @@ setup_rt_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs)
 
 	frame = get_sigframe(&ksig->ka, regs, sizeof(*frame));
 
-	err |= __put_user((current_thread_info()->exec_domain
-			   && current_thread_info()->exec_domain->signal_invmap
-			   && ksig->sig < 32
-			   ? current_thread_info()->exec_domain->
-			   signal_invmap[ksig->sig] : ksig->sig), &frame->sig);
+	err |= __put_user(translate_signal(ksig->sig), &frame->sig);
 
 	err |= __put_user(&frame->info, &frame->pinfo);
 	err |= __put_user(&frame->uc, &frame->puc);
-- 
1.8.4.2

