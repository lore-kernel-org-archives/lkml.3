Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3GTK5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 06:57:33 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45171 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3GTK5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 06:57:31 -0400
Message-ID: <51EA6D19.7040401@kernel.org>
Date: Sat, 20 Jul 2013 11:57:29 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        Torokhov <dmitry.torokhov@gmail.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 03/15] input: ti_tsc: Enable shared IRQ for TSC
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com> <1374186086-5015-4-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1374186086-5015-4-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:21 PM, Zubair Lutfullah wrote:
> From: "Patil, Rachna" <rachna@ti.com>
> 
> Touchscreen and ADC share the same IRQ line from parent MFD core.
> Previously only Touchscreen was interrupt based.
> With continuous mode support added in ADC driver, driver requires
> interrupt to process the ADC samples, so enable shared IRQ flag bit for
> touchscreen.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
cc'd Dmitry and Linux-input.

If this goes through IIO as it is required for the rest of the series to
work then I will need an Ack from Dmitry.

> ---
>  drivers/input/touchscreen/ti_am335x_tsc.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
> index 0e9f02a..edc3d03 100644
> --- a/drivers/input/touchscreen/ti_am335x_tsc.c
> +++ b/drivers/input/touchscreen/ti_am335x_tsc.c
> @@ -260,8 +260,16 @@ static irqreturn_t titsc_irq(int irq, void *dev)
>  	unsigned int fsm;
>  
>  	status = titsc_readl(ts_dev, REG_IRQSTATUS);
> -	if (status & IRQENB_FIFO0THRES) {
>  
> +	/*
> +	* ADC and touchscreen share the IRQ line.
> +	* FIFO1 threshold interrupt is used by ADC,
> +	* hence return from touchscreen IRQ handler if FIFO1
> +	* threshold interrupt occurred.
> +	*/
> +	if (status & IRQENB_FIFO1THRES)
> +		return IRQ_NONE;
> +	else if (status & IRQENB_FIFO0THRES) {
>  		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
>  
>  		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
> @@ -315,7 +323,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
>  	}
>  
>  	if (irqclr) {
> -		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
> +		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
>  		am335x_tsc_se_update(ts_dev->mfd_tscadc);
>  		return IRQ_HANDLED;
>  	}
> @@ -389,7 +397,7 @@ static int titsc_probe(struct platform_device *pdev)
>  	}
>  
>  	err = request_irq(ts_dev->irq, titsc_irq,
> -			  0, pdev->dev.driver->name, ts_dev);
> +			  IRQF_SHARED, pdev->dev.driver->name, ts_dev);
>  	if (err) {
>  		dev_err(&pdev->dev, "failed to allocate irq.\n");
>  		goto err_free_mem;
> 
