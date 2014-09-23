Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaIWKgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:36:03 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:50663 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbaIWKgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:36:00 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 23 Sep 2014 12:33:26 +0200
From: Johan Hovold <johan@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 08/10] rtc: at91sam9: use clk API instead of relying
 on AT91_SLOW_CLOCK
Message-ID: <20140923103326.GA404@localhost>
References: <1411465130-29011-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411465130-29011-9-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411465130-29011-9-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 11:38:48AM +0200, Boris BREZILLON wrote:

> @@ -328,6 +328,7 @@ static int at91_rtc_probe(struct platform_device *pdev)
>  	struct sam9_rtc	*rtc;
>  	int		ret, irq;
>  	u32		mr;
> +	unsigned int	sclk_rate;
>  
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
> @@ -385,11 +386,27 @@ static int at91_rtc_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> +	rtc->sclk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(rtc->sclk))
> +		return PTR_ERR(rtc->sclk);
> +
> +	sclk_rate = clk_get_rate(rtc->sclk);
> +	if (!sclk_rate || sclk_rate > AT91_RTT_RTTRST) {

You probably meant AT91_RTT_RTPRES here.

> +		dev_err(&pdev->dev, "Invalid slow clock rate");
> +		return -EINVAL;
> +	}
> +
> +	ret = clk_prepare_enable(rtc->sclk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not enable slow clock");
> +		return ret;
> +	}
> +
>  	mr = rtt_readl(rtc, MR);
>  
>  	/* unless RTT is counting at 1 Hz, re-initialize it */
> -	if ((mr & AT91_RTT_RTPRES) != AT91_SLOW_CLOCK) {
> -		mr = AT91_RTT_RTTRST | (AT91_SLOW_CLOCK & AT91_RTT_RTPRES);
> +	if ((mr & AT91_RTT_RTPRES) != sclk_rate) {
> +		mr = AT91_RTT_RTTRST | (sclk_rate & AT91_RTT_RTPRES);
>  		gpbr_writel(rtc, 0);
>  	}

Johan
