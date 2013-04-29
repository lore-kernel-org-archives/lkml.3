Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab3D2QeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:34:10 -0400
Received: from nm30.access.bullet.mail.sp2.yahoo.com ([98.139.44.157]:21924
	"EHLO nm30.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758065Ab3D2QeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:34:07 -0400
X-Yahoo-Newman-Id: 823315.18680.bm@smtp113.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bbC_XugVM1lj_ORiWHK5ibI.g0Cj9qPmoe5AH2ou4.b_Tjd
 cugjOUtGg9hyAUso3eZv0QBKgmCiCIbGgrOGyD_NU4NXdCDT38eVAaWEFByX
 71s0e8OS7m.teBl.bsH4RR34C2BQh.Nh1V525jWjW36EvAfyr7_L6d9k7YIj
 .CYTclJdUA_hhSsBDy9KcOC4V8Y01yG232rldvnX0CXgOxi87MJsIn5fA9gJ
 GtzIapYFLmIDOU6l322rUBGQB_iUgU7aP7eMrxkew_sMspAbkSKJBIAmGN98
 iE6cmZ5fhfiOU2qzbl9D3Qe7pUIJXRDbTVj284pBegFy0nh6vz3Yfe3SK0BS
 g0blunWuikOX0pe6716y1IneiNazbw8sdS_eNyLw4Ap4mHMTpqk7C9fS1EOx
 y6h9AATXQ9wzUQXUymosJLbGWJ3oMKprzYdS6hwyQL742BM30aD.eWXvvQ5D
 6_Wc2ReNPhJNEfYCJjW48yVZtuXcfYCh5
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp113.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 09:34:06 -0700 PDT
Date: Mon, 29 Apr 2013 09:34:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 4/5] watchdog: shwdt: use devm_clk_get()
Message-ID: <20130429163407.GF23799@roeck-us.net>
References: <000501ce44ba$3df0f350$b9d2d9f0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501ce44ba$3df0f350$b9d2d9f0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:16:33PM +0900, Jingoo Han wrote:
> Use devm_clk_get() to make cleanup paths more simple.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/shwdt.c |   16 ++++------------
>  1 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
> index 6185af2..ea2154b 100644
> --- a/drivers/watchdog/shwdt.c
> +++ b/drivers/watchdog/shwdt.c
> @@ -241,7 +241,7 @@ static int sh_wdt_probe(struct platform_device *pdev)
>  
>  	wdt->dev = &pdev->dev;
>  
> -	wdt->clk = clk_get(&pdev->dev, NULL);
> +	wdt->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(wdt->clk)) {
>  		/*
>  		 * Clock framework support is optional, continue on
> @@ -251,10 +251,8 @@ static int sh_wdt_probe(struct platform_device *pdev)
>  	}
>  
>  	wdt->base = devm_ioremap_resource(wdt->dev, res);
> -	if (IS_ERR(wdt->base)) {
> -		rc = PTR_ERR(wdt->base);
> -		goto err;
> -	}
> +	if (IS_ERR(wdt->base))
> +		return PTR_ERR(wdt->base);
>  
>  	watchdog_set_nowayout(&sh_wdt_dev, nowayout);
>  	watchdog_set_drvdata(&sh_wdt_dev, wdt);
> @@ -277,7 +275,7 @@ static int sh_wdt_probe(struct platform_device *pdev)
>  	rc = watchdog_register_device(&sh_wdt_dev);
>  	if (unlikely(rc)) {
>  		dev_err(&pdev->dev, "Can't register watchdog (err=%d)\n", rc);
> -		goto err;
> +		return rc;
>  	}
>  
>  	init_timer(&wdt->timer);
> @@ -292,11 +290,6 @@ static int sh_wdt_probe(struct platform_device *pdev)
>  	pm_runtime_enable(&pdev->dev);
>  
>  	return 0;
> -
> -err:
> -	clk_put(wdt->clk);
> -
> -	return rc;
>  }
>  
>  static int sh_wdt_remove(struct platform_device *pdev)
> @@ -308,7 +301,6 @@ static int sh_wdt_remove(struct platform_device *pdev)
>  	watchdog_unregister_device(&sh_wdt_dev);
>  
>  	pm_runtime_disable(&pdev->dev);
> -	clk_put(wdt->clk);
>  
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
