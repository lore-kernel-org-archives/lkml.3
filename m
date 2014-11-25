Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaKYQAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:00:03 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:46214 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKYP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:59:59 -0500
Message-ID: <5474A77B.10806@roeck-us.net>
Date: Tue, 25 Nov 2014 07:59:55 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>
Subject: Re: [PATCH 2/5] hwmon: ina2xx: make shunt resistance configurable
 at run-time
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com> <1416930423-12179-3-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1416930423-12179-3-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5474A77F.0016,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 11/25/2014 07:47 AM, Bartosz Golaszewski wrote:
> The shunt resistance can only be set via platform_data or device tree. This
> isn't suitable for devices in which the shunt resistance can change/isn't
> known at boot-time.
>
For a given system it should always be known, and it appears unlikely
that there is a system out there where the shunt resistor value can change.

What system exactly are you talking about ?

Thanks,
Guenter

> Add a sysfs attribute that allows to read and set the shunt resistance.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/hwmon/ina2xx.c | 58 ++++++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 51 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index 660f8ca..eb66081 100644
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
> +	return (u16)(data->config->calibration_factor / data->rshunt);
> +}
> +
>   static int ina2xx_write_register(const struct i2c_client *client,
>   						u8 reg, u16 value)
>   {
> @@ -198,6 +210,9 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
>   		/* signed register, LSB=1mA (selected), in mA */
>   		val = (s16)data->regs[reg];
>   		break;
> +	case INA2XX_RSHUNT:
> +		val = data->rshunt;
> +		break;
>   	default:
>   		/* programmer goofed */
>   		WARN_ON_ONCE(1);
> @@ -221,6 +236,30 @@ static ssize_t ina2xx_show_value(struct device *dev,
>   			ina2xx_get_value(data, attr->index));
>   }
>
> +static ssize_t ina2xx_set_shunt(struct device *dev,
> +				struct device_attribute *da,
> +				const char *buf, size_t count)
> +{
> +	struct ina2xx_data *data = ina2xx_update_device(dev);
> +	long val;
> +	s32 status;
> +
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	if ((kstrtol(buf, 10, &val) == -EINVAL) || (val <= 0))
> +		return -EINVAL;
> +
> +	mutex_lock(&data->update_lock);
> +	data->rshunt = val;
> +	status = ina2xx_calibrate(data->client, ina2xx_calibration_val(data));
> +	mutex_unlock(&data->update_lock);
> +	if (status < 0)
> +		return -ENODEV;
> +
> +	return count;
> +}
> +
>   /* shunt voltage */
>   static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, ina2xx_show_value, NULL,
>   			  INA2XX_SHUNT_VOLTAGE);
> @@ -237,12 +276,17 @@ static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, ina2xx_show_value, NULL,
>   static SENSOR_DEVICE_ATTR(power1_input, S_IRUGO, ina2xx_show_value, NULL,
>   			  INA2XX_POWER);
>
> +/* shunt resistance */
> +static SENSOR_DEVICE_ATTR(rshunt, S_IRUGO | S_IWUSR | S_IWGRP,
> +			  ina2xx_show_value, ina2xx_set_shunt, INA2XX_RSHUNT);
> +
>   /* pointers to created device attributes */
>   static struct attribute *ina2xx_attrs[] = {
>   	&sensor_dev_attr_in0_input.dev_attr.attr,
>   	&sensor_dev_attr_in1_input.dev_attr.attr,
>   	&sensor_dev_attr_curr1_input.dev_attr.attr,
>   	&sensor_dev_attr_power1_input.dev_attr.attr,
> +	&sensor_dev_attr_rshunt.dev_attr.attr,
>   	NULL,
>   };
>   ATTRIBUTE_GROUPS(ina2xx);
> @@ -255,7 +299,6 @@ static int ina2xx_probe(struct i2c_client *client,
>   	struct device *dev = &client->dev;
>   	struct ina2xx_data *data;
>   	struct device *hwmon_dev;
> -	long shunt = 10000; /* default shunt value 10mOhms */
>   	u32 val;
>
>   	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
> @@ -267,13 +310,15 @@ static int ina2xx_probe(struct i2c_client *client,
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
> @@ -287,8 +332,7 @@ static int ina2xx_probe(struct i2c_client *client,
>   	/* Set current LSB to 1mA, shunt is in uOhms
>   	 * (equation 13 in datasheet).
>   	 */
> -	if (ina2xx_calibrate(client,
> -			data->config->calibration_factor / shunt) < 0)
> +	if (ina2xx_calibrate(client, ina2xx_calibration_val(data)) < 0)
>   		return -ENODEV;
>
>   	data->client = client;
> @@ -300,7 +344,7 @@ static int ina2xx_probe(struct i2c_client *client,
>   		return PTR_ERR(hwmon_dev);
>
>   	dev_info(dev, "power monitor %s (Rshunt = %li uOhm)\n",
> -		 id->name, shunt);
> +		 id->name, data->rshunt);
>
>   	return 0;
>   }
>

