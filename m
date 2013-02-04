Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3BDNyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:54:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BDNyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:54:14 -0500
Date: Mon, 4 Feb 2013 05:53:54 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-7fc788818c8f317c3a9d3331382aeecf4b726a3c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1359942644-26371-4-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-4-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep:
  Add public headers for pthread_rwlock_t implementation
Git-Commit-ID: 7fc788818c8f317c3a9d3331382aeecf4b726a3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:53:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fc788818c8f317c3a9d3331382aeecf4b726a3c
Gitweb:     http://git.kernel.org/tip/7fc788818c8f317c3a9d3331382aeecf4b726a3c
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sun, 3 Feb 2013 20:50:41 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:39:06 +0100

liblockdep: Add public headers for pthread_rwlock_t implementation

Both pthreads and lockdep support dealing with rwlocks, so
here's the liblockdep implementation for those.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1359942644-26371-4-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/lib/lockdep/include/liblockdep/rwlock.h | 91 +++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/tools/lib/lockdep/include/liblockdep/rwlock.h b/tools/lib/lockdep/include/liblockdep/rwlock.h
new file mode 100644
index 0000000..26f9a68
--- /dev/null
+++ b/tools/lib/lockdep/include/liblockdep/rwlock.h
@@ -0,0 +1,91 @@
+#ifndef _LIBLOCKDEP_RWLOCK_H
+#define _LIBLOCKDEP_RWLOCK_H
+
+#ifdef __USE_LIBLOCKDEP
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
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 0, 2, 2, NULL, (unsigned long)ip);
+	return pthread_rwlock_rdlock(&lock->rwlock);
+
+}
+
+static inline int liblockdep_pthread_rwlock_unlock(liblockdep_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_release(&lock->dep_map, 0, (unsigned long)ip);
+	return pthread_rwlock_unlock(&lock->rwlock);
+}
+
+static inline int liblockdep_pthread_rwlock_wrlock(liblockdep_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 0, 0, 2, NULL, (unsigned long)ip);
+	return pthread_rwlock_wrlock(&lock->rwlock);
+}
+
+static inline int liblockdep_pthread_rwlock_tryrdlock(liblockdep_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 1, 2, 2, NULL, (unsigned long)ip);
+	return pthread_rwlock_tryrdlock(&lock->rwlock) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_pthread_rwlock_trywlock(liblockdep_pthread_rwlock_t *lock)
+{
+	void *ip = _THIS_IP_;
+	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)ip);
+	return pthread_rwlock_trywlock(&lock->rwlock) == 0 ? 1 : 0;
+}
+
+static inline int liblockdep_rwlock_destroy(liblockdep_pthread_rwlock_t *lock)
+{
+	return pthread_rwlock_destroy(&lock->rwlock);
+}
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
