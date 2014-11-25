Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaKYVwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:52:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55294 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750984AbaKYVwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:52:12 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cpufreq: Ref the policy object sooner
Date: Tue, 25 Nov 2014 23:13:26 +0100
Message-ID: <1971756.fuSemXHy0C@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohponYcoFkbezPjjUbedzZRgbyROJVgKhecALPH+O2yKQfow@mail.gmail.com>
References: <CAKohponxpSoUXHc9S-y_zgo=T44-6Ayk4vRbW=jRHqQRsdbrGQ@mail.gmail.com> <1416820083-20902-1-git-send-email-tomeu.vizoso@collabora.com> <CAKohponYcoFkbezPjjUbedzZRgbyROJVgKhecALPH+O2yKQfow@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 25, 2014 04:40:23 PM Viresh Kumar wrote:
> On 24 November 2014 at 14:38, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> > Do it before it's assigned to cpufreq_cpu_data, otherwise when a driver
> > tries to get the cpu frequency during initialization the policy kobj is
> > referenced and we get this warning:
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 64 at include/linux/kref.h:47 kobject_get+0x64/0x70()
> > Modules linked in:
> > CPU: 1 PID: 64 Comm: irq/77-tegra-ac Not tainted 3.18.0-rc4-next-20141114ccu-00050-g3eff942 #326
> > [<c0016fac>] (unwind_backtrace) from [<c001272c>] (show_stack+0x10/0x14)
> > [<c001272c>] (show_stack) from [<c06085d8>] (dump_stack+0x98/0xd8)
> > [<c06085d8>] (dump_stack) from [<c002892c>] (warn_slowpath_common+0x84/0xb4)
> > [<c002892c>] (warn_slowpath_common) from [<c00289f8>] (warn_slowpath_null+0x1c/0x24)
> > [<c00289f8>] (warn_slowpath_null) from [<c0220290>] (kobject_get+0x64/0x70)
> > [<c0220290>] (kobject_get) from [<c03e944c>] (cpufreq_cpu_get+0x88/0xc8)
> > [<c03e944c>] (cpufreq_cpu_get) from [<c03e9500>] (cpufreq_get+0xc/0x64)
> > [<c03e9500>] (cpufreq_get) from [<c0285288>] (actmon_thread_isr+0x134/0x198)
> > [<c0285288>] (actmon_thread_isr) from [<c0069008>] (irq_thread_fn+0x1c/0x40)
> > [<c0069008>] (irq_thread_fn) from [<c0069324>] (irq_thread+0x134/0x174)
> > [<c0069324>] (irq_thread) from [<c0040290>] (kthread+0xdc/0xf4)
> > [<c0040290>] (kthread) from [<c000f4b8>] (ret_from_fork+0x14/0x3c)
> > ---[ end trace b7bd64a81b340c59 ]---
> >
> > Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> >
> > ---
> >
> > v2:     * Properly unwind when erroring out.
> > ---
> >  drivers/cpufreq/cpufreq.c | 42 +++++++++++++++++++++---------------------
> >  1 file changed, 21 insertions(+), 21 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 4473eba..ae27ea6 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -898,46 +898,31 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
> >         struct freq_attr **drv_attr;
> >         int ret = 0;
> >
> > -       /* prepare interface data */
> > -       ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
> > -                                  &dev->kobj, "cpufreq");
> > -       if (ret)
> > -               return ret;
> > -
> >         /* set up files for this cpu device */
> >         drv_attr = cpufreq_driver->attr;
> >         while ((drv_attr) && (*drv_attr)) {
> >                 ret = sysfs_create_file(&policy->kobj, &((*drv_attr)->attr));
> >                 if (ret)
> > -                       goto err_out_kobj_put;
> > +                       return ret;
> >                 drv_attr++;
> >         }
> >         if (cpufreq_driver->get) {
> >                 ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
> >                 if (ret)
> > -                       goto err_out_kobj_put;
> > +                       return ret;
> >         }
> >
> >         ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
> >         if (ret)
> > -               goto err_out_kobj_put;
> > +               return ret;
> >
> >         if (cpufreq_driver->bios_limit) {
> >                 ret = sysfs_create_file(&policy->kobj, &bios_limit.attr);
> >                 if (ret)
> > -                       goto err_out_kobj_put;
> > +                       return ret;
> >         }
> 
> We should add proper handling for error returned from sysfs_create_file()
> someday, but its obviously not what you are trying to fix.
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Patch queued up for 3.19-rc1, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
