Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab3GVS5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:57:54 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:15694 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932957Ab3GVS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:57:53 -0400
Message-ID: <1374519467.7608.87.camel@j-VirtualBox>
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
From: Jason Low <jason.low2@hp.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Mon, 22 Jul 2013 11:57:47 -0700
In-Reply-To: <20130722070144.GC5138@linux.vnet.ibm.com>
References: <1374220211.5447.9.camel@j-VirtualBox>
	 <20130722070144.GC5138@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 12:31 +0530, Srikar Dronamraju wrote:
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index e8b3350..da2cb3e 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1348,6 +1348,8 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
> >  		else
> >  			update_avg(&rq->avg_idle, delta);
> >  		rq->idle_stamp = 0;
> > +
> > +		rq->idle_duration = (rq->idle_duration + delta) / 2;
> 
> Cant we just use avg_idle instead of introducing idle_duration?

A potential issue I have found with avg_idle is that it may sometimes be
not quite as accurate for the purposes of this patch, because it is
always given a max value (default is 1000000 ns). For example, a CPU
could have remained idle for 1 second and avg_idle would be set to 1
millisecond. Another question I have is whether we can update avg_idle
at all times without putting a maximum value on avg_idle, or increase
the maximum value of avg_idle by a lot.

> Should we take the consideration of whether a idle_balance was
> successful or not?

I recently ran fserver on the 8 socket machine with HT-enabled and found
that load balance was succeeding at a higher than average rate, but idle
balance was still lowering performance of that workload by a lot.
However, it makes sense to allow idle balance to run longer/more often
when it has a higher success rate.

> I am not sure whats a reasonable value for n can be, but may be we could
> try with n=3.

Based on some of the data I collected, n = 10 to 20 provides much better
performance increases.

> Also have we checked the performance after adjusting the
> sched_migration_cost tunable?
> 
> I guess, if we increase the sched_migration_cost, we should have lesser
> newly idle balance requests. 

Yes, I have done quite a bit of testing with sched_migration_cost and
adjusting it does help performance when idle balance overhead is high.
But I have found that a higher value may decrease the performance during
situations where the cost of idle_balance is not high. Additionally,
when to modify this tunable and by how much to modify it by can
sometimes be unpredictable. 

Thanks,
Jason

