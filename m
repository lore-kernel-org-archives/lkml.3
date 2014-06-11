Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaFKI1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:27:52 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:34170 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaFKI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:27:49 -0400
MIME-Version: 1.0
In-Reply-To: <1402446800-4043-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1402446800-4043-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Wed, 11 Jun 2014 10:27:48 +0200
Message-ID: <CAPDyKFr6aoev3vSmxQOJWDGGFLWyE4eZ_0joQ45-GgZNztYdGA@mail.gmail.com>
Subject: Re: [RFC PATCH] PM: Domain: Add flag to assure that device's runtime
 pm callback is called at once.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, cw00.choi@samsung.com,
        Myungjoo Ham <myungjoo.ham@samsung.com>, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 June 2014 02:33, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> When device uses generic pm domain, its own runtime suspend callback will be
> executed only when all devices in the same domain are suspended. However, some
> device needs sychronized runtime suspend and not to be deffered.
> For those devices, Generic pm domain adds new API for adding device with flag,
> which shows that it guerantees driver's runtime suspend will be executed right
> away not at the time domain is really powered off.
> Existed API, pm_genpd_add_device(), now adds device with flag representing this
> device is not needed sychrnoized callback. It will work as same as before.

Hi Jonghwa,

I understand you have an issue of the behaviour of genpd here and I
agree we need a solution, but I am not sure this is the correct one.
:-)

The current behaviour of how genpd deals with runtime PM suspend
callbacks has two severe issues:

1 ) It prevents fine grained power management within a domain. Simply
because those resources that are controlled on levels below the
pm_domain, can't be put in low power state until the complete domain
will be dropped.
2 ) All devices within a domain will be runtime PM suspended at the
same time. This causes a thundering herd problem since latencies gets
accumulated for each device in a domain.

Instead I think we should try to change the default behaviour of genpd
and let it invoke the runtime PM callbacks immediately and not wait
for the domain to be dropped. Do you think that could work?

Kind regards
Ulf Hansson

