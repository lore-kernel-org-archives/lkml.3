Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3JBOKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:10:06 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:4842 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3JBOJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:09:48 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 3/3] qrwlock: Enable fair queue read/write lock
Date: Wed,  2 Oct 2013 10:09:06 -0400
Message-Id: <1380722946-30468-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
References: <1380722946-30468-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, queue rwlock is fair among writers and gives preference
to readers allowing them to steal lock even if a writer is
waiting. However, there is a desire to have a fair variant of
rwlock that is more deterministic. To enable this, fair variants
of lock initializers are added by this patch to allow lock owners
to choose to use fair rwlock. These newly added initializers all
have the _fair or _FAIR suffix to indicate the desire to use a fair
rwlock. If the QUEUE_RWLOCK config option is not selected, the fair
rwlock initializers will be the same as the regular ones.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/rwlock.h       |   15 +++++++++++++++
 include/linux/rwlock_types.h |   13 +++++++++++++
 lib/spinlock_debug.c         |   19 +++++++++++++++++++
 3 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index bc2994e..5f2628b 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -23,9 +23,24 @@ do {								\
 								\
 	__rwlock_init((lock), #lock, &__key);			\
 } while (0)
+
+# ifdef CONFIG_QUEUE_RWLOCK
+extern void __rwlock_init_fair(rwlock_t *lock, const char *name,
+			       struct lock_class_key *key);
+#  define rwlock_init_fair(lock)				\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	__rwlock_init_fair((lock), #lock, &__key);		\
+} while (0)
+# else
+#  define __rwlock_init_fair(l, n, k)	__rwlock_init(l, n, k)
+# endif /* CONFIG_QUEUE_RWLOCK */
 #else
 # define rwlock_init(lock)					\
 	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
+# define rwlock_init_fair(lock)				\
+	do { *(lock) = __RW_LOCK_UNLOCKED_FAIR(lock); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
diff --git a/include/linux/rwlock_types.h b/include/linux/rwlock_types.h
index cc0072e..d27c812 100644
--- a/include/linux/rwlock_types.h
+++ b/include/linux/rwlock_types.h
@@ -37,12 +37,25 @@ typedef struct {
 				.owner = SPINLOCK_OWNER_INIT,		\
 				.owner_cpu = -1,			\
 				RW_DEP_MAP_INIT(lockname) }
+#define __RW_LOCK_UNLOCKED_FAIR(lockname)				\
+	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED_FAIR,\
+				.magic = RWLOCK_MAGIC,			\
+				.owner = SPINLOCK_OWNER_INIT,		\
+				.owner_cpu = -1,			\
+				RW_DEP_MAP_INIT(lockname) }
 #else
 #define __RW_LOCK_UNLOCKED(lockname) \
 	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED,	\
 				RW_DEP_MAP_INIT(lockname) }
+#define __RW_LOCK_UNLOCKED_FAIR(lockname) \
+	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED_FAIR,\
+				RW_DEP_MAP_INIT(lockname) }
 #endif
 
 #define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
+#define DEFINE_RWLOCK_FAIR(x)	rwlock_t x = __RW_LOCK_UNLOCKED_FAIR(x)
 
+#ifndef	__ARCH_RW_LOCK_UNLOCKED_FAIR
+#define	__ARCH_RW_LOCK_UNLOCKED_FAIR	__ARCH_RW_LOCK_UNLOCKED
+#endif
 #endif /* __LINUX_RWLOCK_TYPES_H */
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 0374a59..d6ef7ce 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -49,6 +49,25 @@ void __rwlock_init(rwlock_t *lock, const char *name,
 
 EXPORT_SYMBOL(__rwlock_init);
 
+#ifdef CONFIG_QUEUE_RWLOCK
+void __rwlock_init_fair(rwlock_t *lock, const char *name,
+			struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+#endif
+	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED_FAIR;
+	lock->magic = RWLOCK_MAGIC;
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+EXPORT_SYMBOL(__rwlock_init_fair);
+#endif /* CONFIG_QUEUE_RWLOCK */
+
 static void spin_dump(raw_spinlock_t *lock, const char *msg)
 {
 	struct task_struct *owner = NULL;
-- 
1.7.1

