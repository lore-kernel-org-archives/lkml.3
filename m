Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaDXQn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:43:26 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:36656 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaDXQnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:43:25 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 12:43:25 EDT
Message-ID: <1398357789.3509.6.camel@j-VirtualBox>
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com, aswin@hp.com,
        chegu_vinod@hp.com
Date: Thu, 24 Apr 2014 09:43:09 -0700
In-Reply-To: <20140424071541.GZ26782@laptop.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
	 <20140424071541.GZ26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 09:15 +0200, Peter Zijlstra wrote:
> On Wed, Apr 23, 2014 at 06:30:35PM -0700, Jason Low wrote:
> > It was found that when running some workloads (such as AIM7) on large systems
> > with many cores, CPUs do not remain idle for long. Thus, tasks can
> > wake/get enqueued while doing idle balancing.
> > 
> > In this patch, while traversing the domains in idle balance, in addition to
> > checking for pulled_task, we add an extra check for this_rq->nr_running for
> > determining if we should stop searching for tasks to pull. If there are
> > runnable tasks on this rq, then we will stop traversing the domains. This
> > reduces the chance that idle balance delays a task from running.
> > 
> > This patch resulted in approximately a 6% performance improvement when
> > running a Java Server workload on an 8 socket machine.
> > 
> > Signed-off-by: Jason Low <jason.low2@hp.com>
> > ---
> >  kernel/sched/fair.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 3e3ffb8..232518c 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -6689,7 +6689,6 @@ static int idle_balance(struct rq *this_rq)
> >  		if (sd->flags & SD_BALANCE_NEWIDLE) {
> >  			t0 = sched_clock_cpu(this_cpu);
> >  
> > -			/* If we've pulled tasks over stop searching: */
> >  			pulled_task = load_balance(this_cpu, this_rq,
> >  						   sd, CPU_NEWLY_IDLE,
> >  						   &continue_balancing);
> > @@ -6704,7 +6703,12 @@ static int idle_balance(struct rq *this_rq)
> >  		interval = msecs_to_jiffies(sd->balance_interval);
> >  		if (time_after(next_balance, sd->last_balance + interval))
> >  			next_balance = sd->last_balance + interval;
> > -		if (pulled_task)
> > +
> > +		/*
> > +		 * Stop searching for tasks to pull if there are
> > +		 * now runnable tasks on this rq.
> > +		 */
> > +		if (pulled_task || this_rq->nr_running > 0)
> >  			break;
> >  	}
> >  	rcu_read_unlock();
> 
> There's also the CONFIG_PREEMPT bit in move_tasks() does making that
> unconditional also help such a workload?

If the below patch is what you were referring to, I believe this
can help too. This was also something that I was testing out before
we went with those patches which compares avg_idle with idle balance
cost. I recall seeing somewhere around a +7% performance improvement
in at least least 1 of the AIM7 workloads. I can do some more testing
with this.

---
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 43232b8..d069054 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5304,7 +5304,6 @@ static int move_tasks(struct lb_env *env)
                pulled++;
                env->imbalance -= load;
 
-#ifdef CONFIG_PREEMPT
                /*
                 * NEWIDLE balancing is a source of latency, so preemptible
                 * kernels will stop after the first task is pulled to minimize
@@ -5312,7 +5311,6 @@ static int move_tasks(struct lb_env *env)
                 */
                if (env->idle == CPU_NEWLY_IDLE)
                        break;
-#endif
 
                /*
                 * We only want to steal up to the prescribed amount of


