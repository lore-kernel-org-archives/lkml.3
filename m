Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaBGQ6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:58:08 -0500
Received: from verein.lst.de ([213.95.11.211]:44585 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaBGQ6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:58:06 -0500
Date: Fri, 7 Feb 2014 17:58:01 +0100
From: Torsten Duwe <duwe@lst.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott Wood <scottwood@freescale.com>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2] powerpc ticket locks
Message-ID: <20140207165801.GC2107@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ticket locks for ppc, version 2. Changes since v1:
* The atomically exchanged entity is always 32 bits.
* asm inline string variations thus removed.
* Carry the additional holder hint only #if defined(CONFIG_PPC_SPLPAR)

Signed-off-by: Torsten Duwe <duwe@suse.de>
--
 arch/powerpc/include/asm/spinlock_types.h |   29 +++++
 arch/powerpc/include/asm/spinlock.h       |  146 +++++++++++++++++++++++-------
 arch/powerpc/lib/locks.c                  |    6 -
 3 files changed, 144 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/include/asm/spinlock_types.h b/arch/powerpc/include/asm/spinlock_types.h
index 2351adc..fce1383 100644
--- a/arch/powerpc/include/asm/spinlock_types.h
+++ b/arch/powerpc/include/asm/spinlock_types.h
@@ -5,11 +5,34 @@
 # error "please don't include this file directly"
 #endif
 
+typedef u16 __ticket_t;
+typedef u32 __ticketpair_t;
+
+#define TICKET_LOCK_INC	((__ticket_t)1)
+
+#define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
+
 typedef struct {
-	volatile unsigned int slock;
-} arch_spinlock_t;
+	union {
+		__ticketpair_t head_tail;
+		struct __raw_tickets {
+#ifdef __BIG_ENDIAN__		/* The "tail" part should be in the MSBs */
+			__ticket_t tail, head;
+#else
+			__ticket_t head, tail;
+#endif
+		} tickets;
+	};
+#if defined(CONFIG_PPC_SPLPAR)
+	u32 holder;
+#endif
+} arch_spinlock_t __aligned(4);
 
-#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+#if defined(CONFIG_PPC_SPLPAR)
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 }, 0 }
+#else
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
+#endif
 
 typedef struct {
 	volatile signed int lock;
diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index 5f54a74..a931514 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -9,8 +9,7 @@
  * Copyright (C) 2001 Anton Blanchard <anton@au.ibm.com>, IBM
  * Copyright (C) 2002 Dave Engebretsen <engebret@us.ibm.com>, IBM
  *	Rework to support virtual processors
- *
- * Type of int is used as a full 64b word is not necessary.
+ * Copyright (C) 2014 Torsten Duwe <duwe@suse.de>, ticket lock port
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -28,7 +27,20 @@
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
 
-#define arch_spin_is_locked(x)		((x)->slock != 0)
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
+{
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+
+	return tmp.tail != tmp.head;
+}
+
+static inline int arch_spin_is_contended(arch_spinlock_t *lock)
+{
+	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+
+	return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
+}
+#define arch_spin_is_contended	arch_spin_is_contended
 
 #ifdef CONFIG_PPC64
 /* use 0x800000yy when locked, where yy == CPU number */
@@ -55,33 +67,59 @@
 #endif
 
 /*
- * This returns the old value in the lock, so we succeeded
- * in getting the lock if the return value is 0.
+ * Our own cmpxchg, operating on spinlock_t's.  Returns 0 iff value
+ * read at lock was equal to "old" AND the cmpxchg succeeded
+ * uninterruptedly.
  */
-static inline unsigned long __arch_spin_trylock(arch_spinlock_t *lock)
+static __always_inline int __arch_spin_cmpxchg_eq(arch_spinlock_t *lock,
+						  __ticketpair_t old,
+						  __ticketpair_t new)
 {
-	unsigned long tmp, token;
+	register int retval = 1;
+	register __ticketpair_t tmp;
 
-	token = LOCK_TOKEN;
-	__asm__ __volatile__(
-"1:	" PPC_LWARX(%0,0,%2,1) "\n\
-	cmpwi		0,%0,0\n\
-	bne-		2f\n\
-	stwcx.		%1,0,%2\n\
-	bne-		1b\n"
-	PPC_ACQUIRE_BARRIER
+	__asm__ __volatile__ (
+"	li %0,1\n"		/* default to "fail" */
+	PPC_RELEASE_BARRIER
+"1:	lwarx	%2,0,%5		# __arch_spin_cmpxchg_eq\n"
+"	cmp	0,0,%3,%2\n"
+"	bne-	2f\n"
+	PPC405_ERR77(0, "%5")
+"	stwcx.	%4,0,%5\n"
+"	bne-	1b\n"
+"	isync\n"
+"	li %0,0\n"
 "2:"
-	: "=&r" (tmp)
-	: "r" (token), "r" (&lock->slock)
-	: "cr0", "memory");
+	: "=&r" (retval), "+m" (*lock)
+	: "r" (tmp), "r" (old), "r" (new), "r" (lock)
+	: "cc", "memory");
 
-	return tmp;
+	return retval;
+}
+
+static __always_inline int __arch_spin_trylock(arch_spinlock_t *lock)
+{
+	arch_spinlock_t old, new;
+
+	old.tickets = ACCESS_ONCE(lock->tickets);
+	if (old.tickets.head != old.tickets.tail)
+		return 0;
+
+	new.head_tail = old.head_tail + (TICKET_LOCK_INC << TICKET_SHIFT);
+
+	if (__arch_spin_cmpxchg_eq(lock, old.head_tail, new.head_tail))
+		return 0;
+
+#if defined(CONFIG_PPC_SPLPAR)
+	lock->holder = LOCK_TOKEN;
+#endif
+	return 1;
 }
 
 static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
-	return __arch_spin_trylock(lock) == 0;
+	return  __arch_spin_trylock(lock);
 }
 
 /*
@@ -93,9 +131,8 @@ static inline int arch_spin_trylock(arch_spinlock_t *lock)
  * rest of our timeslice to the lock holder.
  *
  * So that we can tell which virtual processor is holding a lock,
- * we put 0x80000000 | smp_processor_id() in the lock when it is
- * held.  Conveniently, we have a word in the paca that holds this
- * value.
+ * we put 0x80000000 | smp_processor_id() into lock->holder.
+ * Conveniently, we have a word in the paca that holds this value.
  */
 
 #if defined(CONFIG_PPC_SPLPAR)
