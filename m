Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaEZTuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:50:07 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:58785 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaEZTuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:50:03 -0400
Message-ID: <53839AE5.40401@yahoo.fr>
Date: Mon, 26 May 2014 21:49:57 +0200
From: trem <tremyfr@yahoo.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120623 Thunderbird/10.0.5
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>
CC: Philippe Reynes <tremyfr@yahoo.fr>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, armadeus-forum@lists.sourceforge.net,
        jic23@kernel.org
Subject: Re: [PATCH v2] iio: add support of the max1027
References: <1400621236-20423-1-git-send-email-tremyfr@yahoo.fr> <5382743E.5060600@gmx.de>
In-Reply-To: <5382743E.5060600@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hartmut,

First, thanks a lot for this feedback, I really appreciate it.


On 26/05/14 00:52, Hartmut Knaack wrote:
> Philippe Reynes schrieb:
>> This driver add partial support of the
>> maxim 1027/1029/1031. Differential mode is not
>> supported.
>>
>> It was tested on armadeus apf27 board.
>>
>> Signed-off-by: Philippe Reynes<tremyfr@yahoo.fr>
>> ---
>>   .../devicetree/bindings/iio/adc/max1027-adc.txt    |   21 +
>>   drivers/staging/iio/adc/Kconfig                    |    9 +
>>   drivers/staging/iio/adc/Makefile                   |    1 +
>>   drivers/staging/iio/adc/max1027.c                  |  553 ++++++++++++++++++++
>>   4 files changed, 584 insertions(+), 0 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
>>   create mode 100644 drivers/staging/iio/adc/max1027.c
>>
>> Changelog:
>> v2: (thanks Hartmut Knaack and Jonathan Cameron for the feedback)
>> - really use devm_*
>> - use demux magic
>> - use spi_read and spi_write (instead of spi_sync)
>> - use define for register (instead of hardcoded value)
>>
>> diff --git a/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt b/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
>> new file mode 100644
>> index 0000000..2e8b9f3
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
>> @@ -0,0 +1,21 @@
>> +* Maxim 1027/1029/1031 Analog to Digital Converter (ADC)
>> +
>> +Required properties:
>> +  - compatible: Should be "maxim,max1027" or "maxim,max1029" or "maxim,max1031"
>> +  - reg: Should contain the ADC SPI address
>> +  - interrupt-parent: the phandle for the gpio controller
>> +  - interrupts: (gpio) interrupt to which the chip is connected
>> +
>> +Example:
>> +adc@0 {
>> +	compatible = "maxim,max1027";
>> +	reg =<0>;
>> +	interrupt-parent =<&gpio5>;
>> +	interrupts =<15 IRQ_TYPE_EDGE_RISING>;
>> +	pinctrl-names = "default";
>> +	pinctrl-0 =<&pinctrl_max1027>;
>> +	/* SPI mode = 0 */
>> +	spi-cpol =<0>;
>> +	spi-cpha =<0>;
>> +	spi-max-frequency =<1000000>;
>> +};
>> diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
>> index 3633298..12a78eb 100644
>> --- a/drivers/staging/iio/adc/Kconfig
>> +++ b/drivers/staging/iio/adc/Kconfig
>> @@ -112,6 +112,15 @@ config LPC32XX_ADC
>>   	  activate only one via device tree selection.  Provides direct access
>>   	  via sysfs.
>>
>> +config MAX1027
>> +	tristate "Maxim max1027 ADC driver"
>> +	depends on SPI
>> +	select IIO_BUFFER
>> +	select IIO_TRIGGERED_BUFFER
>> +	help
>> +	  Say yes here to build support for Maxim SPI ADC models
>> +	  max1027, max1029 and max1031.
>> +
>>   config MXS_LRADC
>>   	tristate "Freescale i.MX23/i.MX28 LRADC"
>>   	depends on ARCH_MXS || COMPILE_TEST
>> diff --git a/drivers/staging/iio/adc/Makefile b/drivers/staging/iio/adc/Makefile
>> index 3e9fb14..22fbd0c 100644
>> --- a/drivers/staging/iio/adc/Makefile
>> +++ b/drivers/staging/iio/adc/Makefile
>> @@ -18,5 +18,6 @@ obj-$(CONFIG_AD7816) += ad7816.o
>>   obj-$(CONFIG_AD7192) += ad7192.o
>>   obj-$(CONFIG_AD7280) += ad7280a.o
>>   obj-$(CONFIG_LPC32XX_ADC) += lpc32xx_adc.o
>> +obj-$(CONFIG_MAX1027) += max1027.o
>>   obj-$(CONFIG_MXS_LRADC) += mxs-lradc.o
>>   obj-$(CONFIG_SPEAR_ADC) += spear_adc.o
>> diff --git a/drivers/staging/iio/adc/max1027.c b/drivers/staging/iio/adc/max1027.c
>> new file mode 100644
>> index 0000000..c2e5936
>> --- /dev/null
>> +++ b/drivers/staging/iio/adc/max1027.c
>> @@ -0,0 +1,553 @@
>> + /*
>> +  * iio/adc/max1027.c
>> +  * Copyright (C) 2014 Philippe Reynes
>> +  *
>> +  * based on linux/drivers/iio/ad7923.c
>> +  * Copyright 2011 Analog Devices Inc (from AD7923 Driver)
>> +  * Copyright 2012 CS Systemes d'Information
>> +  *
>> +  * This program is free software; you can redistribute it and/or modify
>> +  * it under the terms of the GNU General Public License version 2 as
>> +  * published by the Free Software Foundation.
>> +  *
>> +  * max1027.c
>> +  *
>> +  * Partial support for max1027 and similar chips.
>> +  */
>> +
>> +#include<linux/kernel.h>
>> +#include<linux/spi/spi.h>
>> +#include<linux/module.h>
>> +#include<linux/interrupt.h>
>> +#include<linux/mutex.h>
>> +#include<linux/of.h>
>> +#include<linux/of_gpio.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/delay.h>
>> +#include<linux/gpio.h>
>> +
>> +#include<linux/iio/iio.h>
>> +#include<linux/iio/buffer.h>
>> +#include<linux/iio/trigger.h>
>> +#include<linux/iio/trigger_consumer.h>
>> +#include<linux/iio/triggered_buffer.h>
>> +
>> +#define MAX1027_CONV_REG  0x80
>> +#define MAX1027_SETUP_REG 0x40
>> +#define MAX1027_AVG_REG   0x20
>> +#define MAX1027_RST_REG   0x10
>> +
>> +/* conversion register */
>> +#define MAX1027_TEMP      0x01
>> +#define MAX1027_SCAN_0_N  (0x00<<  1)
>> +#define MAX1027_SCAN_N_M  (0x01<<  1)
>> +#define MAX1027_SCAN_N    (0x02<<  1)
>> +#define MAX1027_NOSCAN    (0x03<<  1)
>> +#define MAX1027_CHAN(n)   ((n)<<  3)
>> +
>> +/* setup register */
>> +#define MAX1027_UNIPOLAR  0x02
>> +#define MAX1027_BIPOLAR   0x03
>> +#define MAX1027_REF_MODE0 (0x00<<  2)
>> +#define MAX1027_REF_MODE1 (0x01<<  2)
>> +#define MAX1027_REF_MODE2 (0x02<<  2)
>> +#define MAX1027_REF_MODE3 (0x03<<  2)
>> +#define MAX1027_CKS_MODE0 (0x00<<  4)
>> +#define MAX1027_CKS_MODE1 (0x01<<  4)
>> +#define MAX1027_CKS_MODE2 (0x02<<  4)
>> +#define MAX1027_CKS_MODE3 (0x03<<  4)
>> +
>> +/* averaging register */
>> +#define MAX1027_NSCAN_4   0x00
>> +#define MAX1027_NSCAN_8   0x01
>> +#define MAX1027_NSCAN_12  0x02
>> +#define MAX1027_NSCAN_16  0x03
>> +#define MAX1027_NAVG_4    (0x00<<  2)
>> +#define MAX1027_NAVG_8    (0x01<<  2)
>> +#define MAX1027_NAVG_12   (0x02<<  2)
>> +#define MAX1027_NAVG_16   (0x03<<  2)
> According to my datasheet (revision 5) [http://datasheets.maximintegrated.com/en/ds/MAX1027-MAX1031.pdf], there is no NAVG_12, but NAVG_16 (0x02<<  2) and NAVG_32 (0x03<<  2).

My datasheet has the same value, I'll fix this mistake in v3.

>> +#define MAX1027_AVG_EN    (0x01<<  4)
>> +
>> +enum max1027_id {
>> +	max1027,
>> +	max1029,
>> +	max1031,
>> +};
>> +
>> +static const struct spi_device_id max1027_id[] = {
>> +	{"max1027", max1027},
>> +	{"max1029", max1029},
>> +	{"max1031", max1031},
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(spi, max1027_id);
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id max1027_adc_dt_ids[] = {
>> +	{ .compatible = "maxim,max1027" },
>> +	{ .compatible = "maxim,max1029" },
>> +	{ .compatible = "maxim,max1031" },
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, max1027_adc_dt_ids);
>> +#endif
>> +
>> +#define MAX1027_V_CHAN(index)						\
>> +	{								\
>> +		.type = IIO_VOLTAGE,					\
>> +		.indexed = 1,						\
>> +		.channel = index,					\
>> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
>> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
>> +		.address = index,					\
>> +		.scan_index = index+1,					\
>> +		.scan_type = {						\
>> +			.sign = 'u',					\
>> +			.realbits = 10,					\
>> +			.storagebits = 16,				\
>> +			.shift = 2,					\
>> +			.endianness = IIO_BE,				\
>> +		},							\
>> +	}
>> +
>> +#define MAX1027_T_CHAN(index)						\
>> +	{								\
>> +		.type = IIO_TEMP,					\
>> +		.indexed = 0,						\
>> +		.channel = index,					\
>> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
>> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
>> +		.address = index,					\
>> +		.scan_index = index,					\
>> +		.scan_type = {						\
>> +			.sign = 'u',					\
>> +			.realbits = 12,					\
>> +			.storagebits = 16,				\
>> +			.endianness = IIO_BE,				\
>> +		},							\
>> +	}
>> +
>> +static const struct iio_chan_spec max1027_channels[] = {
>> +	MAX1027_T_CHAN(0),
>> +	MAX1027_V_CHAN(0),
>> +	MAX1027_V_CHAN(1),
>> +	MAX1027_V_CHAN(2),
>> +	MAX1027_V_CHAN(3),
>> +	MAX1027_V_CHAN(4),
>> +	MAX1027_V_CHAN(5),
>> +	MAX1027_V_CHAN(6),
>> +	MAX1027_V_CHAN(7)
>> +};
>> +
>> +static const struct iio_chan_spec max1029_channels[] = {
>> +	MAX1027_T_CHAN(0),
>> +	MAX1027_V_CHAN(0),
>> +	MAX1027_V_CHAN(1),
>> +	MAX1027_V_CHAN(2),
>> +	MAX1027_V_CHAN(3),
>> +	MAX1027_V_CHAN(4),
>> +	MAX1027_V_CHAN(5),
>> +	MAX1027_V_CHAN(6),
>> +	MAX1027_V_CHAN(7),
>> +	MAX1027_V_CHAN(8),
>> +	MAX1027_V_CHAN(9),
>> +	MAX1027_V_CHAN(10),
>> +	MAX1027_V_CHAN(11)
>> +};
>> +
>> +static const struct iio_chan_spec max1031_channels[] = {
>> +	MAX1027_T_CHAN(0),
>> +	MAX1027_V_CHAN(0),
>> +	MAX1027_V_CHAN(1),
>> +	MAX1027_V_CHAN(2),
>> +	MAX1027_V_CHAN(3),
>> +	MAX1027_V_CHAN(4),
>> +	MAX1027_V_CHAN(5),
>> +	MAX1027_V_CHAN(6),
>> +	MAX1027_V_CHAN(7),
>> +	MAX1027_V_CHAN(8),
>> +	MAX1027_V_CHAN(9),
>> +	MAX1027_V_CHAN(10),
>> +	MAX1027_V_CHAN(11),
>> +	MAX1027_V_CHAN(12),
>> +	MAX1027_V_CHAN(13),
>> +	MAX1027_V_CHAN(14),
>> +	MAX1027_V_CHAN(15)
>> +};
>> +
>> +static unsigned long max1027_available_scan_masks[] = {
>> +	0x00ff,
>> +	0x0000,
>> +};
>> +
>> +static unsigned long max1029_available_scan_masks[] = {
>> +	0x0fff,
>> +	0x0000,
>> +};
>> +
>> +static unsigned long max1031_available_scan_masks[] = {
>> +	0xffff,
>> +	0x0000,
>> +};
>> +
>> +struct max1027_chip_info {
>> +	const struct iio_chan_spec *channels;
>> +	unsigned int num_channels;
>> +	unsigned long *available_scan_masks;
>> +};
>> +
>> +static const struct max1027_chip_info max1027_chip_info_tbl[] = {
>> +	[max1027] = {
>> +		.channels = max1027_channels,
>> +		.num_channels = ARRAY_SIZE(max1027_channels),
>> +		.available_scan_masks = max1027_available_scan_masks,
>> +	},
>> +	[max1029] = {
>> +		.channels = max1029_channels,
>> +		.num_channels = ARRAY_SIZE(max1029_channels),
>> +		.available_scan_masks = max1029_available_scan_masks,
>> +	},
>> +	[max1031] = {
>> +		.channels = max1031_channels,
>> +		.num_channels = ARRAY_SIZE(max1031_channels),
>> +		.available_scan_masks = max1031_available_scan_masks,
>> +	},
>> +};
>> +
>> +struct max1027_state {
>> +	struct max1027_chip_info	*info;
>> +	struct spi_device		*spi;
>> +	struct iio_trigger		*trig;
>> +	unsigned short			*buffer;
> Better use u16 for buffer?

Yes, fixed in v3.

>> +};
>> +
>> +static int max1027_write_register(struct max1027_state *st, unsigned char reg)
>> +{
>> +	int ret;
>> +
>> +	pr_debug("%s(st = 0x%p, reg = 0x%02x)\n", __func__, st, reg);
>> +
>> +	ret = spi_write(st->spi, (void *)&reg, 1);
>> +	if (ret<  0)
>> +		pr_err("can't write register\n");
>> +
>> +	return ret;
>> +}
> As Jonathan pointed out, better get rid of those debug wrapper functions. Otherwise, think about using typedefs like u8 for 8 bit registers.

I've remove this function (and max10247_read_value) in v3.

>> +
>> +static int max1027_read_value(struct max1027_state *st, int len)
>> +{
>> +	int ret;
>> +
>> +	pr_debug("%s(st = 0x%p, len = %d)\n", __func__, st, len);
>> +
>> +	ret = spi_read(st->spi, st->buffer, len);
>> +	if (ret<  0)
>> +		pr_err("can't read value\n");
>> +
>> +	return ret;
>> +}
>> +
>> +static int max1027_read_single_value(struct iio_dev *indio_dev,
>> +				     struct iio_chan_spec const *chan,
>> +				     int *val, int *val2, long mask)
> val2 and mask are not used.

I'll remove it in v3.

>> +{
>> +	int ret;
>> +	unsigned char reg;
>> +	struct max1027_state *st = iio_priv(indio_dev);
>> +
>> +	if (iio_buffer_enabled(indio_dev)) {
>> +		dev_warn(&indio_dev->dev, "trigger mode already enabled");
>> +		return -EIO;
>> +	}
>> +
>> +	/* Start acquisition on conversion register write */
>> +	reg = MAX1027_SETUP_REG | MAX1027_REF_MODE2 | MAX1027_CKS_MODE2;
>> +	ret = max1027_write_register(st, reg);
>> +	if (ret<  0) {
>> +		dev_err(&indio_dev->dev,
>> +			"Failed to configure setup register\n");
>> +		return ret;
>> +	}
>> +
>> +	/* Configure conversion register with the requested chan */
>> +	reg = MAX1027_CONV_REG | MAX1027_CHAN(chan->channel)
>> +		| MAX1027_NOSCAN | !!(chan->type == IIO_TEMP);
>> +	ret = max1027_write_register(st, reg);
>> +	if (ret<  0) {
>> +		dev_err(&indio_dev->dev,
>> +			"Failed to configure conversion register\n");
>> +		return ret;
>> +	}
>> +
>> +	/*
>> +	 * For an unknown reason, when we use the mode "10" (write
>> +	 * conversion register), the it doesn't occur every time.
> I still don't understand this comment.

For an unknown reason, the max1027 on my armadeus apf27 don't raise
an it when I use the mode "10" (acquisition started on convertion write).
In fact, it's weird, there is an IT when I read temperature, but not
when I read a voltage.

# grep max /proc/interrupts
223:     110213  gpio-mxc  15  max1027
272:     110200  max1027-trigger


# cat /sys/bus/iio/devices/iio\:device0/in_voltage0_raw
2589
# grep max /proc/interrupts
223:     110213  gpio-mxc  15  max1027
272:     110200  max1027-trigger

# cat /sys/bus/iio/devices/iio\:device0/in_temp_raw
214
# grep max /proc/interrupts
223:     110214  gpio-mxc  15  max1027
272:     110200  max1027-trigger

So with mode "10", I use a delay of 1 ms.



>> +	 * So we just wait 1 ms.
>> +	 */
>> +	mdelay(1);
>> +
>> +	/* Read result */
>> +	ret = max1027_read_value(st, (chan->type == IIO_TEMP) ? 4 : 2);
> I guess I didn't have a look into the datasheet before, when reviewing this part, but could you point me to where it is stated, that temperature measurements take 4 bytes?

When the temperature is read, the voltage is also read. So 4 bytes need to be read in the FIFO,
2 for the temperature, 2 for the voltage.

This is described in the "Internal FIFO" paragraph.

>> +	if (ret<  0)
>> +		return ret;
>> +
>> +	*val = be16_to_cpu(st->buffer[0]);
>> +
>> +	return IIO_VAL_INT;
>> +}
>> +
>> +static int max1027_read_raw(struct iio_dev *indio_dev,
>> +			    struct iio_chan_spec const *chan,
>> +			    int *val, int *val2, long mask)
>> +{
>> +	int ret = 0;
>> +
>> +	switch (mask) {
>> +	case IIO_CHAN_INFO_RAW:
>> +		ret = max1027_read_single_value(indio_dev, chan,
>> +						val, val2, mask);
>> +		break;
>> +	case IIO_CHAN_INFO_SCALE:
>> +		switch (chan->type) {
>> +		case IIO_TEMP:
>> +			*val = 1;
>> +			*val2 = 8;
>> +			ret = IIO_VAL_FRACTIONAL;
>> +			break;
>> +		case IIO_VOLTAGE:
>> +			*val = 2500;
>> +			*val2 = 10;
>> +			ret = IIO_VAL_FRACTIONAL_LOG2;
>> +			break;
>> +		default:
>> +			ret = -EINVAL;
>> +			break;
>> +		};
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +		break;
>> +	};
>> +
>> +	return ret;
>> +}
>> +
>> +static int max1027_update_scan_mode(struct iio_dev *indio_dev,
>> +				    const unsigned long *scan_mask)
>> +{
>> +	pr_debug("%s(indio_dev=0x%p, scan_mask=0x%p)\n",
>> +		__func__, indio_dev, scan_mask);
>> +
>> +	return 0;
>> +}
>> +
>> +static int max1027_debugfs_reg_access(struct iio_dev *indio_dev,
>> +				  unsigned reg, unsigned writeval,
>> +				  unsigned *readval)
>> +{
>> +	struct max1027_state *st = iio_priv(indio_dev);
>> +
>> +	if (readval != NULL)
>> +		return -EINVAL;
>> +
>> +	return max1027_write_register(st, writeval);
>> +}
>> +
>> +static int max1027_set_trigger_state(struct iio_trigger *trig, bool state)
>> +{
>> +	struct iio_dev *indio_dev = iio_trigger_get_drvdata(trig);
>> +	struct max1027_state *st = iio_priv(indio_dev);
>> +	unsigned char reg;
>> +	int ret;
>> +
>> +	if (state) {
>> +		/* Start acquisition on cnvst */
>> +		reg = MAX1027_SETUP_REG | MAX1027_CKS_MODE0 | MAX1027_REF_MODE2;
>> +		ret = max1027_write_register(st, reg);
>> +		if (ret<  0)
>> +			return ret;
>> +
>> +		/* Scan from 0 to max */
>> +		reg = MAX1027_CONV_REG | MAX1027_CHAN(0)
>> +			| MAX1027_SCAN_N_M | MAX1027_TEMP;
>> +		ret = max1027_write_register(st, reg);
>> +		if (ret<  0)
>> +			return ret;
>> +	} else {
>> +		/* Start acquisition on conversion register write */
>> +		reg = MAX1027_SETUP_REG | MAX1027_REF_MODE2 | MAX1027_CKS_MODE2;
> Just for improved readability, keep the same order as above (MSB to LSB in your case).

You're right, it's better, I'll fix it in v3.

>> +		ret = max1027_write_register(st, reg);
>> +		if (ret<  0)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static irqreturn_t max1027_interrupt_handler(int irq, void *private)
>> +{
>> +	struct iio_dev *indio_dev = (struct iio_dev *)private;
>> +
>> +	pr_debug("%s(irq=%d, private=0x%p)\n", __func__, irq, private);
>> +
>> +	if (iio_buffer_enabled(indio_dev))
>> +		iio_trigger_poll(indio_dev->trig, iio_get_time_ns());
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static irqreturn_t max1027_trigger_handler(int irq, void *private)
>> +{
>> +	struct iio_poll_func *pf = (struct iio_poll_func *)private;
>> +	struct iio_dev *indio_dev = pf->indio_dev;
>> +	struct max1027_state *st = iio_priv(indio_dev);
>> +
>> +	pr_debug("%s(irq=%d, private=0x%p)\n", __func__, irq, private);
>> +
>> +	/* fill buffer with all channel */
>> +	max1027_read_value(st, indio_dev->masklength * 2);
>> +
>> +	iio_push_to_buffers_with_timestamp(indio_dev, st->buffer,
>> +					   iio_get_time_ns());
>> +
>> +	iio_trigger_notify_done(indio_dev->trig);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static const struct iio_trigger_ops max1027_trigger_ops = {
>> +	.owner = THIS_MODULE,
>> +	.set_trigger_state =&max1027_set_trigger_state,
>> +};
>> +
>> +static const struct iio_info max1027_info = {
>> +	.driver_module = THIS_MODULE,
>> +	.read_raw =&max1027_read_raw,
>> +	.update_scan_mode =&max1027_update_scan_mode,
>> +	.debugfs_reg_access =&max1027_debugfs_reg_access,
>> +};
>> +
>> +static int max1027_probe(struct spi_device *spi)
>> +{
>> +	int err;
>> +	struct iio_dev *indio_dev;
>> +	struct max1027_state *st;
>> +
>> +	pr_debug("%s: probe(spi = 0x%p)\n", __func__, spi);
>> +
>> +	/* allocate iio device */
>> +	indio_dev = devm_iio_device_alloc(&spi->dev,
>> +					  sizeof(struct max1027_state));
>> +	if (!indio_dev) {
>> +		pr_err("can't allocate iio device\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	spi_set_drvdata(spi, indio_dev);
>> +
>> +	st = iio_priv(indio_dev);
>> +	st->spi = spi;
>> +	st->buffer = NULL;
>> +	st->info = (struct max1027_chip_info *)
>> +		&max1027_chip_info_tbl[spi_get_device_id(spi)->driver_data];
>> +
>> +	/* request irq */
>> +	err = devm_request_threaded_irq(&spi->dev, spi->irq,
>> +					max1027_interrupt_handler,
>> +					NULL,
>> +					IRQF_TRIGGER_FALLING,
>> +					spi->dev.driver->name, indio_dev);
>> +	if (err) {
>> +		dev_err(&indio_dev->dev, "Failed to allocate IRQ.\n");
>> +		return err;
>> +	}
>> +
>> +	indio_dev->name = spi_get_device_id(spi)->name;
>> +	indio_dev->dev.parent =&spi->dev;
>> +	indio_dev->info =&max1027_info;
>> +	indio_dev->modes = INDIO_DIRECT_MODE;
>> +	indio_dev->channels = st->info->channels;
>> +	indio_dev->num_channels = st->info->num_channels;
>> +	indio_dev->available_scan_masks = st->info->available_scan_masks;
>> +
>> +	/* Allocate buffer (data) */
>> +	st->buffer = devm_kmalloc(&indio_dev->dev,
>> +				  indio_dev->num_channels * 2,
>> +				  GFP_KERNEL);
>> +	if (st->buffer == NULL) {
> As picky as I am, I could ask why you check for successful allocation in a different way than above for indio_dev ;-)

I don't really know, but I'll update it to always use the same way for the "post allocation check".
I'll update it in v3.

>> +		dev_err(&indio_dev->dev, "Can't allocate bufffer\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	/* Allocate buffer */
>> +	err = iio_triggered_buffer_setup(indio_dev,&iio_pollfunc_store_time,
>> +					&max1027_trigger_handler, NULL);
>> +	if (err<  0) {
>> +		dev_err(&indio_dev->dev, "Failed to setup buffer\n");
>> +		return err;
>> +	}
>> +
>> +	/* Allocate trigger */
>> +	st->trig = devm_iio_trigger_alloc(&spi->dev, "%s-trigger",
>> +							indio_dev->name);
>> +	if (st->trig == NULL) {
>> +		err = -ENOMEM;
>> +		dev_err(&indio_dev->dev, "Failed to allocate iio trigger\n");
>> +		goto fail_trigger_alloc;
>> +	}
>> +
>> +	/* configure and register trigger */
>> +	st->trig->ops =&max1027_trigger_ops;
>> +	st->trig->dev.parent =&spi->dev;
>> +	iio_trigger_set_drvdata(st->trig, indio_dev);
>> +	iio_trigger_register(st->trig);
>> +
>> +	/* Disable averaging */
>> +	err = max1027_write_register(st, MAX1027_AVG_REG);
>> +	if (err<  0) {
>> +		dev_err(&indio_dev->dev, "Failed to configure averaging register\n");
>> +		goto fail_dev_register;
>> +	}
>> +
>> +	/* Register the device */
>> +	err = iio_device_register(indio_dev);
>> +	if (err<  0) {
>> +		dev_err(&indio_dev->dev, "Failed to register iio device\n");
>> +		goto fail_dev_register;
>> +	}
>> +
>> +	return 0;
>> +
>> +fail_dev_register:
>> +fail_trigger_alloc:
>> +	iio_triggered_buffer_cleanup(indio_dev);
>> +
>> +	return err;
>> +}
>> +
>> +static int max1027_remove(struct spi_device *spi)
>> +{
>> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
>> +
>> +	pr_debug("%s: remove(spi = 0x%p)\n", __func__, spi);
>> +
>> +	iio_device_unregister(indio_dev);
>> +	iio_triggered_buffer_cleanup(indio_dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct spi_driver max1027_driver = {
>> +	.driver = {
>> +		.name	= "max1027",
>> +		.owner	= THIS_MODULE,
>> +	},
>> +	.probe		= max1027_probe,
>> +	.remove		= max1027_remove,
>> +	.id_table	= max1027_id,
>> +};
>> +module_spi_driver(max1027_driver);
>> +
>> +MODULE_AUTHOR("Philippe Reynes<tremyfr@yahoo.fr>");
>> +MODULE_DESCRIPTION("MAX1027/MAX1029/MAX1031 ADC");
>> +MODULE_LICENSE("GPL v2");
>
>

Best regards,
Philippe
