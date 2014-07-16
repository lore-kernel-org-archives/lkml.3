Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099AbaGPTXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:23:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934984AbaGPTXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:23:08 -0400
Date: Wed, 16 Jul 2014 12:21:02 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-4d9d951e6b5df85ccfca2c5bd8b4f5c71d256b65@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        peterz@infradead.org, jason.low2@hp.com, clm@fb.com, riel@redhat.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        david@fromorbit.com, davidlohr@hp.com, scott.norton@hp.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, waiman.long@hp.com,
        tim.c.chen@linux.intel.com, paulmck@linux.vnet.ibm.com,
        jbacik@fusionio.com, aswin@hp.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        clm@fb.com, riel@redhat.com, akpm@linux-foundation.org,
        rostedt@goodmis.org, david@fromorbit.com, tglx@linutronix.de,
        scott.norton@hp.com, davidlohr@hp.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, waiman.long@hp.com, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, jbacik@fusionio.com, aswin@hp.com
In-Reply-To: <1405358872-3732-4-git-send-email-jason.low2@hp.com>
References: <1405358872-3732-4-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/urgent] locking/spinlocks/mcs:
  Introduce and use init macro and function for osq locks
Git-Commit-ID: 4d9d951e6b5df85ccfca2c5bd8b4f5c71d256b65
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

Commit-ID:  4d9d951e6b5df85ccfca2c5bd8b4f5c71d256b65
Gitweb:     http://git.kernel.org/tip/4d9d951e6b5df85ccfca2c5bd8b4f5c71d256b65
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Mon, 14 Jul 2014 10:27:50 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:28:05 +0200

locking/spinlocks/mcs: Introduce and use init macro and function for osq locks

Currently, we initialize the osq lock by directly setting the lock's values. It
would be preferable if we use an init macro to do the initialization like we do
with other locks.

This patch introduces and uses a macro and function for initializing the osq lock.

Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Waiman Long <waiman.long@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fusionio.com>
Link: http://lkml.kernel.org/r/1405358872-3732-4-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/osq_lock.h    | 8 ++++++++
 include/linux/rwsem.h       | 2 +-
 kernel/locking/mutex.c      | 2 +-
 kernel/locking/rwsem-xadd.c | 2 +-
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
index b77a623..7190592 100644
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
 
