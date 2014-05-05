Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaEEMqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:46:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:43535 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbaEEMqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:46:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,988,1389772800"; 
   d="scan'208";a="506065255"
Message-ID: <5367881C.6000104@linux.intel.com>
Date: Mon, 05 May 2014 20:46:20 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH] PM / suspend: Always use deepest C-state in the "freeze"
 sleep state
References: <2548502.zJ1no3NhRc@vostro.rjw.lan>
In-Reply-To: <2548502.zJ1no3NhRc@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/5 6:51, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> If freeze_enter() is called, we want to bypass the current cpuidle
> governor and always use the deepest available (that is, not disabled)
> C-state, because we want to save as much energy as reasonably possible
> then and runtime latency constraints don't matter at that point, since
> the system is in a sleep state anyway.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> This is on top of https://patchwork.kernel.org/patch/4071541/ .
> 
> ---
>  drivers/cpuidle/cpuidle.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/cpuidle.h   |    2 ++
>  kernel/power/suspend.c    |    2 ++
>  3 files changed, 48 insertions(+), 1 deletion(-)
> 
> Index: linux-pm/drivers/cpuidle/cpuidle.c
> ===================================================================
> --- linux-pm.orig/drivers/cpuidle/cpuidle.c
> +++ linux-pm/drivers/cpuidle/cpuidle.c
> @@ -32,6 +32,7 @@ LIST_HEAD(cpuidle_detected_devices);
>  static int enabled_devices;
>  static int off __read_mostly;
>  static int initialized __read_mostly;
> +static bool use_deepest_state __read_mostly;
>  
>  int cpuidle_disabled(void)
>  {
> @@ -65,6 +66,45 @@ int cpuidle_play_dead(void)
>  }
>  
>  /**
> + * cpuidle_use_deepest_state - Enable/disable the "deepest idle" mode.
> + * @enable: Whether enable or disable the feature.
> + *
> + * If the "deepest idle" mode is enabled, cpuidle will ignore the governor and
> + * always use the state with the greatest exit latency (out of the states that
> + * are not disabled).
> + *
> + * This function can only be called after cpuidle_pause() to avoid races.
> + */
> +void cpuidle_use_deepest_state(bool enable)
> +{
> +	use_deepest_state = enable;
> +}
> +
> +/**
> + * cpuidle_find_deepest_state - Find the state of the greatest exit latency.
> + * @drv: cpuidle driver for a given CPU.
> + * @dev: cpuidle device for a given CPU.
> + */
> +static int cpuidle_find_deepest_state(struct cpuidle_driver *drv,
> +				      struct cpuidle_device *dev)
> +{
> +	unsigned int latency_req = 0;
> +	int i, ret = CPUIDLE_DRIVER_STATE_START - 1;
> +
> +	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
> +		struct cpuidle_state *s = &drv->states[i];
> +		struct cpuidle_state_usage *su = &dev->states_usage[i];
> +
> +		if (s->disabled || su->disable || s->exit_latency <= latency_req)
> +			continue;
> +
> +		latency_req = s->exit_latency;
> +		ret = i;
> +	}
> +	return ret;
> +}
> +
> +/**
>   * cpuidle_enter_state - enter the state and update stats
>   * @dev: cpuidle device for this cpu
>   * @drv: cpuidle driver for this cpu
> @@ -124,6 +164,9 @@ int cpuidle_select(struct cpuidle_driver
>  	if (!drv || !dev || !dev->enabled)
>  		return -EBUSY;
>  
> +	if (unlikely(use_deepest_state))
> +		return cpuidle_find_deepest_state(drv, dev);
> +
>  	return cpuidle_curr_governor->select(drv, dev);
>  }
>  
> @@ -155,7 +198,7 @@ int cpuidle_enter(struct cpuidle_driver
>   */
>  void cpuidle_reflect(struct cpuidle_device *dev, int index)
>  {
> -	if (cpuidle_curr_governor->reflect)
> +	if (cpuidle_curr_governor->reflect && !unlikely(use_deepest_state))
>  		cpuidle_curr_governor->reflect(dev, index);
>  }
>  
> Index: linux-pm/include/linux/cpuidle.h
> ===================================================================
> --- linux-pm.orig/include/linux/cpuidle.h
> +++ linux-pm/include/linux/cpuidle.h
> @@ -143,6 +143,7 @@ extern void cpuidle_resume(void);
>  extern int cpuidle_enable_device(struct cpuidle_device *dev);
>  extern void cpuidle_disable_device(struct cpuidle_device *dev);
>  extern int cpuidle_play_dead(void);
> +extern void cpuidle_use_deepest_state(bool enable);
>  
>  extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
>  #else
> @@ -175,6 +176,7 @@ static inline int cpuidle_enable_device(
>  {return -ENODEV; }
>  static inline void cpuidle_disable_device(struct cpuidle_device *dev) { }
>  static inline int cpuidle_play_dead(void) {return -ENODEV; }
> +static inline void cpuidle_use_deepest_state(bool enable) {}
>  static inline struct cpuidle_driver *cpuidle_get_cpu_driver(
>  	struct cpuidle_device *dev) {return NULL; }
>  #endif
> Index: linux-pm/kernel/power/suspend.c
> ===================================================================
> --- linux-pm.orig/kernel/power/suspend.c
> +++ linux-pm/kernel/power/suspend.c
> @@ -54,9 +54,11 @@ static void freeze_begin(void)
>  
>  static void freeze_enter(void)
>  {
> +	cpuidle_use_deepest_state(true);
>  	cpuidle_resume();
>  	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
>  	cpuidle_pause();
> +	cpuidle_use_deepest_state(false);
>  }
>  
>  void freeze_wake(void)
> 

Tested-by: Aubrey Li <aubrey.li@linux.intel.com>

I tested freeze mode on ASUS-T100, it works as expected. Thanks Rafael!

-Aubrey
