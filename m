Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3GWLEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:04:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38038 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab3GWLEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:04:10 -0400
Date: Tue, 23 Jul 2013 13:03:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
Message-ID: <20130723110345.GX27075@twins.programming.kicks-ass.net>
References: <1374220211.5447.9.camel@j-VirtualBox>
 <20130722070144.GC5138@linux.vnet.ibm.com>
 <1374519467.7608.87.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374519467.7608.87.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 11:57:47AM -0700, Jason Low wrote:
> On Mon, 2013-07-22 at 12:31 +0530, Srikar Dronamraju wrote:
> > > 
> > > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > > index e8b3350..da2cb3e 100644
> > > --- a/kernel/sched/core.c
> > > +++ b/kernel/sched/core.c
> > > @@ -1348,6 +1348,8 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
> > >  		else
> > >  			update_avg(&rq->avg_idle, delta);
> > >  		rq->idle_stamp = 0;
> > > +
> > > +		rq->idle_duration = (rq->idle_duration + delta) / 2;
> > 
> > Cant we just use avg_idle instead of introducing idle_duration?
> 
> A potential issue I have found with avg_idle is that it may sometimes be
> not quite as accurate for the purposes of this patch, because it is
> always given a max value (default is 1000000 ns). For example, a CPU
> could have remained idle for 1 second and avg_idle would be set to 1
> millisecond. Another question I have is whether we can update avg_idle
> at all times without putting a maximum value on avg_idle, or increase
> the maximum value of avg_idle by a lot.

The only user of avg_idle is idle_balance(); since you're building a new
limiter we can completely scrap/rework avg_idle to do as you want it to.
No point in having two of them.

Also, we now have rq->cfs.{blocked,runnable}_load_avg that might help with
estimating if you're so inclined :-)

> > Should we take the consideration of whether a idle_balance was
> > successful or not?
> 
> I recently ran fserver on the 8 socket machine with HT-enabled and found
> that load balance was succeeding at a higher than average rate, but idle
> balance was still lowering performance of that workload by a lot.
> However, it makes sense to allow idle balance to run longer/more often
> when it has a higher success rate.
> 
> > I am not sure whats a reasonable value for n can be, but may be we could
> > try with n=3.
> 
> Based on some of the data I collected, n = 10 to 20 provides much better
> performance increases.

Right, so I'm still a bit puzzled by why this is so; maybe we're
over-estimating the idle duration due to significant variance in the
idle time?

Maybe we should try with something like the below to test this?


/*
 * http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
 */
struct stats {
	long mean;
	long M2;
	unsigned int n;
};

static void stats_update(struct stats *stats, long x)
{
	long delta;

	stats->n++;
	delta = x - stats->mean;
	stats->mean += delta / stats->n;
	stats->M2 += delta * (x - stats->mean);
}

static long stats_var(struct stats *stats)
{
	long variance;

	if (!stats->n)
		return 0;

	variance = stats->M2 / (stats->n - 1);

	return int_sqrt(variance);
}

static long stats_mean(struct stats *stats)
{
	return stats->mean;
}

> Yes, I have done quite a bit of testing with sched_migration_cost and
> adjusting it does help performance when idle balance overhead is high.
> But I have found that a higher value may decrease the performance during
> situations where the cost of idle_balance is not high. Additionally,
> when to modify this tunable and by how much to modify it by can
> sometimes be unpredictable. 

So the history if sched_migration_cost is that it used to be a per sd
value; see also:

  https://lkml.org/lkml/2008/9/4/215

Ingo wrote it initially for the O(1) scheduler and ripped it out when he
did CFS. He now doesn't like it because it introduces boot-to-boot
scheduling differences -- you never measure the exact numbers again.

That said, there is a case for restoring it since the one measure really
doesn't do justice to larger systems.
