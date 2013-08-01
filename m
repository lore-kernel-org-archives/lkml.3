Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3HAIO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:14:58 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52200 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3HAIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:14:54 -0400
Message-ID: <51FA1818.2050203@linux.vnet.ibm.com>
Date: Thu, 01 Aug 2013 13:41:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
References: <2362640.pUofnXyzOi@vostro.rjw.lan>
In-Reply-To: <2362640.pUofnXyzOi@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080108-0260-0000-0000-00000367D6CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 05:38 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The cpufreq core is a little inconsistent in the way it uses the
> driver module refcount.
> 
> Namely, if __cpufreq_add_dev() is called for a CPU without siblings
> or generally a CPU for which a new policy object has to be created,
> it grabs a reference to the driver module to start with, but drops
> that reference before returning.  As a result, the driver module
> refcount is then equal to 0 after __cpufreq_add_dev() has returned.
> 
> On the other hand, if the given CPU is a sibling of some other
> CPU already having a policy, cpufreq_add_policy_cpu() is called
> to link the new CPU to the existing policy.  In that case,
> cpufreq_cpu_get() is called to obtain that policy and grabs a
> reference to the driver module, but that reference is not
> released and the module refcount will be different from 0 after
> __cpufreq_add_dev() returns (unless there is an error).  That
> prevents the driver module from being unloaded until
> __cpufreq_remove_dev() is called for all the CPUs that
> cpufreq_add_policy_cpu() was called for previously.
> 
> To remove that inconsistency make cpufreq_add_policy_cpu() execute
> cpufreq_cpu_put() for the given policy before returning, which
> decrements the driver module refcount so that it will be 0 after
> __cpufreq_add_dev() returns,

Removing the inconsistency is a good thing, but I think we should
make it consistent the other way around - make a CPU-online increment
the driver module refcount and decrement it only on CPU-offline.

The reason is, one should not be able to unload the back-end cpufreq
driver module when some CPUs are still being managed. Nasty things
will result if we allow that. For example, if we unload the module,
and then try to do a CPU offline, then the cpufreq hotplug notifier
won't even be called (because cpufreq_unregister_driver also
unregisters the hotplug notifier). And that might be troublesome.

Even worse, if we unload a cpufreq driver module and load a new
one and *then* try to offline the CPU, then the cpufreq_driver->exit()
function that we call during CPU offline will end up calling the
corresponding function of an entirely different driver! So the
->init() and ->exit() calls won't match.

These complications won't exist if we simply prevent unloading the
driver module as long as they are used in managing atleast one CPU.
So I think it would be good to make the code consistent that way.

Regards,
Srivatsa S. Bhat

> but also make it take a reference to
> the policy itself using kobject_get() and do not release that
> reference (unless there's an error or system resume is under way),
> which again is consistent with the "raw" __cpufreq_add_dev()
> behavior.
> 
> Accordingly, modify __cpufreq_remove_dev() to use kobject_put() to
> drop policy references taken by cpufreq_add_policy_cpu().
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> On top of current linux-pm.git/linux-next.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/cpufreq/cpufreq.c |   24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> Index: linux-pm/drivers/cpufreq/cpufreq.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> +++ linux-pm/drivers/cpufreq/cpufreq.c
> @@ -908,8 +908,10 @@ static int cpufreq_add_policy_cpu(unsign
>  	unsigned long flags;
> 
>  	policy = cpufreq_cpu_get(sibling);
> -	WARN_ON(!policy);
> +	if (WARN_ON_ONCE(!policy))
> +		return -ENODATA;
> 
> +	kobject_get(&policy->kobj);
>  	if (has_target)
>  		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> 
> @@ -932,14 +934,14 @@ static int cpufreq_add_policy_cpu(unsign
>  	/* Don't touch sysfs links during light-weight init */
>  	if (frozen) {
>  		/* Drop the extra refcount that we took above */
> -		cpufreq_cpu_put(policy);
> -		return 0;
> +		kobject_put(&policy->kobj);
> +	} else {
> +		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> +		if (ret)
> +			kobject_put(&policy->kobj);
>  	}
> 
> -	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> -	if (ret)
> -		cpufreq_cpu_put(policy);
> -
> +	cpufreq_cpu_put(policy);
>  	return ret;
>  }
>  #endif
> @@ -1298,10 +1300,14 @@ static int __cpufreq_remove_dev(struct d
>  		if (!frozen)
>  			cpufreq_policy_free(data);
>  	} else {
> -
> +		/*
> +		 * There are more CPUs using the same policy, so only drop the
> +		 * reference taken by cpufreq_add_policy_cpu() (unless the
> +		 * system is suspending).
> +		 */
>  		if (!frozen) {
>  			pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
> -			cpufreq_cpu_put(data);
> +			kobject_put(&data->kobj);
>  		}
> 
>  		if (cpufreq_driver->target) {
> 

