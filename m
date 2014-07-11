Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaGKVAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:00:19 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:49653 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaGKVAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:00:16 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH peterz-queue:locking/core 2/2] locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER
Date: Fri, 11 Jul 2014 14:00:06 -0700
Message-Id: <1405112406-13052-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1405112406-13052-1-git-send-email-davidlohr@hp.com>
References: <1405112406-13052-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
encapsulate the dependencies for rwsem optimistic spinning.
No logical changes here as it continues to depend on both
SMP and the XADD algorithm variant.

Acked-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
Based on previous discussion (https://lkml.org/lkml/2014/6/6/461):
  rebased & included ifdefs around #include <linux/osq_lock.h>

 include/linux/rwsem.h       | 6 ++++--
 kernel/Kconfig.locks        | 4 ++++
 kernel/locking/rwsem-xadd.c | 4 ++--
 kernel/locking/rwsem.c      | 2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 5d40884..03dbec7 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -14,7 +14,9 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 #include <linux/osq_lock.h>
+#endif
 
 struct rw_semaphore;
 
@@ -26,7 +28,7 @@ struct rw_semaphore {
 	long count;
 	struct list_head wait_list;
 	raw_spinlock_t wait_lock;
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 	struct optimistic_spin_queue osq; /* spinner MCS lock */
 	/*
 	 * Write owner. Used as a speculative check to see
@@ -63,7 +65,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
 
-#if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 #define __RWSEM_OPT_INIT(lockname)	, .owner = NULL, .osq = { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }
 #else
 #define __RWSEM_OPT_INIT(lockname)
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 35536d9..e4c3162 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -224,6 +224,10 @@ config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES
 
+config RWSEM_SPIN_ON_OWNER
+       def_bool y
+       depends on SMP && RWSEM_XCHGADD_ALGORITHM
+
 config ARCH_USE_QUEUE_RWLOCK
 	bool
 
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index a673bba..b3d0e9f 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -82,7 +82,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 	sem->owner = NULL;
 	atomic_set(&sem->osq.tail, OSQ_UNLOCKED_VAL);
 #endif
@@ -262,7 +262,7 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 	return false;
 }
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 /*
  * Try to acquire write lock before the writer has been put on wait queue.
  */
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 42f806d..e2d3bc7 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -12,7 +12,7 @@
 
 #include <linux/atomic.h>
 
-#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 static inline void rwsem_set_owner(struct rw_semaphore *sem)
 {
 	sem->owner = current;
-- 
1.8.1.4

