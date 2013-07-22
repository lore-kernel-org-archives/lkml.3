Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3GVKLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:11:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48395 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab3GVKLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:11:46 -0400
MIME-Version: 1.0
In-Reply-To: <1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
	<1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
Date: Mon, 22 Jul 2013 15:41:45 +0530
Message-ID: <CAKohpo=oTsEjzi_51UaZ8ww8UEfZ6hwKAnu9rFgGBkt=TfHi8A@mail.gmail.com>
Subject: Re: [PATCH 1/3 v6] cpufreq: Add debugfs directory for cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 July 2013 16:47, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> +#ifdef CONFIG_CPU_FREQ_STAT
> +/* The cpufreq_debugfs is used to create debugfs root directory for CPUFreq. */
> +static struct dentry *cpufreq_debugfs;
> +
> +static int cpufreq_create_debugfs_dir(struct cpufreq_policy *policy,
> +                                     struct device *dev)
> +{
> +       char name[CPUFREQ_NAME_LEN];
> +       unsigned int cpus, size, idx;
> +
> +       if (!cpufreq_debugfs)
> +               return -EINVAL;
> +
> +       cpus = cpumask_weight(policy->cpus);

I remember I told you not to use policy->cpus for this purpose?? But
related_cpus.

> +       idx = cpus > 1 ? policy->cpu : 0;

> +       policy->cpu_debugfs[idx] = debugfs_create_dir(name, cpufreq_debugfs);

This is broken. A policy may contain cpus 9,10 only.. You will allocate array
for 2 cpus and try to access cpu_debugfs[9] :)

