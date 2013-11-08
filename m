Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab3KHTwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:52:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:5797 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105Ab3KHTwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:52:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="432139922"
Subject: [PATCH v5 4/4] MCS Lock: Barrier corrections
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
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
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Will Deacon <will.deacon@arm.com>, "Figo.zhang" <figo1802@gmail.com>
In-Reply-To: <cover.1383935697.git.tim.c.chen@linux.intel.com>
References: <cover.1383935697.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Nov 2013 11:52:38 -0800
Message-ID: <1383940358.11046.417.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Waiman Long <Waiman.Long@hp.com>

This patch corrects the way memory barriers are used in the MCS lock
with smp_load_acquire and smp_store_release fucnction.
It removes ones that are not needed.

It uses architecture specific load-acquire and store-release
primitives for synchronization, if available. Generic implementations
are provided in case they are not defined even though they may not
be optimal. These generic implementation could be removed later on
once changes are made in all the relevant header files.

Suggested-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/locking/mcs_spinlock.c |   48 +++++++++++++++++++++++++++++++++++------
 1 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
index b6f27f8..df5c167 100644
--- a/kernel/locking/mcs_spinlock.c
+++ b/kernel/locking/mcs_spinlock.c
@@ -23,6 +23,31 @@
 #endif
 
 /*
+ * Fall back to use the regular atomic operations and memory barrier if
+ * the acquire/release versions are not defined.
+ */
+#ifndef	xchg_acquire
+# define xchg_acquire(p, v)		xchg(p, v)
+#endif
+
+#ifndef	smp_load_acquire
+# define smp_load_acquire(p)				\
+	({						\
+		typeof(*p) __v = ACCESS_ONCE(*(p));	\
+		smp_mb();				\
+		__v;					\
+	})
+#endif
+
+#ifndef smp_store_release
+# define smp_store_release(p, v)		\
+	do {					\
+		smp_mb();			\
+		ACCESS_ONCE(*(p)) = v;		\
+	} while (0)
+#endif
+
+/*
  * In order to acquire the lock, the caller should declare a local node and
  * pass a reference of the node to this function in addition to the lock.
  * If the lock has already been acquired, then this will proceed to spin
@@ -37,15 +62,19 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 	node->locked = 0;
 	node->next   = NULL;
 
-	prev = xchg(lock, node);
+	/* xchg() provides a memory barrier */
+	prev = xchg_acquire(lock, node);
 	if (likely(prev == NULL)) {
 		/* Lock acquired */
 		return;
 	}
 	ACCESS_ONCE(prev->next) = node;
-	smp_wmb();
-	/* Wait until the lock holder passes the lock down */
-	while (!ACCESS_ONCE(node->locked))
+	/*
+	 * Wait until the lock holder passes the lock down.
+	 * Using smp_load_acquire() provides a memory barrier that
+	 * ensures subsequent operations happen after the lock is acquired.
+	 */
+	while (!(smp_load_acquire(&node->locked)))
 		arch_mutex_cpu_relax();
 }
 EXPORT_SYMBOL_GPL(mcs_spin_lock);
@@ -54,7 +83,7 @@ EXPORT_SYMBOL_GPL(mcs_spin_lock);
  * Releases the lock. The caller should pass in the corresponding node that
  * was used to acquire the lock.
  */
-static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
 	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
 
@@ -68,7 +97,12 @@ static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *nod
 		while (!(next = ACCESS_ONCE(node->next)))
 			arch_mutex_cpu_relax();
 	}
-	ACCESS_ONCE(next->locked) = 1;
-	smp_wmb();
+	/*
+	 * Pass lock to next waiter.
+	 * smp_store_release() provides a memory barrier to ensure
+	 * all operations in the critical section has been completed
+	 * before unlocking.
+	 */
+	smp_store_release(&next->locked , 1);
 }
 EXPORT_SYMBOL_GPL(mcs_spin_unlock);
-- 
1.7.4.4


