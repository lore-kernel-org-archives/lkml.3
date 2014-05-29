Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaE2DD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:03:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:36491 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbaE2DD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:03:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,932,1392192000"; 
   d="scan'208";a="546521554"
Subject: Re: [PATCH char-misc-next 2/8] misc: mic: add a bus driver for
 virtual MIC devices
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
In-Reply-To: <20140528205049.GA10468@kroah.com>
References: <cover.1401239759.git.sudeep.dutt@intel.com>
	 <07b374763197000963b1161e0fce0c3254ce8a0d.1401239759.git.sudeep.dutt@intel.com>
	 <20140528205049.GA10468@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 May 2014 19:56:35 -0700
Message-ID: <1401332195.18473.42.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 13:50 -0700, Greg Kroah-Hartman wrote: 
> On Tue, May 27, 2014 at 07:36:11PM -0700, Sudeep Dutt wrote:
> > +int register_mbus_driver(struct mbus_driver *driver)
> > +{
> > +	driver->driver.bus = &mic_bus;
> > +	return driver_register(&driver->driver);
> > +}
> > +EXPORT_SYMBOL_GPL(register_mbus_driver);
> 
> mbus_register_driver()?
> 

The idea was to follow the register_virtio_driver(..) naming convention
but will rename as your suggestion is better.

> > +void unregister_mbus_driver(struct mbus_driver *driver)
> > +{
> > +	driver_unregister(&driver->driver);
> > +}
> > +EXPORT_SYMBOL_GPL(unregister_mbus_driver);
> 
> mbus_unregister_driver()?

Will rename.

> 
> > +int register_mbus_device(struct mbus_device *dev)
> 
> mbus_register_device()?
> 
> Trying to keep the kernel namespace sane.

Will rename.

> 
> Why doesn't this function create the device structure?
> 

The mbus_device containing the device structure is allocated by the
driver calling this API. However that creates other issues as you
highlighted below. It is better to allocate mbus_device here so that it
can be freed in the device release callback correctly by the bus driver.

