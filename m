Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3D1Rwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 13:52:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40260 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab3D1Rwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 13:52:37 -0400
Subject: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Date: Sun, 28 Apr 2013 19:04:07 +0200
Message-ID: <20130428170407.17075.80082.stgit@patser>
In-Reply-To: <20130428165914.17075.57751.stgit@patser>
References: <20130428165914.17075.57751.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since RFC patch v1:
 - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
 - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
 - removed mutex_locked_set_reservation_id (or w/e it was called)
Changes since RFC patch v2:
 - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
   mutex_(,reserve_)lock/unlock.
Changes since v1:
 - Add __always_inline to __mutex_lock_common, otherwise reservation paths can be
   triggered from normal locks, because __builtin_constant_p might evaluate to false
   for the constant 0 in that case. Tests for this have been added in the next patch.
 - Updated documentation slightly.
Changes since v2:
 - Renamed everything to ww_mutex. (mlankhorst)
 - Added ww_acquire_ctx and ww_class. (mlankhorst)
 - Added a lot of checks for wrong api usage. (mlankhorst)
 - Documentation updates. (danvet)

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 Documentation/ww-mutex-design.txt |  322 +++++++++++++++++++++++++++
 include/linux/mutex-debug.h       |    1 
 include/linux/mutex.h             |  257 +++++++++++++++++++++
 kernel/mutex.c                    |  445 ++++++++++++++++++++++++++++++++++++-
 lib/debug_locks.c                 |    2 
 5 files changed, 1010 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/ww-mutex-design.txt

