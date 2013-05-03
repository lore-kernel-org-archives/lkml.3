Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695Ab3ECHql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 03:46:41 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:55454 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758639Ab3ECHqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 03:46:40 -0400
Message-ID: <51836BFA.3030601@metafoo.de>
Date: Fri, 03 May 2013 09:49:14 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Oskar Andero <oskar.andero@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCHv2] iio: adc: add driver for MCP3204/08 12-bit ADC
References: <1367534581-13593-1-git-send-email-oskar.andero@gmail.com>
In-Reply-To: <1367534581-13593-1-git-send-email-oskar.andero@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 12:43 AM, Oskar Andero wrote:
> This adds support for Microchip's 12 bit AD converters MCP3204 and
> MCP3208. These chips communicates over SPI and supports single-ended
> and pseudo-differential configurations.
> 
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Oskar Andero <oskar.andero@gmail.com>

Looks good, except some issues with probe error path handling

> ---
>  drivers/iio/adc/Kconfig   |  10 ++
>  drivers/iio/adc/Makefile  |   1 +
>  drivers/iio/adc/mcp320x.c | 255 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 266 insertions(+)
>  create mode 100644 drivers/iio/adc/mcp320x.c
> 
[...]
> +static int mcp320x_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *channel, int *val,
> +			    int *val2, long mask)
> +{
[...]
> +	case IIO_CHAN_INFO_SCALE:
> +		/* Digital output code = (4096 * Vin) / Vref */
> +		ret = regulator_get_voltage(adc->reg);
> +		if (ret < 0)
> +			goto out;
> +
> +		*val = ret / 1000;
> +		*val2 = 4096;
> +		ret = IIO_VAL_FRACTIONAL;

You can use IIO_VAL_FRACTIONAL_LOG2 here, it is slightly more efficient and
take the log2 of the divisor for val2, e.g. 12 in this case.

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
> +
[...]
> +static int mcp320x_probe(struct spi_device *spi)
> +{
> +	struct iio_dev *indio_dev;
> +	struct mcp320x *adc;
> +	const struct mcp3208_chip_info *chip_info;
> +	int ret;
> +
> +	indio_dev = iio_device_alloc(sizeof(*adc));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	adc = iio_priv(indio_dev);
> +	adc->spi = spi;
> +
> +	indio_dev->dev.parent = &spi->dev;
> +	indio_dev->name = spi_get_device_id(spi)->name;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->info = &mcp320x_info;
> +
> +	chip_info = &mcp3208_chip_infos[spi_get_device_id(spi)->driver_data];
> +	indio_dev->channels = chip_info->channels;
> +	indio_dev->num_channels = chip_info->num_channels;
> +
> +	adc->transfer[0].tx_buf = &adc->tx_buf;
> +	adc->transfer[0].len = sizeof(adc->tx_buf);
> +	adc->transfer[1].rx_buf = adc->rx_buf;
> +	adc->transfer[1].len = sizeof(adc->rx_buf);
> +
> +	spi_message_init_with_transfers(&adc->msg, adc->transfer,
> +					ARRAY_SIZE(adc->transfer));
> +
> +	adc->reg = regulator_get(&spi->dev, "vref");
> +	if (IS_ERR(adc->reg))

You need to free the iio device in this case

> +		return PTR_ERR(adc->reg);
> +
> +	ret = regulator_enable(adc->reg);
> +	if (ret < 0)
> +		goto reg_free;
> +
> +	mutex_init(&adc->lock);
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret < 0)
> +		goto iio_free;
> +
> +	return 0;
> +
> +iio_free:
> +	iio_device_free(indio_dev);
> +reg_free:
> +	regulator_put(adc->reg);
> +

I think the order go reversed here, e.g. if you jump to reg_free you don't free
the IIO device. And you should also disable the regulator again in case
iio_device_register fails.

> +	return ret;
> +}

