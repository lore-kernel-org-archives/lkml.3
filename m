Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3HUSpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:45:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38833 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3HUSpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:45:49 -0400
Message-ID: <52150AD9.3040808@wwwdotorg.org>
Date: Wed, 21 Aug 2013 12:45:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO controller
 on bf54x and bf60x.
References: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
In-Reply-To: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 12:30 AM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> The new ADI GPIO2 controller was introduced since the BF548 and BF60x
> processors. It differs a lot from the old one on BF5xx processors. So,
> create a pinctrl driver under the pinctrl framework.

>  drivers/pinctrl/Kconfig                    |   17 +
>  drivers/pinctrl/Makefile                   |    3 +
>  drivers/pinctrl/pinctrl-adi2-bf54x.c       |  572 +++++++++++
>  drivers/pinctrl/pinctrl-adi2-bf60x.c       |  454 +++++++++

Those files look reasonable.

>  drivers/pinctrl/pinctrl-adi2.c             | 1501 ++++++++++++++++++++++++++++
>  drivers/pinctrl/pinctrl-adi2.h             |   75 ++
>  include/linux/platform_data/pinctrl-adi2.h |   40 +

> diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c

> +/**
> + * struct gpio_reserve_map - a GPIO map structure containing the
> + * reservation status of each PIN.
> + *
> + * @owner: who request the reservation
> + * @rsv_gpio: if this pin is reserved as GPIO
> + * @rsv_int: if this pin is reserved as interrupt
> + * @rsv_peri: if this pin is reserved as part of a peripheral device
> + */
> +struct gpio_reserve_map {
> +	unsigned char owner[RESOURCE_LABEL_SIZE];
> +	bool rsv_gpio;
> +	bool rsv_int;
> +	bool rsv_peri;
> +};

Why is that needed; don't the pinctrl/GPIO cores already know which
pinctrl pins and which GPIOs are used, and for what?

> +#if defined(CONFIG_DEBUG_FS)
> +static inline unsigned short get_gpio_dir(struct gpio_port *port,
> ...

Why aren't the existing GPIO/pinctrl subsystem debugfs files enough?

> +static int adi_pinmux_request(struct pinctrl_dev *pctldev, unsigned pin)
...
> +	/* If a pin can be muxed as either GPIO or peripheral, make
> +	 * sure it is not already a GPIO pin when we request it.
> +	 */
> +	if (port->rsvmap[offset].rsv_gpio) {
> +		if (system_state == SYSTEM_BOOTING)
> +			dump_stack();
> +		dev_err(pctldev->dev,
> +		       "%s: Peripheral PIN %d is already reserved as GPIO by %s!\n",
> +		       __func__, pin, get_label(port, offset));
> +		spin_unlock_irqrestore(&port->lock, flags);
> +		return -EBUSY;
> +	}

Yes, this definitely warrants some more explanation. It looks odd. What
is "system_state"?

> +static int adi_gpio_probe(struct platform_device *pdev)
...
> +	/* Add gpio pin range */
> +	snprintf(pinctrl_devname, RESOURCE_LABEL_SIZE, "pinctrl-adi2.%d",
> +		pdata->pinctrl_id);
> +	pinctrl_devname[RESOURCE_LABEL_SIZE - 1] = 0;
> +	ret = gpiochip_add_pin_range(&port->chip, pinctrl_devname,
> +		0, pdata->port_pin_base, port->width);

This looks like platform data is providing the GPIO <-> pinctrl pin ID
mapping, or at least part of it. Surely that mapping is fixed by the HW
design, and hence isn't something platform data should influence. Do the
files pinctrl-adi2-bf*.c not contain complete information about each HW
configuration for some reason?

> +static struct platform_driver adi_pinctrl_driver = {
> +	.probe		= adi_pinctrl_probe,
> +	.remove		= adi_pinctrl_remove,
> +	.driver		= {
> +		.name	= DRIVER_NAME,
> +	},
> +};
> +
> +static struct platform_driver adi_gpio_pint_driver = {
> +	.probe		= adi_gpio_pint_probe,
> +	.remove		= adi_gpio_pint_remove,
> +	.driver		= {
> +		.name	= "adi-gpio-pint",
> +	},
> +};
> +
> +static struct platform_driver adi_gpio_driver = {
> +	.probe		= adi_gpio_probe,
> +	.remove		= adi_gpio_remove,
> +	.driver		= {
> +		.name	= "adi-gpio",
> +	},
> +};

Hmmm. Is there one HW block that controls GPIOs and pinctrl, or are
there separate HW blocks?

If there's one HW block, why not have just one driver?

If there are separate HW blocks, then having separate GPIO and pinctrl
drivers seems like it would make sense.
