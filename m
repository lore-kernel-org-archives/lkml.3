Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab3LEPx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:53:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56016 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab3LEPxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:53:54 -0500
Message-ID: <52A0AEDD.7060509@ti.com>
Date: Thu, 5 Dec 2013 18:50:37 +0200
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        <rtc-linux@googlegroups.com>, "'Kevin Hilman'" <khilman@linaro.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Peter Ujfalusi'" <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 1/2] rtc: rtc-twl: Use devm_*() functions
References: <000001cef155$be1674e0$3a435ea0$%han@samsung.com>
In-Reply-To: <000001cef155$be1674e0$3a435ea0$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.75]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 03:03 AM, Jingoo Han wrote:
> Use devm_*() functions to make cleanup paths simpler, and remove
> unnecessary remove().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>   drivers/rtc/rtc-twl.c |   38 +++++++++++++-------------------------
>   1 file changed, 13 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
> index c2e80d7..1915464 100644
> --- a/drivers/rtc/rtc-twl.c
> +++ b/drivers/rtc/rtc-twl.c
> @@ -479,7 +479,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
>   	u8 rd_reg;
>   
>   	if (irq <= 0)
> -		goto out1;
> +		return ret;
>   
>   	/* Initialize the register map */
>   	if (twl_class_is_4030())
> @@ -489,7 +489,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
>   
>   	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
>   	if (ret < 0)
> -		goto out1;
> +		return ret;
>   
>   	if (rd_reg & BIT_RTC_STATUS_REG_POWER_UP_M)
>   		dev_warn(&pdev->dev, "Power up reset detected.\n");
> @@ -500,7 +500,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
>   	/* Clear RTC Power up reset and pending alarm interrupts */
>   	ret = twl_rtc_write_u8(rd_reg, REG_RTC_STATUS_REG);
>   	if (ret < 0)
> -		goto out1;
> +		return ret;
>   
>   	if (twl_class_is_6030()) {
>   		twl6030_interrupt_unmask(TWL6030_RTC_INT_MASK,
> @@ -512,7 +512,7 @@ static int twl_rtc_probe(struct platform_device *pdev)
>   	dev_info(&pdev->dev, "Enabling TWL-RTC\n");
>   	ret = twl_rtc_write_u8(BIT_RTC_CTRL_REG_STOP_RTC_M, REG_RTC_CTRL_REG);
>   	if (ret < 0)
> -		goto out1;
> +		return ret;
>   
>   	/* ensure interrupts are disabled, bootloaders can be strange */
>   	ret = twl_rtc_write_u8(0, REG_RTC_INTERRUPTS_REG);
> @@ -522,34 +522,29 @@ static int twl_rtc_probe(struct platform_device *pdev)
>   	/* init cached IRQ enable bits */
>   	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
>   	if (ret < 0)
> -		goto out1;
> +		return ret;
>   
>   	device_init_wakeup(&pdev->dev, 1);
>   
> -	rtc = rtc_device_register(pdev->name,
> -				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
> +	rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
> +					&twl_rtc_ops, THIS_MODULE);
>   	if (IS_ERR(rtc)) {
> -		ret = PTR_ERR(rtc);
>   		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
>   			PTR_ERR(rtc));
> -		goto out1;
> +		return PTR_ERR(rtc);
>   	}
>   
> -	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
> -				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> -				   dev_name(&rtc->dev), rtc);
> +	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
> +					twl_rtc_interrupt,
> +					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> +					dev_name(&rtc->dev), rtc);

Looks like this will change driver release order and free_irq
will be called after RTC device is unregistered.
I think, you need to request irq first -> then register RTC device.
Right?

>   	if (ret < 0) {
>   		dev_err(&pdev->dev, "IRQ is not free.\n");
> -		goto out2;
> +		return ret;
>   	}
>   
>   	platform_set_drvdata(pdev, rtc);
>   	return 0;
> -
> -out2:
> -	rtc_device_unregister(rtc);
> -out1:
> -	return ret;
>   }
>   
>   /*
> @@ -559,9 +554,6 @@ out1:
>   static int twl_rtc_remove(struct platform_device *pdev)
>   {
>   	/* leave rtc running, but disable irqs */
> -	struct rtc_device *rtc = platform_get_drvdata(pdev);
> -	int irq = platform_get_irq(pdev, 0);
> -
>   	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
>   	mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_TIMER_M);
>   	if (twl_class_is_6030()) {
> @@ -571,10 +563,6 @@ static int twl_rtc_remove(struct platform_device *pdev)
>   			REG_INT_MSK_STS_A);
>   	}
>   
> -
> -	free_irq(irq, rtc);
> -
> -	rtc_device_unregister(rtc);
>   	return 0;
>   }
>   
> 

