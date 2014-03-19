Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbaCSHGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:06:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52968 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbaCSG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:28 -0400
Message-Id: <20140319065204.099395624@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 06/31] arch,arm: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-arm-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM uses ll/sc primitives that do not imply barriers for all regular
atomic ops, therefore smp_mb__{before,after} need be a full barrier.

Since ARM doesn't use asm-generic/barrier.h include the required
definitions in its asm/barrier.h

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arm/include/asm/atomic.h  |    5 -----
 arch/arm/include/asm/barrier.h |    3 +++
 arch/arm/include/asm/bitops.h  |    4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -211,11 +211,6 @@ static inline int __atomic_add_unless(at
 
 #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #ifndef CONFIG_GENERIC_ATOMIC64
 typedef struct {
 	long long counter;
--- a/arch/arm/include/asm/barrier.h
+++ b/arch/arm/include/asm/barrier.h
@@ -79,5 +79,8 @@ do {									\
 
 #define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
 
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	smp_mb()
+
 #endif /* !__ASSEMBLY__ */
 #endif /* __ASM_BARRIER_H */
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -25,9 +25,7 @@
 
 #include <linux/compiler.h>
 #include <linux/irqflags.h>
-
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
+#include <asm/barrier.h>
 
 /*
  * These functions are the basis of our bit ops.


