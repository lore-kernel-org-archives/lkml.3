Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab3ILIRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:17:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50956 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3ILIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:17:38 -0400
Message-ID: <523177B5.2050007@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 13:43:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@wwwdotorg.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] cpufreq: don't update policy->cpu while removing
 while removing other CPUs
References: <cover.1378963070.git.viresh.kumar@linaro.org> <0475c234b6ca2849c8a69dad0446d82b065b4161.1378963070.git.viresh.kumar@linaro.org>
In-Reply-To: <0475c234b6ca2849c8a69dad0446d82b065b4161.1378963070.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091208-4790-0000-0000-00000A46AFC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:55 AM, Viresh Kumar wrote:
> With a recent change the logic here is changed a bit and I just figured out it
> is something we don't want.
> 
> Consider we have four CPUs (0,1,2,3) managed by a policy and policy->cpu is set
> to 0. Now we are suspending and hence we call __cpufreq_remove_dev_prepare() for
> cpu 1, 2 & 3..
> 
> With the current code we always call cpufreq_nominate_new_policy_cpu() for cpu
> 1, 2 & 3 whereas we should skipped most of __cpufreq_remove_dev_prepare()
> routine.
> 
> Lets fix it by moving the check for !frozen inside the first if block.
> 

As you noted in the other thread, Rafael already applied my patch[1] which does
the same thing. So I guess you'll drop this patch from your series.

[1].http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=bleeding-edge&id=61173f256

Regards,
Srivatsa S. Bhat

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 5e0a82e..0e11fcb 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1182,8 +1182,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>  		cpumask_clear_cpu(cpu, policy->cpus);
>  	unlock_policy_rwsem_write(cpu);
> 
> -	if (cpu != policy->cpu && !frozen) {
> -		sysfs_remove_link(&dev->kobj, "cpufreq");
> +	if (cpu != policy->cpu) {
> +		if (!frozen)
> +			sysfs_remove_link(&dev->kobj, "cpufreq");
>  	} else if (cpus > 1) {
>  		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu, frozen);
>  		if (new_cpu >= 0) {
> 


