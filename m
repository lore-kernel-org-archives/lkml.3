Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbaJaOq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:46:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbaJaOq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:46:57 -0400
Date: Fri, 31 Oct 2014 14:55:05 +0000
From: Alexander Gordeev <agordeev@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle() from
 tiny RCU
Message-ID: <20141031145504.GC18126@agordeev.usersys.redhat.com>
References: <20141029143439.GN5718@linux.vnet.ibm.com>
 <20141029151622.GD30198@agordeev.usersys.redhat.com>
 <20141029154615.GR5718@linux.vnet.ibm.com>
 <20141029210916.GB13273@agordeev.usersys.redhat.com>
 <20141030000524.GG5718@linux.vnet.ibm.com>
 <20141030175435.GC13273@agordeev.usersys.redhat.com>
 <20141030204318.GR5718@linux.vnet.ibm.com>
 <20141030215433.GA18126@agordeev.usersys.redhat.com>
 <20141031034559.GT5718@linux.vnet.ibm.com>
 <20141031145326.GB18126@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031145326.GB18126@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's start assuming that something in the idle loop posts a callback,
and scheduling-clock interrupt occurs:

1. The system is idle and stays that way, no runnable tasks.

2. Scheduling-clock interrupt occurs, rcu_check_callbacks() is called
   as result, which in turn calls rcu_is_cpu_rrupt_from_idle().

3. rcu_is_cpu_rrupt_from_idle() reports the CPU was interrupted from
   idle, which results in rcu_sched_qs() call, which does a
   raise_softirq(RCU_SOFTIRQ).

4. Upon return from interrupt, rcu_irq_exit() is invoked, which calls
   rcu_idle_enter_common(), which in turn calls rcu_sched_qs() again,
   which does another raise_softirq(RCU_SOFTIRQ).

5. The softirq happens shortly and invokes rcu_process_callbacks(),
   which invokes __rcu_process_callbacks().

6. So now callbacks can be invoked. At least they can be if
   ->donetail has been updated. Which it will have been because
   rcu_sched_qs() invokes rcu_qsctr_help().

In the described scenario rcu_sched_qs() and raise_softirq(RCU_SOFTIRQ)
get called twice in steps 3 and 4. This redundancy could be eliminated
by removing rcu_is_cpu_rrupt_from_idle() function.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tiny.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index c0623fc..0bfb3b9 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -186,16 +186,6 @@ EXPORT_SYMBOL(__rcu_is_watching);
 #endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
 
 /*
- * Test whether the current CPU was interrupted from idle.  Nested
- * interrupts don't count, we must be running at the first interrupt
- * level.
- */
-static int rcu_is_cpu_rrupt_from_idle(void)
-{
-	return rcu_dynticks_nesting <= 1;
-}
-
-/*
  * Helper function for rcu_sched_qs() and rcu_bh_qs().
  * Also irqs are disabled to avoid confusion due to interrupt handlers
  * invoking call_rcu().
@@ -250,7 +240,7 @@ void rcu_bh_qs(void)
 void rcu_check_callbacks(int cpu, int user)
 {
 	RCU_TRACE(check_cpu_stalls());
-	if (user || rcu_is_cpu_rrupt_from_idle())
+	if (user)
 		rcu_sched_qs();
 	else if (!in_softirq())
 		rcu_bh_qs();
-- 
1.8.3.1

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
