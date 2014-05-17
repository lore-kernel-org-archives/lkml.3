Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbaEQPrz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:47:55 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61780 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbaEQPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:47:53 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5377849E.7020001@roeck-us.net>
Date: Sat, 17 May 2014 08:47:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andreas Werner <andreas.werner@men.de>, linux-kernel@vger.kernel.org
CC: sameo@linux.intel.com, lee.jones@linaro.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org, cooloney@gmail.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org, johannes.thumshirn@men.de,
        thomas.schnuerer@men.de, wernerandy@gmx.de
Subject: Re: [PATCH 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00 BMC
 MFD Core driver
References: <cover.1400258021.git.andreas.werner@men.de> <58de41a38511a107941d9c3b2cea314c0becfff7.1400258021.git.andreas.werner@men.de>
In-Reply-To: <58de41a38511a107941d9c3b2cea314c0becfff7.1400258021.git.andreas.werner@men.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 09:37 AM, Andreas Werner wrote:
> The MEN 14F021P00 Board Management Controller provides an
> I2C interface to the host to access the feature implemented in the BMC.
> The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
> and on a few Box/Display Computer.
>
> Added MFD Core driver, supporting the I2C communication to the device.
>
> The MFD driver currently supports the following features:
> 	- Watchdog
> 	- LEDs
>
> Signed-off-by: Andreas Werner <andreas.werner@men.de>
> ---
>   drivers/mfd/Kconfig           |  12 +++
>   drivers/mfd/Makefile          |   1 +
>   drivers/mfd/menf21bmc.c       | 193 ++++++++++++++++++++++++++++++++++++++++++
>   include/linux/mfd/menf21bmc.h |  32 +++++++
>   4 files changed, 238 insertions(+)
>   create mode 100644 drivers/mfd/menf21bmc.c
>   create mode 100644 include/linux/mfd/menf21bmc.h
>
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index ab5a43c..7c2e8d2 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -427,6 +427,18 @@ config MFD_MAX8998
>   	  additional drivers must be enabled in order to use the functionality
>   	  of the device.
>
> +config MFD_MENF21BMC
> +	tristate "MEN 14F021P00 Board Management Controller Support"
> +	depends on I2C=y
> +	select MFD_CORE
> +	help
> +	  Say yes here to add support for the MEN 14F021P00 BMC
> +	  which is a Board Management Controller connected to the I2C bus.
> +	  This driver provides common support for accessing the devices;
> +	  additional drivers must be enabled in order to use the
> +	  functionality of the BMC device.
> +
> +
>   config EZX_PCAP
>   	bool "Motorola EZXPCAP Support"
>   	depends on SPI_MASTER
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 5913208..8f2be38 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -167,3 +167,4 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
>   obj-$(CONFIG_MFD_AS3722)	+= as3722.o
>   obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
>   obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
> +obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
> diff --git a/drivers/mfd/menf21bmc.c b/drivers/mfd/menf21bmc.c
> new file mode 100644
> index 0000000..77de1a8
> --- /dev/null
> +++ b/drivers/mfd/menf21bmc.c
> @@ -0,0 +1,193 @@
> +/*
> + *  MEN 14F021P00 Board Management Controller (BMC) MFD Core Driver.
> + *
> + *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
> + *  Author: Andreas Werner <andreas.werner@men.de>
> + *  All rights reserved.
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/menf21bmc.h>
> +
> +#define BMC_CMD_REV_MAJOR	0x80
> +#define BMC_CMD_REV_MINOR	0x81
> +#define BMC_CMD_REV_MAIN	0x82
> +#define BMC_CMD_REV_BUILD	0x83
> +#define BMC_CMD_REV_VERI	0x84
> +
> +static struct mfd_cell menf21bmc_cell[] = {
> +	{
> +		.name = "menf21bmc_wd",
> +	},
> +	{
> +		.name = "menf21bmc_led",
> +	},
> +};
> +
> +static int
> +menf21bmc_read_byte_data(struct i2c_client *client, u8 reg, uint8_t *val)
> +{
> +	int ret;
> +	struct menf21bmc *data = i2c_get_clientdata(client);
> +
> +	mutex_lock(&data->lock);
> +	ret = i2c_smbus_read_byte_data(client, reg);
> +	mutex_unlock(&data->lock);
> +
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed to read byte at 0x%02x\n", reg);
> +		return ret;
> +	}
> +
> +	*val = (uint8_t)ret;
> +
> +	return 0;
> +}
> +
I personally would prefer if you would retain the original API, which returns both value
and error code as return value. I don't see the benefit of changing the API as you did -
it just complicates the code.

Thanks,
Guenter

