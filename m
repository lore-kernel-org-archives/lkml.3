Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965111Ab3HJQNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:13:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934403Ab3HJQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:13:49 -0400
Date: Sat, 10 Aug 2013 09:13:16 -0700
From: tip-bot for Jeremy Fitzhardinge <tipbot@zytor.com>
Message-ID: <tip-545ac13892ab391049a92108cf59a0d05de7e28c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com, attilio.rao@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de,
        hpa@linux.intel.com, attilio.rao@citrix.com
In-Reply-To: <1376058122-8248-2-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <1376058122-8248-2-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, spinlock:
  Replace pv spinlocks with pv ticketlocks
Git-Commit-ID: 545ac13892ab391049a92108cf59a0d05de7e28c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 10 Aug 2013 09:13:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  545ac13892ab391049a92108cf59a0d05de7e28c
Gitweb:     http://git.kernel.org/tip/545ac13892ab391049a92108cf59a0d05de7e28c
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Fri, 9 Aug 2013 19:51:49 +0530
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 Aug 2013 07:53:05 -0700

x86, spinlock: Replace pv spinlocks with pv ticketlocks

Rather than outright replacing the entire spinlock implementation in
order to paravirtualize it, keep the ticket lock implementation but add
a couple of pvops hooks on the slow patch (long spin on lock, unlocking
a contended lock).

Ticket locks have a number of nice properties, but they also have some
surprising behaviours in virtual environments.  They enforce a strict
FIFO ordering on cpus trying to take a lock; however, if the hypervisor
scheduler does not schedule the cpus in the correct order, the system can
waste a huge amount of time spinning until the next cpu can take the lock.

(See Thomas Friebel's talk "Prevent Guests from Spinning Around"
http://www.xen.org/files/xensummitboston08/LHP.pdf for more details.)

To address this, we add two hooks:
 - __ticket_spin_lock which is called after the cpu has been
   spinning on the lock for a significant number of iterations but has
   failed to take the lock (presumably because the cpu holding the lock
   has been descheduled).  The lock_spinning pvop is expected to block
   the cpu until it has been kicked by the current lock holder.
 - __ticket_spin_unlock, which on releasing a contended lock
   (there are more cpus with tail tickets), it looks to see if the next
   cpu is blocked and wakes it if so.

When compiled with CONFIG_PARAVIRT_SPINLOCKS disabled, a set of stub
functions causes all the extra code to go away.

Results:
=======
setup: 32 core machine with 32 vcpu KVM guest (HT off)  with 8GB RAM
base = 3.11-rc
patched = base + pvspinlock V12

+-----------------+----------------+--------+
 dbench (Throughput in MB/sec. Higher is better)
+-----------------+----------------+--------+
|   base (stdev %)|patched(stdev%) | %gain  |
+-----------------+----------------+--------+
| 15035.3   (0.3) |15150.0   (0.6) |   0.8  |
|  1470.0   (2.2) | 1713.7   (1.9) |  16.6  |
|   848.6   (4.3) |  967.8   (4.3) |  14.0  |
|   652.9   (3.5) |  685.3   (3.7) |   5.0  |
+-----------------+----------------+--------+

pvspinlock shows benefits for overcommit ratio > 1 for PLE enabled cases,
and undercommits results are flat

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/1376058122-8248-2-git-send-email-raghavendra.kt@linux.vnet.ibm.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Attilio Rao <attilio.rao@citrix.com>
[ Raghavendra: Changed SPIN_THRESHOLD, fixed redefinition of arch_spinlock_t]
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/paravirt.h       | 32 ++++-----------------
 arch/x86/include/asm/paravirt_types.h | 14 +++++----
 arch/x86/include/asm/spinlock.h       | 53 ++++++++++++++++++++++++++++-------
 arch/x86/include/asm/spinlock_types.h |  4 ---
 arch/x86/kernel/paravirt-spinlocks.c  | 15 ++--------
 arch/x86/xen/spinlock.c               |  8 ++++--
 6 files changed, 65 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index cfdc9ee..040e72d 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -712,36 +712,16 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
-static inline int arch_spin_is_locked(struct arch_spinlock *lock)
+static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
+							__ticket_t ticket)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_is_locked, lock);
+	PVOP_VCALL2(pv_lock_ops.lock_spinning, lock, ticket);
 }
 
-static inline int arch_spin_is_contended(struct arch_spinlock *lock)
+static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock,
+							__ticket_t ticket)
 {
-	return PVOP_CALL1(int, pv_lock_ops.spin_is_contended, lock);
-}
-#define arch_spin_is_contended	arch_spin_is_contended
-
-static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
-{
-	PVOP_VCALL1(pv_lock_ops.spin_lock, lock);
-}
-
-static __always_inline void arch_spin_lock_flags(struct arch_spinlock *lock,
-						  unsigned long flags)
-{
-	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
-}
-
-static __always_inline int arch_spin_trylock(struct arch_spinlock *lock)
-{
-	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
-}
-
-static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
-{
-	PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
+	PVOP_VCALL2(pv_lock_ops.unlock_kick, lock, ticket);
 }
 
 #endif
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 0db1fca..346a07c 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -327,13 +327,15 @@ struct pv_mmu_ops {
 };
 
 struct arch_spinlock;
