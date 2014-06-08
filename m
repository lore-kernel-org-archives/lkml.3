Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaFHKRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 06:17:11 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:50297 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFHKRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 06:17:09 -0400
Date: Sun, 8 Jun 2014 12:17:03 +0200
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
Subject: Re: [RFC PATCH v6 15/20] vfio/platform: support for maskable and
 automasked interrupts
Message-ID: <20140608101703.GB3279@lvm>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
 <1401987808-23596-16-git-send-email-a.motakis@virtualopensystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401987808-23596-16-git-send-email-a.motakis@virtualopensystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 07:03:23PM +0200, Antonios Motakis wrote:
> Adds support to mask interrupts, and also for automasked interrupts.
> Level sensitive interrupts are exposed as automasked interrupts and
> are masked and disabled automatically when they fire.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/platform/vfio_platform_irq.c     | 112 ++++++++++++++++++++++++--
>  drivers/vfio/platform/vfio_platform_private.h |   2 +
>  2 files changed, 109 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
> index d79f5af..10dfbf0 100644
> --- a/drivers/vfio/platform/vfio_platform_irq.c
> +++ b/drivers/vfio/platform/vfio_platform_irq.c
> @@ -51,9 +51,17 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
>  		if (hwirq < 0)
>  			goto err;
>  
> -		vdev->irq[i].flags = VFIO_IRQ_INFO_EVENTFD;
> +		spin_lock_init(&vdev->irq[i].lock);
> +
> +		vdev->irq[i].flags = VFIO_IRQ_INFO_EVENTFD
> +					| VFIO_IRQ_INFO_MASKABLE;
> +
> +		if (irq_get_trigger_type(hwirq) & IRQ_TYPE_LEVEL_MASK)
> +			vdev->irq[i].flags |= VFIO_IRQ_INFO_AUTOMASKED;

This seems to rely on the fact that you had actually loaded a driver for
your device to set the right type.  Is this assumption always correct?

It seems to me that this configuration bit should now be up to your user
space drive who is the best candidate to know details about your device
at this point?

> +
>  		vdev->irq[i].count = 1;
>  		vdev->irq[i].hwirq = hwirq;
> +		vdev->irq[i].masked = false;
>  	}
>  
>  	vdev->num_irqs = cnt;
> @@ -77,11 +85,27 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
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
> @@ -162,6 +186,82 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>  	return -EFAULT;
>  }
>  
> +static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
> +				    unsigned index, unsigned start,
> +				    unsigned count, uint32_t flags, void *data)
> +{
> +	uint8_t arr;


arr?

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

why the fallthrough, what's this about?

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
> @@ -172,8 +272,10 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
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
> index d6200df..4d887fd 100644
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
> -- 
> 1.8.3.2
> 
