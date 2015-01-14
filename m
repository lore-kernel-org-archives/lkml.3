Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbbANTUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:20:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbANTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:20:30 -0500
Date: Wed, 14 Jan 2015 11:19:38 -0800
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-d84b6728c54dcf73bcef3e3f7cf6767e2d224e39@git.kernel.org>
Cc: dbueso@suse.de, paulmck@linux.vnet.ibm.com, Waiman.Long@hp.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        mpatocka@redhat.com, jason.low2@hp.com, hpa@zytor.com,
        dave@stgolabs.net
Reply-To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@kernel.org, tglx@linutronix.de, mpatocka@redhat.com,
        hpa@zytor.com, jason.low2@hp.com, dave@stgolabs.net, dbueso@suse.de,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, Waiman.Long@hp.com
In-Reply-To: <1420573509-24774-5-git-send-email-dave@stgolabs.net>
References: <1420573509-24774-5-git-send-email-dave@stgolabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mcs:
  Better differentiate between MCS variants
Git-Commit-ID: d84b6728c54dcf73bcef3e3f7cf6767e2d224e39
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

Commit-ID:  d84b6728c54dcf73bcef3e3f7cf6767e2d224e39
Gitweb:     http://git.kernel.org/tip/d84b6728c54dcf73bcef3e3f7cf6767e2d224e39
Author:     Davidlohr Bueso <dave@stgolabs.net>
AuthorDate: Tue, 6 Jan 2015 11:45:07 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 15:07:32 +0100

locking/mcs: Better differentiate between MCS variants

We have two flavors of the MCS spinlock: standard and cancelable (OSQ).
While each one is independent of the other, we currently mix and match
them. This patch:

  - Moves the OSQ code out of mcs_spinlock.h (which only deals with the traditional
    version) into include/linux/osq_lock.h. No unnecessary code is added to the
    more global header file, anything locks that make use of OSQ must include
    it anyway.

  - Renames mcs_spinlock.c to osq_lock.c. This file only contains osq code.

  - Introduces a CONFIG_LOCK_SPIN_ON_OWNER in order to only build osq_lock
    if there is support for it.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Link: http://lkml.kernel.org/r/1420573509-24774-5-git-send-email-dave@stgolabs.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/osq_lock.h                      | 12 ++++++++++--
 kernel/Kconfig.locks                          |  4 ++++
 kernel/locking/Makefile                       |  3 ++-
 kernel/locking/mcs_spinlock.h                 | 16 ----------------
 kernel/locking/{mcs_spinlock.c => osq_lock.c} |  7 +------
 5 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
index 90230d5..3a6490e 100644
--- a/include/linux/osq_lock.h
+++ b/include/linux/osq_lock.h
@@ -5,8 +5,11 @@
  * An MCS like lock especially tailored for optimistic spinning for sleeping
  * lock implementations (mutex, rwsem, etc).
  */
-
-#define OSQ_UNLOCKED_VAL (0)
+struct optimistic_spin_node {
+	struct optimistic_spin_node *next, *prev;
+	int locked; /* 1 if lock acquired */
+	int cpu; /* encoded CPU # + 1 value */
+};
 
 struct optimistic_spin_queue {
 	/*
@@ -16,6 +19,8 @@ struct optimistic_spin_queue {
 	atomic_t tail;
 };
 
+#define OSQ_UNLOCKED_VAL (0)
+
 /* Init macro and function. */
 #define OSQ_LOCK_UNLOCKED { ATOMIC_INIT(OSQ_UNLOCKED_VAL) }
 
@@ -24,4 +29,7 @@ static inline void osq_lock_init(struct optimistic_spin_queue *lock)
 	atomic_set(&lock->tail, OSQ_UNLOCKED_VAL);
 }
 
+extern bool osq_lock(struct optimistic_spin_queue *lock);
+extern void osq_unlock(struct optimistic_spin_queue *lock);
+
 #endif
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 76768ee..08561f1 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -231,6 +231,10 @@ config RWSEM_SPIN_ON_OWNER
        def_bool y
        depends on SMP && RWSEM_XCHGADD_ALGORITHM && ARCH_SUPPORTS_ATOMIC_RMW
 
+config LOCK_SPIN_ON_OWNER
+       def_bool y
+       depends on MUTEX_SPIN_ON_OWNER || RWSEM_SPIN_ON_OWNER
+
 config ARCH_USE_QUEUE_RWLOCK
 	bool
 
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index 8541bfd..4ca8eb1 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o mcs_spinlock.o
+obj-y += mutex.o semaphore.o rwsem.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -14,6 +14,7 @@ ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
+obj-$(CONFIG_LOCK_SPIN_ON_OWNER) += osq_lock.o
 obj-$(CONFIG_SMP) += lglock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinlock.h
index 4d60986..d1fe2ba 100644
--- a/kernel/locking/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.h
@@ -108,20 +108,4 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 	arch_mcs_spin_unlock_contended(&next->locked);
 }
 
-/*
- * Cancellable version of the MCS lock above.
- *
- * Intended for adaptive spinning of sleeping locks:
- * mutex_lock()/rwsem_down_{read,write}() etc.
- */
-
-struct optimistic_spin_node {
-	struct optimistic_spin_node *next, *prev;
-	int locked; /* 1 if lock acquired */
-	int cpu; /* encoded CPU # value */
-};
-
-extern bool osq_lock(struct optimistic_spin_queue *lock);
-extern void osq_unlock(struct optimistic_spin_queue *lock);
-
 #endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/osq_lock.c
similarity index 98%
rename from kernel/locking/mcs_spinlock.c
rename to kernel/locking/osq_lock.c
index 9887a90..ec83d4d 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/osq_lock.c
@@ -1,8 +1,6 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
-#include "mcs_spinlock.h"
-
-#ifdef CONFIG_SMP
+#include <linux/osq_lock.h>
 
 /*
  * An MCS like lock especially tailored for optimistic spinning for sleeping
@@ -203,6 +201,3 @@ void osq_unlock(struct optimistic_spin_queue *lock)
 	if (next)
 		ACCESS_ONCE(next->locked) = 1;
 }
-
-#endif
-
