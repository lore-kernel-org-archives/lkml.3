Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaCYQnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:43:55 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:45140 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaCYQnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:43:53 -0400
Message-ID: <5331B22C.6090100@linaro.org>
Date: Tue, 25 Mar 2014 17:43:24 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: a.motakis@virtualopensystems.com
CC: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, tech@virtualopensystems.com,
        a.rigo@virtualopensystems.com, B08248@freescale.com,
        kim.phillips@linaro.org, jan.kiszka@siemens.com, kvm@vger.kernel.org,
        R65777@freescale.com, B07421@freescale.com,
        christoffer.dall@linaro.org, agraf@suse.de, B16395@freescale.com,
        will.deacon@arm.com, a.motakis@virtualopensystems.com
Subject: Re: [RFC PATCH v4 06/10] VFIO_PLATFORM: Read and write support for
 the device fd
References: <20140325110619.52107df5d6d0cf0476b33cd4@linaro.org>
In-Reply-To: <20140325110619.52107df5d6d0cf0476b33cd4@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Date: Sat,  8 Feb 2014 18:29:36 +0100
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
> +				val = ioread32(io + off);

Hi Antonios,

I suspect there is an issue with the read address. Indeed io being an
unsigned int* the read address is io + off x sizeof (unsigned int) ie.
io+ offx4  whereas we expect to read io + off. declaring io as a void*
corrects the issue (or void __iomem *io). Same issue on write.

Best Regards

Eric

> +				if (copy_to_user(buf, &val, 4))
> +					goto err;
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
> 

