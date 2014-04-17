Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaDQPI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:08:57 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:43471 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaDQPEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:04:49 -0400
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
Subject: [PATCH v9 07/19] qspinlock: Use a simple write to grab the lock, if applicable
Date: Thu, 17 Apr 2014 11:03:59 -0400
Message-Id: <1397747051-15401-8-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, atomic_cmpxchg() is used to get the lock. However, this is
not really necessary if there is more than one task in the queue and
the queue head don't need to reset the queue code word. For that case,
a simple write to set the lock bit is enough as the queue head will
be the only one eligible to get the lock as long as it checks that
both the lock and pending bits are not set. The current pending bit
waiting code will ensure that the bit will not be set as soon as the
queue code word (tail) in the lock is set.

With that change, the are some slight improvement in the performance
of the queue spinlock in the 5M loop micro-benchmark run on a 4-socket
Westere-EX machine as shown in the tables below.

		[Standalone/Embedded - same node]
  # of tasks	Before patch	After patch	%Change
  ----------	-----------	----------	-------
       3	 2324/2321	2248/2265	 -3%/-2%
       4	 2890/2896	2819/2831	 -2%/-2%
       5	 3611/3595	3522/3512	 -2%/-2%
       6	 4281/4276	4173/4160	 -3%/-3%
       7	 5018/5001	4875/4861	 -3%/-3%
       8	 5759/5750	5563/5568	 -3%/-3%

		[Standalone/Embedded - different nodes]
  # of tasks	Before patch	After patch	%Change
  ----------	-----------	----------	-------
       3	12242/12237	12087/12093	 -1%/-1%
       4	10688/10696	10507/10521	 -2%/-2%

It was also found that this change produced a much bigger performance
improvement in the newer IvyBridge-EX chip and was essentially to close
the performance gap between the ticket spinlock and queue spinlock.

The disk workload of the AIM7 benchmark was run on a 4-socket
Westmere-EX machine with both ext4 and xfs RAM disks at 3000 users
on a 3.14 based kernel. The results of the test runs were:

                AIM7 XFS Disk Test
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  ticketlock            5678233    3.17       96.61       5.81
  qspinlock             5750799    3.13       94.83       5.97

                AIM7 EXT4 Disk Test
  kernel                 JPM    Real Time   Sys Time    Usr Time
  -----                  ---    ---------   --------    --------
  ticketlock            1114551   16.15      509.72       7.11
  qspinlock             2184466    8.24      232.99       6.01

The ext4 filesystem run had a much higher spinlock contention than
the xfs filesystem run.

The "ebizzy -m" test was also run with the following results:

  kernel               records/s  Real Time   Sys Time    Usr Time
  -----                ---------  ---------   --------    --------
  ticketlock             2075       10.00      216.35       3.49
  qspinlock              3023       10.00      198.20       4.80

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 kernel/locking/qspinlock.c |   61 +++++++++++++++++++++++++++++++------------
 1 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index 497da24..80fe9ee 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -98,23 +98,29 @@ static inline struct mcs_spinlock *decode_tail(u32 tail)
  * can allow better optimization of the lock acquisition for the pending
  * bit holder.
  */
-#if _Q_PENDING_BITS == 8
-
 struct __qspinlock {
 	union {
 		atomic_t val;
-		struct {
 #ifdef __LITTLE_ENDIAN
+		u8	 locked;
+		struct {
 			u16	locked_pending;
 			u16	tail;
+		};
 #else
+		struct {
 			u16	tail;
 			u16	locked_pending;
-#endif
 		};
+		struct {
+			u8	reserved[3];
+			u8	locked;
+		};
+#endif
 	};
 };
 
+#if _Q_PENDING_BITS == 8
 /**
  * clear_pending_set_locked - take ownership and clear the pending bit.
  * @lock: Pointer to queue spinlock structure
@@ -204,6 +210,22 @@ xchg_tail(struct qspinlock *lock, u32 tail, u32 *pval)
 #endif /* _Q_PENDING_BITS == 8 */
 
 /**
+ * get_qlock - Set the lock bit and own the lock
+ * @lock: Pointer to queue spinlock structure
+ *
+ * This routine should only be called when the caller is the only one
+ * entitled to acquire the lock.
+ */
+static __always_inline void get_qlock(struct qspinlock *lock)
+{
+	struct __qspinlock *l = (void *)lock;
+
+	barrier();
+	ACCESS_ONCE(l->locked) = _Q_LOCKED_VAL;
+	barrier();
+}
+
+/**
  * trylock_pending - try to acquire queue spinlock using the pending bit
  * @lock : Pointer to queue spinlock structure
  * @pval : Pointer to value of the queue spinlock 32-bit word
@@ -322,7 +344,7 @@ static inline int trylock_pending(struct qspinlock *lock, u32 *pval)
 void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 {
 	struct mcs_spinlock *prev, *next, *node;
-	u32 new, old, tail;
+	u32 old, tail;
 	int idx;
 
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
@@ -367,10 +389,13 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	/*
 	 * we're at the head of the waitqueue, wait for the owner & pending to
 	 * go away.
+	 * Load-acquired is used here because the get_qlock()
+	 * function below may not be a full memory barrier.
 	 *
 	 * *,x,y -> *,0,0
 	 */
-	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_PENDING_MASK)
+	while ((val = smp_load_acquire(&lock->val.counter))
+				       & _Q_LOCKED_PENDING_MASK)
 		arch_mutex_cpu_relax();
 
 	/*
@@ -378,15 +403,19 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 *
 	 * n,0,0 -> 0,0,1 : lock, uncontended
 	 * *,0,0 -> *,0,1 : lock, contended
+	 *
+	 * If the queue head is the only one in the queue (lock value == tail),
+	 * clear the tail code and grab the lock. Otherwise, we only need
+	 * to grab the lock.
 	 */
 	for (;;) {
-		new = _Q_LOCKED_VAL;
-		if (val != tail)
-			new |= val;
-
-		old = atomic_cmpxchg(&lock->val, val, new);
-		if (old == val)
+		if (val != tail) {
+			get_qlock(lock);
 			break;
+		}
+		old = atomic_cmpxchg(&lock->val, val, _Q_LOCKED_VAL);
+		if (old == val)
+			goto release;	/* No contention */
 
 		val = old;
 	}
@@ -394,12 +423,10 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	/*
 	 * contended path; wait for next, release.
 	 */
-	if (new != _Q_LOCKED_VAL) {
-		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
+	while (!(next = ACCESS_ONCE(node->next)))
+		arch_mutex_cpu_relax();
 
-		arch_mcs_spin_unlock_contended(&next->locked);
-	}
+	arch_mcs_spin_unlock_contended(&next->locked);
 
 release:
 	/*
-- 
1.7.1

