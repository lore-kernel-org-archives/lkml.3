Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3LTVme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:42:34 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:44660 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3LTVmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:42:32 -0500
Message-ID: <52B4B9C9.3030603@linaro.org>
Date: Fri, 20 Dec 2013 22:42:33 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, rjw@rjwysocki.net
CC: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH v2 8/9] intel_idle: use the common cpuidle_[un]register()
 routines
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com> <1387565251-7051-9-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1387565251-7051-9-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 07:47 PM, Bartlomiej Zolnierkiewicz wrote:
> It is now possible to use the common cpuidle_[un]register() routines
> (instead of open-coding them) so do it.

Just an addition:

The cpuidle_register common routine calls cpuidle_register_driver which 
initialize the driver's cpumask to cpu_possible_mask if not set (which 
is the default on most platform) and right after it uses this mask to 
register the cpuidle devices. That's why the cpu hotplug does not need 
to register the device unlike before this patch where the cpumask was 
cpu_online_mask. So we can't fall in the "Some systems can hotplug a cpu 
at runtime after the kernel has booted" case.

Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Len Brown <lenb@kernel.org>
> ---
>   drivers/idle/intel_idle.c | 114 ++++++++++++----------------------------------
>   1 file changed, 29 insertions(+), 85 deletions(-)
>
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 524d07b..a1a4dbd 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -93,10 +93,8 @@ struct idle_cpu {
>   };
>
>   static const struct idle_cpu *icpu;
> -static struct cpuidle_device __percpu *intel_idle_cpuidle_devices;
>   static int intel_idle(struct cpuidle_device *dev,
>   			struct cpuidle_driver *drv, int index);
> -static int intel_idle_cpu_init(int cpu);
>
>   static struct cpuidle_state *cpuidle_state_table;
>
> @@ -400,11 +398,27 @@ static void __setup_broadcast_timer(void *arg)
>   	clockevents_notify(reason, &cpu);
>   }
>
> +static void auto_demotion_disable(void *dummy)
> +{
> +	unsigned long long msr_bits;
> +
> +	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
> +	msr_bits &= ~(icpu->auto_demotion_disable_flags);
> +	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
> +}
> +static void c1e_promotion_disable(void *dummy)
> +{
> +	unsigned long long msr_bits;
> +
> +	rdmsrl(MSR_IA32_POWER_CTL, msr_bits);
> +	msr_bits &= ~0x2;
> +	wrmsrl(MSR_IA32_POWER_CTL, msr_bits);
> +}
> +
>   static int cpu_hotplug_notify(struct notifier_block *n,
>   			      unsigned long action, void *hcpu)
>   {
>   	int hotcpu = (unsigned long)hcpu;
> -	struct cpuidle_device *dev;
>
>   	switch (action & ~CPU_TASKS_FROZEN) {
>   	case CPU_ONLINE:
> @@ -416,11 +430,15 @@ static int cpu_hotplug_notify(struct notifier_block *n,
>   		/*
>   		 * Some systems can hotplug a cpu at runtime after
>   		 * the kernel has booted, we have to initialize the
> -		 * driver in this case
> +		 * hardware in this case.
>   		 */
> -		dev = per_cpu_ptr(intel_idle_cpuidle_devices, hotcpu);
> -		if (!dev->registered)
> -			intel_idle_cpu_init(hotcpu);
> +		if (icpu->auto_demotion_disable_flags)
> +			smp_call_function_single(hotcpu, auto_demotion_disable,
> +						NULL, 1);
> +
> +		if (icpu->disable_promotion_to_c1e)
> +			smp_call_function_single(hotcpu, c1e_promotion_disable,
> +						NULL, 1);
>
>   		break;
>   	}
> @@ -431,23 +449,6 @@ static struct notifier_block cpu_hotplug_notifier = {
>   	.notifier_call = cpu_hotplug_notify,
>   };
>
> -static void auto_demotion_disable(void *dummy)
> -{
> -	unsigned long long msr_bits;
> -
> -	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
> -	msr_bits &= ~(icpu->auto_demotion_disable_flags);
> -	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
> -}
> -static void c1e_promotion_disable(void *dummy)
> -{
> -	unsigned long long msr_bits;
> -
> -	rdmsrl(MSR_IA32_POWER_CTL, msr_bits);
> -	msr_bits &= ~0x2;
> -	wrmsrl(MSR_IA32_POWER_CTL, msr_bits);
> -}
> -
>   static const struct idle_cpu idle_cpu_nehalem = {
>   	.state_table = nehalem_cstates,
>   	.auto_demotion_disable_flags = NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE,
> @@ -560,23 +561,6 @@ static int __init intel_idle_probe(void)
>   }
>
>   /*
> - * intel_idle_cpuidle_devices_uninit()
> - * unregister, free cpuidle_devices
> - */
> -static void intel_idle_cpuidle_devices_uninit(void)
> -{
> -	int i;
> -	struct cpuidle_device *dev;
> -
> -	for_each_online_cpu(i) {
> -		dev = per_cpu_ptr(intel_idle_cpuidle_devices, i);
> -		cpuidle_unregister_device(dev);
> -	}
> -
> -	free_percpu(intel_idle_cpuidle_devices);
> -	return;
> -}
> -/*
>    * intel_idle_cpuidle_driver_init()
>    * allocate, initialize cpuidle_states
>    */
> @@ -632,37 +616,9 @@ static int __init intel_idle_cpuidle_driver_init(void)
>   }
>
>
> -/*
> - * intel_idle_cpu_init()
> - * allocate, initialize, register cpuidle_devices
> - * @cpu: cpu/core to initialize
> - */
> -static int intel_idle_cpu_init(int cpu)
> -{
> -	struct cpuidle_device *dev;
> -
> -	dev = per_cpu_ptr(intel_idle_cpuidle_devices, cpu);
> -
> -	dev->cpu = cpu;
> -
> -	if (cpuidle_register_device(dev)) {
> -		pr_debug(PREFIX "cpuidle_register_device %d failed!\n", cpu);
> -		intel_idle_cpuidle_devices_uninit();
> -		return -EIO;
> -	}
> -
> -	if (icpu->auto_demotion_disable_flags)
> -		smp_call_function_single(cpu, auto_demotion_disable, NULL, 1);
> -
> -	if (icpu->disable_promotion_to_c1e)
> -		smp_call_function_single(cpu, c1e_promotion_disable, NULL, 1);
> -
> -	return 0;
> -}
> -
>   static int __init intel_idle_init(void)
>   {
> -	int retval, i;
> +	int retval;
>
>   	/* Do not load intel_idle at all for now if idle= is passed */
>   	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
> @@ -673,7 +629,8 @@ static int __init intel_idle_init(void)
>   		return retval;
>
>   	intel_idle_cpuidle_driver_init();
> -	retval = cpuidle_register_driver(&intel_idle_driver);
> +
> +	retval = cpuidle_register(&intel_idle_driver, NULL);
>   	if (retval) {
>   		struct cpuidle_driver *drv = cpuidle_get_driver();
>   		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
> @@ -681,17 +638,6 @@ static int __init intel_idle_init(void)
>   		return retval;
>   	}
>
> -	intel_idle_cpuidle_devices = alloc_percpu(struct cpuidle_device);
> -	if (intel_idle_cpuidle_devices == NULL)
> -		return -ENOMEM;
> -
> -	for_each_online_cpu(i) {
> -		retval = intel_idle_cpu_init(i);
> -		if (retval) {
> -			cpuidle_unregister_driver(&intel_idle_driver);
> -			return retval;
> -		}
> -	}
>   	register_cpu_notifier(&cpu_hotplug_notifier);
>
>   	return 0;
> @@ -699,9 +645,7 @@ static int __init intel_idle_init(void)
>
>   static void __exit intel_idle_exit(void)
>   {
> -	intel_idle_cpuidle_devices_uninit();
> -	cpuidle_unregister_driver(&intel_idle_driver);
> -
> +	cpuidle_unregister(&intel_idle_driver);
>
>   	if (lapic_timer_reliable_states != LAPIC_TIMER_ALWAYS_RELIABLE)
>   		on_each_cpu(__setup_broadcast_timer, (void *)false, 1);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

