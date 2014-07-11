Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaGKHpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:45:50 -0400
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:49988 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240AbaGKHpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:45:46 -0400
X-AuditID: 12074424-f79146d00000067c-62-53bf96283f44
Message-ID: <53BF95AB.6030800@mit.edu>
Date: Fri, 11 Jul 2014 13:13:39 +0530
From: "Srivatsa S. Bhat" <srivatsa@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org> <1405052287-4744-1-git-send-email-skannan@codeaurora.org>
In-Reply-To: <1405052287-4744-1-git-send-email-skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsUixCmqras5bX+wwdc+FotNj6+xWkzcf5bd
	4vKuOWwWn3uPMFqcOX2J1eLHmW4WiwMXJ7JZnF3ezGax8auHA6fH5b5eJo8Fm0o97lzbw+ax
	eUm9x5ar7SwenzfJBbBFcdmkpOZklqUW6dslcGUc+/CYqeDELMaKeUt/sTQwbq/uYuTkkBAw
	kZhwax8jhC0mceHeerYuRi4OIYHZTBIHD/5nh3A2Mkocn74ZKvOTSeLmradsIC28AmoSrT8+
	snQxcnCwCKhKfDpbCWKyCWhLLNsoCVIhKhAn0Xj8OyNEtaDEyZlPWEDGiAjsY5SYfuIZ2AJm
	gW2MEn/6l4HNFBYIk5i5YR0TxLIGRoneKTuZQRKcAm4STxdcAbOZBXQk3vU9gLLlJba/ncM8
	gVFwFpIts5CUzUJStoCReRWjbEpulW5uYmZOcWqybnFyYl5eapGuuV5uZoleakrpJkZQtLC7
	qOxgbD6kdIhRgINRiYf3xJp9wUKsiWXFlbmHGCU5mJREeaX69gcL8SXlp1RmJBZnxBeV5qQW
	H2KU4GBWEuF9Ug+U401JrKxKLcqHSUlzsCiJ8761tgoWEkhPLEnNTk0tSC2CycpwcChJ8G6d
	CtQoWJSanlqRlplTgpBm4uAEGc4DNNwBpIa3uCAxtzgzHSJ/ilGXY8usU21MQix5+XmpUuK8
	gSBFAiBFGaV5cHNgSe4VozjQW8K8tSBVPMAECTfpFdASJqAl2/vBlpQkIqSkGhjnie4UW++1
	846ekeLfs+1diS/P6vxZOb2fs/ig0vV5EzeXCl/rnKrld/vVtpAdJ4TMpvzXDY4XSn9d8GLv
	5qI48b22erMuL1qqrCA/T6x7g8Tb+CfJZW9u7yhm3HY4MuXt2+fz3YynGN5K3rxiQdGRTbMW
	brbbdKDIZVbZDs8/7/7Xfp/i6e9frMRSnJFoqMVcVJwIAECsgoBNAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 09:48 AM, Saravana Kannan wrote:
> The CPUfreq driver moves the cpufreq policy ownership between CPUs when
> CPUs within a cluster (CPUs sharing same policy) go ONLINE/OFFLINE. When
> moving policy ownership between CPUs, it also moves the cpufreq sysfs
> directory between CPUs and also fixes up the symlinks of the other CPUs in
> the cluster.
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
> * Faster suspend/resume.
> * Faster hotplug.
> * Sysfs file permissions maintained across hotplug without userspace
>   workarounds.
> * Policy settings and governor tunables maintained across suspend/resume
>   and hotplug.
> * Cpufreq stats would be maintained across hotplug for all CPUs and can be
>   queried even after CPU goes OFFLINE.
> 
> Change-Id: I39c395e1fee8731880c0fd7c8a9c1d83e2e4b8d0
> Tested-by: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
> 
> Preliminary testing has been done. cpufreq directories are getting created
> properly. Online/offline of CPUs work. Policies remain unmodifiable from
> userspace when all policy CPUs are offline.
> 
> Error handling code has NOT been updated.
> 
> I've added a bunch of FIXME comments next to where I'm not sure about the
> locking in the existing code. I believe most of the try_lock's were present
> to prevent a deadlock between sysfs lock and the cpufreq locks. Now that
> the sysfs entries are not touched after creating them, we should be able to
> replace most/all of these try_lock's with a normal lock.
> 
> This patch has more room for code simplification, but I would like to get
> some acks for the functionality and this code before I do further
> simplification.
> 

The idea behind this work is very welcome indeed! IMHO, there is nothing
conceptually wrong in maintaining the per-cpu sysfs files across CPU hotplug
(as long as we take care to return appropriate error codes if userspace
tries to set values using the control files of offline CPUs). So, it really
boils down to whether or not we get the implementation right; the idea itself
looks fine as of now. Hence, your efforts in making this patch(set) easier to
review will certainly help. Perhaps you can simplify the code later, but at
this point, splitting up this patch into multiple smaller, reviewable pieces
(accompanied by well-written changelogs that explain the intent) is the utmost
priority. Just like Viresh, even I had a hard time reviewing all of this in
one go.

