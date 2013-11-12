Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3KLL5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:57:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab3KLL5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:57:44 -0500
Date: Tue, 12 Nov 2013 12:57:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/fair: Fix group power_orig computation
Message-ID: <20131112115736.GO5056@laptop.programming.kicks-ass.net>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112105547.GA27310@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 04:25:47PM +0530, Srikar Dronamraju wrote:
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Date: Tue, 12 Nov 2013 03:05:31 -0500
> Subject: [PATCH] sched: Check sched_domain before computing group power.
> 
> After Commit-id 863bffc80898 (sched/fair: Fix group power_orig
> computation), we might end up computing group power before the
> sched_domain for a cpu is updated.
> 
> Check for rq->sd before updating group power.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks! My head hurts a bit from going through the overlap init paths
but this does indeed revert to the previous behaviour.

I'm not entirely sure if either are fully correct, but given we
initialize the sgp->power to some 'reasonable' default we can rely on
runtime updates to correct any funnies.

> ---
>  kernel/sched/fair.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index df77c60..f86f704 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5354,8 +5354,13 @@ void update_group_power(struct sched_domain *sd, int cpu)
>  		 */
>  
>  		for_each_cpu(cpu, sched_group_cpus(sdg)) {
> -			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
> +			struct rq *rq = cpu_rq(cpu);
> +			struct sched_group *sg;
>  
> +			if (!rq->sd)
> +				continue;
> +
> +			sg = rq->sd->groups;
>  			power_orig += sg->sgp->power_orig;
>  			power += sg->sgp->power;
>  		}
> -- 
> 1.7.1
> 
