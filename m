Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3HPW2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:28:41 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:36502 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab3HPW2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:28:39 -0400
Date: Fri, 16 Aug 2013 22:31:33 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com
Subject: Re: [PATCH 3/4] input: ti_tsc: Enable shared IRQ for TSC and add
 overrun, underflow checks
Message-ID: <20130816213132.GD2636@gmail.com>
References: <1376412499-21007-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376412499-21007-4-git-send-email-zubair.lutfullah@gmail.com>
 <20130816091409.GC26895@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816091409.GC26895@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:14:09AM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-13 17:48:18 [+0100]:
> >+	if ((status & IRQENB_FIFO0OVRRUN) ||
> >+			(status & IRQENB_FIFO0UNDRFLW)) {
> >+
> >+		config = titsc_readl(ts_dev, REG_CTRL);
> >+		config &= ~(CNTRLREG_TSCSSENB);
> >+		titsc_writel(ts_dev, REG_CTRL, config);
> >+
> >+		if (status & IRQENB_FIFO0UNDRFLW) {
> >+			titsc_writel(ts_dev, REG_IRQSTATUS,
> >+				(status | IRQENB_FIFO0UNDRFLW));
> >+			irqclr |= IRQENB_FIFO0UNDRFLW;
> >+		} else {
> >+			titsc_writel(ts_dev, REG_IRQSTATUS,
> >+				(status | IRQENB_FIFO0OVRRUN));
> >+			irqclr |= IRQENB_FIFO0OVRRUN;
> >+		}
> 
> You don't do anything on overflow / underflow. Is this due to the fact
> once enabled for FIFO1 it also triggers for FIFO0?
> 
The TSCADC module doesn't recover from these interrupts.

> >+		titsc_writel(ts_dev, REG_CTRL,
> >+			(config | CNTRLREG_TSCSSENB));

The fix is to re-enable the module after disabling 
and clearing the interrupts.

That is what the handler is doing.
> >+	} else if (status & IRQENB_FIFO0THRES) {
> > 		titsc_read_coordinates(ts_dev, &x, &y, &z1, &z2);
> > 
> > 		if (ts_dev->pen_down && z1 != 0 && z2 != 0) {
> >@@ -317,9 +342,11 @@ static irqreturn_t titsc_irq(int irq, void *dev)
> > 	}
> > 
> > 	if (irqclr) {
> >-		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
> >+		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
> 
> Shouldn't FIFO1UNDRFLW & OVRRUN be handled by the adc driver? Why do you
> or the unhandled bits as well here?
FIFO1 is only used by TSC. ADC doesn't touch it.
> 
> > 		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
> >-		return IRQ_HANDLED;
> >+		status = titsc_readl(ts_dev, REG_IRQSTATUS);
> >+		if (status == false)
> >+			return IRQ_HANDLED;
> 
> And why this? If you something you handled it, if you didn't you return
> NONE. Why does it depend on REG_IRQSTATUS?

These quirks are to handle the situation where both IRQs happen
simultaneously. Which can occur when someone is using the TSC
while continuously sampling using the ADC.

REG_IRQSTATUS has flags for FIFO0 used by ADC as well.

If there are still those IRQs to handle, then IRQ_NONE is returned.
Otherwise, all IRQ flags are clear so IRQ_HANDLED is returned.

Thanks
Zubair
