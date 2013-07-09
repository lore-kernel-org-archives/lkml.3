Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3GIJXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:23:05 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:60170 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3GIJXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <1373014001-17746-2-git-send-email-cw00.choi@samsung.com>
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
	<1373014001-17746-2-git-send-email-cw00.choi@samsung.com>
Date: Tue, 9 Jul 2013 14:53:00 +0530
Message-ID: <CAKohpomriPXmK3TRFqinyEEuG39O1ppKmPuW0gvs3iRLnsoPrg@mail.gmail.com>
Subject: Re: [PATCH 1/6] cpufreq: Add debugfs directory for cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 July 2013 14:16, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

> +/* The cpufreq_debugfs is used to create debugfs root directory for CPUFreq. */
> +#define MAX_DEBUGFS_NAME_LEN   CPUFREQ_NAME_LEN

Why declare MAX_DEBUGFS_NAME_LEN if it is going to be equal to
CPUFREQ_NAME_LEN. Simply use CPUFREQ_NAME_LEN everywhere.

> +static struct dentry *cpufreq_debugfs;

Probably make this dependent on CONFIG_CPU_FREQ_STAT?

>  /*
>   * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
>   * all cpufreq/hotplug/workqueue/etc related lock issues.
> @@ -726,6 +731,20 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
>                         cpufreq_cpu_put(managed_policy);
>                         return ret;
>                 }
> +
> +               if (cpufreq_debugfs) {
> +                       char symlink_name[MAX_DEBUGFS_NAME_LEN];
> +                       char target_name[MAX_DEBUGFS_NAME_LEN];
> +
> +                       sprintf(symlink_name, "cpu%d", j);
> +                       sprintf(target_name, "./cpu%d", cpu);
> +                       managed_policy->cpu_debugfs[j] = debugfs_create_symlink(
> +                                                       symlink_name,
> +                                                       cpufreq_debugfs,
> +                                                       target_name);
> +                       if (!managed_policy->cpu_debugfs[j])
> +                               pr_debug("creating debugfs symlink failed\n");

pr_err?

> +               }
>         }
>         return ret;
>  }
> @@ -746,6 +765,22 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
>         if (ret)
>                 return ret;
>
> +       /* prepare interface data for debugfs */
> +       if (cpufreq_debugfs) {
> +               char name[MAX_DEBUGFS_NAME_LEN];
> +               int size, i;
> +
> +               sprintf(name, "cpu%d", policy->cpu);
> +               size = sizeof(struct dentry*) * NR_CPUS;

NR_CPUS? You only need to take care of cpus that belong to this
policy, isn't it? policy->related_cpus should be good enough for you.

> +               i = cpu;
> +
> +               policy->cpu_debugfs = devm_kzalloc(dev, size, GFP_KERNEL);
> +               policy->cpu_debugfs[i] = debugfs_create_dir(name,
> +                                                           cpufreq_debugfs);
> +               if (!policy->cpu_debugfs[i])
> +                       pr_debug("creating debugfs directory failed\n");
> +       }

pr_err?

And move this code just before the call to cpufreq_add_dev_symlink().

>         /* set up files for this cpu device */
>         drv_attr = cpufreq_driver->attr;
>         while ((drv_attr) && (*drv_attr)) {
> @@ -839,6 +874,20 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
>                 return ret;
>         }
>
> +       if (cpufreq_debugfs) {
> +               char symlink_name[MAX_DEBUGFS_NAME_LEN];
> +               char target_name[MAX_DEBUGFS_NAME_LEN];
> +
> +               sprintf(symlink_name, "cpu%d", cpu);
> +               sprintf(target_name, "./cpu%d", sibling);
> +               policy->cpu_debugfs[cpu] = debugfs_create_symlink(
> +                                               symlink_name,
> +                                               cpufreq_debugfs,
> +                                               target_name);
> +               if (!policy->cpu_debugfs[cpu])
> +                       pr_debug("creating debugfs symlink failed\n");
> +       }

This is purely replication of same code. Create a routine to
hold these lines and call it from wherever it is required.

>         return 0;
>  }
>  #endif
> @@ -1046,6 +1095,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>
>         if (cpu != data->cpu) {
>                 sysfs_remove_link(&dev->kobj, "cpufreq");
> +               debugfs_remove(data->cpu_debugfs[cpu]);
>         } else if (cpus > 1) {
>                 /* first sibling now owns the new sysfs dir */
>                 cpu_dev = get_cpu_device(cpumask_first(data->cpus));
> @@ -1068,6 +1118,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>                         return -EINVAL;
>                 }
>
> +               debugfs_remove_recursive(data->cpu_debugfs[cpu]);

So you removed load_table here? What about other cpus that were
there in policy->cpus?

> +               debugfs_remove(cpufreq_debugfs);

Who will create this again? Also, there might be multiple policy struct's
in a system and here we have reached to removal of all cpus of
a policy. Other policies are still alive.

>                 WARN_ON(lock_policy_rwsem_write(cpu));
>                 update_policy_cpu(data, cpu_dev->id);
>                 unlock_policy_rwsem_write(cpu);
> @@ -1976,6 +2029,10 @@ static int __init cpufreq_core_init(void)
>         BUG_ON(!cpufreq_global_kobject);
>         register_syscore_ops(&cpufreq_syscore_ops);
>
> +       cpufreq_debugfs = debugfs_create_dir("cpufreq", NULL);
> +       if (!cpufreq_debugfs)
> +               pr_debug("creating debugfs root failed\n");

So, you just added this directory once.. So you must not
remove it.

>         return 0;
>  }
>  core_initcall(cpufreq_core_init);
