Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab3HTCoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:44:04 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52085 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab3HTCm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:42:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH tip/core/rcu 2/9] rcu: Simplify debug-objects fixups
Date: Mon, 19 Aug 2013 19:42:07 -0700
Message-Id: <1376966534-30775-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024148.GA30283@linux.vnet.ibm.com>
 <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-5806-0000-0000-0000227ACA76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current debug-objects fixups are complex and heavyweight, and the
fixups are not complete:  Even with the fixups, RCU's callback lists
can still be corrupted.  This commit therefore strips the fixups down
to their minimal form, eliminating two of the three.

It would be even better if (for example) call_rcu() simply leaked
any problematic callbacks, but for that to happen, the debug-objects
system would need to inform its caller of suspicious situations.
This is the subject of a later commit in this series.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcupdate.c | 100 ------------------------------------------------------
 1 file changed, 100 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 14994d4..33eb462 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -212,43 +212,6 @@ static inline void debug_rcu_head_free(struct rcu_head *head)
 }
 
 /*
- * fixup_init is called when:
- * - an active object is initialized
- */
-static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
-{
-	struct rcu_head *head = addr;
-
-	switch (state) {
-	case ODEBUG_STATE_ACTIVE:
-		/*
-		 * Ensure that queued callbacks are all executed.
-		 * If we detect that we are nested in a RCU read-side critical
-		 * section, we should simply fail, otherwise we would deadlock.
-		 * In !PREEMPT configurations, there is no way to tell if we are
-		 * in a RCU read-side critical section or not, so we never
-		 * attempt any fixup and just print a warning.
-		 */
-#ifndef CONFIG_PREEMPT
-		WARN_ON_ONCE(1);
-		return 0;
-#endif
-		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
-		    irqs_disabled()) {
-			WARN_ON_ONCE(1);
-			return 0;
-		}
-		rcu_barrier();
-		rcu_barrier_sched();
-		rcu_barrier_bh();
-		debug_object_init(head, &rcuhead_debug_descr);
-		return 1;
-	default:
-		return 0;
-	}
-}
-
-/*
  * fixup_activate is called when:
  * - an active object is activated
  * - an unknown object is activated (might be a statically initialized object)
@@ -268,69 +231,8 @@ static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
 		debug_object_init(head, &rcuhead_debug_descr);
 		debug_object_activate(head, &rcuhead_debug_descr);
 		return 0;
-
-	case ODEBUG_STATE_ACTIVE:
-		/*
-		 * Ensure that queued callbacks are all executed.
-		 * If we detect that we are nested in a RCU read-side critical
-		 * section, we should simply fail, otherwise we would deadlock.
-		 * In !PREEMPT configurations, there is no way to tell if we are
-		 * in a RCU read-side critical section or not, so we never
-		 * attempt any fixup and just print a warning.
-		 */
-#ifndef CONFIG_PREEMPT
-		WARN_ON_ONCE(1);
-		return 0;
-#endif
-		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
-		    irqs_disabled()) {
-			WARN_ON_ONCE(1);
-			return 0;
-		}
-		rcu_barrier();
-		rcu_barrier_sched();
-		rcu_barrier_bh();
-		debug_object_activate(head, &rcuhead_debug_descr);
-		return 1;
 	default:
-		return 0;
-	}
-}
-
-/*
- * fixup_free is called when:
- * - an active object is freed
- */
-static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
-{
-	struct rcu_head *head = addr;
-
-	switch (state) {
-	case ODEBUG_STATE_ACTIVE:
-		/*
-		 * Ensure that queued callbacks are all executed.
-		 * If we detect that we are nested in a RCU read-side critical
-		 * section, we should simply fail, otherwise we would deadlock.
-		 * In !PREEMPT configurations, there is no way to tell if we are
-		 * in a RCU read-side critical section or not, so we never
-		 * attempt any fixup and just print a warning.
-		 */
-#ifndef CONFIG_PREEMPT
-		WARN_ON_ONCE(1);
-		return 0;
-#endif
-		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
-		    irqs_disabled()) {
-			WARN_ON_ONCE(1);
-			return 0;
-		}
-		rcu_barrier();
-		rcu_barrier_sched();
-		rcu_barrier_bh();
-		debug_object_free(head, &rcuhead_debug_descr);
 		return 1;
-	default:
-		return 0;
 	}
 }
 
@@ -369,9 +271,7 @@ EXPORT_SYMBOL_GPL(destroy_rcu_head_on_stack);
 
 struct debug_obj_descr rcuhead_debug_descr = {
 	.name = "rcu_head",
-	.fixup_init = rcuhead_fixup_init,
 	.fixup_activate = rcuhead_fixup_activate,
-	.fixup_free = rcuhead_fixup_free,
 };
 EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
 #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
-- 
1.8.1.5

