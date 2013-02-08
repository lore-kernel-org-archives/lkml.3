Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945941Ab3BHG1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:27:43 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:63016 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3BHG1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:27:41 -0500
Date: Fri, 8 Feb 2013 10:27:36 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, valdis.kletnieks@vt.edu,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        dirk.brandewie@gmail.com
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
Message-ID: <20130208062736.GA5563@thinkpad.lan>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
 <2158181.aoVXdpLJe2@vostro.rjw.lan>
 <CAKohponLrVG+ubf5Ok+7AvoWKRF16YLqUEWAU6hH7-H_R=r0Ow@mail.gmail.com>
 <1947746.IyFppZQEx8@vostro.rjw.lan>
 <CAKohpony25Ct94QyCOEmoNVS6Xc5O8=0Cnc6NxLxTP5Y-E1XJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpony25Ct94QyCOEmoNVS6Xc5O8=0Cnc6NxLxTP5Y-E1XJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 10:39:13AM +0530, Viresh Kumar wrote:
> On 8 February 2013 04:37, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > BTW, there still are locking problems in linux-next.  Why do we need
> > to take cpufreq_driver_lock() around driver->init() in cpufreq_add_dev(),
> > in particular?
> I thought a bit more and realized there is no such limitation on
> cpufreq_driver->ops about calling routines which can sleep. And thus
> we shoudln't
> have locks around any of these. I have got a patch for it, that i
> would fold-back into
> the original patch that introduced locking fixes (attached too for testing):
Tested this patch on top of linux-pm.git/bleeding-edge
Now everything seems to be alright.

> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Fri, 8 Feb 2013 10:35:31 +0530
> Subject: [PATCH] cpufreq: Remove unnecessary locking
> 
> I have placed some locks intentionally around calls to driver->ops (init/exit),
> which look to be wrong as these calls can call routines that potentially sleep.
> 
> Lets remove these locks.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 5d8a422..04aab05 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -795,10 +795,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
> 
>  	if (ret) {
>  		pr_debug("setting policy failed\n");
> -		spin_lock_irqsave(&cpufreq_driver_lock, flags);
>  		if (driver->exit)
>  			driver->exit(policy);
> -		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>  	}
>  	return ret;
> 
> @@ -920,17 +918,14 @@ static int cpufreq_add_dev(struct device *dev,
> struct subsys_interface *sif)
>  	init_completion(&policy->kobj_unregister);
>  	INIT_WORK(&policy->update, handle_update);
> 
> -	spin_lock_irqsave(&cpufreq_driver_lock, flags);
>  	/* call driver. From then on the cpufreq must be able
>  	 * to accept all calls to ->verify and ->setpolicy for this CPU
>  	 */
>  	ret = driver->init(policy);
>  	if (ret) {
>  		pr_debug("initialization failed\n");
> -		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>  		goto err_set_policy_cpu;
>  	}
> -	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
>  	/* related cpus should atleast have policy->cpus */
>  	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
> @@ -1100,10 +1095,8 @@ static int __cpufreq_remove_dev(struct device
> *dev, struct subsys_interface *sif
>  		wait_for_completion(cmp);
>  		pr_debug("wait complete\n");
> 
> -		spin_lock_irqsave(&cpufreq_driver_lock, flags);
>  		if (driver->exit)
>  			driver->exit(data);
> -		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
>  		free_cpumask_var(data->related_cpus);
>  		free_cpumask_var(data->cpus);

Tested-by: Artem Savkov <artem.savkov@gmail.com>

-- 
Kind regards,
Artem