diff --git a/Documentation/ww-mutex-design.txt b/Documentation/ww-mutex-design.txt
new file mode 100644
index 0000000..154bae3
--- /dev/null
+++ b/Documentation/ww-mutex-design.txt
@@ -0,0 +1,322 @@
+Wait/Wound Deadlock-Proof Mutex Design
+======================================
+
+Please read mutex-design.txt first, as it applies to wait/wound mutexes too.
+
+Motivation for WW-Mutexes
+-------------------------
+
+GPU's do operations that commonly involve many buffers.  Those buffers
+can be shared across contexts/processes, exist in different memory
+domains (for example VRAM vs system memory), and so on.  And with
+PRIME / dmabuf, they can even be shared across devices.  So there are
+a handful of situations where the driver needs to wait for buffers to
+become ready.  If you think about this in terms of waiting on a buffer
+mutex for it to become available, this presents a problem because
+there is no way to guarantee that buffers appear in a execbuf/batch in
+the same order in all contexts.  That is directly under control of
+userspace, and a result of the sequence of GL calls that an application
+makes.	Which results in the potential for deadlock.  The problem gets
+more complex when you consider that the kernel may need to migrate the
+buffer(s) into VRAM before the GPU operates on the buffer(s), which
+may in turn require evicting some other buffers (and you don't want to
+evict other buffers which are already queued up to the GPU), but for a
+simplified understanding of the problem you can ignore this.
+
+The algorithm that TTM came up with for dealing with this problem is quite
+simple.  For each group of buffers (execbuf) that need to be locked, the caller
+would be assigned a unique reservation id/ticket, from a global counter.  In
+case of deadlock while locking all the buffers associated with a execbuf, the
+one with the lowest reservation ticket (i.e. the oldest task) wins, and the one
+with the higher reservation id (i.e. the younger task) unlocks all of the
+buffers that it has already locked, and then tries again.
+
+In the RDBMS literature this deadlock handling approach is called wait/wound:
+The older tasks waits until it can acquire the contended lock. The younger tasks
+needs to back off and drop all the locks it is currently holding, i.e. the
+younger task is wounded.
+
+Concepts
+--------
+
+Compared to normal mutexes two additional concepts/objects show up in the lock
+interface for w/w mutexes:
+
+Acquire context: To ensure eventual forward progress it is important the a task
+trying to acquire locks doesn't grab a new reservation id, but keeps the one it
+acquired when starting the lock acquisition. This ticket is stored in the
+acquire context. Furthermore the acquire context keeps track of debugging state
+to catch w/w mutex interface abuse.
+
+W/w class: In contrast to normal mutexes the lock class needs to be explicit for
+w/w mutexes, since it is required to initialize the acquire context.
+
+Furthermore there are three different classe of w/w lock acquire functions:
+- Normal lock acquisition with a context, using ww_mutex_lock
+- Slowpath lock acquisition on the contending lock, used by the wounded task
+  after having dropped all already acquired locks. These functions have the
+  _slow postfix.
+- Functions to only acquire a single w/w mutex, which results in the exact same
+  semantics as a normal mutex. These functions have the _single postfix.
+
+Of course, all the usual variants for handling wake-ups due to signals are also
+provided.
+
+Usage
+-----
+
+Three different ways to acquire locks within the same w/w class. Common
+definitions for methods 1&2.
+
+static DEFINE_WW_CLASS(ww_class);
+
+struct obj {
+	sct ww_mutex lock;
+	/* obj data */
+};
+
+struct obj_entry {
+	struct list_head *list;
+	struct obj *obj;
+};
+
+Method 1, using a list in execbuf->buffers that's not allowed to be reordered.
+This is useful if a list of required objects is already tracked somewhere.
+Furthermore the lock helper can use propagate the -EALREADY return code back to
+the caller as a signal that an object is twice on the list. This is useful if
+the list is constructed from userspace input and the ABI requires userspace to
+no have duplicate entries (e.g. for a gpu commandbuffer submission ioctl).
+
+int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj *res_obj = NULL;
+	struct obj_entry *contended_entry = NULL;
+	struct obj_entry *entry;
+
+	ww_acquire_init(ctx, &ww_class);
+
+retry:
+	list_for_each_entry (list, entry) {
+		if (entry == res_obj) {
+			res_obj = NULL;
+			continue;
+		}
+		ret = ww_mutex_lock(&entry->obj->lock, ctx);
+		if (ret < 0) {
+			contended_obj = entry;
+			goto err;
+		}
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+
+err:
+	list_for_each_entry_continue_reverse (list, contended_entry, entry)
+		ww_mutex_unlock(&entry->obj->lock);
+
+	if (res_obj)
+		ww_mutex_unlock(&res_obj->lock);
+
+	if (ret == -EDEADLK) {
+		/* we lost out in a seqno race, lock and retry.. */
+		ww_mutex_lock_slow(&contended_entry->obj->lock, ctx);
+		res_obj = contended_entry->obj;
+		goto retry;
+	}
+	ww_acquire_fini(ctx);
+
+	return ret;
+}
+
+Method 2, using a list in execbuf->buffers that can be reordered. Same semantics
+of duplicate entry detection using -EALREADY as method 1 above. But the
+list-reordering allows for a bit more idiomatic code.
+
+int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj_entry *entry, *entry2;
+
+	ww_acquire_init(ctx, &ww_class);
+
+	list_for_each_entry (list, entry) {
+		ret = ww_mutex_lock(&entry->obj->lock, ctx);
+		if (ret < 0) {
+			entry2 = entry;
+
+			list_for_each_entry_continue_reverse (list, entry2)
+				ww_mutex_unlock(&entry->obj->lock);
+
+			if (ret != -EDEADLK) {
+				ww_acquire_fini(ctx);
+				return ret;
+			}
+
+			/* we lost out in a seqno race, lock and retry.. */
+			ww_mutex_lock_slow(&entry->obj->lock, ctx);
+
+			/*
+			 * Move buf to head of the list, this will point
+			 * buf->next to the first unlocked entry,
+			 * restarting the for loop.
+			 */
+			list_del(&entry->list);
+			list_add(&entry->list, list);
+		}
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+}
+
+Unlocking works the same way for both methods 1&2:
+
+void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj_entry *entry;
+
+	list_for_each_entry (list, entry)
+		ww_mutex_unlock(&entry->obj->lock);
+
+	ww_acquire_fini(ctx);
+}
+
+Method 3 is useful if the list of objects is constructed ad-hoc and not upfront,
+e.g. when adjusting edges in a graph where each node has its own ww_mutex lock,
+and edges can only be changed when holding the locks of all involved nodes. w/w
+mutexes are a natural fit for such a case for two reasons:
+- They can handle lock-acquisition in any order which allows us to start walking
+  a graph from a starting point and then iteratively discovering new edges and
+  locking down the nodes those edges connect to.
+- Due to the -EALREADY return code signalling that a given objects is already
+  held there's no need for additional book-keeping to break cycles in the graph
+  or keep track off which looks are already held (when using more than one node
+  as a starting point).
+
+Note that this approach differs in two important ways from the above methods:
+- Since the list of objects is dynamically constructed (and might very well be
+  different when retrying due to hitting the -EDEADLK wound condition) there's
+  no need to keep any object on a persistent list when it's not locked. We can
+  therefore move the list_head into the object itself.
+- Otoh the dynamic object list construction also means that the -EALREADY return
+  code can't be propagated.
+
+Note also that methodes 1&2 and method 3 can be combined, e.g. to first lock a
+list of starting nodes (passed in from userspace) using one of the above
+methods. And then lock any additional objects affected by the operations using
+method 3 below. The backoff/retry procedure will be a bit more involved, since
+when the dynamic locking step hits -EDEADLK we also need to unlock all the
+objects acquired with the fixed list. But the w/w mutex debug checks will catch
+any interface misuse for these cases.
+
+Also, method 3 can't fail the lock acquisition step since it doesn't return
+-EALREADY. Of course this would be different when using the _interruptible
+variants, but that's outside of the scope of these examples here.
+
+struct obj {
+	struct ww_mutex ww_mutex;
+	struct list_head locked_list;
+};
+
+static DEFINE_WW_CLASS(ww_class);
+
+void __unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj entry;
+
+	for_each_safe (list, entry) {
+		/* need to do that before unlocking, since only the current lock holder is
+		allowed to use object */
+		list_del(entry->locked_list);
+		ww_mutex_unlock(entry->ww_mutex)
+	}
+}
+
+void lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct list_head locked_buffers;
+	struct obj obj = NULL, entry;
+
+	ww_acquire_init(ctx, &ww_class);
+
+retry:
+	/* re-init loop start state */
+	loop {
+		/* magic code which walks over a graph and decides which objects
+		 * to lock */
+
+		ret = ww_mutex_lock(obj->ww_mutex, ctx);
+		if (ret == -EALREADY) {
+			/* we have that one already, get to the next object */
+			continue;
+		}
+		if (ret == -EDEADLK) {
+			__unlock_objs(list, ctx);
+
+			ww_mutex_lock_slow(obj);
+			list_add(locked_buffers, entry->locked_list);
+			goto retry;
+		}
+
+		/* locked a new object, add it to the list */
+		list_add(locked_buffers, entry->locked_list);
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+}
+
+void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	__unlock_objs(list, ctx);
+	ww_acquire_fini(ctx);
+}
+
+Method 4: Only lock one single objects. In that case deadlock detection and
+prevention is obviously overkill, since with grabbing just one lock you can't
+produce a deadlock within just one class. To simplify this case the w/w mutex
+api provides a set of lock/unlock_single functions which don't require an
+acquire context.
+
+Implementation Details
+----------------------
+
+Design:
+  ww_mutex currently encapsulates a struct mutex, this means no extra overhead for
+  normal mutex locks, which are far more common. As such there is only a small
+  increase in code size if wait/wound mutexes are not used.
+
+  In general, not much contention is expected. The locks are typically used to
+  serialize access to resources for devices. The only way to make wakeups
+  smarter would be at the cost of adding a field to struct mutex_waiter. This
+  would add overhead to all cases where normal mutexes are used, and
+  ww_mutexes are generally less performance sensitive.
+
+Lockdep:
+  Special care has been taken to warn for as many cases of api abuse
+  as possible. Some common api abuses will be caught with
+  CONFIG_DEBUG_MUTEXES, but CONFIG_PROVE_LOCKING is recommended.
+
+  Some of the errors which will be warned about:
+   - Forgetting to call ww_acquire_fini or ww_acquire_init.
+   - Attempting to lock more mutexes after ww_acquire_done.
+   - Attempting to lock more mutexes after -EDEADLK,
+     before calling ww_mutex_lock_slow.
+
+   - Calling ww_mutex_lock_slow with while still holding some mutexes.
+   - Calling ww_mutex_lock_slow on the wrong mutex,
+     or before -EDEADLK was returned.
+
+   - Unlocking mutexes with the wrong unlock function.
+   - Calling one of the ww_acquire_* twice on the same context.
+   - Using a different ww_class for the mutex than for the ww_acquire_ctx.
+   - Normal lockdep errors that can result in deadlocks.
+
+  Some of the lockdep errors that can result in deadlocks:
+   - Calling ww_acquire_init to initialize a second ww_acquire_ctx before
+     having called ww_acquire_fini on the first.
+   - Mixing ww_mutex_lock and ww_mutex_lock_single.
+   - 'normal' deadlocks that can occur.
+
+FIXME: Update this section once we have the TASK_DEADLOCK task state flag magic
+implemented.
diff --git a/include/linux/mutex-debug.h b/include/linux/mutex-debug.h
index 731d77d..4ac8b19 100644
--- a/include/linux/mutex-debug.h
+++ b/include/linux/mutex-debug.h
@@ -3,6 +3,7 @@
 
 #include <linux/linkage.h>
 #include <linux/lockdep.h>
