Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162426Ab3DESew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:34:52 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54073 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162402Ab3DESev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:34:51 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 5 Apr 2013 11:34:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hector Palacios <hector.palacios@digi.com>
Cc: linux-watchdog@vger.kernel.org, wim@iguana.be,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] watchdog: core: don't try to stop device if not
 running
Message-ID: <20130405183450.GA29835@roeck-us.net>
References: <515EF748.6060504@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515EF748.6060504@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 06:09:44PM +0200, Hector Palacios wrote:
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

How about the following patch instead ?

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 08b48bb..9775e8d 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -469,7 +469,9 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
 	 * watchdog_stop will fail.
 	 */
-	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
+	if (!test_bit(WDOG_ACTIVE, &wdd->status))
+		err = 0;
+	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
 	    !(wdd->info->options & WDIOF_MAGICCLOSE))
 		err = watchdog_stop(wdd);

Much less invasive and the result is the same.

Thanks,
Guenter

> ---
>  drivers/watchdog/watchdog_dev.c |   38 +++++++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
> index ef8edec..adadbdd 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -463,24 +463,28 @@ out:
>  static int watchdog_release(struct inode *inode, struct file *file)
>  {
>  	struct watchdog_device *wdd = file->private_data;
> -	int err = -EBUSY;
> 
> -	/*
> -	 * We only stop the watchdog if we received the magic character
> -	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
> -	 * watchdog_stop will fail.
> -	 */
> -	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
> -	    !(wdd->info->options & WDIOF_MAGICCLOSE))
> -		err = watchdog_stop(wdd);
> -
> -	/* If the watchdog was not stopped, send a keepalive ping */
> -	if (err < 0) {
> -		mutex_lock(&wdd->lock);
> -		if (!test_bit(WDOG_UNREGISTERED, &wdd->status))
> -			dev_crit(wdd->dev, "watchdog did not stop!\n");
> -		mutex_unlock(&wdd->lock);
> -		watchdog_ping(wdd);
> +	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
> +		int err = -EBUSY;
> +
> +		/*
> +		 * We only stop the watchdog if we received the magic character
> +		 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
> +		 * watchdog_stop will fail.
> +		 */
> +		if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
> +		    !(wdd->info->options & WDIOF_MAGICCLOSE)) {
> +			err = watchdog_stop(wdd);
> +		}
> +
> +		/* If the watchdog was not stopped, send a keepalive ping */
> +		if (err < 0) {
> +			mutex_lock(&wdd->lock);
> +			if (!test_bit(WDOG_UNREGISTERED, &wdd->status))
> +				dev_crit(wdd->dev, "watchdog did not stop!\n");
> +			mutex_unlock(&wdd->lock);
> +			watchdog_ping(wdd);
> +		}
>  	}
> 
>  	/* Allow the owner module to be unloaded again */
> -- 
> 1.7.9.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
