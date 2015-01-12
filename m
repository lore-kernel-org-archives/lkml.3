Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbbALO5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:57:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38211 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbALO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:57:50 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC 2/4] locking/mutex: additional lock information when dumping locks
Date: Mon, 12 Jan 2015 09:57:09 -0500
Message-Id: <1421074631-18831-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
References: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the counter and the owner of the lock when dumping held locks in the
system.

This is useful to figure out who really holds a lock and how many waiters
it has.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/usb/storage/usb.c    |    2 +-
 fs/inode.c                   |    3 ++-
 fs/super.c                   |    3 ++-
 include/linux/lockdep.h      |    2 +-
 include/linux/mutex-debug.h  |    2 ++
 include/linux/mutex.h        |    2 +-
 kernel/events/core.c         |    3 ++-
 kernel/locking/lockdep.c     |    8 +++++++-
 kernel/locking/mutex-debug.c |   14 +++++++++++++-
 9 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d468d02..b0a2565 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -165,7 +165,7 @@ static void us_set_lock_class(struct mutex *mutex,
 
 	BUG_ON(i == config->desc.bNumInterfaces);
 
-	lockdep_set_class(mutex, &us_interface_key[i]);
+	lockdep_set_class_type(mutex, &us_interface_key[i], LOCKTYPE_MUTEX);
 }
 
 #else
diff --git a/fs/inode.c b/fs/inode.c
index 3a53b1d..8e24ff7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -160,7 +160,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
 	mutex_init(&inode->i_mutex);
-	lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
+	lockdep_set_class_type(&inode->i_mutex, &sb->s_type->i_mutex_key,
+				LOCKTYPE_MUTEX);
 
 	atomic_set(&inode->i_dio_count, 0);
 
diff --git a/fs/super.c b/fs/super.c
index eae088f..d6b585c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -217,7 +217,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	s->s_count = 1;
 	atomic_set(&s->s_active, 1);
 	mutex_init(&s->s_vfs_rename_mutex);
-	lockdep_set_class(&s->s_vfs_rename_mutex, &type->s_vfs_rename_key);
+	lockdep_set_class_type(&s->s_vfs_rename_mutex,
+				&type->s_vfs_rename_key, LOCKTYPE_MUTEX);
 	mutex_init(&s->s_dquot.dqio_mutex);
 	mutex_init(&s->s_dquot.dqonoff_mutex);
 	s->s_maxbytes = MAX_NON_LFS;
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2f4c3fe..cab929b 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -143,7 +143,7 @@ struct lock_class_stats lock_stats(struct lock_class *class);
 void clear_lock_stats(struct lock_class *class);
 #endif
 
-enum LOCK_TYPE { LOCKTYPE_NONE, };
+enum LOCK_TYPE { LOCKTYPE_NONE, LOCKTYPE_MUTEX, };
 
 /*
  * Map the lock object (the lock instance) to the lock-class object.
diff --git a/include/linux/mutex-debug.h b/include/linux/mutex-debug.h
index 4ac8b19..ed125d3 100644
--- a/include/linux/mutex-debug.h
+++ b/include/linux/mutex-debug.h
@@ -21,4 +21,6 @@ do {									\
 
 extern void mutex_destroy(struct mutex *lock);
 
+extern void mutex_print_debug(const struct mutex *lock);
+
 #endif
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index cc31498..cba876d 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -102,7 +102,7 @@ static inline void mutex_destroy(struct mutex *lock) {}
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname) \
-		, .dep_map = { .name = #lockname }
+		, .dep_map = { .name = #lockname, .type = LOCKTYPE_MUTEX }
 #else
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)
 #endif
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4c1ee7f..fef4343 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6777,7 +6777,8 @@ skip_type:
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		__perf_event_init_context(&cpuctx->ctx);
-		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
+		lockdep_set_class_type(&cpuctx->ctx.mutex, &cpuctx_mutex,
+					LOCKTYPE_MUTEX);
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
 		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index de4c9aa..07c337d 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -510,8 +510,14 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 
 static void get_lock_info(enum LOCK_TYPE t, struct lockdep_map *map)
 {
+	struct mutex *mtx;
+
 	switch (t) {
-	case LOCKTYPE_NONE: return;
+	case LOCKTYPE_NONE: break;
+	case LOCKTYPE_MUTEX:
+		mtx = container_of(map, struct mutex, dep_map);
+		mutex_print_debug(mtx);
+		break;
 	}
 }
 
diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index 5cf6731..e97f763 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -98,7 +98,7 @@ void debug_mutex_init(struct mutex *lock, const char *name,
 	 * Make sure we are not reinitializing a held lock:
 	 */
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	lockdep_init_map_type(&lock->dep_map, name, key, 0, LOCKTYPE_MUTEX);
 #endif
 	lock->magic = lock;
 }
@@ -118,3 +118,15 @@ void mutex_destroy(struct mutex *lock)
 }
 
 EXPORT_SYMBOL_GPL(mutex_destroy);
+
+void mutex_print_debug(const struct mutex *lock)
+{
+	const char *owner = "None";
+	int c = atomic_read(&lock->count);
+
+	if (lock->owner)
+		owner = lock->owner->comm;
+
+	printk("Mutex: counter: %d owner: %s\n", c, owner);
+}
+EXPORT_SYMBOL_GPL(mutex_print_debug);
-- 
1.7.10.4

