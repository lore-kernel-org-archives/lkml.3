Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab3HBO7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:59:50 -0400
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:38738 "EHLO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3HBO7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:59:47 -0400
MIME-Version: 1.0
In-Reply-To: <51F97F2E.7040006@kernel.org>
References: <1375109893-7917-1-git-send-email-x0199363@ti.com>
	<1375109893-7917-2-git-send-email-x0199363@ti.com>
	<alpine.DEB.2.01.1307291704440.20459@pmeerw.net>
	<51F97F2E.7040006@kernel.org>
Date: Fri, 2 Aug 2013 17:59:45 +0300
Message-ID: <CAGH3drowFydWG9+v=MHWeXohYE1TcRiDepJtDGO==5SxGAyM3w@mail.gmail.com>
Subject: Re: [PATCH 2/2] iio: add Bosch BMA180 acceleration sensor driver
From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Peter Meerwald <pmeerw@pmeerw.net>, Oleksandr Kravchenko <x0199363@ti.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        jic23@cam.ac.uk, holler@ahsoftware.de, srinivas.pandruvada@intel.com,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 12:18 AM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 07/29/13 16:15, Peter Meerwald wrote:
>>
>> kicking out drivers fast :)
>> few comments below; the driver exposes only minimal iio features and
>> integrates input subsystem, this doesn't seem right
>>
> Only taken a very quick look but Peter is quite right.  Either
> this is very much an input directed driver in which case rip out the
> IIO stuff and submit it as an input driver, or it is a multipurpose part
> in which case the 'right' way to do it is that bridge driver I keep
> failing to bring up to date (anyone else fancy taking it on? I'll probably
> get to it, but right now all my available time goes on review so new
> features in my hands will take a while!)
>
> There are some other corners that still need doing, but having large
> quantities of input calls within an IIO driver is not going anywhere
> as it just makes for a maintenance mess.
>
> Actually this driver doesn't support what we would call events in IIO
> so the current feature set of that bridge would probably be fine.  Note
> to use it you'd need full trigger and buffer support under IIO.

I can't completely understand how to use IIO buffer and trigger in my driver.
Please advice me which driver can I use as reference.

