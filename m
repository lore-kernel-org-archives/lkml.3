Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab3BOQeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:34:12 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64174 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037Ab3BOQeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:34:10 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND 1/6 v13] gpio: Add a block GPIO API to gpiolib
To: Roland Stigge <stigge@antcom.de>, gregkh@linuxfoundation.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
Cc: Roland Stigge <stigge@antcom.de>
In-Reply-To: <1358250716-21986-2-git-send-email-stigge@antcom.de>
References: <1358250716-21986-1-git-send-email-stigge@antcom.de> <1358250716-21986-2-git-send-email-stigge@antcom.de>
Date: Fri, 15 Feb 2013 16:34:04 +0000
Message-Id: <20130215163404.642863E044B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 12:51:51 +0100, Roland Stigge <stigge@antcom.de> wrote:
> The recurring task of providing simultaneous access to GPIO lines (especially
> for bit banging protocols) needs an appropriate API.
> 
> This patch adds a kernel internal "Block GPIO" API that enables simultaneous
> access to several GPIOs. This is done by abstracting GPIOs to an n-bit word:
> Once requested, it provides access to a group of GPIOs which can range over
> multiple GPIO chips.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Oops, I forgot to comment on the block API bits. Comments below...

> --- linux-2.6.orig/drivers/gpio/gpiolib.c
> +++ linux-2.6/drivers/gpio/gpiolib.c
> --- linux-2.6.orig/include/asm-generic/gpio.h
> +++ linux-2.6/include/asm-generic/gpio.h
> @@ -44,6 +44,7 @@ static inline bool gpio_is_valid(int num
>  
>  struct device;
>  struct gpio;
> +struct gpio_block;
>  struct seq_file;
>  struct module;
>  struct device_node;
> @@ -109,6 +110,8 @@ struct gpio_chip {
>  						unsigned offset);
>  	int			(*get)(struct gpio_chip *chip,
>  						unsigned offset);
> +	unsigned long		(*get_block)(struct gpio_chip *chip,
> +					     unsigned long mask);
>  	int			(*direction_output)(struct gpio_chip *chip,
>  						unsigned offset, int value);
>  	int			(*set_debounce)(struct gpio_chip *chip,
> @@ -116,6 +119,9 @@ struct gpio_chip {
>  
>  	void			(*set)(struct gpio_chip *chip,
>  						unsigned offset, int value);
> +	void			(*set_block)(struct gpio_chip *chip,
> +					     unsigned long mask,
> +					     unsigned long values);
>  
>  	int			(*to_irq)(struct gpio_chip *chip,
>  						unsigned offset);

This is the core of the impact on gpio_chip drivers, so I'll restrict my
comments to this bit.

First to set the stage. The gpio_chip api is used by all types of GPIO
interfaces from on-chip MMIO (fast & atomic) to off-chip I2c/SPI/USB/etc
attached (slow and will sleep). For on-chip GPIO we want the API to get
out of the way as much as possible. Some systems choose fast on-chip
gpios to get as much speed as possible between bit flips. If there is
too much overhead in gpiolib, then they have to dump gpiolib entirely
and open-code it. There will always be a segment of uses that need to do
this, but I don't want to completely ignore highspeed gpiolib users.

For the slow chips, gpiolib overhead is far dwarfed by the serial bus
latency, so any work that can consolidate transfers has measurable
payoff.

The reason I bring this up even though consolidation calculation isn't
going to be done by the chip itself is that the format of the API is
going to affect how much work the chip needs to do[1]. If set and
direction are different operations, then some chips may not be able to
consolidate them into a single transfer. On the other end, some fast
gpio chips have separate set and clear registers that don't require
read/modify/write cycles, but we don't get the advantage of those if the
API is based on mask & value..... I am thinking/rambling out loud here.
Not everything *has* to be supported, but this is the thought process
I'm going through when looking at the API.

I can think of the following operations that the block API needs to
support for any given pin:

1) set to output and level high
2) set to output and level low
3) set to input (rely on open-collector for output)

Right there, a simple mask/value pair isn't going to do the trick
because using an open-collector state for output is quite common (see
the i2c gpio code for example). Adding a direction parameter would solve
that problem:

	void			(*set_block)(struct gpio_chip *chip,
					     unsigned long mask,
					     unsigned long direction,
					     unsigned long data);

Alternately, if open-collector support was moved inside gpiolib then
that problem goes away.

ugh... I've run out of time. I need to shut down for the day. Anyway,
there are my thoughts. I think the API you have would work fine, but
only if you also add open-collector support into the core. I'll let you
know if I think of anything else.

g.

---

[1] However, I've just had another thought. Maybe we're approaching this
problem from entirely the wrong way around. Instead of baking in a block
GPIO API to all of the chip drivers we could instead allow gpio_chips to
do lazy set/get. For fast chips this wouldn't matter, but a driver could
do multiple lazy set operations, and then one flush that pushes all the
updates out. Similarly, a driver could do an "update" on all the input
gpios that it has followed by lazy gets which just use the last cached
value. I kind of like the elegance of it and it doesn't have the
inherent (unsigned long) limitation of 32 or 64 bits that the block gpio
api imposes.

In this scenario, lazy get/set would just by the real get/set for
existing gpio_chip drivers, but enhanced drivers could replace the
immediate versions with lazy variants and the gpiolib core could take
care of setting and flushing when the non-lazy API gets called.

g.

