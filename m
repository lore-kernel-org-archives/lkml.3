Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaBNMAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:00:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64861 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaBNMA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:00:29 -0500
Date: Fri, 14 Feb 2014 12:00:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: jdelvare@suse.de, linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hwmon: (max6650) Convert to be a platform driver
Message-ID: <20140214120023.GH9462@lee--X1>
References: <1392369342-11472-1-git-send-email-lpapp@kde.org>
 <1392369342-11472-3-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392369342-11472-3-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The MFD driver has now been added, so this driver is now being adopted to be a
> subdevice driver on top of it. This means, the i2c driver usage is being
> converted to platform driver usage all around.
> 
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/hwmon/Kconfig   |   2 +-
>  drivers/hwmon/max6650.c | 125 ++++++++++++++++++++++++------------------------
>  2 files changed, 63 insertions(+), 64 deletions(-)
> 
<snip>

> @@ -39,6 +39,9 @@
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/err.h>
> +#include <linux/platform_device.h>
> +

Not really any need for this.

> +#include <linux/mfd/max665x-private.h>

<snip>

>  struct max6650_data {
>  	struct i2c_client *client;
>  	const struct attribute_group *groups[3];
> +	struct max665x_dev *iodev;

I find the name iodev a bit confusing, why not max665x_dev?

<snip>

> -		data->speed = i2c_smbus_read_byte_data(client,
> -						       MAX6650_REG_SPEED);
> -		data->config = i2c_smbus_read_byte_data(client,
> -							MAX6650_REG_CONFIG);
> +		regmap_read(map, MAX6650_REG_SPEED, &data->speed);
> +		regmap_read(map, MAX6650_REG_CONFIG, &data->config);

I'd like Mark to look over your Regmap implementation if possible.

>  	if (config < 0) {
> -		dev_err(dev, "Error reading config, aborting.\n");
> +		dev_err(&pdev->dev, "Error reading config, aborting.\n");

Rather than make all these changes, just do:

  struct device *dev = &pdev->dev;

... at the top.

<snip>

> +static int max6650_probe(struct platform_device *pdev)
>  {
> -	struct device *dev = &client->dev;
> -	struct max6650_data *data;
> +	struct max6650_data *data = platform_get_drvdata(pdev);

Don't do this here, it's messy. Declare it here and initialise it later.

> +	const struct platform_device_id *id = platform_get_device_id(pdev);

Same here.

>  	struct device *hwmon_dev;
>  	int err;
>  
> -	data = devm_kzalloc(dev, sizeof(struct max6650_data), GFP_KERNEL);
> +	data = devm_kzalloc(&pdev->dev, sizeof(struct max6650_data),
> +							GFP_KERNEL);

Eh? didn't you already initialise 'data'?

<snip>

> -	hwmon_dev = devm_hwmon_device_register_with_groups(dev,
> -							   client->name, data,
> -							   data->groups);
> +	hwmon_dev = devm_hwmon_device_register_with_groups(&pdev->dev,
> +							   data->client->name,
> +							   data, data->groups);

Leave it as 'dev'.

> -static const struct i2c_device_id max6650_id[] = {
> +static const struct platform_device_id max6650_id[] = {
>  	{ "max6650", 1 },
>  	{ "max6651", 4 },

I'm still pretty keen to have these magic numbers #defined.

Not yet though, let's get this sorted first.

> +static struct platform_driver max6650_driver = {
>  	.driver = {
>  		.name	= "max6650",

Guenter, Jean,
  Can this be changed now it's a platform device?

Laszio,
  Next thing to do is to get this working and runtime test it. No more
  mid-term reviews until it's fully functional.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
