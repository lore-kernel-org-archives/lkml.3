Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbaCJQDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 12:03:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53942 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaCJQCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 12:02:38 -0400
Message-Id: <20140310155543.752678774@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Mar 2014 16:42:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 7/7] qspinlock: Optimize for smaller NR_CPUS
References: <20140310154236.038181843@infradead.org>
Content-Disposition: inline; filename=peterz-qspinlock-pending-byte.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we allow for a max NR_CPUS < 2^14 we can optimize the pending
wait-acquire and the xchg_tail() operations.

By growing the pending bit to a byte, we reduce the tail to 16bit.
This means we can use xchg16 for the tail part and do away with all
the trickyness of having to fix up the (pending,locked) state.

This in turn allows us to unconditionally acquire; the locked state as
observed by the wait loops cannot change. And because both locked and
pending are now a full byte we can use simple ordered stores for the
state transition, obviating one atomic operation entirely.

All this is horribly broken on Alpha pre EV56 (and any other arch that
cannot do single-copy atomic byte stores).

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/qspinlock_types.h |    5 +
 kernel/locking/qspinlock.c            |  105 ++++++++++++++++++++++++++++++----
 2 files changed, 98 insertions(+), 12 deletions(-)

--- a/include/asm-generic/qspinlock_types.h
+++ b/include/asm-generic/qspinlock_types.h
@@ -48,7 +48,11 @@ typedef struct qspinlock {
 #define _Q_LOCKED_MASK		(((1U << _Q_LOCKED_BITS) - 1) << _Q_LOCKED_OFFSET)
 
 #define _Q_PENDING_OFFSET	(_Q_LOCKED_OFFSET + _Q_LOCKED_BITS)
+#if CONFIG_NR_CPUS < (1U << 14)
+#define _Q_PENDING_BITS		8
+#else
 #define _Q_PENDING_BITS		1
+#endif
 #define _Q_PENDING_MASK		(((1U << _Q_PENDING_BITS) - 1) << _Q_PENDING_OFFSET)
 
 #define _Q_TAIL_IDX_OFFSET	(_Q_PENDING_OFFSET + _Q_PENDING_BITS)
@@ -59,6 +63,7 @@ typedef struct qspinlock {
 #define _Q_TAIL_CPU_BITS	(32 - _Q_TAIL_CPU_OFFSET)
 #define _Q_TAIL_CPU_MASK	(((1U << _Q_TAIL_CPU_BITS) - 1) << _Q_TAIL_CPU_OFFSET)
 
+#define _Q_TAIL_OFFSET		_Q_TAIL_IDX_OFFSET
 #define _Q_TAIL_MASK		(_Q_TAIL_IDX_MASK | _Q_TAIL_CPU_MASK)
 
 #define _Q_LOCKED_VAL		(1U << _Q_LOCKED_OFFSET)
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -114,6 +114,89 @@ try_set_pending(struct qspinlock *lock,
 	return 1;
 }
 
+#if _Q_PENDING_BITS == 8
+
+struct __qspinlock {
+	union {
+		atomic_t val;
+		struct {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+			u8	locked;
+			u8	pending;
+			u16	tail;
+#else
+			u16	tail;
+			u8	pending;
+			u8	locked;
+#endif
+		};
+	};
+};
+
+/*
+ * take ownership and clear the pending bit.
+ *
+ * *,1,0 -> *,0,1
+ */
+static int __always_inline
+try_clear_pending_set_locked(struct qspinlock *lock, u32 val)
+{
+	struct __qspinlock *l = (void *)lock;
+
+	ACCESS_ONCE(l->locked) = 1;
+	/*
+	 * we must order the stores of locked and pending such that the
+	 * (locked,pending) tuple never observably becomes 0.
+	 *
+	 * 'matched' by the queue wait loop.
+	 */
+	smp_wmb();
+	ACCESS_ONCE(l->pending) = 0;
+
+	return 1;
+}
+
+/*
+ * xchg(lock, tail)
+ *
+ * p,*,* -> n,*,* ; prev = xchg(lock, node)
+ */
+static u32 __always_inline
+xchg_tail(struct qspinlock *lock, u32 tail)
+{
+	struct __qspinlock *l = (void *)lock;
+
+	return (u32)xchg(&l->tail, tail >> _Q_TAIL_OFFSET) << _Q_TAIL_OFFSET;
+}
+
+#else
+
+/*
+ * take ownership and clear the pending bit.
+ *
+ * *,1,0 -> *,0,1
+ */
+static int __always_inline
+try_clear_pending_set_locked(struct qspinlock *lock, u32 val)
+{
+	u32 new, old;
+
+	for (;;) {
+		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		if (unlikely(old & _Q_LOCKED_MASK))
+			return 0;
+
+		val = old;
+	}
+
+	return 1;
+}
+
 /*
  * xchg(lock, tail)
  *
@@ -158,6 +241,8 @@ xchg_tail(struct qspinlock *lock, u32 ta
 	return old; /* tail bits are still fine */
 }
 
+#endif /* _Q_PENDING_BITS == 8 */
+
 #define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
 
 /**
@@ -199,9 +284,14 @@ void queue_spin_lock_slowpath(struct qsp
 	 * we're pending, wait for the owner to go away.
 	 *
 	 * *,1,1 -> *,1,0
+	 *
+	 * this wait loop must be a load-acquire such that we match the
+	 * store-release that clears the locked bit and create lock
+	 * sequentiality; this because not all try_clear_pending_set_locked()
+	 * implementations imply full barriers.
 	 */
 retry_pending_wait:
-	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
+	while ((val = smp_load_acquire(&lock->val.counter)) & _Q_LOCKED_MASK)
 		cpu_relax();
 
 	/*
@@ -209,18 +299,9 @@ void queue_spin_lock_slowpath(struct qsp
 	 *
 	 * *,1,0 -> *,0,1
 	 */
-	for (;;) {
-		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
-
-		old = atomic_cmpxchg(&lock->val, val, new);
-		if (old == val)
-			break;
+	if (!try_clear_pending_set_locked(lock, val))
+		goto retry_pending_wait;
 
-		if (unlikely(old & _Q_LOCKED_MASK))
-			goto retry_pending_wait;
-
-		val = old;
-	}
 	return;
 
 queue:


