Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974Ab3BLAZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:25:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760679Ab3BLAZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:25:29 -0500
Message-ID: <1360628713.3248.8.camel@bling.home>
Subject: Re: [PATCH 2/2] vfio powerpc: implemented IOMMU driver for VFIO
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Date: Mon, 11 Feb 2013 17:25:13 -0700
In-Reply-To: <5119828C.3020106@ozlabs.ru>
References: <1360583672-21924-1-git-send-email-aik@ozlabs.ru>
	  <1360583672-21924-3-git-send-email-aik@ozlabs.ru>
	 <1360621078.12392.119.camel@bling.home> <5119828C.3020106@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 10:45 +1100, Alexey Kardashevskiy wrote:
> On 12/02/13 09:17, Alex Williamson wrote:
> > On Mon, 2013-02-11 at 22:54 +1100, Alexey Kardashevskiy wrote:
> >> VFIO implements platform independent stuff such as
> >> a PCI driver, BAR access (via read/write on a file descriptor
> >> or direct mapping when possible) and IRQ signaling.
> >>
> >> The platform dependent part includes IOMMU initialization
> >> and handling. This patch implements an IOMMU driver for VFIO
> >> which does mapping/unmapping pages for the guest IO and
> >> provides information about DMA window (required by a POWERPC
> >> guest).
> >>
> >> The counterpart in QEMU is required to support this functionality.
> >
> > Revision info would be great here too.
>  >
> >
> >> Cc: David Gibson <david@gibson.dropbear.id.au>
> >> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> ---
> >>   drivers/vfio/Kconfig                |    6 +
> >>   drivers/vfio/Makefile               |    1 +
> >>   drivers/vfio/vfio_iommu_spapr_tce.c |  269 +++++++++++++++++++++++++++++++++++
> >>   include/uapi/linux/vfio.h           |   31 ++++
> >>   4 files changed, 307 insertions(+)
> >>   create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c
> >>
> >> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> >> index 7cd5dec..b464687 100644
> >> --- a/drivers/vfio/Kconfig
> >> +++ b/drivers/vfio/Kconfig
> >> @@ -3,10 +3,16 @@ config VFIO_IOMMU_TYPE1
> >>   	depends on VFIO
> >>   	default n
> >>
> >> +config VFIO_IOMMU_SPAPR_TCE
> >> +	tristate
> >> +	depends on VFIO && SPAPR_TCE_IOMMU
> >> +	default n
> >> +
> >>   menuconfig VFIO
> >>   	tristate "VFIO Non-Privileged userspace driver framework"
> >>   	depends on IOMMU_API
> >>   	select VFIO_IOMMU_TYPE1 if X86
> >> +	select VFIO_IOMMU_SPAPR_TCE if PPC_POWERNV
> >>   	help
> >>   	  VFIO provides a framework for secure userspace device drivers.
> >>   	  See Documentation/vfio.txt for more details.
> >> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> >> index 2398d4a..72bfabc 100644
> >> --- a/drivers/vfio/Makefile
> >> +++ b/drivers/vfio/Makefile
> >> @@ -1,3 +1,4 @@
> >>   obj-$(CONFIG_VFIO) += vfio.o
> >>   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> >> +obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> >>   obj-$(CONFIG_VFIO_PCI) += pci/
> >> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> >> new file mode 100644
> >> index 0000000..9b3fa88
> >> --- /dev/null
> >> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> >> @@ -0,0 +1,269 @@
> >> +/*
> >> + * VFIO: IOMMU DMA mapping support for TCE on POWER
> >> + *
> >> + * Copyright (C) 2012 IBM Corp.  All rights reserved.
> >
> > 2013 now
> >
> >> + *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + * Derived from original vfio_iommu_type1.c:
> >> + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> >> + *     Author: Alex Williamson <alex.williamson@redhat.com>
> >> + */
> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/pci.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/uaccess.h>
> >> +#include <linux/err.h>
> >> +#include <linux/vfio.h>
> >> +#include <asm/iommu.h>
> >> +#include <asm/tce.h>
> >> +
> >> +#define DRIVER_VERSION  "0.1"
> >> +#define DRIVER_AUTHOR   "aik@ozlabs.ru"
> >> +#define DRIVER_DESC     "VFIO IOMMU SPAPR TCE"
> >> +
> >> +static void tce_iommu_detach_group(void *iommu_data,
> >> +		struct iommu_group *iommu_group);
> >> +
> >> +/*
> >> + * VFIO IOMMU fd for SPAPR_TCE IOMMU implementation
> >> + *
> >> + * This code handles mapping and unmapping of user data buffers
> >> + * into DMA'ble space using the IOMMU
> >> + */
> >> +
> >> +/*
> >> + * The container descriptor supports only a single group per container.
> >> + * Required by the API as the container is not supplied with the IOMMU group
> >> + * at the moment of initialization.
> >> + */
> >> +struct tce_container {
> >> +	struct mutex lock;
> >> +	struct iommu_table *tbl;
> >> +};
> >> +
> >> +static void *tce_iommu_open(unsigned long arg)
> >> +{
> >> +	struct tce_container *container;
> >> +
> >> +	if (arg != VFIO_SPAPR_TCE_IOMMU) {
> >> +		pr_err("tce_vfio: Wrong IOMMU type\n");
> >> +		return ERR_PTR(-EINVAL);
> >> +	}
> >> +
> >> +	container = kzalloc(sizeof(*container), GFP_KERNEL);
> >> +	if (!container)
> >> +		return ERR_PTR(-ENOMEM);
> >> +
> >> +	mutex_init(&container->lock);
> >> +
> >> +	return container;
> >> +}
> >> +
> >> +static void tce_iommu_release(void *iommu_data)
> >> +{
> >> +	struct tce_container *container = iommu_data;
> >> +
> >> +	WARN_ON(container->tbl && !container->tbl->it_group);
> >> +	if (container->tbl && container->tbl->it_group)
> >> +		tce_iommu_detach_group(iommu_data, container->tbl->it_group);
> >> +
> >> +	mutex_destroy(&container->lock);
> >> +
> >> +	kfree(container);
> >> +}
> >> +
> >> +static long tce_iommu_ioctl(void *iommu_data,
> >> +				 unsigned int cmd, unsigned long arg)
> >> +{
> >> +	struct tce_container *container = iommu_data;
> >> +	unsigned long minsz;
> >> +	long ret;
> >> +
> >> +	switch (cmd) {
> >> +	case VFIO_CHECK_EXTENSION:
> >> +		return (arg == VFIO_SPAPR_TCE_IOMMU) ? 1 : 0;
> >> +
> >> +	case VFIO_IOMMU_SPAPR_TCE_GET_INFO: {
> >> +		struct vfio_iommu_spapr_tce_info info;
> >> +		struct iommu_table *tbl = container->tbl;
> >> +
> >> +		if (WARN_ON(!tbl))
> >> +			return -ENXIO;
> >> +
> >> +		minsz = offsetofend(struct vfio_iommu_spapr_tce_info,
> >> +				dma32_window_size);
> >> +
> >> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> >> +			return -EFAULT;
> >> +
> >> +		if (info.argsz < minsz)
> >> +			return -EINVAL;
> >> +
> >> +		info.dma32_window_start = tbl->it_offset << IOMMU_PAGE_SHIFT;
> >> +		info.dma32_window_size = tbl->it_size << IOMMU_PAGE_SHIFT;
> >> +		info.flags = 0;
> >> +
> >> +		if (copy_to_user((void __user *)arg, &info, minsz))
> >> +			return -EFAULT;
> >> +
> >> +		return 0;
> >> +	}
> >> +	case VFIO_IOMMU_MAP_DMA: {
> >> +		vfio_iommu_spapr_tce_dma_map param;
> >> +		struct iommu_table *tbl = container->tbl;
> >> +		unsigned long tce;
> >> +
> >> +		if (WARN_ON(!tbl))
> >> +			return -ENXIO;
> >> +
> >> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_map, size);
> >> +
> >> +		if (copy_from_user(&param, (void __user *)arg, minsz))
> >> +			return -EFAULT;
> >> +
> >> +		if (param.argsz < minsz)
> >> +			return -EINVAL;
> >> +
> >> +		if (param.flags & ~(VFIO_DMA_MAP_FLAG_READ |
> >> +				VFIO_DMA_MAP_FLAG_WRITE))
> >> +			return -EINVAL;
> >> +
> >> +		if ((param.size & ~IOMMU_PAGE_MASK) ||
> >> +				(param.vaddr & ~IOMMU_PAGE_MASK))
> >> +			return -EINVAL;
> >> +
> >> +		/* TODO: support multiple TCEs */
> >> +		if (param.size != IOMMU_PAGE_SIZE) {
> >
> > Ouch, ioctl per page...
> 
> Well, there is something to discuss.
> 
> On POWER, there is an interface to add multiple pages at once but the guest 
> does not supply the range of guest phys addresses, it puts some addresses 
> to a small page (so it is up to 512 pages at once) and passes this address 
> to the host as a parameter.
> 
> I posted another series yesterday but forgot to cc: you :) You can find 
> them here - http://patchwork.ozlabs.org/patch/219592/ (emulated devices) 
> and http://patchwork.ozlabs.org/patch/219594/ (vfio). There I convert guest 
> phys address (real and virtual mode are handled different ways) and call 
> iommu_put_tce_user_mode() (or analog) in a loop.
> 
> Either way, I did some tests with 10Gb card and without real mode stuff it 
> does 220MB/s, and even if I do multi-tce it won't be faster than ~400MB/s 
> which is still not enough as the real mode code makes it 1020MB/s. Slower 
> devices work on the same speed no matter what.

Ok, I'll take a look.

> >> +			pr_err("VFIO map on POWER supports only %lu page size\n",
> >> +					IOMMU_PAGE_SIZE);
> >> +			return -EINVAL;
> >> +		}
> >> +
> >> +		/* iova is checked by the IOMMU API */
> >> +		tce = param.vaddr;
> >> +		if (param.flags & VFIO_DMA_MAP_FLAG_READ)
> >> +			tce |= TCE_PCI_READ;
> >> +		if (param.flags & VFIO_DMA_MAP_FLAG_WRITE)
> >> +			tce |= TCE_PCI_WRITE;
> >> +
> >> +		ret = iommu_put_tce_user_mode(tbl, param.iova, tce);
> >> +		iommu_flush_tce(tbl);
> >> +
> >> +		return ret;
> >> +	}
> >> +	case VFIO_IOMMU_UNMAP_DMA: {
> >> +		vfio_iommu_spapr_tce_dma_unmap param;
> >> +		struct iommu_table *tbl = container->tbl;
> >> +
> >> +		if (WARN_ON(!tbl))
> >> +			return -ENXIO;
> >> +
> >> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_unmap, size);
> >> +
> >> +		if (copy_from_user(&param, (void __user *)arg, minsz))
> >> +			return -EFAULT;
> >> +
> >> +		if (param.argsz < minsz)
> >> +			return -EINVAL;
> >> +
> >> +		/* No flag is supported now */
> >> +		if (param.flags)
> >> +			return -EINVAL;
> >> +
> >> +		if (param.size & ~IOMMU_PAGE_MASK)
> >> +			return -EINVAL;
> >
> > But you support multi-page unmaps?
> 
> Yes, this is a lot easier :)
> 
> 
> >> +		/* iova is checked by the IOMMU API */
> >> +		ret = iommu_clear_tce_user_mode(tbl, param.iova, 0,
> >> +				param.size >> IOMMU_PAGE_SHIFT);
> >> +		iommu_flush_tce(tbl);
> >> +
> >> +		return ret;
> >> +	}
> >> +	}
> >> +
> >> +	return -ENOTTY;
> >> +}
> >> +
> >> +static int tce_iommu_attach_group(void *iommu_data,
> >> +		struct iommu_group *iommu_group)
> >> +{
> >> +	int ret;
> >> +	struct tce_container *container = iommu_data;
> >> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> >> +
> >> +	BUG_ON(!tbl);
> >> +	mutex_lock(&container->lock);
> >> +	pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
> >> +			iommu_group_id(iommu_group), iommu_group);
> >> +	if (container->tbl) {
> >> +		pr_warn("tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
> >> +				iommu_group_id(container->tbl->it_group),
> >> +				iommu_group_id(iommu_group));
> >> +		mutex_unlock(&container->lock);
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	container->tbl = tbl;
> >> +	ret = iommu_lock_table(tbl, true);
> >
> > Bug, container->tbl is set regardless of iommu_lock_table.
> 
> Oops, bug.
> 
> > Ok, so now we're checking rlimits and handling page accounting on
> > VFIO_GROUP_SET_CONTAINER to avoid any overhead at map/unmap.  How can
> > the user learn tbl->it_size to set their locked page limit prior to
> > this?  It's available from GET_INFO, but there's a chicken and egg
> > problem that to get it there you have to get past this, which means
> > you're already ok.  Maybe it's in sysfs somewhere already or it could be
> > exposed in the iommu group like the name attribute.  Otherwise we might
> > consider doing locking on first mapping.  Thanks,
> 
> GET_INFO is called in the beginning so QEMU will exit right there. No real 
> work will have been done till that moment so what is the problem?

GET_INFO uses container->tbl, which is set here, so how could it be
called first?  Thanks,

Alex

> >> +	mutex_unlock(&container->lock);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static void tce_iommu_detach_group(void *iommu_data,
> >> +		struct iommu_group *iommu_group)
> >> +{
> >> +	struct tce_container *container = iommu_data;
> >> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> >> +
> >> +	BUG_ON(!tbl);
> >> +	mutex_lock(&container->lock);
> >> +	if (tbl != container->tbl) {
> >> +		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
> >> +				iommu_group_id(iommu_group),
> >> +				iommu_group_id(tbl->it_group));
> >> +	} else {
> >> +
> >> +		pr_debug("tce_vfio: detaching group #%u from iommu %p\n",
> >> +				iommu_group_id(iommu_group), iommu_group);
> >> +
> >> +		container->tbl = NULL;
> >> +		iommu_lock_table(tbl, false);
> >> +	}
> >> +	mutex_unlock(&container->lock);
> >> +}
> >> +
> >> +const struct vfio_iommu_driver_ops tce_iommu_driver_ops = {
> >> +	.name		= "iommu-vfio-powerpc",
> >> +	.owner		= THIS_MODULE,
> >> +	.open		= tce_iommu_open,
> >> +	.release	= tce_iommu_release,
> >> +	.ioctl		= tce_iommu_ioctl,
> >> +	.attach_group	= tce_iommu_attach_group,
> >> +	.detach_group	= tce_iommu_detach_group,
> >> +};
> >> +
> >> +static int __init tce_iommu_init(void)
> >> +{
> >> +	return vfio_register_iommu_driver(&tce_iommu_driver_ops);
> >> +}
> >> +
> >> +static void __exit tce_iommu_cleanup(void)
> >> +{
> >> +	vfio_unregister_iommu_driver(&tce_iommu_driver_ops);
> >> +}
> >> +
> >> +module_init(tce_iommu_init);
> >> +module_exit(tce_iommu_cleanup);
> >> +
> >> +MODULE_VERSION(DRIVER_VERSION);
> >> +MODULE_LICENSE("GPL v2");
> >> +MODULE_AUTHOR(DRIVER_AUTHOR);
> >> +MODULE_DESCRIPTION(DRIVER_DESC);
> >> +
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index 4758d1b..ea9a9a7 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h
> >> @@ -22,6 +22,7 @@
> >>   /* Extensions */
> >>
> >>   #define VFIO_TYPE1_IOMMU		1
> >> +#define VFIO_SPAPR_TCE_IOMMU		2
> >>
> >>   /*
> >>    * The IOCTL interface is designed for extensibility by embedding the
> >> @@ -365,4 +366,34 @@ struct vfio_iommu_type1_dma_unmap {
> >>
> >>   #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
> >>
> >> +/* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
> >> +
> >> +/*
> >> + * The SPAPR TCE info struct provides the information about the PCI bus
> >> + * address ranges available for DMA, these values are programmed into
> >> + * the hardware so the guest has to know that information.
> >> + *
> >> + * The DMA 32 bit window start is an absolute PCI bus address.
> >> + * The IOVA address passed via map/unmap ioctls are absolute PCI bus
> >> + * addresses too so the window works as a filter rather than an offset
> >> + * for IOVA addresses.
> >> + *
> >> + * A flag will need to be added if other page sizes are supported,
> >> + * so as defined here, it is always 4k.
> >> + */
> >> +struct vfio_iommu_spapr_tce_info {
> >> +	__u32 argsz;
> >> +	__u32 flags;			/* reserved for future use */
> >> +	__u32 dma32_window_start;	/* 32 bit window start (bytes) */
> >> +	__u32 dma32_window_size;	/* 32 bit window size (bytes) */
> >> +};
> >> +
> >> +#define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
> >> +
> >> +/* Reuse type1 map/unmap structs as they are the same at the moment */
> >> +typedef struct vfio_iommu_type1_dma_map vfio_iommu_spapr_tce_dma_map;
> >> +typedef struct vfio_iommu_type1_dma_unmap vfio_iommu_spapr_tce_dma_unmap;
> >> +
> >> +/* ***************************************************************** */
> >> +
> >>   #endif /* _UAPIVFIO_H */
> >
> >
> >
> 
> 



