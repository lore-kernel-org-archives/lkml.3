Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab3HVRRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:17:03 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62097 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3HVRRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:17:01 -0400
MIME-Version: 1.0
In-Reply-To: <1375216733-6740-1-git-send-email-zoran.markovic@linaro.org>
References: <1375216733-6740-1-git-send-email-zoran.markovic@linaro.org>
Date: Thu, 22 Aug 2013 10:16:59 -0700
Message-ID: <CAME+o4=uNFDjz8yFJEQR8P4dwki4U0iBv-FrixTA_TFxWctDSA@mail.gmail.com>
Subject: Re: [RFC PATCHv3] drivers: power: Detect device suspend/resume lockup
 and log event in pstore.
From: Zoran Markovic <zoran.markovic@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>, Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zoran Markovic <zoran.markovic@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,
I haven't seen any other proposals/alternatives on how to do this. Is
there anything else we should do to get this upstream? I believe this
is a valuable debug feature for Android and it now explicitly depends
on pstore...
Thanks,
Zoran

On 30 July 2013 13:38, Zoran Markovic <zoran.markovic@linaro.org> wrote:
> From: Benoit Goby <benoit@android.com>
>
> Rather than hard-lock the kernel, dump the suspend/resume thread stack and
> panic() to capture a message in pstore when a driver takes too long to
> suspend/resume. Default suspend/resume watchdog timeout is set to 12
> seconds to be longer than the usbhid 10 second timeout, but could be
> changed at compile time.
>
> Exclude from the watchdog the time spent waiting for children that
> are resumed asynchronously and time every device, whether or not they
> resumed synchronously.
>
> This patch is targeted for mobile devices where a suspend/resume lockup
> could cause a system reboot. Information about failing device can be
> retrieved in subsequent boot session by mounting pstore and inspecting
> the log.
>
> The hardware watchdog timer is likely suspended during this time and
> couldn't be relied upon. The soft-lockup detector would eventually tell
> that tasks are not scheduled, but would provide little context as to why.
> The patch hence uses system timer and assumes it is still active while the
> devices are suspended/resumed.
>
> This feature can be enabled/disabled during kernel configuration.
>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Colin Cross <ccross@android.com>
> Cc: Todd Poynor <toddpoynor@google.com>
> Cc: San Mehat <san@google.com>
> Cc: Benoit Goby <benoit@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Original-author: San Mehat <san@google.com>
> Signed-off-by: Benoit Goby <benoit@android.com>
> [zoran.markovic@linaro.org: Changed printk(KERN_EMERG,...) to pr_emerg(...),
> tweaked commit message. Minor changes to add compile-time inclusion of
> the feature.]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
> ---
> v3:
> * Added explicit dependency on pstore
> * Collapsed recovery options to system panic only
> * Logged driver string in panic message
>
>  drivers/base/power/main.c |   70 +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/power/Kconfig      |   16 +++++++++++
>  2 files changed, 86 insertions(+)
>
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 5a9b656..c19aec0 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -29,6 +29,8 @@
>  #include <linux/async.h>
>  #include <linux/suspend.h>
>  #include <linux/cpuidle.h>
> +#include <linux/timer.h>
> +
>  #include "../base.h"
>  #include "power.h"
>
> @@ -54,6 +56,12 @@ struct suspend_stats suspend_stats;
>  static DEFINE_MUTEX(dpm_list_mtx);
>  static pm_message_t pm_transition;
>
> +struct dpm_watchdog {
> +       struct device           *dev;
> +       struct task_struct      *tsk;
> +       struct timer_list       timer;
> +};
> +
>  static int async_error;
>
>  /**
> @@ -384,6 +392,60 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
>         return error;
>  }
>
> +#ifdef CONFIG_DPM_WD
> +/**
> + * dpm_wd_handler - Driver suspend / resume watchdog handler.
> + *
> + * Called when a driver has timed out suspending or resuming.
> + * There's not much we can do here to recover so panic() to
> + * capture a crash-dump in pstore.
> + */
> +static void dpm_wd_handler(unsigned long data)
> +{
> +       struct dpm_watchdog *wd = (void *)data;
> +
> +       dev_emerg(wd->dev, "**** DPM device timeout ****\n");
> +       show_stack(wd->tsk, NULL);
> +       panic("%s %s: unrecoverable failure\n",
> +               dev_driver_string(wd->dev), dev_name(wd->dev));
> +}
> +
> +/**
> + * dpm_wd_set - Enable pm watchdog for given device.
> + * @wd: Watchdog. Must be allocated on the stack.
> + * @dev: Device to handle.
> + */
> +static void dpm_wd_set(struct dpm_watchdog *wd, struct device *dev)
> +{
> +       struct timer_list *timer = &wd->timer;
> +
> +       wd->dev = dev;
> +       wd->tsk = get_current();
> +
> +       init_timer_on_stack(timer);
> +       /* use same timeout value for both suspend and resume */
> +       timer->expires = jiffies + HZ * CONFIG_DPM_WD_TIMEOUT;
> +       timer->function = dpm_wd_handler;
> +       timer->data = (unsigned long)wd;
> +       add_timer(timer);
> +}
> +
> +/**
> + * dpm_wd_clear - Disable suspend/resume watchdog.
> + * @wd: Watchdog to disable.
> + */
> +static void dpm_wd_clear(struct dpm_watchdog *wd)
> +{
> +       struct timer_list *timer = &wd->timer;
> +
> +       del_timer_sync(timer);
> +       destroy_timer_on_stack(timer);
> +}
> +#else
> +#define dpm_wd_set(x, y)
> +#define dpm_wd_clear(x)
> +#endif
> +
>  /*------------------------- Resume routines -------------------------*/
>
>  /**
> @@ -570,6 +632,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>         pm_callback_t callback = NULL;
>         char *info = NULL;
>         int error = 0;
> +       struct dpm_watchdog wd;
>
>         TRACE_DEVICE(dev);
>         TRACE_RESUME(0);
> @@ -585,6 +648,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>          * a resumed device, even if the device hasn't been completed yet.
>          */
>         dev->power.is_prepared = false;
> +       dpm_wd_set(&wd, dev);
>
>         if (!dev->power.is_suspended)
>                 goto Unlock;
> @@ -636,6 +700,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>
>   Unlock:
>         device_unlock(dev);
> +       dpm_wd_clear(&wd);
>
>   Complete:
>         complete_all(&dev->power.completion);
> @@ -1053,6 +1118,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>         pm_callback_t callback = NULL;
>         char *info = NULL;
>         int error = 0;
> +       struct dpm_watchdog wd;
>
>         dpm_wait_for_children(dev, async);
>
> @@ -1076,6 +1142,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>         if (dev->power.syscore)
>                 goto Complete;
>
> +       dpm_wd_set(&wd, dev);
> +
>         device_lock(dev);
>
>         if (dev->pm_domain) {
> @@ -1131,6 +1199,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>
>         device_unlock(dev);
>
> +       dpm_wd_clear(&wd);
> +
>   Complete:
>         complete_all(&dev->power.completion);
>         if (error)
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index d444c4e..6a6b763 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -178,6 +178,22 @@ config PM_SLEEP_DEBUG
>         def_bool y
>         depends on PM_DEBUG && PM_SLEEP
>
> +config DPM_WD
> +       bool "Device suspend/resume watchdog"
> +       depends on PM_DEBUG && PSTORE
> +       ---help---
> +         Sets up a watchdog timer to capture drivers that are
> +         locked up attempting to suspend/resume a device.
> +         A detected lockup causes system panic with message
> +         captured in pstore device for inspection in subsequent
> +         boot session.
> +
> +config DPM_WD_TIMEOUT
> +       int "Watchdog timeout in seconds"
> +       range 1 120
> +       default 12
> +       depends on DPM_WD
> +
>  config PM_TRACE
>         bool
>         help
> --
> 1.7.9.5
>
