Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbaJ2NLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:11:33 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:50881 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933073AbaJ2NLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <1413543482-12748-1-git-send-email-a.hajda@samsung.com>
References: <1413543482-12748-1-git-send-email-a.hajda@samsung.com>
Date: Wed, 29 Oct 2014 14:11:27 +0100
Message-ID: <CAPDyKFqPB9suSmoH20WWywZ5BWDveSopyvUdA1g8LX309aPVNA@mail.gmail.com>
Subject: Re: [PATCH] PM / Runtime: Rework RPM get callback routines
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2014 12:58, Andrzej Hajda <a.hajda@samsung.com> wrote:
> PM uses three separate functions to fetch RPM callbacks.
> These functions uses quite complicated macro in their body.
> The patch replaces these routines with one small macro and
> one helper function.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi,
>
> I guess such constructs (offsetof and void* arithmetic) are little bit

I haven't seen this kind of constructs, but I like them. It simplifies
the code and removes the ugly macro, which I added some time ago.

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> controversial. On the other side they seems to me more clear than the
> current solution. For sure they produce better code:
>    8186      72      24    8282    205a drivers/base/power/runtime.old.o
>    7938      72      24    8034    1f62 drivers/base/power/runtime.o
>
> Regards
> Andrzej
> ---
>  drivers/base/power/runtime.c | 69 +++++++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 67c7938..8f1ab84 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -13,42 +13,39 @@
>  #include <trace/events/rpm.h>
>  #include "power.h"
>
> -#define RPM_GET_CALLBACK(dev, cb)                              \
> -({                                                             \
> -       int (*__rpm_cb)(struct device *__d);                    \
> -                                                               \
> -       if (dev->pm_domain)                                     \
> -               __rpm_cb = dev->pm_domain->ops.cb;              \
> -       else if (dev->type && dev->type->pm)                    \
> -               __rpm_cb = dev->type->pm->cb;                   \
> -       else if (dev->class && dev->class->pm)                  \
> -               __rpm_cb = dev->class->pm->cb;                  \
> -       else if (dev->bus && dev->bus->pm)                      \
> -               __rpm_cb = dev->bus->pm->cb;                    \
> -       else                                                    \
> -               __rpm_cb = NULL;                                \
> -                                                               \
> -       if (!__rpm_cb && dev->driver && dev->driver->pm)        \
> -               __rpm_cb = dev->driver->pm->cb;                 \
> -                                                               \
> -       __rpm_cb;                                               \
> -})
> -
> -static int (*rpm_get_suspend_cb(struct device *dev))(struct device *)
> -{
> -       return RPM_GET_CALLBACK(dev, runtime_suspend);
> -}
> +typedef int (*pm_callback_t)(struct device *);
>
> -static int (*rpm_get_resume_cb(struct device *dev))(struct device *)
> +static pm_callback_t __rpm_get_callback(struct device *dev, size_t cb_offset)
>  {
> -       return RPM_GET_CALLBACK(dev, runtime_resume);
> +       pm_callback_t cb;
> +       const struct dev_pm_ops *ops;
> +
> +       if (dev->pm_domain)
> +               ops = &dev->pm_domain->ops;
> +       else if (dev->type && dev->type->pm)
> +               ops = dev->type->pm;
> +       else if (dev->class && dev->class->pm)
> +               ops = dev->class->pm;
> +       else if (dev->bus && dev->bus->pm)
> +               ops = dev->bus->pm;
> +       else
> +               ops = NULL;
> +
> +       if (ops)
> +               cb = *(pm_callback_t *)((void *)ops + cb_offset);
> +       else
> +               cb = NULL;
> +
> +       if (!cb && dev->driver && dev->driver->pm)
> +               cb = *(pm_callback_t *)((void *)dev->driver->pm + cb_offset);
> +
> +       return cb;
>  }
>
> +#define RPM_GET_CALLBACK(dev, callback) \
> +               __rpm_get_callback(dev, offsetof(struct dev_pm_ops, callback))
> +
>  #ifdef CONFIG_PM_RUNTIME
> -static int (*rpm_get_idle_cb(struct device *dev))(struct device *)
> -{
> -       return RPM_GET_CALLBACK(dev, runtime_idle);
> -}
>
>  static int rpm_resume(struct device *dev, int rpmflags);
>  static int rpm_suspend(struct device *dev, int rpmflags);
> @@ -347,7 +344,7 @@ static int rpm_idle(struct device *dev, int rpmflags)
>
>         dev->power.idle_notification = true;
>
> -       callback = rpm_get_idle_cb(dev);
> +       callback = RPM_GET_CALLBACK(dev, runtime_idle);
>
>         if (callback)
>                 retval = __rpm_callback(callback, dev);
> @@ -517,7 +514,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
>
>         __update_runtime_status(dev, RPM_SUSPENDING);
>
> -       callback = rpm_get_suspend_cb(dev);
> +       callback = RPM_GET_CALLBACK(dev, runtime_suspend);
>
>         retval = rpm_callback(callback, dev);
>         if (retval)
> @@ -737,7 +734,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
>
>         __update_runtime_status(dev, RPM_RESUMING);
>
> -       callback = rpm_get_resume_cb(dev);
> +       callback = RPM_GET_CALLBACK(dev, runtime_resume);
>
>         retval = rpm_callback(callback, dev);
>         if (retval) {
> @@ -1431,7 +1428,7 @@ int pm_runtime_force_suspend(struct device *dev)
>         if (pm_runtime_status_suspended(dev))
>                 return 0;
>
> -       callback = rpm_get_suspend_cb(dev);
> +       callback = RPM_GET_CALLBACK(dev, runtime_suspend);
>
>         if (!callback) {
>                 ret = -ENOSYS;
> @@ -1467,7 +1464,7 @@ int pm_runtime_force_resume(struct device *dev)
>         int (*callback)(struct device *);
>         int ret = 0;
>
> -       callback = rpm_get_resume_cb(dev);
> +       callback = RPM_GET_CALLBACK(dev, runtime_resume);
>
>         if (!callback) {
>                 ret = -ENOSYS;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
