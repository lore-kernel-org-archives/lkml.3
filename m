Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaDRNMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:12:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39052 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaDRNLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:11:41 -0400
Date: Fri, 18 Apr 2014 06:10:32 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9ph49jbae3hol9v721sbc2g6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        macro@codesourcery.com, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        macro@codesourcery.com, ralf@linux-mips.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch,mips: Convert smp_mb__*()
Git-Commit-ID: 91bbefe6b0fcd2968c34a5a566bda870477afc82
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

Commit-ID:  91bbefe6b0fcd2968c34a5a566bda870477afc82
Gitweb:     http://git.kernel.org/tip/91bbefe6b0fcd2968c34a5a566bda870477afc82
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Mar 2014 19:00:36 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:38 +0200

arch,mips: Convert smp_mb__*()

MIPS is interesting and has hardware variants that reorder over ll/sc
as well as those that do not.

Implement the 2 new barrier functions as per the old barriers.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-9ph49jbae3hol9v721sbc2g6@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maciej W. Rozycki" <macro@codesourcery.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/mips/include/asm/atomic.h  |  9 ---------
 arch/mips/include/asm/barrier.h |  3 +++
 arch/mips/include/asm/bitops.h  | 11 ++---------
 arch/mips/kernel/irq.c          |  4 ++--
 4 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index e8eb3d5..37b2bef 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -761,13 +761,4 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 
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
diff --git a/arch/mips/include/asm/barrier.h b/arch/mips/include/asm/barrier.h
index e1aa4e4..d0101dd 100644
--- a/arch/mips/include/asm/barrier.h
+++ b/arch/mips/include/asm/barrier.h
@@ -195,4 +195,7 @@ do {									\
 	___p1;								\
 })
 
+#define smp_mb__before_atomic()	smp_mb__before_llsc()
+#define smp_mb__after_atomic()	smp_llsc_mb()
+
 #endif /* __ASM_BARRIER_H */
diff --git a/arch/mips/include/asm/bitops.h b/arch/mips/include/asm/bitops.h
index 6a65d49..7c8816f 100644
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
@@ -120,7 +113,7 @@ static inline void set_bit(unsigned long nr, volatile unsigned long *addr)
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static inline void clear_bit(unsigned long nr, volatile unsigned long *addr)
@@ -175,7 +168,7 @@ static inline void clear_bit(unsigned long nr, volatile unsigned long *addr)
  */
 static inline void clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(nr, addr);
 }
 
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index d1fea7a..1818da4 100644
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
