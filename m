Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaAGQBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:01:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57486 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbaAGQBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:01:07 -0500
Date: Tue, 7 Jan 2014 16:00:44 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH] gpio: mcp23s08: Add irq functionality for i2c chips
Message-ID: <20140107160044.GE4180@e106331-lin.cambridge.arm.com>
References: <1389103548-23458-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389103548-23458-1-git-send-email-larsi@wh2.tu-dresden.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:05:48PM +0000, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This adds interrupt functionality for i2c chips to the driver.
> They can act as a interrupt-controller and generate interrupts, if
> the inputs change.
> This is tested on a mcp23017 chip.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
>  .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |  21 +-
>  drivers/gpio/Kconfig                               |   1 +
>  drivers/gpio/gpio-mcp23s08.c                       | 220 ++++++++++++++++++++-
>  3 files changed, 236 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> index daa3017..b8376f3 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> @@ -38,12 +38,31 @@ Required device specific properties (only for SPI chips):
>      removed.
>  - spi-max-frequency = The maximum frequency this chip is able to handle
>  
> -Example I2C:
> +Optional properties:
> +- #interrupt-cells : Should be two.
> +  - first cell is the pin number
> +  - second cell is used to specify flags.
> +- interrupt-controller: Marks the device node as a interrupt controller.
> +NOTE: The interrupt functionality is only supported for i2c versions of the
> +chips yet.
> +
> +Optional device specific properties:
> +- microchip,irq-mirror: Sets the mirror flag in the IOCON register. This causes
> +        devices with two interrupt outputs to always trigger both interrupt
> +        outputs regardless where the interrupt happened.
> +

When is this useful?

When should it be set and when shouldin't it be?

[...]

> @@ -432,13 +618,21 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
>  	/* verify MCP_IOCON.SEQOP = 0, so sequential reads work,
>  	 * and MCP_IOCON.HAEN = 1, so we work with all chips.
>  	 */
> +
>  	status = mcp->ops->read(mcp, MCP_IOCON);
>  	if (status < 0)
>  		goto fail;
> -	if ((status & IOCON_SEQOP) || !(status & IOCON_HAEN)) {
> +
> +	mirror = of_find_property(mcp->chip.of_node,
> +				  "microchip,irq-mirror", NULL);

Use of_property_read_bool.

> +	if ((status & IOCON_SEQOP) || !(status & IOCON_HAEN) || mirror) {
>  		/* mcp23s17 has IOCON twice, make sure they are in sync */
>  		status &= ~(IOCON_SEQOP | (IOCON_SEQOP << 8));
>  		status |= IOCON_HAEN | (IOCON_HAEN << 8);
> +		status &= ~(IOCON_INTPOL | (IOCON_INTPOL << 8));
> +		if (mirror)
> +			status |= IOCON_MIRROR | (IOCON_MIRROR << 8);
> +
>  		status = mcp->ops->write(mcp, MCP_IOCON, status);
>  		if (status < 0)
>  			goto fail;
> @@ -469,7 +663,17 @@ static int mcp23s08_probe_one(struct mcp23s08 *mcp, struct device *dev,
>  			goto fail;
>  	}
>  
> +	if (mcp->irq &&
> +	    of_find_property(mcp->chip.of_node, "interrupt-controller", NULL)) {

You could do so here too.

In fact, doesn't the irq-mirror proeprty only make sense if this is an
interrupt controller?

[...]

> @@ -583,6 +789,10 @@ static int mcp230xx_remove(struct i2c_client *client)
>  	if (status == 0)
>  		kfree(mcp);
>  
> +	if (client->irq &&
> +	    of_find_property(mcp->chip.of_node, "interrupt-controller", NULL))
> +		mcp23s08_irq_teardown(mcp);

Can you not cache the fact it's an interrupt controller?

Parsing the DT in a teardown path is very odd.

Thanks,
Mark.
