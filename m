Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaJUS5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbaJUS5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:57:53 -0400
Message-ID: <1413917846.4202.168.camel@ul30vt.home>
Subject: Re: [PATCH v8 07/18] vfio/platform: return info for device memory
 mapped IO regions
From: Alex Williamson <alex.williamson@redhat.com>
To: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Date: Tue, 21 Oct 2014 12:57:26 -0600
In-Reply-To: <e1fd19d05dd04b9ab5d65a495b5fabad@BLUPR03MB566.namprd03.prod.outlook.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1413205825-6370-8-git-send-email-a.motakis@virtualopensystems.com>
	 <1413909282.4202.141.camel@ul30vt.home>
	 <e1fd19d05dd04b9ab5d65a495b5fabad@BLUPR03MB566.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 18:18 +0000, Bharat.Bhushan@freescale.com wrote:
> 
> > -----Original Message-----
> > From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> > bounces@lists.linux-foundation.org] On Behalf Of Alex Williamson
> > Sent: Tuesday, October 21, 2014 10:05 PM
> > To: Antonios Motakis
> > Cc: open list:VFIO DRIVER; eric.auger@linaro.org; marc.zyngier@arm.com;
> > will.deacon@arm.com; open list; iommu@lists.linux-foundation.org;
> > tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu;
> > christoffer.dall@linaro.org
> > Subject: Re: [PATCH v8 07/18] vfio/platform: return info for device memory
> > mapped IO regions
> > 
> > On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
> > > This patch enables the IOCTLs VFIO_DEVICE_GET_REGION_INFO ioctl call,
> > > which allows the user to learn about the available MMIO resources of a
> > > device.
> > >
> > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > > ---
> > >  drivers/vfio/platform/vfio_platform_common.c  | 93
> > > +++++++++++++++++++++++++--
> > > drivers/vfio/platform/vfio_platform_private.h | 22 +++++++
> > >  2 files changed, 111 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/vfio/platform/vfio_platform_common.c
> > > b/drivers/vfio/platform/vfio_platform_common.c
> > > index 1e4073f..8a7e474 100644
> > > --- a/drivers/vfio/platform/vfio_platform_common.c
> > > +++ b/drivers/vfio/platform/vfio_platform_common.c
> > > @@ -27,17 +27,84 @@
> > >
> > >  #include "vfio_platform_private.h"
> > >
> > > +static int vfio_platform_regions_init(struct vfio_platform_device
> > > +*vdev) {
> > > +	int cnt = 0, i;
> > > +
> > > +	while (vdev->get_resource(vdev, cnt))
> > > +		cnt++;
> > > +
> > > +	vdev->regions = kcalloc(cnt, sizeof(struct vfio_platform_region),
> > > +				GFP_KERNEL);
> > > +	if (!vdev->regions)
> > > +		return -ENOMEM;
> > > +
> > > +	for (i = 0; i < cnt;  i++) {
> > > +		struct resource *res =
> > > +			vdev->get_resource(vdev, i);
> > > +
> > > +		if (!res)
> > > +			goto err;
> > > +
> > > +		vdev->regions[i].addr = res->start;
> > > +		vdev->regions[i].size = resource_size(res);
> > > +		vdev->regions[i].flags = 0;
> > > +
> > > +		switch (resource_type(res)) {
> > > +		case IORESOURCE_MEM:
> > > +			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_MMIO;
> > > +			break;
> > > +		case IORESOURCE_IO:
> > > +			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
> > > +			break;
> > 
> > Ok, we have support for PIO in platform now (thanks!), does the user know what
> > type of region they're dealing with?  Do they care?  For PCI the user tests the
> > PCI BAR in config space to determine which type it is.  I'm guessing that
> > platform would do something similar against the device tree or ACPI, right?
> 
> Interested in knowing what type of PIO region in a platform device, is this for I2C/SPI type of device? 

I don't think we have any specific users, I had noted in a previous
version that we were searching only for MMIO regions and we at least
needed to figure out how PIO regions would be exposed so we don't have
compatibility issues when adding them (ie. how to match a vfio resource
index to a sysfs/dt/acpi description when we're only reporting a subset
of resources).  Antonios has done a good job in this version in adding
all but the accessor functions for PIO.  x86 could theoretically have
ACPI defined devices that are exposed as platform devices that could be
exposed using this code.  Thanks,

Alex

> > > +		default:
> > > +			goto err;
> > > +		}
> > > +	}
> > > +
> > > +	vdev->num_regions = cnt;
> > > +
> > > +	return 0;
> > > +err:
> > > +	kfree(vdev->regions);
> > > +	return -EINVAL;
> > > +}
> > > +
> > > +static void vfio_platform_regions_cleanup(struct vfio_platform_device
> > > +*vdev) {
> > > +	vdev->num_regions = 0;
> > > +	kfree(vdev->regions);
> > > +}
> > > +
> > >  static void vfio_platform_release(void *device_data)  {
> > > +	struct vfio_platform_device *vdev = device_data;
> > > +
> > > +	if (atomic_dec_and_test(&vdev->refcnt))
> > > +		vfio_platform_regions_cleanup(vdev);
> > > +
> > >  	module_put(THIS_MODULE);
> > >  }
> > >
> > >  static int vfio_platform_open(void *device_data)  {
> > > +	struct vfio_platform_device *vdev = device_data;
> > > +	int ret;
> > > +
> > >  	if (!try_module_get(THIS_MODULE))
> > >  		return -ENODEV;
> > >
> > > +	if (atomic_inc_return(&vdev->refcnt) == 1) {
> > > +		ret = vfio_platform_regions_init(vdev);
> > > +		if (ret)
> > > +			goto err_reg;
> > > +	}
> > > +
> > >  	return 0;
> > > +
> > > +err_reg:
> > > +	module_put(THIS_MODULE);
> > > +	return ret;
> > 
> > Note that if vfio_platform_regions_init() fails then your refcnt is wrong.  We
> > switched to a mutex in vfio-pci to avoid this.  See 61d792562b53.
> > 
> > >  }
> > >
> > >  static long vfio_platform_ioctl(void *device_data, @@ -58,15 +125,33
> > > @@ static long vfio_platform_ioctl(void *device_data,
> > >  			return -EINVAL;
> > >
> > >  		info.flags = vdev->flags;
> > > -		info.num_regions = 0;
> > > +		info.num_regions = vdev->num_regions;
> > >  		info.num_irqs = 0;
> > >
> > >  		return copy_to_user((void __user *)arg, &info, minsz);
> > >
> > > -	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
> > > -		return -EINVAL;
> > > +	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> > > +		struct vfio_region_info info;
> > > +
> > > +		minsz = offsetofend(struct vfio_region_info, offset);
> > > +
> > > +		if (copy_from_user(&info, (void __user *)arg, minsz))
> > > +			return -EFAULT;
> > > +
> > > +		if (info.argsz < minsz)
> > > +			return -EINVAL;
> > > +
> > > +		if (info.index >= vdev->num_regions)
> > > +			return -EINVAL;
> > > +
> > > +		/* map offset to the physical address  */
> > > +		info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
> > > +		info.size = vdev->regions[info.index].size;
> > > +		info.flags = vdev->regions[info.index].flags;
> > > +
> > > +		return copy_to_user((void __user *)arg, &info, minsz);
> > >
> > > -	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
> > > +	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
> > >  		return -EINVAL;
> > >
> > >  	else if (cmd == VFIO_DEVICE_SET_IRQS) diff --git
> > > a/drivers/vfio/platform/vfio_platform_private.h
> > > b/drivers/vfio/platform/vfio_platform_private.h
> > > index ef76737..2a06035 100644
> > > --- a/drivers/vfio/platform/vfio_platform_private.h
> > > +++ b/drivers/vfio/platform/vfio_platform_private.h
> > > @@ -15,7 +15,29 @@
> > >  #ifndef VFIO_PLATFORM_PRIVATE_H
> > >  #define VFIO_PLATFORM_PRIVATE_H
> > >
> > > +#define VFIO_PLATFORM_OFFSET_SHIFT   40
> > > +#define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) <<
> > > +VFIO_PLATFORM_OFFSET_SHIFT) - 1)
> > > +
> > > +#define VFIO_PLATFORM_OFFSET_TO_INDEX(off)	\
> > > +	(off >> VFIO_PLATFORM_OFFSET_SHIFT)
> > > +
> > > +#define VFIO_PLATFORM_INDEX_TO_OFFSET(index)	\
> > > +	((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
> > > +
> > > +struct vfio_platform_region {
> > > +	u64			addr;
> > > +	resource_size_t		size;
> > > +	u32			flags;
> > > +	u32			type;
> > > +#define VFIO_PLATFORM_REGION_TYPE_MMIO	1
> > > +#define VFIO_PLATFORM_REGION_TYPE_PIO	2
> > > +};
> > > +
> > >  struct vfio_platform_device {
> > > +	struct vfio_platform_region	*regions;
> > > +	u32				num_regions;
> > > +	atomic_t			refcnt;
> > > +
> > >  	/*
> > >  	 * These fields should be filled by the bus driver at binding time
> > >  	 */
> > 
> > 
> > 
> > _______________________________________________
> > iommu mailing list
> > iommu@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



