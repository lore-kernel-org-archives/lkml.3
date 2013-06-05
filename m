Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3FEM2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:28:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58348 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab3FEM2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:28:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        chenxg.marvell@gmail.com
Subject: Re: [PATCH] cpufreq: userspace: Simplify governor
Date: Wed, 05 Jun 2013 14:37:15 +0200
Message-ID: <1855098.3p2j9hWHoD@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <68ae523282b494da0e8f67536af1df874c326675.1370422554.git.viresh.kumar@linaro.org>
References: <68ae523282b494da0e8f67536af1df874c326675.1370422554.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 05, 2013 02:34:33 PM Viresh Kumar wrote:
> Userspace governor has got more code than what it needs for its functioning.
> Lets simplify it.

OK

Why exactly is the code you're removing unnecessary?

> Over that it will fix issues in cpufreq_governor_userspace(), which isn't doing
> right things in START/STOP.

What exactly is the problem?

> It is working per-cpu currently whereas it just
> required to manage policy->cpu.
> 
> Reported-by: Xiaoguang Chen <chenxg.marvell@gmail.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> @Rafael:
> 
> I don't know why this code was initially added. Please let me know if I am doing
> something stupid.
> 
> Also, please apply it as a fix for 3.10 as it is broken recently in 3.9.

I'd love to, but I need answers to the above questions before I do that.

Thanks,
Rafael


