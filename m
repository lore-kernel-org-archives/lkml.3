Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaGPUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:25:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36490 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaGPUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:25:21 -0400
Message-ID: <53C6DFAD.8030109@codeaurora.org>
Date: Wed, 16 Jul 2014 13:25:17 -0700
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
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org> <1405464473-3916-2-git-send-email-skannan@codeaurora.org> <CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>
In-Reply-To: <CAKohpok2hzwDLy77CZJ+7pHV-Nj4XTviJxVeXQYJRYtKXME00w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 01:24 AM, Viresh Kumar wrote:
> On 16 July 2014 04:17, Saravana Kannan <skannan@codeaurora.org> wrote:
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>
>> +/* symlink related CPUs */
>> +static int cpufreq_dev_symlink(struct cpufreq_policy *policy, bool add)
>>   {
>> -       unsigned int j;
>> +       unsigned int j, first_cpu = cpumask_first(policy->related_cpus);
>
> The CPU which came first should get the ownership by default, instead
> of the first one in the mask.
>
> Normally at boot, all CPUs come up first and then only cpufreq init starts.
> But in case all other CPUs fail to come up, then policy->cpu *might* point
> to a failed cpu.
>
> And so, we should simply use policy->cpu here instead of finding the
> first one in the mask.
>

Replied to this in a different email.

> Also, its not the duty of this routine to find which one is the policy cpu as
> that is done by __cpufreq_add_dev(). And so in case we need to make
> first cpu of a mask as policy->cpu, it should be done in __cpufreq_add_dev()
> and not here. This one should just follow the orders :)

This is a new function. And that split up might have made sense earlier. 
But not so much anymore since I'm sharing a lot of code between 
__cpufreq_add_dev() and __cpufreq_remove_dev(). There's not reason to 
stick with the previous split of up work if it doesn't apply well anymore.

Please give this a second thought. Maybe it'll make more sense after I 
split this up into smaller patches.

