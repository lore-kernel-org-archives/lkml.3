Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaCAApC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:45:02 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64301 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752570AbaCAAo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:44:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: skannan@codeaurora.org, linaro-kernel@lists.linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH 1/3] cpufreq: move call to __find_governor() to cpufreq_init_policy()
Date: Sat, 01 Mar 2014 02:00:03 +0100
Message-ID: <1502303.OT1VzMZkk2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9f9546137135103556c69815c72b81ed93cc1ca2.1393318100.git.viresh.kumar@linaro.org>
References: <9f9546137135103556c69815c72b81ed93cc1ca2.1393318100.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 25, 2014 02:20:09 PM Viresh Kumar wrote:
> We call __find_governor() during addition of first CPU of every policy to find
> the last governor used for this CPU before it was hotplugged-out.
> 
> After that we call cpufreq_parse_governor() in cpufreq_init_policy() either with
> this governor or default governor. And right after that policy->governor is set
> to NULL.

This is a problem, right?  So care to write *why* it is a problem here?

> So, instead of doing this move the relevant parts to cpufreq_init_policy()
> policy only and initialize policy->governor to NULL at the beginning.

And this change is supposed to fix that problem, right?  You're not moving
stuff around just for the fun of it?

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> ---
> 
> Hi Saravana,
> 
> I hope only the first two patches would fix things for you but probably you can
> test all three.
> 
> @Rafael: We might need to get these in next rc only as these are more or less
> fixes.
> 
>  drivers/cpufreq/cpufreq.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index c755b5f..cc4f244 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -879,18 +879,27 @@ err_out_kobj_put:
>  
>  static void cpufreq_init_policy(struct cpufreq_policy *policy)
>  {
> +	struct cpufreq_governor *gov = NULL;
>  	struct cpufreq_policy new_policy;
>  	int ret = 0;
>  
>  	memcpy(&new_policy, policy, sizeof(*policy));
>  
> +	/* Update governor of new_policy to the governor used before hotplug */
> +#ifdef CONFIG_HOTPLUG_CPU
> +	gov = __find_governor(per_cpu(cpufreq_cpu_governor, policy->cpu));
> +#endif
> +	if (gov)
> +		pr_debug("Restoring governor %s for cpu %d\n",
> +				policy->governor->name, policy->cpu);
> +	else
> +		gov = CPUFREQ_DEFAULT_GOVERNOR;
> +
> +	new_policy.governor = gov;
> +
>  	/* Use the default policy if its valid. */
>  	if (cpufreq_driver->setpolicy)
> -		cpufreq_parse_governor(policy->governor->name,
> -					&new_policy.policy, NULL);
> -
> -	/* assure that the starting sequence is run in cpufreq_set_policy */
> -	policy->governor = NULL;
> +		cpufreq_parse_governor(gov->name, &new_policy.policy, NULL);
>  
>  	/* set default policy */
>  	ret = cpufreq_set_policy(policy, &new_policy);
> @@ -944,11 +953,11 @@ static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
>  	unsigned long flags;
>  
>  	read_lock_irqsave(&cpufreq_driver_lock, flags);
> -
>  	policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
> -
>  	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>  
> +	policy->governor = NULL;
> +
>  	return policy;
>  }
>  
> @@ -1036,7 +1045,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  	unsigned long flags;
>  #ifdef CONFIG_HOTPLUG_CPU
>  	struct cpufreq_policy *tpolicy;
> -	struct cpufreq_governor *gov;
>  #endif
>  
>  	if (cpu_is_offline(cpu))
> @@ -1094,7 +1102,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  	else
>  		policy->cpu = cpu;
>  
> -	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
>  	cpumask_copy(policy->cpus, cpumask_of(cpu));
>  
>  	init_completion(&policy->kobj_unregister);
> @@ -1179,15 +1186,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>  				     CPUFREQ_START, policy);
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -	gov = __find_governor(per_cpu(cpufreq_cpu_governor, cpu));
> -	if (gov) {
> -		policy->governor = gov;
> -		pr_debug("Restoring governor %s for cpu %d\n",
> -		       policy->governor->name, cpu);
> -	}
> -#endif
> -
>  	if (!frozen) {
>  		ret = cpufreq_add_dev_interface(policy, dev);
>  		if (ret)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
