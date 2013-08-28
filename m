Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3H1SW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:22:59 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57961 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab3H1SW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:22:56 -0400
Date: Wed, 28 Aug 2013 19:22:50 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Add continuous sampling support
Message-ID: <20130828182249.GB3580@gmail.com>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
 <20130828141835.GD14111@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130828141835.GD14111@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 04:18:35PM +0200, Sebastian Andrzej Siewior wrote:
> * Zubair Lutfullah | 2013-08-25 23:45:24 [+0100]:
> 
> >diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> >index a952538..ae2202b 100644
> >--- a/drivers/iio/adc/ti_am335x_adc.c
> >+++ b/drivers/iio/adc/ti_am335x_adc.c
> …
> 
> >+static struct iio_trigger *tiadc_iio_allocate_trigger(struct iio_dev *indio_dev)
...
> >+	trig = iio_trigger_alloc("%s-dev%d", indio_dev->name, indio_dev->id);
> >+	if (trig == NULL)
> >+		return NULL;
> >+
...
> >+	ret = iio_trigger_register(trig);
> >+	if (ret)
> 
> shouldn't you free the trigger / undo iio_trigger_alloc() here?
> 
> >+		return NULL;
> >+
...
Possible. It's done in the probe section just 
to keep error handling bunched there.
> 
> > 
> > static const char * const chan_name_ain[] = {
> >@@ -220,7 +394,8 @@ static int tiadc_probe(struct platform_device *pdev)
> > 					  sizeof(struct tiadc_device));
> > 	if (indio_dev == NULL) {
> > 		dev_err(&pdev->dev, "failed to allocate iio device\n");
> >-		return -ENOMEM;
> >+		err = -ENOMEM;
> >+		goto err_ret;
> Why the jump instead of leave right away?
> 
> > 	}
Again. Error handling all in one place.

> > 
> >@@ -262,11 +465,14 @@ static int tiadc_remove(struct platform_device *pdev)
> > 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
> > 	u32 step_en;
> > 
> >+	free_irq(adc_dev->irq, indio_dev);
> > 	iio_device_unregister(indio_dev);
> >+	iio_buffer_unregister(indio_dev);
> > 	tiadc_channels_remove(indio_dev);
> 
> I think you need also to
> 
> 	iio_trigger_unregister(adc_dev->trig);
> 	iio_trigger_free(adc_dev->trig);
> 
> here.
Indeed.
Thanks for pointing it out.

Zubair
