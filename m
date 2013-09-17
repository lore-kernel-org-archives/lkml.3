Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab3IQI2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:28:48 -0400
Received: from smarthost01c.mail.zen.net.uk ([212.23.1.5]:59032 "EHLO
	smarthost01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab3IQI2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:28:45 -0400
Message-ID: <1379406519.3413.13.camel@linaro1.home>
Subject: Re: [PATCH 2/2] cpufreq: make return type of
 lock_policy_rwsem_{read|write}() as void
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Tue, 17 Sep 2013 09:28:39 +0100
In-Reply-To: <a257808b511a83f210ed699149ce87fef5db6236.1379344038.git.viresh.kumar@linaro.org>
References: <075032be4fd288074b8f699d4f4ba0179518df6f.1379344038.git.viresh.kumar@linaro.org>
	 <a257808b511a83f210ed699149ce87fef5db6236.1379344038.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01c-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 20:40 +0530, Viresh Kumar wrote:
> lock_policy_rwsem_{read|write}() currently has return type of int but it always
> return zero and hence its return type must be void instead. This patch makes its
> return type void and fixes all users of it as well.
> 
> Reported-by: Jon Medhurst<tixy@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Tested-by: Jon Medhurst <tixy@linaro.org>

> ---
>  drivers/cpufreq/cpufreq.c | 38 +++++++++++---------------------------
>  1 file changed, 11 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index c18bf7b..598af5c 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -67,13 +67,11 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
>  
>  #define lock_policy_rwsem(mode, cpu)					\
> -static int lock_policy_rwsem_##mode(int cpu)				\
> +static void lock_policy_rwsem_##mode(int cpu)				\
>  {									\
>  	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);	\
>  	BUG_ON(!policy);						\
>  	down_##mode(&per_cpu(cpu_policy_rwsem, policy->cpu));		\
> -									\
> -	return 0;							\
>  }
>  
>  lock_policy_rwsem(read, cpu);
> @@ -653,13 +651,12 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
>  {
>  	struct cpufreq_policy *policy = to_policy(kobj);
>  	struct freq_attr *fattr = to_attr(attr);
> -	ssize_t ret = -EINVAL;
> +	ssize_t ret;
>  
>  	if (!down_read_trylock(&cpufreq_rwsem))
> -		goto exit;
> +		return -EINVAL;
>  
> -	if (lock_policy_rwsem_read(policy->cpu) < 0)
> -		goto up_read;
> +	lock_policy_rwsem_read(policy->cpu);
>  
>  	if (fattr->show)
>  		ret = fattr->show(policy, buf);
> @@ -667,10 +664,8 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
>  		ret = -EIO;
>  
>  	unlock_policy_rwsem_read(policy->cpu);
> -
> -up_read:
>  	up_read(&cpufreq_rwsem);
> -exit:
> +
>  	return ret;
>  }
>  
> @@ -689,8 +684,7 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
>  	if (!down_read_trylock(&cpufreq_rwsem))
>  		goto unlock;
>  
> -	if (lock_policy_rwsem_write(policy->cpu) < 0)
> -		goto up_read;
> +	lock_policy_rwsem_write(policy->cpu);
>  
>  	if (fattr->store)
>  		ret = fattr->store(policy, buf, count);
> @@ -699,7 +693,6 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
>  
>  	unlock_policy_rwsem_write(policy->cpu);
>  
> -up_read:
>  	up_read(&cpufreq_rwsem);
>  unlock:
>  	put_online_cpus();
> @@ -1143,7 +1136,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
>  	if (ret) {
>  		pr_err("%s: Failed to move kobj: %d", __func__, ret);
>  
> -		WARN_ON(lock_policy_rwsem_write(old_cpu));
> +		lock_policy_rwsem_write(old_cpu);
>  		cpumask_set_cpu(old_cpu, policy->cpus);
>  		unlock_policy_rwsem_write(old_cpu);
>  
> @@ -1196,7 +1189,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  			policy->governor->name, CPUFREQ_NAME_LEN);
>  #endif
>  
> -	WARN_ON(lock_policy_rwsem_write(cpu));
> +	lock_policy_rwsem_write(cpu);
>  	cpus = cpumask_weight(policy->cpus);
>  
>  	if (cpus > 1)
> @@ -1459,14 +1452,11 @@ unsigned int cpufreq_get(unsigned int cpu)
>  	if (!down_read_trylock(&cpufreq_rwsem))
>  		return 0;
>  
> -	if (unlikely(lock_policy_rwsem_read(cpu)))
> -		goto out_policy;
> +	lock_policy_rwsem_read(cpu);
>  
>  	ret_freq = __cpufreq_get(cpu);
>  
>  	unlock_policy_rwsem_read(cpu);
> -
> -out_policy:
>  	up_read(&cpufreq_rwsem);
>  
>  	return ret_freq;
> @@ -1690,14 +1680,12 @@ int cpufreq_driver_target(struct cpufreq_policy *policy,
>  {
>  	int ret = -EINVAL;
>  
> -	if (unlikely(lock_policy_rwsem_write(policy->cpu)))
> -		goto fail;
> +	lock_policy_rwsem_write(policy->cpu);
>  
>  	ret = __cpufreq_driver_target(policy, target_freq, relation);
>  
>  	unlock_policy_rwsem_write(policy->cpu);
>  
> -fail:
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(cpufreq_driver_target);
> @@ -1988,10 +1976,7 @@ int cpufreq_update_policy(unsigned int cpu)
>  		goto no_policy;
>  	}
>  
> -	if (unlikely(lock_policy_rwsem_write(cpu))) {
> -		ret = -EINVAL;
> -		goto fail;
> -	}
> +	lock_policy_rwsem_write(cpu);
>  
>  	pr_debug("updating policy for CPU %u\n", cpu);
>  	memcpy(&new_policy, policy, sizeof(*policy));
> @@ -2020,7 +2005,6 @@ int cpufreq_update_policy(unsigned int cpu)
>  
>  	unlock_policy_rwsem_write(cpu);
>  
> -fail:
>  	cpufreq_cpu_put(policy);
>  no_policy:
>  	return ret;


