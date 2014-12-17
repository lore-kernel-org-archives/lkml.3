Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaLQCnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:43:50 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:65367 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaLQCns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:43:48 -0500
MIME-Version: 1.0
In-Reply-To: <54901341.20106@samsung.com>
References: <1418489518-7252-1-git-send-email-amit.daniel@samsung.com>
	<54901341.20106@samsung.com>
Date: Wed, 17 Dec 2014 08:13:47 +0530
X-Google-Sender-Auth: KixkTLXo6lxWYfUGK1glX_vwrfI
Message-ID: <CADGdYn60ONwuLtcdXSegbQLgFaF-me+mZY6-LPYRQvdfmWFMdA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/2] PM / Domains: Extend API pm_genpd_dev_need_restore
 to use restore types
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 4:40 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On 2014-12-13 17:51, Amit Daniel Kachhap wrote:
>>
>> Instead of using bool to restore suspended devices initially, use flags
>> like GPD_DEV_SUSPEND_INIT, GPD_DEV_RESTORE_INIT and GPD_DEV_RESTORE_FORCE.
>> The first two flags will be similar to the existing true/false
>> functionality.
>> The third flag may be used to force restore of suspended devices
>> whenever their associated power domain is turned on.
>>
>> Currently, PD power off function powers off all the associated unused
>> devices. The functionality added in this patch is similar to it.
>>
>> This feature may be used for those devices which are always in ON state
>> if the PD associated with them is ON but may need local runtime resume
>> and suspend during PD On/Off. These devices (like clock) may not implement
>> complete pm_runtime calls such as pm_runtime_get/pm_runtime_put due to
>> subsystems interaction behaviour or any other reason.
>>
>> The model works like,
>>      DEV1 (Attaches itself with PD but no calls to pm_runtime_get and
>>      /  pm_runtime_put. Its local runtime_suspend/resume is invoked via
>>     /   GPD_DEV_RESTORE_FORCE option)
>>    /
>> PD -- DEV2 (Implements complete PM runtime and calls pm_runtime_get and
>>    \    pm_runtime_put. This in turn invokes PD On/Off)
>>     \
>>      DEV3 (Similar to DEV1)
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>
>
> The idea of adding new gen_pd flag and reusing runtime pm calls intead of
> additional
> notifiers looks promising, but I have some doubts. I don't see any guarantee
> that
> devices with GPD_DEV_RESTORE_FORCE flag will be suspended after all "normal"
> devices
> and restored before them. Without such assumption it will be hard to use
> this approach
> for iommu related activities, because device might need to use (in its
> suspend/resume
> callbacks) the functionality provided by the other device with
> GPD_DEV_RESTORE_FORCE
> flag. Maybe some additional flags like suspend/resume priority (or more
> flags) will
> solve somehow this dependency.

Hi Marek,

Thanks for pointing this issue out. I agree that there is no priority
in suspending devices with this flag. But this works well in syncing
with power domain on/off as the devices of these types have only
dependency with power domain. BTW I tested this implementation with
your first version of IOMMU save/restore patches. Although i have not
posted those but they work fine. I can post those after cleaning them
up.
Here, the ordering between various devices is taken care as they are
probed at different point of time(clock then IOMMU). so the suspend
happens in reverse probe order and resume happens in probe order. I
will check more on this and get back.

Thanks,
Amit Daniel

