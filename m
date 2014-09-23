Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbaIWMRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:17:31 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:45977 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646AbaIWMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:17:28 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 23 Sep 2014 14:14:55 +0200
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
Subject: Re: [PATCH v8 08/10] rtc: at91sam9: use clk API instead of relying
 on AT91_SLOW_CLOCK
Message-ID: <20140923121455.GC404@localhost>
References: <1411471444-2764-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411471444-2764-9-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411471444-2764-9-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 01:24:02PM +0200, Boris BREZILLON wrote:
> The RTT block is using the slow clock which is accessible through the clk
> API.
> Use the clk API to retrieve, enable and get the slow clk rate instead of
> the AT91_SLOW_CLOCK macro (which hardcodes the slow clk rate).
> Doing this allows us to reference the clk thus preventing the CCF from
> disabling it during the "disable unused" phase.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/rtc/rtc-at91sam9.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> index be9c28b..2eca624 100644
> --- a/drivers/rtc/rtc-at91sam9.c
> +++ b/drivers/rtc/rtc-at91sam9.c
> @@ -23,6 +23,7 @@
>  #include <linux/io.h>
>  #include <linux/mfd/syscon.h>
>  #include <linux/regmap.h>
> +#include <linux/clk.h>
>  
>  /*
>   * This driver uses two configurable hardware resources that live in the
> @@ -61,8 +62,6 @@
>  #define AT91_RTT_ALMS		(1 << 0)		/* Real-time Alarm Status */
>  #define AT91_RTT_RTTINC		(1 << 1)		/* Real-time Timer Increment */
>  
> -#define AT91_SLOW_CLOCK		32768
> -
>  /*
>   * We store ALARM_DISABLED in ALMV to record that no alarm is set.
>   * It's also the reset value for that field.
> @@ -77,6 +76,7 @@ struct sam9_rtc {
>  	struct regmap		*gpbr;
>  	unsigned int		gpbr_offset;
>  	int 			irq;
> +	struct clk		*sclk;
>  };
>  
>  #define rtt_readl(rtc, field) \
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
> +	if (!sclk_rate || sclk_rate > AT91_RTT_RTPRES) {
> +		dev_err(&pdev->dev, "Invalid slow clock rate");

dev_err message needs a newline.

> +		return -EINVAL;
> +	}
> +
> +	ret = clk_prepare_enable(rtc->sclk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not enable slow clock");

Here too.

Johan
