Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049Ab3HTM0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:26:12 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51373 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab3HTM0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:26:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Neil Zhang <zhangwm@marvell.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: coupled: fix dead loop corner case
Date: Tue, 20 Aug 2013 14:36:42 +0200
Message-ID: <26502976.vPDNddhvVv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376975864-31487-1-git-send-email-zhangwm@marvell.com>
References: <1376975864-31487-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 01:17:44 PM Neil Zhang wrote:
> There is a corener case when no peripheral irqs route to secondary
> cores.
> Let's take dual core system for example, the sequence is as following:
> 
> 		Core 0			        Core1
> 1.			           set waiting bit and enter waiting loop
> 2. set waiting bit and poke core1
> 3. 				   clear poke in irq and enter safe state
> 4. set ready bit and enter ready loop
> 
> Since there is no peripheral irq route to core 1, so it will stay in
> safe state forever, and core 0 will dead loop in the following code.
> 	while (!cpuidle_coupled_cpus_ready(coupled)) {
> 		/* Check if any other cpus bailed out of idle. */
> 		if (!cpuidle_coupled_cpus_waiting(coupled))
> 	}
> 
> The solution is don't let secondary core enter safe state when it has
> already handled the poke interrupt.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> Reviewed-by: Fangsuo Wu <fswu@marvell.com>

Daniel, can you please have a look at this?

Rafael


> ---
>  drivers/cpuidle/coupled.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
> index 2a297f8..a37c718 100644
> --- a/drivers/cpuidle/coupled.c
> +++ b/drivers/cpuidle/coupled.c
> @@ -119,6 +119,7 @@ struct cpuidle_coupled {
>  #define CPUIDLE_COUPLED_NOT_IDLE	(-1)
>  
>  static DEFINE_MUTEX(cpuidle_coupled_lock);
> +static DEFINE_PER_CPU(bool, poke_sync);
>  static DEFINE_PER_CPU(struct call_single_data, cpuidle_coupled_poke_cb);
>  
>  /*
> @@ -295,6 +296,7 @@ static void cpuidle_coupled_poked(void *info)
>  {
>  	int cpu = (unsigned long)info;
>  	cpumask_clear_cpu(cpu, &cpuidle_coupled_poked_mask);
> +	__this_cpu_write(poke_sync, true);
>  }
>  
>  /**
> @@ -473,6 +475,7 @@ retry:
>  	 * allowed for a single cpu.
>  	 */
>  	while (!cpuidle_coupled_cpus_waiting(coupled)) {
> +		__this_cpu_write(poke_sync, false);
>  		if (cpuidle_coupled_clear_pokes(dev->cpu)) {
>  			cpuidle_coupled_set_not_waiting(dev->cpu, coupled);
>  			goto out;
> @@ -483,6 +486,10 @@ retry:
>  			goto out;
>  		}
>  
> +		if (cpuidle_coupled_cpus_waiting(coupled)
> +			&& __this_cpu_read(poke_sync))
> +			break;
> +
>  		entered_state = cpuidle_enter_state(dev, drv,
>  			dev->safe_state_index);
>  	}
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
