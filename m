Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3GAIW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:22:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49788 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3GAIW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:22:27 -0400
Date: Mon, 1 Jul 2013 10:22:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@gmail.com>
Subject: [GIT PULL] core/mutexes changes for v3.11: W/W mutex support
Message-ID: <20130701082221.GA14112@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-mutexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-mutexes-for-linus

   HEAD: 166989e366ffa66108b2f37b870e66b85b2185ad locking-selftests: Handle unexpected failures more strictly

This tree adds support for wound/wait style locks, which the graphics guys 
would like to make use of in the TTM graphics subsystem.
    
Wound/wait mutexes are used when other multiple lock acquisitions of a 
similar type can be done in an arbitrary order. The deadlock handling used 
here is called wait/wound in the RDBMS literature: The older tasks waits 
until it can acquire the contended lock. The younger tasks needs to back 
off and drop all the locks it is currently holding, i.e. the younger task 
is wounded.

See this LWN.net description of W/W mutexes:

   https://lwn.net/Articles/548909/

The comments there outline specific usecases for this facility (which have 
already been implemented for the DRM tree).

Also see Documentation/ww-mutex-design.txt for more details.

 Thanks,

	Ingo

------------------>
Daniel Vetter (1):
      mutex: Add w/w mutex slowpath debugging

Maarten Lankhorst (6):
      arch: Make __mutex_fastpath_lock_retval return whether fastpath succeeded or not
      mutex: Add support for wound/wait style locks
      mutex: Add w/w tests to lib/locking-selftest.c
      mutex: Add more tests to lib/locking-selftest.c
      mutex: Add more w/w tests to test EDEADLK path handling
      locking-selftests: Handle unexpected failures more strictly


 Documentation/ww-mutex-design.txt | 344 ++++++++++++++++++
 arch/ia64/include/asm/mutex.h     |  10 +-
 arch/powerpc/include/asm/mutex.h  |  10 +-
 arch/sh/include/asm/mutex-llsc.h  |   4 +-
 arch/x86/include/asm/mutex_32.h   |  11 +-
 arch/x86/include/asm/mutex_64.h   |  11 +-
 include/asm-generic/mutex-dec.h   |  10 +-
 include/asm-generic/mutex-null.h  |   2 +-
 include/asm-generic/mutex-xchg.h  |  10 +-
 include/linux/mutex-debug.h       |   1 +
 include/linux/mutex.h             | 363 ++++++++++++++++++-
 kernel/mutex.c                    | 384 ++++++++++++++++++--
 lib/Kconfig.debug                 |  13 +
 lib/debug_locks.c                 |   2 +
 lib/locking-selftest.c            | 720 +++++++++++++++++++++++++++++++++++++-
 15 files changed, 1803 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/ww-mutex-design.txt

