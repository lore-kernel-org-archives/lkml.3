Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaDYJnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:43:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:41421 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaDYJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:43:42 -0400
Date: Fri, 25 Apr 2014 11:43:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Jason Low <jason.low2@hp.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
Message-ID: <20140425094331.GF26782@laptop.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
 <5358E417.8090503@linux.vnet.ibm.com>
 <20140424120415.GS11096@twins.programming.kicks-ass.net>
 <20140424124438.GT13658@twins.programming.kicks-ass.net>
 <1398358417.3509.11.camel@j-VirtualBox>
 <20140424171453.GZ11096@twins.programming.kicks-ass.net>
 <5359EDDB.4060409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5359EDDB.4060409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 10:38:43AM +0530, Preeti U Murthy wrote:
> > But if it fails to pull anything, we'll (potentially) iterate the entire
> > tree up to the largest domain; and supposedly set next_balanced to the
> > largest possible interval.
> 
> *to the smallest possible interval.
> > 
> > So when we go from busy to idle (!pulled_task), we actually set
> > ->next_balance to the longest interval. Whereas the commit you
> > referenced says it sets it to a shorter while.
> 
> We will set next_balance to the earliest balance time among the sched
> domains iterated.

Duh. I read that time_after the wrong way around.. silly me :-)

> I am unable to understand how updating of rq->next_balance should depend
> solely on the pulled_task parameter( I am not considering the expiry of
> rq->next_balance here).
> 
> True that we will need to override the busy_factor in rq->next_balance
> if we do not pull any tasks and go to idle. Besides that however we will
> probably need to override rq->next_balance irrespective of whether we
> pull any tasks.
> 
> Lets look at what happens to the sd->balance_interval in load_balance().
> If we pull tasks then it is set to min_interval. If active balance
> occurs or if tasks are pinned then we push the interval farther away.In
> the former case where it is set to min_interval, pulled_tasks > 0, in
> the latter case, especially the pinned case, pulled_task=0 (not sure
> about the active balance case).
> 
> If after this modification on sd->balance_interval,
> rq->next_balance > sd->last_balance + sd->balance_interval then
> shouldn't we be resetting rq->next_balance? And if we should, then the
> dependence on pulled_tasks is not justified is it? All this assuming
> that rq->next_balance should always reflect the minimum value of
> sd->next_balance among the sched domains of which the rq is a part.

So how about something like this? It tracks the minimal next_balance for
whatever domains we do visit, or the very bottom domain in the
insta-bail case (but yeah, Mike's got a point.. we could think of
removing that).

The thought is that since the higher domains have larger intervals
anyway, its less likely they will move the timer back often, so skipping
them is not that big a deal.

I also considered tracking next_busy_balance and using that when
pulled_task, but I decided against it (after I'd actually written the
code to do so). We were on the brink of going idle, that's really not
busy.

---
 kernel/sched/fair.c | 58 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 43232b8bacde..2ac1ad3de6c6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6645,17 +6645,29 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	return ld_moved;
 }
 
+static inline void
+update_next_balance(struct sched_domain *sd, unsigned long *next_balance)
+{
+	unsigned long interval, next;
+
+	interval = msecs_to_jiffies(sd->balance_interval);
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
 	/*
@@ -6664,8 +6676,14 @@ static int idle_balance(struct rq *this_rq)
 	 */
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+	if (this_rq->avg_idle < sysctl_sched_migration_cost) {
+		rcu_read_lock();
+		update_next_balance(
+			rcu_dereference_check_sched_domain(this_rq->sd),
+			&next_balance);
+		rcu_read_unlock();
 		goto out;
+	}
 
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
@@ -6675,15 +6693,16 @@ static int idle_balance(struct rq *this_rq)
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
+			update_next_balance(sd, &next_balance);
 			break;
+		}
 
 		if (sd->flags & SD_BALANCE_NEWIDLE) {
 			t0 = sched_clock_cpu(this_cpu);
@@ -6700,9 +6719,7 @@ static int idle_balance(struct rq *this_rq)
 			curr_cost += domain_cost;
 		}
 
-		interval = msecs_to_jiffies(sd->balance_interval);
-		if (time_after(next_balance, sd->last_balance + interval))
-			next_balance = sd->last_balance + interval;
+		update_next_balance(sd, &next_balance);
 		if (pulled_task)
 			break;
 	}
@@ -6710,27 +6727,22 @@ static int idle_balance(struct rq *this_rq)
 
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
