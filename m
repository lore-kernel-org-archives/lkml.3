Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3EPDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 23:16:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23507 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3EPDQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 23:16:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v4 5/9] liblockdep: Add public headers for pthread_rwlock_t implementation
Date: Wed, 15 May 2013 23:15:37 -0400
Message-Id: <1368674141-10796-6-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both pthreads and lockdep support dealing with rwlocks, so
here's the liblockdep implementation for those.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/include/liblockdep/rwlock.h | 86 +++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100644 tools/lib/lockdep/include/liblockdep/rwlock.h

diff --git a/tools/lib/lockdep/include/liblockdep/rwlock.h b/tools/lib/lockdep/include/liblockdep/rwlock.h
new file mode 100644
index 0000000..a680ab8
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/rwlock.h
@@ -0,0 +1,86 @@
+#ifndef _LIBLOCKDEP_RWLOCK_H
+#define _LIBLOCKDEP_RWLOCK_H
+
+#include <pthread.h>
+#include "common.h"
+
+struct liblockdep_pthread_rwlock {
+	pthread_rwlock_t rwlock;
+	struct lockdep_map dep_map;
+};
+
+typedef struct liblockdep_pthread_rwlock liblockdep_pthread_rwlock_t;
+
+#define LIBLOCKDEP_PTHREAD_RWLOCK_INITIALIZER(rwl)			\
+		(struct liblockdep_pthread_rwlock) {			\
+	.rwlock = PTHREAD_RWLOCK_INITIALIZER,				\
+	.dep_map = STATIC_LOCKDEP_MAP_INIT(#rwl, &((&(rwl))->dep_map)),	\
+}
+
+static inline int __rwlock_init(liblockdep_pthread_rwlock_t *lock,
+				const char *name,
+				struct lock_class_key *key,
+				const pthread_rwlockattr_t *attr)
+{
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+
+	return pthread_rwlock_init(&lock->rwlock, attr);
+}
+
+#define liblockdep_pthread_rwlock_init(lock, attr)		\
+({							\
+	static struct lock_class_key __key;		\
+							\
+	__rwlock_init((lock), #lock, &__key, (attr));	\
+})
+
+static inline int liblockdep_pthread_rwlock_rdlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 0, 2, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_rwlock_rdlock(&lock->rwlock);
+
+}
+
+static inline int liblockdep_pthread_rwlock_unlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
+	return pthread_rwlock_unlock(&lock->rwlock);
+}
+
+static inline int liblockdep_pthread_rwlock_wrlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_rwlock_wrlock(&lock->rwlock);
+}
+
+static inline int liblockdep_pthread_rwlock_tryrdlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 1, 2, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_rwlock_tryrdlock(&lock->rwlock) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_pthread_rwlock_trywlock(liblockdep_pthread_rwlock_t *lock)
+{
+	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
+	return pthread_rwlock_trywlock(&lock->rwlock) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_rwlock_destroy(liblockdep_pthread_rwlock_t *lock)
+{
+	return pthread_rwlock_destroy(&lock->rwlock);
+}
+
+#ifdef __USE_LIBLOCKDEP
+
+#define pthread_rwlock_t		liblockdep_pthread_rwlock_t
+#define pthread_rwlock_init		liblockdep_pthread_rwlock_init
+#define pthread_rwlock_rdlock		liblockdep_pthread_rwlock_rdlock
+#define pthread_rwlock_unlock		liblockdep_pthread_rwlock_unlock
+#define pthread_rwlock_wrlock		liblockdep_pthread_rwlock_wrlock
+#define pthread_rwlock_tryrdlock	liblockdep_pthread_rwlock_tryrdlock
+#define pthread_rwlock_trywlock		liblockdep_pthread_rwlock_trywlock
+#define pthread_rwlock_destroy		liblockdep_rwlock_destroy
+
+#endif
+
+#endif
-- 
1.8.2.1

