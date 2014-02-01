Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaBADM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:12:28 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:58806 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaBADMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:12:25 -0500
X-Auth-Info: RzkPH2A1CBcRuwjC8+0bNLxkenQP+5iyEqldawVXpKU=
From: Marek Vasut <marex@denx.de>
To: Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH 2/2] iio: Add AS3935 lightning sensor support
Date: Sat, 1 Feb 2014 04:12:24 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        matt.porter@linaro.org, koen@dominion.thruhere.net,
        pantelis.antoniou@gmail.com, Mark Brown <broonie@kernel.org>
References: <1391182703-2201-1-git-send-email-mranostay@gmail.com> <1391182703-2201-2-git-send-email-mranostay@gmail.com>
In-Reply-To: <1391182703-2201-2-git-send-email-mranostay@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201402010412.24434.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 31, 2014 at 04:38:23 PM, Matt Ranostay wrote:

[...]

> diff --git a/Documentation/devicetree/bindings/iio/distance/as3935.txt
> b/Documentation/devicetree/bindings/iio/distance/as3935.txt new file mode
> 100644
> index 0000000..af35827
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/distance/as3935.txt
> @@ -0,0 +1,25 @@
> +Austrian Microsystems AS3935 Franklin lightning sensor device driver
> +
> +Required properties:
> +	- compatible: must be "ams,as3935"
> +	- reg: SPI chip select number for the device
> +	- spi-max-frequency: Max SPI frequency to use
> +	- spi-cpha: SPI Mode 1
> +	- gpios: GPIO input of interrupt line from IRQ pin of AS3935 IC
> +
> +Optional properties:
> +	- ams,tune-cap: Calibration tuning capacitor stepping value 0 - 15.
> +	  Range of 0 to 120 pF, 8pF steps. This will require using the
> calibration +	  data from the manufacturer.
> +
> +
> +Example:
> +
> +		as3935@0 {
> +			compatible = "ams,as3935";
> +			reg = <0>;
> +			spi-max-frequency = <100000>;
> +			spi-cpha;
> +			ams,tune-cap = /bits/ 8 <10>;
> +			gpios = <&gpio1 16 10>;
> +		};

You should CC devicetree-discuss with new bindings! Such a grave flub ;-)

[...]

> +config AS3935
> +	tristate "AS3935 Franklin lightning sensor"
> +	select IIO_BUFFER
> +	select IIO_TRIGGERED_BUFFER
> +	depends on SPI
> +	help
> +	 If you say yes here you get support for the Austrian Microsystems
> +	 AS3935 lightning detection sensor.
> +
> +	 This driver can also be built as a module. If so, the module
> +	 will be called as3935

Fullstop's missing at the end of the above sentence .

[...]

> +#define AS3935_AFE_GAIN		0x00
> +#define AS3935_AFE_MASK		0x3F
> +#define AS3935_AFE_GAIN_MAX	0x1F
> +
> +#define AS3935_INT		0x03
> +#define AS3935_INT_MASK		0x07
> +#define AS3935_DATA		0x07
> +#define AS3935_DATA_MASK	0x1F
> +
> +#define AS3935_TUNE_CAP		0x08
> +#define AS3935_CALIBRATE	0x3D
> +
> +#define AS3935_WRITE_DATA	(0x1 << 15)
> +#define AS3935_READ_DATA	(0x1 << 14)
> +#define AS3935_ADDRESS(x)	(x << 8)

((x) << 8)

[...]

> +static int as3935_write(struct as3935_state *st,
> +				unsigned int reg,
> +				unsigned int val)
> +{
> +	u8 buf[2];
> +	int ret;
> +
> +	mutex_lock(&st->lock);

You don't need to protect the writes to buf[] with a mutex, since the buf[] is 
on stack here. Each thread will have it's own local copy of that. DTTO for $reg 
variable.

Actually, I think you don't even need mutex around all of the the SPI sync 
stuff. The SPI framework already has a mutex in it.

> +	buf[0] = AS3935_WRITE_DATA | AS3935_ADDRESS(reg) >> 8;
> +	buf[1] = val;
> +
> +	ret = spi_write(st->spi, (u8 *) &buf, 2);
> +	mutex_unlock(&st->lock);
> +
> +	return ret;
> +};
> +