diff --git a/Documentation/ww-mutex-design.txt b/Documentation/ww-mutex-design.txt
new file mode 100644
index 0000000..8a112dc
--- /dev/null
+++ b/Documentation/ww-mutex-design.txt
@@ -0,0 +1,344 @@
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
+The algorithm that the TTM graphics subsystem came up with for dealing with
+this problem is quite simple.  For each group of buffers (execbuf) that need
+to be locked, the caller would be assigned a unique reservation id/ticket,
+from a global counter.  In case of deadlock while locking all the buffers
+associated with a execbuf, the one with the lowest reservation ticket (i.e.
+the oldest task) wins, and the one with the higher reservation id (i.e. the
+younger task) unlocks all of the buffers that it has already locked, and then
+tries again.
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
+Furthermore there are three different class of w/w lock acquire functions:
+
+* Normal lock acquisition with a context, using ww_mutex_lock.
+
+* Slowpath lock acquisition on the contending lock, used by the wounded task
+  after having dropped all already acquired locks. These functions have the
+  _slow postfix.
+
+  From a simple semantics point-of-view the _slow functions are not strictly
+  required, since simply calling the normal ww_mutex_lock functions on the
+  contending lock (after having dropped all other already acquired locks) will
+  work correctly. After all if no other ww mutex has been acquired yet there's
+  no deadlock potential and hence the ww_mutex_lock call will block and not
+  prematurely return -EDEADLK. The advantage of the _slow functions is in
+  interface safety:
+  - ww_mutex_lock has a __must_check int return type, whereas ww_mutex_lock_slow
+    has a void return type. Note that since ww mutex code needs loops/retries
+    anyway the __must_check doesn't result in spurious warnings, even though the
+    very first lock operation can never fail.
+  - When full debugging is enabled ww_mutex_lock_slow checks that all acquired
+    ww mutex have been released (preventing deadlocks) and makes sure that we
+    block on the contending lock (preventing spinning through the -EDEADLK
+    slowpath until the contended lock can be acquired).
+
+* Functions to only acquire a single w/w mutex, which results in the exact same
+  semantics as a normal mutex. This is done by calling ww_mutex_lock with a NULL
+  context.
+
+  Again this is not strictly required. But often you only want to acquire a
+  single lock in which case it's pointless to set up an acquire context (and so
+  better to avoid grabbing a deadlock avoidance ticket).
+
+Of course, all the usual variants for handling wake-ups due to signals are also
+provided.
+
+Usage
+-----
+
+Three different ways to acquire locks within the same w/w class. Common
+definitions for methods #1 and #2:
+
+static DEFINE_WW_CLASS(ww_class);
+
+struct obj {
+	struct ww_mutex lock;
+	/* obj data */
+};
+
+struct obj_entry {
+	struct list_head head;
+	struct obj *obj;
+};
+
+Method 1, using a list in execbuf->buffers that's not allowed to be reordered.
+This is useful if a list of required objects is already tracked somewhere.
+Furthermore the lock helper can use propagate the -EALREADY return code back to
+the caller as a signal that an object is twice on the list. This is useful if
+the list is constructed from userspace input and the ABI requires userspace to
+not have duplicate entries (e.g. for a gpu commandbuffer submission ioctl).
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
+	list_for_each_entry (entry, list, head) {
+		if (entry->obj == res_obj) {
+			res_obj = NULL;
+			continue;
+		}
+		ret = ww_mutex_lock(&entry->obj->lock, ctx);
+		if (ret < 0) {
+			contended_entry = entry;
+			goto err;
+		}
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+
+err:
+	list_for_each_entry_continue_reverse (entry, list, head)
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
+	list_for_each_entry (entry, list, head) {
+		ret = ww_mutex_lock(&entry->obj->lock, ctx);
+		if (ret < 0) {
+			entry2 = entry;
+
+			list_for_each_entry_continue_reverse (entry2, list, head)
+				ww_mutex_unlock(&entry2->obj->lock);
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
+			list_del(&entry->head);
+			list_add(&entry->head, list);
+		}
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+}
+
+Unlocking works the same way for both methods #1 and #2:
+
+void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj_entry *entry;
+
+	list_for_each_entry (entry, list, head)
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
+- On the other hand the dynamic object list construction also means that the -EALREADY return
+  code can't be propagated.
+
+Note also that methods #1 and #2 and method #3 can be combined, e.g. to first lock a
+list of starting nodes (passed in from userspace) using one of the above
+methods. And then lock any additional objects affected by the operations using
+method #3 below. The backoff/retry procedure will be a bit more involved, since
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
+void __unlock_objs(struct list_head *list)
+{
+	struct obj *entry, *temp;
+
+	list_for_each_entry_safe (entry, temp, list, locked_list) {
+		/* need to do that before unlocking, since only the current lock holder is
+		allowed to use object */
+		list_del(&entry->locked_list);
+		ww_mutex_unlock(entry->ww_mutex)
+	}
+}
+
+void lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj *obj;
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
+			__unlock_objs(list);
+
+			ww_mutex_lock_slow(obj, ctx);
+			list_add(&entry->locked_list, list);
+			goto retry;
+		}
+
+		/* locked a new object, add it to the list */
+		list_add_tail(&entry->locked_list, list);
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+}
+
+void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	__unlock_objs(list);
+	ww_acquire_fini(ctx);
+}
+
+Method 4: Only lock one single objects. In that case deadlock detection and
+prevention is obviously overkill, since with grabbing just one lock you can't
+produce a deadlock within just one class. To simplify this case the w/w mutex
+api can be used with a NULL context.
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
+   - Attempting to lock the wrong mutex after -EDEADLK and
+     unlocking all mutexes.
+   - Attempting to lock the right mutex after -EDEADLK,
+     before unlocking all mutexes.
+
+   - Calling ww_mutex_lock_slow before -EDEADLK was returned.
+
+   - Unlocking mutexes with the wrong unlock function.
+   - Calling one of the ww_acquire_* twice on the same context.
+   - Using a different ww_class for the mutex than for the ww_acquire_ctx.
+   - Normal lockdep errors that can result in deadlocks.
+
+  Some of the lockdep errors that can result in deadlocks:
+   - Calling ww_acquire_init to initialize a second ww_acquire_ctx before
+     having called ww_acquire_fini on the first.
+   - 'normal' deadlocks that can occur.
+
+FIXME: Update this section once we have the TASK_DEADLOCK task state flag magic
+implemented.
diff --git a/arch/ia64/include/asm/mutex.h b/arch/ia64/include/asm/mutex.h
index bed73a6..f41e66d 100644
--- a/arch/ia64/include/asm/mutex.h
+++ b/arch/ia64/include/asm/mutex.h
@@ -29,17 +29,15 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
  *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
  *                                 from 1 to a 0 value
  *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
  *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if
- * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns.
+ * Change the count from 1 to a value lower than 1. This function returns 0
+ * if the fastpath succeeds, or -1 otherwise.
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count)
 {
 	if (unlikely(ia64_fetchadd4_acq(count, -1) != 1))
-		return fail_fn(count);
+		return -1;
 	return 0;
 }
 
diff --git a/arch/powerpc/include/asm/mutex.h b/arch/powerpc/include/asm/mutex.h
index 5399f7e..127ab23 100644
--- a/arch/powerpc/include/asm/mutex.h
+++ b/arch/powerpc/include/asm/mutex.h
@@ -82,17 +82,15 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
  *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
  *                                 from 1 to a 0 value
  *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
  *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if
- * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns.
+ * Change the count from 1 to a value lower than 1. This function returns 0
+ * if the fastpath succeeds, or -1 otherwise.
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count)
 {
 	if (unlikely(__mutex_dec_return_lock(count) < 0))
-		return fail_fn(count);
+		return -1;
 	return 0;
 }
 
diff --git a/arch/sh/include/asm/mutex-llsc.h b/arch/sh/include/asm/mutex-llsc.h
index 090358a..dad29b6 100644
--- a/arch/sh/include/asm/mutex-llsc.h
+++ b/arch/sh/include/asm/mutex-llsc.h
@@ -37,7 +37,7 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
 }
 
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count)
 {
 	int __done, __res;
 
@@ -51,7 +51,7 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 		: "t");
 
 	if (unlikely(!__done || __res != 0))
-		__res = fail_fn(count);
+		__res = -1;
 
 	return __res;
 }
