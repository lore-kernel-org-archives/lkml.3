Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbaA1TYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:24:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbaA1TYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:24:06 -0500
Date: Tue, 28 Jan 2014 11:23:18 -0800
From: tip-bot for Will Deacon <tipbot@zytor.com>
Message-ID: <tip-e207552e64ea053a33e856828ad7915484911d06@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        peterz@infradead.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tim.c.chen@linux.intel.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        tglx@linutronix.de
In-Reply-To: <1390347370.3138.65.camel@schen9-DESK>
References: <1390347370.3138.65.camel@schen9-DESK>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mcs:
  Allow architectures to hook in to contended paths
Git-Commit-ID: e207552e64ea053a33e856828ad7915484911d06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 28 Jan 2014 11:23:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e207552e64ea053a33e856828ad7915484911d06
Gitweb:     http://git.kernel.org/tip/e207552e64ea053a33e856828ad7915484911d06
Author:     Will Deacon <will.deacon@arm.com>
AuthorDate: Tue, 21 Jan 2014 15:36:10 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Jan 2014 13:13:28 +0100

locking/mcs: Allow architectures to hook in to contended paths

When contended, architectures may be able to reduce the polling overhead
in ways which aren't expressible using a simple relax() primitive.

This patch allows architectures to hook into the mcs_{lock,unlock}
functions for the contended cases only.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1390347370.3138.65.camel@schen9-DESK
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
