Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab3HCL6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 07:58:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53557 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab3HCL6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 07:58:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com
Subject: Re: [PATCH 08/10] cpufreq: Fix broken usage of governor->owner's refcount
Date: Sat, 03 Aug 2013 14:08:18 +0200
Message-ID: <4846602.3FgvAM66Ta@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <46faea4c060f91f7102d9d33c816693acc25a917.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org> <46faea4c060f91f7102d9d33c816693acc25a917.1375530162.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 03, 2013 05:19:26 PM Viresh Kumar wrote:
> Governor's owner refcount usage was broken. We should increment refcount only
> when CPUFREQ_GOV_POLICY_INIT event has come and should decrement only if
> CPUFREQ_GOV_POLICY_EXIT has come.
> 
> Lets fix it.

OK, and what happens if we don't fix it?

Rafael


> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index e9b969f..74d4969 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1707,8 +1707,9 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  		}
>  	}
>  
> -	if (!try_module_get(policy->governor->owner))
> -		return -EINVAL;
> +	if (event == CPUFREQ_GOV_POLICY_INIT)
> +		if (!try_module_get(policy->governor->owner))
> +			return -EINVAL;
>  
>  	pr_debug("__cpufreq_governor for CPU %u, event %u\n",
>  						policy->cpu, event);
> @@ -1717,6 +1718,8 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  	if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
>  	    (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
>  		mutex_unlock(&cpufreq_governor_lock);
> +		if (event == CPUFREQ_GOV_POLICY_INIT)
> +			module_put(policy->governor->owner);
>  		return -EBUSY;
>  	}
>  
> @@ -1744,11 +1747,8 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  		mutex_unlock(&cpufreq_governor_lock);
>  	}
>  
> -	/* we keep one module reference alive for
> -			each CPU governed by this CPU */
> -	if ((event != CPUFREQ_GOV_START) || ret)
> -		module_put(policy->governor->owner);
> -	if ((event == CPUFREQ_GOV_STOP) && !ret)
> +	if (((event == CPUFREQ_GOV_POLICY_INIT) && ret) ||
> +			((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
>  		module_put(policy->governor->owner);
>  
>  	return ret;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
