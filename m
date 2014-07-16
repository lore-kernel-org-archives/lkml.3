Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081AbaGPObx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:31:53 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:43634 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298AbaGPObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:31:51 -0400
Message-ID: <53C68C54.3010900@gmail.com>
Date: Wed, 16 Jul 2014 07:29:40 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>
CC: dirk.brandewie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org> <1405464473-3916-2-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1405464473-3916-2-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 03:47 PM, Saravana Kannan wrote:
> The CPUfreq core moves the cpufreq policy ownership between CPUs when CPUs
> within a cluster (CPUs sharing same policy) go ONLINE/OFFLINE. When moving
> policy ownership between CPUs, it also moves the cpufreq sysfs directory
> between CPUs and also fixes up the symlinks of the other CPUs in the
> cluster.
>
> Also, when all the CPUs in a cluster go OFFLINE, all the sysfs nodes and
> directories are deleted, the kobject is released and the policy is freed.
> And when the first CPU in a cluster comes up, the policy is reallocated and
> initialized, kobject is acquired, the sysfs nodes are created or symlinked,
> etc.
>
> All these steps end up creating unnecessarily complicated code and locking.
> There's no real benefit to adding/removing/moving the sysfs nodes and the
> policy between CPUs. Other per CPU sysfs directories like power and cpuidle
> are left alone during hotplug. So there's some precedence to what this
> patch is trying to do.
>
> This patch simplifies a lot of the code and locking by removing the
> adding/removing/moving of policy/sysfs/kobj and just leaves the cpufreq
> directory and policy in place irrespective of whether the CPUs are
> ONLINE/OFFLINE.
>
> Leaving the policy, sysfs and kobject in place also brings these additional
> benefits:
> * Faster suspend/resume
> * Faster hotplug
> * Sysfs file permissions maintained across hotplug
> * Policy settings and governor tunables maintained across hotplug
> * Cpufreq stats would be maintained across hotplug for all CPUs and can be
>    queried even after CPU goes OFFLINE
>
> Tested-by: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>   drivers/cpufreq/cpufreq.c | 388 +++++++++++++---------------------------------
>   1 file changed, 107 insertions(+), 281 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 62259d2..a0a2ec2 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -37,7 +37,6 @@
>    */
>   static struct cpufreq_driver *cpufreq_driver;
>   static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
> -static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data_fallback);
>   static DEFINE_RWLOCK(cpufreq_driver_lock);
>   DEFINE_MUTEX(cpufreq_governor_lock);
>   static LIST_HEAD(cpufreq_policy_list);
> @@ -859,34 +858,41 @@ void cpufreq_sysfs_remove_file(const struct attribute *attr)
>   }
>   EXPORT_SYMBOL(cpufreq_sysfs_remove_file);
>
> -/* symlink affected CPUs */
> -static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
> +/* symlink related CPUs */
> +static int cpufreq_dev_symlink(struct cpufreq_policy *policy, bool add)
>   {
> -	unsigned int j;
> +	unsigned int j, first_cpu = cpumask_first(policy->related_cpus);
>   	int ret = 0;
>
> -	for_each_cpu(j, policy->cpus) {
> +	for_each_cpu(j, policy->related_cpus) {
>   		struct device *cpu_dev;
>
> -		if (j == policy->cpu)
> +		if (j == first_cpu)
>   			continue;
>
> -		pr_debug("Adding link for CPU: %u\n", j);
>   		cpu_dev = get_cpu_device(j);
> -		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
> -					"cpufreq");
> +		if (add)
> +			ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
> +						"cpufreq");
> +		else
> +			sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
> +
>   		if (ret)
>   			break;
>   	}
>   	return ret;
>   }
>
> -static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
> -				     struct device *dev)
> +static int cpufreq_add_dev_interface(struct cpufreq_policy *policy)
>   {
>   	struct freq_attr **drv_attr;
> +	struct device *dev;
>   	int ret = 0;
>
> +	dev = get_cpu_device(cpumask_first(policy->related_cpus));
> +	if (!dev)
> +		return -EINVAL;
> +
>   	/* prepare interface data */
>   	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
>   				   &dev->kobj, "cpufreq");
> @@ -917,7 +923,7 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
>   			goto err_out_kobj_put;
>   	}
>
> -	ret = cpufreq_add_dev_symlink(policy);
> +	ret = cpufreq_dev_symlink(policy, true);
>   	if (ret)
>   		goto err_out_kobj_put;
>
> @@ -961,60 +967,58 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
>   }
>
>   #ifdef CONFIG_HOTPLUG_CPU
> -static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
> -				  unsigned int cpu, struct device *dev)
> +static int cpufreq_change_policy_cpus(struct cpufreq_policy *policy,
> +				  unsigned int cpu, bool add)
>   {
>   	int ret = 0;
> -	unsigned long flags;
> +	unsigned int cpus, pcpu;
>
> -	if (has_target()) {
> +	down_write(&policy->rwsem);
> +
> +	cpus = !cpumask_empty(policy->cpus);
> +	if (has_target() && cpus) {
>   		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>   		if (ret) {
>   			pr_err("%s: Failed to stop governor\n", __func__);
> -			return ret;
> +			goto unlock;
>   		}
>   	}
>
> -	down_write(&policy->rwsem);
> -
> -	write_lock_irqsave(&cpufreq_driver_lock, flags);
> -
> -	cpumask_set_cpu(cpu, policy->cpus);
> -	per_cpu(cpufreq_cpu_data, cpu) = policy;
> -	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +	if (add)
> +		cpumask_set_cpu(cpu, policy->cpus);
> +	else
> +		cpumask_clear_cpu(cpu, policy->cpus);
>
> -	up_write(&policy->rwsem);
> +	pcpu = cpumask_first(policy->cpus);
> +	if (pcpu < nr_cpu_ids && policy->cpu != pcpu) {
> +		policy->last_cpu = policy->cpu;
> +		policy->cpu = pcpu;
> +		blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> +					CPUFREQ_UPDATE_POLICY_CPU, policy);
> +	}
>
> -	if (has_target()) {
> +	cpus = !cpumask_empty(policy->cpus);
> +	if (has_target() && cpus) {
>   		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
>   		if (!ret)
>   			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>
>   		if (ret) {
>   			pr_err("%s: Failed to start governor\n", __func__);
> -			return ret;
> +			goto unlock;
>   		}
>   	}
>
> -	return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> -}
> -#endif
> -
> -static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
> -{
> -	struct cpufreq_policy *policy;
> -	unsigned long flags;
> -
> -	read_lock_irqsave(&cpufreq_driver_lock, flags);
> -
> -	policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
> -
> -	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +	if (!cpus && cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
> +		cpufreq_driver->stop_cpu(policy);
> +	}

stop_cpu() only needs to be called during __cpufreq_remove_dev_prepare() no
where else.

>
> -	policy->governor = NULL;
> +unlock:
> +	up_write(&policy->rwsem);
>
> -	return policy;
> +	return ret;
>   }
> +#endif
>
>   static struct cpufreq_policy *cpufreq_policy_alloc(void)
>   {
> @@ -1053,10 +1057,8 @@ static void cpufreq_policy_put_kobj(struct cpufreq_policy *policy)
>   	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>   			CPUFREQ_REMOVE_POLICY, policy);
>
> -	down_read(&policy->rwsem);
>   	kobj = &policy->kobj;
>   	cmp = &policy->kobj_unregister;
> -	up_read(&policy->rwsem);
>   	kobject_put(kobj);
>
>   	/*
> @@ -1076,32 +1078,12 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
>   	kfree(policy);
>   }
>
> -static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
> -{
> -	if (WARN_ON(cpu == policy->cpu))
> -		return;
> -
> -	down_write(&policy->rwsem);
> -
> -	policy->last_cpu = policy->cpu;
> -	policy->cpu = cpu;
> -
> -	up_write(&policy->rwsem);
> -
> -	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> -			CPUFREQ_UPDATE_POLICY_CPU, policy);
> -}
> -
>   static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>   {
>   	unsigned int j, cpu = dev->id;
>   	int ret = -ENOMEM;
>   	struct cpufreq_policy *policy;
>   	unsigned long flags;
> -	bool recover_policy = cpufreq_suspended;
> -#ifdef CONFIG_HOTPLUG_CPU
> -	struct cpufreq_policy *tpolicy;
> -#endif
>
>   	if (cpu_is_offline(cpu))
>   		return 0;
> @@ -1110,9 +1092,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>
>   #ifdef CONFIG_SMP
>   	/* check whether a different CPU already registered this
> -	 * CPU because it is in the same boat. */
> +	 * CPU because it is one of the related CPUs. */
>   	policy = cpufreq_cpu_get(cpu);
> -	if (unlikely(policy)) {
> +	if (policy) {
> +		cpufreq_change_policy_cpus(policy, cpu, true);
>   		cpufreq_cpu_put(policy);
>   		return 0;
>   	}
> @@ -1121,45 +1104,14 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>   	if (!down_read_trylock(&cpufreq_rwsem))
>   		return 0;
>
> -#ifdef CONFIG_HOTPLUG_CPU
> -	/* Check if this cpu was hot-unplugged earlier and has siblings */
> -	read_lock_irqsave(&cpufreq_driver_lock, flags);
> -	list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
> -		if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
> -			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -			ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev);
> -			up_read(&cpufreq_rwsem);
> -			return ret;
> -		}
> -	}
> -	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -#endif
> -
> -	/*
> -	 * Restore the saved policy when doing light-weight init and fall back
> -	 * to the full init if that fails.
> -	 */
> -	policy = recover_policy ? cpufreq_policy_restore(cpu) : NULL;
> -	if (!policy) {
> -		recover_policy = false;
> -		policy = cpufreq_policy_alloc();
> -		if (!policy)
> -			goto nomem_out;
> -	}
> -
> -	/*
> -	 * In the resume path, since we restore a saved policy, the assignment
> -	 * to policy->cpu is like an update of the existing policy, rather than
> -	 * the creation of a brand new one. So we need to perform this update
> -	 * by invoking update_policy_cpu().
> -	 */
> -	if (recover_policy && cpu != policy->cpu)
> -		update_policy_cpu(policy, cpu);
> -	else
> -		policy->cpu = cpu;
> +	/* If we get this far, this is the first time we are adding the
> +	 * policy */
> +	policy = cpufreq_policy_alloc();
> +	if (!policy)
> +		goto nomem_out;
> +	policy->cpu = cpu;
>
>   	cpumask_copy(policy->cpus, cpumask_of(cpu));
> -
>   	init_completion(&policy->kobj_unregister);
>   	INIT_WORK(&policy->update, handle_update);
>
> @@ -1169,26 +1121,25 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>   	ret = cpufreq_driver->init(policy);
>   	if (ret) {
>   		pr_debug("initialization failed\n");
> -		goto err_set_policy_cpu;
> +		goto err_init;
>   	}
>
>   	/* related cpus should atleast have policy->cpus */
>   	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
>
> +	/* Weed out impossible CPUs. */
> +	cpumask_and(policy->related_cpus, policy->related_cpus,
> +			cpu_possible_mask);
> +
>   	/*
>   	 * affected cpus must always be the one, which are online. We aren't
>   	 * managing offline cpus here.
>   	 */
>   	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
>
> -	if (!recover_policy) {
> -		policy->user_policy.min = policy->min;
> -		policy->user_policy.max = policy->max;
> -	}
> -
>   	down_write(&policy->rwsem);
>   	write_lock_irqsave(&cpufreq_driver_lock, flags);
> -	for_each_cpu(j, policy->cpus)
> +	for_each_cpu(j, policy->related_cpus)
>   		per_cpu(cpufreq_cpu_data, j) = policy;
>   	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> @@ -1243,13 +1194,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>   	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>   				     CPUFREQ_START, policy);
>
> -	if (!recover_policy) {
> -		ret = cpufreq_add_dev_interface(policy, dev);
> -		if (ret)
> -			goto err_out_unregister;
> -		blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> -				CPUFREQ_CREATE_POLICY, policy);
> -	}
> +	ret = cpufreq_add_dev_interface(policy);
> +	if (ret)
> +		goto err_out_unregister;
> +	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> +			CPUFREQ_CREATE_POLICY, policy);
>
>   	write_lock_irqsave(&cpufreq_driver_lock, flags);
>   	list_add(&policy->policy_list, &cpufreq_policy_list);
> @@ -1257,10 +1206,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>
>   	cpufreq_init_policy(policy);
>
> -	if (!recover_policy) {
> -		policy->user_policy.policy = policy->policy;
> -		policy->user_policy.governor = policy->governor;
> -	}
>   	up_write(&policy->rwsem);
>
>   	kobject_uevent(&policy->kobj, KOBJ_ADD);
> @@ -1273,20 +1218,14 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>   err_out_unregister:
>   err_get_freq:
>   	write_lock_irqsave(&cpufreq_driver_lock, flags);
> -	for_each_cpu(j, policy->cpus)
> +	for_each_cpu(j, policy->related_cpus)
>   		per_cpu(cpufreq_cpu_data, j) = NULL;
>   	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -
> +	up_write(&policy->rwsem);
>   	if (cpufreq_driver->exit)
>   		cpufreq_driver->exit(policy);
> -err_set_policy_cpu:
> -	if (recover_policy) {
> -		/* Do not leave stale fallback data behind. */
> -		per_cpu(cpufreq_cpu_data_fallback, cpu) = NULL;
> -		cpufreq_policy_put_kobj(policy);
> -	}
> +err_init:
>   	cpufreq_policy_free(policy);
> -
>   nomem_out:
>   	up_read(&cpufreq_rwsem);
>
> @@ -1307,100 +1246,16 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>   	return __cpufreq_add_dev(dev, sif);
>   }
>
> -static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
> -					   unsigned int old_cpu)
> -{
> -	struct device *cpu_dev;
> -	int ret;
> -
> -	/* first sibling now owns the new sysfs dir */
> -	cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));
> -
> -	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
> -	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
> -	if (ret) {
> -		pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
> -
> -		down_write(&policy->rwsem);
> -		cpumask_set_cpu(old_cpu, policy->cpus);
> -		up_write(&policy->rwsem);
> -
> -		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
> -					"cpufreq");
> -
> -		return -EINVAL;
> -	}
> -
> -	return cpu_dev->id;
> -}
> -
> -static int __cpufreq_remove_dev_prepare(struct device *dev,
> -					struct subsys_interface *sif)
> +static int __cpufreq_remove_dev(struct device *dev,
> +				struct subsys_interface *sif)
>   {
> -	unsigned int cpu = dev->id, cpus;
> -	int new_cpu, ret;
> +	unsigned int cpu = dev->id, j;
> +	int ret = 0;
>   	unsigned long flags;
>   	struct cpufreq_policy *policy;
>
>   	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
>
> -	write_lock_irqsave(&cpufreq_driver_lock, flags);
> -
> -	policy = per_cpu(cpufreq_cpu_data, cpu);
> -
> -	/* Save the policy somewhere when doing a light-weight tear-down */
> -	if (cpufreq_suspended)
> -		per_cpu(cpufreq_cpu_data_fallback, cpu) = policy;
> -
> -	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -
> -	if (!policy) {
> -		pr_debug("%s: No cpu_data found\n", __func__);
> -		return -EINVAL;
> -	}
> -
> -	if (has_target()) {
> -		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> -		if (ret) {
> -			pr_err("%s: Failed to stop governor\n", __func__);
> -			return ret;
> -		}
> -	}
> -
> -	if (!cpufreq_driver->setpolicy)
> -		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
> -			policy->governor->name, CPUFREQ_NAME_LEN);
> -
> -	down_read(&policy->rwsem);
> -	cpus = cpumask_weight(policy->cpus);
> -	up_read(&policy->rwsem);
> -
> -	if (cpu != policy->cpu) {
> -		sysfs_remove_link(&dev->kobj, "cpufreq");
> -	} else if (cpus > 1) {
> -		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
> -		if (new_cpu >= 0) {
> -			update_policy_cpu(policy, new_cpu);
> -
> -			if (!cpufreq_suspended)
> -				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
> -					 __func__, new_cpu, cpu);
> -		}
> -	} else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
> -		cpufreq_driver->stop_cpu(policy);
> -	}
> -
> -	return 0;
> -}
> -
> -static int __cpufreq_remove_dev_finish(struct device *dev,
> -				       struct subsys_interface *sif)
> -{
> -	unsigned int cpu = dev->id, cpus;
> -	int ret;
> -	unsigned long flags;
> -	struct cpufreq_policy *policy;
> -
>   	read_lock_irqsave(&cpufreq_driver_lock, flags);
>   	policy = per_cpu(cpufreq_cpu_data, cpu);
>   	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> @@ -1410,56 +1265,45 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>   		return -EINVAL;
>   	}
>
> -	down_write(&policy->rwsem);
> -	cpus = cpumask_weight(policy->cpus);
> -
> -	if (cpus > 1)
> -		cpumask_clear_cpu(cpu, policy->cpus);
> -	up_write(&policy->rwsem);
> -
> -	/* If cpu is last user of policy, free policy */
> -	if (cpus == 1) {
> -		if (has_target()) {
> -			ret = __cpufreq_governor(policy,
> -					CPUFREQ_GOV_POLICY_EXIT);
> -			if (ret) {
> -				pr_err("%s: Failed to exit governor\n",
> -				       __func__);
> -				return ret;
> -			}
> -		}
> -
> -		if (!cpufreq_suspended)
> -			cpufreq_policy_put_kobj(policy);
> +#ifdef CONFIG_HOTPLUG_CPU
> +	ret = cpufreq_change_policy_cpus(policy, cpu, false);
> +#endif
> +	if (ret)
> +		return ret;
>
> -		/*
> -		 * Perform the ->exit() even during light-weight tear-down,
> -		 * since this is a core component, and is essential for the
> -		 * subsequent light-weight ->init() to succeed.
> -		 */
> -		if (cpufreq_driver->exit)
> -			cpufreq_driver->exit(policy);
> +	if (!sif)
> +		return 0;
>
> -		/* Remove policy from list of active policies */
> -		write_lock_irqsave(&cpufreq_driver_lock, flags);
> -		list_del(&policy->policy_list);
> -		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +	if (!cpumask_empty(policy->cpus)) {
> +		return 0;
> +	}
>
> -		if (!cpufreq_suspended)
> -			cpufreq_policy_free(policy);
> -	} else if (has_target()) {
> -		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
> -		if (!ret)
> -			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +	cpufreq_dev_symlink(policy, false);
>
> +	if (has_target()) {
> +		ret = __cpufreq_governor(policy,
> +				CPUFREQ_GOV_POLICY_EXIT);
>   		if (ret) {
> -			pr_err("%s: Failed to start governor\n", __func__);
> +			pr_err("%s: Failed to exit governor\n",
> +			       __func__);
>   			return ret;
>   		}
>   	}
>
> -	per_cpu(cpufreq_cpu_data, cpu) = NULL;
> -	return 0;
> +	cpufreq_policy_put_kobj(policy);
> +	if (cpufreq_driver->exit)
> +		cpufreq_driver->exit(policy);
> +
> +	/* Remove policy from list of active policies */
> +	write_lock_irqsave(&cpufreq_driver_lock, flags);
> +	for_each_cpu(j, policy->related_cpus)
> +		per_cpu(cpufreq_cpu_data, j) = NULL;
> +	list_del(&policy->policy_list);
> +	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
> +	cpufreq_policy_free(policy);
> +
> +	return ret;
>   }
>
>   /**
> @@ -1469,18 +1313,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>    */
>   static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
>   {
> -	unsigned int cpu = dev->id;
> -	int ret;
> -
> -	if (cpu_is_offline(cpu))
> -		return 0;
> -
> -	ret = __cpufreq_remove_dev_prepare(dev, sif);
> -
> -	if (!ret)
> -		ret = __cpufreq_remove_dev_finish(dev, sif);
> -
> -	return ret;
> +	return __cpufreq_remove_dev(dev, sif);
>   }
>
>   static void handle_update(struct work_struct *work)
> @@ -2295,19 +2128,12 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
>   	if (dev) {
>   		switch (action & ~CPU_TASKS_FROZEN) {
>   		case CPU_ONLINE:
> +		case CPU_DOWN_FAILED:
>   			__cpufreq_add_dev(dev, NULL);
>   			break;
>
>   		case CPU_DOWN_PREPARE:
> -			__cpufreq_remove_dev_prepare(dev, NULL);
> -			break;
> -
> -		case CPU_POST_DEAD:
> -			__cpufreq_remove_dev_finish(dev, NULL);
> -			break;
> -
> -		case CPU_DOWN_FAILED:
> -			__cpufreq_add_dev(dev, NULL);
> +			__cpufreq_remove_dev(dev, NULL);
>   			break;
>   		}
>   	}
>

