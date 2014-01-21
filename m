Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaAUBZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 20:25:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:8319 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbaAUBYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 20:24:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,693,1384329600"; 
   d="scan'208";a="469827239"
Subject: [PATCH v8 4/6] MCS Lock: Move mcs_lock/unlock function into its own
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
In-Reply-To: <cover.1390239879.git.tim.c.chen@linux.intel.com>
References: <cover.1390239879.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jan 2014 17:24:31 -0800
Message-ID: <1390267471.3138.38.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Waiman Long <Waiman.Long@hp.com>

Create a new mcs_spinlock.c file to contain the
mcs_spin_lock() and mcs_spin_unlock() function.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/mcs_spinlock.h                       | 77 ++--------------------
 kernel/locking/Makefile                            |  6 +-
 .../locking/mcs_spinlock.c                         | 27 ++++----
 3 files changed, 18 insertions(+), 92 deletions(-)
 copy include/linux/mcs_spinlock.h => kernel/locking/mcs_spinlock.c (82%)

diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
index bfe84c6..d54bb23 100644
--- a/include/linux/mcs_spinlock.h
+++ b/include/linux/mcs_spinlock.h
@@ -17,78 +17,9 @@ struct mcs_spinlock {
 	int locked; /* 1 if lock acquired */
 };
 
-/*
- * Note: the smp_load_acquire/smp_store_release pair is not
- * sufficient to form a full memory barrier across
- * cpus for many architectures (except x86) for mcs_unlock and mcs_lock.
- * For applications that need a full barrier across multiple cpus
- * with mcs_unlock and mcs_lock pair, smp_mb__after_unlock_lock() should be
- * used after mcs_lock.
- */
-
-/*
- * In order to acquire the lock, the caller should declare a local node and
- * pass a reference of the node to this function in addition to the lock.
- * If the lock has already been acquired, then this will proceed to spin
- * on this node->locked until the previous lock holder sets the node->locked
- * in mcs_spin_unlock().
- *
- * We don't inline mcs_spin_lock() so that perf can correctly account for the
- * time spent in this lock function.
- */
-static noinline
-void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
-{
-	struct mcs_spinlock *prev;
-
-	/* Init node */
-	node->locked = 0;
-	node->next   = NULL;
-
-	prev = xchg(lock, node);
-	if (likely(prev == NULL)) {
-		/* Lock acquired, don't need to set node->locked to 1
-		 * as lock owner and other contenders won't check this value.
-		 * If a debug mode is needed to audit lock status, then
-		 * set node->locked value here.
-		 */
-		return;
-	}
-	ACCESS_ONCE(prev->next) = node;
-	/*
-	 * Wait until the lock holder passes the lock down.
-	 * Using smp_load_acquire() provides a memory barrier that
-	 * ensures subsequent operations happen after the lock is acquired.
-	 */
-	while (!(smp_load_acquire(&node->locked)))
-		arch_mutex_cpu_relax();
-}
-
-/*
- * Releases the lock. The caller should pass in the corresponding node that
- * was used to acquire the lock.
- */
-static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
-{
-	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
-
-	if (likely(!next)) {
-		/*
-		 * Release the lock by setting it to NULL
-		 */
-		if (likely(cmpxchg(lock, node, NULL) == node))
-			return;
-		/* Wait until the next pointer is set */
-		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
-	}
-	/*
-	 * Pass lock to next waiter.
-	 * smp_store_release() provides a memory barrier to ensure
-	 * all operations in the critical section has been completed
-	 * before unlocking.
-	 */
-	smp_store_release(&next->locked, 1);
-}
+extern
+void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node);
+extern
+void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node);
 
 #endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index baab8e5..20d9d5c 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -13,12 +13,12 @@ obj-$(CONFIG_LOCKDEP) += lockdep.o
 ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
-obj-$(CONFIG_SMP) += spinlock.o
-obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
+obj-$(CONFIG_SMP) += spinlock.o mcs_spinlock.o
+obj-$(CONFIG_PROVE_LOCKING) += spinlock.o mcs_spinlock.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
-obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
+obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o mcs_spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
 obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
diff --git a/include/linux/mcs_spinlock.h b/kernel/locking/mcs_spinlock.c
similarity index 82%
copy from include/linux/mcs_spinlock.h
copy to kernel/locking/mcs_spinlock.c
index bfe84c6..c3ee9cf 100644
--- a/include/linux/mcs_spinlock.h
+++ b/kernel/locking/mcs_spinlock.c
@@ -1,7 +1,5 @@
 /*
- * MCS lock defines
- *
- * This file contains the main data structure and API definitions of MCS lock.
+ * MCS lock
  *
  * The MCS lock (proposed by Mellor-Crummey and Scott) is a simple spin-lock
  * with the desirable properties of being fair, and with each cpu trying
@@ -9,13 +7,14 @@
  * It avoids expensive cache bouncings that common test-and-set spin-lock
  * implementations incur.
  */
-#ifndef __LINUX_MCS_SPINLOCK_H
-#define __LINUX_MCS_SPINLOCK_H
 
-struct mcs_spinlock {
-	struct mcs_spinlock *next;
-	int locked; /* 1 if lock acquired */
-};
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/processor.h>
+#include <linux/compiler.h>
+#include <linux/mcs_spinlock.h>
+#include <linux/mutex.h>
+#include <linux/export.h>
 
 /*
  * Note: the smp_load_acquire/smp_store_release pair is not
@@ -32,11 +31,7 @@ struct mcs_spinlock {
  * If the lock has already been acquired, then this will proceed to spin
  * on this node->locked until the previous lock holder sets the node->locked
  * in mcs_spin_unlock().
- *
- * We don't inline mcs_spin_lock() so that perf can correctly account for the
- * time spent in this lock function.
  */
-static noinline
 void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
 	struct mcs_spinlock *prev;
@@ -63,12 +58,13 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 	while (!(smp_load_acquire(&node->locked)))
 		arch_mutex_cpu_relax();
 }
+EXPORT_SYMBOL_GPL(mcs_spin_lock);
 
 /*
  * Releases the lock. The caller should pass in the corresponding node that
  * was used to acquire the lock.
  */
-static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
 	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
 
@@ -90,5 +86,4 @@ static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *nod
 	 */
 	smp_store_release(&next->locked, 1);
 }
-
-#endif /* __LINUX_MCS_SPINLOCK_H */
+EXPORT_SYMBOL_GPL(mcs_spin_unlock);
-- 
1.7.11.7



