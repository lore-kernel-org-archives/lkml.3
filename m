Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3IKMDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:03:40 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:53678 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3IKMDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:03:38 -0400
Date: Wed, 11 Sep 2013 21:02:57 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, dmitry.torokhov@gmail.com,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130911160255.GA9339@gmail.com>
References: <1378034277-26728-1-git-send-email-zubair.lutfullah@gmail.com>
 <1378034277-26728-3-git-send-email-zubair.lutfullah@gmail.com>
 <522C7EDB.7090306@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522C7EDB.7090306@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 02:42:51PM +0100, Jonathan Cameron wrote:
> On 09/01/13 12:17, Zubair Lutfullah wrote:

Thanks for the review. Fitting this driver in the usual trigger ABI
is a bad workaround indeed.

I am still a bit unclear regarding the implementation.
Questions and replies inline.

I hope I find the time to pursue the approach you suggest.

Thanks
ZubairLK


> >  #include <linux/of.h>
> Ouch, how did that slip in here.  Dropping this should have been
> in a separate patch as it doesn't really have anything to do with
> the rest of this series.
> 
> > -#include <linux/iio/machine.h>

Squashed it in.. I'll do a cleanup patch separately.

> >  #include <linux/iio/driver.h>
> > +static void tiadc_step_config(struct iio_dev *indio_dev)
> > +{
> > +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> >  	unsigned int stepconfig;
> > -	int i, steps;
> > +	int i, steps, chan;
> Whilst I agree that pulling chan up here is slightly cleaner, technically that
> is a bit of unconnected cleanup and should have been in a precursor patch.
> (though don't bother doing so now!)

Again. Squashed in..

> > +
> > +static irqreturn_t tiadc_irq(int irq, void *private)
> > +{
...
> > +		return IRQ_HANDLED;
> > +	} else if (status & IRQENB_FIFO1THRES) {
> > +		/* Trigger to push FIFO data to iio buffer */
> > +		tiadc_writel(adc_dev, REG_IRQCLR, IRQENB_FIFO1THRES);
> 
> So this is triggering at the threshold.  Thus it isn't acting as a conventional
> trigger in the IIO sense at all.  It is of no real use to anything outside
> this driver, so at the very least add the two callbacks to prevent this
> driver using any other trigger and the trigger being used by any other device.
> However, I'm really not happy with this solution.
> 
> Take a look at running with no trigger at all and calling the buffer
> filling more directly.  The issue is that if we have a trigger now it will
> become part of the userspace interface and become a pain to drop later.
> 
> It is valid here I think to use the INDIO_BUFFER_HARDWARE mode (which skips
> the checks for a trigger) then just don't call iio_triggered_buffer_post_enable
> or iio_triggered_buffer_predisable.  Then make this a threaded interrupt and
> put your tiadc_trigger_h as the thread.  Finally just return IRQ_WAKE_THREAD
> in this case.  You'll have to pull a few bits out of
> industrialio-triggered-buffer.c to create the kfifo etc, but no more than
> a few lines given the pollfunc won't exist.

If I understand correctly.
buffer setup ops for postenable and predisable have 

return iio_triggered_buffer_*(indio_dev)

calls at the end. I return 0 instead.

Insead of iio_triggered_buffer setup. I only use iio_kfifo_alloc
(what size fifo is made? :s )
And do 

indio_dev->modes |= INDIO_BUFFER_HARDWARE;

Then I use request_threaded_irq(*). The hardware IRQ line for the fifos
So the HW irq handler runs in interrupt context which wakes the threaded handler
which pushes samples to the iio buffer.

Shared IRQ line. ADC uses request_threaded_irq(). TSC uses request_irq()
ADC returns IRQ_WAKE_THREAD. But the TSC side returns NONE/HANDLED.
Does this change to a threaded irq affect the TSC side of things?
I just received an ack by Dmitry for that patch..

> 
> Actually, might be cleaner to move the flush case into the thread as well
> and just have a single check in this top half of the handler. That bit
> is up to you given it is really a question of how long it take and hence
> if it is acceptable in interrupt context.

Sorry. I don't understand this paragraph.. Could you please elaborate?
The flushing fifo before/after enabling/disabling the buffer part? 
I explained the reason behind the flushes

> 
> > +		iio_trigger_poll(indio_dev->trig, iio_get_time_ns());
> > +		return IRQ_HANDLED;
> > +	} else
> > +		return IRQ_NONE;
> > +
> > +}
> > +
> > +static irqreturn_t tiadc_trigger_h(int irq, void *p)
> > +{
...
> 
> > +	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> > +	for (k = 0; k < fifo1count; k = k + i) {
> As mentioned below, why not use 16 bit storage in the kfifo?

32 bit storage is because the FIFO is 32 bit in hardware.
It returns 12 bits data. some reserve bits. And 4 bit channel id.
The channel id is used to separate which channel data which.
Need the full 32 bits..

I've added a comment. Not here. but when the storage_bits = 32 is 
set.

...
> > +static int tiadc_buffer_preenable(struct iio_dev *indio_dev)
...
> Why would there be data in the fifo?  Seems to me that flushing
> after disabling it and before enabling it should not both be
> necessary? Is this just a case of playing safe?
> 
> > +	/* Flush FIFO before starting sampling */
> > +	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
> > +	for (i = 0; i < fifo1count; i++)
> > +		read = tiadc_readl(adc_dev, REG_FIFO1);

Pre-flush was needed because TSC events would cause some
redundant ADC samples in the FIFO. Fixes have been sent to input.
Shouldn't happen now.

Post-flush is playing safe. There 'might' be a chance that 
another sample comes in the time it takes for fifocount to be read
And that number of samples read from fifo. and then adc disabled.

> > +static int tiadc_buffer_postdisable(struct iio_dev *indio_dev)
> > +{
> > +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> > +
> > +	tiadc_step_config(indio_dev);
> > +	kfree(adc_dev->data);
> blank line here please.

ok

> > +	return 0;
> > +}
> > +
> > +static const struct iio_buffer_setup_ops tiadc_buffer_setup_ops = {
> > +	.preenable = &tiadc_buffer_preenable,
> > +	.postenable = &tiadc_buffer_postenable,
> > +	.predisable = &tiadc_buffer_predisable,
> > +	.postdisable = &tiadc_buffer_postdisable,
> > +};
> > +
> > +static const struct iio_trigger_ops tiadc_trigger_ops = {
> > +	.owner = THIS_MODULE,
> > +};
> > +
> 
> If you want a utility function for allocation, convention would
> say have one for freeing as well so that the code is obviously
> balanced and easy to check.  Also this registers the buffer as
> well so the name should probably reflect that.
> 

Noted.

> > +static int tiadc_iio_allocate_trigger(struct iio_dev *indio_dev)
> > +{
> > +	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> > +	struct iio_trigger *trig = adc_dev->trig;
> > +	int ret;
> > +
> devm_iio_trigger_alloc is now available and will simplify things a little.
> 

Trigger related stuff is redundant anyways as moving away from trigger..

> > +	trig = iio_trigger_alloc("%s-dev%d", indio_dev->name, indio_dev->id);

> > @@ -120,6 +295,7 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
> >  		chan->scan_type.realbits = 12;
> >  		chan->scan_type.storagebits = 32;
> I never noticed this before but putting 12 bit values in 32 bit storage
> does seem rather wasteful.  Far as I can see above there is no real
> reason for doing so.  If there is, then please add a comment justifying this
> choice!
>

Answered earlier. I added a comment here explaining. 

> > @@ -142,11 +318,14 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
...
> >  	 * Hence we need to flush out this data.
> >  	 */
> Is the comment above still valid?  I'd guess it referred to this code
> which has now gone.
> >

Its valid when the comment is read completely. All ADC channels
are sampled even if only one is read. The one needed is returned
to userspace. The rest of the fifo is flushed. 

Not the ideal way. But I'm focusing on continuous sampling mode at the moment

> >  	adc_dev->channels = channels;
> 
> Use the devm interfaces and there is no need to keep a copy
> of the irq number about.
>

Noted. 
...

> >
> devm_request_irq will simplify error handling a little.
> 

Indeed error handling gets confusing. I'll update.
...

> > +	iio_trigger_free(adc_dev->trig);
> There is a devm trigger allocation function now. Using that
> would make things a little cleaner.

Noted

> 
> > +	free_irq(adc_dev->irq, indio_dev);
> Best to use the devm interfaces for irq handling unless
> there is a good reason to not do so (cleaner code ;)
> 
> >  	iio_device_unregister(indio_dev);
> 

Noted.

> We would normally expect this function to run in exact
> reverse order of the probe.  That is not the case here
> so please reorder things so it is.
> > +	iio_buffer_unregister(indio_dev);

I'll look into it.

> >  	tiadc_channels_remove(indio_dev);
> >
> >  	step_en = get_adc_step_mask(adc_dev);
> > @@ -298,10 +495,16 @@ static int tiadc_resume(struct device *dev)
> >
> >  	/* Make sure ADC is powered up */
> This comment doesn't seem to me to be true any more.
> >  	restore = tiadc_readl(adc_dev, REG_CTRL);
> > -	restore &= ~(CNTRLREG_POWERDOWN);
> Some coments here would be good to explain the sequence that
> is going on.
> 
> I'm guessing a bit, but looks like you turn off the touch screen
> but leave everything else alone, then set the threshold then
> reenable the touch screen before powering up the screen?
> 

To be honest. I don't even remember. 
It might have been a patch I squashed in.
does not seem to be related to the continuous sampling I guess..
I should remove this and send it separately.

> > +	restore &= ~(CNTRLREG_TSCSSENB);
...
> >  	tiadc_writel(adc_dev, REG_CTRL, restore);
> >  	return 0;
> >  }
> > diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
> > index db1791b..a372ebf 100644
> > --- a/include/linux/mfd/ti_am335x_tscadc.h
> > +++ b/include/linux/mfd/ti_am335x_tscadc.h
> > @@ -46,17 +46,25 @@
> >  	/* adc device */
> >  	struct adc_device *adc;
> > +
> > +	/* Context save */
> > +	unsigned int irqstat;
> Where are these used?
> > +	unsigned int ctrl;
> >  };
Oops. Don't think they are used anywhere.
Thanks for pointing it out.
> >
> >  static inline struct ti_tscadc_dev *ti_tscadc_dev_get(struct platform_device *p)
> >

Thanks
ZubairLK
