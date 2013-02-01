Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab3BAEsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:48:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23320 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3BAEs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:48:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 4/7] liblock: public headers for rwlock implementation
Date: Thu, 31 Jan 2013 23:47:35 -0500
Message-Id: <1359694058-24452-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
References: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both pthreads and lockdep support dealing with rwlocks, so here's the
liblock implementation for those.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/liblock/include/liblock/rwlock.h | 78 ++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/liblock/include/liblock/rwlock.h

diff --git a/tools/lib/liblock/include/liblock/rwlock.h b/tools/lib/liblock/include/liblock/rwlock.h
new file mode 100644
index 0000000..0dbe879
--- /dev/null
+++ b/tools/lib/liblock/include/liblock/rwlock.h
@@ -0,0 +1,78 @@
+#ifndef _LIBLOCK_RWLOCK_H
+#define _LIBLOCK_RWLOCK_H
+
+#include <pthread.h>
+#include "common.h"
+
+struct liblock_pthread_rwlock {
+	pthread_rwlock_t rwlock;
+	struct lockdep_map dep_map;
+};
+
+typedef struct liblock_pthread_rwlock liblock_pthread_rwlock_t;
+
+#define LIBLOCK_PTHREAD_RWLOCK_INITIALIZER(rwl)				\
+		(struct liblock_pthread_rwlock) {			\
+	.rwlock = PTHREAD_RWLOCK_INITIALIZER,				\
+	.dep_map = STATIC_LOCKDEP_MAP_INIT(#rwl, &((&(rwl))->dep_map)),	\
+}
+
+static inline int __rwlock_init(liblock_pthread_rwlock_t *lock,
+				const char *name,
+				struct lock_class_key *key,
+				const pthread_rwlockattr_t *attr)
+{
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+
+	return pthread_rwlock_init(&lock->rwlock, attr);
+}
+
+#define liblock_pthread_rwlock_init(lock, attr)		\
+({							\
+	static struct lock_class_key __key;		\
+							\
+	__rwlock_init((lock), #lock, &__key, (attr));	\
+})
+
+static inline int liblock_pthread_rwlock_rdlock(liblock_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 0, 2, 2, NULL, (unsigned long)ip);
+	return pthread_rwlock_rdlock(&lock->rwlock);
+
+}
+
+static inline int liblock_pthread_rwlock_unlock(liblock_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_release(&lock->dep_map, 0, (unsigned long)ip);
+	return pthread_rwlock_unlock(&lock->rwlock);
+}
+
+static inline int liblock_pthread_rwlock_wrlock(liblock_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)ip);
+	return pthread_rwlock_wrlock(&lock->rwlock);
+}
+
+static inline int liblock_pthread_rwlock_tryrdlock(liblock_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 1, 2, 2, NULL, (unsigned long)ip);
+	return pthread_rwlock_tryrdlock(&lock->rwlock) == 0 ? 1 : 0;
+}
+
+static inline int liblock_pthread_rwlock_trywlock(liblock_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)ip);
+	return pthread_rwlock_trywlock(&lock->rwlock) == 0 ? 1 : 0;
+}
+
+static inline int liblock_rwlock_destroy(liblock_pthread_rwlock_t *lock)
+{
+	return pthread_rwlock_destroy(&lock->rwlock);
+}
+
+#endif
-- 
1.8.1.1

