Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaDBNbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:31:48 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:18268 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbaDBN20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:28:26 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v8 05/10] pvqspinlock, x86: Allow unfair spinlock in a PV guest
Date: Wed,  2 Apr 2014 09:27:34 -0400
Message-Id: <1396445259-27670-6-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locking is always an issue in a virtualized environment because of 2
different types of problems:
 1) Lock holder preemption
 2) Lock waiter preemption

One solution to the lock waiter preemption problem is to allow unfair
lock in a para-virtualized environment. In this case, a new lock
acquirer can come and steal the lock if the next-in-line CPU to get
the lock is scheduled out.

A simple unfair lock is the test-and-set byte lock where an lock
acquirer constantly spins on the lock word and attempt to grab it
when the lock is freed. This simple unfair lock has 2 main problems:
 1) The constant spinning on the lock word put a lot of cacheline
    contention traffic on the affected cacheline, thus slowing tasks
    that need to access the cacheline.
 2) Lock starvation is a real possibility especially if the number of
    virtual CPUs is large.

A simple unfair queue spinlock can be implemented by allowing lock
stealing in the fast path. The slowpath will still be the same as
before and all the pending lock acquirers will have to wait in the
queue in FIFO order. This cannot completely solve the lock waiter
preemption problem, but it does help to alleviate the impact of
this problem.

To illustrate the performance impact of the various approaches, the
disk workload of the AIM7 benchmark was run on a 4-socket 40-core
Westmere-EX system (bare metal, HT off, ramdisk) on a 3.14-rc5
based kernel.  The table below shows the performance (jobs/minutes)
of the different kernel flavors.

  Kernel			disk-xfs JPM	disk-ext4 JPM
  ------			------------	-------------
  ticketlock	 		5,660,377	 1,151,631
  qspinlock	 		5,678,233	 2,033,898
  simple test-and-set   	5,678,233	   533,966
  simple unfair qspinlock	5,732,484	 2,216,749

The disk-xfs workload spent only about 2.88% of CPU time in
_raw_spin_lock() whereas the disk-ext4 workload spent 57.8% of CPU
time in _raw_spin_lock(). It can be seen that there wasn't too much
difference in performance with low spinlock contention in the disk-xfs
workload. With heavy spinlock contention, the simple test-and-set
lock is only half the performance of the baseline ticketlock. The
simple unfair qspinlock, on the other hand, is almost double the
performance of the ticketlock.

Unfair lock in a native environment is generally not a good idea as
there is a possibility of lock starvation for a heavily contended lock.

This patch adds a new configuration option for the x86 architecture
to enable the use of unfair queue spinlock (PARAVIRT_UNFAIR_LOCKS) in
a para-virtualized guest. A jump label (paravirt_unfairlocks_enabled)
is used to switch between a fair and an unfair version of the spinlock
code. This jump label will only be enabled in a PV guest where the
X86_FEATURE_HYPERVISOR feature bit is set.

Enabling this configuration feature causes a slight decrease the
performance of an uncontended lock-unlock operation by about 1-2%
mainly due to the use of a static key. However, uncontended lock-unlock
operation are really just a tiny percentage of a real workload. So
there should no noticeable change in application performance.

With the unfair locking activated on bare metal 4-socket Westmere-EX
box, the execution times (in ms) of a spinlock micro-benchmark were
as follows:

  # of    Ticket       Fair	 Unfair simple	  Unfair
  tasks    lock     queue lock    queue lock	byte lock
  ------  -------   ----------    ----------	---------
    1       135        135	     137	  137
    2      1045        951	     732	  462
    3      1827       2256     	     915	  963
    4      2689       2880	    1377	 1706
    5      3736       3636	    1439	 2127
    6      4942       4294	    1724	 2980
    7      6304       4976          2001	 3491
    8      7736       5662          2317	 3955

Executing one task per node, the performance data were:

  # of    Ticket       Fair	 Unfair simple	  Unfair
  nodes    lock     queue lock    queue lock	byte lock
  ------  -------   ----------    ----------	---------
    1        135        135          137	  137
    2       4452       1024         1697	  710
    3      10767      14030         2015	 1468
    4      20835      10740         2732	 2582

In general, the shorter the critical section, the better the
performance benefit of an unfair lock. For large critical section,
however, there may not be much benefit.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/Kconfig                     |   11 ++++
 arch/x86/include/asm/qspinlock.h     |   86 +++++++++++++++++++++++++++++++++-
 arch/x86/kernel/Makefile             |    1 +
 arch/x86/kernel/paravirt-spinlocks.c |   26 ++++++++++
 4 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index de573f9..010abc4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -629,6 +629,17 @@ config PARAVIRT_SPINLOCKS
 
 	  If you are unsure how to answer this question, answer Y.
 
