Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3KSBQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 20:16:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:50313 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KSBQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 20:16:31 -0500
Message-ID: <528ABBEC.5070202@codeaurora.org>
Date: Mon, 18 Nov 2013 17:16:28 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>,
        Gregory Bean <gbean@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] gpio: Add support for SX151x SPI GPIO Expanders
References: <1382608263-13401-1-git-send-email-viktar.palstsiuk@promwad.com> <CACRpkdYdoXuSvmMP+ynyZtPZr3fqAedhZLQTB5jW4FUvDCm7mw@mail.gmail.com>
In-Reply-To: <CACRpkdYdoXuSvmMP+ynyZtPZr3fqAedhZLQTB5jW4FUvDCm7mw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 11:51 AM, Viktar Palstsiuk
<viktar.palstsiuk@promwad.com> wrote:
>> Isolated i2c specific parts and
>> added spi bindings for the sx151x devices.
>>
>> Signed-off-by: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
>>
>> diff --git a/drivers/gpio/gpio-sx150x.c b/drivers/gpio/gpio-sx150x.c
>> index d2983e9..bee1661 100644
>> --- a/drivers/gpio/gpio-sx150x.c
>> +++ b/drivers/gpio/gpio-sx150x.c
>> @@ -22,9 +22,16 @@
>>  #include <linux/module.h>
>>  #include <linux/mutex.h>
>>  #include <linux/slab.h>
>> +#include <linux/spi/spi.h>
>>  #include <linux/workqueue.h>
>>  #include <linux/i2c/sx150x.h>
>>
>> +/**
>> + * SX15xx types supported by driver
>> + */
>> +#define SX15_TYPE_8_GPIOS      0
>> +#define SX15_TYPE_16_GPIOS     1
>> +
>>  #define NO_UPDATE_PENDING      -1
>>
>>  struct sx150x_device_data {
>> @@ -43,9 +50,17 @@ struct sx150x_device_data {
>>         u8 ngpios;
>>  };
>>
>> +struct sx150x_chip;
>> +
>> +struct sx15xx_ops {
>> +       s32     (*read)(struct device *dev, u8 reg, u8 *val);
>> +       s32     (*write)(struct device *dev, u8 reg, u8 val);
>> +};

It would be better to convert this driver to use the regmap APIs. That
could be the first patch and then the second patch would be splitting
off the i2c and spi parts into separate files that use the core code.

>>  struct sx150x_chip {
>>         struct gpio_chip                 gpio_chip;
>> -       struct i2c_client               *client;
>> +       struct device                   *dev;
>> +       const struct sx15xx_ops         *ops;
>>         const struct sx150x_device_data *dev_cfg;
>>         int                              irq_summary;
>>         int                              irq_base;
>> @@ -59,7 +74,7 @@ struct sx150x_chip {
>>  };
>>
>>  static const struct sx150x_device_data sx150x_devices[] = {
>> -       [0] = { /* sx1508q */
>> +       [SX15_TYPE_8_GPIOS] = { /* sx1508q */
>>                 .reg_pullup   = 0x03,
>>                 .reg_pulldn   = 0x04,
>>                 .reg_drain    = 0x05,
>> @@ -74,7 +89,7 @@ static const struct sx150x_device_data sx150x_devices[] = {
>>                 .reg_reset    = 0x7d,
>>                 .ngpios       = 8
>>         },
>> -       [1] = { /* sx1509q */
>> +       [SX15_TYPE_16_GPIOS] = { /* sx1509q */
>>                 .reg_pullup   = 0x07,
>>                 .reg_pulldn   = 0x09,
>>                 .reg_drain    = 0x0b,

This looks like general cleanup that could be it's own patch as well.

>> @@ -91,37 +106,86 @@ static const struct sx150x_device_data sx150x_devices[] = {
>>         },
>>  };
>>
>> -static const struct i2c_device_id sx150x_id[] = {
>> -       {"sx1508q", 0},
>> -       {"sx1509q", 1},
>> -       {}
>> -};
>> -MODULE_DEVICE_TABLE(i2c, sx150x_id);
>> +#ifdef CONFIG_I2C
>>
>> -static s32 sx150x_i2c_write(struct i2c_client *client, u8 reg, u8 val)
>> +static s32 sx150x_i2c_write(struct device *dev, u8 reg, u8 val)
>>  {
>> +       struct i2c_client *client = to_i2c_client(dev);
>>         s32 err = i2c_smbus_write_byte_data(client, reg, val);
>>
>>         if (err < 0)
>> -               dev_warn(&client->dev,
>> +               dev_warn(dev,
>>                         "i2c write fail: can't write %02x to %02x: %d\n",
>>                         val, reg, err);
>>         return err;
>>  }
>>
>> -static s32 sx150x_i2c_read(struct i2c_client *client, u8 reg, u8 *val)
>> +static s32 sx150x_i2c_read(struct device *dev, u8 reg, u8 *val)
>>  {
>> +       struct i2c_client *client = to_i2c_client(dev);
>>         s32 err = i2c_smbus_read_byte_data(client, reg);
>>
>>         if (err >= 0)
>>                 *val = err;
>>         else
>> -               dev_warn(&client->dev,
>> +               dev_warn(dev,
>>                         "i2c read fail: can't read from %02x: %d\n",
>>                         reg, err);
>>         return err;
>>  }
>>
>> +static const struct sx15xx_ops sx150x_ops = {
>> +       .read           = sx150x_i2c_read,
>> +       .write          = sx150x_i2c_write,
>> +};
>> +

This could all be simpler with the regmap APIs.

>> +#ifdef CONFIG_SPI_MASTER
>> +
>> +static int sx151x_probe(struct spi_device *spi)
>> +{
>> +       struct sx150x_platform_data *pdata;
>> +       struct sx150x_chip *chip;
>> +       int rc;
>> +
>> +       pdata = dev_get_platdata(&spi->dev);
>> +       if (!pdata) {
>> +               return -EINVAL;
>> +       }
>> +
>> +       chip = devm_kzalloc(&spi->dev,
>> +               sizeof(struct sx150x_chip), GFP_KERNEL);
>> +       if (!chip)
>> +               return -ENOMEM;
>> +
>> +       sx150x_init_chip(chip, &spi->dev, &sx151x_ops,
>> +                        spi_get_device_id(spi)->driver_data, pdata);
>> +       rc = sx150x_init_hw(chip, pdata);
>> +       if (rc < 0)
>> +               return rc;
>> +
>> +       rc = gpiochip_add(&chip->gpio_chip);
>> +       if (rc < 0)
>> +               return rc;
>> +
>> +       if (pdata->irq_summary >= 0) {
>> +               rc = sx150x_install_irq_chip(chip,
>> +                                       pdata->irq_summary,
>> +                                       pdata->irq_base);
>> +               if (rc < 0)
>> +                       goto probe_fail_post_gpiochip_add;
>> +       }
>> +
>> +       spi_set_drvdata(spi, chip);
>> +
>> +       return 0;
>> +probe_fail_post_gpiochip_add:
>> +       WARN_ON(gpiochip_remove(&chip->gpio_chip) < 0);
>> +       return rc;
>> +}
>> +
>> +static int sx151x_remove(struct spi_device *spi)
>> +{
>> +       struct sx150x_chip *chip;
>> +       int rc;
>> +
>> +       chip = spi_get_drvdata(spi);
>> +       rc = gpiochip_remove(&chip->gpio_chip);
>> +       if (rc < 0)
>> +               return rc;
>> +
>> +       if (chip->irq_summary >= 0)
>> +               sx150x_remove_irq_chip(chip);
>> +
>> +       return 0;
>> +}

This is mostly copy paste of the i2c version. Can you make the non-spi
part common?

>> +
>> +static const struct spi_device_id sx151x_ids[] = {
>> +       { "sx1511", SX15_TYPE_8_GPIOS },
>> +       { "sx1512", SX15_TYPE_16_GPIOS },
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(spi, sx151x_ids);
>> +
[...]
>>
>>  static void __exit sx150x_exit(void)
>>  {
>> -       return i2c_del_driver(&sx150x_driver);
>> +       sx151x_spi_exit();
>> +       sx150x_i2c_exit();
>>  }
>>  module_exit(sx150x_exit);
>>
>>  MODULE_AUTHOR("Gregory Bean <gbean@codeaurora.org>");
>> -MODULE_DESCRIPTION("Driver for Semtech SX150X I2C GPIO Expanders");
>> +MODULE_DESCRIPTION("Driver for Semtech SX15xx I2C/SPI GPIO Expanders");
>>  MODULE_LICENSE("GPL v2");
>>  MODULE_ALIAS("i2c:sx150x");
>>

Do you need another MODULE_ALIAS("spi:..." here?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

