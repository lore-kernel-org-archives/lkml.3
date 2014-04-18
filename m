Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaDRNFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:05:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaDRNFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:05:11 -0400
Date: Fri, 18 Apr 2014 06:04:11 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-wr59327qdyi9mbzn6x937s4e@git.kernel.org>
Cc: srinivas.pandruvada@linux.intel.com, m.chehab@samsung.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        jsrhbz@kanargh.force9.co.uk, tytso@mit.edu, gong.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, arnd@arndb.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        m.chehab@samsung.com, srinivas.pandruvada@linux.intel.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        jsrhbz@kanargh.force9.co.uk, gong.chen@linux.intel.com, tytso@mit.edu,
        arnd@arndb.de, paulmck@linux.vnet.ibm.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch: Prepare for smp_mb__{before,
 after}_atomic()
Git-Commit-ID: febdbfe8a91ce0d11939d4940b592eb0dba8d663
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

Commit-ID:  febdbfe8a91ce0d11939d4940b592eb0dba8d663
Gitweb:     http://git.kernel.org/tip/febdbfe8a91ce0d11939d4940b592eb0dba8d663
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 6 Feb 2014 18:16:07 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 11:40:30 +0200

arch: Prepare for smp_mb__{before,after}_atomic()

Since the smp_mb__{before,after}*() ops are fundamentally dependent on
how an arch can implement atomics it doesn't make sense to have 3
variants of them. They must all be the same.

Furthermore, the 3 variants suggest they're only valid for those 3
atomic ops, while we have many more where they could be applied.

So move away from
smp_mb__{before,after}_{atomic,clear}_{dec,inc,bit}() and reduce the
interface to just the two: smp_mb__{before,after}_atomic().

This patch prepares the way by introducing default implementations in
asm-generic/barrier.h that default to a full barrier and providing
__deprecated inlines for the previous 6 barriers if they're not
provided by the arch.

This should allow for a mostly painless transition (lots of deprecated
warns in the interim).

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-wr59327qdyi9mbzn6x937s4e@git.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: John Sullivan <jsrhbz@kanargh.force9.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/asm-generic/atomic.h  |  7 +------
 include/asm-generic/barrier.h |  8 ++++++++
 include/asm-generic/bitops.h  |  9 +--------
 include/linux/atomic.h        | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/bitops.h        | 20 ++++++++++++++++++++
 kernel/sched/core.c           | 16 ++++++++++++++++
 6 files changed, 82 insertions(+), 14 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 33bd2de..9c79e76 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -16,6 +16,7 @@
 #define __ASM_GENERIC_ATOMIC_H
 
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #ifdef CONFIG_SMP
 /* Force people to define core atomics */
@@ -182,11 +183,5 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 }
 #endif
 
-/* Assume that atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* __KERNEL__ */
 #endif /* __ASM_GENERIC_ATOMIC_H */
diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
index 6f692f8..1402fa8 100644
--- a/include/asm-generic/barrier.h
+++ b/include/asm-generic/barrier.h
@@ -62,6 +62,14 @@
 #define set_mb(var, value)  do { (var) = (value); mb(); } while (0)
 #endif
 
+#ifndef smp_mb__before_atomic
+#define smp_mb__before_atomic()	smp_mb()
+#endif
+
+#ifndef smp_mb__after_atomic
+#define smp_mb__after_atomic()	smp_mb()
+#endif
+
 #define smp_store_release(p, v)						\
 do {									\
 	compiletime_assert_atomic_type(*p);				\
diff --git a/include/asm-generic/bitops.h b/include/asm-generic/bitops.h
index 280ca7a..dcdcacf 100644
--- a/include/asm-generic/bitops.h
+++ b/include/asm-generic/bitops.h
@@ -11,14 +11,7 @@
 
 #include <linux/irqflags.h>
 #include <linux/compiler.h>
-
-/*
- * clear_bit may not imply a memory barrier
- */
-#ifndef smp_mb__before_clear_bit
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-#endif
+#include <asm/barrier.h>
 
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/ffz.h>
diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index 5b08a85..fef3a80 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -3,6 +3,42 @@
 #define _LINUX_ATOMIC_H
 #include <asm/atomic.h>
 
+/*
+ * Provide __deprecated wrappers for the new interface, avoid flag day changes.
+ * We need the ugly external functions to break header recursion hell.
+ */
+#ifndef smp_mb__before_atomic_inc
+static inline void __deprecated smp_mb__before_atomic_inc(void)
+{
+	extern void __smp_mb__before_atomic(void);
+	__smp_mb__before_atomic();
+}
+#endif
+
+#ifndef smp_mb__after_atomic_inc
+static inline void __deprecated smp_mb__after_atomic_inc(void)
+{
+	extern void __smp_mb__after_atomic(void);
+	__smp_mb__after_atomic();
+}
+#endif
+
+#ifndef smp_mb__before_atomic_dec
+static inline void __deprecated smp_mb__before_atomic_dec(void)
+{
+	extern void __smp_mb__before_atomic(void);
+	__smp_mb__before_atomic();
+}
+#endif
+
+#ifndef smp_mb__after_atomic_dec
+static inline void __deprecated smp_mb__after_atomic_dec(void)
+{
+	extern void __smp_mb__after_atomic(void);
+	__smp_mb__after_atomic();
+}
+#endif
+
 /**
  * atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index be5fd38..cbc5833 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -32,6 +32,26 @@ extern unsigned long __sw_hweight64(__u64 w);
  */
 #include <asm/bitops.h>
 
+/*
+ * Provide __deprecated wrappers for the new interface, avoid flag day changes.
+ * We need the ugly external functions to break header recursion hell.
+ */
+#ifndef smp_mb__before_clear_bit
+static inline void __deprecated smp_mb__before_clear_bit(void)
+{
+	extern void __smp_mb__before_atomic(void);
+	__smp_mb__before_atomic();
+}
+#endif
+
+#ifndef smp_mb__after_clear_bit
+static inline void __deprecated smp_mb__after_clear_bit(void)
+{
+	extern void __smp_mb__after_atomic(void);
+	__smp_mb__after_atomic();
+}
+#endif
+
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
 	     (bit) < (size);					\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..8a70ec0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -90,6 +90,22 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
+#ifdef smp_mb__before_atomic
+void __smp_mb__before_atomic(void)
+{
+	smp_mb__before_atomic();
+}
+EXPORT_SYMBOL(__smp_mb__before_atomic);
+#endif
+
+#ifdef smp_mb__after_atomic
+void __smp_mb__after_atomic(void)
+{
+	smp_mb__after_atomic();
+}
+EXPORT_SYMBOL(__smp_mb__after_atomic);
+#endif
+
 void start_bandwidth_timer(struct hrtimer *period_timer, ktime_t period)
 {
 	unsigned long delta;