>
> @Srivatsa: What happens to the sysfs directory if a CPU fails to come up?
> Is it exactly similar to how it happens in hotplug? i.e. we do have a directory
> there?
>
>>          int ret = 0;
>>
>> -       for_each_cpu(j, policy->cpus) {
>> +       for_each_cpu(j, policy->related_cpus) {
>>                  struct device *cpu_dev;
>>
>> -               if (j == policy->cpu)
>> +               if (j == first_cpu)
>>                          continue;
>>
>> -               pr_debug("Adding link for CPU: %u\n", j);
>
> Keep this please, it might be useful while debugging.

Reluctant ok. We don't add/remove these files anymore in a common 
scenario. So, it's not going to be very helpful. I'll also have to do a 
add ? Add : Remove blurb for the print.

>
>>                  cpu_dev = get_cpu_device(j);
>> -               ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>> -                                       "cpufreq");
>> +               if (add)
>> +                       ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>> +                                               "cpufreq");
>> +               else
>> +                       sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
>> +
>>                  if (ret)
>>                          break;
>>          }
>>          return ret;
>>   }
>>
>> -static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
>> -                                    struct device *dev)
>> +static int cpufreq_add_dev_interface(struct cpufreq_policy *policy)
>>   {
>>          struct freq_attr **drv_attr;
>> +       struct device *dev;
>>          int ret = 0;
>>
>> +       dev = get_cpu_device(cpumask_first(policy->related_cpus));
>> +       if (!dev)
>> +               return -EINVAL;
>
> Again, deciding which cpu is policy->cpu here is wrong. Just follow
> orders of __cpufreq_add_dev().

But that's not what I'm doing here?

>>          /* prepare interface data */
>>          ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
>>                                     &dev->kobj, "cpufreq");
>> @@ -917,7 +923,7 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
>>                          goto err_out_kobj_put;
>>          }
>>
>> -       ret = cpufreq_add_dev_symlink(policy);
>> +       ret = cpufreq_dev_symlink(policy, true);
>>          if (ret)
>>                  goto err_out_kobj_put;
>>
>> @@ -961,60 +967,58 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
>>   }
>>
>>   #ifdef CONFIG_HOTPLUG_CPU
>
> @Srivatsa: I will try this but you also take care of this. These
> ifdefs might go wrong,
> i.e. we are surely using it in the current patch without HOTPLUG as well. See
> cpufreq_add_dev()..
>
> Also, how does suspend/resume work without CONFIG_HOTPLUG_CPU ?
> What's the sequence of events?
>
>> -static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>> -                                 unsigned int cpu, struct device *dev)
>> +static int cpufreq_change_policy_cpus(struct cpufreq_policy *policy,
>> +                                 unsigned int cpu, bool add)
>>   {
>>          int ret = 0;
>> -       unsigned long flags;
>> +       unsigned int cpus, pcpu;
>>
>> -       if (has_target()) {
>> +       down_write(&policy->rwsem);
>> +
>> +       cpus = !cpumask_empty(policy->cpus);
>
> We aren't using cpus at multiple places and so probably it would
> be better to using cpumask_empty() directly.
>
>> +       if (has_target() && cpus) {
>
> I may get the answer later in reviews, but when will cpus be 0 here?
> Probably for non-boot cluster during suspend/resume, or forceful
> hotplugging off all CPUs of a cluster. Right?

Yup!

>
>>                  ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>>                  if (ret) {
>>                          pr_err("%s: Failed to stop governor\n", __func__);
>> -                       return ret;
>> +                       goto unlock;
>>                  }
>>          }
>>
>> -       down_write(&policy->rwsem);
>> -
>> -       write_lock_irqsave(&cpufreq_driver_lock, flags);
>> -
>> -       cpumask_set_cpu(cpu, policy->cpus);
>> -       per_cpu(cpufreq_cpu_data, cpu) = policy;
>> -       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> +       if (add)
>> +               cpumask_set_cpu(cpu, policy->cpus);
>> +       else
>> +               cpumask_clear_cpu(cpu, policy->cpus);
>>
>> -       up_write(&policy->rwsem);
>> +       pcpu = cpumask_first(policy->cpus);
>> +       if (pcpu < nr_cpu_ids && policy->cpu != pcpu) {
>
> No, we don't have to consider changing policy->cpu for every change
> in policy->cpus. We need to do that only when policy->cpu goes down.

Ok, I agree I could improve the check to reduce the unnecessary 
notification even more.

> Also pcpu can't be < nr_cpu_ids, right?

This is for the case when all CPUs in a cluster have been taken down. We 
don't want to send the notifier at that point. When the mask is empty, 
the function returns a value >= nr_cpu_ids to indicate an error.

>
>> +               policy->last_cpu = policy->cpu;
>> +               policy->cpu = pcpu;
>> +               blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>> +                                       CPUFREQ_UPDATE_POLICY_CPU, policy);
>> +       }
>>
>> -       if (has_target()) {
>> +       cpus = !cpumask_empty(policy->cpus);
>> +       if (has_target() && cpus) {
>>                  ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
>>                  if (!ret)
>>                          ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>>
>>                  if (ret) {
>>                          pr_err("%s: Failed to start governor\n", __func__);
>> -                       return ret;
>> +                       goto unlock;
>>                  }
>>          }
>>
>> -       return sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
>> -}
>> -#endif
>> -
>> -static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
>> -{
>> -       struct cpufreq_policy *policy;
>> -       unsigned long flags;
>> -
>> -       read_lock_irqsave(&cpufreq_driver_lock, flags);
>> -
>> -       policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
>> -
>> -       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> +       if (!cpus && cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
>
> As I commented on V1, please make it else part of above if..
>
>> +               cpufreq_driver->stop_cpu(policy);
>> +       }
>>
>> -       policy->governor = NULL;
>> +unlock:
>> +       up_write(&policy->rwsem);
>>
>> -       return policy;
>> +       return ret;
>>   }
>> +#endif
>>
>>   static struct cpufreq_policy *cpufreq_policy_alloc(void)
>>   {
>> @@ -1053,10 +1057,8 @@ static void cpufreq_policy_put_kobj(struct cpufreq_policy *policy)
>>          blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>>                          CPUFREQ_REMOVE_POLICY, policy);
>>
>> -       down_read(&policy->rwsem);
>>          kobj = &policy->kobj;
>>          cmp = &policy->kobj_unregister;
>> -       up_read(&policy->rwsem);
>
> Why? And also, these are unrelated changes and must be added as separate
> commits.

This is because we call this with policy rwsem read lock held and 
lockdep throws a warning. So, it's related to this patch.

>
>>          kobject_put(kobj);
>>
>>          /*
>> @@ -1076,32 +1078,12 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
>>          kfree(policy);
>>   }
>>
>> -static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>> -{
>> -       if (WARN_ON(cpu == policy->cpu))
>> -               return;
>> -
>> -       down_write(&policy->rwsem);
>> -
>> -       policy->last_cpu = policy->cpu;
>> -       policy->cpu = cpu;
>> -
>> -       up_write(&policy->rwsem);
>> -
>> -       blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>> -                       CPUFREQ_UPDATE_POLICY_CPU, policy);
>> -}
>> -
>>   static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>   {
>>          unsigned int j, cpu = dev->id;
>>          int ret = -ENOMEM;
>>          struct cpufreq_policy *policy;
>>          unsigned long flags;
>> -       bool recover_policy = cpufreq_suspended;
>> -#ifdef CONFIG_HOTPLUG_CPU
>> -       struct cpufreq_policy *tpolicy;
>> -#endif
>>
>>          if (cpu_is_offline(cpu))
>>                  return 0;
>> @@ -1110,9 +1092,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>
>>   #ifdef CONFIG_SMP
>>          /* check whether a different CPU already registered this
>> -        * CPU because it is in the same boat. */
>> +        * CPU because it is one of the related CPUs. */
>>          policy = cpufreq_cpu_get(cpu);
>> -       if (unlikely(policy)) {
>> +       if (policy) {
>> +               cpufreq_change_policy_cpus(policy, cpu, true);
>
> This is just a waste of time at boot as ... (see below)

Why? Please explain.

>
>>                  cpufreq_cpu_put(policy);
>>                  return 0;
>>          }
>> @@ -1121,45 +1104,14 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
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
>> -
>> -       /*
>> -        * Restore the saved policy when doing light-weight init and fall back
>> -        * to the full init if that fails.
>> -        */
>> -       policy = recover_policy ? cpufreq_policy_restore(cpu) : NULL;
>> -       if (!policy) {
>> -               recover_policy = false;
>> -               policy = cpufreq_policy_alloc();
>> -               if (!policy)
>> -                       goto nomem_out;
>> -       }
>> -
>> -       /*
>> -        * In the resume path, since we restore a saved policy, the assignment
>> -        * to policy->cpu is like an update of the existing policy, rather than
>> -        * the creation of a brand new one. So we need to perform this update
>> -        * by invoking update_policy_cpu().
>> -        */
>> -       if (recover_policy && cpu != policy->cpu)
>> -               update_policy_cpu(policy, cpu);
>> -       else
>> -               policy->cpu = cpu;
>> +       /* If we get this far, this is the first time we are adding the
>> +        * policy */
>> +       policy = cpufreq_policy_alloc();
>> +       if (!policy)
>> +               goto nomem_out;
>> +       policy->cpu = cpu;
>>
>>          cpumask_copy(policy->cpus, cpumask_of(cpu));
>> -
>>          init_completion(&policy->kobj_unregister);
>>          INIT_WORK(&policy->update, handle_update);
>>
>> @@ -1169,26 +1121,25 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>          ret = cpufreq_driver->init(policy);
>>          if (ret) {
>>                  pr_debug("initialization failed\n");
>> -               goto err_set_policy_cpu;
>> +               goto err_init;
>>          }
>>
>>          /* related cpus should atleast have policy->cpus */
>>          cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
>
> policy->cpus is already updated here.
>
>> +       /* Weed out impossible CPUs. */
>> +       cpumask_and(policy->related_cpus, policy->related_cpus,
>> +                       cpu_possible_mask);
>
> This has to be in a separate commit..

I meant to remove this based on your previous comment that it's the 
responsibility of the driver to pass only possible CPUs. Forgot. Will do.

>
>>          /*
>>           * affected cpus must always be the one, which are online. We aren't
>>           * managing offline cpus here.
>>           */
>>          cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
>>
>> -       if (!recover_policy) {
>> -               policy->user_policy.min = policy->min;
>> -               policy->user_policy.max = policy->max;
>> -       }
>> -
>
> Where did these go? There weren't there for fun.

We are keeping the policy intact. So, why would this be needed anymore?

>
>>          down_write(&policy->rwsem);
>>          write_lock_irqsave(&cpufreq_driver_lock, flags);
>> -       for_each_cpu(j, policy->cpus)
>> +       for_each_cpu(j, policy->related_cpus)
>>                  per_cpu(cpufreq_cpu_data, j) = policy;
>>          write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>>
>> @@ -1243,13 +1194,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>          blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>>                                       CPUFREQ_START, policy);
>>
>> -       if (!recover_policy) {
>> -               ret = cpufreq_add_dev_interface(policy, dev);
>> -               if (ret)
>> -                       goto err_out_unregister;
>> -               blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>> -                               CPUFREQ_CREATE_POLICY, policy);
>> -       }
>> +       ret = cpufreq_add_dev_interface(policy);
>> +       if (ret)
>> +               goto err_out_unregister;
>> +       blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>> +                       CPUFREQ_CREATE_POLICY, policy);
>>
>>          write_lock_irqsave(&cpufreq_driver_lock, flags);
>>          list_add(&policy->policy_list, &cpufreq_policy_list);
>> @@ -1257,10 +1206,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>
>>          cpufreq_init_policy(policy);
>>
>> -       if (!recover_policy) {
>> -               policy->user_policy.policy = policy->policy;
>> -               policy->user_policy.governor = policy->governor;
>> -       }
>
> Same here.

