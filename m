Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbaCSHCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:02:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbaCSG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:29 -0400
Message-Id: <20140319065205.267534883@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 28/31] arch, x86: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-x86-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 is strongly ordered and all its atomic ops imply a full barrier.

Implement the two new primitives as the old ones were.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/atomic.h      |    7 +------
 arch/x86/include/asm/barrier.h     |    4 ++++
 arch/x86/include/asm/bitops.h      |    6 ++----
 arch/x86/include/asm/sync_bitops.h |    2 +-
 arch/x86/kernel/apic/hw_nmi.c      |    2 +-
 5 files changed, 9 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -7,6 +7,7 @@
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 #include <asm/rmwcc.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -256,12 +257,6 @@ static inline void atomic_or_long(unsign
 		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
 		     : "memory")
 
-/* Atomic operations are already serializing on x86 */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #ifdef CONFIG_X86_32
 # include <asm/atomic64_32.h>
 #else
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -141,6 +141,10 @@ do {									\
 
 #endif
 
+/* Atomic operations are already serializing on x86 */
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 /*
  * Stop RDTSC speculation. This is needed when you need to use RDTSC
  * (or get_cycles or vread that possibly accesses the TSC) in a defined
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -15,6 +15,7 @@
 #include <linux/compiler.h>
 #include <asm/alternative.h>
 #include <asm/rmwcc.h>
+#include <asm/barrier.h>
 
 #if BITS_PER_LONG == 32
 # define _BITOPS_LONG_SHIFT 5
@@ -102,7 +103,7 @@ static inline void __set_bit(long nr, vo
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static __always_inline void
@@ -156,9 +157,6 @@ static inline void __clear_bit_unlock(lo
 	__clear_bit(nr, addr);
 }
 
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 /**
  * __change_bit - Toggle a bit in memory
  * @nr: the bit to change
--- a/arch/x86/include/asm/sync_bitops.h
+++ b/arch/x86/include/asm/sync_bitops.h
@@ -41,7 +41,7 @@ static inline void sync_set_bit(long nr,
  *
  * sync_clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static inline void sync_clear_bit(long nr, volatile unsigned long *addr)
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -57,7 +57,7 @@ void arch_trigger_all_cpu_backtrace(void
 	}
 
 	clear_bit(0, &backtrace_flag);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static int __kprobes


