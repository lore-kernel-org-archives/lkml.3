Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaHKWNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:13:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59506 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaHKWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:13:07 -0400
Message-ID: <53E93FF1.1010809@codeaurora.org>
Date: Mon, 11 Aug 2014 15:13:05 -0700
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
Subject: Re: [PATCH v4 3/5] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org> <1406250448-470-4-git-send-email-skannan@codeaurora.org> <CAKohpom-+At=YjEkZH-mn8OP1ATDBzuLw7mTPaUnG+1qvJ8FTA@mail.gmail.com>
In-Reply-To: <CAKohpom-+At=YjEkZH-mn8OP1ATDBzuLw7mTPaUnG+1qvJ8FTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 03:48 AM, Viresh Kumar wrote:
> On 25 July 2014 06:37, Saravana Kannan <skannan@codeaurora.org> wrote:
>> This patch simplifies a lot of the hotplug/suspend code by not
>> adding/removing/moving the policy/sysfs/kobj during hotplug and just leaves
>> the cpufreq directory and policy in place irrespective of whether the CPUs
>> are ONLINE/OFFLINE.
>>
>> Leaving the policy, sysfs and kobject in place also brings these additional
>> benefits:
>> * Faster suspend/resume
>> * Faster hotplug
>> * Sysfs file permissions maintained across hotplug
>> * Policy settings and governor tunables maintained across hotplug
>> * Cpufreq stats would be maintained across hotplug for all CPUs and can be
>>    queried even after CPU goes OFFLINE
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>> ---
>>   drivers/cpufreq/cpufreq.c | 83 ++++++++++++++++-------------------------------
>>   1 file changed, 28 insertions(+), 55 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index af4f291..d9fc6e5 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -865,7 +865,7 @@ static int cpufreq_add_dev_symlink(struct cpufreq_policy *policy)
>>          unsigned int j;
>>          int ret = 0;
>>
>> -       for_each_cpu(j, policy->cpus) {
>> +       for_each_cpu(j, policy->related_cpus) {
>>                  struct device *cpu_dev;
>>
>>                  if (j == policy->kobj_cpu)
>> @@ -968,7 +968,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>>          int ret = 0;
>>          unsigned long flags;
>>
>> -       if (has_target()) {
>> +       if (cpumask_weight(policy->cpus) && has_target()) {
>
> Probably cpumask_empty() would be more readable here.

Agreed.

>
>>                  ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>>                  if (ret) {
>>                          pr_err("%s: Failed to stop governor\n", __func__);
>> @@ -997,7 +997,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>>                  }
>>          }
>>
>> -       return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>> +       return 0;
>>   }
>>   #endif
>>
>> @@ -1100,9 +1100,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>          struct cpufreq_policy *policy;
>>          unsigned long flags;
>>          bool recover_policy = cpufreq_suspended;
>> -#ifdef CONFIG_HOTPLUG_CPU
>> -       struct cpufreq_policy *tpolicy;
>> -#endif
>>
>>          if (cpu_is_offline(cpu))
>>                  return 0;
>> @@ -1113,28 +1110,22 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>          /* check whether a different CPU already registered this
>>           * CPU because it is in the same boat. */
>>          policy = cpufreq_cpu_get(cpu);
>> -       if (unlikely(policy)) {
>> +       if (policy) {
>> +               if (!cpumask_test_cpu(cpu, policy->cpus))
>> +                       ret = cpufreq_add_policy_cpu(policy, cpu, dev);
>> +               else
>> +                       ret = 0;
>>                  cpufreq_cpu_put(policy);
>> -               return 0;
>> +               return ret;
>>          }
>>   #endif
>>
>>          if (!down_read_trylock(&cpufreq_rwsem))
>>                  return 0;
>>
>> -#ifdef CONFIG_HOTPLUG_CPU
>> -       /* Check if this cpu was hot-unplugged earlier and has siblings */
>> -       read_lock_irqsave(&cpufreq_driver_lock, flags);
>> -       list_for_each_entry(tpolicy, &cpufreq_policy_list, policy_list) {
>> -               if (cpumask_test_cpu(cpu, tpolicy->related_cpus)) {
>> -                       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> -                       ret = cpufreq_add_policy_cpu(tpolicy, cpu, dev);
>> -                       up_read(&cpufreq_rwsem);
>> -                       return ret;
>> -               }
>> -       }
>> -       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> -#endif
>> +       /* If we get this far, this is the first time we are adding the
>> +        * policy */
>
> I think I have already asked you to use proper comment style?

I did. Then I think I noticed some of the existing comments did keep the 
/* in its own line even for multiline comments. So, I got confused. Will 
fix.

>
>> +       recover_policy = false;
>
> For this patch, probably it will work fine but I hope you will get rid of
> this variable completely in next patches..
>

Yup. In 5/5

>
>> @@ -1340,21 +1331,15 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>>                                          struct subsys_interface *sif)
>>   {
>>          unsigned int cpu = dev->id, cpus;
>> -       int new_cpu, ret;
>> +       int new_cpu, ret = 0;
>
> Why?

Apparently for no good reason :) Probably some stale change when I was 
splitting up the patches. I'll double check and remove this.


>>          unsigned long flags;
>>          struct cpufreq_policy *policy;
>>
>>          pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
>>
>> -       write_lock_irqsave(&cpufreq_driver_lock, flags);
>> -
>> +       read_lock_irqsave(&cpufreq_driver_lock, flags);
>>          policy = per_cpu(cpufreq_cpu_data, cpu);
>> -
>> -       /* Save the policy somewhere when doing a light-weight tear-down */
>> -       if (cpufreq_suspended)
>> -               per_cpu(cpufreq_cpu_data_fallback, cpu) = policy;
>> -
>> -       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> +       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>>
>>          if (!policy) {
>>                  pr_debug("%s: No cpu_data found\n", __func__);
>> @@ -1369,24 +1354,15 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>>                  }
>>          }
>>
>> -       if (!cpufreq_driver->setpolicy)
>> -               strncpy(per_cpu(cpufreq_cpu_governor, cpu),
>> -                       policy->governor->name, CPUFREQ_NAME_LEN);
>> -
>
> Why? Probably I did mention this earlier as well?

This code is saving the governor name here to restore it when the policy 
is created again after suspend/resume or hotplug of all CPUs. Since we 
no longer throw away the policy struct, there's no point in doing this.

I should remove this per cpu variable though. Will do it in v5.

>
>>          down_read(&policy->rwsem);
>>          cpus = cpumask_weight(policy->cpus);
>>          up_read(&policy->rwsem);
>>
>> -       if (cpu != policy->cpu) {
>> -               sysfs_remove_link(&dev->kobj, "cpufreq");
>> -       } else if (cpus > 1) {
>> -               new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
>> -               if (new_cpu >= 0) {
>> -                       update_policy_cpu(policy, new_cpu);
>> -
>> -                       if (!cpufreq_suspended)
>> -                               pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
>> -                                        __func__, new_cpu, cpu);
>> +       if (cpus > 1) {
>> +               if (cpu == policy->cpu) {
>> +                       new_cpu = cpumask_any_but(policy->cpus, cpu);
>> +                       if (new_cpu >= 0)
>
> Can this ever be false?

If this is the last CPU going down. This part of the code didn't really 
change. I just moved the cpumask_any_but() from nominate policy to here 
since I'm not longer moving the kobj around.

>
>> +                               update_policy_cpu(policy, new_cpu);
>>                  }
>>          } else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
>>                  cpufreq_driver->stop_cpu(policy);

>> @@ -1431,6 +1407,9 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>>          cpus = cpumask_weight(policy->cpus);
>>          up_read(&policy->rwsem);
>>
>> +       if (cpu != policy->kobj_cpu)
>> +               sysfs_remove_link(&dev->kobj, "cpufreq");
>> +
>
> Why?

For the physical hot-remove case or when the cpufreq driver is unregistered.

>
>>          /* If cpu is last user of policy, free policy */
>>          if (cpus == 0) {
>>                  if (has_target()) {
>> @@ -1475,12 +1454,10 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>>   static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
>>   {
>>          unsigned int cpu = dev->id;
>> -       int ret;
>> -
>> -       if (cpu_is_offline(cpu))
>> -               return 0;
>> +       int ret = 0;
>>
>> -       ret = __cpufreq_remove_dev_prepare(dev, sif);
>> +       if (cpu_online(cpu))
>> +               ret = __cpufreq_remove_dev_prepare(dev, sif);
>
> Why do you need a change here?

Since we no longer do remove_dev_finish during hotplug, we can't just 
short circuit the entire function. We have to finish the remove when the 
CPU is hot-removed or when the cpufreq driver is unregistered.

>
>>          if (!ret)
>>                  ret = __cpufreq_remove_dev_finish(dev, sif);
>> @@ -2307,10 +2284,6 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
>>                          __cpufreq_remove_dev_prepare(dev, NULL);
>>                          break;
>>
>> -               case CPU_POST_DEAD:
>> -                       __cpufreq_remove_dev_finish(dev, NULL);
>> -                       break;
>> -
>
> Sure? Who will call dev_finish() now?

At this point, all remove_dev_finish() does is remove the sysfs links 
and destroy the policy. So, it never needs to be called for hotplug. 
Only during physical hot-remove or during cpufreq driver unregister.

>
>>                  case CPU_DOWN_FAILED:
>>                          __cpufreq_add_dev(dev, NULL);
>>                          break;
>> --
>> 1.8.2.1
>>
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
>> hosted by The Linux Foundation

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
