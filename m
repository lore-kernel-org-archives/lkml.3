Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaJ2K2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:28:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:6465 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbaJ2K16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:27:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,809,1406617200"; 
   d="scan'208";a="613335172"
Date: Wed, 29 Oct 2014 12:27:54 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] gpio / ACPI: Add knowledge about pin controllers to
 acpi_get_gpiod()
Message-ID: <20141029102754.GM1304@lahna.fi.intel.com>
References: <1414153014-152246-1-git-send-email-mika.westerberg@linux.intel.com>
 <1414153014-152246-2-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdZ=+NmhivkNyjcgjDonypnXLdSBPdHQnbm8KS17pxK9NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ=+NmhivkNyjcgjDonypnXLdSBPdHQnbm8KS17pxK9NA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:41:19AM +0100, Linus Walleij wrote:
> On Fri, Oct 24, 2014 at 2:16 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > The GPIO resources (GpioIo/GpioInt) used in ACPI contain a GPIO number
> > which is relative to the hardware GPIO controller. Typically this number
> > can be translated directly to Linux GPIO number because the mapping is
> > pretty much 1:1.
> >
> > However, when the GPIO driver is using pins exported by a pin controller
> > driver via set of GPIO ranges, the mapping might not be 1:1 anymore and
> > direct translation does not work.
> >
> > In such cases we need to translate the ACPI GPIO number to be suitable for
> > the GPIO controller driver in question by checking all the pin controller
> > GPIO ranges under the given device and using those to get the proper GPIO
> > number.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> I'm not sure what this patch does so I try to rely on you guys here.
> I would strongly like to have Rafael's ACK before proceeding.
> 
> Trying to get the GPIO offsets to map 1:1 to Linux GPIO numbers
> is something that should be avoided since we want to get rid of the
> GPIO number space altogether. GPIO chips should try to register
> with .base = -1 so that the gpiolib just assigns some random GPIO
> numbers to the lines.
> 
> What does actually exist?
> 
> - GPIO offsets for a certain gpio_chip 0..N
> - Pin offsets for a certain pin controller 0..N
> 
> GPIO ranges are for translating between these two.
> 
> But I have a vague idea that there is something like a numberspace
> concept inside ACPI as well, and that is all magic to me...
> mixing that into this is a bit scary to me.

Let me try to explain.

As an example, we have touch panel that has GPIO interrupt declared in
ACPI like this:

	GpioInt (Level, ActiveLow, Shared, PullDefault, 0x0000,
		 "\\_SB.GPO0", 0x00, ResourceConsumer)
	{   // Pin list
		76
	}

The number 76 in this case is GPIO controller relative GPIO number.

Now, we have pinctrl-cherryview.c which has gaps in the pin space (some
of the pins are not available to the OS at all). So for this particular
pin we have:

	# grep SATA_GP1 pins
	pin 76 (SATA_GP1) mode 1 ctrl0 0x00010200 ctrl1 0x04c00000

	# cat gpio-ranges 
	GPIO ranges handled:
	0: INT33FF:00 GPIOS [456 - 463] PINS [0 - 7]
	8: INT33FF:00 GPIOS [464 - 471] PINS [15 - 22]
	16: INT33FF:00 GPIOS [472 - 479] PINS [30 - 37]
	24: INT33FF:00 GPIOS [480 - 487] PINS [45 - 52]
	32: INT33FF:00 GPIOS [488 - 495] PINS [60 - 67]
	40: INT33FF:00 GPIOS [496 - 503] PINS [75 - 82]
	48: INT33FF:00 GPIOS [504 - 511] PINS [90 - 97]

In other words GPIO number for pin 76 is 496 (in Linux global number
space) and 41 in the GPIO driver local number space.

In order to translate the ACPI GPIO number 76 to the right GPIO number
we iterate over each range in the GPIO driver and look for the match.
Note that it actually uses the local number (41) here:

	...
        offset = acpi_gpiochip_pin_to_gpio_offset(chip, pin);
        if (offset < 0)
                return ERR_PTR(offset);

        return gpiochip_get_desc(chip, (u16)offset);

However, if you or others have better ideas how to do this I'm all ears
:-)

> > +#ifdef CONFIG_PINCTRL
> > +/**
> > + * acpi_gpiochip_pin_to_gpio_offset() - translates ACPI GPIO to Linux GPIO
> > + * @chip: GPIO chip
> > + * @pin: ACPI GPIO pin number from GpioIo/GpioInt resource
> 
> So I guess I'm curious about this Gpiolo/GpioInt resource number space...

In the above example:

	GpioInt (Level, ActiveLow, Shared, PullDefault, 0x0000,
		 "\\_SB.GPO0", 0x00, ResourceConsumer)
	{   // Pin list
		76
	}

The GPIO number (76) is relative to the GPIO controller in question
(\_SB.GPO0). 0 would be the first GPIO and so on...
