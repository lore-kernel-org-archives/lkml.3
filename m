Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaKTEkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 23:40:12 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59803 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaKTEkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 23:40:10 -0500
MIME-Version: 1.0
In-Reply-To: <1416403291-7722-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1416403291-7722-1-git-send-email-tomeu.vizoso@collabora.com>
Date: Thu, 20 Nov 2014 10:10:09 +0530
Message-ID: <CAKohponxpSoUXHc9S-y_zgo=T44-6Ayk4vRbW=jRHqQRsdbrGQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Ref the policy object sooner
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2014 18:51, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> Do it before it's assigned to cpufreq_cpu_data, otherwise we can get
> this warning when a driver tries to get the cpu frequency during
> initialization:
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 64 at include/linux/kref.h:47 kobject_get+0x64/0x70()
> Modules linked in:
> CPU: 1 PID: 64 Comm: irq/77-tegra-ac Not tainted 3.18.0-rc4-next-20141114ccu-00050-g3eff942 #326
> [<c0016fac>] (unwind_backtrace) from [<c001272c>] (show_stack+0x10/0x14)
> [<c001272c>] (show_stack) from [<c06085d8>] (dump_stack+0x98/0xd8)
> [<c06085d8>] (dump_stack) from [<c002892c>] (warn_slowpath_common+0x84/0xb4)
> [<c002892c>] (warn_slowpath_common) from [<c00289f8>] (warn_slowpath_null+0x1c/0x24)
> [<c00289f8>] (warn_slowpath_null) from [<c0220290>] (kobject_get+0x64/0x70)
> [<c0220290>] (kobject_get) from [<c03e944c>] (cpufreq_cpu_get+0x88/0xc8)
> [<c03e944c>] (cpufreq_cpu_get) from [<c03e9500>] (cpufreq_get+0xc/0x64)
> [<c03e9500>] (cpufreq_get) from [<c0285288>] (actmon_thread_isr+0x134/0x198)
> [<c0285288>] (actmon_thread_isr) from [<c0069008>] (irq_thread_fn+0x1c/0x40)
> [<c0069008>] (irq_thread_fn) from [<c0069324>] (irq_thread+0x134/0x174)
> [<c0069324>] (irq_thread) from [<c0040290>] (kthread+0xdc/0xf4)
> [<c0040290>] (kthread) from [<c000f4b8>] (ret_from_fork+0x14/0x3c)
> ---[ end trace b7bd64a81b340c59 ]---
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/cpufreq/cpufreq.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 4473eba..954cb2f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -898,12 +898,6 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
>         struct freq_attr **drv_attr;
>         int ret = 0;
>
> -       /* prepare interface data */
> -       ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
> -                                  &dev->kobj, "cpufreq");
> -       if (ret)
> -               return ret;
> -
>         /* set up files for this cpu device */
>         drv_attr = cpufreq_driver->attr;
>         while ((drv_attr) && (*drv_attr)) {
> @@ -1211,6 +1205,15 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
>         }
>
>         down_write(&policy->rwsem);
> +
> +       /* prepare interface data */
> +       ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
> +                                  &dev->kobj, "cpufreq");

This should be done only when (!recover_policy) and so you can merge
it with the 'if' block just above down_write. Actually you can move down_write()
a little bit up as well, just after ->init()

> +       if (ret) {
> +               pr_err("%s: failed to init policy->kobj: %d\n", __func__, ret);
> +               goto err_init_policy_kobj;
> +       }
> +
>         write_lock_irqsave(&cpufreq_driver_lock, flags);
>         for_each_cpu(j, policy->cpus)
>                 per_cpu(cpufreq_cpu_data, j) = policy;
> @@ -1301,6 +1304,7 @@ err_get_freq:
>                 per_cpu(cpufreq_cpu_data, j) = NULL;
>         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> +err_init_policy_kobj:

Oh, that's not enough and you need to get the relevant bits out from
the add_dev_interface() routine as well:

err_out_kobj_put:
kobject_put(&policy->kobj);
wait_for_completion(&policy->kobj_unregister);


>         up_write(&policy->rwsem);
>
>         if (cpufreq_driver->exit)
> --
> 1.9.3
>
