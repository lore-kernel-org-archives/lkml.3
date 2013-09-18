Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3IRN6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:58:52 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:35286 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3IRN6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:58:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <5239B197.2040807@jic23.retrosnub.co.uk>
Date: Wed, 18 Sep 2013 14:58:47 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
References: <1379503383-17086-1-git-send-email-zubair.lutfullah@gmail.com> <1379503383-17086-3-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1379503383-17086-3-git-send-email-zubair.lutfullah@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/13 12:23, Zubair Lutfullah wrote:
> Previously the driver had only one-shot reading functionality.
> This patch adds continuous sampling support to the driver.
>
> Continuous sampling starts when buffer is enabled.
> HW IRQ wakes worker thread that pushes samples to userspace.
> Sampling stops when buffer is disabled by userspace.
>
> Patil Rachna (TI) laid the ground work for ADC HW register access.
> Russ Dill (TI) fixed bugs in the driver relevant to FIFOs and IRQs.
>
> I fixed channel scanning so multiple ADC channels can be read
> simultaneously and pushed to userspace.
> Restructured the driver to fit IIO ABI.
> And added INDIO_BUFFER_HARDWARE mode.
>
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Russ Dill <Russ.Dill@ti.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Very very nearly there. Couple of suggestions in-line.
(about 30 seconds work + testing ;)

I'm still unsure of why we need 32bit storage in the fifo
for the data.  I've proposed the changes I'd make to put it in 16 bit
storage inline.  The fact that the device is working in 32bits
is irrelevant given we only have a 12 bit number coming out and
it is in 12 least significant bits.  I guess there might be a tiny
cost in doing the conversion, but you kfifo will be half the size
as a result and that seems more likely to a worthwhile gain!

Out of interest, are you testing this with generic_buffer.c?
If so, what changes were necessary?  Given this driver will not
have a trigger it would be nice to update that example code to handle
that case if it doesn't already.

Thanks,

Jonathan