Same here. We are keeping the policy intact. So, not needed?

>
>>          up_write(&policy->rwsem);
>>
>>          kobject_uevent(&policy->kobj, KOBJ_ADD);
>> @@ -1273,20 +1218,14 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>   err_out_unregister:
>>   err_get_freq:
>>          write_lock_irqsave(&cpufreq_driver_lock, flags);
>> -       for_each_cpu(j, policy->cpus)
>> +       for_each_cpu(j, policy->related_cpus)
>>                  per_cpu(cpufreq_cpu_data, j) = NULL;
>>          write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> -
>> +       up_write(&policy->rwsem);
>>          if (cpufreq_driver->exit)
>>                  cpufreq_driver->exit(policy);
>> -err_set_policy_cpu:
>> -       if (recover_policy) {
>> -               /* Do not leave stale fallback data behind. */
>> -               per_cpu(cpufreq_cpu_data_fallback, cpu) = NULL;
>> -               cpufreq_policy_put_kobj(policy);
>> -       }
>> +err_init:
>>          cpufreq_policy_free(policy);
>> -
>>   nomem_out:
>>          up_read(&cpufreq_rwsem);
>>
>
> Just to mention, I am not looking at the validity of error fallback paths
> in this version. Just make sure they are all good :)

Will do. And even if it's broken, I'll fix it in a separate patch :)


