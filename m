Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbaHLS5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:57:37 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58281 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbaHLS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:57:34 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 1/4] kactive: introduce generic "active"-refcounts
Date: Tue, 12 Aug 2014 20:54:05 +0200
Message-Id: <1407869648-1449-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
References: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a new reference-type "struct kactive". Unlike kref, this
type manages "active references". That means, references can only be
acquired if the object is active. At any time the object can be
deactivated, causing any new attempt to acquire an active reference to
fail. Furthermore, after disabling an object, you can wait for all active
references to be dropped. This allows synchronous object removal without
dangling _active_ objects.

This obivously does NOT replace the usual ref-count. Moreover, it is meant
to be used in combination with normal ref-counts. This way, you can get
active references and normal references to the object.

Active references are usually required for callbacks. That is, if an
object has callbacks that can be entered by user-space, you usually want
an active reference to the object as long as you are _inside_ the
callback. This way the object cannot be removed while you work on it.
Normal references, on the other hand, are required by the underlying
file/device to make sure the object with its callback-pointer can be
accessed at all.

kernfs implements an active-reference type with spin-locks. This patch is
very loosely based on kernfs but avoids spin-locks.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 include/linux/kactive.h | 269 +++++++++++++++++++++++++++++++++++++++++
 lib/Makefile            |   2 +-
 lib/kactive.c           | 312 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 582 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kactive.h
 create mode 100644 lib/kactive.c

