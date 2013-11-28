Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab3K1OKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:10:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49571 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757435Ab3K1OKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:10:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com
Subject: Re: [PATCH V4] cpufreq: suspend governors on system suspend/hibernate
Date: Thu, 28 Nov 2013 15:23:33 +0100
Message-ID: <3057132.zHNVNQZ8pP@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <28d493f20239a242a7b26dfe1efed40d83bf1e10.1385523340.git.viresh.kumar@linaro.org>
References: <28d493f20239a242a7b26dfe1efed40d83bf1e10.1385523340.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 09:09:42 AM Viresh Kumar wrote:
> This patch adds cpufreq callbacks to dpm_{suspend|resume}_noirq() for handling
> suspend/resume of cpufreq governors.
> 
> There are multiple problems that are fixed by this patch:
> - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
>   wasn't working well with suspend/resume as calls for removing non-boot CPUs
>   was turning out into a call to drivers ->target() which then tries to play
>   with regulators. But regulators and their I2C bus were already suspended and
>   this resulted in a failure. Many platforms have such problems, samsung, tegra,
>   etc.. They solved it with driver specific PM notifiers where they used to
>   disable their driver's ->target() routine.

I don't think that the Nishanth's issue is fixed by this particular version of
the patch, so I modified the changelog and removed a the comment above
cpufreq_suspend() (which should be a proper kerneldoc one if any, BTW).

I've also made some minor changes to the conditionals, because I didn't like them
the way they were written originally.

Please check the result in bleeding-edge.

Thanks!

> - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
>   tunables configuration for clusters/sockets with non-boot CPUs was getting
>   lost after suspend/resume, as we were notifying governors with
>   CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
>   deallocating memory for tunables. This is also fixed with this patch as we
>   don't allow any operation on Governors during suspend/resume now.
> 
> Reported-and-tested-by: Lan Tianyu <tianyu.lan@intel.com>
> Reported-and-tested-by: Nishanth Menon <nm@ti.com>
> Reported-by: Jinhyuk Choi <jinchoi@broadcom.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> 
> This is almost same as 1/6 of V3 version of this patchset:
> 
> https://lkml.org/lkml/2013/11/25/838
> 
> This is done to get some initial fixes for 3.13. These are already tested by
> both the reporters of initial problems. Tegra/exynos/s5p will keep running their
> PM notifiers until v3.14, as they are currently able to work with them..
> 
>  drivers/base/power/main.c |  3 +++
>  drivers/cpufreq/cpufreq.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cpufreq.h   |  8 ++++++++
>  3 files changed, 61 insertions(+)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 1b41fca..e3219df 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -29,6 +29,7 @@
>  #include <linux/async.h>
>  #include <linux/suspend.h>
>  #include <trace/events/power.h>
> +#include <linux/cpufreq.h>
>  #include <linux/cpuidle.h>
>  #include <linux/timer.h>
>  
> @@ -540,6 +541,7 @@ static void dpm_resume_noirq(pm_message_t state)
>  	dpm_show_time(starttime, state, "noirq");
>  	resume_device_irqs();
>  	cpuidle_resume();
> +	cpufreq_resume();
>  }
>  
>  /**
> @@ -955,6 +957,7 @@ static int dpm_suspend_noirq(pm_message_t state)
>  	ktime_t starttime = ktime_get();
>  	int error = 0;
>  
> +	cpufreq_suspend();
>  	cpuidle_pause();
>  	suspend_device_irqs();
>  	mutex_lock(&dpm_list_mtx);
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 02d534d..b6c7821 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -26,6 +26,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/suspend.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/tick.h>
>  #include <trace/events/power.h>
> @@ -47,6 +48,9 @@ static LIST_HEAD(cpufreq_policy_list);
>  static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
>  
> +/* Flag to suspend/resume CPUFreq governors */
> +static bool cpufreq_suspended;
> +
>  static inline bool has_target(void)
>  {
>  	return cpufreq_driver->target_index || cpufreq_driver->target;
> @@ -1462,6 +1466,48 @@ static struct subsys_interface cpufreq_interface = {
>  	.remove_dev	= cpufreq_remove_dev,
>  };
>  
> +/*
> + * Callbacks for suspending/resuming governors as some platforms can't change
> + * frequency after this point in suspend cycle. Because some of the devices
> + * (like: i2c, regulators, etc) they use for changing frequency are suspended
> + * quickly after this point.
> + */
> +void cpufreq_suspend(void)
> +{
> +	struct cpufreq_policy *policy;
> +
> +	if (!has_target())
> +		return;
> +
> +	pr_debug("%s: Suspending Governors\n", __func__);
> +
> +	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> +		if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
> +			pr_err("%s: Failed to stop governor for policy: %p\n",
> +					__func__, policy);
> +
> +	cpufreq_suspended = true;
> +}
> +
> +void cpufreq_resume(void)
> +{
> +	struct cpufreq_policy *policy;
> +
> +	if (!has_target())
> +		return;
> +
> +	pr_debug("%s: Resuming Governors\n", __func__);
> +
> +	cpufreq_suspended = false;
> +
> +	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> +		if (__cpufreq_governor(policy, CPUFREQ_GOV_START) ||
> +				__cpufreq_governor(policy,
> +					CPUFREQ_GOV_LIMITS))
> +			pr_err("%s: Failed to start governor for policy: %p\n",
> +					__func__, policy);
> +}
> +
>  /**
>   * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
>   *
> @@ -1764,6 +1810,10 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  	struct cpufreq_governor *gov = NULL;
>  #endif
>  
> +	/* Don't start any governor operations if we are entering suspend */
> +	if (cpufreq_suspended)
> +		return 0;
> +
>  	if (policy->governor->max_transition_latency &&
>  	    policy->cpuinfo.transition_latency >
>  	    policy->governor->max_transition_latency) {
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index dc196bb..ee5fe9d 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -280,6 +280,14 @@ cpufreq_verify_within_cpu_limits(struct cpufreq_policy *policy)
>  			policy->cpuinfo.max_freq);
>  }
>  
> +#ifdef CONFIG_CPU_FREQ
> +void cpufreq_suspend(void);
> +void cpufreq_resume(void);
> +#else
> +static inline void cpufreq_suspend(void) {}
> +static inline void cpufreq_resume(void) {}
> +#endif
> +
>  /*********************************************************************
>   *                     CPUFREQ NOTIFIER INTERFACE                    *
>   *********************************************************************/
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
