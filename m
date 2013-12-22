Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3LVRs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 12:48:26 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47828 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3LVRsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 12:48:25 -0500
Message-ID: <52B725E8.40302@kernel.org>
Date: Sun, 22 Dec 2013 17:48:24 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mfd: ti_am335x: Drop am335x_tsc_se_update() from
 resume path
References: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de> <1387466911-3732-5-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1387466911-3732-5-git-send-email-bigeasy@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/13 15:28, Sebastian Andrzej Siewior wrote:
> The update of the SE register in MFD doesn't look right as it has
> nothing to do with it. The better place to do it is in TSC driver (which
> is already doing it) and in the ADC driver which needs this only in the
> continues mode.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>  [MFD part]
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  drivers/iio/adc/ti_am335x_adc.c | 2 ++
>  drivers/mfd/ti_am335x_tscadc.c  | 1 -
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index b5197a0..6822b9f 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -199,6 +199,7 @@ static int tiadc_buffer_predisable(struct iio_dev *indio_dev)
>  	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
>  				IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW));
>  	am335x_tsc_se_clr(adc_dev->mfd_tscadc, adc_dev->buffer_en_ch_steps);
> +	adc_dev->buffer_en_ch_steps = 0;
>  
>  	/* Flush FIFO of leftover data in the time it takes to disable adc */
>  	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> @@ -494,6 +495,7 @@ static int tiadc_resume(struct device *dev)
>  	tiadc_writel(adc_dev, REG_CTRL, restore);
>  
>  	tiadc_step_config(indio_dev);
> +	am335x_tsc_se_set(adc_dev->mfd_tscadc, adc_dev->buffer_en_ch_steps);
>  
>  	return 0;
>  }
> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index cb0c211..157f569 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -309,7 +309,6 @@ static int tscadc_resume(struct device *dev)
>  
>  	if (tscadc_dev->tsc_cell != -1)
>  		tscadc_idle_config(tscadc_dev);
> -	am335x_tsc_se_update(tscadc_dev);
>  	restore = tscadc_readl(tscadc_dev, REG_CTRL);
>  	tscadc_writel(tscadc_dev, REG_CTRL,
>  			(restore | CNTRLREG_TSCSSENB));
> 
