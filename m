Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3A2VjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 16:39:21 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59434 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3A2VjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 16:39:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: inderpal.singh@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH V3] cpufreq: Simplify cpufreq_add_dev()
Date: Tue, 29 Jan 2013 22:45:27 +0100
Message-ID: <1714110.knKZFeZSOf@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <c7c9f237a91821661bfc0735e390358124953695.1359469932.git.viresh.kumar@linaro.org>
References: <c7c9f237a91821661bfc0735e390358124953695.1359469932.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 08:09:08 PM Viresh Kumar wrote:
> Currently cpufreq_add_dev() firsts allocates policy, calls driver->init() and
> then checks if this cpu is already managed or not. And if it is already managed,
> free its policy.
> 
> We can save all this if we somehow know cpu is managed or not in advance.
> policy->related_cpus contains list of all valid sibling cpus of policy->cpu. We
> can check this to know if current cpu is already managed.
> 
> From now on, platforms don't really need to set related_cpus from their init()
> routines, as the same work is done by core too.
> 
> If platform driver needs to set the related_cpus mask with some additional cpus,
> other than cpus present in policy->cpus, they are free to do it as we aren't
> overriding anything.
>     
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> Tested-by: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Please don't add my sign-offs in advance.  Yes, I have signed off a *previous*
version of that patch, but that doesn't apply to *this* version automatically.