>
> Anyhow, up to you whether you want to pitch this to linux-input with
> IIO removed or go the IIO  and input bridge route (last version
> 'might' be http://marc.info/?l=linux-iio&m=135167944813803&w=2 .
>
>>>
>>> diff --git a/Documentation/devicetree/bindings/iio/accel/bma180.txt b/Documentation/devicetree/bindings/iio/accel/bma180.txt
>>> new file mode 100644
>>> index 0000000..7c13c84
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/iio/accel/bma180.txt
>>> @@ -0,0 +1,53 @@
>>> +* Bosch BMA180 triaxial acceleration sensor
>>> +
>>> +http://omapworld.com/BMA180_111_1002839.pdf
>>> +
>>> +Required properties:
>>> +
>>> +  - compatible : should be "bosch,bma180"
>>> +  - reg : the I2C address of the sensor
>>> +
>>> +Optional properties:
>>> +
>>> +  - interrupt-parent : should be the phandle for the interrupt controller
>>> +
>>> +  - interrupts : interrupt mapping for GPIO IRQ, it shuld by configured with
>>> +            flags IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING
>>> +
>>> +  - range : select the full scale acceleration range
>>> +            0 : -1g..+1g
>>> +            1 : -1.5g..+1.5g
>>> +            2 : -2g..+2g
>>> +            3 : -3g..+3g
>>> +            4 : -4g..+4g
>>> +            5 : -8g..+8g
>>> +            6 : -16g..+16g
>>> +
>>> +  - bw : select bandwidth bandwidth
>>> +            0 : 10Hz
>>> +            1 : 20Hz
>>> +            2 : 40Hz
>>> +            3 : 75Hz
>>> +            4 : 150Hz
>>> +            5 : 300Hz
> Surely magic numbers should be as unacceptible in device tree files
> as anywhere else?  It's hardly difficult to use the actual values
> for this.
>
>>> +            Don't use bandwidth frequency more than 300Hz couse it
>>
>> because
>>
>>> +            influences the frequency of generating new data interrupts
>>> +            and i2c reading phase can be longer than pheriod of interrupt
>>
>> period
>>
>>> +            generation.
>>> +
>>> +  - mode_config : 0 - select low noise mode, 1 - select low power mode
>>> +
>>> +  - fuzz : specifies fuzz value that is used to filter noise from the event stream
>>> +
>>> +Example:
>>> +
>>> +bma180@40 {
>>> +    compatible = "bosch,bma180";
>>> +    reg = <0x40>;
>>> +    interrupt-parent = <&gpio6>;
>>> +    interrupts = <18 (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING)>;
>>> +    range = <2>;
>>> +    bw = <0>;
>>> +    mode_config = <1>;
>>> +    fuzz = <555>;
>>> +};
>>> diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
>>> index 719d83f..61fd29f 100644
>>> --- a/drivers/iio/accel/Kconfig
>>> +++ b/drivers/iio/accel/Kconfig
>>> @@ -3,6 +3,16 @@
>>>  #
>>>  menu "Accelerometers"
>>>
>>> +config BMA180
>>> +    tristate "Bosch BMA180 3-Axis Accelerometer Driver"
>>> +    depends on I2C
>>> +    help
>>> +      Say Y here if you want to build a driver for the Bosch BMA180
>>> +      triaxial acceleration sensor.
>>> +
>>> +      To compile this driver as a module, choose M here: the
>>> +      module will be called bma180.
>>> +
>>>  config HID_SENSOR_ACCEL_3D
>>>      depends on HID_SENSOR_HUB
>>>      select IIO_BUFFER
>>> diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
>>> index 87d8fa2..31a36fa 100644
>>> --- a/drivers/iio/accel/Makefile
>>> +++ b/drivers/iio/accel/Makefile
>>> @@ -12,3 +12,5 @@ obj-$(CONFIG_IIO_ST_ACCEL_I2C_3AXIS) += st_accel_i2c.o
>>>  obj-$(CONFIG_IIO_ST_ACCEL_SPI_3AXIS) += st_accel_spi.o
>>>
>>>  obj-$(CONFIG_KXSD9) += kxsd9.o
>>> +
>>> +obj-$(CONFIG_BMA180)        += bma180.o
>>
>> alphabetic order
>>
>>> diff --git a/drivers/iio/accel/bma180.c b/drivers/iio/accel/bma180.c
>>> new file mode 100644
>>> index 0000000..9f5341f
>>> --- /dev/null
>>> +++ b/drivers/iio/accel/bma180.c
>>> @@ -0,0 +1,462 @@
>>> +/*
>>> + * bma180.c - IIO driver for Bosch BMA180 triaxial acceleration sensor
>>> + *
>>> + * Copyright 2013 Oleksandr Kravchenko <x0199363@ti.com>
>>> + *
>>> + * This file is subject to the terms and conditions of version 2 of
>>> + * the GNU General Public License.  See the file COPYING in the main
>>> + * directory of this archive for more details.
>>> + */
>>> +
>>> +#include <linux/module.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/input.h>
>>> +#include <linux/of.h>
>>> +#include <linux/bitops.h>
>>> +#include <linux/iio/iio.h>
>>> +#include <linux/iio/sysfs.h>
>>> +#include <linux/iio/events.h>
>>> +
>>> +#define BMA180_DRV_NAME "bma180"
>>> +#define BMA180_IRQ_NAME "bma180_event"
>>> +
>>> +/* Register set */
>>> +#define BMA180_CHIP_ID              0x00 /* Need to distinguish BMA180 from other */
>>> +#define BMA180_ACC_X_LSB    0x02 /* First of 6 registers of accel data */
>>> +#define BMA180_CTRL_REG0    0x0d
>>> +#define BMA180_RESET                0x10
>>> +#define BMA180_BW_TCS               0x20
>>> +#define BMA180_CTRL_REG3    0x21
>>> +#define BMA180_TCO_Z                0x30
>>> +#define BMA180_OFFSET_LSB1  0x35
>>> +
>>> +/* Control bits */
>>> +#define BMA180_SLEEP                BIT(1) /* 1 - chip will sleep */
>>> +#define BMA180_DIS_WAKE_UP  BIT(0) /* Disable wake up mode */
>>> +#define BMA180_EE_W         BIT(4) /* Unlock writing to addr. from 0x20 */
>>> +#define BMA180_NEW_DATA_INT BIT(1) /* Intr every new accel data is ready */
>>> +#define BMA180_SMP_SKIP             BIT(0) /* Sample skipping mode */
>>
>> maybe say which bits belong to which CTRL reg?
>>
>>> +
>>> +/* Bit masks fo registerts bit fields */
>>
>> typos: fo, registerts
>>
>>> +#define BMA180_RANGE                0x0e /* Range of accel measurment */
>>> +#define BMA180_BW           0xf0 /* Accel measurmend bandwidth */
>>
>> typo: measurmend
>>
>>> +#define BMA180_MODE_CONFIG  0x03 /* Config operation modes */
>>> +
>>> +/* We have write this value in reset register to do soft reset */
>>
>> have 'to' write
>>
>>> +#define BMA180_RESET_VAL    0xb6
>>> +
>>> +/* Chip operation modes */
>>> +#define BMA180_LOW_NOISE    0x00
>>> +#define BMA180_LOW_POWER    0x03
>>> +
>>> +struct bma180_data {
>>> +    struct i2c_client *client;
>>> +    struct input_dev *input_dev;
>>> +    struct mutex mutex;
>>> +    int sleep_state;
>>> +    int range;
>>> +    int bw;
>>> +    int mode;
>>> +    int fuzz;
>>> +    int acc_reg[3];
>>> +};
>>> +
>>> +enum bma180_axis {
>>> +    AXIS_X,
>>> +    AXIS_Y,
>>> +    AXIS_Z,
>>> +};
>>> +
>>> +struct bma180_range {
>>> +    int g_range;
>>> +    int ratio;
>>> +};
>>> +
>>> +static struct bma180_range bma180_range_table[7] = {
>>> +    { 1000, 130 },
>>> +    { 1500, 190 },
>>> +    { 2000, 250 },
>>> +    { 3000, 380 },
>>> +    { 4000, 500 },
>>> +    { 8000, 990 },
>>> +    { 16000, 1980 },
>>> +};
>>> +
>>> +static int bma180_get_acc_reg(struct bma180_data *data, enum bma180_axis axis)
>>> +{
>>> +    u8 reg = BMA180_ACC_X_LSB + axis * 2;
>>> +    int ret;
>>> +
>>> +    if (data->sleep_state)
>>> +            return -EBUSY;
>>> +
>>> +    ret = i2c_smbus_read_word_data(data->client, reg);
>>> +    if (ret < 0)
>>> +            dev_err(&data->client->dev,
>>> +                    "failed to read accel_%c registers\n", 'x' + axis);
>>
>> just one register, not registers?
>>
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int bma180_set_bits(struct bma180_data *data, u8 reg, u8 mask, u8 val)
>>> +{
>>> +    int ret = i2c_smbus_read_byte_data(data->client, reg);
>>> +    u8 reg_val = (ret & ~mask) | (val << (ffs(mask) - 1));
>>> +
>>> +    if (ret < 0)
>>> +            return ret;
>>> +
>>> +    return i2c_smbus_write_byte_data(data->client, reg, reg_val);
>>> +}
>>> +
>>> +static int bma180_set_new_data_intr_state(struct bma180_data *data, int state)
>>> +{
>>> +    u8 reg_val = state ? BMA180_NEW_DATA_INT : 0x00;
>>> +    int ret = i2c_smbus_write_byte_data(data->client, BMA180_CTRL_REG3,
>>> +                    reg_val);
>>> +
>>> +    if (ret)
>>> +            dev_err(&data->client->dev,
>>> +                    "failed to set new data interrupt state %d\n", state);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int bma180_set_sleep_state(struct bma180_data *data, int state)
>>> +{
>>> +    int ret = bma180_set_bits(data, BMA180_CTRL_REG0, BMA180_SLEEP, state);
>>> +
>>> +    if (ret) {
>>> +            dev_err(&data->client->dev,
>>> +                    "failed to set sleep state %d\n", state);
>>> +            return ret;
>>> +    }
>>> +    data->sleep_state = state;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int bma180_set_ee_writing_state(struct bma180_data *data, int state)
>>> +{
>>> +    int ret = bma180_set_bits(data, BMA180_CTRL_REG0, BMA180_EE_W, state);
>>> +
>>> +    if (ret)
>>> +            dev_err(&data->client->dev,
>>> +                    "failed to set ee writing state %d\n", state);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int bma180_soft_reset(struct bma180_data *data)
>>> +{
>>> +    int ret = i2c_smbus_write_byte_data(data->client,
>>> +                    BMA180_RESET, BMA180_RESET_VAL);
>>> +
>>> +    if (ret)
>>> +            dev_err(&data->client->dev, "failed to reset the chip\n");
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int bma180_chip_init(struct bma180_data *data)
>>> +{
>>> +    /* Try to read chip_id register. It must return 0x03. */
>>> +    int ret = i2c_smbus_read_byte_data(data->client, BMA180_CHIP_ID);
>>> +
>>> +    if (ret < 0)
>>> +            goto err;
>>> +    if (ret != 0x03) {
>>> +            ret = -ENODEV;
>>> +            goto err;
>>> +    }
>>> +
>>> +    ret = bma180_soft_reset(data);
>>> +    if (ret)
>>> +            goto err;
>>> +    /*
>>> +     * No serial transaction should occur within minimum 10 ìs
>>> +     * after soft_reset command
>>> +     */
>>> +    msleep(20);
>>> +
>>> +    ret = bma180_set_bits(data, BMA180_CTRL_REG0, BMA180_DIS_WAKE_UP, 1);
>>> +    if (ret)
>>> +            goto err;
>>> +    ret = bma180_set_ee_writing_state(data, 1);
>>> +    if (ret)
>>> +            goto err;
>>> +    ret = bma180_set_new_data_intr_state(data, 0);
>>> +    if (ret)
>>> +            goto err;
>>> +    ret = bma180_set_bits(data, BMA180_BW_TCS, BMA180_BW, data->bw);
>>> +    if (ret)
>>> +            goto err;
>>> +    ret = bma180_set_bits(data,
>>> +                    BMA180_OFFSET_LSB1, BMA180_RANGE, data->range);
>>> +    if (ret)
>>> +            goto err;
>>> +    ret = bma180_set_bits(data, BMA180_TCO_Z, BMA180_MODE_CONFIG,
>>> +                    data->mode ? BMA180_LOW_POWER : BMA180_LOW_NOISE);
>>> +    if (ret)
>>> +            goto err;
>>> +    ret = bma180_set_bits(data, BMA180_OFFSET_LSB1, BMA180_SMP_SKIP, 1);
>>> +    if (ret)
>>> +            goto err;
>>> +    ret = bma180_set_new_data_intr_state(data, 1);
>>> +    if (ret)
>>> +            goto err;
>>> +    ret = bma180_set_ee_writing_state(data, 0);
>>> +    if (ret)
>>> +            goto err;
>>> +
>>> +    return 0;
>>> +
>>> +err:
>>> +    dev_err(&data->client->dev, "failed to init the chip\n");
>>> +    return ret;
>>> +}
>>> +
>>> +static void bma180_chip_disable(struct bma180_data *data)
>>> +{
>>> +    if (bma180_set_ee_writing_state(data, 1))
>>> +            goto err;
>>> +    if (bma180_set_new_data_intr_state(data, 0))
>>> +            goto err;
>>> +    if (bma180_set_ee_writing_state(data, 0))
>>> +            goto err;
>>> +    if (bma180_set_sleep_state(data, 1))
>>> +            goto err;
>>> +
>>> +    return;
>>> +
>>> +err:
>>> +    dev_err(&data->client->dev, "failed to disable the chip\n");
>>> +}
>>> +
>>> +static int bma180_read_raw(struct iio_dev *indio_dev,
>>> +            struct iio_chan_spec const *chan, int *val, int *val2,
>>> +            long mask)
>>> +{
>>> +    struct bma180_data *data = iio_priv(indio_dev);
>>> +    long tmp = ((s16)data->acc_reg[chan->channel] >> 2)
>>> +            * bma180_range_table[data->range].ratio;
>>> +
>>> +    if (data->acc_reg[chan->channel] < 0)
>>> +            return data->acc_reg[chan->channel];
>>> +
>>> +    *val = tmp / 1000000;
>>> +    *val2 = (tmp % 1000000);
>>> +
>>> +    return IIO_VAL_INT_PLUS_MICRO;
>>> +}
>>> +
>>> +static const struct iio_info bma180_info = {
>>> +    .driver_module  = THIS_MODULE,
>>> +    .read_raw       = &bma180_read_raw,
>>> +};
>>> +
>>> +static const struct iio_chan_spec bma180_channels[] = {
>>> +    {
>>> +            .type = IIO_ACCEL,
>>> +            .channel = AXIS_X,
>>> +            .channel2 = IIO_MOD_X,
>>> +            .indexed = true,
>>
>> do the channels need to be indexed?
>>
>>> +            .info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
>>> +    }, {
>>> +            .type = IIO_ACCEL,
>>> +            .channel = AXIS_Y,
>>> +            .channel2 = IIO_MOD_Y,
>>> +            .indexed = true,
>>> +            .info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
>>> +    }, {
>>> +            .type = IIO_ACCEL,
>>> +            .channel = AXIS_Z,
>>> +            .channel2 = IIO_MOD_Z,
>>> +            .indexed = true,
>>> +            .info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
>>> +    },
>>> +};
>>> +
>>> +static irqreturn_t bma180_interrupt_handler(int irq, void *private)
>>> +{
>>> +    struct iio_dev *dev_info = private;
>>> +    struct bma180_data *data = iio_priv(dev_info);
>>> +    int i;
>>> +
>>> +    mutex_lock(&data->mutex);
>>> +    for (i = AXIS_X; i <= AXIS_Z; ++i)
>>> +            data->acc_reg[i] = bma180_get_acc_reg(data, i);
>>> +    mutex_unlock(&data->mutex);
>>> +
>>> +    input_report_abs(data->input_dev, ABS_X, data->acc_reg[AXIS_X]);
>>> +    input_report_abs(data->input_dev, ABS_Y, data->acc_reg[AXIS_Y]);
>>> +    input_report_abs(data->input_dev, ABS_Z, data->acc_reg[AXIS_Z]);
>>
>> input subsystem stuff within IIO?
>> uhoh...
>>
>> the driver should probably support more iio features: trigger, scan_mode,
>> buffer
>>
>>> +    input_sync(data->input_dev);
>>> +
>>> +    return IRQ_HANDLED;
>>> +}
>>> +
>>> +static int bma180_probe(struct i2c_client *client,
>>> +            const struct i2c_device_id *id)
>>> +{
>>> +    struct input_dev *input_dev;
>>> +    struct bma180_data *data;
>>> +    struct iio_dev *indio_dev;
>>> +    struct device_node *np = client->dev.of_node;
>>> +    int i, ret;
>>> +
>>> +    if (!client->irq) {
>>> +            dev_err(&client->dev, "this driver cann't work without IRQ\n");
>>
>> can't
>>
>>> +            return -ENODEV;
>>> +    }
>>> +
>>> +    indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
>>> +    if (!indio_dev)
>>> +            return -ENOMEM;
>>> +
>>> +    input_dev = input_allocate_device();
>>> +    if (!input_dev)
>>> +            return -ENOMEM;
>>> +
>>> +    data = iio_priv(indio_dev);
>>> +    i2c_set_clientdata(client, indio_dev);
>>> +    data->client = client;
>>> +
>>> +    of_property_read_u32(np, "bw", &data->bw);
>>> +    of_property_read_u32(np, "range", &data->range);
>>> +    of_property_read_u32(np, "mode", &data->mode);
>>> +    of_property_read_u32(np, "fuzz", &data->fuzz);
>>> +
>>> +    ret = bma180_chip_init(data);
>>> +    if (ret < 0)
>>> +            goto err_1;
>>> +
>>> +    mutex_init(&data->mutex);
>>> +
>>> +    indio_dev->dev.parent = &client->dev;
>>> +    indio_dev->channels = bma180_channels;
>>> +    indio_dev->num_channels = ARRAY_SIZE(bma180_channels);
>>> +    indio_dev->name = BMA180_DRV_NAME;
>>> +    indio_dev->modes = INDIO_DIRECT_MODE;
>>> +    indio_dev->info = &bma180_info;
>>> +
>>> +    input_dev->name = BMA180_DRV_NAME;
>>> +    input_dev->id.bustype = BUS_I2C;
>>> +    __set_bit(EV_ABS, input_dev->evbit);
>>> +    for (i = ABS_X; i <= ABS_Z; ++i)
>>> +            input_set_abs_params(input_dev, i,
>>> +                                 -bma180_range_table[data->range].g_range,
>>> +                                 bma180_range_table[data->range].g_range,
>>> +                                 data->fuzz, 0);
>>> +    input_dev->dev.parent = &client->dev;
>>> +    input_set_drvdata(input_dev, data);
>>> +
>>> +    data->input_dev = input_dev;
>>> +
>>> +    ret = devm_request_threaded_irq(&client->dev, client->irq,
>>> +                    NULL, bma180_interrupt_handler, IRQF_ONESHOT,
>>> +                    BMA180_IRQ_NAME, indio_dev);
>>> +    if (ret < 0) {
>>> +            dev_err(&client->dev, "irq request error %d\n", -ret);
>>> +            goto err_1;
>>> +    }
>>> +
>>> +    ret = input_register_device(input_dev);
>>> +    if (ret) {
>>> +            dev_err(&client->dev, "unable to register input device\n");
>>> +            goto err_1;
>>> +    }
>>> +
>>> +
>>
>> extra newline
>>
>>> +    ret = iio_device_register(indio_dev);
>>> +    if (ret < 0) {
>>> +            dev_err(&client->dev, "unable to register iio device\n");
>>> +            goto err_2;
>>> +    }
>>> +
>>> +    return 0;
>>> +
>>> +err_2:
>>> +    input_unregister_device(input_dev);
>>> +err_1:
>>> +    input_free_device(input_dev);
>>> +
>>> +    bma180_chip_disable(data);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int bma180_remove(struct i2c_client *client)
>>> +{
>>> +    struct iio_dev *indio_dev = i2c_get_clientdata(client);
>>> +    struct bma180_data *data = iio_priv(indio_dev);
>>> +
>>> +    iio_device_unregister(indio_dev);
>>> +    input_unregister_device(data->input_dev);
>>> +
>>> +    mutex_lock(&data->mutex);
>>> +    bma180_chip_disable(data);
>>> +    mutex_unlock(&data->mutex);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +#ifdef CONFIG_PM_SLEEP
>>> +static int bma180_suspend(struct device *dev)
>>> +{
>>> +    struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
>>> +    struct bma180_data *data = iio_priv(indio_dev);
>>> +    int ret;
>>> +
>>> +    mutex_lock(&data->mutex);
>>> +    ret = bma180_set_sleep_state(data, 1);
>>> +    mutex_unlock(&data->mutex);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static int bma180_resume(struct device *dev)
>>> +{
>>> +    struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
>>> +    struct bma180_data *data = iio_priv(indio_dev);
>>> +    int ret;
>>> +
>>> +    mutex_lock(&data->mutex);
>>> +    ret = bma180_set_sleep_state(data, 0);
>>> +    mutex_unlock(&data->mutex);
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static SIMPLE_DEV_PM_OPS(bma180_pm_ops, bma180_suspend, bma180_resume);
>>> +#define BMA180_PM_OPS (&bma180_pm_ops)
>>> +#else
>>> +#define BMA180_PM_OPS NULL
>>> +#endif
>>> +
>>> +static struct i2c_device_id bma180_id[] = {
>>> +    { BMA180_DRV_NAME, 0 },
>>> +    { }
>>> +};
>>> +
>>> +MODULE_DEVICE_TABLE(i2c, bma180_id);
>>> +
>>> +static struct i2c_driver bma180_driver = {
>>> +    .driver = {
>>> +            .name   = BMA180_DRV_NAME,
>>> +            .owner  = THIS_MODULE,
>>> +            .pm     = BMA180_PM_OPS,
>>> +    },
>>> +    .probe          = bma180_probe,
>>> +    .remove         = bma180_remove,
>>> +    .id_table       = bma180_id,
>>> +};
>>> +
>>> +module_i2c_driver(bma180_driver);
>>> +
>>> +MODULE_AUTHOR("Kravchenko Oleksandr <x0199363@ti.com>");
>>> +MODULE_AUTHOR("Texas Instruments, Inc.");
>>> +MODULE_DESCRIPTION("Bosch BMA180 triaxial acceleration sensor");
>>> +MODULE_LICENSE("GPL");
>>>
>>
