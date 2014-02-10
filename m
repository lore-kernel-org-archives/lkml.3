Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaBJWcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:32:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbaBJWcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:32:48 -0500
Message-ID: <1392071540.15608.173.camel@ul30vt.home>
Subject: Re: [RFC PATCH v4 05/10] VFIO_PLATFORM: Return info for device and
 its memory mapped IO regions
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org, jan.kiszka@siemens.com,
        kvm@vger.kernel.org, R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com, Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Date: Mon, 10 Feb 2014 15:32:20 -0700
In-Reply-To: <1391880580-471-6-git-send-email-a.motakis@virtualopensystems.com>
References: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1391880580-471-6-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-08 at 18:29 +0100, Antonios Motakis wrote:
> A VFIO userspace driver will start by opening the VFIO device
> that corresponds to an IOMMU group, and will use the ioctl interface
> to get the basic device info, such as number of memory regions and
> interrupts, and their properties.
> 
> This patch enables the IOCTLs:
>  - VFIO_DEVICE_GET_INFO
>  - VFIO_DEVICE_GET_REGION_INFO
> 
>  IRQ info is provided by one of the latter patches.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/platform/vfio_platform.c         | 74 ++++++++++++++++++++++++---
>  drivers/vfio/platform/vfio_platform_private.h |  8 +++
>  2 files changed, 76 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index a3d8f29..f7db5c0 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -34,15 +34,62 @@
>  #define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
>  #define DRIVER_DESC     "VFIO for platform devices - User Level meta-driver"
>  
> +static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
> +{
> +	int cnt = 0, i;
> +
> +	while (platform_get_resource(vdev->pdev, IORESOURCE_MEM, cnt))
> +		cnt++;
> +
> +	vdev->num_regions = cnt;
> +
> +	vdev->region = kzalloc(sizeof(struct vfio_platform_region) * cnt,
> +				GFP_KERNEL);
> +	if (!vdev->region)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < cnt;  i++) {
> +		struct vfio_platform_region region;
> +		struct resource *res =
> +			platform_get_resource(vdev->pdev, IORESOURCE_MEM, i);
> +
> +		region.addr = res->start;
> +		region.size = resource_size(res);
> +		region.flags = 0;
> +
> +		vdev->region[i] = region;
> +	}
> +
> +	return 0;
> +}
> +
> +static void vfio_platform_regions_cleanup(struct vfio_platform_device *vdev)
> +{
> +	kfree(vdev->region);
> +}
> +
>  static void vfio_platform_release(void *device_data)
>  {
> +	struct vfio_platform_device *vdev = device_data;
> +
> +	vfio_platform_regions_cleanup(vdev);
> +
>  	module_put(THIS_MODULE);
>  }
>  
>  static int vfio_platform_open(void *device_data)
>  {
> -	if (!try_module_get(THIS_MODULE))
> +	struct vfio_platform_device *vdev = device_data;
> +	int ret;
> +
> +	ret = vfio_platform_regions_init(vdev);
> +	if (ret)
> +		return ret;
> +
> +	if (!try_module_get(THIS_MODULE)) {
> +		vfio_platform_regions_cleanup(vdev);
>  		return -ENODEV;
> +	}
>  
>  	return 0;
>  }
> @@ -65,18 +112,33 @@ static long vfio_platform_ioctl(void *device_data,
>  			return -EINVAL;
>  
>  		info.flags = VFIO_DEVICE_FLAGS_PLATFORM;
> -		info.num_regions = 0;
> +		info.num_regions = vdev->num_regions;
>  		info.num_irqs = 0;
>  
>  		return copy_to_user((void __user *)arg, &info, minsz);
>  
> -	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO)
> -		return -EINVAL;
> +	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> +		struct vfio_region_info info;
> +
> +		minsz = offsetofend(struct vfio_region_info, offset);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;

Missing a bounds check for info.index, user could be getting back kernel
data here.  Thanks,

Alex

> +
> +		/* map offset to the physical address  */
> +		info.offset = vdev->region[info.index].addr;
> +		info.size = vdev->region[info.index].size;
> +		info.flags = vdev->region[info.index].flags;
> +
> +		return copy_to_user((void __user *)arg, &info, minsz);
>  
> -	else if (cmd == VFIO_DEVICE_GET_IRQ_INFO)
> +	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>  		return -EINVAL;
>  
> -	else if (cmd == VFIO_DEVICE_SET_IRQS)
> +	} else if (cmd == VFIO_DEVICE_SET_IRQS)
>  		return -EINVAL;
>  
>  	else if (cmd == VFIO_DEVICE_RESET)
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 6df8084..4705aa5 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -15,8 +15,16 @@
>  #ifndef VFIO_PLATFORM_PRIVATE_H
>  #define VFIO_PLATFORM_PRIVATE_H
>  
> +struct vfio_platform_region {
> +	u64			addr;
> +	resource_size_t		size;
> +	u32			flags;
> +};
> +
>  struct vfio_platform_device {
>  	struct platform_device		*pdev;
> +	struct vfio_platform_region	*region;
> +	u32				num_regions;
>  };
>  
>  #endif /* VFIO_PCI_PRIVATE_H */



