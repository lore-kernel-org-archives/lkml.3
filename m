Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab3IHMmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 08:42:47 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37443 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3IHMmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 08:42:44 -0400
Message-ID: <522C7EDB.7090306@kernel.org>
Date: Sun, 08 Sep 2013 14:42:51 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
References: <1378034277-26728-1-git-send-email-zubair.lutfullah@gmail.com> <1378034277-26728-3-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1378034277-26728-3-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/13 12:17, Zubair Lutfullah wrote:
> Previously the driver had only one-shot reading functionality.
> This patch adds triggered buffer support to the driver.
>
> Continuous sampling starts when buffer is enabled.
> And samples are pushed to userpace by the trigger which
> triggers automatically at every hardware interrupt
> of FIFO1 filling with samples upto threshold value.
>
> Userspace responsibility to stop sampling by writing zero
> in the buffer enable file.
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
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Hi

I'm afraid I'm still unconvinced that we can use the trigger infrastructure
as done here.  This trigger from a fifo threshold does not agree with how it
happens in any other driver. Unfortunately as the first hardware buffered
device we have had in recent times (there is the sca3000 in staging, but that
does not have a front end kfifo) you get to break some new ground.

I've suggested below how I would handle this.  In short, drop the trigger
and drive the buffers directly, marking the mode as INDIO_BUFFER_HARDWARE to
avoid the core code complaining at the lack of trigger.  It will end up simpler
and not expose a trigger to userspace that is doing 'interesting' things.
This is the only way I can envision a hardware buffer equiped device like this
working.  It's certainly what I've been intending to do with the sca3000
driver when I finally get around to bringing it up to date. I don't think
we can take the current approach because it would give us horribly inconsistent
userspace interfaces we can't maintain in the long run.

Few other little bits and bobs inline to do with unused variables and
a few places where a small comment or two might make the operation easier
to follow when we have all forgotten how the hardware works ;)

Jonathan

> ---
>  drivers/iio/adc/Kconfig              |    1 +
>  drivers/iio/adc/ti_am335x_adc.c      |  243 +++++++++++++++++++++++++++++++---
>  include/linux/mfd/ti_am335x_tscadc.h |   13 ++
>  3 files changed, 237 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 09371cb..cfa2039 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -167,6 +167,7 @@ config TI_ADC081C
>  config TI_AM335X_ADC
>  	tristate "TI's AM335X ADC driver"
>  	depends on MFD_TI_AM335X_TSCADC
> +	select IIO_TRIGGERED_BUFFER
>  	help
>  	  Say yes here to build support for Texas Instruments ADC
>  	  driver which is also a MFD client.
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index a952538..1626e16 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -24,16 +24,23 @@
>  #include <linux/iio/iio.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
Ouch, how did that slip in here.  Dropping this should have been
in a separate patch as it doesn't really have anything to do with
the rest of this series.

> -#include <linux/iio/machine.h>
>  #include <linux/iio/driver.h>
>
>  #include <linux/mfd/ti_am335x_tscadc.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/triggered_buffer.h>
>
>  struct tiadc_device {
>  	struct ti_tscadc_dev *mfd_tscadc;
>  	int channels;
>  	u8 channel_line[8];
>  	u8 channel_step[8];
> +	int irq;
> +	int buffer_en_ch_steps;
> +	struct iio_trigger *trig;
> +	u32 *data;
>  };
>
>  static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
> @@ -56,10 +63,16 @@ static u32 get_adc_step_mask(struct tiadc_device *adc_dev)
>  	return step_en;
>  }
>
> -static void tiadc_step_config(struct tiadc_device *adc_dev)
> +static u32 get_adc_step_bit(struct tiadc_device *adc_dev, int chan)
>  {
> +	return 1 << adc_dev->channel_step[chan];
> +}
> +
> +static void tiadc_step_config(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>  	unsigned int stepconfig;
> -	int i, steps;
> +	int i, steps, chan;
Whilst I agree that pulling chan up here is slightly cleaner, technically that
is a bit of unconnected cleanup and should have been in a precursor patch.
(though don't bother doing so now!)
>
>  	/*
>  	 * There are 16 configurable steps and 8 analog input
> @@ -72,11 +85,13 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>  	 */
>
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
> @@ -85,7 +100,167 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>  		adc_dev->channel_step[i] = steps;
>  		steps++;
>  	}
> +}
> +
> +static irqreturn_t tiadc_irq(int irq, void *private)
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
> +		/* Trigger to push FIFO data to iio buffer */
> +		tiadc_writel(adc_dev, REG_IRQCLR, IRQENB_FIFO1THRES);

So this is triggering at the threshold.  Thus it isn't acting as a conventional
trigger in the IIO sense at all.  It is of no real use to anything outside
this driver, so at the very least add the two callbacks to prevent this
driver using any other trigger and the trigger being used by any other device.
However, I'm really not happy with this solution.

Take a look at running with no trigger at all and calling the buffer
filling more directly.  The issue is that if we have a trigger now it will
become part of the userspace interface and become a pain to drop later.

