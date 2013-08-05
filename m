Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3HERCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:02:10 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39465 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3HERCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:02:08 -0400
Date: Mon, 5 Aug 2013 18:02:02 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com
Subject: Re: [PATCH 1/2] input: ti_tsc: Enable shared IRQ for TSC
Message-ID: <20130805170201.GA4310@gmail.com>
References: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374882674-18403-2-git-send-email-zubair.lutfullah@gmail.com>
 <51FE361B.5030900@kernel.org>
 <20130805161256.GA8794@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805161256.GA8794@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 09:12:56AM -0700, Dmitry Torokhov wrote:
> > > Touchscreen and ADC share the same IRQ line from parent MFD core.
> > > Previously only Touchscreen was interrupt based.
> > > With continuous mode support added in ADC driver, driver requires
> > > interrupt to process the ADC samples, so enable shared IRQ flag bit for
> > > touchscreen.
> > > 
> > > @@ -260,8 +260,18 @@ static irqreturn_t titsc_irq(int irq, void *dev)
> > >  	unsigned int fsm;
> > >  
> > > +	/*
> > > +	 * ADC and touchscreen share the IRQ line.
> > > +	 * FIFO1 threshold, FIFO1 Overrun and FIFO1 underflow
> > > +	 * interrupts are used by ADC,
> > > +	 * hence return from touchscreen IRQ handler if FIFO1
> > > +	 * related interrupts occurred.
> > > +	 */
> > > +	if ((status & IRQENB_FIFO1THRES) ||
> > > +			(status & IRQENB_FIFO1OVRRUN) ||
> > > +			(status & IRQENB_FIFO1UNDRFLW))
> > > +		return IRQ_NONE;
> > > +	else if (status & IRQENB_FIFO0THRES) {
> 
> What happens if both parts have data at the same time? Can both
> IRQENB_FIFO1THRES and IRQENB_FIFO0THRES be signalled? What will happen
> in this case?

If ADC is sampling and someone is touching the TSC, both interrupts
can signal so closely that for the purpose of the kernel,
they can be seen as signaled together.

FIFO 1 used only by ADC and FIFO1THRES handler is inside the iio/adc driver
FIFO 0 used only by TSC and FIFO0THRES handler is inside the input/touchscreen

Note: These are level interrupts.

I would like some input on how to handle such a situation. 

Thanks
Zubair Lutfullah
