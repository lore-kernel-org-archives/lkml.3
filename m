Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaGNR2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:28:43 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:31291 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbaGNR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:28:33 -0400
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Waiman Long <waiman.long@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott Norton <scott.norton@hp.com>, Dave Chinner <david@fromorbit.com>,
        Jason Low <jason.low2@hp.com>
Subject: [PATCH v2 3/5] MCS spinlocks: Introduce and use init macro and function for osq locks
Date: Mon, 14 Jul 2014 10:27:50 -0700
Message-Id: <1405358872-3732-4-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405358872-3732-1-git-send-email-jason.low2@hp.com>
References: <1405358872-3732-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we initialize the osq lock by directly setting the lock's values. It
would be preferable if we use an init macro to do the initialization like we do
with other locks.

This patch introduces and uses a macro and function for initializing the osq lock.

Signed-off-by: Jason Low <jason.low2@hp.com>
---
 include/linux/osq_lock.h    |    8 ++++++++
 include/linux/rwsem.h       |    2 +-
 kernel/locking/mutex.c      |    2 +-
 kernel/locking/rwsem-xadd.c |    2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
index b001682..90230d5 100644
--- a/include/linux/osq_lock.h
+++ b/include/linux/osq_lock.h
@@ -16,4 +16,12 @@ struct optimistic_spin_queue {
 	atomic_t tail;
 };
 
+/* Init macro and function. */
+#define OSQ_LOCK_UNLOCKED { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }
+
+static inline void osq_lock_init(struct optimistic_spin_queue *lock)
+{
+	atomic_set(&lock->tail, OSQ_UNLOCKED_VAL);
+}
+
 #endif
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 9fdcdd0..25cd9aa 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -69,7 +69,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
 	  LIST_HEAD_INIT((name).wait_list),		\
 	  NULL, /* owner */				\
-	  { ATOMIC_INIT(OSQ_UNLOCKED_VAL) } /* osq */   \
+	  OSQ_LOCK_UNLOCKED /* osq */			\
 	  __RWSEM_DEP_MAP_INIT(name) }
 #else
 #define __RWSEM_INITIALIZER(name)			\
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index d9b3139..acca2c1 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -60,7 +60,7 @@ __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-	atomic_set(&lock->osq.tail, OSQ_UNLOCKED_VAL);
+	osq_lock_init(&lock->osq);
 #endif
 
 	debug_mutex_init(lock, name, key);
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 9416ddb..d512ca0 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -84,7 +84,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	INIT_LIST_HEAD(&sem->wait_list);
 #ifdef CONFIG_SMP
 	sem->owner = NULL;
-	atomic_set(&sem->osq.tail, OSQ_UNLOCKED_VAL);
+	osq_lock_init(&sem->osq);
 #endif
 }
 
-- 
1.7.1

