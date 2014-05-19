Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaESQCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:02:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40256 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbaESQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:02:34 -0400
Date: Mon, 19 May 2014 17:01:43 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/3] perf: disable sampled events if no PMU interrupt
Message-ID: <20140519160143.GL15130@arm.com>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:12:12PM +0100, Vince Weaver wrote:
> 
> Add common code to generate ENOTSUPP at event creation time if an 
> architecture attempts to create a sampled event and PERF_PMU_NO_INTERRUPT
> is set.
> 
> This adds a new pmu->capabilities flag.  
> Initially we only support PERF_PMU_NO_INTERRUPT (to indicate a PMU
> has no support for generating hardware interrupts) but there are 
> other capabilities that can be added later.
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 3356abc..2164763 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -251,9 +251,20 @@ struct pmu {
>  	 * flush branch stack on context-switches (needed in cpu-wide mode)
>  	 */
>  	void (*flush_branch_stack)	(void);
> +
> +	/*
> +	 * various common per-pmu feature flags
> +	 */
> +	int capabilities;

Move this to the top of the struct, along with the other data fields?

Anyway, this looks really useful to me and I'd really like to use it for
ARM!

 Acked-by: Will Deacon <will.deacon@arm.com>

Will


> +
>  };
>  
>  /**
> + * struct pmu->capabilites flags
> + */
> +#define PERF_PMU_NO_INTERRUPT		1
> +
> +/**
>   * enum perf_event_active_state - the states of a event
>   */
>  enum perf_event_active_state {
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index f83a71a..f5d8554 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7072,6 +7072,13 @@ SYSCALL_DEFINE5(perf_event_open,
>  		}
>  	}
>  
> +	if (is_sampling_event(event)) {
> +		if (event->pmu->capabilities & PERF_PMU_NO_INTERRUPT) {
> +			err = -ENOTSUPP;
> +			goto err_alloc;
> +		}
> +	}
> +
>  	account_event(event);
>  
>  	/*
> 
