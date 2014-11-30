Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaK3Tps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 14:45:48 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51544 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaK3Tpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 14:45:47 -0500
Message-ID: <547B739D.7040405@roeck-us.net>
Date: Sun, 30 Nov 2014 11:44:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH v2 2/5] hwmon: ina2xx: make shunt resistance configurable
 at run-time
References: <1417082350-23470-1-git-send-email-bgolaszewski@baylibre.com> <1417082350-23470-3-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1417082350-23470-3-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.547B73EA.00E4,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
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

On 11/27/2014 01:59 AM, Bartosz Golaszewski wrote:
> The shunt resistance can only be set via platform_data or device tree. This
> isn't suitable for devices in which the shunt resistance can change/isn't
> known at boot-time.
>
> Add a sysfs attribute that allows to read and set the shunt resistance.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/hwmon/ina2xx.c | 62 +++++++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 56 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index 0a6b60f..341da67 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -51,6 +51,8 @@
>   #define INA226_ALERT_LIMIT		0x07
>   #define INA226_DIE_ID			0xFF
>
> +/* shunt resistor sysfs attribute index */
> +#define INA2XX_RSHUNT			0x8
>
>   /* register count */
>   #define INA219_REGISTERS		6
> @@ -65,6 +67,9 @@
>   /* worst case is 68.10 ms (~14.6Hz, ina219) */
>   #define INA2XX_CONVERSION_RATE		15
>
> +/* default shunt resistance */
> +#define INA2XX_RSHUNT_DEFAULT		10000
> +
>   enum ina2xx_ids { ina219, ina226 };
>
>   struct ina2xx_config {
> @@ -87,6 +92,8 @@ struct ina2xx_data {
>
>   	int kind;
>   	u16 regs[INA2XX_MAX_REGISTERS];
> +
> +	long rshunt;
>   };
>
>   static const struct ina2xx_config ina2xx_config[] = {
> @@ -110,6 +117,11 @@ static const struct ina2xx_config ina2xx_config[] = {
>   	},
>   };
>
> +static u16 ina2xx_calibration_val(const struct ina2xx_data *data)
> +{
> +	return data->config->calibration_factor / data->rshunt;
> +}
> +
>   static struct ina2xx_data *ina2xx_update_device(struct device *dev)
>   {
>   	struct ina2xx_data *data = dev_get_drvdata(dev);
> @@ -164,6 +176,9 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
>   		/* signed register, LSB=1mA (selected), in mA */
>   		val = (s16)data->regs[reg];
>   		break;
> +	case INA2XX_RSHUNT:
> +		val = data->rshunt;
> +		break;

That doesn't make sense. You neither read the current shunt resistor value
with update_device, nor use the register value to calculate the programmed
shunt resistor value. Just define a separate show function which reports
rshunt as configured.

A better alternative would be to actually _read_ and report rshunt as
programmed into the chip. Otherwise you'll get the "old" value of rshunt
even if the chip was, as your use case suggests, pulled and re-inserted.

>   	default:
>   		/* programmer goofed */
>   		WARN_ON_ONCE(1);
> @@ -187,6 +202,35 @@ static ssize_t ina2xx_show_value(struct device *dev,
>   			ina2xx_get_value(data, attr->index));
>   }
>
> +static ssize_t ina2xx_set_shunt(struct device *dev,
> +				struct device_attribute *da,
> +				const char *buf, size_t count)
> +{
> +	struct ina2xx_data *data = ina2xx_update_device(dev);
> +	long val;

This should be unsigned long since you now use kstrtoul.

> +	int status;
> +
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	status = kstrtoul(buf, 10, &val);
> +	if (status < 0)
> +		return status;

This will accept a value of 0xffffffff which is then converted into -1
since data->rshunt is defined as long.

> +
> +	if (val == 0)
> +		return -EINVAL;
> +
> +	mutex_lock(&data->update_lock);
> +	data->rshunt = val;
> +	status = i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
> +					      ina2xx_calibration_val(data));
> +	mutex_unlock(&data->update_lock);
> +	if (status < 0)
> +		return status;
> +
> +	return count;
> +}
> +
>   /* shunt voltage */
>   static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, ina2xx_show_value, NULL,
>   			  INA2XX_SHUNT_VOLTAGE);
> @@ -203,12 +247,17 @@ static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, ina2xx_show_value, NULL,
>   static SENSOR_DEVICE_ATTR(power1_input, S_IRUGO, ina2xx_show_value, NULL,
>   			  INA2XX_POWER);
>
> +/* shunt resistance */
> +static SENSOR_DEVICE_ATTR(shunt_resistor, S_IRUGO | S_IWUSR | S_IWGRP,

This will have to be S_IRUGO | S_IWUSR. We don't permit group writes.

> +			  ina2xx_show_value, ina2xx_set_shunt, INA2XX_RSHUNT);
> +
>   /* pointers to created device attributes */
>   static struct attribute *ina2xx_attrs[] = {
>   	&sensor_dev_attr_in0_input.dev_attr.attr,
>   	&sensor_dev_attr_in1_input.dev_attr.attr,
>   	&sensor_dev_attr_curr1_input.dev_attr.attr,
>   	&sensor_dev_attr_power1_input.dev_attr.attr,
> +	&sensor_dev_attr_shunt_resistor.dev_attr.attr,
>   	NULL,
>   };
>   ATTRIBUTE_GROUPS(ina2xx);
> @@ -221,7 +270,6 @@ static int ina2xx_probe(struct i2c_client *client,
>   	struct device *dev = &client->dev;
>   	struct ina2xx_data *data;
>   	struct device *hwmon_dev;
> -	long shunt = 10000; /* default shunt value 10mOhms */
>   	u32 val;
>   	int ret;
>
> @@ -234,13 +282,15 @@ static int ina2xx_probe(struct i2c_client *client,
>
>   	if (dev_get_platdata(dev)) {
>   		pdata = dev_get_platdata(dev);
> -		shunt = pdata->shunt_uohms;
> +		data->rshunt = pdata->shunt_uohms;
>   	} else if (!of_property_read_u32(dev->of_node,
>   					 "shunt-resistor", &val)) {
> -		shunt = val;
> +		data->rshunt = val;
> +	} else {
> +		data->rshunt = INA2XX_RSHUNT_DEFAULT;
>   	}
>
> -	if (shunt <= 0)
> +	if (data->rshunt <= 0)
>   		return -ENODEV;
>
>   	/* set the device type */
> @@ -260,7 +310,7 @@ static int ina2xx_probe(struct i2c_client *client,
>   	 * (equation 13 in datasheet).
>   	 */
>   	ret = i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
> -				data->config->calibration_factor / shunt);
> +					   ina2xx_calibration_val(data));
>   	if (ret < 0) {
>   		dev_err(dev,
>   			"error writing to the calibration register: %d", ret);
> @@ -276,7 +326,7 @@ static int ina2xx_probe(struct i2c_client *client,
>   		return PTR_ERR(hwmon_dev);
>
>   	dev_info(dev, "power monitor %s (Rshunt = %li uOhm)\n",
> -		 id->name, shunt);
> +		 id->name, data->rshunt);
>
>   	return 0;
>   }
>