>
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/base/power/domain.c |   17 ++++++++++++++---
>  include/linux/pm_domain.h   |   19 ++++++++++++++++---
>  2 files changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index ae098a2..6c7a786 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -503,6 +503,9 @@ static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
>         genpd->poweroff_task = current;
>
>         list_for_each_entry_reverse(pdd, &genpd->dev_list, list_node) {
> +               if (dev_gpd_data(pdd->dev)->rpmflags & GENPD_RPM_SYNC)
> +                       continue;
> +
>                 ret = atomic_read(&genpd->sd_count) == 0 ?
>                         __pm_genpd_save_device(pdd, genpd) : -EBUSY;
>
> @@ -625,6 +628,9 @@ static int pm_genpd_runtime_suspend(struct device *dev)
>         if (stop_ok && !stop_ok(dev))
>                 return -EBUSY;
>
> +       if (dev_gpd_data(dev)->rpmflags & GENPD_RPM_SYNC)
> +               genpd_save_dev(genpd, dev);
> +
>         ret = genpd_stop_dev(genpd, dev);
>         if (ret)
>                 return ret;
> @@ -1416,7 +1422,7 @@ static void __pm_genpd_free_dev_data(struct device *dev,
>   * @td: Set of PM QoS timing parameters to attach to the device.
>   */
>  int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
> -                         struct gpd_timing_data *td)
> +                         struct gpd_timing_data *td, enum genpd_rpmflags flags)
>  {
>         struct generic_pm_domain_data *gpd_data_new, *gpd_data = NULL;
>         struct pm_domain_data *pdd;
> @@ -1472,6 +1478,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
>         gpd_data->need_restore = genpd->status == GPD_STATE_POWER_OFF;
>         gpd_data->td.constraint_changed = true;
>         gpd_data->td.effective_constraint_ns = -1;
> +       gpd_data->rpmflags = flags;
>         mutex_unlock(&gpd_data->lock);
>
>   out:
> @@ -1494,6 +1501,7 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
>                              struct gpd_timing_data *td)
>  {
>         struct generic_pm_domain *genpd = NULL, *gpd;
> +       enum genpd_rpmflags rpmflags;
>
>         dev_dbg(dev, "%s()\n", __func__);
>
> @@ -1512,7 +1520,9 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
>         if (!genpd)
>                 return -EINVAL;
>
> -       return __pm_genpd_add_device(genpd, dev, td);
> +       rpmflags = of_property_read_bool(dev->of_node, "pm-genpd-rpmsync");
> +
> +       return __pm_genpd_add_device(genpd, dev, td, rpmflags);
>  }
>
>
> @@ -1525,7 +1535,8 @@ int __pm_genpd_of_add_device(struct device_node *genpd_node, struct device *dev,
>  int __pm_genpd_name_add_device(const char *domain_name, struct device *dev,
>                                struct gpd_timing_data *td)
>  {
> -       return __pm_genpd_add_device(pm_genpd_lookup_name(domain_name), dev, td);
> +       struct generic_pm_domain *genpd = pm_genpd_lookup_name(domain_name);
> +       return __pm_genpd_add_device(genpd, dev, td, GENPD_RPM_ASYNC);
>  }
>
>  /**
> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
> index 7c1d252..d36e5cf 100644
> --- a/include/linux/pm_domain.h
> +++ b/include/linux/pm_domain.h
> @@ -106,6 +106,11 @@ struct gpd_timing_data {
>         bool cached_stop_ok;
>  };
>
> +enum genpd_rpmflags {
> +       GENPD_RPM_ASYNC = 0,
> +       GENPD_RPM_SYNC,
> +};
> +
>  struct generic_pm_domain_data {
>         struct pm_domain_data base;
>         struct gpd_dev_ops ops;
> @@ -114,6 +119,7 @@ struct generic_pm_domain_data {
>         struct mutex lock;
>         unsigned int refcount;
>         bool need_restore;
> +       enum genpd_rpmflags rpmflags;
>  };
>
>  #ifdef CONFIG_PM_GENERIC_DOMAINS
> @@ -132,7 +138,8 @@ extern struct dev_power_governor simple_qos_governor;
>  extern struct generic_pm_domain *dev_to_genpd(struct device *dev);
>  extern int __pm_genpd_add_device(struct generic_pm_domain *genpd,
>                                  struct device *dev,
> -                                struct gpd_timing_data *td);
> +                                struct gpd_timing_data *td,
> +                                enum genpd_rpmflags flags);
>
>  extern int __pm_genpd_of_add_device(struct device_node *genpd_node,
>                                     struct device *dev,
> @@ -180,7 +187,8 @@ static inline struct generic_pm_domain *dev_to_genpd(struct device *dev)
>  }
>  static inline int __pm_genpd_add_device(struct generic_pm_domain *genpd,
>                                         struct device *dev,
> -                                       struct gpd_timing_data *td)
> +                                       struct gpd_timing_data *td,
> +                                       enum genpd_rpmflags flags);
>  {
>         return -ENOSYS;
>  }
> @@ -263,10 +271,15 @@ static inline bool default_stop_ok(struct device *dev)
>  #define pm_domain_always_on_gov NULL
>  #endif
>
> +static inline int pm_genpd_add_device_rpmsync(struct generic_pm_domain *genpd,
> +                                     struct device *dev)
> +{
> +       return __pm_genpd_add_device(genpd, dev, NULL, GENPD_RPM_SYNC);
> +}
>  static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
>                                       struct device *dev)
>  {
> -       return __pm_genpd_add_device(genpd, dev, NULL);
> +       return __pm_genpd_add_device(genpd, dev, NULL, GENPD_RPM_ASYNC);
>  }
>
>  static inline int pm_genpd_of_add_device(struct device_node *genpd_node,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
