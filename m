Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaFFJJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:09:51 -0400
Received: from smtp-out-247.synserver.de ([212.40.185.247]:1158 "EHLO
	smtp-out-247.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFFJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:09:48 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 6636
Message-ID: <5391854E.5010301@metafoo.de>
Date: Fri, 06 Jun 2014 11:09:34 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Michael Welling <mwelling@ieee.org>
CC: Jonathan Cameron <jic23@kernel.org>, Peter Meerwald <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] iio: dac: mcp4902/mcp4912/mcp4922 dac driver
References: <alpine.DEB.2.01.1406050812220.20498@pmeerw.net> <1402017131-12397-1-git-send-email-mwelling@ieee.org>
In-Reply-To: <1402017131-12397-1-git-send-email-mwelling@ieee.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 03:12 AM, Michael Welling wrote:
[...]
> +enum mcp49x2_supported_device_ids {
> +	ID_MCP4902,
> +	ID_MCP4912,
> +	ID_MCP4922,
> +};
> +
> +struct mcp49x2_state {
> +	struct spi_device *spi;
> +	unsigned int value[MCP49X2_NUM_CHANNELS];
> +	unsigned int power_mode[MCP49X2_NUM_CHANNELS];
> +	unsigned int vref_mv;
> +	struct regulator *vref_reg;
> +};
> +
> +#define MCP49X2_CHAN(chan, bits) {			\
> +	.type = IIO_VOLTAGE,				\
> +	.output = 1,					\
> +	.indexed = 1,					\
> +	.channel = chan,				\
> +	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),	\
> +	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
> +	.scan_type = IIO_ST('u', bits, 16, 12-bits),	\

The IIO_ST macro was removed a while ago, this will not compile with the 
latest IIO sources.

> +}
> +
> +static int mcp49x2_spi_write(struct spi_device *spi, u8 addr, u32 val)
> +{
> +	u8 mosi[2] ____cacheline_aligned;

It is also important that the transfer buffer is not on the stack and 
strictly speaking the buffer should also be allocated with GFP_DMA.

> +
> +	mosi[1] = val & 0xff;
> +	mosi[0] = (addr == 0) ? 0x00 : 0x80;
> +	mosi[0] |= 0x30 | ((val >> 8) & 0x0f);
> +
> +	return spi_write(spi, mosi, 2);
> +}
[...]
> +
> +static int mcp49x2_probe(struct spi_device *spi)
> +{
> +	struct iio_dev *indio_dev;
> +	struct mcp49x2_state *state;
> +	const struct spi_device_id *id;
> +	int ret;
> +
> +	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*state));
> +	if (indio_dev == NULL)
> +		return -ENOMEM;
> +
> +	state = iio_priv(indio_dev);
> +	state->spi = spi;
> +	state->vref_reg = devm_regulator_get(&spi->dev, "vref");
> +	if (!IS_ERR(state->vref_reg)) {
> +		ret = regulator_enable(state->vref_reg);
> +		if (ret) {
> +			dev_err(&spi->dev, "Failed to enable vref regulator: %d\n",
> +				ret);
> +			return ret;
> +		}
> +
> +		ret = regulator_get_voltage(state->vref_reg);
> +		if (ret < 0) {
> +			dev_err(&spi->dev, "Failed to read vref regulator: %d\n",
> +				ret);
> +			goto error_disable_reg;
> +		}
> +		state->vref_mv = ret / 1000;
> +	} else {
> +		dev_info(&spi->dev, "Vref regulator not specified assuming 2.5V\n");
> +		state->vref_mv = 2500;

This is not a good idea, unless there is a built-in vref with 2.5V. If that 
is the case use devm_regulator_get_optional() as devm_regulator_get() will 
return a dummy regulator if no regulator was specified for the device.

> +	}
> +
> +	spi_set_drvdata(spi, indio_dev);
> +	id = spi_get_device_id(spi);
> +	indio_dev->dev.parent = &spi->dev;
> +	indio_dev->info = &mcp49x2_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = mcp49x2_channels[id->driver_data];
> +	indio_dev->num_channels = MCP49X2_NUM_CHANNELS;
> +	indio_dev->name = id->name;
> +
> +	ret = devm_iio_device_register(&spi->dev, indio_dev);
> +	if (ret) {
> +		dev_err(&spi->dev, "Failed to register iio device: %d\n",
> +				ret);
> +		goto error_disable_reg;
> +	}
> +
> +	return 0;
> +
> +error_disable_reg:
> +	if (!IS_ERR(state->vref_reg))
> +		regulator_disable(state->vref_reg);
> +
> +	return ret;
> +}


