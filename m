Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab3FMWnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:43:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22287 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302Ab3FMWmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:42:12 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [Patch v5 3/9] liblockdep: Add public headers for pthread_mutex_t implementation
Date: Thu, 13 Jun 2013 18:41:18 -0400
Message-Id: <1371163284-6346-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These headers provide the same API as their pthread mutex
counterparts.

The design here is to allow to easily switch to liblockdep lock
validation just by adding a "liblockdep_" to pthread_mutex_*()
calls, which means that it's easy to integrate liblockdep into
existing codebases.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/include/liblockdep/common.h | 50 +++++++++++++++++++
 tools/lib/lockdep/include/liblockdep/mutex.h  | 70 +++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)
 create mode 100644 tools/lib/lockdep/include/liblockdep/common.h
 create mode 100644 tools/lib/lockdep/include/liblockdep/mutex.h

diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
new file mode 100644
index 0000000..0bda630
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/common.h
@@ -0,0 +1,50 @@
+#ifndef _LIBLOCKDEP_COMMON_H
+#define _LIBLOCKDEP_COMMON_H
+
+#include <pthread.h>
+
+#define NR_LOCKDEP_CACHING_CLASSES 2
+#define MAX_LOCKDEP_SUBCLASSES 8UL
+
+#ifndef CALLER_ADDR0
+#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#endif
+
+#ifndef _RET_IP_
+#define _RET_IP_ CALLER_ADDR0
+#endif
+
+#ifndef _THIS_IP_
+#define _THIS_IP_ ({ __label__ __here; __here: (unsigned long)&&__here; })
+#endif
+
+struct lockdep_subclass_key {
+	char __one_byte;
+};
+
+struct lock_class_key {
+	struct lockdep_subclass_key subkeys[MAX_LOCKDEP_SUBCLASSES];
+};
+
+struct lockdep_map {
+	struct lock_class_key	*key;
+	struct lock_class	*class_cache[NR_LOCKDEP_CACHING_CLASSES];
+	const char		*name;
+#ifdef CONFIG_LOCK_STAT
+	int			cpu;
+	unsigned long		ip;
+#endif
+};
+
+void lockdep_init_map(struct lockdep_map *lock, const char *name,
+			struct lock_class_key *key, int subclass);
+void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
+			int trylock, int read, int check,
+			struct lockdep_map *nest_lock, unsigned long ip);
+void lock_release(struct lockdep_map *lock, int nested,
+			unsigned long ip);
+
+#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
+	{ .name = (_name), .key = (void *)(_key), }
+
+#endif
diff --git a/tools/lib/lockdep/include/liblockdep/mutex.h b/tools/lib/lockdep/include/liblockdep/mutex.h
new file mode 100644
index 0000000..c342f70
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/mutex.h
@@ -0,0 +1,70 @@
+#ifndef _LIBLOCKDEP_MUTEX_H
+#define _LIBLOCKDEP_MUTEX_H
+
+#include <pthread.h>
+#include "common.h"
+
+struct liblockdep_pthread_mutex {
+	pthread_mutex_t mutex;
+	struct lockdep_map dep_map;
+};
+
+typedef struct liblockdep_pthread_mutex liblockdep_pthread_mutex_t;
+
+#define LIBLOCKDEP_PTHREAD_MUTEX_INITIALIZER(mtx)			\
+		(const struct liblockdep_pthread_mutex) {		\
+	.mutex = PTHREAD_MUTEX_INITIALIZER,				\
+	.dep_map = STATIC_LOCKDEP_MAP_INIT(#mtx, &((&(mtx))->dep_map)),	\
+}
+
+static inline int __mutex_init(liblockdep_pthread_mutex_t *lock,
+				const char *name,
+				struct lock_class_key *key,
+				const pthread_mutexattr_t *__mutexattr)
+{
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+	return pthread_mutex_init(&lock->mutex, __mutexattr);
+}
+
+#define liblockdep_pthread_mutex_init(mutex, mutexattr)		\
+({								\
+	static struct lock_class_key __key;			\
+								\
+	__mutex_init((mutex), #mutex, &__key, (mutexattr));	\
+})
+
+static inline int liblockdep_pthread_mutex_lock(liblockdep_pthread_mutex_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_mutex_lock(&lock->mutex);
+}
+
+static inline int liblockdep_pthread_mutex_unlock(liblockdep_pthread_mutex_t *lock)
+{
+	lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
+	return pthread_mutex_unlock(&lock->mutex);
+}
+
+static inline int liblockdep_pthread_mutex_trylock(liblockdep_pthread_mutex_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_mutex_trylock(&lock->mutex) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_pthread_mutex_destroy(liblockdep_pthread_mutex_t *lock)
+{
+	return pthread_mutex_destroy(&lock->mutex);
+}
+
+#ifdef __USE_LIBLOCKDEP
+
+#define pthread_mutex_t         liblockdep_pthread_mutex_t
+#define pthread_mutex_init      liblockdep_pthread_mutex_init
+#define pthread_mutex_lock      liblockdep_pthread_mutex_lock
+#define pthread_mutex_unlock    liblockdep_pthread_mutex_unlock
+#define pthread_mutex_trylock   liblockdep_pthread_mutex_trylock
+#define pthread_mutex_destroy   liblockdep_pthread_mutex_destroy
+
+#endif
+
+#endif
-- 
1.8.1.2