+#include <linux/debug_locks.h>
 
 /*
  * Mutexes - debugging helpers:
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 9121595..004f863 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -74,6 +74,35 @@ struct mutex_waiter {
 #endif
 };
 
+struct ww_class {
+	atomic_long_t stamp;
+	struct lock_class_key acquire_key;
+	struct lock_class_key mutex_key;
+	const char *acquire_name;
+	const char *mutex_name;
+};
+
+struct ww_acquire_ctx {
+	struct task_struct *task;
+	unsigned long stamp;
+#ifdef CONFIG_DEBUG_MUTEXES
+	unsigned acquired, done_acquire;
+	struct ww_class *ww_class;
+	struct ww_mutex *contending_lock;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+};
+
+struct ww_mutex {
+	struct mutex base;
+	struct ww_acquire_ctx *ctx;
+#ifdef CONFIG_DEBUG_MUTEXES
+	struct ww_class *ww_class;
+#endif
+};
+
 #ifdef CONFIG_DEBUG_MUTEXES
 # include <linux/mutex-debug.h>
 #else
@@ -98,8 +127,11 @@ static inline void mutex_destroy(struct mutex *lock) {}
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname) \
 		, .dep_map = { .name = #lockname }
+# define __WW_CLASS_MUTEX_INITIALIZER(lockname, ww_class) \
+		, .ww_class = &ww_class
 #else
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)
+# define __WW_CLASS_MUTEX_INITIALIZER(lockname, ww_class)
 #endif
 
 #define __MUTEX_INITIALIZER(lockname) \
@@ -109,13 +141,49 @@ static inline void mutex_destroy(struct mutex *lock) {}
 		__DEBUG_MUTEX_INITIALIZER(lockname) \
 		__DEP_MAP_MUTEX_INITIALIZER(lockname) }
 
+#define __WW_CLASS_INITIALIZER(ww_class) \
+		{ .stamp = ATOMIC_LONG_INIT(0) \
+		, .acquire_name = #ww_class "_acquire" \
+		, .mutex_name = #ww_class "_mutex" }
+
+#define __WW_MUTEX_INITIALIZER(lockname, class) \
+		{ .base = { \__MUTEX_INITIALIZER(lockname) } \
+		__WW_CLASS_MUTEX_INITIALIZER(lockname, class) }
+
 #define DEFINE_MUTEX(mutexname) \
 	struct mutex mutexname = __MUTEX_INITIALIZER(mutexname)
 
+#define DEFINE_WW_CLASS(classname) \
+	struct ww_class classname = __WW_CLASS_INITIALIZER(classname)
+
+#define DEFINE_WW_MUTEX(mutexname, ww_class) \
+	struct ww_mutex mutexname = __WW_MUTEX_INITIALIZER(mutexname, ww_class)
+
+
 extern void __mutex_init(struct mutex *lock, const char *name,
 			 struct lock_class_key *key);
 
 /**
+ * ww_mutex_init - initialize the w/w mutex
+ * @lock: the mutex to be initialized
+ * @ww_class: the w/w class the mutex should belong to
+ *
+ * Initialize the w/w mutex to unlocked state and associate it with the given
+ * class.
+ *
+ * It is not allowed to initialize an already locked mutex.
+ */
+static inline void ww_mutex_init(struct ww_mutex *lock,
+				 struct ww_class *ww_class)
+{
+	__mutex_init(&lock->base, ww_class->mutex_name, &ww_class->mutex_key);
+	lock->ctx = NULL;
+#ifdef CONFIG_DEBUG_MUTEXES
+	lock->ww_class = ww_class;
+#endif
+}
+
+/**
  * mutex_is_locked - is the mutex locked
  * @lock: the mutex to be queried
  *
@@ -133,6 +201,7 @@ static inline int mutex_is_locked(struct mutex *lock)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
 extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
@@ -144,7 +213,7 @@ extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
 
 #define mutex_lock_nest_lock(lock, nest_lock)				\
 do {									\
-	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
 	_mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);		\
 } while (0)
 
@@ -167,6 +236,192 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
+
+/**
+ * ww_acquire_init - initialize a w/w acquire context
+ * @ctx: w/w acquire context to initialize
+ * @ww_class: w/w class of the context
+ *
+ * Initializes an context to acquire multiple mutexes of the given w/w class.
+ *
+ * Context-based w/w mutex acquiring can be done in any order whatsoever within
+ * a given lock class. Deadlocks will be detected and handled with the
+ * wait/wound logic.
+ *
+ * Mixing of context-based w/w mutex acquiring and single w/w mutex locking can
+ * result in undetected deadlocks and is so forbidden. Mixing different contexts
+ * for the same w/w class when acquiring mutexes can also result in undetected
+ * deadlocks, and is hence also forbidden.
+ *
+ * Nesting of acquire contexts for _different_ w/w classes is possible, subject
+ * to the usual locking rules between different lock classes.
+ *
+ * An acquire context must be release by the same task before the memory is
+ * freed with ww_acquire_fini. It is recommended to allocate the context itself
+ * on the stack.
+ */
+static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
+				   struct ww_class *ww_class)
+{
+	ctx->task = current;
+	do {
+		ctx->stamp = atomic_long_inc_return(&ww_class->stamp);
+	} while (unlikely(!ctx->stamp));
+#ifdef CONFIG_DEBUG_MUTEXES
+	ctx->ww_class = ww_class;
+	ctx->acquired = ctx->done_acquire = 0;
+	ctx->contending_lock = NULL;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	debug_check_no_locks_freed((void *)ctx, sizeof(*ctx));
+	lockdep_init_map(&ctx->dep_map, ww_class->acquire_name,
+			 &ww_class->acquire_key, 0);
+	mutex_acquire(&ctx->dep_map, 0, 0, _RET_IP_);
+#endif
+}
+
+/**
+ * ww_acquire_done - marks the end of the acquire phase
+ * @ctx: the acquire context
+ *
+ * Marks the end of the acquire phase, any further w/w mutex lock calls using
+ * this context are forbidden.
+ *
+ * Calling this function is optional, it is just useful to document w/w mutex
+ * code and clearly designated the acquire phase from actually using the locked
+ * data structures.
+ */
+static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	lockdep_assert_held(ctx);
+
+	DEBUG_LOCKS_WARN_ON(ctx->done_acquire);
+	ctx->done_acquire = 1;
+#endif
+}
+
+/**
+ * ww_acquire_fini - releases a w/w acquire context
+ * @ctx: the acquire context to free
+ *
+ * Releases a w/w acquire context. This must be called _after_ all acquired w/w
+ * mutexes have been released with ww_mutex_unlock.
+ */
+static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	mutex_release(&ctx->dep_map, 0, _THIS_IP_);
+
+	DEBUG_LOCKS_WARN_ON(ctx->acquired);
+	if (!config_enabled(CONFIG_PROVE_LOCKING))
+		/*
+		 * lockdep will normally handle this,
+		 * but fail without anyway
+		 */
+		ctx->done_acquire = 1;
+
+	if (!config_enabled(CONFIG_DEBUG_LOCK_ALLOC))
+		/* ensure ww_acquire_fini will still fail if called twice */
+		ctx->acquired = ~0U;
+#endif
+}
+
+extern int __must_check ww_mutex_lock(struct ww_mutex *lock,
+				      struct ww_acquire_ctx *ctx);
+extern int __must_check ww_mutex_lock_interruptible(struct ww_mutex *,
+						    struct ww_acquire_ctx *ctx);
+
+extern void ww_mutex_lock_slow(struct ww_mutex *lock, struct ww_acquire_ctx *ctx);
+extern int __must_check ww_mutex_lock_slow_interruptible(struct ww_mutex *,
+							 struct ww_acquire_ctx *ctx);
+
+extern void ww_mutex_unlock(struct ww_mutex *lock);
+
+/**
+ * ww_mutex_trylock_single - tries to acquire the w/w mutex without acquire context
+ * @lock: mutex to lock
+ *
+ * Trylocks a mutex without acquire context, so no deadlock detection is
+ * possible. Returns 0 if the mutex has been acquired.
+ *
+ * Unlocking the mutex must happen with a call to ww_mutex_unlock_single.
+ */
+static inline int __must_check ww_mutex_trylock_single(struct ww_mutex *lock)
+{
+	return mutex_trylock(&lock->base);
+}
+
+/**
+ * ww_mutex_lock_single - acquire the w/w mutex without acquire context
+ * @lock: mutex to lock
+ *
+ * Locks a mutex without acquire context, so no deadlock detection is
+ * possible.
+ *
+ * Unlocking the mutex must happen with a call to ww_mutex_unlock_single.
+ */
+static inline void ww_mutex_lock_single(struct ww_mutex *lock)
+{
+	mutex_lock(&lock->base);
+}
+
+/**
+ * ww_mutex_lock_single_interruptible - acquire the w/w mutex without acquire
+ * 					context, interruptible
+ * @lock: mutex to lock
+ *
+ * Locks a mutex without acquire context, so no deadlock detection is
+ * possible.If a signal arrives while waiting for the lock then this function
+ * returns -EINTR. Returns 0 if the mutex has been acquired.
+ *
+ * Unlocking the mutex must happen with a call to ww_mutex_unlock_single.
+ */
+static inline int __must_check ww_mutex_lock_single_interruptible(struct ww_mutex *lock)
+{
+	return mutex_lock_interruptible(&lock->base);
+}
+
+/**
+ * ww_mutex_unlock_single - release the w/w mutex without acquire context
+ * @lock: mutex to unlock
+ *
+ * Unlock a w/w mutex that has been locked by this task previously without an
+ * acquire context. If the w/w mutex has been acquired with a context, it must
+ * be released with ww_mutex_unlock.
+ *
+ * This function must not be used in interrupt context. Unlocking
+ * of a not locked mutex is not allowed.
+ */
+static inline void ww_mutex_unlock_single(struct ww_mutex *lock)
+{
+	mutex_unlock(&lock->base);
+}
+
+/***
+ * ww_mutex_destroy - mark a w/w mutex unusable
+ * @lock: the mutex to be destroyed
+ *
+ * This function marks the mutex uninitialized, and any subsequent
+ * use of the mutex is forbidden. The mutex must not be locked when
+ * this function is called.
+ */
+static inline void ww_mutex_destroy(struct ww_mutex *lock)
+{
+	mutex_destroy(&lock->base);
+}
+
+/**
+ * ww_mutex_is_locked - is the w/w mutex locked
+ * @lock: the mutex to be queried
+ *
+ * Returns 1 if the mutex is locked, 0 if unlocked.
+ */
+static inline bool ww_mutex_is_locked(struct ww_mutex *lock)
+{
+	return mutex_is_locked(&lock->base);
+}
+
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
 #ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 84a5f07..66807c7 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -127,16 +127,156 @@ void __sched mutex_unlock(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_unlock);
 
