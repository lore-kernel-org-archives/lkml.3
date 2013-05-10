Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3EJNM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:12:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40356 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3EJNM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:12:56 -0400
Date: Fri, 10 May 2013 15:11:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130510131120.GA32596@dyad.programming.kicks-ass.net>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-8-git-send-email-sasha.levin@oracle.com>
 <20130510111719.GG31235@dyad.programming.kicks-ass.net>
 <20130510114605.GA32110@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510114605.GA32110@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 01:46:05PM +0200, Peter Zijlstra wrote:
> OK, that won't do indeed. Not being able to malloc is only part of the problem.
> 
> /me goes stare at it more

So the below hackery actually does run with firefox -- although it generates a
metric ton of output.

It very much relies on the gnu-libc (although it should work with both the NPTL
and LinuxThread implementations).

The static allocation stuff is still there but shouldn't be needed for this.

---
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -146,7 +146,7 @@ do_app_build =						\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared -ldl $^ -o $@)
+	$(CC) --shared $^ -o $@ -lpthread -ldl)
 
 do_build_static_lib =				\
 	($(print_static_lib_build)		\
--- a/tools/lib/lockdep/preload.c
+++ b/tools/lib/lockdep/preload.c
@@ -1,4 +1,5 @@
 #define _GNU_SOURCE
+#include <sysexits.h>
 #include <pthread.h>
 #include <stdio.h>
 #include <dlfcn.h>
@@ -29,28 +30,63 @@ static struct rb_root locks = RB_ROOT;
 static pthread_rwlock_t locks_rwlock = PTHREAD_RWLOCK_INITIALIZER;
 
 /* pthread mutex API */
+
+#ifdef __GLIBC__
+extern int __pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr);
+extern int __pthread_mutex_lock(pthread_mutex_t *mutex);
+extern int __pthread_mutex_trylock(pthread_mutex_t *mutex);
+extern int __pthread_mutex_unlock(pthread_mutex_t *mutex);
+extern int __pthread_mutex_destroy(pthread_mutex_t *mutex);
+#else
+#define __pthread_mutex_init	NULL
+#define __pthread_mutex_lock	NULL
+#define __pthread_mutex_trylock	NULL
+#define __pthread_mutex_unlock	NULL
+#define __pthread_mutex_destroy	NULL
+#endif
+
 static int (*ll_pthread_mutex_init)(pthread_mutex_t *mutex,
-			const pthread_mutexattr_t *attr);
-static int (*ll_pthread_mutex_lock)(pthread_mutex_t *mutex);
-static int (*ll_pthread_mutex_trylock)(pthread_mutex_t *mutex);
-static int (*ll_pthread_mutex_unlock)(pthread_mutex_t *mutex);
-static int (*ll_pthread_mutex_destroy)(pthread_mutex_t *mutex);
+			const pthread_mutexattr_t *attr)	= __pthread_mutex_init;
+static int (*ll_pthread_mutex_lock)(pthread_mutex_t *mutex)	= __pthread_mutex_lock;
+static int (*ll_pthread_mutex_trylock)(pthread_mutex_t *mutex)	= __pthread_mutex_trylock;
+static int (*ll_pthread_mutex_unlock)(pthread_mutex_t *mutex)	= __pthread_mutex_unlock;
+static int (*ll_pthread_mutex_destroy)(pthread_mutex_t *mutex)	= __pthread_mutex_destroy;
 
 /* pthread rwlock API */
