Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbaD1Tlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:41:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096AbaD1Tlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:41:39 -0400
Message-ID: <1398707198.24318.293.camel@ul30vt.home>
Subject: Re: [RFC PATCH v5 11/11] VFIO_PLATFORM: Support for maskable and
 automasked interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 28 Apr 2014 11:46:38 -0600
In-Reply-To: <1398700371-20096-12-git-send-email-a.motakis@virtualopensystems.com>
References: <1398700371-20096-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1398700371-20096-12-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 17:52 +0200, Antonios Motakis wrote:
> Adds support to mask interrupts, and also for automasked interrupts.
> Level sensitive interrupts are exposed as automasked interrupts and
> are masked and disabled automatically when they fire.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/platform/vfio_platform_irq.c     | 117 ++++++++++++++++++++++++--
>  drivers/vfio/platform/vfio_platform_private.h |   2 +
>  2 files changed, 113 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index 433edc1..e38982f 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -52,9 +52,16 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  		struct vfio_platform_irq irq;
>  		int hwirq = platform_get_irq(vdev->pdev, i);
>  
> -		irq.flags = VFIO_IRQ_INFO_EVENTFD;
> +		spin_lock_init(&irq.lock);
> +
> +		irq.flags = VFIO_IRQ_INFO_EVENTFD | VFIO_IRQ_INFO_MASKABLE;
> +
> +		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
> +			irq.flags |= VFIO_IRQ_INFO_AUTOMASKED;
> +
>  		irq.count = 1;
>  		irq.hwirq = hwirq;
> +		irq.masked = false;
>  
>  		vdev->irq[i] = irq;
>  	}
> @@ -66,19 +73,39 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
>  {
>  	int i;
>  
> -	for (i = 0; i < vdev->num_irqs; i++)
> +	for (i = 0; i < vdev->num_irqs; i++) {
>  		vfio_set_trigger(vdev, i, -1);
>  
> +		if (vdev->irq[i].masked)
> +			enable_irq(vdev->irq[i].hwirq);

This looks suspicious.  set_trigger(,, -1) calls free_irq() and here we
enable_irq().  Shouldn't the nexe user's call to request_irq() be
sufficient to re-enable it?  Thanks,

Alex

> +	}
> +
>  	kfree(vdev->irq);
>  }
>  
>  static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
>  {
> -	struct eventfd_ctx *trigger = dev_id;
> +	struct vfio_platform_irq *irq_ctx = dev_id;
> +	unsigned long flags;
> +	int ret = IRQ_NONE;
> +
> +	spin_lock_irqsave(&irq_ctx->lock, flags);
> +
> +	if (!irq_ctx->masked) {
> +		ret = IRQ_HANDLED;
> +
> +		if (irq_ctx->flags & VFIO_IRQ_INFO_AUTOMASKED) {
> +			disable_irq_nosync(irq_ctx->hwirq);
> +			irq_ctx->masked = true;
> +		}
> +	}
>  
> -	eventfd_signal(trigger, 1);
> +	spin_unlock_irqrestore(&irq_ctx->lock, flags);
>  
> -	return IRQ_HANDLED;
> +	if (ret == IRQ_HANDLED)
> +		eventfd_signal(irq_ctx->trigger, 1);
> +
> +	return ret;
>  }
>  
>  static int vfio_set_trigger(struct vfio_platform_device *vdev,
> @@ -159,6 +186,82 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>  	return -EFAULT;
>  }
>  
> +static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
> +				    unsigned index, unsigned start,
> +				    unsigned count, uint32_t flags, void *data)
> +{
> +	uint8_t arr;
> +
> +	if (start != 0 || count != 1)
> +		return -EINVAL;
> +
> +	switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
> +	case VFIO_IRQ_SET_DATA_BOOL:
> +		if (copy_from_user(&arr, data, sizeof(uint8_t)))
> +			return -EFAULT;
> +
> +		if (arr != 0x1)
> +			return -EINVAL;
> +
> +	case VFIO_IRQ_SET_DATA_NONE:
> +
> +		spin_lock_irq(&vdev->irq[index].lock);
> +
> +		if (vdev->irq[index].masked) {
> +			enable_irq(vdev->irq[index].hwirq);
> +			vdev->irq[index].masked = false;
> +		}
> +
> +		spin_unlock_irq(&vdev->irq[index].lock);
> +
> +		return 0;
> +
> +	case VFIO_IRQ_SET_DATA_EVENTFD: /* XXX not implemented yet */
> +	default:
> +		return -ENOTTY;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
> +				    unsigned index, unsigned start,
> +				    unsigned count, uint32_t flags, void *data)
> +{
> +	uint8_t arr;
> +
> +	if (start != 0 || count != 1)
> +		return -EINVAL;
> +
> +	switch (flags & VFIO_IRQ_SET_DATA_TYPE_MASK) {
> +	case VFIO_IRQ_SET_DATA_BOOL:
> +		if (copy_from_user(&arr, data, sizeof(uint8_t)))
> +			return -EFAULT;
> +
> +		if (arr != 0x1)
> +			return -EINVAL;
> +
> +	case VFIO_IRQ_SET_DATA_NONE:
> +
> +		spin_lock_irq(&vdev->irq[index].lock);
> +
> +		if (!vdev->irq[index].masked) {
> +			disable_irq(vdev->irq[index].hwirq);
> +			vdev->irq[index].masked = true;
> +		}
> +
> +		spin_unlock_irq(&vdev->irq[index].lock);
> +
> +		return 0;
> +
> +	case VFIO_IRQ_SET_DATA_EVENTFD: /* XXX not implemented yet */
> +	default:
> +		return -ENOTTY;
> +	}
> +
> +	return 0;
> +}
> +
>  int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>  				 uint32_t flags, unsigned index, unsigned start,
>  				 unsigned count, void *data)
> @@ -169,8 +272,10 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>  
>  	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
>  	case VFIO_IRQ_SET_ACTION_MASK:
> +		func = vfio_platform_set_irq_mask;
> +		break;
>  	case VFIO_IRQ_SET_ACTION_UNMASK:
> -		/* XXX not implemented */
> +		func = vfio_platform_set_irq_unmask;
>  		break;
>  	case VFIO_IRQ_SET_ACTION_TRIGGER:
>  		func = vfio_platform_set_irq_trigger;
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index e21c15a..e283171 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -30,6 +30,8 @@ struct vfio_platform_irq {
>  	u32			count;
>  	int			hwirq;
>  	char			*name;
> +	bool			masked;
> +	spinlock_t		lock;
>  };
>  
>  struct vfio_platform_region {