+/**
+ * ww_mutex_unlock - release the w/w mutex
+ * @lock: the mutex to be released
+ *
+ * Unlock a mutex that has been locked by this task previously
+ * with ww_mutex_lock* using an acquire context. It is forbidden to release the
+ * locks after releasing the acquire context.
+ *
+ * This function must not be used in interrupt context. Unlocking
+ * of a unlocked mutex is not allowed.
+ *
+ * Note that locks acquired with one of the ww_mutex_lock*single variant must be
+ * unlocked with ww_mutex_unlock_single.
+ */
+void __sched ww_mutex_unlock(struct ww_mutex *lock)
+{
+	/*
+	 * The unlocking fastpath is the 0->1 transition from 'locked'
+	 * into 'unlocked' state:
+	 */
+#ifdef CONFIG_DEBUG_MUTEXES
+	DEBUG_LOCKS_WARN_ON(!lock->ctx);
+	if (lock->ctx) {
+		DEBUG_LOCKS_WARN_ON(!lock->ctx->acquired);
+		if (lock->ctx->acquired > 0)
+			lock->ctx->acquired--;
+	}
+#endif
+	lock->ctx = NULL;
+	smp_mb__before_atomic_inc();
+
+#ifndef CONFIG_DEBUG_MUTEXES
+	/*
+	 * When debugging is enabled we must not clear the owner before time,
+	 * the slow path will always be taken, and that clears the owner field
+	 * after verifying that it was indeed current.
+	 */
+	mutex_clear_owner(&lock->base);
+#endif
+	__mutex_fastpath_unlock(&lock->base.count, __mutex_unlock_slowpath);
+}
+EXPORT_SYMBOL(ww_mutex_unlock);
+
+static inline int __sched
+__mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
+	struct ww_acquire_ctx *hold_ctx = ACCESS_ONCE(ww->ctx);
+
+	if (!hold_ctx)
+		return 0;
+
+	if (unlikely(ctx->stamp == hold_ctx->stamp))
+		return -EALREADY;
+
+	if (unlikely(ctx->stamp - hold_ctx->stamp <= LONG_MAX)) {
+#ifdef CONFIG_DEBUG_MUTEXES
+		DEBUG_LOCKS_WARN_ON(ctx->contending_lock);
+		ctx->contending_lock = ww;
+#endif
+		return -EDEADLK;
+	}
+
+	return 0;
+}
+
+static __always_inline void ww_mutex_lock_acquired(struct ww_mutex *ww,
+						   struct ww_acquire_ctx *ww_ctx,
+						   bool ww_slow)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	/*
+	 * If this WARN_ON triggers, you used mutex_lock to acquire,
+	 * but released with ww_mutex_unlock in this call.
+	 */
+	DEBUG_LOCKS_WARN_ON(ww->ctx);
+
+	/*
+	 * Not quite done after ww_acquire_done() ?
+	 */
+	DEBUG_LOCKS_WARN_ON(ww_ctx->done_acquire);
+
+	if (ww_slow) {
+		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock != ww);
+		ww_ctx->contending_lock = NULL;
+	} else
+		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock);
+
+
+	/*
+	 * Naughty, using a different class can lead to undefined behavior!
+	 */
+	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
+
+	if (ww_slow)
+		DEBUG_LOCKS_WARN_ON(ww_ctx->acquired > 0);
+
+	ww_ctx->acquired++;
+#endif
+}
+
+/*
+ * after acquiring lock with fastpath or when we lost out in contested
+ * slowpath, set ctx and wake up any waiters so they can recheck.
+ *
+ * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
+ * as the fastpath and opportunistic spinning are disabled in that case.
+ */
+static __always_inline void
+ww_mutex_set_context_fastpath(struct ww_mutex *lock,
+			       struct ww_acquire_ctx *ctx)
+{
+	unsigned long flags;
+	struct mutex_waiter *cur;
+
+	ww_mutex_lock_acquired(lock, ctx, false);
+
+	lock->ctx = ctx;
+	smp_mb__after_atomic_dec();
+
+	/*
+	 * Check if lock is contended, if not there is nobody to wake up
+	 */
+	if (likely(atomic_read(&lock->base.count) == 0))
+		return;
+
+	/*
+	 * Uh oh, we raced in fastpath, wake up everyone in this case,
+	 * so they can see the new ctx
+	 */
+	spin_lock_mutex(&lock->base.wait_lock, flags);
+	list_for_each_entry(cur, &lock->base.wait_list, list) {
+		debug_mutex_wake_waiter(&lock->base, cur);
+		wake_up_process(cur->task);
+	}
+	spin_unlock_mutex(&lock->base.wait_lock, flags);
+}
+
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
-static inline int __sched
+static __always_inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-		    struct lockdep_map *nest_lock, unsigned long ip)
+		    struct lockdep_map *nest_lock, unsigned long ip,
+		    struct ww_acquire_ctx *ww_ctx, bool ww_slow)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
+	int ret;
 
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
@@ -163,6 +303,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	for (;;) {
 		struct task_struct *owner;
 
+		if (!__builtin_constant_p(ww_ctx == NULL) && !ww_slow) {
+			struct ww_mutex *ww;
+
+			ww = container_of(lock, struct ww_mutex, base);
+			if (ACCESS_ONCE(ww->ctx))
+				break;
+		}
+
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
@@ -173,6 +321,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
 			lock_acquired(&lock->dep_map, ip);
+			if (ww_slow) {
+				struct ww_mutex *ww;
+				ww = container_of(lock, struct ww_mutex, base);
+
+				ww_mutex_set_context_fastpath(ww, ww_ctx);
+			}
+
 			mutex_set_owner(lock);
 			preempt_enable();
 			return 0;
@@ -228,15 +383,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * TASK_UNINTERRUPTIBLE case.)
 		 */
 		if (unlikely(signal_pending_state(state, task))) {
-			mutex_remove_waiter(lock, &waiter,
-					    task_thread_info(task));
-			mutex_release(&lock->dep_map, 1, ip);
-			spin_unlock_mutex(&lock->wait_lock, flags);
+			ret = -EINTR;
+			goto err;
+		}
 
