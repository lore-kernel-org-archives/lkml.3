Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3HEQNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:13:04 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53434 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3HEQNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:13:00 -0400
Date: Mon, 5 Aug 2013 09:12:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com
Subject: Re: [PATCH 1/2] input: ti_tsc: Enable shared IRQ for TSC
Message-ID: <20130805161256.GA8794@core.coreip.homeip.net>
References: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374882674-18403-2-git-send-email-zubair.lutfullah@gmail.com>
 <51FE361B.5030900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FE361B.5030900@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 12:08:11PM +0100, Jonathan Cameron wrote:
> On 07/27/13 00:51, Zubair Lutfullah wrote:
> > From: "Patil, Rachna" <rachna@ti.com>
> > 
> > Touchscreen and ADC share the same IRQ line from parent MFD core.
> > Previously only Touchscreen was interrupt based.
> > With continuous mode support added in ADC driver, driver requires
> > interrupt to process the ADC samples, so enable shared IRQ flag bit for
> > touchscreen.
> > 
> > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> I'd rather this went via input independent of the other patch
> (if not there all that will happen is one or other driver will
> fail to probe if both are attempted?)
> 
> Can take it through IIO but only with a Dmitry Ack.
> 
> > ---
> >  drivers/input/touchscreen/ti_am335x_tsc.c |   18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
> > index e1c5300..68d1250 100644
> > --- a/drivers/input/touchscreen/ti_am335x_tsc.c
> > +++ b/drivers/input/touchscreen/ti_am335x_tsc.c
> > @@ -260,8 +260,18 @@ static irqreturn_t titsc_irq(int irq, void *dev)
> >  	unsigned int fsm;
> >  
> >  	status = titsc_readl(ts_dev, REG_IRQSTATUS);
> > -	if (status & IRQENB_FIFO0THRES) {
> > -
> > +	/*
> > +	 * ADC and touchscreen share the IRQ line.
> > +	 * FIFO1 threshold, FIFO1 Overrun and FIFO1 underflow
> > +	 * interrupts are used by ADC,
> > +	 * hence return from touchscreen IRQ handler if FIFO1
> > +	 * related interrupts occurred.
> > +	 */
> > +	if ((status & IRQENB_FIFO1THRES) ||
> > +			(status & IRQENB_FIFO1OVRRUN) ||
> > +			(status & IRQENB_FIFO1UNDRFLW))
> > +		return IRQ_NONE;
> > +	else if (status & IRQENB_FIFO0THRES) {

What happens if both parts have data at the same time? Can both
IRQENB_FIFO1THRES and IRQENB_FIFO0THRES be signalled? What will happen
in this case?

Thanks.

-- 
Dmitry
