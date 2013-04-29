Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3D2RwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:52:07 -0400
Received: from nm21-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.176]:30400
	"EHLO nm21-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308Ab3D2RwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:52:03 -0400
X-Yahoo-Newman-Id: 758908.39936.bm@smtp120.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: oPAbZvYVM1nWpk7AS4kBiL2TbjPlBaVlm7bLQkBZhQLCa4s
 _TIDWpwODwlhMd05ldNk7WzKQTjoBXPph16_iNdd.XemVyUTfg8hUv.4D.rg
 8fz2wKsPVFmZnzSdR.e4z48y7cQwKGxQp4BsXLjGaxXpk_3Lir1leJiwkFxk
 VmsIJjK0RsA6g60XEtCgbzwN2xp.cyebxCfW3X3OQyOSxF.LvdsV0SFj5rxM
 wIrp2frHAqqf558.zAPECI5MjK4GGAwswTlGq0ZcJiuj.qVLiuqhmoz0TIrT
 h4l.F.4MgcEmJaGg28jgRyQW.TXnqNPsbRqtdJugFN5K3kECzV0JfaNfK.LO
 1DQAUaXnDAjRpRgmu.bZM7u6XBdEFh5svXp8yZCiTiN_IPsYiRcx7OvYlGyl
 4ayvqcrJh51xwmu05vjLpvFdBC.RIVWBQyG5FKnYtHYuYr0d.l2MammLpw2A
 MrQRSfs5skwZrXI0X5H3FxBP8UxJINPro3dI-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp120.sbc.mail.gq1.yahoo.com with SMTP; 29 Apr 2013 17:52:02 +0000 UTC
Date: Mon, 29 Apr 2013 10:52:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 1/7] watchdog: at32ap700x_wdt: use devm_*()
 functions
Message-ID: <20130429175203.GA5183@roeck-us.net>
References: <000b01ce44bc$c0960280$41c20780$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000b01ce44bc$c0960280$41c20780$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:34:31PM +0900, Jingoo Han wrote:
> Use devm_*() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/at32ap700x_wdt.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
> index 7a715e3..c4cb552 100644
> --- a/drivers/watchdog/at32ap700x_wdt.c
> +++ b/drivers/watchdog/at32ap700x_wdt.c
> @@ -321,13 +321,14 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
>  		return -ENXIO;
>  	}
>  
> -	wdt = kzalloc(sizeof(struct wdt_at32ap700x), GFP_KERNEL);
> +	wdt = devm_kzalloc(&pdev->dev, sizeof(struct wdt_at32ap700x),
> +			GFP_KERNEL);
>  	if (!wdt) {
>  		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
>  		return -ENOMEM;
>  	}
>  
> -	wdt->regs = ioremap(regs->start, resource_size(regs));
> +	wdt->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
>  	if (!wdt->regs) {
>  		ret = -ENOMEM;
>  		dev_dbg(&pdev->dev, "could not map I/O memory\n");
> @@ -342,7 +343,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
>  		dev_info(&pdev->dev, "CPU must be reset with external "
>  				"reset or POR due to silicon errata.\n");
>  		ret = -EIO;
> -		goto err_iounmap;
> +		goto err_free;
>  	} else {
>  		wdt->users = 0;
>  	}
> @@ -375,10 +376,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
>  
>  err_register:
>  	platform_set_drvdata(pdev, NULL);
> -err_iounmap:
> -	iounmap(wdt->regs);
>  err_free:
> -	kfree(wdt);
>  	wdt = NULL;
>  	return ret;
>  }
> @@ -391,8 +389,6 @@ static int __exit at32_wdt_remove(struct platform_device *pdev)
>  			at32_wdt_stop();
>  
>  		misc_deregister(&wdt->miscdev);
> -		iounmap(wdt->regs);
> -		kfree(wdt);
>  		wdt = NULL;
>  		platform_set_drvdata(pdev, NULL);
>  	}

err_free isn't really appropriate anymore as label,
and platform_set_drvdata(pdev, NULL) as well as the associated complexity
in at32_wdt_remove is not really needed, but especially the latter should
really be addressed in another patch, so

Acked-by: Guenter Roeck <linux@roeck-us.net>
