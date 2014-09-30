Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaI3Ke0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:34:26 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56687 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaI3KeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:34:24 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 30 Sep 2014 12:31:37 +0200
From: Johan Hovold <johan@kernel.org>
To: Muthu Mani <muth@cypress.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajaram Regupathy <rera@cypress.com>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v2 2/3] i2c: add support for Cypress CYUSBS234 USB-I2C
 adapter
Message-ID: <20140930103137.GA24736@localhost>
References: <1411624275-5557-1-git-send-email-muth@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411624275-5557-1-git-send-email-muth@cypress.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:21:15AM +0530, Muthu Mani wrote:
> Adds support for USB-I2C interface of Cypress Semiconductor
> CYUSBS234 USB-Serial Bridge controller.
> 
> The read/write operation is setup using vendor command through control endpoint
> and actual data transfer happens through bulk in/out endpoints.
> 
> Details about the device can be found at:
> http://www.cypress.com/?rID=84126
> 
> Signed-off-by: Muthu Mani <muth@cypress.com>
> Signed-off-by: Rajaram Regupathy <rera@cypress.com>
> ---
>  drivers/i2c/busses/Kconfig         |  12 +
>  drivers/i2c/busses/Makefile        |   1 +
>  drivers/i2c/busses/i2c-cyusbs23x.c | 514 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 527 insertions(+)
>  create mode 100644 drivers/i2c/busses/i2c-cyusbs23x.c
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 2ac87fa..1fdc6ec 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -848,6 +848,18 @@ config I2C_RCAR
>  
>  comment "External I2C/SMBus adapter drivers"
>  
> +config I2C_CYUSBS23X
> +        tristate "CYUSBS23x I2C adapter"
> +        depends on MFD_CYUSBS23X && USB
> +        help
> +	  Say yes if you would like to access Cypress CYUSBS23x I2C device.
> +
> +	  This driver enables the I2C interface of CYUSBS23x USB Serial Bridge
> +	  controller.
> +
> +	  This driver can also be built as a module. If so, the module will be
> +	  called i2c-cyusbs23x.
> +
>  config I2C_DIOLAN_U2C
>  	tristate "Diolan U2C-12 USB adapter"
>  	depends on USB
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 49bf07e..cbf28cb 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -84,6 +84,7 @@ obj-$(CONFIG_I2C_XLR)		+= i2c-xlr.o
>  obj-$(CONFIG_I2C_RCAR)		+= i2c-rcar.o
>  
>  # External I2C/SMBus adapter drivers
> +obj-$(CONFIG_I2C_CYUSBS23X)	+= i2c-cyusbs23x.o
>  obj-$(CONFIG_I2C_DIOLAN_U2C)	+= i2c-diolan-u2c.o
>  obj-$(CONFIG_I2C_PARPORT)	+= i2c-parport.o
>  obj-$(CONFIG_I2C_PARPORT_LIGHT)	+= i2c-parport-light.o
> diff --git a/drivers/i2c/busses/i2c-cyusbs23x.c b/drivers/i2c/busses/i2c-cyusbs23x.c
> new file mode 100644
> index 0000000..5cf60f0
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-cyusbs23x.c
> @@ -0,0 +1,514 @@
> +/*
> + * I2C subdriver for Cypress CYUSBS234 USB-Serial Bridge controller.
> + * Details about the device can be found at:
> + *    http://www.cypress.com/?rID=84126
> + *
> + * Copyright (c) 2014 Cypress Semiconductor Corporation.
> + *
> + * Author:
> + *   Rajaram Regupathy <rera@cypress.com>
> + *
> + * Additional contributors include:
> + *   Muthu Mani <muth@cypress.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +/*
> + * It exposes sysfs entries under the i2c adapter for getting the i2c transfer
> + * status, reset i2c read/write module, get/set nak and stop bits.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/usb.h>
> +#include <linux/i2c.h>
> +
> +#include <linux/mfd/cyusbs23x.h>
> +
> +#define CY_I2C_MODE_WRITE          1
> +#define CY_I2C_MODE_READ           0

Make this an enum that you pass to get_status and reset.

> +
> +#define CY_I2C_XFER_STATUS_LEN     3
> +
> +struct cyusbs_i2c_config {
> +	u32 frequency;        /* Frequency of operation. Only valid values are
> +				 100KHz and 400KHz */

