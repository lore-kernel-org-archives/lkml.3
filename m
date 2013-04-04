Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab3DDKs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:48:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64723 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab3DDKs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:48:26 -0400
MIME-Version: 1.0
In-Reply-To: <87fvz7zdht.fsf@linaro.org>
References: <1364392374-12236-1-git-send-email-rajagopal.venkat@linaro.org>
	<1364392374-12236-3-git-send-email-rajagopal.venkat@linaro.org>
	<87fvz7zdht.fsf@linaro.org>
Date: Thu, 4 Apr 2013 16:18:25 +0530
Message-ID: <CA+Z25wWEf2_v4+j7Khxo9FaVnqB6+xezvkg5EZ1sLw2fUyvV6Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] PM / devfreq: tie suspend/resume to runtime-pm
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: myungjoo.ham@samsung.com, rjw@sisk.pl,
        Alan Stern <stern@rowland.harvard.edu>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2013 23:46, Kevin Hilman <khilman@linaro.org> wrote:
> Rajagopal Venkat <rajagopal.venkat@linaro.org> writes:
>
>> Devfreq core suspend/resume of a device is explicitly handled
>> by devfreq driver through devfreq_suspend_device() and
>> devfreq_resume_device() apis typically called from runtime
>> suspend/resume callbacks. This patch aims to take away this
>> from devfreq drivers and handle it from runtime-pm core. So
>> that device devfreq core suspend/resume is automatically done
>> with runtime pm suspend/resume. The devfreq drivers shouldn't
>> be concerned on when to suspend/resume the devfreq.
>
> The terminology is a bit confusing here since you're mixing runtime
> suspend/resume and just suspend/resume.  AFAICT, this patch is only
> handling devfreq in the runtime PM core, correct?

Yes correct. The suspend/resume refers to devfreq core suspend/resume
of a device. Nothing to do with system wide suspend/resume. May be I
am not clear enough. I will update it.

>
> Also, how does this work when multiple devices may be using the same

As per the devfreq design, this is not allowed. Only one devfreq
instance can be associated with a device.

> devfreq instance?  Using this patch, it looks like the devfreq governor
> will be shutdown as soon as the first device runtime suspends, right?
>
>> This patch is targeted to handle devfreq core load monitoring
>> suspend/resume only. Not the actual hardware itself. All the
>> resources like clocks and regulators must still be handled by
>> devfreq driver using runtime-pm. The sequence of devfreq and
>   ^^^^^^^
> devfreq driver?  Did you mean device driver?

Yes. device driver.

