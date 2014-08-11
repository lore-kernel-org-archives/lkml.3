Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbaHKWPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:15:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59730 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaHKWPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:15:03 -0400
Message-ID: <53E94065.3020907@codeaurora.org>
Date: Mon, 11 Aug 2014 15:15:01 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4 4/5] cpufreq: Properly handle physical CPU hot-add/hot-remove
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org> <1406250448-470-5-git-send-email-skannan@codeaurora.org> <CAKohpokC_ufaGcMeEiaxUrduL+vLYSc2KzCPoR+Aj-CGYALYSg@mail.gmail.com>
In-Reply-To: <CAKohpokC_ufaGcMeEiaxUrduL+vLYSc2KzCPoR+Aj-CGYALYSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 04:02 AM, Viresh Kumar wrote:
> On 25 July 2014 06:37, Saravana Kannan <skannan@codeaurora.org> wrote:
>> When CPUs are physically added/removed, its cpuX sysfs directory is
>> dynamically added/removed. To handle this correctly, the cpufreq sysfs
>> nodes also need to be added/removed dynamically.
>
> Hmm, in that case why should we take this thread? I mean, if we do need
> to add/remove sysfs links or move kobjects around, what would we achieve
> with this patchset?

For the reasons mentioned in 3/5.
* Faster suspend/resume
* Faster hotplug
* Sysfs file permissions maintained across hotplug
* Policy settings and governor tunables maintained across hotplug
* Cpufreq stats would be maintained across hotplug for all CPUs and can
   be queried even after CPU goes OFFLINE

Also, logical hotplug happens way more often than physical hot-remove. 
Just because we need to do this during physical hot-remove doesn't mean 
we should do this all the time.

Btw, v5 will have another patch that should allow a lot of code reuse 
that won't be easy with symlink manipulation.

>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>> ---
>>   drivers/cpufreq/cpufreq.c | 46 +++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 33 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index d9fc6e5..97edf05 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -41,6 +41,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data_fallback);
>>   static DEFINE_RWLOCK(cpufreq_driver_lock);
>>   DEFINE_MUTEX(cpufreq_governor_lock);
>>   static LIST_HEAD(cpufreq_policy_list);
>> +static cpumask_t has_symlink;
>>
>>   /* This one keeps track of the previously set governor of a removed CPU */
>>   static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>> @@ -865,7 +866,10 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>>          unsigned int j;
>>          int ret = 0;
>>
>> -       for_each_cpu(j, policy->related_cpus) {
>> +       /* Only some of the related CPUs might be present. So, create
>> +        * symlinks only for those.
>> +        */
>
> Proper styles please.
>
>> +       for_each_cpu_and(j, policy->related_cpus, cpu_present_mask) {
>>                  struct device *cpu_dev;
>>
>>                  if (j == policy->kobj_cpu)
>> @@ -877,6 +881,7 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>>                                          "cpufreq");
>>                  if (ret)
>>                          break;
>> +               cpumask_set_cpu(j, &has_symlink);
>>          }
>>          return ret;
>>   }
>> @@ -1101,9 +1106,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>          unsigned long flags;
>>          bool recover_policy = cpufreq_suspended;
>>
>> -       if (cpu_is_offline(cpu))
>> -               return 0;
>> -
>
> Why?

So that when a CPU is physically hot-added again, we create the symlinks 
again.

>
>>          pr_debug("adding CPU %u\n", cpu);
>>
>>   #ifdef CONFIG_SMP
>> @@ -1111,7 +1113,19 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>           * CPU because it is in the same boat. */
>>          policy = cpufreq_cpu_get(cpu);
>>          if (policy) {
>> -               if (!cpumask_test_cpu(cpu, policy->cpus))
>> +               /* If a CPU gets physically plugged in after one or more of
>> +                * its related CPUs are ONLINE, we need to create a symlink
>> +                * for it since it wouldn't have been created when the policy
>> +                * was initialized. Do this as soon as it's plugged in.
>> +                */
>> +               if (sif && !cpumask_test_cpu(cpu, &has_symlink)) {
>
> Why check for sif?

sif is only set when this is called from hot-add/hot-remove context or 
cpufreq is registered for the first time.

>
>> +                       ret = sysfs_create_link(&dev->kobj, &policy->kobj,
>> +                                               "cpufreq");
>> +                       if (!ret)
>> +                               cpumask_set_cpu(cpu, &has_symlink);
>> +               }
>> +
>
> Move all this to cpufreq_add_policy_cpu()..

The code above is not for online CPUs. So, this can't be added to 
cpufreq_add_policy_cpu().

>
>> +               if (!cpumask_test_cpu(cpu, policy->cpus) && cpu_online(cpu))
>>                          ret = cpufreq_add_policy_cpu(policy, cpu, dev);
>>                  else
>>                          ret = 0;
>> @@ -1120,6 +1134,9 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>          }
>>   #endif
>>
>> +       if (cpu_is_offline(cpu))
>> +               return 0;
>> +
>
> Don't know why we moved it here.. cpufreq_add_dev will only be called for
> online CPUs..

As you said, I just moved it down here. If what you say was true, we 
wouldn't have needed this in the first place.

It's needed because __cpufreq_add_dev() is also called for a present, 
but offline CPU during cpufreq driver register.

>
>>          if (!down_read_trylock(&cpufreq_rwsem))
>>                  return 0;
>>
>> @@ -1303,25 +1320,24 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
>>                                             unsigned int old_cpu)
>>   {
>>          struct device *cpu_dev;
>> +       unsigned int new_cpu;
>>          int ret;
>>
>>          /* first sibling now owns the new sysfs dir */
>> -       cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));
>> +       for_each_cpu_and(new_cpu, policy->related_cpus, cpu_present_mask)
>> +               if (new_cpu != old_cpu)
>> +                       break;
>> +       cpu_dev = get_cpu_device(new_cpu);
>>
>>          sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
>>          ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
>>          if (ret) {
>>                  pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
>> -
>> -               down_write(&policy->rwsem);
>> -               cpumask_set_cpu(old_cpu, policy->cpus);
>> -               up_write(&policy->rwsem);
>> -
>>                  ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>>                                          "cpufreq");
>> -
>>                  return -EINVAL;
>>          }
>> +       cpumask_clear_cpu(new_cpu, &has_symlink);
>>          policy->kobj_cpu = cpu_dev->id;
>>
>>          return cpu_dev->id;
>> @@ -1407,8 +1423,12 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>>          cpus = cpumask_weight(policy->cpus);
>>          up_read(&policy->rwsem);
>>
>> -       if (cpu != policy->kobj_cpu)
>> +       if (cpu != policy->kobj_cpu) {
>>                  sysfs_remove_link(&dev->kobj, "cpufreq");
>> +               cpumask_clear_cpu(cpu, &has_symlink);
>> +       } else {
>> +               cpufreq_nominate_new_policy_cpu(policy, cpu);
>> +       }
>
> This has_symlink thing has made it much more complicated..

Actually, I disagree. No, convoluted deduction of what condition this is 
getting called under, etc. It's pretty simple -- if symlink is present, 
the bit is set; else, it's not set.

Btw, I could have make this similar to policy->related_cpus and 
policy->cpus and it might have looked "simpler". But no point in having 
multiple cpumasks when we are just tracking the global presence of symlinks.

Also, whether it's convoluted or not, it's definitely an improvement 
over removing and adding these all the time.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
