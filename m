Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3GKFlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 01:41:04 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60254 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3GKFlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 01:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <51DDE067.2020106@linux.vnet.ibm.com>
References: <51C08370.4050906@gmx.de>
	<CAKohpok1gThXL925Yz5UgC54vTVQgymBA1cLGER_g-dgZu0JLA@mail.gmail.com>
	<51CF1E53.6060902@gmx.de>
	<8029836.CFiJCXmRQ0@vostro.rjw.lan>
	<51D05DF4.50704@linux.vnet.ibm.com>
	<51D06556.7080204@gmx.de>
	<51D07E7F.2030709@linux.vnet.ibm.com>
	<51DDC8FA.4020609@gmx.de>
	<51DDE067.2020106@linux.vnet.ibm.com>
Date: Thu, 11 Jul 2013 13:40:59 +0800
Message-ID: <CAOLK0pwr03reaMWAEeaUs-6H2URoisFEJ3J4r83Rm1eTs1hU5w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix cpufreq regression after suspend/resume
From: Lan Tianyu <lantianyu1986@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/11 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
> Hi Toralf,
>
> On 07/11/2013 02:20 AM, Toralf Förster wrote:
>> I tested the patch several times on top of a66b2e5 - the origin issue is
>> fixed but - erratically another issue now appears : all 4 cores are runs
>> after wakeup at 2.6 GHz.
>> The temporary hot fix is to switch between governor performance and
>> ondemand for all 4 cores.
>>
>>
>
> Thanks for all your testing efforts. The commit a66b2e5 took a shortcut to
> achieve its goals but failed subtly in many aspects. Below is a patch (only
> compile-tested) which tries to achieve the goal (preserve sysfs files) in
> the proper way, by separating out the cpufreq-core bits from the sysfs bits.
> You might want to give it a try on current mainline and see if it improves
> anything.
>
> Regards,
> Srivatsa S. Bhat
>
>
> (Applies on current mainline)
> ---
>
>  drivers/cpufreq/cpufreq.c |  144 ++++++++++++++++++++++++++-------------------
>  1 file changed, 82 insertions(+), 62 deletions(-)
>
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 6a015ad..28c690f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -834,11 +834,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
>                                      struct cpufreq_policy *policy,
>                                      struct device *dev)
>  {
> -       struct cpufreq_policy new_policy;
>         struct freq_attr **drv_attr;
> -       unsigned long flags;
>         int ret = 0;
> -       unsigned int j;
>
>         /* prepare interface data */
>         ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
> @@ -870,31 +867,10 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
>                         goto err_out_kobj_put;
>         }
>
> -       write_lock_irqsave(&cpufreq_driver_lock, flags);
> -       for_each_cpu(j, policy->cpus) {
> -               per_cpu(cpufreq_cpu_data, j) = policy;
> -               per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
> -       }
> -       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -
>         ret = cpufreq_add_dev_symlink(cpu, policy);
>         if (ret)
>                 goto err_out_kobj_put;
>
> -       memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
> -       /* assure that the starting sequence is run in __cpufreq_set_policy */
> -       policy->governor = NULL;
> -
> -       /* set default policy */
> -       ret = __cpufreq_set_policy(policy, &new_policy);
> -       policy->user_policy.policy = policy->policy;
> -       policy->user_policy.governor = policy->governor;
> -
> -       if (ret) {
> -               pr_debug("setting policy failed\n");
> -               if (cpufreq_driver->exit)
> -                       cpufreq_driver->exit(policy);
> -       }
>         return ret;
>
>  err_out_kobj_put:
> @@ -905,7 +881,7 @@ err_out_kobj_put:
>
>  #ifdef CONFIG_HOTPLUG_CPU
>  static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
> -                                 struct device *dev)
> +                                 struct device *dev, bool init_sysfs)
>  {
>         struct cpufreq_policy *policy;
>         int ret = 0, has_target = !!cpufreq_driver->target;
> @@ -933,30 +909,25 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
>                 __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
>         }
>
> -       ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> -       if (ret) {
> -               cpufreq_cpu_put(policy);
> -               return ret;
> +       if (init_sysfs) {
> +               ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> +               if (ret) {
> +                       cpufreq_cpu_put(policy);
> +                       return ret;
> +               }
>         }
>
>         return 0;
>  }
>  #endif
>
> -/**
> - * cpufreq_add_dev - add a CPU device
> - *
> - * Adds the cpufreq interface for a CPU device.
> - *
> - * The Oracle says: try running cpufreq registration/unregistration concurrently
> - * with with cpu hotplugging and all hell will break loose. Tried to clean this
> - * mess up, but more thorough testing is needed. - Mathieu
> - */
> -static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
> +static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
> +                            bool init_sysfs)
>  {
>         unsigned int j, cpu = dev->id;
>         int ret = -ENOMEM;
>         struct cpufreq_policy *policy;
> +       struct cpufreq_policy new_policy;
>         unsigned long flags;
>  #ifdef CONFIG_HOTPLUG_CPU
>         struct cpufreq_governor *gov;
> @@ -984,7 +955,8 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>                 struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
>                 if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
>                         read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> -                       return cpufreq_add_policy_cpu(cpu, sibling, dev);
> +                       return cpufreq_add_policy_cpu(cpu, sibling, dev,
> +                                                     init_sysfs);
>                 }
>         }
>         read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> @@ -1049,9 +1021,33 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>         }
>  #endif
>
> -       ret = cpufreq_add_dev_interface(cpu, policy, dev);
> -       if (ret)
> -               goto err_out_unregister;
> +       write_lock_irqsave(&cpufreq_driver_lock, flags);
> +       for_each_cpu(j, policy->cpus) {
> +               per_cpu(cpufreq_cpu_data, j) = policy;
> +               per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
> +       }
> +       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +
> +       if (init_sysfs) {
> +               ret = cpufreq_add_dev_interface(cpu, policy, dev);
> +               if (ret)
> +                       goto err_out_unregister;
> +       }
> +
> +       memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
> +       /* assure that the starting sequence is run in __cpufreq_set_policy */
> +       policy->governor = NULL;
> +
> +       /* set default policy */
> +       ret = __cpufreq_set_policy(policy, &new_policy);
> +       policy->user_policy.policy = policy->policy;
> +       policy->user_policy.governor = policy->governor;
> +
> +       if (ret) {
> +               pr_debug("setting policy failed\n");
> +               if (cpufreq_driver->exit)
> +                       cpufreq_driver->exit(policy);
> +       }
>
>         kobject_uevent(&policy->kobj, KOBJ_ADD);
>         module_put(cpufreq_driver->owner);
> @@ -1081,6 +1077,20 @@ module_out:
>         return ret;
>  }
>
> +/**
> + * cpufreq_add_dev - add a CPU device
> + *
> + * Adds the cpufreq interface for a CPU device.
> + *
> + * The Oracle says: try running cpufreq registration/unregistration concurrently
> + * with with cpu hotplugging and all hell will break loose. Tried to clean this
> + * mess up, but more thorough testing is needed. - Mathieu
> + */
> +static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
> +{
> +       return __cpufreq_add_dev(dev, sif, true);
> +}
> +
>  static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>  {
>         int j;
> @@ -1106,7 +1116,7 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
>   * This routine frees the rwsem before returning.
>   */
>  static int __cpufreq_remove_dev(struct device *dev,
> -               struct subsys_interface *sif)
> +                               struct subsys_interface *sif, bool remove_sysfs)
>  {
>         unsigned int cpu = dev->id, ret, cpus;
>         unsigned long flags;
> @@ -1145,9 +1155,9 @@ static int __cpufreq_remove_dev(struct device *dev,
>                 cpumask_clear_cpu(cpu, data->cpus);
>         unlock_policy_rwsem_write(cpu);
>
> -       if (cpu != data->cpu) {
> +       if (cpu != data->cpu && remove_sysfs) {
>                 sysfs_remove_link(&dev->kobj, "cpufreq");
> -       } else if (cpus > 1) {
> +       } else if (cpus > 1 && remove_sysfs) {
>                 /* first sibling now owns the new sysfs dir */
>                 cpu_dev = get_cpu_device(cpumask_first(data->cpus));
>                 sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
> @@ -1184,26 +1194,25 @@ static int __cpufreq_remove_dev(struct device *dev,
>
>         /* If cpu is last user of policy, free policy */
>         if (cpus == 1) {
> -               lock_policy_rwsem_read(cpu);
> -               kobj = &data->kobj;
> -               cmp = &data->kobj_unregister;
> -               unlock_policy_rwsem_read(cpu);
> -               kobject_put(kobj);
> -
> -               /* we need to make sure that the underlying kobj is actually
> -                * not referenced anymore by anybody before we proceed with
> -                * unloading.
> -                */
> -               pr_debug("waiting for dropping of refcount\n");
> -               wait_for_completion(cmp);
> -               pr_debug("wait complete\n");
> -
>                 if (cpufreq_driver->exit)
>                         cpufreq_driver->exit(data);
>
>                 free_cpumask_var(data->related_cpus);
>                 free_cpumask_var(data->cpus);
>                 kfree(data);
> +
> +               if (remove_sysfs) {
> +                       lock_policy_rwsem_read(cpu);
> +                       kobj = &data->kobj;
> +                       cmp = &data->kobj_unregister;

This looks no right.  "data" has already been freed but data-> kobj still is
referenced.

> +                       unlock_policy_rwsem_read(cpu);
> +                       kobject_put(kobj);
> +
> +                       pr_debug("waiting for dropping of refcount\n");
> +                       wait_for_completion(cmp);
> +                       pr_debug("wait complete\n");
> +               }
> +
>         } else if (cpufreq_driver->target) {
>                 __cpufreq_governor(data, CPUFREQ_GOV_START);
>                 __cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
> @@ -1221,7 +1230,7 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
>         if (cpu_is_offline(cpu))
>                 return 0;
>
> -       retval = __cpufreq_remove_dev(dev, sif);
> +       retval = __cpufreq_remove_dev(dev, sif, true);
>         return retval;
>  }
>
> @@ -1943,13 +1952,24 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
>                 case CPU_ONLINE:
>                         cpufreq_add_dev(dev, NULL);
>                         break;
> +               case CPU_ONLINE_FROZEN:
> +                       __cpufreq_add_dev(dev, NULL, false);
> +                       break;
> +
>                 case CPU_DOWN_PREPARE:
>                 case CPU_UP_CANCELED_FROZEN:
> -                       __cpufreq_remove_dev(dev, NULL);
> +                       __cpufreq_remove_dev(dev, NULL, true);
> +                       break;
> +               case CPU_DOWN_PREPARE_FROZEN:
> +                       __cpufreq_remove_dev(dev, NULL, false);
>                         break;
> +
>                 case CPU_DOWN_FAILED:
>                         cpufreq_add_dev(dev, NULL);
>                         break;
> +               case CPU_DOWN_FAILED_FROZEN:
> +                       __cpufreq_add_dev(dev, NULL, false);
> +                       break;
>                 }
>         }
>         return NOTIFY_OK;
>
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
