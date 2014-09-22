Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaIVLBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:01:16 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:54894 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVLBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:01:13 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 22 Sep 2014 12:58:40 +0200
From: Johan Hovold <johan@kernel.org>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajaram Regupathy <rera@cypress.com>
Subject: Re: [PATCH 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Message-ID: <20140922105840.GE5237@localhost>
References: <1411378372-18351-1-git-send-email-muth@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411378372-18351-1-git-send-email-muth@cypress.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:02:52PM +0530, Muthu Mani wrote:
> Adds support for USB-I2C/GPIO interfaces of Cypress Semiconductor
> CYUSBS234 USB-Serial Bridge controller.
> 
> Details about the device can be found at:
> http://www.cypress.com/?rID=84126

Ok, so this is a bit of an odd bird.

First of all it has a single channel serial interface and is not even
configured in i2c mode by default. The three modes uart, i2c, and spi
are mutually exclusive and switching modes and pin configuration appears
to require a Cypress (proprietary?) tool.

You currently expose all 12 pins as gpios although some of these would
be allocated for the serial interface. It appears this information could
(should) be retrieved from flash at probe time.

You should probably also read-out the preprogrammed mode and let the
i2c-subdriver's probe fail unless in i2c mode.

> 
> Signed-off-by: Muthu Mani <muth@cypress.com>
> Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> ---
>  drivers/mfd/Kconfig           |  12 ++++
>  drivers/mfd/Makefile          |   1 +
>  drivers/mfd/cyusbs23x.c       | 163 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/cyusbs23x.h |  51 +++++++++++++
>  4 files changed, 227 insertions(+)
>  create mode 100644 drivers/mfd/cyusbs23x.c
>  create mode 100644 include/linux/mfd/cyusbs23x.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf2..a31e9e3 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -116,6 +116,18 @@ config MFD_ASIC3
>  	  This driver supports the ASIC3 multifunction chip found on many
>  	  PDAs (mainly iPAQ and HTC based ones)
>  
> +config MFD_CYUSBS23X
> +        tristate "Cypress CYUSBS23x USB Serial Bridge controller"
> +	select MFD_CORE
> +	depends on USB
> +	default n
> +	help
> +	  Say yes here if you want support for Cypress Semiconductor
> +	  CYUSBS23x USB-Serial Bridge controller.
> +
> +	  This driver can also be built as a module. If so, the module will be
> +	  called cyusbs23x.
> +
>  config PMIC_DA903X
>  	bool "Dialog Semiconductor DA9030/DA9034 PMIC Support"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..fc5bcd1 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -151,6 +151,7 @@ si476x-core-y := si476x-cmd.o si476x-prop.o si476x-i2c.o
>  obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
>  
>  obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
> +obj-$(CONFIG_MFD_CYUSBS23X)     += cyusbs23x.o
>  obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
>  obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
>  obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
> diff --git a/drivers/mfd/cyusbs23x.c b/drivers/mfd/cyusbs23x.c
> new file mode 100644
> index 0000000..824f020
> --- /dev/null
> +++ b/drivers/mfd/cyusbs23x.c
> @@ -0,0 +1,163 @@
> +/*
> + * Cypress USB-Serial Bridge Controller USB adapter driver
> + *
> + * Copyright (c) 2014 Cypress Semiconductor Corporation.
> + *
> + * Author:
> + *   Muthu Mani <muth@cypress.com>
> + *
> + * Additional contributors include:
> + *   Rajaram Regupathy <rera@cypress.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/cyusbs23x.h>
> +
> +#include <linux/usb.h>
> +
> +static const struct usb_device_id cyusbs23x_usb_table[] = {
> +	{ USB_DEVICE(0x04b4, 0x0004) },   /* Cypress Semiconductor */
> +	{ }                               /* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, cyusbs23x_usb_table);
> +
> +static const struct mfd_cell cyusbs23x_i2c_devs[] = {
> +	{
> +		.name = "cyusbs23x-i2c",
> +	},
> +	{
> +		.name = "cyusbs23x-gpio",
> +	},
> +};
> +
> +static int update_ep_details(struct usb_interface *interface,
> +				struct cyusbs23x *cyusbs)
> +{
> +	struct usb_host_interface *iface_desc;
> +	struct usb_endpoint_descriptor *ep;
> +	int i;
> +
> +	dev_dbg(&interface->dev, "%s\n", __func__);
> +
> +	iface_desc = interface->cur_altsetting;
> +
> +	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> +
> +		dev_dbg(&interface->dev, "%s %d/%d\n",
> +			__func__, i, iface_desc->desc.bNumEndpoints);
> +
> +		ep = &iface_desc->endpoint[i].desc;
> +
> +		if (!cyusbs->bulk_in_ep_num &&
> +			usb_endpoint_is_bulk_in(ep)) {
> +			cyusbs->bulk_in_ep_num = ep->bEndpointAddress;
> +		}
> +		if (!cyusbs->bulk_out_ep_num &&
> +			usb_endpoint_is_bulk_out(ep)) {
> +			cyusbs->bulk_out_ep_num = ep->bEndpointAddress;
> +		}
> +		if (!cyusbs->intr_in_ep_num &&
> +			usb_endpoint_is_int_in(ep)) {
> +			cyusbs->intr_in_ep_num = ep->bEndpointAddress;
> +		}
> +	}
> +
> +	dev_dbg(&interface->dev, "%s %d, %d, %d\n",
> +		__func__, cyusbs->intr_in_ep_num ,
> +		cyusbs->bulk_in_ep_num, cyusbs->bulk_out_ep_num);
> +
> +	if (!cyusbs->bulk_in_ep_num || !cyusbs->bulk_out_ep_num ||
> +		!cyusbs->intr_in_ep_num)
> +		return -EINVAL;

-ENODEV

> +
> +	return 0;
> +}
> +
> +static int cyusbs23x_probe(struct usb_interface *interface,
> +			   const struct usb_device_id *id)
> +{
> +	struct cyusbs23x *cyusbs;
> +	int ret;
> +
> +	cyusbs = kzalloc(sizeof(*cyusbs), GFP_KERNEL);
> +	if (cyusbs == NULL)
> +		return -ENOMEM;
> +
> +	mutex_init(&cyusbs->lock);
> +
> +	cyusbs->usb_dev = usb_get_dev(interface_to_usbdev(interface));
> +	cyusbs->usb_intf = interface;
> +
> +	ret = update_ep_details(interface, cyusbs);
> +	if (ret < 0) {
> +		dev_err(&interface->dev, "invalid interface\n");
> +		goto error;
> +	}
> +
> +	/* save our data pointer in this interface device */
> +	usb_set_intfdata(interface, cyusbs);
> +	dev_set_drvdata(&cyusbs->pdev.dev, cyusbs);

This makes no sense as you have no platform device.

> +
> +	dev_dbg(&interface->dev,
> +		"binding to %02x:%02x, in bus %03d address %03d\n",
> +		le16_to_cpu(cyusbs->usb_dev->descriptor.idVendor),
> +		le16_to_cpu(cyusbs->usb_dev->descriptor.idProduct),
> +		cyusbs->usb_dev->bus->busnum,
> +		cyusbs->usb_dev->devnum);
> +
> +	ret = mfd_add_devices(&interface->dev, -1, cyusbs23x_i2c_devs,

You need to use a unique id here or you cannot have more than one of
these adapters connected at the same time. Use

	busnum << 8 | devnum

for now.
	
> +				ARRAY_SIZE(cyusbs23x_i2c_devs), NULL, 0, NULL);
> +	if (ret != 0) {
> +		dev_err(&interface->dev, "Failed to add mfd devices to core\n");
> +		goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	if (cyusbs) {

cyusbs is never NULL here.

> +		usb_put_dev(cyusbs->usb_dev);
> +		kfree(cyusbs);
> +	}
> +
> +	return ret;
> +}
> +
> +static void cyusbs23x_disconnect(struct usb_interface *interface)
> +{
> +	struct cyusbs23x *cyusbs = usb_get_intfdata(interface);
> +
> +	mfd_remove_devices(&interface->dev);
> +	usb_set_intfdata(interface, NULL);
> +	usb_put_dev(cyusbs->usb_dev);
> +	kfree(cyusbs);
> +
> +	dev_dbg(&interface->dev, "disconnected\n");
> +}
> +
> +static struct usb_driver cyusbs23x_usb_driver = {
> +	.name           = "cyusbs23x",
> +	.probe          = cyusbs23x_probe,
> +	.disconnect     = cyusbs23x_disconnect,
> +	.id_table       = cyusbs23x_usb_table,
> +};
> +
> +module_usb_driver(cyusbs23x_usb_driver);
> +
> +MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
> +MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
> +MODULE_DESCRIPTION("CYUSBS23x driver v0.1");
> +MODULE_LICENSE("GPL");
> +
> diff --git a/include/linux/mfd/cyusbs23x.h b/include/linux/mfd/cyusbs23x.h
> new file mode 100644
> index 0000000..f2d37d4
> --- /dev/null
> +++ b/include/linux/mfd/cyusbs23x.h
> @@ -0,0 +1,51 @@
> +/*
> + * Cypress USB-Serial Bridge Controller definitions
> + *
> + * Copyright (c) 2014 Cypress Semiconductor Corporation.
> + *
> + * Author:
> + *   Muthu Mani <muth@cypress.com>
> + *
> + * Additional contributors include:
> + *   Rajaram Regupathy <rera@cypress.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#ifndef __MFD_CYUSBS23X_H__
> +#define __MFD_CYUSBS23X_H__
> +
> +#include <linux/types.h>
> +#include <linux/usb.h>
> +
> +/* Structure to hold all device specific stuff */
> +struct cyusbs23x {
> +	struct usb_device *usb_dev; /* the usb device for this device */
> +	struct usb_interface *usb_intf; /* the usb interface for this device */

Drop the comments.

> +	struct mutex lock;
> +	struct platform_device pdev;

The usb interface driver has no platform device.

> +
> +	__u8 bulk_in_ep_num;
> +	__u8 bulk_out_ep_num;
> +	__u8 intr_in_ep_num;

Use u8

> +};
> +
> +enum CY_VENDOR_CMDS {

lower case

> +	CY_I2C_GET_CONFIG_CMD = 0xC4,
> +	CY_I2C_SET_CONFIG_CMD = 0xC5,
> +	CY_I2C_WRITE_CMD,

initialise all explicitly

> +	CY_I2C_READ_CMD,
> +	CY_I2C_GET_STATUS_CMD,
> +	CY_I2C_RESET_CMD,
> +	CY_GPIO_GET_CONFIG_CMD = 0xD8,
> +	CY_GPIO_SET_CONFIG_CMD,
> +	CY_GPIO_GET_VALUE_CMD,
> +	CY_GPIO_SET_VALUE_CMD,
> +
> +} CY_VENDOR_CMDS;

Sure you don't want to define a global enum here.

> +
> +#define CY_SCB_INDEX_POS      15
> +
> +#endif /* __MFD_CYUSBS23X_H__ */

Johan