+config PARAVIRT_UNFAIR_LOCKS
+	bool "Enable unfair locks in a para-virtualized guest"
+	depends on PARAVIRT && SMP && QUEUE_SPINLOCK
+	depends on !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE
+	---help---
+	  This changes the kernel to use unfair locks in a
+	  para-virtualized guest. This will help performance in most
+	  cases. However, there is a possibility of lock starvation
+	  on a heavily contended lock especially in a large guest
+	  with many virtual CPUs.
+
 source "arch/x86/xen/Kconfig"
 
 config KVM_GUEST
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index 265b10b..d91994d 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -28,6 +28,10 @@ union arch_qspinlock {
 	u32 qlcode;		/* Complete lock word */
 };
 
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+extern struct static_key paravirt_unfairlocks_enabled;
+#endif
+
 #define	queue_spin_unlock queue_spin_unlock
 /**
  * queue_spin_unlock - release a queue spinlock
@@ -52,15 +56,23 @@ static inline void queue_spin_unlock(struct qspinlock *lock)
 /**
  * __queue_spin_trylock - acquire the lock by setting the lock bit
  * @lock: Pointer to queue spinlock structure
- * Return: Always return 1
+ * Return: 1 if lock acquired, 0 otherwise
  *
  * This routine should only be called when the caller is the only one
- * entitled to acquire the lock. No lock stealing is allowed.
+ * entitled to acquire the lock.
  */
 static __always_inline int __queue_spin_trylock(struct qspinlock *lock)
 {
 	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
 
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+	if (static_key_false(&paravirt_unfairlocks_enabled))
+		/*
+		 * Need to use atomic operation to get the lock when
+		 * lock stealing can happen.
+		 */
+		return cmpxchg(&qlock->lock, 0, _QLOCK_LOCKED) == 0;
+#endif
 	barrier();
 	ACCESS_ONCE(qlock->lock) = _QLOCK_LOCKED;
 	barrier();
@@ -71,4 +83,74 @@ static __always_inline int __queue_spin_trylock(struct qspinlock *lock)
 
 #include <asm-generic/qspinlock.h>
 
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+/**
+ * queue_spin_lock_unfair - acquire a queue spinlock unfairly
+ * @lock: Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_lock_unfair(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	if (likely(cmpxchg(&qlock->lock, 0, _QLOCK_LOCKED) == 0))
+		return;
+	/*
+	 * Since the lock is now unfair, we should not activate the 2-task
+	 * quick spinning code path which disallows lock stealing.
+	 */
+	queue_spin_lock_slowpath(lock, -1);
+}
+
+/**
+ * queue_spin_trylock_unfair - try to acquire the queue spinlock unfairly
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock_unfair(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	if (!qlock->lock && (cmpxchg(&qlock->lock, 0, _QLOCK_LOCKED) == 0))
+		return 1;
+	return 0;
+}
+
+/*
+ * Redefine arch_spin_lock and arch_spin_trylock as inline functions that will
+ * jump to the unfair versions if the static key paravirt_unfairlocks_enabled
+ * is true.
+ */
+#undef arch_spin_lock
+#undef arch_spin_trylock
+#undef arch_spin_lock_flags
+
+/**
+ * arch_spin_lock - acquire a queue spinlock
+ * @lock: Pointer to queue spinlock structure
+ */
+static inline void arch_spin_lock(struct qspinlock *lock)
+{
+	if (static_key_false(&paravirt_unfairlocks_enabled))
+		queue_spin_lock_unfair(lock);
+	else
+		queue_spin_lock(lock);
+}
+
+/**
+ * arch_spin_trylock - try to acquire the queue spinlock
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static inline int arch_spin_trylock(struct qspinlock *lock)
+{
+	if (static_key_false(&paravirt_unfairlocks_enabled))
+		return queue_spin_trylock_unfair(lock);
+	else
+		return queue_spin_trylock(lock);
+}
+
+#define arch_spin_lock_flags(l, f)	arch_spin_lock(l)
+
+#endif /* CONFIG_PARAVIRT_UNFAIR_LOCKS */
+
 #endif /* _ASM_X86_QSPINLOCK_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cb648c8..1107a20 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -88,6 +88,7 @@ obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
+obj-$(CONFIG_PARAVIRT_UNFAIR_LOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index bbb6c73..7dfd02d 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -8,6 +8,7 @@
 
 #include <asm/paravirt.h>
 
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
 struct pv_lock_ops pv_lock_ops = {
 #ifdef CONFIG_SMP
 	.lock_spinning = __PV_IS_CALLEE_SAVE(paravirt_nop),
@@ -18,3 +19,28 @@ EXPORT_SYMBOL(pv_lock_ops);
 
 struct static_key paravirt_ticketlocks_enabled = STATIC_KEY_INIT_FALSE;
 EXPORT_SYMBOL(paravirt_ticketlocks_enabled);
+#endif
+
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+struct static_key paravirt_unfairlocks_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL(paravirt_unfairlocks_enabled);
+
+#include <linux/init.h>
+#include <asm/cpufeature.h>
+
+/*
+ * Enable unfair lock only if it is running under a hypervisor
+ */
+static __init int unfair_locks_init_jump(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return 0;
+
+	static_key_slow_inc(&paravirt_unfairlocks_enabled);
+	printk(KERN_INFO "Unfair spinlock enabled\n");
+
+	return 0;
+}
+early_initcall(unfair_locks_init_jump);
+
+#endif
-- 
1.7.1

