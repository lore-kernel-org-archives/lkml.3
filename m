Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030Ab3HSRMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:12:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:50496 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3HSRMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:12:40 -0400
Date: Mon, 19 Aug 2013 19:12:38 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130819171238.GA31610@linutronix.de>
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
…
>+static irqreturn_t tiadc_irq(int irq, void *private)
>+{
…
>+		wake_up_interruptible(&adc_dev->wq_data_avail);
…
>+}
…
>+static irqreturn_t tiadc_trigger_h(int irq, void *p)
>+{
…
>+	schedule_work(&adc_dev->poll_work);
…
>+}
…
>+static void tiadc_adc_work(struct work_struct *work_s)
>+{
…
>+		wait_event_interruptible(adc_dev->wq_data_avail,
>+					(adc_dev->data_avail == 1));
…
>+}

This is not very nice. The problem is that you might sleep in a
workqueue and so the other jobs will wait until you are done. I'm think
it is better if you create your own worker here instead using the
system's.
I'm looking into DMA support for this so once your code is working it
should be possible to switch to DMA instead reading byte wise from the
fifo.
How did you test the whole thing? Do you have a test program which
selects a few sources and reads them in continuous mode?

Sebastian
