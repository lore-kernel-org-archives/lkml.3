Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750746AbaCREGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 00:06:31 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64211 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaCREGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 00:06:30 -0400
Message-ID: <1395115586.4883.36.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: Initialize rq->age_stamp on processor start
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, Corey Minyard <cminyard@mvista.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 18 Mar 2014 05:06:26 +0100
In-Reply-To: <1395101149-10097-1-git-send-email-minyard@acm.org>
References: <1395101149-10097-1-git-send-email-minyard@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC maintainer improves patch aerodynamics.

On Mon, 2014-03-17 at 19:05 -0500, minyard@acm.org wrote: 
> From: Corey Minyard <cminyard@mvista.com>
> 
> If the sched_clock time starts at a large value, the kernel will spin
> in sched_avg_update for a long time while rq->age_stamp catches up
> with rq->clock.
> 
> The comment in kernel/sched/clock.c says that there is no strict promise
> that it starts at zero.  So initialize rq->age_stamp when a cpu starts up
> to avoid this.
> 
> I was seeing long delays on a simulator that didn't start the clock at
> zero.  This might also be an issue on reboots on processors that don't
> re-initialize the timer to zero on reset, and when using kexec.
> 
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
>  kernel/sched/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b46131e..5be3d4a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5037,11 +5037,20 @@ static struct notifier_block migration_notifier = {
>  	.priority = CPU_PRI_MIGRATION,
>  };
>  
> +static void __cpuinit set_cpu_rq_start_time(void)
> +{
> +	int cpu = smp_processor_id();
> +	struct rq *rq = cpu_rq(cpu);
> +	rq->age_stamp = sched_clock_cpu(cpu);
> +}

rq->age_stamp must lag rq->clock.  See scale_rt_power(), and what
happens when it munches magic timewarp mushrooms.

> +
>  static int sched_cpu_active(struct notifier_block *nfb,
>  				      unsigned long action, void *hcpu)
>  {
>  	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_STARTING:
> +		set_cpu_rq_start_time();
> +		/* fall through */
>  	case CPU_DOWN_FAILED:
>  		set_cpu_active((long)hcpu, true);
>  		return NOTIFY_OK;
> @@ -6922,6 +6931,7 @@ void __init sched_init(void)
>  	init_sched_fair_class();
>  
>  	scheduler_running = 1;
> +	set_cpu_rq_start_time();
>  }
>  
>  #ifdef CONFIG_DEBUG_ATOMIC_SLEEP


