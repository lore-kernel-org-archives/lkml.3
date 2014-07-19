Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaGSUqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 16:46:12 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:53462 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848AbaGSUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 16:46:11 -0400
X-IronPort-AV: E=Sophos;i="5.01,693,1400018400"; 
   d="scan'208";a="86087598"
Date: Sat, 19 Jul 2014 22:46:08 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Jonathan Cameron <jic23@kernel.org>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, julia.lawall@lip6.fr,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] staging:iio:ad7280a: Use managed interfaces
In-Reply-To: <53CAD915.506@kernel.org>
Message-ID: <alpine.DEB.2.02.1407192245340.1989@localhost6.localdomain6>
References: <20140719103341.GA18568@himangi-Dell> <53CAD915.506@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 19 Jul 2014, Jonathan Cameron wrote:

> On 19/07/14 11:33, Himangi Saraogi wrote:
> > This patch moves data allocated using unmanaged interfaces to managed
> > interfaces like devm_kzalloc, devm_iio_device_register, devm_kasprintf,
> > devm_request_threaded_irq and does away with the calls to free the
> > allocated memory in the probe and remove functions. Some labels in the
> > probe function are also removed.
> > 
> > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> cc'ing Lars who tends to look after Analog Devices drivers
> and more specifically was involved in the thread that lead to this
> patch.
> 
> Also, the devm_kasprintf does not appear to be in upstream so this
> patch should have made an dependency clear.
> 
> https://lkml.org/lkml/2014/7/16/667
> 
> What is the intended merge path for that patch?

Greg said that he would be taking it.  He already took the devm_kasprintf 
patch.

julia

