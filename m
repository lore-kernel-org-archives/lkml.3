Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3LRPjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:39:04 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39494 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3LRPjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:39:03 -0500
Date: Wed, 18 Dec 2013 16:38:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 05/13] rcu: Fix unraised IPI to timekeeping CPU
Message-ID: <20131218153857.GF18464@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
 <20131218121204.GS13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218121204.GS13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 01:12:04PM +0100, Peter Zijlstra wrote:
> On Tue, Dec 17, 2013 at 11:51:24PM +0100, Frederic Weisbecker wrote:
> > -			rcu_kick_nohz_cpu(tick_do_timer_cpu);
> > +			smp_send_reschedule(tick_do_timer_cpu);
> 
> Hurm.. so I don't really like this (same for the other patches doing the
> similar change).

Hehe, I knew you wouldn't like it :)
To be honest I'm not very happy with this change either.

> 
> Why not have a function called: wake_time_keeper_cpu(), and have that do
> the right thing?
> 
> Also, afaict, all you want is that remote cpu to run
> tick_nohz_full_check(), right?

Not only. There are two kind of IPIs we are interested in in full dynticks
environment:

1) Calls to tick_nohz_full_check() to make full dynticks CPUs to reevaluate
their tick. This must be called from IRQ to avoid crazy locking scenarios
from deep callers in place like scheduler internals.

So this one is currently implemented by scheduler_ipi() upstream.

2) Timekeeping kick: when a full dynticks CPU wakes up, it needs a housekeeping
CPU to run the timekeeping duty on its behalf. But it's possible that all
housekeeping CPUs are sleeping, so we need to kick one of them with an IPI.

In this case we don't need to call a specific handler, we are only interested in
calling irq_exit(). Although, thinking about it more, having a real handler would
make the code less complicated because then we can modify tick_do_timer_cpu
locally. And that should simplify a few things.


> So why are you (ab)using the scheduler_ipi for this at all?

So, I've been cowardly using it as a swiss army knife IPI ;-)
After the BKL, the BKT (Big kernel timer), the BKI (big kernel IPI) ;-)

> Why not have
> something like:
> 
> static DEFINE_PER_CPU(struct call_single_data, nohz_full_csd);
> 
> int init_nohz_full(void)
> {
> 	int cpu;
> 
> 	for_each_possible_cpu(cpu) {
> 		struct call_single_data *csd = &per_cpu(nohz_full_csd, cpu);
> 
> 		csd->flags = 0;
> 		csd->func = &tick_nohz_full_check;
> 		csd->info = NULL;
> 	}
> 
> 	return 0;
> }
> 
> void wake_time_keeper_cpu(void)
> {
> 	int cpu = pick_timekeeper_cpu();
> 	struct single_call_data *csd = &per_cpu(nohz_full_csd, cpu);
> 
> 	__smp_call_function_single(cpu, csd, 0);
> }

That's because I can't call smp_call_function_single() with interrupts disabled.

BTW this warning in __smp_call_function_single() looks wrong:

    WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
    	      && !oops_in_progress)

I think we want to warn on irqs_disabled() even if !wait, because we wait for csd lock
anyway before raising the IPI.

Anyway so what I need is an IPI that can be raised with irqs disabled. And abusing the
scheduler IPI with ugliness after the other is obsviously not what we want.

So I wonder if we could change these smp_call_function_*() to use llist and behave closer
to what irq_work does.

Like: enqueue the llist_entry, if it's already enqueued then the remote CPU is going to
execute the callback so we are good. But may be we lose some ordering guarantees in
this case:

   store A        exec IPI
   raise IPI      load A

is perhaps not guaranteed anymore if the callback is already queued when we want to
add it and thus we don't raise the IPI. Althouth llist_add() failure perhaps brings
the atomic + full barrier that we need. So on the other side, llist_get() provides
the atomic + barrier that are needed such that the remote CPU sees our latest state.

Now may be I'm missing something obvious there, but that would allow us to drop that csd
thing.

I think that Christophe Hellwig had patches to drop csd and make smp.c lockless, I don't
recall the details though.
