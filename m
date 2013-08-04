Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3HDKIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 06:08:07 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44859 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3HDKID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 06:08:03 -0400
Message-ID: <51FE361B.5030900@kernel.org>
Date: Sun, 04 Aug 2013 12:08:11 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com, Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/2] input: ti_tsc: Enable shared IRQ for TSC
References: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com> <1374882674-18403-2-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1374882674-18403-2-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/13 00:51, Zubair Lutfullah wrote:
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
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
I'd rather this went via input independent of the other patch
(if not there all that will happen is one or other driver will
fail to probe if both are attempted?)

Can take it through IIO but only with a Dmitry Ack.

> ---
>  drivers/input/touchscreen/ti_am335x_tsc.c |   18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
> index e1c5300..68d1250 100644
> --- a/drivers/input/touchscreen/ti_am335x_tsc.c
> +++ b/drivers/input/touchscreen/ti_am335x_tsc.c
> @@ -260,8 +260,18 @@ static irqreturn_t titsc_irq(int irq, void *dev)
>  	unsigned int fsm;
>  
>  	status = titsc_readl(ts_dev, REG_IRQSTATUS);
> -	if (status & IRQENB_FIFO0THRES) {
> -
> +	/*
> +	 * ADC and touchscreen share the IRQ line.
> +	 * FIFO1 threshold, FIFO1 Overrun and FIFO1 underflow
> +	 * interrupts are used by ADC,
> +	 * hence return from touchscreen IRQ handler if FIFO1
> +	 * related interrupts occurred.
> +	 */
> +	if ((status & IRQENB_FIFO1THRES) ||
> +			(status & IRQENB_FIFO1OVRRUN) ||
> +			(status & IRQENB_FIFO1UNDRFLW))
> +		return IRQ_NONE;
> +	else if (status & IRQENB_FIFO0THRES) {
>  		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
>  
>  		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
> @@ -315,7 +325,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
>  	}
>  
>  	if (irqclr) {
> -		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
> +		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
>  		am335x_tsc_se_update(ts_dev->mfd_tscadc);
>  		return IRQ_HANDLED;
>  	}
> @@ -389,7 +399,7 @@ static int titsc_probe(struct platform_device *pdev)
>  	}
>  
>  	err = request_irq(ts_dev->irq, titsc_irq,
> -			  0, pdev->dev.driver->name, ts_dev);
> +			  IRQF_SHARED, pdev->dev.driver->name, ts_dev);
>  	if (err) {
>  		dev_err(&pdev->dev, "failed to allocate irq.\n");
>  		goto err_free_mem;
> 
