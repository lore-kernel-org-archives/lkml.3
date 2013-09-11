Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3IKKoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:44:37 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:41518 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab3IKKof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <52304439.3030301@linux.vnet.ibm.com>
References: <522E1FEF.6080803@wwwdotorg.org>
	<1775778.MeiRhuYy7o@vostro.rjw.lan>
	<522F86AD.6010603@wwwdotorg.org>
	<2521560.SfeNbV74nj@vostro.rjw.lan>
	<52304439.3030301@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 16:14:34 +0530
Message-ID: <CAKohpokTVzikxunqSdUYmLjTOkfhWFJ=N4TTa4rdbj2euCFY-g@mail.gmail.com>
Subject: Re: cpufreq_stats NULL deref on second system suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2013 15:51, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 09/11/2013 04:04 AM, Rafael J. Wysocki wrote:
>> On Tuesday, September 10, 2013 02:53:01 PM Stephen Warren wrote:

>>> Sure, it's due to 5302c3f "cpufreq: Perform light-weight init/teardown
>>> during suspend/resume".

Sorry Stephen, I was away on vacations and came back yesterday only..
And was badly stuck in something other CPUFreq bugs until now :)

> Sure, Rafael. Thanks for CC'ing me.

Thanks for jumping in and helping us out buddy!!!.

> Stephen, I went through the code and I think I found out what is going wrong.
> Can you please try the following patch?
>
> Regards,
> Srivatsa S. Bhat
>
> ----------------------------------------------------------------------------
>
>
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] cpufreq: Fix crash in cpufreq-stats during suspend/resume
>
> Stephen Warren reported that the cpufreq-stats code hits a NULL pointer
> dereference during the second attempt to suspend a system. He also
> pin-pointed the problem to commit 5302c3f "cpufreq: Perform light-weight
> init/teardown during suspend/resume".
>
> That commit actually ensured that the cpufreq-stats table and the
> cpufreq-stats sysfs entries are *not* torn down (ie., not freed) during
> suspend/resume, which makes it all the more surprising. However, it turns
> out that the root-cause is not that we access an already freed memory, but
> that the reference to the allocated memory gets moved around and we lose
> track of that during resume, leading to the reported crash in a subsequent
> suspend attempt.
>
> In the suspend path, during CPU offline, the value of policy->cpu is updated
> by choosing one of the surviving CPUs in that policy, as long as there is
> atleast one CPU in that policy. And cpufreq_stats_update_policy_cpu() is
> invoked to update the reference to the stats structure by assigning it to
> the new CPU. However, in the resume path, during CPU online, we end up
> assigning a fresh CPU as the policy->cpu, without letting cpufreq-stats
> know about this. Thus the reference to the stats structure remains
> (incorrectly) associated with the old CPU. So, in a subsequent suspend attempt,
> during CPU offline, we end up accessing an incorrect location to get the
> stats structure, which eventually leads to the NULL pointer dereference.
>
> Fix this by letting cpufreq-stats know about the update of the policy->cpu
> during CPU online in the resume path. (Also, move the update_policy_cpu()
> function higher up in the file, so that __cpufreq_add_dev() can invoke
> it).

Observation looks good..

> Reported-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/cpufreq.c |   37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 5a64f66..62bdb95 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -947,6 +947,18 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
>         kfree(policy);
>  }
>
> +static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
> +{
> +       policy->last_cpu = policy->cpu;
> +       policy->cpu = cpu;
> +
> +#ifdef CONFIG_CPU_FREQ_TABLE
> +       cpufreq_frequency_table_update_policy_cpu(policy);
> +#endif
> +       blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> +                       CPUFREQ_UPDATE_POLICY_CPU, policy);
> +}
> +
>  static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>                              bool frozen)
>  {
> @@ -1000,7 +1012,18 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>         if (!policy)
>                 goto nomem_out;
>
> -       policy->cpu = cpu;
> +
> +       /*
> +        * In the resume path, since we restore a saved policy, the assignment
> +        * to policy->cpu is like an update of the existing policy, rather than
> +        * the creation of a brand new one. So we need to perform this update
> +        * by invoking update_policy_cpu().
> +        */
> +       if (frozen && cpu != policy->cpu)
> +               update_policy_cpu(policy, cpu);
> +       else
> +               policy->cpu = cpu;
> +
>         policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
>         cpumask_copy(policy->cpus, cpumask_of(cpu));
>
> @@ -1092,18 +1115,6 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>         return __cpufreq_add_dev(dev, sif, false);
>  }
>
> -static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
> -{
> -       policy->last_cpu = policy->cpu;
> -       policy->cpu = cpu;
> -
> -#ifdef CONFIG_CPU_FREQ_TABLE
> -       cpufreq_frequency_table_update_policy_cpu(policy);
> -#endif
> -       blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
> -                       CPUFREQ_UPDATE_POLICY_CPU, policy);
> -}
> -

But I would have solved it differently :)

We don't really need to call update_policy_cpu() again and again
as we don't really need to update policy->cpu...

Rather it would be better to just move following inside
cpufreq_policy_alloc():
