Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3LSImO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:42:14 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:45135 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3LSImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:42:12 -0500
Date: Thu, 19 Dec 2013 08:42:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mfd: input: iio: ti_amm335x: rework TSC/ADC
 synchronisation
Message-ID: <20131219084206.GC2621@lee--X1>
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
 <1387385577-24447-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387385577-24447-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The ADC driver always programms all possible ADC values and discards
> them except for the value IIO asked for. On the am335x-evm the driver
> programs four values and it takes 500us to gather them. Reducing the number
> of coversations down to (required) one also reduces the busy loop down to
> 125us.
> This leads to another error, namely the FIFOCOUNT register is sometimes
> (like one out of 10 attempts) not updated in time leading to timeouts.
> The next read has the fifocount register updated.
> Checking for the ADCStatus status register for beeing idle isn't a good
> choice either. The problem is that it often times out if the TSC is used
> at the same time. The problem is that the HW compelted the conversaton for
> the ADC *and* before the driver noticed it, the HW began to perfom a
> TSC conversation and so the driver never seen the HW idle. The next time
> we would have two values in the fifo but since the driver reads
> everything we always see the current one.
> So instead of polling for the IDLE bit, we check for the fifocount. It
> should be one instead of zero because we request one value.
> This change in turn lead to another error :) Sometimes if TSC & ADC are
> used together the TSC starts becomming interrupts even if nobody
> actually touched the touchscreen. The interrupts are valid because TSC's
> fifo is filled with values. This condition stops after a few ADC reads but
> will occur once TSC & ADC are used at the same time. So not good.
> 
> On top of this (even without the changes I just mentioned) there is a ADC
> & TSC lockup condition which was reported to my Jeff Lance including a test
> case:
> A busyloop of loop of "cat /sys/bus/iio/devices/iio\:device0/in_voltage4_raw"
> and a mug on touch screen. Whith this setup, the hardware will lockup after
> something between 20min and it could take up to a couple of hours. During that
> lockup, the ADCSTAT says 0x30 (or 0x70) which means STEP_ID = IDLE and
> FSM_BUSY = yes. That means it says that it is idle and busy at the same
> time which is an invalid condition.
> 
> For all this reasons I decided to rework this TSC/ADC part and add a
> handshake / synchronisation here:
> First the ADC signals that it needs the HW and writes a 0 mask into the
> SE register. The HW (if active) will complete the current conversation
> and become idle. The TSC driver will gather the values from the FIFO
> (woken up by an interrupt) and won't "enable" another conversation.
> Instead it will wake up the ADC driver which is already waiting. The ADC
> driver will start "its" converstation and once it is done, it will
> enable the TSC events so the TSC will work again.

Spell check this entire block.

Smileys in commit messages are generally a bad idea.

Please insert '\n's between paragraphs.

Proof read, as some of the sentences are not comprehensible.

/* MFD Parts */

> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -24,6 +24,7 @@

> -static void am335x_tsc_se_update(struct ti_tscadc_dev *tsadc)
> +void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
>  {
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tsadc->reg_lock, flags);
> +	tsadc->reg_se_cache |= val;
>  	tscadc_writel(tsadc, REG_SE, tsadc->reg_se_cache);
> +	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
>  }
> +EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
>  
> -void am335x_tsc_se_set(struct ti_tscadc_dev *tsadc, u32 val)
> +void am335x_tsc_se_tsc_set(struct ti_tscadc_dev *tsadc, u32 val)

What's the difference between:

am335x_tsc_se_set()
and
am335x_tsc_se_tsc_set()

Why don't you have a am335x_tsc_se_tsc_set_tsc_se_tsc_set() ;)

Perhaps a better function name might be in order.

>  {
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&tsadc->reg_lock, flags);
> -	tsadc->reg_se_cache |= val;
> -	am335x_tsc_se_update(tsadc);
> +	tsadc->reg_se_cache = val;
> +	if (tsadc->adc_in_use || tsadc->adc_waiting) {
> +		if (tsadc->adc_waiting)
> +			wake_up(&tsadc->reg_se_wait);

So if we're either in-use or waiting, the step mask is never set?

But I guess that the touchscreen driver assumes it has been set.

Is this okay?

> +	} else {
> +		tscadc_writel(tsadc, REG_SE, val);
> +	}

I think this would be better represented as:

        if (tsadc->adc_waiting)
                wake_up(&tsadc->reg_se_wait);
        else if (!tsadc->adc_in_use)
                tscadc_writel(tsadc, REG_SE, val);

>  	spin_unlock_irqrestore(&tsadc->reg_lock, flags);
>  }
> -EXPORT_SYMBOL_GPL(am335x_tsc_se_set);
> +EXPORT_SYMBOL_GPL(am335x_tsc_se_tsc_set);

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
