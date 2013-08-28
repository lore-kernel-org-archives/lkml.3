Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3H1OSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:18:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:44572 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3H1OSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:18:38 -0400
Date: Wed, 28 Aug 2013 16:18:35 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: jic23@cam.ac.uk, lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130828141835.GD14111@linutronix.de>
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
…

>+static struct iio_trigger *tiadc_iio_allocate_trigger(struct iio_dev *indio_dev)
>+{
>+	struct iio_trigger *trig;
>+	int ret;
>+
>+	trig = iio_trigger_alloc("%s-dev%d", indio_dev->name, indio_dev->id);
>+	if (trig == NULL)
>+		return NULL;
>+
>+	trig->dev.parent = indio_dev->dev.parent;
>+	trig->ops = &tiadc_trigger_ops;
>+	iio_trigger_set_drvdata(trig, indio_dev);
>+
>+	ret = iio_trigger_register(trig);
>+	if (ret)

shouldn't you free the trigger / undo iio_trigger_alloc() here?

>+		return NULL;
>+
>+	return trig;
> }

> 
> static const char * const chan_name_ain[] = {
>@@ -220,7 +394,8 @@ static int tiadc_probe(struct platform_device *pdev)
> 					  sizeof(struct tiadc_device));
> 	if (indio_dev == NULL) {
> 		dev_err(&pdev->dev, "failed to allocate iio device\n");
>-		return -ENOMEM;
>+		err = -ENOMEM;
>+		goto err_ret;
Why the jump instead of leave right away?

> 	}
> 	adc_dev = iio_priv(indio_dev);
> 
>@@ -262,11 +465,14 @@ static int tiadc_remove(struct platform_device *pdev)
> 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> 	u32 step_en;
> 
>+	free_irq(adc_dev->irq, indio_dev);
> 	iio_device_unregister(indio_dev);
>+	iio_buffer_unregister(indio_dev);
> 	tiadc_channels_remove(indio_dev);

I think you need also to

	iio_trigger_unregister(adc_dev->trig);
	iio_trigger_free(adc_dev->trig);

here.
 
> 	step_en = get_adc_step_mask(adc_dev);
> 	am335x_tsc_se_clr(adc_dev->mfd_tscadc, step_en);
>+	iio_device_free(indio_dev);
> 
> 	return 0;
> }

Sebastian
