Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaLUQgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 11:36:33 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52600 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaLUQga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 11:36:30 -0500
Date: Sun, 21 Dec 2014 08:36:17 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Patrick Titiano <ptitiano@baylibre.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [v7, 5/5] hwmon: ina2xx: allow to change the averaging rate at
 run-time
Message-ID: <20141221163617.GA5131@roeck-us.net>
References: <1418488041-7433-6-git-send-email-bgolaszewski@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418488041-7433-6-git-send-email-bgolaszewski@baylibre.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5496F70B.0187,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 05:27:21PM +0100, Bartosz Golaszewski wrote:
> The averaging rate of ina226 is hardcoded to 16 in the driver. Make it
> modifiable at run-time via a new sysfs attribute.
> 
> While we're at it - add an additional variable to ina2xx_data, which holds
> the current configuration settings - this way we'll be able to restore the
> configuration in case of an unexpected chip reset.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  Documentation/hwmon/ina2xx |   3 ++
>  drivers/hwmon/ina2xx.c     | 132 +++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 131 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
> index 320dd69..a11256d 100644
> --- a/Documentation/hwmon/ina2xx
> +++ b/Documentation/hwmon/ina2xx
> @@ -48,3 +48,6 @@ The shunt value in micro-ohms can be set via platform data or device tree at
>  compile-time or via the shunt_resistor attribute in sysfs at run-time. Please
>  refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
>  if the device tree is used.
> +
> +The averaging rate of INA226 and INA230 can be changed via the avg_rate sysfs
> +attribute. The available rates are: 1, 4, 16, 64, 128, 256, 512 and 1024.
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index 49537ea..d6fccad 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -68,6 +68,15 @@
>  
>  #define INA2XX_RSHUNT_DEFAULT		10000
>  
> +/* bit masks for the averaging setting in the configuration register */
> +#define INA226_AVG_RD_MASK		0x0E00
> +#define INA226_AVG_WR_MASK		0xF1FF
> +
> +#define INA226_READ_AVG(reg) ((reg & INA226_AVG_RD_MASK) >> 9)
> +
> +/* common attrs, ina226 attrs and NULL */
> +#define INA2XX_MAX_ATTRIBUTE_GROUPS	3
> +
>  enum ina2xx_ids { ina219, ina226 };
>  
>  struct ina2xx_config {
> @@ -85,12 +94,14 @@ struct ina2xx_data {
>  	const struct ina2xx_config *config;
>  
>  	long rshunt;
> +	u16 curr_config;
>  
>  	struct mutex update_lock;
>  	bool valid;
>  	unsigned long last_updated;
>  
>  	int kind;
> +	const struct attribute_group *groups[INA2XX_MAX_ATTRIBUTE_GROUPS];
>  	u16 regs[INA2XX_MAX_REGISTERS];
>  };
>  
> @@ -115,6 +126,38 @@ static const struct ina2xx_config ina2xx_config[] = {
>  	},
>  };
>  
> +/*
> + * Available averaging rates for ina226. The indices correspond with
> + * the bit values expected by the chip (according to the ina226 datasheet,
> + * table 3 AVG bit settings, found at
> + * http://www.ti.com/lit/ds/symlink/ina226.pdf.
> + */
> +static const int ina226_avg_tab[] = { 1, 4, 16, 64, 128, 256, 512, 1024 };
> +
> +static int ina226_avg_bits(int avg)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ina226_avg_tab); i++) {
> +		if (avg == ina226_avg_tab[i])
> +			return i;

I would suggest to select the closest valid average.

> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int ina226_avg_val(int bits)
> +{
> +	/*
> +	 * Value read from the config register should be correct, but do check
> +	 * the boundary just in case.
> +	 */
> +	if (bits >= ARRAY_SIZE(ina226_avg_tab))
> +		return -ENODEV;
> +
> +	return ina226_avg_tab[bits];
> +}
> +
>  static int ina2xx_calibrate(struct ina2xx_data *data)
>  {
>  	return i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
> @@ -131,7 +174,7 @@ static int ina2xx_init(struct ina2xx_data *data)
>  
>  	/* device configuration */
>  	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
> -					   data->config->config_default);
> +					   data->curr_config);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -292,6 +335,66 @@ static ssize_t ina2xx_set_shunt(struct device *dev,
>  	return count;
>  }
>  
> +static ssize_t ina226_show_avg(struct device *dev,
> +			       struct device_attribute *da, char *buf)
> +{
> +	struct ina2xx_data *data = ina2xx_update_device(dev);
> +	int avg, i, written = 0;
> +	const char *fmt;
> +
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	avg = ina226_avg_val(INA226_READ_AVG(data->regs[INA2XX_CONFIG]));
> +	if (avg < 0)
> +		return avg;
> +
> +	for (i = 0; i < ARRAY_SIZE(ina226_avg_tab); i++) {
> +		if (avg == ina226_avg_tab[i])
> +			fmt = "\t[%d]";
> +		else
> +			fmt = "\t%d";
> +
> +		written += snprintf(buf + written, PAGE_SIZE - written,
> +				    fmt, ina226_avg_tab[i]);
> +	}
> +	written += snprintf(buf + written, PAGE_SIZE - written, "\n");
> +
No. sysfs attributes return a single value, not a range.
So you have to return the current value here and nothing else.

This is why it would be better to be more flexibe when accepting a new average.

> +	return written;
> +}
> +
> +static ssize_t ina226_set_avg(struct device *dev,
> +			      struct device_attribute *da,
> +			      const char *buf, size_t count)
> +{
> +	struct ina2xx_data *data = ina2xx_update_device(dev);

Calling update_device here is not necessary.

> +	long val;
> +	int status, avg;
> +
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	status = kstrtol(buf, 10, &val);
> +	if (status < 0)
> +		return status;
> +
> +	avg = ina226_avg_bits(val);
> +	if (avg < 0)
> +		return avg;
> +
> +	mutex_lock(&data->update_lock);
> +	data->curr_config = (data->regs[INA2XX_CONFIG] &
> +			     INA226_AVG_WR_MASK) | (avg << 9);
> +	status = i2c_smbus_write_word_swapped(data->client,
> +					      INA2XX_CONFIG,
> +					      data->curr_config);

You should set data->valid to 0 here to ensure that the next access
re-reads all registers.

> +	mutex_unlock(&data->update_lock);
> +	if (status < 0)
> +		return status;
> +
> +	return count;
> +}
> +
>  /* shunt voltage */
>  static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, ina2xx_show_value, NULL,
>  			  INA2XX_SHUNT_VOLTAGE);
> @@ -313,6 +416,10 @@ static SENSOR_DEVICE_ATTR(shunt_resistor, S_IRUGO | S_IWUSR,
>  			  ina2xx_show_value, ina2xx_set_shunt,
>  			  INA2XX_CALIBRATION);
>  
> +/* averaging rate */
> +static SENSOR_DEVICE_ATTR(avg_rate, S_IRUGO | S_IWUSR,
> +			  ina226_show_avg, ina226_set_avg, 0);
> +
>  /* pointers to created device attributes */
>  static struct attribute *ina2xx_attrs[] = {
>  	&sensor_dev_attr_in0_input.dev_attr.attr,
> @@ -322,7 +429,19 @@ static struct attribute *ina2xx_attrs[] = {
>  	&sensor_dev_attr_shunt_resistor.dev_attr.attr,
>  	NULL,
>  };
> -ATTRIBUTE_GROUPS(ina2xx);
> +
> +static const struct attribute_group ina2xx_group = {
> +	.attrs = ina2xx_attrs,
> +};
> +
> +static struct attribute *ina226_attrs[] = {
> +	&sensor_dev_attr_avg_rate.dev_attr.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group ina226_group = {
> +	.attrs = ina226_attrs,
> +};
>  
>  static int ina2xx_probe(struct i2c_client *client,
>  			const struct i2c_device_id *id)
> @@ -333,7 +452,7 @@ static int ina2xx_probe(struct i2c_client *client,
>  	struct ina2xx_data *data;
>  	struct device *hwmon_dev;
>  	u32 val;
> -	int ret;
> +	int ret, group = 0;
>  
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
>  		return -ENODEV;
> @@ -355,6 +474,7 @@ static int ina2xx_probe(struct i2c_client *client,
>  	/* set the device type */
>  	data->kind = id->driver_data;
>  	data->config = &ina2xx_config[data->kind];
> +	data->curr_config = data->config->config_default;
>  	data->client = client;
>  
>  	if (data->rshunt <= 0 ||
> @@ -369,8 +489,12 @@ static int ina2xx_probe(struct i2c_client *client,
>  
>  	mutex_init(&data->update_lock);
>  
> +	data->groups[group++] = &ina2xx_group;
> +	if (data->kind == ina226)
> +		data->groups[group++] = &ina226_group;
> +
>  	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
> -							   data, ina2xx_groups);
> +							   data, data->groups);
>  	if (IS_ERR(hwmon_dev))
>  		return PTR_ERR(hwmon_dev);
>  
