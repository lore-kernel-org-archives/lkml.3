Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161720Ab3BONQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:16:55 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57638 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161258Ab3BONQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:16:52 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND 1/6 v13] gpio: Add a block GPIO API to gpiolib
To: Stijn Devriendt <highguy@gmail.com>, Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
In-Reply-To: <CAOY=C6EE1yxjxUR6XvxW5tbY8FPBeO2Nqo6wMeD5R3zAVYD+Ag@mail.gmail.com>
References: <1358250716-21986-1-git-send-email-stigge@antcom.de> <1358250716-21986-2-git-send-email-stigge@antcom.de> <CAOY=C6EE1yxjxUR6XvxW5tbY8FPBeO2Nqo6wMeD5R3zAVYD+Ag@mail.gmail.com>
Date: Fri, 15 Feb 2013 13:16:45 +0000
Message-Id: <20130215131645.57D243E044B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013 13:13:01 +0100, Stijn Devriendt <highguy@gmail.com> wrote:
> Hi Roland,
> 
> This mail has been long overdue due to issues with some internal
> permission-tool.
> Just to be clear, this is not a competing implementation, it's what we
> currently use as-is. I'm just posting this as a reference to see if
> perhaps more concepts could be reused. It's based on a 2.6.32 kernel.

Hi Stijn,

Thanks for posting this. As you say it isn't in a mergable state and
there are a lot if individual features lumped into a single patch where
some of them could be split out as seperate patches. Open-drain support
for instance is something that should be investigated.

