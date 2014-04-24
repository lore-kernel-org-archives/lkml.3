Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbaDXO7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:59:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57051 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbaDXO7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:59:33 -0400
Date: Thu, 24 Apr 2014 16:59:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Jason Low <jason.low2@hp.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "aswin@hp.com" <aswin@hp.com>,
        "chegu_vinod@hp.com" <chegu_vinod@hp.com>
Subject: Re: [PATCH 3/3] sched, fair: Stop searching for tasks in newidle
 balance if there are runnable tasks
Message-ID: <20140424145925.GA27561@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
 <1398303035-18255-4-git-send-email-jason.low2@hp.com>
 <20140424103059.GL2500@e103034-lin>
 <20140424113231.GR11096@twins.programming.kicks-ass.net>
 <20140424140802.GM2500@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424140802.GM2500@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 03:08:02PM +0100, Morten Rasmussen wrote:
> On Thu, Apr 24, 2014 at 12:32:31PM +0100, Peter Zijlstra wrote:
> > On Thu, Apr 24, 2014 at 11:30:59AM +0100, Morten Rasmussen wrote:
> > > On Thu, Apr 24, 2014 at 02:30:35AM +0100, Jason Low wrote:
> > > > @@ -6704,7 +6703,12 @@ static int idle_balance(struct rq *this_rq)
> > > >  		interval = msecs_to_jiffies(sd->balance_interval);
> > > >  		if (time_after(next_balance, sd->last_balance + interval))
> > > >  			next_balance = sd->last_balance + interval;
> > > > -		if (pulled_task)
> > > > +
> > > > +		/*
> > > > +		 * Stop searching for tasks to pull if there are
> > > > +		 * now runnable tasks on this rq.
> > > > +		 */
> > > > +		if (pulled_task || this_rq->nr_running > 0)
> > > 
> > > Should this be cfs tasks instead?
> > > 
> > > +		if (pulled_task || this_rq->cfs.h_nr_running > 0)
> > > 
> > > 3.15-rc2 commit 35805ff8f4fc535ac85330170d3c56829c87c677 seems to
> > > indicate that using rq->nr_running may lead to trouble.
> > > 
> > > The other two patches look good to me.
> > 
> > No, this really wants to be nr_running, we want to bail the idle
> > balancer when there's anything runnable present.
> > 
> > Note how out: is very careful to return -1 (which results in RETRY_TASK)
> > when rq->nr_running != rq->cfs.h_nr_running.
> > 
> > That same out: test also makes problem that commit fixes impossible
> > again.
> 
> I should have done my homework properly. I may be missing something, but
> don't we risk bailing out of idle balance if there is a throttled rt
> task and go straight to idle?

Good point, depends, in tip/sched/core Kirill fixed that. For -linus
this is indeed a problem.

See patches:

46383648b3c7 sched: Revert commit 4c6c4e38c4e9 ("sched/core: Fix endless loop in pick_next_task()")
f4ebcbc0d7e0 sched/rt: Substract number of tasks of throttled queues from rq->nr_running
653d07a6989a sched/rt: Add accessors rq_of_rt_se()
22abdef37ceb sched/rt: Sum number of all children tasks in hierarhy at ->rt_nr_running

So for sched/core everything should be fine. This does mean I have to
queue this patch for /core and not /urgent (/me quickly moves).
