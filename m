Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbAUJSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:18:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:12849 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbbAUJSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:18:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="443098920"
Date: Wed, 21 Jan 2015 11:17:49 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] phy: ulpi: add driver for TI TUSB1210
Message-ID: <20150121091749.GB22716@kuha.fi.intel.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1421745502-169447-4-git-send-email-heikki.krogerus@linux.intel.com>
 <20150120154539.GB8988@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120154539.GB8988@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 09:45:39AM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jan 20, 2015 at 11:18:22AM +0200, Heikki Krogerus wrote:
> > TUSB1210 ULPI PHY has vendor specific register for eye
> > diagram tuning. On some platforms the system firmware has
> > set optimized value to it. In order to not loose the
> > optimized value, the driver stores it during probe and
> > restores it every time the PHY is powered back on.
> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> >  drivers/phy/ulpi/Kconfig    |  11 ++++
> >  drivers/phy/ulpi/Makefile   |   2 +
> >  drivers/phy/ulpi/tusb1210.c | 131 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 144 insertions(+)
> >  create mode 100644 drivers/phy/ulpi/tusb1210.c
> > 
> > diff --git a/drivers/phy/ulpi/Kconfig b/drivers/phy/ulpi/Kconfig
> > index 8007df2..7cd6f82 100644
> > --- a/drivers/phy/ulpi/Kconfig
> > +++ b/drivers/phy/ulpi/Kconfig
> > @@ -7,3 +7,14 @@ config ULPI_PHY
> >  	  Say yes if you have ULPI PHY attached to your USB controller.
> >  
> >  	  If unsure, say N.
> > +
> > +if ULPI_PHY
> > +
> > +config ULPI_TUSB1210
> > +	tristate "TI TUSB1210 USB PHY module"
> > +	depends on POWER_SUPPLY
> > +	select USB_PHY
> > +	help
> > +	  Support for TI TUSB1210 USB ULPI PHY.
> > +
> > +endif
> > diff --git a/drivers/phy/ulpi/Makefile b/drivers/phy/ulpi/Makefile
> > index 59e61cb..7ee6679 100644
> > --- a/drivers/phy/ulpi/Makefile
> > +++ b/drivers/phy/ulpi/Makefile
> > @@ -1,2 +1,4 @@
> >  ulpiphy-y			:= ulpi.o
> >  obj-$(CONFIG_ULPI_PHY)		+= ulpiphy.o
> > +
> > +obj-$(CONFIG_ULPI_TUSB1210)	+= tusb1210.o
> > diff --git a/drivers/phy/ulpi/tusb1210.c b/drivers/phy/ulpi/tusb1210.c
> > new file mode 100644
> > index 0000000..ac77f98
> > --- /dev/null
> > +++ b/drivers/phy/ulpi/tusb1210.c
> 
> do you really need this extra ulpi directory ?
> 
> I wonder if phy-tusb1210.c as a name would be enough.

IMO grouping the ULPI PHY drivers and other ULPI bus code into
separate folder from the start is the right thing to do.

