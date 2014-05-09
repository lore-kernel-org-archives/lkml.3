Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaEIAt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 20:49:27 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:53293 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbaEIAtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 20:49:25 -0400
Message-ID: <1399596562.2200.7.camel@j-VirtualBox>
Subject: Re: [PATCH 2/2] sched: Fix next_balance logic in
 rebalance_domains() and idle_balance()
From: Jason Low <jason.low2@hp.com>
To: Ingo Molnar <mingo@kernel.org>, Jason Low <jason.low2@hp.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        daniel.lezcano@linaro.org, alex.shi@linaro.org,
        preeti@linux.vnet.ibm.com, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com
Date: Thu, 08 May 2014 17:49:22 -0700
In-Reply-To: <1399587244.2030.59.camel@j-VirtualBox>
References: <1398725155-7591-1-git-send-email-jason.low2@hp.com>
	 <1398725155-7591-3-git-send-email-jason.low2@hp.com>
	 <1399568364.2030.9.camel@j-VirtualBox> <20140508173835.GB9838@gmail.com>
	 <1399587244.2030.59.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-08 at 15:14 -0700, Jason Low wrote:
> Hi Ingo, Peter,
> 
> Were there NULL domains on the test system? If so, I think we can
> address the problem by doing update_next_balance() only if the below
> rcu_dereference_check_sched_domain() returns a non-null domain.

Also, below is a patch which has the change:

---

Subject: [PATCH v2] sched: Fix next_balance logic in rebalance_domains()

v1->v2:
- Address a potential null pointer dereference.

Currently, in idle_balance(), we update rq->next_balance when we pull_tasks.
However, it is also important to update this in the !pulled_tasks case too.

When the CPU is "busy" (the CPU isn't idle), rq->next_balance gets computed
using sd->busy_factor (so we increase the balance interval when the CPU is
busy). However, when the CPU goes idle, rq->next_balance could still be set
to a large value that was computed with the sd->busy_factor.

Thus, we need to also update rq->next_balance in idle_balance() in the cases
where !pulled_tasks too, so that rq->next_balance gets updated without taking
the busy_factor into account when the CPU is about to go idle.

This patch makes rq->next_balance get updated independently of whether or
not we pulled_task. Also, we add logic to ensure that we always traverse
at least 1 of the sched domains to get a proper next_balance value for
updating rq->next_balance.

Additionally, since load_balance() modifies the sd->balance_interval, we
need to re-obtain the sched domain's interval after the call to
load_balance() in rebalance_domains() before we update rq->next_balance.

This patch adds and uses 2 new helper functions, update_next_balance() and
get_sd_balance_interval() to update next_balance and obtain the sched
domain's balance_interval.

Cc: daniel.lezcano@linaro.org
Cc: alex.shi@linaro.org   
Cc: preeti@linux.vnet.ibm.com
Cc: efault@gmx.de
Cc: vincent.guittot@linaro.org
Cc: morten.rasmussen@arm.com
Cc: aswin@hp.com
Cc: mingo@kernel.org
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/fair.c |   69 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28ccf50..57b7390 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6669,17 +6669,44 @@ out:
 	return ld_moved;
 }
 
+static inline unsigned long
+get_sd_balance_interval(struct sched_domain *sd, int cpu_busy)
+{
+	unsigned long interval = sd->balance_interval;
+
+	if (cpu_busy)
+		interval *= sd->busy_factor;
+
+	/* scale ms to jiffies */
+	interval = msecs_to_jiffies(interval);
+	interval = clamp(interval, 1UL, max_load_balance_interval);
+
+	return interval;
+}
+
+static inline void
+update_next_balance(struct sched_domain *sd, int cpu_busy, unsigned long *next_balance)
+{
+	unsigned long interval, next;
+
+	interval = get_sd_balance_interval(sd, cpu_busy);
+	next = sd->last_balance + interval;
+
+	if (time_after(*next_balance, next))
+		*next_balance = next;
+}
+
 /*
  * idle_balance is called by schedule() if this_cpu is about to become
  * idle. Attempts to pull tasks from other CPUs.
  */
 static int idle_balance(struct rq *this_rq)
 {
+	unsigned long next_balance = jiffies + HZ;
+	int this_cpu = this_rq->cpu;
 	struct sched_domain *sd;
 	int pulled_task = 0;
-	unsigned long next_balance = jiffies + HZ;
 	u64 curr_cost = 0;
-	int this_cpu = this_rq->cpu;
 
 	idle_enter_fair(this_rq);
 
@@ -6689,8 +6716,15 @@ static int idle_balance(struct rq *this_rq)
 	 */
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+	if (this_rq->avg_idle < sysctl_sched_migration_cost) {
+		rcu_read_lock();
+		sd = rcu_dereference_check_sched_domain(this_rq->sd);
+		if (sd)
+			update_next_balance(sd, 0, &next_balance);
+		rcu_read_unlock();
+
 		goto out;
+	}
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6700,15 +6734,16 @@ static int idle_balance(struct rq *this_rq)
 	update_blocked_averages(this_cpu);
 	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
-		unsigned long interval;
 		int continue_balancing = 1;
 		u64 t0, domain_cost;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
-		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost)
+		if (this_rq->avg_idle < curr_cost + sd->max_newidle_lb_cost) {
+			update_next_balance(sd, 0, &next_balance);
 			break;
+		}
 
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			t0 = sched_clock_cpu(this_cpu);
@@ -6724,9 +6759,7 @@ static int idle_balance(struct rq *this_rq)
 			curr_cost += domain_cost;
 		}
 
-		interval = msecs_to_jiffies(sd->balance_interval);
-		if (time_after(next_balance, sd->last_balance + interval))
-			next_balance = sd->last_balance + interval;
+		update_next_balance(sd, 0, &next_balance);
 
 		/*
 		 * Stop searching for tasks to pull if there are
@@ -6750,15 +6783,11 @@ static int idle_balance(struct rq *this_rq)
 	if (this_rq->cfs.h_nr_running && !pulled_task)
 		pulled_task = 1;
 
-	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
-		/*
-		 * We are going idle. next_balance may be set based on
-		 * a busy processor. So reset next_balance.
-		 */
+out:
+	/* Move the next balance forward */
+	if (time_after(this_rq->next_balance, next_balance))
 		this_rq->next_balance = next_balance;
-	}
 
-out:
 	/* Is there a task of a high priority class? */
 	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
 		pulled_task = -1;
@@ -7041,16 +7070,9 @@ static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
 			break;
 		}
 
-		interval = sd->balance_interval;
-		if (idle != CPU_IDLE)
-			interval *= sd->busy_factor;
-
-		/* scale ms to jiffies */
-		interval = msecs_to_jiffies(interval);
-		interval = clamp(interval, 1UL, max_load_balance_interval);
+		interval = get_sd_balance_interval(sd, idle != CPU_IDLE);
 
 		need_serialize = sd->flags & SD_SERIALIZE;
-
 		if (need_serialize) {
 			if (!spin_trylock(&balancing))
 				goto out;
@@ -7066,6 +7088,7 @@ static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
 				idle = idle_cpu(cpu) ? CPU_IDLE : CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
+			interval = get_sd_balance_interval(sd, idle != CPU_IDLE);
 		}
 		if (need_serialize)
 			spin_unlock(&balancing);
-- 
1.7.1



