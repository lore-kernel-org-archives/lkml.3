Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3IQOkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:40:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49272 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3IQOkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:40:31 -0400
Date: Tue, 17 Sep 2013 16:40:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 02/11] sched, rcu: Make RCU use resched_cpu()
Message-ID: <20130917144012.GC29354@twins.programming.kicks-ass.net>
References: <20130917082838.218329307@infradead.org>
 <20130917091143.449530904@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130917091143.449530904@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer reported a UP build fail, should be fixed.

---
Subject: sched, rcu: Make RCU use resched_cpu()
From: Peter Zijlstra <peterz@infradead.org>
Date: Tue Sep 17 09:30:55 CEST 2013

We're going to deprecate and remove set_need_resched() for it will do
the wrong thing. Make an exception for RCU and allow it to use
resched_cpu() which will do the right thing.

Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/rcutree.c    |   15 ++++++++++++++-
 kernel/sched/core.c |   10 ++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -898,6 +898,12 @@ static void print_other_cpu_stall(struct
 	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
+/*
+ * This function really isn't for public consumption, but RCU is special in
+ * that context switches can allow the state machine to make progress.
+ */
+extern void resched_cpu(int cpu);
+
 static void print_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
@@ -927,7 +933,14 @@ static void print_cpu_stall(struct rcu_s
 				     3 * rcu_jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
-	set_need_resched();  /* kick ourselves to get things going. */
+	/*
+	 * Attempt to revive the RCU machinery by forcing a context switch.
+	 *
+	 * A context switch would normally allow the RCU state machine to make
+	 * progress and it could be we're stuck in kernel space without context
+	 * switches for an entirely unreasonable amount of time.
+	 */
+	resched_cpu(smp_processor_id());
 }
 
 static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -513,12 +513,11 @@ static inline void init_hrtick(void)
  * might also involve a cross-CPU call to trigger the scheduler on
  * the target CPU.
  */
-#ifdef CONFIG_SMP
 void resched_task(struct task_struct *p)
 {
 	int cpu;
 
-	assert_raw_spin_locked(&task_rq(p)->lock);
+	lockdep_assert_held(&task_rq(p)->lock);
 
 	if (test_tsk_need_resched(p))
 		return;
@@ -546,6 +545,7 @@ void resched_cpu(int cpu)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
+#ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
@@ -693,12 +693,6 @@ void sched_avg_update(struct rq *rq)
 	}
 }
 
-#else /* !CONFIG_SMP */
-void resched_task(struct task_struct *p)
-{
-	assert_raw_spin_locked(&task_rq(p)->lock);
-	set_tsk_need_resched(p);
-}
 #endif /* CONFIG_SMP */
 
 #if defined(CONFIG_RT_GROUP_SCHED) || (defined(CONFIG_FAIR_GROUP_SCHED) && \


