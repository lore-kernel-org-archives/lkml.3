Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaFWRHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:07:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35622 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaFWRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:07:28 -0400
Message-ID: <1403543240.5850.23.camel@marge.simpson.net>
Subject: Re: [patch] sched: Fix
 clock_gettime(CLOCK_[PROCESS/THREAD]_CPUTIME_ID) monotonicity
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        pjt@google.com, kosaki.motohiro@jp.fujitsu.com
Date: Mon, 23 Jun 2014 19:07:20 +0200
In-Reply-To: <20140623151430.GE19860@laptop.programming.kicks-ass.net>
References: <1402910212.16584.4.camel@marge.simpson.net>
	 <20140623151430.GE19860@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 17:14 +0200, Peter Zijlstra wrote: 
> On Mon, Jun 16, 2014 at 11:16:52AM +0200, Mike Galbraith wrote:
> > (disregard patch of same name from that enterprise weenie;)
> > 
> > If a task has been dequeued, it has been accounted.  Do not project
> > cycles that may or may not ever be accounted to a dequeued task, as
> > that may make clock_gettime() both inaccurate and non-monotonic.
> > 
> > Protect update_rq_clock() from slight TSC skew while at it.
> > 
> > Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
> > ---
> >  kernel/sched/core.c |   13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> > 
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -144,6 +144,8 @@ void update_rq_clock(struct rq *rq)
> >  		return;
> >  
> >  	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> > +	if (delta < 0)
> > +		return;
> >  	rq->clock += delta;
> >  	update_rq_clock_task(rq, delta);
> >  }
> 
> Have you actually observed this? If TSC is stable this should not
> happen, if TSC is not stable we should be using kernel/sched/clock.c
> which should also avoid this, because while sched_clock_cpu(x) -
> sched_clock_cpu(y) < 0 is possible, sched_clock_cpu(x) -
> sched_clock_cpu(x) should always be >= 0.
> 
> I suppose it can happen when the TSC gets screwed and we haven't
> switched to the slow path yet.

Seen, no.   I saw it while eyeballing, and thought making it impossible
for a dinky offset to create a negative delta would be a better plan
than hoping such don't exist in the wild.

> > @@ -2533,7 +2535,12 @@ static u64 do_task_delta_exec(struct tas
> >  {
> >  	u64 ns = 0;
> >  
> > -	if (task_current(rq, p)) {
> > +	/*
> > +	 * Must be ->curr, ->on_cpu _and_ ->on_rq.  If dequeued, we
> > +	 * would project cycles that may never be accounted to this
> > +	 * thread, breaking clock_gettime().
> > +	 */
> > +	if (task_current(rq, p) && p->on_cpu && p->on_rq) {
> 
> do we still need ->on_cpu in this case?

Damn, I had a reason for leaving that, but seems no now.

I don't see why we need to play the accounting projection game at all
really.  If what's accounted at call time isn't good enough, we should
be doing real accounting, not prognostication.

Anyway, I'll retest with the on_cpu dropped, which should either make me
remember why I felt it should stay, or give me cause to make it gone :)

-Mike

