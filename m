Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938AbaCSHAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:00:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53001 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbaCSG4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:30 -0400
Message-Id: <20140319065205.008359711@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 23/31] arch,s390: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-s390-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the existing implementation; implement the new one using
smp_mb().

AFAICT the s390 compare-and-swap does imply a barrier, however there
are some immediate ops that seem to be singly-copy atomic and do not
imply a barrier. One such is the "ni" op (which would be
and-immediate) which is used for the constant clear_bit
implementation. Therefore s390 needs full barriers for the
{before,after} atomic ops.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/s390/include/asm/atomic.h  |    6 +-----
 arch/s390/include/asm/barrier.h |    5 +++--
 arch/s390/include/asm/bitops.h  |    1 +
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/cmpxchg.h>
+#include <asm/barrier.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
@@ -398,9 +399,4 @@ static inline long long atomic64_dec_if_
 #define atomic64_dec_and_test(_v)	(atomic64_sub_return(1, _v) == 0)
 #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
 
-#define smp_mb__before_atomic_dec()	smp_mb()
-#define smp_mb__after_atomic_dec()	smp_mb()
-#define smp_mb__before_atomic_inc()	smp_mb()
-#define smp_mb__after_atomic_inc()	smp_mb()
-
 #endif /* __ARCH_S390_ATOMIC__  */
--- a/arch/s390/include/asm/barrier.h
+++ b/arch/s390/include/asm/barrier.h
@@ -27,8 +27,9 @@
 #define smp_rmb()			rmb()
 #define smp_wmb()			wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	smp_mb()
+
+#define smp_mb__before_atomic()	smp_mb()
+#define smp_mb__after_atomic()	smp_mb()
 
 #define set_mb(var, value)		do { var = value; mb(); } while (0)
 
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -47,6 +47,7 @@
 
 #include <linux/typecheck.h>
 #include <linux/compiler.h>
+#include <asm/barrier.h>
 
 #ifndef CONFIG_64BIT
 


