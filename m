Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab3DBMng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:43:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55655 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758098Ab3DBMne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:43:34 -0400
Date: Tue, 2 Apr 2013 14:43:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V2 1/2] cpufreq: ondemand: allow custom
 powersave_bias_target function to be registered
Message-ID: <20130402124332.GA5488@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>
References: <1364495057-14939-1-git-send-email-jacob.shin@amd.com>
 <1364495057-14939-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364495057-14939-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 01:24:16PM -0500, Jacob Shin wrote:
> This allows for another [arch specific] driver to hook into existing
> powersave bias function of the ondemand governor. i.e. This allows AMD
> specific powersave bias function (in a separate AMD specific driver)
> to aid ondemand governor's frequency transition deicisions.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  drivers/cpufreq/cpufreq_governor.h |    3 +++
>  drivers/cpufreq/cpufreq_ondemand.c |   22 +++++++++++++++++++---
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index c83cabf..4b6808f 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -262,4 +262,7 @@ bool need_load_eval(struct cpu_dbs_common_info *cdbs,
>  		unsigned int sampling_rate);
>  int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  		struct common_dbs_data *cdata, unsigned int event);
> +void od_register_powersave_bias_function(unsigned int (*f)
> +		(struct cpufreq_policy *, unsigned int, unsigned int));
> +void od_unregister_powersave_bias_function(void);

We generally call those a "callback" or a "handler". I.e.,
od_register_powersave_bias_handler or something.

>  #endif /* _CPUFREQ_GOVERNER_H */
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 15e80ee..36f0798 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -40,6 +40,8 @@
>  
>  static DEFINE_PER_CPU(struct od_cpu_dbs_info_s, od_cpu_dbs_info);
>  
> +static struct od_ops od_ops;
> +
>  #ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
>  static struct cpufreq_governor cpufreq_gov_ondemand;
>  #endif
> @@ -145,7 +147,8 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
>  	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
>  
>  	if (od_tuners->powersave_bias)
> -		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
> +		freq = od_ops.powersave_bias_target(p, freq,
> +				CPUFREQ_RELATION_H);
>  	else if (p->cur == p->max)
>  		return;
>  
> @@ -206,8 +209,8 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
>  			__cpufreq_driver_target(policy, freq_next,
>  					CPUFREQ_RELATION_L);
>  		} else {
> -			int freq = powersave_bias_target(policy, freq_next,
> -					CPUFREQ_RELATION_L);
> +			int freq = od_ops.powersave_bias_target(policy,
> +					freq_next, CPUFREQ_RELATION_L);
>  			__cpufreq_driver_target(policy, freq,
>  					CPUFREQ_RELATION_L);
>  		}
> @@ -565,6 +568,19 @@ static struct common_dbs_data od_dbs_cdata = {
>  	.exit = od_exit,
>  };
>  
> +void od_register_powersave_bias_function(unsigned int (*f)
> +		(struct cpufreq_policy *, unsigned int, unsigned int))
> +{
> +	od_ops.powersave_bias_target = f;
> +}
> +EXPORT_SYMBOL_GPL(od_register_powersave_bias_function);
> +
> +void od_unregister_powersave_bias_function(void)
> +{
> +	od_ops.powersave_bias_target = powersave_bias_target;

This is very confusing: we have ->powersave_bias_target and the default
powersave_bias_target in the ondemand governor. Can we call the default
one generic_powersave_bias_target or default_* or whatever.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
