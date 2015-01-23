Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbbAWPCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:02:48 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41898 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbbAWPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:02:45 -0500
Date: Fri, 23 Jan 2015 15:02:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/3] perf: Tighten (and fix) the grouping condition
Message-ID: <20150123150211.GA6091@leverpostej>
References: <20150123125159.696530128@infradead.org>
 <20150123125834.090683288@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123125834.090683288@infradead.org>
Thread-Topic: [RFC][PATCH 1/3] perf: Tighten (and fix) the grouping condition
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 12:52:00PM +0000, Peter Zijlstra wrote:
> The fix from 9fc81d87420d ("perf: Fix events installation during
> moving group") was incomplete in that it failed to recognise that
> creating a group with events for different CPUs is semantically
> broken -- they cannot be co-scheduled.
> 
> Furthermore, it leads to real breakage where, when we create an event
> for CPU Y and then migrate it to form a group on CPU X, the code gets
> confused where the counter is programmed -- triggered by the fuzzer.
> 
> Fix this by tightening the rules for creating groups. Only allow
> grouping of counters that can be co-scheduled in the same context.
> This means for the same task and/or the same cpu.

It seems this would still allow you to group CPU-affine software and
uncore events, which also doesn't make sense: the software events will
count on a single CPU while the uncore events aren't really CPU-affine.

Which isn't anything against this patch, but probably something we
should tighten up too.

> 
> Fixes: 9fc81d87420d ("perf: Fix events installation during moving group")
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  include/linux/perf_event.h |    6 ------
>  kernel/events/core.c       |   15 +++++++++++++--
>  2 files changed, 13 insertions(+), 8 deletions(-)
> 
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -450,11 +450,6 @@ struct perf_event {
>  #endif /* CONFIG_PERF_EVENTS */
>  };
>  
> -enum perf_event_context_type {
> -	task_context,
> -	cpu_context,
> -};
> -
>  /**
>   * struct perf_event_context - event context structure
>   *
> @@ -462,7 +457,6 @@ enum perf_event_context_type {
>   */
>  struct perf_event_context {
>  	struct pmu			*pmu;
> -	enum perf_event_context_type	type;
>  	/*
>  	 * Protect the states of the events in the list,
>  	 * nr_active, and the list:
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6846,7 +6846,6 @@ int perf_pmu_register(struct pmu *pmu, c
>  		__perf_event_init_context(&cpuctx->ctx);
>  		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
>  		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
> -		cpuctx->ctx.type = cpu_context;
>  		cpuctx->ctx.pmu = pmu;
>  
>  		__perf_cpu_hrtimer_init(cpuctx, cpu);
> @@ -7493,7 +7492,19 @@ SYSCALL_DEFINE5(perf_event_open,
>  		 * task or CPU context:
>  		 */
>  		if (move_group) {
> -			if (group_leader->ctx->type != ctx->type)
> +			/*
> +			 * Make sure we're both on the same task, or both
> +			 * per-cpu events.
> +			 */
> +			if (group_leader->ctx->task != ctx->task)
> +				goto err_context;
> +

Up to this point, this looks very similar to what I tried previously
[1], where we eventually figured out [2] that this raced with the
context switch optimisation. I never got around to fixing that race.

I'll try and get my head around that again. I'm not sure if that's still
a problem, and from a quick look at this series it's not clear that it
would be fixed if it is a problem.

Thanks,
Mark.

[1] https://lkml.org/lkml/2014/2/10/937
[2] https://lkml.org/lkml/2014/2/27/834
