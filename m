Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3H0K0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:26:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38356 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab3H0K0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:26:11 -0400
Date: Tue, 27 Aug 2013 11:26:08 +0100
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
Subject: Re: [RFC PATCH 03/14] hwmon: lm75: expose to thermal fw via DT
 nodes
Message-ID: <20130827102608.GD19893@e106331-lin.cambridge.arm.com>
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
 <1377299755-5134-4-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377299755-5134-4-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 12:15:44AM +0100, Eduardo Valentin wrote:
> This patch adds to lm75 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
> 
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the lm75 DT node. Otherwise, the driver behavior
> will be the same.

There'll need to be a binding document if you're extending the lm75
binding. See the comment at the top of [1]. However, I don't think you
need this at all, as I explain in my comments on the previous patch.

Thanks,
Mark.

[1] Documentation/devicetree/bindings/i2c/trivial-devices.txt

> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/hwmon/lm75.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
> index c03b490..dc55908 100644
> --- a/drivers/hwmon/lm75.c
> +++ b/drivers/hwmon/lm75.c
> @@ -27,6 +27,8 @@
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/err.h>
>  #include <linux/mutex.h>
> +#include <linux/thermal.h>
> +#include <linux/of.h>
>  #include "lm75.h"
>  
>  
> @@ -70,6 +72,7 @@ static const u8 LM75_REG_TEMP[3] = {
>  /* Each client has this additional data */
>  struct lm75_data {
>  	struct device		*hwmon_dev;
> +	struct thermal_zone_device	*tz;
>  	struct mutex		update_lock;
>  	u8			orig_conf;
>  	u8			resolution;	/* In bits, between 9 and 12 */
> @@ -92,6 +95,19 @@ static struct lm75_data *lm75_update_device(struct device *dev);
>  
>  /* sysfs attributes for hwmon */
>  
> +static int lm75_read_temp(void *dev, unsigned long *temp)
> +{
> +	struct lm75_data *data = lm75_update_device(dev);
> +
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	*temp = ((data->temp[0] >> (16 - data->resolution)) * 1000) >>
> +			(data->resolution - 8);
> +
> +	return 0;
> +}
> +
>  static ssize_t show_temp(struct device *dev, struct device_attribute *da,
>  			 char *buf)
>  {
> @@ -271,11 +287,25 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		goto exit_remove;
>  	}
>  
> +	if (of_find_property(client->dev.of_node, "monitored-zones", NULL)) {
> +		data->tz = thermal_zone_of_device_register(&client->dev,
> +							   0,
> +							   false, /* -hwmon */
> +							   &client->dev,
> +							   lm75_read_temp);
> +		if (IS_ERR(data->tz)) {
> +			status = PTR_ERR(data->tz);
> +			goto exit_hwmon;
> +		}
> +	}
> +
>  	dev_info(&client->dev, "%s: sensor '%s'\n",
>  		 dev_name(data->hwmon_dev), client->name);
>  
>  	return 0;
>  
> +exit_hwmon:
> +	hwmon_device_unregister(data->hwmon_dev);
>  exit_remove:
>  	sysfs_remove_group(&client->dev.kobj, &lm75_group);
>  	return status;
> @@ -285,6 +315,7 @@ static int lm75_remove(struct i2c_client *client)
>  {
>  	struct lm75_data *data = i2c_get_clientdata(client);
>  
> +	thermal_zone_device_unregister(data->tz);
>  	hwmon_device_unregister(data->hwmon_dev);
>  	sysfs_remove_group(&client->dev.kobj, &lm75_group);
>  	lm75_write_value(client, LM75_REG_CONF, data->orig_conf);
> -- 
> 1.8.2.1.342.gfa7285d
> 
> 
