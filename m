Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3HQI6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 04:58:34 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45790 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3HQI6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 04:58:31 -0400
Date: Sat, 17 Aug 2013 09:58:25 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130817085824.GA5090@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
 <520CBEC6.8010400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520CBEC6.8010400@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 12:43:02PM +0100, Jonathan Cameron wrote:
> Note I'd also like a much more detailed description in the patch header.
> 
> I would also expect an option for the trigger to be supplied from the
> chip itself based on fifo watershead interrupts.  Thus the adc could be
> operated at full rate without losing data.  As you described in a previous
> email this is much more similar to a one shot osciloscope trigger where it
> grabs the next set of readings.  Now this is an interesting option, but
> it isn't the standard one for IIO.  I'd be interested to see a proposal
> for adding this functionality to the core in a more general fashion.

When I read trigger, this functionality is what comes to my mind.
Not the single scan current implementation in IIO. My background I guess.

Adding this feature to the core feels a bit above my level at the moment.
I'd like to get this driver sorted first.
> 
> For now I'd be much happier if this driver conformed to more or less the
> standard form with the one exception being that the 'trigger' is based on
> the fifo threshold and so it might appear to grab multiple scans of the
> enabled channels for each trigger (which is fine). Even if we provide the
> functionality sketched out above, it would still be as core functionality, not
> in the driver as you have done here.
> 
> Jonathan

Will that affect the way generic_buffer.c will read from the driver?

Rest comments below.

> > diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> > +	/* FIFO Overrun. Clear flag. Disable/Enable ADC to recover */
> > +	if (status & IRQENB_FIFO1OVRRUN) {
> > +		config = tiadc_readl(adc_dev, REG_CTRL);
> > +		config &= ~(CNTRLREG_TSCSSENB);
> > +		tiadc_writel(adc_dev, REG_CTRL, config);
> > +		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1OVRRUN |
> > +				IRQENB_FIFO1UNDRFLW | IRQENB_FIFO1THRES);
> > +		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
> > +	} else if (status & IRQENB_FIFO1THRES) {
> 
> I'd normally expect this interrupt to drive a trigger that in turn results in
> the data being dumped into the software buffers.
> 
The work handler is sort of providing similar functionality..
But, I guess using the trigger ABI is more efficient.
> > +
> > +	tiadc_writel(adc_dev,  REG_IRQSTATUS, IRQENB_FIFO1THRES |
> > +			 IRQENB_FIFO1OVRRUN | IRQENB_FIFO1UNDRFLW);
> > +	tiadc_writel(adc_dev,  REG_IRQENABLE, IRQENB_FIFO1THRES
> > +				| IRQENB_FIFO1OVRRUN);
> > +
> > +	iio_trigger_notify_done(indio_dev->trig);
> Are you actually done?  What happens if another trigger turns up in the
> meantime?  I'd expect this to occur only after the results of the trigger
> have been handled.

Indeed Done is passed immediately while ADC is still sampling.
Because of the way the trigger was used and structure of the driver.

> > +static int tiadc_buffer_preenable(struct iio_dev *indio_dev)
> > +{
> Don't have pointless wrappers like this.

Noted
> > +	return iio_sw_buffer_preenable(indio_dev);
> > +}
> > +
> > +static void tiadc_adc_work(struct work_struct *work_s)
> > +{
> > +	struct tiadc_device *adc_dev =
> > +		container_of(work_s, struct tiadc_device, poll_work);
> > +	struct iio_dev *indio_dev = iio_priv_to_dev(adc_dev);
> > +	struct iio_buffer *buffer = indio_dev->buffer;
> > +	int i, j, k, fifo1count, read;
> > +	unsigned int config;
> So normally we'd just fill with one sample hence for this case
> I'd expect to push out whatever samples are in the fifo right now
> then return.  The next trigger would grab the next lot etc.
>
Again. If I understand correctly, 

I restructure the driver so that
enabling the buffer via userspace starts sampling the ADC channels.
Preenable/postenable do all that hard work.

I need to use iio_trigger_register to create an IIO trigger inside the
driver.

The IRQ handler for FIFO Threshold causes a trigger event.

The trigger handler pushes the entire fifo to userspace.

I'd like a small ACK before I get to work.
Just to make sure I got things correctly.

Thanks for the input
Zubair
