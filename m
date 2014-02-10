Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaBJUlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:41:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35703 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaBJUl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:29 -0500
Message-Id: <20140210203659.863926149@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 8/8] x86,locking: Enable qrwlock
References: <20140210195820.834693028@infradead.org>
Content-Disposition: inline; filename=qrwlock2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make x86 use the fair rwlock_t.

Implement the custom queue_write_unlock() for best performance.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
[peterz: near complete rewrite]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/qrwlock.h        |   18 ++++++++++++++++++
 arch/x86/include/asm/spinlock.h       |    2 ++
 arch/x86/include/asm/spinlock_types.h |    4 ++++
 4 files changed, 25 insertions(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -119,6 +119,7 @@ config X86
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
 	select ARCH_USE_BUILTIN_BSWAP
+	select ARCH_USE_QUEUE_RWLOCK
 	select OLD_SIGSUSPEND3 if X86_32 || IA32_EMULATION
 	select OLD_SIGACTION if X86_32
 	select COMPAT_OLD_SIGACTION if IA32_EMULATION
--- /dev/null
+++ b/arch/x86/include/asm/qrwlock.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_QRWLOCK_H
+#define _ASM_X86_QRWLOCK_H
+
+#include <asm-generic/qrwlock_types.h>
+
+#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
+#define queue_write_unlock queue_write_unlock
+static inline void queue_write_unlock(struct qrwlock *lock)
+{
+        barrier();
+        ACCESS_ONCE(*(u8 *)&lock->cnts) = 0;
+}
+#endif
+
+#include <asm-generic/qrwlock.h>
+
+#endif /* _ASM_X86_QRWLOCK_H */
+
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -188,6 +188,7 @@ static inline void arch_spin_unlock_wait
 		cpu_relax();
 }
 
+#ifndef CONFIG_QUEUE_RWLOCK
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
@@ -270,6 +271,7 @@ static inline void arch_write_unlock(arc
 	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
 		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
 }
+#endif /* CONFIG_QUEUE_RWLOCK */
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -34,6 +34,10 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
+#ifdef CONFIG_QUEUE_RWLOCK
+#include <asm/qrwlock.h>
+#else
 #include <asm/rwlock.h>
+#endif
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */


