Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3HOMbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 08:31:21 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:61076 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3HOMbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 08:31:19 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, grant.likely@linaro.org,
        linus.walleij@linaro.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v2] RFC: interrupt consistency check for OF GPIO IRQs
Date: Thu, 15 Aug 2013 14:31:08 +0200
Message-ID: <5024472.WsjusA1KXL@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.6-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <201308151412.43932.poeschel@lemonage.de>
References: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de> <1955836.AOXICuVgjP@flatron> <201308151412.43932.poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6463264.is8iAGSuk6"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart6463264.is8iAGSuk6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 15 of August 2013 14:12:43 Lars Poeschel wrote:
> On Thursday 15 August 2013 at 11:53:15, Tomasz Figa wrote:
> > Hi Lars, Linus,
> > 
> > On Tuesday 13 of August 2013 11:46:35 Lars Poeschel wrote:
> > > From: Linus Walleij <linus.walleij@linaro.org>
> > > 
> > > Currently the kernel is ambigously treating GPIOs and interrupts
> > > from a GPIO controller: GPIOs and interrupts are treated as
> > > orthogonal. This unfortunately makes it unclear how to actually
> > > retrieve and request a GPIO line or interrupt from a GPIO
> > > controller in the device tree probe path.
> > > 
> > > In the non-DT probe path it is clear that the GPIO number has to
> > > be passed to the consuming device, and if it is to be used as
> > > an interrupt, the consumer shall performa a gpio_to_irq() mapping
> > > and request the resulting IRQ number.
> > > 
> > > In the DT boot path consumers may have been given one or more
> > > interrupts from the interrupt-controller side of the GPIO chip
> > > in an abstract way, such that the driver is not aware of the
> > > fact that a GPIO chip is backing this interrupt, and the GPIO
> > > side of the same line is never requested with gpio_request().
> > > A typical case for this is ethernet chips which just take some
> > > interrupt line which may be a "hard" interrupt line (such as an
> > > external interrupt line from an SoC) or a cascaded interrupt
> > > connected to a GPIO line.
> > > 
> > > This has the following undesired effects:
> > > 
> > > - The GPIOlib subsystem is not aware that the line is in use
> > > 
> > >   and willingly lets some other consumer perform gpio_request()
> > >   on it, leading to a complex resource conflict if it occurs.
> > > 
> > > - The GPIO debugfs file claims this GPIO line is "free".
> > > 
> > > - The line direction of the interrupt GPIO line is not
> > > 
> > >   explicitly set as input, even though it is obvious that such
> > >   a line need to be set up in this way, often making the system
> > >   depend on boot-on defaults for this kind of settings.
> > > 
> > > To solve this dilemma, perform an interrupt consistency check
> > > when adding a GPIO chip: if the chip is both gpio-controller and
> > > interrupt-controller, walk all children of the device tree,
> > > check if these in turn reference the interrupt-controller, and
> > > if they do, loop over the interrupts used by that child and
> > > perform gpio_reques() and gpio_direction_input() on these,
> > > making them unreachable from the GPIO side.
> > 
> > The idea is rather interesting, but there are some problems I
> > commented
> > on inline. (Feel free to ignore those that are nits, since this is at
> > RFC stage.)
> 
> I don't want to ignore. I want to discuss and test the idea here. Thanks
> for your contribution!

You're welcome.

> > >  /**
> > > 
> > > + * of_gpio_scan_nodes_and_x_irq_lines - internal function to
> > 
> > Hmm, what is an "x irq line"?
> 
> You already found out. Comment on this is below.
> 
> > > +	for_each_child_of_node(node, child) {
> > > +		of_gpio_scan_nodes_and_x_irq_lines(child, gcn, gc,
> > 
> > request);
> > 
> > nit: A blank line would be nice here.
> 
> Ok.
> 
> > > +		/* Check if we have an IRQ parent, else continue */
> > > +		irq_parent = of_irq_find_parent(child);
> > > +		if (!irq_parent)
> > > +			continue;
> > 
> > You can probably put the irq_parent node here to not duplicate calls
> > in
> > both code paths below.
> 
> I thought about that before. Is this really allowed? Would the
> inequality- check (irq_parent != gcn) after of_node_put be still valid?

Well, this is just a check over pointers. Assuming that you know that your 
GPIO chip won't go away while this code is running, you can safely compare 
the pointers as the same device tree node can't have two different 
pointers.

> > > +		/* Is it so that this very GPIO chip is the parent? */
> > > +		if (irq_parent != gcn) {
> > > +			of_node_put(irq_parent);
> > > +			continue;
> > > +		}
> > > +		of_node_put(irq_parent);
> > > +
> > > +		pr_debug("gpiochip OF: node %s references GPIO interrupt
> > 
> > lines\n",
> > 
> > > +				child->name);
> > > +
> > > +		/* Get the interrupts property */
> > > +		intspec = of_get_property(child, "interrupts", &intlen);
> > > +		if (intspec == NULL)
> > > +			continue;
> > > +		intlen /= sizeof(*intspec);
> > > +
> > > +		num_irq = of_irq_count(gcn);
> > > +		for (i = 0; i < num_irq; i++) {
> > > +			/*
> > > +			 * The first cell is always the local IRQ number,
> > 
> > and
> > 
> > > +			 * this corresponds to the GPIO line offset for a
> > 
> > GPIO
> > 
> > > +			 * chip.
> > > +			 *
> > > +			 * FIXME: take interrupt-cells into account here.
> > 
> > This is the biggest problem of this patch. It assumes that there is
> > only a single and shared GPIO/interrupt specification scheme, which
> > might not be true.
> > 
> > First of all, almost all interrupt bindings have an extra,
> > semi-generic
> > flags field as last cell in the specifier. Now there can be more than
> > 
> > one cell used to index GPIOs and interrupts, for example:
> > 	interrupts = <1 3 8>
> > 
> > which could mean: bank 1, pin 3, low level triggered.
> > 
> > I think you may need to reuse a lot of the code that normally parses
> > the interrupts property, i.e. the irq_of_parse_and_map() path, which
> > will then give you the hwirq index inside your irq chip, which may
> > (or may not) be the same as the GPIO offset inside your GPIO chip.
> 
> Ok, valid objection. This is what the FIXME is about. But this should be
> solvable. Am I right that there are 3 cases to handle:
> interrupt-cells = 1: It is the index for the gpio.
> interrupt-cells = 2: First is index for the gpio, second flags (like low
> level triggered)
> interrupt-cells = 3: First bank number, middle gpio inside that bank,
> last flags.

Well, there are basically no restrictions over the format of GPIO and 
interrupt specifiers. Any driver is free to define its own and provide 
private .xlate() callback to parse it. No assumptions should be made about 
the format, other than each GPIO/interrupt is specified by numer of cells 
specified in #interrupt- or #gpio-cells property of the controller.

> You are right, that we should try to reuse existing code for that. I
> will see, if I find the time to put up a third patch, which honors
> this.
> > If you're unlucky enough to spot a controller that uses completely
> > different numbering schemes for GPIOs and interrupts, then you're
> > probably screwed, because only the driver for this controller can know
> > the mapping between them.
> 
> Do such cases exist right now? Shouldn't be the number I request for
> interrupt in the device tree the gpio number I use with this chip ?
> Everything else would be weird.

We can't simply cover all the existing cases and say it's done. We should 
design things that are more or less future-proof.

I can imagine a single device that is both a GPIO expander and an 
interrupt controller, but has separate sets of pins, e.g. 8 dedicated 
interrupt pins and 16 separate general-purpose I/O pins. It would have 
both interrupt-controller and gpio-controller properties, but wouldn't not 
have any mapping between both namespaces at all, because both are about 
completely different entities.

> > I don't have any good ideas for doing this properly at the moment, but
> > I will think about it and post another reply if something nice comes
> > to my mind.
> 
> If we really have to take this into account, that would require an
> additional function pointer inside gpio_chip, something like
> irq_to_gpio. The driver has to implement this functions then.

Something like this could probably handle this, but I'm not sure if this 
is really necessary. Let me think about it a bit more as I think this 
could be done in a completely different way, but need to figure out all 
the details.

> > > +			 */
> > > +			offset = of_read_number(intspec + i, 1);
> > 
> > nit: of_read_number is a little overkill for simply getting a single
> > cell. You could use be32_to_cpup(intspec + i) to achieve the same.
> 
> Ok.
> 
> > > +			pr_debug("gpiochip: OF node references
> > 
> > offset=%d\n",
> > 
> > > +				 offset);
> > > +
> > > +			if (request) {
> > > +				/*
> > > +				 * This child is making a reference to
> > 
> > this
> > 
> > > +				 * chip through the interrupts property,
> > 
> > so
> > 
> > > +				 * reserve these GPIO lines and set them
> > 
> > as
> > 
> > > +				 * input.
> > > +				 */
> > > +				ret = gpio_request(gc->base + offset, "OF
> > 
> > IRQ");
> > 
> > > +				if (ret)
> > > +					pr_err("gpiolib OF: could not
> > 
> > request IRQ GPIO %d (%d)\n",
> > 
> > > +					       gc->base + offset, offset);
> > 
> > Would some kind of error handling be a bad idea here? Like, for
> > example, marking this IRQ as invalid or something among these lines.
> 
> If that fails, things are like before and someone would request an irq
> for a gpio he does not own. Again what misses here is a connection
> between gpio and irq subsystem. I could only record that this gpio pin
> failed somewhere in the gpio subsystem, but what has to fail later is
> the request for the irq inside the irq subsystem.
> Hmm....

See below.

> > > +				ret = gpio_direction_input(gc->base +
> > 
> > offset);
> > 
> > > +				if (ret)
> > > +					pr_err("gpiolib OF: could not set
> > 
> > IRQ GPIO %d (%d) as input\n",
> > 
> > > +					       gc->base + offset, offset);
> > 
> > I'm not sure if this is the correct action if someone already
> > requested
> > the GPIO before and probably already set it up with their own set of
> > parameters (not necessarily the same as enforced by calling
> > gpio_direction_input()).
> 
> That should definitely not happen! This is what this patch is for. As we
> are requesting this gpio somewhere inside the gpiochip_add process, no
> one should be able to request that gpio earlier.

Ahh, right. The pins are being requested before the GPIO chip actually 
becomes available to the consumers. So this is probably fine. Sorry for 
the noise.

> > > +			} else {
> > > +				gpio_free(gc->base + offset);
> > 
> > What if the request failed? This would mean calling gpio_free() on a
> > GPIO previously requested by someone else.
> 
> See above.

Fair enough.

> > > +			}
> > > +		}
> > > +	}
> > > +}
> > > +
> > > +#define of_gpiochip_request_irq_lines(np, gc) \
> > > +	of_gpiochip_x_irq_lines(np, gc, 1)
> > > +
> > > +#define of_gpiochip_free_irq_lines(np, gc) \
> > > +	of_gpiochip_x_irq_lines(np, gc, 0)
> > 
> > Aha, so the x is a wildcard. Fine, although it makes the code slightly
> > less reader-friendly IMHO.
> 
> I am not happy with this naming as well, but I did not want to duplicate
> the code. I could have seperate request_irq_lines and free_irq_lines
> functions having most of the code in common. Has someone a better
> solution in mind ?