-			debug_mutex_free_waiter(&waiter);
-			preempt_enable();
-			return -EINTR;
+		if (!__builtin_constant_p(ww_ctx == NULL) && !ww_slow) {
+			ret = __mutex_lock_check_stamp(lock, ww_ctx);
+			if (ret)
+				goto err;
 		}
+
 		__set_task_state(task, state);
 
 		/* didn't get the lock, go to sleep: */
@@ -251,6 +407,30 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
+	if (!__builtin_constant_p(ww_ctx == NULL)) {
+		struct ww_mutex *ww = container_of(lock,
+						      struct ww_mutex,
+						      base);
+		struct mutex_waiter *cur;
+
+		/*
+		 * This branch gets optimized out for the common case,
+		 * and is only important for ww_mutex_lock.
+		 */
+
+		ww_mutex_lock_acquired(ww, ww_ctx, ww_slow);
+		ww->ctx = ww_ctx;
+
+		/*
+		 * Give any possible sleeping processes the chance to wake up,
+		 * so they can recheck if they have to back off.
+		 */
+		list_for_each_entry(cur, &lock->wait_list, list) {
+			debug_mutex_wake_waiter(lock, cur);
+			wake_up_process(cur->task);
+		}
+	}
+
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
 		atomic_set(&lock->count, 0);
