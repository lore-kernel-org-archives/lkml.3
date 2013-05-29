Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967123Ab3E2WxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:53:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966799Ab3E2WxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:53:12 -0400
Date: Wed, 29 May 2013 15:53:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Yanovich <ynvich@gmail.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@misterjones.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] rtc-ds1302: handle write protection
Message-Id: <20130529155311.9e35e847968f3923bc83f4cd@linux-foundation.org>
In-Reply-To: <1369092090-5384-1-git-send-email-ynvich@gmail.com>
References: <1369092090-5384-1-git-send-email-ynvich@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013 03:21:30 +0400 Sergey Yanovich <ynvich@gmail.com> wrote:

> This chip has a control register and can prevent altering saved clock.
> Without this patch we could have:
> ----8<----
> (arm)root@pac14:~# date
> Tue May 21 03:08:27 MSK 2013
> (arm)root@pac14:~# /etc/init.d/hwclock.sh show
> Tue May 21 11:13:58 2013  -0.067322 seconds
> (arm)root@pac14:~# /etc/init.d/hwclock.sh stop
> [info] Saving the system clock.
> [info] Hardware Clock updated to Tue May 21 03:09:01 MSK 2013.
> (arm)root@pac14:~# /etc/init.d/hwclock.sh show
> Tue May 21 11:14:15 2013  -0.624272 seconds
> ----8<----
>
> ...
>
> --- a/drivers/rtc/rtc-ds1302.c
> +++ b/drivers/rtc/rtc-ds1302.c
> @@ -23,8 +23,12 @@
>  #define	RTC_CMD_READ	0x81		/* Read command */
>  #define	RTC_CMD_WRITE	0x80		/* Write command */
>  
> +#define	RTC_CMD_WRITE_ENABLE	0x00		/* Write enable */
> +#define	RTC_CMD_WRITE_DISABLE	0x80		/* Write disable */
> +
>  #define RTC_ADDR_RAM0	0x20		/* Address of RAM0 */
>  #define RTC_ADDR_TCR	0x08		/* Address of trickle charge register */
> +#define	RTC_ADDR_CTRL	0x07		/* Address of control register */
>  #define	RTC_ADDR_YEAR	0x06		/* Address of year register */
>  #define	RTC_ADDR_DAY	0x05		/* Address of day of week register */
>  #define	RTC_ADDR_MON	0x04		/* Address of month register */
> @@ -313,6 +317,7 @@ static int __init ds1302_rtc_probe(struct platform_device *pdev)
>  		return PTR_ERR(rtc);
>  
>  	platform_set_drvdata(pdev, rtc);
> +	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_ENABLE);
>  
>  	return 0;
>  }
> @@ -321,6 +326,7 @@ static int ds1302_rtc_remove(struct platform_device *pdev)
>  {
>  	struct rtc_device *rtc = platform_get_drvdata(pdev);
>  
> +	ds1302_writebyte(RTC_ADDR_CTRL, RTC_CMD_WRITE_DISABLE);
>  	rtc_device_unregister(rtc);
>  	platform_set_drvdata(pdev, NULL);

ds1302_rtc_remove() no longer exists in my tree - it got whittled away
to nothing by
http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch
and
http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1302c-remove-empty-function.patch

Perhaps it should be re-added for this?
