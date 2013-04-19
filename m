Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab3DSKTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:19:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:24567 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab3DSKTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:19:52 -0400
Message-ID: <51711A41.50209@atmel.com>
Date: Fri, 19 Apr 2013 12:19:45 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>
CC: Johan Hovold <jhovold@gmail.com>, <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc: rtc-at91rm9200: fix missing iounmap
References: <1365691116-8882-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1365691116-8882-1-git-send-email-jhovold@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 04:38 PM, Johan Hovold :
> Add missing iounmap to probe error path and remove.
> 
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Andrew, can you take this one please?
(https://patchwork.kernel.org/patch/2429031/)


Best regards,

> ---
>  drivers/rtc/rtc-at91rm9200.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
> index 434ebc3..eebd8ac 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -297,7 +297,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
>  				"at91_rtc", pdev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "IRQ %d already in use.\n", irq);
> -		return ret;
> +		goto err_unmap;
>  	}
>  
>  	/* cpu init code should really have flagged this device as
> @@ -309,13 +309,20 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
>  	rtc = rtc_device_register(pdev->name, &pdev->dev,
>  				&at91_rtc_ops, THIS_MODULE);
>  	if (IS_ERR(rtc)) {
> -		free_irq(irq, pdev);
> -		return PTR_ERR(rtc);
> +		ret = PTR_ERR(rtc);
> +		goto err_free_irq;
>  	}
>  	platform_set_drvdata(pdev, rtc);
>  
>  	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
>  	return 0;
> +
> +err_free_irq:
> +	free_irq(irq, pdev);
> +err_unmap:
> +	iounmap(at91_rtc_regs);
> +
> +	return ret;
>  }
>  
>  /*
> @@ -332,6 +339,7 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
>  	free_irq(irq, pdev);
>  
>  	rtc_device_unregister(rtc);
> +	iounmap(at91_rtc_regs);
>  	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
> 


-- 
Nicolas Ferre