>
>
>> ---
>> This work is continuation of earlier work,
>>
>> In V2: Completely removed notfiers and add support for huge clock list to
>> be
>>         suspended and restored. There was some issue in this as some
>> clocks are
>>         not exposed and are just initialised by bootloaders. This approach
>>         required all of them to be exposed which is cumbersome. Also some
>>         clock API's set_parent are disabling the original parent clocks
>>         which is not required.
>>         Link (https://lkml.org/lkml/2014/11/24/290)
>>
>> In V1: Implemented PM Domain notfier such as PD_ON_PRE, PD_ON_POST
>>         PD_OFF_PRE and PD_OFF_POST. This was not supported and other
>>         options suggested. link
>> (http://www.spinics.net/lists/linux-samsung-soc/msg38442.html)
>>
>> This work may also assist exynos iommu pm runtime posted earlier by Marek
>> http://lists.linaro.org/pipermail/linaro-mm-sig/2014-August/004099.html
>>
>>   drivers/base/power/domain.c | 40
>> ++++++++++++++++++++++++++++++++++++----
>>   include/linux/pm_domain.h   | 15 +++++++++++++--
>>   2 files changed, 49 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
>> index 6a103a3..d955a05 100644
>> --- a/drivers/base/power/domain.c
>> +++ b/drivers/base/power/domain.c
>> @@ -49,6 +49,7 @@
>>     static LIST_HEAD(gpd_list);
>>   static DEFINE_MUTEX(gpd_list_lock);
>> +static void __pm_genpd_restore_devices(struct generic_pm_domain *genpd);
>>     static struct generic_pm_domain *pm_genpd_lookup_name(const char
>> *domain_name)
>>   {
>> @@ -176,6 +177,8 @@ static int genpd_power_on(struct generic_pm_domain
>> *genpd)
>>         pr_warn("%s: Power-%s latency exceeded, new value %lld ns\n",
>>                 genpd->name, "on", elapsed_ns);
>>   +     __pm_genpd_restore_devices(genpd);
>> +
>>         return ret;
>>   }
>>   @@ -453,6 +456,24 @@ static void __pm_genpd_restore_device(struct
>> pm_domain_data *pdd,
>>   }
>>     /**
>> + * __pm_genpd_restore_devices- Restore the pre-suspend state of all
>> device
>> + *                             according to the restore flag.
>> + * @genpd: PM domain the device belongs to.
>> + */
>> +static void __pm_genpd_restore_devices(struct generic_pm_domain *genpd)
>> +{
>> +       struct pm_domain_data *pdd;
>> +       struct generic_pm_domain_data *gpd_data;
>> +
>> +       /* Force restore the devices according to the restore flag */
>> +       list_for_each_entry(pdd, &genpd->dev_list, list_node) {
>> +               gpd_data = to_gpd_data(pdd);
>> +               if (gpd_data->force_restore == true)
>> +                       __pm_genpd_restore_device(pdd, genpd);
>> +       }
>> +}
>> +
>> +/**
>>    * genpd_abort_poweroff - Check if a PM domain power off should be
>> aborted.
>>    * @genpd: PM domain to check.
>>    *
>> @@ -1469,6 +1490,7 @@ int __pm_genpd_add_device(struct generic_pm_domain
>> *genpd, struct device *dev,
>>         gpd_data->base.dev = dev;
>>         list_add_tail(&gpd_data->base.list_node, &genpd->dev_list);
>>         gpd_data->need_restore = -1;
>> +       gpd_data->force_restore = false;
>>         gpd_data->td.constraint_changed = true;
>>         gpd_data->td.effective_constraint_ns = -1;
>>         mutex_unlock(&gpd_data->lock);
>> @@ -1561,18 +1583,28 @@ int pm_genpd_remove_device(struct
>> generic_pm_domain *genpd,
>>   /**
>>    * pm_genpd_dev_need_restore - Set/unset the device's "need restore"
>> flag.
>>    * @dev: Device to set/unset the flag for.
>> - * @val: The new value of the device's "need restore" flag.
>> + * @val: This can have values GPD_DEV_SUSPEND_INIT or
>> GPD_DEV_RESTORE_INIT
>> + *     together with GPD_DEV_RESTORE_FORCE.
>>    */
>> -void pm_genpd_dev_need_restore(struct device *dev, bool val)
>> +void pm_genpd_dev_need_restore(struct device *dev, unsigned int val)
>>   {
>>         struct pm_subsys_data *psd;
>> +       struct generic_pm_domain_data *pdd;
>>         unsigned long flags;
>>         spin_lock_irqsave(&dev->power.lock, flags);
>>         psd = dev_to_psd(dev);
>> -       if (psd && psd->domain_data)
>> -               to_gpd_data(psd->domain_data)->need_restore = val ? 1 : 0;
>> +       if (psd && psd->domain_data) {
>> +               pdd = to_gpd_data(psd->domain_data);
>> +               if (val & GPD_DEV_SUSPEND_INIT)
>> +                       pdd->need_restore = 0;
>> +               else if (val & GPD_DEV_RESTORE_INIT)
>> +                       pdd->need_restore = 1;
>> +
>> +               if (val & GPD_DEV_RESTORE_FORCE)
>> +                       pdd->force_restore = true;
>> +       }
>>         spin_unlock_irqrestore(&dev->power.lock, flags);
>>   }
>> diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
>> index 6cd20d5..8aa74ee 100644
>> --- a/include/linux/pm_domain.h
>> +++ b/include/linux/pm_domain.h
>> @@ -20,6 +20,15 @@
>>   /* Defines used for the flags field in the struct generic_pm_domain */
>>   #define GENPD_FLAG_PM_CLK     (1U << 0) /* PM domain uses PM clk */
>>   +/* Defines used for the types of restore */
>> +#define        GPD_DEV_SUSPEND_INIT    0x1     /* Initiate the device
>> runtime as
>> +                                          suspend/resume/suspend... */
>> +#define        GPD_DEV_RESTORE_INIT    0x10    /* Initiate the device
>> runtime as
>> +                                          resume/suspend/suspend... */
>> +#define        GPD_DEV_RESTORE_FORCE   0x100   /* Force these devices to
>> always do
>> +                                          resume in PD power on. Initial
>> +                                          behaviour can be one of the
>> above */
>> +
>>   enum gpd_status {
>>         GPD_STATE_ACTIVE = 0,   /* PM domain is active */
>>         GPD_STATE_WAIT_MASTER,  /* PM domain's master is being waited for
>> */
>> @@ -116,6 +125,7 @@ struct generic_pm_domain_data {
>>         struct mutex lock;
>>         unsigned int refcount;
>>         int need_restore;
>> +       bool force_restore;
>>   };
>>     #ifdef CONFIG_PM_GENERIC_DOMAINS
>> @@ -140,7 +150,7 @@ extern int __pm_genpd_name_add_device(const char
>> *domain_name,
>>     extern int pm_genpd_remove_device(struct generic_pm_domain *genpd,
>>                                   struct device *dev);
>> -extern void pm_genpd_dev_need_restore(struct device *dev, bool val);
>> +extern void pm_genpd_dev_need_restore(struct device *dev, unsigned int
>> val);
>>   extern int pm_genpd_add_subdomain(struct generic_pm_domain *genpd,
>>                                   struct generic_pm_domain
>> *new_subdomain);
>>   extern int pm_genpd_add_subdomain_names(const char *master_name,
>> @@ -187,7 +197,8 @@ static inline int pm_genpd_remove_device(struct
>> generic_pm_domain *genpd,
>>   {
>>         return -ENOSYS;
>>   }
>> -static inline void pm_genpd_dev_need_restore(struct device *dev, bool
>> val) {}
>> +static inline void pm_genpd_dev_need_restore(struct device *dev,
>> +                                               unsigned int val) {}
>>   static inline int pm_genpd_add_subdomain(struct generic_pm_domain
>> *genpd,
>>                                          struct generic_pm_domain *new_sd)
>>   {
>
>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