+#ifdef CONFIG_SMP
+#include <asm/spinlock_types.h>
+#else
+typedef u16 __ticket_t;
+#endif
+
 struct pv_lock_ops {
-	int (*spin_is_locked)(struct arch_spinlock *lock);
-	int (*spin_is_contended)(struct arch_spinlock *lock);
-	void (*spin_lock)(struct arch_spinlock *lock);
-	void (*spin_lock_flags)(struct arch_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct arch_spinlock *lock);
-	void (*spin_unlock)(struct arch_spinlock *lock);
+	void (*lock_spinning)(struct arch_spinlock *lock, __ticket_t ticket);
+	void (*unlock_kick)(struct arch_spinlock *lock, __ticket_t ticket);
 };
 
 /* This contains all the paravirt structures: we get a convenient
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 33692ea..4d54244 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -34,6 +34,35 @@
 # define UNLOCK_LOCK_PREFIX
 #endif
 
+/* How long a lock should spin before we consider blocking */
+#define SPIN_THRESHOLD	(1 << 15)
+
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
+
+static __always_inline void __ticket_lock_spinning(struct arch_spinlock *lock,
+							__ticket_t ticket)
+{
+}
+
+static __always_inline void ____ticket_unlock_kick(struct arch_spinlock *lock,
+							 __ticket_t ticket)
+{
+}
+
+#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+
+
+/*
+ * If a spinlock has someone waiting on it, then kick the appropriate
+ * waiting cpu.
+ */
+static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
+							__ticket_t next)
+{
+	if (unlikely(lock->tickets.tail != next))
+		____ticket_unlock_kick(lock, next);
+}
+
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
  * the queue, and the other indicating the current tail. The lock is acquired
@@ -47,19 +76,24 @@
  * in the high part, because a wide xadd increment of the low part would carry
  * up and contaminate the high part.
  */
-static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
+static __always_inline void __ticket_spin_lock(struct arch_spinlock *lock)
 {
 	register struct __raw_tickets inc = { .tail = 1 };
 
 	inc = xadd(&lock->tickets, inc);
 
 	for (;;) {
-		if (inc.head == inc.tail)
-			break;
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
+		unsigned count = SPIN_THRESHOLD;
+
+		do {
+			if (inc.head == inc.tail)
+				goto out;
+			cpu_relax();
+			inc.head = ACCESS_ONCE(lock->tickets.head);
+		} while (--count);
+		__ticket_lock_spinning(lock, inc.tail);
 	}
-	barrier();		/* make sure nothing creeps before the lock is taken */
+out:	barrier();	/* make sure nothing creeps before the lock is taken */
 }
 
 static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
@@ -78,7 +112,10 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
+	__ticket_t next = lock->tickets.head + 1;
+
 	__add(&lock->tickets.head, 1, UNLOCK_LOCK_PREFIX);
+	__ticket_unlock_kick(lock, next);
 }
 
 static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
@@ -95,8 +132,6 @@ static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 	return (__ticket_t)(tmp.tail - tmp.head) > 1;
 }
 
-#ifndef CONFIG_PARAVIRT_SPINLOCKS
-
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
@@ -129,8 +164,6 @@ static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 	arch_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT_SPINLOCKS */
-
 static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (arch_spin_is_locked(lock))
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index ad0ad07..83fd3c7 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -1,10 +1,6 @@
 #ifndef _ASM_X86_SPINLOCK_TYPES_H
 #define _ASM_X86_SPINLOCK_TYPES_H
 
-#ifndef __LINUX_SPINLOCK_TYPES_H
-# error "please don't include this file directly"
-#endif
-
 #include <linux/types.h>
 
 #if (CONFIG_NR_CPUS < 256)
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 676b8c7..c2e010e 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,21 +7,10 @@
 
 #include <asm/paravirt.h>
 
-static inline void
-default_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
-{
-	arch_spin_lock(lock);
-}
-
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
-	.spin_is_locked = __ticket_spin_is_locked,
-	.spin_is_contended = __ticket_spin_is_contended,
-
-	.spin_lock = __ticket_spin_lock,
-	.spin_lock_flags = default_spin_lock_flags,
-	.spin_trylock = __ticket_spin_trylock,
-	.spin_unlock = __ticket_spin_unlock,
+	.lock_spinning = paravirt_nop,
+	.unlock_kick = paravirt_nop,
 #endif
 };
 EXPORT_SYMBOL(pv_lock_ops);
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index cf3caee..d509629 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -139,6 +139,9 @@ struct xen_spinlock {
 	xen_spinners_t spinners;	/* count of waiting cpus */
 };
 
+static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
+
+#if 0
 static int xen_spin_is_locked(struct arch_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
@@ -167,7 +170,6 @@ static int xen_spin_trylock(struct arch_spinlock *lock)
 }
 
 static DEFINE_PER_CPU(char *, irq_name);
-static DEFINE_PER_CPU(int, lock_kicker_irq) = -1;
 static DEFINE_PER_CPU(struct xen_spinlock *, lock_spinners);
 
 /*
@@ -354,6 +356,7 @@ static void xen_spin_unlock(struct arch_spinlock *lock)
 	if (unlikely(xl->spinners))
 		xen_spin_unlock_slow(xl);
 }
+#endif
 
 static irqreturn_t dummy_handler(int irq, void *dev_id)
 {
@@ -418,13 +421,14 @@ void __init xen_init_spinlocks(void)
 		return;
 
 	BUILD_BUG_ON(sizeof(struct xen_spinlock) > sizeof(arch_spinlock_t));
-
+#if 0
 	pv_lock_ops.spin_is_locked = xen_spin_is_locked;
 	pv_lock_ops.spin_is_contended = xen_spin_is_contended;
 	pv_lock_ops.spin_lock = xen_spin_lock;
 	pv_lock_ops.spin_lock_flags = xen_spin_lock_flags;
 	pv_lock_ops.spin_trylock = xen_spin_trylock;
 	pv_lock_ops.spin_unlock = xen_spin_unlock;
+#endif
 }
 
 #ifdef CONFIG_XEN_DEBUG_FS
