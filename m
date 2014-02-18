Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaBRJQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:16:34 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:35385 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbaBRJQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:16:31 -0500
Message-ID: <530323A2.3040909@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 14:40:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Refactor cpufreq_set_policy()
References: <3582112.BRVGbkstFm@vostro.rjw.lan>
In-Reply-To: <3582112.BRVGbkstFm@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021809-7014-0000-0000-00000459B7AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 06:36 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Reduce the rampant usage of goto and the indentation level in
> cpufreq_set_policy() to improve the readability of that code.
> 
> No functional changes should result from that.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/cpufreq.c |  102 ++++++++++++++++++++--------------------------
>  1 file changed, 45 insertions(+), 57 deletions(-)
> 
> Index: linux-pm/drivers/cpufreq/cpufreq.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> +++ linux-pm/drivers/cpufreq/cpufreq.c
> @@ -2018,22 +2018,21 @@ EXPORT_SYMBOL(cpufreq_get_policy);
>  static int cpufreq_set_policy(struct cpufreq_policy *policy,
>  				struct cpufreq_policy *new_policy)
>  {
> -	int ret = 0, failed = 1;
> +	struct cpufreq_governor *old_gov;
> +	int ret;
> 
>  	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", new_policy->cpu,
>  		new_policy->min, new_policy->max);
> 
>  	memcpy(&new_policy->cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
> 
> -	if (new_policy->min > policy->max || new_policy->max < policy->min) {
> -		ret = -EINVAL;
> -		goto error_out;
> -	}
> +	if (new_policy->min > policy->max || new_policy->max < policy->min)
> +		return -EINVAL;
> 
>  	/* verify the cpu speed can be set within this limit */
>  	ret = cpufreq_driver->verify(new_policy);
>  	if (ret)
> -		goto error_out;
> +		return ret;
> 
>  	/* adjust if necessary - all reasons */
>  	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> @@ -2049,7 +2048,7 @@ static int cpufreq_set_policy(struct cpu
>  	 */
>  	ret = cpufreq_driver->verify(new_policy);
>  	if (ret)
> -		goto error_out;
> +		return ret;
> 
>  	/* notification of the new policy */
>  	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> @@ -2064,58 +2063,47 @@ static int cpufreq_set_policy(struct cpu
>  	if (cpufreq_driver->setpolicy) {
>  		policy->policy = new_policy->policy;
>  		pr_debug("setting range\n");
> -		ret = cpufreq_driver->setpolicy(new_policy);
> -	} else {
> -		if (new_policy->governor != policy->governor) {
> -			/* save old, working values */
> -			struct cpufreq_governor *old_gov = policy->governor;
> -
> -			pr_debug("governor switch\n");
> -
> -			/* end old governor */
> -			if (policy->governor) {
> -				__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> -				up_write(&policy->rwsem);
> -				__cpufreq_governor(policy,
> -						CPUFREQ_GOV_POLICY_EXIT);
> -				down_write(&policy->rwsem);
> -			}
> -
> -			/* start new governor */
> -			policy->governor = new_policy->governor;
> -			if (!__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT)) {
> -				if (!__cpufreq_governor(policy, CPUFREQ_GOV_START)) {
> -					failed = 0;
> -				} else {
> -					up_write(&policy->rwsem);
> -					__cpufreq_governor(policy,
> -							CPUFREQ_GOV_POLICY_EXIT);
> -					down_write(&policy->rwsem);
> -				}
> -			}
> -
> -			if (failed) {
> -				/* new governor failed, so re-start old one */
> -				pr_debug("starting governor %s failed\n",
> -							policy->governor->name);
> -				if (old_gov) {
> -					policy->governor = old_gov;
> -					__cpufreq_governor(policy,
> -							CPUFREQ_GOV_POLICY_INIT);
> -					__cpufreq_governor(policy,
> -							   CPUFREQ_GOV_START);
> -				}
> -				ret = -EINVAL;
> -				goto error_out;
> -			}
> -			/* might be a policy change, too, so fall through */
> -		}
> -		pr_debug("governor: change or update limits\n");
> -		ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> +		return cpufreq_driver->setpolicy(new_policy);
>  	}
> +	if (new_policy->governor == policy->governor)
> +		goto out;
> +
> +	pr_debug("governor switch\n");
> +
> +	/* save old, working values */
> +	old_gov = policy->governor;
> +	/* end old governor */
> +	if (old_gov) {
> +		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> +		up_write(&policy->rwsem);
> +		__cpufreq_governor(policy,CPUFREQ_GOV_POLICY_EXIT);
> +		down_write(&policy->rwsem);
> +	}
> +
> +	/* start new governor */
> +	policy->governor = new_policy->governor;
> +	if (!__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT)) {
> +		if (!__cpufreq_governor(policy, CPUFREQ_GOV_START))
> +			goto out;
> +
> +		up_write(&policy->rwsem);
> +		__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
> +		down_write(&policy->rwsem);
> +	}
> +
> +	/* new governor failed, so re-start old one */
> +	pr_debug("starting governor %s failed\n", policy->governor->name);
> +	if (old_gov) {
> +		policy->governor = old_gov;
> +		__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_INIT);
> +		__cpufreq_governor(policy, CPUFREQ_GOV_START);
> +	}
> +
> +	return -EINVAL;
> 
> -error_out:
> -	return ret;
> + out:
> +	pr_debug("governor: change or update limits\n");
> +	return __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>  }
> 
>  /**
> 

