Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaGVI4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:56:49 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34041 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbaGVI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:56:45 -0400
Date: Tue, 22 Jul 2014 09:56:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wei-Chun Pan <weichun.pan@advantech.com.tw>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mfd: imanager2: Add Core supports for IT8516/18/28
Message-ID: <20140722085639.GF28529@lee--X1>
References: <1405342486-17031-1-git-send-email-weichun.pan@advantech.com.tw>
 <1405342486-17031-3-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405342486-17031-3-git-send-email-weichun.pan@advantech.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no way that you are introducing a 300 line driver and have
nothing to say about it.  Please put a nice descriptive commit log
here when you resubmit.

> Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
> ---

I also expect to see a change log here and version information in the
$SUBJECT line of the email.  I think the next one is v3 (or is it
v4?), so the start of the subject should read [PATCH v4 x/y].

>  drivers/mfd/Kconfig          |   6 +
>  drivers/mfd/Makefile         |   2 +
>  drivers/mfd/imanager2_core.c | 303 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 311 insertions(+)
>  create mode 100644 drivers/mfd/imanager2_core.c
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3383412..48b063f 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -10,6 +10,12 @@ config MFD_CORE
>  	select IRQ_DOMAIN
>  	default n
>  
> +config MFD_IMANAGER2
> +	tristate "Support for Advantech iManager2 EC ICs"
> +	select MFD_CORE
> +	help
> +	  Support for Advantech iManager2 EC ICs
> +
>  config MFD_CS5535
>  	tristate "AMD CS5535 and CS5536 southbridge core functions"
>  	select MFD_CORE
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 2851275..10c64ae 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -166,3 +166,5 @@ obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
>  obj-$(CONFIG_MFD_AS3711)	+= as3711.o
>  obj-$(CONFIG_MFD_AS3722)	+= as3722.o
>  obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
> +imanager2-objs			:= imanager2_core.o imanager2_ec.o
> +obj-$(CONFIG_MFD_IMANAGER2)	+= imanager2.o

No need to do this.  Just do:

obj-$(CONFIG_MFD_IMANAGER2)	+= imanager2_core.o imanager2_ec.o

> diff --git a/drivers/mfd/imanager2_core.c b/drivers/mfd/imanager2_core.c
> new file mode 100644
> index 0000000..2264d29
> --- /dev/null
> +++ b/drivers/mfd/imanager2_core.c
> @@ -0,0 +1,303 @@
> +/*
> + * imanager2_core.c - MFD core driver of Advantech EC IT8516/18/28
> + * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/imanager2_ec.h>

You need more headers than this.

> +#define DRV_NAME	"imanager2"

No need to #define the driver name.

Just use the string, where you need to use it.

> +#define DRV_VERSION	"4.0.1"

Remove this.

> +static struct mfd_cell imanager2_cells[] = {
> +	{
> +		.name = "imanager2_hwm",
> +	},
> +	{
> +		.name = "imanager2_i2c",
> +	},

Put these on a single line.

> +};
> +
> +enum chips {
> +	it8516 = 0x8516,
> +	it8518 = 0x8518,
> +	it8528 = 0x8528,

s/it/CHIP_IT

> +};

Move this to the top.

> +#define EC_CMD_AUTHENTICATION	0x30

Why is this seperate from the rest of the #defines?

> +static int imanager2_authentication(struct imanager2 *ec)
> +{
> +	u8 tmp;
> +	int ret;
> +
> +	mutex_lock(&ec->lock);
> +
> +	if (inb(EC_IO_PORT_CMD) == 0xFF && inb(EC_IO_PORT_DATA) == 0xFF) {
> +		ret = -ENODEV;
> +		goto unlock;
> +	}
> +
> +	if (inb(EC_IO_PORT_CMD) & IO_FLAG_OBF)
> +		inb(EC_IO_PORT_DATA);	/* initial OBF */

What's OBF?

