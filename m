Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3CFNh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:37:28 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:53441 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab3CFNh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:37:26 -0500
MIME-Version: 1.0
In-Reply-To: <1362521727-20666-3-git-send-email-dirk.brandewie@gmail.com>
References: <1362521727-20666-1-git-send-email-dirk.brandewie@gmail.com>
	<1362521727-20666-3-git-send-email-dirk.brandewie@gmail.com>
Date: Wed, 6 Mar 2013 21:37:18 +0800
X-Google-Sender-Auth: fD9MaS7Hp9CXfrQB6i5TFdLB87s
Message-ID: <CAOh2x=n_eZFajyXg5E3GNmS_SOTGB30DLSXoE+wM=GZv-BLqvA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq/intel_pstate: Fix intel_pstate_init() error path
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        konrad.wilk@oracle.com, jwboyer@redhat.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 6:15 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> If cpufreq_register_driver() fails just free memory that has been
> allocated and return. intel_pstate_exit() function is removed sine we

s/sine/since

> are built-in only now there is no reason for a module exit proceedure.

s/proceedure/procedure

> Reported-by:Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/intel_pstate.c |   39 +++++++++++----------------------------
>  1 files changed, 11 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 2bfd083..f6dd1e7 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -750,37 +750,11 @@ static struct cpufreq_driver intel_pstate_driver = {
>         .owner          = THIS_MODULE,
>  };
>
> -static void intel_pstate_exit(void)
> -{
> -       int cpu;
> -
> -       sysfs_remove_group(intel_pstate_kobject,
> -                               &intel_pstate_attr_group);
> -       debugfs_remove_recursive(debugfs_parent);
> -
> -       cpufreq_unregister_driver(&intel_pstate_driver);
> -
> -       if (!all_cpu_data)
> -               return;
> -
> -       get_online_cpus();
> -       for_each_online_cpu(cpu) {
> -               if (all_cpu_data[cpu]) {
> -                       del_timer_sync(&all_cpu_data[cpu]->timer);
> -                       kfree(all_cpu_data[cpu]);
> -               }
> -       }
> -
> -       put_online_cpus();
> -       vfree(all_cpu_data);
> -}
> -module_exit(intel_pstate_exit);
> -
>  static int __initdata no_load;
>
>  static int __init intel_pstate_init(void)
>  {
> -       int rc = 0;
> +       int cpu, rc = 0;
>         const struct x86_cpu_id *id;
>
>         if (no_load)
> @@ -805,7 +779,16 @@ static int __init intel_pstate_init(void)
>         intel_pstate_sysfs_expose_params();
>         return rc;
>  out:
> -       intel_pstate_exit();
> +       get_online_cpus();
> +       for_each_online_cpu(cpu) {
> +               if (all_cpu_data[cpu]) {
> +                       del_timer_sync(&all_cpu_data[cpu]->timer);
> +                       kfree(all_cpu_data[cpu]);
> +               }
> +       }
> +
> +       put_online_cpus();
> +       vfree(all_cpu_data);
>         return -ENODEV;
>  }
>  device_initcall(intel_pstate_init);
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
