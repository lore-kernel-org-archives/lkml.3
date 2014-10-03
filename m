Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaJCF3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:29:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaJCF3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:29:11 -0400
Date: Thu, 2 Oct 2014 22:28:20 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-f10e00f4bf360c36edbe6bf18a6c75b171cbe012@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, ktkhai@parallels.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1412065417.20287.24.camel@tkhai>
References: <1412065417.20287.24.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/dl: Use dl_bw_of()
  under rcu_read_lock_sched()
Git-Commit-ID: f10e00f4bf360c36edbe6bf18a6c75b171cbe012
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f10e00f4bf360c36edbe6bf18a6c75b171cbe012
Gitweb:     http://git.kernel.org/tip/f10e00f4bf360c36edbe6bf18a6c75b171cbe012
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Tue, 30 Sep 2014 12:23:37 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 05:46:58 +0200

sched/dl: Use dl_bw_of() under rcu_read_lock_sched()

rq->rd is freed using call_rcu_sched(), so rcu_read_lock() to access it
is not enough. We should use either rcu_read_lock_sched() or preempt_disable().

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Fixes: 66339c31bc39 "sched: Use dl_bw_of() under RCU read lock"
Link: http://lkml.kernel.org/r/1412065417.20287.24.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5349fe..c84bdc0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5264,6 +5264,7 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 {
 	unsigned long flags;
 	long cpu = (long)hcpu;
+	struct dl_bw *dl_b;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
@@ -5271,15 +5272,19 @@ static int sched_cpu_inactive(struct notifier_block *nfb,
 
 		/* explicitly allow suspend */
 		if (!(action & CPU_TASKS_FROZEN)) {
-			struct dl_bw *dl_b = dl_bw_of(cpu);
 			bool overflow;
 			int cpus;
 
+			rcu_read_lock_sched();
+			dl_b = dl_bw_of(cpu);
+
 			raw_spin_lock_irqsave(&dl_b->lock, flags);
 			cpus = dl_bw_cpus(cpu);
 			overflow = __dl_overflow(dl_b, cpus, 0, 0);
 			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
+			rcu_read_unlock_sched();
+
 			if (overflow)
 				return notifier_from_errno(-EBUSY);
 		}
@@ -7647,11 +7652,10 @@ static int sched_dl_global_constraints(void)
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
@@ -7662,25 +7666,27 @@ static int sched_dl_global_constraints(void)
 	 * solutions is welcome!
 	 */
 	for_each_possible_cpu(cpu) {
-		struct dl_bw *dl_b = dl_bw_of(cpu);
+		rcu_read_lock_sched();
+		dl_b = dl_bw_of(cpu);
 
 		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		if (new_bw < dl_b->total_bw)
 			ret = -EBUSY;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
+		rcu_read_unlock_sched();
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
 
@@ -7690,18 +7696,19 @@ static void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
-	rcu_read_lock();
 	/*
 	 * FIXME: As above...
 	 */
 	for_each_possible_cpu(cpu) {
-		struct dl_bw *dl_b = dl_bw_of(cpu);
+		rcu_read_lock_sched();
+		dl_b = dl_bw_of(cpu);
 
 		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		dl_b->bw = new_bw;
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+		rcu_read_unlock_sched();
 	}
-	rcu_read_unlock();
 }
 
 static int sched_rt_global_validate(void)
