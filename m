Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3IXWXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:23:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:19584 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab3IXWW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:22:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,974,1371106800"; 
   d="scan'208";a="408595176"
Subject: [PATCH v5 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <cover.1380057198.git.tim.c.chen@linux.intel.com>
References: <cover.1380057198.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Sep 2013 15:22:46 -0700
Message-ID: <1380061366.3467.54.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will need the MCS lock code for doing optimistic spinning for rwsem.
Extracting the MCS code from mutex.c and put into its own file allow us
to reuse this code easily for rwsem.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/mutex.c |   58 ++++++-------------------------------------------------
 1 files changed, 7 insertions(+), 51 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 6d647ae..1b6ba3f 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -25,6 +25,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
+#include <linux/mcslock.h>
 
 /*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,
@@ -111,54 +112,9 @@ EXPORT_SYMBOL(mutex_lock);
  * more or less simultaneously, the spinners need to acquire a MCS lock
  * first before spinning on the owner field.
  *
- * We don't inline mspin_lock() so that perf can correctly account for the
- * time spent in this lock function.
  */
-struct mspin_node {
-	struct mspin_node *next ;
-	int		  locked;	/* 1 if lock acquired */
-};
-#define	MLOCK(mutex)	((struct mspin_node **)&((mutex)->spin_mlock))
 
-static noinline
-void mspin_lock(struct mspin_node **lock, struct mspin_node *node)
-{
-	struct mspin_node *prev;
-
-	/* Init node */
-	node->locked = 0;
-	node->next   = NULL;
-
-	prev = xchg(lock, node);
-	if (likely(prev == NULL)) {
-		/* Lock acquired */
-		node->locked = 1;
-		return;
-	}
-	ACCESS_ONCE(prev->next) = node;
-	smp_wmb();
-	/* Wait until the lock holder passes the lock down */
-	while (!ACCESS_ONCE(node->locked))
-		arch_mutex_cpu_relax();
-}
-
-static void mspin_unlock(struct mspin_node **lock, struct mspin_node *node)
-{
-	struct mspin_node *next = ACCESS_ONCE(node->next);
-
-	if (likely(!next)) {
-		/*
-		 * Release the lock by setting it to NULL
-		 */
-		if (cmpxchg(lock, node, NULL) == node)
-			return;
-		/* Wait until the next pointer is set */
-		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
-	}
-	ACCESS_ONCE(next->locked) = 1;
-	smp_wmb();
-}
+#define	MLOCK(mutex)	((struct mcs_spin_node **)&((mutex)->spin_mlock))
 
 /*
  * Mutex spinning code migrated from kernel/sched/core.c
@@ -448,7 +404,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	for (;;) {
 		struct task_struct *owner;
-		struct mspin_node  node;
+		struct mcs_spin_node  node;
 
 		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
 			struct ww_mutex *ww;
@@ -470,10 +426,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
-		mspin_lock(MLOCK(lock), &node);
+		mcs_spin_lock(MLOCK(lock), &node);
 		owner = ACCESS_ONCE(lock->owner);
 		if (owner && !mutex_spin_on_owner(lock, owner)) {
-			mspin_unlock(MLOCK(lock), &node);
+			mcs_spin_unlock(MLOCK(lock), &node);
 			goto slowpath;
 		}
 
@@ -488,11 +444,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			}
 
 			mutex_set_owner(lock);
-			mspin_unlock(MLOCK(lock), &node);
+			mcs_spin_unlock(MLOCK(lock), &node);
 			preempt_enable();
 			return 0;
 		}
-		mspin_unlock(MLOCK(lock), &node);
+		mcs_spin_unlock(MLOCK(lock), &node);
 
 		/*
 		 * When there's no owner, we might have preempted between the
-- 
1.7.4.4



