Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbaCSHE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:04:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52970 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbaCSG42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:28 -0400
Message-Id: <20140319065204.255295668@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 09/31] arch,blackfin: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-blackfin-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blackfin's atomic primitives do not imply a full barrier as whitnessed
from its SMP smp_mb__{before,after}_clear_bit() implementations.

However since !SMP smp_mb() reduces to barrier() remove everything and
rely on the asm-generic/barrier.h implentation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/blackfin/include/asm/barrier.h |    3 +++
 arch/blackfin/include/asm/bitops.h  |   14 ++------------
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/arch/blackfin/include/asm/barrier.h
+++ b/arch/blackfin/include/asm/barrier.h
@@ -27,6 +27,9 @@
 
 #endif /* !CONFIG_SMP */
 
+#define smp_mb__before_atomic()	barrier()
+#define smp_mb__after_atomic()	barrier()
+
 #include <asm-generic/barrier.h>
 
 #endif /* _BLACKFIN_BARRIER_H */
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -27,21 +27,17 @@
 
 #include <asm-generic/bitops/ext2-atomic.h>
 
+#include <asm/barrier.h>
+
 #ifndef CONFIG_SMP
 #include <linux/irqflags.h>
-
 /*
  * clear_bit may not imply a memory barrier
  */
-#ifndef smp_mb__before_clear_bit
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
-#endif
 #include <asm-generic/bitops/atomic.h>
 #include <asm-generic/bitops/non-atomic.h>
 #else
 
-#include <asm/barrier.h>
 #include <asm/byteorder.h>	/* swab32 */
 #include <linux/linkage.h>
 
@@ -101,12 +97,6 @@ static inline int test_and_change_bit(in
 	return __raw_bit_test_toggle_asm(a, nr & 0x1f);
 }
 
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 #define test_bit __skip_test_bit
 #include <asm-generic/bitops/non-atomic.h>
 #undef test_bit