>  drivers/cpufreq/cpufreq_userspace.c | 108 ++++--------------------------------
>  1 file changed, 12 insertions(+), 96 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
> index bbeb9c0..5dc77b7 100644
> --- a/drivers/cpufreq/cpufreq_userspace.c
> +++ b/drivers/cpufreq/cpufreq_userspace.c
> @@ -13,55 +13,13 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/smp.h>
> -#include <linux/init.h>
> -#include <linux/spinlock.h>
> -#include <linux/interrupt.h>
>  #include <linux/cpufreq.h>
> -#include <linux/cpu.h>
> -#include <linux/types.h>
> -#include <linux/fs.h>
> -#include <linux/sysfs.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
>  #include <linux/mutex.h>
>  
> -/**
> - * A few values needed by the userspace governor
> - */
> -static DEFINE_PER_CPU(unsigned int, cpu_max_freq);
> -static DEFINE_PER_CPU(unsigned int, cpu_min_freq);
> -static DEFINE_PER_CPU(unsigned int, cpu_cur_freq); /* current CPU freq */
> -static DEFINE_PER_CPU(unsigned int, cpu_set_freq); /* CPU freq desired by
> -							userspace */
>  static DEFINE_PER_CPU(unsigned int, cpu_is_managed);
> -
>  static DEFINE_MUTEX(userspace_mutex);
> -static int cpus_using_userspace_governor;
> -
> -/* keep track of frequency transitions */
> -static int
> -userspace_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
> -	void *data)
> -{
> -	struct cpufreq_freqs *freq = data;
> -
> -	if (!per_cpu(cpu_is_managed, freq->cpu))
> -		return 0;
> -
> -	if (val == CPUFREQ_POSTCHANGE) {
> -		pr_debug("saving cpu_cur_freq of cpu %u to be %u kHz\n",
> -				freq->cpu, freq->new);
> -		per_cpu(cpu_cur_freq, freq->cpu) = freq->new;
> -	}
> -
> -	return 0;
> -}
> -
> -static struct notifier_block userspace_cpufreq_notifier_block = {
> -	.notifier_call  = userspace_cpufreq_notifier
> -};
> -
>  
>  /**
>   * cpufreq_set - set the CPU frequency
> @@ -80,13 +38,6 @@ static int cpufreq_set(struct cpufreq_policy *policy, unsigned int freq)
>  	if (!per_cpu(cpu_is_managed, policy->cpu))
>  		goto err;
>  
> -	per_cpu(cpu_set_freq, policy->cpu) = freq;
> -
> -	if (freq < per_cpu(cpu_min_freq, policy->cpu))
> -		freq = per_cpu(cpu_min_freq, policy->cpu);
> -	if (freq > per_cpu(cpu_max_freq, policy->cpu))
> -		freq = per_cpu(cpu_max_freq, policy->cpu);
> -
>  	/*
>  	 * We're safe from concurrent calls to ->target() here
>  	 * as we hold the userspace_mutex lock. If we were calling
> @@ -107,7 +58,7 @@ static int cpufreq_set(struct cpufreq_policy *policy, unsigned int freq)
>  
>  static ssize_t show_speed(struct cpufreq_policy *policy, char *buf)
>  {
> -	return sprintf(buf, "%u\n", per_cpu(cpu_cur_freq, policy->cpu));
> +	return sprintf(buf, "%u\n", policy->cur);
>  }
>  
>  static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
> @@ -119,66 +70,31 @@ static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
>  	switch (event) {
>  	case CPUFREQ_GOV_START:
>  		BUG_ON(!policy->cur);
> -		mutex_lock(&userspace_mutex);
> -
> -		if (cpus_using_userspace_governor == 0) {
> -			cpufreq_register_notifier(
> -					&userspace_cpufreq_notifier_block,
> -					CPUFREQ_TRANSITION_NOTIFIER);
> -		}
> -		cpus_using_userspace_governor++;
> +		pr_debug("started managing cpu %u\n", cpu);
>  
> +		mutex_lock(&userspace_mutex);
>  		per_cpu(cpu_is_managed, cpu) = 1;
> -		per_cpu(cpu_min_freq, cpu) = policy->min;
> -		per_cpu(cpu_max_freq, cpu) = policy->max;
> -		per_cpu(cpu_cur_freq, cpu) = policy->cur;
> -		per_cpu(cpu_set_freq, cpu) = policy->cur;
> -		pr_debug("managing cpu %u started "
> -			"(%u - %u kHz, currently %u kHz)\n",
> -				cpu,
> -				per_cpu(cpu_min_freq, cpu),
> -				per_cpu(cpu_max_freq, cpu),
> -				per_cpu(cpu_cur_freq, cpu));
> -
>  		mutex_unlock(&userspace_mutex);
>  		break;
>  	case CPUFREQ_GOV_STOP:
> -		mutex_lock(&userspace_mutex);
> -		cpus_using_userspace_governor--;
> -		if (cpus_using_userspace_governor == 0) {
> -			cpufreq_unregister_notifier(
> -					&userspace_cpufreq_notifier_block,
> -					CPUFREQ_TRANSITION_NOTIFIER);
> -		}
> +		pr_debug("managing cpu %u stopped\n", cpu);
>  
> +		mutex_lock(&userspace_mutex);
>  		per_cpu(cpu_is_managed, cpu) = 0;
> -		per_cpu(cpu_min_freq, cpu) = 0;
> -		per_cpu(cpu_max_freq, cpu) = 0;
> -		per_cpu(cpu_set_freq, cpu) = 0;
> -		pr_debug("managing cpu %u stopped\n", cpu);
>  		mutex_unlock(&userspace_mutex);
>  		break;
>  	case CPUFREQ_GOV_LIMITS:
>  		mutex_lock(&userspace_mutex);
> -		pr_debug("limit event for cpu %u: %u - %u kHz, "
> -			"currently %u kHz, last set to %u kHz\n",
> +		pr_debug("limit event for cpu %u: %u - %u kHz, currently %u kHz\n",
>  			cpu, policy->min, policy->max,
> -			per_cpu(cpu_cur_freq, cpu),
> -			per_cpu(cpu_set_freq, cpu));
> -		if (policy->max < per_cpu(cpu_set_freq, cpu)) {
> +			policy->cur);
> +
> +		if (policy->max < policy->cur)
>  			__cpufreq_driver_target(policy, policy->max,
>  						CPUFREQ_RELATION_H);
> -		} else if (policy->min > per_cpu(cpu_set_freq, cpu)) {
> +		else if (policy->min > policy->cur)
>  			__cpufreq_driver_target(policy, policy->min,
>  						CPUFREQ_RELATION_L);
> -		} else {
> -			__cpufreq_driver_target(policy,
> -						per_cpu(cpu_set_freq, cpu),
> -						CPUFREQ_RELATION_L);
> -		}
> -		per_cpu(cpu_min_freq, cpu) = policy->min;
> -		per_cpu(cpu_max_freq, cpu) = policy->max;
> -		per_cpu(cpu_cur_freq, cpu) = policy->cur;
>  		mutex_unlock(&userspace_mutex);
>  		break;
>  	}
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
