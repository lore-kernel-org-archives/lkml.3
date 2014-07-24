Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935095AbaGXKQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:16:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934413AbaGXJrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lennox Wu <lennox.wu@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 048/128] Score: The commit is for compiling successfully.
Date: Thu, 24 Jul 2014 10:44:57 +0100
Message-Id: <1406195177-8656-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lennox Wu <lennox.wu@gmail.com>

commit 5fbbf8a1a93452b26e7791cf32cefce62b0a480b upstream.
	The modifications include:
	1. Kconfig of Score: we don't support ioremap
	2. Missed headfile including
	3. There are some errors in other people's commit not checked by us, we fix it now
	3.1 arch/score/kernel/entry.S: wrong instructions
	3.2 arch/score/kernel/process.c : just some typos

Signed-off-by: Lennox Wu <lennox.wu@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/score/Kconfig               | 3 +++
 arch/score/include/asm/io.h      | 1 -
 arch/score/include/asm/pgalloc.h | 2 +-
 arch/score/kernel/entry.S        | 4 ++--
 arch/score/kernel/process.c      | 4 ++--
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 5fc237581caf..305f7ee1f382 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -111,3 +111,6 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+config NO_IOMEM
+       def_bool y
diff --git a/arch/score/include/asm/io.h b/arch/score/include/asm/io.h
index fbbfd7132e3b..574c8827abe2 100644
--- a/arch/score/include/asm/io.h
+++ b/arch/score/include/asm/io.h
@@ -5,5 +5,4 @@
 
 #define virt_to_bus	virt_to_phys
 #define bus_to_virt	phys_to_virt
-
 #endif /* _ASM_SCORE_IO_H */
diff --git a/arch/score/include/asm/pgalloc.h b/arch/score/include/asm/pgalloc.h
index 059a61b7071b..716b3fd1d863 100644
--- a/arch/score/include/asm/pgalloc.h
+++ b/arch/score/include/asm/pgalloc.h
@@ -2,7 +2,7 @@
 #define _ASM_SCORE_PGALLOC_H
 
 #include <linux/mm.h>
-
+#include <linux/highmem.h>
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
 	pte_t *pte)
 {
diff --git a/arch/score/kernel/entry.S b/arch/score/kernel/entry.S
index 7234ed09b7b7..befb87d30a89 100644
--- a/arch/score/kernel/entry.S
+++ b/arch/score/kernel/entry.S
@@ -264,7 +264,7 @@ resume_kernel:
 	disable_irq
 	lw	r8, [r28, TI_PRE_COUNT]
 	cmpz.c	r8
-	bne	r8, restore_all
+	bne	restore_all
 need_resched:
 	lw	r8, [r28, TI_FLAGS]
 	andri.c	r9, r8, _TIF_NEED_RESCHED
@@ -415,7 +415,7 @@ ENTRY(handle_sys)
 	sw	r9, [r0, PT_EPC]
 
 	cmpi.c	r27, __NR_syscalls 	# check syscall number
-	bgeu	illegal_syscall
+	bcs	illegal_syscall
 
 	slli	r8, r27, 2		# get syscall routine
 	la	r11, sys_call_table
diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index f4c6d02421d3..a1519ad3d49d 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -78,8 +78,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	p->thread.reg0 = (unsigned long) childregs;
 	if (unlikely(p->flags & PF_KTHREAD)) {
 		memset(childregs, 0, sizeof(struct pt_regs));
-		p->thread->reg12 = usp;
-		p->thread->reg13 = arg;
+		p->thread.reg12 = usp;
+		p->thread.reg13 = arg;
 		p->thread.reg3 = (unsigned long) ret_from_kernel_thread;
 	} else {
 		*childregs = *current_pt_regs();
-- 
1.9.1

