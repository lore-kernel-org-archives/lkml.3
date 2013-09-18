Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3IRLG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:06:56 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39739 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3IRLGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:06:53 -0400
Date: Wed, 18 Sep 2013 04:06:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, khali@linux-fr.org,
        rui.zhang@intel.com, wni@nvidia.com, grant.likely@linaro.org,
        durgadoss.r@intel.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 06/16] hwmon: tmp102: expose to thermal fw via DT nodes
Message-ID: <20130918110649.GA9050@roeck-us.net>
References: <523643D4.30208@roeck-us.net>
 <1379457245-17810-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379457245-17810-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 06:34:05PM -0400, Eduardo Valentin wrote:
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
>  drivers/hwmon/tmp102.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> ---
> 
> Guenter,
> 
> Here is a version without the warnings, as requested.
> 
> Eduardo
> 
> diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
> index d7b47ab..dc96598 100644
> --- a/drivers/hwmon/tmp102.c
> +++ b/drivers/hwmon/tmp102.c
> @@ -27,6 +27,8 @@
>  #include <linux/mutex.h>
>  #include <linux/device.h>
>  #include <linux/jiffies.h>
> +#include <linux/thermal.h>
> +#include <linux/of.h>
>  
>  #define	DRIVER_NAME "tmp102"
>  
> @@ -50,6 +52,7 @@
>  
>  struct tmp102 {
>  	struct device *hwmon_dev;
> +	struct thermal_zone_device *tz;
>  	struct mutex lock;
>  	u16 config_orig;
>  	unsigned long last_update;
> @@ -93,6 +96,15 @@ static struct tmp102 *tmp102_update_device(struct i2c_client *client)
>  	return tmp102;
>  }
>  
> +static int tmp102_read_temp(void *dev, long *temp)
> +{
> +	struct tmp102 *tmp102 = tmp102_update_device(to_i2c_client(dev));
> +
> +	*temp = tmp102->temp[0];
> +
> +	return 0;
> +}
> +
>  static ssize_t tmp102_show_temp(struct device *dev,
>  				struct device_attribute *attr,
>  				char *buf)
> @@ -204,6 +216,12 @@ static int tmp102_probe(struct i2c_client *client,
>  		goto fail_remove_sysfs;
>  	}
>  
> +	tmp102->tz = thermal_zone_of_sensor_register(&client->dev, 0,
> +						     &client->dev,
> +						     tmp102_read_temp, NULL);
> +	if (IS_ERR(tmp102->tz))
> +		tmp102->tz = NULL;
> +
>  	dev_info(&client->dev, "initialized\n");
>  
>  	return 0;
> @@ -220,6 +238,8 @@ static int tmp102_remove(struct i2c_client *client)
>  {
>  	struct tmp102 *tmp102 = i2c_get_clientdata(client);
>  
> +	/* thermal zone life cycle is not our responsibility */

This comment does not provide any value. Please drop it from both drivers.
Sorry I missed that earlier.

> +	thermal_zone_of_sensor_unregister(&client->dev, tmp102->tz);
>  	hwmon_device_unregister(tmp102->hwmon_dev);
>  	sysfs_remove_group(&client->dev.kobj, &tmp102_attr_group);
>  
> -- 
> 1.8.2.1.342.gfa7285d
> 
> 
