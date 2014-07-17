Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaGQMmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:42:08 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:47204 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbaGQMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:42:04 -0400
Date: Thu, 17 Jul 2014 13:41:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andreas Werner <andreas.werner@men.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, cooloney@gmail.com,
        rpurdie@rpsys.net, linux-leds@vger.kernel.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
Message-ID: <20140717124156.GF30888@lee--X1>
References: <cover.1405602280.git.andreas.werner@men.de>
 <e035a8a5211769e610a1337dc786f2fcc8dfd14d.1405602280.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e035a8a5211769e610a1337dc786f2fcc8dfd14d.1405602280.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Andreas Werner wrote:
> The MEN 14F021P00 Board Management Controller provides an
> I2C interface to the host to access the feature implemented in the BMC.
> The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
> and on a few Box/Display Computer.
> 
> Added MFD Core driver, supporting the I2C communication to the device.
> 
> The MFD driver currently supports the following features:
>  	- Watchdog
>  	- LEDs
> 
> Signed-off-by: Andreas Werner <andreas.werner@men.de>
> ---
>  drivers/mfd/Kconfig     |  12 +++++
>  drivers/mfd/Makefile    |   1 +
>  drivers/mfd/menf21bmc.c | 136 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 149 insertions(+)
>  create mode 100644 drivers/mfd/menf21bmc.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b8d9ca0..6e2cd14 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -453,6 +453,18 @@ config MFD_MAX8998
>  	  additional drivers must be enabled in order to use the functionality
>  	  of the device.
>  
> +config MFD_MENF21BMC
> +	tristate "MEN 14F021P00 Board Management Controller Support"
> +	depends on I2C=y
> +	select MFD_CORE
> +	help
> +	  Say yes here to add support for the MEN 14F021P00 BMC
> +	  which is a Board Management Controller connected to the I2C bus.
> +	  The device supports multiple sub-devices like LED and WDT.
> +	  This driver provides common support for accessing the devices;
> +	  additional drivers must be enabled in order to use the
> +	  functionality of the BMC device.

Can you mention what those devices are here in the help text?

>  config EZX_PCAP
>  	bool "Motorola EZXPCAP Support"
>  	depends on SPI_MASTER
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 4e2bc25..37bf336 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -169,6 +169,7 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
>  obj-$(CONFIG_MFD_AS3722)	+= as3722.o
>  obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
>  obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
> +obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
>  
>  intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
>  obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
> diff --git a/drivers/mfd/menf21bmc.c b/drivers/mfd/menf21bmc.c
> new file mode 100644
> index 0000000..76f94cd
> --- /dev/null
> +++ b/drivers/mfd/menf21bmc.c
> @@ -0,0 +1,136 @@
> +/*
> + *  MEN 14F021P00 Board Management Controller (BMC) MFD Core Driver.
> + *
> + *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
> + *  Author: Andreas Werner <andreas.werner@men.de>
> + *  All rights reserved.

This normally resides wit the company, rather than the author.

> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *

Remove this line.

> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/core.h>
> +
> +#define BMC_CMD_REV_MAJOR	0x80
> +#define BMC_CMD_REV_MINOR	0x81
> +#define BMC_CMD_REV_MAIN	0x82
> +#define BMC_CMD_WDT_EXIT_PROD	0x18
> +#define BMC_CMD_WDT_PROD_STAT	0x19

If these are in the same address space, can you order them by number.

> +static struct mfd_cell menf21bmc_cell[] = {
> +	{ .name = "menf21bmc_wdt", },
> +	{ .name = "menf21bmc_led", },
> +};
> +
> +static int menf21bmc_wdt_exit_prod_mode(struct i2c_client *client)
> +{
> +	int val, ret;
> +
> +	val = i2c_smbus_read_byte_data(client, BMC_CMD_WDT_PROD_STAT);
> +	if (val < 0)
> +		return val;
> +
> +	/*
> +	 * Production mode should be not active after delivery of the Board.
> +	 * To be sure we check it, inform the user and exit the mode
> +	 * if active.
> +	 */
> +	if (val == 0x00) {
> +		dev_info(&client->dev,
> +			"BMC in production mode. Exit production mode\n");
> +
> +		ret = i2c_smbus_write_byte(client, BMC_CMD_WDT_EXIT_PROD);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +menf21bmc_probe(struct i2c_client *client, const struct i2c_device_id *ids)
> +{
> +	int ret;
> +	int rev_major, rev_minor, rev_main;
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_SMBUS_BYTE_DATA |
> +				     I2C_FUNC_SMBUS_WORD_DATA |
> +				     I2C_FUNC_SMBUS_BYTE))

Can you take the function call out of the if() please?

> +		return -ENODEV;
> +
> +	rev_major = i2c_smbus_read_word_data(client, BMC_CMD_REV_MAJOR);
> +	if (rev_major < 0) {
> +		dev_err(&client->dev, "failed to get BMC major revision\n");
> +		return rev_major;
> +	}
> +
> +	rev_minor = i2c_smbus_read_word_data(client, BMC_CMD_REV_MINOR);
> +	if (rev_minor < 0) {
> +		dev_err(&client->dev, "failed to get BMC minor revision\n");
> +		return rev_minor;
> +	}
> +
> +	rev_main = i2c_smbus_read_word_data(client, BMC_CMD_REV_MAIN);
> +	if (rev_main < 0) {
> +		dev_err(&client->dev, "failed to get BMC main revision\n");
> +		return rev_main;
> +	}
> +
> +	dev_info(&client->dev, "FW Revision: %02d.%02d.%02d\n",
> +					rev_major, rev_minor, rev_main);
> +
> +	/*
> +	 * We have to exit the Production Mode of the BMC to activate the
> +	 * Watchdog functionality and the BIOS life sign monitoring.
> +	 */
> +	ret = menf21bmc_wdt_exit_prod_mode(client);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed to leave production mode\n");
> +		return ret;
> +	}
> +
> +	ret = mfd_add_devices(&client->dev, 0, menf21bmc_cell,
> +				ARRAY_SIZE(menf21bmc_cell), NULL, 0, NULL);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed to add BMC sub-devices\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int menf21bmc_remove(struct i2c_client *client)
> +{
> +	mfd_remove_devices(&client->dev);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id menf21bmc_id_table[] = {
> +	{ "menf21bmc", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, menf21bmc_id_table);
> +
> +static struct i2c_driver menf21bmc_driver = {
> +	.driver		= {
> +		.name	= "menf21bmc",
> +		.owner	= THIS_MODULE,

Remove this line, it's handled elsewhere.

> +	},
> +	.id_table	= menf21bmc_id_table,
> +	.probe		= menf21bmc_probe,
> +	.remove		= menf21bmc_remove,
> +};
> +
> +module_i2c_driver(menf21bmc_driver);
> +
> +MODULE_DESCRIPTION("MEN 14F021P00 BMC mfd core driver");
> +MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
> +MODULE_LICENSE("GPL");

The header says that this is GPL v2.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
