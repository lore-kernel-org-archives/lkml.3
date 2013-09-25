Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3IYWXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:23:09 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45415 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab3IYWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:22:50 -0400
Message-ID: <52436237.3040500@linaro.org>
Date: Thu, 26 Sep 2013 00:22:47 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/21] cpuidle: don't call poll_idle_init() for every
 cpu
References: <cover.1379779777.git.viresh.kumar@linaro.org> <495ffb1175175b0180ca3da96eb5ed72a8280364.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <495ffb1175175b0180ca3da96eb5ed72a8280364.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

The optimization sounds good but IMHO if we can move this state out of
the cpuidle common framework that would be nicer.

The poll_idle is only applicable for x86 (acpi_driver and intel_idle),
hence I suggest we move this state to these drivers, that will cleanup
the framework code and will remove index shift macro
CPUIDLE_DRIVER_STATE_START which IMHO is weid and prone-to-error.

> ---
>  drivers/cpuidle/cpuidle.c | 41 -----------------------------------------
>  drivers/cpuidle/driver.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 43d5836..bf80236 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -226,45 +226,6 @@ void cpuidle_resume(void)
>  	mutex_unlock(&cpuidle_lock);
>  }
>  
> -#ifdef CONFIG_ARCH_HAS_CPU_RELAX
> -static int poll_idle(struct cpuidle_device *dev,
> -		struct cpuidle_driver *drv, int index)
> -{
> -	ktime_t	t1, t2;
> -	s64 diff;
> -
> -	t1 = ktime_get();
> -	local_irq_enable();
> -	while (!need_resched())
> -		cpu_relax();
> -
> -	t2 = ktime_get();
> -	diff = ktime_to_us(ktime_sub(t2, t1));
> -	if (diff > INT_MAX)
> -		diff = INT_MAX;
> -
> -	dev->last_residency = (int) diff;
> -
> -	return index;
> -}
> -
> -static void poll_idle_init(struct cpuidle_driver *drv)
> -{
> -	struct cpuidle_state *state = &drv->states[0];
> -
> -	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
> -	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
> -	state->exit_latency = 0;
> -	state->target_residency = 0;
> -	state->power_usage = -1;
> -	state->flags = 0;
> -	state->enter = poll_idle;
> -	state->disabled = false;
> -}
> -#else
> -static void poll_idle_init(struct cpuidle_driver *drv) {}
> -#endif /* CONFIG_ARCH_HAS_CPU_RELAX */
> -
>  /**
>   * cpuidle_enable_device - enables idle PM for a CPU
>   * @dev: the CPU
> @@ -294,8 +255,6 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
>  	if (!dev->state_count)
>  		dev->state_count = drv->state_count;
>  
> -	poll_idle_init(drv);
> -
>  	ret = cpuidle_add_device_sysfs(dev);
>  	if (ret)
>  		return ret;
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 7b2510a..a4a93b4 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -10,6 +10,7 @@
>  
>  #include <linux/mutex.h>
>  #include <linux/module.h>
> +#include <linux/sched.h>
>  #include <linux/cpuidle.h>
>  #include <linux/cpumask.h>
>  #include <linux/clockchips.h>
> @@ -179,6 +180,45 @@ static void __cpuidle_driver_init(struct cpuidle_driver *drv)
>  	}
>  }
>  
> +#ifdef CONFIG_ARCH_HAS_CPU_RELAX
> +static int poll_idle(struct cpuidle_device *dev,
> +		struct cpuidle_driver *drv, int index)
> +{
> +	ktime_t	t1, t2;
> +	s64 diff;
> +
> +	t1 = ktime_get();
> +	local_irq_enable();
> +	while (!need_resched())
> +		cpu_relax();
> +
> +	t2 = ktime_get();
> +	diff = ktime_to_us(ktime_sub(t2, t1));
> +	if (diff > INT_MAX)
> +		diff = INT_MAX;
> +
> +	dev->last_residency = (int) diff;
> +
> +	return index;
> +}
> +
> +static void poll_idle_init(struct cpuidle_driver *drv)
> +{
> +	struct cpuidle_state *state = &drv->states[0];
> +
> +	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
> +	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
> +	state->exit_latency = 0;
> +	state->target_residency = 0;
> +	state->power_usage = -1;
> +	state->flags = 0;
> +	state->enter = poll_idle;
> +	state->disabled = false;
> +}
> +#else
> +static void poll_idle_init(struct cpuidle_driver *drv) {}
> +#endif /* !CONFIG_ARCH_HAS_CPU_RELAX */
> +
>  /**
>   * __cpuidle_register_driver: register the driver
>   * @drv: a valid pointer to a struct cpuidle_driver
> @@ -212,6 +252,8 @@ static int __cpuidle_register_driver(struct cpuidle_driver *drv)
>  		on_each_cpu_mask(drv->cpumask, cpuidle_setup_broadcast_timer,
>  				 (void *)CLOCK_EVT_NOTIFY_BROADCAST_ON, 1);
>  
> +	poll_idle_init(drv);
> +
>  	return 0;
>  }
>  
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

