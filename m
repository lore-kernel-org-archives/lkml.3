Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbaGPA2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:28:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54960 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaGPA2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:28:43 -0400
Message-ID: <53C5C738.5040705@codeaurora.org>
Date: Tue, 15 Jul 2014 17:28:40 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>, linux-pm@vger.kernel.org,
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

One preemptive comment.

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

<SNIP>

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

<SNIP>

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

<SNIP>

> +	if (!cpus && cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
> +		cpufreq_driver->stop_cpu(policy);
> +	}
>

Viresh, I tried your suggestion (and my initial thought too) to combine 
this as an if/else with the previous if. But the indentation got nasty 
and made it hard to read. I'm sure the compiler will optimize it. So, I 
would prefer to leave it this way.


> -	policy->governor = NULL;
> +unlock:
> +	up_write(&policy->rwsem);
>
> -	return policy;
> +	return ret;
>   }
> +#endif
>

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
