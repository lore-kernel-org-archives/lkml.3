Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab3EKGNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 02:13:33 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:61203 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3EKGN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 02:13:28 -0400
MIME-Version: 1.0
In-Reply-To: <1368221329-1841-2-git-send-email-zoran.markovic@linaro.org>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
	<1368221329-1841-2-git-send-email-zoran.markovic@linaro.org>
Date: Fri, 10 May 2013 23:13:27 -0700
X-Google-Sender-Auth: lF_Fan9EDfynNc4w38GEkzOkF60
Message-ID: <CAMbhsRS+fNo19srma9WqcHutJnv8driOMnpM1-yW=pduJMo63g@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/2] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend/resume.
From: Colin Cross <ccross@android.com>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 2:28 PM, Zoran Markovic
<zoran.markovic@linaro.org> wrote:
> From: Benoit Goby <benoit@android.com>
>
> Below is a patch from android kernel that detects a driver suspend/resume
> lockup and captures dump in the kernel log. Please review and provide
> comments.

This paragraph should go below the --- line so it doesn't end up in
the final commit message.

> Rather than hard-lock the kernel, dump the suspend/resume thread stack and
> BUG() when a driver takes too long to suspend/resume.  The timeout is set to
> 12 seconds to be longer than the usbhid 10 second timeout.
>
> Exclude from the watchdog the time spent waiting for children that
> are resumed asynchronously and time every device, whether or not they
> resumed synchronously.
>
> This patch is targeted for mobile devices where a suspend/resume lockup
> could cause a system reboot and catch user's attention. Information
> about failing device can later be retrieved from captured log in
> subsequent boot session.

I would take out the phrase "catch user's attention", the intention of
this patch is actually the opposite - get the system back to working
normally as fast as possible, while still putting enough information
to debug the problem into the log.

> The hardware watchdog timer is likely suspended during this time and
> couldn't be relied upon. The soft-lockup detector would eventually tell
> that tasks are not scheduled, but would provide little context as to why.
> The patch hence uses system timer and assumes it is still active while the
> devices are suspended/resumed.
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
> tweaked commit message. Minor changes to merge code into kernel tip.]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
> ---
>  drivers/base/power/main.c |   66 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
>
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 5a9b656..a6a02c0 100644
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
> @@ -384,6 +392,56 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
>         return error;
>  }
>
> +/**
> + * dpm_wd_handler - Driver suspend / resume watchdog handler.
> + *
> + * Called when a driver has timed out suspending or resuming.
> + * There's not much we can do here to recover so BUG() out for
> + * a crash-dump
> + */
> +static void dpm_wd_handler(unsigned long data)
> +{
> +       struct dpm_watchdog *wd = (void *)data;
> +       struct device *dev      = wd->dev;
> +       struct task_struct *tsk = wd->tsk;
> +
> +       dev_emerg(dev, "**** DPM device timeout ****\n");
> +       show_stack(tsk, NULL);
> +
> +       BUG();
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
> +       timer->expires = jiffies + HZ * 12;
> +       timer->function = dpm_wd_handler;
> +       timer->data = (unsigned long)wd;
> +       add_timer(timer);
> +}
> +
> +/**
> + * dpm_wd_clear - Disable pm watchdog.
> + * @wd: Watchdog to disable.
> + */
> +static void dpm_wd_clear(struct dpm_watchdog *wd)
> +{
> +       struct timer_list *timer = &wd->timer;
> +
> +       del_timer_sync(timer);
> +       destroy_timer_on_stack(timer);
> +}
> +
>  /*------------------------- Resume routines -------------------------*/
>
>  /**
> @@ -570,6 +628,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>         pm_callback_t callback = NULL;
>         char *info = NULL;
>         int error = 0;
> +       struct dpm_watchdog wd;
>
>         TRACE_DEVICE(dev);
>         TRACE_RESUME(0);
> @@ -585,6 +644,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>          * a resumed device, even if the device hasn't been completed yet.
>          */
>         dev->power.is_prepared = false;
> +       dpm_wd_set(&wd, dev);
>
>         if (!dev->power.is_suspended)
>                 goto Unlock;
> @@ -636,6 +696,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>
>   Unlock:
>         device_unlock(dev);
> +       dpm_wd_clear(&wd);
>
>   Complete:
>         complete_all(&dev->power.completion);
> @@ -1053,6 +1114,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>         pm_callback_t callback = NULL;
>         char *info = NULL;
>         int error = 0;
> +       struct dpm_watchdog wd;
>
>         dpm_wait_for_children(dev, async);
>
> @@ -1076,6 +1138,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>         if (dev->power.syscore)
>                 goto Complete;
>
> +       dpm_wd_set(&wd, dev);
> +
>         device_lock(dev);
>
>         if (dev->pm_domain) {
> @@ -1131,6 +1195,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>
>         device_unlock(dev);
>
> +       dpm_wd_clear(&wd);
> +
>   Complete:
>         complete_all(&dev->power.completion);
>         if (error)
> --
> 1.7.9.5
>
