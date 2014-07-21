Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaGUR1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:27:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaGUR1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:27:41 -0400
Date: Mon, 21 Jul 2014 13:27:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH percpu/for-3.17 2/2] blk-throttle: replace custom async
 percpu alloc mechanism with percpu_pool
Message-ID: <20140721172734.GA13577@redhat.com>
References: <20140718200804.GG13012@htj.dyndns.org>
 <20140718200834.GH13012@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718200834.GH13012@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 04:08:34PM -0400, Tejun Heo wrote:
> >From 0a4bd997ba9725565883c688d7dcee8264abf71c Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 18 Jul 2014 16:07:14 -0400
> 
> throtl_pd_init() is called under the queue lock but needs to allocate
> the percpu stats area.  This is currently handled by queueing it on a
> list and scheduling a work item to allocate and fill the percpu stats
> area.  Now that perpcu_pool is available, this custom mechanism can be
> replaced.
> 
> Add tg_stats_cpu_pool and implement tg_ensure_stats_cpu() which tries
> to make sure that tg->stats_cpu is populated to replace the custom
> async alloc mechanism.  As percpu_pool allocation can fail,
> tg_ensure_stats_cpu() is invoked whenever ->stats_cpu is about to be
> accessed.  This is similar to the way code was structured before as
> the custom async alloc could take arbitrary amount of time and each
> access should verify that ->stats_cpu is populated.
> 
> This simplifies the code.  There shouldn't be noticeable functional
> difference.
Hi Tejun,

This is a very good cleanup.

I have a query inline below.

Otherwise patch looks good to me from blk-throttle perspective.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

[..]
> +static bool tg_ensure_stats_cpu(struct throtl_grp *tg)
> +{
> +	struct tg_stats_cpu __percpu *stats_cpu;
> +	int cpu;
> +
> +	if (likely(tg->stats_cpu))
> +		return true;
> +
> +	stats_cpu = percpu_pool_alloc(&tg_stats_cpu_pool);
> +	if (!stats_cpu)
> +		return false;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct tg_stats_cpu *tg_stats = per_cpu_ptr(stats_cpu, cpu);
> +
> +		blkg_rwstat_init(&tg_stats->service_bytes);
> +		blkg_rwstat_init(&tg_stats->serviced);
> +	}
> +
> +	/*
> +	 * Try to install @stats_cpu.  There may be multiple competing
> +	 * instances of this function.  Use cmpxchg() so that only the
> +	 * first one gets installed.
> +	 */
> +	if (cmpxchg(&tg->stats_cpu, (struct tg_stats_cpu __percpu *)NULL,
> +		    stats_cpu))
> +		free_percpu(stats_cpu);
> +


So we are using atomic cmpxchg() so that we don't ask callers to hold queue
lock during this call? One of the callers is throtl_update_dispatch_stats()
and we don't want to grab queue lock while updating per cpu stat. In fact
stats were made per cpu so that we don't have to grab the lock.

Thanks
Vivek
