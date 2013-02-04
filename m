Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3BDNvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:51:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3BDNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:51:45 -0500
Date: Mon, 4 Feb 2013 05:51:29 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-0ebd64ee0f225028c5a97581cdfeeb15931ec35c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1359942644-26371-2-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-2-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep:
  Add public headers for pthread_mutex_t implementation
Git-Commit-ID: 0ebd64ee0f225028c5a97581cdfeeb15931ec35c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:51:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ebd64ee0f225028c5a97581cdfeeb15931ec35c
Gitweb:     http://git.kernel.org/tip/0ebd64ee0f225028c5a97581cdfeeb15931ec35c
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sun, 3 Feb 2013 20:50:39 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:39:04 +0100

liblockdep: Add public headers for pthread_mutex_t implementation

These headers provide the same API as their pthread mutex
counterparts.

The design here is to allow to easily switch to liblockdep lock
validation just by adding a "liblockdep_" to pthread_mutex_*()
calls, which means that it's easy to integrate liblockdep into
existing codebases.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1359942644-26371-2-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/include/liblockdep/common.h | 42 +++++++++++++++
 tools/lib/lockdep/include/liblockdep/mutex.h  | 73 +++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
new file mode 100644
index 0000000..b72f9c1
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/common.h
@@ -0,0 +1,42 @@
+#ifndef _LIBLOCKDEP_COMMON_H
+#define _LIBLOCKDEP_COMMON_H
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
+void liblockdep_init(void);
+void liblockdep_set_thread(void);
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
index 0000000..5154a9d
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/mutex.h
@@ -0,0 +1,73 @@
+#ifndef _LIBLOCKDEP_MUTEX_H
+#define _LIBLOCKDEP_MUTEX_H
+
+#ifdef __USE_LIBLOCKDEP
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
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)ip);
+	return pthread_mutex_lock(&lock->mutex);
+}
+
+static inline int liblockdep_pthread_mutex_unlock(liblockdep_pthread_mutex_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_release(&lock->dep_map, 0, (unsigned long)ip);
+	return pthread_mutex_unlock(&lock->mutex);
+}
+
+static inline int liblockdep_pthread_mutex_trylock(liblockdep_pthread_mutex_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)ip);
+	return pthread_mutex_trylock(&lock->mutex) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_pthread_mutex_destroy(liblockdep_pthread_mutex_t *lock)
+{
+	return pthread_mutex_destroy(&lock->mutex);
+}
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
