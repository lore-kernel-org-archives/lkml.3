Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaE1HIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:08:42 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.149]:33637 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbaE1HIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:08:40 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 May 2014 03:08:39 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-15.tower-179.messagelabs.com!1401260538!30541067!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 28 May 2014 09:02:18 +0200
Date: Wed, 28 May 2014 09:02:23 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Lee Jones <lee.jones@linaro.org>
CC: Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <johannes.thumshirn@men.de>
Subject: Re: [PATCH v2 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
Message-ID: <20140528070222.GA24101@jtlinux>
References: <cover.1401181010.git.andreas.werner@men.de>
 <a3cd43562effd2580d0174c56eff5584791217ac.1401181010.git.andreas.werner@men.de>
 <20140527150547.GA4227@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140527150547.GA4227@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 04:05:47PM +0100, Lee Jones wrote:
> > The MEN 14F021P00 Board Management Controller provides an
> > I2C interface to the host to access the feature implemented in the BMC.
> > The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
> > and on a few Box/Display Computer.
> >
> > Added MFD Core driver, supporting the I2C communication to the device.
> >
> > The MFD driver currently supports the following features:
> > 	- Watchdog
> > 	- LEDs
> >
> > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> > ---
> >  drivers/mfd/Kconfig           |  12 +++
> >  drivers/mfd/Makefile          |   1 +
> >  drivers/mfd/menf21bmc.c       | 220 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/menf21bmc.h |  31 ++++++
> >  4 files changed, 264 insertions(+)
> >  create mode 100644 drivers/mfd/menf21bmc.c
> >  create mode 100644 include/linux/mfd/menf21bmc.h
> >
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > index ab5a43c..7c2e8d2 100644
> > --- a/drivers/mfd/Kconfig
> > +++ b/drivers/mfd/Kconfig
> > @@ -427,6 +427,18 @@ config MFD_MAX8998
> >  	  additional drivers must be enabled in order to use the functionality
> >  	  of the device.
> >
> > +config MFD_MENF21BMC
> > +	tristate "MEN 14F021P00 Board Management Controller Support"
> > +	depends on I2C=y
> > +	select MFD_CORE
> > +	help
> > +	  Say yes here to add support for the MEN 14F021P00 BMC
> > +	  which is a Board Management Controller connected to the I2C bus.
> > +	  This driver provides common support for accessing the devices;
> > +	  additional drivers must be enabled in order to use the
> > +	  functionality of the BMC device.
>
> Would be good if you mention the WD and LED devices here too.
>
> > +
> > +
>
> To many '\n's here.
>
> >  config EZX_PCAP
> >  	bool "Motorola EZXPCAP Support"
> >  	depends on SPI_MASTER
> > diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> > index 5913208..8f2be38 100644
> > --- a/drivers/mfd/Makefile
> > +++ b/drivers/mfd/Makefile
> > @@ -167,3 +167,4 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
> >  obj-$(CONFIG_MFD_AS3722)	+= as3722.o
> >  obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
> >  obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
> > +obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
> > diff --git a/drivers/mfd/menf21bmc.c b/drivers/mfd/menf21bmc.c
> > new file mode 100644
> > index 0000000..8de92b5
> > --- /dev/null
> > +++ b/drivers/mfd/menf21bmc.c
> > @@ -0,0 +1,220 @@
> > +/*
> > + *  MEN 14F021P00 Board Management Controller (BMC) MFD Core Driver.
> > + *
> > + *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
> > + *  Author: Andreas Werner <andreas.werner@men.de>
> > + *  All rights reserved.
> > + *
> > + *  This program is free software; you can redistribute  it and/or modify it
> > + *  under  the terms of  the GNU General  Public License as published by the
> > + *  Free Software Foundation;  either version 2 of the  License, or (at your
> > + *  option) any later version.
> > + *
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/device.h>
> > +#include <linux/module.h>
> > +#include <linux/i2c.h>
> > +#include <linux/mfd/core.h>
> > +#include <linux/mfd/menf21bmc.h>
> > +
> > +#define BMC_CMD_REV_MAJOR	0x80
> > +#define BMC_CMD_REV_MINOR	0x81
> > +#define BMC_CMD_REV_MAIN	0x82
> > +#define BMC_CMD_REV_BUILD	0x83
> > +#define BMC_CMD_REV_VERI	0x84
> > +#define BMC_CMD_WD_ARM_SET	0x18
> > +#define BMC_CMD_WD_ARM_GET	0x19
> > +
> > +static struct mfd_cell menf21bmc_cell[] = {
> > +	{
> > +		.name = "menf21bmc_wd",
>
> I prefer wdog to wd, as it's a little move obvious what we're dealing
> with.
>
> > +	},
> > +	{
> > +		.name = "menf21bmc_led",
> > +	},
> > +};
>
> If these are the only struct attributes, please place them on a single
> line (each).
>
> > +static int
> > +menf21bmc_read_byte_data(struct i2c_client *client, u8 reg)
> > +{
> > +	int ret;
> > +	struct menf21bmc *data = i2c_get_clientdata(client);
> > +
> > +	mutex_lock(&data->lock);
> > +	ret = i2c_smbus_read_byte_data(client, reg);
> > +	mutex_unlock(&data->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int
> > +menf21bmc_read_word_data(struct i2c_client *client, u8 reg)
> > +{
> > +	int ret;
> > +	struct menf21bmc *data = i2c_get_clientdata(client);
> > +
> > +	mutex_lock(&data->lock);
> > +	ret = i2c_smbus_read_word_data(client, reg);
> > +	mutex_unlock(&data->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int menf21bmc_write_byte_data(struct i2c_client *client, u8 reg, u8 val)
> > +{
> > +	int ret;
> > +	struct menf21bmc *data = i2c_get_clientdata(client);
> > +
> > +	mutex_lock(&data->lock);
> > +	ret = i2c_smbus_write_byte_data(client, reg, val);
> > +	mutex_unlock(&data->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int menf21bmc_write_word_data(struct i2c_client *client, u8 reg, u16 val)
> > +{
> > +	int ret;
> > +	struct menf21bmc *data = i2c_get_clientdata(client);
> > +
> > +	mutex_lock(&data->lock);
> > +	ret = i2c_smbus_write_word_data(client, reg, val);
> > +	mutex_unlock(&data->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int menf21bmc_write_byte(struct i2c_client *client, u8 val)
> > +{
> > +	int ret;
> > +	struct menf21bmc *data = i2c_get_clientdata(client);
> > +
> > +	mutex_lock(&data->lock);
> > +	ret = i2c_smbus_write_byte(client, val);
> > +	mutex_unlock(&data->lock);
> > +
> > +	return ret;
> > +}
>
> Didn't we ask you to remove these?  Just make the i2c_smbus_* calls
> from within the driver.  The I2C subsystem conducts its own locking.
> I'm really starting to frown on aggregation for the sake of
> aggregation.  It's just overhead.
>

Correct me if I'm wrong but as far as I remember Guenther asked to retain the
original API, not the remove the "abstraction layer". Once we build a board with
one of these BMCs attached via e.g. SPI we would have to reintroduce it anyways,
in order to re-use these drivers.

Just my 2 cents.


     Johannes
