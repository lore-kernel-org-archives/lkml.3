Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab3GRFdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 01:33:24 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13151 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab3GRFdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 01:33:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 17 Jul 2013 22:33:04 -0700
Message-ID: <51E77E1D.3000306@nvidia.com>
Date: Thu, 18 Jul 2013 13:33:17 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [RESEND PATCH V1 8/9] hwmon: lm75: expose to thermal fw via DT
 nodes
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com> <1374074248-31690-9-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1374074248-31690-9-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 11:17 PM, Eduardo Valentin wrote:
> This patch adds to lm75 temperature sensor the possibility
> to expose itself as thermal zone device, registered on the
> thermal framework.
> 
> The thermal zone is built only if a device tree node
> describing a thermal zone for this sensor is present
> inside the lm75 DT node. Otherwise, the driver behavior
> will be the same.
> 
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

Hi, Eduardo
I have two questions:
1. As we know, after register to the thermal framework, it will have
duplicate hwmon devices. I think lm-sensor maintainer would not like this.
How about to add a flag to indicate it, which I talk about with
Durgadoss in your [RFC 1/4]patch.

2. I'm also trying to use your codes on lm90. The LM90 serial has more
then one sensors in one chip, local sensor, remote sensor and may have
remote2 sensor, so it mean there may have more than one thermal_zone
under the lm90 device node, will you consider it?

Thanks.
Wei.

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
> 

