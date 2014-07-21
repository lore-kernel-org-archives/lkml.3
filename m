Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaGULFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:05:00 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55606 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaGULE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:04:58 -0400
Date: Mon, 21 Jul 2014 19:03:23 +0800
From: Wang YanQing <udknight@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, jhovold@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        dforsi@gmail.com
Subject: Re: [PATCH v3] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140721110323.GA8864@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Andreas Mohr <andi@lisas.de>, gregkh@linuxfoundation.org,
	linus.walleij@linaro.org, jhovold@gmail.com,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	dforsi@gmail.com
References: <20140721024624.GA25469@udknight>
 <20140721054646.GB29620@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721054646.GB29620@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 07:46:46AM +0200, Andreas Mohr wrote:
> Hi,
> 
> Did some more review, sorry ;)
> 
> On Mon, Jul 21, 2014 at 10:46:24AM +0800, Wang YanQing wrote:
> > +static struct gpio_chip template_chip = {
> > +	.label                  = "pl2303-gpio",
> > +	.owner                  = THIS_MODULE,
> > +	.direction_input        = pl2303_gpio_direction_in,
> > +	.get                    = pl2303_gpio_get,
> > +	.direction_output       = pl2303_gpio_direction_out,
> > +	.set                    = pl2303_gpio_set,
> > +	.can_sleep              = 1,
> > +};
> 
> Could this be made static const? (since it's for one-time copy purposes only)
> 
> 

OK, I will add const.

> > +struct pl2303_gpio {
> > +       /*
> > +        * 0..3: unknown (zero)
> > +        * 4: gp0 output enable (1: gp0 pin is output, 0: gp0 pin is input)
> > +        * 5: gp1 output enable (1: gp1 pin is output, 0: gp1 pin is input)
> > +        * 6: gp0 pin value
> > +        * 7: gp1 pin value
> > +        */
> > +       u8 index;
> 
> Most frequently accessed member at first position - good.
> 
> 
> > +static inline struct pl2303_gpio *to_pl2303_gpio(struct gpio_chip
> > *chip)
> > +{
> > +       return container_of(chip, struct pl2303_gpio, gpio_chip);
> > +}
> 
> Nicely cast-avoiding helper :)
> 
> 
> > +		spriv->gpio->index = 0x00;
> > +		spriv->gpio->serial = serial;
> > +		spriv->gpio->gpio_chip = template_chip;
> > +		spriv->gpio->gpio_chip.ngpio = GPIO_NUM;
> > +		spriv->gpio->gpio_chip.base = -1;
> > +		spriv->gpio->gpio_chip.dev = &serial->interface->dev;
> > +		/* initialize GPIOs, input mode as default */
> > +		pl2303_vendor_write(spriv->gpio->serial, 1, spriv->gpio->index);
> 
> Perhaps the index line should better be moved
> right before the pl2303_vendor_write() line,
> to more obviously hint at why it's "input mode"
> (but OTOH currently you're cleanly initializing things in correct member order,
> so it's probably better to keep it that way).
> 
> Also, it's perhaps a better idea to do this initial init call
> via calls of actual GPIO API rather than implementation-specific call
> (e.g. that way one could simple reuse the generic GPIO call for devices
> which happen to implement GPIO via a different mechanism...).
> (hmm, nope, from a layering POV it's not recommendable,
> since we clearly are at hardware-specific init here,
> where you want to firmly guarantee
> that the hardware is directly and fully initialized).
> 
> 

Thanks very much for review :)

> Since there are several repeated
> pl2303_vendor_write(...serial, 1, ...index) calls,
> it's possibly a good idea to wrap these calls in a convenience
> pl2303_gpio_state_update(gpio)
> This would also increase GPIO hardware abstraction,
> by then simply having to provide an alternative for this single function
> if needed.
> Also, it may (depending on the number of callers,
> which is on the low side here unfortunately)
> reduce instruction cache footprint.

The reason I don't want to add more abstraction here are:
1: Abstraction don't reduce code lines, then reuse
   pl2303_vendor_write|read is a better choice, i think.

2: pl2303_vendor_write|read is more generic than abstraction,
   then someone maybe could use pl2303_vendor_write|read to support
   another two Auxiliary GPIOs on PL2303HXD(I don't have one) directly
   without play with abstraction.


Thanks.
   
