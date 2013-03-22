Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab3CVIdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:33:17 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34218 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3CVIdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <1362414873-17676-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1362414873-17676-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Fri, 22 Mar 2013 09:33:10 +0100
Message-ID: <CACRpkdYYsULLsDQuxoRHp=HXsaOAejwaO-CezdEK4sNprWpDYQ@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: mcp23s08: convert driver to DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: poeschel@lemonage.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

sorry for taking eternities to review stuff :-(

I recommend that you include SPI co-maintainer Mark Brown on subsequent
postings.

On Mon, Mar 4, 2013 at 5:34 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:

> This converts the mcp23s08 driver to be able to be used with device
> tree.

OK!

> +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> @@ -0,0 +1,43 @@
> +Microchip MCP2308/MCP23S08/MCP23017/MCP23S17 driver for
> +8-/16-bit I/O expander with serial interface (I2C/SPI)
> +
> +Required properties:
> +- compatible : Should be
> +    - "mcp,mcp23s08" for  8 GPIO SPI version
> +    - "mcp,mcp23s17" for 16 GPIO SPI version
> +    - "mcp,mcp23008" for  8 GPIO I2C version or
> +    - "mcp,mcp23017" for 16 GPIO I2C version of the chip
> +- #gpio-cells : Should be two.
> +  - first cell is the pin number
> +  - second cell is used to specify flags. Flags currently used:
> +    bit0 : activate a ~100k pullup

Pullup is basically about pin config. This is sort of sneaking
behind the subsystems, but I know I might be overzealous.

Can the electronics do more things than pull-up?

Like pull-down, open drain, drive strength...

If it's a lot it's better to consider pinctrl from the start.
I'm saying this because the DT bindings will be maintained
perpetually and need to set a good example.

I would currently feel a lot better if you did not include this
flag. How would you control this the day drivers need to
enable/disable pull-up at runtime?

> +- gpio-controller : Marks the device node as a GPIO controller.
> +- reg : For an address on its bus

On the I2C/SPI bus?

Please state here what kind of buses it can be. Explain if multiple
buses are supported.

> +Required device specific properties (only for SPI chips):
> +- mcp,spi-present-mask : This is a present flag, that makes only sense for SPI
> +        chips - as the name suggests.

AFAIK this is not how we disable/enable devices in the device tree.

Istead we include a property on the node called "status" and set it
to "disabled" if the device is not there.

> +        Multiple chips can share the same
> +        SPI chipselect. Set bit 0-7 in this mask to 1 if there is a chip
> +        connected with this spi address. If you have a chip with address 3
> +        connected, you have to set bit3 to 1, which is 0x08. mcp23s08 only
> +        supports bits 0-3. It is not possible to mix mcp23s08 and mcp23s17
> +        on the same chipselect. Set at least one bit to 1 for SPI chips.

This looks awkward, why are you using a bitfield for this? Then you
can only ever support 8 devices, since the text also implies that the
value is 8bit (this should be stated).

What about just using a number?

> diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> index 3cea0ea..a8ca469 100644
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@ -12,6 +12,8 @@
>  #include <linux/spi/mcp23s08.h>
>  #include <linux/slab.h>
>  #include <asm/byteorder.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>
>  /**
>   * MCP types supported by driver
> @@ -21,6 +23,11 @@
>  #define MCP_TYPE_008   2
>  #define MCP_TYPE_017   3
>
> +/**
> + * Flags used in device tree
> + */
> +#define MCP_DT_FLAG_PULLUP 0x01

So I'm sceptical here. Is this already supported using platform data?

>  /* Registers are all 8 bits wide.
>   *
>   * The mcp23s17 has twice as many bits, and can be configured to work
> @@ -75,6 +82,25 @@ struct mcp23s08_driver_data {
>         struct mcp23s08         chip[];
>  };
>
> +#ifdef CONFIG_OF
> +static int mcp23s08_of_xlate(struct gpio_chip *gc,
> +                       const struct of_phandle_args *gpiospec, u32 *flags);
> +
> +static int mcp23s08_set_pullup(struct mcp23s08 *mcp, unsigned offset)
> +{
> +       int status;
> +       u16 value;
> +
> +       mutex_lock(&mcp->lock);
> +       value = mcp->cache[MCP_GPPU] | (1 << offset);
> +       status = mcp->ops->write(mcp, MCP_GPPU, value);
> +       if (!status)
> +               mcp->cache[MCP_GPPU] = value;
> +       mutex_unlock(&mcp->lock);
> +
> +       return status;
> +}

The pull-up business actually looks like new functionality that
has nothing to do with adding device tree support and should be
a separate patch.

Yours,
Linus Walleij
