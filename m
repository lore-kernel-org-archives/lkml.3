Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaDRNKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:10:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38987 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRNKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:10:44 -0400
Date: Fri, 18 Apr 2014 06:09:55 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-wh6xljltyvmpy9t0bc80k1fy@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, takata@linux-m32r.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, takata@linux-m32r.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,m32r: Convert smp_mb__*()
Git-Commit-ID: 89607d5e2928d49bb64669d6d1e30e933a33f817
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

Commit-ID:  89607d5e2928d49bb64669d6d1e30e933a33f817
Gitweb:     http://git.kernel.org/tip/89607d5e2928d49bb64669d6d1e30e933a33f817
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:36 +0200

arch,m32r: Convert smp_mb__*()

M32r uses asm-generic/barrier.h and its smp_mb() is barrier();
therefore we can use the generic versions which default to smp_mb().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-wh6xljltyvmpy9t0bc80k1fy@git.kernel.org
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-m32r-ja@ml.linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/m32r/include/asm/atomic.h | 7 +------
 arch/m32r/include/asm/bitops.h | 6 ++----
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index 0d81697..8ad0ed4 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -13,6 +13,7 @@
 #include <asm/assembler.h>
 #include <asm/cmpxchg.h>
 #include <asm/dcache_clear.h>
+#include <asm/barrier.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -308,10 +309,4 @@ static __inline__ void atomic_set_mask(unsigned long  mask, atomic_t *addr)
 	local_irq_restore(flags);
 }
 
-/* Atomic operations are already serializing on m32r */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
 #endif	/* _ASM_M32R_ATOMIC_H */
diff --git a/arch/m32r/include/asm/bitops.h b/arch/m32r/include/asm/bitops.h
index d3dea9a..86ba2b4 100644
--- a/arch/m32r/include/asm/bitops.h
+++ b/arch/m32r/include/asm/bitops.h
@@ -21,6 +21,7 @@
 #include <asm/byteorder.h>
 #include <asm/dcache_clear.h>
 #include <asm/types.h>
+#include <asm/barrier.h>
 
 /*
  * These have to be done with inline assembly: that way the bit-setting
@@ -73,7 +74,7 @@ static __inline__ void set_bit(int nr, volatile void * addr)
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static __inline__ void clear_bit(int nr, volatile void * addr)
@@ -103,9 +104,6 @@ static __inline__ void clear_bit(int nr, volatile void * addr)
 	local_irq_restore(flags);
 }
 
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
 /**
  * change_bit - Toggle a bit in memory
  * @nr: Bit to clear
