Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaBZF5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:57:13 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:47082 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaBZF5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:57:11 -0500
Date: Wed, 26 Feb 2014 00:59:10 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <20140224112839.GQ15586@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1402260054560.17626@vincent-weaver-1.um.maine.edu>
References: <20140217152859.GF15586@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu> <20140219101949.GG15586@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu> <20140220100830.GN6835@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1402201302150.24360@vincent-weaver-1.um.maine.edu> <20140220182300.GN9987@twins.programming.kicks-ass.net>
 <20140221150312.GF3104@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402211514560.6395@vincent-weaver-1.um.maine.edu> <20140224112839.GQ15586@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Peter Zijlstra wrote:

> On Fri, Feb 21, 2014 at 03:18:38PM -0500, Vince Weaver wrote:
> > I've applied the patch and have been unable to trigger the warning with 
> > either my testcase or a few hours of fuzzing.
> 
> Yay.
> 
> > My only comment on the patch is it could always use some comments.
> > 
> > The perf_event code is really hard to follow as is, without adding
> > more uncommented special cases.
> 
> Does the below help a bit? Or is there anywhere in particular you want
> more comments?

yes, every little bit helps.

While chasing these fuzzer-related bugs I end up deep in the perf_event
code and many of the routines have no comments at all.  Eventually I have 
to dig out the K+R book to figure out order precendece of ++ prefix 
operators, have at least 2-3 different files open in editors, plus a bunch 
of firefox tabs open to http://lxr.free-electrons.com, and even then I 
misunderstand the code a lot.

Vince

> 
> ---
> Subject: perf, x86: Add a few more comments
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon Feb 24 12:26:21 CET 2014
> 
> Add a few comments on the ->add(), ->del() and ->*_txn()
> implementation.
> 
> Requested-by: Vince Weaver <vincent.weaver@maine.edu>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/kernel/cpu/perf_event.c |   49 +++++++++++++++++++++++++++------------
>  arch/x86/kernel/cpu/perf_event.h |    8 +++---
>  2 files changed, 39 insertions(+), 18 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -892,7 +892,6 @@ static void x86_pmu_enable(struct pmu *p
>  		 * hw_perf_group_sched_in() or x86_pmu_enable()
>  		 *
>  		 * step1: save events moving to new counters
> -		 * step2: reprogram moved events into new counters
>  		 */
>  		for (i = 0; i < n_running; i++) {
>  			event = cpuc->event_list[i];
> @@ -918,6 +917,9 @@ static void x86_pmu_enable(struct pmu *p
>  			x86_pmu_stop(event, PERF_EF_UPDATE);
>  		}
>  
> +		/*
> +		 * step2: reprogram moved events into new counters
> +		 */
>  		for (i = 0; i < cpuc->n_events; i++) {
>  			event = cpuc->event_list[i];
>  			hwc = &event->hw;
> @@ -1043,7 +1045,7 @@ static int x86_pmu_add(struct perf_event
>  	/*
>  	 * If group events scheduling transaction was started,
>  	 * skip the schedulability test here, it will be performed
> -	 * at commit time (->commit_txn) as a whole
> +	 * at commit time (->commit_txn) as a whole.
>  	 */
>  	if (cpuc->group_flag & PERF_EVENT_TXN)
>  		goto done_collect;
> @@ -1058,6 +1060,10 @@ static int x86_pmu_add(struct perf_event
>  	memcpy(cpuc->assign, assign, n*sizeof(int));
>  
>  done_collect:
> +	/*
> +	 * Commit the collect_events() state. See x86_pmu_del() and
> +	 * x86_pmu_*_txn().
> +	 */
>  	cpuc->n_events = n;
>  	cpuc->n_added += n - n0;
>  	cpuc->n_txn += n - n0;
> @@ -1183,28 +1189,38 @@ static void x86_pmu_del(struct perf_even
>  	 * If we're called during a txn, we don't need to do anything.
>  	 * The events never got scheduled and ->cancel_txn will truncate
>  	 * the event_list.
> +	 *
> +	 * XXX assumes any ->del() called during a TXN will only be on
> +	 * an event added during that same TXN.
>  	 */
>  	if (cpuc->group_flag & PERF_EVENT_TXN)
>  		return;
>  
> +	/*
> +	 * Not a TXN, therefore cleanup properly.
> +	 */
>  	x86_pmu_stop(event, PERF_EF_UPDATE);
>  
>  	for (i = 0; i < cpuc->n_events; i++) {
> -		if (event == cpuc->event_list[i]) {
> -
> -			if (i >= cpuc->n_events - cpuc->n_added)
> -				--cpuc->n_added;
> +		if (event == cpuc->event_list[i])
> +			break;
> +	}
>  
> -			if (x86_pmu.put_event_constraints)
> -				x86_pmu.put_event_constraints(cpuc, event);
> +	if (WARN_ON_ONCE(i == cpuc->n_events)) /* called ->del() without ->add() ? */
> +		return;
>  
> -			while (++i < cpuc->n_events)
> -				cpuc->event_list[i-1] = cpuc->event_list[i];
> +	/* If we have a newly added event; make sure to decrease n_added. */
> +	if (i >= cpuc->n_events - cpuc->n_added)
> +		--cpuc->n_added;
> +
> +	if (x86_pmu.put_event_constraints)
> +		x86_pmu.put_event_constraints(cpuc, event);
> +
> +	/* Delete the array entry. */
> +	while (++i < cpuc->n_events)
> +		cpuc->event_list[i-1] = cpuc->event_list[i];
> +	--cpuc->n_events;
>  
> -			--cpuc->n_events;
> -			break;
> -		}
> -	}
>  	perf_event_update_userpage(event);
>  }
>  
> @@ -1598,7 +1614,8 @@ static void x86_pmu_cancel_txn(struct pm
>  {
>  	__this_cpu_and(cpu_hw_events.group_flag, ~PERF_EVENT_TXN);
>  	/*
> -	 * Truncate the collected events.
> +	 * Truncate collected array by the number of events added in this
> +	 * transaction. See x86_pmu_add() and x86_pmu_*_txn().
>  	 */
>  	__this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
>  	__this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
> @@ -1609,6 +1626,8 @@ static void x86_pmu_cancel_txn(struct pm
>   * Commit group events scheduling transaction
>   * Perform the group schedulability test as a whole
>   * Return 0 if success
> + *
> + * Does not cancel the transaction on failure; expects the caller to do this.
>   */
>  static int x86_pmu_commit_txn(struct pmu *pmu)
>  {
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -130,9 +130,11 @@ struct cpu_hw_events {
>  	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>  	int			enabled;
>  
> -	int			n_events;
> -	int			n_added;
> -	int			n_txn;
> +	int			n_events; /* the # of events in the below arrays */
> +	int			n_added;  /* the # last events in the below arrays;
> +					     they've never been enabled yet */
> +	int			n_txn;    /* the # last events in the below arrays;
> +					     added in the current transaction */
>  	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
>  	u64			tags[X86_PMC_IDX_MAX];
>  	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
> 