> > +{
> > +	int err;
> > +
> > +	dev->dev.bus = &mic_bus;
> > +
> > +	/* Assign a unique device index and hence name. */
> > +	err = ida_simple_get(&mbus_index_ida, 0, 0, GFP_KERNEL);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	dev->index = err;
> > +	dev_set_name(&dev->dev, "mbus-dev%u", dev->index);
> > +	/*
> > +	 * device_register() causes the bus infrastructure to look for a
> > +	 * matching driver.
> > +	 */
> > +	err = device_register(&dev->dev);
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(register_mbus_device);
> > +
> > +void unregister_mbus_device(struct mbus_device *dev)
> > +{
> > +	int index = dev->index; /* save for after device release */
> > +
> > +	device_unregister(&dev->dev);
> > +	ida_simple_remove(&mbus_index_ida, index);
> > +}
> > +EXPORT_SYMBOL_GPL(unregister_mbus_device);
> > +
> > +static int __init mbus_init(void)
> > +{
> > +	return bus_register(&mic_bus);
> > +}
> > +
> > +static void __exit mbus_exit(void)
> > +{
> > +	bus_unregister(&mic_bus);
> > +}
> > +
> > +core_initcall(mbus_init);
> > +module_exit(mbus_exit);
> > +
> > +MODULE_AUTHOR("Intel Corporation");
> > +MODULE_DESCRIPTION("Intel(R) MIC Bus driver");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/include/linux/mic_bus.h b/include/linux/mic_bus.h
> > new file mode 100644
> > index 0000000..8297573
> > --- /dev/null
> > +++ b/include/linux/mic_bus.h
> > @@ -0,0 +1,148 @@
> > +/*
> > + * Intel MIC Platform Software Stack (MPSS)
> > + *
> > + * Copyright(c) 2014 Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License, version 2, as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> > + * General Public License for more details.
> > + *
> > + * The full GNU General Public License is included in this distribution in
> > + * the file called "COPYING".
> > + *
> > + * Intel MIC Bus driver.
> > + *
> > + * This implementation is very similar to the the virtio bus driver
> > + * implementation @ include/linux/virtio.h.
> > + */
> > +#ifndef _MIC_BUS_H_
> > +#define _MIC_BUS_H_
> > +/*
> > + * Everything a mbus driver needs to work with any particular mbus
> > + * implementation.
> > + */
> > +#include <linux/types.h>
> > +#include <linux/device.h>
> > +#include <linux/mod_devicetable.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/dma-mapping.h>
> > +
> > +struct mbus_device_id {
> > +	__u32 device;
> > +	__u32 vendor;
> > +};
> > +
> > +#define MBUS_DEV_DMA_HOST 2
> > +#define MBUS_DEV_DMA_MIC 3
> > +#define MBUS_DEV_ANY_ID 0xffffffff
> > +
> > +/**
> > + * mbus_device - representation of a device using mbus
> > + * @priv: private pointer for the driver's use.
> > + * @mmio_va: virtual address of mmio space
> > + * @hw_ops: the hardware ops supported by this device.
> > + * @id: the device type identification (used to match it with a driver).
> > + * @dev: underlying device.
> > + * be used to communicate with.
> > + * @index: unique position on the mbus bus
> > + */
> > +struct mbus_device {
> > +	void *priv;
> > +	void __iomem *mmio_va;
> > +	struct mbus_hw_ops *hw_ops;
> > +	struct mbus_device_id id;
> > +	struct device dev;
> > +	int index;
> > +};
> > +
> > +/**
> > + * mbus_driver - operations for a mbus I/O driver
> > + * @driver: underlying device driver (populate name and owner).
> > + * @id_table: the ids serviced by this driver.
> > + * @probe: the function to call when a device is found.  Returns 0 or -errno.
> > + * @remove: the function to call when a device is removed.
> > + */
> > +struct mbus_driver {
> > +	struct device_driver driver;
> > +	const struct mbus_device_id *id_table;
> > +	int (*probe)(struct mbus_device *dev);
> > +	void (*scan)(struct mbus_device *dev);
> > +	void (*remove)(struct mbus_device *dev);
> > +};
> > +
> > +/**
> > + * struct mic_irq - opaque pointer used as cookie
> > + */
> > +struct mic_irq;
> > +
> > +/**
> > + * mbus_hw_ops - Hardware operations for accessing a MIC device on the MIC bus.
> > + */
> > +struct mbus_hw_ops {
> > +	struct mic_irq* (*request_threaded_irq)(struct mbus_device *mbdev,
> > +			irq_handler_t handler, irq_handler_t thread_fn,
> > +			const char *name, void *data, int intr_src);
> > +	void (*free_irq)(struct mbus_device *mbdev,
> > +			struct mic_irq *cookie, void *data);
> > +	void (*ack_interrupt)(struct mbus_device *mbdev, int num);
> > +};
> > +
> > +int register_mbus_device(struct mbus_device *dev);
> > +void unregister_mbus_device(struct mbus_device *dev);
> > +
> > +int register_mbus_driver(struct mbus_driver *drv);
> > +void unregister_mbus_driver(struct mbus_driver *drv);
> > +
> > +static inline struct mbus_device *dev_to_mbus(struct device *_dev)
> > +{
> > +	return container_of(_dev, struct mbus_device, dev);
> > +}
> > +
> > +static inline struct mbus_driver *drv_to_mbus(struct device_driver *drv)
> > +{
> > +	return container_of(drv, struct mbus_driver, driver);
> > +}
> > +
> > +static inline void mbus_release_dev(struct device *d)
> > +{
> > +}
> 
> As per the kernel documentation rules, I get to publicly make fun of you
> for doing this half-hearted attempt to get around the kernel providing
> you with a valid kernel message as to why you always need to provide a
> proper release function :(
> 
> Consider yourself mocked.
> 
> And go read the kernel documentation for why.

This will be fixed up by allocating mbus_device in
mbus_register_device(..) so that it can be freed in the device release
callback correctly by the bus driver.

> An inline function?  Why?
> 

This is no longer an inline function after the changes above.

> 
> > +static inline int
> > +mbus_add_device(struct mbus_device *mbdev, struct device *pdev, int id,
> > +		struct dma_map_ops *dma_ops, struct mbus_hw_ops *hw_ops,
> > +		void __iomem *mmio_va)
> 
> inline?  Why?
> 

This API was a wrapper for register_mbus_device(..). However after the
changes above this inline function is no longer required as
mbus_register_device(..) allocates and initializes mbus_device.

> > +{
> > +	int ret;
> > +
> > +	mbdev->mmio_va = mmio_va;
> > +	mbdev->dev.parent = pdev;
> > +	mbdev->id.device = id;
> > +	mbdev->id.vendor = MBUS_DEV_ANY_ID;
> > +	mbdev->dev.archdata.dma_ops = dma_ops;
> > +	mbdev->dev.dma_mask = &mbdev->dev.coherent_dma_mask;
> > +	dma_set_mask(&mbdev->dev, DMA_BIT_MASK(64));
> > +	mbdev->dev.release = mbus_release_dev;
> > +	mbdev->hw_ops = hw_ops;
> > +	dev_set_drvdata(&mbdev->dev, mbdev);
> > +
> > +	ret = register_mbus_device(mbdev);
> > +	if (ret) {
> > +		dev_err(mbdev->dev.parent,
> > +			"Failed to register mbus device type %u\n", id);
> > +		return ret;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static inline void mbus_remove_device(struct mbus_device *mbdev)
> > +{
> > +	unregister_mbus_device(mbdev);
> > +	memset(mbdev, 0x0, sizeof(*mbdev));
> 
> Why are you doing this?  (hint, I think I know why, and it's totally and
> unacceptably wrong.)
> 

mbus_device is registered by the host driver upon card boot and
unregistered when the card is reset. The mbus_device field in the host
driver was being reused since it was not allocated by the bus driver for
each reboot iteration and hence needed the ugly memset(..) here. The
change to allocate the mbus_device in the bus driver cleans this up
nicely and we no longer need the memset(..).

> Also, inline?
> 

This inline function is no longer required after the changes above. 

Rev2 of this patch series addressing your feedback will be posted this
week after some validation. Thanks for the review!

Sudeep Dutt 

