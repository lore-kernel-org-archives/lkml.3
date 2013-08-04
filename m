Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3HDKFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 06:05:31 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44823 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3HDKF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 06:05:28 -0400
Message-ID: <51FE357C.2040401@kernel.org>
Date: Sun, 04 Aug 2013 12:05:32 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling and trigger
 support
References: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com> <1374882674-18403-3-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1374882674-18403-3-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/13 00:51, Zubair Lutfullah wrote:
> Previously the driver had only one-shot reading functionality.
> This patch adds triggered buffer support to the driver.
> A buffer of samples can now be read via /dev/iio.
>
> Patil Rachna (TI) laid the ground work for ADC HW register access.
> Russ Dill (TI) fixed bugs in the driver relevant to FIFOs and IRQs.
>
> I fixed channel scanning so multiple ADC channels can be read
> simultaneously and pushed to userspace.
> Restructured the driver to fit IIO ABI.
> And added trigger support.
>
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Russ Dill <Russ.Dill@ti.com>
I'm afraid the tree has moved on a bit so this will need rebasing
against what is currently in iio.git.

Some other bits and bobs inline.

I would like a description in here of what form of buffered sampling the
driver/device provides.  Does it run on it's own internal clock?  E.g.
are we dealing with a fairly autonomous device with a data ready trigger?
Is the driver to always be driven from an external trigger?
This looks like there is no explicit trigger at all (which is an unusual
case).  I vaguely remember discussing this before and concluding it was
probably valid for this device (as it is a hardware fifo pushed into a software
one).  If nothing else generic_buffer.c won't cover this case so might need
appropriately updating with a 'don't bother with an explicit trigger' option.

Having this stuff in the git commit log would be good as well as available
at time of review.  It's also usually best to assume everyone has forgotten
everything about the driver inbetween reviews ;)

Nearly there.

Jonathan

> ---
>  drivers/iio/adc/ti_am335x_adc.c      |  334 +++++++++++++++++++++++++++-------
>  include/linux/mfd/ti_am335x_tscadc.h |   13 +-
>  2 files changed, 285 insertions(+), 62 deletions(-)
>
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 3ceac3e..630ce85 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -26,14 +26,25 @@
>  #include <linux/of_device.h>
>  #include <linux/iio/machine.h>
Err, what is the machine header doing in here?
(clearly my review of the original driver missed a few
things).

