Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3DLO5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:57:23 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54309 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3DLO5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:57:22 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 12 Apr 2013 07:57:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] watchdog: fix cleanup device code on registration
Message-ID: <20130412145733.GA28704@roeck-us.net>
References: <A874F61F95741C4A9BA573A70FE3998F82E4BBCA@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E4BBCA@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 06:51:48AM +0000, Kim, Milo wrote:
> Duplicate lines of code are moved to cleanup_dev section.
> And it returns 0 explicitly in case of no error.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/watchdog/watchdog_dev.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
> index 42bfc9a..37c2dcc 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -613,11 +613,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
>  	if (err) {
>  		pr_err("watchdog%d unable to add device %d:%d\n",
>  			watchdog->id,  MAJOR(watchdog_devt), watchdog->id);
> -		if (watchdog->id == 0) {
> -			misc_deregister(&watchdog_miscdev);
> -			old_wdd = NULL;
> -		}
> -		return err;
> +		goto cleanup_dev;
>  	}
>  
>  	/* Activate the watchdog automatically by the driver itself */
> @@ -625,13 +621,17 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
>  		err = watchdog_auto_start(watchdog);
>  		if (err) {
>  			cdev_del(&watchdog->cdev);

If you are doing this, you should also move cdev_del into the cleanup path:

> -			if (watchdog->id == 0) {
> -				misc_deregister(&watchdog_miscdev);
> -				old_wdd = NULL;
> -			}
> +			goto cleanup_dev;
>  		}
>  	}
>  
> +	return 0;
> +
cleanup_cdev:
	cdev_del(&watchdog->cdev);

> +cleanup_dev:
> +	if (watchdog->id == 0) {
> +		misc_deregister(&watchdog_miscdev);
> +		old_wdd = NULL;
> +	}
>  	return err;
>  }
>  
> -- 
> 1.7.9.5
> 
> 
> Best Regards,
> Milo
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