[...]

> +static int as3935_read_raw(struct iio_dev *indio_dev,
> +			   struct iio_chan_spec const *chan,
> +			   int *val,
> +			   int *val2,
> +			   long m)
> +{
> +	struct as3935_state *st = iio_priv(indio_dev);
> +
> +	if (m == IIO_CHAN_INFO_RAW) {

if (m != IIO...)
 return -EINVAL;

... rest of the code ...

This will cut down on the depth of indent.

> +		int ret;
> +		*val2 = 0;
> +		ret = as3935_read(st, AS3935_DATA, val);
> +		if (ret)
> +			return ret;
> +		return IIO_VAL_INT;
> +	}
> +
> +	return -EINVAL;
> +}

[...]

> +#ifdef CONFIG_PM_SLEEP
> +static int as3935_suspend(struct spi_device *spi, pm_message_t msg)
> +{
> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> +	struct as3935_state *st = iio_priv(indio_dev);
> +	int val, ret;
> +
> +	ret = as3935_read(st, AS3935_AFE_GAIN, &val);
> +	if (ret)
> +		return ret;
> +	val |= 0x01;

What's this hexadecimal magic constant here?

> +
> +	return as3935_write(st, AS3935_AFE_GAIN, val);
> +}
> +
> +static int as3935_resume(struct spi_device *spi)
> +{
> +	struct iio_dev *indio_dev = spi_get_drvdata(spi);
> +	struct as3935_state *st = iio_priv(indio_dev);
> +	int val, ret;
> +
> +	ret = as3935_read(st, AS3935_AFE_GAIN, &val);
> +	if (ret)
> +		return ret;
> +	val &= ~1;

What's this decimal magic constant here?

> +	return as3935_write(st, AS3935_AFE_GAIN, val);
> +}
> +#else
> +#define as3935_suspend	NULL
> +#define as3935_resume	NULL
> +#endif
> +
> +static int as3935_probe(struct spi_device *spi)
> +{
> +	struct iio_dev *indio_dev;
> +	struct iio_trigger *trig;
> +	struct as3935_state *st;
> +	struct device_node *np = spi->dev.of_node;
> +	int gpio;
> +	int irq;
> +	int ret;
> +
> +	/* Grab the GPIO to use for lightning event interrupt */
> +	if (np)
> +		gpio = of_get_gpio(spi->dev.of_node, 0);
> +	else {
> +		dev_err(&spi->dev, "unable to get interrupt gpio\n");
> +		return -EINVAL;
> +	}

The logic is a bit weird here. Why don't you check this like so:

if (!np) {
 ... bail ...
}

gpio = ...

> +	/* GPIO event setup */
> +	ret = devm_gpio_request(&spi->dev, gpio, "as3935");
> +	if (ret) {
> +		dev_err(&spi->dev, "failed to request GPIO %u\n", gpio);
> +		return ret;
> +	}
> +
> +	ret = gpio_direction_input(gpio);
> +	if (ret) {
> +		dev_err(&spi->dev, "failed to set pin direction\n");
> +		return -EINVAL;
> +	}
> +
> +	/* IRQ setup */
> +	irq = gpio_to_irq(gpio);
> +	if (irq < 0) {
> +		dev_err(&spi->dev, "failed to map GPIO to IRQ: %d\n", irq);
> +		return -EINVAL;
> +	}
> +
> +	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(st));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	st = iio_priv(indio_dev);
> +	st->spi = spi;
> +	st->tune_cap = 0;
> +	spi_set_drvdata(spi, indio_dev);
> +	mutex_init(&st->lock);
> +	INIT_DELAYED_WORK(&st->work, as3935_event_work);
> +
> +	of_property_read_u8(np, "ams,tune-cap", &st->tune_cap);

This can fail, check the retval please.

> +	if (st->tune_cap > 15) {
> +		dev_err(&spi->dev,
> +			"wrong tune_cap setting of %d\n", st->tune_cap);
> +		return -EINVAL;
> +	}

[...]

> +
> +MODULE_AUTHOR("Matt Ranostay <mranostay@gmail.com>");
> +MODULE_DESCRIPTION("AS3935 lightning sensor");
> +MODULE_LICENSE("GPL");

MODULE_ALIAS() is missing , no?
