Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaFNNxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:53:01 -0400
Received: from mout.gmx.net ([212.227.15.18]:63806 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbaFNNw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:52:59 -0400
Message-ID: <539C53AD.4020504@gmx.de>
Date: Sat, 14 Jun 2014 15:52:45 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26
MIME-Version: 1.0
To: Philippe Reynes <tremyfr@yahoo.fr>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, armadeus-forum@lists.sourceforge.net,
        jic23@kernel.org, lars@metafoo.de, devicetree@vger.kernel.org,
        pmeerw@pmeerw.net
Subject: Re: [PATCH v6] iio: add support of the max1027
References: <1402148312-22663-1-git-send-email-tremyfr@yahoo.fr>
In-Reply-To: <1402148312-22663-1-git-send-email-tremyfr@yahoo.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:QOqcchmVPNj39+oTpRMfKpswRlcr3OhWJCcfuG1eP6mAA04WsWO
 ech5MEQD0UX043KVjJfGkEt8ppuYFaMHPvt7eurGhpLerTYsBpbBt2mU8o8ZOqO2Yx3y32F
 jRNWlxGTfpRTiPEXSibIBsenk5DCU+AsWrB0rkPbfBHxfwTKhsdKVtekShxaTQXWJNa4OyQ
 fQTjrxZBkSYE+WhFwlXtA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe Reynes schrieb:
> This driver add partial support of the
> maxim 1027/1029/1031. Differential mode is not
> supported.
>
> It was tested on armadeus apf27 board.
>
> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
> ---
>  .../devicetree/bindings/iio/adc/max1027-adc.txt    |   22 +
>  drivers/iio/adc/Kconfig                            |    9 +
>  drivers/iio/adc/Makefile                           |    1 +
>  drivers/iio/adc/max1027.c                          |  522 ++++++++++++++++++++
>  4 files changed, 554 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
>  create mode 100644 drivers/iio/adc/max1027.c
>
> Changelog:
> v6: (thanks Peter Meerwald for the feedback)
> - dont use index with temperature
> - use const on scan mask
> - use __be16 * for buffer
> - return -EBUSY if trigger is already running
> - replace it by interrupt in comment
> - dont finish case with ";"
> - use iio_push_to_buffers
> - remove useless initialization of st->buffer
> - remove useless obvious comment
>
> v5: (thanks Jonathan Cameron for the feedback)
> - add validate_trigger
> - add validate_device
> - remove useless (void *) cast
> - use allocated buffer for spi_write
>
> v4: (thanks Jonathan Cameron for the feedback)
> - use iio_trigger_generic_data_rdy_poll
>
> v3: (thanks Hartmut Knaack, Lars-Peter Clausen and Jonathan Cameron for the feedback)
> - move to drivers/iio/adc (was in staging)
> - clean binding doc
> - drop empty update_scan_mode callback
> - add a lock around single channel read code
> - remove useless wrappers around spi_write and spi_read
> - fix available scan mask (a bit was missing)
> - remove useless header
> - some others little cleanp
>
> v2: (thanks Hartmut Knaack and Jonathan Cameron for the feedback)
> - really use devm_* 
> - use demux magic
> - use spi_read and spi_write (instead of spi_sync)
> - use define for register (instead of hardcoded value)
>
> diff --git a/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt b/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
> new file mode 100644
> index 0000000..a8770cc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
> @@ -0,0 +1,22 @@
> +* Maxim 1027/1029/1031 Analog to Digital Converter (ADC)
> +
> +Required properties:
> +  - compatible: Should be "maxim,max1027" or "maxim,max1029" or "maxim,max1031"
> +  - reg: SPI chip select number for the device
> +  - interrupt-parent: phandle to the parent interrupt controller
> +  see: Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> +  - interrupts: IRQ line for the ADC
> +  see: Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> +
> +Recommended properties:
> +- spi-max-frequency: Definition as per
> +                     Documentation/devicetree/bindings/spi/spi-bus.txt
> +
> +Example:
> +adc@0 {
> +	compatible = "maxim,max1027";
> +	reg = <0>;
> +	interrupt-parent = <&gpio5>;
> +	interrupts = <15 IRQ_TYPE_EDGE_RISING>;
> +	spi-max-frequency = <1000000>;
> +};
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 24c28e3..517f886 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -119,6 +119,15 @@ config LP8788_ADC
>  	help
>  	  Say yes here to build support for TI LP8788 ADC.
>  
> +config MAX1027
> +	tristate "Maxim max1027 ADC driver"
> +	depends on SPI
> +	select IIO_BUFFER
> +	select IIO_TRIGGERED_BUFFER
> +	help
> +	  Say yes here to build support for Maxim SPI ADC models
> +	  max1027, max1029 and max1031.
> +
>  config MAX1363
>  	tristate "Maxim max1363 ADC driver"
>  	depends on I2C
> diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> index ab346d8..daac784 100644
> --- a/drivers/iio/adc/Makefile
> +++ b/drivers/iio/adc/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_AD7887) += ad7887.o
>  obj-$(CONFIG_AT91_ADC) += at91_adc.o
>  obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
>  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
> +obj-$(CONFIG_MAX1027) += max1027.o
>  obj-$(CONFIG_MAX1363) += max1363.o
>  obj-$(CONFIG_MCP320X) += mcp320x.o
>  obj-$(CONFIG_MCP3422) += mcp3422.o
> diff --git a/drivers/iio/adc/max1027.c b/drivers/iio/adc/max1027.c
> new file mode 100644
> index 0000000..92d6c7f
> --- /dev/null
> +++ b/drivers/iio/adc/max1027.c
> @@ -0,0 +1,522 @@
> + /*
> +  * iio/adc/max1027.c
> +  * Copyright (C) 2014 Philippe Reynes
> +  *
> +  * based on linux/drivers/iio/ad7923.c
> +  * Copyright 2011 Analog Devices Inc (from AD7923 Driver)
> +  * Copyright 2012 CS Systemes d'Information
> +  *
> +  * This program is free software; you can redistribute it and/or modify
> +  * it under the terms of the GNU General Public License version 2 as
> +  * published by the Free Software Foundation.
> +  *
> +  * max1027.c
> +  *
> +  * Partial support for max1027 and similar chips.
> +  */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spi/spi.h>
> +#include <linux/delay.h>
> +
> +#include <linux/iio/iio.h>
> +#include <linux/iio/buffer.h>
> +#include <linux/iio/trigger.h>
> +#include <linux/iio/trigger_consumer.h>
> +#include <linux/iio/triggered_buffer.h>
> +
We had some tendency on the list lately to include bitops.h and use BIT(n) instead of 1 << n. Jonathan, is it "planned" to switch to that style for the whole IIO subsystem? If so, it would safe some cleanup to implement it already in new drivers.
> +#define MAX1027_CONV_REG  0x80
> +#define MAX1027_SETUP_REG 0x40
> +#define MAX1027_AVG_REG   0x20
> +#define MAX1027_RST_REG   0x10
> +
> +/* conversion register */
> +#define MAX1027_TEMP      0x01
> +#define MAX1027_SCAN_0_N  (0x00 << 1)
> +#define MAX1027_SCAN_N_M  (0x01 << 1)
> +#define MAX1027_SCAN_N    (0x02 << 1)
> +#define MAX1027_NOSCAN    (0x03 << 1)
> +#define MAX1027_CHAN(n)   ((n) << 3)
> +
> +/* setup register */
> +#define MAX1027_UNIPOLAR  0x02
> +#define MAX1027_BIPOLAR   0x03
> +#define MAX1027_REF_MODE0 (0x00 << 2)
> +#define MAX1027_REF_MODE1 (0x01 << 2)
> +#define MAX1027_REF_MODE2 (0x02 << 2)
> +#define MAX1027_REF_MODE3 (0x03 << 2)
> +#define MAX1027_CKS_MODE0 (0x00 << 4)
> +#define MAX1027_CKS_MODE1 (0x01 << 4)
> +#define MAX1027_CKS_MODE2 (0x02 << 4)
> +#define MAX1027_CKS_MODE3 (0x03 << 4)
> +
> +/* averaging register */
> +#define MAX1027_NSCAN_4   0x00
> +#define MAX1027_NSCAN_8   0x01
> +#define MAX1027_NSCAN_12  0x02
> +#define MAX1027_NSCAN_16  0x03
> +#define MAX1027_NAVG_4    (0x00 << 2)
> +#define MAX1027_NAVG_8    (0x01 << 2)
> +#define MAX1027_NAVG_16   (0x02 << 2)
> +#define MAX1027_NAVG_32   (0x03 << 2)
> +#define MAX1027_AVG_EN    (0x01 << 4)
> +
> +enum max1027_id {
> +	max1027,
> +	max1029,
> +	max1031,
> +};
> +
> +static const struct spi_device_id max1027_id[] = {
> +	{"max1027", max1027},
> +	{"max1029", max1029},
> +	{"max1031", max1031},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(spi, max1027_id);
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id max1027_adc_dt_ids[] = {
> +	{ .compatible = "maxim,max1027" },
> +	{ .compatible = "maxim,max1029" },
> +	{ .compatible = "maxim,max1031" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, max1027_adc_dt_ids);
> +#endif
> +
> +#define MAX1027_V_CHAN(index)						\
> +	{								\
> +		.type = IIO_VOLTAGE,					\
> +		.indexed = 1,						\
> +		.channel = index,					\
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
> +		.scan_index = index+1,					\
Separate operators with whitespaces.
> +		.scan_type = {						\
> +			.sign = 'u',					\
> +			.realbits = 10,					\
> +			.storagebits = 16,				\
> +			.shift = 2,					\
> +			.endianness = IIO_BE,				\
> +		},							\
> +	}
> +
> +#define MAX1027_T_CHAN							\
> +	{								\
> +		.type = IIO_TEMP,					\
> +		.channel = 0,						\
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
> +		.scan_index = 0,					\
> +		.scan_type = {						\
> +			.sign = 'u',					\
> +			.realbits = 12,					\
> +			.storagebits = 16,				\
> +			.endianness = IIO_BE,				\
> +		},							\
> +	}
> +
> +static const struct iio_chan_spec max1027_channels[] = {
> +	MAX1027_T_CHAN,
> +	MAX1027_V_CHAN(0),
> +	MAX1027_V_CHAN(1),
> +	MAX1027_V_CHAN(2),
> +	MAX1027_V_CHAN(3),
> +	MAX1027_V_CHAN(4),
> +	MAX1027_V_CHAN(5),
> +	MAX1027_V_CHAN(6),
> +	MAX1027_V_CHAN(7)
> +};
> +
> +static const struct iio_chan_spec max1029_channels[] = {
> +	MAX1027_T_CHAN,
> +	MAX1027_V_CHAN(0),
> +	MAX1027_V_CHAN(1),
> +	MAX1027_V_CHAN(2),
> +	MAX1027_V_CHAN(3),
> +	MAX1027_V_CHAN(4),
> +	MAX1027_V_CHAN(5),
> +	MAX1027_V_CHAN(6),
> +	MAX1027_V_CHAN(7),
> +	MAX1027_V_CHAN(8),
> +	MAX1027_V_CHAN(9),
> +	MAX1027_V_CHAN(10),
> +	MAX1027_V_CHAN(11)
> +};
> +
> +static const struct iio_chan_spec max1031_channels[] = {
> +	MAX1027_T_CHAN,
> +	MAX1027_V_CHAN(0),
> +	MAX1027_V_CHAN(1),
> +	MAX1027_V_CHAN(2),
> +	MAX1027_V_CHAN(3),
> +	MAX1027_V_CHAN(4),
> +	MAX1027_V_CHAN(5),
> +	MAX1027_V_CHAN(6),
> +	MAX1027_V_CHAN(7),
> +	MAX1027_V_CHAN(8),
> +	MAX1027_V_CHAN(9),
> +	MAX1027_V_CHAN(10),
> +	MAX1027_V_CHAN(11),
> +	MAX1027_V_CHAN(12),
> +	MAX1027_V_CHAN(13),
> +	MAX1027_V_CHAN(14),
> +	MAX1027_V_CHAN(15)
> +};
> +
> +static const unsigned long max1027_available_scan_masks[] = {
> +	0x000001ff,
> +	0x00000000,
> +};
> +
> +static const unsigned long max1029_available_scan_masks[] = {
> +	0x00001fff,
> +	0x00000000,
> +};
> +
> +static const unsigned long max1031_available_scan_masks[] = {
> +	0x0001ffff,
> +	0x00000000,
> +};
> +
> +struct max1027_chip_info {
> +	const struct iio_chan_spec *channels;
> +	unsigned int num_channels;
> +	const unsigned long *available_scan_masks;
> +};
> +
> +static const struct max1027_chip_info max1027_chip_info_tbl[] = {
> +	[max1027] = {
> +		.channels = max1027_channels,
> +		.num_channels = ARRAY_SIZE(max1027_channels),
> +		.available_scan_masks = max1027_available_scan_masks,
> +	},
> +	[max1029] = {
> +		.channels = max1029_channels,
> +		.num_channels = ARRAY_SIZE(max1029_channels),
> +		.available_scan_masks = max1029_available_scan_masks,
> +	},
> +	[max1031] = {
> +		.channels = max1031_channels,
> +		.num_channels = ARRAY_SIZE(max1031_channels),
> +		.available_scan_masks = max1031_available_scan_masks,
> +	},
> +};
> +
> +struct max1027_state {
> +	struct max1027_chip_info	*info;
> +	struct spi_device		*spi;
> +	struct iio_trigger		*trig;
> +	__be16				*buffer;
> +	struct mutex			lock;
> +};
> +
> +static int max1027_read_single_value(struct iio_dev *indio_dev,
> +				     struct iio_chan_spec const *chan,
> +				     int *val)
> +{
> +	int ret;
> +	struct max1027_state *st = iio_priv(indio_dev);
> +	unsigned char *reg = (unsigned char *)st->buffer;
> +
> +	if (iio_buffer_enabled(indio_dev)) {
> +		dev_warn(&indio_dev->dev, "trigger mode already enabled");
> +		return -EBUSY;
> +	}
> +
> +	/* Start acquisition on conversion register write */
> +	*reg = MAX1027_SETUP_REG | MAX1027_REF_MODE2 | MAX1027_CKS_MODE2;
> +	ret = spi_write(st->spi, reg, 1);
> +	if (ret < 0) {
> +		dev_err(&indio_dev->dev,
> +			"Failed to configure setup register\n");
> +		return ret;
> +	}
> +
> +	/* Configure conversion register with the requested chan */
> +	*reg = MAX1027_CONV_REG | MAX1027_CHAN(chan->channel)
> +		| MAX1027_NOSCAN | !!(chan->type == IIO_TEMP);
> +	ret = spi_write(st->spi, reg, 1);
> +	if (ret < 0) {
> +		dev_err(&indio_dev->dev,
> +			"Failed to configure conversion register\n");
> +		return ret;
> +	}
> +
> +	/*
> +	 * For an unknown reason, when we use the mode "10" (write
> +	 * conversion register), the interrupt doesn't occur every time.
> +	 * So we just wait 1 ms.
> +	 */
> +	mdelay(1);
> +
> +	/* Read result */
> +	ret = spi_read(st->spi, st->buffer, (chan->type == IIO_TEMP) ? 4 : 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	*val = be16_to_cpu(st->buffer[0]);
> +
> +	return IIO_VAL_INT;
> +}
> +
> +static int max1027_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val, int *val2, long mask)
> +{
> +	int ret = 0;
> +	struct max1027_state *st = iio_priv(indio_dev);
> +
> +	mutex_lock(&st->lock);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_RAW:
> +		ret = max1027_read_single_value(indio_dev, chan, val);
> +		break;
> +	case IIO_CHAN_INFO_SCALE:
> +		switch (chan->type) {
> +		case IIO_TEMP:
> +			*val = 1;
> +			*val2 = 8;
> +			ret = IIO_VAL_FRACTIONAL;
> +			break;
> +		case IIO_VOLTAGE:
> +			*val = 2500;
> +			*val2 = 10;
> +			ret = IIO_VAL_FRACTIONAL_LOG2;
> +			break;
> +		default:
> +			ret = -EINVAL;
> +			break;
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	mutex_unlock(&st->lock);
> +
> +	return ret;
> +}
> +
> +static int max1027_debugfs_reg_access(struct iio_dev *indio_dev,
> +				      unsigned reg, unsigned writeval,
> +				      unsigned *readval)
> +{
> +	struct max1027_state *st = iio_priv(indio_dev);
> +	unsigned char *val = (unsigned char *)st->buffer;
> +
> +	if (readval != NULL)
> +		return -EINVAL;
> +
> +	*val = (unsigned char)writeval;
> +	return spi_write(st->spi, val, 1);
> +}
> +
> +static int max1027_validate_trigger(struct iio_dev *indio_dev,
> +				    struct iio_trigger *trig)
> +{
> +	struct max1027_state *st = iio_priv(indio_dev);
> +
> +	if (st->trig != trig)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int max1027_set_trigger_state(struct iio_trigger *trig, bool state)
> +{
> +	struct iio_dev *indio_dev = iio_trigger_get_drvdata(trig);
> +	struct max1027_state *st = iio_priv(indio_dev);
> +	unsigned char *reg = (unsigned char *)st->buffer;
> +	int ret;
> +
> +	if (state) {
> +		/* Start acquisition on cnvst */
> +		*reg = MAX1027_SETUP_REG|MAX1027_CKS_MODE0|MAX1027_REF_MODE2;
Also put some a whitespace around operators here.
> +		ret = spi_write(st->spi, reg, 1);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Scan from 0 to max */
> +		*reg = MAX1027_CONV_REG | MAX1027_CHAN(0)
> +			| MAX1027_SCAN_N_M | MAX1027_TEMP;
> +		ret = spi_write(st->spi, reg, 1);
> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		/* Start acquisition on conversion register write */
> +		*reg = MAX1027_SETUP_REG|MAX1027_CKS_MODE2|MAX1027_REF_MODE2;
And here as well.
> +		ret = spi_write(st->spi, reg, 1);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int max1027_validate_device(struct iio_trigger *trig,
> +				   struct iio_dev *indio_dev)
> +{
> +	struct iio_dev *indio = iio_trigger_get_drvdata(trig);
> +
> +	if (indio != indio_dev)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static irqreturn_t max1027_trigger_handler(int irq, void *private)
> +{
> +	struct iio_poll_func *pf = (struct iio_poll_func *)private;
> +	struct iio_dev *indio_dev = pf->indio_dev;
> +	struct max1027_state *st = iio_priv(indio_dev);
> +
> +	pr_debug("%s(irq=%d, private=0x%p)\n", __func__, irq, private);
> +
> +	/* fill buffer with all channel */
> +	spi_read(st->spi, st->buffer, indio_dev->masklength * 2);
> +
> +	iio_push_to_buffers(indio_dev, st->buffer);
> +
> +	iio_trigger_notify_done(indio_dev->trig);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static const struct iio_trigger_ops max1027_trigger_ops = {
> +	.owner = THIS_MODULE,
> +	.validate_device = &max1027_validate_device,
> +	.set_trigger_state = &max1027_set_trigger_state,
> +};
> +
> +static const struct iio_info max1027_info = {
> +	.driver_module = THIS_MODULE,
> +	.read_raw = &max1027_read_raw,
> +	.validate_trigger = &max1027_validate_trigger,
> +	.debugfs_reg_access = &max1027_debugfs_reg_access,
> +};
> +
> +static int max1027_probe(struct spi_device *spi)
> +{
> +	int err;
After calling your error/return value ret before, it would be more consistent to do the same here.
> +	unsigned char *reg;
> +	struct iio_dev *indio_dev;
> +	struct max1027_state *st;
> +
> +	pr_debug("%s: probe(spi = 0x%p)\n", __func__, spi);
> +
> +	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*st));
> +	if (indio_dev == NULL) {
> +		pr_err("can't allocate iio device\n");
Start sentence with capital letter.
> +		return -ENOMEM;
> +	}
> +
> +	spi_set_drvdata(spi, indio_dev);
> +
> +	st = iio_priv(indio_dev);
> +	st->spi = spi;
> +	st->info = (struct max1027_chip_info *)
> +		&max1027_chip_info_tbl[spi_get_device_id(spi)->driver_data];
> +
> +	mutex_init(&st->lock);
> +
> +	indio_dev->name = spi_get_device_id(spi)->name;
> +	indio_dev->dev.parent = &spi->dev;
> +	indio_dev->info = &max1027_info;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->channels = st->info->channels;
> +	indio_dev->num_channels = st->info->num_channels;
> +	indio_dev->available_scan_masks = st->info->available_scan_masks;
> +
> +	st->buffer = devm_kmalloc(&indio_dev->dev,
> +				  indio_dev->num_channels * 2,
> +				  GFP_KERNEL);
> +	if (st->buffer == NULL) {
> +		dev_err(&indio_dev->dev, "Can't allocate bufffer\n");
> +		return -ENOMEM;
> +	}
> +
> +	err = iio_triggered_buffer_setup(indio_dev, &iio_pollfunc_store_time,
> +					 &max1027_trigger_handler, NULL);
> +	if (err < 0) {
> +		dev_err(&indio_dev->dev, "Failed to setup buffer\n");
> +		return err;
> +	}
> +
> +	st->trig = devm_iio_trigger_alloc(&spi->dev, "%s-trigger",
> +							indio_dev->name);
> +	if (st->trig == NULL) {
> +		err = -ENOMEM;
> +		dev_err(&indio_dev->dev, "Failed to allocate iio trigger\n");
> +		goto fail_trigger_alloc;
> +	}
> +
> +	st->trig->ops = &max1027_trigger_ops;
> +	st->trig->dev.parent = &spi->dev;
> +	iio_trigger_set_drvdata(st->trig, indio_dev);
> +	iio_trigger_register(st->trig);
> +
> +	err = devm_request_threaded_irq(&spi->dev, spi->irq,
> +					iio_trigger_generic_data_rdy_poll,
> +					NULL,
> +					IRQF_TRIGGER_FALLING,
> +					spi->dev.driver->name, st->trig);
> +	if (err < 0) {
> +		dev_err(&indio_dev->dev, "Failed to allocate IRQ.\n");
> +		goto fail_dev_register;
> +	}
> +
> +	/* Disable averaging */
> +	reg = (unsigned char *)st->buffer;
> +	*reg = MAX1027_AVG_REG;
What is your intention here? Why not define reg independently as u8 (or unsigned char, if it really has to be) and set your desired value?
> +	err = spi_write(st->spi, reg, 1);
> +	if (err < 0) {
> +		dev_err(&indio_dev->dev, "Failed to configure averaging register\n");
> +		goto fail_dev_register;
> +	}
> +
> +	err = iio_device_register(indio_dev);
> +	if (err < 0) {
> +		dev_err(&indio_dev->dev, "Failed to register iio device\n");
> +		goto fail_dev_register;
> +	}
> +
> +	return 0;
> +
> +fail_dev_register:
> +fail_trigger_alloc:
> +	iio_triggered_buffer_cleanup(indio_dev);
> +
> +	return err;
> +}
> +
> +static int max1027_remove(struct spi_device *spi)
> +{
> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> +
> +	pr_debug("%s: remove(spi = 0x%p)\n", __func__, spi);
> +
> +	iio_device_unregister(indio_dev);
> +	iio_triggered_buffer_cleanup(indio_dev);
> +
> +	return 0;
> +}
> +
> +static struct spi_driver max1027_driver = {
> +	.driver = {
> +		.name	= "max1027",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= max1027_probe,
> +	.remove		= max1027_remove,
> +	.id_table	= max1027_id,
> +};
> +module_spi_driver(max1027_driver);
> +
> +MODULE_AUTHOR("Philippe Reynes <tremyfr@yahoo.fr>");
> +MODULE_DESCRIPTION("MAX1027/MAX1029/MAX1031 ADC");
> +MODULE_LICENSE("GPL v2");

