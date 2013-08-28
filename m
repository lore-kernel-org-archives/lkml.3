Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3H1SUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:20:00 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:48757 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3H1ST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:19:58 -0400
Date: Wed, 28 Aug 2013 19:19:52 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130828181951.GA3580@gmail.com>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
 <20130828164308.GE14111@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130828164308.GE14111@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 06:43:08PM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-25 23:45:24 [+0100]:
> 
> >diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> >index a952538..ae2202b 100644
> >--- a/drivers/iio/adc/ti_am335x_adc.c
> >+++ b/drivers/iio/adc/ti_am335x_adc.c
> >@@ -231,28 +406,56 @@ static int tiadc_probe(struct platform_device *pdev)
> …
> >+err_free_device:
> >+	iio_device_free(indio_dev);
> 
> I am not sure about this one.

If I understand correctly, if devm_iio_device_alloc 
is successful earlier in the code and subsequent stuff fails. 

Then the code jumps to err_free_device and this is needed.

> 
> >+err_ret:
> > 	return err;
> > }
> > 
> >@@ -262,11 +465,14 @@ static int tiadc_remove(struct platform_device *pdev)
> > 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> > 	u32 step_en;
> > 
> >+	free_irq(adc_dev->irq, indio_dev);
> > 	iio_device_unregister(indio_dev);
> >+	iio_buffer_unregister(indio_dev);
> > 	tiadc_channels_remove(indio_dev);
> > 
> > 	step_en = get_adc_step_mask(adc_dev);
> > 	am335x_tsc_se_clr(adc_dev->mfd_tscadc, step_en);
> >+	iio_device_free(indio_dev);
> 
> But this one is wrong. The will be removed via dev_res() and if you do
> it here as well then dev_res() will decrement the reference of an unused
> object.
I was unaware of this aspect.

*but*

iio_simple_dummy.c has it in its remove function.
And I just checked and found it in several drivers as well.

I'll leave this to the more experienced folks on the list..
> > 
> > 	return 0;
> > }
> 
> Sebastian
