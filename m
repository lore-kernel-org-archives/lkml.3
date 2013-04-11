Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177Ab3DKQrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:47:37 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:41264 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934395Ab3DKQrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:47:36 -0400
Date: Thu, 11 Apr 2013 18:47:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 30/33] sched: Debug nohz rq clock
Message-ID: <20130411164723.GA17039@somewhere.redhat.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
 <1357610913-1080-31-git-send-email-fweisbec@gmail.com>
 <514A44F6.8010203@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514A44F6.8010203@deeprootsystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:23:34PM -0700, Kevin Hilman wrote:
> Hi Frederic,
> 
> On 01/07/2013 06:08 PM, Frederic Weisbecker wrote:
> > The runqueue clock is supposed to be periodically updated by the
> > tick. On full dynticks CPU we call update_nohz_rq_clock() before
> > reading it. Now the scheduler code is complicated enough that we
> > may miss some update_nohz_rq_clock() calls before reading the
> > runqueue clock.
> > 
> > This therefore introduce a new debugging feature that detects
> > when the rq clock is stale due to missing updates on full
> > dynticks CPUs.
> > 
> > This can be later expanded to debug stale clocks on dynticks-idle
> > CPUs.
> 
> [...]
> 
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index e1bac76..0fef0b3 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -502,16 +502,39 @@ DECLARE_PER_CPU(struct rq, runqueues);
> >  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
> >  #define raw_rq()		(&__raw_get_cpu_var(runqueues))
> >  
> > +static inline void rq_clock_check(struct rq *rq)
> > +{
> > +#if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_NO_HZ_FULL)
> > +	unsigned long long clock;
> > +	unsigned long flags;
> > +	int cpu;
> > +
> > +	cpu = cpu_of(rq);
> > +	if (!tick_nohz_full_cpu(cpu) || rq->curr == rq->idle)
> > +		return;
> > +
> > +	local_irq_save(flags);
> > +	clock = sched_clock_cpu(cpu_of(rq));
> > +	local_irq_restore(flags);
> > +
> > +	if (abs(clock - rq->clock) > (TICK_NSEC * 3))
> > +		WARN_ON_ONCE(1);
> > +#endif
> > +}
> 
> In working on the ARM port for full nohz, I'm hitting this
> warning early in the kernel boot, well before userspace starts
> (dump below[2].)
> 
> I've seen a few different variations of this, but the common
> thing for all of them is the use of wait_for_completion().
> 
> During boot, only swapper is running so it seems
> any waiting of sufficient length during boot will always trigger
> this warning.  The hack below[1] avoids checking for the init task,
> but I'm not sure if it's the right fix.
> 
> Kevin
> 
> [1]
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index f96329b..56e74df 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -512,7 +512,8 @@ static inline void rq_clock_check(struct rq *rq)
>  	int cpu;
> 
>  	cpu = cpu_of(rq);
> -	if (!tick_nohz_full_cpu(cpu) || rq->curr == rq->idle)
> +	if (!tick_nohz_full_cpu(cpu) || rq->curr == rq->idle ||
> +	    is_global_init(current))

Makes sense. But we seem to be taking a new direction there after feedback from Ingo
and Peterz: tag scheduler entry and exit points and invalidate on top of missing rq clock
updates since the last scheduler entry point.

thanks.
