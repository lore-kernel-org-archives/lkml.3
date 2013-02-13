Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815Ab3BMLNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:13:30 -0500
Received: from [212.90.139.80] ([212.90.139.80]:17467 "EHLO smtp1.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab3BMLN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:13:28 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.773
From: Lars Poeschel <poeschel@lemonage.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] gpio: mcp23s08: convert driver to DT
Date: Wed, 13 Feb 2013 12:13:08 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, rob.herring@calxeda.com,
        rob@landley.net, linus.walleij@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
References: <1360583563-10707-1-git-send-email-larsi@wh2.tu-dresden.de> <20130211212551.1002A3E3530@localhost>
In-Reply-To: <20130211212551.1002A3E3530@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302131213.08631.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2013 at 22:25:51, Grant Likely wrote:
> On Mon, 11 Feb 2013 12:52:42 +0100, Lars Poeschel <larsi@wh2.tu-dresden.de> 
wrote:

> > +Optional device specific properties:
> > +- mcp,chips : This is a table with 2 columns and up to 8 entries. The
> > first column +	is a is_present flag, that makes only sense for SPI
> > chips. Multiple +	chips can share the same chipselect. This flag can be
> > 0 or 1 depending +	if there is a chip at this address or not.
> > +	The second column is written to the GPPU register, selecting a 100k
> > +	pullup resistor or not. Setting a 1 is activating the pullup.
> > +	For I2C chips only the first line in this table is used. Further 
chips
> > +	are registered at different addresses at the I2C bus.
> 
> Since these are two separate things, I would put them into separate
> properties. Perhaps something like:
>  - mcp,spi-present-mask = < mask >; /* one bit per chip */
>  - mcp,pullup-enable-mask = < enable-value ... >;
> 
> However, is the pullup selection per-gpio line? If so, then why not
> encode it into the flags field of the gpio specifier?

Yes, the pullup is per-gpio line. I am working on that. It turns out, that 
this is a bit difficult for me, as there is no real documentation and no 
other driver is doing it or something similar yet. Exception are very few 
gpio soc drivers where situation is a bit different. They seem to rely an 
fixed global gpio numbers and they are always memory mapped.
But as I said I am working on it...

> > diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> > index 3cea0ea..ad08a5a 100644
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
> > @@ -473,17 +475,88 @@ fail:
> >  /*---------------------------------------------------------------------
> >  -*/
> > 
> > +#ifdef CONFIG_OF
> > +static struct of_device_id mcp23s08_of_match[] = {
> > +#ifdef CONFIG_SPI_MASTER
> > +	{
> > +		.compatible = "mcp,mcp23s08",
> > +	},
> > +	{
> > +		.compatible = "mcp,mcp23s17",
> > +	},
> > +#endif
> > +#if IS_ENABLED(CONFIG_I2C)
> > +	{
> > +		.compatible = "mcp,mcp23008",
> > +	},
> > +	{
> > +		.compatible = "mcp,mcp23017",
> > +	},
> > +#endif
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, mcp23s08_of_match);
> 
> I don't think this is actually what you want. You should use separate
> match tables; one for I2C and one for SPI.

I am working on that.

> > +
> > +static struct mcp23s08_platform_data *
> > +		of_get_mcp23s08_pdata(struct device *dev)
> > +{
> > +	struct mcp23s08_platform_data *pdata;
> > +	struct device_node *np = dev->of_node;
> > +	u32 chips[sizeof(pdata->chip)];
> > +	int ret, i, j;
> > +
> > +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata)
> > +		return NULL;
> > +
> > +	pdata->base = -1;
> > +
> > +	for (i = ARRAY_SIZE(pdata->chip) * MCP23S08_CHIP_INFO_MEMBERS;
> > +				i > 0; i -= MCP23S08_CHIP_INFO_MEMBERS) {
> > +		ret = of_property_read_u32_array(np, "mcp,chips", chips, i);
> > +		if (ret == -EOVERFLOW)
> > +			continue;
> > +		break;
> > +	}
> > +	if (!ret) {
> > +		for (j = 0; j < i / MCP23S08_CHIP_INFO_MEMBERS ; j++) {
> > +			pdata->chip[j].is_present =
> > +				chips[j * MCP23S08_CHIP_INFO_MEMBERS];
> > +			pdata->chip[j].pullups =
> > +				chips[j * MCP23S08_CHIP_INFO_MEMBERS + 1];
> > +		}
> > +	}
> > +
> > +	return pdata;
> 
> Using devm is probably overkill since the pdata structure is not touched
> again after probe() exits. You could instead just put the
> mcp23s08_platform_data structure into the stack of the probe hook.

I wanted to keep the impact for the driver itself a minimum. But this is the 
better solution. Working on that too, ...


Thanks for your review,
Lars
