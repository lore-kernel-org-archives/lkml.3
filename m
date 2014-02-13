Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBMRlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:41:46 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49707 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaBMRlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <1387814889-16670-3-git-send-email-lpapp@kde.org>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-3-git-send-email-lpapp@kde.org>
Date: Thu, 13 Feb 2014 17:41:43 +0000
X-Google-Sender-Auth: WwoEYbmE_y8OMQyUUNzGWte5LrE
Message-ID: <CAOMwXhOq7-dGDa1K_QxPqke2mEB9x4B8BbWHAUtKLnPpwB6O2Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] hwmon: (max6650) Convert to be a platform driver
From: Laszlo Papp <lpapp@kde.org>
To: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Laszlo Papp <lpapp@kde.org>,
        Jean Delvare <jdelvare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping? Fwiw, this change has been submitted a bit less two months ago,
and it has not still received any feedback from the hwmon maintainers.

On Mon, Dec 23, 2013 at 4:08 PM, Laszlo Papp <lpapp@kde.org> wrote:
> The MFD driver has now been added, so this driver is now being adopted to be a
> subdevice driver on top of it. This means, the i2c driver usage is being
> converted to platform driver usage all around.
>
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/hwmon/Kconfig   |   2 +-
>  drivers/hwmon/max6650.c | 150 +++++++++++++++++++++++++-----------------------
>  drivers/mfd/max6651.c   |   2 +-
>  3 files changed, 80 insertions(+), 74 deletions(-)
>
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 52d548f..ee4fb07 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -925,7 +925,7 @@ config SENSORS_MAX6642
>
>  config SENSORS_MAX6650
>         tristate "Maxim MAX6650 sensor chip"
> -       depends on I2C
> +       depends on MFD_MAX6651
>         help
>           If you say yes here you get support for the MAX6650 / MAX6651
>           sensor chips.
> diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
> index 0cafc39..ec7dac2 100644
> --- a/drivers/hwmon/max6650.c
> +++ b/drivers/hwmon/max6650.c
> @@ -39,6 +39,9 @@
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
>  #include <linux/err.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/mfd/max6651-private.h>
>
>  /*
>   * Insmod parameters
> @@ -105,24 +108,24 @@ module_param(clock, int, S_IRUGO);
>
>  #define DIV_FROM_REG(reg) (1 << (reg & 7))
>
> -static int max6650_probe(struct i2c_client *client,
> -                        const struct i2c_device_id *id);
> -static int max6650_init_client(struct i2c_client *client);
> -static int max6650_remove(struct i2c_client *client);
> +static int max6650_probe(struct platform_device *pdev);
> +static int max6650_init_client(struct platform_device *pdev);
> +static int max6650_remove(struct platform_device *pdev);
>  static struct max6650_data *max6650_update_device(struct device *dev);
>
>  /*
>   * Driver data (common to all clients)
>   */
>
> -static const struct i2c_device_id max6650_id[] = {
> +static const struct platform_device_id max6650_id[] = {
>         { "max6650", 1 },
>         { "max6651", 4 },
>         { }
>  };
> -MODULE_DEVICE_TABLE(i2c, max6650_id);
>
> -static struct i2c_driver max6650_driver = {
> +MODULE_DEVICE_TABLE(platform, max6650_id);
> +
> +static struct platform_driver max6650_driver = {
>         .driver = {
>                 .name   = "max6650",
>         },
> @@ -136,7 +139,9 @@ static struct i2c_driver max6650_driver = {
>   */
>
>  struct max6650_data {
> +       struct max6651 *max6651;
>         struct device *hwmon_dev;
> +       struct max6651_dev *iodev;
>         struct mutex update_lock;
>         int nr_fans;
>         char valid; /* zero until following fields are valid */
> @@ -235,8 +240,7 @@ static ssize_t get_target(struct device *dev, struct device_attribute *devattr,
>  static ssize_t set_target(struct device *dev, struct device_attribute *devattr,
>                          const char *buf, size_t count)
>  {
> -       struct i2c_client *client = to_i2c_client(dev);
> -       struct max6650_data *data = i2c_get_clientdata(client);
> +       struct max6650_data *data = dev_get_drvdata(dev);
>         int kscale, ktach;
>         unsigned long rpm;
>         int err;
> @@ -264,7 +268,7 @@ static ssize_t set_target(struct device *dev, struct device_attribute *devattr,
>                 ktach = 255;
>         data->speed = ktach;
>
> -       i2c_smbus_write_byte_data(client, MAX6650_REG_SPEED, data->speed);
> +       max6651_write_reg(data->iodev->i2c, MAX6650_REG_SPEED, data->speed);
>
>         mutex_unlock(&data->update_lock);
>
> @@ -304,8 +308,7 @@ static ssize_t get_pwm(struct device *dev, struct device_attribute *devattr,
>  static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
>                         const char *buf, size_t count)
>  {
> -       struct i2c_client *client = to_i2c_client(dev);
> -       struct max6650_data *data = i2c_get_clientdata(client);
> +       struct max6650_data *data = dev_get_drvdata(dev);
>         unsigned long pwm;
>         int err;
>
> @@ -322,7 +325,7 @@ static ssize_t set_pwm(struct device *dev, struct device_attribute *devattr,
>         else
>                 data->dac = 76 - (76 * pwm)/255;
>
> -       i2c_smbus_write_byte_data(client, MAX6650_REG_DAC, data->dac);
> +       max6651_write_reg(data->iodev->i2c, MAX6650_REG_DAC, data->dac);
>
>         mutex_unlock(&data->update_lock);
>
> @@ -350,8 +353,8 @@ static ssize_t get_enable(struct device *dev, struct device_attribute *devattr,
>  static ssize_t set_enable(struct device *dev, struct device_attribute *devattr,
>                           const char *buf, size_t count)
>  {
> -       struct i2c_client *client = to_i2c_client(dev);
> -       struct max6650_data *data = i2c_get_clientdata(client);
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct max6650_data *data = platform_get_drvdata(pdev);
>         int max6650_modes[3] = {0, 3, 2};
>         unsigned long mode;
>         int err;
> @@ -365,11 +368,11 @@ static ssize_t set_enable(struct device *dev, struct device_attribute *devattr,
>
>         mutex_lock(&data->update_lock);
>
> -       data->config = i2c_smbus_read_byte_data(client, MAX6650_REG_CONFIG);
> +       max6651_read_reg(data->iodev->i2c, MAX6650_REG_CONFIG, &data->config);
>         data->config = (data->config & ~MAX6650_CFG_MODE_MASK)
>                        | (max6650_modes[mode] << 4);
>
> -       i2c_smbus_write_byte_data(client, MAX6650_REG_CONFIG, data->config);
> +       max6651_write_reg(data->iodev->i2c, MAX6650_REG_CONFIG, data->config);
>
>         mutex_unlock(&data->update_lock);
>
> @@ -400,8 +403,7 @@ static ssize_t get_div(struct device *dev, struct device_attribute *devattr,
>  static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
>                        const char *buf, size_t count)
>  {
> -       struct i2c_client *client = to_i2c_client(dev);
> -       struct max6650_data *data = i2c_get_clientdata(client);
> +       struct max6650_data *data = dev_get_drvdata(dev);
>         unsigned long div;
>         int err;
>
> @@ -428,7 +430,7 @@ static ssize_t set_div(struct device *dev, struct device_attribute *devattr,
>                 return -EINVAL;
>         }
>
> -       i2c_smbus_write_byte_data(client, MAX6650_REG_COUNT, data->count);
> +       max6651_write_reg(data->iodev->i2c, MAX6650_REG_COUNT, data->count);
>         mutex_unlock(&data->update_lock);
>
>         return count;
> @@ -446,15 +448,14 @@ static ssize_t get_alarm(struct device *dev, struct device_attribute *devattr,
>  {
>         struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
>         struct max6650_data *data = max6650_update_device(dev);
> -       struct i2c_client *client = to_i2c_client(dev);
>         int alarm = 0;
>
>         if (data->alarm & attr->index) {
>                 mutex_lock(&data->update_lock);
>                 alarm = 1;
>                 data->alarm &= ~attr->index;
> -               data->alarm |= i2c_smbus_read_byte_data(client,
> -                                                       MAX6650_REG_ALARM);
> +               max6651_read_reg(data->iodev->i2c, MAX6650_REG_ALARM,
> +                                &data->alarm);
>                 mutex_unlock(&data->update_lock);
>         }
>
> @@ -484,10 +485,13 @@ static umode_t max6650_attrs_visible(struct kobject *kobj, struct attribute *a,
>                                     int n)
>  {
>         struct device *dev = container_of(kobj, struct device, kobj);
> -       struct i2c_client *client = to_i2c_client(dev);
> -       u8 alarm_en = i2c_smbus_read_byte_data(client, MAX6650_REG_ALARM_EN);
> +       struct max6650_data *data = dev_get_drvdata(dev);
> +       u8 alarm_en;
> +
>         struct device_attribute *devattr;
>
> +       max6651_read_reg(data->iodev->i2c, MAX6650_REG_ALARM_EN, &alarm_en);
> +
>         /*
>          * Hide the alarms that have not been enabled by the firmware
>          */
> @@ -539,74 +543,72 @@ static const struct attribute_group max6651_attr_grp = {
>   * Real code
>   */
>
> -static int max6650_probe(struct i2c_client *client,
> -                        const struct i2c_device_id *id)
> +static int max6650_probe(struct platform_device *pdev)
>  {
>         struct max6650_data *data;
>         int err;
>
> -       data = devm_kzalloc(&client->dev, sizeof(struct max6650_data),
> +       data = devm_kzalloc(&pdev->dev, sizeof(struct max6650_data),
>                             GFP_KERNEL);
>         if (!data) {
> -               dev_err(&client->dev, "out of memory.\n");
> +               dev_err(&pdev->dev, "out of memory.\n");
>                 return -ENOMEM;
>         }
>
> -       i2c_set_clientdata(client, data);
> +       platform_set_drvdata(pdev, data);
>         mutex_init(&data->update_lock);
> -       data->nr_fans = id->driver_data;
>
>         /*
>          * Initialize the max6650 chip
>          */
> -       err = max6650_init_client(client);
> +       err = max6650_init_client(pdev);
>         if (err)
>                 return err;
>
> -       err = sysfs_create_group(&client->dev.kobj, &max6650_attr_grp);
> +       err = sysfs_create_group(&pdev->dev.kobj, &max6650_attr_grp);
>         if (err)
>                 return err;
>         /* 3 additional fan inputs for the MAX6651 */
>         if (data->nr_fans == 4) {
> -               err = sysfs_create_group(&client->dev.kobj, &max6651_attr_grp);
> +               err = sysfs_create_group(&pdev->dev.kobj, &max6651_attr_grp);
>                 if (err)
>                         goto err_remove;
>         }
>
> -       data->hwmon_dev = hwmon_device_register(&client->dev);
> +       data->hwmon_dev = hwmon_device_register(&pdev->dev);
>         if (!IS_ERR(data->hwmon_dev))
>                 return 0;
>
>         err = PTR_ERR(data->hwmon_dev);
> -       dev_err(&client->dev, "error registering hwmon device.\n");
> +       dev_err(&pdev->dev, "error registering hwmon device.\n");
>         if (data->nr_fans == 4)
> -               sysfs_remove_group(&client->dev.kobj, &max6651_attr_grp);
> +               sysfs_remove_group(&pdev->dev.kobj, &max6651_attr_grp);
>  err_remove:
> -       sysfs_remove_group(&client->dev.kobj, &max6650_attr_grp);
> +       sysfs_remove_group(&pdev->dev.kobj, &max6650_attr_grp);
>         return err;
>  }
>
> -static int max6650_remove(struct i2c_client *client)
> +static int max6650_remove(struct platform_device *pdev)
>  {
> -       struct max6650_data *data = i2c_get_clientdata(client);
> +       struct max6650_data *data = platform_get_drvdata(pdev);
>
>         hwmon_device_unregister(data->hwmon_dev);
>         if (data->nr_fans == 4)
> -               sysfs_remove_group(&client->dev.kobj, &max6651_attr_grp);
> -       sysfs_remove_group(&client->dev.kobj, &max6650_attr_grp);
> +               sysfs_remove_group(&pdev->dev.kobj, &max6651_attr_grp);
> +       sysfs_remove_group(&pdev->dev.kobj, &max6650_attr_grp);
>         return 0;
>  }
>
> -static int max6650_init_client(struct i2c_client *client)
> +static int max6650_inpdevent(struct platform_device *pdev)
>  {
> -       struct max6650_data *data = i2c_get_clientdata(client);
> -       int config;
> +       struct max6650_data *data = dev_get_drvdata(pdev->dev.parent);
> +       u8 config;
>         int err = -EIO;
>
> -       config = i2c_smbus_read_byte_data(client, MAX6650_REG_CONFIG);
> +       err = max6651_read_reg(data->iodev->i2c, MAX6650_REG_CONFIG, &config);
>
> -       if (config < 0) {
> -               dev_err(&client->dev, "Error reading config, aborting.\n");
> +       if (err < 0) {
> +               dev_err(&pdev->dev, "Error reading config, aborting.\n");
>                 return err;
>         }
>
> @@ -620,11 +622,11 @@ static int max6650_init_client(struct i2c_client *client)
>                 config |= MAX6650_CFG_V12;
>                 break;
>         default:
> -               dev_err(&client->dev, "illegal value for fan_voltage (%d)\n",
> +               dev_err(&pdev->dev, "illegal value for fan_voltage (%d)\n",
>                         fan_voltage);
>         }
>
> -       dev_info(&client->dev, "Fan voltage is set to %dV.\n",
> +       dev_info(&pdev->dev, "Fan voltage is set to %dV.\n",
>                  (config & MAX6650_CFG_V12) ? 12 : 5);
>
>         switch (prescaler) {
> @@ -650,11 +652,11 @@ static int max6650_init_client(struct i2c_client *client)
>                          | MAX6650_CFG_PRESCALER_16;
>                 break;
>         default:
> -               dev_err(&client->dev, "illegal value for prescaler (%d)\n",
> +               dev_err(&pdev->dev, "illegal value for prescaler (%d)\n",
>                         prescaler);
>         }
>
> -       dev_info(&client->dev, "Prescaler is set to %d.\n",
> +       dev_info(&pdev->dev, "Prescaler is set to %d.\n",
>                  1 << (config & MAX6650_CFG_PRESCALER_MASK));
>
>         /*
> @@ -664,22 +666,24 @@ static int max6650_init_client(struct i2c_client *client)
>          */
>
>         if ((config & MAX6650_CFG_MODE_MASK) == MAX6650_CFG_MODE_OFF) {
> -               dev_dbg(&client->dev, "Change mode to open loop, full off.\n");
> +               dev_dbg(&pdev->dev, "Change mode to open loop, full off.\n");
>                 config = (config & ~MAX6650_CFG_MODE_MASK)
>                          | MAX6650_CFG_MODE_OPEN_LOOP;
> -               if (i2c_smbus_write_byte_data(client, MAX6650_REG_DAC, 255)) {
> -                       dev_err(&client->dev, "DAC write error, aborting.\n");
> +               if (max6651_write_reg(data->iodev->i2c, MAX6650_REG_DAC, 255) <
> +                   0) {
> +                       dev_err(&pdev->dev, "DAC write error, aborting.\n");
>                         return err;
>                 }
>         }
>
> -       if (i2c_smbus_write_byte_data(client, MAX6650_REG_CONFIG, config)) {
> -               dev_err(&client->dev, "Config write error, aborting.\n");
> +       if (max6651_write_reg(data->iodev->i2c,
> +               MAX6650_REG_CONFIG, config) < 0) {
> +               dev_err(&pdev->dev, "Config write error, aborting.\n");
>                 return err;
>         }
>
>         data->config = config;
> -       data->count = i2c_smbus_read_byte_data(client, MAX6650_REG_COUNT);
> +       max6651_read_reg(data->iodev->i2c, MAX6650_REG_COUNT, &data->count);
>
>         return 0;
>  }
> @@ -694,31 +698,32 @@ static const u8 tach_reg[] = {
>  static struct max6650_data *max6650_update_device(struct device *dev)
>  {
>         int i;
> -       struct i2c_client *client = to_i2c_client(dev);
> -       struct max6650_data *data = i2c_get_clientdata(client);
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct max6650_data *data = platform_get_drvdata(pdev);
> +       u8 alarm;
>
>         mutex_lock(&data->update_lock);
>
>         if (time_after(jiffies, data->last_updated + HZ) || !data->valid) {
> -               data->speed = i2c_smbus_read_byte_data(client,
> -                                                      MAX6650_REG_SPEED);
> -               data->config = i2c_smbus_read_byte_data(client,
> -                                                       MAX6650_REG_CONFIG);
> +               max6651_read_reg(data->iodev->i2c, MAX6650_REG_SPEED,
> +                                &data->speed);
> +               max6651_read_reg(data->iodev->i2c, MAX6650_REG_CONFIG,
> +                                &data->config);
>                 for (i = 0; i < data->nr_fans; i++) {
> -                       data->tach[i] = i2c_smbus_read_byte_data(client,
> -                                                                tach_reg[i]);
> +                       max6651_read_reg(data->iodev->i2c, tach_reg[i],
> +                                        &data->tach[i]);
>                 }
> -               data->count = i2c_smbus_read_byte_data(client,
> -                                                       MAX6650_REG_COUNT);
> -               data->dac = i2c_smbus_read_byte_data(client, MAX6650_REG_DAC);
> +               max6651_read_reg(data->iodev->i2c, MAX6650_REG_COUNT,
> +                                &data->count);
> +               max6651_read_reg(data->iodev->i2c, MAX6650_REG_DAC, &data->dac);
>
>                 /*
>                  * Alarms are cleared on read in case the condition that
>                  * caused the alarm is removed. Keep the value latched here
>                  * for providing the register through different alarm files.
>                  */
> -               data->alarm |= i2c_smbus_read_byte_data(client,
> -                                                       MAX6650_REG_ALARM);
> +               max6651_read_reg(data->iodev->i2c, MAX6650_REG_ALARM, &alarm);
> +               data->alarm |= alarm;
>
>                 data->last_updated = jiffies;
>                 data->valid = 1;
> @@ -729,8 +734,9 @@ static struct max6650_data *max6650_update_device(struct device *dev)
>         return data;
>  }
>
> -module_i2c_driver(max6650_driver);
> +module_platform_driver(max6650_driver);
>
>  MODULE_AUTHOR("Hans J. Koch");
>  MODULE_DESCRIPTION("MAX6650 sensor driver");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:max6650-hwmon");
> diff --git a/drivers/mfd/max6651.c b/drivers/mfd/max6651.c
> index c6b1716..d423b7a 100644
> --- a/drivers/mfd/max6651.c
> +++ b/drivers/mfd/max6651.c
> @@ -24,7 +24,7 @@
>
>  static struct mfd_cell max6651_devs[] = {
>      { .name = "max6651-gpio", },
> -    { .name = "max6650", },
> +    { .name = "max6650-hwmon", },
>  };
>
>  int max6651_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> --
> 1.8.5.1
>
