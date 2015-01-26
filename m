Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbbAZHgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:36:51 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:38775 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbbAZHgo (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 02:36:44 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 3/6] locking/rwsem: Set lock ownership ASAP
Date: Sun, 25 Jan 2015 23:36:06 -0800
Message-Id: <1422257769-14083-4-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to optimize the spinning step, we need to set the lock
owner as soon as the lock is acquired; after a successful counter
cmpxchg operation, that is. This is particularly useful as rwsems
need to set the owner to nil for readers, so there is a greater
chance of falling out of the spinning. Currently we only set the
owner much later in the game, in the more generic level -- latency
can be specially bad when waiting for a node->next pointer when
releasing the osq in up_write calls.

As such, update the owner inside rwsem_try_write_lock (when the
lock is obtained after blocking) and rwsem_try_write_lock_unqueued
(when the lock is obtained while spinning). This requires creating
a new internal rwsem.h header to share the owner related calls.

Also cleanup some headers for mutex and rwsem.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/mutex.c      |  2 +-
 kernel/locking/rwsem-xadd.c |  8 ++++++--
 kernel/locking/rwsem.c      | 22 +---------------------
 kernel/locking/rwsem.h      | 20 ++++++++++++++++++++
 4 files changed, 28 insertions(+), 24 deletions(-)
 create mode 100644 kernel/locking/rwsem.h

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index c67a60b..166355e 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -25,7 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
-#include "mcs_spinlock.h"
+#include <linux/osq_lock.h>
 
 /*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,
diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 149e8c7..5e425d8 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -14,8 +14,9 @@
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/sched/rt.h>
+#include <linux/osq_lock.h>
 
-#include "mcs_spinlock.h"
+#include "rwsem.h"
 
 /*
  * Guide to the rw_semaphore's count field for common values.
@@ -263,6 +264,7 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 		    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
 		if (!list_is_singular(&sem->wait_list))
 			rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
+		rwsem_set_owner(sem);
 		return true;
 	}
 
@@ -282,8 +284,10 @@ static inline bool rwsem_try_write_lock_unqueued(struct rw_semaphore *sem)
 			return false;
 
 		old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);
-		if (old == count)
+		if (old == count) {
+			rwsem_set_owner(sem);
 			return true;
+		}
 
 		count = old;
 	}
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index e2d3bc7..205be0c 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -9,29 +9,9 @@
 #include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/rwsem.h>
-
 #include <linux/atomic.h>
 
-#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
-static inline void rwsem_set_owner(struct rw_semaphore *sem)
-{
-	sem->owner = current;
-}
-
-static inline void rwsem_clear_owner(struct rw_semaphore *sem)
-{
-	sem->owner = NULL;
-}
-
-#else
-static inline void rwsem_set_owner(struct rw_semaphore *sem)
-{
-}
-
-static inline void rwsem_clear_owner(struct rw_semaphore *sem)
-{
-}
-#endif
+#include "rwsem.h"
 
 /*
  * lock for reading
diff --git a/kernel/locking/rwsem.h b/kernel/locking/rwsem.h
new file mode 100644
index 0000000..870ed9a
--- /dev/null
+++ b/kernel/locking/rwsem.h
@@ -0,0 +1,20 @@
+#ifdef CONFIG_RWSEM_SPIN_ON_OWNER
+static inline void rwsem_set_owner(struct rw_semaphore *sem)
+{
+	sem->owner = current;
+}
+
+static inline void rwsem_clear_owner(struct rw_semaphore *sem)
+{
+	sem->owner = NULL;
+}
+
+#else
+static inline void rwsem_set_owner(struct rw_semaphore *sem)
+{
+}
+
+static inline void rwsem_clear_owner(struct rw_semaphore *sem)
+{
+}
+#endif
-- 
2.1.2

