Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbaCSG5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:57:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53007 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbaCSG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:31 -0400
Message-Id: <20140319065204.800659849@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 19/31] arch,mn10300: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-mn10300-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mn10300 fully relies on asm-generic/barrier.h and therefore its
smp_mb() is barrier(). We can use the default implementation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/mn10300/include/asm/atomic.h |    7 +------
 arch/mn10300/include/asm/bitops.h |    4 +---
 arch/mn10300/mm/tlb-smp.c         |    4 ++--
 3 files changed, 4 insertions(+), 11 deletions(-)

--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -13,6 +13,7 @@
 
 #include <asm/irqflags.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #ifndef CONFIG_SMP
 #include <asm-generic/atomic.h>
@@ -234,12 +235,6 @@ static inline void atomic_set_mask(unsig
 #endif
 }
 
-/* Atomic operations are already serializing on MN10300??? */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif /* __KERNEL__ */
 #endif /* CONFIG_SMP */
 #endif /* _ASM_ATOMIC_H */
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -18,9 +18,7 @@
 #define __ASM_BITOPS_H
 
 #include <asm/cpu-regs.h>
-
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
+#include <asm/barrier.h>
 
 /*
  * set bit
--- a/arch/mn10300/mm/tlb-smp.c
+++ b/arch/mn10300/mm/tlb-smp.c
@@ -78,9 +78,9 @@ void smp_flush_tlb(void *unused)
 	else
 		local_flush_tlb_page(flush_mm, flush_va);
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	cpumask_clear_cpu(cpu_id, &flush_cpumask);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 out:
 	put_cpu();
 }


