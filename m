Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaGQVIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:08:05 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:51607
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbaGQVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:08:04 -0400
X-IronPort-AV: E=Sophos;i="5.01,680,1400018400"; 
   d="scan'208";a="71876489"
Date: Thu, 17 Jul 2014 23:08:00 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: adis16203: Use devm_iio_device_register
In-Reply-To: <53C8364D.6010908@metafoo.de>
Message-ID: <alpine.DEB.2.02.1407172306230.1976@localhost6.localdomain6>
References: <20140717204040.GA22788@himangi-Dell> <53C8364D.6010908@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2014, Lars-Peter Clausen wrote:

> On 07/17/2014 10:40 PM, Himangi Saraogi wrote:
> > This patch introduces the use of iio_device_register and does away with
> > the call to the corressponding unregister function in the probe and
> > remove functions of the driver respectively.
> > 
> > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> 
> No, you changed the relative order in which iio_device_unregister() and
> adis_cleanup_buffer_and_trigger() are called, this opens up the way for race
> conditions. Rule of thumb: Don't convert drivers to managed functions if this
> will change the order in which functions will called on device removal.

Thanks for the information.  I was indeed not sure about this.

Unfortunately, removal code is not always perfectly written, and the 
operations are not always done in the right order...

julia

> - Lars
> 
> > ---
> >   drivers/staging/iio/accel/adis16203_core.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/iio/accel/adis16203_core.c
> > b/drivers/staging/iio/accel/adis16203_core.c
> > index 409a28e..5077779 100644
> > --- a/drivers/staging/iio/accel/adis16203_core.c
> > +++ b/drivers/staging/iio/accel/adis16203_core.c
> > @@ -175,7 +175,7 @@ static int adis16203_probe(struct spi_device *spi)
> >   	if (ret)
> >   		goto error_cleanup_buffer_trigger;
> > 
> > -	ret = iio_device_register(indio_dev);
> > +	ret = devm_iio_device_register(&spi->dev, indio_dev);
> >   	if (ret)
> >   		goto error_cleanup_buffer_trigger;
> > 
> > @@ -191,7 +191,6 @@ static int adis16203_remove(struct spi_device *spi)
> >   	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> >   	struct adis *st = iio_priv(indio_dev);
> > 
> > -	iio_device_unregister(indio_dev);
> >   	adis_cleanup_buffer_and_trigger(st, indio_dev);
> > 
> >   	return 0;
> > 
> 
> 
