Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab3KPF5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 00:57:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:8206 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3KPF4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 00:56:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,712,1378882800"; 
   d="scan'208";a="428665151"
Message-ID: <52870904.5070102@intel.com>
Date: Sat, 16 Nov 2013 13:56:20 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, jinchoi@broadcom.com,
        sebastian.capella@linaro.org
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
In-Reply-To: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 06:12 PM, Viresh Kumar wrote:
> This patch adds PM notifiers for handling suspend/resume of cpufreq governors.
> This is required for early suspend and late resume of governors.
>
> There are multiple reasons that support this patch:
> - Firstly it looks very much logical to stop governors when we know we are going
>    into suspend. But the question is when? Is PM notifiers the right place?
>    Following reasons are the supporting hands for this decision.
> - Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
>    wasn't working well with suspend/resume as calls for removing non-boot CPUs
>    was turning out into a call to drivers ->target() which then tries to play
>    with regulators. But regulators and their I2C bus were already suspended and
>    this resulted in a failure. This is why we need a PM notifier here.
> - Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
>    tunables configuration for clusters/sockets with non-boot CPUs was getting
>    lost after suspend/resume, as we were notifying governors with
>    CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
>    deallocating memory for tunables.
>
> All above problems get fixed with having a PM notifier in place which will stop
> any operation on governor. Hence no need to do any special handling of variables
> like (frozen) in suspend/resume paths.
>
> Reported-by: Lan Tianyu <tianyu.lan@intel.com>
> Reported-by: Nishanth Menon <nm@ti.com>
> Reported-by: Jinhyuk Choi <jinchoi@broadcom.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>
> Hi Guys,
>
> Can you please verify if this fixes issues reported by you? I have tested this
> for multiple suspend-resumes on my thinkpad. It doesn't crash :)

This patch fixs my issue.

Tested-by: Lan Tianyu <tianyu.lan@intel.com>

>
>   drivers/cpufreq/cpufreq.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 63 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 02d534d..c87ced9 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -26,6 +26,7 @@
>   #include <linux/module.h>
>   #include <linux/mutex.h>
>   #include <linux/slab.h>
> +#include <linux/suspend.h>
>   #include <linux/syscore_ops.h>
>   #include <linux/tick.h>
>   #include <trace/events/power.h>
> @@ -47,6 +48,9 @@ static LIST_HEAD(cpufreq_policy_list);
>   static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>   #endif
>
> +/* Flag to suspend/resume CPUFreq governors */
> +static bool cpufreq_suspended;
> +
>   static inline bool has_target(void)
>   {
>   	return cpufreq_driver->target_index || cpufreq_driver->target;
> @@ -1462,6 +1466,54 @@ static struct subsys_interface cpufreq_interface = {
>   	.remove_dev	= cpufreq_remove_dev,
>   };
>
> +/*
> + * PM Notifier for suspending governors as some platforms can't change frequency
> + * after this point in suspend cycle. Because some of the devices (like: i2c,
> + * regulators, etc) they use for changing frequency are suspended quickly after
> + * this point.
> + */
> +static int cpufreq_pm_notify(struct notifier_block *nb, unsigned long action,
> +		void *data)
> +{
> +	struct cpufreq_policy *policy;
> +	unsigned long flags;
> +
> +	if (!has_target())
> +		return NOTIFY_OK;
> +
> +	if (action == PM_SUSPEND_PREPARE) {
> +		pr_debug("%s: Suspending Governors\n", __func__);
> +
> +		list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> +			if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
> +				pr_err("%s: Failed to stop governor for policy: %p\n",
> +						__func__, policy);
> +
> +		write_lock_irqsave(&cpufreq_driver_lock, flags);
> +		cpufreq_suspended = true;
> +		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +	} else if (action == PM_POST_SUSPEND) {
> +		pr_debug("%s: Resuming Governors\n", __func__);
> +
> +		write_lock_irqsave(&cpufreq_driver_lock, flags);
> +		cpufreq_suspended = false;
> +		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
> +		list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> +			if (__cpufreq_governor(policy, CPUFREQ_GOV_START) ||
> +					__cpufreq_governor(policy,
> +						CPUFREQ_GOV_LIMITS))
> +				pr_err("%s: Failed to start governor for policy: %p\n",
> +						__func__, policy);
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block cpufreq_pm_notifier = {
> +	.notifier_call = cpufreq_pm_notify,
> +};
> +
>   /**
>    * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
>    *
> @@ -1752,6 +1804,8 @@ EXPORT_SYMBOL_GPL(cpufreq_driver_target);
>   static int __cpufreq_governor(struct cpufreq_policy *policy,
>   					unsigned int event)
>   {
> +	unsigned long flags;
> +	bool is_suspended;
>   	int ret;
>
>   	/* Only must be defined when default governor is known to have latency
> @@ -1764,6 +1818,14 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>   	struct cpufreq_governor *gov = NULL;
>   #endif
>
> +	/* Don't start any governor operations if we are entering suspend */
> +	read_lock_irqsave(&cpufreq_driver_lock, flags);
> +	is_suspended = cpufreq_suspended;
> +	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
> +	if (is_suspended)
> +		return 0;
> +
>   	if (policy->governor->max_transition_latency &&
>   	    policy->cpuinfo.transition_latency >
>   	    policy->governor->max_transition_latency) {
> @@ -2222,6 +2284,7 @@ static int __init cpufreq_core_init(void)
>   	cpufreq_global_kobject = kobject_create();
>   	BUG_ON(!cpufreq_global_kobject);
>   	register_syscore_ops(&cpufreq_syscore_ops);
> +	register_pm_notifier(&cpufreq_pm_notifier);
>
>   	return 0;
>   }
>


-- 
Best Regards
Tianyu Lan
