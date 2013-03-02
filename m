Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3CCJXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:23:23 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:44834 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3CCJXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:23:18 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpio: gpio-generic: Fix bug in big endian bit conversion
To: Andreas Larsson <andreas@gaisler.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
In-Reply-To: <512C9287.6000100@gaisler.com>
References: <1360060383-16880-1-git-send-email-andreas@gaisler.com> <1360060383-16880-2-git-send-email-andreas@gaisler.com> <20130209145855.D517E3E328E@localhost> <20130226075228.A963F3E0AEF@localhost> <512C9287.6000100@gaisler.com>
Date: Sat, 02 Mar 2013 09:16:22 +0000
Message-Id: <20130302091622.7ABC13E14C7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013 11:46:31 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> On 2013-02-26 08:52, Grant Likely wrote:
> > On Sat, 09 Feb 2013 14:58:55 +0000, Grant Likely <grant.likely@secretlab.ca> wrote:
> >> On Tue,  5 Feb 2013 11:33:02 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> >>> The swap to convert LE to BE in bgpio_pin2mask_be should be on byte level, not
> >>> on bit level.
> >>>
> >>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> >>> ---
> >>>   drivers/gpio/gpio-generic.c |    5 ++++-
> >>>   1 files changed, 4 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> >>> index 05fcc0f..7f11537 100644
> >>> --- a/drivers/gpio/gpio-generic.c
> >>> +++ b/drivers/gpio/gpio-generic.c
> >>> @@ -112,7 +112,10 @@ static unsigned long bgpio_pin2mask(struct bgpio_chip *bgc, unsigned int pin)
> >>>   static unsigned long bgpio_pin2mask_be(struct bgpio_chip *bgc,
> >>>   				       unsigned int pin)
> >>>   {
> >>> -	return 1 << (bgc->bits - 1 - pin);
> >>> +	unsigned int bit = pin & 0x7; /* Bit number within byte */
> >>> +	unsigned int base = pin - bit; /* Pin that is bit 0 within byte */
> >>> +
> >>> +	return 1 << ((bgc->bits - base - 8) + bit); /* shifted base + bit */
> >>
> >> Ah, sorry for my previous reply. I see you have seen gpio-generic.  :-)
> >>
> >> No, the original calculation is correct. BE and LE bit numbering are
> >> opposite, bit Linux always uses LE numbers as far as bit masks are
> >> concerned. Therefore pin 0 is the most significant bit, and
> >> pin (nr_bits-1) is the least significant bit.
> >
> > Hi Andreas,
> >
> > Actually I'm wrong here (at least partially) after looking closer at the
> > generic gpio driver. The problem is that things get messed up on 16 or
> > 32 bit access depending on how the hardware expects to be accessed.
> > bgpio always uses iowrite/ioread for register access which is inherently
> > little endian, but if the hardware is wired up as a big-endian device
> > then you have to do the fiddly bit you did above to get the bit
> > positions to line up where you what then. So, there could potentially be
> > 4 different ways to count bits on a value ioread() from a gpio register:
> >
> > little-endian, LSB = 0 (sane)
> > little-endian, MSB = 0 (odd)
> > big-endian (bytes swapped), MSB = 0 (common on BE platforms)
> > big-endian (bytes swapped), LSB = 0 (why are you making my life hard?)
> 
> Yes, in v4 of my patch I solved it using custom accessors set outside of 
> gpio-generic internally using ioread32be/iowrite32be instead of adding a 
> whole set of be variants in gpio-generic.

Until we've got something better, please do add the be accessor versions
to gpio-generic. I'm not thrilled with the need for them, but it is
still better than coding your own version.

> > We /could/ have a ioread32be/write32be mode in the driver, but I don't
> > think that is the right approach. It means we need yet another set of
> > accessors for register except using the 'be' variants. Blech. What I'd
> > actually like to do is add a bitmask field to the gpio_desc which can be
> > calculated ahead of time to whatever madness is required from the way
> > the device is wired. Then the access routines don't need to even care.
> > they just apply the bitmask to ioread/iowrite and it doesn't even need
> > to know what the bit number actually is. The new support for gpio_desc
> > in the core code makes this feasable.
> 
> I am not sure I understand what you mean here or what new support for 
> gpio_desc you are referring to (looking in gpio/next at 
> git://git.secretlab.ca/git/linux-2.6).
> 
> Do you mean to add something like an 'unsigned long bitmask[64]' bitmap 
> array with one bitmap for each gpio line to struct gpio_desc and use 
> this primarily by gpio-generic.c, populated in bgpio_init? Is gpio_desc 
> now available outside of gpiolib.c in some repository/branch that I 
> might be unaware of?

No this isn't something that is anywhere, neither on the list nor in a
branch. It's an idea that I've been toying around with along side
pulling basic MMIO access directly into gpiolib to create a fast path.
It's not even a fully thought-through idea.  :-)

The idea is that each gpio_desc would get a hwbit field that would be
pre-populated with the bit used when ioread/iowrite (non-be) accessors
are used. If it is a BE register, then the bit positions can be munged
at setup time so that the accessor itself doesn't have to muck around
with bit position calcuation. This isn't significant for i2c or spi GPIO
controllers because they are slow anyway, but for MMIO, it is a really
big deal. It would mean dropping an entire callback call which is 10's
of instructions compaired to the 2 or 3 required to write the bit to a
set/clr register.

g.
