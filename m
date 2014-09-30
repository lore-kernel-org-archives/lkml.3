Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaI3Sld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:41:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:46127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaI3Slc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:41:32 -0400
Date: Tue, 30 Sep 2014 20:41:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, riel@redhat.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH] sched: fix spurious active migration
Message-ID: <20140930184129.GM4241@worktop.programming.kicks-ass.net>
References: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:41:08AM +0200, Vincent Guittot wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2a1e6ac..adad532 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6425,13 +6425,14 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
>  
>  	if (env->idle == CPU_IDLE) {
>  		/*
> -		 * This cpu is idle. If the busiest group load doesn't
> -		 * have more tasks than the number of available cpu's and
> -		 * there is no imbalance between this and busiest group
> -		 * wrt to idle cpu's, it is balanced.
> +		 * This cpu is idle. If the busiest group is not overloaded
> +		 * and there is no imbalance between this and busiest group
> +		 * wrt to idle cpus, it is balanced. The imbalance becomes
> +		 * significant if the diff is greater than 1 otherwise we
> +		 * might end up to just move the imbalance on another group
>  		 */
> -		if ((local->idle_cpus < busiest->idle_cpus) &&
> -		    busiest->sum_nr_running <= busiest->group_weight)
> +		if ((local->idle_cpus <= (busiest->idle_cpus + 1)) &&

So I'm thick and I don't get this one.. In fact I don't seem to
understand the existing code either.

If we're idle, and busiest is overloaded, we want to have tasks. Why
would we care about number of idle cpus etc..

> +		    !(busiest->group_type == group_overloaded))

Would not: busiest->group_type != group_overloaded, read more natural?
Also, would it make sense to make this the first condition?

>  			goto out_balanced;
>  	} else {


