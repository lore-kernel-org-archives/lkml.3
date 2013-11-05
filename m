Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3KEMZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:25:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55920 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab3KEMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:23:42 -0500
Message-Id: <20131105110027.441118795@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Nov 2013 13:10:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, rostedt@goodmis.org,
        airlied@gmail.com, maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC 8/8] locking: Move percpu-rwsem into kernel/locking/
References: <20131105105244.666320103@infradead.org>
Content-Disposition: inline; filename=peterz-move-locking-percpu-rwsem.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: oleg@redhat.com
Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/locking/Makefile       |    3 
 kernel/locking/percpu-rwsem.c |  165 ++++++++++++++++++++++++++++++++++++++++++
 lib/Makefile                  |    1 
 lib/percpu-rwsem.c            |  165 ------------------------------------------
 4 files changed, 167 insertions(+), 167 deletions(-)

--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -21,4 +21,5 @@ obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
\ No newline at end of file
+obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
+obj-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
--- /dev/null
+++ b/kernel/locking/percpu-rwsem.c
@@ -0,0 +1,165 @@
+#include <linux/atomic.h>
+#include <linux/rwsem.h>
+#include <linux/percpu.h>
+#include <linux/wait.h>
+#include <linux/lockdep.h>
+#include <linux/percpu-rwsem.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+
+int __percpu_init_rwsem(struct percpu_rw_semaphore *brw,
+			const char *name, struct lock_class_key *rwsem_key)
+{
+	brw->fast_read_ctr = alloc_percpu(int);
+	if (unlikely(!brw->fast_read_ctr))
+		return -ENOMEM;
+
+	/* ->rw_sem represents the whole percpu_rw_semaphore for lockdep */
+	__init_rwsem(&brw->rw_sem, name, rwsem_key);
+	atomic_set(&brw->write_ctr, 0);
+	atomic_set(&brw->slow_read_ctr, 0);
+	init_waitqueue_head(&brw->write_waitq);
+	return 0;
+}
+
+void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
+{
+	free_percpu(brw->fast_read_ctr);
+	brw->fast_read_ctr = NULL; /* catch use after free bugs */
+}
+
+/*
+ * This is the fast-path for down_read/up_read, it only needs to ensure
+ * there is no pending writer (atomic_read(write_ctr) == 0) and inc/dec the
+ * fast per-cpu counter. The writer uses synchronize_sched_expedited() to
+ * serialize with the preempt-disabled section below.
+ *
+ * The nontrivial part is that we should guarantee acquire/release semantics
+ * in case when
+ *
+ *	R_W: down_write() comes after up_read(), the writer should see all
+ *	     changes done by the reader
+ * or
+ *	W_R: down_read() comes after up_write(), the reader should see all
+ *	     changes done by the writer
+ *
+ * If this helper fails the callers rely on the normal rw_semaphore and
+ * atomic_dec_and_test(), so in this case we have the necessary barriers.
+ *
+ * But if it succeeds we do not have any barriers, atomic_read(write_ctr) or
+ * __this_cpu_add() below can be reordered with any LOAD/STORE done by the
+ * reader inside the critical section. See the comments in down_write and
+ * up_write below.
+ */
+static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int val)
+{
+	bool success = false;
+
+	preempt_disable();
+	if (likely(!atomic_read(&brw->write_ctr))) {
+		__this_cpu_add(*brw->fast_read_ctr, val);
+		success = true;
+	}
+	preempt_enable();
+
+	return success;
+}
+
+/*
+ * Like the normal down_read() this is not recursive, the writer can
+ * come after the first percpu_down_read() and create the deadlock.
+ *
+ * Note: returns with lock_is_held(brw->rw_sem) == T for lockdep,
+ * percpu_up_read() does rwsem_release(). This pairs with the usage
+ * of ->rw_sem in percpu_down/up_write().
+ */
+void percpu_down_read(struct percpu_rw_semaphore *brw)
+{
+	might_sleep();
+	if (likely(update_fast_ctr(brw, +1))) {
+		rwsem_acquire_read(&brw->rw_sem.dep_map, 0, 0, _RET_IP_);
+		return;
+	}
+
+	down_read(&brw->rw_sem);
+	atomic_inc(&brw->slow_read_ctr);
+	/* avoid up_read()->rwsem_release() */
+	__up_read(&brw->rw_sem);
+}
+
+void percpu_up_read(struct percpu_rw_semaphore *brw)
+{
+	rwsem_release(&brw->rw_sem.dep_map, 1, _RET_IP_);
+
+	if (likely(update_fast_ctr(brw, -1)))
+		return;
+
+	/* false-positive is possible but harmless */
+	if (atomic_dec_and_test(&brw->slow_read_ctr))
+		wake_up_all(&brw->write_waitq);
+}
+
+static int clear_fast_ctr(struct percpu_rw_semaphore *brw)
+{
+	unsigned int sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		sum += per_cpu(*brw->fast_read_ctr, cpu);
+		per_cpu(*brw->fast_read_ctr, cpu) = 0;
+	}
+
+	return sum;
+}
+
+/*
+ * A writer increments ->write_ctr to force the readers to switch to the
+ * slow mode, note the atomic_read() check in update_fast_ctr().
+ *
+ * After that the readers can only inc/dec the slow ->slow_read_ctr counter,
+ * ->fast_read_ctr is stable. Once the writer moves its sum into the slow
+ * counter it represents the number of active readers.
+ *
+ * Finally the writer takes ->rw_sem for writing and blocks the new readers,
+ * then waits until the slow counter becomes zero.
+ */
+void percpu_down_write(struct percpu_rw_semaphore *brw)
+{
+	/* tell update_fast_ctr() there is a pending writer */
+	atomic_inc(&brw->write_ctr);
+	/*
+	 * 1. Ensures that write_ctr != 0 is visible to any down_read/up_read
+	 *    so that update_fast_ctr() can't succeed.
+	 *
+	 * 2. Ensures we see the result of every previous this_cpu_add() in
+	 *    update_fast_ctr().
+	 *
+	 * 3. Ensures that if any reader has exited its critical section via
+	 *    fast-path, it executes a full memory barrier before we return.
+	 *    See R_W case in the comment above update_fast_ctr().
+	 */
+	synchronize_sched_expedited();
+
+	/* exclude other writers, and block the new readers completely */
+	down_write(&brw->rw_sem);
+
+	/* nobody can use fast_read_ctr, move its sum into slow_read_ctr */
+	atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
+
+	/* wait for all readers to complete their percpu_up_read() */
+	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
+}
+
+void percpu_up_write(struct percpu_rw_semaphore *brw)
+{
+	/* release the lock, but the readers can't use the fast-path */
+	up_write(&brw->rw_sem);
+	/*
+	 * Insert the barrier before the next fast-path in down_read,
+	 * see W_R case in the comment above update_fast_ctr().
+	 */
+	synchronize_sched_expedited();
+	/* the last writer unblocks update_fast_ctr() */
+	atomic_dec(&brw->write_ctr);
+}
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -42,7 +42,6 @@ obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_i
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
-lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
--- a/lib/percpu-rwsem.c
+++ /dev/null
@@ -1,165 +0,0 @@
-#include <linux/atomic.h>
-#include <linux/rwsem.h>
-#include <linux/percpu.h>
-#include <linux/wait.h>
-#include <linux/lockdep.h>
-#include <linux/percpu-rwsem.h>
-#include <linux/rcupdate.h>
-#include <linux/sched.h>
-#include <linux/errno.h>
-
-int __percpu_init_rwsem(struct percpu_rw_semaphore *brw,
-			const char *name, struct lock_class_key *rwsem_key)
-{
-	brw->fast_read_ctr = alloc_percpu(int);
-	if (unlikely(!brw->fast_read_ctr))
-		return -ENOMEM;
-
-	/* ->rw_sem represents the whole percpu_rw_semaphore for lockdep */
-	__init_rwsem(&brw->rw_sem, name, rwsem_key);
-	atomic_set(&brw->write_ctr, 0);
-	atomic_set(&brw->slow_read_ctr, 0);
-	init_waitqueue_head(&brw->write_waitq);
-	return 0;
-}
-
-void percpu_free_rwsem(struct percpu_rw_semaphore *brw)
-{
-	free_percpu(brw->fast_read_ctr);
-	brw->fast_read_ctr = NULL; /* catch use after free bugs */
-}
-
-/*
- * This is the fast-path for down_read/up_read, it only needs to ensure
- * there is no pending writer (atomic_read(write_ctr) == 0) and inc/dec the
- * fast per-cpu counter. The writer uses synchronize_sched_expedited() to
- * serialize with the preempt-disabled section below.
- *
- * The nontrivial part is that we should guarantee acquire/release semantics
- * in case when
- *
- *	R_W: down_write() comes after up_read(), the writer should see all
- *	     changes done by the reader
- * or
- *	W_R: down_read() comes after up_write(), the reader should see all
- *	     changes done by the writer
- *
- * If this helper fails the callers rely on the normal rw_semaphore and
- * atomic_dec_and_test(), so in this case we have the necessary barriers.
- *
- * But if it succeeds we do not have any barriers, atomic_read(write_ctr) or
- * __this_cpu_add() below can be reordered with any LOAD/STORE done by the
- * reader inside the critical section. See the comments in down_write and
- * up_write below.
- */
-static bool update_fast_ctr(struct percpu_rw_semaphore *brw, unsigned int val)
-{
-	bool success = false;
-
-	preempt_disable();
-	if (likely(!atomic_read(&brw->write_ctr))) {
-		__this_cpu_add(*brw->fast_read_ctr, val);
-		success = true;
-	}
-	preempt_enable();
-
-	return success;
-}
-
-/*
- * Like the normal down_read() this is not recursive, the writer can
- * come after the first percpu_down_read() and create the deadlock.
- *
- * Note: returns with lock_is_held(brw->rw_sem) == T for lockdep,
- * percpu_up_read() does rwsem_release(). This pairs with the usage
- * of ->rw_sem in percpu_down/up_write().
- */
-void percpu_down_read(struct percpu_rw_semaphore *brw)
-{
-	might_sleep();
-	if (likely(update_fast_ctr(brw, +1))) {
-		rwsem_acquire_read(&brw->rw_sem.dep_map, 0, 0, _RET_IP_);
-		return;
-	}
-
-	down_read(&brw->rw_sem);
-	atomic_inc(&brw->slow_read_ctr);
-	/* avoid up_read()->rwsem_release() */
-	__up_read(&brw->rw_sem);
-}
-
-void percpu_up_read(struct percpu_rw_semaphore *brw)
-{
-	rwsem_release(&brw->rw_sem.dep_map, 1, _RET_IP_);
-
-	if (likely(update_fast_ctr(brw, -1)))
-		return;
-
-	/* false-positive is possible but harmless */
-	if (atomic_dec_and_test(&brw->slow_read_ctr))
-		wake_up_all(&brw->write_waitq);
-}
-
-static int clear_fast_ctr(struct percpu_rw_semaphore *brw)
-{
-	unsigned int sum = 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		sum += per_cpu(*brw->fast_read_ctr, cpu);
-		per_cpu(*brw->fast_read_ctr, cpu) = 0;
-	}
-
-	return sum;
-}
-
-/*
- * A writer increments ->write_ctr to force the readers to switch to the
- * slow mode, note the atomic_read() check in update_fast_ctr().
- *
- * After that the readers can only inc/dec the slow ->slow_read_ctr counter,
- * ->fast_read_ctr is stable. Once the writer moves its sum into the slow
- * counter it represents the number of active readers.
- *
- * Finally the writer takes ->rw_sem for writing and blocks the new readers,
- * then waits until the slow counter becomes zero.
- */
-void percpu_down_write(struct percpu_rw_semaphore *brw)
-{
-	/* tell update_fast_ctr() there is a pending writer */
-	atomic_inc(&brw->write_ctr);
-	/*
-	 * 1. Ensures that write_ctr != 0 is visible to any down_read/up_read
-	 *    so that update_fast_ctr() can't succeed.
-	 *
-	 * 2. Ensures we see the result of every previous this_cpu_add() in
-	 *    update_fast_ctr().
-	 *
-	 * 3. Ensures that if any reader has exited its critical section via
-	 *    fast-path, it executes a full memory barrier before we return.
-	 *    See R_W case in the comment above update_fast_ctr().
-	 */
-	synchronize_sched_expedited();
-
-	/* exclude other writers, and block the new readers completely */
-	down_write(&brw->rw_sem);
-
-	/* nobody can use fast_read_ctr, move its sum into slow_read_ctr */
-	atomic_add(clear_fast_ctr(brw), &brw->slow_read_ctr);
-
-	/* wait for all readers to complete their percpu_up_read() */
-	wait_event(brw->write_waitq, !atomic_read(&brw->slow_read_ctr));
-}
-
-void percpu_up_write(struct percpu_rw_semaphore *brw)
-{
-	/* release the lock, but the readers can't use the fast-path */
-	up_write(&brw->rw_sem);
-	/*
-	 * Insert the barrier before the next fast-path in down_read,
-	 * see W_R case in the comment above update_fast_ctr().
-	 */
-	synchronize_sched_expedited();
-	/* the last writer unblocks update_fast_ctr() */
-	atomic_dec(&brw->write_ctr);
-}


