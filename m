Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3HBNVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 09:21:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52078 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3HBNVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 09:21:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references for additional policy CPUs
Date: Fri, 02 Aug 2013 15:31:35 +0200
Message-ID: <5361062.ChI1FUI32W@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpon7jyJWhf+j-M6Nuqy-AaY73YUpBpt-1uh12e_SYRv2bQ@mail.gmail.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com> <CAKohpon7jyJWhf+j-M6Nuqy-AaY73YUpBpt-1uh12e_SYRv2bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 04:25:58 PM Viresh Kumar wrote:
> On 2 August 2013 10:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> @@ -908,7 +905,8 @@ static int cpufreq_add_policy_cpu(unsign
> >>         unsigned long flags;
> >>
> >>         policy = cpufreq_cpu_get(sibling);
> >
> > This can be skipped completely at this place. Caller of
> > cpufreq_add_policy_cpu() has got the policy pointer with it and so
> > can be passed. I haven't done it earlier as the impression was we need
> > to call cpufreq_cpu_get()..
> 
> And here is the fixup to do this (attached too):

Care to add a changelog?

I'll apply this on top of my $subject patch, then.

Thanks,
Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 46e70ae..47f2a6e 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -889,21 +889,17 @@ static void cpufreq_init_policy(struct
> cpufreq_policy *policy)
>  }
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> -static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
> -				  struct device *dev, bool frozen)
> +static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
> +				  unsigned int cpu, struct device *dev,
> +				  bool frozen)
>  {
> -	struct cpufreq_policy *policy;
>  	int ret = 0, has_target = !!cpufreq_driver->target;
>  	unsigned long flags;
> 
> -	policy = cpufreq_cpu_get(sibling);
> -	if (WARN_ON_ONCE(!policy))
> -		return -ENODATA;
> -
>  	if (has_target)
>  		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> 
> -	lock_policy_rwsem_write(sibling);
> +	lock_policy_rwsem_write(policy->cpu);
> 
>  	write_lock_irqsave(&cpufreq_driver_lock, flags);
> 
> @@ -912,7 +908,7 @@ static int cpufreq_add_policy_cpu(unsigned int
> cpu, unsigned int sibling,
>  	per_cpu(cpufreq_cpu_data, cpu) = policy;
>  	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
> -	unlock_policy_rwsem_write(sibling);
> +	unlock_policy_rwsem_write(policy->cpu);
> 
>  	if (has_target) {
>  		__cpufreq_governor(policy, CPUFREQ_GOV_START);
> @@ -923,7 +919,6 @@ static int cpufreq_add_policy_cpu(unsigned int
> cpu, unsigned int sibling,
>  	if (!frozen)
>  		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> 
> -	cpufreq_cpu_put(policy);
>  	return ret;
>  }
>  #endif
> @@ -1006,8 +1001,7 @@ static int __cpufreq_add_dev(struct device *dev,
> struct subsys_interface *sif,
>  		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
>  		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
>  			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -			return cpufreq_add_policy_cpu(cpu, sibling, dev,
> -						      frozen);
> +			return cpufreq_add_policy_cpu(cp, cpu, dev, frozen);
>  		}
>  	}
>  	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
