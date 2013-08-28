Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3H1QnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:43:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:45451 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3H1QnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:43:11 -0400
Date: Wed, 28 Aug 2013 18:43:08 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130828164308.GE14111@linutronix.de>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zubair Lutfullah | 2013-08-25 23:45:24 [+0100]:

>diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
>index a952538..ae2202b 100644
>--- a/drivers/iio/adc/ti_am335x_adc.c
>+++ b/drivers/iio/adc/ti_am335x_adc.c
>@@ -231,28 +406,56 @@ static int tiadc_probe(struct platform_device *pdev)
…
>+err_free_device:
>+	iio_device_free(indio_dev);

I am not sure about this one.

>+err_ret:
> 	return err;
> }
> 
>@@ -262,11 +465,14 @@ static int tiadc_remove(struct platform_device *pdev)
> 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> 	u32 step_en;
> 
>+	free_irq(adc_dev->irq, indio_dev);
> 	iio_device_unregister(indio_dev);
>+	iio_buffer_unregister(indio_dev);
> 	tiadc_channels_remove(indio_dev);
> 
> 	step_en = get_adc_step_mask(adc_dev);
> 	am335x_tsc_se_clr(adc_dev->mfd_tscadc, step_en);
>+	iio_device_free(indio_dev);

But this one is wrong. The will be removed via dev_res() and if you do
it here as well then dev_res() will decrement the reference of an unused
object.

> 
> 	return 0;
> }

Sebastian
