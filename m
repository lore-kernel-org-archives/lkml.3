Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3LSRSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:18:32 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40641 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3LSRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:18:29 -0500
Date: Thu, 19 Dec 2013 17:18:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mfd: input: iio: ti_amm335x: Rework TSC/ADC
 synchronization
Message-ID: <20131219171823.GC16145@lee--X1>
References: <1387466911-3732-1-git-send-email-bigeasy@linutronix.de>
 <1387466911-3732-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387466911-3732-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, Sebastian Andrzej Siewior wrote:

> The ADC driver always programs all possible ADC values and discards
> them except for the value IIO asked for. On the am335x-evm the driver
> programs four values and it takes 500us to gather them. Reducing the number
> of conversations down to the (required) one also reduces the busy loop down
> to 125us.
> 
> This leads to another error, namely the FIFOCOUNT register is sometimes
> (like one out of 10 attempts) not updated in time leading to EBUSY.
> The next read has the FIFOCOUNT register updated.
> Checking for the ADCSTAT register for being idle isn't a good choice either.
> The problem is that if TSC is used at the same time, the HW completes the
> conversation for ADC *and* before the driver noticed it, the HW begins to
> perform a TSC conversation and so the driver never seen the HW idle. The
> next time we would have two values in the FIFO but since the driver reads
> everything we always see the current one.
> So instead of polling for the IDLE bit in ADCStatus register, we should
> check the FIFOCOUNT register. It should be one instead of zero because we
> request one value.
> 
> This change in turn leads to another error. Sometimes if TSC & ADC are
> used together the TSC starts becoming interrupts even if nobody
> actually touched the touchscreen. The interrupts seem valid because TSC's
> FIFO is filled with values for each channel of the TSC. This condition stops
> after a few ADC reads but will occur again. Not good.
> 
> On top of this (even without the changes I just mentioned) there is a ADC
> & TSC lockup condition which was reported to me by Jeff Lance including the
> following test case:
> A busy loop of "cat /sys/bus/iio/devices/iio\:device0/in_voltage4_raw"
> and a mug on touch screen. With this setup, the hardware will lockup after
> something between 20 minutes and it could take up to a couple of hours.
> During that lockup, the ADCSTAT register says 0x30 (or 0x70) which means
> STEP_ID = IDLE and FSM_BUSY = yes. That means the hardware says that it is
> idle and busy at the same time which is an invalid condition.
> 
> For all this reasons I decided to rework this TSC/ADC part and add a
> handshake / synchronization here:
> First the ADC signals that it needs the HW and writes a 0 mask into the
> SE register. The HW (if active) will complete the current conversation
> and become idle. The TSC driver will gather the values from the FIFO
> (woken up by an interrupt) and won't "enable" another conversation.
> Instead it will wake up the ADC driver which is already waiting. The ADC
> driver will start "its" conversation and once it is done, it will
> enable the TSC steps so the TSC will work again.
> 
> After this rework I haven't observed the lockup so far. Plus the busy
> loop has been reduced from 500us to 125us.
> 
> The continues-read mode remains unchanged.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/iio/adc/ti_am335x_adc.c      | 64 ++++++++++++++++++++++++++----------
>  drivers/mfd/ti_am335x_tscadc.c       | 63 +++++++++++++++++++++++++++++------
>  include/linux/mfd/ti_am335x_tscadc.h |  4 +++

Assuming nothing else has changed since the answers you gave me:
  Acked-by: Lee Jones <lee.jones@linaro.org>

Once we have the remaining Acks I'll happily apply this patch-set.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
