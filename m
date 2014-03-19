Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbaCSG5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:57:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53010 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbaCSG4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:32 -0400
Message-Id: <20140319065204.744686217@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 18/31] arch,mips: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-mips-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS is interesting and has hardware variants that reorder over ll/sc
as well as those that do not.

Implement the 2 new barrier functions as per the old barriers.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/mips/include/asm/atomic.h  |    9 ---------
 arch/mips/include/asm/barrier.h |    3 +++
 arch/mips/include/asm/bitops.h  |   11 ++---------
 arch/mips/kernel/irq.c          |    4 ++--
 4 files changed, 7 insertions(+), 20 deletions(-)

--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -761,13 +761,4 @@ static __inline__ int atomic64_add_unles
 
 #endif /* CONFIG_64BIT */
 
-/*
- * atomic*_return operations are serializing but not the non-*_return
- * versions.
- */
-#define smp_mb__before_atomic_dec()	smp_mb__before_llsc()
-#define smp_mb__after_atomic_dec()	smp_llsc_mb()
-#define smp_mb__before_atomic_inc()	smp_mb__before_llsc()
-#define smp_mb__after_atomic_inc()	smp_llsc_mb()
-
 #endif /* _ASM_ATOMIC_H */
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -195,4 +195,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__before_atomic()	smp_mb__before_llsc()
+#define smp_mb__after_atomic()	smp_llsc_mb()
+
 #endif /* __ASM_BARRIER_H */
--- a/arch/mips/include/asm/bitops.h
+++ b/arch/mips/include/asm/bitops.h
@@ -38,13 +38,6 @@
 #endif
 
 /*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	smp_mb__before_llsc()
-#define smp_mb__after_clear_bit()	smp_llsc_mb()
-
-
-/*
  * These are the "slower" versions of the functions and are in bitops.c.
  * These functions call raw_local_irq_{save,restore}().
  */
@@ -120,7 +113,7 @@ static inline void set_bit(unsigned long
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static inline void clear_bit(unsigned long nr, volatile unsigned long *addr)
@@ -175,7 +168,7 @@ static inline void clear_bit(unsigned lo
  */
 static inline void clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(nr, addr);
 }
 
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -62,9 +62,9 @@ void __init alloc_legacy_irqno(void)
 
 void free_irqno(unsigned int irq)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(irq, irq_map);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 /*


