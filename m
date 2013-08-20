Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3HTCrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:47:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43607 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3HTCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:47:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/9] rcu: Eliminate unused APIs intended for adaptive ticks
Date: Mon, 19 Aug 2013 19:47:13 -0700
Message-Id: <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130820024700.GA31075@linux.vnet.ibm.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-1542-0000-0000-000000A790E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_user_enter_after_irq() and rcu_user_exit_after_irq()
functions were intended for use by adaptive ticks, but changes
in implementation have rendered them unnecessary.  This commit
therefore removes them.

Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rcupdate.h |  4 ----
 kernel/rcutree.c         | 43 -------------------------------------------
 2 files changed, 47 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 0c38abb..30bea9c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -229,13 +229,9 @@ extern void rcu_irq_exit(void);
 #ifdef CONFIG_RCU_USER_QS
 extern void rcu_user_enter(void);
 extern void rcu_user_exit(void);
-extern void rcu_user_enter_after_irq(void);
-extern void rcu_user_exit_after_irq(void);
 #else
 static inline void rcu_user_enter(void) { }
 static inline void rcu_user_exit(void) { }
-static inline void rcu_user_enter_after_irq(void) { }
-static inline void rcu_user_exit_after_irq(void) { }
 static inline void rcu_user_hooks_switch(struct task_struct *prev,
 					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 338f1d1..8807019 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -444,27 +444,6 @@ void rcu_user_enter(void)
 {
 	rcu_eqs_enter(1);
 }
-
-/**
- * rcu_user_enter_after_irq - inform RCU that we are going to resume userspace
- * after the current irq returns.
- *
- * This is similar to rcu_user_enter() but in the context of a non-nesting
- * irq. After this call, RCU enters into idle mode when the interrupt
- * returns.
- */
-void rcu_user_enter_after_irq(void)
-{
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
-
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	/* Ensure this irq is interrupting a non-idle RCU state.  */
-	WARN_ON_ONCE(!(rdtp->dynticks_nesting & DYNTICK_TASK_MASK));
-	rdtp->dynticks_nesting = 1;
-	local_irq_restore(flags);
-}
 #endif /* CONFIG_RCU_USER_QS */
 
 /**
@@ -581,28 +560,6 @@ void rcu_user_exit(void)
 {
 	rcu_eqs_exit(1);
 }
-
-/**
- * rcu_user_exit_after_irq - inform RCU that we won't resume to userspace
- * idle mode after the current non-nesting irq returns.
- *
- * This is similar to rcu_user_exit() but in the context of an irq.
- * This is called when the irq has interrupted a userspace RCU idle mode
- * context. When the current non-nesting interrupt returns after this call,
- * the CPU won't restore the RCU idle mode.
- */
-void rcu_user_exit_after_irq(void)
-{
-	unsigned long flags;
-	struct rcu_dynticks *rdtp;
-
-	local_irq_save(flags);
-	rdtp = &__get_cpu_var(rcu_dynticks);
-	/* Ensure we are interrupting an RCU idle mode. */
-	WARN_ON_ONCE(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK);
-	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
-	local_irq_restore(flags);
-}
 #endif /* CONFIG_RCU_USER_QS */
 
 /**
-- 
1.8.1.5

