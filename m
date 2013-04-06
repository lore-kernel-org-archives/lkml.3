Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab3DFITm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 04:19:42 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:46804 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab3DFITi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 04:19:38 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] watchdog: Fix race condition in registration code
Date: Sat, 6 Apr 2013 10:19:34 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.6-dirty; KDE/4.10.2; x86_64; ; )
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>
References: <1365222163-26761-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1365222163-26761-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304061019.34473.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 of April 2013, Guenter Roeck wrote:
> A race condition exists when registering the first watchdog device.
> Sequence of events:
> 
> - watchdog_register_device calls watchdog_dev_register
> - watchdog_dev_register creates the watchdog misc device by calling
>   misc_register.
>   At that time, the matching character device (/dev/watchdog0) does not yet
>   exist, and old_wdd is not set either.
> - Userspace gets an event and opens /dev/watchdog
> - watchdog_open is called and sets sets wdd = old_wdd, which is still NULL,
>   and tries to dereference it. This causes the kernel to panic.
> 
> Seen with systemd trying to open /dev/watchdog immediately after
> it was created.
> 
> Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>

Please use
Reported-by: Arkadiusz Miśkiewicz <arekm@maven.pl>

I have to use gmail address because maven.pl domain is blocked due to some 
unknown, secret reason and vger.kernel.org postmasters (Dave M etc) are less 
than helpful:

"We are under no obligation to explain why you were banned nor to remove
the ban.

If you don't like this, you can run your own list server and on it determine
your own set of policies."


> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> Arkadiusz,
> 
> would be great if you can test this in your system.

Did few reboots without oops but this test isn't reliable. Previously I wasn't 
able to reproduce this on demand. It just happens sometime. If any problem 
popup I'll let you know.

So for now
Tested-by: Arkadiusz Miśkiewicz <arekm@maven.pl>

> 
>  drivers/watchdog/watchdog_dev.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/watchdog_dev.c
> b/drivers/watchdog/watchdog_dev.c index 08b48bb..faf4e18 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -523,6 +523,7 @@ int watchdog_dev_register(struct watchdog_device
> *watchdog) int err, devno;
> 
>  	if (watchdog->id == 0) {
> +		old_wdd = watchdog;
>  		watchdog_miscdev.parent = watchdog->parent;
>  		err = misc_register(&watchdog_miscdev);
>  		if (err != 0) {
> @@ -531,9 +532,9 @@ int watchdog_dev_register(struct watchdog_device
> *watchdog) if (err == -EBUSY)
>  				pr_err("%s: a legacy watchdog module is probably present.\n",
>  					watchdog->info->identity);
> +			old_wdd = NULL;
>  			return err;
>  		}
> -		old_wdd = watchdog;
>  	}
> 
>  	/* Fill in the data structures */


-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
