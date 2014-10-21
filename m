Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaJURrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:47:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaJURrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:47:35 -0400
Message-ID: <1413913638.4202.153.camel@ul30vt.home>
Subject: Re: [PATCH v8 13/18] vfio/platform: support for maskable and
 automasked interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        will.deacon@arm.com, tech@virtualopensystems.com,
        christoffer.dall@linaro.org, eric.auger@linaro.org,
        kim.phillips@freescale.com, marc.zyngier@arm.com,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 21 Oct 2014 11:47:18 -0600
In-Reply-To: <1413205825-6370-14-git-send-email-a.motakis@virtualopensystems.com>
References: <1413205825-6370-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1413205825-6370-14-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-13 at 15:10 +0200, Antonios Motakis wrote:
> Adds support to mask interrupts, and also for automasked interrupts.
> Level sensitive interrupts are exposed as automasked interrupts and
> are masked and disabled automatically when they fire.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/platform/vfio_platform_irq.c     | 94 +++++++++++++++++++++++++--
>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>  2 files changed, 91 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index 4359b9c..7620a17 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -31,27 +31,103 @@
>  
>  #include "vfio_platform_private.h"
>  
> +static void vfio_platform_mask(struct vfio_platform_irq *irq_ctx)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&irq_ctx->lock, flags);
> +
> +	if (!irq_ctx->masked) {
> +		disable_irq(irq_ctx->hwirq);
> +		irq_ctx->masked = true;
> +	}
> +
> +	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> +}
> +
>  static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
>  				    unsigned index, unsigned start,
>  				    unsigned count, uint32_t flags, void *data)
>  {
> -	return -EINVAL;
> +	if (start != 0 || count != 1)
> +		return -EINVAL;
> +
> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
> +		return -EINVAL; /* not implemented yet */
> +
> +	if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +		vfio_platform_mask(&vdev->irqs[index]);
> +
> +	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +		uint8_t mask = *(uint8_t *)data;
> +
> +		if (mask)
> +			vfio_platform_mask(&vdev->irqs[index]);
> +	}
> +
> +	return 0;
> +}
> +
> +static void vfio_platform_unmask(struct vfio_platform_irq *irq_ctx)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&irq_ctx->lock, flags);
> +
> +	if (irq_ctx->masked) {
> +		enable_irq(irq_ctx->hwirq);
> +		irq_ctx->masked = false;
> +	}
> +
> +	spin_unlock_irqrestore(&irq_ctx->lock, flags);
>  }
>  
>  static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
>  				    unsigned index, unsigned start,
>  				    unsigned count, uint32_t flags, void *data)
>  {
> -	return -EINVAL;
> +	if (start != 0 || count != 1)
> +		return -EINVAL;
> +
> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD)
> +		return -EINVAL; /* not implemented yet */
> +
> +	if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +		vfio_platform_unmask(&vdev->irqs[index]);
> +
> +	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
> +		uint8_t unmask = *(uint8_t *)data;
> +
> +		if (unmask)
> +			vfio_platform_unmask(&vdev->irqs[index]);
> +	}
> +
> +	return 0;
>  }
>  
>  static irqreturn_t vfio_irq_handler(int irq, void *dev_id)
>  {
>  	struct vfio_platform_irq *irq_ctx = dev_id;
> +	unsigned long flags;
> +	int ret = IRQ_NONE;
>  
> -	eventfd_signal(irq_ctx->trigger, 1);
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
> -	return IRQ_HANDLED;
> +	spin_unlock_irqrestore(&irq_ctx->lock, flags);
> +
> +	if (ret == IRQ_HANDLED)
> +		eventfd_signal(irq_ctx->trigger, 1);
> +
> +	return ret;
>  }

If you actually have edge interrupts, you're unnecessarily penalizing
them with the spinlock here.  You could do like vfio-pci and only
advertise level interrupts as maskable then use separate edge vs level
handlers.

>  
>  static int vfio_set_trigger(struct vfio_platform_device *vdev,
> @@ -169,9 +245,17 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  		if (hwirq < 0)
>  			goto err;
>  
> -		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
> +		spin_lock_init(&vdev->irqs[i].lock);
> +
> +		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD
> +					| VFIO_IRQ_INFO_MASKABLE;
> +
> +		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
> +			vdev->irqs[i].flags |= VFIO_IRQ_INFO_AUTOMASKED;
> +
>  		vdev->irqs[i].count = 1;
>  		vdev->irqs[i].hwirq = hwirq;
> +		vdev->irqs[i].masked = false;
>  	}
>  
>  	vdev->num_irqs = cnt;
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 47af6e0..65e80e7 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -30,6 +30,8 @@ struct vfio_platform_irq {
>  	int			hwirq;
>  	char			*name;
>  	struct eventfd_ctx	*trigger;
> +	bool			masked;
> +	spinlock_t		lock;
>  };
>  
>  struct vfio_platform_region {



