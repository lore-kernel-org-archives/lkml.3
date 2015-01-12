Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbbALO5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:57:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38156 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbALO5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:57:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC 3/4] locking/rwsem: additional lock information when dumping locks
Date: Mon, 12 Jan 2015 09:57:10 -0500
Message-Id: <1421074631-18831-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
References: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the counter and the owner of the lock when dumping held locks in the
system.

This is useful to figure out who really holds a lock and how many waiters
it has.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/lockdep.h         |    2 +-
 include/linux/rwsem.h           |    3 ++-
 kernel/locking/lockdep.c        |    5 +++++
 kernel/locking/rwsem-spinlock.c |    7 ++++++-
 kernel/locking/rwsem-xadd.c     |    2 +-
 kernel/locking/rwsem.c          |   15 +++++++++++++++
 6 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index cab929b..4527f99 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -143,7 +143,7 @@ struct lock_class_stats lock_stats(struct lock_class *class);
 void clear_lock_stats(struct lock_class *class);
 #endif
 
-enum LOCK_TYPE { LOCKTYPE_NONE, LOCKTYPE_MUTEX, };
+enum LOCK_TYPE { LOCKTYPE_NONE, LOCKTYPE_MUTEX, LOCKTYPE_RWSEM, };
 
 /*
  * Map the lock object (the lock instance) to the lock-class object.
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 8f498cd..68732af 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -60,7 +60,8 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 /* Common initializer macros and functions */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+extern void rwsem_print_debug(const struct rw_semaphore *sem);
+# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname, .type = LOCKTYPE_RWSEM }
 #else
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 07c337d..e75f83b 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -511,6 +511,7 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 static void get_lock_info(enum LOCK_TYPE t, struct lockdep_map *map)
 {
 	struct mutex *mtx;
+	struct rw_semaphore *rw;
 
 	switch (t) {
 	case LOCKTYPE_NONE: break;
@@ -518,6 +519,10 @@ static void get_lock_info(enum LOCK_TYPE t, struct lockdep_map *map)
 		mtx = container_of(map, struct mutex, dep_map);
 		mutex_print_debug(mtx);
 		break;
+	case LOCKTYPE_RWSEM:
+		rw = container_of(map, struct rw_semaphore, dep_map);
+		rwsem_print_debug(rw);
+		break;
 	}
 }
 
diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
index 2c93571..b07029e 100644
--- a/kernel/locking/rwsem-spinlock.c
+++ b/kernel/locking/rwsem-spinlock.c
@@ -44,7 +44,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	 * Make sure we are not reinitializing a held semaphore:
 	 */
 	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
-	lockdep_init_map(&sem->dep_map, name, key, 0);
+	lockdep_init_map_type(&sem->dep_map, name, key, 0, LOCKTYPE_RWSEM);
 #endif
 	sem->count = 0;
 	raw_spin_lock_init(&sem->wait_lock);
@@ -294,3 +294,8 @@ void __downgrade_write(struct rw_semaphore *sem)
 	raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
+void rwsem_print_debug(const struct rw_semaphore *sem)
+{
+        printk("RWsem: count: %l\n", sem->count);
+}
+EXPORT_SYMBOL_GPL(rwsem_print_debug);
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 7628c3f..8b00656 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -77,7 +77,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	 * Make sure we are not reinitializing a held semaphore:
 	 */
 	debug_check_no_locks_freed((void *)sem, sizeof(*sem));
-	lockdep_init_map(&sem->dep_map, name, key, 0);
+	lockdep_init_map_type(&sem->dep_map, name, key, 0, LOCKTYPE_RWSEM);
 #endif
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	raw_spin_lock_init(&sem->wait_lock);
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index e2d3bc7..24183cc 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -181,6 +181,21 @@ void up_read_non_owner(struct rw_semaphore *sem)
 
 EXPORT_SYMBOL(up_read_non_owner);
 
+void rwsem_print_debug(const struct rw_semaphore *sem)
+{
+	const char *owner = "Unknown";
+
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
+	if (sem->owner)
+		owner = sem->owner->comm;
+	else
+		owner = "None";
+#endif
+
+	printk("RWsem: count: %ld owner: %s\n", sem->count, owner);
+}
+EXPORT_SYMBOL_GPL(rwsem_print_debug);
+
 #endif
 
 
-- 
1.7.10.4