>
> Kevin
>
>> device runtime suspend/resume is,
>>
>> pm_runtime_suspend(dev) will first suspend device devfreq
>> (if available) before device is suspended to ensure devfreq load
>> monitoring is stopped and no device resources like clocks are
>> accessed while device suspend is in progress.
>>
>> pm_runtime_resume(dev) will resume device devfreq(if available)
>> after device is resumed to ensure device resources like clocks
>> are ready for use.
>>
>> As devfreq suspend/resume is done automatically from runtime-pm,
>> this patch removes the existing devfreq_suspend_device() and
>> devfreq_resume_device() apis.
>>
>> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
>> ---
>>  drivers/base/power/runtime.c |   21 ++++++++++++-
>>  drivers/devfreq/devfreq.c    |   69 +++++++++++++++++++++++++++++++++++++++---
>>  include/linux/devfreq.h      |   18 +++--------
>>  include/linux/pm.h           |    2 ++
>>  4 files changed, 91 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
>> index 3148b10..2438abc 100644
>> --- a/drivers/base/power/runtime.c
>> +++ b/drivers/base/power/runtime.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/export.h>
>>  #include <linux/pm_runtime.h>
>>  #include <trace/events/rpm.h>
>> +#include <linux/devfreq.h>
>>  #include "power.h"
>>
>>  static int rpm_resume(struct device *dev, int rpmflags);
>> @@ -406,6 +407,14 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>>
>>       __update_runtime_status(dev, RPM_SUSPENDING);
>>
>> +     /*
>> +      * Try suspending devfreq before device is runtime suspended.
>> +      * It wouldn't make sense to continue devfreq load monitoring
>> +      * when device is runtime suspended.
>> +      */
>> +     if (dev->power.devfreq && dev->power.devfreq->runtime_suspend)
>> +             dev->power.devfreq->runtime_suspend(dev);
>> +
>>       if (dev->pm_domain)
>>               callback = dev->pm_domain->ops.runtime_suspend;
>>       else if (dev->type && dev->type->pm)
>> @@ -421,8 +430,12 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>>               callback = dev->driver->pm->runtime_suspend;
>>
>>       retval = rpm_callback(callback, dev);
>> -     if (retval)
>> +     if (retval) {
>> +             /* Resume back devfreq on device suspend failure */
>> +             if (dev->power.devfreq && dev->power.devfreq->runtime_resume)
>> +                     dev->power.devfreq->runtime_resume(dev);
>>               goto fail;
>> +     }
>>
>>   no_callback:
>>       __update_runtime_status(dev, RPM_SUSPENDED);
>> @@ -661,6 +674,12 @@ static int rpm_resume(struct device *dev, int rpmflags)
>>               __update_runtime_status(dev, RPM_ACTIVE);
>>               if (parent)
>>                       atomic_inc(&parent->power.child_count);
>> +             /*
>> +              * Resume devfreq after runtime resume sequence to ensure
>> +              * device resources are available for devfreq load monitoring.
>> +              */
>> +             if (dev->power.devfreq && dev->power.devfreq->runtime_resume)
>> +                     dev->power.devfreq->runtime_resume(dev);
>>       }
>>       wake_up_all(&dev->power.wait_queue);
>>
>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>> index 44c4079..b8dab0d 100644
>> --- a/drivers/devfreq/devfreq.c
>> +++ b/drivers/devfreq/devfreq.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/list.h>
>>  #include <linux/printk.h>
>>  #include <linux/hrtimer.h>
>> +#include <linux/pm_runtime.h>
>>  #include "governor.h"
>>
>>  static struct class *devfreq_class;
>> @@ -42,6 +43,9 @@ static LIST_HEAD(devfreq_governor_list);
>>  static LIST_HEAD(devfreq_list);
>>  static DEFINE_MUTEX(devfreq_list_lock);
>>
>> +static void devfreq_runtime_suspend(struct device *dev);
>> +static void devfreq_runtime_resume(struct device *dev);
>> +
>>  /**
>>   * find_device_devfreq() - find devfreq struct using device pointer
>>   * @dev:     device pointer used to lookup device devfreq.
>> @@ -387,6 +391,8 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
>>   */
>>  static void _remove_devfreq(struct devfreq *devfreq, bool skip)
>>  {
>> +     unsigned long flags;
>> +
>>       mutex_lock(&devfreq_list_lock);
>>       if (IS_ERR(find_device_devfreq(devfreq->dev.parent))) {
>>               mutex_unlock(&devfreq_list_lock);
>> @@ -400,6 +406,10 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
>>               devfreq->governor->event_handler(devfreq,
>>                                                DEVFREQ_GOV_STOP, NULL);
>>
>> +     spin_lock_irqsave(&devfreq->dev.parent->power.lock, flags);
>> +     devfreq->dev.parent->power.devfreq = NULL;
>> +     spin_unlock_irqrestore(&devfreq->dev.parent->power.lock, flags);
>> +
>>       if (devfreq->profile->exit)
>>               devfreq->profile->exit(devfreq->dev.parent);
>>
>> @@ -442,6 +452,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>  {
>>       struct devfreq *devfreq;
>>       struct devfreq_governor *governor;
>> +     unsigned long flags;
>>       int err = 0;
>>
>>       if (!dev || !profile || !governor_name) {
>> @@ -476,6 +487,12 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>       devfreq->previous_freq = profile->initial_freq;
>>       devfreq->data = data;
>>       devfreq->nb.notifier_call = devfreq_notifier_call;
>> +     devfreq->runtime_suspend = devfreq_runtime_suspend;
>> +     devfreq->runtime_resume = devfreq_runtime_resume;
>> +     spin_lock_irqsave(&dev->power.lock, flags);
>> +     dev->power.devfreq = devfreq;
>> +     spin_unlock_irqrestore(&dev->power.lock, flags);
>> +
>>
>>       devfreq->trans_table =  devm_kzalloc(dev, sizeof(unsigned int) *
>>                                               devfreq->profile->max_state *
>> @@ -549,7 +566,7 @@ EXPORT_SYMBOL(devfreq_remove_device);
>>   * (e.g., runtime_suspend, suspend) of the device driver that
>>   * holds the devfreq.
>>   */
>> -int devfreq_suspend_device(struct devfreq *devfreq)
>> +static int devfreq_suspend_device(struct devfreq *devfreq)
>>  {
>>       if (!devfreq)
>>               return -EINVAL;
>> @@ -560,7 +577,6 @@ int devfreq_suspend_device(struct devfreq *devfreq)
>>       return devfreq->governor->event_handler(devfreq,
>>                               DEVFREQ_GOV_SUSPEND, NULL);
>>  }
>> -EXPORT_SYMBOL(devfreq_suspend_device);
>>
>>  /**
>>   * devfreq_resume_device() - Resume devfreq of a device.
>> @@ -570,7 +586,7 @@ EXPORT_SYMBOL(devfreq_suspend_device);
>>   * (e.g., runtime_resume, resume) of the device driver that
>>   * holds the devfreq.
>>   */
>> -int devfreq_resume_device(struct devfreq *devfreq)
>> +static int devfreq_resume_device(struct devfreq *devfreq)
>>  {
>>       if (!devfreq)
>>               return -EINVAL;
>> @@ -581,7 +597,52 @@ int devfreq_resume_device(struct devfreq *devfreq)
>>       return devfreq->governor->event_handler(devfreq,
>>                               DEVFREQ_GOV_RESUME, NULL);
>>  }
>> -EXPORT_SYMBOL(devfreq_resume_device);
>> +
>> +/**
>> + * devfreq_runtime_suspend() - Suspend devfreq of a device.
>> + * @dev: the device associated with devfreq
>> + *
>> + * This function is intended to be called by the runtime-pm
>> + * core when the device associated with devfreq is
>> + * runtime suspended.
>> + */
>> +static void devfreq_runtime_suspend(struct device *dev)
>> +{
>> +     struct devfreq *devfreq;
>> +     int err;
>> +
>> +     mutex_lock(&devfreq_list_lock);
>> +     devfreq = find_device_devfreq(dev);
>> +     mutex_unlock(&devfreq_list_lock);
>> +
>> +     err = devfreq_suspend_device(devfreq);
>> +     if (err)
>> +             dev_err(dev, "devfreq runtime suspend failed with (%d) error\n",
>> +                     err);
>> +}
>> +
>> +/**
>> + * devfreq_runtime_resume() - Resume devfreq of a device.
>> + * @dev: the device associated with devfreq
>> + *
>> + * This function is intended to be called by the runtime-pm
>> + * core when the device associated with devfreq is
>> + * runtime resumed.
>> + */
>> +static void devfreq_runtime_resume(struct device *dev)
>> +{
>> +     struct devfreq *devfreq;
>> +     int err;
>> +
>> +     mutex_lock(&devfreq_list_lock);
>> +     devfreq = find_device_devfreq(dev);
>> +     mutex_unlock(&devfreq_list_lock);
>> +
>> +     err = devfreq_resume_device(devfreq);
>> +     if (err)
>> +             dev_err(dev, "devfreq runtime resume failed with (%d) error\n",
>> +                     err);
>> +}
>>
>>  /**
>>   * devfreq_add_governor() - Add devfreq governor
>> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
>> index 5f1ab92..669368b 100644
>> --- a/include/linux/devfreq.h
>> +++ b/include/linux/devfreq.h
>> @@ -140,6 +140,8 @@ struct devfreq_governor {
>>   * @trans_table:     Statistics of devfreq transitions
>>   * @time_in_state:   Statistics of devfreq states
>>   * @last_stat_updated:       The last time stat updated
>> + * @runtime_suspend: func to runtime suspend devfreq from runtime core
>> + * @runtime_resume:  func to runtime resume devfreq from runtime core
>>   *
>>   * This structure stores the devfreq information for a give device.
>>   *
>> @@ -173,6 +175,8 @@ struct devfreq {
>>       unsigned int *trans_table;
>>       unsigned long *time_in_state;
>>       unsigned long last_stat_updated;
>> +     void (*runtime_suspend)(struct device *dev);
>> +     void (*runtime_resume)(struct device *dev);
>>  };
>>
>>  #if defined(CONFIG_PM_DEVFREQ)
>> @@ -182,10 +186,6 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
>>                                 void *data);
>>  extern int devfreq_remove_device(struct devfreq *devfreq);
>>
>> -/* Supposed to be called by PM_SLEEP/PM_RUNTIME callbacks */
>> -extern int devfreq_suspend_device(struct devfreq *devfreq);
>> -extern int devfreq_resume_device(struct devfreq *devfreq);
>> -
>>  /* Helper functions for devfreq user device driver with OPP. */
>>  extern struct opp *devfreq_recommended_opp(struct device *dev,
>>                                          unsigned long *freq, u32 flags);
>> @@ -228,16 +228,6 @@ static inline int devfreq_remove_device(struct devfreq *devfreq)
>>       return 0;
>>  }
>>
>> -static inline int devfreq_suspend_device(struct devfreq *devfreq)
>> -{
>> -     return 0;
>> -}
>> -
>> -static inline int devfreq_resume_device(struct devfreq *devfreq)
>> -{
>> -     return 0;
>> -}
>> -
>>  static inline struct opp *devfreq_recommended_opp(struct device *dev,
>>                                          unsigned long *freq, u32 flags)
>>  {
>> diff --git a/include/linux/pm.h b/include/linux/pm.h
>> index 03d7bb1..734449c 100644
>> --- a/include/linux/pm.h
>> +++ b/include/linux/pm.h
>> @@ -40,6 +40,7 @@ extern void (*pm_power_off_prepare)(void);
>>   */
>>
>>  struct device;
>> +struct devfreq;
>>
>>  #ifdef CONFIG_PM
>>  extern const char power_group_name[];                /* = "power" */
>> @@ -549,6 +550,7 @@ struct dev_pm_info {
>>  #endif
>>       struct pm_subsys_data   *subsys_data;  /* Owned by the subsystem. */
>>       struct dev_pm_qos       *qos;
>> +     struct devfreq          *devfreq;  /* device devfreq */
>>  };
>>
>>  extern void update_pm_runtime_accounting(struct device *dev);



-- 
Regards,
Rajagopal
