Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3ARMb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:31:27 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:55893 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab3ARMbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:31:25 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v2 41/76] ARC: [3.8 tracking] altstack consolidation, trace_clock, cacheflush.h
Date: Fri, 18 Jan 2013 17:54:55 +0530
Message-ID: <1358511930-7424-42-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* 64d8f41 "switch rt_sigreturn instances to restore_altstack"
* b1c4c5a "unify native sigaltstack"
* f4a94f2 "new helpers: __save_altstack/__compat_save_altstack"

* 8cbd9cc "tracing,x86: Add a TSC trace_clock"
* 9b04ebd "asm-generic/io.h: remove asm/cacheflush.h include"

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig                   |    1 +
 arch/arc/include/asm/Kbuild        |    1 +
 arch/arc/include/asm/dma-mapping.h |    1 +
 arch/arc/kernel/signal.c           |   14 ++------------
 4 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 8fb9264..3adc87b 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -21,6 +21,7 @@ config ARC
 	select GENERIC_KERNEL_EXECVE
 	select GENERIC_KERNEL_THREAD
 	select GENERIC_PENDING_IRQ if SMP
+	select GENERIC_SIGALTSTACK
 	select GENERIC_SMP_IDLE_THREAD
 	select HAVE_GENERIC_HARDIRQS
 	select HOTPLUG if !INITRAMFS_SOURCE=""
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 148dfcf..105ec11 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -50,6 +50,7 @@ generic-y += statfs.h
 generic-y += termbits.h
 generic-y += termios.h
 generic-y += topology.h
+generic-y += trace_clock.h
 generic-y += types.h
 generic-y += ucontext.h
 generic-y += unaligned.h
diff --git a/arch/arc/include/asm/dma-mapping.h b/arch/arc/include/asm/dma-mapping.h
index ea0f56f..96e4316 100644
--- a/arch/arc/include/asm/dma-mapping.h
+++ b/arch/arc/include/asm/dma-mapping.h
@@ -12,6 +12,7 @@
 #define ASM_ARC_DMA_MAPPING_H
 
 #include <asm-generic/dma-coherent.h>
+#include <asm/cacheflush.h>
 #include <plat/dma_addr.h>
 
 void *dma_alloc_noncoherent(struct device *dev, size_t size,
diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index 6671968..9d97040 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -57,12 +57,6 @@
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
-asmlinkage int sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss)
-{
-	struct pt_regs *regs = task_pt_regs(current);
-	return do_sigaltstack(uss, uoss, regs->sp);
-}
-
 struct rt_sigframe {
 	struct siginfo info;
 	struct ucontext uc;
@@ -134,7 +128,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
 		goto badframe;
 
 	if (unlikely(is_do_ss_needed(magic)))
-		if (do_sigaltstack(&sf->uc.uc_stack, NULL, regs->sp) == -EFAULT)
+		if (restore_altstack(&sf->uc.uc_stack))
 			goto badframe;
 
 	/* Don't restart from sigreturn */
@@ -193,7 +187,6 @@ setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
 {
 	struct rt_sigframe __user *sf;
 	unsigned int magic = 0;
-	stack_t stk;
 	int err = 0;
 
 	sf = get_sigframe(ka, regs, sizeof(struct rt_sigframe));
@@ -210,10 +203,7 @@ setup_rt_frame(int signo, struct k_sigaction *ka, siginfo_t *info,
 		err |= copy_siginfo_to_user(&sf->info, info);
 		err |= __put_user(0, &sf->uc.uc_flags);
 		err |= __put_user(NULL, &sf->uc.uc_link);
-		stk.ss_sp = (void __user *)current->sas_ss_sp;
-		stk.ss_flags = sas_ss_flags(regs->sp);
-		stk.ss_size = current->sas_ss_size;
-		err |= __copy_to_user(&sf->uc.uc_stack, &stk, sizeof(stk));
+		err |= __save_altstack(&sf->uc.uc_stack, regs->sp);
 
 		/* setup args 2 and 3 fo ruse rmode handler */
 		regs->r1 = (unsigned long)&sf->info;
-- 
1.7.4.1

