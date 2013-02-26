Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab3BZHwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:52:38 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:49643 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3BZHwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:52:37 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpio: gpio-generic: Fix bug in big endian bit conversion
To: Andreas Larsson <andreas@gaisler.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
In-Reply-To: <20130209145855.D517E3E328E@localhost>
References: <1360060383-16880-1-git-send-email-andreas@gaisler.com> <1360060383-16880-2-git-send-email-andreas@gaisler.com> <20130209145855.D517E3E328E@localhost>
Date: Tue, 26 Feb 2013 07:52:28 +0000
Message-Id: <20130226075228.A963F3E0AEF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Feb 2013 14:58:55 +0000, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue,  5 Feb 2013 11:33:02 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> > The swap to convert LE to BE in bgpio_pin2mask_be should be on byte level, not
> > on bit level.
> > 
> > Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> > ---
> >  drivers/gpio/gpio-generic.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> > index 05fcc0f..7f11537 100644
> > --- a/drivers/gpio/gpio-generic.c
> > +++ b/drivers/gpio/gpio-generic.c
> > @@ -112,7 +112,10 @@ static unsigned long bgpio_pin2mask(struct bgpio_chip *bgc, unsigned int pin)
> >  static unsigned long bgpio_pin2mask_be(struct bgpio_chip *bgc,
> >  				       unsigned int pin)
> >  {
> > -	return 1 << (bgc->bits - 1 - pin);
> > +	unsigned int bit = pin & 0x7; /* Bit number within byte */
> > +	unsigned int base = pin - bit; /* Pin that is bit 0 within byte */
> > +
> > +	return 1 << ((bgc->bits - base - 8) + bit); /* shifted base + bit */
> 
> Ah, sorry for my previous reply. I see you have seen gpio-generic.  :-)
> 
> No, the original calculation is correct. BE and LE bit numbering are
> opposite, bit Linux always uses LE numbers as far as bit masks are
> concerned. Therefore pin 0 is the most significant bit, and
> pin (nr_bits-1) is the least significant bit.

Hi Andreas,

Actually I'm wrong here (at least partially) after looking closer at the
generic gpio driver. The problem is that things get messed up on 16 or
32 bit access depending on how the hardware expects to be accessed.
bgpio always uses iowrite/ioread for register access which is inherently
little endian, but if the hardware is wired up as a big-endian device
then you have to do the fiddly bit you did above to get the bit
positions to line up where you what then. So, there could potentially be
4 different ways to count bits on a value ioread() from a gpio register:

little-endian, LSB = 0 (sane)
little-endian, MSB = 0 (odd)
big-endian (bytes swapped), MSB = 0 (common on BE platforms)
big-endian (bytes swapped), LSB = 0 (why are you making my life hard?)

We /could/ have a ioread32be/write32be mode in the driver, but I don't
think that is the right approach. It means we need yet another set of
accessors for register except using the 'be' variants. Blech. What I'd
actually like to do is add a bitmask field to the gpio_desc which can be
calculated ahead of time to whatever madness is required from the way
the device is wired. Then the access routines don't need to even care.
they just apply the bitmask to ioread/iowrite and it doesn't even need
to know what the bit number actually is. The new support for gpio_desc
in the core code makes this feasable.

g.

