Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbbASNXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 08:23:25 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.153]:31665 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbbASNXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:23:22 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-10.tower-178.messagelabs.com!1421673797!40771714!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH v5 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Thread-Topic: [PATCH v5 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Thread-Index: AQHQHgd+W2OiD6n4RUaNlFSB0FVd3JzHe3IAgAAcpYA=
Date: Mon, 19 Jan 2015 13:23:15 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB52874E@SW-EX-MBX01.diasemi.com>
References: <cover.1419264383.git.Adam.Thomson.Opensource@diasemi.com>
 <8768cf84babd1bc3e16dadc25bdbb50cebfb44b6.1419264383.git.Adam.Thomson.Opensource@diasemi.com>
 <20150119113332.GP21886@x1>
In-Reply-To: <20150119113332.GP21886@x1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0JDNUjM003525

On January 19, 2015 11:34, Lee Jones wrote:

> On Mon, 22 Dec 2014, Adam Thomson wrote:
> 
> > DA9150 is a combined Charger and Fuel-Gauge IC, with additional
> > GPIO and GPADC functionality.
> >
> > Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> > ---
> >  drivers/mfd/Kconfig                  |   12 +
> >  drivers/mfd/Makefile                 |    2 +-
> >  drivers/mfd/da9150-core.c            |  413 ++++++++++++
> >  include/linux/mfd/da9150/core.h      |   68 ++
> >  include/linux/mfd/da9150/registers.h | 1155
> ++++++++++++++++++++++++++++++++++
> >  5 files changed, 1649 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/mfd/da9150-core.c
> >  create mode 100644 include/linux/mfd/da9150/core.h
> >  create mode 100644 include/linux/mfd/da9150/registers.h
> >
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index 2e6b731..56e80d2 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -195,6 +195,18 @@ config MFD_DA9063
> >  	  Additional drivers must be enabled in order to use the functionality
> >  	  of the device.
> >
> > +config MFD_DA9150
> > +	tristate "Dialog Semiconductor DA9150 Charger Fuel-Gauge chip"
> > +	depends on I2C=y
> > +	select MFD_CORE
> > +	select REGMAP_I2C
> > +	select REGMAP_IRQ
> > +	help
> > +	  This adds support for the DA9150 integrated charger and fuel-gauge
> > +	  chip. This driver provides common support for accessing the device.
> > +	  Additional drivers must be enabled in order to use the specific
> > +	  features of the device.
> > +
> >  config MFD_DLN2
> >  	tristate "Diolan DLN2 support"
> >  	select MFD_CORE
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index 53467e2..f06f4c6 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -113,7 +113,7 @@ obj-$(CONFIG_MFD_DA9055)	+= da9055.o
> >
> >  da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
> >  obj-$(CONFIG_MFD_DA9063)	+= da9063.o
> > -
> > +obj-$(CONFIG_MFD_DA9150)	+= da9150-core.o
> >  obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
> >  obj-$(CONFIG_MFD_MAX77686)	+= max77686.o
> >  obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
> > diff --git a/drivers/mfd/da9150-core.c b/drivers/mfd/da9150-core.c
> > new file mode 100644
> > index 0000000..4d757b9
> > --- /dev/null
> > +++ b/drivers/mfd/da9150-core.c
> > @@ -0,0 +1,413 @@
> > +/*
> > + * DA9150 Core MFD Driver
> > + *
> > + * Copyright (c) 2014 Dialog Semiconductor
> > + *
> > + * Author: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> > + *
> > + * This program is free software; you can redistribute  it and/or modify it
> > + * under  the terms of  the GNU General  Public License as published by the
> > + * Free Software Foundation;  either version 2 of the  License, or (at your
> > + * option) any later version.
> > + */
> 
> [...]
> 
> > +u8 da9150_reg_read(struct da9150 *da9150, u16 reg)
> > +{
> > +	int val, ret;
> > +
> > +	ret = regmap_read(da9150->regmap, reg, &val);
> > +	if (ret)
> > +		dev_err(da9150->dev, "Failed to read from reg 0x%x: %d\n",
> > +			reg, ret);
> > +
> > +	return (u8) val;
> > +}
> > +EXPORT_SYMBOL_GPL(da9150_reg_read);
> > +
> > +void da9150_reg_write(struct da9150 *da9150, u16 reg, u8 val)
> > +{
> > +	int ret;
> > +
> > +	ret = regmap_write(da9150->regmap, reg, val);
> > +	if (ret)
> > +		dev_err(da9150->dev, "Failed to write to reg 0x%x: %d\n",
> > +			reg, ret);
> > +}
> > +EXPORT_SYMBOL_GPL(da9150_reg_write);
> > +
> > +void da9150_set_bits(struct da9150 *da9150, u16 reg, u8 mask, u8 val)
> > +{
> > +	int ret;
> > +
> > +	ret = regmap_update_bits(da9150->regmap, reg, mask, val);
> > +	if (ret)
> > +		dev_err(da9150->dev, "Failed to set bits in reg 0x%x: %d\n",
> > +			reg, ret);
> > +}
> > +EXPORT_SYMBOL_GPL(da9150_set_bits);
> > +
> > +void da9150_bulk_read(struct da9150 *da9150, u16 reg, int count, u8 *buf)
> > +{
> > +	int ret;
> > +
> > +	ret = regmap_bulk_read(da9150->regmap, reg, buf, count);
> > +	if (ret)
> > +		dev_err(da9150->dev, "Failed to bulk read from reg 0x%x: %d\n",
> > +			reg, ret);
> > +}
> > +EXPORT_SYMBOL_GPL(da9150_bulk_read);
> > +
> > +void da9150_bulk_write(struct da9150 *da9150, u16 reg, int count, const u8
> *buf)
> > +{
> > +	int ret;
> > +
> > +	ret = regmap_raw_write(da9150->regmap, reg, buf, count);
> > +	if (ret)
> > +		dev_err(da9150->dev, "Failed to bulk write to reg 0x%x %d\n",
> > +			reg, ret);
> > +}
> > +EXPORT_SYMBOL_GPL(da9150_bulk_write);
> 
> I've never been a fan of this type of aggregation.  Can you explain to
> me what the point of them is?

I refer you back to our previous discussion some time back:

https://lkml.org/lkml/2014/9/9/284

'The reason for these is because future patches to add additional functionality
will introduce I2C access functions which do not use regmap and access the
device via a separate I2C address for this purpose. I will need to provide
access functions for that, and so having a common style of I2C access makes
sense for this driver. Means any access just needs to provide the MFD private
data, and the relevant functions take care of the rest. I think this is cleaner
in this instance.'
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