Well, simply a better name would be enough, but this is just a nitpick of 
mine.

Best regards,
Tomasz

--nextPart6463264.is8iAGSuk6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAABAgAGBQJSDMoQAAoJEIv3Hb8G/XrunqkQAJNa72V/CxFITc4rqDIEDQRi
NjwcxBMTc8BGuJqwpih17v3GZBXTlBaj/moFWxDQ1mJuC5bTiG6+1mtbQtnKF6g4
8v03ztPWo9jWj/60L+00+79K5eHO9K9eDN9cAewQI6IzPHuVFccNFg0EmdfQNMb3
NzDQsJb9LVfeyZQzwTgtPgdm6pLp1iusK1rMnFfcaPXqIo67G4cw3pWlcK0/6MiC
l0P0RwdwrwJHguKoZsv6MhSdXSeNuV57yy58qjgzJ6Jq2EEeGpRqAc67yFuAoMyN
+I2XBbqdJhzsAjwQSytwq9qqoM4UyWCrvKTxpGbkFPKBelGcznxsSh9IkaJYbjSR
mTxRTjbKAif9GUK2xsNyot/8uMOWJM7owRqJwt9+xzXgmZ+Ug6QiCm5zrofZ3+HF
+jJdB5ROpNFxe70n449i0q/l/qqQ0n5LGGHCXWfYTxSolr3eyn956JkHVXZEEtL5
a8gIQ0kpdbWcbBSW27+r0rtmHeFP4VXa8lBoLiBy3cH6WKBnjLLKAFHTqMY5rMfL
Y96EqDq/hLSIqe6YkknO8Xxq5+Zzz5dHbJh0/FTNwsqWFWvEB5XkjW+xo3vdUxzo
pXeZPP6LqbZyLPuxy+vbstwVjO/DBDY+JFiQLxvMNe+sK3abzEqFQ+uWQ6ugXQE6
yvUoZ21V/N6A9tp6VsX2
=a5KB
-----END PGP SIGNATURE-----

--nextPart6463264.is8iAGSuk6--