Multi-line comments should be on the form

	/*
	 * ...
	 */

> +	u8 slave_addr;        /* Slave address to be used when in slave mode */
> +	u8 is_msb_first;      /* Whether to transmit MSB first */
> +	u8 is_master;         /* Whether block is to be configured as a master:
> +				 1 - The block functions as I2C master;
> +				 0 - The block functions as I2C slave */
> +	u8 s_ignore;          /* Ignore general call in slave mode */
> +	u8 clock_stretch;     /* Whether to stretch clock in case of no FIFO
> +				 availability */
> +	u8 is_loopback;       /* Whether to loop back TX data to RX. Valid
> +				 only for debug purposes */
> +	u8 reserved[6];       /* Reserved for future use */
> +} __packed;
> +
> +struct cyusbs_i2c {
> +	struct i2c_adapter i2c_adapter;
> +	struct cyusbs_i2c_config *i2c_config;
> +
> +	bool is_stop_bit;
> +	bool is_nak_bit;

What are these for? Document along with attributes (see below).

Seems like use_ rather than is_ would be more appropriate.

> +};
> +
> +#define to_cyusbs_i2c(a) container_of(a, struct cyusbs_i2c, i2c_adapter)
> +
> +static int cy_i2c_get_status(struct device *d, char *buf, u16 mode);
> +static int cy_i2c_reset(struct device *d, u16 mode);
> +
> +static ssize_t i2c_read_status_show(struct device *d,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	dev_dbg(d, "%s\n", __func__);

Drop this.

> +	return cy_i2c_get_status(d, buf, CY_I2C_MODE_READ);

As already mentioned, you must do some sort of sanity check on the data
returned from the device before passing it to user space. At a minimum
you need to make sure it is null-terminated. Again, it is ascii data you
are reading, right? Please provide some detail.

Note that all sysfs attributes must be documented under
Documentation/ABI so you can provide the description there (including in
what format the status is returned).

> +}
> +
> +static ssize_t i2c_write_status_show(struct device *d,
> +				     struct device_attribute *attr, char *buf)
> +{
> +	dev_dbg(d, "%s\n", __func__);

Drop this.

> +	return cy_i2c_get_status(d, buf, CY_I2C_MODE_WRITE);
> +}
> +
> +static ssize_t i2c_read_reset_store(struct device *d,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t count)
> +{
> +	int ret;
> +
> +	if (((count != 1) && (count != 2 || buf[1] != '\n')) || (buf[0] != '1'))
> +		return -EINVAL;

Use kstrtol (throughout).

> +
> +	dev_dbg(d, "%s\n", __func__);

Drop.

> +	ret = cy_i2c_reset(d, CY_I2C_MODE_READ);
> +

No empty line.

> +	if (!ret)
> +		ret = count;
> +
> +	return ret;
> +}
> +
> +static ssize_t i2c_write_reset_store(struct device *d,
> +				  struct device_attribute *attr,
> +				  const char *buf, size_t count)
> +{
> +	int ret;
> +
> +	if (((count != 1) && (count != 2 || buf[1] != '\n')) || (buf[0] != '1'))
> +		return -EINVAL;
> +
> +	dev_dbg(d, "%s\n", __func__);
> +	ret = cy_i2c_reset(d, CY_I2C_MODE_WRITE);
> +
> +	if (!ret)
> +		ret = count;
> +
> +	return ret;
> +}
> +
> +static ssize_t is_stop_bit_show(struct device *d,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_adapter *adapter = to_i2c_adapter(d);
> +	struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
> +
> +	return sprintf(buf, "%d\n", cy_i2c->is_stop_bit);

Always use scnprintf (and PAGE_SIZE).

> +}
> +
> +static ssize_t is_stop_bit_store(struct device *d,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t count)
> +{
> +	struct i2c_adapter *adapter = to_i2c_adapter(d);
> +	struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
> +
> +	if ((count != 1) && (count != 2 || buf[1] != '\n'))
> +		return -EINVAL;
> +
> +	if (buf[0] == '0')
> +		cy_i2c->is_stop_bit = 0;
> +	else if (buf[0] == '1')
> +		cy_i2c->is_stop_bit = 1;
> +	else
> +		return -EINVAL;
> +
> +	dev_dbg(d, "is_stop_bit=%d buf=%s\n", cy_i2c->is_stop_bit, buf);

Drop.

> +
> +	return count;
> +}
> +
> +static ssize_t is_nak_bit_show(struct device *d,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_adapter *adapter = to_i2c_adapter(d);
> +	struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
> +
> +	return sprintf(buf, "%d\n", cy_i2c->is_nak_bit);
> +}
> +
> +static ssize_t is_nak_bit_store(struct device *d,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct i2c_adapter *adapter = to_i2c_adapter(d);
> +	struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
> +
> +	if ((count != 1) && (count != 2 || buf[1] != '\n'))
> +		return -EINVAL;
> +
> +	if (buf[0] == '0')
> +		cy_i2c->is_nak_bit = 0;
> +	else if (buf[0] == '1')
> +		cy_i2c->is_nak_bit = 1;
> +	else
> +		return -EINVAL;
> +
> +	dev_dbg(d, "is_nak_bit=%d buf=%s\n", cy_i2c->is_nak_bit, buf);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR_RO(i2c_read_status);
> +static DEVICE_ATTR_RO(i2c_write_status);
> +static DEVICE_ATTR_WO(i2c_read_reset);
> +static DEVICE_ATTR_WO(i2c_write_reset);
> +static DEVICE_ATTR_RW(is_stop_bit);
> +static DEVICE_ATTR_RW(is_nak_bit);
> +
> +static struct attribute *cyusbs_i2c_device_attrs[] = {
> +	&dev_attr_i2c_read_status.attr,
> +	&dev_attr_i2c_write_status.attr,
> +	&dev_attr_i2c_read_reset.attr,
> +	&dev_attr_i2c_write_reset.attr,
> +	&dev_attr_is_stop_bit.attr,
> +	&dev_attr_is_nak_bit.attr,
> +	NULL
> +};
> +
> +ATTRIBUTE_GROUPS(cyusbs_i2c_device);
> +
> +static int cy_i2c_get_status(struct device *d, char *buf, u16 mode)

Cast the struct device * to struct cyusbs23x * in the accessor functions
and pass that instead (even if it adds a couple of lines).

> +{
> +	int ret;
> +	u16 wIndex, wValue, scb_index;
> +	struct i2c_adapter *adapter = to_i2c_adapter(d);
> +	struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
> +	char *data;
> +
> +	scb_index = cyusbs->intf_num & 0x01;

Why is the least significant bit important here (see my question about
interface layout in my comments to PATCH 1/3)?

> +	wValue = ((scb_index << CY_SCB_INDEX_POS) | mode);
> +	wIndex = 0;
> +	data = kmalloc(CY_I2C_XFER_STATUS_LEN, GFP_KERNEL);

Error handling missing.

> +
> +	mutex_lock(&cyusbs->lock);

Locking not needed.

> +	/* read the i2c transfer status */
> +	ret = usb_control_msg(cyusbs->usb_dev,
> +			usb_rcvctrlpipe(cyusbs->usb_dev, 0),
> +			CY_I2C_GET_STATUS_CMD,
> +			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +			wValue, wIndex, data, CY_I2C_XFER_STATUS_LEN, 2000);

Use a define for the timeout (throughout).

Error handling missing.

> +	mutex_unlock(&cyusbs->lock);
> +
> +	memcpy(buf, data, CY_I2C_XFER_STATUS_LEN);
> +	kfree(data);
> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s: %02x %02x %02x\n", __func__,
> +		buf[0], buf[1], buf[2]);

Use the i2c rather than interface device here (and below).

> +	return ret;
> +}
> +
> +static int cy_i2c_reset(struct device *d, u16 mode)
> +{
> +	int ret;
> +	u16 wIndex, wValue, scb_index;
> +	struct i2c_adapter *adapter = to_i2c_adapter(d);
> +	struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
> +
> +	scb_index = cyusbs->intf_num & 0x01;
> +	wValue = ((scb_index << CY_SCB_INDEX_POS) | mode);
> +	wIndex = 0;
> +
> +	mutex_lock(&cyusbs->lock);

Locking not needed.

> +	ret = usb_control_msg(cyusbs->usb_dev,
> +			usb_sndctrlpipe(cyusbs->usb_dev, 0),
> +			CY_I2C_RESET_CMD,
> +			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
> +			wValue, wIndex, NULL, 0, 2000);
> +	mutex_unlock(&cyusbs->lock);
> +	dev_dbg(d, "%s: %d\n", __func__, ret);

Drop.

> +	return ret;

Error handling missing (dev_err).

You shouldn't leak usb specific error codes to user space here. Use
usb_translate_errors().

> +}
> +
> +static int cy_get_i2c_config(struct cyusbs23x *cyusbs,
> +				struct cyusbs_i2c *cy_i2c)
> +{
> +	int ret;
> +	u16 scb_index;
> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s\n", __func__);
> +
> +	scb_index = (cyusbs->intf_num & 0x01) << CY_SCB_INDEX_POS;
> +
> +	mutex_lock(&cyusbs->lock);

Not needed.

> +	ret = usb_control_msg(cyusbs->usb_dev,
> +			usb_rcvctrlpipe(cyusbs->usb_dev, 0),
> +			CY_I2C_GET_CONFIG_CMD,
> +			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +			scb_index, 0, cy_i2c->i2c_config,
> +			sizeof(*cy_i2c->i2c_config), 2000);
> +	mutex_unlock(&cyusbs->lock);

Error handling + usb_translate_errors().

> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s: %d, 0x%02x, %d, %d, %d, %d, %d\n",
> +		__func__, cy_i2c->i2c_config->frequency,
> +		cy_i2c->i2c_config->slave_addr,
> +		cy_i2c->i2c_config->is_msb_first,
> +		cy_i2c->i2c_config->is_master,
> +		cy_i2c->i2c_config->s_ignore,
> +		cy_i2c->i2c_config->clock_stretch,
> +		cy_i2c->i2c_config->is_loopback);

