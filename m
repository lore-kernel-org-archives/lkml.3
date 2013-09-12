Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3ILGoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:44:22 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51674 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3ILGoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:44:19 -0400
Message-ID: <523161D1.9040005@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 12:10:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@wwwdotorg.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
References: <cover.1378963070.git.viresh.kumar@linaro.org> <8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org>
In-Reply-To: <8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091206-2674-0000-0000-00000A9DD9B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:55 AM, Viresh Kumar wrote:
> This broke after a recent change "cedb70a cpufreq: Split __cpufreq_remove_dev()
> into two parts" from Srivatsa..
> 
> Consider a scenario where we have two CPUs in a policy (0 & 1) and we are
> removing cpu 1. On the call to __cpufreq_remove_dev_prepare() we have cleared 1
> from policy->cpus and now on a call to __cpufreq_remove_dev_finish() we read
> cpumask_weight of policy->cpus, which will come as 1 and this code will behave
> as if we are removing the last cpu from policy :)
> 
> Fix it by clearing cpu mask in __cpufreq_remove_dev_finish() instead of
> __cpufreq_remove_dev_prepare().
>

Oops! Good catch!

That said, your fix doesn't look correct. See below.
 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 0e11fcb..b556d46 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1175,12 +1175,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  			policy->governor->name, CPUFREQ_NAME_LEN);
>  #endif
> 
> -	WARN_ON(lock_policy_rwsem_write(cpu));
> +	lock_policy_rwsem_read(cpu);
>  	cpus = cpumask_weight(policy->cpus);
> -
> -	if (cpus > 1)
> -		cpumask_clear_cpu(cpu, policy->cpus);
> -	unlock_policy_rwsem_write(cpu);
> +	unlock_policy_rwsem_read(cpu);
> 
>  	if (cpu != policy->cpu) {
>  		if (!frozen)

Around here, we call cpufreq_nominate_new_policy_cpu(), and if we haven't cleared
the CPU by then, there is a chance that it will nominate the same CPU that we are
taking offline. So its important to clear the CPU before that point.

> @@ -1222,9 +1219,12 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>  		return -EINVAL;
>  	}
> 
> -	lock_policy_rwsem_read(cpu);
> +	WARN_ON(lock_policy_rwsem_write(cpu));
>  	cpus = cpumask_weight(policy->cpus);
> -	unlock_policy_rwsem_read(cpu);
> +
> +	if (cpus > 1)
> +		cpumask_clear_cpu(cpu, policy->cpus);
> +	unlock_policy_rwsem_write(cpu);
>

Perhaps we can retain the above as a read operation, ...
 
>  	/* If cpu is last user of policy, free policy */
>  	if (cpus == 1) {
> 
... and change this suitably (from 1 to 0 etc..) ? To add to it, it will look more
clear as well:

if (cpus == 0) {
	/* No cpus in policy, so free it */
} else {
	/* Restart governor */
}

Regards,
Srivatsa S. Bhat