diff --git a/arch/x86/include/asm/mutex_32.h b/arch/x86/include/asm/mutex_32.h
index 03f90c8..0208c3c 100644
--- a/arch/x86/include/asm/mutex_32.h
+++ b/arch/x86/include/asm/mutex_32.h
@@ -42,17 +42,14 @@ do {								\
  *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
  *                                 from 1 to a 0 value
  *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
  *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if it
- * wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns
+ * Change the count from 1 to a value lower than 1. This function returns 0
+ * if the fastpath succeeds, or -1 otherwise.
  */
-static inline int __mutex_fastpath_lock_retval(atomic_t *count,
-					       int (*fail_fn)(atomic_t *))
+static inline int __mutex_fastpath_lock_retval(atomic_t *count)
 {
 	if (unlikely(atomic_dec_return(count) < 0))
-		return fail_fn(count);
+		return -1;
 	else
 		return 0;
 }
diff --git a/arch/x86/include/asm/mutex_64.h b/arch/x86/include/asm/mutex_64.h
index 68a87b0..2c543ff 100644
--- a/arch/x86/include/asm/mutex_64.h
+++ b/arch/x86/include/asm/mutex_64.h
@@ -37,17 +37,14 @@ do {								\
  *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
  *                                 from 1 to a 0 value
  *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
  *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if
- * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns
+ * Change the count from 1 to a value lower than 1. This function returns 0
+ * if the fastpath succeeds, or -1 otherwise.
  */
-static inline int __mutex_fastpath_lock_retval(atomic_t *count,
-					       int (*fail_fn)(atomic_t *))
+static inline int __mutex_fastpath_lock_retval(atomic_t *count)
 {
 	if (unlikely(atomic_dec_return(count) < 0))
-		return fail_fn(count);
+		return -1;
 	else
 		return 0;
 }
diff --git a/include/asm-generic/mutex-dec.h b/include/asm-generic/mutex-dec.h
index f104af7..d4f9fb4 100644
--- a/include/asm-generic/mutex-dec.h
+++ b/include/asm-generic/mutex-dec.h
@@ -28,17 +28,15 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
  *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
  *                                 from 1 to a 0 value
  *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
  *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if
- * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns.
+ * Change the count from 1 to a value lower than 1. This function returns 0
+ * if the fastpath succeeds, or -1 otherwise.
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count)
 {
 	if (unlikely(atomic_dec_return(count) < 0))
-		return fail_fn(count);
+		return -1;
 	return 0;
 }
 
diff --git a/include/asm-generic/mutex-null.h b/include/asm-generic/mutex-null.h
index e1bbbc7..61069ed 100644
--- a/include/asm-generic/mutex-null.h
+++ b/include/asm-generic/mutex-null.h
@@ -11,7 +11,7 @@
 #define _ASM_GENERIC_MUTEX_NULL_H
 
 #define __mutex_fastpath_lock(count, fail_fn)		fail_fn(count)
-#define __mutex_fastpath_lock_retval(count, fail_fn)	fail_fn(count)
+#define __mutex_fastpath_lock_retval(count)		(-1)
 #define __mutex_fastpath_unlock(count, fail_fn)		fail_fn(count)
 #define __mutex_fastpath_trylock(count, fail_fn)	fail_fn(count)
 #define __mutex_slowpath_needs_to_unlock()		1
diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
index c04e0db..f169ec0 100644
--- a/include/asm-generic/mutex-xchg.h
+++ b/include/asm-generic/mutex-xchg.h
@@ -39,18 +39,16 @@ __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
  *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
  *                                 from 1 to a 0 value
  *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
  *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if it
- * wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns
+ * Change the count from 1 to a value lower than 1. This function returns 0
+ * if the fastpath succeeds, or -1 otherwise.
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count)
 {
 	if (unlikely(atomic_xchg(count, 0) != 1))
 		if (likely(atomic_xchg(count, -1) != 1))
-			return fail_fn(count);
+			return -1;
 	return 0;
 }
 
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
index 433da8a..3793ed7 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -10,6 +10,7 @@
 #ifndef __LINUX_MUTEX_H
 #define __LINUX_MUTEX_H
 
+#include <asm/current.h>
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
 #include <linux/linkage.h>
@@ -77,6 +78,40 @@ struct mutex_waiter {
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
+	unsigned acquired;
+#ifdef CONFIG_DEBUG_MUTEXES
+	unsigned done_acquire;
+	struct ww_class *ww_class;
+	struct ww_mutex *contending_lock;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	unsigned deadlock_inject_interval;
+	unsigned deadlock_inject_countdown;
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
@@ -101,8 +136,11 @@ static inline void mutex_destroy(struct mutex *lock) {}
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
@@ -112,13 +150,49 @@ static inline void mutex_destroy(struct mutex *lock) {}
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
@@ -136,6 +210,7 @@ static inline int mutex_is_locked(struct mutex *lock)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
 extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
@@ -147,7 +222,7 @@ extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
 
 #define mutex_lock_nest_lock(lock, nest_lock)				\
 do {									\
-	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
 	_mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);		\
 } while (0)
 
