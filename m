Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3BUX3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:29:20 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41076 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab3BUX3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:29:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com
Subject: Re: [PATCH V2 1/4] cpufreq: Add per policy governor-init/exit infrastructure
Date: Fri, 22 Feb 2013 00:35:56 +0100
Message-ID: <3793606.bilcxohA80@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <ece24bb874ad1834fc43b83f053b2560db8c25d3.1360568193.git.viresh.kumar@linaro.org>
References: <cover.1360568193.git.viresh.kumar@linaro.org> <ece24bb874ad1834fc43b83f053b2560db8c25d3.1360568193.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2013 01:20:00 PM Viresh Kumar wrote:
> Currently, there can't be multiple instances of single governor_type. If we have
> a multi-package system, where we have multiple instances of struct policy (per
> package), we can't have multiple instances of same governor. i.e. We can't have
> multiple instances of ondemand governor for multiple packages.
> 
> Governors directory in sysfs is created at /sys/devices/system/cpu/cpufreq/
> governor-name/. Which again reflects that there can be only one instance of a
> governor_type in the system.
> 
> This is a bottleneck for multicluster system, where we want different packages
> to use same governor type, but with different tunables.
> 
> This patch is inclined towards providing this infrastructure. Because we are
> required to allocate governor's resources dynamically now, we must do it at
> policy creation and end. And so got CPUFREQ_GOV_POLICY_INIT/EXIT.

Are those new events NOPs now?

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 21 ++++++++++++++++++---
>  include/linux/cpufreq.h   |  9 ++++++---
>  2 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 04aab05..40f7083 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1081,6 +1081,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>  
>  	/* If cpu is last user of policy, free policy */
>  	if (cpus == 1) {
> +		__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
> +
>  		lock_policy_rwsem_read(cpu);
>  		kobj = &data->kobj;
>  		cmp = &data->kobj_unregister;
> @@ -1669,7 +1671,7 @@ EXPORT_SYMBOL(cpufreq_get_policy);
>  static int __cpufreq_set_policy(struct cpufreq_policy *data,
>  				struct cpufreq_policy *policy)
>  {
> -	int ret = 0;
> +	int ret = 0, failed = 1;
>  	struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
>  
>  	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", policy->cpu,
> @@ -1724,18 +1726,31 @@ static int __cpufreq_set_policy(struct cpufreq_policy *data,
>  			pr_debug("governor switch\n");
>  
>  			/* end old governor */
> -			if (data->governor)
> +			if (data->governor) {
>  				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
> +				__cpufreq_governor(data,
> +						CPUFREQ_GOV_POLICY_EXIT);
> +			}
>  
>  			/* start new governor */
>  			data->governor = policy->governor;
> -			if (__cpufreq_governor(data, CPUFREQ_GOV_START)) {
> +			if (!__cpufreq_governor(data, CPUFREQ_GOV_POLICY_INIT)) {
> +				if (!__cpufreq_governor(data, CPUFREQ_GOV_START))
> +					failed = 0;
> +				else
> +					__cpufreq_governor(data,
> +							CPUFREQ_GOV_POLICY_EXIT);
> +			}
> +
> +			if (failed) {
>  				/* new governor failed, so re-start old one */
>  				pr_debug("starting governor %s failed\n",
>  							data->governor->name);
>  				if (old_gov) {
>  					data->governor = old_gov;
>  					__cpufreq_governor(data,
> +							CPUFREQ_GOV_POLICY_INIT);
> +					__cpufreq_governor(data,
>  							   CPUFREQ_GOV_START);
>  				}
>  				ret = -EINVAL;
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index a22944c..3b822ce 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -106,6 +106,7 @@ struct cpufreq_policy {
>  					 * governors are used */
>  	unsigned int		policy; /* see above */
>  	struct cpufreq_governor	*governor; /* see below */
> +	void			*governor_data;
>  
>  	struct work_struct	update; /* if update_policy() needs to be
>  					 * called, but you're in IRQ context */
> @@ -178,9 +179,11 @@ static inline unsigned long cpufreq_scale(unsigned long old, u_int div, u_int mu
>   *                          CPUFREQ GOVERNORS                        *
>   *********************************************************************/
>  
> -#define CPUFREQ_GOV_START  1
> -#define CPUFREQ_GOV_STOP   2
> -#define CPUFREQ_GOV_LIMITS 3
> +#define CPUFREQ_GOV_START	1
> +#define CPUFREQ_GOV_STOP	2
> +#define CPUFREQ_GOV_LIMITS	3
> +#define CPUFREQ_GOV_POLICY_INIT	4
> +#define CPUFREQ_GOV_POLICY_EXIT	4

Why don't you use different values here?

If you need only one value, one #define should be sufficient.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
