Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3CTUpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:45:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab3CTUpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:45:36 -0400
Message-ID: <1363812324.24132.544.camel@bling.home>
Subject: Re: [PATCH] vfio powerpc: implement IOMMU driver for VFIO
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 14:45:24 -0600
In-Reply-To: <1363676892-3891-1-git-send-email-aik@ozlabs.ru>
References: <1363660844.24132.452.camel@bling.home>
	 <1363676892-3891-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 18:08 +1100, Alexey Kardashevskiy wrote:
> VFIO implements platform independent stuff such as
> a PCI driver, BAR access (via read/write on a file descriptor
> or direct mapping when possible) and IRQ signaling.
> 
> The platform dependent part includes IOMMU initialization
> and handling. This patch implements an IOMMU driver for VFIO
> which does mapping/unmapping pages for the guest IO and
> provides information about DMA window (required by a POWERPC
> guest).
> 
> The counterpart in QEMU is required to support this functionality.
> 
> Changelog:
> * documentation updated
> * containter enable/disable ioctls added
> * request_module(spapr_iommu) added
> * various locks fixed
> 
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---


Looking pretty good.  There's one problem with the detach_group,
otherwise just some trivial comments below.  What's the status of the
tce code that this depends on?  Thanks,

Alex

>  Documentation/vfio.txt              |   63 ++++++
>  drivers/vfio/Kconfig                |    6 +
>  drivers/vfio/Makefile               |    1 +
>  drivers/vfio/vfio.c                 |    1 +
>  drivers/vfio/vfio_iommu_spapr_tce.c |  365 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h           |   38 ++++
>  6 files changed, 474 insertions(+)
>  create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c
> 
> diff --git a/Documentation/vfio.txt b/Documentation/vfio.txt
> index 8eda363..351f7c9 100644
> --- a/Documentation/vfio.txt
> +++ b/Documentation/vfio.txt
> @@ -283,6 +283,69 @@ a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
>  interfaces implement the device region access defined by the device's
>  own VFIO_DEVICE_GET_REGION_INFO ioctl.
>  
> +
> +PPC64 sPAPR implementation note
> +-------------------------------------------------------------------------------
> +
> +This implementation has some specifics:
> +
> +1) Only one IOMMU group per container is supported as an IOMMU group
> +represents the minimal entity which isolation can be guaranteed for and
> +groups are allocated statically, one per a Partitionable Endpoint (PE)
> +(PE is often a PCI domain but not always).
> +
> +2) The hardware supports so called DMA windows - the PCI address range
> +within which DMA transfer is allowed, any attempt to access address space
> +out of the window leads to the whole PE isolation.
> +
> +3) PPC64 guests are paravirtualized but not fully emulated. There is an API
> +to map/unmap pages for DMA, and it normally maps 1..32 pages per call and
> +currently there is no way to reduce the number of calls. In order to make things
> +faster, the map/unmap handling has been implented in real mode which provides

s/implented/implemented/

