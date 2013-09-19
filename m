Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3ISKM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 06:12:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3ISKM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 06:12:56 -0400
Date: Thu, 19 Sep 2013 12:12:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Vince Weaver <vince@deater.net>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        eranian@googlemail.com
Subject: Re: [PATCH] perf: Always set bit 0 in the capabilities field of
 'struct perf_event_mmap_page' to 0, to maintain the ABI
Message-ID: <20130919101240.GN9326@twins.programming.kicks-ass.net>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
 <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
 <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
 <20130918085722.GL12926@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
 <20130918154224.GK9326@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy>
 <20130919081642.GL9326@twins.programming.kicks-ass.net>
 <20130919091452.GB14112@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919091452.GB14112@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 11:14:53AM +0200, Ingo Molnar wrote:
> @@ -442,12 +445,14 @@ struct perf_event_mmap_page {
>  	 *               ((rem * time_mult) >> time_shift);
>  	 */
>  	__u64	time_zero;
> +	__u32	size;			/* Header size up to this point */
> +	__u32	__reserved0;		/* 4 byte hole */
>  
>  		/*
>  		 * Hole for extension of the self monitor capabilities
>  		 */
>  
> -	__u64	__reserved[119];	/* align to 1k */
> +	__u64	__reserved[118];	/* align to 1k */
>  
>  	/*
>  	 * Control data for the mmap() data buffer.
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index dd236b6..27d339f 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3660,6 +3660,26 @@ static void calc_timer_values(struct perf_event *event,
>  	*running = ctx_time - event->tstamp_running;
>  }
>  
> +static void perf_event_init_userpage(struct perf_event *event)
> +{
> +	struct perf_event_mmap_page *userpg;
> +	struct ring_buffer *rb;
> +
> +	rcu_read_lock();
> +	rb = rcu_dereference(event->rb);
> +	if (!rb)
> +		goto unlock;
> +
> +	userpg = rb->user_page;
> +
> +	/* Allow new userspace to detect that bit 0 is deprecated */
> +	userpg->cap_bit0_is_deprecated = 1;
> +	userpg->size = offsetof(struct perf_event_mmap_page, size);

This is fragile and I'm 100% sure we'll forget to update it.

	userpg->size = offsetof(struct perf_event_mmap_page, __reserved);

Will auto update and mostly do the right thing.

Also, how will userspace know there's a valid size field way out there?
Shouldn't we bump the version field to indicate so? :-) After all,
running on old userspace this field will be 0.

> +
> +unlock:
> +	rcu_read_unlock();
> +}
