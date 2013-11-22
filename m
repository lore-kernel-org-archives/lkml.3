Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3KVMUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:20:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54964 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751956Ab3KVMU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:20:29 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianyu.lan@intel.com, nm@ti.com,
        jinchoi@broadcom.com, sebastian.capella@linaro.org
Subject: Re: [PATCH V2 1/2] cpufreq: suspend governors on system suspend/hibernate
Date: Fri, 22 Nov 2013 13:33:10 +0100
Message-ID: <230872262.gyF1HmIKoj@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <e4bc55fac6bc68694e9905cc3cc6844173b64925.1385118256.git.viresh.kumar@linaro.org>
References: <cover.1385118255.git.viresh.kumar@linaro.org> <e4bc55fac6bc68694e9905cc3cc6844173b64925.1385118256.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 22, 2013 04:59:48 PM Viresh Kumar wrote:
> This patch adds cpufreq callbacks to dpm_{suspend|resume}_noirq() for handling
> suspend/resume of cpufreq governors. This is required for early suspend and late
> resume of governors.
> 
> There are multiple problems that are fixed by this patch:
> - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
>   wasn't working well with suspend/resume as calls for removing non-boot CPUs
>   was turning out into a call to drivers ->target() which then tries to play
>   with regulators. But regulators and their I2C bus were already suspended and
>   this resulted in a failure. This is why we need a PM notifier here.
> - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
>   tunables configuration for clusters/sockets with non-boot CPUs was getting
>   lost after suspend/resume, as we were notifying governors with
>   CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
>   deallocating memory for tunables.
> 
> Reported-by: Lan Tianyu <tianyu.lan@intel.com>
> Reported-by: Nishanth Menon <nm@ti.com>
> Reported-by: Jinhyuk Choi <jinchoi@broadcom.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/base/power/main.c |  3 +++
>  drivers/cpufreq/cpufreq.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cpufreq.h   |  3 +++
>  3 files changed, 68 insertions(+)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index c12e9b9..0fbe792 100644
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
> index 02d534d..540bd87 100644
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
> @@ -1462,6 +1466,54 @@ static struct subsys_interface cpufreq_interface = {
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
> +	unsigned long flags;
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
> +	write_lock_irqsave(&cpufreq_driver_lock, flags);
> +	cpufreq_suspended = true;
> +	write_unlock_irqrestore(&cpufreq_driver_lock, flags);

The locking here is pointless.  It doesn't prevent any race conditions
from happening.

> +}
> +
> +void cpufreq_resume(void)
> +{
> +	struct cpufreq_policy *policy;
> +	unsigned long flags;
> +
> +	if (!has_target())
> +		return;
> +
> +	pr_debug("%s: Resuming Governors\n", __func__);
> +
> +	write_lock_irqsave(&cpufreq_driver_lock, flags);
> +	cpufreq_suspended = false;
> +	write_unlock_irqrestore(&cpufreq_driver_lock, flags);

Same here.

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
> @@ -1752,6 +1804,8 @@ EXPORT_SYMBOL_GPL(cpufreq_driver_target);
>  static int __cpufreq_governor(struct cpufreq_policy *policy,
>  					unsigned int event)
>  {
> +	unsigned long flags;
> +	bool is_suspended;
>  	int ret;
>  
>  	/* Only must be defined when default governor is known to have latency
> @@ -1764,6 +1818,14 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  	struct cpufreq_governor *gov = NULL;
>  #endif
>  
> +	/* Don't start any governor operations if we are entering suspend */
> +	read_lock_irqsave(&cpufreq_driver_lock, flags);
> +	is_suspended = cpufreq_suspended;
> +	read_unlock_irqrestore(&cpufreq_driver_lock, flags);

And same here.

> +
> +	if (is_suspended)

And you can check cpufreq_suspended directly here.

> +		return 0;
> +
>  	if (policy->governor->max_transition_latency &&
>  	    policy->cpuinfo.transition_latency >
>  	    policy->governor->max_transition_latency) {
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index dc196bb..6d93f91 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -255,6 +255,9 @@ struct cpufreq_driver {
>  int cpufreq_register_driver(struct cpufreq_driver *driver_data);
>  int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
>  
> +void cpufreq_suspend(void);
> +void cpufreq_resume(void);
> +
>  const char *cpufreq_get_current_driver(void);
>  
>  static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
