Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3HPWSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:18:05 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62376 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3HPWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:18:03 -0400
Date: Fri, 16 Aug 2013 22:13:29 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130816211312.GB2528@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
 <20130816132549.GD1263@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130816132549.GD1263@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 03:25:49PM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-13 21:05:03 [+0100]:
> 
> >diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> >index 3ceac3e..0d7e313 100644
> >--- a/drivers/iio/adc/ti_am335x_adc.c
> >+++ b/drivers/iio/adc/ti_am335x_adc.c
> >@@ -141,58 +350,51 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
> > {
> …
> >+	if (iio_buffer_enabled(indio_dev))
> >+		return -EBUSY;
> >+	else {
> 
> You can drop else so you lose one ident level.
> 
Noted.

> >+		unsigned long timeout = jiffies + usecs_to_jiffies
> >+					(IDLE_TIMEOUT * adc_dev->channels);
> 
> What computing this once? ->channels is assigned at probe time.
> 
The timeout depends on number of SW enabled channels.
Hence the calculation. In this read_raw, one channel is to be
read. 
However, all channels are sampled. And the one that the 
userspace requires is pushed to user.

> >+		/* Wait for ADC sequencer to complete sampling */
> >+		while (tiadc_readl(adc_dev, REG_ADCFSM) & SEQ_STATUS) {
> >+			if (time_after(jiffies, timeout))
> >+				return -EAGAIN;
> 
> You should check the condition after the timeout occured once again. It
> is possible that the task performing the read has been pushed away by a
> higher prio task (or preempted incase this sounds like a bully) and
> after it got back on the cpu the timeout occured but the condition is
> valid and no reason for -EAGAIN.
> 
> Sebastian

Interesting catch. I'll look into it.

Thanks for pointing it out.

Zubair
