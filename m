Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab3J2QwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:52:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44028 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3J2QwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:52:17 -0400
Message-ID: <526FE7BF.1060402@codeaurora.org>
Date: Tue, 29 Oct 2013 09:52:15 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v3 02/10] spmi: Linux driver framework for SPMI
References: <cover.1382985169.git.joshc@codeaurora.org> <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org>
In-Reply-To: <149bbfe89e37376cc176c3aeb6c1fab9e4fd2b91.1382985169.git.joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 11:12, Josh Cartwright wrote:
> diff --git a/drivers/spmi/Kconfig b/drivers/spmi/Kconfig
> new file mode 100644
> index 0000000..a03835f
> --- /dev/null
> +++ b/drivers/spmi/Kconfig
> @@ -0,0 +1,9 @@
> +#
> +# SPMI driver configuration
> +#
> +menuconfig SPMI
> +	bool "SPMI support"

Can we do tristate?

> +	help
> +	  SPMI (System Power Management Interface) is a two-wire
> +	  serial interface between baseband and application processors
> +	  and Power Management Integrated Circuits (PMIC).
> diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
> new file mode 100644
> index 0000000..0780bd4
> --- /dev/null
> +++ b/drivers/spmi/spmi.c
> @@ -0,0 +1,491 @@
> +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/idr.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/spmi.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +
> +#include <dt-bindings/spmi/spmi.h>
> +
> +static DEFINE_MUTEX(ctrl_idr_lock);
> +static DEFINE_IDR(ctrl_idr);
> +
> +static void spmi_dev_release(struct device *dev)
> +{
> +	struct spmi_device *sdev = to_spmi_device(dev);
> +	kfree(sdev);
> +}
> +
> +static struct device_type spmi_dev_type = {
> +	.release	= spmi_dev_release,

const?

> +};
> +
> +static void spmi_ctrl_release(struct device *dev)
> +{
> +	struct spmi_controller *ctrl = to_spmi_controller(dev);
> +	mutex_lock(&ctrl_idr_lock);
> +	idr_remove(&ctrl_idr, ctrl->nr);
> +	mutex_unlock(&ctrl_idr_lock);
> +	kfree(ctrl);
> +}
> +
> +static struct device_type spmi_ctrl_type = {

const?

> +	.release	= spmi_ctrl_release,
> +};
> +
[...]
> +
> +/*
> + * register read/write: 5-bit address, 1 byte of data
> + * extended register read/write: 8-bit address, up to 16 bytes of data
> + * extended register read/write long: 16-bit address, up to 8 bytes of data
> + */
> +
> +int spmi_register_read(struct spmi_device *sdev, u8 addr, u8 *buf)
> +{
> +	/* 5-bit register address */
> +	if (addr > 0x1F)

Perhaps 0x1f should be a #define.

> +		return -EINVAL;
> +
> +	return spmi_read_cmd(sdev->ctrl, SPMI_CMD_READ, sdev->usid, addr, 0,
> +			     buf);
> +}
> +EXPORT_SYMBOL_GPL(spmi_register_read);
> +
[...]
> +struct spmi_controller *spmi_controller_alloc(struct device *parent,
> +					      size_t size)
> +{
> +	struct spmi_controller *ctrl;
> +	int id;
> +
> +	if (WARN_ON(!parent))
> +		return NULL;
> +
> +	ctrl = kzalloc(sizeof(*ctrl) + size, GFP_KERNEL);
> +	if (!ctrl)
> +		return NULL;
> +
> +	device_initialize(&ctrl->dev);
> +	ctrl->dev.type = &spmi_ctrl_type;
> +	ctrl->dev.bus = &spmi_bus_type;
> +	ctrl->dev.parent = parent;
> +	ctrl->dev.of_node = parent->of_node;
> +	spmi_controller_set_drvdata(ctrl, &ctrl[1]);
> +
> +	idr_preload(GFP_KERNEL);
> +	mutex_lock(&ctrl_idr_lock);
> +	id = idr_alloc(&ctrl_idr, ctrl, 0, 0, GFP_NOWAIT);
> +	mutex_unlock(&ctrl_idr_lock);
> +	idr_preload_end();

This can just be:

    mutex_lock(&ctrl_idr_lock);
    id = idr_alloc(&ctrl_idr, ctrl, 0, 0, GFP_KERNEL);
    mutex_unlock(&ctrl_idr_lock);

> +
> +	if (id < 0) {
> +		dev_err(parent,
> +			"unable to allocate SPMI controller identifier.\n");
> +		spmi_controller_put(ctrl);
> +		return NULL;
> +	}
> +
> +	ctrl->nr = id;
> +	dev_set_name(&ctrl->dev, "spmi-%d", id);
> +
> +	dev_dbg(&ctrl->dev, "allocated controller 0x%p id %d\n", ctrl, id);
> +	return ctrl;
> +}
> +EXPORT_SYMBOL_GPL(spmi_controller_alloc);
> +
> +static int of_spmi_register_devices(struct spmi_controller *ctrl)
> +{
> +	struct device_node *node;
> +	int err;
> +
> +	dev_dbg(&ctrl->dev, "of_spmi_register_devices\n");

Could be

    dev_dbg(&ctrl->dev, "%s", __func__);

so that function renaming is transparent.

> +
> +	if (!ctrl->dev.of_node)
> +		return -ENODEV;
> +
> +	dev_dbg(&ctrl->dev, "looping through children\n");
> +
> +	for_each_available_child_of_node(ctrl->dev.of_node, node) {
> +		struct spmi_device *sdev;
> +		u32 reg[2];
> +
> +		dev_dbg(&ctrl->dev, "adding child %s\n", node->full_name);
> +
> +		err = of_property_read_u32_array(node, "reg", reg, 2);
> +		if (err) {
> +			dev_err(&ctrl->dev,
> +				"node %s does not have 'reg' property\n",
> +				node->full_name);
> +				continue;
> +		}
> +
> +		if (reg[1] != SPMI_USID) {
> +			dev_err(&ctrl->dev,
> +				"node %s contains unsupported 'reg' entry\n",
> +				node->full_name);
> +			continue;
> +		}
> +
> +		if (reg[0] > 0xF) {

Perhaps call this MAX_USID?

> +			dev_err(&ctrl->dev,
> +				"invalid usid on node %s\n",
> +				node->full_name);
> +			continue;
> +		}
> +
[...]
> diff --git a/include/linux/spmi.h b/include/linux/spmi.h
> new file mode 100644
> index 0000000..29cf0c9
> --- /dev/null
> +++ b/include/linux/spmi.h
> @@ -0,0 +1,342 @@
> +/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#ifndef _LINUX_SPMI_H
> +#define _LINUX_SPMI_H
> +
> +#include <linux/types.h>
> +#include <linux/device.h>
> +#include <linux/mod_devicetable.h>
> +
> +/* Maximum slave identifier */
> +#define SPMI_MAX_SLAVE_ID		16
> +
> +/* SPMI Commands */
> +#define SPMI_CMD_EXT_WRITE		0x00
> +#define SPMI_CMD_RESET			0x10
> +#define SPMI_CMD_SLEEP			0x11
> +#define SPMI_CMD_SHUTDOWN		0x12
> +#define SPMI_CMD_WAKEUP			0x13
> +#define SPMI_CMD_AUTHENTICATE		0x14
> +#define SPMI_CMD_MSTR_READ		0x15
> +#define SPMI_CMD_MSTR_WRITE		0x16
> +#define SPMI_CMD_TRANSFER_BUS_OWNERSHIP	0x1A
> +#define SPMI_CMD_DDB_MASTER_READ	0x1B
> +#define SPMI_CMD_DDB_SLAVE_READ		0x1C
> +#define SPMI_CMD_EXT_READ		0x20
> +#define SPMI_CMD_EXT_WRITEL		0x30
> +#define SPMI_CMD_EXT_READL		0x38
> +#define SPMI_CMD_WRITE			0x40
> +#define SPMI_CMD_READ			0x60
> +#define SPMI_CMD_ZERO_WRITE		0x80
> +
> +/**
> + * Client/device handle (struct spmi_device):

This isn't kernel-doc format.

> + *  This is the client/device handle returned when a SPMI device
> + *  is registered with a controller.
> + *  Pointer to this structure is used by client-driver as a handle.
> + *  @dev: Driver model representation of the device.
> + *  @ctrl: SPMI controller managing the bus hosting this device.
> + *  @usid: Unique Slave IDentifier.
> + */
> +struct spmi_device {
> +	struct device		dev;
> +	struct spmi_controller	*ctrl;
> +	u8			usid;
> +};
> +#define to_spmi_device(d) container_of(d, struct spmi_device, dev)
> +
> +static inline void *spmi_device_get_drvdata(const struct spmi_device *sdev)
> +{
> +	return dev_get_drvdata(&sdev->dev);
> +}
> +
> +static inline void spmi_device_set_drvdata(struct spmi_device *sdev, void *data)
> +{
> +	dev_set_drvdata(&sdev->dev, data);
> +}
> +
> +/**
> + * spmi_controller_alloc: Allocate a new SPMI controller

There should be a dash here instead of colon.

> + * @ctrl: associated controller
> + *
> + * Caller is responsible for either calling spmi_device_add() to add the
> + * newly allocated controller, or calling spmi_device_put() to discard it.
> + */
> +struct spmi_device *spmi_device_alloc(struct spmi_controller *ctrl);
> +
> +static inline void spmi_device_put(struct spmi_device *sdev)
> +{
> +	if (sdev)
> +		put_device(&sdev->dev);
> +}
> +
[...]
> +
> +/**
> + * spmi_controller_alloc: Allocate a new SPMI controller
> + * @parent: parent device
> + * @size: size of private data
> + *
> + * Caller is responsible for either calling spmi_controller_add() to add the
> + * newly allocated controller, or calling spmi_controller_put() to discard it.
> + */
> +struct spmi_controller *spmi_controller_alloc(struct device *parent,
> +					      size_t size);
> +
> +static inline void spmi_controller_put(struct spmi_controller *ctrl)
> +{
> +	if (ctrl)
> +		put_device(&ctrl->dev);
> +}

This function is missing documentation.

> +
> +/**
> + * spmi_controller_add: Controller bring-up.
> + * @ctrl: controller to be registered.
> + *
> + * Register a controller previously allocated via spmi_controller_alloc() with
> + * the SPMI core
> + */
> +int spmi_controller_add(struct spmi_controller *ctrl);
[...]
> +
> +/**
> + * spmi_driver_unregister - reverse effect of spmi_driver_register
> + * @sdrv: the driver to unregister
> + * Context: can sleep
> + */
> +static inline void spmi_driver_unregister(struct spmi_driver *sdrv)
> +{
> +	if (sdrv)
> +		driver_unregister(&sdrv->driver);
> +}
> +
> +#define module_spmi_driver(__spmi_driver) \
> +	module_driver(__spmi_driver, spmi_driver_register, \
> +			spmi_driver_unregister)
> +
> +/**
> + * spmi_register_read() - register read

This is right but then it's not consistent. These functions have ()
after them but higher up we don't have that.

Usually the prototypes aren't documented because people use tags and
such to go to the definition of the function. I would prefer we put the
documentation near the implementation so that 1) this file gives a high
level overview of the API and 2) I don't have to double jump with tags
to figure out what to pass to these functions.

> + * @sdev: SPMI device
> + * @addr: slave register address (5-bit address).
> + * @buf: buffer to be populated with data from the Slave.
> + *
> + * Reads 1 byte of data from a Slave device register.
> + */
> +int spmi_register_read(struct spmi_device *sdev, u8 addr, u8 *buf);
> +

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