> > @@ -0,0 +1,131 @@
> > +/**
> > + * tusb1210.c - TUSB1210 USB ULPI PHY driver
> > + *
> > + * Copyright (C) 2015 Intel Corporation
> > + *
> > + * Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +#include <linux/module.h>
> > +#include <linux/phy/ulpi/driver.h>
> > +#include <linux/phy/ulpi/regs.h>
> > +#include <linux/gpio/consumer.h>
> > +
> > +#include "ulpi_phy.h"
> > +
> > +struct tusb1210 {
> > +	struct ulpi *ulpi;
> > +	struct phy *phy;
> > +	struct gpio_desc *gpio_reset;
> > +	struct gpio_desc *gpio_cs;
> > +	u8 ctx[1];
> > +};
> > +
> > +static int tusb1210_power_on(struct phy *phy)
> > +{
> > +	struct tusb1210 *tusb = phy_get_drvdata(phy);
> > +
> > +	gpiod_set_value_cansleep(tusb->gpio_reset, 1);
> > +	gpiod_set_value_cansleep(tusb->gpio_cs, 1);
> > +
> > +	/* Restore eye optimisation value */
> > +	ulpi_write(tusb->ulpi, ULPI_EXT_VENDOR_SPECIFIC, tusb->ctx[0]);
> > +
> > +	return 0;
> > +}
> > +
> > +static int tusb1210_power_off(struct phy *phy)
> > +{
> > +	struct tusb1210 *tusb = phy_get_drvdata(phy);
> > +
> > +	gpiod_set_value_cansleep(tusb->gpio_reset, 0);
> > +	gpiod_set_value_cansleep(tusb->gpio_cs, 0);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct phy_ops phy_ops = {
> > +	.power_on = tusb1210_power_on,
> > +	.power_off = tusb1210_power_off,
> > +	.init = tusb1210_power_on,
> > +	.exit = tusb1210_power_off,
> > +	.owner = THIS_MODULE,
> > +};
> > +
> > +static int tusb1210_probe(struct ulpi *ulpi)
> > +{
> > +	struct gpio_desc *gpio;
> > +	struct tusb1210 *tusb;
> > +	int ret;
> > +
> > +	tusb = devm_kzalloc(&ulpi->dev, sizeof(*tusb), GFP_KERNEL);
> > +	if (!tusb)
> > +		return -ENOMEM;
> > +
> > +	gpio = devm_gpiod_get(&ulpi->dev, "reset");
> > +	if (!IS_ERR(gpio)) {
> > +		ret = gpiod_direction_output(gpio, 0);
> > +		if (ret)
> > +			return ret;
> > +		tusb->gpio_reset = gpio;
> > +	}
> > +
> > +	gpio = devm_gpiod_get(&ulpi->dev, "cs");
> > +	if (!IS_ERR(gpio)) {
> > +		ret = gpiod_direction_output(gpio, 0);
> > +		if (ret)
> > +			return ret;
> > +		tusb->gpio_cs = gpio;
> > +	}
> > +
> > +	/* Store initial eye diagram optimisation value */
> > +	ret = ulpi_read(ulpi, ULPI_EXT_VENDOR_SPECIFIC);
> 
> do they *all* use this register for eye diagram optimization or is this
> something that Intel decided to do ?
> 
> (sorry, don't know much about tusb1210 other than it sucks like hell :-)

All I know that somebody needs to save the value. The ones using this
PHY who don't need to save it can most likely live without the driver.

> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	tusb->ctx[0] = ret;
> > +
> > +	tusb->phy = ulpi_phy_create(ulpi, &phy_ops);
> > +	if (IS_ERR(tusb->phy))
> > +		return PTR_ERR(tusb->phy);
> > +
> > +	tusb->ulpi = ulpi;
> > +
> > +	phy_set_drvdata(tusb->phy, tusb);
> > +	dev_set_drvdata(&ulpi->dev, tusb);
> > +	return 0;
> > +}
> > +
> > +static void tusb1210_remove(struct ulpi *ulpi)
> > +{
> > +	struct tusb1210 *tusb = dev_get_drvdata(&ulpi->dev);
> 
> completely unrelated to $subject, but we might want to have a
> ulpi_{set,get}_drvdata() at some point.

Makes sense.

> In fact, we might decide to add an entire ULPI bus, eventually, though
> I'm still considering if there's any benefit to that.

I don't think I understand this comment? ULPI bus is what I'm
introducing in this set (the first patch in it)?

> > +
> > +	ulpi_phy_destroy(ulpi, tusb->phy);
> > +}
> > +
> > +#define TI_VENDOR_ID 0x0451
> > +
> > +static struct ulpi_device_id tusb1210_ulpi_id[] = {
> > +	{ TI_VENDOR_ID, 0x1508, },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(ulpi, tusb1210_ulpi_id);
> > +
> > +static struct ulpi_driver tusb1210_driver = {
> > +	.id_table = tusb1210_ulpi_id,
> > +	.probe = tusb1210_probe,
> > +	.remove = tusb1210_remove,
> > +	.driver = {
> > +		.name = "tusb1210",
> > +		.owner = THIS_MODULE,
> > +	},
> > +};
> > +
> > +module_ulpi_driver(tusb1210_driver);
> > +
> > +MODULE_AUTHOR("Intel Corporation");
> > +MODULE_LICENSE("GPL");
> 
> comment says GPL 2 only, this says GPL 2+

True. I'll fix it.


Thanks!

-- 
heikki
