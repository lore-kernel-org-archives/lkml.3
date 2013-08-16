Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3HPW0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:26:24 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:48123 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3HPW0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:26:20 -0400
Date: Fri, 16 Aug 2013 22:18:10 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130816211809.GA2636@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
 <20130816125340.GC1263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130816125340.GC1263@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 02:53:40PM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-13 21:05:03 [+0100]:
> 
> >diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> >index 3ceac3e..0d7e313 100644
> >--- a/drivers/iio/adc/ti_am335x_adc.c
> >+++ b/drivers/iio/adc/ti_am335x_adc.c
> >@@ -24,16 +24,28 @@
> …
> >+static irqreturn_t tiadc_irq(int irq, void *private)
> >+{
> >+	struct iio_dev *idev = private;
> >+	struct tiadc_device *adc_dev = iio_priv(idev);
> >+	unsigned int status, config;
> >+	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
> >+
> >+	/* FIFO Overrun. Clear flag. Disable/Enable ADC to recover */
> >+	if (status & IRQENB_FIFO1OVRRUN) {
> >+		config = tiadc_readl(adc_dev, REG_CTRL);
> >+		config &= ~(CNTRLREG_TSCSSENB);
> >+		tiadc_writel(adc_dev, REG_CTRL, config);
> >+		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1OVRRUN |
> >+				IRQENB_FIFO1UNDRFLW | IRQENB_FIFO1THRES);
> >+		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));
> 
> I have no idea how other handle this but shouldn't you somehow inform
> *anyone* that you lost some samples due to this overrun?
> 
> Sebastian

The ref manual states that TSCADC module doesn't recover 
from overrun interrupts. Thats why the disable enable of
the module here to handle the situation.
And of course, clearing interrupt flags.
The data is lost.

Informing someone about lost samples is important indeed.
But a print statement in this area causes more overruns.

I'm open to some input on how to inform userspace of such 
a situation.

Thanks
Zubair