> +an excellent performance which has limitations such as inability to do
> +locked pages accounting in real time.
> +
> +So 3 additional ioctls have been added:
> +
> +	VFIO_IOMMU_SPAPR_TCE_GET_INFO - returns the size and the start
> +		of the DMA window on the PCI bus.
> +
> +	VFIO_IOMMU_ENABLE - enables the container. The locked pages accounting
> +		is done at this point. This lets user first to know what
> +		the DMA window is and adjust rlimit before doing any real job.
> +
> +	VFIO_IOMMU_DISABLE - disables the container.
> +
> +
> +The code flow from the example above should be slightly changed:
> +
> +	.....
> +	/* Add the group to the container */
> +	ioctl(group, VFIO_GROUP_SET_CONTAINER, &container);
> +
> +	/* Enable the IOMMU model we want */
> +	ioctl(container, VFIO_SET_IOMMU, VFIO_SPAPR_TCE_IOMMU)
> +
> +	/* Get addition sPAPR IOMMU info */
> +	vfio_iommu_spapr_tce_info spapr_iommu_info;
> +	ioctl(container, VFIO_IOMMU_SPAPR_TCE_GET_INFO, &spapr_iommu_info);
> +
> +	if (ioctl(container, VFIO_IOMMU_ENABLE))
> +		/* Cannot enable container, may be low rlimit */
> +
> +	/* Allocate some space and setup a DMA mapping */
> +	dma_map.vaddr = mmap(0, 1024 * 1024, PROT_READ | PROT_WRITE,
> +			     MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
> +
> +	dma_map.size = 1024 * 1024;
> +	dma_map.iova = 0; /* 1MB starting at 0x0 from device view */
> +	dma_map.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE;
> +
> +	/* Check here is .iova/.size are within DMA window from spapr_iommu_info */
> +
> +	ioctl(container, VFIO_IOMMU_MAP_DMA, &dma_map);
> +	.....
> +

Awesome, thanks for the docs update

>  -------------------------------------------------------------------------------
>  
>  [1] VFIO was originally an acronym for "Virtual Function I/O" in its
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 7cd5dec..b464687 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -3,10 +3,16 @@ config VFIO_IOMMU_TYPE1
>  	depends on VFIO
>  	default n
>  
> +config VFIO_IOMMU_SPAPR_TCE
> +	tristate
> +	depends on VFIO && SPAPR_TCE_IOMMU
> +	default n
> +
>  menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	depends on IOMMU_API
>  	select VFIO_IOMMU_TYPE1 if X86
> +	select VFIO_IOMMU_SPAPR_TCE if PPC_POWERNV
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
>  	  See Documentation/vfio.txt for more details.
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 2398d4a..72bfabc 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_VFIO) += vfio.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> +obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>  obj-$(CONFIG_VFIO_PCI) += pci/
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 12c264d..004033d 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1376,6 +1376,7 @@ static int __init vfio_init(void)
>  	 * drivers.
>  	 */
>  	request_module_nowait("vfio_iommu_type1");
> +	request_module_nowait("vfio_iommu_spapr");
>  
>  	return 0;
>  
> diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
> new file mode 100644
> index 0000000..22ba0b5
> --- /dev/null
> +++ b/drivers/vfio/vfio_iommu_spapr_tce.c
> @@ -0,0 +1,365 @@
> +/*
> + * VFIO: IOMMU DMA mapping support for TCE on POWER
> + *
> + * Copyright (C) 2013 IBM Corp.  All rights reserved.
> + *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Derived from original vfio_iommu_type1.c:
> + * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
> + *     Author: Alex Williamson <alex.williamson@redhat.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/err.h>
> +#include <linux/vfio.h>
> +#include <asm/iommu.h>
> +#include <asm/tce.h>
> +
> +#define DRIVER_VERSION  "0.1"
> +#define DRIVER_AUTHOR   "aik@ozlabs.ru"
> +#define DRIVER_DESC     "VFIO IOMMU SPAPR TCE"
> +
> +static void tce_iommu_detach_group(void *iommu_data,
> +		struct iommu_group *iommu_group);
> +
> +/*
> + * VFIO IOMMU fd for SPAPR_TCE IOMMU implementation
> + *
> + * This code handles mapping and unmapping of user data buffers
> + * into DMA'ble space using the IOMMU
> + */
> +
> +/*
> + * The container descriptor supports only a single group per container.
> + * Required by the API as the container is not supplied with the IOMMU group
> + * at the moment of initialization.
> + */
> +struct tce_container {
> +	struct mutex lock;
> +	struct iommu_table *tbl;
> +	bool enabled;
> +};
> +
> +static int tce_iommu_enable(struct tce_container *container)
> +{
> +	int ret = 0;
> +	unsigned long locked, lock_limit, npages;
> +	struct iommu_table *tbl = container->tbl;
> +
> +	if (!container->tbl)
> +		return -ENXIO;
> +
> +	if (!current->mm)
> +		return -ESRCH; /* process exited */
> +
> +	mutex_lock(&container->lock);
> +	if (container->enabled) {
> +		mutex_unlock(&container->lock);
> +		return -EBUSY;
> +	}
> +
> +	/*
> +	 * Accounting for locked pages.
> +	 *
> +	 * On sPAPR platform, IOMMU translation table contains
> +	 * an entry per 4K page. Every map/unmap request is sent
> +	 * by the guest via hypercall and supposed to be handled
> +	 * quickly, ecpesially in real mode (if such option is

s/ecpesially/especially/

> +	 * supported and enabled).
> +	 * As handling the accounting in real time is rather
> +	 * impossible, it may require switching to virtual mode
> +	 * which is quite expensive operation.
> +	 * As the whole window can be actuall mapped on high

s/actuall/actually/

> +	 * performance guests and we do not want such guests
> +	 * to fail, we do the accounting as a part of IOMMU
> +	 * enablement process.
> +	 */
> +	down_write(&current->mm->mmap_sem);
> +	npages = (tbl->it_size << IOMMU_PAGE_SHIFT) >> PAGE_SHIFT;
> +	locked = current->mm->locked_vm + npages;
> +	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> +	if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
> +		pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
> +				rlimit(RLIMIT_MEMLOCK));
> +		ret = -ENOMEM;
> +	} else {
> +
> +		current->mm->locked_vm += npages;
> +		container->enabled = true;
> +	}
> +	up_write(&current->mm->mmap_sem);
> +
> +	mutex_unlock(&container->lock);
> +
> +	return ret;
> +}
> +
> +static void tce_iommu_disable(struct tce_container *container)
> +{
> +	mutex_lock(&container->lock);
> +
> +	if (container->enabled && container->tbl) {
> +		if (current->mm) {
> +			down_write(&current->mm->mmap_sem);
> +			current->mm->locked_vm -= (container->tbl->it_size <<
> +					IOMMU_PAGE_SHIFT) >> PAGE_SHIFT;
> +			up_write(&current->mm->mmap_sem);
> +		}
> +		container->enabled = false;
> +	}
> +
> +	mutex_unlock(&container->lock);
> +}
> +
> +static void *tce_iommu_open(unsigned long arg)
> +{
> +	struct tce_container *container;
> +
> +	if (arg != VFIO_SPAPR_TCE_IOMMU) {
> +		pr_err("tce_vfio: Wrong IOMMU type\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	container = kzalloc(sizeof(*container), GFP_KERNEL);
> +	if (!container)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mutex_init(&container->lock);
> +
> +	return container;
> +}
> +
> +static void tce_iommu_release(void *iommu_data)
> +{
> +	struct tce_container *container = iommu_data;
> +
> +	WARN_ON(container->tbl && !container->tbl->it_group);
> +	tce_iommu_disable(container);
> +
> +	if (container->tbl && container->tbl->it_group)
> +		tce_iommu_detach_group(iommu_data, container->tbl->it_group);
> +
> +	mutex_destroy(&container->lock);
> +
> +	kfree(container);
> +}
> +
> +static long tce_iommu_ioctl(void *iommu_data,
> +				 unsigned int cmd, unsigned long arg)
> +{
> +	struct tce_container *container = iommu_data;
> +	unsigned long minsz;
> +	long ret;
> +
> +	switch (cmd) {
> +	case VFIO_CHECK_EXTENSION:
> +		return (arg == VFIO_SPAPR_TCE_IOMMU) ? 1 : 0;
> +
> +	case VFIO_IOMMU_SPAPR_TCE_GET_INFO: {
> +		struct vfio_iommu_spapr_tce_info info;
> +		struct iommu_table *tbl = container->tbl;
> +
> +		if (WARN_ON(!tbl))
> +			return -ENXIO;
> +
> +		minsz = offsetofend(struct vfio_iommu_spapr_tce_info,
> +				dma32_window_size);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		info.dma32_window_start = tbl->it_offset << IOMMU_PAGE_SHIFT;
> +		info.dma32_window_size = tbl->it_size << IOMMU_PAGE_SHIFT;
> +		info.flags = 0;
> +
> +		if (copy_to_user((void __user *)arg, &info, minsz))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
> +	case VFIO_IOMMU_MAP_DMA: {
> +		vfio_iommu_spapr_tce_dma_map param;
> +		struct iommu_table *tbl = container->tbl;
> +		unsigned long tce;
> +
> +		if (WARN_ON(!tbl))
> +			return -ENXIO;
> +
> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_map, size);
> +
> +		if (copy_from_user(&param, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (param.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (param.flags & ~(VFIO_DMA_MAP_FLAG_READ |
> +				VFIO_DMA_MAP_FLAG_WRITE))
> +			return -EINVAL;
> +
> +		if ((param.size & ~IOMMU_PAGE_MASK) ||
> +				(param.vaddr & ~IOMMU_PAGE_MASK))
> +			return -EINVAL;
> +
> +		/* TODO: support multiple TCEs */
> +		if (param.size != IOMMU_PAGE_SIZE) {
> +			pr_err("VFIO map on POWER supports only %lu page size\n",
> +					IOMMU_PAGE_SIZE);
> +			return -EINVAL;
> +		}
> +
> +		/* iova is checked by the IOMMU API */
> +		tce = param.vaddr;
> +		if (param.flags & VFIO_DMA_MAP_FLAG_READ)
> +			tce |= TCE_PCI_READ;
> +		if (param.flags & VFIO_DMA_MAP_FLAG_WRITE)
> +			tce |= TCE_PCI_WRITE;
> +
> +		ret = iommu_tce_put_param_check(tbl, param.iova, tce);
> +		if (ret)
> +			return ret;
> +
> +		ret = iommu_put_tce_user_mode(tbl,
> +				param.iova >> IOMMU_PAGE_SHIFT, tce);
> +		iommu_flush_tce(tbl);
> +
> +		return ret;
> +	}
> +	case VFIO_IOMMU_UNMAP_DMA: {
> +		vfio_iommu_spapr_tce_dma_unmap param;
> +		struct iommu_table *tbl = container->tbl;
> +
> +		if (WARN_ON(!tbl))
> +			return -ENXIO;
> +
> +		minsz = offsetofend(vfio_iommu_spapr_tce_dma_unmap, size);
> +
> +		if (copy_from_user(&param, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (param.argsz < minsz)
> +			return -EINVAL;
> +
> +		/* No flag is supported now */
> +		if (param.flags)
> +			return -EINVAL;
> +
> +		if (param.size & ~IOMMU_PAGE_MASK)
> +			return -EINVAL;
> +
> +		ret = iommu_tce_clear_param_check(tbl, param.iova, 0,
> +				param.size >> IOMMU_PAGE_SHIFT);
> +		if (ret)
> +			return ret;
> +
> +		ret = iommu_clear_tces_and_put_pages(tbl,
> +				param.iova >> IOMMU_PAGE_SHIFT,
> +				param.size >> IOMMU_PAGE_SHIFT);
> +		iommu_flush_tce(tbl);
> +
> +		return ret;
> +	}
> +	case VFIO_IOMMU_ENABLE: {
> +		return tce_iommu_enable(container);
> +	}
> +	case VFIO_IOMMU_DISABLE: {
> +		tce_iommu_disable(container);
> +		return 0;
> +	}

Unnecessary brackets

> +	}
> +
> +	return -ENOTTY;
> +}
> +
> +static int tce_iommu_attach_group(void *iommu_data,
> +		struct iommu_group *iommu_group)
> +{
> +	int ret;
> +	struct tce_container *container = iommu_data;
> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> +
> +	BUG_ON(!tbl);
> +	mutex_lock(&container->lock);
> +	pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
> +			iommu_group_id(iommu_group), iommu_group);
> +	if (container->tbl) {
> +		pr_warn("tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
> +				iommu_group_id(container->tbl->it_group),
> +				iommu_group_id(iommu_group));
> +		mutex_unlock(&container->lock);
> +		return -EBUSY;
> +	}
> +
> +	ret = iommu_take_ownership(tbl);
> +	if (!ret)
> +		container->tbl = tbl;
> +
> +	mutex_unlock(&container->lock);
> +
> +	return ret;
> +}
> +
> +static void tce_iommu_detach_group(void *iommu_data,
> +		struct iommu_group *iommu_group)
> +{
> +	struct tce_container *container = iommu_data;
> +	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
> +
> +	BUG_ON(!tbl);
> +	mutex_lock(&container->lock);
> +	if (tbl != container->tbl) {
> +		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
> +				iommu_group_id(iommu_group),
> +				iommu_group_id(tbl->it_group));
> +	} else if (container->enabled) {
> +		pr_err("tce_vfio: detaching group #%u from enabled container\n",
> +				iommu_group_id(tbl->it_group));

Hmm, something more than a pr_err needs to happen here.  Wouldn't this
imply a disable and going back to an unprivileged container?

> +	} else {
> +
> +		pr_debug("tce_vfio: detaching group #%u from iommu %p\n",
> +				iommu_group_id(iommu_group), iommu_group);
> +
> +		container->tbl = NULL;
> +		iommu_release_ownership(tbl);
> +	}
> +	mutex_unlock(&container->lock);
> +}
> +
> +const struct vfio_iommu_driver_ops tce_iommu_driver_ops = {
> +	.name		= "iommu-vfio-powerpc",
> +	.owner		= THIS_MODULE,
> +	.open		= tce_iommu_open,
> +	.release	= tce_iommu_release,
> +	.ioctl		= tce_iommu_ioctl,
> +	.attach_group	= tce_iommu_attach_group,
> +	.detach_group	= tce_iommu_detach_group,
> +};
> +
> +static int __init tce_iommu_init(void)
> +{
> +	return vfio_register_iommu_driver(&tce_iommu_driver_ops);
> +}
> +
> +static void __exit tce_iommu_cleanup(void)
> +{
> +	vfio_unregister_iommu_driver(&tce_iommu_driver_ops);
> +}
> +
> +module_init(tce_iommu_init);
> +module_exit(tce_iommu_cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 4758d1b..38ecccf 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -22,6 +22,7 @@
>  /* Extensions */
>  
>  #define VFIO_TYPE1_IOMMU		1
> +#define VFIO_SPAPR_TCE_IOMMU		2
>  
>  /*
>   * The IOCTL interface is designed for extensibility by embedding the
> @@ -365,4 +366,41 @@ struct vfio_iommu_type1_dma_unmap {
>  
>  #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
>  
> +/*
> + * IOCTLs to enable/disable IOMMU container usage.
> + * No parameters are supported.
> + */
> +#define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
> +#define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
> +
> +/* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
> +
> +/*
> + * The SPAPR TCE info struct provides the information about the PCI bus
> + * address ranges available for DMA, these values are programmed into
> + * the hardware so the guest has to know that information.
> + *
> + * The DMA 32 bit window start is an absolute PCI bus address.
> + * The IOVA address passed via map/unmap ioctls are absolute PCI bus
> + * addresses too so the window works as a filter rather than an offset
> + * for IOVA addresses.
> + *
> + * A flag will need to be added if other page sizes are supported,
> + * so as defined here, it is always 4k.
> + */
> +struct vfio_iommu_spapr_tce_info {
> +	__u32 argsz;
> +	__u32 flags;			/* reserved for future use */
> +	__u32 dma32_window_start;	/* 32 bit window start (bytes) */
> +	__u32 dma32_window_size;	/* 32 bit window size (bytes) */
> +};
> +
> +#define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
> +
> +/* Reuse type1 map/unmap structs as they are the same at the moment */
> +typedef struct vfio_iommu_type1_dma_map vfio_iommu_spapr_tce_dma_map;
> +typedef struct vfio_iommu_type1_dma_unmap vfio_iommu_spapr_tce_dma_unmap;
> +
> +/* ***************************************************************** */
> +
>  #endif /* _UAPIVFIO_H */



