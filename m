Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaDRNNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:13:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaDRNNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:13:14 -0400
Date: Fri, 18 Apr 2014 06:12:26 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-euuabnf5a3u23fy4fq8m3jcg@git.kernel.org>
Cc: mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        cmetcalf@tilera.com, akinobu.mita@gmail.com,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        gang.chen@asianux.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@polymtl.ca, torvalds@linux-foundation.org,
        peterz@infradead.org, cmetcalf@tilera.com, akinobu.mita@gmail.com,
        paulmck@linux.vnet.ibm.com, geert@linux-m68k.org,
        gang.chen@asianux.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,tile: Convert smp_mb__*()
Git-Commit-ID: ce3609f93445846f7b5a5b4bacb236a9bdc35216
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

Commit-ID:  ce3609f93445846f7b5a5b4bacb236a9bdc35216
Gitweb:     http://git.kernel.org/tip/ce3609f93445846f7b5a5b4bacb236a9bdc35216
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:45 +0200

arch,tile: Convert smp_mb__*()

Implement the new smp_mb__* ops as per the old ones.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/n/tip-euuabnf5a3u23fy4fq8m3jcg@git.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/tile/include/asm/atomic_32.h | 10 ----------
 arch/tile/include/asm/atomic_64.h |  6 ------
 arch/tile/include/asm/barrier.h   | 14 ++++++++++++++
 arch/tile/include/asm/bitops.h    |  1 +
 arch/tile/include/asm/bitops_32.h |  8 ++------
 arch/tile/include/asm/bitops_64.h |  4 ----
 6 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index 1ad4a1f..1b109fa 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -169,16 +169,6 @@ static inline void atomic64_set(atomic64_t *v, long long n)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
 
-/*
- * We need to barrier before modifying the word, since the _atomic_xxx()
- * routines just tns the lock and then read/modify/write of the word.
- * But after the word is updated, the routine issues an "mf" before returning,
- * and since it's a function call, we don't even need a compiler barrier.
- */
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_dec()	do { } while (0)
-#define smp_mb__after_atomic_inc()	do { } while (0)
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/arch/tile/include/asm/atomic_64.h b/arch/tile/include/asm/atomic_64.h
index ad220ee..7b11c5f 100644
--- a/arch/tile/include/asm/atomic_64.h
+++ b/arch/tile/include/asm/atomic_64.h
@@ -105,12 +105,6 @@ static inline long atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
 
-/* Atomic dec and inc don't implement barrier, so provide them if needed. */
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 /* Define this to indicate that cmpxchg is an efficient operation. */
 #define __HAVE_ARCH_CMPXCHG
 
diff --git a/arch/tile/include/asm/barrier.h b/arch/tile/include/asm/barrier.h
index b5a05d0..96a42ae 100644
--- a/arch/tile/include/asm/barrier.h
+++ b/arch/tile/include/asm/barrier.h
@@ -72,6 +72,20 @@ mb_incoherent(void)
 #define mb()		fast_mb()
 #define iob()		fast_iob()
 
+#ifndef __tilegx__ /* 32 bit */
+/*
+ * We need to barrier before modifying the word, since the _atomic_xxx()
+ * routines just tns the lock and then read/modify/write of the word.
+ * But after the word is updated, the routine issues an "mf" before returning,
+ * and since it's a function call, we don't even need a compiler barrier.
+ */
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	do { } while (0)
+#else /* 64 bit */
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	smp_mb()
+#endif
+
 #include <asm-generic/barrier.h>
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
index d5a2068..20caa34 100644
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -17,6 +17,7 @@
 #define _ASM_TILE_BITOPS_H
 
 #include <linux/types.h>
+#include <asm/barrier.h>
 
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
diff --git a/arch/tile/include/asm/bitops_32.h b/arch/tile/include/asm/bitops_32.h
index 386865a..bbf7b66 100644
--- a/arch/tile/include/asm/bitops_32.h
+++ b/arch/tile/include/asm/bitops_32.h
@@ -49,8 +49,8 @@ static inline void set_bit(unsigned nr, volatile unsigned long *addr)
  * restricted to acting on a single-word quantity.
  *
  * clear_bit() may not contain a memory barrier, so if it is used for
- * locking purposes, you should call smp_mb__before_clear_bit() and/or
- * smp_mb__after_clear_bit() to ensure changes are visible on other cpus.
+ * locking purposes, you should call smp_mb__before_atomic() and/or
+ * smp_mb__after_atomic() to ensure changes are visible on other cpus.
  */
 static inline void clear_bit(unsigned nr, volatile unsigned long *addr)
 {
@@ -121,10 +121,6 @@ static inline int test_and_change_bit(unsigned nr,
 	return (_atomic_xor(addr, mask) & mask) != 0;
 }
 
-/* See discussion at smp_mb__before_atomic_dec() in <asm/atomic_32.h>. */
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	do {} while (0)
-
 #include <asm-generic/bitops/ext2-atomic.h>
 
 #endif /* _ASM_TILE_BITOPS_32_H */
diff --git a/arch/tile/include/asm/bitops_64.h b/arch/tile/include/asm/bitops_64.h
index ad34cd0..bb1a292 100644
--- a/arch/tile/include/asm/bitops_64.h
+++ b/arch/tile/include/asm/bitops_64.h
@@ -32,10 +32,6 @@ static inline void clear_bit(unsigned nr, volatile unsigned long *addr)
 	__insn_fetchand((void *)(addr + nr / BITS_PER_LONG), ~mask);
 }
 
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-
-
 static inline void change_bit(unsigned nr, volatile unsigned long *addr)
 {
 	unsigned long mask = (1UL << (nr % BITS_PER_LONG));
