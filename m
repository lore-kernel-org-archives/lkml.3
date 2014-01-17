Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaAQAI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:08:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:59372 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbaAQAIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:08:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="467969952"
Subject: [PATCH v7 2/6] MCS Lock: optimizations and extra comments
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
In-Reply-To: <cover.1389890175.git.tim.c.chen@linux.intel.com>
References: <cover.1389890175.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jan 2014 16:08:20 -0800
Message-ID: <1389917300.3138.12.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary operation and make the cmpxchg(lock, node, NULL) == node
check in mcs_spin_unlock() likely() as it is likely that a race did not occur
most of the time.

Also add in more comments describing how the local node is used in MCS locks.

From: Jason Low <jason.low2@hp.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 include/linux/mcs_spinlock.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
index b5de3b0..96f14299 100644
--- a/include/linux/mcs_spinlock.h
+++ b/include/linux/mcs_spinlock.h
@@ -18,6 +18,12 @@ struct mcs_spinlock {
 };
 
 /*
+ * In order to acquire the lock, the caller should declare a local node and
+ * pass a reference of the node to this function in addition to the lock.
+ * If the lock has already been acquired, then this will proceed to spin
+ * on this node->locked until the previous lock holder sets the node->locked
+ * in mcs_spin_unlock().
+ *
  * We don't inline mcs_spin_lock() so that perf can correctly account for the
  * time spent in this lock function.
  */
@@ -33,7 +39,6 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 	prev = xchg(lock, node);
 	if (likely(prev == NULL)) {
 		/* Lock acquired */
-		node->locked = 1;
 		return;
 	}
 	ACCESS_ONCE(prev->next) = node;
@@ -43,6 +48,10 @@ void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 		arch_mutex_cpu_relax();
 }
 
+/*
+ * Releases the lock. The caller should pass in the corresponding node that
+ * was used to acquire the lock.
+ */
 static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
 	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
@@ -51,7 +60,7 @@ static void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *nod
 		/*
 		 * Release the lock by setting it to NULL
 		 */
-		if (cmpxchg(lock, node, NULL) == node)
+		if (likely(cmpxchg(lock, node, NULL) == node))
 			return;
 		/* Wait until the next pointer is set */
 		while (!(next = ACCESS_ONCE(node->next)))
-- 
1.7.11.7



