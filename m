Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3H1KmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:42:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:42588 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3H1KmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:42:13 -0400
Date: Wed, 28 Aug 2013 12:42:11 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] input: ti_am335x_tsc: Enable shared IRQ for TSC
Message-ID: <20130828104211.GB14111@linutronix.de>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-2-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1377470724-15710-2-git-send-email-zubair.lutfullah@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zubair Lutfullah | 2013-08-25 23:45:23 [+0100]:

>diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
>index e1c5300..4124e580 100644
>--- a/drivers/input/touchscreen/ti_am335x_tsc.c
>+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
>@@ -315,11 +321,17 @@ static irqreturn_t titsc_irq(int irq, void *dev)
> 	}
> 
> 	if (irqclr) {
>-		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
>-		am335x_tsc_se_update(ts_dev->mfd_tscadc);
>-		return IRQ_HANDLED;
>+		titsc_writel(ts_dev, REG_IRQSTATUS, (status | irqclr));
>+		am335x_tsc_se_set(ts_dev->mfd_tscadc, ts_dev->step_mask);
> 	}
>-	return IRQ_NONE;
>+
>+	/* If any IRQ flags left, return none. So ADC can handle its IRQs */
>+	status = titsc_readl(ts_dev, REG_IRQSTATUS);
>+	if (status == false)
>+		return IRQ_HANDLED;
>+	else
>+		return IRQ_NONE;

If I understand this correctly you return IRQ_NONE the TSC interrupt has
been handled and no ADC interrupt is outstanding.
This is bad because if you received 1k _only_ TSC interrupts you return
always IRQ_NONE and the irq-core will disable the interrupt line. You
don't want this.

Now, if you handle an interrupt at the TSC level and return IRQ_HANDLED
then the second handler, the ADC in your case, is also invoked.
So you can drop this and return IRQ_HANDLED if you *did* something here
and NONE if didn't do anything.

Basides that, I'm fine with it.

>+
> }

Sebastian
