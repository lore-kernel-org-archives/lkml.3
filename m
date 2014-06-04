Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaFDM6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:58:19 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.163]:52611 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbaFDM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:58:17 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-2.tower-38.messagelabs.com!1401886672!20589006!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 04 Jun 2014 14:57:53 +0200
Date: Wed, 4 Jun 2014 15:50:22 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Lee Jones <lee.jones@linaro.org>
CC: Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <johannes.thumshirn@men.de>
Subject: Re: [PATCH v2 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
Message-ID: <20140604135022.GA382@awelinux>
References: <cover.1401181010.git.andreas.werner@men.de>
 <a3cd43562effd2580d0174c56eff5584791217ac.1401181010.git.andreas.werner@men.de>
 <20140527150547.GA4227@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140527150547.GA4227@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
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

I will ad WD and LED and fix the \n.

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

I agree.

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

Ok i'll change that.

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

I'll remove that.

> > +static int menf21bmc_wd_leave_prod_mode(struct i2c_client *client)
> > +{
> > +	int val, ret;
> > +
> > +	val = menf21bmc_read_byte_data(client, BMC_CMD_WD_ARM_GET);
> 
> ARM like the processor, or 'arm' as in "arm the missile", or something
> else?
> 

I will change that name.

> > +	if (val < 0)
> > +		return val;
> > +
> > +	/*
> > +	 * Production mode should be not active after delivery of the Board.
> > +	 * To be sure we check it, inform the user and leave the mode
> > +	 * if active.
> > +	 */
> 
> I prefer the term 'exit', as 'leave' is ambiguous.  It could read
> "leave it in production mode", or "leave (exit) production mode".
> 

I agree.

> > +	if (val == 0x00) {
> > +		dev_info(&client->dev,
> > +			"BMC in production mode. Leave production mode\n");
> > +
> > +		ret = menf21bmc_write_byte(client, BMC_CMD_WD_ARM_SET);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +menf21bmc_probe(struct i2c_client *client, const struct i2c_device_id *ids)
> > +{
> > +	int ret;
> > +	struct menf21bmc *data;
> > +	int rev_major, rev_minor, rev_main;
> > +
> > +	if (!i2c_check_functionality(client->adapter,
> > +						I2C_FUNC_SMBUS_BYTE_DATA |
> > +						I2C_FUNC_SMBUS_WORD_DATA |
> > +						I2C_FUNC_SMBUS_BYTE))
> 
> Tabbing is off.  Try to line up with the '('.
> 

I agree.

> > +		return -EIO;
> 
> -ENODEV is more common.

I agree.

> 
> > +	data = devm_kzalloc(&client->dev, sizeof(struct menf21bmc), GFP_KERNEL);
> 
> s/sizeof(struct menf21bmc)/sizeof(*data)/
> 
> data doesn't tend to be a good name for a variable.
> 
> > +	if (data == NULL)
> 
> if (!data)
> 
> > +		return -ENOMEM;
> > +
> > +	mutex_init(&data->lock);
> > +
> > +	i2c_set_clientdata(client, data);
> > +	data->client = client;
> > +	data->read_word_data = menf21bmc_read_word_data;
> > +	data->read_byte_data = menf21bmc_read_byte_data;
> > +	data->write_word_data = menf21bmc_write_word_data;
> > +	data->write_byte_data = menf21bmc_write_byte_data;
> > +	data->write_byte = menf21bmc_write_byte;
> 
> Yuck, please remove these.
>

Yes will be removed.
 
> > +	rev_major = menf21bmc_read_word_data(client, BMC_CMD_REV_MAJOR);
> > +	if (rev_major < 0) {
> > +		dev_err(&client->dev, "failed to get BMC major revision\n");
> > +		return rev_major;
> > +	}
> > +
> > +	rev_minor = menf21bmc_read_word_data(client, BMC_CMD_REV_MINOR);
> > +	if (rev_minor < 0) {
> > +		dev_err(&client->dev, "failed to get BMC minor revision\n");
> > +		return rev_minor;
> > +	}
> > +
> > +	rev_main = menf21bmc_read_word_data(client, BMC_CMD_REV_MAIN);
> > +	if (rev_main < 0) {
> > +		dev_err(&client->dev, "failed to get BMC main revision\n");
> > +		return rev_main;
> > +	}
> > +
> > +	dev_info(&client->dev, "FW Revision: %02d.%02d.%02d\n",
> > +					rev_major, rev_minor, rev_main);
> > +
> > +	/*
> > +	 * We have to leave the Production Mode of the BMC to activate the
> > +	 * Watchdog functionality and the BIOS life sign monitoring.
> > +	 */
> > +	ret = menf21bmc_wd_leave_prod_mode(client);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "failed to leave production mode\n");
> > +		return ret;
> > +	}
> 
> Is it possible that someone might want to use production mode?
> 

No it is just for the board bring up. Because if the BIOS does not implement
the Life sign the BMC will not start the Board. Production mode is
active after programming the PIC.

> > +	ret = mfd_add_devices(&client->dev, 0, menf21bmc_cell,
> > +				ARRAY_SIZE(menf21bmc_cell), NULL, 0, NULL);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "mfd_add_devices failed\n");
> 
> This error message should be more useful to the user.
> 
> E.g. "Failed to add sub-devices"
> 

I'll change that.

> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int menf21bmc_remove(struct i2c_client *client)
> > +{
> > +	mfd_remove_devices(&client->dev);
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id menf21bmc_id_table[] = {
> > +	{"menf21bmc", 0},
> 
> Please add a ' ' after '{' and before '}'.
> 

I agree.

> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, menf21bmc_id_table);
> > +
> > +static struct i2c_driver menf21bmc_driver = {
> > +	.driver		= {
> > +		.name	= "menf21bmc",
> > +		.owner	= THIS_MODULE,
> > +	},
> > +	.id_table	= menf21bmc_id_table,
> > +	.probe		= menf21bmc_probe,
> > +	.remove		= menf21bmc_remove,
> > +};
> > +
> > +module_i2c_driver(menf21bmc_driver);
> > +
> > +MODULE_DESCRIPTION("MEN 14F021P00 BMC mfd core driver");
> > +MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de");
> 
> Missing '>'.

I'll change that.

> 
> > +MODULE_LICENSE("GPL");
> > diff --git a/include/linux/mfd/menf21bmc.h b/include/linux/mfd/menf21bmc.h
> > new file mode 100644
> > index 0000000..1fc9b5c
> > --- /dev/null
> > +++ b/include/linux/mfd/menf21bmc.h
> > @@ -0,0 +1,31 @@
> > +/*
> > + *  MEN 14F021P00 Board Management Controller (BMC)
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
> > +#ifndef MENF21BMC_H
> > +#define MENF21BMC_H
> > +
> > +struct menf21bmc {
> > +	struct i2c_client *client;
> > +	struct mutex lock;
> > +
> > +	int (*read_word_data)(struct i2c_client *client, u8 reg);
> > +	int (*read_byte_data)(struct i2c_client *client, u8 reg);
> > +	int (*write_word_data)(struct i2c_client *client, u8 reg, u16 val);
> > +	int (*write_byte_data)(struct i2c_client *client, u8 reg, u8 val);
> > +	int (*write_byte)(struct i2c_client *client, u8 val);
> > +};
> > +
> > +#endif /* MENF21BMC_H */
> > +
> > +
> 
> Too many '\n's here.
>

I'll change that.
 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog


Thanks.
Andy
