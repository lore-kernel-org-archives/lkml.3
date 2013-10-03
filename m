Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3JCH1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:27:37 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:33572 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3JCH1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:27:35 -0400
Message-ID: <524D1B66.6050808@linux.vnet.ibm.com>
Date: Thu, 03 Oct 2013 12:53:18 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 02/11] cpufreq: create per policy rwsem instead
 of per cpu cpu_policy_rwsem
References: <cover.1380703248.git.viresh.kumar@linaro.org> <fef9eba980ca340b3f1b1a56e92c84f6bb0f5d81.1380703248.git.viresh.kumar@linaro.org>
In-Reply-To: <fef9eba980ca340b3f1b1a56e92c84f6bb0f5d81.1380703248.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100307-8256-0000-0000-0000097BBA64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 02:13 PM, Viresh Kumar wrote:
> We have per-cpu cpu_policy_rwsem for cpufreq core, but we never use all of them.
> We always use rwsem of policy->cpu and so we can actually make this rwsem per
> policy instead.
> 
> This patch does this change. With this change other tricky situations are also
> avoided now, like which lock to take while we are changing policy->cpu, etc.
> 
> Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

This is a very nice improvement!

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  drivers/cpufreq/cpufreq.c | 110 +++++++++++++---------------------------------
>  include/linux/cpufreq.h   |  14 ++++++
>  2 files changed, 45 insertions(+), 79 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index eb993d9..ae866b1 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -48,47 +48,6 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
> 
>  /*
> - * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
> - * all cpufreq/hotplug/workqueue/etc related lock issues.
> - *
> - * The rules for this semaphore:
> - * - Any routine that wants to read from the policy structure will
> - *   do a down_read on this semaphore.
> - * - Any routine that will write to the policy structure and/or may take away
> - *   the policy altogether (eg. CPU hotplug), will hold this lock in write
> - *   mode before doing so.
> - *
> - * Additional rules:
> - * - Governor routines that can be called in cpufreq hotplug path should not
> - *   take this sem as top level hotplug notifier handler takes this.
> - * - Lock should not be held across
> - *     __cpufreq_governor(data, CPUFREQ_GOV_STOP);
> - */
> -static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
> -
> -#define lock_policy_rwsem(mode, cpu)					\
> -static void lock_policy_rwsem_##mode(int cpu)				\
> -{									\
> -	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
> -	BUG_ON(!policy);						\
> -	down_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
> -}
> -
> -lock_policy_rwsem(read, cpu);
> -lock_policy_rwsem(write, cpu);
> -
> -#define unlock_policy_rwsem(mode, cpu)					\
> -static void unlock_policy_rwsem_##mode(int cpu)				\
> -{									\
> -	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
> -	BUG_ON(!policy);						\
> -	up_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
> -}
> -
> -unlock_policy_rwsem(read, cpu);
> -unlock_policy_rwsem(write, cpu);
> -
> -/*
>   * rwsem to guarantee that cpufreq driver module doesn't unload during critical
>   * sections
>   */
> @@ -656,14 +615,14 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
>  	if (!down_read_trylock(&cpufreq_rwsem))
>  		return -EINVAL;
> 
> -	lock_policy_rwsem_read(policy->cpu);
> +	down_read(&policy->rwsem);
> 
>  	if (fattr->show)
>  		ret = fattr->show(policy, buf);
>  	else
>  		ret = -EIO;
> 
> -	unlock_policy_rwsem_read(policy->cpu);
> +	up_read(&policy->rwsem);
>  	up_read(&cpufreq_rwsem);
> 
>  	return ret;
> @@ -684,14 +643,14 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
>  	if (!down_read_trylock(&cpufreq_rwsem))
>  		goto unlock;
> 
> -	lock_policy_rwsem_write(policy->cpu);
> +	down_write(&policy->rwsem);
> 
>  	if (fattr->store)
>  		ret = fattr->store(policy, buf, count);
>  	else
>  		ret = -EIO;
> 
> -	unlock_policy_rwsem_write(policy->cpu);
> +	up_write(&policy->rwsem);
> 
>  	up_read(&cpufreq_rwsem);
>  unlock:
> @@ -868,7 +827,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>  		}
>  	}
> 
> -	lock_policy_rwsem_write(policy->cpu);
> +	down_write(&policy->rwsem);
> 
>  	write_lock_irqsave(&cpufreq_driver_lock, flags);
> 
> @@ -876,7 +835,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>  	per_cpu(cpufreq_cpu_data, cpu) = policy;
>  	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
> -	unlock_policy_rwsem_write(policy->cpu);
> +	up_write(&policy->rwsem);
> 
>  	if (has_target) {
>  		if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
> @@ -923,6 +882,8 @@ static struct cpufreq_policy *cpufreq_policy_alloc(void)
>  		goto err_free_cpumask;
> 
>  	INIT_LIST_HEAD(&policy->policy_list);
> +	init_rwsem(&policy->rwsem);
> +
>  	return policy;
> 
>  err_free_cpumask:
> @@ -945,19 +906,12 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>  	if (cpu == policy->cpu)
>  		return;
> 
> -	/*
> -	 * Take direct locks as lock_policy_rwsem_write wouldn't work here.
> -	 * Also lock for last cpu is enough here as contention will happen only
> -	 * after policy->cpu is changed and after it is changed, other threads
> -	 * will try to acquire lock for new cpu. And policy is already updated
> -	 * by then.
> -	 */
> -	down_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
> +	down_write(&policy->rwsem);
> 
>  	policy->last_cpu = policy->cpu;
>  	policy->cpu = cpu;
> 
> -	up_write(&per_cpu(cpu_policy_rwsem, policy->last_cpu));
> +	up_write(&policy->rwsem);
> 
>  #ifdef CONFIG_CPU_FREQ_TABLE
>  	cpufreq_frequency_table_update_policy_cpu(policy);
> @@ -1140,9 +1094,9 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
>  	if (ret) {
>  		pr_err("%s: Failed to move kobj: %d", __func__, ret);
> 
> -		lock_policy_rwsem_write(old_cpu);
> +		down_write(&policy->rwsem);
>  		cpumask_set_cpu(old_cpu, policy->cpus);
> -		unlock_policy_rwsem_write(old_cpu);
> +		up_write(&policy->rwsem);
> 
>  		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>  					"cpufreq");
> @@ -1193,9 +1147,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  			policy->governor->name, CPUFREQ_NAME_LEN);
>  #endif
> 
> -	lock_policy_rwsem_read(cpu);
> +	down_read(&policy->rwsem);
>  	cpus = cpumask_weight(policy->cpus);
> -	unlock_policy_rwsem_read(cpu);
> +	up_read(&policy->rwsem);
> 
>  	if (cpu != policy->cpu) {
>  		if (!frozen)
> @@ -1236,12 +1190,12 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>  		return -EINVAL;
>  	}
> 
> -	lock_policy_rwsem_write(cpu);
> +	down_write(&policy->rwsem);
>  	cpus = cpumask_weight(policy->cpus);
> 
>  	if (cpus > 1)
>  		cpumask_clear_cpu(cpu, policy->cpus);
> -	unlock_policy_rwsem_write(cpu);
> +	up_write(&policy->rwsem);
> 
>  	/* If cpu is last user of policy, free policy */
>  	if (cpus == 1) {
> @@ -1256,10 +1210,10 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>  		}
> 
>  		if (!frozen) {
> -			lock_policy_rwsem_read(cpu);
> +			down_read(&policy->rwsem);
>  			kobj = &policy->kobj;
>  			cmp = &policy->kobj_unregister;
> -			unlock_policy_rwsem_read(cpu);
> +			up_read(&policy->rwsem);
>  			kobject_put(kobj);
> 
>  			/*
> @@ -1451,19 +1405,22 @@ static unsigned int __cpufreq_get(unsigned int cpu)
>   */
>  unsigned int cpufreq_get(unsigned int cpu)
>  {
> +	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
>  	unsigned int ret_freq = 0;
> 
>  	if (cpufreq_disabled() || !cpufreq_driver)
>  		return -ENOENT;
> 
> +	BUG_ON(!policy);
> +
>  	if (!down_read_trylock(&cpufreq_rwsem))
>  		return 0;
> 
> -	lock_policy_rwsem_read(cpu);
> +	down_read(&policy->rwsem);
> 
>  	ret_freq = __cpufreq_get(cpu);
> 
> -	unlock_policy_rwsem_read(cpu);
> +	up_read(&policy->rwsem);
>  	up_read(&cpufreq_rwsem);
> 
>  	return ret_freq;
> @@ -1687,11 +1644,11 @@ int cpufreq_driver_target(struct cpufreq_policy *policy,
>  {
>  	int ret = -EINVAL;
> 
> -	lock_policy_rwsem_write(policy->cpu);
> +	down_write(&policy->rwsem);
> 
>  	ret = __cpufreq_driver_target(policy, target_freq, relation);
> 
> -	unlock_policy_rwsem_write(policy->cpu);
> +	up_write(&policy->rwsem);
> 
>  	return ret;
>  }
> @@ -1922,10 +1879,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *policy,
>  			/* end old governor */
>  			if (policy->governor) {
>  				__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> -				unlock_policy_rwsem_write(new_policy->cpu);
> +				up_write(&new_policy->rwsem);
>  				__cpufreq_governor(policy,
>  						CPUFREQ_GOV_POLICY_EXIT);
> -				lock_policy_rwsem_write(new_policy->cpu);
> +				down_write(&new_policy->rwsem);
>  			}
> 
>  			/* start new governor */
> @@ -1934,10 +1891,10 @@ static int __cpufreq_set_policy(struct cpufreq_policy *policy,
>  				if (!__cpufreq_governor(policy, CPUFREQ_GOV_START)) {
>  					failed = 0;
>  				} else {
> -					unlock_policy_rwsem_write(new_policy->cpu);
> +					up_write(&new_policy->rwsem);
>  					__cpufreq_governor(policy,
>  							CPUFREQ_GOV_POLICY_EXIT);
> -					lock_policy_rwsem_write(new_policy->cpu);
> +					down_write(&new_policy->rwsem);
>  				}
>  			}
> 
> @@ -1983,7 +1940,7 @@ int cpufreq_update_policy(unsigned int cpu)
>  		goto no_policy;
>  	}
> 
> -	lock_policy_rwsem_write(cpu);
> +	down_write(&policy->rwsem);
> 
>  	pr_debug("updating policy for CPU %u\n", cpu);
>  	memcpy(&new_policy, policy, sizeof(*policy));
> @@ -2010,7 +1967,7 @@ int cpufreq_update_policy(unsigned int cpu)
> 
>  	ret = __cpufreq_set_policy(policy, &new_policy);
> 
> -	unlock_policy_rwsem_write(cpu);
> +	up_write(&policy->rwsem);
> 
>  	cpufreq_cpu_put(policy);
>  no_policy:
> @@ -2167,14 +2124,9 @@ EXPORT_SYMBOL_GPL(cpufreq_unregister_driver);
> 
>  static int __init cpufreq_core_init(void)
>  {
> -	int cpu;
> -
>  	if (cpufreq_disabled())
>  		return -ENODEV;
> 
> -	for_each_possible_cpu(cpu)
> -		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
> -
>  	cpufreq_global_kobject = kobject_create();
>  	BUG_ON(!cpufreq_global_kobject);
>  	register_syscore_ops(&cpufreq_syscore_ops);
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 6b199ed..a72bac2 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -85,6 +85,20 @@ struct cpufreq_policy {
>  	struct list_head        policy_list;
>  	struct kobject		kobj;
>  	struct completion	kobj_unregister;
> +
> +	/*
> +	 * The rules for this semaphore:
> +	 * - Any routine that wants to read from the policy structure will
> +	 *   do a down_read on this semaphore.
> +	 * - Any routine that will write to the policy structure and/or may take away
> +	 *   the policy altogether (eg. CPU hotplug), will hold this lock in write
> +	 *   mode before doing so.
> +	 *
> +	 * Additional rules:
> +	 * - Lock should not be held across
> +	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
> +	 */
> +	struct rw_semaphore	rwsem;
>  };
> 
>  /* Only for ACPI */
> 

