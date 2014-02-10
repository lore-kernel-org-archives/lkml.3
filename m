Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaBJUmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:42:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35713 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBJUlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:41:31 -0500
Message-Id: <20140210203659.400473390@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 10 Feb 2014 20:58:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, akpm@linux-foundation.org,
        davidlohr@hp.com, hpa@zytor.com, andi@firstfloor.org, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: [PATCH 1/8] locking: Move mcs_spinlock.h into kernel/locking/
References: <20140210195820.834693028@infradead.org>
Content-Disposition: inline; filename=move-mcs_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mcs_spinlock code is not meant (or suitable) as a generic locking
primitive, therefore take it away from the normal includes and place
it in kernel/locking/.

This way the locking primitives implemented there can use it as part
of their implementation but we do not risk it getting used
inapropriately.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/mcs_spinlock.h  |  114 ------------------------------------------
 kernel/locking/mcs_spinlock.h |  114 ++++++++++++++++++++++++++++++++++++++++++
 kernel/locking/mutex.c        |    2 
 3 files changed, 115 insertions(+), 115 deletions(-)

--- a/include/linux/mcs_spinlock.h
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * MCS lock defines
- *
- * This file contains the main data structure and API definitions of MCS lock.
- *
- * The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spin-lock
- * with the desirable properties of being fair, and with each cpu trying
- * to acquire the lock spinning on a local variable.
- * It avoids expensive cache bouncings that common test-and-set spin-lock
- * implementations incur.
- */
-#ifndef __LINUX_MCS_SPINLOCK_H
-#define __LINUX_MCS_SPINLOCK_H
-
-#include <asm/mcs_spinlock.h>
-
-struct mcs_spinlock {
-	struct mcs_spinlock *next;
-	int locked; /* 1 if lock acquired */
-};
-
-#ifndef arch_mcs_spin_lock_contended
-/*
- * Using smp_load_acquire() provides a memory barrier that ensures
- * subsequent operations happen after the lock is acquired.
- */
-#define arch_mcs_spin_lock_contended(l)					\
-do {									\
-	while (!(smp_load_acquire(l)))					\
-		arch_mutex_cpu_relax();					\
-} while (0)
-#endif
-
-#ifndef arch_mcs_spin_unlock_contended
-/*
- * smp_store_release() provides a memory barrier to ensure all
- * operations in the critical section has been completed before
- * unlocking.
- */
-#define arch_mcs_spin_unlock_contended(l)				\
-	smp_store_release((l), 1)
-#endif
-
-/*
- * Note: the smp_load_acquire/smp_store_release pair is not
- * sufficient to form a full memory barrier across
- * cpus for many architectures (except x86) for mcs_unlock and mcs_lock.
- * For applications that need a full barrier across multiple cpus
- * with mcs_unlock and mcs_lock pair, smp_mb__after_unlock_lock() should be
- * used after mcs_lock.
- */
-
-/*
- * In order to acquire the lock, the caller should declare a local node and
- * pass a reference of the node to this function in addition to the lock.
- * If the lock has already been acquired, then this will proceed to spin
- * on this node->locked until the previous lock holder sets the node->locked
- * in mcs_spin_unlock().
- *
- * We don't inline mcs_spin_lock() so that perf can correctly account for the
- * time spent in this lock function.
- */
-static inline
-void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
-{
-	struct mcs_spinlock *prev;
-
-	/* Init node */
-	node->locked = 0;
-	node->next   = NULL;
-
-	prev = xchg(lock, node);
-	if (likely(prev == NULL)) {
-		/*
-		 * Lock acquired, don't need to set node->locked to 1. Threads
-		 * only spin on its own node->locked value for lock acquisition.
-		 * However, since this thread can immediately acquire the lock
-		 * and does not proceed to spin on its own node->locked, this
-		 * value won't be used. If a debug mode is needed to
-		 * audit lock status, then set node->locked value here.
-		 */
-		return;
-	}
-	ACCESS_ONCE(prev->next) = node;
-
-	/* Wait until the lock holder passes the lock down. */
-	arch_mcs_spin_lock_contended(&node->locked);
-}
-
-/*
- * Releases the lock. The caller should pass in the corresponding node that
- * was used to acquire the lock.
- */
-static inline
-void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
-{
-	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
-
-	if (likely(!next)) {
-		/*
-		 * Release the lock by setting it to NULL
-		 */
-		if (likely(cmpxchg(lock, node, NULL) == node))
-			return;
-		/* Wait until the next pointer is set */
-		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
-	}
-
-	/* Pass lock to next waiter. */
-	arch_mcs_spin_unlock_contended(&next->locked);
-}
-
-#endif /* __LINUX_MCS_SPINLOCK_H */
--- /dev/null
+++ b/kernel/locking/mcs_spinlock.h
@@ -0,0 +1,114 @@
+/*
+ * MCS lock defines
+ *
+ * This file contains the main data structure and API definitions of MCS lock.
+ *
+ * The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spin-lock
+ * with the desirable properties of being fair, and with each cpu trying
+ * to acquire the lock spinning on a local variable.
+ * It avoids expensive cache bouncings that common test-and-set spin-lock
+ * implementations incur.
+ */
+#ifndef __LINUX_MCS_SPINLOCK_H
+#define __LINUX_MCS_SPINLOCK_H
+
+#include <asm/mcs_spinlock.h>
+
+struct mcs_spinlock {
+	struct mcs_spinlock *next;
+	int locked; /* 1 if lock acquired */
+};
+
+#ifndef arch_mcs_spin_lock_contended
+/*
+ * Using smp_load_acquire() provides a memory barrier that ensures
+ * subsequent operations happen after the lock is acquired.
+ */
+#define arch_mcs_spin_lock_contended(l)					\
+do {									\
+	while (!(smp_load_acquire(l)))					\
+		arch_mutex_cpu_relax();					\
+} while (0)
+#endif
+
+#ifndef arch_mcs_spin_unlock_contended
+/*
+ * smp_store_release() provides a memory barrier to ensure all
+ * operations in the critical section has been completed before
+ * unlocking.
+ */
+#define arch_mcs_spin_unlock_contended(l)				\
+	smp_store_release((l), 1)
+#endif
+
+/*
+ * Note: the smp_load_acquire/smp_store_release pair is not
+ * sufficient to form a full memory barrier across
+ * cpus for many architectures (except x86) for mcs_unlock and mcs_lock.
+ * For applications that need a full barrier across multiple cpus
+ * with mcs_unlock and mcs_lock pair, smp_mb__after_unlock_lock() should be
+ * used after mcs_lock.
+ */
+
+/*
+ * In order to acquire the lock, the caller should declare a local node and
+ * pass a reference of the node to this function in addition to the lock.
+ * If the lock has already been acquired, then this will proceed to spin
+ * on this node->locked until the previous lock holder sets the node->locked
+ * in mcs_spin_unlock().
+ *
+ * We don't inline mcs_spin_lock() so that perf can correctly account for the
+ * time spent in this lock function.
+ */
+static inline
+void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+{
+	struct mcs_spinlock *prev;
+
+	/* Init node */
+	node->locked = 0;
+	node->next   = NULL;
+
+	prev = xchg(lock, node);
+	if (likely(prev == NULL)) {
+		/*
+		 * Lock acquired, don't need to set node->locked to 1. Threads
+		 * only spin on its own node->locked value for lock acquisition.
+		 * However, since this thread can immediately acquire the lock
+		 * and does not proceed to spin on its own node->locked, this
+		 * value won't be used. If a debug mode is needed to
+		 * audit lock status, then set node->locked value here.
+		 */
+		return;
+	}
+	ACCESS_ONCE(prev->next) = node;
+
+	/* Wait until the lock holder passes the lock down. */
+	arch_mcs_spin_lock_contended(&node->locked);
+}
+
+/*
+ * Releases the lock. The caller should pass in the corresponding node that
+ * was used to acquire the lock.
+ */
+static inline
+void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+{
+	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
+
+	if (likely(!next)) {
+		/*
+		 * Release the lock by setting it to NULL
+		 */
+		if (likely(cmpxchg(lock, node, NULL) == node))
+			return;
+		/* Wait until the next pointer is set */
+		while (!(next = ACCESS_ONCE(node->next)))
+			arch_mutex_cpu_relax();
+	}
+
+	/* Pass lock to next waiter. */
+	arch_mcs_spin_unlock_contended(&next->locked);
+}
+
+#endif /* __LINUX_MCS_SPINLOCK_H */
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -25,7 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
-#include <linux/mcs_spinlock.h>
+#include "mcs_spinlock.h"
 
 /*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,


