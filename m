Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaFWPOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:14:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaFWPOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:14:38 -0400
Date: Mon, 23 Jun 2014 17:14:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        pjt@google.com, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [patch] sched: Fix
 clock_gettime(CLOCK_[PROCESS/THREAD]_CPUTIME_ID) monotonicity
Message-ID: <20140623151430.GE19860@laptop.programming.kicks-ass.net>
References: <1402910212.16584.4.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402910212.16584.4.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:16:52AM +0200, Mike Galbraith wrote:
> (disregard patch of same name from that enterprise weenie;)
> 
> If a task has been dequeued, it has been accounted.  Do not project
> cycles that may or may not ever be accounted to a dequeued task, as
> that may make clock_gettime() both inaccurate and non-monotonic.
> 
> Protect update_rq_clock() from slight TSC skew while at it.
> 
> Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
> ---
>  kernel/sched/core.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -144,6 +144,8 @@ void update_rq_clock(struct rq *rq)
>  		return;
>  
>  	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> +	if (delta < 0)
> +		return;
>  	rq->clock += delta;
>  	update_rq_clock_task(rq, delta);
>  }

Have you actually observed this? If TSC is stable this should not
happen, if TSC is not stable we should be using kernel/sched/clock.c
which should also avoid this, because while sched_clock_cpu(x) -
sched_clock_cpu(y) < 0 is possible, sched_clock_cpu(x) -
sched_clock_cpu(x) should always be >= 0.

I suppose it can happen when the TSC gets screwed and we haven't
switched to the slow path yet.

> @@ -2533,7 +2535,12 @@ static u64 do_task_delta_exec(struct tas
>  {
>  	u64 ns = 0;
>  
> -	if (task_current(rq, p)) {
> +	/*
> +	 * Must be ->curr, ->on_cpu _and_ ->on_rq.  If dequeued, we
> +	 * would project cycles that may never be accounted to this
> +	 * thread, breaking clock_gettime().
> +	 */
> +	if (task_current(rq, p) && p->on_cpu && p->on_rq) {

do we still need ->on_cpu in this case?
