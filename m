Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbbALO5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:57:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbALO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:57:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@redhat.com,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC 1/4] lockdep: additional lock specific information when dumping locks
Date: Mon, 12 Jan 2015 09:57:08 -0500
Message-Id: <1421074631-18831-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dumping held locks, it might be useful to get additional lock-specific
information about each lock.

This is mainly useful to figure out who really holds each lock rather then
who's just waiting on it, but it could be extended further or extended to
the other lockdep users if required.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/lockdep.h  |   10 ++++++++++
 kernel/locking/lockdep.c |   21 +++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 74ab231..2f4c3fe 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -143,6 +143,8 @@ struct lock_class_stats lock_stats(struct lock_class *class);
 void clear_lock_stats(struct lock_class *class);
 #endif
 
+enum LOCK_TYPE { LOCKTYPE_NONE, };
+
 /*
  * Map the lock object (the lock instance) to the lock-class object.
  * This is embedded into specific lock instances:
@@ -151,6 +153,7 @@ struct lockdep_map {
 	struct lock_class_key		*key;
 	struct lock_class		*class_cache[NR_LOCKDEP_CACHING_CLASSES];
 	const char			*name;
+	enum LOCK_TYPE			type;
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
 	unsigned long			ip;
@@ -279,6 +282,10 @@ extern void lockdep_on(void);
 extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 			     struct lock_class_key *key, int subclass);
 
+extern void lockdep_init_map_type(struct lockdep_map *lock, const char *name,
+			     struct lock_class_key *key, int subclass,
+			     enum LOCK_TYPE t);
+
 /*
  * To initialize a lockdep_map statically use this macro.
  * Note that _name must not be NULL.
@@ -301,6 +308,8 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 #define lockdep_set_subclass(lock, sub)	\
 		lockdep_init_map(&(lock)->dep_map, #lock, \
 				 (lock)->dep_map.key, sub)
+#define lockdep_set_class_type(lock, key, type) \
+                lockdep_init_map_type(&(lock)->dep_map, #key, key, 0, type)
 
 #define lockdep_set_novalidate_class(lock) \
 	lockdep_set_class_and_name(lock, &__lockdep_no_validate__, #lock)
@@ -395,6 +404,7 @@ static inline void lockdep_on(void)
 #define lockdep_set_class_and_subclass(lock, key, sub) \
 		do { (void)(key); } while (0)
 #define lockdep_set_subclass(lock, sub)		do { } while (0)
+#define lockdep_set_class_type(lock, key, type) do { } while (0)
 
 #define lockdep_set_novalidate_class(lock) do { } while (0)
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 88d0d44..de4c9aa 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -508,6 +508,13 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 	usage[i] = '\0';
 }
 
+static void get_lock_info(enum LOCK_TYPE t, struct lockdep_map *map)
+{
+	switch (t) {
+	case LOCKTYPE_NONE: return;
+	}
+}
+
 static void __print_lock_name(struct lock_class *class)
 {
 	char str[KSYM_NAME_LEN];
@@ -554,6 +561,7 @@ static void print_lock(struct held_lock *hlock)
 	print_lock_name(hlock_class(hlock));
 	printk(", at: ");
 	print_ip_sym(hlock->acquire_ip);
+	get_lock_info(hlock->instance->type, hlock->instance);
 }
 
 static void lockdep_print_held_locks(struct task_struct *curr)
@@ -2951,8 +2959,9 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 /*
  * Initialize a lock instance's lock-class mapping info:
  */
-void lockdep_init_map(struct lockdep_map *lock, const char *name,
-		      struct lock_class_key *key, int subclass)
+void lockdep_init_map_type(struct lockdep_map *lock, const char *name,
+		      struct lock_class_key *key, int subclass,
+		      enum LOCK_TYPE t)
 {
 	int i;
 
@@ -2974,6 +2983,7 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	}
 
 	lock->name = name;
+	lock->type = t;
 
 	/*
 	 * No key, no joy, we need to hash something.
@@ -2999,6 +3009,13 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
 }
+EXPORT_SYMBOL_GPL(lockdep_init_map_type);
+
+void lockdep_init_map(struct lockdep_map *lock, const char *name,
+			struct lock_class_key *key, int subclass)
+{
+	lockdep_init_map_type(lock, name, key, subclass, LOCKTYPE_NONE);
+}
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 struct lock_class_key __lockdep_no_validate__;
-- 
1.7.10.4

