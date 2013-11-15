Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab3KOLwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:52:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50443 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3KOLvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:51:54 -0500
Date: Fri, 15 Nov 2013 12:51:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf code using smp_processor_id() in preemptible [00000000] code
Message-ID: <20131115115150.GC10456@twins.programming.kicks-ass.net>
References: <20131115032907.GA25243@redhat.com>
 <20131115100254.GC2965@twins.programming.kicks-ass.net>
 <20131115101946.GG1754@moon>
 <20131115113046.GA26143@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115113046.GA26143@moon>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 03:30:46PM +0400, Cyrill Gorcunov wrote:

>  arch/x86/kernel/cpu/perf_event_p4.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -1207,7 +1207,7 @@ static int p4_pmu_schedule_events(struct
>  {
>  	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
>  	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
> -	int cpu = smp_processor_id();
> +	int cpu = get_cpu();
>  	struct hw_perf_event *hwc;
>  	struct p4_event_bind *bind;
>  	unsigned int i, thread, num;
> @@ -1267,6 +1267,7 @@ reserve:
>  	}
>  
>  done:
> +	put_cpu();
>  	return num ? -EINVAL : 0;
>  }


ok, this will make the error go away, but what about the semantics of
the case? Does it really matter for the grouping on which cpu we compute
it? That is can we end up with a different group for one cpu as for
another?

Or do we simply need a coherent single cpu to do the computation with?
In which case raw_smp_processor_id() would also suffice.


If we can indeed get a different result depending on which cpu we do the
computation, then things are broken, because it might be a task group
we're building which has to be able to migrate around with the task.

In that case we must compute the maximal group that can be scheduled on
all cpus.

This wasn't at all clear.
