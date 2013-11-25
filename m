Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3KYEZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 23:25:23 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43381 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3KYEZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 23:25:20 -0500
MIME-Version: 1.0
In-Reply-To: <528F1FC9.4070306@linaro.org>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
	<1531674.UoqyyWSbOg@vostro.rjw.lan>
	<CAKohpo=e+0cpq5XfWpM6Jm0VrnzzAu-xybpucEG6sRL0ydBmLQ@mail.gmail.com>
	<2642790.BqNcqy9aCb@vostro.rjw.lan>
	<528F1FC9.4070306@linaro.org>
Date: Mon, 25 Nov 2013 09:55:19 +0530
Message-ID: <CAKohponZEpk52rOcx-XxfUp75rZMUN8tqR=DJHnutO9Ga3fJ-Q@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2013 14:41, viresh kumar <viresh.kumar@linaro.org> wrote:
> So, what about something like this ?
>
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index f48370d..523c0bc 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -120,6 +120,45 @@ static DEVICE_ATTR(release, S_IWUSR, NULL, cpu_release_store);
>  #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
>  #endif /* CONFIG_HOTPLUG_CPU */
>
> +int cpu_subsys_suspend_noirq(struct device *dev)
> +{
> +       struct bus_type *bus = dev->bus;
> +       struct subsys_interface *sif;
> +       int ret = 0;
> +
> +       list_for_each_entry(sif, &bus->p->interfaces, node) {
> +               if (sif->pm && sif->pm->suspend_noirq) {
> +                       ret = sif->suspend_noirq(dev);
> +                       if (ret)
> +                               break;
> +               }
> +       }
> +
> +       return ret;
> +}
> +
> +int cpu_subsys_resume_noirq(struct device *dev)
> +{
> +       struct bus_type *bus = dev->bus;
> +       struct subsys_interface *sif;
> +       int ret = 0;
> +
> +       list_for_each_entry(sif, &bus->p->interfaces, node) {
> +               if (sif->pm && sif->pm->resume_noirq) {
> +                       ret = sif->resume_noirq(dev);
> +                       if (ret)
> +                               break;
> +               }
> +       }
> +
> +       return ret;
> +}
> +
> +static const struct dev_pm_ops cpu_subsys_pm_ops = {
> +       .suspend_noirq = cpu_subsys_suspend_noirq,
> +       .resume_noirq = cpu_subsys_resume_noirq,
> +};
> +
>  struct bus_type cpu_subsys = {
>         .name = "cpu",
>         .dev_name = "cpu",
> @@ -128,6 +167,7 @@ struct bus_type cpu_subsys = {
>         .online = cpu_subsys_online,
>         .offline = cpu_subsys_offline,
>  #endif
> +       .pm = &cpu_subsys_pm_ops,
>  };
>  EXPORT_SYMBOL_GPL(cpu_subsys);
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index b025925..fa01273 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -298,11 +298,16 @@ struct device *driver_find_device(struct device_driver *drv,
>   * @node:       the list of functions registered at the subsystem
>   * @add_dev:    device hookup to device function handler
>   * @remove_dev: device hookup to device function handler
> + * @pm: Power management operations of this interface.
>   *
>   * Simple interfaces attached to a subsystem. Multiple interfaces can
>   * attach to a subsystem and its devices. Unlike drivers, they do not
>   * exclusively claim or control devices. Interfaces usually represent
>   * a specific functionality of a subsystem/class of devices.
> + *
> + * PM callbacks are called from individual subsystems instead of PM core. And
> + * hence might not be available for all subsystems. Currently present for:
> + * cpu_subsys.
>   */
>  struct subsys_interface {
>         const char *name;
> @@ -310,6 +315,7 @@ struct subsys_interface {
>         struct list_head node;
>         int (*add_dev)(struct device *dev, struct subsys_interface *sif);
>         int (*remove_dev)(struct device *dev, struct subsys_interface *sif);
> +       const struct dev_pm_ops *pm;
>  };
>
>  int subsys_interface_register(struct subsys_interface *sif);

Any inputs?
