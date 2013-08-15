Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3HOJx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:53:29 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45458 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3HOJxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:53:25 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] RFC: interrupt consistency check for OF GPIO IRQs
Date: Thu, 15 Aug 2013 11:53:15 +0200
Message-ID: <1955836.AOXICuVgjP@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.6-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1425505.kMVyfscuVS"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1425505.kMVyfscuVS
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Lars, Linus,

On Tuesday 13 of August 2013 11:46:35 Lars Poeschel wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Currently the kernel is ambigously treating GPIOs and interrupts
> from a GPIO controller: GPIOs and interrupts are treated as
> orthogonal. This unfortunately makes it unclear how to actually
> retrieve and request a GPIO line or interrupt from a GPIO
> controller in the device tree probe path.
> 
> In the non-DT probe path it is clear that the GPIO number has to
> be passed to the consuming device, and if it is to be used as
> an interrupt, the consumer shall performa a gpio_to_irq() mapping
> and request the resulting IRQ number.
> 
> In the DT boot path consumers may have been given one or more
> interrupts from the interrupt-controller side of the GPIO chip
> in an abstract way, such that the driver is not aware of the
> fact that a GPIO chip is backing this interrupt, and the GPIO
> side of the same line is never requested with gpio_request().
> A typical case for this is ethernet chips which just take some
> interrupt line which may be a "hard" interrupt line (such as an
> external interrupt line from an SoC) or a cascaded interrupt
> connected to a GPIO line.
> 
> This has the following undesired effects:
> 
> - The GPIOlib subsystem is not aware that the line is in use
>   and willingly lets some other consumer perform gpio_request()
>   on it, leading to a complex resource conflict if it occurs.
> 
> - The GPIO debugfs file claims this GPIO line is "free".
> 
> - The line direction of the interrupt GPIO line is not
>   explicitly set as input, even though it is obvious that such
>   a line need to be set up in this way, often making the system
>   depend on boot-on defaults for this kind of settings.
> 
> To solve this dilemma, perform an interrupt consistency check
> when adding a GPIO chip: if the chip is both gpio-controller and
> interrupt-controller, walk all children of the device tree,
> check if these in turn reference the interrupt-controller, and
> if they do, loop over the interrupts used by that child and
> perform gpio_reques() and gpio_direction_input() on these,
> making them unreachable from the GPIO side.

The idea is rather interesting, but there are some problems I commented on 
inline. (Feel free to ignore those that are nits, since this is at RFC 
stage.)

