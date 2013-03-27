Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3C0Lef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:34:35 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:43002 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab3C0Led (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:34:33 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.886
From: Lars Poeschel <poeschel@lemonage.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3] gpio: mcp23s08: convert driver to DT
Date: Wed, 27 Mar 2013 12:35:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Peter Korsgaard <jacmet@sunsite.dk>
References: <1362414873-17676-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdYYsULLsDQuxoRHp=HXsaOAejwaO-CezdEK4sNprWpDYQ@mail.gmail.com>
In-Reply-To: <CACRpkdYYsULLsDQuxoRHp=HXsaOAejwaO-CezdEK4sNprWpDYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303271235.32346.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 March 2013 at 09:33:10, Linus Walleij wrote:

> > +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> > @@ -0,0 +1,43 @@
> > +Microchip MCP2308/MCP23S08/MCP23017/MCP23S17 driver for
> > +8-/16-bit I/O expander with serial interface (I2C/SPI)
> > +
> > +Required properties:
> > +- compatible : Should be
> > +    - "mcp,mcp23s08" for  8 GPIO SPI version
> > +    - "mcp,mcp23s17" for 16 GPIO SPI version
> > +    - "mcp,mcp23008" for  8 GPIO I2C version or
> > +    - "mcp,mcp23017" for 16 GPIO I2C version of the chip
> > +- #gpio-cells : Should be two.
> > +  - first cell is the pin number
> > +  - second cell is used to specify flags. Flags currently used:
> > +    bit0 : activate a ~100k pullup
> 
> Pullup is basically about pin config. This is sort of sneaking
> behind the subsystems, but I know I might be overzealous.
> 
> Can the electronics do more things than pull-up?
> 
> Like pull-down, open drain, drive strength...

No pull-down, no open drain, no drive strength, nothing - only 100k pull-up.
 
> If it's a lot it's better to consider pinctrl from the start.
> I'm saying this because the DT bindings will be maintained
> perpetually and need to set a good example.
> 
> I would currently feel a lot better if you did not include this
> flag. How would you control this the day drivers need to
> enable/disable pull-up at runtime?

For me it would also be easier to remove the flag (for DT boot case). I don't 
need the pullups. I did only include it, because this is how the driver is 
designed to work and what it did already. What I wanted was to make a good 
transfer from what the features of the driver are and how it works to be able 
to use it with device tree. If it now turns out that's bad for some reason, I 
have no problem to remove this from the patch completely.
You're right: Runtime config is not possible this way.
What should I do now ? Remove it ?

> > +- gpio-controller : Marks the device node as a GPIO controller.
> > +- reg : For an address on its bus
> 
> On the I2C/SPI bus?

Yes, both. For I2C it's the I2C address, for SPI it's the chip select to use 
for this chip.

> Please state here what kind of buses it can be. Explain if multiple
> buses are supported.

Ok, I will add a line about it.

> > +Required device specific properties (only for SPI chips):
> > +- mcp,spi-present-mask : This is a present flag, that makes only sense
> > for SPI +        chips - as the name suggests.
> 
> AFAIK this is not how we disable/enable devices in the device tree.
> 
> Istead we include a property on the node called "status" and set it
> to "disabled" if the device is not there.

This would require multiple instances with the same reg property as up to 8 
chips can live on the same chip select. I wonder if this is possible ?
 
> > +        Multiple chips can share the same
> > +        SPI chipselect. Set bit 0-7 in this mask to 1 if there is a
> > chip +        connected with this spi address. If you have a chip with
> > address 3 +        connected, you have to set bit3 to 1, which is 0x08.
> > mcp23s08 only +        supports bits 0-3. It is not possible to mix
> > mcp23s08 and mcp23s17 +        on the same chipselect. Set at least one
> > bit to 1 for SPI chips.
> 
> This looks awkward, why are you using a bitfield for this? Then you
> can only ever support 8 devices, since the text also implies that the
> value is 8bit (this should be stated).

Grant had the idea with the bitfield. You have the reg property specifying 
the chip select line. This bitfield is then used to indicate which of the 8 
possible chips on this same chip select line is really present. Not beeing 
able to support more than 8 devices is not problem, because it is a hardware 
limitation, that not more than 8 devices can share the same SPI chip select. 
This is again how the driver worked so far.
 
> What about just using a number?

This would again require multiple instances with the same reg property for 
SPI. Is this really possible ?
 
> > diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> > index 3cea0ea..a8ca469 100644
> > --- a/drivers/gpio/gpio-mcp23s08.c
> > +++ b/drivers/gpio/gpio-mcp23s08.c
> > @@ -12,6 +12,8 @@
> > 
> >  #include <linux/spi/mcp23s08.h>
> >  #include <linux/slab.h>
> >  #include <asm/byteorder.h>
> > 
> > +#include <linux/of.h>
> > +#include <linux/of_device.h>
> > 
> >  /**
> >  
> >   * MCP types supported by driver
> > 
> > @@ -21,6 +23,11 @@
> > 
> >  #define MCP_TYPE_008   2
> >  #define MCP_TYPE_017   3
> > 
> > +/**
> > + * Flags used in device tree
> > + */
> > +#define MCP_DT_FLAG_PULLUP 0x01
> 
> So I'm sceptical here. Is this already supported using platform data?

Yes, setting the pullups using platform data on probe time is supported.

> >  /* Registers are all 8 bits wide.
> >  
> >   *
> >   * The mcp23s17 has twice as many bits, and can be configured to work
> > 
> > @@ -75,6 +82,25 @@ struct mcp23s08_driver_data {
> > 
> >         struct mcp23s08         chip[];
> >  
> >  };
> > 
> > +#ifdef CONFIG_OF
> > +static int mcp23s08_of_xlate(struct gpio_chip *gc,
> > +                       const struct of_phandle_args *gpiospec, u32
> > *flags); +
> > +static int mcp23s08_set_pullup(struct mcp23s08 *mcp, unsigned offset)
> > +{
> > +       int status;
> > +       u16 value;
> > +
> > +       mutex_lock(&mcp->lock);
> > +       value = mcp->cache[MCP_GPPU] | (1 << offset);
> > +       status = mcp->ops->write(mcp, MCP_GPPU, value);
> > +       if (!status)
> > +               mcp->cache[MCP_GPPU] = value;
> > +       mutex_unlock(&mcp->lock);
> > +
> > +       return status;
> > +}
> 
> The pull-up business actually looks like new functionality that
> has nothing to do with adding device tree support and should be
> a separate patch.

I can put this in a seperate patch if you want. There still is the general 
question: Remove the pullup thing from the device tree boot or keep it in ?

Regards,
Lars
