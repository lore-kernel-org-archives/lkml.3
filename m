Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3CLXIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:08:47 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22912 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755895Ab3CLXIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:08:45 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19YRMmdUiqF9TVMV6PBFpctNKpCiu4smpU=
Date: Tue, 12 Mar 2013 19:08:43 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Simon Baatz <gmbnomis@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [ 33/40] rtc: rtc-mv: Add support for clk to avoid lockups
Message-ID: <20130312230843.GK12700@titan.lakedaemon.net>
References: <20130312223211.492954675@linuxfoundation.org>
 <20130312223214.995095830@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312223214.995095830@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tue, Mar 12, 2013 at 03:43:54PM -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Andrew Lunn <andrew@lunn.ch>
> 
> commit 89c58c198b252f2bc20657fdd72a2aea788c435c upstream.
> 
> The Marvell RTC on Kirkwood makes use of the runit clock. Ensure the
> driver clk_prepare_enable() this clock, otherwise there is a danger
> the SoC will lockup when accessing RTC registers with the clock
> disabled.
> 
> Reported-by: Simon Baatz <gmbnomis@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Simon Baatz <gmbnomis@gmail.com>
> Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/arm/boot/dts/kirkwood.dtsi |    1 +
>  drivers/rtc/rtc-mv.c            |   28 ++++++++++++++++++++++++----
>  2 files changed, 25 insertions(+), 4 deletions(-)

Please drop from 3.4-stable.  devm_clk_get() wasn't available.

thx,


Jason.

> 
> --- a/arch/arm/boot/dts/kirkwood.dtsi
> +++ b/arch/arm/boot/dts/kirkwood.dtsi
> @@ -31,6 +31,7 @@
>  			compatible = "mrvl,kirkwood-rtc", "mrvl,orion-rtc";
>  			reg = <0x10300 0x20>;
>  			interrupts = <53>;
> +			clocks = <&gate_clk 7>;
>  		};
>  	};
>  };
> --- a/drivers/rtc/rtc-mv.c
> +++ b/drivers/rtc/rtc-mv.c
> @@ -14,6 +14,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/of.h>
>  #include <linux/delay.h>
> +#include <linux/clk.h>
>  #include <linux/gfp.h>
>  #include <linux/module.h>
>  
> @@ -41,6 +42,7 @@ struct rtc_plat_data {
>  	struct rtc_device *rtc;
>  	void __iomem *ioaddr;
>  	int		irq;
> +	struct clk	*clk;
>  };
>  
>  static int mv_rtc_set_time(struct device *dev, struct rtc_time *tm)
> @@ -221,6 +223,7 @@ static int __devinit mv_rtc_probe(struct
>  	struct rtc_plat_data *pdata;
>  	resource_size_t size;
>  	u32 rtc_time;
> +	int ret = 0;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!res)
> @@ -239,11 +242,17 @@ static int __devinit mv_rtc_probe(struct
>  	if (!pdata->ioaddr)
>  		return -ENOMEM;
>  
> +	pdata->clk = devm_clk_get(&pdev->dev, NULL);
> +	/* Not all SoCs require a clock.*/
> +	if (!IS_ERR(pdata->clk))
> +		clk_prepare_enable(pdata->clk);
> +
>  	/* make sure the 24 hours mode is enabled */
>  	rtc_time = readl(pdata->ioaddr + RTC_TIME_REG_OFFS);
>  	if (rtc_time & RTC_HOURS_12H_MODE) {
>  		dev_err(&pdev->dev, "24 Hours mode not supported.\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out;
>  	}
>  
>  	/* make sure it is actually functional */
> @@ -252,7 +261,8 @@ static int __devinit mv_rtc_probe(struct
>  		rtc_time = readl(pdata->ioaddr + RTC_TIME_REG_OFFS);
>  		if (rtc_time == 0x01000000) {
>  			dev_err(&pdev->dev, "internal RTC not ticking\n");
> -			return -ENODEV;
> +			ret = -ENODEV;
> +			goto out;
>  		}
>  	}
>  
> @@ -268,8 +278,10 @@ static int __devinit mv_rtc_probe(struct
>  	} else
>  		pdata->rtc = rtc_device_register(pdev->name, &pdev->dev,
>  						 &mv_rtc_ops, THIS_MODULE);
> -	if (IS_ERR(pdata->rtc))
> -		return PTR_ERR(pdata->rtc);
> +	if (IS_ERR(pdata->rtc)) {
> +		ret = PTR_ERR(pdata->rtc);
> +		goto out;
> +	}
>  
>  	if (pdata->irq >= 0) {
>  		writel(0, pdata->ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
> @@ -282,6 +294,11 @@ static int __devinit mv_rtc_probe(struct
>  	}
>  
>  	return 0;
> +out:
> +	if (!IS_ERR(pdata->clk))
> +		clk_disable_unprepare(pdata->clk);
> +
> +	return ret;
>  }
>  
>  static int __exit mv_rtc_remove(struct platform_device *pdev)
> @@ -292,6 +309,9 @@ static int __exit mv_rtc_remove(struct p
>  		device_init_wakeup(&pdev->dev, 0);
>  
>  	rtc_device_unregister(pdata->rtc);
> +	if (!IS_ERR(pdata->clk))
> +		clk_disable_unprepare(pdata->clk);
> +
>  	return 0;
>  }
>  
> 
> 
