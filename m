Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaAJPSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:18:08 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48200 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaAJPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:18:06 -0500
Date: Fri, 10 Jan 2014 16:17:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] sched/nohz: add debugfs control over
 sched_tick_max_deferment
Message-ID: <20140110151753.GA15280@localhost.localdomain>
References: <1387315388-31676-1-git-send-email-khilman@linaro.org>
 <20140105132153.GA25212@localhost.localdomain>
 <87eh4lez2w.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh4lez2w.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 10:37:27AM -0800, Kevin Hilman wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > On Tue, Dec 17, 2013 at 01:23:07PM -0800, Kevin Hilman wrote:
> >> Allow debugfs override of sched_tick_max_deferment in order to ease
> >> finding/fixing the remaining issues with full nohz.
> >> 
> >> The value to be written is in jiffies, and -1 means the max deferment
> >> is disabled (scheduler_tick_max_deferment() returns KTIME_MAX.)
> >> 
> >> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> >> ---
> >>  kernel/sched/core.c | 16 +++++++++++++++-
> >>  1 file changed, 15 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >> index 5ac63c9a995a..4b1fe3e69fe4 100644
> >> --- a/kernel/sched/core.c
> >> +++ b/kernel/sched/core.c
> >> @@ -2175,6 +2175,8 @@ void scheduler_tick(void)
> >>  }
> >>  
> >>  #ifdef CONFIG_NO_HZ_FULL
> >> +static u32 sched_tick_max_deferment = HZ;
> >> +
> >>  /**
> >>   * scheduler_tick_max_deferment
> >>   *
> >> @@ -2193,13 +2195,25 @@ u64 scheduler_tick_max_deferment(void)
> >>  	struct rq *rq = this_rq();
> >>  	unsigned long next, now = ACCESS_ONCE(jiffies);
> >>  
> >> -	next = rq->last_sched_tick + HZ;
> >> +	if (sched_tick_max_deferment == -1)
> >> +		return KTIME_MAX;
> >> +
> >> +	next = rq->last_sched_tick + sched_tick_max_deferment;
> >>  
> >>  	if (time_before_eq(next, now))
> >>  		return 0;
> >>  
> >>  	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
> >>  }
> >> +
> >> +static __init int sched_nohz_full_init_debug(void)
> >> +{
> >> +	debugfs_create_u32("sched_tick_max_deferment", 0644, NULL,
> >> +			   &sched_tick_max_deferment);
> >> +
> >> +	return 0;
> >> +}
> >> +late_initcall(sched_nohz_full_init_debug);
> >
> > If the goal is mostly to turn off sched_tick_max_deferment (set to -1), we should
> > perhaps make it a boolean sched feature (see kernel/sched/features.h) as it's a pretty
> > well consolidated interface.
> 
> Well, I suspect folks may want to set it to various values, depending on
> workload to experiment with the results.

Another option is to add an integer file in sched_features/ debugfs directory. But all other
files there are boolean, so that wouldn't integrate there very well.

One of the things I would like to try is to offline sched_class(current[$CPU])::scheduler_tick()
to the timekeeper or any housekeeping CPU.

So the housekeeper could handle the periodic tick on behalf of full dynticks CPUs. And then
being able to tune the frequency of this sounds interesting.

So yeah having an tunable integer makes sense after all.

> 
> Also, my first attempt was to add control over this via sysctl[1] (though
> not sched_features) and you suggested[2] I use debugfs instead since this
> should be a temporary hack until we can remove the 1Hz residual tick.

Right, but SCHED_FEAT are debugfs :)  And I thought we could either reuse it
or reuse the sched feature debugfs directory. But again I realize it's all made of bool values
so it's not very welcoming for consistency.

Anyway thinking about it more, perhaps we should actually use your patch that use sysctl since
the rest of the scheduler does that for tunable numbers.

Now since it's sysctl, I'm kind of more picky about correctness limits: what if people set high values,
thinking the kernel can handle them just fine, while it can't yet obviously? Should we ignore values that
goes too far? And how to we draw the line?

Thoughts?

> Kevin
> 
> [1] http://marc.info/?l=linux-kernel&m=137159992306877&w=2
> [2] http://marc.info/?l=linux-kernel&m=137166737830821&w=2