Please add some description of the values (e.g. "master = %d")-

> +	return ret;
> +}
> +
> +static int cy_i2c_set_data_config(struct cyusbs23x *cyusbs,
> +				  struct cyusbs_i2c *cy_i2c, u16 slave_addr,
> +				  u16 length, u8 command)
> +{
> +	int ret;
> +	u16 wIndex, wValue;
> +	u16 scb_index;
> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s\n", __func__);

i2c dev

> +
> +	scb_index = (cyusbs->intf_num & 0x01) << 7;

Different shift here (i.e. not CY_SCB_INDEX_POS)?

> +	slave_addr = (slave_addr & 0x7F) | scb_index;
> +	wValue = cy_i2c->is_stop_bit | cy_i2c->is_nak_bit << 1;
> +	wValue |= (slave_addr << 8);
> +	wIndex = length;
> +
> +	dev_dbg(&cyusbs->usb_intf->dev,
> +		"%s, cmd=0x%x,val=0x%x,idx=0x%x\n",

Add some whitespace to the message.

> +		__func__, command, wValue, wIndex);
> +
> +	ret = usb_control_msg(cyusbs->usb_dev,
> +		usb_sndctrlpipe(cyusbs->usb_dev, 0),
> +		command, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
> +		wValue, wIndex, NULL, 0, 2000);
> +
> +	return ret;
> +}
> +
> +static int cy_i2c_read(struct cyusbs23x *cyusbs, struct i2c_msg *msgs)
> +{
> +	int ret, actual_read_len = 0;

One declaration per line (especially when initialising).

> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s\n", __func__);

i2c dev

> +
> +	ret = usb_bulk_msg(cyusbs->usb_dev,
> +		usb_rcvbulkpipe(cyusbs->usb_dev, cyusbs->bulk_in_ep_num),
> +		msgs[0].buf,
> +		msgs[0].len,
> +		&actual_read_len, 5000);
> +
> +	if (ret)
> +		dev_dbg(&cyusbs->usb_intf->dev,
> +			"read %d/%d returned %d\n",
> +			actual_read_len, msgs[0].len, ret);

dev err, add braces

> +
> +	return ret;
> +}
> +
> +static int cy_i2c_write(struct cyusbs23x *cyusbs, struct i2c_msg *msgs)
> +{
> +	int ret, actual_write_len = 0;
> +
> +	dev_dbg(&cyusbs->usb_intf->dev, "%s\n", __func__);
> +
> +	ret = usb_bulk_msg(cyusbs->usb_dev,
> +		usb_sndbulkpipe(cyusbs->usb_dev, cyusbs->bulk_out_ep_num),
> +		msgs[0].buf,
> +		msgs[0].len,
> +		&actual_write_len, 5000);
> +
> +	if (ret)
> +		dev_dbg(&cyusbs->usb_intf->dev,
> +			"write %d/%d returned %d\n",
> +			actual_write_len, msgs[0].len, ret);
> +
> +	return ret;
> +}
> +
> +static int cy_i2c_xfer(struct i2c_adapter *adapter,
> +		       struct i2c_msg *msgs, int num)
> +{
> +	int ret = 0;
> +	struct cyusbs_i2c *cy_i2c;
> +	struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
> +
> +	dev_dbg(&adapter->dev, "%s\n", __func__);
> +
> +	if (num > 1) {
> +		dev_err(&adapter->dev, "i2c_msg number is > 1\n");
> +		return -EIO;
> +	}

Please lift this limitation, as I mentioned before. 

> +
> +	cy_i2c = to_cyusbs_i2c(adapter);
> +
> +	mutex_lock(&cyusbs->lock);

Locking really needed? Are you trying to prevent a reset through sysfs
while transferring? Why not simply let the transfer fail in that case?

> +	if (msgs[0].flags & I2C_M_RD) {
> +		dev_dbg(&adapter->dev,
> +			"I2C read requested for addr 0x%02x, data length %d\n",
> +			msgs[0].addr, msgs[0].len);
> +
> +		ret = cy_i2c_set_data_config(cyusbs, cy_i2c, msgs[0].addr,
> +				msgs[0].len, CY_I2C_READ_CMD);
> +

No empty lines (before checking return values throughout).

> +		if (ret < 0) {
> +			dev_err(&adapter->dev,
> +				"Set Config (read) failed with %d\n", ret);
> +			goto io_error;
> +		}
> +
> +		ret = cy_i2c_read(cyusbs, msgs);
> +		if (ret) {
> +			dev_err(&adapter->dev,
> +				"Read failed with error code %d\n", ret);
> +			goto io_error;
> +		}
> +	} else {
> +		dev_dbg(&adapter->dev,
> +			"I2C write requested for addr 0x%02x, data length %d\n",
> +			msgs[0].addr, msgs[0].len);
> +
> +		ret = cy_i2c_set_data_config(cyusbs, cy_i2c, msgs[0].addr,
> +				msgs[0].len, CY_I2C_WRITE_CMD);
> +
> +		if (ret < 0) {
> +			dev_err(&adapter->dev,
> +			"Set Config (write) failed with %d\n", ret);
> +			goto io_error;
> +		}
> +
> +		ret = cy_i2c_write(cyusbs, msgs);
> +		if (ret) {
> +			dev_err(&adapter->dev,
> +				"Write failed with error code %d\n", ret);
> +			goto io_error;
> +		}
> +	}
> +	mutex_unlock(&cyusbs->lock);
> +	return ret;
> +
> +io_error:
> +	mutex_unlock(&cyusbs->lock);
> +	return ret;
> +}
> +
> +static u32 cy_i2c_func(struct i2c_adapter *adapter)
> +{
> +	dev_dbg(&adapter->dev, "%s\n", __func__);

Drop the debug.

> +	return I2C_FUNC_I2C;

Isn't this too limited?

> +}
> +
> +static const struct i2c_algorithm i2c_cyusbs23x_algorithm = {
> +	.master_xfer	= cy_i2c_xfer,
> +	.functionality	= cy_i2c_func,
> +};
> +
> +static int cyusbs23x_i2c_probe(struct platform_device *pdev)
> +{
> +	struct cyusbs23x *cyusbs;
> +	struct cyusbs_i2c *cy_i2c;
> +	int ret = 0;
> +
> +	dev_dbg(&pdev->dev, "%s\n", __func__);
> +
> +	cyusbs = dev_get_drvdata(pdev->dev.parent);
> +
> +	cy_i2c = devm_kzalloc(&pdev->dev, sizeof(*cy_i2c), GFP_KERNEL);
> +	if (cy_i2c == NULL)
> +		return -ENOMEM;
> +
> +	cy_i2c->i2c_config = kmalloc(sizeof(struct cyusbs_i2c_config),
> +					GFP_KERNEL);

Don't mix devres allocation and kmalloc here. Stick to either (e.g.
devres and simplify the error paths).

