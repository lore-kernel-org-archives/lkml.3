Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3HBEh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:37:26 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:45064 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3HBEhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <2298639.F0Qv2QqRnZ@vostro.rjw.lan>
References: <2362640.pUofnXyzOi@vostro.rjw.lan>
	<51FAC46D.1000703@linux.vnet.ibm.com>
	<1757496.qSuJuAun9Z@vostro.rjw.lan>
	<2298639.F0Qv2QqRnZ@vostro.rjw.lan>
Date: Fri, 2 Aug 2013 10:07:23 +0530
Message-ID: <CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow!! Lot of stuff happened while I was asleep..

@Srivatsa: Thanks for answering what I would have answered to Rafael :)
And you should really get some sleep, I would suggest :)

On 2 August 2013 02:23, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: cpufreq: Do not hold driver module references for additional policy CPUs

I still have issues with this subject. Why don't we get rid of .owner
field completely? And stop using a mix of cpufreq_cpu_get() and
kobject_get()?

> The cpufreq core is a little inconsistent in the way it uses the
> driver module refcount.
>
> Namely, if __cpufreq_add_dev() is called for a CPU that doesn't
> share the policy object with any other CPUs, the driver module
> refcount it grabs to start with will be dropped by it before
> returning and will be equal to 0 afterward.

It wouldn't be zero but 1, this is what it is initialized with probably.
That's what I can see in my tests.

> However, if the given CPU does share the policy object with other
> CPUs, either cpufreq_add_policy_cpu() is called to link the new CPU
> to the existing policy, or cpufreq_add_dev_symlink() is used to link
> the other CPUs sharing the policy with it to the just created policy
> object.  In that case, because both cpufreq_add_policy_cpu() and
> cpufreq_add_dev_symlink() call cpufreq_cpu_get() for the given
> policy (the latter possibly many times) without the balancing
> cpufreq_cpu_put() (unless there is an error), the driver module
> refcount will be left by __cpufreq_add_dev() with a nonzero value.
>
> To remove that inconsistency make cpufreq_add_policy_cpu() execute
> cpufreq_cpu_put() for the given policy before returning, which
> decrements the driver module refcount so that it will be 0 after
> __cpufreq_add_dev() returns.  Moreover, remove the cpufreq_cpu_get()
> call from cpufreq_add_dev_symlink(), since both the policy refcount
> and the driver module refcount are nonzero when it is called and they
> don't need to be bumped up by it.
>
> Accordingly, drop the cpufreq_cpu_put() from __cpufreq_remove_dev(),
> since it is only necessary to balance the cpufreq_cpu_get() called
> by cpufreq_add_policy_cpu() or cpufreq_add_dev_symlink().
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>  drivers/cpufreq/cpufreq.c |   28 +++++++---------------------
>  1 file changed, 7 insertions(+), 21 deletions(-)

So, we can't rmmod the module as soon as it is inserted and so the
problem stays as is. :(

> Index: linux-pm/drivers/cpufreq/cpufreq.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> +++ linux-pm/drivers/cpufreq/cpufreq.c
> @@ -818,14 +818,11 @@ static int cpufreq_add_dev_symlink(struc
>                         continue;
>
>                 pr_debug("Adding link for CPU: %u\n", j);
> -               cpufreq_cpu_get(policy->cpu);
>                 cpu_dev = get_cpu_device(j);
>                 ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>                                         "cpufreq");
> -               if (ret) {
> -                       cpufreq_cpu_put(policy);
> -                       return ret;
> -               }
> +               if (ret)
> +                       break;
>         }
>         return ret;
>  }
> @@ -908,7 +905,8 @@ static int cpufreq_add_policy_cpu(unsign
>         unsigned long flags;
>
>         policy = cpufreq_cpu_get(sibling);

This can be skipped completely at this place. Caller of
cpufreq_add_policy_cpu() has got the policy pointer with it and so
can be passed. I haven't done it earlier as the impression was we need
to call cpufreq_cpu_get()..

> -       WARN_ON(!policy);
> +       if (WARN_ON_ONCE(!policy))
> +               return -ENODATA;
>
>         if (has_target)
>                 __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> @@ -930,16 +928,10 @@ static int cpufreq_add_policy_cpu(unsign
>         }
>
>         /* Don't touch sysfs links during light-weight init */
> -       if (frozen) {
> -               /* Drop the extra refcount that we took above */
> -               cpufreq_cpu_put(policy);
> -               return 0;
> -       }
> -
> -       ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> -       if (ret)
> -               cpufreq_cpu_put(policy);
> +       if (!frozen)
> +               ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>
> +       cpufreq_cpu_put(policy);

And so this will go away.
