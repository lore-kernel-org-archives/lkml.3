Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaAQWoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:44:00 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37880 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaAQWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:43:29 -0500
MIME-Version: 1.0
In-Reply-To: <20140117205346.GH15937@n2100.arm.linux.org.uk>
References: <20140117184731.GE15937@n2100.arm.linux.org.uk>
	<52D98712.3070103@wwwdotorg.org>
	<20140117202405.GF15937@n2100.arm.linux.org.uk>
	<52D995C4.80104@wwwdotorg.org>
	<20140117205346.GH15937@n2100.arm.linux.org.uk>
Date: Fri, 17 Jan 2014 23:43:27 +0100
Message-ID: <CACRpkdaRQRD85-0wUmip=j1SHzti6Nb69JEUXznYTkrxGvky=A@mail.gmail.com>
Subject: Re: More GPIO madness on iMX6 - and the crappy ARM port of Linux
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 9:53 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jan 17, 2014 at 01:42:44PM -0700, Stephen Warren wrote:

>> I believe you want gpio_get_value() to return either the driven or
>> actual pin value where it can on the current HW, but just e.g. hard-code
>> 0 on other HW. That would introduce a core feature that works some
>> places but not others, and hence make drivers that relied on the feature
>> less portable between HW with different actual features.
>
> I can buy that argument, but there's an issue which stands squarely in
> its way, and that is open-drain GPIOs.
>
> These are modelled just as any other GPIO, mainly so that both
> gpio_set_value(gpio, 1) and gpio_direction_input(gpio) both result in
> the signal being high.  The only combination which results in the
> signal being driven low is outputting zero - and the state of the signal
> can aways be read back.
>
> The problem here is that such gpios are implemented in things like the
> I2C driver such that they're _always_ outputs, and gpio_set_value() is
> used to pull the signal down.  gpio_get_value() is used to read its
> current state.
>
> So, if we say that gpio_get_value() is undefined, we force such
> subsystems to always jump through the non-open-drain paths (using
> gpio_direction_input() to set the line high and
> gpio_direction_output(gpio, 0) to drive it low.)

Incidentally that is what gpiolib is doing internally in
gpiod_direction_output().

You're absolutely right that it makes no sense to have open
drain (or open source) unless the signal can be read back from
the hardware.

I'm thinking something like if the driver manages to obtain a
GPIO with

gpio_request_one(gpio, GPIOF_OPEN_DRAIN |
                     GPIOF_OUT_INIT_HIGH);

As the I2C core does, and then when that call succeeds, it can
expect that whatever comes back from gpio_get_value() is
always what is actually on the line. If the driver cannot determine
this it should not have allowed that flag to succeed in the first
place, so this might be something we want to enforce.

There are two white spots on the map here:

1. Today this OPEN_DRAIN flag is not even passed down to
the driver so how could it say anything about it :-( it's a pure gpiolib
internal flag. We don't know if the hardware can actually even
do open drain, we just assume it can.

What it should really do - in the best of worlds - is to check if
it can cross-reference the GPIO line to a pin in the pin control
subsystem, and if that is possible, then ask the pin if it
is supporting open drain and set it. It currently has no such
cross-calls, it is just assumed that the configuration is consistent,
and the actual pin is set up as open drain. But it would make
sense to add more cross-calls here, since GPIO is accepting
these flags (OPEN_DRAIN/OPEN_SOURCE).

Like:
int pinctrl_gpio_set_flags(unsigned gpio, unsigned long flags);

Where the pinctrl subsystem would attempt to cross reference
and set the flag, and the pin controller backend will then have
the option to return an error code.

We could atleast support that for the select pin controllers
that use generic pin config. i.MX is another story, but I'm open
to compromises.

2. In the new descriptor API this open drain setting would
be set from the lookup table and be a property on the line,
meaning this flag is not requested explicitly by the consumer,
and the consumer needs to inspect the obtained descriptor
to figure out if it is set to open drain.

Alexandre: do you have plans for how to handle a dynamic
consumer passing flags to its gpio request in the gpiod API?
I noticed that API missing now, there is exactly one user in the
entire kernel, in drivers/i2c/i2c-core.c but a very important one.

I guess to switch the I2C core over to descriptors I could
think of an API like this:

int gpiod_get_flags(const struct gpio_desc *desc);

If the OPEN_DRAIN flag is set on that descriptor we should
always be able to read the input. But as this is not really what the
I2C core wants to know (it really would prefer not to bother with
such GPIO flag details) so is it better if we add a special call to
figure out if the input can be read? Like:

bool gpiod_input_always_valid(const struct gpio_desc *desc);

And leave it up to the core to look at flags, driver characteristics
etc and determine whether the input can be trusted?

Yours,
Linus Walleij