It is valid here I think to use the INDIO_BUFFER_HARDWARE mode (which skips
the checks for a trigger) then just don't call iio_triggered_buffer_post_enable
or iio_triggered_buffer_predisable.  Then make this a threaded interrupt and
put your tiadc_trigger_h as the thread.  Finally just return IRQ_WAKE_THREAD
in this case.  You'll have to pull a few bits out of
industrialio-triggered-buffer.c to create the kfifo etc, but no more than
a few lines given the pollfunc won't exist.

Actually, might be cleaner to move the flush case into the thread as well
and just have a single check in this top half of the handler. That bit
is up to you given it is really a question of how long it take and hence
if it is acceptable in interrupt context.

> +		iio_trigger_poll(indio_dev->trig, iio_get_time_ns());
> +		return IRQ_HANDLED;
> +	} else
> +		return IRQ_NONE;
> +
> +}
> +
> +static irqreturn_t tiadc_trigger_h(int irq, void *p)
> +{
> +	struct iio_poll_func *pf = p;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	int i, k, fifo1count, read;
> +	u32 *data = adc_dev->data;
> +

Hmm.. This results in all data in the fifo being read from a single
trigger.  I think I would still be happier if in the case of hardware
buffers like this we didn't use a visible trigger at all.  Such
a trigger has a somewhat fuzzy meaning to say the least.

> +	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> +	for (k = 0; k < fifo1count; k = k + i) {
As mentioned below, why not use 16 bit storage in the kfifo?
> +		for (i = 0; i < (indio_dev->scan_bytes)/4; i++) {
> +			read = tiadc_readl(adc_dev, REG_FIFO1);
> +			data[i] = read & FIFOREAD_DATA_MASK;
> +		}
> +		iio_push_to_buffers(indio_dev, (u8 *) data);
> +	}
>
> +	tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1THRES);
> +	tiadc_writel(adc_dev, REG_IRQENABLE, IRQENB_FIFO1THRES);
> +
> +	iio_trigger_notify_done(indio_dev->trig);
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

Why would there be data in the fifo?  Seems to me that flushing
after disabling it and before enabling it should not both be
necessary? Is this just a case of playing safe?

> +	/* Flush FIFO before starting sampling */
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
> +	return iio_triggered_buffer_postenable(indio_dev);
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
> +
> +	tiadc_step_config(indio_dev);
> +	kfree(adc_dev->data);
blank line here please.

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
> +static const struct iio_trigger_ops tiadc_trigger_ops = {
> +	.owner = THIS_MODULE,
> +};
> +

If you want a utility function for allocation, convention would
say have one for freeing as well so that the code is obviously
balanced and easy to check.  Also this registers the buffer as
well so the name should probably reflect that.

