Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3LROt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:49:27 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46745 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab3LROtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:49:24 -0500
Date: Wed, 18 Dec 2013 15:49:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 07/13] sched: Enable IPI reception on timekeeper under
 nohz full system
Message-ID: <20131218144915.GD18464@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-8-git-send-email-fweisbec@gmail.com>
 <20131217235248.GJ19211@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217235248.GJ19211@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 03:52:48PM -0800, Paul E. McKenney wrote:
> On Tue, Dec 17, 2013 at 11:51:26PM +0100, Frederic Weisbecker wrote:
> > We need the default timekeeping CPU to be able to receive IPIs sent
> > from full dynticks CPUs when they wake up from full system idle state.
> > 
> > Therefore we need an entrypoint from the scheduler IPI so that the
> > need to poll on timekeeping duty is re-evaluated from irq_exit().
> > 
> > In order to achieve this, lets take the scheduler IPI everytime as long
> > as there is at least one full dynticks CPU around. Full dynticks CPUs
> > are interested too in taking scheduler IPIs to reevaluate their tick.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: John Stultz <john.stultz@linaro.org>
> > Cc: Alex Shi <alex.shi@linaro.org>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > ---
> >  kernel/sched/core.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index e85cda2..f46a7bc 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1502,9 +1502,9 @@ void scheduler_ipi(void)
> >  	if (tif_need_resched())
> >  		set_preempt_need_resched();
> > 
> > -	if (llist_empty(&this_rq()->wake_list)
> > -			&& !tick_nohz_full_cpu(smp_processor_id())
> > -			&& !got_nohz_idle_kick())
> > +	if (llist_empty(&this_rq()->wake_list) &&
> > +	    !tick_nohz_full_enabled() &&
> > +	    !got_nohz_idle_kick())
> >  		return;
> 
> OK, this is what I was missing in my question about whether the
> NO_HZ_FULL state was re-evaluated in the interrupt-return path.

I tend to write my patchset by splitting every single logical bricks and then only
in the end I enable the feature.

But that makes a tradeoff between patchset granularity and global overview. And in the end,
may be it's unbalanced toward overview.

Notwithstanding bisectability.

I remember I had similar reactions when I posted the initial full nohz patchset.

OTOH it's not good to have big all-in-one patches. And granular patchsets like this
are better to focus discussions on each isolated topics.

There is a hard balance to find out here.
 
> 						Thanx, Paul
> 
> >  	/*
> > -- 
> > 1.8.3.1
> > 
> 
