Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab3BJVN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 16:13:27 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:54623 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3BJVNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 16:13:25 -0500
Message-ID: <51180DA7.8040203@gmail.com>
Date: Sun, 10 Feb 2013 22:14:15 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, Steve.Bannister@arm.com, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH 4/4] cpufreq: governor: Implement per policy instances
 of governors
References: <cover.1359976493.git.viresh.kumar@linaro.org> <b16436f3b3eba648500a287d552efbbf48bcc9bb.1359976493.git.viresh.kumar@linaro.org>
In-Reply-To: <b16436f3b3eba648500a287d552efbbf48bcc9bb.1359976493.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/04/2013 12:38 PM, Viresh Kumar wrote:
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
> This patch uses the infrastructure provided by earlier patch and implements
> init/exit routines for ondemand and conservative governors.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c              |   4 -
>  drivers/cpufreq/cpufreq_conservative.c | 142 +++++++++++++----------
>  drivers/cpufreq/cpufreq_governor.c     | 138 +++++++++++++---------
>  drivers/cpufreq/cpufreq_governor.h     |  42 ++++---
>  drivers/cpufreq/cpufreq_ondemand.c     | 205 +++++++++++++++++++--------------
>  include/linux/cpufreq.h                |  19 +--
>  6 files changed, 314 insertions(+), 236 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 1ae78d4..7aacfbf 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1551,9 +1551,6 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  						policy->cpu, event);
>  	ret = policy->governor->governor(policy, event);
>  
> -	if (!policy->governor->initialized && (event == CPUFREQ_GOV_START))
> -		policy->governor->initialized = 1;
> -
>  	/* we keep one module reference alive for
>  			each CPU governed by this CPU */
>  	if ((event != CPUFREQ_GOV_START) || ret)
> @@ -1577,7 +1574,6 @@ int cpufreq_register_governor(struct cpufreq_governor *governor)
>  
>  	mutex_lock(&cpufreq_governor_mutex);
>  
> -	governor->initialized = 0;
>  	err = -EBUSY;
>  	if (__find_governor(governor->name) == NULL) {
>  		err = 0;
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
[...]
> +static int cs_init(struct dbs_data *dbs_data)
> +{
> +	struct cs_dbs_tuners *tuners;
> +
> +	tuners = kzalloc(sizeof(struct cs_dbs_tuners), GFP_KERNEL);
> +	if (!tuners) {
> +		pr_err("%s: kzalloc failed\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	tuners->up_threshold = DEF_FREQUENCY_UP_THRESHOLD;
> +	tuners->down_threshold = DEF_FREQUENCY_DOWN_THRESHOLD;
> +	tuners->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
> +	tuners->ignore_nice = 0;
> +	tuners->freq_step = 5;
> +
> +	dbs_data->tuners = tuners;

dbs_data->tuners is never freed, which means there is a memory leak
across CPUFREQ_GOV_POLICY_INIT and CPUFREQ_GOV_POLICY_EXIT events.

The same goes for the ondemand governor.

Regards,
Francesco
