Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaCCABY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:01:24 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62420 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaCCABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:21 -0500
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
Subject: [PATCH 36/44] microblaze: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:36 +0100
Message-Id: <1393804844-8008-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804844-8008-1-git-send-email-richard@nod.at>
References: <1393804844-8008-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/microblaze/kernel/signal.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index a34da52..7bde506 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -28,7 +28,6 @@
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
-#include <linux/personality.h>
 #include <linux/percpu.h>
 #include <linux/linkage.h>
 #include <linux/tracehook.h>
@@ -160,8 +159,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	int err = 0, sig = ksig->sig;
-	int signal;
+	int err = 0, signal;
 	unsigned long address = 0;
 #ifdef CONFIG_MMU
 	pmd_t *pmdp;
@@ -173,11 +171,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	signal = current_thread_info()->exec_domain
-		&& current_thread_info()->exec_domain->signal_invmap
-		&& sig < 32
-		? current_thread_info()->exec_domain->signal_invmap[sig]
-		: sig;
+	signal = translate_signal(ksig->sig);
 
 	if (ksig->ka.sa.sa_flags & SA_SIGINFO)
 		err |= copy_siginfo_to_user(&frame->info, &ksig->info);
-- 
1.8.4.2

