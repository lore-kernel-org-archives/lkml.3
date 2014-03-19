Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbaCSHB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:01:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52998 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaCSG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:29 -0400
Message-Id: <20140319065204.956605799@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 22/31] arch,powerpc: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-powerpc-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc allows reordering over its ll/sc implementation. Implement the
two new barriers as appropriate.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/powerpc/include/asm/atomic.h  |    6 +-----
 arch/powerpc/include/asm/barrier.h |    3 +++
 arch/powerpc/include/asm/bitops.h  |    6 +-----
 arch/powerpc/kernel/crash.c        |    2 +-
 4 files changed, 6 insertions(+), 11 deletions(-)

--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -8,6 +8,7 @@
 #ifdef __KERNEL__
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 
@@ -270,11 +271,6 @@ static __inline__ int atomic_dec_if_posi
 }
 #define atomic_dec_if_positive atomic_dec_if_positive
 
-#define smp_mb__before_atomic_dec()     smp_mb()
-#define smp_mb__after_atomic_dec()      smp_mb()
-#define smp_mb__before_atomic_inc()     smp_mb()
-#define smp_mb__after_atomic_inc()      smp_mb()
-
 #ifdef __powerpc64__
 
 #define ATOMIC64_INIT(i)	{ (i) }
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -84,4 +84,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__before_atomic()     smp_mb()
+#define smp_mb__after_atomic()      smp_mb()
+
 #endif /* _ASM_POWERPC_BARRIER_H */
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -51,11 +51,7 @@
 #define PPC_BIT(bit)		(1UL << PPC_BITLSHIFT(bit))
 #define PPC_BITMASK(bs, be)	((PPC_BIT(bs) - PPC_BIT(be)) | PPC_BIT(bs))
 
-/*
- * clear_bit doesn't imply a memory barrier
- */
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
+#include <asm/barrier.h>
 
 /* Macro for generating the ***_bits() functions */
 #define DEFINE_BITOP(fn, op, prefix)		\
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -81,7 +81,7 @@ void crash_ipi_callback(struct pt_regs *
 	}
 
 	atomic_inc(&cpus_in_crash);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	/*
 	 * Starting the kdump boot.


