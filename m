Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3IQJYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:24:54 -0400
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:48569 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859Ab3IQJYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:24:52 -0400
Message-ID: <1379409886.3413.14.camel@linaro1.home>
Subject: Re: [PATCH V2 1/2] cpufreq: unlock correct rwsem while updating
 policy->cpu
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Tue, 17 Sep 2013 10:24:46 +0100
In-Reply-To: <63ac1edc637ef2c8cf05579972506ad5365948c1.1379393377.git.viresh.kumar@linaro.org>
References: <63ac1edc637ef2c8cf05579972506ad5365948c1.1379393377.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-17 at 10:22 +0530, Viresh Kumar wrote:
> Current code looks like this:
> 
>         WARN_ON(lock_policy_rwsem_write(cpu));
>         update_policy_cpu(policy, new_cpu);
>         unlock_policy_rwsem_write(cpu);
> 
> {lock|unlock}_policy_rwsem_write(cpu) takes/releases policy->cpu's rwsem.
> Because cpu is changing with the call to update_policy_cpu(), the
> unlock_policy_rwsem_write() will release the incorrect lock.
> 
> The right solution would be to release the same lock as was taken earlier. Also
> update_policy_cpu() was also called from cpufreq_add_dev() without any locks and
> so its better if we move this locking to inside update_policy_cpu().
> 
> Reported-and-Tested-by: Jon Medhurst<tixy@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Rafael,
> 
> Only one patch is sent now as other one is unchanged.

This patch fixes a regression introduced in 3.12 by commit f9ba680d23
(cpufreq: Extract the handover of policy cpu to a helper function).

The other patch is a tidyup of long-standing code.

>  drivers/cpufreq/cpufreq.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 43c24aa..1479522 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -952,9 +952,20 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>  	if (cpu == policy->cpu)
>  		return;
>  
> +	/*
> +	 * Take direct locks as lock_policy_rwsem_write wouldn't work here.
> +	 * Also lock for last cpu is enough here as contention will happen only
> +	 * after policy->cpu is changed and after it is changed, other threads
> +	 * will try to acquire lock for new cpu. And policy is already updated
> +	 * by then.
> +	 */
> +	down_write(&per_cpu(cpu_policy_rwsem, policy->cpu));
> +
>  	policy->last_cpu = policy->cpu;
>  	policy->cpu = cpu;
>  
> +	up_write(&per_cpu(cpu_policy_rwsem, policy->last_cpu));
> +
>  #ifdef CONFIG_CPU_FREQ_TABLE
>  	cpufreq_frequency_table_update_policy_cpu(policy);
>  #endif
> @@ -1203,9 +1214,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  
>  		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
>  		if (new_cpu >= 0) {
> -			WARN_ON(lock_policy_rwsem_write(cpu));
>  			update_policy_cpu(policy, new_cpu);
> -			unlock_policy_rwsem_write(cpu);
>  
>  			if (!frozen) {
>  				pr_debug("%s: policy Kobject moved to cpu: %d "

-- 
Tixy

