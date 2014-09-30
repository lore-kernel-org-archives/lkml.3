Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaI3IXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:23:46 -0400
Received: from relay.parallels.com ([195.214.232.42]:41069 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaI3IXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:23:43 -0400
Message-ID: <1412065417.20287.24.camel@tkhai>
Subject: Re: [PATCH] sched: Use RCU read lock on all calls to dl_bw_of()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <sasha.levin@oracle.com>, <mingo@kernel.org>,
        <torvalds@linux-foundation.org>, <paulmck@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 30 Sep 2014 12:23:37 +0400
In-Reply-To: <20140929170022.GA18926@worktop.programming.kicks-ass.net>
References: <1412003970-25277-1-git-send-email-sasha.levin@oracle.com>
	 <1412009027.20287.17.camel@tkhai> <20140929165418.GQ5430@worktop>
	 <20140929170022.GA18926@worktop.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пн, 29/09/2014 в 19:00 +0200, Peter Zijlstra пишет:
> On Mon, Sep 29, 2014 at 06:54:18PM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 29, 2014 at 08:43:47PM +0400, Kirill Tkhai wrote:
> > > Thanks for your report. It looks like your fix is not enough, because
> > > we check for rcu_read_lock_sched_held() in dl_bw_of(). It still warns
> > > even if rcu_read_lock() is held.
> > > 
> > > I used rcu_read_lock_sched_held() because we free root_domain using
> > > call_rcu_sched(). So, it's necessary to held rcu_read_lock_sched(),
> > > and my initial commit has this problem too.
> > > 
> > > It looks like we should fix it in a way like this:
> > > 
> > > [PATCH]sched: Use dl_bw_of() under rcu_read_lock_sched()
> > > 
> > > rq->rd is freed using call_rcu_sched(), and it's accessed with preemption
> > > disabled in the most cases.
> > > 
> > > So in other places we should use rcu_read_lock_sched() to access it to fit
> > > the scheme:
> > > 
> > > rcu_read_lock_sched() or preempt_disable() <==> call_rcu_sched().
> > 
> > Hmm, sad that. I cannot remember why that is rcu_sched, I suspect
> > because we rely on it someplace but I cannot remember where.
> > 
> > We could of course do a double take on that and use call_rcu after
> > call_rcu_sched(), such that either or both are sufficient.
> > 
> > I would very much prefer not to add extra preempt_disable()s if
> > possible.
> 
> Ah wait, if we simply move that preempt_disable() inside the
> for_each_cpu() loop there's no harm done. Having them outside is painful
> though.

[PATCH]sched: Use dl_bw_of() under preempt_disable()

rq->rd is freed using call_rcu_sched(), so rcu_read_lock() to access it
is not enough. We should use either rcu_read_lock_sched() or preempt_disable().

We choose preempt_disable()/preempt_enable() like in other places
where rq->rd is used.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com
Fixes 66339c31bc39 "sched: Use dl_bw_of() under RCU read lock"
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 25e4513..e1a4d76 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5248,6 +5248,7 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 {
 	unsigned long flags;
 	long cpu = (long)hcpu;
+	struct dl_bw *dl_b;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
@@ -5255,15 +5256,19 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 
 		/* explicitly allow suspend */
 		if (!(action & CPU_TASKS_FROZEN)) {
-			struct dl_bw *dl_b = dl_bw_of(cpu);
 			bool overflow;
 			int cpus;
 
+			preempt_disable();
+			dl_b = dl_bw_of(cpu);
+
 			raw_spin_lock_irqsave(&dl_b->lock, flags);
 			cpus = dl_bw_cpus(cpu);
 			overflow = __dl_overflow(dl_b, cpus, 0, 0);
 			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
+			preempt_enable();
+
 			if (overflow)
 				return notifier_from_errno(-EBUSY);
 		}
@@ -7631,11 +7636,10 @@ static int sched_dl_global_constraints(void)
 	u64 runtime = global_rt_runtime();
 	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
+	struct dl_bw *dl_b;
 	int cpu, ret = 0;
 	unsigned long flags;
 
-	rcu_read_lock();
-
 	/*
 	 * Here we want to check the bandwidth not being set to some
 	 * value smaller than the currently allocated bandwidth in
@@ -7646,25 +7650,27 @@ static int sched_dl_global_constraints(void)
 	 * solutions is welcome!
 	 */
 	for_each_possible_cpu(cpu) {
-		struct dl_bw *dl_b = dl_bw_of(cpu);
+		preempt_disable();
+		dl_b = dl_bw_of(cpu);
 
 		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		if (new_bw < dl_b->total_bw)
 			ret = -EBUSY;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
+		preempt_enable();
+
 		if (ret)
 			break;
 	}
 
-	rcu_read_unlock();
-
 	return ret;
 }
 
 static void sched_dl_do_global(void)
 {
 	u64 new_bw = -1;
+	struct dl_bw *dl_b;
 	int cpu;
 	unsigned long flags;
 
@@ -7674,18 +7680,19 @@ static void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
-	rcu_read_lock();
 	/*
 	 * FIXME: As above...
 	 */
 	for_each_possible_cpu(cpu) {
-		struct dl_bw *dl_b = dl_bw_of(cpu);
+		preempt_disable();
+		dl_b = dl_bw_of(cpu);
 
 		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+		preempt_enable();
 	}
-	rcu_read_unlock();
 }
 
 static int sched_rt_global_validate(void)


