Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaCGAqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:46:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53345 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750924AbaCGAqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:46:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com
Subject: Re: [PATCH V6 Resend 1/5] cpufreq: suspend governors on system suspend/hibernate
Date: Fri, 07 Mar 2014 02:01:14 +0100
Message-ID: <6523021.Z15JvIV2Lx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
References: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 04, 2014 11:00:26 AM Viresh Kumar wrote:
> This patch adds cpufreq suspend/resume calls to dpm_{suspend|resume}() for
> handling suspend/resume of cpufreq governors.
> 
> Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found an issue where tunables
> configuration for clusters/sockets with non-boot CPUs was getting lost after
> suspend/resume, as we were notifying governors with CPUFREQ_GOV_POLICY_EXIT on
> removal of the last cpu for that policy and so deallocating memory for tunables.
> This is fixed by this patch as we don't allow any operation on governors after
> device suspend and before device resume now.
> 
> We could have added these callbacks at dpm_{suspend|resume}_noirq() level but
> the problem here is that most of the devices (i.e. devices with ->suspend()
> callbacks) have already been suspended by now and so if drivers want to change
> frequency before suspending, then it might not be possible for many platforms
> (which depend on other peripherals like i2c, regulators, etc).
> 
> Reported-and-tested-by: Lan Tianyu <tianyu.lan@intel.com>
> Reported-by: Jinhyuk Choi <jinchoi@broadcom.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up for 3.15, thanks!

