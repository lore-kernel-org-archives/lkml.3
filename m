Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423189Ab3CWBbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 21:31:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:7961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422843Ab3CWBZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 21:25:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,896,1355126400"; 
   d="scan'208";a="306338478"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 20/29] x86, tsx: Enable elision for read write spinlocks
Date: Fri, 22 Mar 2013 18:25:14 -0700
Message-Id: <1364001923-10796-21-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

rwspinlocks don't support paravirt ops, so add hooks to call lock elision
based on the CPUID bit. We use the standard patching, so the overhead
in the fast path is low when RTM is not supported.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h |  104 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 33692ea..5bff3c0 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -6,6 +6,10 @@
 #include <asm/processor.h>
 #include <linux/compiler.h>
 #include <asm/paravirt.h>
+#include <asm/cpufeature.h>
+#include <asm/rtm-locks.h>
+#include <linux/elide.h>
+
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  *
@@ -169,7 +173,12 @@ static inline int arch_write_can_lock(arch_rwlock_t *lock)
 	return lock->write == WRITE_LOCK_CMP;
 }
 
-static inline void arch_read_lock(arch_rwlock_t *rw)
+static inline int arch_rwlock_is_locked(arch_rwlock_t *lock)
+{
+	return lock->lock != RW_LOCK_BIAS;
+}
+
+static inline void arch_do_read_lock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(dec) " (%0)\n\t"
 		     "jns 1f\n"
@@ -178,7 +187,20 @@ static inline void arch_read_lock(arch_rwlock_t *rw)
 		     ::LOCK_PTR_REG (rw) : "memory");
 }
 
-static inline void arch_write_lock(arch_rwlock_t *rw)
+#define ARCH_HAS_RWLOCK_UNLOCK_IRQ 1
+
+#ifdef CONFIG_RTM_LOCKS
+#define RTM_OR_NORMAL(n, r) (static_cpu_has(X86_FEATURE_RTM) ? (r) : (n))
+#else
+#define RTM_OR_NORMAL(n, r) n
+#endif
+
+static inline void arch_read_lock(arch_rwlock_t *rw)
+{
+	RTM_OR_NORMAL(arch_do_read_lock(rw), rtm_read_lock(rw));
+}
+
+static inline void arch_do_write_lock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX WRITE_LOCK_SUB(%1) "(%0)\n\t"
 		     "jz 1f\n"
@@ -188,7 +210,12 @@ static inline void arch_write_lock(arch_rwlock_t *rw)
 		     : "memory");
 }
 
-static inline int arch_read_trylock(arch_rwlock_t *lock)
+static inline void arch_write_lock(arch_rwlock_t *rw)
+{
+	RTM_OR_NORMAL(arch_do_write_lock(rw), rtm_write_lock(rw));
+}
+
+static inline int arch_do_read_trylock(arch_rwlock_t *lock)
 {
 	READ_LOCK_ATOMIC(t) *count = (READ_LOCK_ATOMIC(t) *)lock;
 
@@ -198,6 +225,13 @@ static inline int arch_read_trylock(arch_rwlock_t *lock)
 	return 0;
 }
 
+static inline int arch_read_trylock(arch_rwlock_t *lock)
+{
+	return RTM_OR_NORMAL(arch_do_read_trylock(lock),
+			     rtm_read_trylock(lock));
+}
+
+/* Not elided because noone uses it */
 static inline int arch_write_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)&lock->write;
@@ -208,18 +242,78 @@ static inline int arch_write_trylock(arch_rwlock_t *lock)
 	return 0;
 }
 
-static inline void arch_read_unlock(arch_rwlock_t *rw)
+static inline void arch_do_read_unlock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX READ_LOCK_SIZE(inc) " %0"
 		     :"+m" (rw->lock) : : "memory");
 }
 
-static inline void arch_write_unlock(arch_rwlock_t *rw)
+static inline void arch_do_write_unlock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX WRITE_LOCK_ADD(%1) "%0"
 		     : "+m" (rw->write) : "i" (RW_LOCK_BIAS) : "memory");
 }
 
+static inline void arch_read_unlock(arch_rwlock_t *rw)
+{
+	RTM_OR_NORMAL(arch_do_read_unlock(rw), rtm_read_unlock(rw));
+}
+
+static inline void arch_write_unlock(arch_rwlock_t *rw)
+{
+	RTM_OR_NORMAL(arch_do_write_unlock(rw), rtm_write_unlock(rw));
+}
+
+static inline void arch_do_read_unlock_irqrestore(arch_rwlock_t *rw,
+						  unsigned long flags)
+{
+	arch_do_read_unlock(rw);
+	local_irq_restore(flags);
+}
+
+static inline void arch_do_write_unlock_irqrestore(arch_rwlock_t *rw,
+						   unsigned long flags)
+{
+	arch_do_write_unlock(rw);
+	local_irq_restore(flags);
+}
+
+static inline void arch_read_unlock_irqrestore(arch_rwlock_t *rw,
+					       unsigned long flags)
+{
+	RTM_OR_NORMAL(arch_do_read_unlock_irqrestore(rw, flags),
+		      rtm_read_unlock_irqrestore(rw, flags));
+}
+
+static inline void arch_write_unlock_irqrestore(arch_rwlock_t *rw,
+						unsigned long flags)
+{
+	RTM_OR_NORMAL(arch_do_write_unlock_irqrestore(rw, flags),
+		      rtm_write_unlock_irqrestore(rw, flags));
+}
+
+static inline void arch_do_read_unlock_irq(arch_rwlock_t *rw)
+{
+	arch_do_read_unlock(rw);
+	local_irq_enable();
+}
+
+static inline void arch_do_write_unlock_irq(arch_rwlock_t *rw)
+{
+	arch_do_write_unlock(rw);
+	local_irq_enable();
+}
+
+static inline void arch_read_unlock_irq(arch_rwlock_t *rw)
+{
+	RTM_OR_NORMAL(arch_do_read_unlock_irq(rw), rtm_read_unlock_irq(rw));
+}
+
+static inline void arch_write_unlock_irq(arch_rwlock_t *rw)
+{
+	RTM_OR_NORMAL(arch_do_write_unlock_irq(rw), rtm_write_unlock_irq(rw));
+}
+
 #define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
 #define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
-- 
1.7.7.6

