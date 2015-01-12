Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbbALO6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:58:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41155 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbbALO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:57:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC 4/4] locking/spinlock: additional lock information when dumping locks
Date: Mon, 12 Jan 2015 09:57:11 -0500
Message-Id: <1421074631-18831-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
References: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the owner cpu and task of the lock when dumping held locks in the system.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/lockdep.h         |    2 +-
 include/linux/spinlock.h        |    4 ++++
 include/linux/spinlock_types.h  |    2 +-
 kernel/locking/lockdep.c        |    5 +++++
 kernel/locking/spinlock_debug.c |   17 ++++++++++++++++-
 5 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4527f99..01e0b14 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -143,7 +143,7 @@ struct lock_class_stats lock_stats(struct lock_class *class);
 void clear_lock_stats(struct lock_class *class);
 #endif
 
-enum LOCK_TYPE { LOCKTYPE_NONE, LOCKTYPE_MUTEX, LOCKTYPE_RWSEM, };
+enum LOCK_TYPE { LOCKTYPE_NONE, LOCKTYPE_MUTEX, LOCKTYPE_RWSEM, LOCKTYPE_SPINLOCK, };
 
 /*
  * Map the lock object (the lock instance) to the lock-class object.
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 3e18379..963f7626 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -409,6 +409,10 @@ static inline int spin_can_lock(spinlock_t *lock)
 
 #define assert_spin_locked(lock)	assert_raw_spin_locked(&(lock)->rlock)
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern void spinlock_print_debug(const spinlock_t *lock);
+#endif
+
 /*
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index 73548eb..efbe667 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -36,7 +36,7 @@ typedef struct raw_spinlock {
 #define SPINLOCK_OWNER_INIT	((void *)-1L)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define SPIN_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+# define SPIN_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname, .type = LOCKTYPE_SPINLOCK }
 #else
 # define SPIN_DEP_MAP_INIT(lockname)
 #endif
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index e75f83b..b3d4151 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -512,6 +512,7 @@ static void get_lock_info(enum LOCK_TYPE t, struct lockdep_map *map)
 {
 	struct mutex *mtx;
 	struct rw_semaphore *rw;
+	spinlock_t *spin;
 
 	switch (t) {
 	case LOCKTYPE_NONE: break;
@@ -523,6 +524,10 @@ static void get_lock_info(enum LOCK_TYPE t, struct lockdep_map *map)
 		rw = container_of(map, struct rw_semaphore, dep_map);
 		rwsem_print_debug(rw);
 		break;
+	case LOCKTYPE_SPINLOCK:
+		spin = container_of(map, struct spinlock, dep_map);
+		spinlock_print_debug(spin);
+		break;
 	}
 }
 
diff --git a/kernel/locking/spinlock_debug.c b/kernel/locking/spinlock_debug.c
index 0374a59..52798c0 100644
--- a/kernel/locking/spinlock_debug.c
+++ b/kernel/locking/spinlock_debug.c
@@ -21,7 +21,7 @@ void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 	 * Make sure we are not reinitializing a held lock:
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	lockdep_init_map_type(&lock->dep_map, name, key, 0, LOCKTYPE_SPINLOCK);
 #endif
 	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	lock->magic = SPINLOCK_MAGIC;
@@ -300,3 +300,18 @@ void do_raw_write_unlock(rwlock_t *lock)
 	debug_write_unlock(lock);
 	arch_write_unlock(&lock->raw_lock);
 }
+
+void spinlock_print_debug(const spinlock_t *lock)
+{
+	const char *owner_comm = NULL;
+	const struct task_struct *owner;
+	unsigned int cpu = lock->rlock.owner_cpu;
+
+	owner = lock->rlock.owner;
+
+	if (owner && owner != SPINLOCK_OWNER_INIT)
+		owner_comm = owner->comm;
+
+	printk("Spinlock: owner cpu: %u owner: %s\n", cpu, owner_comm);
+}
+EXPORT_SYMBOL_GPL(spinlock_print_debug);
-- 
1.7.10.4

