Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaHNR1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:27:43 -0400
Received: from g5t1626.atlanta.hp.com ([15.192.137.9]:6605 "EHLO
	g5t1626.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaHNR1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:27:42 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 1/2] rwlock, x86: clean up asm/spinlock*.h to remove old rwlock code
Date: Thu, 14 Aug 2014 13:27:30 -0400
Message-Id: <1408037251-45918-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1408037251-45918-1-git-send-email-Waiman.Long@hp.com>
References: <1408037251-45918-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the x86 architecture now uses qrwlock for its read/write lock
implementation, it is no longer necessary to keep the old rwlock code
around. This patch removes the old rwlock code in the asm/spinlock.h
and asm/spinlock_types.h files. Now the ARCH_USE_QUEUE_RWLOCK
config parameter cannot be removed from x86/Kconfig or there will be
compilation error.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/spinlock.h       |   81 +--------------------------------
 arch/x86/include/asm/spinlock_types.h |    4 --
 2 files changed, 2 insertions(+), 83 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 54f1c80..9295016 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -187,7 +187,6 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 		cpu_relax();
 }
 
-#ifndef CONFIG_QUEUE_RWLOCK
 /*
  * Read-write spinlocks, allowing multiple readers
  * but only one writer.
@@ -198,91 +197,15 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
  * irq-safe write-lock, but readers can get non-irqsafe
  * read-locks.
  *
- * On x86, we implement read-write locks as a 32-bit counter
- * with the high bit (sign) being the "contended" bit.
+ * On x86, we implement read-write locks using the generic qrwlock with
+ * x86 specific optimization.
  */
 
-/**
- * read_can_lock - would read_trylock() succeed?
- * @lock: the rwlock in question.
- */
-static inline int arch_read_can_lock(arch_rwlock_t *lock)
-{
-	return lock->lock > 0;
-}
-
-/**
- * write_can_lock - would write_trylock() succeed?
- * @lock: the rwlock in question.
- */
-static inline int arch_write_can_lock(arch_rwlock_t *lock)
-{
-	return lock->write == WRITE_LOCK_CMP;
-}
-
-static inline void arch_read_lock(arch_rwlock_t *rw)
-{
-	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(dec) " (%0)\n\t"
-		     "jns 1f\n"
-		     "call __read_lock_failed\n\t"
-		     "1:\n"
-		     ::LOCK_PTR_REG (rw) : "memory");
-}
-
-static inline void arch_write_lock(arch_rwlock_t *rw)
-{
-	asm volatile(LOCK_PREFIX WRITE_LOCK_SUB(%1) "(%0)\n\t"
-		     "jz 1f\n"
-		     "call __write_lock_failed\n\t"
-		     "1:\n"
-		     ::LOCK_PTR_REG (&rw->write), "i" (RW_LOCK_BIAS)
-		     : "memory");
-}
-
-static inline int arch_read_trylock(arch_rwlock_t *lock)
-{
-	READ_LOCK_ATOMIC(t) *count = (READ_LOCK_ATOMIC(t) *)lock;
-
-	if (READ_LOCK_ATOMIC(dec_return)(count) >= 0)
-		return 1;
-	READ_LOCK_ATOMIC(inc)(count);
-	return 0;
-}
-
-static inline int arch_write_trylock(arch_rwlock_t *lock)
-{
-	atomic_t *count = (atomic_t *)&lock->write;
-
-	if (atomic_sub_and_test(WRITE_LOCK_CMP, count))
-		return 1;
-	atomic_add(WRITE_LOCK_CMP, count);
-	return 0;
-}
-
-static inline void arch_read_unlock(arch_rwlock_t *rw)
-{
-	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(inc) " %0"
-		     :"+m" (rw->lock) : : "memory");
-}
-
-static inline void arch_write_unlock(arch_rwlock_t *rw)
-{
-	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
-		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
-}
-#else
 #include <asm/qrwlock.h>
-#endif /* CONFIG_QUEUE_RWLOCK */
 
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
-#undef READ_LOCK_SIZE
-#undef READ_LOCK_ATOMIC
-#undef WRITE_LOCK_ADD
-#undef WRITE_LOCK_SUB
-#undef WRITE_LOCK_CMP
-
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
 #define arch_write_relax(lock)	cpu_relax()
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 73c4c00..5f9d757 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -34,10 +34,6 @@ typedef struct arch_spinlock {
 
 #define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
 
-#ifdef CONFIG_QUEUE_RWLOCK
 #include <asm-generic/qrwlock_types.h>
-#else
-#include <asm/rwlock.h>
-#endif
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
-- 
1.7.1

