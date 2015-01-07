Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbbAGRVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:21:10 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:40823 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbbAGRVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:21:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, Alexander Gordeev <agordeev@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/10] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle() from tiny RCU
Date: Wed,  7 Jan 2015 09:20:49 -0800
Message-Id: <1420651257-553-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107172030.GA31571@linux.vnet.ibm.com>
 <1420651257-553-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0021-0000-0000-00000793775D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Gordeev <agordeev@redhat.com>

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
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tiny.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index 0db5649f8817..805b6d59c854 100644
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
 void rcu_check_callbacks(int user)
 {
 	RCU_TRACE(check_cpu_stalls());
-	if (user || rcu_is_cpu_rrupt_from_idle())
+	if (user)
 		rcu_sched_qs();
 	else if (!in_softirq())
 		rcu_bh_qs();
-- 
1.8.1.5

