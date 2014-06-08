Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaFHKJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 06:09:32 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:51364 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaFHKJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 06:09:30 -0400
Date: Sun, 8 Jun 2014 12:09:24 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, tech@virtualopensystems.com,
        a.rigo@virtualopensystems.com, kvm@vger.kernel.org,
        will.deacon@arm.com, kim.phillips@freescale.com,
        stuart.yoder@freescale.com, eric.auger@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 14/20] vfio/platform: initial interrupts support
Message-ID: <20140608100924.GA3279@lvm>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-15-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401987808-23596-15-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 07:03:22PM +0200, Antonios Motakis wrote:
> This patch allows to set an eventfd for a patform device's interrupt,
> and also to trigger the interrupt eventfd from userspace for testing.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/platform/vfio_platform.c         |  36 ++++++-
>  drivers/vfio/platform/vfio_platform_irq.c     | 130 +++++++++++++++++++++++++-
>  drivers/vfio/platform/vfio_platform_private.h |   7 ++
>  3 files changed, 169 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 192291c..f4c06c6 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -177,10 +177,40 @@ static long vfio_platform_ioctl(void *device_data,
>  
>  		return copy_to_user((void __user *)arg, &info, minsz);
>  
> -	} else if (cmd == VFIO_DEVICE_SET_IRQS)
> -		return -EINVAL;
> +	} else if (cmd == VFIO_DEVICE_SET_IRQS) {
> +		struct vfio_irq_set hdr;
> +		int ret = 0;
> +
> +		minsz = offsetofend(struct vfio_irq_set, count);
> +
> +		if (copy_from_user(&hdr, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (hdr.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (hdr.index >= vdev->num_irqs)
> +			return -EINVAL;
> +
> +		if (hdr.start != 0 || hdr.count > 1)
> +			return -EINVAL;
> +
> +		if (hdr.count == 0 &&
> +			(!(hdr.flags & VFIO_IRQ_SET_DATA_NONE) ||
> +			 !(hdr.flags & VFIO_IRQ_SET_ACTION_TRIGGER)))
> +			return -EINVAL;
> +
> +		if (hdr.flags & ~(VFIO_IRQ_SET_DATA_TYPE_MASK |
> +				  VFIO_IRQ_SET_ACTION_TYPE_MASK))
> +			return -EINVAL;
> +
> +		ret = vfio_platform_set_irqs_ioctl(vdev, hdr.flags, hdr.index,
> +						   hdr.start, hdr.count,
> +						   (void *)arg+minsz);
> +
> +		return ret;
>  
> -	else if (cmd == VFIO_DEVICE_RESET)
> +	} else if (cmd == VFIO_DEVICE_RESET)
>  		return -EINVAL;
>  
>  	return -ENOTTY;
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index 22c214f..d79f5af 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -31,6 +31,9 @@
>  
>  #include "vfio_platform_private.h"
>  
> +static int vfio_set_trigger(struct vfio_platform_device *vdev,
> +			    int index, int fd);
> +
>  int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  {
>  	int cnt = 0, i;
> @@ -43,17 +46,142 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  		return -ENOMEM;
>  
>  	for (i = 0; i < cnt; i++) {
> -		vdev->irq[i].flags = 0;
> +		int hwirq = platform_get_irq(vdev->pdev, i);
> +
> +		if (hwirq < 0)
> +			goto err;
> +
> +		vdev->irq[i].flags = VFIO_IRQ_INFO_EVENTFD;
>  		vdev->irq[i].count = 1;
> +		vdev->irq[i].hwirq = hwirq;
>  	}
>  
>  	vdev->num_irqs = cnt;
>  
>  	return 0;
> +err:
> +	kfree(vdev->irq);
> +	return -EINVAL;
>  }
>  
>  void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>  {
> +	int i;
> +
> +	for (i = 0; i < vdev->num_irqs; i++)
> +		vfio_set_trigger(vdev, i, -1);
> +
>  	vdev->num_irqs = 0;
>  	kfree(vdev->irq);
>  }
> +
> +static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
> +{
> +	struct eventfd_ctx *trigger = dev_id;
> +
> +	eventfd_signal(trigger, 1);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int vfio_set_trigger(struct vfio_platform_device *vdev,
> +			    int index, int fd)
> +{
> +	struct vfio_platform_irq *irq = &vdev->irq[index];
> +	struct eventfd_ctx *trigger;
> +	int ret;
> +
> +	if (irq->trigger) {
> +		free_irq(irq->hwirq, irq);
> +		kfree(irq->name);
> +		eventfd_ctx_put(irq->trigger);
> +		irq->trigger = NULL;
> +	}

this feels incredibly racy, is some lock protecting this access?

-Christoffer
