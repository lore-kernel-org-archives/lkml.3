Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3IHK3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 06:29:20 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36413 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3IHK3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 06:29:18 -0400
Message-ID: <522C5F96.20001@kernel.org>
Date: Sun, 08 Sep 2013 12:29:26 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] input: ti_am335x_tsc: Enable shared IRQ for TSC
References: <1378034277-26728-1-git-send-email-zubair.lutfullah@gmail.com> <1378034277-26728-2-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1378034277-26728-2-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/13 12:17, Zubair Lutfullah wrote:
> Enable shared IRQ to allow ADC to share IRQ line from
> parent MFD core. Only FIFO0 IRQs are for TSC and handled
> on the TSC side.
> 
> Step mask would be updated from cached variable only previously.
> In rare cases when both TSC and ADC are used, the cached
> variable gets mixed up.
> The step mask is written with the required mask every time.
> 
> Rachna Patil (TI) laid ground work for shared IRQ.
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Whilst I would have prefered an mfd under these drivers and elegant handling
of the interrupts, I guess if this works it is at least not terribly invasive.

However, this does need an Ack from Dmitry before I can take it (or for
Dmitry to take it himself?)

> ---
>  drivers/input/touchscreen/ti_am335x_tsc.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
> index e1c5300..24e625c 100644
> --- a/drivers/input/touchscreen/ti_am335x_tsc.c
> +++ b/drivers/input/touchscreen/ti_am335x_tsc.c
> @@ -52,6 +52,7 @@ struct titsc {
>  	u32			config_inp[4];
>  	u32			bit_xp, bit_xn, bit_yp, bit_yn;
>  	u32			inp_xp, inp_xn, inp_yp, inp_yn;
> +	u32			step_mask;
>  };
>  
>  static unsigned int titsc_readl(struct titsc *ts, unsigned int reg)
> @@ -196,7 +197,8 @@ static void titsc_step_config(struct titsc *ts_dev)
>  
>  	/* The steps1 … end and bit 0 for TS_Charge */
>  	stepenable = (1 << (end_step + 2)) - 1;
> -	am335x_tsc_se_set(ts_dev->mfd_tscadc, stepenable);
> +	ts_dev->step_mask = stepenable;
> +	am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
>  }
>  
>  static void titsc_read_coordinates(struct titsc *ts_dev,
> @@ -260,6 +262,10 @@ static irqreturn_t titsc_irq(int irq, void *dev)
>  	unsigned int fsm;
>  
>  	status = titsc_readl(ts_dev, REG_IRQSTATUS);
> +	/*
> +	 * ADC and touchscreen share the IRQ line.
> +	 * FIFO1 interrupts are used by ADC. Handle FIFO0 IRQs here only
> +	 */
>  	if (status & IRQENB_FIFO0THRES) {
>  
>  		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
> @@ -316,7 +322,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
>  
>  	if (irqclr) {
>  		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
> -		am335x_tsc_se_update(ts_dev->mfd_tscadc);
> +		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
>  		return IRQ_HANDLED;
>  	}
>  	return IRQ_NONE;
> @@ -389,7 +395,7 @@ static int titsc_probe(struct platform_device *pdev)
>  	}
>  
>  	err = request_irq(ts_dev->irq, titsc_irq,
> -			  0, pdev->dev.driver->name, ts_dev);
> +			  IRQF_SHARED, pdev->dev.driver->name, ts_dev);
>  	if (err) {
>  		dev_err(&pdev->dev, "failed to allocate irq.\n");
>  		goto err_free_mem;
> 
