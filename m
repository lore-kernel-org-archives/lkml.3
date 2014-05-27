Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaE0Npz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:45:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53470 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaE0Npy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:45:54 -0400
Date: Tue, 27 May 2014 15:45:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 02/11] sched: remove a wake_affine condition
Message-ID: <20140527134542.GB11074@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-3-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400860385-14555-3-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 05:52:56PM +0200, Vincent Guittot wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9587ed1..30240ab 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4238,7 +4238,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  {
>  	s64 this_load, load;
>  	int idx, this_cpu, prev_cpu;
> -	unsigned long tl_per_task;
>  	struct task_group *tg;
>  	unsigned long weight;
>  	int balanced;
> @@ -4296,32 +4295,22 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  		balanced = this_eff_load <= prev_eff_load;
>  	} else
>  		balanced = true;
> +	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
>  
> +	if (!balanced)
> +		return 0;
>  	/*
>  	 * If the currently running task will sleep within
>  	 * a reasonable amount of time then attract this newly
>  	 * woken task:
>  	 */
> +	if (sync)
>  		return 1;
>  
> +	schedstat_inc(sd, ttwu_move_affine);
> +	schedstat_inc(p, se.statistics.nr_wakeups_affine);
>  
> +	return 1;
>  }

So I'm not usually one for schedstat nitpicking, but should we fix it in
the sync case? That is, for sync we return 1 but do no inc
nr_wakeups_affine, even though its going to be an affine wakeup.