> +       if (!policy->cpu_debugfs[idx]) {
> +               pr_err("creating debugfs directory failed\n");
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +static int cpufreq_create_debugfs_symlink(struct cpufreq_policy *policy,
> +                                          unsigned int src_cpu,
> +                                          unsigned int dest_cpu)

Only use policy and cpu for which symlink has to be created as param
to this routine. And create link to policy->cpu.

> +{
> +       char symlink_name[CPUFREQ_NAME_LEN];
> +       char target_name[CPUFREQ_NAME_LEN];
> +
> +       if (!cpufreq_debugfs)
> +               return -EINVAL;
> +
> +       if (!policy->cpu_debugfs[src_cpu])
> +               return -EINVAL;
> +
> +       sprintf(symlink_name, "cpu%d", dest_cpu);
> +       sprintf(target_name, "./cpu%d", src_cpu);
> +       policy->cpu_debugfs[dest_cpu] = debugfs_create_symlink(
> +                                       symlink_name,
> +                                       cpufreq_debugfs,
> +                                       target_name);
> +       if (!policy->cpu_debugfs[dest_cpu]) {
> +               pr_err("creating debugfs symlink failed\n");
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +static void cpufreq_remove_debugfs_dir(struct cpufreq_policy *policy,
> +                                      unsigned int cpu)
> +{
> +       unsigned int idx = cpumask_weight(policy->cpus) > 1 ? cpu : 0;
> +
> +       if (!policy->cpu_debugfs[idx])
> +               return;
> +
> +       debugfs_remove_recursive(policy->cpu_debugfs[idx]);

Whey do we need recursive here? And what exactly does recursive will
do?

> +}
> +

same problem here too.
> +static void cpufreq_move_debugfs_dir(struct cpufreq_policy *policy,
> +                                    unsigned int new_cpu)
> +{
> +       struct dentry *old_entry, *new_entry;
> +       char new_dir_name[CPUFREQ_NAME_LEN];
> +       unsigned int j, old_cpu = policy->cpu;
> +
> +       if (!policy->cpu_debugfs[new_cpu])
> +               return;
> +
> +       /*
> +        * Remove symbolic link of debugfs directory except for debugfs
> +        * directory of old_cpu.
> +        */
> +       for_each_present_cpu(j) {
> +               if (old_cpu == j)
> +                       continue;
> +
> +               debugfs_remove(policy->cpu_debugfs[j]);

Why you need this? We aren't removing the earlier dentry at all here.

> +       }
> +
> +       /*
> +        * Change debugfs directory name from as following:
> +        * - old debugfs dir name : /sys/kernel/debugfs/cpufreq/cpu${old_cpu}
> +        * - new debugfs dir name : /sys/kernel/debugfs/cpufreq/cpu${new_cpu}
> +        */
> +       sprintf(new_dir_name, "cpu%d", new_cpu);
> +       old_entry = policy->cpu_debugfs[old_cpu];
> +       new_entry = debugfs_rename(cpufreq_debugfs, old_entry,
> +                                  cpufreq_debugfs, new_dir_name);

This routine returns old_entry only.. and so you can simply create a
single routine with name dentry.

> +       if (!new_entry) {
> +               pr_err("changing debugfs directory name failed\n");
> +               goto err_rename;
> +       }
> +
> +       policy->cpu_debugfs[new_cpu] = new_entry;
> +       policy->cpu_debugfs[old_cpu] = NULL;
> +
> +       /* Create again symbolic link of debugfs directory */
> +       for_each_present_cpu(j) {

present_cpu?? We discussed this before.. You will break multi cluster
systems.

> +               if (new_cpu == j)
> +                       continue;
> +
> +               cpufreq_create_debugfs_symlink(policy, new_cpu, j);
> +       }
> +
> +       return;
> +
> +err_rename:
> +       for_each_present_cpu(j) {
> +               if (old_cpu == j)
> +                       continue;
> +
> +               cpufreq_create_debugfs_symlink(policy, old_cpu, j);
> +       }
> +}
> +
> +static int cpufreq_create_debugfs(void)
> +{
> +       cpufreq_debugfs = debugfs_create_dir("cpufreq", NULL);
> +       if (!cpufreq_debugfs) {
> +               pr_err("creating debugfs root failed\n");
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +static void cpufreq_remove_debugfs(void)
> +{
> +       if (cpufreq_debugfs)
> +               debugfs_remove_recursive(cpufreq_debugfs);
> +}
> +#else
> +static int cpufreq_create_debugfs_dir(struct cpufreq_policy *policy,
> +                                       struct device *dev) { return 0; }
> +static int cpufreq_create_debugfs_symlink(struct cpufreq_policy *policy,
> +                                       unsigned int src_cpu,
> +                                       unsigned int dest_cpu) { return 0;}
> +static void cpufreq_remove_debugfs_dir(struct cpufreq_policy *policy,
> +                                       unsigned int cpu) { }
> +static void cpufreq_move_debugfs_dir(struct cpufreq_policy *policy,
> +                                       unsigned int new_cpu) { }
> +static int cpufreq_create_debugfs(void) { return 0; }
> +static void cpufreq_remove_debugfs(void) { }

make all above #else part routines inline.

> +#endif
> +
>  /* symlink affected CPUs */
>  static int cpufreq_add_dev_symlink(unsigned int cpu,
>                                    struct cpufreq_policy *policy)
> @@ -726,6 +885,8 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
>                         cpufreq_cpu_put(managed_policy);
>                         return ret;
>                 }
> +
> +               cpufreq_create_debugfs_symlink(policy, cpu, j);
>         }
>         return ret;
>  }
> @@ -777,6 +938,9 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
>         }
>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> +       /* prepare interface data for debugfs */
> +       cpufreq_create_debugfs_dir(policy, dev);
> +
>         ret = cpufreq_add_dev_symlink(cpu, policy);
>         if (ret)
>                 goto err_out_kobj_put;
> @@ -839,6 +1003,8 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
>                 return ret;
>         }
>
> +       cpufreq_create_debugfs_symlink(policy, sibling, cpu);
> +
>         return 0;
>  }
>  #endif
> @@ -1046,6 +1212,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>
>         if (cpu != data->cpu) {
>                 sysfs_remove_link(&dev->kobj, "cpufreq");
> +               cpufreq_remove_debugfs_dir(data, cpu);
>         } else if (cpus > 1) {
>                 /* first sibling now owns the new sysfs dir */
>                 cpu_dev = get_cpu_device(cpumask_first(data->cpus));
> @@ -1068,6 +1235,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>                         return -EINVAL;
>                 }
>
> +               cpufreq_move_debugfs_dir(data, cpu_dev->id);
> +
>                 WARN_ON(lock_policy_rwsem_write(cpu));
>                 update_policy_cpu(data, cpu_dev->id);
>                 unlock_policy_rwsem_write(cpu);
> @@ -1089,6 +1258,8 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>                 unlock_policy_rwsem_read(cpu);
>                 kobject_put(kobj);
>
> +               cpufreq_remove_debugfs_dir(data, cpu);
> +
>                 /* we need to make sure that the underlying kobj is actually
>                  * not referenced anymore by anybody before we proceed with
>                  * unloading.
> @@ -1894,6 +2065,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>         cpufreq_driver = driver_data;
>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> +       cpufreq_create_debugfs();

Why you moved this to register_driver? It was fine at cpufreq_core_init()

>         ret = subsys_interface_register(&cpufreq_interface);
>         if (ret)
>                 goto err_null_driver;
> @@ -1918,12 +2091,14 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>         }
>
>         register_hotcpu_notifier(&cpufreq_cpu_notifier);
> +

unrelated change.

>         pr_debug("driver %s up and running\n", driver_data->name);
>
>         return 0;
>  err_if_unreg:
>         subsys_interface_unregister(&cpufreq_interface);
>  err_null_driver:
> +       cpufreq_remove_debugfs();
>         write_lock_irqsave(&cpufreq_driver_lock, flags);
>         cpufreq_driver = NULL;
>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> @@ -1949,6 +2124,8 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
>
>         pr_debug("unregistering driver %s\n", driver->name);
>
> +       cpufreq_remove_debugfs();

And so you don't need this.

>         subsys_interface_unregister(&cpufreq_interface);
>         unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
>
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 037d36a..825f379 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -115,6 +115,7 @@ struct cpufreq_policy {
>
>         struct kobject          kobj;
>         struct completion       kobj_unregister;
> +       struct dentry           **cpu_debugfs;
>  };
>
>  #define CPUFREQ_ADJUST                 (0)
> --
> 1.8.0
>
