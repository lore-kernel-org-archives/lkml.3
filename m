Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3JEIje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 04:39:34 -0400
Received: from smtp-out-061.synserver.de ([212.40.185.61]:1035 "EHLO
	smtp-out-061.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3JEIjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 04:39:31 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1799
Message-ID: <524FD0AB.7020209@metafoo.de>
Date: Sat, 05 Oct 2013 10:41:15 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO AD7923 iio_consumer support
References: <201310050821.r958LBqP012933@localhost.localdomain>
In-Reply-To: <201310050821.r958LBqP012933@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 10:21 AM, Christophe Leroy wrote:
> This patch adds support for iio_consumer to Analog Devices AD7923 ADC driver.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Verified-by: Patrick Vasseur <patrick.vasseur@c-s.fr>
> 
> diff -urN a/drivers/iio/adc/ad7923.c b/drivers/iio/adc/ad7923.c
> --- a/drivers/iio/adc/ad7923.c	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/iio/adc/ad7923.c	2013-02-12 15:16:29.000000000 +0100
> @@ -19,11 +19,15 @@
>  #include <linux/interrupt.h>
>  
>  #include <linux/iio/iio.h>
> +#include <linux/iio/driver.h>
> +#include <linux/iio/machine.h>

The fact that you need to include machine.h here should ring some alarm
bells. machine.h is meant to be included by machine or board drivers, not by
device drivers.

>  #include <linux/iio/sysfs.h>
>  #include <linux/iio/buffer.h>
>  #include <linux/iio/trigger_consumer.h>
>  #include <linux/iio/triggered_buffer.h>
>  
> +#define AD7923_NAME	"ad7923"
> +
>  #define AD7923_WRITE_CR		(1 << 11)	/* write control register */
>  #define AD7923_RANGE		(1 << 1)	/* range to REFin */
>  #define AD7923_CODING		(1 << 0)	/* coding is straight binary */
> @@ -96,6 +100,7 @@
>  			.storagebits = 16,				\
>  			.endianness = IIO_BE,				\
>  		},							\
> +		.datasheet_name = #index,				\

The names for the pins in the datasheet are VINx

>  	}
>  
>  #define DECLARE_AD7923_CHANNELS(name, bits) \
> @@ -195,6 +200,31 @@
>  	return IRQ_HANDLED;
>  }
>  
> +/* default maps used by iio consumer */
> +static struct iio_map ad7923_default_iio_maps[] = {
> +	{
> +		.consumer_dev_name = AD7923_NAME,

The consumer_dev_name field is the dev_name() of the device that is going to
consume data from the channel. This device provides data on the channel.

> +		.consumer_channel = "channel_0",
> +		.adc_channel_label = "0",
> +	},
> +	{
> +		.consumer_dev_name = AD7923_NAME,
> +		.consumer_channel = "channel_1",
> +		.adc_channel_label = "1",
> +	},
> +	{
> +		.consumer_dev_name = AD7923_NAME,
> +		.consumer_channel = "channel_2",
> +		.adc_channel_label = "2",
> +	},
> +	{
> +		.consumer_dev_name = AD7923_NAME,
> +		.consumer_channel = "channel_3",
> +		.adc_channel_label = "3",
> +	},
> +	{ }
> +};

This is a mapping between channel names of the provider between the channel
names of the consumer. So it is specific to a certain combination of
consumer and provider and usually depend on how things are physically wired
on your board. As such there can be no generic mapping and this needs to go
into your machine/board driver. The mapping is usually passed to the IIO
driver via its platform data.

So e.g. imagine you have a provider like this driver and you have a consumer
that has a "voltage" channel. And on your board channel 3 of the ADC is what
you want to route to that consumer. Then your mapping would look like this:

{
	.consumer_dev_name = "your_consumer_device.1",
	.consumer_channel = "voltage",
	.adc_channel_label = "AIN3",
}

And in your consumer driver you'd do:

channel = iio_channel_get(dev, "voltage");

- Lars
