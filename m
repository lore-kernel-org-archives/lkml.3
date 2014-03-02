Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaCAXro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 18:47:44 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52181 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753318AbaCAXrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 18:47:42 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com
Subject: Re: [PATCH V6 3/7] cpufreq: call driver's suspend/resume for each policy
Date: Sun, 02 Mar 2014 01:02:48 +0100
Message-ID: <2643598.WF6sczxQTx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <c2fe4eb6746b1dfd234d1d07ad2efdea55292359.1392629003.git.viresh.kumar@linaro.org>
References: <cover.1392629003.git.viresh.kumar@linaro.org> <c2fe4eb6746b1dfd234d1d07ad2efdea55292359.1392629003.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 02:55:09 PM Viresh Kumar wrote:
> Earlier cpufreq suspend/resume callbacks into drivers were getting called only
> for the boot CPU, as by the time callbacks were called non-boot CPUs were
> already removed. Because we might still need driver specific actions on
> suspend/resume, its better to use earlier infrastructure from the early
> suspend/late resume calls.
> 
> In effect, we call suspend/resume for each policy. The resume part also takes
> care of synchronising frequency for boot CPU, which might turn out be different
> than what cpufreq core believes.
> 
> Hence, the earlier syscore infrastructure is getting removed now.

This should be folded into [1-2/7] too, I think, because otherwise you have a
gap where things are kind of in between the two solutions.

> Tested-by: Lan Tianyu <tianyu.lan@intel.com>
> Tested-by: Nishanth Menon <nm@ti.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 98 +++++++++--------------------------------------
>  1 file changed, 18 insertions(+), 80 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 4ca2297..c240232 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -27,7 +27,6 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <linux/suspend.h>
> -#include <linux/syscore_ops.h>
>  #include <linux/tick.h>
>  #include <trace/events/power.h>
>  
> @@ -1599,10 +1598,15 @@ void cpufreq_suspend(void)
>  
>  	pr_debug("%s: Suspending Governors\n", __func__);
>  
> -	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> +	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
>  		if (__cpufreq_governor(policy, CPUFREQ_GOV_STOP))
>  			pr_err("%s: Failed to stop governor for policy: %p\n",
>  				__func__, policy);
> +		else if (cpufreq_driver->suspend
> +		    && cpufreq_driver->suspend(policy))
> +			pr_err("%s: Failed to suspend driver: %p\n", __func__,
> +				policy);
> +	}
>  
>  	cpufreq_suspended = true;
>  }
> @@ -1627,91 +1631,26 @@ void cpufreq_resume(void)
>  
>  	cpufreq_suspended = false;
>  
> -	list_for_each_entry(policy, &cpufreq_policy_list, policy_list)
> +	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
>  		if (__cpufreq_governor(policy, CPUFREQ_GOV_START)
>  		    || __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))
>  			pr_err("%s: Failed to start governor for policy: %p\n",
>  				__func__, policy);
> -}
> -
> -/**
> - * cpufreq_bp_suspend - Prepare the boot CPU for system suspend.
> - *
> - * This function is only executed for the boot processor.  The other CPUs
> - * have been put offline by means of CPU hotplug.
> - */
> -static int cpufreq_bp_suspend(void)
> -{
> -	int ret = 0;
> -
> -	int cpu = smp_processor_id();
> -	struct cpufreq_policy *policy;
> -
> -	pr_debug("suspending cpu %u\n", cpu);
> -
> -	/* If there's no policy for the boot CPU, we have nothing to do. */
> -	policy = cpufreq_cpu_get(cpu);
> -	if (!policy)
> -		return 0;
> -
> -	if (cpufreq_driver->suspend) {
> -		ret = cpufreq_driver->suspend(policy);
> -		if (ret)
> -			printk(KERN_ERR "cpufreq: suspend failed in ->suspend "
> -					"step on CPU %u\n", policy->cpu);
> -	}
> -
> -	cpufreq_cpu_put(policy);
> -	return ret;
> -}
> +		else if (cpufreq_driver->resume
> +		    && cpufreq_driver->resume(policy))
> +			pr_err("%s: Failed to resume driver: %p\n", __func__,
> +				policy);
>  
> -/**
> - * cpufreq_bp_resume - Restore proper frequency handling of the boot CPU.
> - *
> - *	1.) resume CPUfreq hardware support (cpufreq_driver->resume())
> - *	2.) schedule call cpufreq_update_policy() ASAP as interrupts are
> - *	    restored. It will verify that the current freq is in sync with
> - *	    what we believe it to be. This is a bit later than when it
> - *	    should be, but nonethteless it's better than calling
> - *	    cpufreq_driver->get() here which might re-enable interrupts...
> - *
> - * This function is only executed for the boot CPU.  The other CPUs have not
> - * been turned on yet.
> - */
> -static void cpufreq_bp_resume(void)
> -{
> -	int ret = 0;
> -
> -	int cpu = smp_processor_id();
> -	struct cpufreq_policy *policy;
> -
> -	pr_debug("resuming cpu %u\n", cpu);
> -
> -	/* If there's no policy for the boot CPU, we have nothing to do. */
> -	policy = cpufreq_cpu_get(cpu);
> -	if (!policy)
> -		return;
> -
> -	if (cpufreq_driver->resume) {
> -		ret = cpufreq_driver->resume(policy);
> -		if (ret) {
> -			printk(KERN_ERR "cpufreq: resume failed in ->resume "
> -					"step on CPU %u\n", policy->cpu);
> -			goto fail;
> -		}
> +		/*
> +		 * schedule call cpufreq_update_policy() for boot CPU, i.e. last
> +		 * policy in list. It will verify that the current freq is in
> +		 * sync with what we believe it to be.
> +		 */
> +		if (list_is_last(&policy->policy_list, &cpufreq_policy_list))
> +			schedule_work(&policy->update);
>  	}
> -
> -	schedule_work(&policy->update);
> -
> -fail:
> -	cpufreq_cpu_put(policy);
>  }
>  
> -static struct syscore_ops cpufreq_syscore_ops = {
> -	.suspend	= cpufreq_bp_suspend,
> -	.resume		= cpufreq_bp_resume,
> -};
> -
>  /**
>   *	cpufreq_get_current_driver - return current driver's name
>   *
> @@ -2477,7 +2416,6 @@ static int __init cpufreq_core_init(void)
>  
>  	cpufreq_global_kobject = kobject_create();
>  	BUG_ON(!cpufreq_global_kobject);
> -	register_syscore_ops(&cpufreq_syscore_ops);
>  
>  	return 0;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
