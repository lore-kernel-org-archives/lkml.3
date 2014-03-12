Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaCLPcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:32:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36239 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaCLPck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:32:40 -0400
Date: Wed, 12 Mar 2014 16:32:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, arnd@arndb.de, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        akpm@linux-foundation.org, walken@google.com, andi@firstfloor.org,
        riel@redhat.com, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, oleg@redhat.com
Subject: Re: [RFC][PATCH 0/7] locking: qspinlock
Message-ID: <20140312153215.GW3104@twins.programming.kicks-ass.net>
References: <20140310154236.038181843@infradead.org>
 <20140311104503.GA10916@gmail.com>
 <531FD1DA.5010006@hp.com>
 <20140312062436.GI30956@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312062436.GI30956@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 07:24:36AM +0100, Peter Zijlstra wrote:
> On Tue, Mar 11, 2014 at 11:17:46PM -0400, Waiman Long wrote:
> > Except that I do a single atomic short integer write to switch the bits
> > instead of 2 byte write.
> 
> D'0h why didn't I think of that. A single short write is much better
> than the 2 byte writes.

Here's a replacement patch that does the one short store.

---
Subject: qspinlock: Optimize for smaller NR_CPUS
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Mar 10 14:05:36 CET 2014

When we allow for a max NR_CPUS < 2^14 we can optimize the pending
wait-acquire and the xchg_tail() operations.

By growing the pending bit to a byte, we reduce the tail to 16bit.
This means we can use xchg16 for the tail part and do away with all
the trickyness of having to fix up the (pending,locked) state.

This in turn allows us to unconditionally acquire; the locked state as
observed by the wait loops cannot change. And because both locked and
pending are now a full byte we can use simple store for the state
transition, obviating one atomic operation entirely.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/asm-generic/qspinlock_types.h |    5 +
 kernel/locking/qspinlock.c            |   96 +++++++++++++++++++++++++++++-----
 2 files changed, 89 insertions(+), 12 deletions(-)

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
@@ -22,6 +22,7 @@
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
 #include <linux/mutex.h>
+#include <asm/byteorder.h>
 #include <asm/qspinlock.h>
 
 /*
@@ -114,6 +115,79 @@ try_set_pending(struct qspinlock *lock,
 	return 1;
 }
 
+#if _Q_PENDING_BITS == 8
+
+struct __qspinlock {
+	union {
+		atomic_t val;
+		struct {
+#ifdef __LITTLE_ENDIAN
+			u16	locked_pending;
+			u16	tail;
+#else
+			u16	tail;
+			u16	locked_pending;
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
+	ACCESS_ONCE(l->locked_pending) = __constant_le16_to_cpu(_Q_LOCKED_VAL);
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
@@ -158,6 +232,8 @@ xchg_tail(struct qspinlock *lock, u32 ta
 	return old; /* tail bits are still fine */
 }
 
+#endif /* _Q_PENDING_BITS == 8 */
+
 #define _Q_LOCKED_PENDING_MASK	(_Q_LOCKED_MASK | _Q_PENDING_MASK)
 
 /**
@@ -199,9 +275,14 @@ void queue_spin_lock_slowpath(struct qsp
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
@@ -209,18 +290,9 @@ void queue_spin_lock_slowpath(struct qsp
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
