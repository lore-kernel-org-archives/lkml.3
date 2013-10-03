Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3JCHNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:13:24 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51367 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3JCHNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:13:22 -0400
Message-ID: <524D1815.2070809@linux.vnet.ibm.com>
Date: Thu, 03 Oct 2013 12:39:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 01/11] cpufreq: make return type of lock_policy_rwsem_{read|write}()
 as void
References: <cover.1380703248.git.viresh.kumar@linaro.org> <b361f4df33e414ecd2e8a25959746e84da789d6a.1380703248.git.viresh.kumar@linaro.org>
In-Reply-To: <b361f4df33e414ecd2e8a25959746e84da789d6a.1380703248.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100307-5564-0000-0000-000009FDD44B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 02:13 PM, Viresh Kumar wrote:
> lock_policy_rwsem_{read|write}() currently has return type of int but it always
> return zero and hence its return type must be void instead. This patch makes its
> return type void and fixes all users of it as well.
> 
> Reported-by: Jon Medhurst<tixy@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  drivers/cpufreq/cpufreq.c | 38 +++++++++++---------------------------
>  1 file changed, 11 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 04548f7..eb993d9 100644
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
> @@ -1147,7 +1140,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
>  	if (ret) {
>  		pr_err("%s: Failed to move kobj: %d", __func__, ret);
> 
> -		WARN_ON(lock_policy_rwsem_write(old_cpu));
> +		lock_policy_rwsem_write(old_cpu);
>  		cpumask_set_cpu(old_cpu, policy->cpus);
>  		unlock_policy_rwsem_write(old_cpu);
> 
> @@ -1243,7 +1236,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>  		return -EINVAL;
>  	}
> 
> -	WARN_ON(lock_policy_rwsem_write(cpu));
> +	lock_policy_rwsem_write(cpu);
>  	cpus = cpumask_weight(policy->cpus);
> 
>  	if (cpus > 1)
> @@ -1466,14 +1459,11 @@ unsigned int cpufreq_get(unsigned int cpu)
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
> @@ -1697,14 +1687,12 @@ int cpufreq_driver_target(struct cpufreq_policy *policy,
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
> @@ -1995,10 +1983,7 @@ int cpufreq_update_policy(unsigned int cpu)
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
> @@ -2027,7 +2012,6 @@ int cpufreq_update_policy(unsigned int cpu)
> 
>  	unlock_policy_rwsem_write(cpu);
> 
> -fail:
>  	cpufreq_cpu_put(policy);
>  no_policy:
>  	return ret;
> 

