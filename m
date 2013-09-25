Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3IYQig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:38:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IYQie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:38:34 -0400
Date: Wed, 25 Sep 2013 09:37:58 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-2eywnacjl1nllctl1nszqa5w@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, rcu: Make RCU use resched_cpu()
Git-Commit-ID: b021fe3e25094fbec22d0eff846d2adeee1b9736
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:38:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b021fe3e25094fbec22d0eff846d2adeee1b9736
Gitweb:     http://git.kernel.org/tip/b021fe3e25094fbec22d0eff846d2adeee1b9736
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 17 Sep 2013 09:30:55 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 13:53:08 +0200

sched, rcu: Make RCU use resched_cpu()

We're going to deprecate and remove set_need_resched() for it will do
the wrong thing. Make an exception for RCU and allow it to use
resched_cpu() which will do the right thing.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-2eywnacjl1nllctl1nszqa5w@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/rcutree.c    | 15 ++++++++++++++-
 kernel/sched/core.c | 10 ++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 32618b3..1dc9f36 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -898,6 +898,12 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
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
@@ -927,7 +933,14 @@ static void print_cpu_stall(struct rcu_state *rsp)
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
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ac57967..242da0c 100644
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
