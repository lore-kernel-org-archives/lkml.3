Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaAUXgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:36:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:56634 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbaAUXgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:36:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,697,1384329600"; 
   d="scan'208";a="470404327"
Subject: [PATCH v9 4/6] MCS Lock: Allow architectures to hook in to
 contended paths
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
In-Reply-To: <cover.1390320729.git.tim.c.chen@linux.intel.com>
References: <cover.1390320729.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jan 2014 15:36:10 -0800
Message-ID: <1390347370.3138.65.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com

When contended, architectures may be able to reduce the polling overhead
in ways which aren't expressible using a simple relax() primitive.

This patch allows architectures to hook into the mcs_{lock,unlock}
functions for the contended cases only.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/mcs_spinlock.h | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
index 143fa42..e9a4d74 100644
--- a/include/linux/mcs_spinlock.h
+++ b/include/linux/mcs_spinlock.h
@@ -17,6 +17,28 @@ struct mcs_spinlock {
 	int locked; /* 1 if lock acquired */
 };
 
+#ifndef arch_mcs_spin_lock_contended
+/*
+ * Using smp_load_acquire() provides a memory barrier that ensures
+ * subsequent operations happen after the lock is acquired.
+ */
+#define arch_mcs_spin_lock_contended(l)					\
+do {									\
+	while (!(smp_load_acquire(l)))					\
+		arch_mutex_cpu_relax();					\
+} while (0)
+#endif
+
+#ifndef arch_mcs_spin_unlock_contended
+/*
+ * smp_store_release() provides a memory barrier to ensure all
+ * operations in the critical section has been completed before
+ * unlocking.
+ */
+#define arch_mcs_spin_unlock_contended(l)				\
+	smp_store_release((l), 1)
+#endif
+
 /*
  * Note: the smp_load_acquire/smp_store_release pair is not
  * sufficient to form a full memory barrier across
@@ -58,13 +80,9 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 		return;
 	}
 	ACCESS_ONCE(prev->next) = node;
-	/*
-	 * Wait until the lock holder passes the lock down.
-	 * Using smp_load_acquire() provides a memory barrier that
-	 * ensures subsequent operations happen after the lock is acquired.
-	 */
-	while (!(smp_load_acquire(&node->locked)))
-		arch_mutex_cpu_relax();
+
+	/* Wait until the lock holder passes the lock down. */
+	arch_mcs_spin_lock_contended(&node->locked);
 }
 
 /*
@@ -86,13 +104,9 @@ void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 		while (!(next = ACCESS_ONCE(node->next)))
 			arch_mutex_cpu_relax();
 	}
-	/*
-	 * Pass lock to next waiter.
-	 * smp_store_release() provides a memory barrier to ensure
-	 * all operations in the critical section has been completed
-	 * before unlocking.
-	 */
-	smp_store_release(&next->locked, 1);
+
+	/* Pass lock to next waiter. */
+	arch_mcs_spin_unlock_contended(&next->locked);
 }
 
 #endif /* __LINUX_MCS_SPINLOCK_H */
-- 
1.7.11.7



