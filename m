Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3ILNbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:31:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57505 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3ILNbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:31:09 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5231C219.8030604@roeck-us.net>
Date: Thu, 12 Sep 2013 06:31:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, broonie@kernel.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] hwmon: (lm90) Add power control
References: <1378985061-28547-1-git-send-email-wni@nvidia.com> <1378985061-28547-2-git-send-email-wni@nvidia.com>
In-Reply-To: <1378985061-28547-2-git-send-email-wni@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 04:24 AM, Wei Ni wrote:
> The device lm90 can be controlled by the vcc rail.
> Adding the regulator support to power on/off the vcc rail.
> Enable the "vcc" regulator before accessing the device.
>
> Signed-off-by: Wei Ni <wni@nvidia.com>

I still believe that you should update all .dts files referencing this driver
to match the new requirement.

Guenter

> ---
>   drivers/hwmon/lm90.c |   20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index cdff742..f3f66d5 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -89,6 +89,8 @@
>   #include <linux/err.h>
>   #include <linux/mutex.h>
>   #include <linux/sysfs.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/delay.h>
>
>   /*
>    * Addresses to scan
> @@ -302,6 +304,7 @@ static const struct lm90_params lm90_params[] = {
>   struct lm90_data {
>   	struct device *hwmon_dev;
>   	struct mutex update_lock;
> +	struct regulator *lm90_reg;
>   	char valid; /* zero until following fields are valid */
>   	unsigned long last_updated; /* in jiffies */
>   	int kind;
> @@ -1397,8 +1400,20 @@ static int lm90_probe(struct i2c_client *client,
>   	struct device *dev = &client->dev;
>   	struct i2c_adapter *adapter = to_i2c_adapter(dev->parent);
>   	struct lm90_data *data;
> +	struct regulator *reg;
>   	int err;
>
> +	reg = devm_regulator_get(dev, "vcc");
> +	if (IS_ERR(reg))
> +		return PTR_ERR(reg);
> +
> +	err = regulator_enable(reg);
> +	if (err < 0) {
> +		dev_err(&client->dev,
> +			"Failed to enable regulator: %d\n", err);
> +		return err;
> +	}
> +
>   	data = devm_kzalloc(&client->dev, sizeof(struct lm90_data), GFP_KERNEL);
>   	if (!data)
>   		return -ENOMEM;
> @@ -1406,6 +1421,8 @@ static int lm90_probe(struct i2c_client *client,
>   	i2c_set_clientdata(client, data);
>   	mutex_init(&data->update_lock);
>
> +	data->lm90_reg = reg;
> +
>   	/* Set the device type */
>   	data->kind = id->driver_data;
>   	if (data->kind == adm1032) {
> @@ -1473,6 +1490,8 @@ exit_remove_files:
>   	lm90_remove_files(client, data);
>   exit_restore:
>   	lm90_restore_conf(client, data);
> +	regulator_disable(data->lm90_reg);
> +
>   	return err;
>   }
>
> @@ -1483,6 +1502,7 @@ static int lm90_remove(struct i2c_client *client)
>   	hwmon_device_unregister(data->hwmon_dev);
>   	lm90_remove_files(client, data);
>   	lm90_restore_conf(client, data);
> +	regulator_disable(data->lm90_reg);
>
>   	return 0;
>   }
>

