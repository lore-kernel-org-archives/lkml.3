Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3KFXef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:34:35 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64875 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3KFXec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:34:32 -0500
Date: Wed, 6 Nov 2013 23:34:27 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Heiko Stuebner <heiko@sntech.de>,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH 1/1] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20131106233427.GA6090@maple>
References: <1383778182-16941-1-git-send-email-delicious.quinoa@gmail.com>
 <1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Nov 06, 2013 at 04:49:42PM -0600, Alan Tull wrote:
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> new file mode 100644
> index 0000000..7957dfd
> --- /dev/null
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -0,0 +1,458 @@
> +/*
> + * Copyright (c) 2011 Jamie Iles
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * All enquiries to support@picochip.com
> + */
> +#include <linux/basic_mmio_gpio.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +
> +#define GPIO_SWPORTA_DR		0x00
> +#define GPIO_SWPORTA_DDR	0x04
> +#define GPIO_SWPORTB_DR		0x0c
> +#define GPIO_SWPORTB_DDR	0x10
> +#define GPIO_SWPORTC_DR		0x18
> +#define GPIO_SWPORTC_DDR	0x1c
> +#define GPIO_SWPORTD_DR		0x24
> +#define GPIO_SWPORTD_DDR	0x28
> +#define GPIO_INTEN		0x30
> +#define GPIO_INTMASK		0x34
> +#define GPIO_INTTYPE_LEVEL	0x38
> +#define GPIO_INT_POLARITY	0x3c
> +#define GPIO_INTSTATUS		0x40
> +#define GPIO_PORTA_EOI		0x4c
> +#define GPIO_EXT_PORTA		0x50
> +#define GPIO_EXT_PORTB		0x54
> +#define GPIO_EXT_PORTC		0x58
> +#define GPIO_EXT_PORTD		0x5c
> +
> +struct dwapb_gpio;
> +
> +struct dwapb_gpio_port {
> +	struct bgpio_chip	bgc;
> +	bool			is_registered;
> +	struct dwapb_gpio	*gpio;
> +};
> +
> +struct dwapb_gpio {
> +	struct	device		*dev;
> +	void __iomem		*regs;
> +	struct dwapb_gpio_port	*ports;
> +	unsigned int		nr_ports;
> +	struct irq_domain	*domain;
> +	int			hwirq;

I'm not sure I fully understand what hwirq is in this context - is it 
the IRQ line from the Synopsys block to the system interrupt controller?  
If so I don't think this covers all configurations - the Picochip 
devices for instance have each GPIO in port A as an individual IRQ going 
to the VIC.

It looks here like hwirq is used for all of the interrupt registers so 
only one GPIO interrupt is supported?

> +static struct platform_driver dwapb_gpio_driver = {
> +	.driver		= {
> +		.name	= "gpio-dwapb",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(dwapb_of_match),
> +	},
> +	.probe		= dwapb_gpio_probe,
> +	.remove		= dwapb_gpio_remove,
> +};
> +
> +static int __init dwapb_gpio_init(void)
> +{
> +	return platform_driver_register(&dwapb_gpio_driver);
> +}
> +postcore_initcall(dwapb_gpio_init);
> +
> +static void __exit dwapb_gpio_exit(void)
> +{
> +	platform_driver_unregister(&dwapb_gpio_driver);
> +}
> +module_exit(dwapb_gpio_exit);

We can replace the registration and unregistration with 
module_platform_driver() now.

Jamie
