Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaCCAEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:04:41 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62413 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaCBX7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:54 -0500
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
Subject: [PATCH 34/44] m32r: Use translate_signal()
Date: Mon,  3 Mar 2014 00:59:17 +0100
Message-Id: <1393804758-7916-12-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/m32r/kernel/signal.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index cce3fd3..2673513 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -19,7 +19,6 @@
 #include <linux/wait.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
-#include <linux/personality.h>
 #include <linux/tracehook.h>
 #include <asm/cacheflush.h>
 #include <asm/ucontext.h>
@@ -178,18 +177,14 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 {
 	struct rt_sigframe __user *frame;
 	int err = 0;
-	int signal, sig = ksig->sig;
+	int signal;
 
 	frame = get_sigframe(&ksig->ka, regs->spu, sizeof(*frame));
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	signal = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
+	signal = translate_signal(ksig->sig);
 
 	err |= __put_user(signal, &frame->sig);
 	if (err)
-- 
1.8.4.2

