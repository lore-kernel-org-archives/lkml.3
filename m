Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbaD1Tmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:42:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbaD1Tmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:42:42 -0400
Message-ID: <1398705857.24318.284.camel@ul30vt.home>
Subject: Re: [RFC PATCH v5 07/11] VFIO_PLATFORM: Read and write support for
 the device fd
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 28 Apr 2014 11:24:17 -0600
In-Reply-To: <1398700371-20096-8-git-send-email-a.motakis@virtualopensystems.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1398700371-20096-8-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 17:52 +0200, Antonios Motakis wrote:
> VFIO returns a file descriptor which we can use to manipulate the memory
> regions of the device. Since some memory regions we cannot mmap due to
> security concerns, we also allow to read and write to this file descriptor
> directly.

If there are regions we cannot mmap for security, why do we provide full
read/write access to them?

> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/platform/vfio_platform.c | 110 +++++++++++++++++++++++++++++++++-
>  1 file changed, 107 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 5430cbe..7c01ced 100644
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
> @@ -153,13 +154,116 @@ static long vfio_platform_ioctl(void *device_data,
>  static ssize_t vfio_platform_read(void *device_data, char __user *buf,
>  			     size_t count, loff_t *ppos)
>  {
> -	return 0;
> +	struct vfio_platform_device *vdev = device_data;
> +	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
> +	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
> +	unsigned int done = 0;
> +	void __iomem *io;
> +
> +	if (index >= vdev->num_regions)
> +		return -EINVAL;
> +
> +	io = ioremap_nocache(vdev->region[index].addr,
> +			     vdev->region[index].size);

I haven't looked at ioremap on arm, but if it's remotely non-trivially,
it's probably a good idea to do this only on first access, cache it, and
unmap it on region cleanup.  Thanks,

Alex

> +
> +	while (count) {
> +		size_t filled;
> +
> +		if (count >= 4 && !(off % 4)) {
> +			u32 val;
> +
> +			val = ioread32(io + off);
> +			if (copy_to_user(buf, &val, 4))
> +				goto err;
> +
> +			filled = 4;
> +		} else if (count >= 2 && !(off % 2)) {
> +			u16 val;
> +
> +			val = ioread16(io + off);
> +			if (copy_to_user(buf, &val, 2))
> +				goto err;
> +
> +			filled = 2;
> +		} else {
> +			u8 val;
> +
> +			val = ioread8(io + off);
> +			if (copy_to_user(buf, &val, 1))
> +				goto err;
> +
> +			filled = 1;
> +		}
> +
> +
> +		count -= filled;
> +		done += filled;
> +		off += filled;
> +		buf += filled;
> +	}
> +
> +	iounmap(io);
> +	return done;
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
> +	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
> +	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
> +	unsigned int done = 0;
> +	void __iomem *io;
> +
> +	if (index >= vdev->num_regions)
> +		return -EINVAL;
> +
> +	io = ioremap_nocache(vdev->region[index].addr,
> +			     vdev->region[index].size);
> +
> +	while (count) {
> +		size_t filled;
> +
> +		if (count >= 4 && !(off % 4)) {
> +			u32 val;
> +
> +			if (copy_from_user(&val, buf, 4))
> +				goto err;
> +			iowrite32(val, io + off);
> +
> +			filled = 4;
> +		} else if (count >= 2 && !(off % 2)) {
> +			u16 val;
> +
> +			if (copy_from_user(&val, buf, 2))
> +				goto err;
> +			iowrite16(val, io + off);
> +
> +			filled = 2;
> +		} else {
> +			u8 val;
> +
> +			if (copy_from_user(&val, buf, 1))
> +				goto err;
> +			iowrite8(val, io + off);
> +
> +			filled = 1;
> +		}
> +
> +		count -= filled;
> +		done += filled;
> +		off += filled;
> +		buf += filled;
> +	}
> +
> +	iounmap(io);
> +	return done;
> +err:
> +	iounmap(io);
> +	return -EFAULT;
>  }
>  
>  static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)



