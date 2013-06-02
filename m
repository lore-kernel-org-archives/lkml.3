Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3FBK0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 06:26:50 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63137 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3FBK0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <1370167987-14252-1-git-send-email-anish198519851985@gmail.com>
References: <1370167987-14252-1-git-send-email-anish198519851985@gmail.com>
Date: Sun, 2 Jun 2013 15:56:40 +0530
Message-ID: <CAK7N6voRDGCCwG1CxNoaUYrWDZrA6yMHU7Jjsc01JN_cb-puvw@mail.gmail.com>
Subject: Re: [PATCH] [RFC]Watchdog:core: constant pinging until userspace
 timesout when delay very less
From: anish singh <anish198519851985@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 2, 2013 at 3:43 PM, anish kumar <anish198519851985@gmail.com> wrote:
> Certain watchdog drivers use a timer to keep kicking the watchdog at
> a rate of 0.5s (HZ/2) untill userspace times out.They do this as
> we can't guarantee that watchdog will be pinged fast enough
> for all system loads, especially if timeout is configured for
> less than or equal to 1 second(basically small values).
>
> As suggested by Wim Van Sebroeck & Guenter Roeck we should
> add this functionality of individual watchdog drivers in the core
> watchdog core.
>
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  drivers/watchdog/watchdog_dev.c |   34 +++++++++++++++++++++++++++++-----
>  include/linux/watchdog.h        |    1 +
>  2 files changed, 30 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
> index faf4e18..0305803 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -41,9 +41,14 @@
>  #include <linux/miscdevice.h>  /* For handling misc devices */
>  #include <linux/init.h>                /* For __init/__exit/... */
>  #include <linux/uaccess.h>     /* For copy_to_user/put_user/... */
> +#include <linux/timer.h>
> +#include <linux/jiffies.h>
>
>  #include "watchdog_core.h"
>
> +/* Timer heartbeat (500ms) */
> +#define WDT_TIMEOUT    (HZ/2) /* should this be sysfs? */
> +
>  /* the dev_t structure to store the dynamically allocated watchdog devices */
>  static dev_t watchdog_devt;
>  /* the watchdog device behind /dev/watchdog */
> @@ -73,16 +78,33 @@ static int watchdog_ping(struct watchdog_device *wddev)
I think watchdog_ping function prototype should be changed as nowhere
we use the return value.
>         if (!watchdog_active(wddev))
>                 goto out_ping;
>
> -       if (wddev->ops->ping)
> -               err = wddev->ops->ping(wddev);  /* ping the watchdog */
> -       else
> -               err = wddev->ops->start(wddev); /* restart watchdog */
> +       /* should we check ping interval value i.e. timeout value
> +          if it is less than certain threshold then only we
> +          should add this logic of periodic pinging? */
> +       if (time_before(jiffies, (unsigned long)wddev->timeout)) {
> +               if (wddev->ops->ping)
> +                       err = wddev->ops->ping(wddev);/* ping the watchdog */
> +               else
> +                       err = wddev->ops->start(wddev);/* restart watchdog */
> +               mod_timer(&wddev->timer, jiffies + WDT_TIMEOUT);
> +       } else {
> +               /*
> +                *what we should when we find out that userspace
> +                *has timed out?
> +                **/
> +       }
>
>  out_ping:
>         mutex_unlock(&wddev->lock);
>         return err;
>  }
>
> +static void watchdog_ping_wrapper(unsigned long priv)
if we change the watchdog_ping api then we don't need this wrapper.
> +{
> +       struct watchdog_device *wdd = (void *)priv;
> +       watchdog_ping(wdd);
> +}
> +
>  /*
>   *     watchdog_start: wrapper to start the watchdog.
>   *     @wddev: the watchdog device to start
> @@ -109,7 +131,8 @@ static int watchdog_start(struct watchdog_device *wddev)
>         err = wddev->ops->start(wddev);
>         if (err == 0)
>                 set_bit(WDOG_ACTIVE, &wddev->status);
> -
> +
> +       mod_timer(&wddev->timer, jiffies + WDT_TIMEOUT);
>  out_start:
>         mutex_unlock(&wddev->lock);
>         return err;
> @@ -552,6 +575,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
>                         old_wdd = NULL;
>                 }
>         }
> +       setup_timer(&watchdog->timer, 0, (long)watchdog_ping_wrapper);
>         return err;
>  }
>
> diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> index 2a3038e..e5f18f7 100644
> --- a/include/linux/watchdog.h
> +++ b/include/linux/watchdog.h
> @@ -84,6 +84,7 @@ struct watchdog_device {
>         const struct watchdog_ops *ops;
>         unsigned int bootstatus;
>         unsigned int timeout;
> +       struct timer_list timer;
should we use hrtimer? or timer would do?
>         unsigned int min_timeout;
>         unsigned int max_timeout;
>         void *driver_data;
> --
> 1.7.10.4
>
