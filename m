Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3EPGRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 02:17:06 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:58942 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866Ab3EPGRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 02:17:03 -0400
Message-ID: <51947935.50607@marvell.com>
Date: Thu, 16 May 2013 14:14:13 +0800
From: Xiaoguang Chen <chenxg@marvell.com>
Organization: Marvell
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Xiaoguang Chen <chenxg@marvell.com>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ning Jiang <njiang1@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Zhoujie Wu <zjwu@marvell.com>
Subject: Re: [PATCH] cpufreq: fix governor start/stop race condition
References: <1368442050-16548-1-git-send-email-chenxg@marvell.com>
In-Reply-To: <1368442050-16548-1-git-send-email-chenxg@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 06:47 PM, Xiaoguang Chen wrote:
> cpufreq governor stop and start should be kept in sequence.
> If not, there will be unexpected behavior, for example:
>
> we have 4 cpus and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
> the normal sequence is as below:
>
> 1) Current governor is userspace, one application tries to set
> governor to ondemand. it will call __cpufreq_set_policy in which it
> will stop userspace governor and then start ondemand governor.
>
> 2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
> call cpufreq_add_policy_cpu. on which it first stops userspace
> governor, and then starts userspace governor.
>
> Now if the sequence of above two cases interleaves, it becames
> below sequence:
>
> 1) application stops userspace governor
> 2)                                      hotplug stops userspace governor
> 3) application starts ondemand governor
> 4)                                      hotplug starts a governor
>
> in step 4, hotplug is supposed to start userspace governor, but now
> the governor has been changed by application to ondemand, so hotplug
> starts ondemand governor again !!!!
>
> The solution is as below:
> cpufreq policy has a rwsem to protect the read and write of policy.
> make the scope of the rwsem to contain cpufreq governor stop/start
> sequence, so that after the stop governor has started, other threads
> will not stop governor, they have to wait the current thread starts
> the governor and then do their job.
>
> Change-Id: I054bb52789fc8abdcf80bdcc1caebd429c182bb0
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> ---
>   drivers/cpufreq/cpufreq.c | 19 ++++++++-----------
>   1 file changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 1b8a48e..935f750 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -811,14 +811,14 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
>   	int ret = 0, has_target = !!cpufreq_driver->target;
>   	unsigned long flags;
>   
> +	lock_policy_rwsem_write(sibling);
> +
>   	policy = cpufreq_cpu_get(sibling);
>   	WARN_ON(!policy);
>   
>   	if (has_target)
>   		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>   
> -	lock_policy_rwsem_write(sibling);
> -
>   	write_lock_irqsave(&cpufreq_driver_lock, flags);
>   
>   	cpumask_set_cpu(cpu, policy->cpus);
> @@ -826,13 +826,13 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
>   	per_cpu(cpufreq_cpu_data, cpu) = policy;
>   	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>   
> -	unlock_policy_rwsem_write(sibling);
> -
>   	if (has_target) {
>   		__cpufreq_governor(policy, CPUFREQ_GOV_START);
>   		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>   	}
>   
> +	unlock_policy_rwsem_write(sibling);
> +
>   	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>   	if (ret) {
>   		cpufreq_cpu_put(policy);
> @@ -1028,6 +1028,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>   		return -EINVAL;
>   	}
>   
> +	WARN_ON(lock_policy_rwsem_write(cpu));
> +
>   	if (cpufreq_driver->target)
>   		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
>   
> @@ -1037,12 +1039,10 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>   			data->governor->name, CPUFREQ_NAME_LEN);
>   #endif
>   
> -	WARN_ON(lock_policy_rwsem_write(cpu));
>   	cpus = cpumask_weight(data->cpus);
>   
>   	if (cpus > 1)
>   		cpumask_clear_cpu(cpu, data->cpus);
> -	unlock_policy_rwsem_write(cpu);
>   
>   	if (cpu != data->cpu) {
>   		sysfs_remove_link(&dev->kobj, "cpufreq");
> @@ -1054,7 +1054,6 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>   		if (ret) {
>   			pr_err("%s: Failed to move kobj: %d", __func__, ret);
>   
> -			WARN_ON(lock_policy_rwsem_write(cpu));
>   			cpumask_set_cpu(cpu, data->cpus);
>   
>   			write_lock_irqsave(&cpufreq_driver_lock, flags);
> @@ -1068,9 +1067,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>   			return -EINVAL;
>   		}
>   
> -		WARN_ON(lock_policy_rwsem_write(cpu));
>   		update_policy_cpu(data, cpu_dev->id);
> -		unlock_policy_rwsem_write(cpu);
>   		pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
>   				__func__, cpu_dev->id, cpu);
>   	}
> @@ -1083,10 +1080,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>   		if (cpufreq_driver->target)
>   			__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
>   
> -		lock_policy_rwsem_read(cpu);
>   		kobj = &data->kobj;
>   		cmp = &data->kobj_unregister;
> -		unlock_policy_rwsem_read(cpu);
>   		kobject_put(kobj);
>   
>   		/* we need to make sure that the underlying kobj is actually
> @@ -1108,6 +1103,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>   		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
>   	}
>   
> +	unlock_policy_rwsem_write(cpu);
> +
>   	per_cpu(cpufreq_policy_cpu, cpu) = -1;
>   	return 0;
>   }
Hi, Guys
What's your opinion about this patch?

-- 
Thanks
Xiaoguang

