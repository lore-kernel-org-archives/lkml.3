Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3GTLVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 07:21:18 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45388 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3GTLVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 07:21:16 -0400
Message-ID: <51EA72AB.9060308@kernel.org>
Date: Sat, 20 Jul 2013 12:21:15 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: Re: [PATCH 08/15] iio: ti_am335x_adc: Handle overrun before threshold
 event
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com> <1374186086-5015-9-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1374186086-5015-9-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:21 PM, Zubair Lutfullah wrote:
> From: Russ Dill <Russ.Dill@ti.com>
> 
> If an overrun occurs, the threshold event is meaningless, handle
> the overrun event first.
> 
> Signed-off-by: Russ Dill <Russ.Dill@ti.com>
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>

This is getting a little silly.  Would Russ mind if these get
rolled up into the original patches?  Perhaps with his sign-off to
reflect his various contributions?

> ---
>  drivers/iio/adc/ti_am335x_adc.c |   24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 1c47818..7ac28a9 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -167,7 +167,16 @@ static irqreturn_t tiadc_irq(int irq, void *private)
>  	unsigned int status, config;
>  
>  	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
> -	if (status & IRQENB_FIFO1THRES) {
> +	if (status & IRQENB_FIFO1OVRRUN) {
> +		config = tiadc_readl(adc_dev, REG_CTRL);
> +		config &= ~(CNTRLREG_TSCSSENB);
> +		tiadc_writel(adc_dev, REG_CTRL, config);
> +		tiadc_writel(adc_dev, REG_IRQSTATUS,
> +				IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW);
> +		tiadc_writel(adc_dev, REG_CTRL,
> +				(config | CNTRLREG_TSCSSENB));
> +		return IRQ_HANDLED;
> +	} else if (status & IRQENB_FIFO1THRES) {
>  		tiadc_writel(adc_dev, REG_IRQCLR,
>  				IRQENB_FIFO1THRES);
>  
> @@ -180,19 +189,6 @@ static irqreturn_t tiadc_irq(int irq, void *private)
>  		tiadc_writel(adc_dev, REG_IRQSTATUS,
>  					IRQENB_FIFO1THRES);
>  		return IRQ_HANDLED;
> -	} else if ((status &  IRQENB_FIFO1OVRRUN) ||
> -			(status &  IRQENB_FIFO1UNDRFLW)) {
> -		config = tiadc_readl(adc_dev,  REG_CTRL);
> -		config &= ~(CNTRLREG_TSCSSENB);
> -		tiadc_writel(adc_dev,  REG_CTRL, config);
> -
> -		tiadc_writel(adc_dev, REG_IRQSTATUS,
> -				IRQENB_FIFO1OVRRUN |
> -				IRQENB_FIFO1UNDRFLW);
> -
> -		tiadc_writel(adc_dev,  REG_CTRL,
> -			(config |  CNTRLREG_TSCSSENB));
> -		return IRQ_HANDLED;
>  	} else {
>  		return IRQ_NONE;
>  	}
> 
