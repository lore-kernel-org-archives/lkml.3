Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaGWPyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:54:18 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64453 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaGWPyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:54:16 -0400
Message-ID: <53CFDA9F.2010406@gmail.com>
Date: Wed, 23 Jul 2014 21:24:07 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>, santosh.shilimkar@ti.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
CC: ivan.khoronzhuk@ti.com, m-karicheri2@ti.com,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpio: keystone: add dsp gpio controller driver
References: <1406126699-10053-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1406126699-10053-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 23 July 2014 08:14 PM, Grygorii Strashko wrote:

(...)

> +
> +Required Properties:
> +- compatible: should be "ti,keystone-dsp-gpio"
> +
> +- ti,syscon-dev : phandle/offset pair. The phandle to syscon used to
> +				  access device state control registers and the offset
> +				  in order to use block of device's specific registers.
> +
> +- gpio-controller : Marks the device node as a gpio controller.
> +
> +- #gpio-cells : Should be one.
> +				See gpio.txt in this directory for a of the cells format
> +

proper indentation for all the properties...

> +Please refer to gpio.txt in this directory for details of the common GPIO
> +bindings used by client devices.
> +
> +Example:
> +	dspgpio0: keystone_dsp_gpio@02620240 {
> +		compatible = "ti,keystone-dsp-gpio";
> +		ti,syscon-dev = <&devctrl 0x240>;
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +	};
> +
> +	dsp0: dsp0 {
> +		compatible = "linux,rproc-user";
> +		...
> +		kick-gpio = <&dspgpio0 27>;
> +	};
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 4a1b511..990871f 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -158,6 +158,14 @@ config GPIO_EP93XX
>   	depends on ARCH_EP93XX
>   	select GPIO_GENERIC
>   
> +config GPIO_KEYSTONE_DSP
> +	tristate "Keystone DSP GPIO support"
> +	depends on ARCH_KEYSTONE
> +	help
> +	  Say yes here to support the DSP GPIO driver for Keystone 2. This defines
> +	  up to 28 GPIOs per each Remote (DSP) core. This is used to send
> +	  signals from ARM to the Remote (DSP) core.
> +
>   config GPIO_ZEVIO
>   	bool "LSI ZEVIO SoC memory mapped GPIOs"
>   	depends on ARM && OF_GPIO
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index d10f6a9..15c3389 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_GPIO_IOP)		+= gpio-iop.o
>   obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
>   obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
>   obj-$(CONFIG_GPIO_KEMPLD)	+= gpio-kempld.o
> +obj-$(CONFIG_GPIO_KEYSTONE_DSP)	+= gpio-keystone.o
>   obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
>   obj-$(CONFIG_GPIO_INTEL_MID)	+= gpio-intel-mid.o
>   obj-$(CONFIG_GPIO_LP3943)	+= gpio-lp3943.o
> diff --git a/drivers/gpio/gpio-keystone.c b/drivers/gpio/gpio-keystone.c
> new file mode 100644
> index 0000000..7909a1c
> --- /dev/null
> +++ b/drivers/gpio/gpio-keystone.c
> @@ -0,0 +1,138 @@
> +/*
> + * Keystone 2 DSP GPIO support.
> + *
> + * Copyright (C) 2014 Texas Instruments, Inc.
> + * Author: Murali Karicheri <m-karicheri2@ti.com>
> + *	   Grygorii Strashko <grygorii.strashko@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +#include <linux/gpio.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +

includes in alphabetical order..

> +/* 28 bits in IPCGRx are treated as GPIO pins to generate interrupt */
> +#define GPIOS_PER_BANK		28
> +#define GPIO_OFFSET		4
> +
> +struct keystone_gpio_bank {
> +	struct gpio_chip	 chip;
> +	struct device		*dev;
> +	struct regmap		*devctrl_regs;
> +	u32			devctrl_offset;
> +};
> +#define chip_to_bank(c) \
> +	container_of(c, struct keystone_gpio_bank, chip)
> +
> +static int keystone_gpio_direction_out(struct gpio_chip *c,
> +					unsigned ofs, int val)
> +{
> +	return 0;
> +}
> +
> +static int keystone_gpio_get(struct gpio_chip *c, unsigned ofs)
> +{
> +	struct keystone_gpio_bank *bank = chip_to_bank(c);
> +	int bit = ofs + GPIO_OFFSET;
> +	int ret;
> +	u32 val = 0;
> +
> +	ret = regmap_read(bank->devctrl_regs, bank->devctrl_offset, &val);
> +	if (ret < 0)
> +		dev_dbg(bank->dev, "gpio read failed ret(%d)\n", ret);

If this read fails what will happen...?

we will get the debug message and return (val >> bit) & 1, But this val can be garbage or zero...?

> +
> +	return (val >> bit) & 1;
> +}

-- 
-Varka Bhadram