@@ -170,6 +245,292 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
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
+ * deadlocks, and is hence also forbidden. Both types of abuse will be caught by
+ * enabling CONFIG_PROVE_LOCKING.
+ *
+ * Nesting of acquire contexts for _different_ w/w classes is possible, subject
+ * to the usual locking rules between different lock classes.
+ *
+ * An acquire context must be released with ww_acquire_fini by the same task
+ * before the memory is freed. It is recommended to allocate the context itself
+ * on the stack.
+ */
+static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
+				   struct ww_class *ww_class)
+{
+	ctx->task = current;
+	ctx->stamp = atomic_long_inc_return(&ww_class->stamp);
+	ctx->acquired = 0;
+#ifdef CONFIG_DEBUG_MUTEXES
+	ctx->ww_class = ww_class;
+	ctx->done_acquire = 0;
+	ctx->contending_lock = NULL;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	debug_check_no_locks_freed((void *)ctx, sizeof(*ctx));
+	lockdep_init_map(&ctx->dep_map, ww_class->acquire_name,
+			 &ww_class->acquire_key, 0);
+	mutex_acquire(&ctx->dep_map, 0, 0, _RET_IP_);
+#endif
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	ctx->deadlock_inject_interval = 1;
+	ctx->deadlock_inject_countdown = ctx->stamp & 0xf;
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
+extern int __must_check __ww_mutex_lock(struct ww_mutex *lock,
+					struct ww_acquire_ctx *ctx);
+extern int __must_check __ww_mutex_lock_interruptible(struct ww_mutex *lock,
+						      struct ww_acquire_ctx *ctx);
+
+/**
+ * ww_mutex_lock - acquire the w/w mutex
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context, or NULL to acquire only a single lock.
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
+ * kernel memory where the mutex resides must not be freed with the mutex still
+ * locked. The mutex must first be initialized (or statically defined) before it
+ * can be locked. memset()-ing the mutex to 0 is not allowed. The mutex must be
+ * of the same w/w lock class as was used to initialize the acquire context.
+ *
+ * A mutex acquired with this function must be released with ww_mutex_unlock.
+ */
+static inline int ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	if (ctx)
+		return __ww_mutex_lock(lock, ctx);
+	else {
+		mutex_lock(&lock->base);
+		return 0;
+	}
+}
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
+ * kernel memory where the mutex resides must not be freed with the mutex still
+ * locked. The mutex must first be initialized (or statically defined) before it
+ * can be locked. memset()-ing the mutex to 0 is not allowed. The mutex must be
+ * of the same w/w lock class as was used to initialize the acquire context.
+ *
+ * A mutex acquired with this function must be released with ww_mutex_unlock.
+ */
+static inline int __must_check ww_mutex_lock_interruptible(struct ww_mutex *lock,
+							   struct ww_acquire_ctx *ctx)
+{
+	if (ctx)
+		return __ww_mutex_lock_interruptible(lock, ctx);
+	else
+		return mutex_lock_interruptible(&lock->base);
+}
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
+ *
+ * Note that the slowpath lock acquiring can also be done by calling
+ * ww_mutex_lock directly. This function here is simply to help w/w mutex
+ * locking code readability by clearly denoting the slowpath.
+ */
+static inline void
+ww_mutex_lock_slow(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+#ifdef CONFIG_DEBUG_MUTEXES
+	DEBUG_LOCKS_WARN_ON(!ctx->contending_lock);
+#endif
+	ret = ww_mutex_lock(lock, ctx);
+	(void)ret;
+}
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
+ *
+ * Note that the slowpath lock acquiring can also be done by calling
+ * ww_mutex_lock_interruptible directly. This function here is simply to help
+ * w/w mutex locking code readability by clearly denoting the slowpath.
+ */
+static inline int __must_check
+ww_mutex_lock_slow_interruptible(struct ww_mutex *lock,
+				 struct ww_acquire_ctx *ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	DEBUG_LOCKS_WARN_ON(!ctx->contending_lock);
+#endif
+	return ww_mutex_lock_interruptible(lock, ctx);
+}
+
+extern void ww_mutex_unlock(struct ww_mutex *lock);
+
+/**
+ * ww_mutex_trylock - tries to acquire the w/w mutex without acquire context
+ * @lock: mutex to lock
+ *
+ * Trylocks a mutex without acquire context, so no deadlock detection is
+ * possible. Returns 1 if the mutex has been acquired successfully, 0 otherwise.
+ */
+static inline int __must_check ww_mutex_trylock(struct ww_mutex *lock)
+{
+	return mutex_trylock(&lock->base);
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
index ad53a66..e581ada 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -254,16 +254,165 @@ void __sched mutex_unlock(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_unlock);
 
+/**
+ * ww_mutex_unlock - release the w/w mutex
+ * @lock: the mutex to be released
+ *
+ * Unlock a mutex that has been locked by this task previously with any of the
+ * ww_mutex_lock* functions (with or without an acquire context). It is
+ * forbidden to release the locks after releasing the acquire context.
+ *
+ * This function must not be used in interrupt context. Unlocking
+ * of a unlocked mutex is not allowed.
+ */
+void __sched ww_mutex_unlock(struct ww_mutex *lock)
+{
+	/*
+	 * The unlocking fastpath is the 0->1 transition from 'locked'
+	 * into 'unlocked' state:
+	 */
+	if (lock->ctx) {
+#ifdef CONFIG_DEBUG_MUTEXES
+		DEBUG_LOCKS_WARN_ON(!lock->ctx->acquired);
+#endif
+		if (lock->ctx->acquired > 0)
+			lock->ctx->acquired--;
+		lock->ctx = NULL;
+	}
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
+	if (unlikely(ctx == hold_ctx))
+		return -EALREADY;
+
+	if (ctx->stamp - hold_ctx->stamp <= LONG_MAX &&
+	    (ctx->stamp != hold_ctx->stamp || ctx > hold_ctx)) {
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
+						   struct ww_acquire_ctx *ww_ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	/*
+	 * If this WARN_ON triggers, you used ww_mutex_lock to acquire,
+	 * but released with a normal mutex_unlock in this call.
+	 *
+	 * This should never happen, always use ww_mutex_unlock.
+	 */
+	DEBUG_LOCKS_WARN_ON(ww->ctx);
+
+	/*
+	 * Not quite done after calling ww_acquire_done() ?
+	 */
+	DEBUG_LOCKS_WARN_ON(ww_ctx->done_acquire);
+
+	if (ww_ctx->contending_lock) {
+		/*
+		 * After -EDEADLK you tried to
+		 * acquire a different ww_mutex? Bad!
+		 */
+		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock != ww);
+
+		/*
+		 * You called ww_mutex_lock after receiving -EDEADLK,
+		 * but 'forgot' to unlock everything else first?
+		 */
+		DEBUG_LOCKS_WARN_ON(ww_ctx->acquired > 0);
+		ww_ctx->contending_lock = NULL;
+	}
+
+	/*
+	 * Naughty, using a different class will lead to undefined behavior!
+	 */
+	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
+#endif
+	ww_ctx->acquired++;
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
+	ww_mutex_lock_acquired(lock, ctx);
+
+	lock->ctx = ctx;
+
+	/*
+	 * The lock->ctx update should be visible on all cores before
+	 * the atomic read is done, otherwise contended waiters might be
+	 * missed. The contended waiters will either see ww_ctx == NULL
+	 * and keep spinning, or it will acquire wait_lock, add itself
+	 * to waiter list and sleep.
+	 */
+	smp_mb(); /* ^^^ */
+
+	/*
+	 * Check if lock is contended, if not there is nobody to wake up
+	 */
+	if (likely(atomic_read(&lock->base.count) == 0))
+		return;
+
+	/*
+	 * Uh oh, we raced in fastpath, wake up everyone in this case,
+	 * so they can see the new lock->ctx.
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
+		    struct ww_acquire_ctx *ww_ctx)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
+	int ret;
 
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
@@ -298,6 +447,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct task_struct *owner;
 		struct mspin_node  node;
 
+		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+			struct ww_mutex *ww;
+
+			ww = container_of(lock, struct ww_mutex, base);
+			/*
+			 * If ww->ctx is set the contents are undefined, only
+			 * by acquiring wait_lock there is a guarantee that
+			 * they are not invalid when reading.
+			 *
+			 * As such, when deadlock detection needs to be
+			 * performed the optimistic spinning cannot be done.
+			 */
+			if (ACCESS_ONCE(ww->ctx))
+				break;
+		}
+
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
@@ -312,6 +477,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if ((atomic_read(&lock->count) == 1) &&
 		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
 			lock_acquired(&lock->dep_map, ip);
+			if (!__builtin_constant_p(ww_ctx == NULL)) {
+				struct ww_mutex *ww;
+				ww = container_of(lock, struct ww_mutex, base);
+
+				ww_mutex_set_context_fastpath(ww, ww_ctx);
+			}
+
 			mutex_set_owner(lock);
 			mspin_unlock(MLOCK(lock), &node);
 			preempt_enable();
@@ -371,15 +543,16 @@ slowpath:
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
+		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+			ret = __mutex_lock_check_stamp(lock, ww_ctx);
+			if (ret)
+				goto err;
 		}
+
 		__set_task_state(task, state);
 
 		/* didn't get the lock, go to sleep: */
@@ -394,6 +567,30 @@ done:
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
+		ww_mutex_lock_acquired(ww, ww_ctx);
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
@@ -404,6 +601,14 @@ done:
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
@@ -411,7 +616,8 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    subclass, NULL, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -420,7 +626,8 @@ void __sched
 _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, nest, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    0, nest, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -429,7 +636,8 @@ int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE,
+				   subclass, NULL, _RET_IP_, NULL);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -438,10 +646,68 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, NULL, _RET_IP_);
+				   subclass, NULL, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
+
+static inline int
+ww_mutex_deadlock_injection(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+#ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+	unsigned tmp;
+
+	if (ctx->deadlock_inject_countdown-- == 0) {
+		tmp = ctx->deadlock_inject_interval;
+		if (tmp > UINT_MAX/4)
+			tmp = UINT_MAX;
+		else
+			tmp = tmp*2 + tmp + tmp/2;
+
+		ctx->deadlock_inject_interval = tmp;
+		ctx->deadlock_inject_countdown = tmp;
+		ctx->contending_lock = lock;
+
+		ww_mutex_unlock(lock);
+
+		return -EDEADLK;
+	}
+#endif
+
+	return 0;
+}
+
+int __sched
+__ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	might_sleep();
+	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
+				   0, &ctx->dep_map, _RET_IP_, ctx);
+	if (!ret && ctx->acquired > 0)
+		return ww_mutex_deadlock_injection(lock, ctx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__ww_mutex_lock);
+
+int __sched
+__ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	might_sleep();
+	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
+				  0, &ctx->dep_map, _RET_IP_, ctx);
+
+	if (!ret && ctx->acquired > 0)
+		return ww_mutex_deadlock_injection(lock, ctx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
+
 #endif
 
 /*
@@ -494,10 +760,10 @@ __mutex_unlock_slowpath(atomic_t *lock_count)
  * mutex_lock_interruptible() and mutex_trylock().
  */
 static noinline int __sched
-__mutex_lock_killable_slowpath(atomic_t *lock_count);
+__mutex_lock_killable_slowpath(struct mutex *lock);
 
 static noinline int __sched
-__mutex_lock_interruptible_slowpath(atomic_t *lock_count);
+__mutex_lock_interruptible_slowpath(struct mutex *lock);
 
 /**
  * mutex_lock_interruptible - acquire the mutex, interruptible
@@ -515,12 +781,12 @@ int __sched mutex_lock_interruptible(struct mutex *lock)
 	int ret;
 
 	might_sleep();
-	ret =  __mutex_fastpath_lock_retval
-			(&lock->count, __mutex_lock_interruptible_slowpath);
-	if (!ret)
+	ret =  __mutex_fastpath_lock_retval(&lock->count);
+	if (likely(!ret)) {
 		mutex_set_owner(lock);
-
-	return ret;
+		return 0;
+	} else
+		return __mutex_lock_interruptible_slowpath(lock);
 }
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
@@ -530,12 +796,12 @@ int __sched mutex_lock_killable(struct mutex *lock)
 	int ret;
 
 	might_sleep();
-	ret = __mutex_fastpath_lock_retval
-			(&lock->count, __mutex_lock_killable_slowpath);
-	if (!ret)
+	ret = __mutex_fastpath_lock_retval(&lock->count);
+	if (likely(!ret)) {
 		mutex_set_owner(lock);
-
-	return ret;
+		return 0;
+	} else
+		return __mutex_lock_killable_slowpath(lock);
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
@@ -544,24 +810,39 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
+			    NULL, _RET_IP_, NULL);
 }
 
 static noinline int __sched
-__mutex_lock_killable_slowpath(atomic_t *lock_count)
+__mutex_lock_killable_slowpath(struct mutex *lock)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
+				   NULL, _RET_IP_, NULL);
+}
 
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
+static noinline int __sched
+__mutex_lock_interruptible_slowpath(struct mutex *lock)
+{
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, NULL);
 }
 
 static noinline int __sched
-__mutex_lock_interruptible_slowpath(atomic_t *lock_count)
+__ww_mutex_lock_slowpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
+	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, ctx);
+}
 
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
+static noinline int __sched
+__ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
+					    struct ww_acquire_ctx *ctx)
+{
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, ctx);
 }
+
 #endif
 
 /*
@@ -617,6 +898,45 @@ int __sched mutex_trylock(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_trylock);
 
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
+int __sched
+__ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
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
+EXPORT_SYMBOL(__ww_mutex_lock);
+
+int __sched
+__ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
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
+EXPORT_SYMBOL(__ww_mutex_lock_interruptible);
+
+#endif
+
 /**
  * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
  * @cnt: the atomic which we are to dec
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 566cf2b..7154f79 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -547,6 +547,19 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config DEBUG_WW_MUTEX_SLOWPATH
+	bool "Wait/wound mutex debugging: Slowpath testing"
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select DEBUG_LOCK_ALLOC
+	select DEBUG_SPINLOCK
+	select DEBUG_MUTEXES
+	help
+	 This feature enables slowpath testing for w/w mutex users by
+	 injecting additional -EDEADLK wound/backoff cases. Together with
+	 the full mutex checks enabled with (CONFIG_PROVE_LOCKING) this
+	 will test all possible w/w mutex interface abuse with the
+	 exception of simply not acquiring all the required locks.
+
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
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
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index c3eb261..aad024d 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -26,6 +26,8 @@
  */
 static unsigned int debug_locks_verbose;
 
+static DEFINE_WW_CLASS(ww_lockdep);
+
 static int __init setup_debug_locks_verbose(char *str)
 {
 	get_option(&str, &debug_locks_verbose);
@@ -42,6 +44,10 @@ __setup("debug_locks_verbose=", setup_debug_locks_verbose);
 #define LOCKTYPE_RWLOCK	0x2
 #define LOCKTYPE_MUTEX	0x4
 #define LOCKTYPE_RWSEM	0x8
+#define LOCKTYPE_WW	0x10
+
+static struct ww_acquire_ctx t, t2;
+static struct ww_mutex o, o2, o3;
 
 /*
  * Normal standalone locks, for the circular and irq-context
@@ -193,6 +199,20 @@ static void init_shared_classes(void)
 #define RSU(x)			up_read(&rwsem_##x)
 #define RWSI(x)			init_rwsem(&rwsem_##x)
 
+#ifndef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
+#define WWAI(x)			ww_acquire_init(x, &ww_lockdep)
+#else
+#define WWAI(x)			do { ww_acquire_init(x, &ww_lockdep); (x)->deadlock_inject_countdown = ~0U; } while (0)
+#endif
+#define WWAD(x)			ww_acquire_done(x)
+#define WWAF(x)			ww_acquire_fini(x)
+
+#define WWL(x, c)		ww_mutex_lock(x, c)
+#define WWT(x)			ww_mutex_trylock(x)
+#define WWL1(x)			ww_mutex_lock(x, NULL)
+#define WWU(x)			ww_mutex_unlock(x)
+
+
 #define LOCK_UNLOCK_2(x,y)	LOCK(x); LOCK(y); UNLOCK(y); UNLOCK(x)
 
 /*
@@ -894,11 +914,13 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 # define I_RWLOCK(x)	lockdep_reset_lock(&rwlock_##x.dep_map)
 # define I_MUTEX(x)	lockdep_reset_lock(&mutex_##x.dep_map)
 # define I_RWSEM(x)	lockdep_reset_lock(&rwsem_##x.dep_map)
+# define I_WW(x)	lockdep_reset_lock(&x.dep_map)
 #else
 # define I_SPINLOCK(x)
 # define I_RWLOCK(x)
 # define I_MUTEX(x)
 # define I_RWSEM(x)
+# define I_WW(x)
 #endif
 
 #define I1(x)					\
@@ -920,11 +942,20 @@ GENERATE_PERMUTATIONS_3_EVENTS(irq_read_recursion_soft)
 static void reset_locks(void)
 {
 	local_irq_disable();
+	lockdep_free_key_range(&ww_lockdep.acquire_key, 1);
+	lockdep_free_key_range(&ww_lockdep.mutex_key, 1);
+
 	I1(A); I1(B); I1(C); I1(D);
 	I1(X1); I1(X2); I1(Y1); I1(Y2); I1(Z1); I1(Z2);
+	I_WW(t); I_WW(t2); I_WW(o.base); I_WW(o2.base); I_WW(o3.base);
 	lockdep_reset();
 	I2(A); I2(B); I2(C); I2(D);
 	init_shared_classes();
+
+	ww_mutex_init(&o, &ww_lockdep); ww_mutex_init(&o2, &ww_lockdep); ww_mutex_init(&o3, &ww_lockdep);
+	memset(&t, 0, sizeof(t)); memset(&t2, 0, sizeof(t2));
+	memset(&ww_lockdep.acquire_key, 0, sizeof(ww_lockdep.acquire_key));
+	memset(&ww_lockdep.mutex_key, 0, sizeof(ww_lockdep.mutex_key));
 	local_irq_enable();
 }
 
@@ -938,7 +969,6 @@ static int unexpected_testcase_failures;
 static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 {
 	unsigned long saved_preempt_count = preempt_count();
-	int expected_failure = 0;
 
 	WARN_ON(irqs_disabled());
 
@@ -947,25 +977,17 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	 * Filter out expected failures:
 	 */
 #ifndef CONFIG_PROVE_LOCKING
-	if ((lockclass_mask & LOCKTYPE_SPIN) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_RWLOCK) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_MUTEX) && debug_locks != expected)
-		expected_failure = 1;
-	if ((lockclass_mask & LOCKTYPE_RWSEM) && debug_locks != expected)
-		expected_failure = 1;
+	if (expected == FAILURE && debug_locks) {
+		expected_testcase_failures++;
+		printk("failed|");
+	}
+	else
 #endif
 	if (debug_locks != expected) {
-		if (expected_failure) {
-			expected_testcase_failures++;
-			printk("failed|");
-		} else {
-			unexpected_testcase_failures++;
-
-			printk("FAILED|");
-			dump_stack();
-		}
+		unexpected_testcase_failures++;
+		printk("FAILED|");
+
+		dump_stack();
 	} else {
 		testcase_successes++;
 		printk("  ok  |");
@@ -1108,6 +1130,666 @@ static inline void print_testname(const char *testname)
 	DO_TESTCASE_6IRW(desc, name, 312);			\
 	DO_TESTCASE_6IRW(desc, name, 321);
 
+static void ww_test_fail_acquire(void)
+{
+	int ret;
+
+	WWAI(&t);
+	t.stamp++;
+
+	ret = WWL(&o, &t);
+
+	if (WARN_ON(!o.ctx) ||
+	    WARN_ON(ret))
+		return;
+
+	/* No lockdep test, pure API */
+	ret = WWL(&o, &t);
+	WARN_ON(ret != -EALREADY);
+
+	ret = WWT(&o);
+	WARN_ON(ret);
+
+	t2 = t;
+	t2.stamp++;
+	ret = WWL(&o, &t2);
+	WARN_ON(ret != -EDEADLK);
+	WWU(&o);
+
+	if (WWT(&o))
+		WWU(&o);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	else
+		DEBUG_LOCKS_WARN_ON(1);
+#endif
+}
+
+static void ww_test_normal(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	/*
+	 * None of the ww_mutex codepaths should be taken in the 'normal'
+	 * mutex calls. The easiest way to verify this is by using the
+	 * normal mutex calls, and making sure o.ctx is unmodified.
+	 */
+
+	/* mutex_lock (and indirectly, mutex_lock_nested) */
+	o.ctx = (void *)~0UL;
+	mutex_lock(&o.base);
+	mutex_unlock(&o.base);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* mutex_lock_interruptible (and *_nested) */
+	o.ctx = (void *)~0UL;
+	ret = mutex_lock_interruptible(&o.base);
+	if (!ret)
+		mutex_unlock(&o.base);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* mutex_lock_killable (and *_nested) */
+	o.ctx = (void *)~0UL;
+	ret = mutex_lock_killable(&o.base);
+	if (!ret)
+		mutex_unlock(&o.base);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* trylock, succeeding */
+	o.ctx = (void *)~0UL;
+	ret = mutex_trylock(&o.base);
+	WARN_ON(!ret);
+	if (ret)
+		mutex_unlock(&o.base);
+	else
+		WARN_ON(1);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* trylock, failing */
+	o.ctx = (void *)~0UL;
+	mutex_lock(&o.base);
+	ret = mutex_trylock(&o.base);
+	WARN_ON(ret);
+	mutex_unlock(&o.base);
+	WARN_ON(o.ctx != (void *)~0UL);
+
+	/* nest_lock */
+	o.ctx = (void *)~0UL;
+	mutex_lock_nest_lock(&o.base, &t);
+	mutex_unlock(&o.base);
+	WARN_ON(o.ctx != (void *)~0UL);
+}
+
+static void ww_test_two_contexts(void)
+{
+	WWAI(&t);
+	WWAI(&t2);
+}
+
+static void ww_test_diff_class(void)
+{
+	WWAI(&t);
+#ifdef CONFIG_DEBUG_MUTEXES
+	t.ww_class = NULL;
+#endif
+	WWL(&o, &t);
+}
+
+static void ww_test_context_done_twice(void)
+{
+	WWAI(&t);
+	WWAD(&t);
+	WWAD(&t);
+	WWAF(&t);
+}
+
+static void ww_test_context_unlock_twice(void)
+{
+	WWAI(&t);
+	WWAD(&t);
+	WWAF(&t);
+	WWAF(&t);
+}
+
+static void ww_test_context_fini_early(void)
+{
+	WWAI(&t);
+	WWL(&o, &t);
+	WWAD(&t);
+	WWAF(&t);
+}
+
+static void ww_test_context_lock_after_done(void)
+{
+	WWAI(&t);
+	WWAD(&t);
+	WWL(&o, &t);
+}
+
+static void ww_test_object_unlock_twice(void)
+{
+	WWL1(&o);
+	WWU(&o);
+	WWU(&o);
+}
+
+static void ww_test_object_lock_unbalanced(void)
+{
+	WWAI(&t);
+	WWL(&o, &t);
+	t.acquired = 0;
+	WWU(&o);
+	WWAF(&t);
+}
+
+static void ww_test_object_lock_stale_context(void)
+{
+	WWAI(&t);
+	o.ctx = &t2;
+	WWL(&o, &t);
+}
+
+static void ww_test_edeadlk_normal(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	o2.ctx = &t2;
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	o2.ctx = NULL;
+	mutex_acquire(&o2.base.dep_map, 0, 1, _THIS_IP_);
+	mutex_unlock(&o2.base);
+	WWU(&o);
+
+	WWL(&o2, &t);
+}
+
+static void ww_test_edeadlk_normal_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	o2.ctx = NULL;
+	mutex_acquire(&o2.base.dep_map, 0, 1, _THIS_IP_);
+	mutex_unlock(&o2.base);
+	WWU(&o);
+
+	ww_mutex_lock_slow(&o2, &t);
+}
+
+static void ww_test_edeadlk_no_unlock(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	o2.ctx = &t2;
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	o2.ctx = NULL;
+	mutex_acquire(&o2.base.dep_map, 0, 1, _THIS_IP_);
+	mutex_unlock(&o2.base);
+
+	WWL(&o2, &t);
+}
+
+static void ww_test_edeadlk_no_unlock_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	o2.ctx = NULL;
+	mutex_acquire(&o2.base.dep_map, 0, 1, _THIS_IP_);
+	mutex_unlock(&o2.base);
+
+	ww_mutex_lock_slow(&o2, &t);
+}
+
+static void ww_test_edeadlk_acquire_more(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	ret = WWL(&o3, &t);
+}
+
+static void ww_test_edeadlk_acquire_more_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	ww_mutex_lock_slow(&o3, &t);
+}
+
+static void ww_test_edeadlk_acquire_more_edeadlk(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	mutex_lock(&o3.base);
+	mutex_release(&o3.base.dep_map, 1, _THIS_IP_);
+	o3.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	ret = WWL(&o3, &t);
+	WARN_ON(ret != -EDEADLK);
+}
+
+static void ww_test_edeadlk_acquire_more_edeadlk_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	mutex_lock(&o3.base);
+	mutex_release(&o3.base.dep_map, 1, _THIS_IP_);
+	o3.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+
+	ww_mutex_lock_slow(&o3, &t);
+}
+
+static void ww_test_edeadlk_acquire_wrong(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+	if (!ret)
+		WWU(&o2);
+
+	WWU(&o);
+
+	ret = WWL(&o3, &t);
+}
+
+static void ww_test_edeadlk_acquire_wrong_slow(void)
+{
+	int ret;
+
+	mutex_lock(&o2.base);
+	mutex_release(&o2.base.dep_map, 1, _THIS_IP_);
+	o2.ctx = &t2;
+
+	WWAI(&t);
+	t2 = t;
+	t2.stamp--;
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret != -EDEADLK);
+	if (!ret)
+		WWU(&o2);
+
+	WWU(&o);
+
+	ww_mutex_lock_slow(&o3, &t);
+}
+
+static void ww_test_spin_nest_unlocked(void)
+{
+	raw_spin_lock_nest_lock(&lock_A, &o.base);
+	U(A);
+}
+
+static void ww_test_unneeded_slow(void)
+{
+	WWAI(&t);
+
+	ww_mutex_lock_slow(&o, &t);
+}
+
+static void ww_test_context_block(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	WWL1(&o2);
+}
+
+static void ww_test_context_try(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWT(&o2);
+	WARN_ON(!ret);
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_context_context(void)
+{
+	int ret;
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_try_block(void)
+{
+	bool ret;
+
+	ret = WWT(&o);
+	WARN_ON(!ret);
+
+	WWL1(&o2);
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_try_try(void)
+{
+	bool ret;
+
+	ret = WWT(&o);
+	WARN_ON(!ret);
+	ret = WWT(&o2);
+	WARN_ON(!ret);
+	WWU(&o2);
+	WWU(&o);
+}
+
+static void ww_test_try_context(void)
+{
+	int ret;
+
+	ret = WWT(&o);
+	WARN_ON(!ret);
+
+	WWAI(&t);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+}
+
+static void ww_test_block_block(void)
+{
+	WWL1(&o);
+	WWL1(&o2);
+}
+
+static void ww_test_block_try(void)
+{
+	bool ret;
+
+	WWL1(&o);
+	ret = WWT(&o2);
+	WARN_ON(!ret);
+}
+
+static void ww_test_block_context(void)
+{
+	int ret;
+
+	WWL1(&o);
+	WWAI(&t);
+
+	ret = WWL(&o2, &t);
+	WARN_ON(ret);
+}
+
+static void ww_test_spin_block(void)
+{
+	L(A);
+	U(A);
+
+	WWL1(&o);
+	L(A);
+	U(A);
+	WWU(&o);
+
+	L(A);
+	WWL1(&o);
+	WWU(&o);
+	U(A);
+}
+
+static void ww_test_spin_try(void)
+{
+	bool ret;
+
+	L(A);
+	U(A);
+
+	ret = WWT(&o);
+	WARN_ON(!ret);
+	L(A);
+	U(A);
+	WWU(&o);
+
+	L(A);
+	ret = WWT(&o);
+	WARN_ON(!ret);
+	WWU(&o);
+	U(A);
+}
+
+static void ww_test_spin_context(void)
+{
+	int ret;
+
+	L(A);
+	U(A);
+
+	WWAI(&t);
+
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	L(A);
+	U(A);
+	WWU(&o);
+
+	L(A);
+	ret = WWL(&o, &t);
+	WARN_ON(ret);
+	WWU(&o);
+	U(A);
+}
+
+static void ww_tests(void)
+{
+	printk("  --------------------------------------------------------------------------\n");
+	printk("  | Wound/wait tests |\n");
+	printk("  ---------------------\n");
+
+	print_testname("ww api failures");
+	dotest(ww_test_fail_acquire, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_normal, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_unneeded_slow, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("ww contexts mixing");
+	dotest(ww_test_two_contexts, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_diff_class, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("finishing ww context");
+	dotest(ww_test_context_done_twice, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_unlock_twice, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_fini_early, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_lock_after_done, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("locking mismatches");
+	dotest(ww_test_object_unlock_twice, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_object_lock_unbalanced, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_object_lock_stale_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("EDEADLK handling");
+	dotest(ww_test_edeadlk_normal, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_normal_slow, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_no_unlock, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_no_unlock_slow, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_more, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_more_slow, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_more_edeadlk, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_more_edeadlk_slow, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_wrong, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_edeadlk_acquire_wrong_slow, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("spinlock nest unlocked");
+	dotest(ww_test_spin_nest_unlocked, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	printk("  -----------------------------------------------------\n");
+	printk("                                 |block | try  |context|\n");
+	printk("  -----------------------------------------------------\n");
+
+	print_testname("context");
+	dotest(ww_test_context_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_context_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_context_context, SUCCESS, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("try");
+	dotest(ww_test_try_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_try_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_try_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("block");
+	dotest(ww_test_block_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_block_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_block_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+
+	print_testname("spinlock");
+	dotest(ww_test_spin_block, FAILURE, LOCKTYPE_WW);
+	dotest(ww_test_spin_try, SUCCESS, LOCKTYPE_WW);
+	dotest(ww_test_spin_context, FAILURE, LOCKTYPE_WW);
+	printk("\n");
+}
 
 void locking_selftest(void)
 {
@@ -1188,6 +1870,8 @@ void locking_selftest(void)
 	DO_TESTCASE_6x2("irq read-recursion", irq_read_recursion);
 //	DO_TESTCASE_6x2B("irq read-recursion #2", irq_read_recursion2);
 
+	ww_tests();
+
 	if (unexpected_testcase_failures) {
 		printk("-----------------------------------------------------------------\n");
 		debug_locks = 0;
