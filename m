Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3HRN42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 09:56:28 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48187 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab3HRN41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 09:56:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH V2 07/11] cpufreq: Use cpufreq_policy_list for iterating over policies
Date: Sun, 18 Aug 2013 16:06:55 +0200
Message-ID: <1582060.zfvsylJcxu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <e54ce908bb964d643a2bbb945ed4a8dcb3ea00bf.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org> <e54ce908bb964d643a2bbb945ed4a8dcb3ea00bf.1375809311.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 06, 2013 10:53:09 PM Viresh Kumar wrote:
> For iterating over all policies currently we are iterating over all CPUs and
> then finding their policies. Lets use the newly created infrastructure
> cpufreq_policy_list.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

I noticed that the current linux-next branch of linux-pm.git caused the
BUG_ON() in lock_policy_rwsem_##mode() to trigger when user space tried to
access cpufreq sysfs attributes before system suspend and after system
resume.

I tried to debug that and it turned out that this patch caused resume
to block indefinitely on one of my test machines and after reverting it the
BUG_ON() stopped triggering, so I've just reverted it in my tree (it is not an
important change).

I don't have the time to figure out why this change breaks things and I would
appreciate it if you tested stuff like suspend/resume on an x86 laptop or
similar with your patches applied before posting them for merging.

Thanks,
Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index f5999c4..fe04b79 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -984,8 +984,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  	struct cpufreq_policy *policy;
>  	unsigned long flags;
>  #ifdef CONFIG_HOTPLUG_CPU
> +	struct cpufreq_policy *tpolicy;
>  	struct cpufreq_governor *gov;
> -	int sibling;
>  #endif
>  
>  	if (cpu_is_offline(cpu))
> @@ -1005,11 +1005,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  #ifdef CONFIG_HOTPLUG_CPU
>  	/* Check if this cpu was hot-unplugged earlier and has siblings */
>  	read_lock_irqsave(&cpufreq_driver_lock, flags);
> -	for_each_online_cpu(sibling) {
> -		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
> -		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
> +	list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
> +		if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
>  			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -			return cpufreq_add_policy_cpu(cp, cpu, dev, frozen);
> +			return cpufreq_add_policy_cpu(tpolicy, cpu, dev,
> +					frozen);
>  		}
>  	}
>  	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
