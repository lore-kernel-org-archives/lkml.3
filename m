Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaBMJ61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:58:27 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37101 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaBMJ6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:58:23 -0500
Date: Thu, 13 Feb 2014 09:58:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: jdelvare@suse.de, linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] hwmon: (max6650) Convert to be a platform driver
Message-ID: <20140213095817.GD32508@lee--X1>
References: <1392281438-31836-1-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392281438-31836-1-git-send-email-lpapp@kde.org>
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
> This patch has been compile tested only and will be tested with real hardware,
> but early reviews to catch any trivial issues would be welcome.
>  drivers/hwmon/Kconfig   |   2 +-
>  drivers/hwmon/max6650.c | 155 ++++++++++++++++++++++++------------------------
>  2 files changed, 79 insertions(+), 78 deletions(-)

<snip>

>  /*
>   * Insmod parameters
> @@ -105,24 +108,23 @@ module_param(clock, int, S_IRUGO);
>  
>  #define DIV_FROM_REG(reg) (1 << (reg & 7))
>  
> -static int max6650_probe(struct i2c_client *client,
> -			 const struct i2c_device_id *id);
> -static int max6650_init_client(struct i2c_client *client);
> -static int max6650_remove(struct i2c_client *client);
> +static int max6650_probe(struct platform_device *pdev);
> +static int max6650_init_client(struct platform_device *pdev);
> +static int max6650_remove(struct platform_device *pdev);
>  static struct max6650_data *max6650_update_device(struct device *dev);

It would be good to remove these forward declarations in the future.

If no one volunteers I'll happily do it.

>  /*
>   * Driver data (common to all clients)
>   */
>  
> -static const struct i2c_device_id max6650_id[] = {
> +static const struct platform_device_id max6650_id[] = {
>  	{ "max6650", 1 },
>  	{ "max6651", 4 },
>  	{ }
>  };
> -MODULE_DEVICE_TABLE(i2c, max6650_id);
> +MODULE_DEVICE_TABLE(platform, max6650_id);

I thought you were going to do the matching in the MFD driver?

If not, what's the point in the exported 'type' attribute?

> -static struct i2c_driver max6650_driver = {
> +static struct platform_driver max6650_driver = {
>  	.driver = {
>  		.name	= "max6650",

This should be changed as it now supports max665{0,1} right?

<snip>

> -	i2c_smbus_write_byte_data(client, MAX6650_REG_SPEED, data->speed);
> +	regmap_write(data->iodev->map, MAX6650_REG_SPEED, data->speed);

Ensure all of the regmap stuff is fully tested.

<snip>

> @@ -484,10 +482,12 @@ static umode_t max6650_attrs_visible(struct kobject *kobj, struct attribute *a,
>  				    int n)
>  {
>  	struct device *dev = container_of(kobj, struct device, kobj);
> -	struct i2c_client *client = to_i2c_client(dev);
> -	u8 alarm_en = i2c_smbus_read_byte_data(client, MAX6650_REG_ALARM_EN);
> +	struct max6650_data *data = dev_get_drvdata(dev);
> +	int alarm_en;
>  	struct device_attribute *devattr;
>  
> +	regmap_read(data->iodev->map, MAX6650_REG_ALARM_EN, &alarm_en);
> +

Where is this then used?

> -static int max6650_probe(struct i2c_client *client,
> -			 const struct i2c_device_id *id)
> +static int max6650_probe(struct platform_device *pdev)
>  {
> +	struct max665x_dev *max665x = dev_get_drvdata(pdev->dev.parent);
>  	struct max6650_data *data;
> +	const struct platform_device_id *id = platform_get_device_id(pdev);

What's the point in 'type' in the global container?

It's looking as though you're not going to need it to be global after
all, right?

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
