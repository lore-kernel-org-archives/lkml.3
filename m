Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaJ1V6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:58:07 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51223 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaJ1V5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/10] rcu: Remove "cpu" argument to rcu_check_callbacks()
Date: Tue, 28 Oct 2014 14:53:30 -0700
Message-Id: <1414533217-24910-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
 <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0025-0000-0000-000000F04B2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The "cpu" argument was kept around on the off-chance that RCU might
offload scheduler-clock interrupts.  However, this offload approach
has been replaced by NO_HZ_FULL, which offloads -all- RCU processing
from qualifying CPUs.  It is therefore time to remove the "cpu" argument
to rcu_check_callbacks(), which this commit does.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 2 +-
 kernel/rcu/tiny.c        | 2 +-
 kernel/rcu/tree.c        | 6 +++---
 kernel/time/timer.c      | 3 +--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a4a819ffb2d1..b4ad275d90d0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -260,7 +260,7 @@ static inline int rcu_preempt_depth(void)
 void rcu_init(void);
 void rcu_sched_qs(void);
 void rcu_bh_qs(void);
-void rcu_check_callbacks(int cpu, int user);
+void rcu_check_callbacks(int user);
 struct notifier_block;
 void rcu_idle_enter(void);
 void rcu_idle_exit(void);
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index c0623fc47125..01570c68d237 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -247,7 +247,7 @@ void rcu_bh_qs(void)
  * be called from hardirq context.  It is normally called from the
  * scheduling-clock interrupt.
  */
-void rcu_check_callbacks(int cpu, int user)
+void rcu_check_callbacks(int user)
 {
 	RCU_TRACE(check_cpu_stalls());
 	if (user || rcu_is_cpu_rrupt_from_idle())
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ab6fcfb4fe11..3107811bba69 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2388,7 +2388,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
  * invoked from the scheduling-clock interrupt.  If rcu_pending returns
  * false, there is no point in invoking rcu_check_callbacks().
  */
-void rcu_check_callbacks(int cpu, int user)
+void rcu_check_callbacks(int user)
 {
 	trace_rcu_utilization(TPS("Start scheduler-tick"));
 	increment_cpu_stall_ticks();
@@ -2420,8 +2420,8 @@ void rcu_check_callbacks(int cpu, int user)
 
 		rcu_bh_qs();
 	}
-	rcu_preempt_check_callbacks(cpu);
-	if (rcu_pending(cpu))
+	rcu_preempt_check_callbacks(smp_processor_id());
+	if (rcu_pending(smp_processor_id()))
 		invoke_rcu_core();
 	if (user)
 		rcu_note_voluntary_context_switch(current);
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 3260ffdb368f..2d3f5c504939 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1377,12 +1377,11 @@ unsigned long get_next_timer_interrupt(unsigned long now)
 void update_process_times(int user_tick)
 {
 	struct task_struct *p = current;
-	int cpu = smp_processor_id();
 
 	/* Note: this timer irq context must be accounted for as well. */
 	account_process_tick(p, user_tick);
 	run_local_timers();
-	rcu_check_callbacks(cpu, user_tick);
+	rcu_check_callbacks(user_tick);
 #ifdef CONFIG_IRQ_WORK
 	if (in_irq())
 		irq_work_tick();
-- 
1.8.1.5

