Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376Ab3JPWjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:39:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51431 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760936Ab3JPWjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:39:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCHv5] drivers: power: Detect device suspend/resume lockup and log event in pstore.
Date: Thu, 17 Oct 2013 00:50:56 +0200
Message-ID: <2243280.h9uyCYFNRF@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381426465-30191-1-git-send-email-zoran.markovic@linaro.org>
References: <1381426465-30191-1-git-send-email-zoran.markovic@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 10, 2013 10:34:25 AM Zoran Markovic wrote:
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
> the log. Laptops with EFI-enabled pstore could also benefit from
> this feature.
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
> tweaked commit message. Moved call to dpm_wd_set() before device_lock() in
> device_resume(). Minor changes to add compile-time inclusion of the feature.
> Renamed 'dpm_wd...' to 'dpm_watchdog...'.]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>

Queued up for 3.13, thanks!

> ---
>  drivers/base/power/main.c |   68 +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/power/Kconfig      |   16 +++++++++++
>  2 files changed, 84 insertions(+)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 9f098a8..06fbc62 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -30,6 +30,8 @@
>  #include <linux/suspend.h>
>  #include <trace/events/power.h>
>  #include <linux/cpuidle.h>
> +#include <linux/timer.h>
> +
>  #include "../base.h"
>  #include "power.h"
>  
> @@ -55,6 +57,12 @@ struct suspend_stats suspend_stats;
>  static DEFINE_MUTEX(dpm_list_mtx);
>  static pm_message_t pm_transition;
>  
> +struct dpm_watchdog {
> +	struct device		*dev;
> +	struct task_struct	*tsk;
> +	struct timer_list	timer;
> +};
> +
>  static int async_error;
>  
>  static char *pm_verb(int event)
> @@ -390,6 +398,60 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
>  	return error;
>  }
>  
> +#ifdef CONFIG_DPM_WATCHDOG
> +/**
> + * dpm_watchdog_handler - Driver suspend / resume watchdog handler.
> + *
> + * Called when a driver has timed out suspending or resuming.
> + * There's not much we can do here to recover so panic() to
> + * capture a crash-dump in pstore.
> + */
> +static void dpm_watchdog_handler(unsigned long data)
> +{
> +	struct dpm_watchdog *wd = (void *)data;
> +
> +	dev_emerg(wd->dev, "**** DPM device timeout ****\n");
> +	show_stack(wd->tsk, NULL);
> +	panic("%s %s: unrecoverable failure\n",
> +		dev_driver_string(wd->dev), dev_name(wd->dev));
> +}
> +
> +/**
> + * dpm_watchdog_set - Enable pm watchdog for given device.
> + * @wd: Watchdog. Must be allocated on the stack.
> + * @dev: Device to handle.
> + */
> +static void dpm_watchdog_set(struct dpm_watchdog *wd, struct device *dev)
> +{
> +	struct timer_list *timer = &wd->timer;
> +
> +	wd->dev = dev;
> +	wd->tsk = get_current();
> +
> +	init_timer_on_stack(timer);
> +	/* use same timeout value for both suspend and resume */
> +	timer->expires = jiffies + HZ * CONFIG_DPM_WATCHDOG_TIMEOUT;
> +	timer->function = dpm_watchdog_handler;
> +	timer->data = (unsigned long)wd;
> +	add_timer(timer);
> +}
> +
> +/**
> + * dpm_watchdog_clear - Disable suspend/resume watchdog.
> + * @wd: Watchdog to disable.
> + */
> +static void dpm_watchdog_clear(struct dpm_watchdog *wd)
> +{
> +	struct timer_list *timer = &wd->timer;
> +
> +	del_timer_sync(timer);
> +	destroy_timer_on_stack(timer);
> +}
> +#else
> +#define dpm_watchdog_set(x, y)
> +#define dpm_watchdog_clear(x)
> +#endif
> +
>  /*------------------------- Resume routines -------------------------*/
>  
>  /**
> @@ -576,6 +638,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>  	pm_callback_t callback = NULL;
>  	char *info = NULL;
>  	int error = 0;
> +	struct dpm_watchdog wd;
>  
>  	TRACE_DEVICE(dev);
>  	TRACE_RESUME(0);
> @@ -584,6 +647,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>  		goto Complete;
>  
>  	dpm_wait(dev->parent, async);
> +	dpm_watchdog_set(&wd, dev);
>  	device_lock(dev);
>  
>  	/*
> @@ -642,6 +706,7 @@ static int device_resume(struct device *dev, pm_message_t state, bool async)
>  
>   Unlock:
>  	device_unlock(dev);
> +	dpm_watchdog_clear(&wd);
>  
>   Complete:
>  	complete_all(&dev->power.completion);
> @@ -1060,6 +1125,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  	pm_callback_t callback = NULL;
>  	char *info = NULL;
>  	int error = 0;
> +	struct dpm_watchdog wd;
>  
>  	dpm_wait_for_children(dev, async);
>  
> @@ -1083,6 +1149,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  	if (dev->power.syscore)
>  		goto Complete;
>  
> +	dpm_watchdog_set(&wd, dev);
>  	device_lock(dev);
>  
>  	if (dev->pm_domain) {
> @@ -1139,6 +1206,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
>  	}
>  
>  	device_unlock(dev);
> +	dpm_watchdog_clear(&wd);
>  
>   Complete:
>  	complete_all(&dev->power.completion);
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index d444c4e..2fac9cc 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -178,6 +178,22 @@ config PM_SLEEP_DEBUG
>  	def_bool y
>  	depends on PM_DEBUG && PM_SLEEP
>  
> +config DPM_WATCHDOG
> +	bool "Device suspend/resume watchdog"
> +	depends on PM_DEBUG && PSTORE
> +	---help---
> +	  Sets up a watchdog timer to capture drivers that are
> +	  locked up attempting to suspend/resume a device.
> +	  A detected lockup causes system panic with message
> +	  captured in pstore device for inspection in subsequent
> +	  boot session.
> +
> +config DPM_WATCHDOG_TIMEOUT
> +	int "Watchdog timeout in seconds"
> +	range 1 120
> +	default 12
> +	depends on DPM_WATCHDOG
> +
>  config PM_TRACE
>  	bool
>  	help
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
