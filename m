Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3CYGNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:13:31 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:40030 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab3CYGNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:13:30 -0400
MIME-Version: 1.0
In-Reply-To: <87fvzncp91.fsf@linaro.org>
References: <1363872506-3630-1-git-send-email-rajagopal.venkat@linaro.org>
	<1363872506-3630-3-git-send-email-rajagopal.venkat@linaro.org>
	<87fvzncp91.fsf@linaro.org>
Date: Mon, 25 Mar 2013 11:43:29 +0530
Message-ID: <CA+Z25wWE8wNiDeDXs2Xc9tW8kDQwUWgPScUaz7NqkkoKv1XLUA@mail.gmail.com>
Subject: Re: [PATCH 2/2] PM / devfreq: tie suspend/resume to runtime-pm
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: myungjoo.ham@samsung.com, rjw@sisk.pl, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 23:04, Kevin Hilman <khilman@linaro.org> wrote:
> Hi Rajagopal,
>
> Rajagopal Venkat <rajagopal.venkat@linaro.org> writes:
>
>> Allow device devfreq to be suspend/resume automatically with
>> runtime pm suspend/resume. The devfreq drivers should be least
>> cared when to suspend/resume the devfreq.
>
> That is the "what", but the changelog should also answer the question
> "why?".
>
>> pm_runtime_suspend(dev) will first suspend device devfreq(if available)
>> before device is suspended from runtime pm core.
>
> And here you should describe what you mentioned in your response to Alan
> to clarify that suspending devfreq is suspending/resuming the load
> monitoring, not any actual device hardware.  You should also describe
> the rationale behind the ordering of devfreq susepnd/resume and device
> suspend/resume.
>

Kevin, Thanks for the review, I am taking in all your comments. I will
improve the changelog and code comments and send new version.