> +	if (cy_i2c->i2c_config == NULL)
> +		return -ENOMEM;
> +
> +	cy_i2c->is_stop_bit = 1;
> +	cy_i2c->is_nak_bit = 1;
> +
> +	cy_i2c->i2c_adapter.owner = THIS_MODULE;
> +	cy_i2c->i2c_adapter.class = I2C_CLASS_HWMON;
> +	cy_i2c->i2c_adapter.algo = &i2c_cyusbs23x_algorithm;
> +	cy_i2c->i2c_adapter.algo_data = cyusbs;
> +	snprintf(cy_i2c->i2c_adapter.name, sizeof(cy_i2c->i2c_adapter.name),
> +			"cyusbs23x_i2c at bus %03d dev %03d intf %03d",
> +			cyusbs->usb_dev->bus->busnum, cyusbs->usb_dev->devnum,
> +			cyusbs->intf_num);'
> +	cy_i2c->i2c_adapter.dev.parent = &pdev->dev;
> +	cy_i2c->i2c_adapter.dev.groups = cyusbs_i2c_device_groups;
> +
> +	ret = cy_get_i2c_config(cyusbs, cy_i2c);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "error to get i2c config\n");
> +		goto error;
> +	}
> +
> +	if (!cy_i2c->i2c_config->is_master) {
> +		ret = -EIO;

-ENODEV

> +		dev_err(&pdev->dev, "not an I2C master\n");
> +		goto error;
> +	}
> +
> +	ret = i2c_add_adapter(&cy_i2c->i2c_adapter);
> +	if (ret != 0) {
> +		dev_err(&pdev->dev, "failed to add i2c adapter\n");
> +		goto error;
> +	}
> +
> +	platform_set_drvdata(pdev, cy_i2c);
> +
> +	dev_dbg(&pdev->dev, "added I2C adapter\n");
> +	return 0;
> +
> +error:
> +	dev_dbg(&pdev->dev, "error occured %d\n", ret);
> +	kfree(cy_i2c->i2c_config);
> +	return ret;
> +}
> +
> +static int cyusbs23x_i2c_remove(struct platform_device *pdev)
> +{
> +	struct cyusbs_i2c *cy_i2c = platform_get_drvdata(pdev);
> +
> +	dev_dbg(&pdev->dev, "%s\n", __func__);
> +	kfree(cy_i2c->i2c_config);

Even if this is not an issue in this case, do not release any adapter
data until after you've removed it.

> +	i2c_del_adapter(&cy_i2c->i2c_adapter);
> +	return 0;
> +}
> +
> +static struct platform_driver cyusbs23x_i2c_driver = {
> +	.driver.name	= "cyusbs23x-i2c",
> +	.driver.owner	= THIS_MODULE,
> +	.probe		= cyusbs23x_i2c_probe,
> +	.remove		= cyusbs23x_i2c_remove,
> +};
> +
> +module_platform_driver(cyusbs23x_i2c_driver);
> +
> +MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
> +MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
> +MODULE_DESCRIPTION("I2C adapter driver for CYUSBS23x");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:cyusbs23x-i2c");

Johan
