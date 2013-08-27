Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3H0K1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:27:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38371 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143Ab3H0K1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:27:11 -0400
Date: Tue, 27 Aug 2013 11:27:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "wni@nvidia.com" <wni@nvidia.com>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [RFC PATCH 04/14] hwmon: tmp102: expose to thermal fw via DT
 nodes
Message-ID: <20130827102708.GE19893@e106331-lin.cambridge.arm.com>
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
 <1377299755-5134-5-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377299755-5134-5-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 12:15:45AM +0100, Eduardo Valentin wrote:
> This patch adds to tmp102 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
> 
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the tmp102 DT node. Otherwise, the driver behavior
> will be the same.

Similarly to the lm75, this requires a binding document update, but I
don't think the binding extension's necessary anyway.

Thanks,
Mark.

> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/hwmon/tmp102.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
> index d7b47ab..0f1e44a 100644
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
> +static int tmp102_read_temp(void *dev, unsigned long *temp)
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
> @@ -204,10 +216,23 @@ static int tmp102_probe(struct i2c_client *client,
>  		goto fail_remove_sysfs;
>  	}
>  
> +	if (of_find_property(client->dev.of_node, "monitored-zones", NULL)) {
> +		tmp102->tz = thermal_zone_of_device_register(&client->dev, 0,
> +							     false, /* -hwmon */
> +							     &client->dev,
> +							     tmp102_read_temp);
> +		if (IS_ERR(tmp102->tz)) {
> +			status = PTR_ERR(tmp102->tz);
> +			goto exit_hwmon;
> +		}
> +	}
> +
>  	dev_info(&client->dev, "initialized\n");
>  
>  	return 0;
>  
> +exit_hwmon:
> +	hwmon_device_unregister(tmp102->hwmon_dev);
>  fail_remove_sysfs:
>  	sysfs_remove_group(&client->dev.kobj, &tmp102_attr_group);
>  fail_restore_config:
> @@ -220,6 +245,7 @@ static int tmp102_remove(struct i2c_client *client)
>  {
>  	struct tmp102 *tmp102 = i2c_get_clientdata(client);
>  
> +	thermal_zone_device_unregister(tmp102->tz);
>  	hwmon_device_unregister(tmp102->hwmon_dev);
>  	sysfs_remove_group(&client->dev.kobj, &tmp102_attr_group);
>  
> -- 
> 1.8.2.1.342.gfa7285d
> 
> 