> ---
> V5->V6: 1-2-3/7 merged into 1/5
> 
>  drivers/base/power/main.c |   5 +++
>  drivers/cpufreq/cpufreq.c | 111 +++++++++++++++++++++++-----------------------
>  include/linux/cpufreq.h   |   8 ++++
>  3 files changed, 69 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 42355e4..86d5e4f 100644
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
> @@ -866,6 +867,8 @@ void dpm_resume(pm_message_t state)
>  	mutex_unlock(&dpm_list_mtx);
>  	async_synchronize_full();
>  	dpm_show_time(starttime, state, NULL);
> +
> +	cpufreq_resume();
>  }
>  
>  /**
> @@ -1434,6 +1437,8 @@ int dpm_suspend(pm_message_t state)
>  
>  	might_sleep();
>  
> +	cpufreq_suspend();
> +
>  	mutex_lock(&dpm_list_mtx);
>  	pm_transition = state;
>  	async_error = 0;
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 56b7b1b..2e43c08 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -26,7 +26,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> -#include <linux/syscore_ops.h>
> +#include <linux/suspend.h>
>  #include <linux/tick.h>
>  #include <trace/events/power.h>
>  
> @@ -47,6 +47,9 @@ static LIST_HEAD(cpufreq_policy_list);
>  static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
>  
> +/* Flag to suspend/resume CPUFreq governors */
> +static bool cpufreq_suspended;
> +
>  static inline bool has_target(void)
>  {
>  	return cpufreq_driver->target_index || cpufreq_driver->target;
> @@ -1576,82 +1579,77 @@ static struct subsys_interface cpufreq_interface = {
>  };
>  
>  /**
> - * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
> + * cpufreq_suspend() - Suspend CPUFreq governors
>   *
> - * This function is only executed for the boot processor.  The other CPUs
> - * have been put offline by means of CPU hotplug.
> + * Called during system wide Suspend/Hibernate cycles for suspending governors
> + * as some platforms can't change frequency after this point in suspend cycle.
> + * Because some of the devices (like: i2c, regulators, etc) they use for
> + * changing frequency are suspended quickly after this point.
>   */
> -static int cpufreq_bp_suspend(void)
> +void cpufreq_suspend(void)
>  {
> -	int ret = 0;
> -
> -	int cpu = smp_processor_id();
>  	struct cpufreq_policy *policy;
>  
> -	pr_debug("suspending cpu %u\n", cpu);
> +	if (!cpufreq_driver)
> +		return;
>  
> -	/* If there's no policy for the boot CPU, we have nothing to do. */
> -	policy = cpufreq_cpu_get(cpu);
> -	if (!policy)
> -		return 0;
> +	if (!has_target())
> +		return;
>  
> -	if (cpufreq_driver->suspend) {
> -		ret = cpufreq_driver->suspend(policy);
> -		if (ret)
> -			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
> -					"step on CPU %u\n", policy->cpu);
> +	pr_debug("%s: Suspending Governors\n", __func__);
> +
> +	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
> +		if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
> +			pr_err("%s: Failed to stop governor for policy: %p\n",
> +				__func__, policy);
> +		else if (cpufreq_driver->suspend
> +		    && cpufreq_driver->suspend(policy))
> +			pr_err("%s: Failed to suspend driver: %p\n", __func__,
> +				policy);
>  	}
>  
> -	cpufreq_cpu_put(policy);
> -	return ret;
> +	cpufreq_suspended = true;
>  }
>  
>  /**
> - * cpufreq_bp_resume - Restore proper frequency handling of the boot CPU.
> + * cpufreq_resume() - Resume CPUFreq governors
>   *
> - *	1.) resume CPUfreq hardware support (cpufreq_driver->resume())
> - *	2.) schedule call cpufreq_update_policy() ASAP as interrupts are
> - *	    restored. It will verify that the current freq is in sync with
> - *	    what we believe it to be. This is a bit later than when it
> - *	    should be, but nonethteless it's better than calling
> - *	    cpufreq_driver->get() here which might re-enable interrupts...
> - *
> - * This function is only executed for the boot CPU.  The other CPUs have not
> - * been turned on yet.
> + * Called during system wide Suspend/Hibernate cycle for resuming governors that
> + * are suspended with cpufreq_suspend().
>   */
> -static void cpufreq_bp_resume(void)
> +void cpufreq_resume(void)
>  {
> -	int ret = 0;
> -
> -	int cpu = smp_processor_id();
>  	struct cpufreq_policy *policy;
>  
> -	pr_debug("resuming cpu %u\n", cpu);
> +	if (!cpufreq_driver)
> +		return;
>  
> -	/* If there's no policy for the boot CPU, we have nothing to do. */
> -	policy = cpufreq_cpu_get(cpu);
> -	if (!policy)
> +	if (!has_target())
>  		return;
>  
> -	if (cpufreq_driver->resume) {
> -		ret = cpufreq_driver->resume(policy);
> -		if (ret) {
> -			printk(KERN_ERR "cpufreq: resume failed in ->resume "
> -					"step on CPU %u\n", policy->cpu);
> -			goto fail;
> -		}
> -	}
> +	pr_debug("%s: Resuming Governors\n", __func__);
>  
> -	schedule_work(&policy->update);
> +	cpufreq_suspended = false;
>  
> -fail:
> -	cpufreq_cpu_put(policy);
> -}
> +	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
> +		if (__cpufreq_governor(policy, CPUFREQ_GOV_START)
> +		    || __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))
> +			pr_err("%s: Failed to start governor for policy: %p\n",
> +				__func__, policy);
> +		else if (cpufreq_driver->resume
> +		    && cpufreq_driver->resume(policy))
> +			pr_err("%s: Failed to resume driver: %p\n", __func__,
> +				policy);
>  
> -static struct syscore_ops cpufreq_syscore_ops = {
> -	.suspend	= cpufreq_bp_suspend,
> -	.resume		= cpufreq_bp_resume,
> -};
> +		/*
> +		 * schedule call cpufreq_update_policy() for boot CPU, i.e. last
> +		 * policy in list. It will verify that the current freq is in
> +		 * sync with what we believe it to be.
> +		 */
> +		if (list_is_last(&policy->policy_list, &cpufreq_policy_list))
> +			schedule_work(&policy->update);
> +	}
> +}
>  
>  /**
>   *	cpufreq_get_current_driver - return current driver's name
> @@ -1868,6 +1866,10 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
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
> @@ -2407,7 +2409,6 @@ static int __init cpufreq_core_init(void)
>  
>  	cpufreq_global_kobject = kobject_create();
>  	BUG_ON(!cpufreq_global_kobject);
> -	register_syscore_ops(&cpufreq_syscore_ops);
>  
>  	return 0;
>  }
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 4d89e0e..94ed907 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -296,6 +296,14 @@ cpufreq_verify_within_cpu_limits(struct cpufreq_policy *policy)
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
