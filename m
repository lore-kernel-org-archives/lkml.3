Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaBSJf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:35:56 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.173]:54430 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbaBSJfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:35:52 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-13.tower-38.messagelabs.com!1392802547!14378213!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 19 Feb 2014 10:35:48 +0100
Date: Wed, 19 Feb 2014 10:35:42 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers: Introduce MEN Chameleon Bus
Message-ID: <20140219093541.GA16649@jtlinux>
References: <1392737654-22682-1-git-send-email-johannes.thumshirn@men.de>
 <1392737654-22682-2-git-send-email-johannes.thumshirn@men.de>
 <20140218230210.GK31116@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140218230210.GK31116@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Josh,

On Tue, Feb 18, 2014 at 05:02:10PM -0600, Josh Cartwright wrote:
> Hello Johannes,
>
> On Tue, Feb 18, 2014 at 04:34:12PM +0100, Johannes Thumshirn wrote:
> [..]
> > +++ b/drivers/mcb/mcb-core.c
> > @@ -0,0 +1,420 @@
> > +/*
> > + * MEN Chameleon Bus.
> > + *
> > + * Copyright (C) 2013 MEN Mikroelektronik GmbH (www.men.de)
> > + * Author: Johannes Thumshirn <johannes.thumshirn@men.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License as published by the Free
> > + * Software Foundation; version 2 of the License.
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/rwsem.h>
> > +#include <linux/idr.h>
> > +#include <linux/mcb.h>
> > +
> > +static DECLARE_RWSEM(mcb_bus_sem);
>
> Why a rwsemaphore and not a simple mutex?  It doesn't appear like you
> attempt to handle any multiple-reader usecases.

Yup, you're right. It's actually a copy'n'paste from PCI.

>
> > +static DEFINE_IDA(mcb_ida);
> > +
> [..]
> > +static void mcb_release_dev(struct device *dev)
> > +{
> > +	struct mcb_device *mdev = to_mcb_device(dev);
> > +
> > +	down_write(&mcb_bus_sem);
> > +	list_del(&mdev->bus_list);
> > +	up_write(&mcb_bus_sem);
>
> Why even maintain your own list of devices?  Doesn't the bus_type
> already do so for you? (And provides conveniences such as
> bus_for_each_dev, etc).

Again, I looked how PCI handles this stuff and just copied everything I thought it could
be important to me.

>
> > +
> > +	mcb_bus_put(mdev->bus);
> > +	kfree(mdev);
> > +}
> > +
> > +/**
> > + * mcb_device_register() - Register a mcb_device
> > + * @bus: The @mcb_bus of the device
> > + * @dev: The @mcb_device
> > + *
> > + * Register a specific @mcb_device at a @mcb_bus and the system itself.
> > + */
> > +int mcb_device_register(struct mcb_bus *bus, struct mcb_device *dev)
> > +{
> > +	int ret;
> > +	int device_id;
> > +
> > +	device_initialize(&dev->dev);
> > +	dev->dev.bus = &mcb_bus_type;
> > +	dev->dev.parent = bus->dev.parent;
> > +	dev->dev.release = mcb_release_dev;
> > +
> > +
>
> Nit: extraneous line.

Yup.

>
> > +	device_id = dev->id;
> > +	dev_set_name(&dev->dev, "mcb%d-16z%03d-%d:%d:%d",
> > +		bus->bus_nr, device_id, dev->inst, dev->group, dev->var);
> > +
> > +	down_write(&mcb_bus_sem);
> > +	list_add_tail(&dev->bus_list, &bus->devices);
> > +	up_write(&mcb_bus_sem);
>
> Again, unsure why you maintain your own list :(.

See comment above.

>
> > +
> > +	ret = device_add(&dev->dev);
> > +	if (ret < 0) {
> > +		pr_err("Failed registering device 16z%03d on bus mcb%d (%d)\n",
> > +			device_id, bus->bus_nr, ret);
> > +		goto out;
> > +	}
> > +
> > +	return 0;
> > +
> > +out:
> > +
> > +	return ret;
> > +}
> [..]
> > +/**
> > + * mcb_get_irq() - Get device's IRQ number
> > + * @dev: The @mcb_device the IRQ is for
> > + *
> > + * Get the IRQ number of a given @mcb_device.
> > + */
> > +int mcb_get_irq(struct mcb_device *dev)
> > +{
> > +	struct resource *irq = &dev->irq;
> > +
> > +	return irq ? irq->start : -ENXIO;
>
> How could irq ever be NULL?
>

You're right.

> > +}
> > +EXPORT_SYMBOL_GPL(mcb_get_irq);
> > +
> > +static int mcb_init(void)
> > +{
> > +	ida_init(&mcb_ida);
>
> This isn't explicitly necessary (DEFINE_IDA statically initializes the
> ida).
>

Blindly copied from ipack.c. Looks like it should be changed over there as well then.

> > +	return bus_register(&mcb_bus_type);
> > +}
> > +
> > +static void mcb_exit(void)
> > +{
> > +	bus_unregister(&mcb_bus_type);
> > +	ida_destroy(&mcb_ida);
>
> This is also unnecessary.

See comment above.

>
> > +}
> > +
> > +/* mcb must be initialized after PCI but before the chameleon drivers.
> > + * That means we must use some initcall between subsys_initcall and
> > + * device_initcall.
> > + */
> > +fs_initcall(mcb_init);
> > +module_exit(mcb_exit);
> > +
> > +MODULE_DESCRIPTION("MEN Chameleon Bus Driver");
> > +MODULE_AUTHOR("Johannes Thumshirn <johannes.thumshirn@men.de>");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/mcb/mcb-internal.h b/drivers/mcb/mcb-internal.h
> > new file mode 100644
> > index 0000000..ca253e3
> > --- /dev/null
> > +++ b/drivers/mcb/mcb-internal.h
> > @@ -0,0 +1,118 @@
> > +#ifndef __MCB_INTERNAL
> > +#define __MCB_INTERNAL
> > +
> > +#include <linux/types.h>
> > +
> > +#define PCI_VENDOR_ID_MEN		0x1a88
> > +#define PCI_DEVICE_ID_MEN_CHAMELEON	0x4d45
>
> This seems misplaced.  Perhaps it should really be in the PCI carrier
> patch?

