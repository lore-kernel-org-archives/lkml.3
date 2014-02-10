Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaBJWpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:45:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaBJWpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:45:49 -0500
Message-ID: <1392072326.15608.181.camel@ul30vt.home>
Subject: Re: [RFC PATCH v4 06/10] VFIO_PLATFORM: Read and write support for
 the device fd
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org, jan.kiszka@siemens.com,
        kvm@vger.kernel.org, R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com
Date: Mon, 10 Feb 2014 15:45:26 -0700
In-Reply-To: <1391880580-471-7-git-send-email-a.motakis@virtualopensystems.com>
References: <1391880580-471-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1391880580-471-7-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-08 at 18:29 +0100, Antonios Motakis wrote:
> VFIO returns a file descriptor which we can use to manipulate the memory
> regions of the device. Since some memory regions we cannot mmap due to
> security concerns, we also allow to read and write to this file descriptor
> directly.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> Tested-by: Alvise Rigo <a.rigo@virtualopensystems.com>
> ---
>  drivers/vfio/platform/vfio_platform.c | 128 +++++++++++++++++++++++++++++++++-
>  1 file changed, 125 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index f7db5c0..ee96078 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -55,7 +55,8 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>  
>  		region.addr = res->start;
>  		region.size = resource_size(res);
> -		region.flags = 0;
> +		region.flags = VFIO_REGION_INFO_FLAG_READ
> +				| VFIO_REGION_INFO_FLAG_WRITE;
>  
>  		vdev->region[i] = region;
>  	}
> @@ -150,13 +151,134 @@ static long vfio_platform_ioctl(void *device_data,
>  static ssize_t vfio_platform_read(void *device_data, char __user *buf,
>  			     size_t count, loff_t *ppos)
>  {
> -	return 0;
> +	struct vfio_platform_device *vdev = device_data;
> +	unsigned int *io;
> +	int i;
> +
> +	for (i = 0; i < vdev->num_regions; i++) {
> +		struct vfio_platform_region region = vdev->region[i];
> +		unsigned int done = 0;
> +		loff_t off;
> +
> +		if ((*ppos < region.addr)
> +		     || (*ppos + count - 1) >= (region.addr + region.size))
> +			continue;

Perhaps there's something to be said for vfio-pci's use of fixed offsets
to have a direct offset to index lookup.

> +
> +		io = ioremap_nocache(region.addr, region.size);

This must incur some overhead per access.

> +
> +		off = *ppos - region.addr;
> +
> +		while (count) {
> +			size_t filled;
> +
> +			if (count >= 4 && !(off % 4)) {
> +				u32 val;
> +
> +				val = ioread32(io + off);
> +				if (copy_to_user(buf, &val, 4))
> +					goto err;

For vfio-pci we've decided that these interfaces are always little
endian, have you considered whether it makes sense to do something
similar here?  Thanks,

Alex

> +
> +				filled = 4;
> +			} else if (count >= 2 && !(off % 2)) {
> +				u16 val;
> +
> +				val = ioread16(io + off);
> +				if (copy_to_user(buf, &val, 2))
> +					goto err;
> +
> +				filled = 2;
> +			} else {
> +				u8 val;
> +
> +				val = ioread8(io + off);
> +				if (copy_to_user(buf, &val, 1))
> +					goto err;
> +
> +				filled = 1;
> +			}
> +
> +
> +			count -= filled;
> +			done += filled;
> +			off += filled;
> +			buf += filled;
> +		}
> +
> +		iounmap(io);
> +		return done;
> +	}
> +
> +	return -EFAULT;
> +
> +err:
> +	iounmap(io);
> +	return -EFAULT;
>  }
>  
>  static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
>  			      size_t count, loff_t *ppos)
>  {
> -	return 0;
> +	struct vfio_platform_device *vdev = device_data;
> +	unsigned int *io;
> +	int i;
> +
> +	for (i = 0; i < vdev->num_regions; i++) {
> +		struct vfio_platform_region region = vdev->region[i];
> +		unsigned int done = 0;
> +		loff_t off;
> +
> +		if ((*ppos < region.addr)
> +		     || (*ppos + count - 1) >= (region.addr + region.size))
> +			continue;
> +
> +		io = ioremap_nocache(region.addr, region.size);
> +
> +		off = *ppos - region.addr;
> +
> +		while (count) {
> +			size_t filled;
> +
> +			if (count >= 4 && !(off % 4)) {
> +				u32 val;
> +
> +				if (copy_from_user(&val, buf, 4))
> +					goto err;
> +				iowrite32(val, io + off);
> +
> +				filled = 4;
> +			} else if (count >= 2 && !(off % 2)) {
> +				u16 val;
> +
> +				if (copy_from_user(&val, buf, 2))
> +					goto err;
> +				iowrite16(val, io + off);
> +
> +				filled = 2;
> +			} else {
> +				u8 val;
> +
> +				if (copy_from_user(&val, buf, 1))
> +					goto err;
> +				iowrite8(val, io + off);
> +
> +				filled = 1;
> +			}
> +
> +			count -= filled;
> +			done += filled;
> +			off += filled;
> +			buf += filled;
> +		}
> +
> +		iounmap(io);
> +		return done;
> +	}
> +
> +	return -EINVAL;
> +
> +err:
> +	iounmap(io);
> +	return -EFAULT;
>  }
>  
>  static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)



