Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaGUFqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:46:53 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:40771 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaGUFqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:46:51 -0400
Date: Mon, 21 Jul 2014 07:46:46 +0200
From: Andreas Mohr <andi@lisas.de>
To: Wang YanQing <udknight@gmail.com>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, jhovold@gmail.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andi@lisas.de, dforsi@gmail.com
Subject: Re: [PATCH v3] usb:serial:pl2303: add GPIOs interface on PL2303
Message-ID: <20140721054646.GB29620@rhlx01.hs-esslingen.de>
References: <20140721024624.GA25469@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721024624.GA25469@udknight>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Did some more review, sorry ;)

On Mon, Jul 21, 2014 at 10:46:24AM +0800, Wang YanQing wrote:
> +static struct gpio_chip template_chip = {
> +	.label                  = "pl2303-gpio",
> +	.owner                  = THIS_MODULE,
> +	.direction_input        = pl2303_gpio_direction_in,
> +	.get                    = pl2303_gpio_get,
> +	.direction_output       = pl2303_gpio_direction_out,
> +	.set                    = pl2303_gpio_set,
> +	.can_sleep              = 1,
> +};

Could this be made static const? (since it's for one-time copy purposes only)


> +struct pl2303_gpio {
> +       /*
> +        * 0..3: unknown (zero)
> +        * 4: gp0 output enable (1: gp0 pin is output, 0: gp0 pin is input)
> +        * 5: gp1 output enable (1: gp1 pin is output, 0: gp1 pin is input)
> +        * 6: gp0 pin value
> +        * 7: gp1 pin value
> +        */
> +       u8 index;

Most frequently accessed member at first position - good.


> +static inline struct pl2303_gpio *to_pl2303_gpio(struct gpio_chip
> *chip)
> +{
> +       return container_of(chip, struct pl2303_gpio, gpio_chip);
> +}

Nicely cast-avoiding helper :)


> +		spriv->gpio->index = 0x00;
> +		spriv->gpio->serial = serial;
> +		spriv->gpio->gpio_chip = template_chip;
> +		spriv->gpio->gpio_chip.ngpio = GPIO_NUM;
> +		spriv->gpio->gpio_chip.base = -1;
> +		spriv->gpio->gpio_chip.dev = &serial->interface->dev;
> +		/* initialize GPIOs, input mode as default */
> +		pl2303_vendor_write(spriv->gpio->serial, 1, spriv->gpio->index);

Perhaps the index line should better be moved
right before the pl2303_vendor_write() line,
to more obviously hint at why it's "input mode"
(but OTOH currently you're cleanly initializing things in correct member order,
so it's probably better to keep it that way).

Also, it's perhaps a better idea to do this initial init call
via calls of actual GPIO API rather than implementation-specific call
(e.g. that way one could simple reuse the generic GPIO call for devices
which happen to implement GPIO via a different mechanism...).
(hmm, nope, from a layering POV it's not recommendable,
since we clearly are at hardware-specific init here,
where you want to firmly guarantee
that the hardware is directly and fully initialized).


Since there are several repeated
pl2303_vendor_write(...serial, 1, ...index) calls,
it's possibly a good idea to wrap these calls in a convenience
pl2303_gpio_state_update(gpio)
This would also increase GPIO hardware abstraction,
by then simply having to provide an alternative for this single function
if needed.
Also, it may (depending on the number of callers,
which is on the low side here unfortunately)
reduce instruction cache footprint.


So these are my additional thoughts about the implementation,
which you may or may not choose to adopt.

HTH,

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
