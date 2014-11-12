Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaKLRsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:48:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaKLRsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:48:01 -0500
Message-ID: <1415810985.16601.361.camel@ul30vt.home>
Subject: Re: [PATCH v9 01/19] vfio/platform: initial skeleton of VFIO
 support for platform devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Auger <eric.auger@linaro.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, kim.phillips@freescale.com,
        marc.zyngier@arm.com, open list <linux-kernel@vger.kernel.org>,
        VFIO DRIVER <kvm@vger.kernel.org>
Date: Wed, 12 Nov 2014 09:49:45 -0700
In-Reply-To: <546330DE.5010002@linaro.org>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1414433284-31719-2-git-send-email-a.motakis@virtualopensystems.com>
	 <546330DE.5010002@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 11:05 +0100, Eric Auger wrote:
> Hi Antonios,
> 
> On 10/27/2014 07:07 PM, Antonios Motakis wrote:
> > This patch forms the common skeleton code for platform devices support
> > with VFIO. This will include the core functionality of VFIO_PLATFORM,
> > however binding to the device and discovering the device resources will
> > be done with the help of a separate file where any Linux platform bus
> > specific code will reside.
> > 
> > This will allow us to implement support for also discovering AMBA devices
> > and their resources, but still reuse a large part of the VFIO_PLATFORM
> > implementation.
> > 
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > ---
> >  drivers/vfio/platform/vfio_platform_common.c  | 126 ++++++++++++++++++++++++++
> >  drivers/vfio/platform/vfio_platform_private.h |  36 ++++++++
> >  2 files changed, 162 insertions(+)
> >  create mode 100644 drivers/vfio/platform/vfio_platform_common.c
> >  create mode 100644 drivers/vfio/platform/vfio_platform_private.h
> > 
> > diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> > new file mode 100644
> > index 0000000..e0fdbc8
> > --- /dev/null
> > +++ b/drivers/vfio/platform/vfio_platform_common.c
> > @@ -0,0 +1,126 @@
> > +/*
> > + * Copyright (C) 2013 - Virtual Open Systems
> > + * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License, version 2, as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/iommu.h>
> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/notifier.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/vfio.h>
> > +#include <linux/io.h>
> not sure at that state all the above includes are needed.
> > +
> > +#include "vfio_platform_private.h"
> > +
> > +static void vfio_platform_release(void *device_data)
> > +{
> > +	module_put(THIS_MODULE);
> > +}
> > +
> > +static int vfio_platform_open(void *device_data)
> > +{
> > +	if (!try_module_get(THIS_MODULE))
> > +		return -ENODEV;
> > +
> > +	return 0;
> > +}
> > +
> > +static long vfio_platform_ioctl(void *device_data,
> > +			   unsigned int cmd, unsigned long arg)
> a minor style comment/question that applies on all the series. Shouldn't
> subsequent argument lines rather be aligned with the first char after
> "(", as done in PCI code?

It's also my preferred style to indent to just after the open paren on
wrapped lines where possible, but I don't think there are hard rules in
CodingStyle or checkpatch that enforce this, so I often let it slide.
Thanks,

Alex

> > +{
> > +	if (cmd == VFIO_DEVICE_GET_INFO)
> > +		return -EINVAL;
> > +
> > +	else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
> > +		return -EINVAL;
> > +
> > +	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
> > +		return -EINVAL;
> > +
> > +	else if (cmd == VFIO_DEVICE_SET_IRQS)
> > +		return -EINVAL;
> > +
> > +	else if (cmd == VFIO_DEVICE_RESET)
> > +		return -EINVAL;
> > +
> > +	return -ENOTTY;
> > +}
> > +
> > +static ssize_t vfio_platform_read(void *device_data, char __user *buf,
> > +				  size_t count, loff_t *ppos)
> > +{
> > +	return -EINVAL;
> > +}
> > +
> > +static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
> > +				   size_t count, loff_t *ppos)
> > +{
> > +	return -EINVAL;
> > +}
> > +
> > +static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
> > +{
> > +	return -EINVAL;
> > +}
> > +
> > +static const struct vfio_device_ops vfio_platform_ops = {
> > +	.name		= "vfio-platform",
> > +	.open		= vfio_platform_open,
> > +	.release	= vfio_platform_release,
> > +	.ioctl		= vfio_platform_ioctl,
> > +	.read		= vfio_platform_read,
> > +	.write		= vfio_platform_write,
> > +	.mmap		= vfio_platform_mmap,
> > +};
> > +
> > +int vfio_platform_probe_common(struct vfio_platform_device *vdev,
> > +			       struct device *dev)
> > +{
> > +	struct iommu_group *group;
> > +	int ret;
> > +
> > +	if (!vdev)
> > +		return -EINVAL;
> > +
> > +	group = iommu_group_get(dev);
> > +	if (!group) {
> > +		pr_err("VFIO: No IOMMU group for device %s\n", vdev->name);
> > +		return -EINVAL;
> > +	}
> I saw the above check also is done at beginning of vfio_add_group_dev.
> Added value however is pr_err which is useful and PCI code does the
> check too.
> 
> Eric
> > +
> > +	ret = vfio_add_group_dev(dev, &vfio_platform_ops, vdev);
> > +	if (ret) {
> > +		iommu_group_put(group);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
> > +
> > +struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
> > +{
> > +	struct vfio_platform_device *vdev;
> > +
> > +	vdev = vfio_del_group_dev(dev);
> > +	if (vdev)
> > +		iommu_group_put(dev->iommu_group);
> > +
> > +	return vdev;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
> > diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> > new file mode 100644
> > index 0000000..062b92d
> > --- /dev/null
> > +++ b/drivers/vfio/platform/vfio_platform_private.h
> > @@ -0,0 +1,36 @@
> > +/*
> > + * Copyright (C) 2013 - Virtual Open Systems
> > + * Author: Antonios Motakis <a.motakis@virtualopensystems.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License, version 2, as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef VFIO_PLATFORM_PRIVATE_H
> > +#define VFIO_PLATFORM_PRIVATE_H
> > +
> > +struct vfio_platform_device {
> > +	/*
> > +	 * These fields should be filled by the bus specific binder
> > +	 */
> > +	void		*opaque;
> > +	const char	*name;
> > +	uint32_t	flags;
> > +	/* callbacks to discover device resources */
> > +	struct resource*
> > +		(*get_resource)(struct vfio_platform_device *vdev, int i);
> > +	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
> > +};
> > +
> > +extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
> > +				      struct device *dev);
> > +extern struct vfio_platform_device *vfio_platform_remove_common
> > +				     (struct device *dev);
> > +
> > +#endif /* VFIO_PLATFORM_PRIVATE_H */
> > 
> 



