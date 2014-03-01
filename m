Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaCAA7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:59:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49202 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752727AbaCAA7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:59:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: skannan@codeaurora.org, linaro-kernel@lists.linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH 2/3] cpufreq: Initialize policy before making it available for others to use
Date: Sat, 01 Mar 2014 02:14:35 +0100
Message-ID: <278741659.0r4LI3yGJ4@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <57b8ab66ba21f42c91311641319cec16d2c8923d.1393318100.git.viresh.kumar@linaro.org>
References: <9f9546137135103556c69815c72b81ed93cc1ca2.1393318100.git.viresh.kumar@linaro.org> <57b8ab66ba21f42c91311641319cec16d2c8923d.1393318100.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 25, 2014 02:20:10 PM Viresh Kumar wrote:
> Policy must be fully initialized before it is being made available for use by
> others.

True enough.  And the problem is?

> This patch moves some initialization code before making policy available
> for others.

So why/how exactly does this fix the problem?

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index cc4f244..110c0cd 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1116,6 +1116,20 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  		goto err_set_policy_cpu;
>  	}
>  
> +	/* related cpus should atleast have policy->cpus */
> +	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
> +
> +	/*
> +	 * affected cpus must always be the one, which are online. We aren't
> +	 * managing offline cpus here.
> +	 */
> +	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
> +
> +	if (!frozen) {
> +		policy->user_policy.min = policy->min;
> +		policy->user_policy.max = policy->max;
> +	}
> +
>  	write_lock_irqsave(&cpufreq_driver_lock, flags);
>  	for_each_cpu(j, policy->cpus)
>  		per_cpu(cpufreq_cpu_data, j) = policy;
> @@ -1169,20 +1183,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  		}
>  	}
>  
> -	/* related cpus should atleast have policy->cpus */
> -	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
> -
> -	/*
> -	 * affected cpus must always be the one, which are online. We aren't
> -	 * managing offline cpus here.
> -	 */
> -	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
> -
> -	if (!frozen) {
> -		policy->user_policy.min = policy->min;
> -		policy->user_policy.max = policy->max;
> -	}
> -
>  	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>  				     CPUFREQ_START, policy);
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
