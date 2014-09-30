Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaI3JIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:08:53 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:38848 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaI3JIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:08:49 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 30 Sep 2014 11:06:06 +0200
From: Johan Hovold <johan@kernel.org>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajaram Regupathy <rera@cypress.com>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v2 1/3] mfd: add support for Cypress CYUSBS234 USB Serial
 Bridge controller
Message-ID: <20140930090606.GA17834@localhost>
References: <1411624212-5515-1-git-send-email-muth@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411624212-5515-1-git-send-email-muth@cypress.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:20:12AM +0530, Muthu Mani wrote:
> Adds support for USB-I2C/GPIO interfaces of Cypress Semiconductor
> CYUSBS234 USB-Serial Bridge controller.
> 
> Details about the device can be found at:
> http://www.cypress.com/?rID=84126
> 
> Signed-off-by: Muthu Mani <muth@cypress.com>
> Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> ---
>  drivers/mfd/Kconfig           |  12 +++
>  drivers/mfd/Makefile          |   1 +
>  drivers/mfd/cyusbs23x.c       | 190 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/cyusbs23x.h |  57 +++++++++++++
>  4 files changed, 260 insertions(+)
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
> index 0000000..cf2d53b
> --- /dev/null
> +++ b/drivers/mfd/cyusbs23x.c
> @@ -0,0 +1,190 @@
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
> +/*
> + * This is core MFD driver for Cypress Semiconductor CYUSBS234 USB-Serial
> + * Bridge controller. CYUSBS234 offers a single channel serial interface
> + * (I2C/SPI/UART). It can be configured to enable either of I2C, SPI, UART
> + * interfaces. The GPIOs are also available to access.
> + * Details about the device can be found at:
> + *    http://www.cypress.com/?rID=84126
> + *
> + * Separate cell drivers are available for I2C and GPIO. SPI and UART are not
> + * supported yet. All GPIOs are exposed for get operation. However, only
> + * unused GPIOs can be set.
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

Drop this.

> +
> +	iface_desc = interface->cur_altsetting;
> +
> +	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> +
> +		dev_dbg(&interface->dev, "%s %d/%d\n",
> +			__func__, i, iface_desc->desc.bNumEndpoints);

Drop this one as well. lsusb can always be used to give the endpoint
configuration (count).

> +
> +		ep = &iface_desc->endpoint[i].desc;
> +
> +		if (!cyusbs->bulk_in_ep_num &&
> +			usb_endpoint_is_bulk_in(ep)) {

Indent continuation lines at least two tabs (throughout).

But why are you even breaking this one? Merge the lines and remove the
braces.

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

Add some descriptions to these values (e.g. "bulk_out = %d")?

> +		__func__, cyusbs->intr_in_ep_num ,
> +		cyusbs->bulk_in_ep_num, cyusbs->bulk_out_ep_num);
> +
> +	if (!cyusbs->bulk_in_ep_num || !cyusbs->bulk_out_ep_num ||
> +		!cyusbs->intr_in_ep_num)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
> +static int cyusbs23x_probe(struct usb_interface *interface,
> +			   const struct usb_device_id *id)
> +{
> +	struct cyusbs23x *cyusbs;
> +	const struct mfd_cell *cyusbs23x_devs;
> +	int ret, mfd_id, ndevs = 0;
> +	u8 sub_class;
> +
> +	cyusbs = kzalloc(sizeof(*cyusbs), GFP_KERNEL);
> +	if (cyusbs == NULL)
> +		return -ENOMEM;
> +
> +	mutex_init(&cyusbs->lock);
> +
> +	cyusbs->usb_dev = usb_get_dev(interface_to_usbdev(interface));
> +	cyusbs->usb_intf = interface;
> +	cyusbs->intf_num = interface->cur_altsetting->desc.bInterfaceNumber;
> +
> +	ret = update_ep_details(interface, cyusbs);
> +	if (ret < 0) {
> +		dev_err(&interface->dev, "invalid interface\n");
> +		goto error;
> +	}
> +
> +	usb_set_intfdata(interface, cyusbs);
> +
> +	dev_dbg(&interface->dev,
> +		"binding to %02x:%02x, in bus %03d address %03d\n",
> +		le16_to_cpu(cyusbs->usb_dev->descriptor.idVendor),
> +		le16_to_cpu(cyusbs->usb_dev->descriptor.idProduct),
> +		cyusbs->usb_dev->bus->busnum,
> +		cyusbs->usb_dev->devnum);

This information has already been logged by usb core.

> +
> +	sub_class = interface->cur_altsetting->desc.bInterfaceSubClass;

Great. Thanks for fixing this.

Could describe how the device is put into the different serial modes
and what happens with the descriptors when you do? Are you always using
the same interface, but only its subclass changes?

Could you provide lsusb -v output for the three modes?

> +	switch (sub_class) {
> +	case CY_USBS_SCB_I2C:
> +		dev_dbg(&interface->dev, "I2C interface found\n");

Make this an info message instead as it could be useful to know what
mode the device is configured for.

> +		cyusbs23x_devs = cyusbs23x_i2c_devs;
> +		ndevs = ARRAY_SIZE(cyusbs23x_i2c_devs);
> +		break;
> +	default:
> +		dev_err(&interface->dev, "unsupported subclass\n");
> +		ret = -ENODEV;
> +		goto error;
> +	}
> +
> +	mfd_id = cyusbs->usb_dev->bus->busnum << 16 |
> +			cyusbs->usb_dev->devnum << 8 | cyusbs->intf_num;

Do you really expect more than one MFD per USB device? Otherwise the
intf_num bit would be unnecessary.

Either way, after giving this some more thought, I think you should just
use PLATFORM_DEVID_AUTO as id. I have submitted a series to fix the
other USB MFD drivers and add a convenience helper to register
hotpluggable MFDs here:

	http://marc.info/?l=linux-kernel&m=141172912516884&w=2

> +	ret = mfd_add_devices(&interface->dev, mfd_id, cyusbs23x_devs,
> +				ndevs, NULL, 0, NULL);
> +	if (ret != 0) {
> +		dev_err(&interface->dev, "Failed to add mfd devices to core\n");
> +		goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	usb_set_intfdata(interface, NULL);

This is not needed.

> +	usb_put_dev(cyusbs->usb_dev);
> +	kfree(cyusbs);
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

Not needed.

> +	usb_put_dev(cyusbs->usb_dev);
> +	kfree(cyusbs);
> +
> +	dev_dbg(&interface->dev, "disconnected\n");a
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

As I already commented on v1, this is not a description and version
numbers does not make sense for in-kernel drivers (the kernel version is
what matters).

Please add a module description or remove it completely.

> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/cyusbs23x.h b/include/linux/mfd/cyusbs23x.h
> new file mode 100644
> index 0000000..0b71825
> --- /dev/null
> +++ b/include/linux/mfd/cyusbs23x.h
> @@ -0,0 +1,57 @@
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
> +	struct usb_device *usb_dev;
> +	struct usb_interface *usb_intf;
> +	struct mutex lock;
> +
> +	u8 intf_num;
> +	u8 bulk_in_ep_num;
> +	u8 bulk_out_ep_num;
> +	u8 intr_in_ep_num;
> +};
> +
> +enum cy_vendor_cmds {
> +	CY_I2C_GET_CONFIG_CMD  = 0xC4,
> +	CY_I2C_SET_CONFIG_CMD  = 0xC5,
> +	CY_I2C_WRITE_CMD       = 0xC6,
> +	CY_I2C_READ_CMD        = 0xC7,
> +	CY_I2C_GET_STATUS_CMD  = 0xC8,
> +	CY_I2C_RESET_CMD       = 0xC9,
> +	CY_GPIO_GET_CONFIG_CMD = 0xD8,
> +	CY_GPIO_SET_CONFIG_CMD = 0xD9,
> +	CY_GPIO_GET_VALUE_CMD  = 0xDA,
> +	CY_GPIO_SET_VALUE_CMD  = 0xDB,
> +};

If you don't have a reason to do otherwise, please split these up and
define in each driver directly.

> +
> +enum cy_scb_modes {
> +	CY_USBS_SCB_DISABLED = 0,
> +	CY_USBS_SCB_UART = 1,
> +	CY_USBS_SCB_SPI = 2,
> +	CY_USBS_SCB_I2C = 3
> +};
> +
> +#define CY_SCB_INDEX_POS      15

Will this also be needed by a SPI and UART driver? Please add a comment
above about what it is for.

> +
> +#endif /* __MFD_CYUSBS23X_H__ */

Johan
