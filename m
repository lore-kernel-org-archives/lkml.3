Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab3KYXQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:16:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50497 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751788Ab3KYXQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:16:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com
Subject: Re: [PATCH V3 1/6] cpufreq: suspend governors on system suspend/hibernate
Date: Tue, 26 Nov 2013 00:29:07 +0100
Message-ID: <40779593.MBXsTetiKz@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <55cc3fbf9c553d669629e8ba98eef2b0ef33aaad.1385374822.git.viresh.kumar@linaro.org>
References: <cover.1385374819.git.viresh.kumar@linaro.org> <55cc3fbf9c553d669629e8ba98eef2b0ef33aaad.1385374822.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 07:41:41 PM Viresh Kumar wrote:
> 
> This patch adds cpufreq callbacks to dpm_{suspend|resume}() for handling
> suspend/resume of cpufreq governors. This is required for early suspend and
> late resume of governors and cpufreq core.
> 
> There are multiple problems that are fixed by this patch:
> - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board 
>   wasn't working well with suspend/resume as calls for removing non-boot CPUs
>   was turning out into a call to drivers ->target() which then tries to play
>   with regulators. But regulators and their I2C bus were already suspended and
>   this resulted in a failure. Many platforms have such problems, samsung,
>   tegra, etc.. They solved it with driver specific PM notifiers where they
>   used to disable their driver's ->target() routine.
> 
> - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
> 
>   tunables configuration for clusters/sockets with non-boot CPUs was getting
>   lost after suspend/resume, as we were notifying governors with
>   CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
>   deallocating memory for tunables. This is also fixed with this patch as don't
>   allow any operation on Governors during suspend/resume now.
> 
> Reported-by: Lan Tianyu <tianyu.lan@intel.com>
> Reported-by: Nishanth Menon <nm@ti.com>
> Reported-by: Jinhyuk Choi <jinchoi@broadcom.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> ---
> drivers/base/power/main.c |  5 +++++
> 
>  drivers/cpufreq/cpufreq.c | 50
>  +++++++++++++++++++++++++++++++++++++++++++++++ include/linux/cpufreq.h  
>  |  3 +++
>  3 files changed, 58 insertions(+)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 1b41fca..c9fbb9d 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -29,6 +29,7 @@
> 
>  #include <linux/async.h>
>  #include <linux/suspend.h>
>  #include <trace/events/power.h>
> 
> +#include <linux/cpufreq.h>
> 
>  #include <linux/cpuidle.h>
>  #include <linux/timer.h>
> 
> @@ -789,6 +790,8 @@ void dpm_resume(pm_message_t state)
> 
>  	mutex_unlock(&dpm_list_mtx);
>  	async_synchronize_full();
>  	dpm_show_time(starttime, state, NULL);
> 
> +
> +	cpufreq_resume();
> 
>  }
>  
>  /**
> 
> @@ -1259,6 +1262,8 @@ int dpm_suspend(pm_message_t state)
> 
>  	might_sleep();
> 
> +	cpufreq_suspend();
> +
> 
>  	mutex_lock(&dpm_list_mtx);
>  	pm_transition = state;
>  	async_error = 0;

Shouldn't it do cpufreq_resume() on errors?

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 02d534d..b6c7821 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -26,6 +26,7 @@
> 
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> 
> +#include <linux/suspend.h>
> 
>  #include <linux/syscore_ops.h>
>  #include <linux/tick.h>
>  #include <trace/events/power.h>
> 
> @@ -47,6 +48,9 @@ static LIST_HEAD(cpufreq_policy_list);
> 
>  static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
> 
> +/* Flag to suspend/resume CPUFreq governors */
> +static bool cpufreq_suspended;
> +
> 
>  static inline bool has_target(void)
>  {
>  
>  	return cpufreq_driver->target_index || cpufreq_driver->target;
> 
> @@ -1462,6 +1466,48 @@ static struct subsys_interface cpufreq_interface = {
> 
>  	.remove_dev	= cpufreq_remove_dev,
>  
>  };
> 
> +/*
> + * Callbacks for suspending/resuming governors as some platforms can't
> change + * frequency after this point in suspend cycle. Because some of the
> devices + * (like: i2c, regulators, etc) they use for changing frequency
> are suspended + * quickly after this point.
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

This appears to be racy.  Is it really racy, or just seemingly?

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
> 
>  /**
>  
>   * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
>   *
> 
> @@ -1764,6 +1810,10 @@ static int __cpufreq_governor(struct cpufreq_policy
> *policy,> 
>  	struct cpufreq_governor *gov = NULL;
>  
>  #endif
> 
> +	/* Don't start any governor operations if we are entering suspend */
> +	if (cpufreq_suspended)
> +		return 0;
> +
> 
>  	if (policy->governor->max_transition_latency &&
>  	
>  	    policy->cpuinfo.transition_latency >
>  	    policy->governor->max_transition_latency) {
> 
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index dc196bb..6d93f91 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -255,6 +255,9 @@ struct cpufreq_driver {
> 
>  int cpufreq_register_driver(struct cpufreq_driver *driver_data);
>  int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
> 
> +void cpufreq_suspend(void);
> +void cpufreq_resume(void);
> +
> 
>  const char *cpufreq_get_current_driver(void);
>  
>  static inline void cpufreq_verify_within_limits(struct cpufreq_policy
>  *policy,

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
