Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030338AbaGPTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:25:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44642 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaGPTZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:25:54 -0400
Date: Wed, 16 Jul 2014 12:24:51 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-5db6c6fefb1ca0e81e3bd6dd8998bf51c453d823@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        clm@fb.com, Waiman.Long@hp.com, jbacik@fusionio.com,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        clm@fb.com, jbacik@fusionio.com, Waiman.Long@hp.com,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1405112406-13052-2-git-send-email-davidlohr@hp.com>
References: <1405112406-13052-2-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] locking/rwsem:
  Add CONFIG_RWSEM_SPIN_ON_OWNER
Git-Commit-ID: 5db6c6fefb1ca0e81e3bd6dd8998bf51c453d823
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5db6c6fefb1ca0e81e3bd6dd8998bf51c453d823
Gitweb:     http://git.kernel.org/tip/5db6c6fefb1ca0e81e3bd6dd8998bf51c453d823
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Fri, 11 Jul 2014 14:00:06 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 14:57:13 +0200

locking/rwsem: Add CONFIG_RWSEM_SPIN_ON_OWNER

Just like with mutexes (CONFIG_MUTEX_SPIN_ON_OWNER),
encapsulate the dependencies for rwsem optimistic spinning.
No logical changes here as it continues to depend on both
SMP and the XADD algorithm variant.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Jason Low <jason.low2@hp.com>
[ Also make it depend on ARCH_SUPPORTS_ATOMIC_RMW. ]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1405112406-13052-2-git-send-email-davidlohr@hp.com
Cc: aswin@hp.com
Cc: Chris Mason <clm@fb.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Josef Bacik <jbacik@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/rwsem.h       | 6 ++++--
 kernel/Kconfig.locks        | 4 ++++
 kernel/locking/rwsem-xadd.c | 4 ++--
 kernel/locking/rwsem.c      | 2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 716807f..035d3c5 100644
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
 #define __RWSEM_OPT_INIT(lockname) , .osq = OSQ_LOCK_UNLOCKED, .owner = NULL
 #else
 #define __RWSEM_OPT_INIT(lockname)
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 8190794..76768ee 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -227,6 +227,10 @@ config MUTEX_SPIN_ON_OWNER
 	def_bool y
 	depends on SMP && !DEBUG_MUTEXES && ARCH_SUPPORTS_ATOMIC_RMW
 
+config RWSEM_SPIN_ON_OWNER
+       def_bool y
+       depends on SMP && RWSEM_XCHGADD_ALGORITHM && ARCH_SUPPORTS_ATOMIC_RMW
+
 config ARCH_USE_QUEUE_RWLOCK
 	bool
 
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 7190592..a2391ac 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -82,7 +82,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	sem->count = RWSEM_UNLOCKED_VALUE;
 	raw_spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 	sem->owner = NULL;
 	osq_lock_init(&sem->osq);
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
