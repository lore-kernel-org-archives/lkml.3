Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbaJUSeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:34:05 -0400
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:32928
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754405AbaJUSeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:34:03 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 14:34:03 EDT
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>
CC: "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Subject: RE: [PATCH v8 07/18] vfio/platform: return info for device memory
	mapped IO regions
Thread-Topic: [PATCH v8 07/18] vfio/platform: return info for device memory
	mapped IO regions
Thread-Index: AQHP7Uz5nEAsn5mtB0iQTAYWrBXUn5w624QA
Date: Tue, 21 Oct 2014 18:18:50 +0000
Message-ID: <e1fd19d05dd04b9ab5d65a495b5fabad@BLUPR03MB566.namprd03.prod.outlook.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
	<1413205825-6370-8-git-send-email-a.motakis@virtualopensystems.com>
 <1413909282.4202.141.camel@ul30vt.home>
In-Reply-To: <1413909282.4202.141.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [122.176.195.189]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB567;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0371762FE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(377454003)(41574002)(377424004)(13464003)(51704005)(24454002)(99396003)(21056001)(101416001)(87936001)(74316001)(92566001)(106356001)(85852003)(120916001)(97736003)(108616004)(85306004)(4396001)(95666004)(106116001)(99286002)(105586002)(107046002)(76482002)(19580405001)(33646002)(19580395003)(76576001)(64706001)(122556002)(46102003)(86362001)(50986999)(2656002)(31966008)(54356999)(20776003)(80022003)(66066001)(15975445006)(76176999)(40100003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB567;H:BLUPR03MB566.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Alex Williamson
> Sent: Tuesday, October 21, 2014 10:05 PM
> To: Antonios Motakis
> Cc: open list:VFIO DRIVER; eric.auger@linaro.org; marc.zyngier@arm.com;
> will.deacon@arm.com; open list; iommu@lists.linux-foundation.org;
> tech@virtualopensystems.com; kvmarm@lists.cs.columbia.edu;
> christoffer.dall@linaro.org
> Subject: Re: [PATCH v8 07/18] vfio/platform: return info for device memory
> mapped IO regions
> 
> On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
> > This patch enables the IOCTLs VFIO_DEVICE_GET_REGION_INFO ioctl call,
> > which allows the user to learn about the available MMIO resources of a
> > device.
> >
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > ---
> >  drivers/vfio/platform/vfio_platform_common.c  | 93
> > +++++++++++++++++++++++++--
> > drivers/vfio/platform/vfio_platform_private.h | 22 +++++++
> >  2 files changed, 111 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vfio/platform/vfio_platform_common.c
> > b/drivers/vfio/platform/vfio_platform_common.c
> > index 1e4073f..8a7e474 100644
> > --- a/drivers/vfio/platform/vfio_platform_common.c
> > +++ b/drivers/vfio/platform/vfio_platform_common.c
> > @@ -27,17 +27,84 @@
> >
> >  #include "vfio_platform_private.h"
> >
> > +static int vfio_platform_regions_init(struct vfio_platform_device
> > +*vdev) {
> > +	int cnt = 0, i;
> > +
> > +	while (vdev->get_resource(vdev, cnt))
> > +		cnt++;
> > +
> > +	vdev->regions = kcalloc(cnt, sizeof(struct vfio_platform_region),
> > +				GFP_KERNEL);
> > +	if (!vdev->regions)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < cnt;  i++) {
> > +		struct resource *res =
> > +			vdev->get_resource(vdev, i);
> > +
> > +		if (!res)
> > +			goto err;
> > +
> > +		vdev->regions[i].addr = res->start;
> > +		vdev->regions[i].size = resource_size(res);
> > +		vdev->regions[i].flags = 0;
> > +
> > +		switch (resource_type(res)) {
> > +		case IORESOURCE_MEM:
> > +			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_MMIO;
> > +			break;
> > +		case IORESOURCE_IO:
> > +			vdev->regions[i].type = VFIO_PLATFORM_REGION_TYPE_PIO;
> > +			break;
> 
> Ok, we have support for PIO in platform now (thanks!), does the user know what
> type of region they're dealing with?  Do they care?  For PCI the user tests the
> PCI BAR in config space to determine which type it is.  I'm guessing that
> platform would do something similar against the device tree or ACPI, right?

Interested in knowing what type of PIO region in a platform device, is this for I2C/SPI type of device? 


Thanks
-Bharat

> 
> > +		default:
> > +			goto err;
> > +		}
> > +	}
> > +
> > +	vdev->num_regions = cnt;
> > +
> > +	return 0;
> > +err:
> > +	kfree(vdev->regions);
> > +	return -EINVAL;
> > +}
> > +
> > +static void vfio_platform_regions_cleanup(struct vfio_platform_device
> > +*vdev) {
> > +	vdev->num_regions = 0;
> > +	kfree(vdev->regions);
> > +}
> > +
> >  static void vfio_platform_release(void *device_data)  {
> > +	struct vfio_platform_device *vdev = device_data;
> > +
> > +	if (atomic_dec_and_test(&vdev->refcnt))
> > +		vfio_platform_regions_cleanup(vdev);
> > +
> >  	module_put(THIS_MODULE);
> >  }
> >
> >  static int vfio_platform_open(void *device_data)  {
> > +	struct vfio_platform_device *vdev = device_data;
> > +	int ret;
> > +
> >  	if (!try_module_get(THIS_MODULE))
> >  		return -ENODEV;
> >
> > +	if (atomic_inc_return(&vdev->refcnt) == 1) {
> > +		ret = vfio_platform_regions_init(vdev);
> > +		if (ret)
> > +			goto err_reg;
> > +	}
> > +
> >  	return 0;
> > +
> > +err_reg:
> > +	module_put(THIS_MODULE);
> > +	return ret;
> 
> Note that if vfio_platform_regions_init() fails then your refcnt is wrong.  We
> switched to a mutex in vfio-pci to avoid this.  See 61d792562b53.
> 
> >  }
> >
> >  static long vfio_platform_ioctl(void *device_data, @@ -58,15 +125,33
> > @@ static long vfio_platform_ioctl(void *device_data,
> >  			return -EINVAL;
> >
> >  		info.flags = vdev->flags;
> > -		info.num_regions = 0;
> > +		info.num_regions = vdev->num_regions;
> >  		info.num_irqs = 0;
> >
> >  		return copy_to_user((void __user *)arg, &info, minsz);
> >
> > -	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
> > -		return -EINVAL;
> > +	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> > +		struct vfio_region_info info;
> > +
> > +		minsz = offsetofend(struct vfio_region_info, offset);
> > +
> > +		if (copy_from_user(&info, (void __user *)arg, minsz))
> > +			return -EFAULT;
> > +
> > +		if (info.argsz < minsz)
> > +			return -EINVAL;
> > +
> > +		if (info.index >= vdev->num_regions)
> > +			return -EINVAL;
> > +
> > +		/* map offset to the physical address  */
> > +		info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
> > +		info.size = vdev->regions[info.index].size;
> > +		info.flags = vdev->regions[info.index].flags;
> > +
> > +		return copy_to_user((void __user *)arg, &info, minsz);
> >
> > -	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
> > +	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
> >  		return -EINVAL;
> >
> >  	else if (cmd == VFIO_DEVICE_SET_IRQS) diff --git
> > a/drivers/vfio/platform/vfio_platform_private.h
> > b/drivers/vfio/platform/vfio_platform_private.h
> > index ef76737..2a06035 100644
> > --- a/drivers/vfio/platform/vfio_platform_private.h
> > +++ b/drivers/vfio/platform/vfio_platform_private.h
> > @@ -15,7 +15,29 @@
> >  #ifndef VFIO_PLATFORM_PRIVATE_H
> >  #define VFIO_PLATFORM_PRIVATE_H
> >
> > +#define VFIO_PLATFORM_OFFSET_SHIFT   40
> > +#define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) <<
> > +VFIO_PLATFORM_OFFSET_SHIFT) - 1)
> > +
> > +#define VFIO_PLATFORM_OFFSET_TO_INDEX(off)	\
> > +	(off >> VFIO_PLATFORM_OFFSET_SHIFT)
> > +
> > +#define VFIO_PLATFORM_INDEX_TO_OFFSET(index)	\
> > +	((u64)(index) << VFIO_PLATFORM_OFFSET_SHIFT)
> > +
> > +struct vfio_platform_region {
> > +	u64			addr;
> > +	resource_size_t		size;
> > +	u32			flags;
> > +	u32			type;
> > +#define VFIO_PLATFORM_REGION_TYPE_MMIO	1
> > +#define VFIO_PLATFORM_REGION_TYPE_PIO	2
> > +};
> > +
> >  struct vfio_platform_device {
> > +	struct vfio_platform_region	*regions;
> > +	u32				num_regions;
> > +	atomic_t			refcnt;
> > +
> >  	/*
> >  	 * These fields should be filled by the bus driver at binding time
> >  	 */
> 
> 
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
