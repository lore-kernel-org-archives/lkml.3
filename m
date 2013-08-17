Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3HQJ71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 05:59:27 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:62828 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3HQJ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 05:59:24 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Lars Poeschel <poeschel@lemonage.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        swarren@wwwdotorg.org, mark.rutland@arm.com, ian.campbell@citrix.com,
        galak@codeaurora.org, pawel.moll@arm.com
Subject: Re: [PATCH v2] RFC: interrupt consistency check for OF GPIO IRQs
Date: Sat, 17 Aug 2013 11:59:17 +0200
Message-ID: <9241298.URG9CVQFmF@flatron>
User-Agent: KMail/4.11 (Linux/3.10.6-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <CACRpkdZqtn80rkpGokpjwoeEWTx+f_ug1zqOHBA1SeSz9Oj7mA@mail.gmail.com>
References: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de> <1955836.AOXICuVgjP@flatron> <CACRpkdZqtn80rkpGokpjwoeEWTx+f_ug1zqOHBA1SeSz9Oj7mA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ccing DT maintainers, as they may have some ideas as well]

On Saturday 17 of August 2013 02:16:11 Linus Walleij wrote:
> On Thu, Aug 15, 2013 at 11:53 AM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> >> +             /* Check if we have an IRQ parent, else continue */
> >> +             irq_parent = of_irq_find_parent(child);
> >> +             if (!irq_parent)
> >> +                     continue;
> > 
> > You can probably put the irq_parent node here to not duplicate calls
> > in
> > both code paths below.
> 
> But...
> 
> >> +             /* Is it so that this very GPIO chip is the parent? */
> >> +             if (irq_parent != gcn) {
> 
> I am using it here in this comparison.

You don't seem to be dereferencing it in this comparison.

> >> +                     of_node_put(irq_parent);
> >> +                     continue;
> >> +             }
> >> +             of_node_put(irq_parent);
> 
> Then here I put it.
> 
> >> +             num_irq = of_irq_count(gcn);
> >> +             for (i = 0; i < num_irq; i++) {
> >> +                     /*
> >> +                      * The first cell is always the local IRQ
> >> number,
> > 
> > and
> > 
> >> +                      * this corresponds to the GPIO line offset for
> >> a
> > 
> > GPIO
> > 
> >> +                      * chip.
> >> +                      *
> >> +                      * FIXME: take interrupt-cells into account
> >> here.
> > 
> > This is the biggest problem of this patch. It assumes that there is
> > only a single and shared GPIO/interrupt specification scheme, which
> > might not be true.
> > 
> > First of all, almost all interrupt bindings have an extra,
> > semi-generic
> > flags field as last cell in the specifier. Now there can be more than
> > one> 
> > cell used to index GPIOs and interrupts, for example:
> >         interrupts = <1 3 8>
> > 
> > which could mean: bank 1, pin 3, low level triggered.
> 
> You are right, but:
> Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> Specifies how to handle the one-celled and two-celled versions.
> 
> And nothing else is specified. So it's not overly complex.

The documentation states that:

	It is the responsibility of the interrupt controller's binding to 
	define the length and format of the interrupt specifier.

Then two _example_ formats follow, preceded by following statement:

	The following two variants are commonly used:

I already know a variant which uses three (Exynos combiner) and four 
(S3C24xx interrupt controller) cells. They are not pin controllers, but 
you can't stop anyone from adopting similar or even more complex 
specifiers formats for their hardware, especially when it matches more 
closely the interrupt/pin layout used in their hardware.

> But we have to read out the #interrupt-cells specifier from the
> controller I guess, but since we the gcn pointer we can do this
> easily. (I'll fix...)
> 
> > I think you may need to reuse a lot of the code that normally parses
> > the interrupts property, i.e. the irq_of_parse_and_map() path, which
> > will then give you the hwirq index inside your irq chip, which may
> > (or may not) be the same as the GPIO offset inside your GPIO chip.
> 
> We don't need to map it, and that's the hard part of that code.
> We just need to add some code to check the number of
> cells.

Not really. Only the interrupt controller's driver (or rather its .xlate() 
callback) knows how to map all the cells into hwirq index. So we must at 
least get the irq domain associated with the node and call its .xlate() 
callback with requested count of cells.

> > If you're unlucky enough to spot a controller that uses completely
> > different numbering schemes for GPIOs and interrupts, then you're
> > probably screwed, because only the driver for this controller can
> > know the mapping between them.
> 
> But the binding documents state how this shall be done, as illustrated.
> Documentation/devicetree/bindings/interrupt-controller/interrupts.txt

No. Both specifier formats shown in the documentation are just examples. 
As I already quoted, specifier format is up to the binding of particular 
interrupt controller, without any restrictions.

> Documentation/devicetree/bindings/gpio/gpio.txt
> 
> >> +                             if (ret)
> >> +                                     pr_err("gpiolib OF: could not
> > 
> > request IRQ GPIO %d (%d)\n",
> > 
> >> +                                            gc->base + offset,
> >> offset);> 
> > Would some kind of error handling be a bad idea here? Like, for
> > example, marking this IRQ as invalid or something among these lines.
> 
> Sorry I'm not following. The GPIO core has no clue of how the
> driver implements its irqchip and no handle on it so it cannot
> go in and mark any interrupts.

Well, this code already tries to map GPIO pins into interrupts. As I 
explained above, you will need to get access to irq domain anyway, so it 
shouldn't be a problem to do some operations on interrupts here.

But...

> >> +                             ret = gpio_direction_input(gc->base +
> > 
> > offset);
> > 
> >> +                             if (ret)
> >> +                                     pr_err("gpiolib OF: could not
> >> set
> > 
> > IRQ GPIO %d (%d) as input\n",
> > 
> >> +                                            gc->base + offset,
> >> offset);> 
> > I'm not sure if this is the correct action if someone already
> > requested
> > the GPIO before and probably already set it up with their own set of
> > parameters (not necessarily the same as enforced by calling
> > gpio_direction_input()).
> 
> What do you mean with " someone already requested the GPIO
> before" here?
> 
> This code is run right after the gpiochip is added, noone has a
> chance of requesting anything before this happens. This is the
> general idea: steal all GPIOs marked to be used as interrupts
> so no other consumer can get at them.

...yes, I haven't noticed that this is called from gpiochip add context 
and so gotten it wrong a bit. Please ignore the original comment 
(including previous one as well, since it is unlikely that request_gpio() 
will fail for us).

> >> +                     } else {
> >> +                             gpio_free(gc->base + offset);
> > 
> > What if the request failed? This would mean calling gpio_free() on a
> > GPIO previously requested by someone else.
> 
> Noone can request before us, as stated.

Right.

> >> +#define of_gpiochip_request_irq_lines(np, gc) \
> >> +     of_gpiochip_x_irq_lines(np, gc, 1)
> >> +
> >> +#define of_gpiochip_free_irq_lines(np, gc) \
> >> +     of_gpiochip_x_irq_lines(np, gc, 0)
> > 
> > Aha, so the x is a wildcard. Fine, although it makes the code slightly
> > less reader-friendly IMHO.
> 
> I renamed it a bit.

OK.

Best regards,
Tomasz

