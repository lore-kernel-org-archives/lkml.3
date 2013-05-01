Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709Ab3EAOEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:04:53 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:35632 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916Ab3EAOEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:04:44 -0400
Message-ID: <51812195.3030305@metafoo.de>
Date: Wed, 01 May 2013 16:07:17 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Oskar Andero <oskar.andero@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] iio: adc: add driver for MCP3204/08 12-bit ADC
References: <1367360497-16820-1-git-send-email-oskar.andero@gmail.com>
In-Reply-To: <1367360497-16820-1-git-send-email-oskar.andero@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 12:21 AM, Oskar Andero wrote:
> This adds support for Microchip's 12 bit AD converters MCP3204 and
> MCP3208. These chips communicates over SPI and supports single-ended
> and pseudo-differential configurations.
> 
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Oskar Andero <oskar.andero@gmail.com>

Hi,

Looks very good in general. A few minor things, mostly related to the regulator
handling and a couple of nitpicks inline.

> ---
>  drivers/iio/adc/Kconfig               |  10 ++
>  drivers/iio/adc/Makefile              |   1 +
>  drivers/iio/adc/mcp320x.c             | 261 ++++++++++++++++++++++++++++++++++
>  include/linux/platform_data/mcp320x.h |  23 +++
>  4 files changed, 295 insertions(+)
>  create mode 100644 drivers/iio/adc/mcp320x.c
>  create mode 100644 include/linux/platform_data/mcp320x.h
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index ab0767e6..93129ec 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
[...]
> +
> +static int mcp320x_read_raw(struct iio_dev *iio,
> +			    struct iio_chan_spec const *channel, int *val,
> +			    int *val2, long mask)
> +{
> +	struct mcp320x *adc = iio_priv(iio);
> +	int ret = -EINVAL;
> +
> +	mutex_lock(&adc->lock);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
[...]
> +	case IIO_CHAN_INFO_SCALE:
> +		/* Digital output code = (4096 * Vin) / Vref */
> +		if (!IS_ERR_OR_NULL(adc->reg)) {
> +			ret = regulator_get_voltage(adc->reg);
> +			if (ret < 0)
> +				goto out;
> +			*val = ret / 1000;
> +		} else {
> +			*val = adc->ref_mv;
> +		}
> +		*val2 = 4096 * 1000;

The scale of voltage channels is in mV. So I think the * 1000 should be removed.

> +		ret = IIO_VAL_FRACTIONAL;
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +out:
> +	mutex_unlock(&adc->lock);
> +
> +	return ret;
> +}
[...]h
> +static int mcp320x_probe(struct spi_device *spi)
> +{
> +	struct mcp320x_platform_data *pdata = spi->dev.platform_data;
> +	struct iio_dev *iio;

It's not a big deal, but usually we call the iio_dev variabl indio_dev would be
nice for consistency to use this name in your driver as well.

> +	struct mcp320x *adc;
> +	int ret;
> +
> +	if (!pdata) {
> +		dev_err(&spi->dev, "No platform data!");
> +		return -EINVAL;
> +	}
> +
> +	iio = iio_device_alloc(sizeof(*adc));
> +	if (!iio)
> +		return -ENOMEM;
> +
> +	adc = iio_priv(iio);
> +	adc->spi = spi;
> +
> +	iio->dev.parent = &spi->dev;
> +	iio->name = spi_get_device_id(spi)->name;
> +	iio->modes = INDIO_DIRECT_MODE;
> +	iio->info = &mcp320x_info;
> +
> +	if (spi_get_device_id(spi)->driver_data == mcp3204) {
> +		iio->channels = mcp3204_channels;
> +		iio->num_channels = ARRAY_SIZE(mcp3204_channels);
> +	} else {
> +		iio->channels = mcp3208_channels;
> +		iio->num_channels = ARRAY_SIZE(mcp3208_channels);
> +	}

Usually we use a lookup table for this. E.g

struct mcp3208_chip_info {
	struct iio_chan_spec *channels;
	unsigned int num_channels;
};

static const struct mcp3208_chip_info[] = {
	[mcp3204] = {
		.channels = mcp3204_channels,
		.num_channels = ARRAY_SIZE(mcp3204_channels)
	},
	[mcp3204] = {
		...
	},
};

	indio_dev->channels = mcp3208_chip_info[id].channels;
	indio_dev->num_channels = mcp3208_chip_info[id].num_channels;

This keeps things a bit more tidy. Especially if more chip variants are added
later.

> +
> +	adc->transfer[0].tx_buf = &adc->tx_buf;
> +	adc->transfer[0].len = sizeof(adc->tx_buf);
> +	adc->transfer[1].rx_buf = adc->rx_buf;
> +	adc->transfer[1].len = sizeof(adc->rx_buf);
> +
> +	spi_message_init(&adc->msg);
> +	spi_message_add_tail(&adc->transfer[0], &adc->msg);
> +	spi_message_add_tail(&adc->transfer[1], &adc->msg);

There is a new helper function which makes this a bit shorter:

	spi_message_init_with_transfers(&adc->msg, adc->transfer,
		ARRAY_SIZE(adc->transfer));

> +
> +	if (pdata->reg) {
> +		adc->reg = regulator_get(&spi->dev, pdata->reg);

This not how the regulator API is supposed to be used. The regulator name
should be const. E.g. "vref". Your board code then provides a lookup table map
the regulator to the name in the consumer.

> +		if (IS_ERR_OR_NULL(adc->reg))
> +			return PTR_ERR(adc->reg);

So what happens in the OR_NULL case? I think it is save to just use
IS_ERR(adc->reg)

> +
> +		ret = regulator_enable(adc->reg);
> +		if (ret < 0)
> +			goto reg_free;
> +	} else {
> +		adc->ref_mv = pdata->ref_mv;

I'd like to see this fallback path go away. For supplies with a const voltage
the fixed-voltage-regulator can be used.

> +	}
> +
> +	mutex_init(&adc->lock);
> +
> +	ret = iio_device_register(iio);
> +	if (ret < 0)
> +		goto iio_free;
> +
> +	return 0;
> +
> +iio_free:
> +	iio_device_free(iio);
> +reg_free:
> +	if (!IS_ERR_OR_NULL(adc->reg))
> +		regulator_put(adc->reg);
> +
> +	return ret;
> +}
> +
> +static int mcp320x_remove(struct spi_device *spi)
> +{
> +	struct iio_dev *iio = spi_get_drvdata(spi);
> +	struct mcp320x *adc = iio_priv(iio);
> +
> +	if (!IS_ERR_OR_NULL(adc->reg)) {
> +		regulator_disable(adc->reg);
> +		regulator_put(adc->reg);
> +	}

First unregister the device, then free the regulator, then free the device.

> +
> +	iio_device_unregister(iio);
> +	iio_device_free(iio);
> +
> +	return 0;
> +}
[...]
