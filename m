Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3IOXdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 19:33:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55600 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3IOXdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 19:33:43 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <523643D4.30208@roeck-us.net>
Date: Sun, 15 Sep 2013 16:33:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, rui.zhang@intel.com,
        wni@nvidia.com, grant.likely@linaro.org, durgadoss.r@intel.com,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 06/16] hwmon: tmp102: expose to thermal fw via DT nodes
References: <1379282563-14650-1-git-send-email-eduardo.valentin@ti.com> <1379282563-14650-7-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1379282563-14650-7-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2013 03:02 PM, Eduardo Valentin wrote:
> This patch adds to tmp102 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
>
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the tmp102 DT node. Otherwise, the driver behavior
> will be the same.
>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>   drivers/hwmon/tmp102.c | 28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
>
> diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
> index d7b47ab..e432444 100644
> --- a/drivers/hwmon/tmp102.c
> +++ b/drivers/hwmon/tmp102.c
> @@ -27,6 +27,8 @@
>   #include <linux/mutex.h>
>   #include <linux/device.h>
>   #include <linux/jiffies.h>
> +#include <linux/thermal.h>
> +#include <linux/of.h>
>
>   #define	DRIVER_NAME "tmp102"
>
> @@ -50,6 +52,7 @@
>
>   struct tmp102 {
>   	struct device *hwmon_dev;
> +	struct thermal_zone_device *tz;
>   	struct mutex lock;
>   	u16 config_orig;
>   	unsigned long last_update;
> @@ -93,6 +96,19 @@ static struct tmp102 *tmp102_update_device(struct i2c_client *client)
>   	return tmp102;
>   }
>
> +static int tmp102_read_temp(void *dev, long *temp)
> +{
> +	struct tmp102 *tmp102 = tmp102_update_device(to_i2c_client(dev));
> +
> +	if (tmp102->temp[0] < 0)
> +		dev_warn(tmp102->hwmon_dev,
> +			 "operating in negative temp: %d\n", tmp102->temp[0]);
> +

Please drop this warning.

Guenter

> +	*temp = tmp102->temp[0];
> +
> +	return 0;
> +}
> +
>   static ssize_t tmp102_show_temp(struct device *dev,
>   				struct device_attribute *attr,
>   				char *buf)
> @@ -204,6 +220,16 @@ static int tmp102_probe(struct i2c_client *client,
>   		goto fail_remove_sysfs;
>   	}
>
> +	tmp102->tz = thermal_zone_of_sensor_register(&client->dev, 0,
> +						     &client->dev,
> +						     tmp102_read_temp, NULL);
> +	if (IS_ERR(tmp102->tz)) {
> +		dev_warn(&client->dev,
> +			 "Could not parse thermal data in device tree: %ld\n",
> +			 PTR_ERR(tmp102->tz));

Please drop this warning. You already create error messages in
thermal_zone_of_sensor_register(). That should be sufficient.
The same applies to the lm75 patch.

As a side note, I would suggest to provide devm_ functions for registration.
We are introducing those for hwmon registration, which enables us to remove
most _remove functions. It would be great if we can keep it that way.

On a higher level, I don't think it is a good idea to make thermal zones
and thermal zone data mandatory. Many systems may neither need nor want it.

Guenter

> +		tmp102->tz = NULL;
> +	}
> +
>   	dev_info(&client->dev, "initialized\n");
>
>   	return 0;
> @@ -220,6 +246,8 @@ static int tmp102_remove(struct i2c_client *client)
>   {
>   	struct tmp102 *tmp102 = i2c_get_clientdata(client);
>
> +	/* thermal zone life cycle is not our responsibility */
> +	thermal_zone_of_sensor_unregister(&client->dev, tmp102->tz);
>   	hwmon_device_unregister(tmp102->hwmon_dev);
>   	sysfs_remove_group(&client->dev.kobj, &tmp102_attr_group);
>
>

