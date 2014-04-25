Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaDYTyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:54:22 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:17471 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaDYTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:54:18 -0400
Message-ID: <1398455654.2102.29.camel@j-VirtualBox>
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Date: Fri, 25 Apr 2014 12:54:14 -0700
In-Reply-To: <20140425094331.GF26782@laptop.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
	 <5358E417.8090503@linux.vnet.ibm.com>
	 <20140424120415.GS11096@twins.programming.kicks-ass.net>
	 <20140424124438.GT13658@twins.programming.kicks-ass.net>
	 <1398358417.3509.11.camel@j-VirtualBox>
	 <20140424171453.GZ11096@twins.programming.kicks-ass.net>
	 <5359EDDB.4060409@linux.vnet.ibm.com>
	 <20140425094331.GF26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 11:43 +0200, Peter Zijlstra wrote:
> So how about something like this? It tracks the minimal next_balance for
> whatever domains we do visit, or the very bottom domain in the
> insta-bail case (but yeah, Mike's got a point.. we could think of
> removing that).
> 
> The thought is that since the higher domains have larger intervals
> anyway, its less likely they will move the timer back often, so skipping
> them is not that big a deal.
> 
> I also considered tracking next_busy_balance and using that when
> pulled_task, but I decided against it (after I'd actually written the
> code to do so). We were on the brink of going idle, that's really not
> busy.

Preeti mentioned that sd->balance_interval is changed during load_balance().
Should we also consider updating the interval in rebalance_domains() after
calling load_balance(), and also taking max_load_balance_interval into account
in the updates for next_balance in idle_balance()?

If so, how about the something like the below change which also introduces
get_sd_balance_interval() to obtain the sd's balance interval, and have both
update_next_balance() and rebalance_domains() use that function.


Signed-off-by: Jason Low <jason.low2@hp.com>
---
 kernel/sched/fair.c |   81 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 43232b8..09c546c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6645,27 +6645,59 @@ out:
 	return ld_moved;
 }
 
+static inline unsigned long get_sd_balance_interval(struct sched_domain *sd, int busy)
+{
+	unsigned long interval = sd->balance_interval;
+
+	if (busy)
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
+update_next_balance(struct sched_domain *sd, int busy, unsigned long *next_balance)
+{
+	unsigned long interval, next;
+
+	interval = get_sd_balance_interval(sd, busy);
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
+
 	/*
 	 * We must set idle_stamp _before_ calling idle_balance(), such that we
 	 * measure the duration of idle_balance() as idle time.
 	 */
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+	if (this_rq->avg_idle < sysctl_sched_migration_cost) {
+		rcu_read_lock();
+		sd = rcu_dereference_check_sched_domain(this_rq->sd);
+		update_next_balance(sd, 0, &next_balance);
+		rcu_read_unlock();
 		goto out;
+	}
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6675,15 +6707,16 @@ static int idle_balance(struct rq *this_rq)
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
@@ -6700,9 +6733,7 @@ static int idle_balance(struct rq *this_rq)
 			curr_cost += domain_cost;
 		}
 
-		interval = msecs_to_jiffies(sd->balance_interval);
-		if (time_after(next_balance, sd->last_balance + interval))
-			next_balance = sd->last_balance + interval;
+		update_next_balance(sd, 0, &next_balance);
 		if (pulled_task)
 			break;
 	}
@@ -6710,27 +6741,22 @@ static int idle_balance(struct rq *this_rq)
 
 	raw_spin_lock(&this_rq->lock);
 
+	if (curr_cost > this_rq->max_idle_balance_cost)
+		this_rq->max_idle_balance_cost = curr_cost;
+
 	/*
-	 * While browsing the domains, we released the rq lock.
-	 * A task could have be enqueued in the meantime
+	 * While browsing the domains, we released the rq lock, a task could
+	 * have be enqueued in the meantime. Since we're not going idle,
+	 * pretend we pulled a task.
 	 */
-	if (this_rq->cfs.h_nr_running && !pulled_task) {
+	if (this_rq->cfs.h_nr_running && !pulled_task)
 		pulled_task = 1;
-		goto out;
-	}
 
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
-
-	if (curr_cost > this_rq->max_idle_balance_cost)
-		this_rq->max_idle_balance_cost = curr_cost;
 
-out:
 	/* Is there a task of a high priority class? */
 	if (this_rq->nr_running != this_rq->cfs.h_nr_running)
 		pulled_task = -1;
@@ -7013,13 +7039,7 @@ static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
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
 
@@ -7038,6 +7058,7 @@ static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
 				idle = idle_cpu(cpu) ? CPU_IDLE : CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
+			interval = get_sd_balance_interval(sd, idle != CPU_IDLE);
 		}
 		if (need_serialize)
 			spin_unlock(&balancing);
-- 
1.7.1