diff --git a/include/linux/kactive.h b/include/linux/kactive.h
new file mode 100644
index 0000000..e8fca7e
--- /dev/null
+++ b/include/linux/kactive.h
@@ -0,0 +1,269 @@
+/*
+ * kactive - library routines for handling active counters on objects that can
+ *           be revoked at any time
+ *
+ * Copyright (C) 2014 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _KACTIVE_H_
+#define _KACTIVE_H_
+
+#include <linux/atomic.h>
+#include <linux/bug.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+/**
+ * struct kactive - Counting active object users
+ * @count: internal state-tracking
+ *
+ * "kactive" counts active users on arbitrary objects. For each user currently
+ * accessing the object, an internal counter is increased. However, unlike
+ * reference-counts, kactive allows to disable objects so no new references can
+ * be acquired. Once disabled, you can wait for the counter to drop to zero,
+ * thus, waiting until all users are gone (called 'draining').
+ *
+ * All paths that operate on an object and require it to be active, have to use
+ * kactive_get() to acquire an active reference, and kactive_put() to drop it
+ * again. Unlike kref_get(), kactive_get() might fail, in which case the caller
+ * must bail out. Furthermore, an active reference should be dropped as soon as
+ * possible. If it is claimed for an undefinite period, you must integrate it
+ * into a wait-queue and pass it to kactive. Otherwise, draining a kactive
+ * counter will stall.
+ * You're strongly recommended to drop active references before stalling for an
+ * undefinite period and trying to reacquire them afterwards.
+ *
+ * A kactive counter will undergo the following states (in this order):
+ *  - NEW: First, a counter has to be initialized via kactive_init(). The object
+ *         may not be accessed before it is initialized. kactive_is_new()
+ *         returns true iff the counter is in this state. While in this state
+ *         no references can be acquired.
+ *    test: kactive_is_new()
+ *  - ENABLED: Once a counter is enabled via kactive_enable(), the counter is
+ *             alive and references can be acquired. kactive_is_enabled()
+ *             returns true iff the counter is in this state.
+ *             This state may be skipped if kactive_disable() is called before
+ *             kactive_enable().
+ *    test: kactive_is_enabled()
+ *  - DRAINING: Once a counter is disabled via kactive_disable() no new
+ *              references can be acquired. However, there might still be
+ *              pending references that haven't been dropped. If so, the counter
+ *              is put into the DRAINING state until all those references are
+ *              dropped.
+ *    test: kactive_is_draining()
+ *  - SELF_DRAINING: This is the same state as DRAINING, but is entered after
+ *                   the first call to kactive_drain_self() returned. All
+ *                   remaining refs are now hold by callers of
+ *                   kactive_drain_self(). If kactive_drain_self() is never
+ *                   called, this state may be skipped.
+ *                   In the public API, this state is treated the same as
+ *                   DRAINING and kactive_is_draining() returns true if in this
+ *                   state.
+ *    test: __kactive_is_self_draining()
+ *  - DRAINED: Once a counter was disabled via kactive_disable() and there are
+ *             no more active references, the counter will become DRAINED. It
+ *             will stay in this state until it is destroyed.
+ *    test: kactive_is_drained()
+ *
+ * Both kactive_disable() and kactive_put() can cause a transition to state
+ * DRAINED. In that case, the caller might want to perform cleanups on the
+ * object before doing the transition. Therefore, both functions take a
+ * callback to run before the final transition is done.
+ *
+ * Calling kactive_drain() waits until all active references have been dropped.
+ * Obviously, you must have called kactive_disable() beforehand, otherwise this
+ * might sleep for an indefinite period. Furthermore, kactive_drain() must be
+ * called without any active reference held. You can use kactive_drain_self()
+ * to avoid this restriction and drain all users but yourself. This requires an
+ * additional atomic_t counter, though. It has to be shared across all users of
+ * kactive_drain_self() on that kactive counter.
+ *
+ * If you plan on using kactive_drain() or kactive_drain_self(), the kactive
+ * counter needs a wait-queue to wait on. As draining is supposed to be called
+ * scarcely, the kactive counter does not include its own wait-queue. Instead,
+ * you have to pass a wait-queue pointer to all functions releasing references
+ * or draining the counter.
+ * When draining the wait-queue, the task will wait as TASK_NORMAL on the
+ * wait-queue until the object is drained. Therefore, any call that releases
+ * references wakes up all waiting tasks in state TASK_NORMAL. If that's
+ * incompatible with your wait-queue, you must provide a separate one for the
+ * kactive counter. Note that wake-ups only happen when the last (or second to
+ * last, to support self-draining) reference is dropped. Hence, the wait-queue
+ * of each kactive counter is woken up twice tops.
+ *
+ * The internal counter can be in one of the following states:
+ *   [0, +inf]
+ *      Counter is enabled and counts active refs
+ *   [__KACTIVE_BIAS + 1, -1]
+ *      Counter is draining and counts active refs
+ *   {__KACTIVE_BIAS}
+ *      Counter is draining and there's only a single ref left. It has already
+ *      been dropped but the last user performs cleanups before the counter is
+ *      marked as drained.
+ *   [__KACTIVE_BIAS * 2 + 1, __KACTIVE_BIAS - 1]
+ *      Counter was drained via kactive_drain_self() before and now counts the
+ *      remaining refs of all tasks that drained the counter while holding refs
+ *      themselves.
+ *   {__KACTIVE_BIAS * 2}
+ *      Counter was drained via kactive_drain_self() before and only a single
+ *      remaining ref is left. It has already been dropped, but the last user
+ *      performs cleanups before the counter is marked as drained.
+ *   {__KACTIVE_BIAS * 2 - 1}
+ *      Counter is drained.
+ *   {__KACTIVE_BIAS * 2 - 2}
+ *      Initial state of the counter.
+ */
+struct kactive {
+	atomic_t count;
+};
+
+typedef void (*kactive_release_t) (struct kactive *kactive);
+
+#define __KACTIVE_BIAS			(INT_MIN / 2 + 2)
+#define __KACTIVE_NEW			(__KACTIVE_BIAS * 2 - 2)
+#define __KACTIVE_DRAINED		(__KACTIVE_BIAS * 2 - 1)
+
+/**
+ * kactive_init() - Initialize kactive counter
+ * @kactive: kactive counter to modify
+ *
+ * This initializes a kactive counter. You should call this on any counter
+ * before accessing it via kactive_*() calls. If you don't call this, you must
+ * initialize the memory to 0 and it will behave as if you called:
+ *         kactive_init(&kactive);
+ *         kactive_enable(&kactive);
+ *
+ * Once this call returns the counter is in state NEW. You may call
+ * kactive_enable() to enable the counter, or kactive_disable() to immediately
+ * disable the counter.
+ *
+ * There is no allocated memory on a counter so you can destroy it at any time
+ * as long as you make sure no-one else can access it, anymore. Furthermore,
+ * you can call kactive_init() (or clear the memory) at any time to reset the
+ * counter. This, however, will cause undefined behavior if there are other
+ * tasks that may access the counter in parallel.
+ */
+static inline void kactive_init(struct kactive *kactive)
+{
+	atomic_set(&kactive->count, __KACTIVE_NEW);
+}
+
+/* true if @kactive is in state NEW */
+static inline bool kactive_is_new(struct kactive *kactive)
+{
+	return atomic_read(&kactive->count) == __KACTIVE_NEW;
+}
+
+/* true if @kactive is in state ENABLED */
+static inline bool kactive_is_enabled(struct kactive *kactive)
+{
+	return atomic_read(&kactive->count) >= 0;
+}
+
+/* true if @kactive is DRAINING or DRAINED */
+static inline bool kactive_is_disabled(struct kactive *kactive)
+{
+	int v = atomic_read(&kactive->count);
+	return v > __KACTIVE_NEW && v < 0;
+}
+
+/* true if @kactive is in state DRAINING or SELF_DRAINING */
+static inline bool kactive_is_draining(struct kactive *kactive)
+{
+	int v = atomic_read(&kactive->count);
+	return v > __KACTIVE_DRAINED && v < 0;
+}
+
+/* true if @kactive is in state DRAINED */
+static inline bool kactive_is_drained(struct kactive *kactive)
+{
+	return atomic_read(&kactive->count) == __KACTIVE_DRAINED;
+}
+
+/**
+ * kactive_get() - Acquire active reference
+ * @kactive: kactive counter to modify or NULL
+ *
+ * This tries to acquire a new active reference on @kactive. If @kactive wasn't
+ * enabled, yet, or if it was already disabled, this will return false.
+ * Otherwise, the active-counter of @kactive is increased and this will return
+ * true. You can release this reference via kactive_put() again.
+ *
+ * If @kactive is NULL, this is a no-op and will always return false.
+ *
+ * It is safe to nest multiple calls to kactive_get(). However, kactive_get()
+ * might fail regardless whether you already own a reference or not.
+ *
+ * Returns: If an active reference was acquired, true is returned. Otherwise,
+ *          this returns false.
+ */
+static inline bool kactive_get(struct kactive *kactive)
+{
+	if (unlikely(!kactive))
+		return false;
+
+	return atomic_inc_unless_negative(&kactive->count);
+}
+
+/* slow-path of kactive_put() */
+bool __kactive_release(struct kactive *kactive,
+		       wait_queue_head_t *waitq,
+		       kactive_release_t release,
+		       int v);
+
+/**
+ * kactive_put() - Release active reference
+ * @kactive: kactive counter to modify or NULL
+ * @waitq: wait queue to wake up if counter dropped to zero
+ * @release: release-function to call before dropping the last ref, or NULL
+ *
+ * This drops an active reference previously acquired via kactive_get(). Iff
+ * this call dropped the last reference and the kactive counter is in state
+ * DRAINING, then @release is called (if not NULL) and the counter is marked as
+ * DRAINED.
+ *
+ * All waiters on @waitq are woken up if the kactive counter is in state
+ * DRAINING and this call dropped the last or second to last reference.
+ *
+ * If @kactive is NULL, this is a no-op.
+ *
+ * Returns: If this caused a transition to state DRAINED, true is returned.
+ *          Otherwise, this call returns false.
+ */
+static inline bool kactive_put(struct kactive *kactive,
+			       wait_queue_head_t *waitq,
+			       kactive_release_t release)
+{
+	int v;
+
+	if (unlikely(!kactive))
+		return false;
+
+	v = atomic_read(&kactive->count);
+	if (WARN_ON(v <= __KACTIVE_BIAS * 2 ||
+	            v == __KACTIVE_BIAS ||
+		    v == 0))
+		return false;
+
+	v = atomic_dec_return(&kactive->count);
+	if (v < 0)
+		return __kactive_release(kactive, waitq, release, v);
+
+	return false;
+}
+
+void kactive_drain(struct kactive *kactive, wait_queue_head_t *waitq);
+void kactive_drain_self(struct kactive *kactive,
+			wait_queue_head_t *waitq,
+			unsigned int refs_owned,
+			atomic_t *drain_counter);
+
+bool kactive_enable(struct kactive *kactive);
+bool kactive_disable(struct kactive *kactive,
+		     wait_queue_head_t *waitq,
+		     kactive_release_t release);
+
+#endif /* _KACTIVE_H_ */
diff --git a/lib/Makefile b/lib/Makefile
index d6b4bc4..ec7f6a0 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -20,7 +20,7 @@ lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
 lib-y	+= kobject.o klist.o