>  #include <linux/iio/driver.h>
> -
Cleaner to group the headers appropriately.
>  #include <linux/mfd/ti_am335x_tscadc.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/triggered_buffer.h>
> +#include <linux/wait.h>
> +#include <linux/sched.h>
>
>  struct tiadc_device {
>  	struct ti_tscadc_dev *mfd_tscadc;
>  	int channels;
>  	u8 channel_line[8];
>  	u8 channel_step[8];
> +	struct work_struct poll_work;
> +	wait_queue_head_t wq_data_avail;
> +	bool data_avail;
> +	u32 *inputbuffer;
> +	int sample_count;
> +	int irq;
>  };
>
>  static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
> @@ -56,27 +67,28 @@ static u32 get_adc_step_mask(struct tiadc_device *adc_dev)
>  	return step_en;
>  }
>
> -static void tiadc_step_config(struct tiadc_device *adc_dev)
> +static void tiadc_step_config(struct iio_dev *indio_dev)
>  {
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>  	unsigned int stepconfig;
> -	int i, steps;
> +	int i, steps, chan;
>
>  	/*
>  	 * There are 16 configurable steps and 8 analog input
>  	 * lines available which are shared between Touchscreen and ADC.
> -	 *
>  	 * Steps backwards i.e. from 16 towards 0 are used by ADC
>  	 * depending on number of input lines needed.
>  	 * Channel would represent which analog input
>  	 * needs to be given to ADC to digitalize data.
>  	 */
> -
>  	steps = TOTAL_STEPS - adc_dev->channels;
> -	stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
> +	if (iio_buffer_enabled(indio_dev))
> +		stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1
> +					| STEPCONFIG_MODE_SWCNT;
> +	else
> +		stepconfig = STEPCONFIG_AVG_16 | STEPCONFIG_FIFO1;
>
>  	for (i = 0; i < adc_dev->channels; i++) {
> -		int chan;
> -
>  		chan = adc_dev->channel_line[i];
>  		tiadc_writel(adc_dev, REG_STEPCONFIG(steps),
>  				stepconfig | STEPCONFIG_INP(chan));
> @@ -85,7 +97,190 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>  		adc_dev->channel_step[i] = steps;
>  		steps++;
>  	}
> +}
> +
> +static irqreturn_t tiadc_irq(int irq, void *private)
> +{
> +	struct iio_dev *idev = private;
> +	struct tiadc_device *adc_dev = iio_priv(idev);
> +	unsigned int status, config;
> +	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
> +
> +	/* FIFO Overrun. Clear flag. Disable/Enable ADC to recover */
> +	if (status & IRQENB_FIFO1OVRRUN) {
> +		config = tiadc_readl(adc_dev, REG_CTRL);
> +		config &= ~(CNTRLREG_TSCSSENB);
> +		tiadc_writel(adc_dev, REG_CTRL, config);
> +		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1OVRRUN |
> +				IRQENB_FIFO1UNDRFLW | IRQENB_FIFO1THRES);
> +		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
> +		return IRQ_HANDLED;
> +	} else if (status & IRQENB_FIFO1THRES) {
> +		/* Wake adc_work that pushes FIFO data to iio buffer */
> +		tiadc_writel(adc_dev, REG_IRQCLR, IRQENB_FIFO1THRES);
> +		adc_dev->data_avail = 1;
> +		wake_up_interruptible(&adc_dev->wq_data_avail);
> +		return IRQ_HANDLED;
> +	} else
> +		return IRQ_NONE;
> +}
> +
> +static irqreturn_t tiadc_trigger_h(int irq, void *p)
> +{
> +	struct iio_poll_func *pf = p;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	unsigned int config;
> +
> +	schedule_work(&adc_dev->poll_work);
> +	config = tiadc_readl(adc_dev, REG_CTRL);
> +	tiadc_writel(adc_dev, REG_CTRL,	config & ~CNTRLREG_TSCSSENB);
> +	tiadc_writel(adc_dev, REG_CTRL,	config |  CNTRLREG_TSCSSENB);
> +
> +	tiadc_writel(adc_dev,  REG_IRQSTATUS, IRQENB_FIFO1THRES |
> +			 IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW);
> +	tiadc_writel(adc_dev,  REG_IRQENABLE, IRQENB_FIFO1THRES
> +				| IRQENB_FIFO1OVRRUN);
> +
> +	iio_trigger_notify_done(indio_dev->trig);
> +	return IRQ_HANDLED;
> +}
> +
> +static int tiadc_buffer_preenable(struct iio_dev *indio_dev)
> +{
> +	return iio_sw_buffer_preenable(indio_dev);
> +}
> +
> +static int tiadc_buffer_postenable(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	struct iio_buffer *buffer = indio_dev->buffer;
> +	unsigned int enb, stepnum;
> +	u8 bit;
> +
> +	tiadc_step_config(indio_dev);
> +	tiadc_writel(adc_dev, REG_SE, 0x00);
> +	for_each_set_bit(bit, buffer->scan_mask,
> +			adc_dev->channels) {
> +		struct iio_chan_spec const *chan = indio_dev->channels + bit;
> +		/*
> +		 * There are a total of 16 steps available
> +		 * that are shared between ADC and touchscreen.
> +		 * We start configuring from step 16 to 0 incase of
> +		 * ADC. Hence the relation between input channel
> +		 * and step for ADC would be as below.
> +		 */
> +		stepnum = chan->channel + 9;
> +		enb = tiadc_readl(adc_dev, REG_SE);
> +		enb |= (1 << stepnum);
> +		tiadc_writel(adc_dev, REG_SE, enb);
> +	}
> +
> +	return iio_triggered_buffer_postenable(indio_dev);
> +}
> +
> +static int tiadc_buffer_predisable(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	int fifo1count, i, read, config;
> +
> +	config = tiadc_readl(adc_dev, REG_CTRL);
> +	config &= ~(CNTRLREG_TSCSSENB);
> +	tiadc_writel(adc_dev, REG_CTRL, config);
> +	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
> +				IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW));
> +	tiadc_writel(adc_dev, REG_SE, STPENB_STEPENB_TC);
> +
> +	/* Flush FIFO of any leftover data */
> +	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> +	for (i = 0; i < fifo1count; i++)
> +		read = tiadc_readl(adc_dev, REG_FIFO1);
> +
> +	return iio_triggered_buffer_predisable(indio_dev);
> +}
> +
> +static int tiadc_buffer_postdisable(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	int config;
> +
> +	tiadc_step_config(indio_dev);
> +	config = tiadc_readl(adc_dev, REG_CTRL);
> +	tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
> +
> +	return 0;
> +}
> +
> +static const struct iio_buffer_setup_ops tiadc_buffer_setup_ops = {
> +	.preenable = &tiadc_buffer_preenable,
> +	.postenable = &tiadc_buffer_postenable,
> +	.predisable = &tiadc_buffer_predisable,
> +	.postdisable = &tiadc_buffer_postdisable,
> +};
> +
> +static void tiadc_adc_work(struct work_struct *work_s)
> +{
> +	struct tiadc_device *adc_dev =
> +		container_of(work_s, struct tiadc_device, poll_work);
> +	struct iio_dev *indio_dev = iio_priv_to_dev(adc_dev);
> +	struct iio_buffer *buffer = indio_dev->buffer;
> +	int i, j, k, fifo1count, read;
> +	unsigned int config;
> +	int size_to_acquire = buffer->access->get_length(buffer);
> +	int sample_count = 0;
> +	u32 *data;
> +
> +	adc_dev->data_avail = 0;
> +	data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
> +	if (data == NULL)
> +		goto out;
> +
> +	while (sample_count < size_to_acquire) {
> +		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1THRES);
> +		tiadc_writel(adc_dev, REG_IRQENABLE, IRQENB_FIFO1THRES);
> +
> +		wait_event_interruptible(adc_dev->wq_data_avail,
> +					(adc_dev->data_avail == 1));
> +		adc_dev->data_avail = 0;
> +
> +		fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> +		if (fifo1count * sizeof(u32) <
> +				buffer->access->get_bytes_per_datum(buffer))
> +			continue;
> +
> +		sample_count = sample_count + fifo1count;
> +		for (k = 0; k < fifo1count; k = k + i) {
> +			for (i = 0, j = 0; i < (indio_dev->scan_bytes)/4; i++) {
> +				read = tiadc_readl(adc_dev, REG_FIFO1);
> +				data[i] = read & FIFOREAD_DATA_MASK;
> +			}
> +			iio_push_to_buffers(indio_dev, (u8 *) data);
> +		}
> +	}
> +out:
> +	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
> +				IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW));
> +	config = tiadc_readl(adc_dev, REG_CTRL);
> +	tiadc_writel(adc_dev, REG_CTRL,	config & ~CNTRLREG_TSCSSENB);
> +}
>
> +irqreturn_t tiadc_iio_pollfunc(int irq, void *p)
> +{
> +	struct iio_poll_func *pf = p;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	int i, fifo1count, read;
> +
> +	tiadc_writel(adc_dev, REG_IRQCLR, (IRQENB_FIFO1THRES |
> +				IRQENB_FIFO1OVRRUN |
> +				IRQENB_FIFO1UNDRFLW));
> +
> +	/* Flush FIFO before trigger */
> +	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> +	for (i = 0; i < fifo1count; i++)
> +		read = tiadc_readl(adc_dev, REG_FIFO1);
> +
> +	return IRQ_WAKE_THREAD;
>  }
>
>  static const char * const chan_name_ain[] = {
> @@ -120,13 +315,13 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
>  		chan->channel = adc_dev->channel_line[i];
>  		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
>  		chan->datasheet_name = chan_name_ain[chan->channel];
> +		chan->scan_index = i;
>  		chan->scan_type.sign = 'u';
>  		chan->scan_type.realbits = 12;
>  		chan->scan_type.storagebits = 32;
>  	}
>
>  	indio_dev->channels = chan_array;
> -
>  	return 0;
>  }
>
> @@ -141,58 +336,48 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
>  {
>  	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>  	int i, map_val;
> -	unsigned int fifo1count, read, stepid;
> -	u32 step = UINT_MAX;
> -	bool found = false;
> -	u32 step_en;
> -	unsigned long timeout = jiffies + usecs_to_jiffies
> -				(IDLE_TIMEOUT * adc_dev->channels);
> -	step_en = get_adc_step_mask(adc_dev);
> -	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
> -
> -	/* Wait for ADC sequencer to complete sampling */
> -	while (tiadc_readl(adc_dev, REG_ADCFSM) & SEQ_STATUS) {
> -		if (time_after(jiffies, timeout))
> -			return -EAGAIN;
> -		}
> -	map_val = chan->channel + TOTAL_CHANNELS;
> -
> -	/*
> -	 * When the sub-system is first enabled,
> -	 * the sequencer will always start with the
> -	 * lowest step (1) and continue until step (16).
> -	 * For ex: If we have enabled 4 ADC channels and
> -	 * currently use only 1 out of them, the
> -	 * sequencer still configures all the 4 steps,
> -	 * leading to 3 unwanted data.
> -	 * Hence we need to flush out this data.
> -	 */
> +	unsigned int fifo1count, read, stepid, step_en;
>
> -	for (i = 0; i < ARRAY_SIZE(adc_dev->channel_step); i++) {
> -		if (chan->channel == adc_dev->channel_line[i]) {
> -			step = adc_dev->channel_step[i];
> -			break;
> -		}
> -	}
> -	if (WARN_ON_ONCE(step == UINT_MAX))
> -		return -EINVAL;
> -
> -	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> -	for (i = 0; i < fifo1count; i++) {
> -		read = tiadc_readl(adc_dev, REG_FIFO1);
> -		stepid = read & FIFOREAD_CHNLID_MASK;
> -		stepid = stepid >> 0x10;
> -
> -		if (stepid == map_val) {
> -			read = read & FIFOREAD_DATA_MASK;
> -			found = true;
> -			*val = read;
> +	if (iio_buffer_enabled(indio_dev))
> +		return -EBUSY;
> +	else {
> +		unsigned long timeout = jiffies + usecs_to_jiffies
> +					(IDLE_TIMEOUT * adc_dev->channels);
> +		step_en = get_adc_step_mask(adc_dev);
> +		am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
> +
> +		/* Wait for ADC sequencer to complete sampling */
> +		while (tiadc_readl(adc_dev, REG_ADCFSM) & SEQ_STATUS) {
> +			if (time_after(jiffies, timeout))
> +				return -EAGAIN;
> +			}
> +		map_val = chan->channel + TOTAL_CHANNELS;
> +
> +		/*
> +		 * When the sub-system is first enabled,
> +		 * the sequencer will always start with the
> +		 * lowest step (1) and continue until step (16).
> +		 * For ex: If we have enabled 4 ADC channels and
> +		 * currently use only 1 out of them, the
> +		 * sequencer still configures all the 4 steps,
> +		 * leading to 3 unwanted data.
> +		 * Hence we need to flush out this data.
> +		 */
> +
> +		fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> +		for (i = 0; i < fifo1count; i++) {
> +			read = tiadc_readl(adc_dev, REG_FIFO1);
> +			stepid = read & FIFOREAD_CHNLID_MASK;
> +			stepid = stepid >> 0x10;
> +
> +			if (stepid == map_val) {
> +				read = read & FIFOREAD_DATA_MASK;
> +				*val = read;
> +				return IIO_VAL_INT;
> +			}
>  		}
> +		return -EAGAIN;
>  	}
> -
> -	if (found == false)
> -		return -EBUSY;
> -	return IIO_VAL_INT;
>  }
>
>  static const struct iio_info tiadc_info = {
> @@ -231,18 +416,33 @@ static int tiadc_probe(struct platform_device *pdev)
>  		channels++;
>  	}
>  	adc_dev->channels = channels;
> +	adc_dev->irq = adc_dev->mfd_tscadc->irq;
>
>  	indio_dev->dev.parent = &pdev->dev;
>  	indio_dev->name = dev_name(&pdev->dev);
>  	indio_dev->modes = INDIO_DIRECT_MODE;
>  	indio_dev->info = &tiadc_info;
>
> -	tiadc_step_config(adc_dev);
> +	tiadc_step_config(indio_dev);
> +	tiadc_writel(adc_dev, REG_FIFO1THR, FIFO1_THRESHOLD);
>
>  	err = tiadc_channel_init(indio_dev, adc_dev->channels);
>  	if (err < 0)
>  		goto err_free_device;
>
> +	INIT_WORK(&adc_dev->poll_work, &tiadc_adc_work);
> +	init_waitqueue_head(&adc_dev->wq_data_avail);
> +
> +	err = request_irq(adc_dev->irq, tiadc_irq, IRQF_SHARED,
> +		indio_dev->name, indio_dev);
> +	if (err)
> +		goto err_free_irq;
> +
> +	err = iio_triggered_buffer_setup(indio_dev, &tiadc_iio_pollfunc,
> +			&tiadc_trigger_h, &tiadc_buffer_setup_ops);
> +	if (err)
> +		goto err_unregister;
> +
>  	err = iio_device_register(indio_dev);
>  	if (err)
>  		goto err_free_channels;
> @@ -251,6 +451,10 @@ static int tiadc_probe(struct platform_device *pdev)
>
>  	return 0;
>
The error handling in this function is thoroughly scrambled up. Please review
it and fix it.

> +err_unregister:
This label is too generic to make for easy review.
> +	iio_buffer_unregister(indio_dev);
> +err_free_irq:
> +	free_irq(adc_dev->irq, indio_dev);
>  err_free_channels:
>  	tiadc_channels_remove(indio_dev);
>  err_free_device:
> @@ -265,7 +469,9 @@ static int tiadc_remove(struct platform_device *pdev)
>  	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>  	u32 step_en;
>
> +	free_irq(adc_dev->irq, indio_dev);
>  	iio_device_unregister(indio_dev);
> +	iio_buffer_unregister(indio_dev);
>  	tiadc_channels_remove(indio_dev);
>
>  	step_en = get_adc_step_mask(adc_dev);
> @@ -303,10 +509,16 @@ static int tiadc_resume(struct device *dev)
>
>  	/* Make sure ADC is powered up */
>  	restore = tiadc_readl(adc_dev, REG_CTRL);
> -	restore &= ~(CNTRLREG_POWERDOWN);
> +	restore &= ~(CNTRLREG_TSCSSENB);
>  	tiadc_writel(adc_dev, REG_CTRL, restore);
>
> -	tiadc_step_config(adc_dev);
> +	tiadc_writel(adc_dev, REG_FIFO1THR, FIFO1_THRESHOLD);
> +	tiadc_step_config(indio_dev);
> +
> +	/* Make sure ADC is powered up */
> +	restore &= ~(CNTRLREG_POWERDOWN);
> +	restore |= CNTRLREG_TSCSSENB;
> +	tiadc_writel(adc_dev, REG_CTRL, restore);
>
>  	return 0;
>  }
> diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> index db1791b..cb61027 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h

Clearly you are working in keeping with the current driver
but these defines could really do with appropriate prefixes
to make them more specific to the driver.  You are almost
certain that one of these will turn up in a general header
at some point.

> @@ -46,17 +46,23 @@
>  /* Step Enable */
>  #define STEPENB_MASK		(0x1FFFF << 0)
>  #define STEPENB(val)		((val) << 0)
> +#define ENB(val)			(1 << (val))
> +#define STPENB_STEPENB		STEPENB(0x1FFFF)
> +#define STPENB_STEPENB_TC	STEPENB(0x1FFF)
>
>  /* IRQ enable */
>  #define IRQENB_HW_PEN		BIT(0)
>  #define IRQENB_FIFO0THRES	BIT(2)
>  #define IRQENB_FIFO1THRES	BIT(5)
>  #define IRQENB_PENUP		BIT(9)
> +#define IRQENB_FIFO1OVRRUN	BIT(6)
> +#define IRQENB_FIFO1UNDRFLW	BIT(7)
>
>  /* Step Configuration */
>  #define STEPCONFIG_MODE_MASK	(3 << 0)
>  #define STEPCONFIG_MODE(val)	((val) << 0)
>  #define STEPCONFIG_MODE_HWSYNC	STEPCONFIG_MODE(2)
> +#define STEPCONFIG_MODE_SWCNT	STEPCONFIG_MODE(1)
>  #define STEPCONFIG_AVG_MASK	(7 << 2)
>  #define STEPCONFIG_AVG(val)	((val) << 2)
>  #define STEPCONFIG_AVG_16	STEPCONFIG_AVG(4)
> @@ -124,7 +130,8 @@
>  #define	MAX_CLK_DIV		7
>  #define TOTAL_STEPS		16
>  #define TOTAL_CHANNELS		8
> -
> +#define FIFO1_THRESHOLD		19
> +#define FIFO_SIZE			64
>  /*
>  * ADC runs at 3MHz, and it takes
>  * 15 cycles to latch one data output.
> @@ -153,6 +160,10 @@ struct ti_tscadc_dev {
>
>  	/* adc device */
>  	struct adc_device *adc;
> +
> +	/* Context save */
> +	unsigned int irqstat;
> +	unsigned int ctrl;
>  };
>
>  static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)
>
