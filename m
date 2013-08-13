Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3HMK3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:29:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50102 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab3HMK3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:29:53 -0400
Date: Tue, 13 Aug 2013 12:29:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        jolsa@redhat.com, eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] perf, x86: Avoid checkpointed counters causing
 excessive TSX aborts v4
Message-ID: <20130813102932.GU27162@twins.programming.kicks-ass.net>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <1376010946-28666-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376010946-28666-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 06:15:43PM -0700, Andi Kleen wrote:
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c

> @@ -1141,6 +1146,17 @@ static void intel_pmu_enable_event(struct perf_event *event)
>  int intel_pmu_save_and_restart(struct perf_event *event)
>  {
>  	x86_perf_event_update(event);
> +	/*
> +	 * For a checkpointed counter always reset back to 0.  This
> +	 * avoids a situation where the counter overflows, aborts the
> +	 * transaction and is then set back to shortly before the
> +	 * overflow, and overflows and aborts again.
> +	 */
> +	if (unlikely(event_is_checkpointed(event))) {
> +		/* No race with NMIs because the counter should not be armed */
> +		wrmsrl(event->hw.event_base, 0);
> +		local64_set(&event->hw.prev_count, 0);
> +	}

Right, if it wasn't for KVM you could've done a smaller special case
handler for checkpointed events, but as it stands I suppose it makes
sense to use the normal paths.

>  	return x86_perf_event_set_period(event);
>  }
>  
> @@ -1224,6 +1240,15 @@ again:
>  		x86_pmu.drain_pebs(regs);
>  	}
>  
> +	/*
> +	 * To avoid spurious interrupts with perf stat always reset checkpointed
> +	 * counters.
> +	 *
> +	 * XXX move somewhere else.

Like where? Afaict it needs to be here. You could write it prettier I
suppose and I guess we'll eventually need to assume all events can be
checkpointed but I don't see how it could be done elsewhere.

> +	 */
> +	if (cpuc->events[2] && event_is_checkpointed(cpuc->events[2]))
> +		status |= (1ULL << 2);
> +
>  	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
>  		struct perf_event *event = cpuc->events[bit];
>  