-obj-y	+= lockref.o
+obj-y	+= lockref.o kactive.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
diff --git a/lib/kactive.c b/lib/kactive.c
new file mode 100644
index 0000000..5029110
--- /dev/null
+++ b/lib/kactive.c
@@ -0,0 +1,312 @@
+/*
+ * kactive - library routines for handling active counters on objects that can
+ *           be revoked at any time
+ *
+ * Copyright (C) 2014 David Herrmann <dh.herrmann@gmail.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/atomic.h>
+#include <linux/bug.h>
+#include <linux/export.h>
+#include <linux/kactive.h>
+#include <linux/kernel.h>
+#include <linux/lockdep.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+
+/* true if @kactive is SELF_DRAINING */
+static inline bool __kactive_is_self_draining(struct kactive *kactive)
+{
+	int v = atomic_read(&kactive->count);
+	return v > __KACTIVE_DRAINED && v < __KACTIVE_BIAS;
+}
+
+/* true if @kactive is SELF_DRAINING or DRAINING with context-ref */
+static inline bool __kactive_is_almost_drained(struct kactive *kactive)
+{
+	int v = atomic_read(&kactive->count);
+	return v > __KACTIVE_DRAINED && v <= __KACTIVE_BIAS + 1;
+}
+
+/* atomically add @num to @kactive iff @kactive is greater than @cmp */
+static inline int __kactive_add_gt(struct kactive *kactive, int num, int cmp)
+{
+	int old, new;
+
+	do {
+		old = atomic_read(&kactive->count);
+		if (old <= cmp)
+			return old;
+		new = old + num;
+	} while (atomic_cmpxchg(&kactive->count, old, new) != old);
+
+	return old;
+}
+
+/* atomically add @num to @kactive iff @kactive is lower than @cmp */
+static inline int __kactive_add_lt(struct kactive *kactive, int num, int cmp)
+{
+	int old, new;
+
+	do {
+		old = atomic_read(&kactive->count);
+		if (old >= cmp)
+			return old;
+		new = old + num;
+	} while (atomic_cmpxchg(&kactive->count, old, new) != old);
+
+	return old;
+}
+
+bool __kactive_release(struct kactive *kactive,
+		       wait_queue_head_t *waitq,
+		       kactive_release_t release,
+		       int v)
+{
+	if (v == __KACTIVE_BIAS || v == __KACTIVE_BIAS * 2) {
+		if (release)
+			release(kactive);
+
+		/*
+		 * We allow freeing @kactive immediately after kactive_drain()
+		 * returns. So make sure release() is fully done before we
+		 * mark it as drained.
+		 */
+		mb();
+
+		atomic_set(&kactive->count, __KACTIVE_DRAINED);
+		wake_up_all(waitq);
+		return true;
+	} else if (v == __KACTIVE_BIAS + 1) {
+		/* wake up kactive_drain_self() with context-ref */
+		wake_up_all(waitq);
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(__kactive_release);
+
+/**
+ * kactive_drain() - Drain kactive counter
+ * @kactive: kactive counter to drain
+ * @waitq: wait queue to wait on
+ *
+ * This waits on the given kactive counter until all references were dropped.
+ * You must wake up any sleeping tasks that might hold active references before
+ * draining the kactive counter, otherwise this call might stall. Moreover, if
+ * this is called on an enabled counter it will stall until someone disables
+ * the counter.
+ *
+ * You must not hold any active references yourself when calling this! See
+ * kactive_drain_self() to avoid this restriction.
+ *
+ * Once this call returns, no active reference will exist, anymore.
+ *
+ * This call waits on @waitq in case there are active references. You must pass
+ * the same wait-queue to kactive_put() or wake up the queue manually to make
+ * sure all draining tasks are correctly notified.
+ *
+ * It is safe to call this function multiple times (even in parallel). All of
+ * those calls are guaranteed to sleep until there are no more active refs.
+ * This can even be called in parallel to kactive_drain_self(), it will wait
+ * until all references, including those held by callers to kactive_drain_self()
+ * are released.
+ */
+void kactive_drain(struct kactive *kactive, wait_queue_head_t *waitq)
+{
+	/*
+	 * When draining without holding active refs we simply wait
+	 * until the kactive counter drops to DRAINED.
+	 */
+	wait_event(*waitq, kactive_is_drained(kactive));
+}
+EXPORT_SYMBOL_GPL(kactive_drain);
+
+/**
+ * kactive_drain_self() - Drain kactive counter while holding active refs
+ * @kactive: kactive counter to drain
+ * @waitq: wait queue to wait on
+ * @refs_owned: number of active references owned by the caller
+ * @drain_counter: separate atomic counter to keep track of context refs
+ *
+ * This is similar to kactive_drain(), but allows the caller to hold active
+ * references themself. However, you must know how many references are hold
+ * by your call-stack and pass this as @refs_owned. Otherwise, this will
+ * dead-lock. Furthermore, a second atomic_t counter is needed to make this
+ * work. This counter has to be shared across all users of kactive_drain_self()
+ * on this kactive counter. It has to be initialized to 0 and passed as
+ * @drain_counter to this helper. No other kactive helpers need access to it.
+ *
+ * If @refs_owned is 0, this is equivalent to kactive_drain() and
+ * @drain_counter is not accessed (can be NULL). The following description
+ * assumes @refs_owned is greater than zero.
+ *
+ * When calling kactive_drain_self(), this blocks until all other references
+ * but the own are dropped. The kactive counter must have been disabled before
+ * this is called. Furthermore, any pending tasks that hold active refs must
+ * have been woken up. Otherwise, this might block indefinitely.
+ *
+ * If there are multiple parallel callers of kactive_drain_self(), they're
+ * treated equally. That means, all calls will block until all refs but the
+ * sum of their refs were dropped.
+ *
+ * If any caller of kactive_drain_self() calls this function a second time, it
+ * will immediately return as all remaining refs are guaranteed to be hold by a
+ * caller of kactive_drain_self().
+ * Once kactive_drain_self() returns, your remaining active references are
+ * still valid as usual.
+ */
+void kactive_drain_self(struct kactive *kactive,
+			wait_queue_head_t *waitq,
+			unsigned int refs_owned,
+			atomic_t *drain_counter)
+{
+	bool first;
+	int v;
+
+	if (refs_owned < 1) {
+		kactive_drain(kactive, waitq);
+		return;
+	}
+
+	/*
+	 * When draining while holding refs yourself, we drop the refs
+	 * and then drain the kactive counter. The first one to enter
+	 * kactive_drain_self() retains a context-ref to make sure
+	 * racing calls to kactive_put() don't free the object. Once
+	 * all but the context-ref are dropped, the first one to leave
+	 * performs a transition to SELF_DRAINING, acquires all refs of
+	 * all tasks inside kactive_drain_self() and then drops the
+	 * context-ref. This guarantees that no task leaving
+	 * kactive_drain_self() early can drop all remaining refs via
+	 * kactive_put().
+	 * Once the first task leaves kactive_drain_self(), we know all
+	 * other tasks with self-refs had to be inside
+	 * kactive_drain_self(), too, and must have dropped their local
+	 * refs. Otherwise, the counter would have never dropped to 1
+	 * and the task could not have left kactive_drain_self(). If a
+	 * task enters kactive_drain_self() a second time, their local
+	 * cache must already see that we're SELF_DRAINING and we can
+	 * exit early without waiting again.
+	 */
+
+	if (__kactive_is_self_draining(kactive))
+		return;
+
+	/*
+	 * At this point we know:
+	 *  - this task has never entered kactive_drain_self() before,
+	 *    otherwise the local view must show SELF_DRAINING
+	 *  - no-one else can have left kactive_drain_self() as we
+	 *    still hold refs and never dropped them
+	 * We might not be the first to enter kactive_drain_self() so
+	 * remember our ref-count in the shared counter.
+	 */
+
+	v = atomic_add_return(refs_owned, drain_counter);
+	first = (v == refs_owned);
+
+	/*
+	 * Make sure our refs are acoounted for in @drain_counter
+	 * before we drop them.
+	 */
+	smp_wmb();
+
+	/*
+	 * If we were the first to modify @drain_counter, acquire an
+	 * additional context-ref. Only one is allowed to do that,
+	 * otherwise kactive_put() might never wake us up as it has no
+	 * access to @drain_counter.
+	 * If someone passed us and enters wait_event() early, our own
+	 * refs serve as their context-ref until we acquire it.
+	 */
+	atomic_sub(refs_owned - first, &kactive->count);
+
+	wait_event(*waitq, __kactive_is_almost_drained(kactive));
+
+	/*
+	 * Make sure we read all context-references after wait_event()
+	 * read the kactive counter.
+	 */
+	smp_rmb();
+	v = atomic_read(drain_counter);
+
+	/*
+	 * The first one to leave has to do an atomic transition to
+	 * SELF_DRAINING while acquiring all @drain_counter refs and
+	 * dropping the context-ref.
+	 * All others to leave know that their refs have already been
+	 * safely reacquired.
+	 */
+	__kactive_add_gt(kactive,
+			 v + __KACTIVE_BIAS - 1,
+			 __KACTIVE_BIAS);
+}
+EXPORT_SYMBOL_GPL(kactive_drain_self);
+
+/**
+ * kactive_enable() - Enable kactive counter
+ * @kactive: kactive counter to enable
+ *
+ * This enables a kactive counter in case it wasn't already enabled. Note that
+ * if the counter was disabled via kactive_disable() before, it can never be
+ * enabled again.
+ *
+ * It is safe to call this multiple times (even in parallel). Any call but the
+ * first is a no-op.
+ *
+ * Returns: If the counter was not in state NEW, false is returned. Otherwise,
+ *          the counter is put into state ENABLED and true is returned.
+ */
+bool kactive_enable(struct kactive *kactive)
+{
+	/* try transition NEW=>ENABLED */
+	return __kactive_add_lt(kactive,
+				-__KACTIVE_NEW,
+				__KACTIVE_NEW + 1) <= __KACTIVE_NEW;
+}
+EXPORT_SYMBOL_GPL(kactive_enable);
+
+/**
+ * kactive_disable() - Disable kactive counter
+ * @kactive: kactive counter to disable
+ * @waitq: wait queue to wake up if counter dropped to zero
+ * @release: release-function to call before dropping the last ref, or NULL
+ *
+ * This disables a kactive counter. This works regardless of the state @kactive
+ * is in, even if it wasn't enabled, yet. A counter that was disabled can never
+ * be enabled again. Once this call returns, no new active references can be
+ * acquired.
+ *
+ * It is safe to call this multiple times (even in parallel). Any call but the
+ * first is a no-op.
+ *
+ * Iff this call causes a transition to state DRAINED, @release is called (if
+ * not NULL) before it is marked as DRAINED.
+ *
+ * Returns: If this call caused a transition into state DRAINED, this returns
+ *          true. Otherwise, false is returned.
+ */
+bool kactive_disable(struct kactive *kactive,
+		     wait_queue_head_t *waitq,
+		     kactive_release_t release)
+{
+	/*
+	 * First try direct transition from NEW=>DRAINING...
+	 * ...then it can never be NEW again, so try ENABLED=>DRAINING.
+	 */
+	if (__kactive_add_lt(kactive,
+			     2 - __KACTIVE_BIAS,
+			     __KACTIVE_NEW + 1) <= __KACTIVE_NEW)
+		return __kactive_release(kactive, waitq, release,
+					 __KACTIVE_BIAS);
+	else if (__kactive_add_gt(kactive, __KACTIVE_BIAS, -1) == 0)
+		return __kactive_release(kactive, waitq, release,
+					 __KACTIVE_BIAS);
+
+	/* someone else already disabled it, we didn't modify @kactive */
+	return false;
+}
+EXPORT_SYMBOL_GPL(kactive_disable);
-- 
2.0.4

