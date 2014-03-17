Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaCQIBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 04:01:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24186 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaCQIBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 04:01:17 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-fc-5326abcad785
Message-id: <1395043273.3950.3.camel@AMDC1943>
Subject: Re: [PATCH] iio: cm36651: Fix i2c client leak and possible NULL
 pointer dereference
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beomho Seo <beomho.seo@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Date: Mon, 17 Mar 2014 09:01:13 +0100
In-reply-to: <53247EC9.6090505@kernel.org>
References: <1394098390-11213-1-git-send-email-k.kozlowski@samsung.com>
 <53247EC9.6090505@kernel.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xy7qnVqsFGxy4omRx+tM2dosHTauY
	LJZMns9qMe/IOxaLy7vmsDmwemxa1cnmseTNIVaPvi2rGD0+b5ILYInisklJzcksSy3St0vg
	ypjyto2xYINkxfWtc1kbGO+IdDFyckgImEjcWHaMEcIWk7hwbz1bFyMXh5DAUkaJU5d7WSCc
	z4wS/QfPMYNU8QroSXx70AlmCwvESaz/chmsm03AWGLz8iVsILaIgLrEtBlXmEBsZoEORomm
	T6wgNouAqsTpx2fB6jkFtCQm3p0IZgsJpEucvrsRql5dYtK8RcwQFylJ7G7vZIeIy0tsXvMW
	6gZBiR+T77FMYBSYhaRlFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQICeSv
	OxiXHrM6xCjAwajEwztBWS1YiDWxrLgy9xCjBAezkgjvlJlAId6UxMqq1KL8+KLSnNTiQ4xM
	HJxSDYyJM9XVeTwX6mx/rhvuob0veWn7LS6jpEfCZsJtgcc992cqb2Bd45TWWfvV9MZa0Qky
	p5x0TY5KRMgazfrHdE5ng7jf1I9/v//ayhW6QNEvaMnFOAP/FRJ6ax9t+7SKJ9lg8dWm3rjE
	wuk8N/nSJ/k5vkjPTJkof17okA7zi9qWfRqsL/8eblNiKc5INNRiLipOBABd4N+1QgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2014-03-15 at 16:24 +0000, Jonathan Cameron wrote:
> On 06/03/14 09:33, Krzysztof Kozlowski wrote:
> > During probe the driver allocates dummy I2C devices (i2c_new_dummy())
> > but they aren't unregistered during driver remove or probe failure.
> >
> > Additionally driver does not check the return value of i2c_new_dummy().
> > In case of error (i2c_new_device(): memory allocation failure or I2C
> > address cannot be used) this function returns NULL which is later
> > dereferenced by i2c_smbus_{read,write}_data() functions.
> >
> > Fix issues by properly checking for i2c_new_dummy() return value and
> > unregistering I2C devices on driver remove or probe failure.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Good catch, but the error path needs more care.
> > ---
> >   drivers/iio/light/cm36651.c |   12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> >
> > diff --git a/drivers/iio/light/cm36651.c b/drivers/iio/light/cm36651.c
> > index a45e07492db3..e7e9a597159f 100644
> > --- a/drivers/iio/light/cm36651.c
> > +++ b/drivers/iio/light/cm36651.c
> > @@ -653,6 +653,11 @@ static int cm36651_probe(struct i2c_client *client,
> >   	cm36651->ps_client = i2c_new_dummy(client->adapter,
> >   						     CM36651_I2C_ADDR_PS);
> >   	cm36651->ara_client = i2c_new_dummy(client->adapter, CM36651_ARA);
> > +	if (!cm36651->ps_client || !cm36651->ara_client) {
> > +		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
> > +		ret = -ENODEV;
> > +		goto error_i2c_unregister;
> > +	}
> The two failures need to be handled independently as we only want to unregister
> those that succeeded.  i2c_new_dummy will not return an error and leave a device
> registered.  This is particularly true given the first thing that i2c_unregister_device
> does is to derefence the client pointer.  That will cause a segfault if you do it
> for NULL as here.
> 

Where the segfault would occur? If i2c_new_dummy fails then
i2c_unregister_device() will be called only on NON-null values:
	+error_i2c_unregister:
	+	if (cm36651->ps_client)
	+		i2c_unregister_device(cm36651->ps_client);
	+	if (cm36651->ara_client)
	+		i2c_unregister_device(cm36651->ara_client);

If probe() succeeds (both i2c_new_dummy return proper pointer) then
remove() will unregister two i2c devices.


> >   	mutex_init(&cm36651->lock);
> >   	indio_dev->dev.parent = &client->dev;
> >   	indio_dev->channels = cm36651_channels;
> > @@ -687,6 +692,11 @@ error_free_irq:
> >   	free_irq(client->irq, indio_dev);
> >   error_disable_reg:
> >   	regulator_disable(cm36651->vled_reg);
> > +error_i2c_unregister:
> > +	if (cm36651->ps_client)
> > +		i2c_unregister_device(cm36651->ps_client);
> > +	if (cm36651->ara_client)
> > +		i2c_unregister_device(cm36651->ara_client);
> >   	return ret;
> >   }
> >
> > @@ -698,6 +708,8 @@ static int cm36651_remove(struct i2c_client *client)
> >   	iio_device_unregister(indio_dev);
> >   	regulator_disable(cm36651->vled_reg);
> >   	free_irq(client->irq, indio_dev);
> > +	i2c_unregister_device(cm36651->ps_client);
> > +	i2c_unregister_device(cm36651->ara_client);
> Good catch.
> >
> >   	return 0;
> >   }
> >