While you can do such things with Acked-by or Reviewed-by tags (that's not very
polite, but people usually don't mind), sign-off is a bit different, because
it is a *certificate* that this particular patch (and not some previous version
of it) has gone through my hands.

I'm going to apply this, but please be more careful in the future.

Thanks,
Rafael


> ---
> V2->V3:
> - Set all cpus present in policy->cpus in related_cpus as well.
> - Remove code to set related_cpus from SPEAr cpufreq driver.
> 
>  drivers/cpufreq/cpufreq.c       | 158 +++++++++++++++-------------------------
>  drivers/cpufreq/spear-cpufreq.c |   1 -
>  2 files changed, 58 insertions(+), 101 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index f1bb8f8..db81382 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -554,8 +554,6 @@ static ssize_t show_cpus(const struct cpumask *mask, char *buf)
>   */
>  static ssize_t show_related_cpus(struct cpufreq_policy *policy, char *buf)
>  {
> -	if (cpumask_empty(policy->related_cpus))
> -		return show_cpus(policy->cpus, buf);
>  	return show_cpus(policy->related_cpus, buf);
>  }
>  
> @@ -711,92 +709,6 @@ static struct kobj_type ktype_cpufreq = {
>  	.release	= cpufreq_sysfs_release,
>  };
>  
> -/*
> - * Returns:
> - *   Negative: Failure
> - *   0:        Success
> - *   Positive: When we have a managed CPU and the sysfs got symlinked
> - */
> -static int cpufreq_add_dev_policy(unsigned int cpu,
> -				  struct cpufreq_policy *policy,
> -				  struct device *dev)
> -{
> -	int ret = 0;
> -#ifdef CONFIG_SMP
> -	unsigned long flags;
> -	unsigned int j;
> -#ifdef CONFIG_HOTPLUG_CPU
> -	struct cpufreq_governor *gov;
> -
> -	gov = __find_governor(per_cpu(cpufreq_cpu_governor, cpu));
> -	if (gov) {
> -		policy->governor = gov;
> -		pr_debug("Restoring governor %s for cpu %d\n",
> -		       policy->governor->name, cpu);
> -	}
> -#endif
> -
> -	for_each_cpu(j, policy->cpus) {
> -		struct cpufreq_policy *managed_policy;
> -
> -		if (cpu == j)
> -			continue;
> -
> -		/* Check for existing affected CPUs.
> -		 * They may not be aware of it due to CPU Hotplug.
> -		 * cpufreq_cpu_put is called when the device is removed
> -		 * in __cpufreq_remove_dev()
> -		 */
> -		managed_policy = cpufreq_cpu_get(j);
> -		if (unlikely(managed_policy)) {
> -
> -			/* Set proper policy_cpu */
> -			unlock_policy_rwsem_write(cpu);
> -			per_cpu(cpufreq_policy_cpu, cpu) = managed_policy->cpu;
> -
> -			if (lock_policy_rwsem_write(cpu) < 0) {
> -				/* Should not go through policy unlock path */
> -				if (cpufreq_driver->exit)
> -					cpufreq_driver->exit(policy);
> -				cpufreq_cpu_put(managed_policy);
> -				return -EBUSY;
> -			}
> -
> -			__cpufreq_governor(managed_policy, CPUFREQ_GOV_STOP);
> -
> -			spin_lock_irqsave(&cpufreq_driver_lock, flags);
> -			cpumask_copy(managed_policy->cpus, policy->cpus);
> -			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
> -			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -
> -			__cpufreq_governor(managed_policy, CPUFREQ_GOV_START);
> -			__cpufreq_governor(managed_policy, CPUFREQ_GOV_LIMITS);
> -
> -			pr_debug("CPU already managed, adding link\n");
> -			ret = sysfs_create_link(&dev->kobj,
> -						&managed_policy->kobj,
> -						"cpufreq");
> -			if (ret)
> -				cpufreq_cpu_put(managed_policy);
> -			/*
> -			 * Success. We only needed to be added to the mask.
> -			 * Call driver->exit() because only the cpu parent of
> -			 * the kobj needed to call init().
> -			 */
> -			if (cpufreq_driver->exit)
> -				cpufreq_driver->exit(policy);
> -
> -			if (!ret)
> -				return 1;
> -			else
> -				return ret;
> -		}
> -	}
> -#endif
> -	return ret;
> -}
> -
> -
>  /* symlink affected CPUs */
>  static int cpufreq_add_dev_symlink(unsigned int cpu,
>  				   struct cpufreq_policy *policy)
> @@ -901,6 +813,42 @@ err_out_kobj_put:
>  	return ret;
>  }
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
> +				  struct device *dev)
> +{
> +	struct cpufreq_policy *policy;
> +	int ret = 0;
> +	unsigned long flags;
> +
> +	policy = cpufreq_cpu_get(sibling);
> +	WARN_ON(!policy);
> +
> +	per_cpu(cpufreq_policy_cpu, cpu) = policy->cpu;
> +
> +	lock_policy_rwsem_write(cpu);
> +
> +	__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> +
> +	spin_lock_irqsave(&cpufreq_driver_lock, flags);
> +	cpumask_set_cpu(cpu, policy->cpus);
> +	per_cpu(cpufreq_cpu_data, cpu) = policy;
> +	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
> +	__cpufreq_governor(policy, CPUFREQ_GOV_START);
> +	__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +
> +	unlock_policy_rwsem_write(cpu);
> +
> +	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> +	if (ret) {
> +		cpufreq_cpu_put(policy);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +#endif
>  
>  /**
>   * cpufreq_add_dev - add a CPU device
> @@ -913,12 +861,12 @@ err_out_kobj_put:
>   */
>  static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  {
> -	unsigned int cpu = dev->id;
> -	int ret = 0, found = 0;
> +	unsigned int j, cpu = dev->id;
> +	int ret = -ENOMEM, found = 0;
>  	struct cpufreq_policy *policy;
>  	unsigned long flags;
> -	unsigned int j;
>  #ifdef CONFIG_HOTPLUG_CPU
> +	struct cpufreq_governor *gov;
>  	int sibling;
>  #endif
>  
> @@ -935,6 +883,15 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  		cpufreq_cpu_put(policy);
>  		return 0;
>  	}
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +	/* Check if this cpu was hot-unplugged earlier and has siblings */
> +	for_each_online_cpu(sibling) {
> +		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
> +		if (cp && cpumask_test_cpu(cpu, cp->related_cpus))
> +			return cpufreq_add_policy_cpu(cpu, sibling, dev);
> +	}
> +#endif
>  #endif
>  
>  	if (!try_module_get(cpufreq_driver->owner)) {
> @@ -942,7 +899,6 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  		goto module_out;
>  	}
>  
> -	ret = -ENOMEM;
>  	policy = kzalloc(sizeof(struct cpufreq_policy), GFP_KERNEL);
>  	if (!policy)
>  		goto nomem_out;
> @@ -987,6 +943,9 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  		goto err_unlock_policy;
>  	}
>  
> +	/* related cpus should atleast have policy->cpus */
> +	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
> +
>  	/*
>  	 * affected cpus must always be the one, which are online. We aren't
>  	 * managing offline cpus here.
> @@ -1000,14 +959,14 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>  				     CPUFREQ_START, policy);
>  
> -	ret = cpufreq_add_dev_policy(cpu, policy, dev);
> -	if (ret) {
> -		if (ret > 0)
> -			/* This is a managed cpu, symlink created,
> -			   exit with 0 */
> -			ret = 0;
> -		goto err_unlock_policy;
> +#ifdef CONFIG_HOTPLUG_CPU
> +	gov = __find_governor(per_cpu(cpufreq_cpu_governor, cpu));
> +	if (gov) {
> +		policy->governor = gov;
> +		pr_debug("Restoring governor %s for cpu %d\n",
> +		       policy->governor->name, cpu);
>  	}
> +#endif
>  
>  	ret = cpufreq_add_dev_interface(cpu, policy, dev);
>  	if (ret)
> @@ -1021,7 +980,6 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  
>  	return 0;
>  
> -
>  err_out_unregister:
>  	spin_lock_irqsave(&cpufreq_driver_lock, flags);
>  	for_each_cpu(j, policy->cpus)
> diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
> index 8ff26af..fc714a6 100644
> --- a/drivers/cpufreq/spear-cpufreq.c
> +++ b/drivers/cpufreq/spear-cpufreq.c
> @@ -189,7 +189,6 @@ static int spear_cpufreq_init(struct cpufreq_policy *policy)
>  	policy->cur = spear_cpufreq_get(0);
>  
>  	cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
> -	cpumask_copy(policy->related_cpus, policy->cpus);
>  
>  	return 0;
>  }
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
