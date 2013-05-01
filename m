Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab3EAAbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:31:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49248 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840Ab3EAAbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:31:00 -0400
Date: Wed, 1 May 2013 02:30:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Colin Cross <ccross@android.com>, Todd Poynor <toddpoynor@google.com>,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend.
Message-ID: <20130501003058.GB20042@amd.pavel.ucw.cz>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Below is a patch from android kernel that detects a driver suspend
> lockup and captures dump in the kernel log. Please review and provide
> comments.
> 
> Rather than hard-lock the kernel, dump the suspend thread stack and
> BUG() when a driver takes too long to suspend.  The timeout is set to
> 12 seconds to be longer than the usbhid 10 second timeout.
> 
> Exclude from the watchdog the time spent waiting for children that
> are resumed asynchronously and time every device, whether or not they
> resumed synchronously.
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
> tweaked commit message.]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
> ---
>  drivers/base/power/main.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 15beb50..eb70c0e 100644
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
> +static void dpm_drv_timeout(unsigned long data);
> +struct dpm_drv_wd_data {
> +	struct device *dev;
> +	struct task_struct *tsk;
> +};
> +
>  static int async_error;
>  
>  /**
> @@ -663,6 +671,30 @@ static bool is_async(struct device *dev)
>  }
>  
>  /**
> + *     dpm_drv_timeout - Driver suspend / resume watchdog handler
> + *     @data: struct device which timed out
> + *
> + *     Called when a driver has timed out suspending or resuming.
> + *     There's not much we can do here to recover so
> + *     BUG() out for a crash-dump
> + *
> + */
> +static void dpm_drv_timeout(unsigned long data)
> +{
> +	struct dpm_drv_wd_data *wd_data = (void *)data;
> +	struct device *dev = wd_data->dev;
> +	struct task_struct *tsk = wd_data->tsk;
> +
> +	pr_emerg("**** DPM device timeout: %s (%s)\n", dev_name(dev),
> +		(dev->driver ? dev->driver->name : "no driver"));
> +
> +	pr_emerg("dpm suspend stack:\n");
> +	show_stack(tsk, NULL);
> +
> +	BUG();
> +}

So you:

dump stack of the suspend task

do BUG which
   dumps stack of current task
   kills current task

Current task may very well be idle task; in such case you kill the
machine. Sounds like you should be doing something else, like kill -9
instead of BUG()?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
