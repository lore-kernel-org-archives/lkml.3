Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaK3UAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:00:18 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53362 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaK3UAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:00:16 -0500
Message-ID: <547B7707.5060708@roeck-us.net>
Date: Sun, 30 Nov 2014 11:59:03 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH v2 3/5] hwmon: ina2xx: allow to change the averaging rate
 at run-time
References: <1417082350-23470-1-git-send-email-bgolaszewski@baylibre.com> <1417082350-23470-4-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1417082350-23470-4-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.547B774F.016E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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
> The averaging rate of ina226 is hardcoded to 16 in the driver.
>
> Make it modifiable at run-time via a new sysfs attribute.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/hwmon/ina2xx.c | 120 ++++++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 109 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index 341da67..7fdb586 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -54,6 +54,9 @@
>   /* shunt resistor sysfs attribute index */
>   #define INA2XX_RSHUNT			0x8
>
> +/* INA226 averaging sysfs index */
> +#define INA226_AVG			0x9
> +
>   /* register count */
>   #define INA219_REGISTERS		6
>   #define INA226_REGISTERS		8
> @@ -70,6 +73,12 @@
>   /* default shunt resistance */
>   #define INA2XX_RSHUNT_DEFAULT		10000
>
> +/* bit masks for the averaging setting in the configuration register */
> +#define INA226_AVG_RD_MASK		0x0E00
> +#define INA226_AVG_WR_MASK		0xF1FF
> +
> +#define INA226_READ_AVG(reg) ((reg & INA226_AVG_RD_MASK) >> 9)
> +
>   enum ina2xx_ids { ina219, ina226 };
>
>   struct ina2xx_config {
> @@ -117,11 +126,57 @@ static const struct ina2xx_config ina2xx_config[] = {
>   	},
>   };
>
> +/* Available averaging rates for ina226. The indices correspond with

We use standard multi-line comment style in hwmon.

> + * the bit values expected by the chip (according to the ina226 datasheet,
> + * table 3 AVG bit settings, found at
> + * http://www.ti.com/lit/ds/symlink/ina226.pdf.
> + */
> +static const int ina226_avg_tab[] = { 1, 4, 16, 64, 128, 256, 512, 1024 };
> +
>   static u16 ina2xx_calibration_val(const struct ina2xx_data *data)
>   {
>   	return data->config->calibration_factor / data->rshunt;
>   }
>
> +static int ina226_avg_bits(int avg)
> +{
> +	int i;
> +
> +	for (i = 0; i <= ARRAY_SIZE(ina226_avg_tab); i++) {
> +		if (avg == ina226_avg_tab[i])
> +			return i;

Reads beyond the end of the table.

> +	}
> +
> +	return -EINVAL;

You are expecting the user to know the valid averages.

> +}
> +
> +static int ina226_avg_val(int bits)
> +{
> +	/* Value read from the config register should be correct, but do check
> +	 * the boundary just in case.
> +	 */
> +	if (bits >= ARRAY_SIZE(ina226_avg_tab)) {
> +		WARN_ON_ONCE(1);

Really ? Traceback if you read an unexpected value from the chip ?

> +		return -1;

Please use a defined error code.

> +	}
> +
> +	return ina226_avg_tab[bits];
> +}
> +
> +static inline int ina226_update_avg(struct ina2xx_data *data, int avg)
> +{
> +	int status;
> +	u16 conf;
> +
> +	mutex_lock(&data->update_lock);
> +	conf = (data->regs[INA2XX_CONFIG] & INA226_AVG_WR_MASK) | (avg << 9);
> +	status = i2c_smbus_write_word_swapped(data->client,
> +					      INA2XX_CONFIG, conf);
> +	mutex_unlock(&data->update_lock);
> +
> +	return status;
> +}
> +
>   static struct ina2xx_data *ina2xx_update_device(struct device *dev)
>   {
>   	struct ina2xx_data *data = dev_get_drvdata(dev);
> @@ -179,6 +234,10 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
>   	case INA2XX_RSHUNT:
>   		val = data->rshunt;
>   		break;
> +	case INA226_AVG:
> +		val = ina226_avg_val(INA226_READ_AVG(
> +				     data->regs[INA2XX_CONFIG]));
> +		break;
>   	default:
>   		/* programmer goofed */
>   		WARN_ON_ONCE(1);
> @@ -202,10 +261,22 @@ static ssize_t ina2xx_show_value(struct device *dev,
>   			ina2xx_get_value(data, attr->index));
>   }
>
> -static ssize_t ina2xx_set_shunt(struct device *dev,

Use separate functions. There is no common code.

> +static ssize_t ina226_show_avg(struct device *dev,
> +			       struct device_attribute *da, char *buf)
> +{
> +	struct ina2xx_data *data = dev_get_drvdata(dev);
> +
> +	if (data->kind != ina226)
> +		return -ENXIO;
> +
No.

> +	return ina2xx_show_value(dev, da, buf);
> +}
> +
> +static ssize_t ina2xx_set_value(struct device *dev,
>   				struct device_attribute *da,
>   				const char *buf, size_t count)
>   {
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(da);
>   	struct ina2xx_data *data = ina2xx_update_device(dev);
>   	long val;
>   	int status;
> @@ -217,16 +288,38 @@ static ssize_t ina2xx_set_shunt(struct device *dev,
>   	if (status < 0)
>   		return status;
>
> -	if (val == 0)
> -		return -EINVAL;
> +	switch (attr->index) {
> +	case INA2XX_RSHUNT:
> +		if (val == 0)
> +			return -EINVAL;
>
> -	mutex_lock(&data->update_lock);
> -	data->rshunt = val;
> -	status = i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
> -					      ina2xx_calibration_val(data));
> -	mutex_unlock(&data->update_lock);
> -	if (status < 0)
> -		return status;
> +		mutex_lock(&data->update_lock);
> +		data->rshunt = val;
> +		status = i2c_smbus_write_word_swapped(data->client,
> +			INA2XX_CALIBRATION, ina2xx_calibration_val(data));
> +		mutex_unlock(&data->update_lock);
> +		if (status < 0)
> +			return status;
> +
> +		break;
> +	case INA226_AVG:
> +		if (data->kind != ina226)
> +			return -ENXIO;
> +
For other chips the attribute should not exist or be handled correctly.
ENXIO is inappropriate.

> +		status = ina226_avg_bits(val);
> +		if (status < 0)
> +			return status;
> +
> +		status = ina226_update_avg(data, status);
> +		if (status < 0)
> +			return status;
> +		break;
> +	default:
> +		/* programmer goofed */
> +		WARN_ON_ONCE(1);
> +		val = 0;
> +		break;
> +	}
>
>   	return count;
>   }
> @@ -249,7 +342,11 @@ static SENSOR_DEVICE_ATTR(power1_input, S_IRUGO, ina2xx_show_value, NULL,
>
>   /* shunt resistance */
>   static SENSOR_DEVICE_ATTR(shunt_resistor, S_IRUGO | S_IWUSR | S_IWGRP,
> -			  ina2xx_show_value, ina2xx_set_shunt, INA2XX_RSHUNT);
> +			  ina2xx_show_value, ina2xx_set_value, INA2XX_RSHUNT);
> +
> +/* averaging rate */
> +static SENSOR_DEVICE_ATTR(avg_rate, S_IRUGO | S_IWUSR | S_IWGRP,
> +			  ina226_show_avg, ina2xx_set_value, INA226_AVG);
>
>   /* pointers to created device attributes */
>   static struct attribute *ina2xx_attrs[] = {
> @@ -258,6 +355,7 @@ static struct attribute *ina2xx_attrs[] = {
>   	&sensor_dev_attr_curr1_input.dev_attr.attr,
>   	&sensor_dev_attr_power1_input.dev_attr.attr,
>   	&sensor_dev_attr_shunt_resistor.dev_attr.attr,
> +	&sensor_dev_attr_avg_rate.dev_attr.attr,
>   	NULL,
>   };
>   ATTRIBUTE_GROUPS(ina2xx);
>

