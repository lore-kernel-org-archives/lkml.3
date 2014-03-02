Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbaCBX7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:59:55 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62418 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaCBX7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:59:52 -0500
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
Subject: [PATCH 33/44] frv: Use translate_signal()
Date: Mon,  3 Mar 2014 00:59:16 +0100
Message-Id: <1393804758-7916-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393804758-7916-1-git-send-email-richard@nod.at>
References: <1393804758-7916-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the common helper instead of it's own open coded variant.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/frv/kernel/signal.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/frv/kernel/signal.c b/arch/frv/kernel/signal.c
index 8e37cf2..108a74e 100644
--- a/arch/frv/kernel/signal.c
+++ b/arch/frv/kernel/signal.c
@@ -19,7 +19,6 @@
 #include <linux/wait.h>
 #include <linux/ptrace.h>
 #include <linux/unistd.h>
-#include <linux/personality.h>
 #include <linux/tracehook.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -183,7 +182,6 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
 static int setup_frame(struct ksignal *ksig, sigset_t *set)
 {
 	struct sigframe __user *frame;
-	int rsig, sig = ksig->sig;
 
 	set_fs(USER_DS);
 
@@ -192,13 +190,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set)
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	rsig = sig;
-	if (sig < 32 &&
-	    __current_thread_info->exec_domain &&
-	    __current_thread_info->exec_domain->signal_invmap)
-		rsig = __current_thread_info->exec_domain->signal_invmap[sig];
-
-	if (__put_user(rsig, &frame->sig) < 0)
+	if (__put_user(translate_signal(ksig->sig), &frame->sig) < 0)
 		return -EFAULT;
 
 	if (setup_sigcontext(&frame->sc, set->sig[0]))
@@ -246,11 +238,11 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set)
 
 	__frame->sp   = (unsigned long) frame;
 	__frame->lr   = (unsigned long) &frame->retcode;
-	__frame->gr8  = sig;
+	__frame->gr8  = ksig->sig;
 
 #if DEBUG_SIG
 	printk("SIG deliver %d (%s:%d): sp=%p pc=%lx ra=%p\n",
-	       sig, current->comm, current->pid, frame, __frame->pc,
+	       ksig->sig, current->comm, current->pid, frame, __frame->pc,
 	       frame->pretcode);
 #endif
 
@@ -264,7 +256,6 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set)
 static int setup_rt_frame(struct ksignal *ksig, sigset_t *set)
 {
 	struct rt_sigframe __user *frame;
-	int rsig, sig = ksig->sig;
 
 	set_fs(USER_DS);
 
@@ -273,13 +264,7 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set)
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	rsig = sig;
-	if (sig < 32 &&
-	    __current_thread_info->exec_domain &&
-	    __current_thread_info->exec_domain->signal_invmap)
-		rsig = __current_thread_info->exec_domain->signal_invmap[sig];
-
-	if (__put_user(rsig,		&frame->sig) ||
+	if (__put_user(translate_signal(ksig->sig), &frame->sig) ||
 	    __put_user(&frame->info,	&frame->pinfo) ||
 	    __put_user(&frame->uc,	&frame->puc))
 		return -EFAULT;
@@ -335,12 +320,12 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set)
 
 	__frame->sp  = (unsigned long) frame;
 	__frame->lr  = (unsigned long) &frame->retcode;
-	__frame->gr8 = sig;
+	__frame->gr8 = ksig->sig;
 	__frame->gr9 = (unsigned long) &frame->info;
 
 #if DEBUG_SIG
 	printk("SIG deliver %d (%s:%d): sp=%p pc=%lx ra=%p\n",
-	       sig, current->comm, current->pid, frame, __frame->pc,
+	       ksig->sig, current->comm, current->pid, frame, __frame->pc,
 	       frame->pretcode);
 #endif
 	return 0;
-- 
1.8.4.2

