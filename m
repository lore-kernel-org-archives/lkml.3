Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460Ab3E1OtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:49:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46474 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934359Ab3E1OtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:49:11 -0400
Subject: [PATCH v4 1/4] arch: make __mutex_fastpath_lock_retval return whether
 fastpath succeeded or not.
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Date: Tue, 28 May 2013 16:48:33 +0200
Message-ID: <20130528144833.4538.16154.stgit@patser>
In-Reply-To: <20130528144420.4538.70725.stgit@patser>
References: <20130528144420.4538.70725.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow me to call functions that have multiple arguments if fastpath fails.
This is required to support ticket mutexes, because they need to be able to pass an
extra argument to the fail function.

Originally I duplicated the functions, by adding __mutex_fastpath_lock_retval_arg.
This ended up being just a duplication of the existing function, so a way to test
if fastpath was called ended up being better.

This also cleaned up the reservation mutex patch some by being able to call an
atomic_set instead of atomic_xchg, and making it easier to detect if the wrong
unlock function was previously used.

Changes since v1, pointed out by Francesco Lavra:
- fix a small comment issue in mutex_32.h
- fix the __mutex_fastpath_lock_retval macro for mutex-null.h

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 arch/ia64/include/asm/mutex.h    |   10 ++++------
 arch/powerpc/include/asm/mutex.h |   10 ++++------
 arch/sh/include/asm/mutex-llsc.h |    4 ++--
 arch/x86/include/asm/mutex_32.h  |   11 ++++-------
 arch/x86/include/asm/mutex_64.h  |   11 ++++-------
 include/asm-generic/mutex-dec.h  |   10 ++++------
 include/asm-generic/mutex-null.h |    2 +-
 include/asm-generic/mutex-xchg.h |   10 ++++------
 kernel/mutex.c                   |   32 ++++++++++++++------------------
 9 files changed, 41 insertions(+), 59 deletions(-)

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
 
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 52f2301..84a5f07 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -351,10 +351,10 @@ __mutex_unlock_slowpath(atomic_t *lock_count)
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
@@ -372,12 +372,12 @@ int __sched mutex_lock_interruptible(struct mutex *lock)
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
@@ -387,12 +387,12 @@ int __sched mutex_lock_killable(struct mutex *lock)
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
 
@@ -405,18 +405,14 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 }
 
 static noinline int __sched
-__mutex_lock_killable_slowpath(atomic_t *lock_count)
+__mutex_lock_killable_slowpath(struct mutex *lock)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
-
 	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
 }
 
 static noinline int __sched
-__mutex_lock_interruptible_slowpath(atomic_t *lock_count)
+__mutex_lock_interruptible_slowpath(struct mutex *lock)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
-
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
 }
 #endif