>> @@ -1307,100 +1246,16 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>>          return __cpufreq_add_dev(dev, sif);
>>   }
>>
>> -static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
>> -                                          unsigned int old_cpu)
>> -{
>> -       struct device *cpu_dev;
>> -       int ret;
>> -
>> -       /* first sibling now owns the new sysfs dir */
>> -       cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));
>> -
>> -       sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
>> -       ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
>> -       if (ret) {
>> -               pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
>> -
>> -               down_write(&policy->rwsem);
>> -               cpumask_set_cpu(old_cpu, policy->cpus);
>> -               up_write(&policy->rwsem);
>> -
>> -               ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
>> -                                       "cpufreq");
>> -
>> -               return -EINVAL;
>> -       }
>> -
>> -       return cpu_dev->id;
>> -}
>> -
>> -static int __cpufreq_remove_dev_prepare(struct device *dev,
>> -                                       struct subsys_interface *sif)
>> +static int __cpufreq_remove_dev(struct device *dev,
>> +                               struct subsys_interface *sif)
>>   {
>> -       unsigned int cpu = dev->id, cpus;
>> -       int new_cpu, ret;
>> +       unsigned int cpu = dev->id, j;
>> +       int ret = 0;
>>          unsigned long flags;
>>          struct cpufreq_policy *policy;
>>
>>          pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
>>
>> -       write_lock_irqsave(&cpufreq_driver_lock, flags);
>> -
>> -       policy = per_cpu(cpufreq_cpu_data, cpu);
>> -
>> -       /* Save the policy somewhere when doing a light-weight tear-down */
>> -       if (cpufreq_suspended)
>> -               per_cpu(cpufreq_cpu_data_fallback, cpu) = policy;
>> -
>> -       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> -
>> -       if (!policy) {
>> -               pr_debug("%s: No cpu_data found\n", __func__);
>> -               return -EINVAL;
>> -       }
>> -
>> -       if (has_target()) {
>> -               ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>> -               if (ret) {
>> -                       pr_err("%s: Failed to stop governor\n", __func__);
>> -                       return ret;
>> -               }
>> -       }
>> -
>> -       if (!cpufreq_driver->setpolicy)
>> -               strncpy(per_cpu(cpufreq_cpu_governor, cpu),
>> -                       policy->governor->name, CPUFREQ_NAME_LEN);
>
> Where is this gone? There are several instances of code just being
> removed, this is the third one. Its really really tough to catch these
> in this big of a patch. Believe me.
>
> You have to break this patch into multiple ones, see this on how to
> break even simplest of the changes into multiple patches:
> https://lkml.org/lkml/2013/9/6/400
>
> Its just impossible to catch bugs that you might have introduced here due
> to the size of this patch. And its taking a LOT of time for me to review this.
> As I have to keep diff in one tab, new cpufreq.c in one and the old cpufreq.c
> in one and then compare..

Will do. With Srivatsa point about just making sure every patch 
compiles, it should be easy to break it up. But to answer your original 
question, it's again not needed to save/restore since we don't destroy it.

>
>> -       down_read(&policy->rwsem);
>> -       cpus = cpumask_weight(policy->cpus);
>> -       up_read(&policy->rwsem);
>> -
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
>> -               }
>> -       } else if (cpufreq_driver->stop_cpu && cpufreq_driver->setpolicy) {
>> -               cpufreq_driver->stop_cpu(policy);
>> -       }
>> -
>> -       return 0;
>> -}
>> -
>> -static int __cpufreq_remove_dev_finish(struct device *dev,
>> -                                      struct subsys_interface *sif)
>> -{
>> -       unsigned int cpu = dev->id, cpus;
>> -       int ret;
>> -       unsigned long flags;
>> -       struct cpufreq_policy *policy;
>> -
>>          read_lock_irqsave(&cpufreq_driver_lock, flags);
>>          policy = per_cpu(cpufreq_cpu_data, cpu);
>>          read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> @@ -1410,56 +1265,45 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>>                  return -EINVAL;
>>          }
>>
>> -       down_write(&policy->rwsem);
>> -       cpus = cpumask_weight(policy->cpus);
>> -
>> -       if (cpus > 1)
>> -               cpumask_clear_cpu(cpu, policy->cpus);
>> -       up_write(&policy->rwsem);
>> -
>> -       /* If cpu is last user of policy, free policy */
>> -       if (cpus == 1) {
>> -               if (has_target()) {
>> -                       ret = __cpufreq_governor(policy,
>> -                                       CPUFREQ_GOV_POLICY_EXIT);
>> -                       if (ret) {
>> -                               pr_err("%s: Failed to exit governor\n",
>> -                                      __func__);
>> -                               return ret;
>> -                       }
>> -               }
>> -
>> -               if (!cpufreq_suspended)
>> -                       cpufreq_policy_put_kobj(policy);
>> +#ifdef CONFIG_HOTPLUG_CPU
>> +       ret = cpufreq_change_policy_cpus(policy, cpu, false);
>> +#endif
>> +       if (ret)
>> +               return ret;
>
> Why is the if block kept outside of #ifdef? And should we really call
> change_*() from inside a #ifdef here?

Yeah, it can be inside.

>
>>
>> -               /*
>> -                * Perform the ->exit() even during light-weight tear-down,
>> -                * since this is a core component, and is essential for the
>> -                * subsequent light-weight ->init() to succeed.
>> -                */
>> -               if (cpufreq_driver->exit)
>> -                       cpufreq_driver->exit(policy);
>> +       if (!sif)
>> +               return 0;
>
> Why? I know that, but we should have comments to describe this ...

Will do.

>
>>
>> -               /* Remove policy from list of active policies */
>> -               write_lock_irqsave(&cpufreq_driver_lock, flags);
>> -               list_del(&policy->policy_list);
>> -               write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> +       if (!cpumask_empty(policy->cpus)) {
>> +               return 0;
>> +       }
>
> You might still call this attempt a showcase of idea, but I am reviewing it
> at my full capacity.

Oh, at this point this is not an RFC at all. I want it merged. So, 
that's for the thorough review.

> And these small things just break my flow.
>
> - Don't add {} for single liner blocks
> - Add comments with proper comment style
> - Run checkpatch --strict before sending patches.

Will do.

>
>>
>> -               if (!cpufreq_suspended)
>> -                       cpufreq_policy_free(policy);
>> -       } else if (has_target()) {
>> -               ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
>> -               if (!ret)
>> -                       ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>> +       cpufreq_dev_symlink(policy, false);
>>
>> +       if (has_target()) {
>> +               ret = __cpufreq_governor(policy,
>> +                               CPUFREQ_GOV_POLICY_EXIT);
>
> Can come in single line
>
>>                  if (ret) {
>> -                       pr_err("%s: Failed to start governor\n", __func__);
>> +                       pr_err("%s: Failed to exit governor\n",
>> +                              __func__);
>
> This too..
>
>>                          return ret;
>>                  }
>>          }
>>
>> -       per_cpu(cpufreq_cpu_data, cpu) = NULL;
>> -       return 0;
>> +       cpufreq_policy_put_kobj(policy);
>> +       if (cpufreq_driver->exit)
>> +               cpufreq_driver->exit(policy);
>> +
>> +       /* Remove policy from list of active policies */
>> +       write_lock_irqsave(&cpufreq_driver_lock, flags);
>> +       for_each_cpu(j, policy->related_cpus)
>> +               per_cpu(cpufreq_cpu_data, j) = NULL;
>> +       list_del(&policy->policy_list);
>> +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>> +
>> +       cpufreq_policy_free(policy);
>> +
>> +       return ret;
>>   }
>>
>>   /**
>> @@ -1469,18 +1313,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
>>    */
>>   static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
>>   {
>> -       unsigned int cpu = dev->id;
>> -       int ret;
>> -
>> -       if (cpu_is_offline(cpu))
>> -               return 0;
>
> Why is it part of this commit?

Which part? Just removing the offline check? I should move it to 2/2 (or 
the split ups of it) probably.

>
>> -       ret = __cpufreq_remove_dev_prepare(dev, sif);
>> -
>> -       if (!ret)
>> -               ret = __cpufreq_remove_dev_finish(dev, sif);
>> -
>> -       return ret;
>> +       return __cpufreq_remove_dev(dev, sif);
>>   }
>>
>>   static void handle_update(struct work_struct *work)
>> @@ -2295,19 +2128,12 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
>>          if (dev) {
>>                  switch (action & ~CPU_TASKS_FROZEN) {
>>                  case CPU_ONLINE:
>> +               case CPU_DOWN_FAILED:
>
> For example. This change doesn't have anything to do with this patch
> and would have been so easy to review it, if it was kept separate.
>
> Also, this would even require to wait for this complete series to make
> sense and can be merged very early.

Ok

>
>>                          __cpufreq_add_dev(dev, NULL);
>>                          break;
>>
>>                  case CPU_DOWN_PREPARE:
>> -                       __cpufreq_remove_dev_prepare(dev, NULL);
>> -                       break;
>> -
>> -               case CPU_POST_DEAD:
>> -                       __cpufreq_remove_dev_finish(dev, NULL);
>> -                       break;
>> -
>> -               case CPU_DOWN_FAILED:
>> -                       __cpufreq_add_dev(dev, NULL);
>> +                       __cpufreq_remove_dev(dev, NULL);
>
> @Srivatsa: You might want to have a look at this, remove sequence was
> separated for some purpose and I am just not able to concentrate enough
> to think of that, just too many cases running in my mind :)
>
>>                          break;
>>                  }
>>          }
>
> I am still not sure if everything will work as expected as I seriously doubt
> my reviewing capabilities. There might be corner cases which I am still
> missing.
>

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