However, the one thing I do want to raise (and I have this concern when
reading Roland's series too) is that I'm going to be very cautious about
extending the sysfs interface. Aside from the fact that the current
interface is buggy, it also potientially exposes far too much control
over hardware into userspace. I do see the advantages of a group
interface to a block of GPIO pins, but the details about how it is
accomplished are really key.

I'm in the process of reviewing Roland's patches now, and I'll respond
to his series with specifics.

g.

> 
> It includes:
> - labels in sysfs (to provide useful names to userspace)
> - gpio group support
> - exporting individual/groups of gpios dictated by platform-data or device-tree
> - open-drain support (different from mainline)
> - examplary support for multi-gpio to pcf8575 driver
> - gpio_direction_output_keep() function that prevents toggling when
> changing direction
> 
> Provided-as-is-by: Stijn Devriendt <sdevrien@cisco.com>
> ---
>  drivers/gpio/Kconfig        |    6 +
>  drivers/gpio/Makefile       |    1 +
>  drivers/gpio/gpio-export.c  |  327 ++++++++++++++
>  drivers/gpio/gpiolib.c      | 1021 ++++++++++++++++++++++++++++++++++++++++---
>  drivers/gpio/pcf857x.c      |  102 ++++-
>  include/asm-generic/gpio.h  |   67 +++
>  include/linux/gpio-export.h |   64 +++
>  include/linux/gpio.h        |   83 ++++
>  8 files changed, 1602 insertions(+), 69 deletions(-)
>  create mode 100644 drivers/gpio/gpio-export.c
>  create mode 100644 include/linux/gpio-export.h
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 2ad0128..7daf6df 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -48,6 +48,12 @@ config DEBUG_GPIO
>  	  slower.  The diagnostics help catch the type of setup errors
>  	  that are most common when setting up new platforms or boards.
> 
> +config GPIO_EXPORT
> +	bool "GPIO export driver"
> +	depends on GPIO_SYSFS && GPIOLIB
> +	help
> +	  Say Y here to include the GPIO export driver.
> +
>  config GPIO_SYSFS
>  	bool "/sys/class/gpio/... (sysfs interface)"
>  	depends on SYSFS && EXPERIMENTAL
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 00a532c..40b96d7 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -4,6 +4,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
> 
>  obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
> 
> +obj-$(CONFIG_GPIO_EXPORT)	+= gpio-export.o
>  obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
>  obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
>  obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
> diff --git a/drivers/gpio/gpio-export.c b/drivers/gpio/gpio-export.c
> new file mode 100644
> index 0000000..4ee4fe5
> --- /dev/null
> +++ b/drivers/gpio/gpio-export.c
> @@ -0,0 +1,327 @@
> +/* drivers/gpio/gpio-export.c
> + *
> + * Copyright (C) 2011 Stijn Devriendt, Cisco Systems Inc.
> + * Copyright (C) 2011 Eli Steenput, Cisco Systems Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/gpio.h>
> +#include <linux/device.h>
> +#include <linux/string.h>
> +#include <linux/gpio-export.h>
> +#include <linux/err.h>
> +
> +#ifdef CONFIG_OF
> +
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
> +
> +#endif
> +
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +
> +struct gpio_export_priv
> +{
> +	int count;
> +	int gpio_num;
> +	struct gpio_group *group;
> +	char desc[MAX_GPIO_LABEL_SIZE];
> +};
> +
> +static __devinit int common_gpio_probe(struct mp_gpio_platform_data
> *pdata, struct device *dev)
> +{
> +	int gpio_count = pdata->gpio_count;
> +	struct mp_gpio_line *gpio_line;
> +	int i;
> +	int err = 0;
> +	struct gpio_export_priv *priv;
> +
> +	if (gpio_count <= 0 || gpio_count > 32)
> +		return -ENODEV;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->count = gpio_count;
> +	strncpy(priv->desc, pdata->desc, MAX_GPIO_LABEL_SIZE);
> +	if (gpio_count > 1)
> +	{
> +		u32 gpio[32];
> +		u32 value = pdata->initialvalue;
> +		u32 opendrain = 0;
> +		for (i = 0; i < gpio_count; ++i)
> +		{
> +			gpio_line = &pdata->gpio_data[i];
> +			gpio[i] = gpio_line->gpio_num;
> +			if (gpio_line->active_low)
> +				value ^= (1 << i);
> +			if (gpio_line->open_drain)
> +				opendrain |= (1 << i);
> +		}
> +
> +		priv->group = gpio_group_request(gpio, gpio_count, priv->desc);
> +		if (IS_ERR(priv->group))
> +		{
> +			dev_err(dev, "Could not request gpio-group: %ld\n", PTR_ERR(priv->group));
> +			err = PTR_ERR(priv->group);
> +			goto out_mem;
> +		}
> +
> +		if (opendrain)
> +		{
> +			err = gpio_group_set_opendrain(priv->group,
> gpio_group_value_to_raw(priv->group, opendrain));
> +			if (err)
> +			{
> +				dev_err(dev, "Could not set gpio-group open-drain: %d\n", err);
> +				goto out_free_group;
> +			}
> +		}
> +
> +		switch (pdata->direction)
> +		{
> +			case GPIO_INPUT:
> +				err = gpio_group_direction_input(priv->group);
> +				break;
> +			case GPIO_OUTPUT:
> +				err = gpio_group_direction_output(priv->group,
> gpio_group_value_to_raw(priv->group, value));
> +				break;
> +			case GPIO_OUTPUT_KEEP:
> +				err = gpio_group_direction_output_keep(priv->group);
> +				break;
> +			default:
> +        break;
> +		}
> +
> +		if (err)
> +		{
> +			dev_err(dev, "Could not set gpio-group direction: %d\n", err);
> +			goto out_free_group;
> +		}
> +
> +		err = gpio_group_export(priv->group, pdata->direction == GPIO_CHANGE);
> +		if (err)
> +		{
> +			dev_err(dev, "Could not export gpio-group: %d\n", err);
> +			goto out_free_group;
> +		}
> +	}
> +	else
> +	{
> +		gpio_line = &pdata->gpio_data[0];
> +		err = gpio_request(gpio_line->gpio_num, priv->desc);
> +		if (err)
> +		{
> +			dev_err(dev, "Could not request gpio %d\n", gpio_line->gpio_num);
> +			goto out_free;
> +		}
> +		if (gpio_line->open_drain)
> +		{
> +			err = gpio_set_opendrain(gpio_line->gpio_num, 1);
> +			if (err)
> +			{
> +				dev_warn(dev, "Could not set open-drain on gpio %d\n",
> gpio_line->gpio_num);
> +				goto out_free;
> +			}
> +		}
> +
> +		if (pdata->direction == GPIO_INPUT)
> +		{
> +			err = gpio_direction_input(gpio_line->gpio_num);
> +		}
> +		else if (pdata->direction == GPIO_OUTPUT)
> +		{
> +			int value = 0;
> +			value = pdata->initialvalue;
> +			if (gpio_line->active_low)
> +				value = !value;
> +			dev_dbg(dev, "Setting output on gpio %d with value %d\n",
> gpio_line->gpio_num, value);
> +			err = gpio_direction_output(gpio_line->gpio_num, value);
> +		}
> +		else if (pdata->direction == GPIO_OUTPUT_KEEP)
> +		{
> +			err = gpio_direction_output_keep(gpio_line->gpio_num);
> +		}
> +
> +		if (err)
> +		{
> +			dev_err(dev, "Could not set direction: %d\n", err);
> +			goto out_free;
> +		}
> +
> +		err = gpio_export(gpio_line->gpio_num, pdata->direction == GPIO_CHANGE);
> +		if (err)
> +		{
> +			dev_warn(dev, "Could not export gpio %d\n", gpio_line->gpio_num);
> +			goto out_free;
> +		}
> +		priv->gpio_num = gpio_line->gpio_num;
> +	}
> +	dev_set_drvdata(dev, priv);
> +	dev_info(dev, "%s: Exported %d GPIO pins\n", pdata->desc, pdata->gpio_count);
> +out:
> +	return err;
> +out_free:
> +	gpio_free(gpio_line->gpio_num);
> +	kfree(priv);
> +	goto out;
> +out_free_group:
> +	gpio_group_free(priv->group);
> +	kfree(priv);
> +	goto out;
> +out_mem:
> +	kfree(priv);
> +	goto out;
> +}
> +
> +int common_gpio_remove(struct device *dev)
> +{
> +	struct gpio_export_priv *priv = dev_get_drvdata(dev);
> +	BUG_ON(!priv);
> +
> +	if (priv->count == 1)
> +		gpio_free(priv->gpio_num);
> +	else
> +		gpio_group_free(priv->group);
> +
> +	dev_set_drvdata(dev, NULL);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +
> +static __devinit int of_gpio_probe(struct platform_device *of_dev,
> +		const struct of_device_id *match)
> +{
> +	struct device_node *np = of_dev->dev.of_node;
> +	int gpio_count = of_gpio_count(np);
> +	const char* linuxname = of_get_property(np, "desc", NULL);
> +
> +	struct mp_gpio_platform_data pdata;
> +	struct mp_gpio_line gpio_line[32];
> +	int i;
> +
> +	pdata.gpio_data = gpio_line;
> +	pdata.gpio_count = gpio_count;
> +	strncpy(pdata.desc, linuxname, MAX_GPIO_LABEL_SIZE);
> +	pdata.initialvalue = 0;
> +
> +	if (of_device_is_compatible(np, "gpio-input"))
> +		pdata.direction = GPIO_INPUT;
> +	else if (of_device_is_compatible(np, "gpio-output"))
> +	{
> +		const __be32 *value = of_get_property_u32(np, "initial");
> +		if (!value)
> +			pdata.direction = GPIO_OUTPUT_KEEP;
> +		else
> +		{
> +			pdata.direction = GPIO_OUTPUT;
> +			pdata.initialvalue = be32_to_cpup(value);
> +			dev_dbg(&of_dev->dev, "initialvalue=%u, keep=%d\n",
> pdata.initialvalue, pdata.direction == GPIO_OUTPUT_KEEP);
> +		}
> +	}
> +	else
> +	{
> +		pdata.direction = GPIO_CHANGE;
> +	}
> +
> +	for (i=0; i < gpio_count; ++i)
> +	{
> +		u32 flags;
> +		gpio_line[i].gpio_num = of_get_gpio_flags(np, i, &flags);
> +		gpio_line[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
> +		gpio_line[i].open_drain = flags & OF_GPIO_OPEN_DRAIN;
> +	}
> +	return common_gpio_probe(&pdata, &of_dev->dev);
> +}
> +
> +static __devexit int of_gpio_remove(struct platform_device *of_dev)
> +{
> +	return common_gpio_remove(&of_dev->dev);
> +}
> +
> +static const struct of_device_id __devinitconst of_gpio_match[] = {
> +	{ .compatible = "gpio-input", },
> +	{ .compatible = "gpio-output", },
> +	{ .compatible = "gpio-user", },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, of_gpio_match);
> +
> +static struct of_platform_driver of_gpio_driver = {
> +	.probe = of_gpio_probe,
> +	.remove = __devexit_p(of_gpio_remove),
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = "of-gpio",
> +		.of_match_table = of_gpio_match,
> +	},
> +};
> +
> +static int __init of_gpio_init(void)
> +{
> +	// Use i2c_bus_type to support I/O expanders?
> +	return of_register_platform_driver(&of_gpio_driver);
> +}
> +
> +static void __exit of_gpio_exit(void)
> +{
> +	of_unregister_driver(&of_gpio_driver);
> +}
> +
> +late_initcall(of_gpio_init);
> +module_exit(of_gpio_exit);
> +
> +#else
> +
> +static __devinit int mp_probe(struct platform_device *p_device)
> +{
> +	return common_gpio_probe(dev_get_platdata(&p_device->dev), &p_device->dev);
> +}
> +
> +static __devexit int mp_remove(struct platform_device *p_device)
> +{
> +	return common_gpio_remove(&p_device->dev);
> +}
> +
> +static struct platform_device_id mp_id_table[] = {
> +	{
> +		.name		= "gpio-export",
> +	},
> +};
> +
> +static struct platform_driver mp_gpio_driver = {
> +	.probe = mp_probe,
> +	.remove = mp_remove,
> +	.id_table = mp_id_table,
> +	.driver.name = "gpio-export",
> +	.driver.bus = &platform_bus_type,
> +	.driver.owner = THIS_MODULE,
> +};
> +
> +static int __init mp_gpio_init(void)
> +{
> +	return platform_driver_register(&mp_gpio_driver);
> +}
> +
> +static void __exit mp_gpio_exit(void)
> +{
> +	platform_driver_unregister(&mp_gpio_driver);
> +}
> +
> +late_initcall(mp_gpio_init);
> +module_exit(mp_gpio_exit);
> +
> +#endif
> +
> +MODULE_AUTHOR("Stijn Devriendt, Eli Steenput");
> +MODULE_DESCRIPTION("Multi Purpose GPIO export driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 50de0f5..1c9c426 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -8,7 +8,9 @@
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/gpio.h>
> +#include <linux/of_gpio.h>
>  #include <linux/idr.h>
> +#include <linux/ctype.h>
> 
> 
>  /* Optional implementation infrastructure for GPIO interfaces.
> @@ -53,15 +55,15 @@ struct gpio_desc {
>  #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
>  #define FLAG_TRIG_FALL	5	/* trigger on falling edge */
>  #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
> +#define FLAG_OPEN_DRAIN 7       /* gpio is open drain */
> 
>  #define PDESC_ID_SHIFT	16	/* add new flags before this one */
> 
>  #define GPIO_FLAGS_MASK		((1 << PDESC_ID_SHIFT) - 1)
>  #define GPIO_TRIGGER_MASK	(BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE))
> 
> -#ifdef CONFIG_DEBUG_FS
>  	const char		*label;
> -#endif
> +	struct gpio_group *group;
>  };
>  static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
> 
> @@ -76,9 +78,7 @@ static struct idr pdesc_idr;
> 
>  static inline void desc_set_label(struct gpio_desc *d, const char *label)
>  {
> -#ifdef CONFIG_DEBUG_FS
>  	d->label = label;
> -#endif
>  }
> 
>  /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
> @@ -119,6 +119,11 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
>  	return gpio_desc[gpio].chip;
>  }
> 
> +static inline struct gpio_group *gpio_to_group(unsigned gpio)
> +{
> +	return gpio_desc[gpio].group;
> +}
> +
>  /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
>  static int gpiochip_find_base(int ngpio)
>  {
> @@ -189,6 +194,110 @@ err:
>  	return ret;
>  }
> 
> +/* gpio_group_raw_to_value() - reorder bits according to the gpio group
> + * request
> + *
> + * @group: gpio_group
> + * @raw: raw value
> + *
> + * Returns a compact value representing the gpio_group value.
> + * e.g. consider gpio pins [1,0,2,3] have been requested and their
> + * value is [1,0,0,1] respectively. The raw readout will be 0xA [1,0,1,0]
> + * while the return value of this function will be 0x9, considering
> + * the order of the GPIOs in the group.
> + */
> +u32 gpio_group_raw_to_value(const struct gpio_group *group, u32 raw)
> +{
> +	int i = 0;
> +	u32 ret = 0;
> +	unsigned base = gpio_to_chip(group->gpios[0])->base;
> +
> +	while (i < 32 && group->gpios[i] != ARCH_NR_GPIOS)
> +	{
> +		unsigned offset = group->gpios[i] - base;
> +		u32 rawbit = (1 << offset);
> +
> +		// if raw[offset] is set
> +		// then set ret[i]
> +		if (raw & rawbit)
> +			ret |= (1 << i);
> +
> +		++i;
> +	}
> +	return ret;
> +}
> +
> +/* gpio_group_value_to_raw() - Inverse of gpio_group_raw_to_value
> + *
> + * @group: gpio_group
> + * @raw: compact value
> + *
> + * Returns the raw value.
> + */
> +u32 gpio_group_value_to_raw(const struct gpio_group *group, u32 value)
> +{
> +	int i = 0;
> +	u32 raw = 0;
> +	unsigned base = gpio_to_chip(group->gpios[0])->base;
> +
> +	while (i < 32 && group->gpios[i] != ARCH_NR_GPIOS)
> +	{
> +		unsigned offset = group->gpios[i] - base;
> +		u32 rawbit = (1 << offset);
> +
> +		// if value[i] is set
> +		// then set ret[offset]
> +		if (value & (1 << i))
> +			raw |= rawbit;
> +
> +		++i;
> +	}
> +	return raw;
> +}
> +
> +int gpio_group_test_bit(unsigned long flag, const struct gpio_group *group)
> +{
> +	u32 set = 0;
> +	int i;
> +	unsigned base = gpio_to_chip(group->gpios[0])->base;
> +	for (i = 0; i < 32; ++i)
> +	{
> +		if (group->mask & (1 << i) && test_bit(flag, &gpio_desc[base + i].flags))
> +			set |= (1 << i);
> +	}
> +	if (set == 0)
> +		return 0;
> +	else if (set == group->mask)
> +		return 1;
> +	else
> +		return -EIO;
> +}
> +
> +void gpio_group_set_bit(unsigned long flag, const struct gpio_group *group)
> +{
> +	int i;
> +	unsigned base = gpio_to_chip(group->gpios[0])->base;
> +
> +	for (i = 0; i < 32; ++i)
> +	{
> +		if (group->mask & (1 << i))
> +			set_bit(flag, &gpio_desc[base + i].flags);
> +	}
> +}
> +
> +void gpio_group_clear_bit(unsigned long flag, const struct gpio_group *group)
> +{
> +	int i;
> +	unsigned base = gpio_to_chip(group->gpios[0])->base;
> +
> +	for (i = 0; i < 32; ++i)
> +	{
> +		if (group->mask & (1 << i))
> +			clear_bit(flag, &gpio_desc[base + i].flags);
> +	}
> +}
> +
> +
>  #ifdef CONFIG_GPIO_SYSFS
> 
>  /* lock protects against unexport_gpio() being called while
> @@ -231,6 +340,30 @@ static ssize_t gpio_direction_show(struct device *dev,
>  	return status;
>  }
> 
> +static ssize_t gpio_group_direction_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_group *group = dev_get_drvdata(dev);
> +	ssize_t status = 0;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (gpio_desc[group->gpios[0]].group != group
> +			|| gpio_group_test_bit(FLAG_EXPORT, group) <= 0)
> +	{
> +		status = -EIO;
> +		goto out;
> +	}
> +
> +	status = gpio_group_test_bit(FLAG_IS_OUT, group);
> +	if (status >= 0)
> +		status = sprintf(buf, "%s\n", status == 0 ? "in" : "out");
> +
> +out:
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
>  static ssize_t gpio_direction_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t size)
>  {
> @@ -255,9 +388,49 @@ static ssize_t gpio_direction_store(struct device *dev,
>  	return status ? : size;
>  }
> 
> -static const DEVICE_ATTR(direction, 0644,
> +static ssize_t gpio_group_direction_store(struct device *dev,
> +    struct device_attribute *attr, const char* buf, size_t size)
> +{
> +  const struct gpio_group *group = dev_get_drvdata(dev);
> +  ssize_t status;
> +  unsigned long input;
> +
> +  mutex_lock(&sysfs_lock);
> +
> +  if (gpio_desc[group->gpios[0]].group != group
> +   || gpio_group_test_bit(FLAG_EXPORT, group) <= 0)
> +  {
> +    status = -EIO;
> +    goto out;
> +  }
> +
> +  if (sysfs_streq(buf, "in"))
> +    status = gpio_group_direction_input(group);
> +  else if (sysfs_streq(buf, "out"))
> +    status = gpio_group_direction_output(group, 0);
> +  else
> +  {
> +    status = strict_strtoul(buf, 0, &input);
> +    if (!status)
> +    {
> +      if ((input & group->mask) == input)
> +        status = gpio_group_direction_output(group, input);
> +      else
> +        status = -EINVAL;
> +    }
> +  }
> +
> +out:
> +  mutex_unlock(&sysfs_lock);
> +  return status ? : size;
> +}
> +
> +static DEVICE_ATTR(direction, 0644,
>  		gpio_direction_show, gpio_direction_store);
> 
> +struct device_attribute dev_attr_direction_group =
> +	__ATTR(direction, 0644, gpio_group_direction_show,
> gpio_group_direction_store);
> +
>  static ssize_t gpio_value_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> @@ -276,6 +449,50 @@ static ssize_t gpio_value_show(struct device *dev,
>  	return status;
>  }
> 
> +static ssize_t gpio_group_value_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_group *group = dev_get_drvdata(dev);
> +	ssize_t status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (gpio_desc[group->gpios[0]].group != group
> +			|| gpio_group_test_bit(FLAG_EXPORT, group) <= 0)
> +	{
> +		status = -EIO;
> +		goto out;
> +	}
> +	status = sprintf(buf, "%u\n", gpio_group_raw_to_value(group,
> +				gpio_group_get_raw_cansleep(group)));
> +
> +out:
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
> +
> +static ssize_t gpio_group_raw_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_group *group = dev_get_drvdata(dev);
> +	ssize_t status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (gpio_desc[group->gpios[0]].group != group
> +			|| gpio_group_test_bit(FLAG_EXPORT, group) <= 0)
> +	{
> +		status = -EIO;
> +		goto out;
> +	}
> +	status = sprintf(buf, "%u\n", gpio_group_get_raw_cansleep(group));
> +
> +out:
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
>  static ssize_t gpio_value_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t size)
>  {
> @@ -303,9 +520,96 @@ static ssize_t gpio_value_store(struct device *dev,
>  	return status;
>  }
> 
> +static ssize_t gpio_group_value_store(struct device *dev,
> +    struct device_attribute *attr, const char* buf, size_t size)
> +{
> +	const struct gpio_group *group = dev_get_drvdata(dev);
> +	ssize_t status;
> +	unsigned long value;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (gpio_desc[group->gpios[0]].group != group
> +			|| gpio_group_test_bit(FLAG_EXPORT, group) <= 0
> +			|| gpio_group_test_bit(FLAG_IS_OUT, group) <= 0)
> +	{
> +		status = -EIO;
> +		goto out;
> +	}
> +	status = strict_strtoul(buf, 0, &value);
> +	if (status == 0)
> +	{
> +		gpio_group_set_raw_cansleep(group,
> +				gpio_group_value_to_raw(group, value));
> +		status = size;
> +	}
> +
> +out:
> +	mutex_unlock(&sysfs_lock);
> +
> +	return status;
> +}
> +
> +static ssize_t gpio_group_raw_store(struct device *dev,
> +    struct device_attribute *attr, const char* buf, size_t size)
> +{
> +	const struct gpio_group *group = dev_get_drvdata(dev);
> +	ssize_t status;
> +	unsigned long value;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (gpio_desc[group->gpios[0]].group != group
> +			|| gpio_group_test_bit(FLAG_EXPORT, group) <= 0
> +			|| gpio_group_test_bit(FLAG_IS_OUT, group) <= 0)
> +	{
> +		status = -EIO;
> +		goto out;
> +	}
> +	status = strict_strtoul(buf, 0, &value);
> +	if (status == 0)
> +	{
> +		gpio_group_set_raw_cansleep(group, value);
> +		status = size;
> +	}
> +
> +out:
> +	mutex_unlock(&sysfs_lock);
> +
> +	return status;
> +}
> +
> +static ssize_t gpio_group_mask_show(struct device *dev,
> +    struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_group *group = dev_get_drvdata(dev);
> +	ssize_t status;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (gpio_desc[group->gpios[0]].group != group
> +			|| gpio_group_test_bit(FLAG_EXPORT, group) <= 0)
> +	{
> +		status = -EIO;
> +		goto out;
> +	}
> +	status = sprintf(buf, "%u\n", group->mask);
> +
> +out:
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
>  static /*const*/ DEVICE_ATTR(value, 0644,
>  		gpio_value_show, gpio_value_store);
> 
> +struct device_attribute dev_attr_value_group =
> +	__ATTR(value, 0644, gpio_group_value_show, gpio_group_value_store);
> +
> +DEVICE_ATTR(raw, 0644, gpio_group_raw_show, gpio_group_raw_store);
> +
> +DEVICE_ATTR(mask, 0444, gpio_group_mask_show, NULL);
> +
>  static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
>  {
>  	struct work_struct	*work = priv;
> @@ -381,7 +685,7 @@ static int gpio_setup_irq(struct gpio_desc *desc,
> struct device *dev,
>  			goto free_id;
>  		}
> 
> -		pdesc->value_sd = sysfs_get_dirent(dev->kobj.sd, "value");
> +		pdesc->value_sd = sysfs_get_dirent(dev->kobj.sd, NULL, "value");
>  		if (!pdesc->value_sd) {
>  			ret = -ENODEV;
>  			goto free_id;
> @@ -475,9 +779,55 @@ found:
> 
>  static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
> 
> +static ssize_t gpio_label_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_desc	*desc = dev_get_drvdata(dev);
> +	ssize_t			status = 0;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +		status = -EIO;
> +	else if (desc->label)
> +		status = sprintf(buf, "%s\n", desc->label);
> +
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
> +static ssize_t gpio_group_label_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	const struct gpio_group *group = dev_get_drvdata(dev);
> +	const struct gpio_desc	*desc = &gpio_desc[group->gpios[0]];
> +	ssize_t			status = 0;
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	if (!test_bit(FLAG_EXPORT, &desc->flags))
> +		status = -EIO;
> +	else if (desc->label)
> +		status = sprintf(buf, "%s\n", desc->label);
> +
> +	mutex_unlock(&sysfs_lock);
> +	return status;
> +}
> +
> +static struct device_attribute dev_attr_gpio_label = __ATTR(label,
> 0444, gpio_label_show, NULL);
> +static struct device_attribute dev_attr_gpio_group_label =
> __ATTR(label, 0444, gpio_group_label_show, NULL);
> +
>  static const struct attribute *gpio_attrs[] = {
> -	&dev_attr_direction.attr,
>  	&dev_attr_value.attr,
> +	&dev_attr_gpio_label.attr,
> +	NULL,
> +};
> +
> +static const struct attribute *gpio_group_attrs[] = {
> +	&dev_attr_value_group.attr,
> +	&dev_attr_raw.attr,
> +	&dev_attr_mask.attr,
> +	&dev_attr_gpio_group_label.attr,
>  	NULL,
>  };
> 
> @@ -485,6 +835,10 @@ static const struct attribute_group gpio_attr_group = {
>  	.attrs = (struct attribute **) gpio_attrs,
>  };
> 
> +static const struct attribute_group gpio_group_attr_group = {
> +	.attrs = (struct attribute **) gpio_group_attrs,
> +};
> +
>  /*
>   * /sys/class/gpio/gpiochipN/
>   *   /base ... matching gpio_chip.base (N)
> @@ -530,6 +884,36 @@ static const struct attribute_group gpiochip_attr_group = {
>  	.attrs = (struct attribute **) gpiochip_attrs,
>  };
> 
> +int read_gpios(const char *buf, size_t len, unsigned *gpios)
> +{
> +	const char *startp = buf;
> +	char *endp = (char*)buf;
> +	int i;
> +	for (i = 0; i < 32; ++i)
> +	{
> +		unsigned gpio;
> +
> +		gpio = simple_strtoul(startp, &endp, 0);
> +
> +		if (endp == startp)
> +			return -EINVAL; // not a number, bail out
> +
> +		gpios[i] = gpio;
> +
> +		while (endp - buf < len && isspace(*endp)) // eat whitespace
> +			endp++;
> +
> +
> +		if (endp - buf > len) // buffer overrun, should never happen
> +			return -EINVAL;
> +		else if (endp - buf == len) // end of buffer, return number of read gpios
> +			return i+1;
> +
> +		startp = endp;
> +	}
> +	return -EINVAL;
> +}
> +
>  /*
>   * /sys/class/gpio/export ... write-only
>   *	integer N ... number of GPIO to export (full access)
> @@ -538,10 +922,10 @@ static const struct attribute_group
> gpiochip_attr_group = {
>   */
>  static ssize_t export_store(struct class *class, const char *buf, size_t len)
>  {
> -	long	gpio;
> +	unsigned	gpio[32];
>  	int	status;
> 
> -	status = strict_strtol(buf, 0, &gpio);
> +	status = read_gpios(buf, len, gpio);
>  	if (status < 0)
>  		goto done;
> 
> @@ -550,16 +934,41 @@ static ssize_t export_store(struct class *class,
> const char *buf, size_t len)
>  	 * they may be undone on its behalf too.
>  	 */
> 
> -	status = gpio_request(gpio, "sysfs");
> -	if (status < 0)
> -		goto done;
> +	if (status == 1)
> +	{
> +		status = gpio_request(gpio[0], "sysfs");
> +		if (status < 0)
> +			goto done;
> 
> -	status = gpio_export(gpio, true);
> -	if (status < 0)
> -		gpio_free(gpio);
> +		status = gpio_export(gpio[0], true);
> +		if (status < 0)
> +			gpio_free(gpio[0]);
> +		else
> +			set_bit(FLAG_SYSFS, &gpio_desc[gpio[0]].flags);
> +	}
>  	else
> -		set_bit(FLAG_SYSFS, &gpio_desc[gpio].flags);
> +	{
> +		struct gpio_group *group = gpio_group_request(gpio, status, "sysfs");
> +		if (IS_ERR(group))
> +		{
> +			status = PTR_ERR(group);
> +			goto done;
> +		}
> 
> +		status = gpio_group_export(group, true);
> +		if (status < 0)
> +			gpio_group_free(group);
> +		else
> +    {
> +      // Lock required to protect against unexport being called
> +      // against when only parts of the group have the flag set.
> +      // The other cases: all have the flag or none have the flag
> +      // are handled correctly.
> +      mutex_lock(&sysfs_lock);
> +			gpio_group_set_bit(FLAG_SYSFS, group);
> +      mutex_unlock(&sysfs_lock);
> +    }
> +	}
>  done:
>  	if (status)
>  		pr_debug("%s: status %d\n", __func__, status);
> @@ -570,6 +979,7 @@ static ssize_t unexport_store(struct class *class,
> const char *buf, size_t len)
>  {
>  	long	gpio;
>  	int	status;
> +	struct gpio_group *group;
> 
>  	status = strict_strtol(buf, 0, &gpio);
>  	if (status < 0)
> @@ -581,13 +991,29 @@ static ssize_t unexport_store(struct class
> *class, const char *buf, size_t len)
>  	if (!gpio_is_valid(gpio))
>  		goto done;
> 
> -	/* No extra locking here; FLAG_SYSFS just signifies that the
> -	 * request and export were done by on behalf of userspace, so
> -	 * they may be undone on its behalf too.
> -	 */
> -	if (test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags)) {
> -		status = 0;
> -		gpio_free(gpio);
> +	group = gpio_to_group(gpio);
> +	if (group)
> +	{
> +		mutex_lock(&sysfs_lock);
> +		if (gpio_group_test_bit(FLAG_SYSFS, group))
> +		{
> +			status = 0;
> +			gpio_group_clear_bit(FLAG_SYSFS, group);
> +		}
> +		mutex_unlock(&sysfs_lock);
> +		if (!status)
> +			gpio_group_free(group);
> +	}
> +	else
> +	{
> +		/* No extra locking here; FLAG_SYSFS just signifies that the
> +		 * request and export were done by on behalf of userspace, so
> +		 * they may be undone on its behalf too.
> +		 */
> +		if (test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags)) {
> +			status = 0;
> +			gpio_free(gpio);
> +		}
>  	}
>  done:
>  	if (status)
> @@ -662,12 +1088,11 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>  		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
>  				desc, ioname ? ioname : "gpio%d", gpio);
>  		if (!IS_ERR(dev)) {
> -			if (direction_may_change)
> -				status = sysfs_create_group(&dev->kobj,
> -						&gpio_attr_group);
> -			else
> -				status = device_create_file(dev,
> -						&dev_attr_value);
> +  		status = sysfs_create_group(&dev->kobj,
> +  						&gpio_attr_group);
> +
> +			if (!status && direction_may_change)
> +				status = device_create_file(dev, &dev_attr_direction);
> 
>  			if (!status && gpio_to_irq(gpio) >= 0
>  					&& (direction_may_change
> @@ -694,6 +1119,72 @@ done:
>  }
>  EXPORT_SYMBOL_GPL(gpio_export);
> 
> +int gpio_group_export(struct gpio_group *group, bool direction_may_change)
> +{
> +	unsigned long flags;
> +	int status = -EINVAL;
> +	struct gpio_chip *chip;
> +	unsigned lowest = group->gpios[0];
> +	int i;
> +
> +	/* can't export until sysfs is available ... */
> +	if (!gpio_class.p) {
> +		pr_debug("%s: called too early!\n", __func__);
> +		return -ENOENT;
> +	}
> +
> +	mutex_lock(&sysfs_lock);
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +	chip = gpio_to_chip(group->gpios[0]);
> +	if (gpio_group_test_bit(FLAG_REQUESTED, group) > 0
> +			&& gpio_group_test_bit(FLAG_EXPORT, group) == 0)
> +	{
> +		status = 0;
> +		if (!chip->direction_input_multi || !chip->direction_output_multi)
> +		{
> +			direction_may_change = false;
> +		}
> +	}
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	if (status == 0)
> +	{
> +		struct device *dev;
> +
> +		i=1;
> +		while (i < 32 && group->gpios[i] != ARCH_NR_GPIOS)
> +		{
> +			if (group->gpios[i] < lowest)
> +				lowest = group->gpios[i];
> +			++i;
> +		}
> +
> +		dev = device_create(&gpio_class, chip->dev, MKDEV(0, 0),
> +				group, "group%d", lowest);
> +		if (!IS_ERR(dev)) {
> +			status = sysfs_create_group(&dev->kobj, &gpio_group_attr_group);
> +
> +			if (status == 0 && direction_may_change)
> +				status = device_create_file(dev, &dev_attr_direction_group);
> +
> +			if (status != 0)
> +				device_unregister(dev);
> +		}
> +		else
> +			status = PTR_ERR(dev);
> +		if (status == 0)
> +			gpio_group_set_bit(FLAG_EXPORT, group);
> +	}
> +	mutex_unlock(&sysfs_lock);
> +
> +	if (status)
> +		pr_debug("%s: group%d status %d\n", __func__, group->gpios[0], status);
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_export);
> +
> +
>  static int match_export(struct device *dev, void *data)
>  {
>  	return dev_get_drvdata(dev) == data;
> @@ -744,6 +1235,30 @@ done:
>  }
>  EXPORT_SYMBOL_GPL(gpio_export_link);
> 
> +int gpio_group_export_link(struct device *dev, const char *name,
> struct gpio_group *group)
> +{
> +	int status = -EINVAL;
> +	mutex_lock(&sysfs_lock);
> +	if (gpio_group_test_bit(FLAG_EXPORT, group) == 1)
> +	{
> +		struct device *tdev;
> +
> +		tdev = class_find_device(&gpio_class, NULL, group, match_export);
> +		if (tdev != NULL) {
> +			status = sysfs_create_link(&dev->kobj, &tdev->kobj, name);
> +		}
> +		else
> +		{
> +			status = -ENODEV;
> +		}
> +	}
> +	mutex_unlock(&sysfs_lock);
> +	if (status)
> +		pr_debug("%s: group%d status %d\n", __func__, group->gpios[0], status);
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_export_link);
> +
>  /**
>   * gpio_unexport - reverse effect of gpio_export()
>   * @gpio: gpio to make unavailable
> @@ -783,6 +1298,31 @@ done:
>  }
>  EXPORT_SYMBOL_GPL(gpio_unexport);
> 
> +void gpio_group_unexport(struct gpio_group *group)
> +{
> +	int status = -EINVAL;
> +	mutex_lock(&sysfs_lock);
> +
> +	if (gpio_group_test_bit(FLAG_EXPORT, group) == 1)
> +	{
> +		struct device *dev = NULL;
> +		dev = class_find_device(&gpio_class, NULL, group, match_export);
> +		if (dev)
> +		{
> +			gpio_group_clear_bit(FLAG_EXPORT, group);
> +			put_device(dev);
> +			device_unregister(dev);
> +			status = 0;
> +		}
> +		else
> +			status = -ENODEV;
> +	}
> +	mutex_unlock(&sysfs_lock);
> +	if (status)
> +		pr_debug("%s: group%d status %d\n", __func__, group->gpios[0], status);
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_unexport);
> +
>  static int gpiochip_export(struct gpio_chip *chip)
>  {
>  	int		status;
> @@ -959,6 +1499,8 @@ int gpiochip_add(struct gpio_chip *chip)
>  		}
>  	}
> 
> +	of_gpiochip_add(chip);
> +
>  unlock:
>  	spin_unlock_irqrestore(&gpio_lock, flags);
>  	if (status == 0)
> @@ -987,6 +1529,8 @@ int gpiochip_remove(struct gpio_chip *chip)
> 
>  	spin_lock_irqsave(&gpio_lock, flags);
> 
> +	of_gpiochip_remove(chip);
> +
>  	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
>  		if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
>  			status = -EBUSY;
> @@ -1007,6 +1551,38 @@ int gpiochip_remove(struct gpio_chip *chip)
>  }
>  EXPORT_SYMBOL_GPL(gpiochip_remove);
> 
> +/**
> + * gpiochip_find() - iterator for locating a specific gpio_chip
> + * @data: data to pass to match function
> + * @callback: Callback function to check gpio_chip
> + *
> + * Similar to bus_find_device.  It returns a reference to a gpio_chip as
> + * determined by a user supplied @match callback.  The callback should return
> + * 0 if the device doesn't match and non-zero if it does.  If the callback is
> + * non-zero, this function will return to the caller and not iterate over any
> + * more gpio_chips.
> + */
> +struct gpio_chip *gpiochip_find(void *data,
> +				int (*match)(struct gpio_chip *chip, void *data))
> +{
> +	struct gpio_chip *chip = NULL;
> +	unsigned long flags;
> +	int i;
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +	for (i = 0; i < ARCH_NR_GPIOS; i++) {
> +		if (!gpio_desc[i].chip)
> +			continue;
> +
> +		if (match(gpio_desc[i].chip, data)) {
> +			chip = gpio_desc[i].chip;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	return chip;
> +}
> 
>  /* These "optional" allocation calls help prevent drivers from stomping
>   * on each other, and help provide better diagnostics in debugfs.
> @@ -1066,6 +1642,111 @@ done:
>  }
>  EXPORT_SYMBOL_GPL(gpio_request);
> 
> +struct gpio_group* gpio_group_request(unsigned *gpio, int ngpios,
> const char* label)
> +{
> +	int i;
> +	unsigned long flags;
> +	u32 mask = 0;
> +	struct gpio_chip *chip;
> +	int rc = 0;
> +	struct gpio_group *group;
> +
> +	if (ngpios <= 0)
> +		return ERR_PTR(-EINVAL);
> +
> +	group = kzalloc(sizeof(struct gpio_group), GFP_KERNEL);
> +	if (!group)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +	if (!gpio_is_valid(gpio[0]))
> +	{
> +		rc = -EINVAL;
> +		goto out_free;
> +	}
> +	chip = gpio_to_chip(gpio[0]);
> +	// if not (multi-input or multi-output capable)
> +	if (!chip ||
> +			!(   (chip->get_multi && chip->direction_input_multi)
> +				|| (chip->set_multi && chip->direction_output_multi))
> +	   )
> +	{
> +		rc = -ENODEV;
> +		goto out_free;
> +	}
> +
> +	mask |= (1 << (gpio[0] - chip->base));
> +	for (i = 1; i < ngpios; ++i)
> +	{
> +		if (gpio[i] < chip->base || gpio[i] > chip->base + chip->ngpio)
> +		{
> +			rc = -EINVAL;
> +			goto out_free;
> +		}
> +		mask |= (1 << (gpio[i] - chip->base));
> +	}
> +
> +	if (!try_module_get(chip->owner))
> +	{
> +		rc = -ENOSYS;
> +		goto out_free;
> +	}
> +
> +	group->mask = mask;
> +	for (i = 0; i < 32; ++i)
> +	{
> +		if (i < ngpios)
> +			group->gpios[i] = gpio[i];
> +		else
> +			group->gpios[i] = ARCH_NR_GPIOS;
> +	}
> +
> +	if (gpio_group_test_bit(FLAG_REQUESTED, group) != 0)
> +	{
> +		rc = -EBUSY;
> +		goto out_put;
> +	}
> +
> +	gpio_group_set_bit(FLAG_REQUESTED, group);
> +	for (i = 0; i < ngpios; ++i)
> +	{
> +		gpio_desc[gpio[i]].group = group;
> +		desc_set_label(&gpio_desc[gpio[i]], label ? : "?");
> +	}
> +
> +	if (chip->request_multi) {
> +		spin_unlock_irqrestore(&gpio_lock, flags);
> +		rc = chip->request_multi(chip, mask);
> +		spin_lock_irqsave(&gpio_lock, flags);
> +		if (rc)
> +			goto out_label;
> +	}
> +
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +	return group;
> +out_label:
> +	for (i = 0; i < ngpios; ++i)
> +	{
> +		desc_set_label(&gpio_desc[gpio[i]], NULL);
> +		gpio_desc[gpio[i]].group = NULL;
> +	}
> +out_put:
> +	module_put(chip->owner);
> +out_free:
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +	kfree(group);
> +	pr_debug("%s: group%d (%s) status %d\n", __func__, *gpio, label ? : "?", rc);
> +	return ERR_PTR(rc);
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_request);
> +
> +struct gpio_group * gpio_get_group(unsigned gpio)
> +{
> +	if (!gpio_is_valid(gpio))
> +		return NULL;
> +	return gpio_desc[gpio].group;
> +}
> +
>  void gpio_free(unsigned gpio)
>  {
>  	unsigned long		flags;
> @@ -1102,6 +1783,45 @@ void gpio_free(unsigned gpio)
>  }
>  EXPORT_SYMBOL_GPL(gpio_free);
> 
> +void gpio_group_free(struct gpio_group *group)
> +{
> +	unsigned long flags;
> +	struct gpio_chip *chip;
> +
> +	might_sleep();
> +
> +	gpio_group_unexport(group);
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +
> +	chip = gpio_to_chip(group->gpios[0]);
> +	if (chip && gpio_group_test_bit(FLAG_REQUESTED, group))
> +	{
> +		int i;
> +		if (chip->free_multi) {
> +			spin_unlock_irqrestore(&gpio_lock, flags);
> +			might_sleep_if(extra_checks && chip->can_sleep);
> +			chip->free_multi(chip, group->mask);
> +			spin_lock_irqsave(&gpio_lock, flags);
> +		}
> +		for (i = 0; i < 32; ++i)
> +		{
> +			if (group->mask & (1 << i))
> +			{
> +				desc_set_label(&gpio_desc[chip->base + i], NULL);
> +				gpio_desc[chip->base +i].group = NULL;
> +			}
> +			module_put(chip->owner);
> +			gpio_group_clear_bit(FLAG_REQUESTED, group);
> +		}
> +	}
> +	else
> +		WARN_ON(extra_checks);
> +
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +	kfree(group);
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_free);
> 
>  /**
>   * gpiochip_is_requested - return string iff signal was requested
> @@ -1124,15 +1844,10 @@ const char *gpiochip_is_requested(struct
> gpio_chip *chip, unsigned offset)
>  		return NULL;
>  	if (test_bit(FLAG_REQUESTED, &gpio_desc[gpio].flags) == 0)
>  		return NULL;
> -#ifdef CONFIG_DEBUG_FS
>  	return gpio_desc[gpio].label;
> -#else
> -	return "?";
> -#endif
>  }
>  EXPORT_SYMBOL_GPL(gpiochip_is_requested);
> 
> -
>  /* Drivers MUST set GPIO direction before making get/set calls.  In
>   * some cases this is done in early boot, before IRQs are enabled.
>   *
> @@ -1195,6 +1910,25 @@ fail:
>  }
>  EXPORT_SYMBOL_GPL(gpio_direction_input);
> 
> +
> +int gpio_group_direction_input(const struct gpio_group *group)
> +{
> +	struct gpio_chip *chip = gpio_to_chip(group->gpios[0]);
> +	int rc;
> +
> +	if (!chip->get_multi || !chip->direction_input_multi)
> +		return -EINVAL;
> +
> +	rc = chip->direction_input_multi(chip, group->mask);
> +	if (rc == 0)
> +	{
> +		gpio_group_clear_bit(FLAG_IS_OUT, group);
> +	}
> +	else
> +		pr_debug("%s: group%d status %d\n", __func__, group->gpios[0], rc);
> +	return rc;
> +}
> +
>  int gpio_direction_output(unsigned gpio, int value)
>  {
>  	unsigned long		flags;
> @@ -1248,6 +1982,124 @@ fail:
>  }
>  EXPORT_SYMBOL_GPL(gpio_direction_output);
> 
> +int gpio_group_direction_output(const struct gpio_group *group, u32 value)
> +{
> +	struct gpio_chip *chip = gpio_to_chip(group->gpios[0]);
> +	int rc;
> +
> +	if (!chip->set_multi || !chip->direction_output_multi)
> +		return -EINVAL;
> +
> +	rc = chip->direction_output_multi(chip, group->mask, value & group->mask);
> +	if (rc == 0)
> +	{
> +		gpio_group_set_bit(FLAG_IS_OUT, group);
> +	}
> +	else
> +		pr_debug("%s: group%d status %d\n", __func__, group->gpios[0], rc);
> +	return rc;
> +}
> +
> +int gpio_set_opendrain(unsigned gpio, int value)
> +{
> +	unsigned long		flags;
> +	struct gpio_chip	*chip;
> +	struct gpio_desc	*desc = &gpio_desc[gpio];
> +	int			status = -EINVAL;
> +
> +	spin_lock_irqsave(&gpio_lock, flags);
> +
> +	if (!gpio_is_valid(gpio))
> +		goto fail;
> +	chip = desc->chip;
> +	if (!chip || !chip->set || !chip->direction_output)
> +		goto fail;
> +	gpio -= chip->base;
> +	if (gpio >= chip->ngpio)
> +		goto fail;
> +	status = gpio_ensure_requested(desc, gpio);
> +	if (status < 0)
> +		goto fail;
> +
> +	/* now we know the gpio is valid and chip won't vanish */
> +
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +
> +	might_sleep_if(extra_checks && chip->can_sleep);
> +
> +	if (!chip->set_opendrain)
> +		return -ENOSYS;
> +
> +	if (status) {
> +		status = chip->request(chip, gpio);
> +		if (status < 0) {
> +			pr_debug("GPIO-%d: chip request fail, %d\n",
> +				chip->base + gpio, status);
> +			/* and it's not available to anyone else ...
> +			 * gpio_request() is the fully clean solution.
> +			 */
> +			goto lose;
> +		}
> +	}
> +
> +	status = chip->set_opendrain(chip, gpio, value);
> +	if (status == 0)
> +	{
> +		if (value)
> +			set_bit(FLAG_OPEN_DRAIN, &desc->flags);
> +		else
> +			clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
> +	}
> +lose:
> +	return status;
> +fail:
> +	spin_unlock_irqrestore(&gpio_lock, flags);
> +	if (status)
> +		pr_debug("%s: gpio-%d status %d\n",
> +			__func__, gpio, status);
> +	return status;
> +}
> +EXPORT_SYMBOL_GPL(gpio_set_opendrain);
> +
> +int gpio_group_set_opendrain(struct gpio_group *group, u32 value)
> +{
> +	struct gpio_chip *chip = gpio_to_chip(group->gpios[0]);
> +	int err;
> +	if (!chip)
> +		return -EINVAL;
> +	if (!chip->set_multi || !chip->direction_output_multi)
> +		return -EINVAL;
> +	if (!chip->set_opendrain_multi)
> +		return -ENOSYS;
> +
> +	might_sleep_if(extra_checks && chip->can_sleep);
> +
> +	err = chip->set_opendrain_multi(chip, group->mask, value & group->mask);
> +	if (err == 0)
> +	{
> +		int i;
> +		unsigned base = chip->base;
> +		for (i = 0; i < 32; ++i)
> +		{
> +			if (group->mask & (1 << i))
> +			{
> +				if (value & (1 << i))
> +				{
> +					set_bit(FLAG_OPEN_DRAIN, &gpio_desc[base+i].flags);
> +				}
> +				else
> +				{
> +					clear_bit(FLAG_OPEN_DRAIN, &gpio_desc[base+i].flags);
> +				}
> +			}
> +		}
> +	}
> +	if (err)
> +		pr_debug("%s: group%d status %d\n",
> +				__func__, group->gpios[0], err);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_set_opendrain);
> 
>  /* I/O calls are only valid after configuration completed; the relevant
>   * "is this a valid GPIO" error checks should already have been done.
> @@ -1290,6 +2142,14 @@ int __gpio_get_value(unsigned gpio)
>  }
>  EXPORT_SYMBOL_GPL(__gpio_get_value);
> 
> +u32 gpio_group_get_raw(const struct gpio_group* group)
> +{
> +	struct gpio_chip *chip;
> +	chip = gpio_to_chip(group->gpios[0]);
> +	return chip->get_multi ? chip->get_multi(chip, group->mask) : 0;
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_get_raw);
> +
>  /**
>   * __gpio_set_value() - assign a gpio's value
>   * @gpio: gpio whose value will be assigned
> @@ -1309,6 +2169,13 @@ void __gpio_set_value(unsigned gpio, int value)
>  }
>  EXPORT_SYMBOL_GPL(__gpio_set_value);
> 
> +void gpio_group_set_raw(const struct gpio_group *group, u32 value)
> +{
> +	struct gpio_chip *chip;
> +	chip = gpio_to_chip(group->gpios[0]);
> +	chip->set_multi(chip, group->mask, value | group->mask);
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_set_raw);
>  /**
>   * __gpio_cansleep() - report whether gpio value access will sleep
>   * @gpio: gpio in question
> @@ -1328,6 +2195,11 @@ int __gpio_cansleep(unsigned gpio)
>  }
>  EXPORT_SYMBOL_GPL(__gpio_cansleep);
> 
> +int gpio_group_cansleep(const struct gpio_group *group)
> +{
> +	return __gpio_cansleep(group->gpios[0]);
> +}
> +
>  /**
>   * __gpio_to_irq() - return the IRQ corresponding to a GPIO
>   * @gpio: gpio whose IRQ will be returned (already requested)
> @@ -1362,6 +2234,15 @@ int gpio_get_value_cansleep(unsigned gpio)
>  }
>  EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
> 
> +u32 gpio_group_get_raw_cansleep(const struct gpio_group *group)
> +{
> +	struct gpio_chip *chip;
> +	might_sleep_if(extra_checks);
> +	chip = gpio_to_chip(group->gpios[0]);
> +	return chip->get_multi ? chip->get_multi(chip, group->mask) : 0;
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_get_raw_cansleep);
> +
>  void gpio_set_value_cansleep(unsigned gpio, int value)
>  {
>  	struct gpio_chip	*chip;
> @@ -1372,6 +2253,14 @@ void gpio_set_value_cansleep(unsigned gpio, int value)
>  }
>  EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
> 
> +void gpio_group_set_raw_cansleep(const struct gpio_group *group, u32 value)
> +{
> +	struct gpio_chip *chip;
> +	might_sleep_if(extra_checks);
> +	chip = gpio_to_chip(group->gpios[0]);
> +	chip->set_multi(chip, group->mask, value & group->mask);
> +}
> +EXPORT_SYMBOL_GPL(gpio_group_set_raw_cansleep);
> 
>  #ifdef CONFIG_DEBUG_FS
> 
> @@ -1381,18 +2270,24 @@ static void gpiolib_dbg_show(struct seq_file
> *s, struct gpio_chip *chip)
>  	unsigned		gpio = chip->base;
>  	struct gpio_desc	*gdesc = &gpio_desc[gpio];
>  	int			is_out;
> +	int			is_open;
> +	int     is_group;
> 
>  	for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
>  		if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
>  			continue;
> 
>  		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
> -		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
> -			gpio, gdesc->label,
> -			is_out ? "out" : "in ",
> -			chip->get
> +		is_open = test_bit(FLAG_OPEN_DRAIN, &gdesc->flags);
> +		is_group = (gdesc->group != NULL);
> +		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s %s %s",
> +				gpio, gdesc->label,
> +				is_out ? "out" : "in ",
> +				chip->get
>  				? (chip->get(chip, i) ? "hi" : "lo")
> -				: "?  ");
> +				: "?  ",
> +				is_open ? "open" : "act ",
> +				is_group ? "grp" : "pin");
> 
>  		if (!is_out) {
>  			int		irq = gpio_to_irq(gpio);
> @@ -1408,32 +2303,32 @@ static void gpiolib_dbg_show(struct seq_file
> *s, struct gpio_chip *chip)
>  				char *trigger;
> 
>  				switch (desc->status & IRQ_TYPE_SENSE_MASK) {
> -				case IRQ_TYPE_NONE:
> -					trigger = "(default)";
> -					break;
> -				case IRQ_TYPE_EDGE_FALLING:
> -					trigger = "edge-falling";
> -					break;
> -				case IRQ_TYPE_EDGE_RISING:
> -					trigger = "edge-rising";
> -					break;
> -				case IRQ_TYPE_EDGE_BOTH:
> -					trigger = "edge-both";
> -					break;
> -				case IRQ_TYPE_LEVEL_HIGH:
> -					trigger = "level-high";
> -					break;
> -				case IRQ_TYPE_LEVEL_LOW:
> -					trigger = "level-low";
> -					break;
> -				default:
> -					trigger = "?trigger?";
> -					break;
> +					case IRQ_TYPE_NONE:
> +						trigger = "(default)";
> +						break;
> +					case IRQ_TYPE_EDGE_FALLING:
> +						trigger = "edge-falling";
> +						break;
> +					case IRQ_TYPE_EDGE_RISING:
> +						trigger = "edge-rising";
> +						break;
> +					case IRQ_TYPE_EDGE_BOTH:
> +						trigger = "edge-both";
> +						break;
> +					case IRQ_TYPE_LEVEL_HIGH:
> +						trigger = "level-high";
> +						break;
> +					case IRQ_TYPE_LEVEL_LOW:
> +						trigger = "level-low";
> +						break;
> +					default:
> +						trigger = "?trigger?";
> +						break;
>  				}
> 
>  				seq_printf(s, " irq-%d %s%s",
> -					irq, trigger,
> -					(desc->status & IRQ_WAKEUP)
> +						irq, trigger,
> +						(desc->status & IRQ_WAKEUP)
>  						? " wakeup" : "");
>  			}
>  		}
> diff --git a/drivers/gpio/pcf857x.c b/drivers/gpio/pcf857x.c
> index 29f19ce..a51d9ad 100644
> --- a/drivers/gpio/pcf857x.c
> +++ b/drivers/gpio/pcf857x.c
> @@ -79,6 +79,20 @@ static int pcf857x_input8(struct gpio_chip *chip,
> unsigned offset)
>  	return status;
>  }
> 
> +static int pcf857x_input8_multi(struct gpio_chip *chip, u32 mask)
> +{
> +	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> +	int		status;
> +
> +	mutex_lock(&gpio->lock);
> +	gpio->out |= (u16)mask;
> +	status = i2c_smbus_write_byte(gpio->client, gpio->out);
> +	mutex_unlock(&gpio->lock);
> +
> +	return status;
> +}
> +
> +
>  static int pcf857x_get8(struct gpio_chip *chip, unsigned offset)
>  {
>  	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> @@ -88,6 +102,15 @@ static int pcf857x_get8(struct gpio_chip *chip,
> unsigned offset)
>  	return (value < 0) ? 0 : (value & (1 << offset));
>  }
> 
> +static u32 pcf857x_get8_multi(struct gpio_chip *chip, u32 mask)
> +{
> +	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> +	u32		value;
> +
> +	value = i2c_smbus_read_byte(gpio->client);
> +	return (value < 0) ? 0 : (value & mask);
> +}
> +
>  static int pcf857x_output8(struct gpio_chip *chip, unsigned offset, int value)
>  {
>  	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> @@ -105,6 +128,25 @@ static int pcf857x_output8(struct gpio_chip
> *chip, unsigned offset, int value)
>  	return status;
>  }
> 
> +static int pcf857x_output8_multi(struct gpio_chip *chip, u32 mask, u32 value)
> +{
> +	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> +	int		status;
> +
> +	mutex_lock(&gpio->lock);
> +	gpio->out &= ~mask;
> +	gpio->out |= value;
> +	status = i2c_smbus_write_byte(gpio->client, gpio->out);
> +	mutex_unlock(&gpio->lock);
> +
> +	return status;
> +}
> +
> +static void pcf857x_set8_multi(struct gpio_chip *chip, u32 mask, u32 value)
> +{
> +	pcf857x_output8_multi(chip, mask, value);
> +}
> +
>  static void pcf857x_set8(struct gpio_chip *chip, unsigned offset, int value)
>  {
>  	pcf857x_output8(chip, offset, value);
> @@ -147,6 +189,19 @@ static int pcf857x_input16(struct gpio_chip
> *chip, unsigned offset)
>  	return status;
>  }
> 
> +static int pcf857x_input16_multi(struct gpio_chip *chip, u32 mask)
> +{
> +	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> +	int		status;
> +
> +	mutex_lock(&gpio->lock);
> +	gpio->out |= mask;
> +	status = i2c_write_le16(gpio->client, gpio->out);
> +	mutex_unlock(&gpio->lock);
> +
> +	return status;
> +}
> +
>  static int pcf857x_get16(struct gpio_chip *chip, unsigned offset)
>  {
>  	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> @@ -156,6 +211,15 @@ static int pcf857x_get16(struct gpio_chip *chip,
> unsigned offset)
>  	return (value < 0) ? 0 : (value & (1 << offset));
>  }
> 
> +static u32 pcf857x_get16_multi(struct gpio_chip *chip, u32 mask)
> +{
> +	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> +	u32		value;
> +
> +	value = i2c_read_le16(gpio->client);
> +	return (value < 0) ? 0 : (value & mask);
> +}
> +
>  static int pcf857x_output16(struct gpio_chip *chip, unsigned offset, int value)
>  {
>  	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> @@ -173,11 +237,30 @@ static int pcf857x_output16(struct gpio_chip
> *chip, unsigned offset, int value)
>  	return status;
>  }
> 
> +static int pcf857x_output16_multi(struct gpio_chip *chip, u32 mask, u32 value)
> +{
> +	struct pcf857x	*gpio = container_of(chip, struct pcf857x, chip);
> +	int		status;
> +
> +	mutex_lock(&gpio->lock);
> +	gpio->out &= ~mask;
> +	gpio->out |= value;
> +	status = i2c_write_le16(gpio->client, gpio->out);
> +	mutex_unlock(&gpio->lock);
> +
> +	return status;
> +}
> +
>  static void pcf857x_set16(struct gpio_chip *chip, unsigned offset, int value)
>  {
>  	pcf857x_output16(chip, offset, value);
>  }
> 
> +static void pcf857x_set16_multi(struct gpio_chip *chip, u32 mask, u32 value)
> +{
> +	pcf857x_output16_multi(chip, mask, value);
> +}
> +
>  /*-------------------------------------------------------------------------*/
> 
>  static int pcf857x_probe(struct i2c_client *client,
> @@ -190,7 +273,6 @@ static int pcf857x_probe(struct i2c_client *client,
>  	pdata = client->dev.platform_data;
>  	if (!pdata) {
>  		dev_dbg(&client->dev, "no platform data\n");
> -		return -EINVAL;
>  	}
> 
>  	/* Allocate, initialize, and register this gpio_chip. */
> @@ -200,7 +282,7 @@ static int pcf857x_probe(struct i2c_client *client,
> 
>  	mutex_init(&gpio->lock);
> 
> -	gpio->chip.base = pdata->gpio_base;
> +	gpio->chip.base = pdata ? pdata->gpio_base : -1;
>  	gpio->chip.can_sleep = 1;
>  	gpio->chip.dev = &client->dev;
>  	gpio->chip.owner = THIS_MODULE;
> @@ -218,10 +300,14 @@ static int pcf857x_probe(struct i2c_client *client,
>  	 */
>  	gpio->chip.ngpio = id->driver_data;
>  	if (gpio->chip.ngpio == 8) {
> +		gpio->chip.direction_input_multi = pcf857x_input8_multi;
>  		gpio->chip.direction_input = pcf857x_input8;
>  		gpio->chip.get = pcf857x_get8;
> +		gpio->chip.get_multi = pcf857x_get8_multi;
>  		gpio->chip.direction_output = pcf857x_output8;
> +		gpio->chip.direction_output_multi = pcf857x_output8_multi;
>  		gpio->chip.set = pcf857x_set8;
> +		gpio->chip.set_multi = pcf857x_set8_multi;
> 
>  		if (!i2c_check_functionality(client->adapter,
>  				I2C_FUNC_SMBUS_BYTE))
> @@ -239,9 +325,13 @@ static int pcf857x_probe(struct i2c_client *client,
>  	 */
>  	} else if (gpio->chip.ngpio == 16) {
>  		gpio->chip.direction_input = pcf857x_input16;
> +		gpio->chip.direction_input_multi = pcf857x_input16_multi;
>  		gpio->chip.get = pcf857x_get16;
> +		gpio->chip.get_multi = pcf857x_get16_multi;
>  		gpio->chip.direction_output = pcf857x_output16;
> +		gpio->chip.direction_output_multi = pcf857x_output16_multi;
>  		gpio->chip.set = pcf857x_set16;
> +		gpio->chip.set_multi = pcf857x_set16_multi;
> 
>  		if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
>  			status = -EIO;
> @@ -278,7 +368,7 @@ static int pcf857x_probe(struct i2c_client *client,
>  	 * to zero, our software copy of the "latch" then matches the chip's
>  	 * all-ones reset state.  Otherwise it flags pins to be driven low.
>  	 */
> -	gpio->out = ~pdata->n_latch;
> +	gpio->out = pdata ? ~pdata->n_latch : ~0;
> 
>  	status = gpiochip_add(&gpio->chip);
>  	if (status < 0)
> @@ -299,7 +389,7 @@ static int pcf857x_probe(struct i2c_client *client,
>  	/* Let platform code set up the GPIOs and their users.
>  	 * Now is the first time anyone could use them.
>  	 */
> -	if (pdata->setup) {
> +	if (pdata && pdata->setup) {
>  		status = pdata->setup(client,
>  				gpio->chip.base, gpio->chip.ngpio,
>  				pdata->context);
> @@ -310,7 +400,7 @@ static int pcf857x_probe(struct i2c_client *client,
>  	return 0;
> 
>  fail:
> -	dev_dbg(&client->dev, "probe error %d for '%s'\n",
> +	dev_err(&client->dev, "probe error %d for '%s'\n",
>  			status, client->name);
>  	kfree(gpio);
>  	return status;
> @@ -322,7 +412,7 @@ static int pcf857x_remove(struct i2c_client *client)
>  	struct pcf857x			*gpio = i2c_get_clientdata(client);
>  	int				status = 0;
> 
> -	if (pdata->teardown) {
> +	if (pdata && pdata->teardown) {
>  		status = pdata->teardown(client,
>  				gpio->chip.base, gpio->chip.ngpio,
>  				pdata->context);
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 66d6106..ed2407f 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -30,6 +30,7 @@ static inline int gpio_is_valid(int number)
> 
>  struct seq_file;
>  struct module;
> +struct device_node;
> 
>  /**
>   * struct gpio_chip - abstract a GPIO controller
> @@ -89,6 +90,22 @@ struct gpio_chip {
>  						unsigned offset, int value);
>  	void			(*set)(struct gpio_chip *chip,
>  						unsigned offset, int value);
> +	int			(*set_opendrain)(struct gpio_chip *chip,
> +						unsigned offset, int value);
> +	int			(*set_opendrain_multi)(struct gpio_chip *chip,
> +						u32 mask, u32 value);
> +
> +	int			(*request_multi)(struct gpio_chip *chip,
> +						u32 mask);
> +	void			(*free_multi)(struct gpio_chip *chip,
> +						u32 mask);
> +
> +	int			(*direction_input_multi)(struct gpio_chip *chip,
> +						u32 mask);
> +	int			(*direction_output_multi)(struct gpio_chip *chip,
> +						u32 mask, u32 value);
> +	void			(*set_multi)(struct gpio_chip *chip, u32 mask, u32 value);
> +	u32			(*get_multi)(struct gpio_chip *chip, u32 mask);
> 
>  	int			(*to_irq)(struct gpio_chip *chip,
>  						unsigned offset);
> @@ -100,6 +117,23 @@ struct gpio_chip {
>  	char			**names;
>  	unsigned		can_sleep:1;
>  	unsigned		exported:1;
> +
> +#if defined(CONFIG_OF_GPIO)
> +	/*
> +	 * If CONFIG_OF is enabled, then all GPIO controllers described in the
> +	 * device tree automatically may have an OF translation
> +	 */
> +	struct device_node *of_node;
> +	int of_gpio_n_cells;
> +	int (*of_xlate)(struct gpio_chip *gc, struct device_node *np,
> +		        const void *gpio_spec, u32 *flags);
> +#endif
> +};
> +
> +struct gpio_group
> +{
> +	unsigned gpios[32];
> +	u32 mask;
>  };
> 
>  extern const char *gpiochip_is_requested(struct gpio_chip *chip,
> @@ -109,6 +143,9 @@ extern int __must_check gpiochip_reserve(int
> start, int ngpio);
>  /* add/remove chips */
>  extern int gpiochip_add(struct gpio_chip *chip);
>  extern int __must_check gpiochip_remove(struct gpio_chip *chip);
> +extern struct gpio_chip *gpiochip_find(void *data,
> +					int (*match)(struct gpio_chip *chip,
> +						     void *data));
> 
> 
>  /* Always use the library code for GPIO management calls,
> @@ -120,9 +157,28 @@ extern void gpio_free(unsigned gpio);
>  extern int gpio_direction_input(unsigned gpio);
>  extern int gpio_direction_output(unsigned gpio, int value);
> 
> +extern int gpio_set_opendrain(unsigned gpio, int value);
> +
>  extern int gpio_get_value_cansleep(unsigned gpio);
>  extern void gpio_set_value_cansleep(unsigned gpio, int value);
> 
> +/*
> + * Handling of gpio groups
> + */
> +extern struct gpio_group* gpio_group_request(unsigned *gpio, int ngpios,
> +    const char *label);
> +extern void gpio_group_free(struct gpio_group* group);
> +
> +extern int gpio_group_direction_input(const struct gpio_group *group);
> +extern int gpio_group_direction_output(const struct gpio_group
> *group, u32 value);
> +
> +extern u32 gpio_group_get_raw_cansleep(const struct gpio_group *group);
> +extern void gpio_group_set_raw_cansleep(const struct gpio_group
> *group, u32 value);
> +
> +extern int gpio_group_set_opendrain(struct gpio_group* group, u32 value);
> +
> +u32 gpio_group_raw_to_value(const struct gpio_group *group, u32 raw);
> +u32 gpio_group_value_to_raw(const struct gpio_group *group, u32 value);
> 
>  /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
>   * the GPIO is constant and refers to some always-present controller,
> @@ -135,6 +191,11 @@ extern int __gpio_cansleep(unsigned gpio);
> 
>  extern int __gpio_to_irq(unsigned gpio);
> 
> +extern u32 gpio_group_get_raw(const struct gpio_group *group);
> +extern void gpio_group_set_raw(const struct gpio_group *group, u32 value);
> +
> +extern int gpio_group_cansleep(const struct gpio_group *group);
> +
>  #ifdef CONFIG_GPIO_SYSFS
> 
>  /*
> @@ -146,6 +207,12 @@ extern int gpio_export_link(struct device *dev,
> const char *name,
>  			unsigned gpio);
>  extern void gpio_unexport(unsigned gpio);
> 
> +extern int gpio_group_export(struct gpio_group *group,
> +    bool direction_may_change);
> +extern int gpio_group_export_link(struct device *dev, const char *name,
> +    struct gpio_group *group);
> +extern void gpio_group_unexport(struct gpio_group *group);
> +
>  #endif	/* CONFIG_GPIO_SYSFS */
> 
>  #else	/* !CONFIG_HAVE_GPIO_LIB */
> diff --git a/include/linux/gpio-export.h b/include/linux/gpio-export.h
> new file mode 100644
> index 0000000..712e9ff
> --- /dev/null
> +++ b/include/linux/gpio-export.h
> @@ -0,0 +1,64 @@
> +/*    Structures for passing gpio settings to drivers/gpio/gpio-export.c
> + *    201103 steene99
> + */
> +#ifndef __LINUX_GPIO_EXPORT_H
> +#define __LINUX_GPIO_EXPORT_H
> +
> +enum gpio_direction
> +{
> +	GPIO_INPUT,
> +	GPIO_OUTPUT,
> +	GPIO_CHANGE,
> +	GPIO_OUTPUT_KEEP,
> +};
> +
> +struct mp_gpio_line
> +{
> +	int gpio_num;
> +	int active_low;
> +	int open_drain;
> +};
> +
> +#define GPIO_PIN(_nr, _active_low, _open_drain) \
> +{ \
> +	.gpio_num = _nr, \
> +	.active_low = _active_low, \
> +	.open_drain = _open_drain, \
> +}
> +
> +#define SIMPLE_GPIO_PIN(_name, _nr) \
> +static struct mp_gpio_line _name[] = \
> +{ \
> +	GPIO_PIN(_nr, 0, 0), \
> +}
> +
> +#define MAX_GPIO_LABEL_SIZE 32
> +
> +struct mp_gpio_platform_data
> +{
> +	int gpio_count;
> +	enum gpio_direction direction;
> +	u32 initialvalue;  // value
> +	struct mp_gpio_line *gpio_data;
> +	char desc[MAX_GPIO_LABEL_SIZE];
> +};
> +
> +#define DEFINE_GPIO_GROUP(_name, _count, _direction, _initial, _pin, _desc) \
> +	static struct mp_gpio_platform_data _name = { \
> +		.gpio_count = _count, \
> +		.direction = _direction, \
> +		.initialvalue = _initial, \
> +		.gpio_data = _pin, \
> +		.desc=_desc, \
> +	}
> +
> +#define GPIO_PDEV(_id, _pdata) \
> +{ \
> +	.name = "gpio-export", \
> +	.id = _id, \
> +	.dev = { \
> +		.platform_data = &_pdata, \
> +	}, \
> +}
> +
> +#endif //__LINUX_GPIO_EXPORT_H
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 059bd18..f82edad 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -13,6 +13,7 @@
>  #include <linux/errno.h>
> 
>  struct device;
> +struct gpio_chip;
> 
>  /*
>   * Some platforms don't support the GPIO programming interface.
> @@ -33,6 +34,11 @@ static inline int gpio_request(unsigned gpio, const
> char *label)
>  	return -ENOSYS;
>  }
> 
> +static inline int gpio_group_request(unsigned *gpios, int ngpios,
> const char *label)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
> +
>  static inline void gpio_free(unsigned gpio)
>  {
>  	might_sleep();
> @@ -41,16 +47,32 @@ static inline void gpio_free(unsigned gpio)
>  	WARN_ON(1);
>  }
> 
> +static inline void gpio_group_free(struct gpio_group *group)
> +{
> +	might_sleep();
> +	WARN_ON(1);
> +}
> +
>  static inline int gpio_direction_input(unsigned gpio)
>  {
>  	return -ENOSYS;
>  }
> 
> +static inline int gpio_group_direction_input(const struct gpio_group *group)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int gpio_direction_output(unsigned gpio, int value)
>  {
>  	return -ENOSYS;
>  }
> 
> +static inline int gpio_group_direction_output(const struct gpio_group
> *group, u32 value)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int gpio_get_value(unsigned gpio)
>  {
>  	/* GPIO can never have been requested or set as {in,out}put */
> @@ -58,12 +80,29 @@ static inline int gpio_get_value(unsigned gpio)
>  	return 0;
>  }
> 
> +static inline int gpio_group_get_raw(const struct gpio_group *group)
> +{
> +	WARN_ON(1);
> +	return 0;
> +}
> +
>  static inline void gpio_set_value(unsigned gpio, int value)
>  {
>  	/* GPIO can never have been requested or set as output */
>  	WARN_ON(1);
>  }
> 
> +static inline void gpio_group_set_raw(const struct gpio_group *group,
> u32 value)
> +{
> +	WARN_ON(1);
> +}
> +
> +static inline int gpio_set_opendrain(unsigned gpio, int value)
> +{
> +	WARN_ON(1);
> +	return -ENOSYS;
> +}
> +
>  static inline int gpio_cansleep(unsigned gpio)
>  {
>  	/* GPIO can never have been requested or set as {in,out}put */
> @@ -71,6 +110,12 @@ static inline int gpio_cansleep(unsigned gpio)
>  	return 0;
>  }
> 
> +static inline int gpio_group_cansleep(const struct gpio_group *group)
> +{
> +	WARN_ON(1);
> +	return 0;
> +}
> +
>  static inline int gpio_get_value_cansleep(unsigned gpio)
>  {
>  	/* GPIO can never have been requested or set as {in,out}put */
> @@ -78,12 +123,23 @@ static inline int gpio_get_value_cansleep(unsigned gpio)
>  	return 0;
>  }
> 
> +static inline int gpio_group_get_raw_cansleep(const struct gpio_group *group)
> +{
> +	WARN_ON(1);
> +	return 0;
> +}
> +
>  static inline void gpio_set_value_cansleep(unsigned gpio, int value)
>  {
>  	/* GPIO can never have been requested or set as output */
>  	WARN_ON(1);
>  }
> 
> +static inline void gpio_group_set_raw_cansleep(const struct
> gpio_group *group, u32 value)
> +{
> +	WARN_ON(1);
> +}
> +
>  static inline int gpio_export(unsigned gpio, bool direction_may_change)
>  {
>  	/* GPIO can never have been requested or set as {in,out}put */
> @@ -91,6 +147,12 @@ static inline int gpio_export(unsigned gpio, bool
> direction_may_change)
>  	return -EINVAL;
>  }
> 
> +static inline int gpio_group_export(struct gpio_group *group, bool
> direction_may_change)
> +{
> +	WARN_ON(1);
> +	return -EINVAL;
> +}
> +
>  static inline int gpio_export_link(struct device *dev, const char *name,
>  				unsigned gpio)
>  {
> @@ -99,6 +161,12 @@ static inline int gpio_export_link(struct device
> *dev, const char *name,
>  	return -EINVAL;
>  }
> 
> +static inline int gpio_group_export_link(struct device *dev, const char *name,
> +    struct gpio_group *group)
> +{
> +	WARN_ON(1);
> +	return -EINVAL;
> +}
> 
>  static inline void gpio_unexport(unsigned gpio)
>  {
> @@ -106,6 +174,11 @@ static inline void gpio_unexport(unsigned gpio)
>  	WARN_ON(1);
>  }
> 
> +static inline void gpio_group_unexport(struct gpio_group *group)
> +{
> +	WARN_ON(1);
> +}
> +
>  static inline int gpio_to_irq(unsigned gpio)
>  {
>  	/* GPIO can never have been requested or set as input */
> @@ -122,4 +195,14 @@ static inline int irq_to_gpio(unsigned irq)
> 
>  #endif
> 
> +static inline int gpio_direction_output_keep(int gpio)
> +{
> +	return gpio_direction_output(gpio, gpio_get_value_cansleep(gpio));
> +}
> +
> +static inline int gpio_group_direction_output_keep(const struct
> gpio_group *group)
> +{
> +	return gpio_group_direction_output(group, gpio_group_get_raw_cansleep(group));
> +}
> +
>  #endif /* __LINUX_GPIO_H */
> -- 
> 1.7.5.4

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
