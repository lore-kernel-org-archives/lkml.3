Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3BKMbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:31:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60355 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3BKMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:31:40 -0500
Date: Mon, 11 Feb 2013 04:31:23 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-eb1aa2ea7da68149bd9ec4491379a81277127ac0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-9-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-9-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Support using LD_PRELOAD
Git-Commit-ID: eb1aa2ea7da68149bd9ec4491379a81277127ac0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:31:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb1aa2ea7da68149bd9ec4491379a81277127ac0
Gitweb:     http://git.kernel.org/tip/eb1aa2ea7da68149bd9ec4491379a81277127ac0
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:39 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:40 +0100

liblockdep: Support using LD_PRELOAD

This allows lockdep to be used without being compiled in the
original program.

Usage is quite simple:

	LD_PRELOAD=/path/to/liblockdep.so /path/to/my/program

And magically, you'll have lockdep checking in your program!

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: jamie.iles@oracle.com
Cc: penberg@kernel.org
Cc: acme@ghostprotocols.net
Cc: paulus@samba.org
Cc: namhyung@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1360456781-32462-9-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/Makefile  |   4 +-
 tools/lib/lockdep/preload.c | 209 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 211 insertions(+), 2 deletions(-)

diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index e82ffe9..245f8ba 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -143,7 +143,7 @@ do_app_build =						\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ -o $@)
+	$(CC) --shared -ldl $^ -o $@)
 
 do_build_static_lib =				\
 	($(print_static_lib_build)		\
@@ -161,7 +161,7 @@ $(obj)/%.o: $(src)/%.c
 %.o: $(src)/%.c
 	$(Q)$(call do_compile)
 
-PEVENT_LIB_OBJS = common.o lockdep.o
+PEVENT_LIB_OBJS = common.o lockdep.o preload.o rbtree.o
 
 ALL_OBJS = $(PEVENT_LIB_OBJS)
 
diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
new file mode 100644
index 0000000..b65a3f3
--- /dev/null
+++ b/tools/lib/lockdep/preload.c
@@ -0,0 +1,209 @@
+#define _GNU_SOURCE
+#include <pthread.h>
+#include <stdio.h>
+#include <dlfcn.h>
+#include <stdlib.h>
+#include "include/liblockdep/mutex.h"
+#include "../../../include/linux/rbtree.h"
+
+struct lock_lookup {
+	void *orig;
+	struct lockdep_map dep_map;
+	struct rb_node node;
+};
+
+struct rb_root locks = RB_ROOT;
+
+int (*ll_pthread_mutex_init)(pthread_mutex_t *mutex,
+			const pthread_mutexattr_t *attr);
+int (*ll_pthread_mutex_lock)(pthread_mutex_t *mutex);
+int (*ll_pthread_mutex_trylock)(pthread_mutex_t *mutex);
+int (*ll_pthread_mutex_unlock)(pthread_mutex_t *mutex);
+int (*ll_pthread_mutex_destroy)(pthread_mutex_t *mutex);
+
+int (*ll_pthread_rwlock_init)(pthread_rwlock_t *rwlock,
+			const pthread_rwlockattr_t *attr);
+int (*ll_pthread_rwlock_destroy)(pthread_rwlock_t *rwlock);
+int (*ll_pthread_rwlock_rdlock)(pthread_rwlock_t *rwlock);
+int (*ll_pthread_rwlock_tryrdlock)(pthread_rwlock_t *rwlock);
+int (*ll_pthread_rwlock_trywrlock)(pthread_rwlock_t *rwlock);
+int (*ll_pthread_rwlock_wrlock)(pthread_rwlock_t *rwlock);
+int (*ll_pthread_rwlock_unlock)(pthread_rwlock_t *rwlock);
+
+static void init_preload();
+
+static struct lock_lookup *__get_lock(void *lock)
+{
+	struct rb_node **node = &locks.rb_node, *parent = NULL;
+	struct lock_lookup *l;
+
+	while (*node) {
+		l = rb_entry(*node, struct lock_lookup, node);
+
+		parent = *node;
+		if (lock < l->orig)
+			node = &l->node.rb_left;
+		else if (lock > l->orig)
+			node = &l->node.rb_right;
+		else
+			return l;
+	}
+
+	l = malloc(sizeof(*l));
+	if (l == NULL)
+		return NULL;
+
+	*l = (struct lock_lookup) {
+		.orig = lock,
+		.dep_map = STATIC_LOCKDEP_MAP_INIT("lock", &l->dep_map),
+	};
+
+	rb_link_node(&l->node, parent, node);
+	rb_insert_color(&l->node, &locks);
+
+	return l;
+}
+
+int pthread_mutex_init(pthread_mutex_t *mutex,
+			const pthread_mutexattr_t *attr)
+{
+	init_preload();
+
+	__get_lock(mutex);
+	return ll_pthread_mutex_init(mutex, attr);
+}
+
+int pthread_mutex_lock(pthread_mutex_t *mutex)
+{
+	void *ip = _THIS_IP_;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(mutex)->dep_map, 0, 0, 0, 2, NULL, (unsigned long)ip);
+	return ll_pthread_mutex_lock(mutex);
+}
+
+int pthread_mutex_trylock(pthread_mutex_t *mutex)
+{
+	void *ip = _THIS_IP_;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(mutex)->dep_map, 0, 1, 0, 2, NULL, (unsigned long)ip);
+	return ll_pthread_mutex_trylock(mutex);
+}
+
+int pthread_mutex_unlock(pthread_mutex_t *mutex)
+{
+	void *ip = _THIS_IP_;
+
+        init_preload();
+
+	lock_release(&__get_lock(mutex)->dep_map, 0, (unsigned long)ip);
+	return ll_pthread_mutex_unlock(mutex);
+}
+
+int pthread_mutex_destroy(pthread_mutex_t *mutex)
+{
+	struct lock_lookup *l = __get_lock(mutex);
+
+        init_preload();
+
+	rb_erase(&l->node, &locks);
+	free(l);
+	return ll_pthread_mutex_destroy(mutex);
+}
+
+int pthread_rwlock_init(pthread_rwlock_t *rwlock,
+			const pthread_rwlockattr_t *attr)
+{
+        init_preload();
+
+	__get_lock(rwlock);
+	return ll_pthread_rwlock_init(rwlock, attr);
+}
+
+int pthread_rwlock_destroy(pthread_rwlock_t *rwlock)
+{
+	struct lock_lookup *l = __get_lock(rwlock);
+
+        init_preload();
+
+	rb_erase(&l->node, &locks);
+	free(l);
+	return ll_pthread_rwlock_destroy(rwlock);
+}
+
+int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock)
+{
+	void *ip = _THIS_IP_;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 2, 2, NULL, (unsigned long)ip);
+	return ll_pthread_rwlock_rdlock(rwlock);
+}
+
+int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock)
+{
+	void *ip = _THIS_IP_;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 2, 2, NULL, (unsigned long)ip);
+	return ll_pthread_rwlock_tryrdlock(rwlock);
+}
+
+int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock)
+{
+	void *ip = _THIS_IP_;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 1, 0, 2, NULL, (unsigned long)ip);
+	return ll_pthread_rwlock_trywrlock(rwlock);
+}
+
+int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock)
+{
+	void *ip = _THIS_IP_;
+
+        init_preload();
+
+	lock_acquire(&__get_lock(rwlock)->dep_map, 0, 0, 0, 2, NULL, (unsigned long)ip);
+	return ll_pthread_rwlock_wrlock(rwlock);
+}
+
+int pthread_rwlock_unlock(pthread_rwlock_t *rwlock)
+{
+	void *ip = _THIS_IP_;
+
+        init_preload();
+
+	lock_release(&__get_lock(rwlock)->dep_map, 0, (unsigned long)ip);
+	return ll_pthread_rwlock_unlock(rwlock);
+}
+
+__attribute__((constructor)) static void init_preload(void)
+{
+	static bool preload_done;
+
+	if (preload_done)
+		return;
+
+	ll_pthread_mutex_init = dlsym(RTLD_NEXT, "pthread_mutex_init");
+	ll_pthread_mutex_lock = dlsym(RTLD_NEXT, "pthread_mutex_lock");
+	ll_pthread_mutex_trylock = dlsym(RTLD_NEXT, "pthread_mutex_trylock");
+	ll_pthread_mutex_unlock = dlsym(RTLD_NEXT, "pthread_mutex_unlock");
+	ll_pthread_mutex_destroy = dlsym(RTLD_NEXT, "pthread_mutex_destroy");
+
+	ll_pthread_rwlock_init = dlsym(RTLD_NEXT, "pthread_rwlock_init");
+	ll_pthread_rwlock_destroy = dlsym(RTLD_NEXT, "pthread_rwlock_destroy");
+	ll_pthread_rwlock_rdlock = dlsym(RTLD_NEXT, "pthread_rwlock_rdlock");
+	ll_pthread_rwlock_tryrdlock = dlsym(RTLD_NEXT, "pthread_rwlock_tryrdlock");
+	ll_pthread_rwlock_wrlock = dlsym(RTLD_NEXT, "pthread_rwlock_wrlock");
+	ll_pthread_rwlock_trywrlock = dlsym(RTLD_NEXT, "pthread_rwlock_trywrlock");
+	ll_pthread_rwlock_unlock = dlsym(RTLD_NEXT, "pthread_rwlock_unlock");
+
+	preload_done = true;
+}
