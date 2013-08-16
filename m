Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3HPMxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:53:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:39196 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3HPMxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:53:42 -0400
Date: Fri, 16 Aug 2013 14:53:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130816125340.GC1263@linutronix.de>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zubair Lutfullah | 2013-08-13 21:05:03 [+0100]:

>diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
>index 3ceac3e..0d7e313 100644
>--- a/drivers/iio/adc/ti_am335x_adc.c
>+++ b/drivers/iio/adc/ti_am335x_adc.c
>@@ -24,16 +24,28 @@
…
>+static irqreturn_t tiadc_irq(int irq, void *private)
>+{
>+	struct iio_dev *idev = private;
>+	struct tiadc_device *adc_dev = iio_priv(idev);
>+	unsigned int status, config;
>+	status = tiadc_readl(adc_dev, REG_IRQSTATUS);
>+
>+	/* FIFO Overrun. Clear flag. Disable/Enable ADC to recover */
>+	if (status & IRQENB_FIFO1OVRRUN) {
>+		config = tiadc_readl(adc_dev, REG_CTRL);
>+		config &= ~(CNTRLREG_TSCSSENB);
>+		tiadc_writel(adc_dev, REG_CTRL, config);
>+		tiadc_writel(adc_dev, REG_IRQSTATUS, IRQENB_FIFO1OVRRUN |
>+				IRQENB_FIFO1UNDRFLW | IRQENB_FIFO1THRES);
>+		tiadc_writel(adc_dev, REG_CTRL, (config | CNTRLREG_TSCSSENB));

I have no idea how other handle this but shouldn't you somehow inform
*anyone* that you lost some samples due to this overrun?

>+	} else if (status & IRQENB_FIFO1THRES) {
>+		/* Wake adc_work that pushes FIFO data to iio buffer */
>+		tiadc_writel(adc_dev, REG_IRQCLR, IRQENB_FIFO1THRES);
>+		adc_dev->data_avail = 1;
>+		wake_up_interruptible(&adc_dev->wq_data_avail);
>+	} else
>+		return IRQ_NONE;

Sebastian