Yup.

>
> > +#define CHAMELEON_FILENAME_LEN		12
> > +#define CHAMELEONV2_MAGIC		0xabce
> > +
> [..]
> > +int parse_chameleon_cells(struct mcb_bus *bus, phys_addr_t mapbase,
> > +			  void __iomem *base);
>
> Nit: it'd be nicer if you consistently used the chameleon_ prefix.  That
> is, rename this chameleon_parse_cells(...).
>
> [..]
> > +int parse_chameleon_cells(struct mcb_bus *bus, phys_addr_t mapbase,
> > +			void __iomem *base)
> > +{
> > +	char __iomem *p = base;
> > +	struct chameleon_fpga_header *header;
> > +	uint32_t dtype;
> > +	int num_cells = 0;
> > +	int ret = 0;
> > +	u32 hsize;
> > +
> > +	hsize = sizeof(struct chameleon_fpga_header);
> > +
> > +	header = kzalloc(hsize, GFP_KERNEL);
> > +	if (!header)
> > +		return -ENOMEM;
> > +
> > +	/* Extract header information */
> > +	memcpy_fromio(header, p, hsize);
> > +	/* We only support chameleon v2 at the moment */
> > +	header->magic = le16_to_cpu(header->magic);
> > +	if (header->magic != CHAMELEONV2_MAGIC) {
> > +		pr_err("Unsupported chameleon version 0x%x\n",
> > +				header->magic);
> > +		kfree(header);
> > +		return -ENODEV;
> > +	}
> > +	p += hsize;
> > +
> > +	pr_debug("header->revision = %d\n", header->revision);
> > +	pr_debug("header->model = 0x%x ('%c')\n", header->model,
> > +		header->model);
> > +	pr_debug("header->minor = %d\n", header->minor);
> > +	pr_debug("header->bus_type = 0x%x\n", header->bus_type);
> > +
> > +
> > +	pr_debug("header->magic = 0x%x\n", header->magic);
> > +	pr_debug("header->filename = \"%.*s\"\n", CHAMELEON_FILENAME_LEN,
> > +		header->filename);
> > +
> > +	for_each_chameleon_cell(dtype, p) {
> > +		switch (dtype) {
> > +		case CHAMELEON_DTYPE_GENERAL:
> > +			ret = parse_chameleon_gdd(bus, mapbase, p);
>
> Same comment about using chameleon_ prefix.
>
> > +			if (ret < 0)
> > +				goto out;
> > +			p += sizeof(struct chameleon_gdd);
> > +			break;
> > +		case CHAMELEON_DTYPE_BRIDGE:
> > +			parse_chameleon_bdd(bus, mapbase, p);
>
> And this one, too :).

Agreed for all three above.

>
> [..]
> > +++ b/include/linux/mcb.h
> > @@ -0,0 +1,113 @@
> > +/*
> > + * MEN Chameleon Bus.
> > + *
> > + * Copyright (C) 2014 MEN Mikroelektronik GmbH (www.men.de)
> > + * Author: Johannes Thumshirn <johannes.thumshirn@men.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License as published by the Free
> > + * Software Foundation; version 2 of the License.
> > + */
> > +#ifndef _LINUX_MCB_H
> > +#define _LINUX_MCB_H
> > +
> > +#include <linux/mod_devicetable.h>
> > +#include <linux/device.h>
> > +#include <linux/irqreturn.h>
> > +
> > +struct mcb_driver;
> > +
> > +/**
> > + * struct mcb_bus - MEN Chameleon Bus
> > + *
> > + * @parent: Pointer to carrier device
> > + * @cores: Number of cores available on this bus
>
> Looks like these comments could be updated...

args, yes.

>
> > + * @bus_nr: mcb bus number
> > + */
> > +struct mcb_bus {
> > +	struct list_head node;
> > +	struct list_head devices;
> > +	struct list_head children;
> > +	struct device dev;
> > +	int bus_nr;
> > +};
> > +#define to_mcb_bus(b) container_of((b), struct mcb_bus, dev)
> > +
> > +/**
> > + * struct mcb_device - MEN Chameleon Bus device
> > + *
> > + * @bus_list: internal list handling for bus code
> > + * @dev: device in kernel representation
> > + * @bus: mcb bus the device is plugged to
> > + * @subordinate: subordinate MCBus in case of bridge
> > + * @is_added: flag to check if device is added to bus
> > + * @driver: associated mcb_driver
> > + * @id: mcb device id
> > + * @inst: instance in Chameleon table
> > + * @group: group in Chameleon table
> > + * @var: variant in Chameleon table
> > + * @bar: BAR in Chameleon table
> > + * @rev: revision in Chameleon table
> > + * @irq: IRQ resource
> > + * @memory: memory resource
> > + */
> > +struct mcb_device {
> > +	struct list_head bus_list;
> > +	struct device dev;
> > +	struct mcb_bus *bus;
> > +	struct mcb_bus *subordinate;
> > +	bool is_added;
> > +	struct mcb_driver *driver;
> > +	u16 id;
> > +	int inst;
> > +	int group;
> > +	int var;
> > +	int bar;
> > +	int rev;
> > +	struct resource irq;
> > +	struct resource mem;
> > +};
> > +#define to_mcb_device(x) container_of((x), struct mcb_device, dev)
> > +
> > +struct mcb_driver {
>
> This could probably use a kerneldoc.

Yes.

>
> > +	struct list_head node;
>
> How is this node used?

Again, probably copied from somewhere (probably PCI) and forgotten to validate
if I actually use it.

>
> > +	struct device_driver driver;
> > +	const struct mcb_device_id *id_table;
> > +	int (*probe)(struct mcb_device *mdev, const struct mcb_device_id *id);
> > +	void (*remove)(struct mcb_device *mdev);
> > +	void (*shutdown)(struct mcb_device *mdev);
> > +};
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation


This will be changed in a v2 of this patch. But I'm not sure if I can get to it today,
and then I have 2 days off, so maybe v2 will hit the list on monday, sorry.

Thanks,
Johannes