@@ -109,19 +146,55 @@ extern void __rw_yield(arch_rwlock_t *lock);
 #define SHARED_PROCESSOR	0
 #endif
 
-static inline void arch_spin_lock(arch_spinlock_t *lock)
+/*
+ * Ticket locks are conceptually two parts, one indicating the current head of
+ * the queue, and the other indicating the current tail. The lock is acquired
+ * by atomically noting the tail and incrementing it by one (thus adding
+ * ourself to the queue and noting our position), then waiting until the head
+ * becomes equal to the the initial value of the tail.
+ *
+ * We use an asm covering *both* parts of the lock, to increment the tail and
+ * also load the position of the head, which takes care of memory ordering
+ * issues and should be optimal for the uncontended case. Note the tail must be
+ * in the high part, because a wide add increment of the low part would carry
+ * up and contaminate the high part.
+ */
+static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 {
+	register struct __raw_tickets old, tmp,
+		inc = { .tail = TICKET_LOCK_INC };
+
 	CLEAR_IO_SYNC;
-	while (1) {
-		if (likely(__arch_spin_trylock(lock) == 0))
-			break;
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%4		# arch_spin_lock\n"
+"	add	%1,%3,%0\n"
+	PPC405_ERR77(0, "%4")
+"	stwcx.	%1,0,%4\n"
+"	bne-	1b"
+	: "=&r" (old), "=&r" (tmp), "+m" (lock->tickets)
+	: "r" (inc), "r" (&lock->tickets)
+	: "cc");
+
+	if (likely(old.head == old.tail))
+		goto out;
+
+	for (;;) {
+		unsigned count = 100;
+
 		do {
+			if (ACCESS_ONCE(lock->tickets.head) == old.tail)
+				goto out;
 			HMT_low();
 			if (SHARED_PROCESSOR)
 				__spin_yield(lock);
-		} while (unlikely(lock->slock != 0));
+		} while (--count);
 		HMT_medium();
 	}
+out:
+#if defined(CONFIG_PPC_SPLPAR)
+	lock->holder = LOCK_TOKEN;
+#endif
+	barrier();	/* make sure nothing creeps before the lock is taken */
 }
 
 static inline
@@ -131,7 +204,7 @@ void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 
 	CLEAR_IO_SYNC;
 	while (1) {
-		if (likely(__arch_spin_trylock(lock) == 0))
+		if (likely(__arch_spin_trylock(lock)))
 			break;
 		local_save_flags(flags_dis);
 		local_irq_restore(flags);
@@ -139,7 +212,7 @@ void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 			HMT_low();
 			if (SHARED_PROCESSOR)
 				__spin_yield(lock);
-		} while (unlikely(lock->slock != 0));
+		} while (arch_spin_is_locked(lock));
 		HMT_medium();
 		local_irq_restore(flags_dis);
 	}
@@ -147,10 +220,21 @@ void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 
 static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
+	arch_spinlock_t old, new;
+
+#if defined(CONFIG_PPC_SPLPAR)
+	lock->holder = 0;
+#endif
+	do {
+		old.tickets = ACCESS_ONCE(lock->tickets);
+		new.tickets.head = old.tickets.head + TICKET_LOCK_INC;
+		new.tickets.tail = old.tickets.tail;
+	} while (unlikely(__arch_spin_cmpxchg_eq(lock,
+						 old.head_tail,
+						 new.head_tail)));
 	SYNC_IO;
 	__asm__ __volatile__("# arch_spin_unlock\n\t"
 				PPC_RELEASE_BARRIER: : :"memory");
-	lock->slock = 0;
 }
 
 #ifdef CONFIG_PPC64
diff --git a/arch/powerpc/lib/locks.c b/arch/powerpc/lib/locks.c
index 0c9c8d7..4a57e32 100644
--- a/arch/powerpc/lib/locks.c
+++ b/arch/powerpc/lib/locks.c
@@ -27,7 +27,7 @@ void __spin_yield(arch_spinlock_t *lock)
 {
 	unsigned int lock_value, holder_cpu, yield_count;
 
-	lock_value = lock->slock;
+	lock_value = lock->holder;
 	if (lock_value == 0)
 		return;
 	holder_cpu = lock_value & 0xffff;
@@ -36,7 +36,7 @@ void __spin_yield(arch_spinlock_t *lock)
 	if ((yield_count & 1) == 0)
 		return;		/* virtual cpu is currently running */
 	rmb();
-	if (lock->slock != lock_value)
+	if (lock->holder != lock_value)
 		return;		/* something has changed */
 	plpar_hcall_norets(H_CONFER,
 		get_hard_smp_processor_id(holder_cpu), yield_count);
@@ -70,7 +70,7 @@ void __rw_yield(arch_rwlock_t *rw)
 
 void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
-	while (lock->slock) {
+	while (arch_spin_is_locked(lock)) {
 		HMT_low();
 		if (SHARED_PROCESSOR)
 			__spin_yield(lock);
