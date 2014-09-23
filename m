Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaIWIPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:15:45 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:13458 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaIWIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:15:42 -0400
Message-ID: <54212C2A.8000109@atmel.com>
Date: Tue, 23 Sep 2014 10:15:38 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Hovold <jhovold@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 3/9] rtc: at91sam9: replace devm_ioremap by devm_ioremap_resource
References: <1411400563-570-1-git-send-email-boris.brezillon@free-electrons.com> <1411400563-570-4-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1411400563-570-4-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/09/2014 17:42, Boris BREZILLON :
> Replace devm_ioremap calls by devm_ioremap_resource which already check
> resource consistency (resource != NULL) and print an error in case of
> failure.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/rtc/rtc-at91sam9.c | 29 ++++++++++-------------------
>  1 file changed, 10 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> index 74a9ca0..38a2693 100644
> --- a/drivers/rtc/rtc-at91sam9.c
> +++ b/drivers/rtc/rtc-at91sam9.c
> @@ -306,18 +306,11 @@ static const struct rtc_class_ops at91_rtc_ops = {
>   */
>  static int at91_rtc_probe(struct platform_device *pdev)
>  {
> -	struct resource	*r, *r_gpbr;
> +	struct resource	*r;
>  	struct sam9_rtc	*rtc;
>  	int		ret, irq;
>  	u32		mr;
>  
> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	r_gpbr = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (!r || !r_gpbr) {
> -		dev_err(&pdev->dev, "need 2 ressources\n");
> -		return -ENODEV;
> -	}
> -
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
>  		dev_err(&pdev->dev, "failed to get interrupt resource\n");
> @@ -335,18 +328,16 @@ static int at91_rtc_probe(struct platform_device *pdev)
>  		device_init_wakeup(&pdev->dev, 1);
>  
>  	platform_set_drvdata(pdev, rtc);
> -	rtc->rtt = devm_ioremap(&pdev->dev, r->start, resource_size(r));
> -	if (!rtc->rtt) {
> -		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
> -		return -ENOMEM;
> -	}
>  
> -	rtc->gpbr = devm_ioremap(&pdev->dev, r_gpbr->start,
> -				resource_size(r_gpbr));
> -	if (!rtc->gpbr) {
> -		dev_err(&pdev->dev, "failed to map gpbr registers, aborting.\n");
> -		return -ENOMEM;
> -	}
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	rtc->rtt = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(rtc->rtt))
> +		return PTR_ERR(rtc->rtt);
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	rtc->gpbr = devm_ioremap_resource(&pdev->dev, r);
> +	if (IS_ERR(rtc->gpbr))
> +		return PTR_ERR(rtc->rtt);
>  
>  	mr = rtt_readl(rtc, MR);
>  
> 


-- 
Nicolas Ferre
