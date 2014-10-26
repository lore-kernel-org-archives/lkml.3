Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaJZL53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 07:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaJZL51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 07:57:27 -0400
Date: Sun, 26 Oct 2014 13:56:46 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "john.liuli" <john.liuli@huawei.com>
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        peter.huangpeng@huawei.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        n.nikolaev@virtualopensystems.com, yingshiuan.pan@gmail.com,
        remy.gauguey@cea.fr, joel.schopp@amd.com
Subject: Re: [RFC PATCH 2/2] Assign a new irq handler while irqfd enabled
Message-ID: <20141026115646.GB5497@redhat.com>
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>
 <1414225494-2208-3-git-send-email-john.liuli@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414225494-2208-3-git-send-email-john.liuli@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 04:24:54PM +0800, john.liuli wrote:
> From: Li Liu <john.liuli@huawei.com>
> 
> This irq handler will get the interrupt reason from a
> shared memory. And will be assigned only while irqfd
> enabled.
> 
> Signed-off-by: Li Liu <john.liuli@huawei.com>
> ---
>  drivers/virtio/virtio_mmio.c |   34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index 28ddb55..7229605 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -259,7 +259,31 @@ static irqreturn_t vm_interrupt(int irq, void *opaque)
>  	return ret;
>  }
>  
> +/* Notify all virtqueues on an interrupt. */
> +static irqreturn_t vm_interrupt_irqfd(int irq, void *opaque)
> +{
> +	struct virtio_mmio_device *vm_dev = opaque;
> +	struct virtio_mmio_vq_info *info;
> +	unsigned long status;
> +	unsigned long flags;
> +	irqreturn_t ret = IRQ_NONE;
>  
> +	/* Read the interrupt reason and reset it */
> +	status = *vm_dev->isr_mem;
> +	*vm_dev->isr_mem = 0x0;

you are reading and modifying shared memory
without atomics and any memory barriers.
Why is this safe?

> +
> +	if (unlikely(status & VIRTIO_MMIO_INT_CONFIG)) {
> +		virtio_config_changed(&vm_dev->vdev);
> +		ret = IRQ_HANDLED;
> +	}
> +
> +	spin_lock_irqsave(&vm_dev->lock, flags);
> +	list_for_each_entry(info, &vm_dev->virtqueues, node)
> +		ret |= vring_interrupt(irq, info->vq);
> +	spin_unlock_irqrestore(&vm_dev->lock, flags);
> +
> +	return ret;
> +}
>  
>  static void vm_del_vq(struct virtqueue *vq)
>  {

So you invoke callbacks for all VQs.
This won't scale well as the number of VQs grows, will it?

> @@ -391,6 +415,7 @@ error_available:
>  	return ERR_PTR(err);
>  }
>  
> +#define VIRTIO_MMIO_F_IRQFD        (1 << 7)
>  static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  		       struct virtqueue *vqs[],
>  		       vq_callback_t *callbacks[],
> @@ -400,8 +425,13 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>  	unsigned int irq = platform_get_irq(vm_dev->pdev, 0);
>  	int i, err;
>  
> -	err = request_irq(irq, vm_interrupt, IRQF_SHARED,
> -			dev_name(&vdev->dev), vm_dev);
> +	if (*vm_dev->isr_mem & VIRTIO_MMIO_F_IRQFD) {
> +		err = request_irq(irq, vm_interrupt_irqfd, IRQF_SHARED,
> +				  dev_name(&vdev->dev), vm_dev);
> +	} else {
> +		err = request_irq(irq, vm_interrupt, IRQF_SHARED,
> +				  dev_name(&vdev->dev), vm_dev);
> +	}
>  	if (err)
>  		return err;


So still a single interrupt for all VQs.
Again this doesn't scale: a single CPU has to handle
interrupts for all of them.
I think you need to find a way to get per-VQ interrupts.

> -- 
> 1.7.9.5
> 
