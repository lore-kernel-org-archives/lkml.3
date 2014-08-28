Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaH1Stu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:49:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39813 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754250AbaH1Str (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:49:47 -0400
Date: Thu, 28 Aug 2014 19:48:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "balbi@ti.com" <balbi@ti.com>, "kishon@ti.com" <kishon@ti.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>
Subject: Re: [PATCH 1/5] usb: dwc3: exynos: Add support for SCLK present on
 Exynos7
Message-ID: <20140828184847.GA18464@leverpostej>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
 <1409212920-28526-2-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409212920-28526-2-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 09:01:56AM +0100, Vivek Gautam wrote:
> Exynos7 also has a separate special gate clock going to the IP
> apart from the usual AHB clock. So add support for the same.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
> index f9fb8ad..bab6395 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -35,6 +35,7 @@ struct dwc3_exynos {
>  	struct device		*dev;
>  
>  	struct clk		*clk;
> +	struct clk		*sclk;
>  	struct regulator	*vdd33;
>  	struct regulator	*vdd10;
>  };
> @@ -141,10 +142,17 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> +	/* Exynos7 has a special gate clock going to this IP */
> +	exynos->sclk = devm_clk_get(dev, "usbdrd30_sclk");
> +	if (IS_ERR(exynos->sclk))
> +		dev_warn(dev, "couldn't get sclk\n");

Doesn't this introduce a pointless warning for Exynos SoCs other than
Exynos7?

> +
>  	exynos->dev	= dev;
>  	exynos->clk	= clk;
>  
>  	clk_prepare_enable(exynos->clk);
> +	if (!IS_ERR(exynos->sclk))
> +		clk_prepare_enable(exynos->sclk);

If you replaced the returned err value with NULL you could avoid these
IS_ERR cases.

Mark.

>  
>  	exynos->vdd33 = devm_regulator_get(dev, "vdd33");
>  	if (IS_ERR(exynos->vdd33)) {
> @@ -187,6 +195,8 @@ err4:
>  err3:
>  	regulator_disable(exynos->vdd33);
>  err2:
> +	if (!IS_ERR(exynos->sclk))
> +		clk_disable_unprepare(exynos->sclk);
>  	clk_disable_unprepare(clk);
>  	return ret;
>  }
> @@ -199,6 +209,8 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
>  	platform_device_unregister(exynos->usb2_phy);
>  	platform_device_unregister(exynos->usb3_phy);
>  
> +	if (!IS_ERR(exynos->sclk))
> +		clk_disable_unprepare(exynos->sclk);
>  	clk_disable_unprepare(exynos->clk);
>  
>  	regulator_disable(exynos->vdd33);
> @@ -220,6 +232,8 @@ static int dwc3_exynos_suspend(struct device *dev)
>  {
>  	struct dwc3_exynos *exynos = dev_get_drvdata(dev);
>  
> +	if (!IS_ERR(exynos->sclk))
> +		clk_disable(exynos->sclk);
>  	clk_disable(exynos->clk);
>  
>  	regulator_disable(exynos->vdd33);
> @@ -245,6 +259,8 @@ static int dwc3_exynos_resume(struct device *dev)
>  	}
>  
>  	clk_enable(exynos->clk);
> +	if (!IS_ERR(exynos->sclk))
> +		clk_enable(exynos->sclk);
>  
>  	/* runtime set active to reflect active state. */
>  	pm_runtime_disable(dev);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
