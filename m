Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaDRNNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:13:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaDRNNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:13:00 -0400
Date: Fri, 18 Apr 2014 06:12:14 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-2cla9ubpd8chrntnm7e4zdt4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, davem@davemloft.net, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,sparc: Convert smp_mb__*()
Git-Commit-ID: 56d3648948c202e8b89cd786a004c451a3eb264f
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

Commit-ID:  56d3648948c202e8b89cd786a004c451a3eb264f
Gitweb:     http://git.kernel.org/tip/56d3648948c202e8b89cd786a004c451a3eb264f
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:44 +0200

arch,sparc: Convert smp_mb__*()

sparc32: fully relies on asm-generic/barrier.h and thus can use its
	 implementation.

sparc64: is strongly ordered and its atomic ops imply a full barrier,
	 implement the new primitives using barrier().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/n/tip-2cla9ubpd8chrntnm7e4zdt4@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/sparc/include/asm/atomic_32.h  | 7 +------
 arch/sparc/include/asm/atomic_64.h  | 7 +------
 arch/sparc/include/asm/barrier_64.h | 3 +++
 arch/sparc/include/asm/bitops_32.h  | 3 ---
 arch/sparc/include/asm/bitops_64.h  | 4 +---
 5 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 905832a..f08fe51 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 #include <asm-generic/atomic64.h>
 
 
@@ -52,10 +53,4 @@ extern void atomic_set(atomic_t *, int);
 #define atomic_dec_and_test(v) (atomic_dec_return(v) == 0)
 #define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* !(__ARCH_SPARC_ATOMIC__) */
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index be56a24..8b2f1bd 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
@@ -108,10 +109,4 @@ static inline long atomic64_add_unless(atomic64_t *v, long a, long u)
 
 extern long atomic64_dec_if_positive(atomic64_t *v);
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* !(__ARCH_SPARC64_ATOMIC__) */
diff --git a/arch/sparc/include/asm/barrier_64.h b/arch/sparc/include/asm/barrier_64.h
index b5aad96..305dcc3 100644
--- a/arch/sparc/include/asm/barrier_64.h
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -68,4 +68,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 #endif /* !(__SPARC64_BARRIER_H) */
diff --git a/arch/sparc/include/asm/bitops_32.h b/arch/sparc/include/asm/bitops_32.h
index 25a6766..88c9a96 100644
--- a/arch/sparc/include/asm/bitops_32.h
+++ b/arch/sparc/include/asm/bitops_32.h
@@ -90,9 +90,6 @@ static inline void change_bit(unsigned long nr, volatile unsigned long *addr)
 
 #include <asm-generic/bitops/non-atomic.h>
 
-#define smp_mb__before_clear_bit()	do { } while(0)
-#define smp_mb__after_clear_bit()	do { } while(0)
-
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/sched.h>
diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
index 29011cc..f1a051c 100644
--- a/arch/sparc/include/asm/bitops_64.h
+++ b/arch/sparc/include/asm/bitops_64.h
@@ -13,6 +13,7 @@
 
 #include <linux/compiler.h>
 #include <asm/byteorder.h>
+#include <asm/barrier.h>
 
 extern int test_and_set_bit(unsigned long nr, volatile unsigned long *addr);
 extern int test_and_clear_bit(unsigned long nr, volatile unsigned long *addr);
@@ -23,9 +24,6 @@ extern void change_bit(unsigned long nr, volatile unsigned long *addr);
 
 #include <asm-generic/bitops/non-atomic.h>
 
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
