Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3GXUNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:13:36 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20962 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GXUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:13:31 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v2 3/3] qrwlock: Optionally enable classic read/write lock behavior
Date: Wed, 24 Jul 2013 16:12:26 -0400
Message-Id: <1374696746-40184-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374696746-40184-1-git-send-email-Waiman.Long@hp.com>
References: <1374696746-40184-1-git-send-email-Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, queue read/write lock is fair with respect to both the
readers and writers. However, there are situations where a bias
towards readers can increase throughput especially for reader-heavy
situations. There may also be cases where deviation from the classic
read/write lock behavior may cause problem like recursive read lock
in an interrupt handler with a waiting writer. Using the classic
behavior, however, will cause the queue read/write lock to lose some
of the fairness attribute that it has.

This patch enables lock owners to decide what behavior do they want
for their read/write lock by using the appropriate initializer. Two
types of initializers will be provided:
1. Default - fair to both readers and writers
2. Classic - readers that come after a waiting writer can steal
	     the lock

The classic initializers have a "_classic" suffix. If the queue
read/write lock feature is not enabled, the classic initializer will
be the same as the default initializer.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/rwlock.h         |   15 +++++++++++++++
 include/linux/rwlock_types.h   |   12 +++++++++++-
 include/linux/spinlock_types.h |    4 ++++
 lib/spinlock_debug.c           |   20 ++++++++++++++++++++
 4 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/include/linux/rwlock.h b/include/linux/rwlock.h
index bc2994e..234305a 100644
--- a/include/linux/rwlock.h
+++ b/include/linux/rwlock.h
@@ -23,9 +23,24 @@ do {								\
 								\
 	__rwlock_init((lock), #lock, &__key);			\
 } while (0)
+
+# ifdef CONFIG_QUEUE_RWLOCK
+  extern void __rwlock_init_classic(rwlock_t *lock, const char *name,
+				    struct lock_class_key *key);
+#  define rwlock_init_classic(lock)				\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	__rwlock_init_classic((lock), #lock, &__key);		\
+} while (0)
+# else
+#  define __rwlock_init_classic(l,n,k)	__rwlock_init(l,n,k)
+# endif /* CONFIG_QUEUE_RWLOCK */
 #else
 # define rwlock_init(lock)					\
 	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
+# define rwlock_init_classic(lock)				\
+	do { *(lock) = __RW_LOCK_UNLOCKED_CLASSIC(lock); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
diff --git a/include/linux/rwlock_types.h b/include/linux/rwlock_types.h
index cc0072e..0b1bd3b 100644
--- a/include/linux/rwlock_types.h
+++ b/include/linux/rwlock_types.h
@@ -37,12 +37,22 @@ typedef struct {
 				.owner = SPINLOCK_OWNER_INIT,		\
 				.owner_cpu = -1,			\
 				RW_DEP_MAP_INIT(lockname) }
+#define __RW_LOCK_UNLOCKED_CLASSIC(lockname)				\
+	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED_CLASSIC,\
+				.magic = RWLOCK_MAGIC,			\
+				.owner = SPINLOCK_OWNER_INIT,		\
+				.owner_cpu = -1,			\
+				RW_DEP_MAP_INIT(lockname) }
 #else
 #define __RW_LOCK_UNLOCKED(lockname) \
 	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED,	\
 				RW_DEP_MAP_INIT(lockname) }
+#define __RW_LOCK_UNLOCKED_CLASSIC(lockname) \
+	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED_CLASSIC,\
+				RW_DEP_MAP_INIT(lockname) }
 #endif
 
-#define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
+#define DEFINE_RWLOCK(x)	 rwlock_t x = __RW_LOCK_UNLOCKED(x)
+#define DEFINE_RWLOCK_CLASSIC(x) rwlock_t x = __RW_LOCK_UNLOCKED_CLASSIC(x)
 
 #endif /* __LINUX_RWLOCK_TYPES_H */
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 73548eb..ff5554f 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -85,4 +85,8 @@ typedef struct spinlock {
 
 #include <linux/rwlock_types.h>
 
+#ifndef	__ARCH_RW_LOCK_UNLOCKED_CLASSIC
+#define	__ARCH_RW_LOCK_UNLOCKED_CLASSIC	__ARCH_RW_LOCK_UNLOCKED
+#endif
+
 #endif /* __LINUX_SPINLOCK_TYPES_H */
diff --git a/lib/spinlock_debug.c b/lib/spinlock_debug.c
index 0374a59..a765f17 100644
--- a/lib/spinlock_debug.c
+++ b/lib/spinlock_debug.c
@@ -49,6 +49,26 @@ void __rwlock_init(rwlock_t *lock, const char *name,
 
 EXPORT_SYMBOL(__rwlock_init);
 
+#ifdef CONFIG_QUEUE_RWLOCK
+void __rwlock_init_classic(rwlock_t *lock, const char *name,
+			   struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
+	lockdep_init_map(&lock->dep_map, name, key, 0);
+#endif
+	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED_CLASSIC;
+	lock->magic = RWLOCK_MAGIC;
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+
+EXPORT_SYMBOL(__rwlock_init_classic);
+#endif /* CONFIG_QUEUE_RWLOCK */
+
 static void spin_dump(raw_spinlock_t *lock, const char *msg)
 {
 	struct task_struct *owner = NULL;
-- 
1.7.1

