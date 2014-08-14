Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaHNR2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:28:46 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:53584 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaHNR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:28:44 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 2/2] rwlock, x86: delete unused asm/rwlock.h and rwlock.S
Date: Thu, 14 Aug 2014 13:27:31 -0400
Message-Id: <1408037251-45918-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1408037251-45918-1-git-send-email-Waiman.Long@hp.com>
References: <1408037251-45918-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused asm/rwlock.h and rwlock.S files.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/rwlock.h |   49 -----------------------------------------
 arch/x86/lib/Makefile         |    1 -
 arch/x86/lib/rwlock.S         |   44 ------------------------------------
 3 files changed, 0 insertions(+), 94 deletions(-)
 delete mode 100644 arch/x86/include/asm/rwlock.h
 delete mode 100644 arch/x86/lib/rwlock.S

diff --git a/arch/x86/include/asm/rwlock.h b/arch/x86/include/asm/rwlock.h
deleted file mode 100644
index a5370a0..0000000
--- a/arch/x86/include/asm/rwlock.h
+++ /dev/null
@@ -1,49 +0,0 @@
-#ifndef _ASM_X86_RWLOCK_H
-#define _ASM_X86_RWLOCK_H
-
-#include <asm/asm.h>
-
-#if CONFIG_NR_CPUS <= 2048
-
-#ifndef __ASSEMBLY__
-typedef union {
-	s32 lock;
-	s32 write;
-} arch_rwlock_t;
-#endif
-
-#define RW_LOCK_BIAS		0x00100000
-#define READ_LOCK_SIZE(insn)	__ASM_FORM(insn##l)
-#define READ_LOCK_ATOMIC(n)	atomic_##n
-#define WRITE_LOCK_ADD(n)	__ASM_FORM_COMMA(addl n)
-#define WRITE_LOCK_SUB(n)	__ASM_FORM_COMMA(subl n)
-#define WRITE_LOCK_CMP		RW_LOCK_BIAS
-
-#else /* CONFIG_NR_CPUS > 2048 */
-
-#include <linux/const.h>
-
-#ifndef __ASSEMBLY__
-typedef union {
-	s64 lock;
-	struct {
-		u32 read;
-		s32 write;
-	};
-} arch_rwlock_t;
-#endif
-
-#define RW_LOCK_BIAS		(_AC(1,L) << 32)
-#define READ_LOCK_SIZE(insn)	__ASM_FORM(insn##q)
-#define READ_LOCK_ATOMIC(n)	atomic64_##n
-#define WRITE_LOCK_ADD(n)	__ASM_FORM(incl)
-#define WRITE_LOCK_SUB(n)	__ASM_FORM(decl)
-#define WRITE_LOCK_CMP		1
-
-#endif /* CONFIG_NR_CPUS */
-
-#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
-
-/* Actual code is in asm/spinlock.h or in arch/x86/lib/rwlock.S */
-
-#endif /* _ASM_X86_RWLOCK_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 4d4f96a..7ef9a30 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -20,7 +20,6 @@ lib-y := delay.o misc.o cmdline.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
-lib-$(CONFIG_SMP) += rwlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
diff --git a/arch/x86/lib/rwlock.S b/arch/x86/lib/rwlock.S
deleted file mode 100644
index 1cad221..0000000
--- a/arch/x86/lib/rwlock.S
+++ /dev/null
@@ -1,44 +0,0 @@
-/* Slow paths of read/write spinlocks. */
-
-#include <linux/linkage.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
-#include <asm/rwlock.h>
-
-#ifdef CONFIG_X86_32
-# define __lock_ptr eax
-#else
-# define __lock_ptr rdi
-#endif
-
-ENTRY(__write_lock_failed)
-	CFI_STARTPROC
-	FRAME
-0:	LOCK_PREFIX
-	WRITE_LOCK_ADD($RW_LOCK_BIAS) (%__lock_ptr)
-1:	rep; nop
-	cmpl	$WRITE_LOCK_CMP, (%__lock_ptr)
-	jne	1b
-	LOCK_PREFIX
-	WRITE_LOCK_SUB($RW_LOCK_BIAS) (%__lock_ptr)
-	jnz	0b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-END(__write_lock_failed)
-
-ENTRY(__read_lock_failed)
-	CFI_STARTPROC
-	FRAME
-0:	LOCK_PREFIX
-	READ_LOCK_SIZE(inc) (%__lock_ptr)
-1:	rep; nop
-	READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
-	js	1b
-	LOCK_PREFIX
-	READ_LOCK_SIZE(dec) (%__lock_ptr)
-	js	0b
-	ENDFRAME
-	ret
-	CFI_ENDPROC
-END(__read_lock_failed)
-- 
1.7.1

