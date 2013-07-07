Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab3GGSyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 14:54:46 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:38242 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3GGSyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 14:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <1373014001-17746-2-git-send-email-cw00.choi@samsung.com>
References: <1373014001-17746-1-git-send-email-cw00.choi@samsung.com>
	<1373014001-17746-2-git-send-email-cw00.choi@samsung.com>
Date: Sun, 7 Jul 2013 11:54:40 -0700
Message-ID: <CADTbHxqsSpyAKFBg7t31h3SH-p_x2UO=jTpLz80GZW4+64eo5g@mail.gmail.com>
Subject: Re: [PATCH 1/6] cpufreq: Add debugfs directory for cpufreq
From: Pankaj Jangra <jangra.pankaj9@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: viresh.kumar@linaro.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Fri, Jul 5, 2013 at 1:46 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch create debugfs root directory and child directory according to
> the number of CPUs for CPUFreq as below debugfs directory path:
> - /sys/kernel/debug/cpufreq/cpuX
>
> If many CPUs share only one cpufreq policy, other CPU(except for CPU0) create
> a link for debugfs directory of CPU0.
> - /sys/kernel/debug/cpufreq/cpu0
> - /sys/kernel/debug/cpufreq/cpu[1-(N-1)] -> /sys/kernel/debug/cpufreq/cpu0
>
> And then cpufreq may need to create debugfs specific file below of debugfs
> directory of cpufreq. (e.g., /sys/kernel/debug/cpufreq/cpu0/load_table)
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/cpufreq/cpufreq.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/cpufreq.h   |  1 +
>  2 files changed, 58 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2d53f47..bc01c8e 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -23,6 +23,7 @@
>  #include <linux/notifier.h>
>  #include <linux/cpufreq.h>
>  #include <linux/delay.h>
> +#include <linux/debugfs.h>
>  #include <linux/interrupt.h>
>  #include <linux/spinlock.h>
>  #include <linux/device.h>
> @@ -47,6 +48,10 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
>  static DEFINE_RWLOCK(cpufreq_driver_lock);
>
> +/* The cpufreq_debugfs is used to create debugfs root directory for CPUFreq. */
> +#define MAX_DEBUGFS_NAME_LEN   CPUFREQ_NAME_LEN
> +static struct dentry *cpufreq_debugfs;
> +
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
> +               i = cpu;
> +
> +               policy->cpu_debugfs = devm_kzalloc(dev, size, GFP_KERNEL);
> +               policy->cpu_debugfs[i] = debugfs_create_dir(name,
> +                                                           cpufreq_debugfs);
> +               if (!policy->cpu_debugfs[i])
> +                       pr_debug("creating debugfs directory failed\n");
> +       }
> +
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
> +
>         return 0;
>  }
>  #endif
> @@ -1046,6 +1095,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>
>         if (cpu != data->cpu) {
>                 sysfs_remove_link(&dev->kobj, "cpufreq");
> +               debugfs_remove(data->cpu_debugfs[cpu]);

I think you should add the call to remove the "cpufreq" also ???
               "debugfs_remove(cpufreq_debugfs);"
>         } else if (cpus > 1) {
>                 /* first sibling now owns the new sysfs dir */
>                 cpu_dev = get_cpu_device(cpumask_first(data->cpus));
> @@ -1068,6 +1118,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>                         return -EINVAL;
>                 }
>
> +               debugfs_remove_recursive(data->cpu_debugfs[cpu]);
> +               debugfs_remove(cpufreq_debugfs);
> +
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
> +
>         return 0;
>  }
>  core_initcall(cpufreq_core_init);
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,
Pankaj Jangra
