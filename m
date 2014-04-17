Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaDQPIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:08:23 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43552 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaDQPEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:53 -0400
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
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v9 10/19] qspinlock, x86: Allow unfair spinlock in a virtual guest
Date: Thu, 17 Apr 2014 11:04:02 -0400
Message-Id: <1397747051-15401-11-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locking is always an issue in a virtualized environment because of 2
different types of problems:
 1) Lock holder preemption
 2) Lock waiter preemption

One solution to the lock waiter preemption problem is to allow unfair
lock in a virtualized environment. In this case, a new lock acquirer
can come and steal the lock if the next-in-line CPU to get the lock
is scheduled out.

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
disk workload of the AIM7 benchmark and the ebizzy test were run on
a 4-socket 40-core Westmere-EX system (bare metal, HT off, ramdisk)
on a 3.14 based kernel.  The table below shows the performance
of the different kernel flavors.

                AIM7 XFS Disk Test
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  ticketlock            5678233    3.17       96.61       5.81
  qspinlock             5750799    3.13       94.83       5.97
  simple test-and-set	5625000	   3.20	      98.29	  5.93
  simple unfair		5750799	   3.13	      95.91	  5.98
    qspinlock

                AIM7 EXT4 Disk Test
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  ticketlock            1114551   16.15      509.72       7.11
  qspinlock             2184466    8.24      232.99       6.01
  simple test-and-set	 593081	  30.35	     967.55	  9.00
  simple unfair		2292994	   7.85	     222.84	  5.89
    qspinlock

                Ebizzy -m test
  kernel               records/s  Real Time   Sys Time    Usr Time
  -----                ---------  ---------   --------    --------
  ticketlock             2075       10.00      216.35       3.49
  qspinlock              3023       10.00      198.20       4.80
  simple test-and-set	 1667	    10.00      198.93	    2.89
  simple unfair		 2915	    10.00      165.68	    4.31
    qspinlock

The disk-xfs workload spent only about 2.88% of CPU time in
_raw_spin_lock() whereas the disk-ext4 workload spent 57.8% of CPU
time in _raw_spin_lock(). It can be seen that there wasn't too much
difference in performance with low spinlock contention in the disk-xfs
workload. With heavy spinlock contention, the performance of simple
test-and-set lock can plummet when compared with the ticket and
queue spinlocks.

Unfair lock in a native environment is generally not a good idea as
there is a possibility of lock starvation for a heavily contended lock.

This patch adds a new configuration option for the x86 architecture
to enable the use of unfair queue spinlock (PARAVIRT_UNFAIR_LOCKS) in
a para-virtualized guest. A jump label (paravirt_unfairlocks_enabled)
is used to switch between a fair and an unfair version of the spinlock
code. This jump label will only be enabled in a virtual guest where
the X86_FEATURE_HYPERVISOR feature bit is set.

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
    2       890       1082	     421	  718
    3      1932       2248     	     708	 1263
    4      2829       2819	    1030	 1916
    5      3834       3522	    1323	 2327
    6      4963       4173	    1723	 2938
    7      6299       4875          2067	 3292
    8      7691       5563          2360	 3768

Executing one task per node, the performance data were:

  # of    Ticket       Fair	 Unfair simple	  Unfair
  nodes    lock     queue lock    queue lock	byte lock
  ------  -------   ----------    ----------	---------
    1        135        135          137	  137
    2       4603       1034          670	  766
    3      10940      12087         1389	 1934
    4      21555      10507         1869	 3731

In general, the shorter the critical section, the better the
performance benefit of an unfair lock. For large critical section,
however, there may not be much benefit.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/Kconfig                     |   11 +++++
 arch/x86/include/asm/qspinlock.h     |   79 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile             |    1 +
 arch/x86/kernel/paravirt-spinlocks.c |   26 +++++++++++
 kernel/locking/qspinlock.c           |    8 +++
 5 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dabeed8..59a6f84 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -583,6 +583,17 @@ config PARAVIRT_SPINLOCKS
 
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
index e4a4f5d..19af937 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -5,6 +5,10 @@
 
 #if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
 
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+extern struct static_key paravirt_unfairlocks_enabled;
+#endif
+
 #define	queue_spin_unlock queue_spin_unlock
 /**
  * queue_spin_unlock - release a queue spinlock
@@ -26,4 +30,79 @@ static inline void queue_spin_unlock(struct qspinlock *lock)
 
 #include <asm-generic/qspinlock.h>
 
+union arch_qspinlock {
+	atomic_t val;
+	u8	 locked;
+};
+
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+/**
+ * queue_spin_trylock_unfair - try to acquire the queue spinlock unfairly
+ * @lock : Pointer to queue spinlock structure
+ * Return: 1 if lock acquired, 0 if failed
+ */
+static __always_inline int queue_spin_trylock_unfair(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	if (!qlock->locked && (cmpxchg(&qlock->locked, 0, _Q_LOCKED_VAL) == 0))
+		return 1;
+	return 0;
+}
+
+/**
+ * queue_spin_lock_unfair - acquire a queue spinlock unfairly
+ * @lock: Pointer to queue spinlock structure
+ */
+static __always_inline void queue_spin_lock_unfair(struct qspinlock *lock)
+{
+	union arch_qspinlock *qlock = (union arch_qspinlock *)lock;
+
+	if (likely(cmpxchg(&qlock->locked, 0, _Q_LOCKED_VAL) == 0))
+		return;
+	/*
+	 * Since the lock is now unfair, we should not activate the 2-task
+	 * pending bit spinning code path which disallows lock stealing.
+	 */
+	queue_spin_lock_slowpath(lock, -1);
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
index f4d9600..b436419 100644
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
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index eab005a..20e3fa6 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -231,6 +231,14 @@ static __always_inline int get_qlock(struct qspinlock *lock)
 {
 	struct __qspinlock *l = (void *)lock;
 
+#ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
+	if (static_key_false(&paravirt_unfairlocks_enabled))
+		/*
+		 * Need to use atomic operation to get the lock when
+		 * lock stealing can happen.
+		 */
+		return cmpxchg(&l->locked, 0, _Q_LOCKED_VAL) == 0;
+#endif
 	barrier();
 	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
 	barrier();
-- 
1.7.1

