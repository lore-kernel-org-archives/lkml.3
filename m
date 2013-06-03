Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab3FCB7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 21:59:35 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43666 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3FCB72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 21:59:28 -0400
Message-ID: <51ABF879.1090509@gmail.com>
Date: Mon, 03 Jun 2013 11:59:21 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@intel.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v1.1] gpiolib: append SFI helpers for GPIO API
References: <CACRpkdZbCytqaWTK7HvfU2aMpPQVZWX2uf-NXL-rUPGJ6DQ-mQ@mail.gmail.com> <1369992439-5421-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1369992439-5421-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/13 19:27, Andy Shevchenko wrote:
> To support some (legacy) firmwares and platforms let's make life easier for
> their customers.
> 
> This patch extracts SFI GPIO API from arch/x86/platform/mrst/mrst.c.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Len Brown <len.brown@intel.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> ---
> Since v1:
>  - address Linus' comments: self-descriptive error codes, removal of __init in
>    header, better title in c-file.

Hi Andy,

Some trivial coding style comment below.

~Ryan

> 
>  drivers/gpio/Kconfig       |  4 +++
>  drivers/gpio/Makefile      |  1 +
>  drivers/gpio/gpiolib-sfi.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/sfi/sfi_core.c     |  7 +++++
>  include/linux/sfi_gpio.h   | 27 ++++++++++++++++
>  5 files changed, 115 insertions(+)
>  create mode 100644 drivers/gpio/gpiolib-sfi.c
>  create mode 100644 include/linux/sfi_gpio.h
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index f471fe8..a615d47 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -51,6 +51,10 @@ config OF_GPIO
>  	def_bool y
>  	depends on OF
>  
> +config GPIO_SFI
> +	def_bool y
> +	depends on SFI
> +
>  config GPIO_ACPI
>  	def_bool y
>  	depends on ACPI
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 0cb2d65..63d2abd 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -5,6 +5,7 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
>  obj-$(CONFIG_GPIO_DEVRES)	+= devres.o
>  obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
>  obj-$(CONFIG_OF_GPIO)		+= gpiolib-of.o
> +obj-$(CONFIG_GPIO_SFI)		+= gpiolib-sfi.o
>  obj-$(CONFIG_GPIO_ACPI)		+= gpiolib-acpi.o
>  
>  # Device drivers. Generally keep list sorted alphabetically
> diff --git a/drivers/gpio/gpiolib-sfi.c b/drivers/gpio/gpiolib-sfi.c
> new file mode 100644
> index 0000000..cccdc0f
> --- /dev/null
> +++ b/drivers/gpio/gpiolib-sfi.c
> @@ -0,0 +1,76 @@
> +/*
> + * Simple Firmware Interface (SFI) helpers for GPIO API
> + *
> + * Copyright (C) 2013, Intel Corporation
> + * Author: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> + *
> + * Based on work done for Intel MID platforms (mrst.c)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#define pr_fmt(fmt) "SFI: GPIO: " fmt
> +
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +#include <linux/export.h>
> +#include <linux/sfi_gpio.h>
> +#include <linux/sfi.h>
> +
> +static struct sfi_gpio_table_entry *sfi_gpio_table;
> +static int sfi_gpio_num_entry;
> +
> +int sfi_get_gpio_by_name(const char *name)
> +{
> +	struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
> +	int i;
> +
> +	if (!pentry)
> +		return -EINVAL;
> +
> +	for (i = 0; i < sfi_gpio_num_entry; i++, pentry++) {
> +		if (!strncmp(name, pentry->pin_name, SFI_NAME_LEN))
> +			return pentry->pin_no;
> +	}

Nitpick - Don't need the braces on the for loop.

> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(sfi_get_gpio_by_name);
> +
> +static int __init sfi_gpio_parse(struct sfi_table_header *table)
> +{
> +	struct sfi_table_simple *sb = (struct sfi_table_simple *)table;

Using container_of is preferable to casting:

	sb = container_of(table, struct sfi_table_simple, header);

> +	struct sfi_gpio_table_entry *pentry;
> +	int num, i;
> +
> +	if (sfi_gpio_table)
> +		return 0;
> +
> +	num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
> +	pentry = (struct sfi_gpio_table_entry *)sb->pentry;
> +
> +	sfi_gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);

Use kcalloc when you have a size and a count.

> +	if (!sfi_gpio_table)
> +		return -ENOMEM;
> +
> +	memcpy(sfi_gpio_table, pentry, num * sizeof(*pentry));
> +	sfi_gpio_num_entry = num;
> +
> +	pr_debug("Pin info:\n");
> +	for (i = 0; i < num; i++, pentry++)
> +		pr_debug("[%2d] chip = %16.16s, name = %16.16s, pin=%d\n", i,
> +			 pentry->controller_name, pentry->pin_name,
> +			 pentry->pin_no);

Why "%16.16s" here? "%16s" will right justify with leading spaces, or
"%-16s" will left justify with trailing spaces.

> +
> +	return 0;
> +}
> +
> +int __init sfi_gpio_init(void)
> +{
> +	return sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_gpio_parse);
> +}
> diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
> index 296db7a..2828da0 100644
> --- a/drivers/sfi/sfi_core.c
> +++ b/drivers/sfi/sfi_core.c
> @@ -67,6 +67,7 @@
>  #include <linux/acpi.h>
>  #include <linux/init.h>
>  #include <linux/sfi.h>
> +#include <linux/sfi_gpio.h>
>  #include <linux/slab.h>
>  
>  #include "sfi_core.h"
> @@ -512,6 +513,12 @@ void __init sfi_init_late(void)
>  	syst_va = sfi_map_memory(syst_pa, length);
>  
>  	sfi_acpi_init();
> +
> +	/*
> +	 * Parsing GPIO table first, since the DEVS table will need this table
> +	 * to map the pin name to the actual pin.
> +	 */
> +	sfi_gpio_init();
>  }
>  
>  /*
> diff --git a/include/linux/sfi_gpio.h b/include/linux/sfi_gpio.h
> new file mode 100644
> index 0000000..02ae6df
> --- /dev/null
> +++ b/include/linux/sfi_gpio.h
> @@ -0,0 +1,27 @@
> +#ifndef _LINUX_SFI_GPIO_H_
> +#define _LINUX_SFI_GPIO_H_
> +
> +#include <linux/errno.h>
> +#include <linux/gpio.h>
> +#include <linux/sfi.h>
> +
> +#ifdef CONFIG_GPIO_SFI
> +
> +int sfi_get_gpio_by_name(const char *name);
> +int sfi_gpio_init(void);
> +
> +#else /* CONFIG_GPIO_SFI */
> +
> +static inline int sfi_get_gpio_by_name(const char *name);
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int sfi_gpio_init(void)
> +{
> +	return -ENODEV;
> +}
> +
> +#endif /* CONFIG_GPIO_SFI */
> +
> +#endif /* _LINUX_SFI_GPIO_H_ */
> 

