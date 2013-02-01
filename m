Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3BAEs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:48:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40303 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3BAEs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:48:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 2/7] liblock: public headers for mutex implementation
Date: Thu, 31 Jan 2013 23:47:33 -0500
Message-Id: <1359694058-24452-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
References: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These headers provide the same API as their pthread mutex counterparts.

The design here is to allow to easily switch to liblock lock validation
just by adding a "liblock_" to pthread_mutex_*() calls, which means that
it's easy to integrate liblock into existing codebases.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/liblock/include/liblock/common.h | 42 ++++++++++++++++++++
 tools/lib/liblock/include/liblock/mutex.h  | 62 ++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)
 create mode 100644 tools/lib/liblock/include/liblock/common.h
 create mode 100644 tools/lib/liblock/include/liblock/mutex.h

diff --git a/tools/lib/liblock/include/liblock/common.h b/tools/lib/liblock/include/liblock/common.h
new file mode 100644
index 0000000..a3409d7
--- /dev/null
+++ b/tools/lib/liblock/include/liblock/common.h
@@ -0,0 +1,42 @@
+#ifndef _LIBLOCK_COMMON_H
+#define _LIBLOCK_COMMON_H
+
+#include <pthread.h>
+
+#define CALLER_ADDR0 (__builtin_return_address(0))
+#define _THIS_IP_ CALLER_ADDR0
+#define NR_LOCKDEP_CACHING_CLASSES 2
+#define MAX_LOCKDEP_SUBCLASSES 8UL
+
+struct lockdep_subclass_key {
+	char __one_byte;
+};
+
+struct lock_class_key {
+	struct lockdep_subclass_key     subkeys[MAX_LOCKDEP_SUBCLASSES];
+};
+
+struct lockdep_map {
+	struct lock_class_key           *key;
+	struct lock_class               *class_cache[NR_LOCKDEP_CACHING_CLASSES];
+	const char                      *name;
+#ifdef CONFIG_LOCK_STAT
+	int                             cpu;
+	unsigned long                   ip;
+#endif
+};
+
+void liblock_init(void);
+void liblock_set_thread(void);
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
diff --git a/tools/lib/liblock/include/liblock/mutex.h b/tools/lib/liblock/include/liblock/mutex.h
new file mode 100644
index 0000000..d350733
--- /dev/null
+++ b/tools/lib/liblock/include/liblock/mutex.h
@@ -0,0 +1,62 @@
+#ifndef _LIBLOCK_MUTEX_H
+#define _LIBLOCK_MUTEX_H
+
+#include <pthread.h>
+#include "common.h"
+
+struct liblock_pthread_mutex {
+	pthread_mutex_t mutex;
+	struct lockdep_map dep_map;
+};
+
+typedef struct liblock_pthread_mutex liblock_pthread_mutex_t;
+
+#define LIBLOCK_PTHREAD_MUTEX_INITIALIZER(mtx)				\
+		(const struct liblock_pthread_mutex) {			\
+	.mutex = PTHREAD_MUTEX_INITIALIZER,				\
+	.dep_map = STATIC_LOCKDEP_MAP_INIT(#mtx, &((&(mtx))->dep_map)),	\
+}
+
+static inline int __mutex_init(liblock_pthread_mutex_t *lock,
+				const char *name,
+				struct lock_class_key *key,
+				const pthread_mutexattr_t *__mutexattr)
+{
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+	return pthread_mutex_init(&lock->mutex, __mutexattr);
+}
+
+#define liblock_pthread_mutex_init(mutex, mutexattr) 		\
+({								\
+	static struct lock_class_key __key;			\
+    								\
+	__mutex_init((mutex), #mutex, &__key, (mutexattr));	\
+})
+
+static inline int liblock_pthread_mutex_lock(liblock_pthread_mutex_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)ip);
+	return pthread_mutex_lock(&lock->mutex);
+}
+
+static inline int liblock_pthread_mutex_unlock(liblock_pthread_mutex_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_release(&lock->dep_map, 0, (unsigned long)ip);
+	return pthread_mutex_unlock(&lock->mutex);
+}
+
+static inline int liblock_pthread_mutex_trylock(liblock_pthread_mutex_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)ip);
+	return pthread_mutex_trylock(&lock->mutex) == 0 ? 1 : 0;
+}
+
+static inline int liblock_pthread_mutex_destroy(liblock_pthread_mutex_t *lock)
+{
+	return pthread_mutex_destroy(&lock->mutex);
+}
+
+#endif
-- 
1.8.1.1

