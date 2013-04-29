Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561Ab3D2Qo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:44:26 -0400
Received: from nm30-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.194]:31941
	"EHLO nm30-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757279Ab3D2QoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:44:25 -0400
X-Yahoo-Newman-Id: 7852.81887.bm@smtp104.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5_VIZJgVM1kkEmp6jMAg5XqDRxcVcFgVm.sdxNQm1nHSoGe
 cpq_IlXvKUXQd2dcwIQZnwRQjkO0Zp7kb8ZiA2804PQhzlG3OdMOlsgzHgfm
 yUPUYerqhoz5tDqXouYoOllrTE2x5gF9AtAhhYC3TFF02en5C9sfKEH31lHG
 iR6akYpnJ_pSJ_w6pEPNvyPfJxof4JDf_pTUYHFaHnOXoGIUj7JT5e_CT2Nj
 _sXFYRPq79J3ikcYbo1LEuGTy1XAwmflDD3r3wneNWbjnU70y8OTLfIa89LX
 Nf2y6ZswD6VKNP_9BMX1In2IQsd2ONfPjYAmNEGbAzYLfx9ExajdElCbizfb
 JWp5hyugt4zLkIoBfhZzQ_9nAVktMa2dDUtPXTna5qw4kgN6j0SMpAgA9Jpg
 MkdzYlwYFqzS6AAjXlIEweW7OEUQVCBmItnWBWjyLfMgptPzG65e109T6LfK
 CXQtm.roYQ5GvLX4kGiQUZjr.AATVP_WF
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp104.sbc.mail.gq1.yahoo.com with SMTP; 29 Apr 2013 09:44:24 -0700 PDT
Date: Mon, 29 Apr 2013 09:44:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] watchdog: mtx1-wdt: use
 devm_gpio_request_one()
Message-ID: <20130429164425.GJ23799@roeck-us.net>
References: <000901ce44bc$38dcfbf0$aa96f3d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901ce44bc$38dcfbf0$aa96f3d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:30:43PM +0900, Jingoo Han wrote:
> Use devm_gpio_request_one() to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

This patch also addresses the missing gpio_free in the probe error path
(if the call to misc_register() fails).

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/mtx-1_wdt.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
> index 14dab6f..b434111 100644
> --- a/drivers/watchdog/mtx-1_wdt.c
> +++ b/drivers/watchdog/mtx-1_wdt.c
> @@ -209,7 +209,7 @@ static int mtx1_wdt_probe(struct platform_device *pdev)
>  	int ret;
>  
>  	mtx1_wdt_device.gpio = pdev->resource[0].start;
> -	ret = gpio_request_one(mtx1_wdt_device.gpio,
> +	ret = devm_gpio_request_one(&pdev->dev, mtx1_wdt_device.gpio,
>  				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to request gpio");
> @@ -241,7 +241,6 @@ static int mtx1_wdt_remove(struct platform_device *pdev)
>  		wait_for_completion(&mtx1_wdt_device.stop);
>  	}
>  
> -	gpio_free(mtx1_wdt_device.gpio);
>  	misc_deregister(&mtx1_wdt_misc);
>  	return 0;
>  }
> -- 
> 1.7.2.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
