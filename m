Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbaCSHDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:03:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52977 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbaCSG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:29 -0400
Message-Id: <20140319065204.150839038@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 07/31] arch,arm64: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-arm64-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AARGH64 uses ll/sc primitives that do not imply any barriers for the
normal atomics, therefore smp_mb__{before,after} should be a full
barrier.

Since AARGH64 doesn't use asm-generic/barrier.h, add the required
definitions to its asm/barrier.h.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arm64/include/asm/atomic.h  |    5 -----
 arch/arm64/include/asm/barrier.h |    3 +++
 arch/arm64/include/asm/bitops.h  |    9 ---------
 3 files changed, 3 insertions(+), 14 deletions(-)

--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -152,11 +152,6 @@ static inline int __atomic_add_unless(at
 
 #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 /*
  * 64-bit atomic operations.
  */
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -97,6 +97,9 @@ do {									\
 #define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
 #define nop()		asm volatile("nop");
 
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	smp_mb()
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __ASM_BARRIER_H */
--- a/arch/arm64/include/asm/bitops.h
+++ b/arch/arm64/include/asm/bitops.h
@@ -17,17 +17,8 @@
 #define __ASM_BITOPS_H
 
 #include <linux/compiler.h>
-
 #include <asm/barrier.h>
 
-/*
- * clear_bit may not imply a memory barrier
- */
-#ifndef smp_mb__before_clear_bit
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-#endif
-
 #ifndef _LINUX_BITOPS_H
 #error only <linux/bitops.h> can be included directly
 #endif


