Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbaGWUsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:48:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:34754 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaGWUsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:48:14 -0400
Message-ID: <53D02019.5040801@kernel.org>
Date: Wed, 23 Jul 2014 21:50:33 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atalax.net>, linux-iio@vger.kernel.org
CC: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net,
        dan.carpenter@oracle.com, lars@metafoo.de
Subject: Re: [PATCH v5 (staging-next) 1/5] staging:iio:hmc5843: Added regmap
 support
References: <20140722150009.GA7845@dashie> <20140722150043.GB7845@dashie>
In-Reply-To: <20140722150043.GB7845@dashie>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 16:00, Josef Gajdusek wrote:
> This patch changes hmc5843.c to use regmap. This provides transparent caching
> to the code as well as abstraction necessary to add support for SPI-based
> hmc5983.
>
> Signed-off-by: Josef Gajdusek <atx@atx.name>
Applied to the togreg branch of iio.git - initially pushed out as testing.
> ---
>   drivers/staging/iio/magnetometer/Kconfig   |   1 +
>   drivers/staging/iio/magnetometer/hmc5843.c | 140 +++++++++++++++++++----------
>   2 files changed, 96 insertions(+), 45 deletions(-)
>
> diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
> index 34634da..ad88d61 100644
> --- a/drivers/staging/iio/magnetometer/Kconfig
> +++ b/drivers/staging/iio/magnetometer/Kconfig
> @@ -8,6 +8,7 @@ config SENSORS_HMC5843
>   	depends on I2C
>   	select IIO_BUFFER
>   	select IIO_TRIGGERED_BUFFER
> +	select REGMAP_I2C
>   	help
>   	  Say Y here to add support for the Honeywell HMC5843, HMC5883 and
>   	  HMC5883L 3-Axis Magnetometer (digital compass).
> diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
> index f595fdc..6f06f98 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843.c
> @@ -21,6 +21,7 @@
>
>   #include <linux/module.h>
>   #include <linux/i2c.h>
> +#include <linux/regmap.h>
>   #include <linux/iio/iio.h>
>   #include <linux/iio/sysfs.h>
>   #include <linux/iio/trigger_consumer.h>
> @@ -34,6 +35,7 @@
>   #define HMC5843_DATA_OUT_MSB_REGS		0x03
>   #define HMC5843_STATUS_REG			0x09
>   #define HMC5843_ID_REG				0x0a
> +#define HMC5843_ID_END				0x0c
>
>   enum hmc5843_ids {
>   	HMC5843_ID,
> @@ -49,6 +51,7 @@ enum hmc5843_ids {
>   #define HMC5843_RANGE_GAIN_OFFSET		0x05
>   #define HMC5843_RANGE_GAIN_DEFAULT		0x01
>   #define HMC5843_RANGE_GAINS			8
> +#define HMC5843_RANGE_GAIN_MASK		0xe0
>
>   /* Device status */
>   #define HMC5843_DATA_READY			0x01
> @@ -68,6 +71,7 @@ enum hmc5843_ids {
>   #define HMC5843_RATE_OFFSET			0x02
>   #define HMC5843_RATE_DEFAULT			0x04
>   #define HMC5843_RATES				7
> +#define HMC5843_RATE_MASK		0x1c
>
>   /* Device measurement configuration */
>   #define HMC5843_MEAS_CONF_NORMAL		0x00
> @@ -121,10 +125,7 @@ struct hmc5843_chip_info {
>   struct hmc5843_data {
>   	struct i2c_client *client;
>   	struct mutex lock;
> -	u8 rate;
> -	u8 meas_conf;
> -	u8 operating_mode;
> -	u8 range;
> +	struct regmap *regmap;
>   	const struct hmc5843_chip_info *variant;
>   	__be16 buffer[8]; /* 3x 16-bit channels + padding + 64-bit timestamp */
>   };
> @@ -135,10 +136,8 @@ static s32 hmc5843_set_mode(struct hmc5843_data *data, u8 operating_mode)
>   	int ret;
>
>   	mutex_lock(&data->lock);
> -	ret = i2c_smbus_write_byte_data(data->client, HMC5843_MODE_REG,
> -					operating_mode & HMC5843_MODE_MASK);
> -	if (ret >= 0)
> -		data->operating_mode = operating_mode;
> +	ret = regmap_update_bits(data->regmap, HMC5843_MODE_REG,
> +			HMC5843_MODE_MASK, operating_mode);
>   	mutex_unlock(&data->lock);
>
>   	return ret;
> @@ -146,15 +145,15 @@ static s32 hmc5843_set_mode(struct hmc5843_data *data, u8 operating_mode)
>
>   static int hmc5843_wait_measurement(struct hmc5843_data *data)
>   {
> -	s32 result;
>   	int tries = 150;
> +	int val;
> +	int ret;
>
>   	while (tries-- > 0) {
> -		result = i2c_smbus_read_byte_data(data->client,
> -			HMC5843_STATUS_REG);
> -		if (result < 0)
> -			return result;
> -		if (result & HMC5843_DATA_READY)
> +		ret = regmap_read(data->regmap, HMC5843_STATUS_REG, &val);
> +		if (ret < 0)
> +			return ret;
> +		if (val & HMC5843_DATA_READY)
>   			break;
>   		msleep(20);
>   	}
> @@ -171,20 +170,20 @@ static int hmc5843_wait_measurement(struct hmc5843_data *data)
>   static int hmc5843_read_measurement(struct hmc5843_data *data,
>   				    int idx, int *val)
>   {
> -	s32 result;
>   	__be16 values[3];
> +	int ret;
>
>   	mutex_lock(&data->lock);
> -	result = hmc5843_wait_measurement(data);
> -	if (result < 0) {
> +	ret = hmc5843_wait_measurement(data);
> +	if (ret < 0) {
>   		mutex_unlock(&data->lock);
> -		return result;
> +		return ret;
>   	}
> -	result = i2c_smbus_read_i2c_block_data(data->client,
> -		HMC5843_DATA_OUT_MSB_REGS, sizeof(values), (u8 *) values);
> +	ret = regmap_bulk_read(data->regmap, HMC5843_DATA_OUT_MSB_REGS,
> +			values, sizeof(values));
>   	mutex_unlock(&data->lock);
> -	if (result < 0)
> -		return -EINVAL;
> +	if (ret < 0)
> +		return ret;
>
>   	*val = sign_extend32(be16_to_cpu(values[idx]), 15);
>   	return IIO_VAL_INT;
> @@ -208,16 +207,13 @@ static int hmc5843_read_measurement(struct hmc5843_data *data,
>    *     and BN.
>    *
>    */
> -static s32 hmc5843_set_meas_conf(struct hmc5843_data *data, u8 meas_conf)
> +static int hmc5843_set_meas_conf(struct hmc5843_data *data, u8 meas_conf)
>   {
>   	int ret;
>
>   	mutex_lock(&data->lock);
> -	ret = i2c_smbus_write_byte_data(data->client, HMC5843_CONFIG_REG_A,
> -		(meas_conf & HMC5843_MEAS_CONF_MASK) |
> -		(data->rate << HMC5843_RATE_OFFSET));
> -	if (ret >= 0)
> -		data->meas_conf = meas_conf;
> +	ret = regmap_update_bits(data->regmap, HMC5843_CONFIG_REG_A,
> +			HMC5843_MEAS_CONF_MASK, meas_conf);
>   	mutex_unlock(&data->lock);
>
>   	return ret;
> @@ -228,7 +224,15 @@ static ssize_t hmc5843_show_measurement_configuration(struct device *dev,
>   						char *buf)
>   {
>   	struct hmc5843_data *data = iio_priv(dev_to_iio_dev(dev));
> -	return sprintf(buf, "%d\n", data->meas_conf);
> +	int val;
> +	int ret;
> +
> +	ret = regmap_read(data->regmap, HMC5843_CONFIG_REG_A, &val);
> +	if (ret)
> +		return ret;
> +	val &= HMC5843_MEAS_CONF_MASK;
> +
> +	return sprintf(buf, "%d\n", val);
>   }
>
>   static ssize_t hmc5843_set_measurement_configuration(struct device *dev,
> @@ -282,10 +286,8 @@ static int hmc5843_set_samp_freq(struct hmc5843_data *data, u8 rate)
>   	int ret;
>
>   	mutex_lock(&data->lock);
> -	ret = i2c_smbus_write_byte_data(data->client, HMC5843_CONFIG_REG_A,
> -		data->meas_conf | (rate << HMC5843_RATE_OFFSET));
> -	if (ret >= 0)
> -		data->rate = rate;
> +	ret = regmap_update_bits(data->regmap, HMC5843_CONFIG_REG_A,
> +			HMC5843_RATE_MASK, rate << HMC5843_RATE_OFFSET);
>   	mutex_unlock(&data->lock);
>
>   	return ret;
> @@ -309,10 +311,9 @@ static int hmc5843_set_range_gain(struct hmc5843_data *data, u8 range)
>   	int ret;
>
>   	mutex_lock(&data->lock);
> -	ret = i2c_smbus_write_byte_data(data->client, HMC5843_CONFIG_REG_B,
> -		range << HMC5843_RANGE_GAIN_OFFSET);
> -	if (ret >= 0)
> -		data->range = range;
> +	ret = regmap_update_bits(data->regmap, HMC5843_CONFIG_REG_B,
> +			HMC5843_RANGE_GAIN_MASK,
> +			range << HMC5843_RANGE_GAIN_OFFSET);
>   	mutex_unlock(&data->lock);
>
>   	return ret;
> @@ -358,17 +359,27 @@ static int hmc5843_read_raw(struct iio_dev *indio_dev,
>   			    int *val, int *val2, long mask)
>   {
>   	struct hmc5843_data *data = iio_priv(indio_dev);
> +	int rval;
> +	int ret;
>
>   	switch (mask) {
>   	case IIO_CHAN_INFO_RAW:
>   		return hmc5843_read_measurement(data, chan->scan_index, val);
>   	case IIO_CHAN_INFO_SCALE:
> +		ret = regmap_read(data->regmap, HMC5843_CONFIG_REG_B, &rval);
> +		if (ret < 0)
> +			return ret;
> +		rval >>= HMC5843_RANGE_GAIN_OFFSET;
>   		*val = 0;
> -		*val2 = data->variant->regval_to_nanoscale[data->range];
> +		*val2 = data->variant->regval_to_nanoscale[rval];
>   		return IIO_VAL_INT_PLUS_NANO;
>   	case IIO_CHAN_INFO_SAMP_FREQ:
> -		*val = data->variant->regval_to_samp_freq[data->rate][0];
> -		*val2 = data->variant->regval_to_samp_freq[data->rate][1];
> +		ret = regmap_read(data->regmap, HMC5843_CONFIG_REG_A, &rval);
> +		if (ret < 0)
> +			return ret;
> +		rval >>= HMC5843_RATE_OFFSET;
> +		*val = data->variant->regval_to_samp_freq[rval][0];
> +		*val2 = data->variant->regval_to_samp_freq[rval][1];
>   		return IIO_VAL_INT_PLUS_MICRO;
>   	}
>   	return -EINVAL;
> @@ -426,9 +437,9 @@ static irqreturn_t hmc5843_trigger_handler(int irq, void *p)
>   		goto done;
>   	}
>
> -	ret = i2c_smbus_read_i2c_block_data(data->client,
> -		HMC5843_DATA_OUT_MSB_REGS, 3 * sizeof(__be16),
> -			(u8 *) data->buffer);
> +	ret = regmap_bulk_read(data->regmap, HMC5843_DATA_OUT_MSB_REGS,
> +			data->buffer, 3 * sizeof(__be16));
> +
>   	mutex_unlock(&data->lock);
>   	if (ret < 0)
>   		goto done;
> @@ -508,8 +519,8 @@ static int hmc5843_init(struct hmc5843_data *data)
>   	int ret;
>   	u8 id[3];
>
> -	ret = i2c_smbus_read_i2c_block_data(data->client, HMC5843_ID_REG,
> -		sizeof(id), id);
> +	ret = regmap_bulk_read(data->regmap, HMC5843_ID_REG,
> +			id, ARRAY_SIZE(id));
>   	if (ret < 0)
>   		return ret;
>   	if (id[0] != 'H' || id[1] != '4' || id[2] != '3') {
> @@ -539,6 +550,44 @@ static const struct iio_info hmc5843_info = {
>
>   static const unsigned long hmc5843_scan_masks[] = {0x7, 0};
>
> +static const struct regmap_range hmc5843_readable_ranges[] = {
> +		regmap_reg_range(0, HMC5843_ID_END),
> +};
> +
> +static struct regmap_access_table hmc5843_readable_table = {
> +		.yes_ranges = hmc5843_readable_ranges,
> +		.n_yes_ranges = ARRAY_SIZE(hmc5843_readable_ranges),
> +};
> +
> +static const struct regmap_range hmc5843_writable_ranges[] = {
> +		regmap_reg_range(0, HMC5843_MODE_REG),
> +};
> +
> +static struct regmap_access_table hmc5843_writable_table = {
> +		.yes_ranges = hmc5843_writable_ranges,
> +		.n_yes_ranges = ARRAY_SIZE(hmc5843_writable_ranges),
> +};
> +
> +static const struct regmap_range hmc5843_volatile_ranges[] = {
> +		regmap_reg_range(HMC5843_DATA_OUT_MSB_REGS, HMC5843_STATUS_REG),
> +};
> +
> +static struct regmap_access_table hmc5843_volatile_table = {
> +		.yes_ranges = hmc5843_volatile_ranges,
> +		.n_yes_ranges = ARRAY_SIZE(hmc5843_volatile_ranges),
> +};
> +
> +static struct regmap_config hmc5843_regmap_config = {
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +
> +		.rd_table = &hmc5843_readable_table,
> +		.wr_table = &hmc5843_writable_table,
> +		.volatile_table = &hmc5843_volatile_table,
> +
> +		.cache_type = REGCACHE_RBTREE,
> +};
> +
>   static int hmc5843_probe(struct i2c_client *client,
>   			 const struct i2c_device_id *id)
>   {
> @@ -554,6 +603,7 @@ static int hmc5843_probe(struct i2c_client *client,
>   	data = iio_priv(indio_dev);
>   	data->client = client;
>   	data->variant = &hmc5843_chip_info_tbl[id->driver_data];
> +	data->regmap = devm_regmap_init_i2c(client, &hmc5843_regmap_config);
>   	mutex_init(&data->lock);
>
>   	i2c_set_clientdata(client, indio_dev);
>