Thank you for taking up this work!

Regards,
Srivatsa S. Bhat

> I should also be able to remove get_online_cpus() in the store function and
> replace it with just a check for policy->governor_enabled. That should
> theoretically reduce some contention between cpufreq stats check and
> hotplug of unrelated CPUs.
> 
> Appreciate all the feedback.
> 
> Thanks,
> Saravana
> 
>  drivers/cpufreq/cpufreq.c | 331 ++++++++++------------------------------------
>  1 file changed, 69 insertions(+), 262 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 62259d2..e350b15 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -859,16 +859,16 @@ void cpufreq_sysfs_remove_file(const struct attribute *attr)
>  }
>  EXPORT_SYMBOL(cpufreq_sysfs_remove_file);
> 
> -/* symlink affected CPUs */
> +/* symlink related CPUs */
>  static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>  {
> -	unsigned int j;
> +	unsigned int j, first_cpu = cpumask_first(policy->related_cpus);
>  	int ret = 0;
> 
> -	for_each_cpu(j, policy->cpus) {
> +	for_each_cpu(j, policy->related_cpus) {
>  		struct device *cpu_dev;
> 
> -		if (j == policy->cpu)
> +		if (j == first_cpu)
>  			continue;
> 
>  		pr_debug("Adding link for CPU: %u\n", j);
> @@ -881,12 +881,16 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>  	return ret;
>  }
> 
> -static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
> -				     struct device *dev)
> +static int cpufreq_add_dev_interface(struct cpufreq_policy *policy)
>  {
>  	struct freq_attr **drv_attr;
> +	struct device *dev;
>  	int ret = 0;
> 
> +	dev = get_cpu_device(cpumask_first(policy->related_cpus));
> +	if (!dev)
> +		return -EINVAL;
> +
>  	/* prepare interface data */
>  	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
>  				   &dev->kobj, "cpufreq");
> @@ -961,60 +965,53 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
>  }
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> -static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
> -				  unsigned int cpu, struct device *dev)
> +static int cpufreq_change_policy_cpus(struct cpufreq_policy *policy,
> +				  unsigned int cpu, bool add)
>  {
>  	int ret = 0;
> -	unsigned long flags;
> +	unsigned int cpus;
> 
> -	if (has_target()) {
> +	down_write(&policy->rwsem);
> +	cpus = cpumask_weight(policy->cpus);
> +	if (has_target() && cpus > 0) {
>  		ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>  		if (ret) {
>  			pr_err("%s: Failed to stop governor\n", __func__);
> -			return ret;
> +			goto unlock;
>  		}
>  	}
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
> +	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> +					CPUFREQ_UPDATE_POLICY_CPU, policy);
> 
> -	if (has_target()) {
> +	cpus = cpumask_weight(policy->cpus);
> +	policy->cpu = cpumask_first(policy->cpus);
> +	if (has_target() && cpus > 0) {
>  		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
>  		if (!ret)
>  			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> 
>  		if (ret) {
>  			pr_err("%s: Failed to start governor\n", __func__);
> -			return ret;
> +			goto unlock;
>  		}
>  	}
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
> +	if (cpus < 1 && cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
> +		cpufreq_driver->stop_cpu(policy);
> +	}
> 
> -	policy->governor = NULL;
> +unlock:
> +	up_write(&policy->rwsem);
> 
> -	return policy;
> +	return ret;
>  }
> +#endif
> 
>  static struct cpufreq_policy *cpufreq_policy_alloc(void)
>  {
> @@ -1076,22 +1073,6 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
>  	kfree(policy);
>  }
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
>  static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  {
>  	unsigned int j, cpu = dev->id;
> @@ -1099,9 +1080,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  	struct cpufreq_policy *policy;
>  	unsigned long flags;
>  	bool recover_policy = cpufreq_suspended;
> -#ifdef CONFIG_HOTPLUG_CPU
> -	struct cpufreq_policy *tpolicy;
> -#endif
> 
>  	if (cpu_is_offline(cpu))
>  		return 0;
> @@ -1111,55 +1089,28 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  #ifdef CONFIG_SMP
>  	/* check whether a different CPU already registered this
>  	 * CPU because it is in the same boat. */
> +	/* FIXME: This probably needs fixing to avoid "try lock" from
> +	 * returning NULL. Also, change to likely() */
>  	policy = cpufreq_cpu_get(cpu);
>  	if (unlikely(policy)) {
> +		cpufreq_change_policy_cpus(policy, cpu, true);
>  		cpufreq_cpu_put(policy);
>  		return 0;
>  	}
>  #endif
> 
> +	/* FIXME: Is returning 0 the right thing to do?! Existing code */
>  	if (!down_read_trylock(&cpufreq_rwsem))
>  		return 0;
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
>  	cpumask_copy(policy->cpus, cpumask_of(cpu));
> -
>  	init_completion(&policy->kobj_unregister);
>  	INIT_WORK(&policy->update, handle_update);
> 
> @@ -1175,20 +1126,19 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  	/* related cpus should atleast have policy->cpus */
>  	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
> 
> +	/* Weed out impossible CPUs. */
> +	cpumask_and(policy->related_cpus, policy->related_cpus,
> +			cpu_possible_mask);
> +
>  	/*
>  	 * affected cpus must always be the one, which are online. We aren't
>  	 * managing offline cpus here.
>  	 */
>  	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
> 
> -	if (!recover_policy) {
> -		policy->user_policy.min = policy->min;
> -		policy->user_policy.max = policy->max;
> -	}
> -
>  	down_write(&policy->rwsem);
>  	write_lock_irqsave(&cpufreq_driver_lock, flags);
> -	for_each_cpu(j, policy->cpus)
> +	for_each_cpu(j, policy->related_cpus)
>  		per_cpu(cpufreq_cpu_data, j) = policy;
>  	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
> @@ -1243,13 +1193,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>  				     CPUFREQ_START, policy);
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
>  	write_lock_irqsave(&cpufreq_driver_lock, flags);
>  	list_add(&policy->policy_list, &cpufreq_policy_list);
> @@ -1257,10 +1205,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
> 
>  	cpufreq_init_policy(policy);
> 
> -	if (!recover_policy) {
> -		policy->user_policy.policy = policy->policy;
> -		policy->user_policy.governor = policy->governor;
> -	}
>  	up_write(&policy->rwsem);
> 
>  	kobject_uevent(&policy->kobj, KOBJ_ADD);
> @@ -1307,100 +1251,16 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>  	return __cpufreq_add_dev(dev, sif);
>  }
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
>  {
> -	unsigned int cpu = dev->id, cpus;
> -	int new_cpu, ret;
> +	unsigned int cpu = dev->id;
> +	int ret = 0;
>  	unsigned long flags;
>  	struct cpufreq_policy *policy;
> 
>  	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
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
>  	read_lock_irqsave(&cpufreq_driver_lock, flags);
>  	policy = per_cpu(cpufreq_cpu_data, cpu);
>  	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> @@ -1410,56 +1270,11 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>  		return -EINVAL;
>  	}
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
> -
> -		/*
> -		 * Perform the ->exit() even during light-weight tear-down,
> -		 * since this is a core component, and is essential for the
> -		 * subsequent light-weight ->init() to succeed.
> -		 */
> -		if (cpufreq_driver->exit)
> -			cpufreq_driver->exit(policy);
> -
> -		/* Remove policy from list of active policies */
> -		write_lock_irqsave(&cpufreq_driver_lock, flags);
> -		list_del(&policy->policy_list);
> -		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -
> -		if (!cpufreq_suspended)
> -			cpufreq_policy_free(policy);
> -	} else if (has_target()) {
> -		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
> -		if (!ret)
> -			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> -
> -		if (ret) {
> -			pr_err("%s: Failed to start governor\n", __func__);
> -			return ret;
> -		}
> -	}
> +#ifdef CONFIG_HOTPLUG_CPU
> +	ret = cpufreq_change_policy_cpus(policy, cpu, false);
> +#endif
> 
> -	per_cpu(cpufreq_cpu_data, cpu) = NULL;
> -	return 0;
> +	return ret;
>  }
> 
>  /**
> @@ -1475,10 +1290,7 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
>  	if (cpu_is_offline(cpu))
>  		return 0;
> 
> -	ret = __cpufreq_remove_dev_prepare(dev, sif);
> -
> -	if (!ret)
> -		ret = __cpufreq_remove_dev_finish(dev, sif);
> +	ret = __cpufreq_remove_dev(dev, sif);
> 
>  	return ret;
>  }
> @@ -2141,7 +1953,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
>  				struct cpufreq_policy *new_policy)
>  {
>  	struct cpufreq_governor *old_gov;
> -	int ret;
> +	int ret = 0;
> 
>  	pr_debug("setting new policy for CPU %u: %u - %u kHz\n",
>  		 new_policy->cpu, new_policy->min, new_policy->max);
> @@ -2226,7 +2038,9 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
> 
>   out:
>  	pr_debug("governor: change or update limits\n");
> -	return __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +	if (policy->governor_enabled)
> +		ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +	return ret;
>  }
> 
>  /**
> @@ -2295,19 +2109,12 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
>  	if (dev) {
>  		switch (action & ~CPU_TASKS_FROZEN) {
>  		case CPU_ONLINE:
> +		case CPU_DOWN_FAILED:
>  			__cpufreq_add_dev(dev, NULL);
>  			break;
> 
>  		case CPU_DOWN_PREPARE:
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
>  			break;
>  		}
>  	}
> 