>> pm_runtime_resume(dev) will resume device devfreq(if available) after
>> device is resumed from runtime pm core.
>>
>> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
>> ---
>>  drivers/base/power/runtime.c |   18 ++++++++++++++-
>>  drivers/devfreq/devfreq.c    |   51 ++++++++++++++++++++++++++++++++++++++----
>>  include/linux/devfreq.h      |   18 ++++-----------
>>  include/linux/pm.h           |    2 ++
>>  4 files changed, 70 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
>> index 3148b10..951bf92 100644
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
>> @@ -406,6 +407,10 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>>
>>       __update_runtime_status(dev, RPM_SUSPENDING);
>>
>> +     if (dev->power.devfreq &&
>> +                     dev->power.devfreq->runtime_suspend(dev))
>> +             goto fail;
>
> It's not obvious to me why you want to abort the entire runtime suspend
> path if the devfreq governor fails to runtime suspend.  That should also
> be described someplace.
>
> Same comment on skipping the callbacks in rpm_resume below.
>
>>       if (dev->pm_domain)
>>               callback = dev->pm_domain->ops.runtime_suspend;
>>       else if (dev->type && dev->type->pm)
>> @@ -421,8 +426,11 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>>               callback = dev->driver->pm->runtime_suspend;
>>
>>       retval = rpm_callback(callback, dev);
>> -     if (retval)
>> +     if (retval) {
>> +             if (dev->power.devfreq)
>> +                     dev->power.devfreq->runtime_resume(dev);
>
> What if ->runtime_resume is NULL?
>
>>               goto fail;
>> +     }
>>
>>   no_callback:
>>       __update_runtime_status(dev, RPM_SUSPENDED);
>> @@ -638,6 +646,11 @@ static int rpm_resume(struct device *dev, int rpmflags)
>>
>>       __update_runtime_status(dev, RPM_RESUMING);
>>
>> +     if (dev->power.devfreq)
>> +             retval = dev->power.devfreq->runtime_resume(dev);
>
> ditto.
>
> I see that the devfreq core always sets these function pointers in this
> patch, but that's not an assumption the PM core should make, IMO.
>
>> +             if (retval)
>> +                     goto skip_callback;
>> +
>>       if (dev->pm_domain)
>>               callback = dev->pm_domain->ops.runtime_resume;
>>       else if (dev->type && dev->type->pm)
>> @@ -653,9 +666,12 @@ static int rpm_resume(struct device *dev, int rpmflags)
>>               callback = dev->driver->pm->runtime_resume;
>>
>>       retval = rpm_callback(callback, dev);
>> +skip_callback:
>>       if (retval) {
>>               __update_runtime_status(dev, RPM_SUSPENDED);
>>               pm_runtime_cancel_pending(dev);
>> +             if (dev->power.devfreq)
>> +                     dev->power.devfreq->runtime_suspend(dev);
>>       } else {
>>   no_callback:
>>               __update_runtime_status(dev, RPM_ACTIVE);
>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>> index 44c4079..ed6cb88 100644
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
>> +static int devfreq_runtime_suspend(struct device *dev);
>> +static int devfreq_runtime_resume(struct device *dev);
>> +
>>  /**
>>   * find_device_devfreq() - find devfreq struct using device pointer
>>   * @dev:     device pointer used to lookup device devfreq.
>> @@ -476,6 +480,9 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>       devfreq->previous_freq = profile->initial_freq;
>>       devfreq->data = data;
>>       devfreq->nb.notifier_call = devfreq_notifier_call;
>> +     devfreq->runtime_suspend = devfreq_runtime_suspend;
>> +     devfreq->runtime_resume = devfreq_runtime_resume;
>> +     dev->power.devfreq = devfreq;
>>
>>       devfreq->trans_table =  devm_kzalloc(dev, sizeof(unsigned int) *
>>                                               devfreq->profile->max_state *
>> @@ -549,7 +556,7 @@ EXPORT_SYMBOL(devfreq_remove_device);
>>   * (e.g., runtime_suspend, suspend) of the device driver that
>>   * holds the devfreq.
>>   */
>> -int devfreq_suspend_device(struct devfreq *devfreq)
>> +static int devfreq_suspend_device(struct devfreq *devfreq)
>>  {
>>       if (!devfreq)
>>               return -EINVAL;
>> @@ -560,7 +567,6 @@ int devfreq_suspend_device(struct devfreq *devfreq)
>>       return devfreq->governor->event_handler(devfreq,
>>                               DEVFREQ_GOV_SUSPEND, NULL);
>>  }
>> -EXPORT_SYMBOL(devfreq_suspend_device);
>
>>  /**
>>   * devfreq_resume_device() - Resume devfreq of a device.
>> @@ -570,7 +576,7 @@ EXPORT_SYMBOL(devfreq_suspend_device);
>>   * (e.g., runtime_resume, resume) of the device driver that
>>   * holds the devfreq.
>>   */
>> -int devfreq_resume_device(struct devfreq *devfreq)
>> +static int devfreq_resume_device(struct devfreq *devfreq)
>>  {
>>       if (!devfreq)
>>               return -EINVAL;
>> @@ -581,7 +587,44 @@ int devfreq_resume_device(struct devfreq *devfreq)
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
>> +static int devfreq_runtime_suspend(struct device *dev)
>> +{
>> +     struct devfreq *devfreq;
>> +
>> +     mutex_lock(&devfreq_list_lock);
>> +     devfreq = find_device_devfreq(dev);
>> +     mutex_unlock(&devfreq_list_lock);
>> +
>> +     return devfreq_suspend_device(devfreq);
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
>> +static int devfreq_runtime_resume(struct device *dev)
>> +{
>> +     struct devfreq *devfreq;
>> +
>> +     mutex_lock(&devfreq_list_lock);
>> +     devfreq = find_device_devfreq(dev);
>> +     mutex_unlock(&devfreq_list_lock);
>> +
>> +     return devfreq_resume_device(devfreq);
>> +}
>>
>>  /**
>>   * devfreq_add_governor() - Add devfreq governor
>> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
>> index 5f1ab92..f50f46e 100644
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
>> +     int (*runtime_suspend)(struct device *dev);
>> +     int (*runtime_resume)(struct device *dev);
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
>
> Remvoing these, and removing the EXPORT_SYMBOL()s is an API change that
> is not described in the changelog.
>
> Kevin
>
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
>> index 03d7bb1..6097db1 100644
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
>> +     struct devfreq          *devfreq;
>>  };
>>
>>  extern void update_pm_runtime_accounting(struct device *dev);



-- 
Regards,
Rajagopal
