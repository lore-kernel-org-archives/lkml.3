Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3FDJgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:36:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49610 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3FDJgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:36:19 -0400
Date: Tue, 4 Jun 2013 11:36:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched: fix clear NOHZ_BALANCE_KICK
Message-ID: <20130604093611.GJ8923@twins.programming.kicks-ass.net>
References: <1369927385-7801-1-git-send-email-vincent.guittot@linaro.org>
 <20130603224836.GA9388@somewhere>
 <CAKfTPtCB_ftNWjgAM9s79dX_tuS4yevjdD0YxvKfKS4dxz=LLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtCB_ftNWjgAM9s79dX_tuS4yevjdD0YxvKfKS4dxz=LLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The best I can seem to come up with is something like the below; but I think
its ghastly. Surely we can do something saner with that bit.

Having to clear it at 3 different places is just wrong.

---
 kernel/sched/core.c | 35 +++++++++++++++++++++++++----------
 kernel/sched/fair.c |  6 ++++--
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 142c682..4846223 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -630,15 +630,23 @@ void wake_up_nohz_cpu(int cpu)
 		wake_up_idle_cpu(cpu);
 }
 
-static inline bool got_nohz_idle_kick(void)
+static inline bool got_nohz_idle_kick(int cpu)
 {
-	int cpu = smp_processor_id();
-	return idle_cpu(cpu) && test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+	bool nohz_kick = test_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+	
+	if (!nohz_kick)
+		return false;
+
+	if (idle_cpu(cpu))
+		return true;
+
+	clear_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu));
+	return false;
 }
 
 #else /* CONFIG_NO_HZ_COMMON */
 
-static inline bool got_nohz_idle_kick(void)
+static inline bool got_nohz_idle_kick(int cpu)
 {
 	return false;
 }
@@ -1395,8 +1403,11 @@ static void sched_ttwu_pending(void)
 
 void scheduler_ipi(void)
 {
-	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick()
-	    && !tick_nohz_full_cpu(smp_processor_id()))
+	int this_cpu = smp_processor_id();
+	bool nohz_kick = got_nohz_idle_kick(this_cpu);
+
+	if (llist_empty(&this_rq()->wake_list) && !nohz_kick &&
+	    !tick_nohz_full_cpu(this_cpu))
 		return;
 
 	/*
@@ -1413,15 +1424,19 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
-	tick_nohz_full_check();
+	tick_nohz_full_check(); /* restart tick if required */
 	sched_ttwu_pending();
 
 	/*
 	 * Check if someone kicked us for doing the nohz idle load balance.
 	 */
-	if (unlikely(got_nohz_idle_kick() && !need_resched())) {
-		this_rq()->idle_balance = 1;
-		raise_softirq_irqoff(SCHED_SOFTIRQ);
+	if (unlikely(nohz_kick)) {
+		if (!need_resched()) {
+			this_rq()->idle_balance = 1;
+			raise_softirq_irqoff(SCHED_SOFTIRQ);
+		} else {
+			clear_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu));
+		}
 	}
 	irq_exit();
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 143dcdb..4e6cff4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5600,8 +5600,10 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 	struct rq *rq;
 	int balance_cpu;
 
-	if (idle != CPU_IDLE ||
-	    !test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu)))
+	if (!test_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu)))
+		return;
+
+	if (idle != CPU_IDLE)
 		goto end;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {

