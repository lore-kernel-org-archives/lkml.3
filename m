Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaIJRdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:33:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaIJRdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:33:21 -0400
Date: Wed, 10 Sep 2014 10:32:09 -0700
From: tip-bot for Waiman Long <tipbot@zytor.com>
Message-ID: <tip-6157c7e1bb23dae5af4d5b2037203da4c64cc561@git.kernel.org>
Cc: ffusco@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, dborkman@redhat.com,
        peterz@infradead.org, davem@davemloft.net, tgraf@redhat.com,
        Waiman.Long@hp.com, tglx@linutronix.de, scott.norton@hp.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ffusco@redhat.com, dborkman@redhat.com, torvalds@linux-foundation.org,
        peterz@infradead.org, davem@davemloft.net, Waiman.Long@hp.com,
        tgraf@redhat.com, tglx@linutronix.de, bp@suse.de, scott.norton@hp.com
In-Reply-To: <1408037251-45918-3-git-send-email-Waiman.Long@hp.com>
References: <1408037251-45918-3-git-send-email-Waiman.Long@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/rwlock, x86: Delete unused asm/
 rwlock.h and rwlock.S
Git-Commit-ID: 6157c7e1bb23dae5af4d5b2037203da4c64cc561
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6157c7e1bb23dae5af4d5b2037203da4c64cc561
Gitweb:     http://git.kernel.org/tip/6157c7e1bb23dae5af4d5b2037203da4c64cc561
Author:     Waiman Long <Waiman.Long@hp.com>
AuthorDate: Thu, 14 Aug 2014 13:27:31 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Sep 2014 11:46:39 +0200

locking/rwlock, x86: Delete unused asm/rwlock.h and rwlock.S

This patch removes the unused asm/rwlock.h and rwlock.S files.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1408037251-45918-3-git-send-email-Waiman.Long@hp.com
Cc: Scott J Norton <scott.norton@hp.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Graf <tgraf@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/rwlock.h | 49 -------------------------------------------
 arch/x86/lib/Makefile         |  1 -
 arch/x86/lib/rwlock.S         | 44 --------------------------------------
 3 files changed, 94 deletions(-)

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
