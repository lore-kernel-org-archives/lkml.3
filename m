Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3EJLSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:18:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58593
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab3EJLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:18:54 -0400
Date: Fri, 10 May 2013 13:17:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130510111719.GG31235@dyad.programming.kicks-ass.net>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-8-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368115089-8909-8-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:58:07AM -0400, Sasha Levin wrote:
> +	/*
> +	 * Some programs attempt to initialize and use locks in their
> +	 * allocation path. This means that a call to malloc() would
> +	 * result in locks being initialized and locked.
> +	 *
> +	 * Why is it an issue for us? dlsym() below will try allocating to
> +	 * give us the original function. Since this allocation will result
> +	 * in a locking operations, we have to let pthread deal with it,
> +	 * but we can't! we don't have the pointer to the original API
> +	 * since we're inside dlsym() trying to get it :(
> +	 *
> +	 * We can work around it by telling the program that locking was
> +	 * really okay, and just initialize those locks when we're fully
> +	 * up and running (this is ok because this all happens during
> +	 * initialization phase, when we have just one thread). But
> +	 * this is a big TODO at this point.
> +	 */
> +	if (preload_started) {
> +		printf(
> +		"LOCKDEP error: It seems that the program you are trying to "
> +		"debug is initializing locks in it's allocation path.\n"
> +		"This means that liblockdep cannot reliably analyze this "
> +		"program since we need the allocator to work before we can "
> +		"debug locks.\nSorry!\n");
> +
> +		exit(1);
> +	}


Would something like the below cure things? Obviously this hasn't been near a
compiler for the entire thing still isn't wanting to compile for me.

---
--- a/tools/lib/lockdep/preload.c
+++ b/tools/lib/lockdep/preload.c
@@ -1,4 +1,5 @@
 #define _GNU_SOURCE
+#include <sysexits.h>
 #include <pthread.h>
 #include <stdio.h>
 #include <dlfcn.h>
@@ -46,11 +47,12 @@ static int (*ll_pthread_rwlock_trywrlock
 static int (*ll_pthread_rwlock_wrlock)(pthread_rwlock_t *rwlock);
 static int (*ll_pthread_rwlock_unlock)(pthread_rwlock_t *rwlock);
 
-static bool preload_done;
+enum { none, prepare, done, } __init_state;
+
 static void init_preload(void);
 static void try_init_preload(void)
 {
-	if (!preload_done)
+	if (__init_state != done)
 		init_preload();
 }
 
@@ -76,6 +78,54 @@ static struct rb_node **__get_lock_node(
 	return node;
 }
 
+#ifndef LIBLOCKDEP_STATIC_ENTRIES
+#define LIBLOCKDEP_STATIC_ENTRIES	1024
+#endif 
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
+	if (unlikely(__init_state != done)) {
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
+	return malloc(sizeof(*lock));
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
@@ -96,7 +146,7 @@ static struct lock_lookup *__get_lock(vo
 	}
 
 	/* We didn't find the lock, let's create it */
-	l = malloc(sizeof(*l));
+	l = alloc_lock();
 	if (l == NULL)
 		return NULL;
 
@@ -125,7 +175,7 @@ static void __del_lock(struct lock_looku
 	ll_pthread_rwlock_wrlock(&locks_rwlock);
 	rb_erase(&lock->node, &locks);
 	ll_pthread_rwlock_unlock(&locks_rwlock);
-	free(lock);
+	free_lock(lock);
 }
 
 int pthread_mutex_init(pthread_mutex_t *mutex,
@@ -329,40 +379,10 @@ int pthread_rwlock_unlock(pthread_rwlock
 
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
+	__init_state = prepare;
 
 	ll_pthread_mutex_init = dlsym(RTLD_NEXT, "pthread_mutex_init");
 	ll_pthread_mutex_lock = dlsym(RTLD_NEXT, "pthread_mutex_lock");
@@ -380,5 +400,5 @@ __attribute__((constructor)) static void
 
 	lockdep_init();
 
-	preload_done = true;
+	__init_state = done;
 }