> +static int tiadc_iio_allocate_trigger(struct iio_dev *indio_dev)
> +{
> +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> +	struct iio_trigger *trig = adc_dev->trig;
> +	int ret;
> +
devm_iio_trigger_alloc is now available and will simplify things a little.

> +	trig = iio_trigger_alloc("%s-dev%d", indio_dev->name, indio_dev->id);
> +	if (trig == NULL)
> +		return -ENOMEM;
> +
> +	trig->dev.parent = indio_dev->dev.parent;
> +	trig->ops = &tiadc_trigger_ops;
> +	iio_trigger_set_drvdata(trig, indio_dev);
> +
> +	ret = iio_trigger_register(trig);
> +	if (ret)
> +		goto err_free_trigger;
> +
> +	return 0;
> +
> +err_free_trigger:
> +	iio_trigger_free(adc_dev->trig);
> +
> +	return ret;
>  }
>
>  static const char * const chan_name_ain[] = {
> @@ -120,6 +295,7 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
>  		chan->channel = adc_dev->channel_line[i];
>  		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
>  		chan->datasheet_name = chan_name_ain[chan->channel];
> +		chan->scan_index = i;
>  		chan->scan_type.sign = 'u';
>  		chan->scan_type.realbits = 12;
>  		chan->scan_type.storagebits = 32;
I never noticed this before but putting 12 bit values in 32 bit storage
does seem rather wasteful.  Far as I can see above there is no real
reason for doing so.  If there is, then please add a comment justifying this
choice!

> @@ -142,11 +318,14 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
>  	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>  	int i, map_val;
>  	unsigned int fifo1count, read, stepid;
> -	u32 step = UINT_MAX;
>  	bool found = false;
>  	u32 step_en;
>  	unsigned long timeout = jiffies + usecs_to_jiffies
>  				(IDLE_TIMEOUT * adc_dev->channels);
> +
> +	if (iio_buffer_enabled(indio_dev))
> +		return -EBUSY;
> +
>  	step_en = get_adc_step_mask(adc_dev);
>  	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
>
> @@ -168,15 +347,6 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
>  	 * Hence we need to flush out this data.
>  	 */
Is the comment above still valid?  I'd guess it referred to this code
which has now gone.
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
>  	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
>  	for (i = 0; i < fifo1count; i++) {
>  		read = tiadc_readl(adc_dev, REG_FIFO1);
> @@ -231,26 +401,49 @@ static int tiadc_probe(struct platform_device *pdev)
>  		channels++;
>  	}
>  	adc_dev->channels = channels;

Use the devm interfaces and there is no need to keep a copy
of the irq number about.

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
>  		return err;
>
> -	err = iio_device_register(indio_dev);
> +	err = tiadc_iio_allocate_trigger(indio_dev);
>  	if (err)
>  		goto err_free_channels;
>
devm_request_irq will simplify error handling a little.

> +	err = request_irq(adc_dev->irq, tiadc_irq, IRQF_SHARED,
> +		indio_dev->name, indio_dev);
> +	if (err)
> +		goto err_unregister_trigger;
> +
> +	err = iio_triggered_buffer_setup(indio_dev, NULL,
> +			&tiadc_trigger_h, &tiadc_buffer_setup_ops);
> +	if (err)
> +		goto err_free_irq;
> +
> +	err = iio_device_register(indio_dev);
> +	if (err)
> +		goto err_buffer_unregister;
> +
>  	platform_set_drvdata(pdev, indio_dev);
>
>  	return 0;
>
> +err_buffer_unregister:
> +	iio_buffer_unregister(indio_dev);
> +err_free_irq:
> +	free_irq(adc_dev->irq, indio_dev);
> +err_unregister_trigger:
> +	iio_trigger_unregister(adc_dev->trig);
> +	iio_trigger_free(adc_dev->trig);
>  err_free_channels:
>  	tiadc_channels_remove(indio_dev);
>  	return err;
> @@ -262,7 +455,11 @@ static int tiadc_remove(struct platform_device *pdev)
>  	struct tiadc_device *adc_dev = iio_priv(indio_dev);
>  	u32 step_en;
>
> +	iio_trigger_unregister(adc_dev->trig);
> +	iio_trigger_free(adc_dev->trig);
There is a devm trigger allocation function now. Using that
would make things a little cleaner.

> +	free_irq(adc_dev->irq, indio_dev);
Best to use the devm interfaces for irq handling unless
there is a good reason to not do so (cleaner code ;)

>  	iio_device_unregister(indio_dev);

We would normally expect this function to run in exact
reverse order of the probe.  That is not the case here
so please reorder things so it is.
> +	iio_buffer_unregister(indio_dev);
>  	tiadc_channels_remove(indio_dev);
>
>  	step_en = get_adc_step_mask(adc_dev);
> @@ -298,10 +495,16 @@ static int tiadc_resume(struct device *dev)
>
>  	/* Make sure ADC is powered up */
This comment doesn't seem to me to be true any more.
>  	restore = tiadc_readl(adc_dev, REG_CTRL);
> -	restore &= ~(CNTRLREG_POWERDOWN);
Some coments here would be good to explain the sequence that
is going on.

I'm guessing a bit, but looks like you turn off the touch screen
but leave everything else alone, then set the threshold then
reenable the touch screen before powering up the screen?

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
> index db1791b..a372ebf 100644
> --- a/include/linux/mfd/ti_am335x_tscadc.h
> +++ b/include/linux/mfd/ti_am335x_tscadc.h
> @@ -46,17 +46,25 @@
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
> +#define IRQENB_FIFO0OVRRUN	BIT(3)
> +#define IRQENB_FIFO0UNDRFLW	BIT(4)
>  #define IRQENB_FIFO1THRES	BIT(5)
> +#define IRQENB_FIFO1OVRRUN	BIT(6)
> +#define IRQENB_FIFO1UNDRFLW	BIT(7)
>  #define IRQENB_PENUP		BIT(9)
>
>  /* Step Configuration */
>  #define STEPCONFIG_MODE_MASK	(3 << 0)
>  #define STEPCONFIG_MODE(val)	((val) << 0)
>  #define STEPCONFIG_MODE_HWSYNC	STEPCONFIG_MODE(2)
> +#define STEPCONFIG_MODE_SWCNT	STEPCONFIG_MODE(1)
>  #define STEPCONFIG_AVG_MASK	(7 << 2)
>  #define STEPCONFIG_AVG(val)	((val) << 2)
>  #define STEPCONFIG_AVG_16	STEPCONFIG_AVG(4)
> @@ -124,6 +132,7 @@
>  #define	MAX_CLK_DIV		7
>  #define TOTAL_STEPS		16
>  #define TOTAL_CHANNELS		8
> +#define FIFO1_THRESHOLD		19
>
>  /*
>  * ADC runs at 3MHz, and it takes
> @@ -153,6 +162,10 @@ struct ti_tscadc_dev {
>
>  	/* adc device */
>  	struct adc_device *adc;
> +
> +	/* Context save */
> +	unsigned int irqstat;
Where are these used?
> +	unsigned int ctrl;
>  };
>
>  static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)
>
