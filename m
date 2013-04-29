Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab3D2SJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:09:59 -0400
Received: from nm1.access.bullet.mail.sp2.yahoo.com ([98.139.44.128]:21426
	"EHLO nm1.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758330Ab3D2SJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:09:57 -0400
X-Yahoo-Newman-Id: 476566.63142.bm@smtp112.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mQWkFVkVM1mXb.QAiZmcdd.f9JcPGTMySb.2xgOBfapueCS
 1pUmoGkfAfeteEGZElklqc4j_4w8s1Py5S96hbmyXjjJvXeAxKdq_aqesA_w
 Ko77AaJeoj1.o_I9TU2xMjNr9sr38AdcnCTRz4cGsqHRm9NETcwelNpoYEV2
 nR1OV_1TuCkSkoaSly3iW86oajesBlJBYhwgwUugJnu1s1SNNw6NTWpLh47F
 2U9khyKV.E48ku9D7.bk90._XjluLYoCkCAT6euunYcP57C7ci1GV81KYp8L
 aEUbHf5v3feSxFnvxF7Tvnyuo5KM0tG2OyVWHxkKpvxHVPG_fEkdCLFs_uAw
 gst6rcId6LLlG8MJ8nhsvTJww1_M7AU7.EkQ04VuOM4aZdSWwWcal0qsAxLi
 DXHrreNdJtk41Cza4zYXHXcGaJJfMxYZYI2pOeDSviw0zqNnP6V4gsjMfx0U
 YbfPegX.6JVc4d9dbq76JXsD7fsTtUhfGBDE-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp112.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 11:09:56 -0700 PDT
Date: Mon, 29 Apr 2013 11:09:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 7/7] watchdog: ts72xx_wdt: use devm_*() functions
Message-ID: <20130429180957.GG5183@roeck-us.net>
References: <001101ce44bd$0a0105f0$1e0311d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101ce44bd$0a0105f0$1e0311d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:36:34PM +0900, Jingoo Han wrote:
> Use devm_*() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/ts72xx_wdt.c |   64 +++++++----------------------------------
>  1 files changed, 11 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
> index b8a9245..b19ca75 100644
> --- a/drivers/watchdog/ts72xx_wdt.c
> +++ b/drivers/watchdog/ts72xx_wdt.c
> @@ -396,7 +396,7 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
>  	struct resource *r1, *r2;
>  	int error = 0;
>  
> -	wdt = kzalloc(sizeof(struct ts72xx_wdt), GFP_KERNEL);
> +	wdt = devm_kzalloc(&pdev->dev, sizeof(struct ts72xx_wdt), GFP_KERNEL);
>  	if (!wdt) {
>  		dev_err(&pdev->dev, "failed to allocate memory\n");
>  		return -ENOMEM;
> @@ -405,44 +405,22 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
>  	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!r1) {
>  		dev_err(&pdev->dev, "failed to get memory resource\n");
> -		error = -ENODEV;
> -		goto fail;
> -	}
> -
> -	r1 = request_mem_region(r1->start, resource_size(r1), pdev->name);
> -	if (!r1) {
> -		dev_err(&pdev->dev, "cannot request memory region\n");
> -		error = -EBUSY;
> -		goto fail;
> +		return -ENODEV;
>  	}
>  
> -	wdt->control_reg = ioremap(r1->start, resource_size(r1));
> -	if (!wdt->control_reg) {
> -		dev_err(&pdev->dev, "failed to map memory\n");
> -		error = -ENODEV;
> -		goto fail_free_control;
> -	}
> +	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
> +	if (IS_ERR(wdt->control_reg))
> +		return PTR_ERR(wdt->control_reg);
>  
>  	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>  	if (!r2) {
>  		dev_err(&pdev->dev, "failed to get memory resource\n");
> -		error = -ENODEV;
> -		goto fail_unmap_control;
> +		return -ENODEV;
>  	}
>  
> -	r2 = request_mem_region(r2->start, resource_size(r2), pdev->name);
> -	if (!r2) {
> -		dev_err(&pdev->dev, "cannot request memory region\n");
> -		error = -EBUSY;
> -		goto fail_unmap_control;
> -	}
> -
> -	wdt->feed_reg = ioremap(r2->start, resource_size(r2));
> -	if (!wdt->feed_reg) {
> -		dev_err(&pdev->dev, "failed to map memory\n");
> -		error = -ENODEV;
> -		goto fail_free_feed;
> -	}
> +	wdt->feed_reg = devm_ioremap_resource(&pdev->dev, r2);
> +	if (IS_ERR(wdt->feed_reg))
> +		return PTR_ERR(wdt->feed_reg);
>  
You have a mix of returns with and without error messages now. Can you make sure
that this is all consistent ?

Thanks,
Guenter