> ---
>   drivers/iio/adc/ti_am335x_adc.c      |  216 +++++++++++++++++++++++++++++++++-
>   include/linux/mfd/ti_am335x_tscadc.h |    9 ++
>   2 files changed, 220 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index a952538..b4b2ea0 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -28,12 +28,19 @@
>   #include <linux/iio/driver.h>
>
>   #include <linux/mfd/ti_am335x_tscadc.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/kfifo_buf.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/triggered_buffer.h>
>
>   struct tiadc_device {
>   	struct ti_tscadc_dev *mfd_tscadc;
>   	int channels;
>   	u8 channel_line[8];
>   	u8 channel_step[8];
> +	int buffer_en_ch_steps;
> +	u32 *data;
u16 *data;

Also it might actually save memory to simply have a fixed size array of 
the maximum size used here and avoid the extra allocations for the cost
of 16 bytes in here.

Hence,

u16 data[8];
>   };
>
>   static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
> @@ -56,8 +63,14 @@ static u32 get_adc_step_mask(struct tiadc_device *adc_dev)
>   	return step_en;
>   }
>
> -static void tiadc_step_config(struct tiadc_device *adc_dev)
> +static u32 get_adc_step_bit(struct tiadc_device *adc_dev, int chan)
>   {
> +	return 1 << adc_dev->channel_step[chan];
> +}
> +
> +static void tiadc_step_config(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>   	unsigned int stepconfig;
>   	int i, steps;
>
> @@ -72,7 +85,11 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>   	 */
>
>   	steps = TOTAL_STEPS - adc_dev->channels;
> -	stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
> +	if (iio_buffer_enabled(indio_dev))
> +		stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1
> +					| STEPCONFIG_MODE_SWCNT;
> +	else
> +		stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
>
>   	for (i = 0; i < adc_dev->channels; i++) {
>   		int chan;
> @@ -85,7 +102,177 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>   		adc_dev->channel_step[i] = steps;
>   		steps++;
>   	}
> +}
> +
> +static irqreturn_t tiadc_irq_h(int irq, void *private)
> +{
> +	struct iio_dev *indio_dev = private;
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	unsigned int status, config;
> +	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
> +
> +	/*
> +	 * ADC and touchscreen share the IRQ line.
> +	 * FIFO0 interrupts are used by TSC. Handle FIFO1 IRQs here only
> +	 */
> +	if (status & IRQENB_FIFO1OVRRUN) {
> +		/* FIFO Overrun. Clear flag. Disable/Enable ADC to recover */
> +		config = tiadc_readl(adc_dev, REG_CTRL);
> +		config &= ~(CNTRLREG_TSCSSENB);
> +		tiadc_writel(adc_dev, REG_CTRL, config);
> +		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1OVRRUN
> +				| IRQENB_FIFO1UNDRFLW | IRQENB_FIFO1THRES);
> +		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
> +		return IRQ_HANDLED;
> +	} else if (status & IRQENB_FIFO1THRES) {
> +		/* Disable irq and wake worker thread */
> +		tiadc_writel(adc_dev, REG_IRQCLR, IRQENB_FIFO1THRES);
I guess this is necessary given the sharing will make IRQF_ONESHOT
tricky. As disabling the source of the interrupts is nice and
easy here this will do the job.
> +		return IRQ_WAKE_THREAD;
> +	}
> +
> +	return IRQ_NONE;
> +}
> +
> +static irqreturn_t tiadc_worker_h(int irq, void *private)
> +{
> +	struct iio_dev *indio_dev = private;
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	int i, k, fifo1count, read;
> +	u32 *data = adc_dev->data;
	u16* data = adc_dev->data;
> +
> +	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> +	for (k = 0; k < fifo1count; k = k + i) {
> +		for (i = 0; i < (indio_dev->scan_bytes)/4; i++) {
> +			read = tiadc_readl(adc_dev, REG_FIFO1);
> +			data[i] = read & FIFOREAD_DATA_MASK;
//This is a 12 bit number after the mask so will fit just fine into 16 bits.
> +		}
> +		iio_push_to_buffers(indio_dev, (u8 *) data);
> +	}
>
> +	tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1THRES);
> +	tiadc_writel(adc_dev, REG_IRQENABLE, IRQENB_FIFO1THRES);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int tiadc_buffer_preenable(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	int i, fifo1count, read;
> +
> +	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
> +				IRQENB_FIFO1OVRRUN |
> +				IRQENB_FIFO1UNDRFLW));
> +
> +	/* Flush FIFO. Needed in corner cases in simultaneous tsc/adc use */
> +	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> +	for (i = 0; i < fifo1count; i++)
> +		read = tiadc_readl(adc_dev, REG_FIFO1);
> +
> +	return iio_sw_buffer_preenable(indio_dev);
> +}
> +
> +static int tiadc_buffer_postenable(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	struct iio_buffer *buffer = indio_dev->buffer;
> +	unsigned int enb = 0;
> +	u8 bit;
> +
(can drop this if doing the array with adc_dev as suggested above)
> +	adc_dev->data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
> +	if (adc_dev->data == NULL)
> +		return -ENOMEM;
> +
> +	tiadc_step_config(indio_dev);
> +	for_each_set_bit(bit, buffer->scan_mask, adc_dev->channels)
> +		enb |= (get_adc_step_bit(adc_dev, bit) << 1);
> +	adc_dev->buffer_en_ch_steps = enb;
> +
> +	am335x_tsc_se_set(adc_dev->mfd_tscadc, enb);
> +
> +	tiadc_writel(adc_dev,  REG_IRQSTATUS, IRQENB_FIFO1THRES
> +				| IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW);
> +	tiadc_writel(adc_dev,  REG_IRQENABLE, IRQENB_FIFO1THRES
> +				| IRQENB_FIFO1OVRRUN);
> +
> +	return 0;
> +}
> +
> +static int tiadc_buffer_predisable(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	int fifo1count, i, read;
> +
> +	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
> +				IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW));
> +	am335x_tsc_se_clr(adc_dev->mfd_tscadc, adc_dev->buffer_en_ch_steps);
> +
> +	/* Flush FIFO of leftover data in the time it takes to disable adc */
> +	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> +	for (i = 0; i < fifo1count; i++)
> +		read = tiadc_readl(adc_dev, REG_FIFO1);
> +
> +	return 0;
> +}
> +
> +static int tiadc_buffer_postdisable(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +
> +	tiadc_step_config(indio_dev);
(can drop this if doing the array withing adc_dev as suggested above)
> +	kfree(adc_dev->data);
This is also missbalanced with the preenable (which is true of quite
a few drivers - one day I'll clean those up!)
> +
> +	return 0;
> +}


