Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbaCCAB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 19:01:29 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62423 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaCCABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 19:01:25 -0500
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
Subject: [PATCH 38/44] s390: Use translate_signal()
Date: Mon,  3 Mar 2014 01:00:38 +0100
Message-Id: <1393804844-8008-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804844-8008-1-git-send-email-richard@nod.at>
References: <1393804844-8008-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/s390/kernel/compat_signal.c | 15 ++-------------
 arch/s390/kernel/signal.c        | 15 ++-------------
 2 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index f6c6140..0ac6be5 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -20,7 +20,6 @@
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/tty.h>
-#include <linux/personality.h>
 #include <linux/binfmts.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -310,16 +309,6 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
 	return (void __user *)((sp - frame_size) & -8ul);
 }
 
-static inline int map_signal(int sig)
-{
-	if (current_thread_info()->exec_domain
-	    && current_thread_info()->exec_domain->signal_invmap
-	    && sig < 32)
-		return current_thread_info()->exec_domain->signal_invmap[sig];
-        else
-		return sig;
-}
-
 static int setup_frame32(struct ksignal *ksig, sigset_t *set,
 			 struct pt_regs *regs)
 {
@@ -362,7 +351,7 @@ static int setup_frame32(struct ksignal *ksig, sigset_t *set,
 		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__force __u64) ksig->ka.sa.sa_handler;
 
-	regs->gprs[2] = map_signal(sig);
+	regs->gprs[2] = translate_signal(sig);
 	regs->gprs[3] = (__force __u64) &frame->sc;
 
 	/* We forgot to include these in the sigcontext.
@@ -426,7 +415,7 @@ static int setup_rt_frame32(struct ksignal *ksig, sigset_t *set,
 		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (__u64 __force) ksig->ka.sa.sa_handler;
 
-	regs->gprs[2] = map_signal(ksig->sig);
+	regs->gprs[2] = translate_signal(ksig->sig);
 	regs->gprs[3] = (__force __u64) &frame->info;
 	regs->gprs[4] = (__force __u64) &frame->uc;
 	regs->gprs[5] = task_thread_info(current)->last_break;
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 0e420a1..d63272b 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -20,7 +20,6 @@
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/tty.h>
-#include <linux/personality.h>
 #include <linux/binfmts.h>
 #include <linux/tracehook.h>
 #include <linux/syscalls.h>
@@ -182,16 +181,6 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs * regs, size_t frame_size)
 	return (void __user *)((sp - frame_size) & -8ul);
 }
 
-static inline int map_signal(int sig)
-{
-	if (current_thread_info()->exec_domain
-	    && current_thread_info()->exec_domain->signal_invmap
-	    && sig < 32)
-		return current_thread_info()->exec_domain->signal_invmap[sig];
-	else
-		return sig;
-}
-
 static int setup_frame(int sig, struct k_sigaction *ka,
 		       sigset_t *set, struct pt_regs * regs)
 {
@@ -235,7 +224,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ka->sa.sa_handler | PSW_ADDR_AMODE;
 
-	regs->gprs[2] = map_signal(sig);
+	regs->gprs[2] = translate_signal(sig);
 	regs->gprs[3] = (unsigned long) &frame->sc;
 
 	/* We forgot to include these in the sigcontext.
@@ -302,7 +291,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 		(regs->psw.mask & ~PSW_MASK_ASC);
 	regs->psw.addr = (unsigned long) ksig->ka.sa.sa_handler | PSW_ADDR_AMODE;
 
-	regs->gprs[2] = map_signal(ksig->sig);
+	regs->gprs[2] = translate_signal(ksig->sig);
 	regs->gprs[3] = (unsigned long) &frame->info;
 	regs->gprs[4] = (unsigned long) &frame->uc;
 	regs->gprs[5] = task_thread_info(current)->last_break;
-- 
1.8.4.2

