Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbaCSHEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:04:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52971 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaCSG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:28 -0400
Message-Id: <20140319065204.526383736@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 14/31] arch,ia64: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-ia64-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 atomic ops are full barriers; implement the new
smp_mb__{before,after}_atomic().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/ia64/include/asm/atomic.h  |    7 +------
 arch/ia64/include/asm/barrier.h |    3 +++
 arch/ia64/include/asm/bitops.h  |    6 ++----
 3 files changed, 6 insertions(+), 10 deletions(-)

--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 #include <asm/intrinsics.h>
+#include <asm/barrier.h>
 
 
 #define ATOMIC_INIT(i)		{ (i) }
@@ -208,10 +209,4 @@ atomic64_add_negative (__s64 i, atomic64
 #define atomic64_inc(v)			atomic64_add(1, (v))
 #define atomic64_dec(v)			atomic64_sub(1, (v))
 
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* _ASM_IA64_ATOMIC_H */
--- a/arch/ia64/include/asm/barrier.h
+++ b/arch/ia64/include/asm/barrier.h
@@ -55,6 +55,9 @@
 
 #endif
 
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 /*
  * IA64 GCC turns volatile stores into st.rel and volatile loads into ld.acq no
  * need for asm trickery!
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/intrinsics.h>
+#include <asm/barrier.h>
 
 /**
  * set_bit - Atomically set a bit in memory
@@ -65,9 +66,6 @@ __set_bit (int nr, volatile void *addr)
 	*((__u32 *) addr + (nr >> 5)) |= (1 << (nr & 31));
 }
 
-#define smp_mb__before_clear_bit()	barrier();
-#define smp_mb__after_clear_bit()	barrier();
-
 /**
  * clear_bit - Clears a bit in memory
  * @nr: Bit to clear
@@ -75,7 +73,7 @@ __set_bit (int nr, volatile void *addr)
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static __inline__ void