> +	if (ec_outb_after_ibc0(EC_IO_PORT_CMD, EC_CMD_AUTHENTICATION)) {
> +		ret = -ENODEV;
> +		goto unlock;
> +	}
> +
> +	ret = ec_inb_after_obf1(&tmp);
> +
> +unlock:
> +	mutex_unlock(&ec->lock);
> +
> +	if (ret)
> +		return ret;

Remove this.

> +	if (tmp != 0x95)

... and change this to:

	if (!ret && tmp != 0x95)

But 0x95 should be #defined somewhere.

> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +#define EC_ITE_CHIPID_H8	0x20
> +#define EC_ITE_CHIPID_L8	0x21

Group all of the #defines somewhere.

> +static int imanager2_get_chip_type(struct imanager2 *ec)
> +{
> +	mutex_lock(&ec->lock);
> +
> +	outb(EC_ITE_CHIPID_H8, EC_SIO_CMD);
> +	ec->id = inb(EC_SIO_DATA) << 8;
> +	outb(EC_ITE_CHIPID_L8, EC_SIO_CMD);
> +	ec->id |= inb(EC_SIO_DATA);
> +
> +	mutex_unlock(&ec->lock);
> +
> +	switch (ec->id) {
> +	case it8516:
> +	case it8518:
> +		ec->flag = EC_FLAG_IO;
> +		break;
> +	case it8528:
> +		ec->flag |= EC_FLAG_IO_MAILBOX;
> +		break;
> +	default:

No error message to the user?

> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}

[...]

> +static int __init imanager2_mfd_device_init(void)

Drop the '_mfd_device' part of this.

> +{

All of the code below should be in .probe(), not init().

> +	struct imanager2 ec = { 0 };

Allocate memory instead.

> +	int ret;
> +
> +	mutex_init(&ec.lock);
> +
> +	ret = imanager2_authentication(&ec);
> +	if (ret)

How does the user know what broke?  I don't see any err/warn prints?


> +		return ret;
> +
> +	ret = imanager2_get_chip_type(&ec);
> +	if (ret)
> +		return ret;
> +
> +	ret = imanager2_get_info(&ec);
> +	if (ret)
> +		return ret;
> +
> +	ret = imanager2_build_device_table(&ec);
> +	if (ret)
> +		return ret;
> +
> +	ec_pdev = platform_device_alloc(DRV_NAME, PLATFORM_DEVID_AUTO);
> +	if (!ec_pdev)
> +		return -ENOMEM;
> +
> +	if (!devm_request_region(&ec_pdev->dev, EC_IO_PORT_DATA, 2, DRV_NAME))
> +		return -EIO;
> +
> +	if (!devm_request_region(&ec_pdev->dev, EC_ITE_PORT_OFS, 2, DRV_NAME))
> +		return -EIO;
> +
> +	ret = platform_device_add_data(ec_pdev, &ec, sizeof(struct imanager2));
> +	if (ret)
> +		goto exit_device_put;
> +
> +	ret = platform_device_add(ec_pdev);
> +	if (ret)
> +		goto exit_device_put;

If you convert this driver to be a prober platform device, you can get
rid of all of this above.

> +	ret = mfd_add_devices(&ec_pdev->dev, -1, imanager2_cells,
> +			      ARRAY_SIZE(imanager2_cells), NULL, -1, NULL);
> +	if (ret)
> +		goto exit_device_unregister;
> +
> +	return 0;
> +
> +exit_device_unregister:
> +	platform_device_unregister(ec_pdev);
> +exit_device_put:
> +	platform_device_put(ec_pdev);
> +
> +	return ret;
> +}
> +
> +static void __exit imanager2_mfd_device_exit(void)
> +{
> +	mfd_remove_devices(&ec_pdev->dev);
> +	platform_device_unregister(ec_pdev);
> +}
> +
> +module_init(imanager2_mfd_device_init);
> +module_exit(imanager2_mfd_device_exit);

This is a mess.  Use module_platform_driver() instead.

> +MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at advantech.com>");
> +MODULE_DESCRIPTION("iManager2 platform device definitions v" DRV_VERSION);
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRV_VERSION);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
