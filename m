Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab3GVRz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:55:26 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44436 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab3GVRzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:55:24 -0400
Message-ID: <51ED8015.70406@kernel.org>
Date: Mon, 22 Jul 2013 19:55:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oleksandr Kravchenko <x0199363@ti.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, jic23@cam.ac.uk,
        pmeerw@pmeerw.net, holler@ahsoftware.de, srinivas.pandruvada@intel.com,
        devicetree-discuss@lists.ozlabs.org, grygorii.strashko@ti.com,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: Re: [PATCH v3 2/2] iio: add APDS9300 ambilent light sensor driver
References: <1374498688-24701-1-git-send-email-x0199363@ti.com> <1374498688-24701-2-git-send-email-x0199363@ti.com>
In-Reply-To: <1374498688-24701-2-git-send-email-x0199363@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/13 14:11, Oleksandr Kravchenko wrote:
> From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
>
> This patch adds IIO driver for APDS9300 ambient light sensor (ALS).
> http://www.avagotech.com/docs/AV02-1077EN
>
> The driver allows to read raw data from ADC registers or calculate
> lux value. It also can handle threshold interrupt.
>
> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Excellent.

Applied to the togreg branch of iio.git .

Thanks
> ---
>  .../devicetree/bindings/iio/light/apds9300.txt     |   22 +
>  drivers/iio/light/Kconfig                          |   10 +
>  drivers/iio/light/Makefile                         |    1 +
>  drivers/iio/light/apds9300.c                       |  512 ++++++++++++++++++++
>  4 files changed, 545 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/light/apds9300.txt
>  create mode 100644 drivers/iio/light/apds9300.c
>
> diff --git a/Documentation/devicetree/bindings/iio/light/apds9300.txt b/Documentation/devicetree/bindings/iio/light/apds9300.txt
> new file mode 100644
> index 0000000..d6f66c7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/light/apds9300.txt
> @@ -0,0 +1,22 @@
> +* Avago APDS9300 ambient light sensor
> +
> +http://www.avagotech.com/docs/AV02-1077EN
> +
> +Required properties:
> +
> +  - compatible : should be "avago,apds9300"
> +  - reg : the I2C address of the sensor
> +
> +Optional properties:
> +
> +  - interrupt-parent : should be the phandle for the interrupt controller
> +  - interrupts : interrupt mapping for GPIO IRQ
> +
> +Example:
> +
> +apds9300@39 {
> +	compatible = "avago,apds9300";
> +	reg = <0x39>;
> +	interrupt-parent = <&gpio2>;
> +	interrupts = <29 8>;
> +};
> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
> index 5ef1a39..fb6af1b 100644
> --- a/drivers/iio/light/Kconfig
> +++ b/drivers/iio/light/Kconfig
> @@ -15,6 +15,16 @@ config ADJD_S311
>  	 This driver can also be built as a module.  If so, the module
>  	 will be called adjd_s311.
>
> +config APDS9300
> +	tristate "APDS9300 ambient light sensor"
> +	depends on I2C
> +	help
> +	 Say Y here if you want to build a driver for the Avago APDS9300
> +	 ambient light sensor.
> +
> +	 To compile this driver as a module, choose M here: the
> +	 module will be called apds9300.
> +
>  config SENSORS_LM3533
>  	tristate "LM3533 ambient light sensor"
>  	depends on MFD_LM3533
> diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
> index 040d9c7..da58e12 100644
> --- a/drivers/iio/light/Makefile
> +++ b/drivers/iio/light/Makefile
> @@ -6,4 +6,5 @@ obj-$(CONFIG_ADJD_S311)		+= adjd_s311.o
>  obj-$(CONFIG_SENSORS_LM3533)	+= lm3533-als.o
>  obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>  obj-$(CONFIG_VCNL4000)		+= vcnl4000.o
> +obj-$(CONFIG_APDS9300)		+= apds9300.o
>  obj-$(CONFIG_HID_SENSOR_ALS)	+= hid-sensor-als.o
> diff --git a/drivers/iio/light/apds9300.c b/drivers/iio/light/apds9300.c
> new file mode 100644
> index 0000000..66a58bd
> --- /dev/null
> +++ b/drivers/iio/light/apds9300.c
> @@ -0,0 +1,512 @@
> +/*
> + * apds9300.c - IIO driver for Avago APDS9300 ambient light sensor
> + *
> + * Copyright 2013 Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> + *
> + * This file is subject to the terms and conditions of version 2 of
> + * the GNU General Public License.  See the file COPYING in the main
> + * directory of this archive for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/pm.h>
> +#include <linux/i2c.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/interrupt.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/sysfs.h>
> +#include <linux/iio/events.h>
> +
> +#define APDS9300_DRV_NAME "apds9300"
> +#define APDS9300_IRQ_NAME "apds9300_event"
> +
> +/* Command register bits */
> +#define APDS9300_CMD	BIT(7) /* Select command register. Must write as 1 */
> +#define APDS9300_WORD	BIT(5) /* I2C write/read: if 1 word, if 0 byte */
> +#define APDS9300_CLEAR	BIT(6) /* Interrupt clear. Clears pending interrupt */
> +
> +/* Register set */
> +#define APDS9300_CONTROL	0x00 /* Control of basic functions */
> +#define APDS9300_THRESHLOWLOW	0x02 /* Low byte of low interrupt threshold */
> +#define APDS9300_THRESHHIGHLOW	0x04 /* Low byte of high interrupt threshold */
> +#define APDS9300_INTERRUPT	0x06 /* Interrupt control */
> +#define APDS9300_DATA0LOW	0x0c /* Low byte of ADC channel 0 */
> +#define APDS9300_DATA1LOW	0x0e /* Low byte of ADC channel 1 */
> +
> +/* Power on/off value for APDS9300_CONTROL register */
> +#define APDS9300_POWER_ON	0x03
> +#define APDS9300_POWER_OFF	0x00
> +
> +/* Interrupts */
> +#define APDS9300_INTR_ENABLE	0x10
> +/* Interrupt Persist Function: Any value outside of threshold range */
> +#define APDS9300_THRESH_INTR	0x01
> +
> +#define APDS9300_THRESH_MAX	0xffff /* Max threshold value */
> +
> +struct apds9300_data {
> +	struct i2c_client *client;
> +	struct mutex mutex;
> +	int power_state;
> +	int thresh_low;
> +	int thresh_hi;
> +	int intr_en;
> +};
> +
> +/* Lux calculation */
> +
> +/* Calculated values 1000 * (CH1/CH0)^1.4 for CH1/CH0 from 0 to 0.52 */
> +static const u16 apds9300_lux_ratio[] = {
> +	0, 2, 4, 7, 11, 15, 19, 24, 29, 34, 40, 45, 51, 57, 64, 70, 77, 84, 91,
> +	98, 105, 112, 120, 128, 136, 144, 152, 160, 168, 177, 185, 194, 203,
> +	212, 221, 230, 239, 249, 258, 268, 277, 287, 297, 307, 317, 327, 337,
> +	347, 358, 368, 379, 390, 400,
> +};
> +
> +static unsigned long apds9300_calculate_lux(u16 ch0, u16 ch1)
> +{
> +	unsigned long lux, tmp;
> +
> +	/* avoid division by zero */
> +	if (ch0 == 0)
> +		return 0;
> +
> +	tmp = DIV_ROUND_UP(ch1 * 100, ch0);
> +	if (tmp <= 52) {
> +		lux = 3150 * ch0 - (unsigned long)DIV_ROUND_UP_ULL(ch0
> +				* apds9300_lux_ratio[tmp] * 5930ull, 1000);
> +	} else if (tmp <= 65) {
> +		lux = 2290 * ch0 - 2910 * ch1;
> +	} else if (tmp <= 80) {
> +		lux = 1570 * ch0 - 1800 * ch1;
> +	} else if (tmp <= 130) {
> +		lux = 338 * ch0 - 260 * ch1;
> +	} else {
> +		lux = 0;
> +	}
> +
> +	return lux / 100000;
> +}
> +
> +static int apds9300_get_adc_val(struct apds9300_data *data, int adc_number)
> +{
> +	int ret;
> +	u8 flags = APDS9300_CMD | APDS9300_WORD;
> +
> +	if (!data->power_state)
> +		return -EBUSY;
> +
> +	/* Select ADC0 or ADC1 data register */
> +	flags |= adc_number ? APDS9300_DATA1LOW : APDS9300_DATA0LOW;
> +
> +	ret = i2c_smbus_read_word_data(data->client, flags);
> +	if (ret < 0)
> +		dev_err(&data->client->dev,
> +			"failed to read ADC%d value\n", adc_number);
> +
> +	return ret;
> +}
> +
> +static int apds9300_set_thresh_low(struct apds9300_data *data, int value)
> +{
> +	int ret;
> +
> +	if (!data->power_state)
> +		return -EBUSY;
> +
> +	if (value > APDS9300_THRESH_MAX)
> +		return -EINVAL;
> +
> +	ret = i2c_smbus_write_word_data(data->client, APDS9300_THRESHLOWLOW
> +			| APDS9300_CMD | APDS9300_WORD, value);
> +	if (ret) {
> +		dev_err(&data->client->dev, "failed to set thresh_low\n");
> +		return ret;
> +	}
> +	data->thresh_low = value;
> +
> +	return 0;
> +}
> +
> +static int apds9300_set_thresh_hi(struct apds9300_data *data, int value)
> +{
> +	int ret;
> +
> +	if (!data->power_state)
> +		return -EBUSY;
> +
> +	if (value > APDS9300_THRESH_MAX)
> +		return -EINVAL;
> +
> +	ret = i2c_smbus_write_word_data(data->client, APDS9300_THRESHHIGHLOW
> +			| APDS9300_CMD | APDS9300_WORD, value);
> +	if (ret) {
> +		dev_err(&data->client->dev, "failed to set thresh_hi\n");
> +		return ret;
> +	}
> +	data->thresh_hi = value;
> +
> +	return 0;
> +}
> +
> +static int apds9300_set_intr_state(struct apds9300_data *data, int state)
> +{
> +	int ret;
> +	u8 cmd;
> +
> +	if (!data->power_state)
> +		return -EBUSY;
> +
> +	cmd = state ? APDS9300_INTR_ENABLE | APDS9300_THRESH_INTR : 0x00;
> +	ret = i2c_smbus_write_byte_data(data->client,
> +			APDS9300_INTERRUPT | APDS9300_CMD, cmd);
> +	if (ret) {
> +		dev_err(&data->client->dev,
> +			"failed to set interrupt state %d\n", state);
> +		return ret;
> +	}
> +	data->intr_en = state;
> +
> +	return 0;
> +}
> +
> +static int apds9300_set_power_state(struct apds9300_data *data, int state)
> +{
> +	int ret;
> +	u8 cmd;
> +
> +	cmd = state ? APDS9300_POWER_ON : APDS9300_POWER_OFF;
> +	ret = i2c_smbus_write_byte_data(data->client,
> +			APDS9300_CONTROL | APDS9300_CMD, cmd);
> +	if (ret) {
> +		dev_err(&data->client->dev,
> +			"failed to set power state %d\n", state);
> +		return ret;
> +	}
> +	data->power_state = state;
> +
> +	return 0;
> +}
> +
> +static void apds9300_clear_intr(struct apds9300_data *data)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte(data->client, APDS9300_CLEAR | APDS9300_CMD);
> +	if (ret < 0)
> +		dev_err(&data->client->dev, "failed to clear interrupt\n");
> +}
> +
> +static int apds9300_chip_init(struct apds9300_data *data)
> +{
> +	int ret;
> +
> +	/* Need to set power off to ensure that the chip is off */
> +	ret = apds9300_set_power_state(data, 0);
> +	if (ret < 0)
> +		goto err;
> +	/*
> +	 * Probe the chip. To do so we try to power up the device and then to
> +	 * read back the 0x03 code
> +	 */
> +	ret = apds9300_set_power_state(data, 1);
> +	if (ret < 0)
> +		goto err;
> +	ret = i2c_smbus_read_byte_data(data->client,
> +			APDS9300_CONTROL | APDS9300_CMD);
> +	if (ret != APDS9300_POWER_ON) {
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +	/*
> +	 * Disable interrupt to ensure thai it is doesn't enable
> +	 * i.e. after device soft reset
> +	 */
> +	ret = apds9300_set_intr_state(data, 0);
> +	if (ret < 0)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	dev_err(&data->client->dev, "failed to init the chip\n");
> +	return ret;
> +}
> +
> +static int apds9300_read_raw(struct iio_dev *indio_dev,
> +		struct iio_chan_spec const *chan, int *val, int *val2,
> +		long mask)
> +{
> +	int ch0, ch1, ret = -EINVAL;
> +	struct apds9300_data *data = iio_priv(indio_dev);
> +
> +	mutex_lock(&data->mutex);
> +	switch (chan->type) {
> +	case IIO_LIGHT:
> +		ch0 = apds9300_get_adc_val(data, 0);
> +		if (ch0 < 0) {
> +			ret = ch0;
> +			break;
> +		}
> +		ch1 = apds9300_get_adc_val(data, 1);
> +		if (ch1 < 0) {
> +			ret = ch1;
> +			break;
> +		}
> +		*val = apds9300_calculate_lux(ch0, ch1);
> +		ret = IIO_VAL_INT;
> +		break;
> +	case IIO_INTENSITY:
> +		ret = apds9300_get_adc_val(data, chan->channel);
> +		if (ret < 0)
> +			break;
> +		*val = ret;
> +		ret = IIO_VAL_INT;
> +		break;
> +	default:
> +		break;
> +	}
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static int apds9300_read_thresh(struct iio_dev *indio_dev, u64 event_code,
> +		int *val)
> +{
> +	struct apds9300_data *data = iio_priv(indio_dev);
> +
> +	switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
> +	case IIO_EV_DIR_RISING:
> +		*val = data->thresh_hi;
> +		break;
> +	case IIO_EV_DIR_FALLING:
> +		*val = data->thresh_low;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int apds9300_write_thresh(struct iio_dev *indio_dev, u64 event_code,
> +		int val)
> +{
> +	struct apds9300_data *data = iio_priv(indio_dev);
> +	int ret;
> +
> +	mutex_lock(&data->mutex);
> +	if (IIO_EVENT_CODE_EXTRACT_DIR(event_code) == IIO_EV_DIR_RISING)
> +		ret = apds9300_set_thresh_hi(data, val);
> +	else
> +		ret = apds9300_set_thresh_low(data, val);
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static int apds9300_read_interrupt_config(struct iio_dev *indio_dev,
> +		u64 event_code)
> +{
> +	struct apds9300_data *data = iio_priv(indio_dev);
> +
> +	return data->intr_en;
> +}
> +
> +static int apds9300_write_interrupt_config(struct iio_dev *indio_dev,
> +		u64 event_code, int state)
> +{
> +	struct apds9300_data *data = iio_priv(indio_dev);
> +	int ret;
> +
> +	mutex_lock(&data->mutex);
> +	ret = apds9300_set_intr_state(data, state);
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static const struct iio_info apds9300_info_no_irq = {
> +	.driver_module	= THIS_MODULE,
> +	.read_raw	= apds9300_read_raw,
> +};
> +
> +static const struct iio_info apds9300_info = {
> +	.driver_module		= THIS_MODULE,
> +	.read_raw		= apds9300_read_raw,
> +	.read_event_value	= apds9300_read_thresh,
> +	.write_event_value	= apds9300_write_thresh,
> +	.read_event_config	= apds9300_read_interrupt_config,
> +	.write_event_config	= apds9300_write_interrupt_config,
> +};
> +
> +static const struct iio_chan_spec apds9300_channels[] = {
> +	{
> +		.type = IIO_LIGHT,
> +		.channel = 0,
> +		.indexed = true,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> +	}, {
> +		.type = IIO_INTENSITY,
> +		.channel = 0,
> +		.channel2 = IIO_MOD_LIGHT_BOTH,
> +		.indexed = true,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +		.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					  IIO_EV_DIR_RISING) |
> +			       IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					  IIO_EV_DIR_FALLING)),
> +	}, {
> +		.type = IIO_INTENSITY,
> +		.channel = 1,
> +		.channel2 = IIO_MOD_LIGHT_IR,
> +		.indexed = true,
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
> +	},
> +};
> +
> +static irqreturn_t apds9300_interrupt_handler(int irq, void *private)
> +{
> +	struct iio_dev *dev_info = private;
> +	struct apds9300_data *data = iio_priv(dev_info);
> +
> +	iio_push_event(dev_info,
> +		       IIO_UNMOD_EVENT_CODE(IIO_INTENSITY, 0,
> +					    IIO_EV_TYPE_THRESH,
> +					    IIO_EV_DIR_EITHER),
> +		       iio_get_time_ns());
> +
> +	apds9300_clear_intr(data);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int apds9300_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
> +{
> +	struct apds9300_data *data;
> +	struct iio_dev *indio_dev;
> +	int ret;
> +
> +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	data = iio_priv(indio_dev);
> +	i2c_set_clientdata(client, indio_dev);
> +	data->client = client;
> +
> +	ret = apds9300_chip_init(data);
> +	if (ret < 0)
> +		goto err;
> +
> +	mutex_init(&data->mutex);
> +
> +	indio_dev->dev.parent = &client->dev;
> +	indio_dev->channels = apds9300_channels;
> +	indio_dev->num_channels = ARRAY_SIZE(apds9300_channels);
> +	indio_dev->name = APDS9300_DRV_NAME;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +
> +	if (client->irq)
> +		indio_dev->info = &apds9300_info;
> +	else
> +		indio_dev->info = &apds9300_info_no_irq;
> +
> +	if (client->irq) {
> +		ret = devm_request_threaded_irq(&client->dev, client->irq,
> +				NULL, apds9300_interrupt_handler,
> +				IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +				APDS9300_IRQ_NAME, indio_dev);
> +		if (ret) {
> +			dev_err(&client->dev, "irq request error %d\n", -ret);
> +			goto err;
> +		}
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret < 0)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	/* Ensure that power off in case of error */
> +	apds9300_set_power_state(data, 0);
> +	return ret;
> +}
> +
> +static int apds9300_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +	struct apds9300_data *data = iio_priv(indio_dev);
> +
> +	iio_device_unregister(indio_dev);
> +
> +	/* Ensure that power off and interrupts are disabled */
> +	apds9300_set_intr_state(data, 0);
> +	apds9300_set_power_state(data, 0);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int apds9300_suspend(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> +	struct apds9300_data *data = iio_priv(indio_dev);
> +	int ret;
> +
> +	mutex_lock(&data->mutex);
> +	ret = apds9300_set_power_state(data, 0);
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static int apds9300_resume(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> +	struct apds9300_data *data = iio_priv(indio_dev);
> +	int ret;
> +
> +	mutex_lock(&data->mutex);
> +	ret = apds9300_set_power_state(data, 1);
> +	mutex_unlock(&data->mutex);
> +
> +	return ret;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(apds9300_pm_ops, apds9300_suspend, apds9300_resume);
> +#define APDS9300_PM_OPS (&apds9300_pm_ops)
> +#else
> +#define APDS9300_PM_OPS NULL
> +#endif
> +
> +static struct i2c_device_id apds9300_id[] = {
> +	{ APDS9300_DRV_NAME, 0 },
> +	{ }
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, apds9300_id);
> +
> +static struct i2c_driver apds9300_driver = {
> +	.driver = {
> +		.name	= APDS9300_DRV_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	= APDS9300_PM_OPS,
> +	},
> +	.probe		= apds9300_probe,
> +	.remove		= apds9300_remove,
> +	.id_table	= apds9300_id,
> +};
> +
> +module_i2c_driver(apds9300_driver);
> +
> +MODULE_AUTHOR("Kravchenko Oleksandr <o.v.kravchenko@globallogic.com>");
> +MODULE_AUTHOR("GlobalLogic inc.");
> +MODULE_DESCRIPTION("APDS9300 ambient light photo sensor driver");
> +MODULE_LICENSE("GPL");
>
