Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab3BKJSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:18:51 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33654 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3BKJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:18:48 -0500
Message-ID: <5118B776.6090604@linaro.org>
Date: Mon, 11 Feb 2013 10:18:46 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 01/16] APM idle: register apm_cpu_idle via cpuidle
References: <1360475903-30007-1-git-send-email-lenb@kernel.org> <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
In-Reply-To: <2b219d07e0f287c2c713f5465fc8646158fa986e.1360475150.git.len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 06:58 AM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> Update APM to register its local idle routine with cpuidle.
> 
> This allows us to stop exporting pm_idle to modules on x86.
> 
> The Kconfig sub-option, APM_CPU_IDLE, now depends on on CPU_IDLE.
> 
> Compile-tested only.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> ---

[ ... ]

>  
> +static int apm_cpu_idle(struct cpuidle_device *dev,
> +			struct cpuidle_driver *drv, int index);
> +
> +static struct cpuidle_driver apm_idle_driver = {
> +	.name = "apm_idle",
> +	.owner = THIS_MODULE,
> +	.en_core_tk_irqen = 1,
> +	.states = {
> +		{ /* entry 0 is for polling */ },
> +		{ /* entry 1 is for APM idle */
> +			.name = "APM",
> +			.desc = "APM idle",
> +			.flags = CPUIDLE_FLAG_TIME_VALID,
> +			.exit_latency = 250,	/* WAG */
> +			.target_residency = 500,	/* WAG */
> +			.enter = &apm_cpu_idle
> +		},
> +	},
> +};
> +
> +static struct cpuidle_device apm_cpuidle_device = {
> +	.state_count = 2,
> +};

This will make the cpuidle_register_driver to fail because the
state_count field of the cpuidle_driver is zero, no ?

static struct cpuidle_driver apm_idle_driver = {
	.name = "apm_idle",
	...
	.states = {
	...
	},
	.state_count = 2,
}

static struct cpuidle_device apm_cpuidle_device;

>  /*
>   * Local variables
>   */
> @@ -377,7 +402,6 @@ static struct {
>  static int clock_slowed;
>  static int idle_threshold __read_mostly = DEFAULT_IDLE_THRESHOLD;
>  static int idle_period __read_mostly = DEFAULT_IDLE_PERIOD;
> -static int set_pm_idle;
>  static int suspends_pending;
>  static int standbys_pending;
>  static int ignore_sys_suspend;
> @@ -884,8 +908,6 @@ static void apm_do_busy(void)
>  #define IDLE_CALC_LIMIT	(HZ * 100)
>  #define IDLE_LEAKY_MAX	16
>  
> -static void (*original_pm_idle)(void) __read_mostly;
> -
>  /**
>   * apm_cpu_idle		-	cpu idling for APM capable Linux
>   *
> @@ -894,7 +916,8 @@ static void (*original_pm_idle)(void) __read_mostly;
>   * Furthermore it calls the system default idle routine.
>   */
>  
> -static void apm_cpu_idle(void)
> +static int apm_cpu_idle(struct cpuidle_device *dev,
> +	struct cpuidle_driver *drv, int index)
>  {
>  	static int use_apm_idle; /* = 0 */
>  	static unsigned int last_jiffies; /* = 0 */
> @@ -904,7 +927,6 @@ static void apm_cpu_idle(void)
>  	unsigned int jiffies_since_last_check = jiffies - last_jiffies;
>  	unsigned int bucket;
>  
> -	WARN_ONCE(1, "deprecated apm_cpu_idle will be deleted in 2012");
>  recalc:
>  	if (jiffies_since_last_check > IDLE_CALC_LIMIT) {
>  		use_apm_idle = 0;
> @@ -950,10 +972,7 @@ recalc:
>  				break;
>  			}
>  		}
> -		if (original_pm_idle)
> -			original_pm_idle();
> -		else
> -			default_idle();
> +		default_idle();
>  		local_irq_disable();
>  		jiffies_since_last_check = jiffies - last_jiffies;
>  		if (jiffies_since_last_check > idle_period)
> @@ -964,6 +983,7 @@ recalc:
>  		apm_do_busy();
>  
>  	local_irq_enable();

           ^^^^^^^^

As the 'en_core_tk_irqen' flag has been enabled in the driver, the
caller of this function will call 'local_irq_enable'. We can remove the
this line no ?

> +	return index;
>  }
>  
>  /**
> @@ -2381,9 +2401,9 @@ static int __init apm_init(void)
>  	if (HZ != 100)
>  		idle_period = (idle_period * HZ) / 100;
>  	if (idle_threshold < 100) {
> -		original_pm_idle = pm_idle;
> -		pm_idle  = apm_cpu_idle;
> -		set_pm_idle = 1;
> +		if (!cpuidle_register_driver(&apm_idle_driver))
> +			if (cpuidle_register_device(&apm_cpuidle_device))
> +				cpuidle_unregister_driver(&apm_idle_driver);
>  	}
>  
>  	return 0;
> @@ -2393,15 +2413,9 @@ static void __exit apm_exit(void)
>  {
>  	int error;
>  
> -	if (set_pm_idle) {
> -		pm_idle = original_pm_idle;
> -		/*
> -		 * We are about to unload the current idle thread pm callback
> -		 * (pm_idle), Wait for all processors to update cached/local
> -		 * copies of pm_idle before proceeding.
> -		 */
> -		kick_all_cpus_sync();
> -	}
> +	cpuidle_unregister_device(&apm_cpuidle_device);
> +	cpuidle_unregister_driver(&apm_idle_driver);
> +
>  	if (((apm_info.bios.flags & APM_BIOS_DISENGAGED) == 0)
>  	    && (apm_info.connection_version > 0x0100)) {
>  		error = apm_engage_power_management(APM_DEVICE_ALL, 0);
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 2ed787f..f571a6e 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -272,9 +272,6 @@ EXPORT_SYMBOL(boot_option_idle_override);
>   * Powermanagement idle function, if any..
>   */
>  void (*pm_idle)(void);
> -#ifdef CONFIG_APM_MODULE
> -EXPORT_SYMBOL(pm_idle);
> -#endif
>  
>  #ifndef CONFIG_SMP
>  static inline void play_dead(void)
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

