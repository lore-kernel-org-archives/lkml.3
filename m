Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935932Ab3DHNlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:41:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57446 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935851Ab3DHNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:41:15 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 8 Apr 2013 06:41:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hector Palacios <hector.palacios@digi.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        wim@iguana.be
Subject: Re: [PATCH v2] watchdog: core: don't try to stop device if not
 running
Message-ID: <20130408134118.GA18644@roeck-us.net>
References: <1365412258-10785-1-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365412258-10785-1-git-send-email-hector.palacios@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:10:58AM +0200, Hector Palacios wrote:
> A watchdog device may be stopped from userspace using WDIOC_SETOPTIONS
> ioctl and flag WDIOS_DISABLECARD. If the device is closed after this
> operation, watchdog_release() is called and status bits checked for
> stopping it. Besides, if the device has not been unregistered a critical
> message "watchdog did not stop!" is printed, although the ioctl may have
> successfully stopped it already.
> 
> Without the patch a user application sample code like this will successfully
> stop the watchdog, but the kernel will output the message
> "watchdog did not stop!":
> 
> 	wd_fd = open("/dev/watchdog", O_RDWR);
> 
> 	flags = WDIOS_DISABLECARD;
> 	ioctl(wd_fd, WDIOC_SETOPTIONS, &flags);
> 
> 	close(wd_fd);
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> ---
> 
> Changes from v1:
> - Make it less intrusive with 'if/else if' clauses
> - Change the logic of 'err' variable for better readability of code
> - Remove one-liner if brackets that broke coding sytle
> 
>  drivers/watchdog/watchdog_dev.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
> index ef8edec..8e0f1b8 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -463,15 +463,17 @@ out:
>  static int watchdog_release(struct inode *inode, struct file *file)
>  {
>  	struct watchdog_device *wdd = file->private_data;
> -	int err = -EBUSY;
> +	int err = 0;
>  
>  	/*
>  	 * We only stop the watchdog if we received the magic character
>  	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
>  	 * watchdog_stop will fail.
>  	 */
> -	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
> -	    !(wdd->info->options & WDIOF_MAGICCLOSE))
> +	if (test_bit(WDOG_ACTIVE, &wdd->status))
> +		err = -EBUSY;
> +	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
> +		 !(wdd->info->options & WDIOF_MAGICCLOSE))
>  		err = watchdog_stop(wdd);
>  
Looking at it again, it is now broken and fails with EBUSY if WDOG_ACTIVE is
set, and it tries to stop the watchdog if it is already stopped.

Guenter
