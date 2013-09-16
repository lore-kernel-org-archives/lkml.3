Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3IPFnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 01:43:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3IPFnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 01:43:12 -0400
Date: Mon, 16 Sep 2013 07:43:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/2] sched: load_balance: Reset env when going to redo
 due to all pinned
Message-ID: <20130916054301.GK21832@twins.programming.kicks-ass.net>
References: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
 <c34e2ebbe55403d5db111fa3ecdf6ca52b73a337.1379265590.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c34e2ebbe55403d5db111fa3ecdf6ca52b73a337.1379265590.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 09:30:14PM +0400, Vladimir Davydov wrote:
> Firstly, reset env.dst_cpu/dst_rq to this_cpu/this_rq, because it could
> have changed in 'some pinned' case. Otherwise, should_we_balance() can
> stop balancing beforehand.
> 
> Secondly, reset env.flags, because it can have LBF_SOME_PINNED set.
> 
> Thirdly, reset env.dst_grpmask cpus in env.cpus to allow handling 'some
> pinned' case when pulling tasks from a new busiest cpu.

Did you actually run into any problems because of this?

> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  kernel/sched/fair.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index cd59640..d840e51 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5289,8 +5289,16 @@ more_balance:
>  		if (unlikely(env.flags & LBF_ALL_PINNED)) {
>  			cpumask_clear_cpu(cpu_of(busiest), cpus);
>  			if (!cpumask_empty(cpus)) {
> -				env.loop = 0;
> -				env.loop_break = sched_nr_migrate_break;
> +				env.dst_cpu	= this_cpu;
> +				env.dst_rq	= this_rq;
> +				env.flags	= 0;
> +				env.loop	= 0;
> +				env.loop_break	= sched_nr_migrate_break;
> +
> +				/* Reset cpus cleared in LBF_SOME_PINNED case */
> +				if (env.dst_grpmask)
> +					cpumask_or(cpus, cpus, env.dst_grpmask);
> +
>  				goto redo;
>  			}
>  			goto out_balanced;

So the problem I have with this is that it removes the bound on the
number of iterations we do. Currently we're limited by the bits in cpus,
but by resetting those we can do on and on and on...
