Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3JCHne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:43:34 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35759 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3JCHn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:43:28 -0400
Message-ID: <524D1F26.2080908@linux.vnet.ibm.com>
Date: Thu, 03 Oct 2013 13:09:18 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 10/11] cpufreq: use cpufreq_driver->flags to mark
 CPUFREQ_HAVE_GOVERNOR_PER_POLICY
References: <cover.1380703248.git.viresh.kumar@linaro.org> <4c9af8dda1c4f968e08815632cea3987d0426127.1380703248.git.viresh.kumar@linaro.org>
In-Reply-To: <4c9af8dda1c4f968e08815632cea3987d0426127.1380703248.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100307-9574-0000-0000-000009E7B1CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 02:13 PM, Viresh Kumar wrote:
> Lets use cpufreq_driver->flags to mark CPUFREQ_HAVE_GOVERNOR_PER_POLICY instead
> of a separate field within cpufreq_driver. This will save some bytes for us.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

>  drivers/cpufreq/arm_big_little.c   |  4 ++--
>  drivers/cpufreq/cpufreq.c          |  2 +-
>  drivers/cpufreq/cpufreq_governor.h |  5 ++++-
>  include/linux/cpufreq.h            | 15 ++++++++-------
>  4 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
> index 9acfb82..2c7c134 100644
> --- a/drivers/cpufreq/arm_big_little.c
> +++ b/drivers/cpufreq/arm_big_little.c
> @@ -213,13 +213,13 @@ static struct freq_attr *bL_cpufreq_attr[] = {
> 
>  static struct cpufreq_driver bL_cpufreq_driver = {
>  	.name			= "arm-big-little",
> -	.flags			= CPUFREQ_STICKY,
> +	.flags			= CPUFREQ_STICKY |
> +					CPUFREQ_HAVE_GOVERNOR_PER_POLICY,
>  	.verify			= bL_cpufreq_verify_policy,
>  	.target			= bL_cpufreq_set_target,
>  	.get			= bL_cpufreq_get,
>  	.init			= bL_cpufreq_init,
>  	.exit			= bL_cpufreq_exit,
> -	.have_governor_per_policy = true,
>  	.attr			= bL_cpufreq_attr,
>  };
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 267ae99..23e0a40 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -92,7 +92,7 @@ static DEFINE_MUTEX(cpufreq_governor_mutex);
> 
>  bool have_governor_per_policy(void)
>  {
> -	return cpufreq_driver->have_governor_per_policy;
> +	return !!(cpufreq_driver->flags & CPUFREQ_HAVE_GOVERNOR_PER_POLICY);
>  }
>  EXPORT_SYMBOL_GPL(have_governor_per_policy);
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index 88cd39f..b5f2b86 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -191,7 +191,10 @@ struct common_dbs_data {
>  	struct attribute_group *attr_group_gov_sys; /* one governor - system */
>  	struct attribute_group *attr_group_gov_pol; /* one governor - policy */
> 
> -	/* Common data for platforms that don't set have_governor_per_policy */
> +	/*
> +	 * Common data for platforms that don't set
> +	 * CPUFREQ_HAVE_GOVERNOR_PER_POLICY
> +	 */
>  	struct dbs_data *gdbs_data;
> 
>  	struct cpu_dbs_common_info *(*get_cpu_cdbs)(int cpu);
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 9321059..6c9c365 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -194,13 +194,6 @@ __ATTR(_name, 0644, show_##_name, store_##_name)
>  struct cpufreq_driver {
>  	char			name[CPUFREQ_NAME_LEN];
>  	u8			flags;
> -	/*
> -	 * This should be set by platforms having multiple clock-domains, i.e.
> -	 * supporting multiple policies. With this sysfs directories of governor
> -	 * would be created in cpu/cpu<num>/cpufreq/ directory and so they can
> -	 * use the same governor with different tunables for different clusters.
> -	 */
> -	bool			have_governor_per_policy;
> 
>  	/* needed by all drivers */
>  	int	(*init)		(struct cpufreq_policy *policy);
> @@ -234,6 +227,14 @@ struct cpufreq_driver {
>  #define CPUFREQ_PM_NO_WARN	(1 << 2)	/* don't warn on suspend/resume
>  						   speed mismatches */
> 
> +/*
> + * This should be set by platforms having multiple clock-domains, i.e.
> + * supporting multiple policies. With this sysfs directories of governor would
> + * be created in cpu/cpu<num>/cpufreq/ directory and so they can use the same
> + * governor with different tunables for different clusters.
> + */
> +#define CPUFREQ_HAVE_GOVERNOR_PER_POLICY (1 << 3)
> +
>  int cpufreq_register_driver(struct cpufreq_driver *driver_data);
>  int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
> 


