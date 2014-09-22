Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaIVRNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:13:49 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39568 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaIVRNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:13:47 -0400
From: bsegall@google.com
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: peterz@infradead.org, mingo@redhat.com, dietmar.eggemann@arm.com,
        pjt@google.com, vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        mturquette@linaro.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: Make sched entity usage tracking scale-invariant
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
	<1411403047-32010-7-git-send-email-morten.rasmussen@arm.com>
Date: Mon, 22 Sep 2014 10:13:46 -0700
In-Reply-To: <1411403047-32010-7-git-send-email-morten.rasmussen@arm.com>
	(Morten Rasmussen's message of "Mon, 22 Sep 2014 17:24:06 +0100")
Message-ID: <xm2638bjlgs5.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morten Rasmussen <morten.rasmussen@arm.com> writes:

> Apply scale-invariance correction factor to usage tracking as well.

It seems like it would make more sense to order the patches as first the
usage tracking and then all of the scale-invariance together, or perhaps
to just fold this into the usage tracking patch.
>
> cc: Paul Turner <pjt@google.com>
> cc: Ben Segall <bsegall@google.com>
>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  kernel/sched/fair.c |   28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index d8a8c83..c7aa8c1 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2302,9 +2302,9 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
>  							int runnable,
>  							int running)
>  {
> -	u64 delta, periods;
> -	u32 runnable_contrib;
> -	int delta_w, decayed = 0;
> +	u64 delta, scaled_delta, periods;
> +	u32 runnable_contrib, scaled_runnable_contrib;
> +	int delta_w, scaled_delta_w, decayed = 0;
>  	u32 scale_cap = arch_scale_load_capacity(cpu);
>  
>  	delta = now - sa->last_runnable_update;
> @@ -2339,11 +2339,12 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
>  		 */
>  		delta_w = 1024 - delta_w;
>  
> +		scaled_delta_w = (delta_w * scale_cap) >> SCHED_CAPACITY_SHIFT;
> +
>  		if (runnable)
> -			sa->runnable_avg_sum += (delta_w * scale_cap)
> -					>> SCHED_CAPACITY_SHIFT;
> +			sa->runnable_avg_sum += scaled_delta_w;
>  		if (running)
> -			sa->usage_avg_sum += delta_w;
> +			sa->usage_avg_sum += scaled_delta_w;
>  		sa->runnable_avg_period += delta_w;
>  
>  		delta -= delta_w;
> @@ -2361,20 +2362,23 @@ static __always_inline int __update_entity_runnable_avg(u64 now, int cpu,
>  		/* Efficiently calculate \sum (1..n_period) 1024*y^i */
>  		runnable_contrib = __compute_runnable_contrib(periods);
>  
> -		if (runnable)
> -			sa->runnable_avg_sum += (runnable_contrib * scale_cap)
> +		scaled_runnable_contrib = (runnable_contrib * scale_cap)
>  						>> SCHED_CAPACITY_SHIFT;
> +
> +		if (runnable)
> +			sa->runnable_avg_sum +=  scaled_runnable_contrib;
>  		if (running)
> -			sa->usage_avg_sum += runnable_contrib;
> +			sa->usage_avg_sum +=  scaled_runnable_contrib;
>  		sa->runnable_avg_period += runnable_contrib;
>  	}
>  
>  	/* Remainder of delta accrued against u_0` */
> +	scaled_delta = (delta * scale_cap) >> SCHED_CAPACITY_SHIFT;
> +
>  	if (runnable)
> -		sa->runnable_avg_sum += (delta * scale_cap)
> -				>> SCHED_CAPACITY_SHIFT;
> +		sa->runnable_avg_sum += scaled_delta;
>  	if (running)
> -		sa->usage_avg_sum += delta;
> +		sa->usage_avg_sum += scaled_delta;
>  	sa->runnable_avg_period += delta;
>  
>  	return decayed;
