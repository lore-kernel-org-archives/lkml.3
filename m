Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3KLVxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:53:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41010 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3KLVxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:53:02 -0500
Date: Tue, 12 Nov 2013 13:52:59 -0800
From: David Brown <davidb@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>,
        Gregory Bean <gbean@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: Add support for SX151x SPI GPIO Expanders
Message-ID: <20131112215259.GA16905@codeaurora.org>
References: <1382608263-13401-1-git-send-email-viktar.palstsiuk@promwad.com>
 <CACRpkdYdoXuSvmMP+ynyZtPZr3fqAedhZLQTB5jW4FUvDCm7mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACRpkdYdoXuSvmMP+ynyZtPZr3fqAedhZLQTB5jW4FUvDCm7mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:32:20PM +0100, Linus Walleij wrote:
>Gregory,
>
>this is your driver, can you take a look at this patch?

I don't think Gregory has this email address any more, and I don't
know another address for him.

David

>Yours,
>Linus Walleij
>
>
>On Thu, Oct 24, 2013 at 11:51 AM, Viktar Palstsiuk
><viktar.palstsiuk@promwad.com> wrote:
>
>> Isolated i2c specific parts and
>> added spi bindings for the sx151x devices.
>>
>> Signed-off-by: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
>> ---
>>  drivers/gpio/Kconfig       |  10 +-
>>  drivers/gpio/gpio-sx150x.c | 267 +++++++++++++++++++++++++++++++++++++++------
>>  2 files changed, 239 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index b6ed304..4d296ab 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -465,15 +465,15 @@ config GPIO_RC5T583
>>           of RC5T583 device through standard gpio library.
>>
>>  config GPIO_SX150X
>> -       bool "Semtech SX150x I2C GPIO expander"
>> -       depends on I2C=y
>> +       bool "Semtech SX15xx I2C/SPI GPIO expander"
>> +       depends on SPI_MASTER || I2C
>>         default n
>>         help
>> -         Say yes here to provide support for Semtech SX150-series I2C
>> +         Say yes here to provide support for Semtech SX15xx-series I2C/SPI
>>           GPIO expanders. Compatible models include:
>>
>> -         8 bits:  sx1508q
>> -         16 bits: sx1509q
>> +         8 bits:  sx1508q, sx1511
>> +         16 bits: sx1509q, sx1512
>>
>>  config GPIO_STMPE
>>         bool "STMPE GPIOs"
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
>> +
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
>> +#endif /* CONFIG_I2C */
>> +
>> +#ifdef CONFIG_SPI_MASTER
>> +
>> +static s32 sx151x_spi_write(struct device *dev, u8 reg, u8 val)
>> +{
>> +       struct spi_device *spi = to_spi_device(dev);
>> +       u8 tx[2];
>> +       s32 err;
>> +
>> +       tx[0] = reg;
>> +       tx[1] = val;
>> +
>> +       err = spi_write(spi, tx, sizeof tx);
>> +
>> +       if (err < 0)
>> +               dev_warn(dev,
>> +                       "spi write fail: can't write %02x to %02x: %d\n",
>> +                       val, reg, err);
>> +       return err;
>> +}
>> +
>> +static s32 sx151x_spi_read(struct device *dev, u8 reg, u8 *val)
>> +{
>> +       struct spi_device *spi = to_spi_device(dev);
>> +       u8 tx[1], rx[1];
>> +       s32 err;
>> +
>> +       tx[0] = reg | 0x80;
>> +       err = spi_write_then_read(spi, tx, sizeof tx, rx, sizeof rx);
>> +
>> +       if (err >= 0)
>> +               *val = rx[0];
>> +       else
>> +               dev_warn(dev,
>> +                       "spi read fail: can't read from %02x: %d\n",
>> +                       reg, err);
>> +       return err;
>> +}
>> +
>> +static const struct sx15xx_ops sx151x_ops = {
>> +       .read           = sx151x_spi_read,
>> +       .write          = sx151x_spi_write,
>> +};
>> +
>> +#endif /* CONFIG_SPI_MASTER */
>> +
>>  static inline bool offset_is_oscio(struct sx150x_chip *chip, unsigned offset)
>>  {
>>         return (chip->dev_cfg->ngpios == offset);
>> @@ -164,13 +228,12 @@ static s32 sx150x_write_cfg(struct sx150x_chip *chip,
>>         s32 err;
>>
>>         sx150x_find_cfg(offset, width, &reg, &mask, &shift);
>> -       err = sx150x_i2c_read(chip->client, reg, &data);
>> +       err = chip->ops->read(chip->dev, reg, &data);
>>         if (err < 0)
>>                 return err;
>> -
>>         data &= ~mask;
>>         data |= (val << shift) & mask;
>> -       return sx150x_i2c_write(chip->client, reg, data);
>> +       return chip->ops->write(chip->dev, reg, data);
>>  }
>>
>>  static int sx150x_get_io(struct sx150x_chip *chip, unsigned offset)
>> @@ -182,7 +245,7 @@ static int sx150x_get_io(struct sx150x_chip *chip, unsigned offset)
>>         s32 err;
>>
>>         sx150x_find_cfg(offset, 1, &reg, &mask, &shift);
>> -       err = sx150x_i2c_read(chip->client, reg, &data);
>> +       err = chip->ops->read(chip->dev, reg, &data);
>>         if (err >= 0)
>>                 err = (data & mask) != 0 ? 1 : 0;
>>
>> @@ -191,7 +254,7 @@ static int sx150x_get_io(struct sx150x_chip *chip, unsigned offset)
>>
>>  static void sx150x_set_oscio(struct sx150x_chip *chip, int val)
>>  {
>> -       sx150x_i2c_write(chip->client,
>> +       chip->ops->write(chip->dev,
>>                         chip->dev_cfg->reg_clock,
>>                         (val ? 0x1f : 0x10));
>>  }
>> @@ -361,13 +424,13 @@ static irqreturn_t sx150x_irq_thread_fn(int irq, void *dev_id)
>>         int i;
>>
>>         for (i = (chip->dev_cfg->ngpios / 8) - 1; i >= 0; --i) {
>> -               err = sx150x_i2c_read(chip->client,
>> +               err = chip->ops->read(chip->dev,
>>                                       chip->dev_cfg->reg_irq_src - i,
>>                                       &val);
>>                 if (err < 0)
>>                         continue;
>>
>> -               sx150x_i2c_write(chip->client,
>> +               chip->ops->write(chip->dev,
>>                                 chip->dev_cfg->reg_irq_src - i,
>>                                 val);
>>                 for (n = 0; n < 8; ++n) {
>> @@ -421,15 +484,17 @@ out:
>>  }
>>
>>  static void sx150x_init_chip(struct sx150x_chip *chip,
>> -                       struct i2c_client *client,
>> +                       struct device *dev,
>> +                       const struct sx15xx_ops *ops,
>>                         kernel_ulong_t driver_data,
>>                         struct sx150x_platform_data *pdata)
>>  {
>>         mutex_init(&chip->lock);
>>
>> -       chip->client                     = client;
>> +       chip->dev                        = dev;
>> +       chip->ops                        = ops;
>>         chip->dev_cfg                    = &sx150x_devices[driver_data];
>> -       chip->gpio_chip.label            = client->name;
>> +       chip->gpio_chip.label            = dev_name(dev);
>>         chip->gpio_chip.direction_input  = sx150x_gpio_direction_input;
>>         chip->gpio_chip.direction_output = sx150x_gpio_direction_output;
>>         chip->gpio_chip.get              = sx150x_gpio_get;
>> @@ -441,7 +506,7 @@ static void sx150x_init_chip(struct sx150x_chip *chip,
>>         if (pdata->oscio_is_gpo)
>>                 ++chip->gpio_chip.ngpio;
>>
>> -       chip->irq_chip.name                = client->name;
>> +       chip->irq_chip.name                = dev_name(dev);
>>         chip->irq_chip.irq_mask            = sx150x_irq_mask;
>>         chip->irq_chip.irq_unmask          = sx150x_irq_unmask;
>>         chip->irq_chip.irq_set_type        = sx150x_irq_set_type;
>> @@ -462,7 +527,7 @@ static int sx150x_init_io(struct sx150x_chip *chip, u8 base, u16 cfg)
>>         unsigned n;
>>
>>         for (n = 0; err >= 0 && n < (chip->dev_cfg->ngpios / 8); ++n)
>> -               err = sx150x_i2c_write(chip->client, base - n, cfg >> (n * 8));
>> +               err = chip->ops->write(chip->dev, base - n, cfg >> (n * 8));
>>         return err;
>>  }
>>
>> @@ -470,13 +535,13 @@ static int sx150x_reset(struct sx150x_chip *chip)
>>  {
>>         int err;
>>
>> -       err = i2c_smbus_write_byte_data(chip->client,
>> +       err = chip->ops->write(chip->dev,
>>                                         chip->dev_cfg->reg_reset,
>>                                         0x12);
>>         if (err < 0)
>>                 return err;
>>
>> -       err = i2c_smbus_write_byte_data(chip->client,
>> +       err = chip->ops->write(chip->dev,
>>                                         chip->dev_cfg->reg_reset,
>>                                         0x34);
>>         return err;
>> @@ -493,7 +558,7 @@ static int sx150x_init_hw(struct sx150x_chip *chip,
>>                         return err;
>>         }
>>
>> -       err = sx150x_i2c_write(chip->client,
>> +       err = chip->ops->write(chip->dev,
>>                         chip->dev_cfg->reg_misc,
>>                         0x01);
>>         if (err < 0)
>> @@ -548,7 +613,7 @@ static int sx150x_install_irq_chip(struct sx150x_chip *chip,
>>  #endif
>>         }
>>
>> -       err = devm_request_threaded_irq(&chip->client->dev,
>> +       err = devm_request_threaded_irq(chip->dev,
>>                                 irq_summary,
>>                                 NULL,
>>                                 sx150x_irq_thread_fn,
>> @@ -574,6 +639,8 @@ static void sx150x_remove_irq_chip(struct sx150x_chip *chip)
>>         }
>>  }
>>
>> +#ifdef CONFIG_I2C
>> +
>>  static int sx150x_probe(struct i2c_client *client,
>>                                 const struct i2c_device_id *id)
>>  {
>> @@ -595,7 +662,7 @@ static int sx150x_probe(struct i2c_client *client,
>>         if (!chip)
>>                 return -ENOMEM;
>>
>> -       sx150x_init_chip(chip, client, id->driver_data, pdata);
>> +       sx150x_init_chip(chip, &client->dev, &sx150x_ops, id->driver_data, pdata);
>>         rc = sx150x_init_hw(chip, pdata);
>>         if (rc < 0)
>>                 return rc;
>> @@ -636,6 +703,13 @@ static int sx150x_remove(struct i2c_client *client)
>>         return 0;
>>  }
>>
>> +static const struct i2c_device_id sx150x_id[] = {
>> +       {"sx1508q", SX15_TYPE_8_GPIOS},
>> +       {"sx1509q", SX15_TYPE_16_GPIOS},
>> +       {}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, sx150x_id);
>> +
>>  static struct i2c_driver sx150x_driver = {
>>         .driver = {
>>                 .name = "sx150x",
>> @@ -646,19 +720,146 @@ static struct i2c_driver sx150x_driver = {
>>         .id_table = sx150x_id,
>>  };
>>
>> -static int __init sx150x_init(void)
>> +static int __init sx150x_i2c_init(void)
>>  {
>>         return i2c_add_driver(&sx150x_driver);
>>  }
>> +
>> +static void __exit sx150x_i2c_exit(void)
>> +{
>> +       return i2c_del_driver(&sx150x_driver);
>> +}
>> +
>> +#else
>> +
>> +static int __init sx150x_i2c_init(void) { return 0; }
>> +static void sx150x_i2c_exit(void) { }
>> +
>> +#endif /* CONFIG_I2C */
>> +
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
>> +
>> +static const struct spi_device_id sx151x_ids[] = {
>> +       { "sx1511", SX15_TYPE_8_GPIOS },
>> +       { "sx1512", SX15_TYPE_16_GPIOS },
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(spi, sx151x_ids);
>> +
>> +static struct spi_driver sx151x_driver = {
>> +       .probe          = sx151x_probe,
>> +       .remove         = sx151x_remove,
>> +       .id_table       = sx151x_ids,
>> +       .driver = {
>> +               .name   = "sx151x",
>> +               .owner  = THIS_MODULE,
>> +       },
>> +};
>> +
>> +static int __init sx151x_spi_init(void)
>> +{
>> +       return spi_register_driver(&sx151x_driver);
>> +}
>> +
>> +static void sx151x_spi_exit(void)
>> +{
>> +       spi_unregister_driver(&sx151x_driver);
>> +}
>> +
>> +#else
>> +
>> +static int __init sx151x_spi_init(void) { return 0; }
>> +static void sx151x_spi_exit(void) { }
>> +
>> +#endif /* CONFIG_SPI_MASTER */
>> +
>> +static int __init sx150x_init(void)
>> +{
>> +       int ret;
>> +
>> +       ret = sx151x_spi_init();
>> +       if (ret)
>> +               goto spi_fail;
>> +
>> +       ret = sx150x_i2c_init();
>> +       if (ret)
>> +               goto i2c_fail;
>> +
>> +       return 0;
>> +
>> + i2c_fail:
>> +       sx151x_spi_exit();
>> + spi_fail:
>> +       return ret;
>> +}
>>  subsys_initcall(sx150x_init);
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
>> --
>> 1.8.4.rc3
>>

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
