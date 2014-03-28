Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaC1SRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:17:10 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:64201 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaC1SRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:17:07 -0400
Date: Fri, 28 Mar 2014 14:17:03 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        rjw@rjwysocki.net, linux-pm@vger.kernel.org, alex.shi@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 1/3] cpuidle: encapsulate power info in a separate
 structure
In-Reply-To: <1396009796-31598-2-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1403281356220.1571@knanqh.ubzr>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <1396009796-31598-2-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014, Daniel Lezcano wrote:

> The scheduler needs some information from cpuidle to know the timing for a
> specific idle state a cpu is.
> 
> This patch creates a separate structure to group the cpuidle power info in
> order to share it with the scheduler. It improves the encapsulation of the
> code.

Having cpuidle_power as a structure name, or worse, 'power' as a struct 
member, is a really bad choice.  Amongst the fields this struct 
contains, only 1 out of 3 is about power.  The word "power" is already 
abused quite significantly to mean too many different things already.

I'd suggest something inspired by your own patch log message i.e. 
'struct cpuidle_info' instead, and use 'info' as a field name within 
struct cpuidle_state.  Having 'params" instead of "info" could be a good 
alternative too, although slightly longer.

And with struct rq in patch 2/3 I'd simply use:

	struct cpuidle_info *cpuidle;

This way you'll have rq->cpuidle->exit_latency to refer to from the 
scheduler context which is IMHO much more self explanatory.

> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  arch/arm/include/asm/cpuidle.h       |    6 +-
>  arch/arm/mach-exynos/cpuidle.c       |    4 +-
>  drivers/acpi/processor_idle.c        |    4 +-
>  drivers/base/power/domain.c          |    6 +-
>  drivers/cpuidle/cpuidle-at91.c       |    4 +-
>  drivers/cpuidle/cpuidle-big_little.c |    9 +--
>  drivers/cpuidle/cpuidle-calxeda.c    |    6 +-
>  drivers/cpuidle/cpuidle-kirkwood.c   |    4 +-
>  drivers/cpuidle/cpuidle-powernv.c    |    8 +--
>  drivers/cpuidle/cpuidle-pseries.c    |   12 ++--
>  drivers/cpuidle/cpuidle-ux500.c      |   14 ++---
>  drivers/cpuidle/cpuidle-zynq.c       |    4 +-
>  drivers/cpuidle/driver.c             |    6 +-
>  drivers/cpuidle/governors/ladder.c   |   14 +++--
>  drivers/cpuidle/governors/menu.c     |    8 +--
>  drivers/cpuidle/sysfs.c              |    2 +-
>  drivers/idle/intel_idle.c            |  112 +++++++++++++++++-----------------
>  include/linux/cpuidle.h              |   10 ++-
>  18 files changed, 120 insertions(+), 113 deletions(-)
> 
> diff --git a/arch/arm/include/asm/cpuidle.h b/arch/arm/include/asm/cpuidle.h
> index 2fca60a..987ee53 100644
> --- a/arch/arm/include/asm/cpuidle.h
> +++ b/arch/arm/include/asm/cpuidle.h
> @@ -12,9 +12,9 @@ static inline int arm_cpuidle_simple_enter(struct cpuidle_device *dev,
>  /* Common ARM WFI state */
>  #define ARM_CPUIDLE_WFI_STATE_PWR(p) {\
>  	.enter                  = arm_cpuidle_simple_enter,\
> -	.exit_latency           = 1,\
> -	.target_residency       = 1,\
> -	.power_usage		= p,\
> +	.power.exit_latency     = 1,\
> +	.power.target_residency = 1,\
> +	.power.power_usage	= p,\
>  	.flags                  = CPUIDLE_FLAG_TIME_VALID,\
>  	.name                   = "WFI",\
>  	.desc                   = "ARM WFI",\
> diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
> index f57cb91..f6275cb 100644
> --- a/arch/arm/mach-exynos/cpuidle.c
> +++ b/arch/arm/mach-exynos/cpuidle.c
> @@ -73,8 +73,8 @@ static struct cpuidle_driver exynos4_idle_driver = {
>  		[0] = ARM_CPUIDLE_WFI_STATE,
>  		[1] = {
>  			.enter			= exynos4_enter_lowpower,
> -			.exit_latency		= 300,
> -			.target_residency	= 100000,
> +			.power.exit_latency	= 300,
> +			.power.target_residency = 100000,
>  			.flags			= CPUIDLE_FLAG_TIME_VALID,
>  			.name			= "C1",
>  			.desc			= "ARM power down",
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 3dca36d..05fa991 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -979,8 +979,8 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
>  		state = &drv->states[count];
>  		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", i);
>  		strncpy(state->desc, cx->desc, CPUIDLE_DESC_LEN);
> -		state->exit_latency = cx->latency;
> -		state->target_residency = cx->latency * latency_factor;
> +		state->power.exit_latency = cx->latency;
> +		state->power.target_residency = cx->latency * latency_factor;
>  
>  		state->flags = 0;
>  		switch (cx->type) {
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index bfb8955..6bcb1e8 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -154,7 +154,7 @@ static void genpd_recalc_cpu_exit_latency(struct generic_pm_domain *genpd)
>  	usecs64 = genpd->power_on_latency_ns;
>  	do_div(usecs64, NSEC_PER_USEC);
>  	usecs64 += genpd->cpu_data->saved_exit_latency;
> -	genpd->cpu_data->idle_state->exit_latency = usecs64;
> +	genpd->cpu_data->idle_state->power.exit_latency = usecs64;
>  }
>  
>  /**
> @@ -1882,7 +1882,7 @@ int pm_genpd_attach_cpuidle(struct generic_pm_domain *genpd, int state)
>  		goto err;
>  	}
>  	cpu_data->idle_state = idle_state;
> -	cpu_data->saved_exit_latency = idle_state->exit_latency;
> +	cpu_data->saved_exit_latency = idle_state->power.exit_latency;
>  	genpd->cpu_data = cpu_data;
>  	genpd_recalc_cpu_exit_latency(genpd);
>  
> @@ -1936,7 +1936,7 @@ int pm_genpd_detach_cpuidle(struct generic_pm_domain *genpd)
>  		ret = -EAGAIN;
>  		goto out;
>  	}
> -	idle_state->exit_latency = cpu_data->saved_exit_latency;
> +	idle_state->power.exit_latency = cpu_data->saved_exit_latency;
>  	cpuidle_driver_unref();
>  	genpd->cpu_data = NULL;
>  	kfree(cpu_data);
> diff --git a/drivers/cpuidle/cpuidle-at91.c b/drivers/cpuidle/cpuidle-at91.c
> index a077437..48c7063 100644
> --- a/drivers/cpuidle/cpuidle-at91.c
> +++ b/drivers/cpuidle/cpuidle-at91.c
> @@ -40,9 +40,9 @@ static struct cpuidle_driver at91_idle_driver = {
>  	.owner			= THIS_MODULE,
>  	.states[0]		= ARM_CPUIDLE_WFI_STATE,
>  	.states[1]		= {
> +		.power.exit_latency	= 10,
> +		.power.target_residency = 10000,
>  		.enter			= at91_enter_idle,
> -		.exit_latency		= 10,
> -		.target_residency	= 10000,
>  		.flags			= CPUIDLE_FLAG_TIME_VALID,
>  		.name			= "RAM_SR",
>  		.desc			= "WFI and DDR Self Refresh",
> diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
> index b45fc62..5a0af4b 100644
> --- a/drivers/cpuidle/cpuidle-big_little.c
> +++ b/drivers/cpuidle/cpuidle-big_little.c
> @@ -62,9 +62,9 @@ static struct cpuidle_driver bl_idle_little_driver = {
>  	.owner = THIS_MODULE,
>  	.states[0] = ARM_CPUIDLE_WFI_STATE,
>  	.states[1] = {
> +		.power.exit_latency	= 700,
> +		.power.target_residency = 2500,
>  		.enter			= bl_enter_powerdown,
> -		.exit_latency		= 700,
> -		.target_residency	= 2500,
>  		.flags			= CPUIDLE_FLAG_TIME_VALID |
>  					  CPUIDLE_FLAG_TIMER_STOP,
>  		.name			= "C1",
> @@ -78,9 +78,10 @@ static struct cpuidle_driver bl_idle_big_driver = {
>  	.owner = THIS_MODULE,
>  	.states[0] = ARM_CPUIDLE_WFI_STATE,
>  	.states[1] = {
> +
> +		.power.exit_latency	= 500,
> +		.power.target_residency = 2000,
>  		.enter			= bl_enter_powerdown,
> -		.exit_latency		= 500,
> -		.target_residency	= 2000,
>  		.flags			= CPUIDLE_FLAG_TIME_VALID |
>  					  CPUIDLE_FLAG_TIMER_STOP,
>  		.name			= "C1",
> diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
> index 6e51114..8357a20 100644
> --- a/drivers/cpuidle/cpuidle-calxeda.c
> +++ b/drivers/cpuidle/cpuidle-calxeda.c
> @@ -56,9 +56,9 @@ static struct cpuidle_driver calxeda_idle_driver = {
>  			.name = "PG",
>  			.desc = "Power Gate",
>  			.flags = CPUIDLE_FLAG_TIME_VALID,
> -			.exit_latency = 30,
> -			.power_usage = 50,
> -			.target_residency = 200,
> +			.power.exit_latency = 30,
> +			.power.power_usage = 50,
> +			.power.target_residency = 200,
>  			.enter = calxeda_pwrdown_idle,
>  		},
>  	},
> diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
> index 41ba843..0ae4138 100644
> --- a/drivers/cpuidle/cpuidle-kirkwood.c
> +++ b/drivers/cpuidle/cpuidle-kirkwood.c
> @@ -44,9 +44,9 @@ static struct cpuidle_driver kirkwood_idle_driver = {
>  	.owner			= THIS_MODULE,
>  	.states[0]		= ARM_CPUIDLE_WFI_STATE,
>  	.states[1]		= {
> +		.power.exit_latency	= 10,
> +		.power.target_residency = 100000,
>  		.enter			= kirkwood_enter_idle,
> -		.exit_latency		= 10,
> -		.target_residency	= 100000,
>  		.flags			= CPUIDLE_FLAG_TIME_VALID,
>  		.name			= "DDR SR",
>  		.desc			= "WFI and DDR Self Refresh",
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index f48607c..c47cc02 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -62,15 +62,15 @@ static struct cpuidle_state powernv_states[] = {
>  		.name = "snooze",
>  		.desc = "snooze",
>  		.flags = CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 0,
> -		.target_residency = 0,
> +		.power.exit_latency = 0,
> +		.power.target_residency = 0,
>  		.enter = &snooze_loop },
>  	{ /* NAP */
>  		.name = "NAP",
>  		.desc = "NAP",
>  		.flags = CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 10,
> -		.target_residency = 100,
> +		.power.exit_latency = 10,
> +		.power.target_residency = 100,
>  		.enter = &nap_loop },
>  };
>  
> diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
> index 6f7b019..483d7e7 100644
> --- a/drivers/cpuidle/cpuidle-pseries.c
> +++ b/drivers/cpuidle/cpuidle-pseries.c
> @@ -143,15 +143,15 @@ static struct cpuidle_state dedicated_states[] = {
>  		.name = "snooze",
>  		.desc = "snooze",
>  		.flags = CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 0,
> -		.target_residency = 0,
> +		.power.exit_latency = 0,
> +		.power.target_residency = 0,
>  		.enter = &snooze_loop },
>  	{ /* CEDE */
>  		.name = "CEDE",
>  		.desc = "CEDE",
>  		.flags = CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 10,
> -		.target_residency = 100,
> +		.power.exit_latency = 10,
> +		.power.target_residency = 100,
>  		.enter = &dedicated_cede_loop },
>  };
>  
> @@ -163,8 +163,8 @@ static struct cpuidle_state shared_states[] = {
>  		.name = "Shared Cede",
>  		.desc = "Shared Cede",
>  		.flags = CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 0,
> -		.target_residency = 0,
> +		.power.exit_latency = 0,
> +		.power.target_residency = 0,
>  		.enter = &shared_cede_loop },
>  };
>  
> diff --git a/drivers/cpuidle/cpuidle-ux500.c b/drivers/cpuidle/cpuidle-ux500.c
> index 5e35804..3261eb2 100644
> --- a/drivers/cpuidle/cpuidle-ux500.c
> +++ b/drivers/cpuidle/cpuidle-ux500.c
> @@ -98,13 +98,13 @@ static struct cpuidle_driver ux500_idle_driver = {
>  	.states = {
>  		ARM_CPUIDLE_WFI_STATE,
>  		{
> -			.enter		  = ux500_enter_idle,
> -			.exit_latency	  = 70,
> -			.target_residency = 260,
> -			.flags		  = CPUIDLE_FLAG_TIME_VALID |
> -			                    CPUIDLE_FLAG_TIMER_STOP,
> -			.name		  = "ApIdle",
> -			.desc		  = "ARM Retention",
> +			.power.exit_latency	= 70,
> +			.power.target_residency = 260,
> +			.enter			= ux500_enter_idle,
> +			.flags			= CPUIDLE_FLAG_TIME_VALID |
> +						CPUIDLE_FLAG_TIMER_STOP,
> +			.name			= "ApIdle",
> +			.desc			= "ARM Retention",
>  		},
>  	},
>  	.safe_state_index = 0,
> diff --git a/drivers/cpuidle/cpuidle-zynq.c b/drivers/cpuidle/cpuidle-zynq.c
> index aded759..dddefb8 100644
> --- a/drivers/cpuidle/cpuidle-zynq.c
> +++ b/drivers/cpuidle/cpuidle-zynq.c
> @@ -56,9 +56,9 @@ static struct cpuidle_driver zynq_idle_driver = {
>  	.states = {
>  		ARM_CPUIDLE_WFI_STATE,
>  		{
> +			.power.exit_latency	= 10,
> +			.power.target_residency = 10000,
>  			.enter			= zynq_enter_idle,
> -			.exit_latency		= 10,
> -			.target_residency	= 10000,
>  			.flags			= CPUIDLE_FLAG_TIME_VALID |
>  						  CPUIDLE_FLAG_TIMER_STOP,
>  			.name			= "RAM_SR",
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 06dbe7c..40ddd3c 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -206,9 +206,9 @@ static void poll_idle_init(struct cpuidle_driver *drv)
>  
>  	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
>  	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
> -	state->exit_latency = 0;
> -	state->target_residency = 0;
> -	state->power_usage = -1;
> +	state->power.exit_latency = 0;
> +	state->power.target_residency = 0;
> +	state->power.power_usage = -1;
>  	state->flags = 0;
>  	state->enter = poll_idle;
>  	state->disabled = false;
> diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
> index 9f08e8c..4837880 100644
> --- a/drivers/cpuidle/governors/ladder.c
> +++ b/drivers/cpuidle/governors/ladder.c
> @@ -81,7 +81,7 @@ static int ladder_select_state(struct cpuidle_driver *drv,
>  
>  	if (drv->states[last_idx].flags & CPUIDLE_FLAG_TIME_VALID) {
>  		last_residency = cpuidle_get_last_residency(dev) - \
> -					 drv->states[last_idx].exit_latency;
> +			drv->states[last_idx].power.exit_latency;
>  	}
>  	else
>  		last_residency = last_state->threshold.promotion_time + 1;
> @@ -91,7 +91,7 @@ static int ladder_select_state(struct cpuidle_driver *drv,
>  	    !drv->states[last_idx + 1].disabled &&
>  	    !dev->states_usage[last_idx + 1].disable &&
>  	    last_residency > last_state->threshold.promotion_time &&
> -	    drv->states[last_idx + 1].exit_latency <= latency_req) {
> +	    drv->states[last_idx + 1].power.exit_latency <= latency_req) {
>  		last_state->stats.promotion_count++;
>  		last_state->stats.demotion_count = 0;
>  		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
> @@ -104,11 +104,11 @@ static int ladder_select_state(struct cpuidle_driver *drv,
>  	if (last_idx > CPUIDLE_DRIVER_STATE_START &&
>  	    (drv->states[last_idx].disabled ||
>  	    dev->states_usage[last_idx].disable ||
> -	    drv->states[last_idx].exit_latency > latency_req)) {
> +	    drv->states[last_idx].power.exit_latency > latency_req)) {
>  		int i;
>  
>  		for (i = last_idx - 1; i > CPUIDLE_DRIVER_STATE_START; i--) {
> -			if (drv->states[i].exit_latency <= latency_req)
> +			if (drv->states[i].power.exit_latency <= latency_req)
>  				break;
>  		}
>  		ladder_do_selection(ldev, last_idx, i);
> @@ -155,9 +155,11 @@ static int ladder_enable_device(struct cpuidle_driver *drv,
>  		lstate->threshold.demotion_count = DEMOTION_COUNT;
>  
>  		if (i < drv->state_count - 1)
> -			lstate->threshold.promotion_time = state->exit_latency;
> +			lstate->threshold.promotion_time =
> +				state->power.exit_latency;
>  		if (i > 0)
> -			lstate->threshold.demotion_time = state->exit_latency;
> +			lstate->threshold.demotion_time =
> +				state->power.exit_latency;
>  	}
>  
>  	return 0;
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index cf7f2f0..34bd463 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -351,15 +351,15 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>  
>  		if (s->disabled || su->disable)
>  			continue;
> -		if (s->target_residency > data->predicted_us)
> +		if (s->power.target_residency > data->predicted_us)
>  			continue;
> -		if (s->exit_latency > latency_req)
> +		if (s->power.exit_latency > latency_req)
>  			continue;
> -		if (s->exit_latency * multiplier > data->predicted_us)
> +		if (s->power.exit_latency * multiplier > data->predicted_us)
>  			continue;
>  
>  		data->last_state_idx = i;
> -		data->exit_us = s->exit_latency;
> +		data->exit_us = s->power.exit_latency;
>  	}
>  
>  	return data->last_state_idx;
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index e918b6d..1a45541 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -252,7 +252,7 @@ static struct cpuidle_state_attr attr_##_name = __ATTR(_name, 0644, show, store)
>  static ssize_t show_state_##_name(struct cpuidle_state *state, \
>  			 struct cpuidle_state_usage *state_usage, char *buf) \
>  { \
> -	return sprintf(buf, "%u\n", state->_name);\
> +	return sprintf(buf, "%u\n", state->power._name);\
>  }
>  
>  #define define_store_state_ull_function(_name) \
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 8e1939f..4f0533e 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -128,29 +128,29 @@ static struct cpuidle_state nehalem_cstates[] = {
>  		.name = "C1-NHM",
>  		.desc = "MWAIT 0x00",
>  		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 3,
> -		.target_residency = 6,
> +		.power.exit_latency = 3,
> +		.power.target_residency = 6,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C1E-NHM",
>  		.desc = "MWAIT 0x01",
>  		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 10,
> -		.target_residency = 20,
> +		.power.exit_latency = 10,
> +		.power.target_residency = 20,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C3-NHM",
>  		.desc = "MWAIT 0x10",
>  		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 20,
> -		.target_residency = 80,
> +		.power.exit_latency = 20,
> +		.power.target_residency = 80,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C6-NHM",
>  		.desc = "MWAIT 0x20",
>  		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 200,
> -		.target_residency = 800,
> +		.power.exit_latency = 200,
> +		.power.target_residency = 800,
>  		.enter = &intel_idle },
>  	{
>  		.enter = NULL }
> @@ -161,36 +161,36 @@ static struct cpuidle_state snb_cstates[] = {
>  		.name = "C1-SNB",
>  		.desc = "MWAIT 0x00",
>  		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 2,
> -		.target_residency = 2,
> +		.power.exit_latency = 2,
> +		.power.target_residency = 2,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C1E-SNB",
>  		.desc = "MWAIT 0x01",
>  		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 10,
> -		.target_residency = 20,
> +		.power.exit_latency = 10,
> +		.power.target_residency = 20,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C3-SNB",
>  		.desc = "MWAIT 0x10",
>  		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 80,
> -		.target_residency = 211,
> +		.power.exit_latency = 80,
> +		.power.target_residency = 211,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C6-SNB",
>  		.desc = "MWAIT 0x20",
>  		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 104,
> -		.target_residency = 345,
> +		.power.exit_latency = 104,
> +		.power.target_residency = 345,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C7-SNB",
>  		.desc = "MWAIT 0x30",
>  		.flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 109,
> -		.target_residency = 345,
> +		.power.exit_latency = 109,
> +		.power.target_residency = 345,
>  		.enter = &intel_idle },
>  	{
>  		.enter = NULL }
> @@ -201,36 +201,36 @@ static struct cpuidle_state ivb_cstates[] = {
>  		.name = "C1-IVB",
>  		.desc = "MWAIT 0x00",
>  		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 1,
> -		.target_residency = 1,
> +		.power.exit_latency = 1,
> +		.power.target_residency = 1,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C1E-IVB",
>  		.desc = "MWAIT 0x01",
>  		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 10,
> -		.target_residency = 20,
> +		.power.exit_latency = 10,
> +		.power.target_residency = 20,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C3-IVB",
>  		.desc = "MWAIT 0x10",
>  		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 59,
> -		.target_residency = 156,
> +		.power.exit_latency = 59,
> +		.power.target_residency = 156,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C6-IVB",
>  		.desc = "MWAIT 0x20",
>  		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 80,
> -		.target_residency = 300,
> +		.power.exit_latency = 80,
> +		.power.target_residency = 300,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C7-IVB",
>  	A	.desc = "MWAIT 0x30",
>  		.flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 87,
> -		.target_residency = 300,
> +		.power.exit_latency = 87,
> +		.power.target_residency = 300,
>  		.enter = &intel_idle },
>  	{
>  		.enter = NULL }
> @@ -241,57 +241,57 @@ static struct cpuidle_state hsw_cstates[] = {
>  		.name = "C1-HSW",
>  		.desc = "MWAIT 0x00",
>  		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 2,
> -		.target_residency = 2,
> +		.power.exit_latency = 2,
> +		.power.target_residency = 2,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C1E-HSW",
>  		.desc = "MWAIT 0x01",
>  		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 10,
> -		.target_residency = 20,
> +		.power.exit_latency = 10,
> +		.power.target_residency = 20,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C3-HSW",
>  		.desc = "MWAIT 0x10",
>  		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 33,
> -		.target_residency = 100,
> +		.power.exit_latency = 33,
> +		.power.target_residency = 100,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C6-HSW",
>  		.desc = "MWAIT 0x20",
>  		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 133,
> -		.target_residency = 400,
> +		.power.exit_latency = 133,
> +		.power.target_residency = 400,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C7s-HSW",
>  		.desc = "MWAIT 0x32",
>  		.flags = MWAIT2flg(0x32) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 166,
> -		.target_residency = 500,
> +		.power.exit_latency = 166,
> +		.power.target_residency = 500,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C8-HSW",
>  		.desc = "MWAIT 0x40",
>  		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 300,
> -		.target_residency = 900,
> +		.power.exit_latency = 300,
> +		.power.target_residency = 900,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C9-HSW",
>  		.desc = "MWAIT 0x50",
>  		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 600,
> -		.target_residency = 1800,
> +		.power.exit_latency = 600,
> +		.power.target_residency = 1800,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C10-HSW",
>  		.desc = "MWAIT 0x60",
>  		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 2600,
> -		.target_residency = 7700,
> +		.power.exit_latency = 2600,
> +		.power.target_residency = 7700,
>  		.enter = &intel_idle },
>  	{
>  		.enter = NULL }
> @@ -302,29 +302,29 @@ static struct cpuidle_state atom_cstates[] = {
>  		.name = "C1E-ATM",
>  		.desc = "MWAIT 0x00",
>  		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 10,
> -		.target_residency = 20,
> +		.power.exit_latency = 10,
> +		.power.target_residency = 20,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C2-ATM",
>  		.desc = "MWAIT 0x10",
>  		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 20,
> -		.target_residency = 80,
> +		.power.exit_latency = 20,
> +		.power.target_residency = 80,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C4-ATM",
>  		.desc = "MWAIT 0x30",
>  		.flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 100,
> -		.target_residency = 400,
> +		.power.exit_latency = 100,
> +		.power.target_residency = 400,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C6-ATM",
>  		.desc = "MWAIT 0x52",
>  		.flags = MWAIT2flg(0x52) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 140,
> -		.target_residency = 560,
> +		.power.exit_latency = 140,
> +		.power.target_residency = 560,
>  		.enter = &intel_idle },
>  	{
>  		.enter = NULL }
> @@ -334,15 +334,15 @@ static struct cpuidle_state avn_cstates[] = {
>  		.name = "C1-AVN",
>  		.desc = "MWAIT 0x00",
>  		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
> -		.exit_latency = 2,
> -		.target_residency = 2,
> +		.power.exit_latency = 2,
> +		.power.target_residency = 2,
>  		.enter = &intel_idle },
>  	{
>  		.name = "C6-AVN",
>  		.desc = "MWAIT 0x51",
>  		.flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
> -		.exit_latency = 15,
> -		.target_residency = 45,
> +		.power.exit_latency = 15,
> +		.power.target_residency = 45,
>  		.enter = &intel_idle },
>  	{
>  		.enter = NULL }
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index b0238cb..eb58ab3 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -35,14 +35,18 @@ struct cpuidle_state_usage {
>  	unsigned long long	time; /* in US */
>  };
>  
> +struct cpuidle_power {
> +	unsigned int	exit_latency; /* in US */
> +	unsigned int	target_residency; /* in US */
> +	int		power_usage; /* in mW */
> +};
> +
>  struct cpuidle_state {
>  	char		name[CPUIDLE_NAME_LEN];
>  	char		desc[CPUIDLE_DESC_LEN];
>  
>  	unsigned int	flags;
> -	unsigned int	exit_latency; /* in US */
> -	int		power_usage; /* in mW */
> -	unsigned int	target_residency; /* in US */
> +	struct cpuidle_power power;
>  	bool		disabled; /* disabled on all CPUs */
>  
>  	int (*enter)	(struct cpuidle_device *dev,
> -- 
> 1.7.9.5
> 
