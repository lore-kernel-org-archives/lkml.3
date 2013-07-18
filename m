Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3GRHWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 03:22:32 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35529 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3GRHWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 03:22:30 -0400
Date: Thu, 18 Jul 2013 00:22:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, wni@nvidia.com,
        l.stach@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lm-sensors@lm-sensors.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [RESEND PATCH V1 8/9] hwmon: lm75: expose to thermal fw via DT
 nodes
Message-ID: <20130718072233.GA11120@roeck-us.net>
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com>
 <1374074248-31690-9-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374074248-31690-9-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 11:17:27AM -0400, Eduardo Valentin wrote:
> This patch adds to lm75 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
> 
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the lm75 DT node. Otherwise, the driver behavior
> will be the same.
> 
As mentioned before, your usage of devicetree information is clearly
outside the scope for devicetree data.

One clear guideline for devicetree data is that it is supposed to be usable
across multiple operating systems. Your proposal is clearly operating system
and even subsystem specific. It does _not_ describe hardware.

NACK.

Guenter

> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/hwmon/lm75.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
> index c03b490..0aa5e28 100644
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
> @@ -271,11 +287,23 @@ lm75_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  		goto exit_remove;
>  	}
>  
> +	if (of_find_node_by_name(client->dev.of_node, "thermal_zone")) {
> +		data->tz = thermal_zone_of_device_register(&client->dev,
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
> @@ -285,6 +313,7 @@ static int lm75_remove(struct i2c_client *client)
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