> 
> 
> > ---
> > I am not very sure if devmifying request_irq is a good idea as it
> > leads to the freeing of the interrupt after the ad7280_write.
> Agreed. I wouldn't do it!
> 
> Otherwise, all looks fine.
> >   drivers/staging/iio/adc/ad7280a.c | 57
> > ++++++++++++++-------------------------
> >   1 file changed, 20 insertions(+), 37 deletions(-)
> > 
> > diff --git a/drivers/staging/iio/adc/ad7280a.c
> > b/drivers/staging/iio/adc/ad7280a.c
> > index d215edf..3706b3e 100644
> > --- a/drivers/staging/iio/adc/ad7280a.c
> > +++ b/drivers/staging/iio/adc/ad7280a.c
> > @@ -486,8 +486,8 @@ static int ad7280_channel_init(struct ad7280_state *st)
> >   {
> >   	int dev, ch, cnt;
> > 
> > -	st->channels = kcalloc((st->slave_num + 1) * 12 + 2,
> > -			       sizeof(*st->channels), GFP_KERNEL);
> > +	st->channels = devm_kcalloc(&st->spi->dev, (st->slave_num + 1) * 12 +
> > 2,
> > +				    sizeof(*st->channels), GFP_KERNEL);
> >   	if (st->channels == NULL)
> >   		return -ENOMEM;
> > 
> > @@ -547,8 +547,9 @@ static int ad7280_attr_init(struct ad7280_state *st)
> >   {
> >   	int dev, ch, cnt;
> > 
> > -	st->iio_attr = kzalloc(sizeof(*st->iio_attr) * (st->slave_num + 1) *
> > -				AD7280A_CELLS_PER_DEV * 2, GFP_KERNEL);
> > +	st->iio_attr = devm_kzalloc(&st->spi->dev, sizeof(*st->iio_attr) *
> > +				    (st->slave_num + 1) *
> > +				    AD7280A_CELLS_PER_DEV * 2, GFP_KERNEL);
> >   	if (st->iio_attr == NULL)
> >   		return -ENOMEM;
> > 
> > @@ -564,7 +565,7 @@ static int ad7280_attr_init(struct ad7280_state *st)
> >   			st->iio_attr[cnt].dev_attr.store =
> >   				ad7280_store_balance_sw;
> >   			st->iio_attr[cnt].dev_attr.attr.name =
> > -				kasprintf(GFP_KERNEL,
> > +				devm_kasprintf(&st->spi->dev, GFP_KERNEL,
> >   					"in%d-in%d_balance_switch_en",
> >   					(dev * AD7280A_CELLS_PER_DEV) + ch,
> >   					(dev * AD7280A_CELLS_PER_DEV) + ch +
> > 1);
> > @@ -581,7 +582,8 @@ static int ad7280_attr_init(struct ad7280_state *st)
> >   			st->iio_attr[cnt].dev_attr.store =
> >   				ad7280_store_balance_timer;
> >   			st->iio_attr[cnt].dev_attr.attr.name =
> > -				kasprintf(GFP_KERNEL,
> > "in%d-in%d_balance_timer",
> > +				devm_kasprintf(&st->spi->dev, GFP_KERNEL,
> > +					"in%d-in%d_balance_timer",
> >   					(dev * AD7280A_CELLS_PER_DEV) + ch,
> >   					(dev * AD7280A_CELLS_PER_DEV) + ch +
> > 1);
> >   			ad7280_attributes[cnt] =
> > @@ -900,48 +902,36 @@ static int ad7280_probe(struct spi_device *spi)
> > 
> >   	ret = ad7280_attr_init(st);
> >   	if (ret < 0)
> > -		goto error_free_channels;
> > +		return ret;
> > 
> > -	ret = iio_device_register(indio_dev);
> > +	ret = devm_iio_device_register(&spi->dev, indio_dev);
> >   	if (ret)
> > -		goto error_free_attr;
> > +		return ret;
> > 
> >   	if (spi->irq > 0) {
> >   		ret = ad7280_write(st, AD7280A_DEVADDR_MASTER,
> >   				   AD7280A_ALERT, 1,
> >   				   AD7280A_ALERT_RELAY_SIG_CHAIN_DOWN);
> >   		if (ret)
> > -			goto error_unregister;
> > +			return ret;
> > 
> >   		ret = ad7280_write(st, AD7280A_DEVADDR(st->slave_num),
> >   				   AD7280A_ALERT, 0,
> >   				   AD7280A_ALERT_GEN_STATIC_HIGH |
> >   				   (pdata->chain_last_alert_ignore & 0xF));
> >   		if (ret)
> > -			goto error_unregister;
> > -
> > -		ret = request_threaded_irq(spi->irq,
> > -					   NULL,
> > -					   ad7280_event_handler,
> > -					   IRQF_TRIGGER_FALLING |
> > -					   IRQF_ONESHOT,
> > -					   indio_dev->name,
> > -					   indio_dev);
> > +			return ret;
> > +
> > +		ret = devm_request_threaded_irq(&spi->dev, spi->irq, NULL,
> > +						ad7280_event_handler,
> > +						IRQF_TRIGGER_FALLING |
> > +						IRQF_ONESHOT, indio_dev->name,
> > +						indio_dev);
> >   		if (ret)
> > -			goto error_unregister;
> > +			return ret;
> >   	}
> > 
> >   	return 0;
> > -error_unregister:
> > -	iio_device_unregister(indio_dev);
> > -
> > -error_free_attr:
> > -	kfree(st->iio_attr);
> > -
> > -error_free_channels:
> > -	kfree(st->channels);
> > -
> > -	return ret;
> >   }
> > 
> >   static int ad7280_remove(struct spi_device *spi)
> > @@ -949,16 +939,9 @@ static int ad7280_remove(struct spi_device *spi)
> >   	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> >   	struct ad7280_state *st = iio_priv(indio_dev);
> > 
> > -	if (spi->irq > 0)
> > -		free_irq(spi->irq, indio_dev);
> > -	iio_device_unregister(indio_dev);
> > -
> >   	ad7280_write(st, AD7280A_DEVADDR_MASTER, AD7280A_CONTROL_HB, 1,
> >   			AD7280A_CTRL_HB_PWRDN_SW | st->ctrl_hb);
> > 
> > -	kfree(st->channels);
> > -	kfree(st->iio_attr);
> > -
> >   	return 0;
> >   }
> > 
> > 
> 
> 
