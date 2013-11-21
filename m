Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3KUNju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:39:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47499 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3KUNjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:39:48 -0500
Date: Thu, 21 Nov 2013 14:39:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: Clean up preempt_enable_no_resched() abuse
Message-ID: <20131121133936.GF10022@twins.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
 <20131120162736.691879744@infradead.org>
 <528CF94E.8020300@linux.intel.com>
 <20131121101018.GX10022@twins.programming.kicks-ass.net>
 <528E09F9.9030501@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528E09F9.9030501@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 03:26:17PM +0200, Eliezer Tamir wrote:
> On 21/11/2013 12:10, Peter Zijlstra wrote:
> > On Wed, Nov 20, 2013 at 08:02:54PM +0200, Eliezer Tamir wrote:
> >> IMHO This has been reviewed thoroughly.
> >>
> >> When Ben Hutchings voiced concerns I rewrote the code to use time_after,
> >> so even if you do get switched over to a CPU where the time is random
> >> you will at most poll another full interval.
> >>
> >> Linus asked me to remove this since it makes us use two time values
> >> instead of one. see https://lkml.org/lkml/2013/7/8/345.
> > 
> > I'm not sure I see how this would be true.
> > 
> > So the do_select() code basically does:
> > 
> >   for (;;) {
> > 
> >     /* actual poll loop */
> > 
> >     if (!need_resched()) {
> >       if (!busy_end) {
> > 	busy_end = now() + busypoll;
> > 	continue;
> >       }
> >       if (!((long)(busy_end - now()) < 0))
> > 	continue;
> >     }
> > 
> >     /* go sleep */
> > 
> >   }
> > 
> > So imagine our CPU0 timebase is 1 minute ahead of CPU1 (60e9 vs 0), and we start by:
> > 
> >   busy_end = now() + busypoll; /* CPU0: 60e9 + d */
> > 
> > but then we migrate to CPU1 and do:
> > 
> >   busy_end - now() /* CPU1: 60e9 + d' */
> > 
> > and find we're still a minute out; and in fact we'll keep spinning for
> > that entire minute barring a need_resched().
> 
> not exactly, poll will return if there are any events to report of if
> a signal is pending.

Sure, but lacking any of those, you're now busy waiting for a minute.

> > Surely that's not intended and desired?
> 
> This limit is an extra safety net, because busy polling is expensive,
> we limit the time we are willing to do it.

I just said your limit 'sysctl_net_busy_poll' isn't meaningful in any
way shape or fashion.

> We don't override any limit the user has put on the system call.

You are in fact, note how the normal select @endtime argument is only
set up _after_ you're done polling. So if the syscall had a timeout of 5
seconds, you just blew it by 55.

> A signal or having events to report will also stop the looping.
> So we are mostly capping the resources an _idle_ system will waste
> on busy polling.

Repeat, you're not actually capping anything.

> We want to globally cap the amount of time the system busy polls, on
> average. Nothing catastrophic will happen in the extremely rare occasion
> that we miss.
> 
> The alternative is to use one more int on every poll/select all the
> time, this seems like a bigger cost.

No, 'int' has nothing to do with it, using a semi-sane timesource does.