> Cc: devicetree@vger.kernel.org
> Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Jon Hunter <jgchunter@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> 
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index 665f953..5f6ac79 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -10,7 +10,6 @@
>   * the Free Software Foundation; either version 2 of the License, or
>   * (at your option) any later version.
>   */
> -
>  #include <linux/device.h>
>  #include <linux/errno.h>
>  #include <linux/module.h>
> @@ -19,6 +18,7 @@
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/of_gpio.h>
> +#include <linux/of_irq.h>
>  #include <linux/pinctrl/pinctrl.h>
>  #include <linux/slab.h>
> 
> @@ -127,6 +127,160 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
>  EXPORT_SYMBOL(of_gpio_simple_xlate);
> 
>  /**
> + * of_gpio_scan_nodes_and_x_irq_lines - internal function to

Hmm, what is an "x irq line"?

> recursively scan + * the device tree and request or free the GPIOs that
> are to be use + * @node:	node to start the scanning at
> + * @gcn:	device node of the GPIO chip
> + * @gc:		GPIO chip instantiated from same node
> + * @request:	wheter the function should request(1) or free(0) the irq
> lines + *
> + * This is a internal function that calls itself to recursively scan
> the device + * tree. It scans for uses of the device_node gcn as an
> interrupt-controller. + * If it finds some, it requests the
> corresponding gpio lines that are to be + * used as irq lines and sets
> them as input.
> + * If the request parameter is 0 it frees the gpio lines.
> + * For more information see documentation of of_gpiochip_x_irq_lines
> function. + */
> +void of_gpio_scan_nodes_and_x_irq_lines(
> +		const struct device_node *const node,
> +		struct device_node * const gcn,
> +		const struct gpio_chip * const gc, int const request)
> +{
> +	struct device_node *child;
> +	struct device_node *irq_parent;
> +	const __be32 *intspec;
> +	u32 intlen;
> +	u32 offset;
> +	int ret;
> +	int num_irq;
> +	int i;
> +
> +	if (node == NULL)
> +		return;
> +
> +	for_each_child_of_node(node, child) {
> +		of_gpio_scan_nodes_and_x_irq_lines(child, gcn, gc, 
request);

nit: A blank line would be nice here.

> +		/* Check if we have an IRQ parent, else continue */
> +		irq_parent = of_irq_find_parent(child);
> +		if (!irq_parent)
> +			continue;

You can probably put the irq_parent node here to not duplicate calls in 
both code paths below.

> +		/* Is it so that this very GPIO chip is the parent? */
> +		if (irq_parent != gcn) {
> +			of_node_put(irq_parent);
> +			continue;
> +		}
> +		of_node_put(irq_parent);
> +
> +		pr_debug("gpiochip OF: node %s references GPIO interrupt 
lines\n",
> +				child->name);
> +
> +		/* Get the interrupts property */
> +		intspec = of_get_property(child, "interrupts", &intlen);
> +		if (intspec == NULL)
> +			continue;
> +		intlen /= sizeof(*intspec);
> +
> +		num_irq = of_irq_count(gcn);
> +		for (i = 0; i < num_irq; i++) {
> +			/*
> +			 * The first cell is always the local IRQ number, 
and
> +			 * this corresponds to the GPIO line offset for a 
GPIO
> +			 * chip.
> +			 *
> +			 * FIXME: take interrupt-cells into account here.

This is the biggest problem of this patch. It assumes that there is only a 
single and shared GPIO/interrupt specification scheme, which might not be 
true.

First of all, almost all interrupt bindings have an extra, semi-generic 
flags field as last cell in the specifier. Now there can be more than one 
cell used to index GPIOs and interrupts, for example:

	interrupts = <1 3 8>

which could mean: bank 1, pin 3, low level triggered.

I think you may need to reuse a lot of the code that normally parses the 
interrupts property, i.e. the irq_of_parse_and_map() path, which will then 
give you the hwirq index inside your irq chip, which may (or may not) be 
the same as the GPIO offset inside your GPIO chip.

If you're unlucky enough to spot a controller that uses completely 
different numbering schemes for GPIOs and interrupts, then you're probably 
screwed, because only the driver for this controller can know the mapping 
between them.

I don't have any good ideas for doing this properly at the moment, but I 
will think about it and post another reply if something nice comes to my 
mind.

> +			 */
> +			offset = of_read_number(intspec + i, 1);

nit: of_read_number is a little overkill for simply getting a single cell. 
You could use be32_to_cpup(intspec + i) to achieve the same.

> +			pr_debug("gpiochip: OF node references 
offset=%d\n",
> +				 offset);
> +
> +			if (request) {
> +				/*
> +				 * This child is making a reference to 
this
> +				 * chip through the interrupts property, 
so
> +				 * reserve these GPIO lines and set them 
as
> +				 * input.
> +				 */
> +				ret = gpio_request(gc->base + offset, "OF 
IRQ");
> +				if (ret)
> +					pr_err("gpiolib OF: could not 
request IRQ GPIO %d (%d)\n",
> +					       gc->base + offset, offset);

Would some kind of error handling be a bad idea here? Like, for example, 
marking this IRQ as invalid or something among these lines.

> +				ret = gpio_direction_input(gc->base + 
offset);
> +				if (ret)
> +					pr_err("gpiolib OF: could not set 
IRQ GPIO %d (%d) as input\n",
> +					       gc->base + offset, offset);

I'm not sure if this is the correct action if someone already requested 
the GPIO before and probably already set it up with their own set of 
parameters (not necessarily the same as enforced by calling 
gpio_direction_input()).

> +			} else {
> +				gpio_free(gc->base + offset);

What if the request failed? This would mean calling gpio_free() on a GPIO 
previously requested by someone else.

> +			}
> +		}
> +	}
> +}
> +
> +#define of_gpiochip_request_irq_lines(np, gc) \
> +	of_gpiochip_x_irq_lines(np, gc, 1)
> +
> +#define of_gpiochip_free_irq_lines(np, gc) \
> +	of_gpiochip_x_irq_lines(np, gc, 0)

Aha, so the x is a wildcard. Fine, although it makes the code slightly 
less reader-friendly IMHO.

Best regards,
Tomasz

--nextPart1425505.kMVyfscuVS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABAgAGBQJSDKUOAAoJEIv3Hb8G/XrulzIQALY5Ee/CildSJmwKY188cXz8
IL+M9lojsACo95ScYDzwONMW3vcE3CAQmMynSM79oeRF3qtwRBduCpqye65psncK
qZSLM8Fv1XKY6o7ZCt/3AmWa0E5BLII1AiAAx5/CJuzBTwc+6HSzNY4KX9nCEwhU
xAdIIfLwiMB7qe9JkPpz79RVGjl0hTKc+qvaUFbuaEDOeLhF2fXC+rCSpGlbXN9m
QGjgGTDGD9oOqSx1oCC82H6x0S6pHBOImOrBjYIGgHPuQwD66owX4KZcVjkd30yg
ZYYCicsZCrI17lvUC29Er+grE8mcwrvAKE2b67O5GYJ7YbtJRfjo0oomxvmX8fUi
d1HjIHYkGNgcw/VTSUSG+rh6FVXxVxQsARKtOPKjCSXmFCtigClWiFWV864W6Rjv
5vOJal4AgrbpVgqItp0z3q63jK5UaFsn+kUJVpF+kjoN0TXRh6IAuaIzywwZSb0x
Jdr/2mlgj+YGYHw+jmz1JFt2CLXEhippuQ4uagc/hlm9aWH0/swwSK5hHcWaxDBY
UcRDJJ1DBi6IUwLV9ShddW0T/c7FiFg043aDkDFSipdBIQFW1z7EKca04xDVZv0t
vJCMFNn0qD3wjmCOSskqPHoX+vwQsAFE18Xoqcu4LpWpCpCIhoj8m07aWXsnvRUh
sGRKPXRG6UwtUEZF937y
=uIsa
-----END PGP SIGNATURE-----

--nextPart1425505.kMVyfscuVS--