@@ -261,6 +441,14 @@ done:
 	preempt_enable();
 
 	return 0;
+
+err:
+	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
+	spin_unlock_mutex(&lock->wait_lock, flags);
+	debug_mutex_free_waiter(&waiter);
+	mutex_release(&lock->dep_map, 1, ip);
+	preempt_enable();
+	return ret;
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -268,7 +456,8 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    subclass, NULL, _RET_IP_, 0, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -277,7 +466,8 @@ void __sched
 _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, nest, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    0, nest, _RET_IP_, 0, 0);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -286,7 +476,8 @@ int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE,
+				   subclass, NULL, _RET_IP_, 0, 0);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -295,10 +486,156 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, NULL, _RET_IP_);
+				   subclass, NULL, _RET_IP_, 0, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
+
+
+/**
+ * ww_mutex_lock - acquire the w/w mutex
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context
+ *
+ * Lock the w/w mutex exclusively for this task.
+ *
+ * Deadlocks within a given w/w class of locks are detected and handled with the
+ * wait/wound algorithm. If the lock isn't immediately avaiable this function
+ * will either sleep until it is (wait case). Or it selects the current context
+ * for backing off by returning -EDEADLK (wound case). Trying to acquire the
+ * same lock with the same context twice is also detected and signalled by
+ * returning -EALREADY. Returns 0 if the mutex was successfully acquired.
+ *
+ * In the wound case the caller must release all currently held w/w mutexes for
+ * the given context and then wait for this contending lock to be available by
+ * calling ww_mutex_lock_slow. Alternatively callers can opt to not acquire this
+ * lock and proceed with trying to acquire further w/w mutexes (e.g. when
+ * scanning through lru lists trying to free resources).
+ *
+ * The mutex must later on be released by the same task that
+ * acquired it. The task may not exit without first unlocking the mutex. Also,
+ * kernel memory where the mutex resides mutex must not be freed with the mutex
+ * still locked. The mutex must first be initialized (or statically defined)
+ * before it can be locked. memset()-ing the mutex to 0 is not allowed. The
+ * mutex must be of the same w/w lock class as was used to initialize the
+ * acquire context.
+ *
+ * A mutex acquired with this function must be released with ww_mutex_unlock.
+ *
+ * This function is similar to (but not equivalent to) mutex_lock().
+ */
+int __sched
+ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
+				   0, &ctx->dep_map, _RET_IP_, ctx, 0);
+}
+EXPORT_SYMBOL_GPL(ww_mutex_lock);
+
+/**
+ * ww_mutex_lock_interruptible - acquire the w/w mutex, interruptible
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context
+ *
+ * Lock the w/w mutex exclusively for this task.
+ *
+ * Deadlocks within a given w/w class of locks are detected and handled with the
+ * wait/wound algorithm. If the lock isn't immediately avaiable this function
+ * will either sleep until it is (wait case). Or it selects the current context
+ * for backing off by returning -EDEADLK (wound case). Trying to acquire the
+ * same lock with the same context twice is also detected and signalled by
+ * returning -EALREADY. Returns 0 if the mutex was successfully acquired. If a
+ * signal arrives while waiting for the lock then this function returns -EINTR.
+ *
+ * In the wound case the caller must release all currently held w/w mutexes for
+ * the given context and then wait for this contending lock to be available by
+ * calling ww_mutex_lock_slow_interruptible. Alternatively callers can opt to
+ * not acquire this lock and proceed with trying to acquire further w/w mutexes
+ * (e.g. when scanning through lru lists trying to free resources).
+ *
+ * The mutex must later on be released by the same task that
+ * acquired it. The task may not exit without first unlocking the mutex. Also,
+ * kernel memory where the mutex resides mutex must not be freed with the mutex
+ * still locked. The mutex must first be initialized (or statically defined)
+ * before it can be locked. memset()-ing the mutex to 0 is not allowed. The
+ * mutex must be of the same w/w lock class as was used to initialize the
+ * acquire context.
+ *
+ * A mutex acquired with this function must be released with ww_mutex_unlock.
+ *
+ * This function is similar to (but not equivalent to) mutex_lock_interruptible().
+ */
+int __sched
+ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
+				   0, &ctx->dep_map, _RET_IP_, ctx, 0);
+}
+EXPORT_SYMBOL_GPL(ww_mutex_lock_interruptible);
+
+/**
+ * ww_mutex_lock_slow - slowpath acquiring of the w/w mutex
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context
+ *
+ * Acquires a w/w mutex with the given context after a wound case. This function
+ * will sleep until the lock becomes available.
+ *
+ * The caller must have released all w/w mutexes already acquired with the
+ * context and then call this function on the contended lock.
+ *
+ * Afterwards the caller may continue to (re)acquire the other w/w mutexes it
+ * needs with ww_mutex_lock. Note that the -EALREADY return code from
+ * ww_mutex_lock can be used to avoid locking this contended mutex twice.
+ *
+ * It is forbidden to call this function with any other w/w mutexes associated
+ * with the context held. It is forbidden to call this on anything else than the
+ * contending mutex.
+ */
+void __sched
+ww_mutex_lock_slow(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	might_sleep();
+	__mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
+			    0, &ctx->dep_map, _RET_IP_, ctx, 1);
+}
+EXPORT_SYMBOL_GPL(ww_mutex_lock_slow);
+
+/**
+ * ww_mutex_lock_slow_interruptible - slowpath acquiring of the w/w mutex,
+ * 				      interruptible
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context
+ *
+ * Acquires a w/w mutex with the given context after a wound case. This function
+ * will sleep until the lock becomes available and returns 0 when the lock has
+ * been acquired. If a signal arrives while waiting for the lock then this
+ * function returns -EINTR.
+ *
+ * The caller must have released all w/w mutexes already acquired with the
+ * context and then call this function on the contended lock.
+ *
+ * Afterwards the caller may continue to (re)acquire the other w/w mutexes it
+ * needs with ww_mutex_lock. Note that the -EALREADY return code from
+ * ww_mutex_lock can be used to avoid locking this contended mutex twice.
+ *
+ * It is forbidden to call this function with any other w/w mutexes associated
+ * with the given context held. It is forbidden to call this on anything else
+ * than the contending mutex.
+ */
+int __sched
+ww_mutex_lock_slow_interruptible(struct ww_mutex *lock,
+				 struct ww_acquire_ctx *ctx)
+{
+	might_sleep();
+
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
+				   0, &ctx->dep_map, _RET_IP_, ctx, 1);
+}
+EXPORT_SYMBOL_GPL(ww_mutex_lock_slow_interruptible);
+
 #endif
 
 /*
@@ -401,20 +738,39 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
+			    NULL, _RET_IP_, 0, 0);
 }
 
 static noinline int __sched
 __mutex_lock_killable_slowpath(struct mutex *lock)
 {
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
+				   NULL, _RET_IP_, 0, 0);
 }
 
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(struct mutex *lock)
 {
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, 0, 0);
 }
+
+static noinline int __sched
+__ww_mutex_lock_slowpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, ctx, 0);
+}
+
+static noinline int __sched
+__ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
+					    struct ww_acquire_ctx *ctx)
+{
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, ctx, 0);
+}
+
 #endif
 
 /*
@@ -470,6 +826,63 @@ int __sched mutex_trylock(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_trylock);
 
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
+int __sched
+ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	might_sleep();
+
+	ret = __mutex_fastpath_lock_retval(&lock->base.count);
+
+	if (likely(!ret)) {
+		ww_mutex_set_context_fastpath(lock, ctx);
+		mutex_set_owner(&lock->base);
+	} else
+		ret = __ww_mutex_lock_slowpath(lock, ctx);
+	return ret;
+}
+EXPORT_SYMBOL(ww_mutex_lock);
+
+int __sched
+ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	might_sleep();
+
+	ret = __mutex_fastpath_lock_retval(&lock->base.count);
+
+	if (likely(!ret)) {
+		ww_mutex_set_context_fastpath(lock, ctx);
+		mutex_set_owner(&lock->base);
+	} else
+		ret = __ww_mutex_lock_interruptible_slowpath(lock, ctx);
+	return ret;
+}
+EXPORT_SYMBOL(ww_mutex_lock_interruptible);
+
+void __sched
+ww_mutex_lock_slow(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	might_sleep();
+	__mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
+			    0, NULL, _RET_IP_, ctx, 1);
+}
+EXPORT_SYMBOL(ww_mutex_lock_slow);
+
+int __sched
+ww_mutex_lock_slow_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
+				   0, NULL, _RET_IP_, ctx, 1);
+}
+EXPORT_SYMBOL(ww_mutex_lock_slow_interruptible);
+
+#endif
+
 /**
  * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
  * @cnt: the atomic which we are to dec
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index f2fa60c..96c4c63 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -30,6 +30,7 @@ EXPORT_SYMBOL_GPL(debug_locks);
  * a locking bug is detected.
  */
 int debug_locks_silent;
+EXPORT_SYMBOL_GPL(debug_locks_silent);
 
 /*
  * Generic 'turn off all lock debugging' function:
@@ -44,3 +45,4 @@ int debug_locks_off(void)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(debug_locks_off);