+
+#ifdef __GLIBC__
+extern int __pthread_rwlock_init(pthread_rwlock_t *rwlock, const pthread_rwlockattr_t *attr);
+extern int __pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
+extern int __pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
+#else
+#define __pthread_rwlock_init		NULL
+#define __pthread_rwlock_destroy	NULL
+#define __pthread_rwlock_wrlock		NULL
+#define __pthread_rwlock_trywrlock	NULL
+#define __pthread_rwlock_rdlock		NULL
+#define __pthread_rwlock_tryrdlock	NULL
+#define __pthread_rwlock_unlock		NULL
+#endif
+
 static int (*ll_pthread_rwlock_init)(pthread_rwlock_t *rwlock,
-			const pthread_rwlockattr_t *attr);
-static int (*ll_pthread_rwlock_destroy)(pthread_rwlock_t *rwlock);
-static int (*ll_pthread_rwlock_rdlock)(pthread_rwlock_t *rwlock);
-static int (*ll_pthread_rwlock_tryrdlock)(pthread_rwlock_t *rwlock);
-static int (*ll_pthread_rwlock_trywrlock)(pthread_rwlock_t *rwlock);
-static int (*ll_pthread_rwlock_wrlock)(pthread_rwlock_t *rwlock);
-static int (*ll_pthread_rwlock_unlock)(pthread_rwlock_t *rwlock);
+			const pthread_rwlockattr_t *attr)		= __pthread_rwlock_init;
+static int (*ll_pthread_rwlock_destroy)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_destroy;
+static int (*ll_pthread_rwlock_rdlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_rdlock;
+static int (*ll_pthread_rwlock_tryrdlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_tryrdlock;
+static int (*ll_pthread_rwlock_trywrlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_trywrlock;
+static int (*ll_pthread_rwlock_wrlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_wrlock;
+static int (*ll_pthread_rwlock_unlock)(pthread_rwlock_t *rwlock)	= __pthread_rwlock_unlock;
+
+enum { none, prepare, done, } __init_state;
 
-static bool preload_done;
 static void init_preload(void);
 static void try_init_preload(void)
 {
-	if (!preload_done)
+	if (__init_state != done)
 		init_preload();
 }
 
@@ -76,6 +112,56 @@ static struct rb_node **__get_lock_node(
 	return node;
 }
 
+#ifndef LIBLOCKDEP_STATIC_ENTRIES
+#define LIBLOCKDEP_STATIC_ENTRIES	1024
+#endif
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+static struct lock_lookup __locks[LIBLOCKDEP_STATIC_ENTRIES];
+static int __locks_nr;
+
+static inline bool is_static_lock(struct lock_lookup *lock)
+{
+	return lock >= __locks && lock < __locks + ARRAY_SIZE(__locks);
+}
+
+static struct lock_lookup *alloc_lock(void)
+{
+	if (__init_state != done) {
+		/*
+		 * Some programs attempt to initialize and use locks in their
+		 * allocation path. This means that a call to malloc() would
+		 * result in locks being initialized and locked.
+		 *
+		 * Why is it an issue for us? dlsym() below will try allocating
+		 * to give us the original function. Since this allocation will
+		 * result in a locking operations, we have to let pthread deal
+		 * with it, but we can't! we don't have the pointer to the
+		 * original API since we're inside dlsym() trying to get it :(
+		 */
+
+		/* XXX: can we be concurrent already? if so add lock */
+
+		int idx = __locks_nr++;
+		if (idx >= ARRAY_SIZE(__locks)) {
+			fprintf(stderr,
+		"LOCKDEP error: insufficient LIBLOCKDEP_STATIC_ENTRIES\n");
+
+			exit(EX_UNAVAILABLE);
+		}
+		return __locks + idx;
+	}
+
+	return malloc(sizeof(struct lock_lookup));
+}
+
+static inline void free_lock(struct lock_lookup *lock)
+{
+	if (likely(!is_static_lock(lock)))
+		free(lock);
+}
+
 /**
  * __get_lock - find or create a lock instance
  * @lock: pointer to a pthread lock function
@@ -96,7 +182,7 @@ static struct lock_lookup *__get_lock(vo
 	}
 
 	/* We didn't find the lock, let's create it */
-	l = malloc(sizeof(*l));
+	l = alloc_lock();
 	if (l == NULL)
 		return NULL;
 
@@ -125,7 +211,7 @@ static void __del_lock(struct lock_looku
 	ll_pthread_rwlock_wrlock(&locks_rwlock);
 	rb_erase(&lock->node, &locks);
 	ll_pthread_rwlock_unlock(&locks_rwlock);
-	free(lock);
+	free_lock(lock);
 }
 
 int pthread_mutex_init(pthread_mutex_t *mutex,
@@ -329,40 +415,11 @@ int pthread_rwlock_unlock(pthread_rwlock
 
 __attribute__((constructor)) static void init_preload(void)
 {
-	static bool preload_started;
-
-	if (preload_done)
+	if (__init_state != done)
 		return;
 
-	/*
-	 * Some programs attempt to initialize and use locks in their
-	 * allocation path. This means that a call to malloc() would
-	 * result in locks being initialized and locked.
-	 *
-	 * Why is it an issue for us? dlsym() below will try allocating to
-	 * give us the original function. Since this allocation will result
-	 * in a locking operations, we have to let pthread deal with it,
-	 * but we can't! we don't have the pointer to the original API
-	 * since we're inside dlsym() trying to get it :(
-	 *
-	 * We can work around it by telling the program that locking was
-	 * really okay, and just initialize those locks when we're fully
-	 * up and running (this is ok because this all happens during
-	 * initialization phase, when we have just one thread). But
-	 * this is a big TODO at this point.
-	 */
-	if (preload_started) {
-		printf(
-		"LOCKDEP error: It seems that the program you are trying to "
-		"debug is initializing locks in it's allocation path.\n"
-		"This means that liblockdep cannot reliably analyze this "
-		"program since we need the allocator to work before we can "
-		"debug locks.\nSorry!\n");
-
-		exit(1);
-	}
-
-	preload_started = true;
+#ifndef __GLIBC__
+	__init_state = prepare;
 
 	ll_pthread_mutex_init = dlsym(RTLD_NEXT, "pthread_mutex_init");
 	ll_pthread_mutex_lock = dlsym(RTLD_NEXT, "pthread_mutex_lock");
@@ -377,8 +434,9 @@ __attribute__((constructor)) static void
 	ll_pthread_rwlock_wrlock = dlsym(RTLD_NEXT, "pthread_rwlock_wrlock");
 	ll_pthread_rwlock_trywrlock = dlsym(RTLD_NEXT, "pthread_rwlock_trywrlock");
 	ll_pthread_rwlock_unlock = dlsym(RTLD_NEXT, "pthread_rwlock_unlock");
+#endif
 
 	lockdep_init();
 
-	preload_done = true;
+	__init_state = done;
 }

