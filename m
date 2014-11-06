Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbaKFLJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:09:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbaKFLJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:09:57 -0500
Date: Thu, 6 Nov 2014 13:09:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: linux-kernel@vger.kernel.org, peter.maydell@linaro.org,
        john.liuli@huawei.com, joel.schopp@amd.com, remy.gauguey@cea.fr,
        qemu-devel@nongnu.org, n.nikolaev@virtualopensystems.com,
        virtualization@lists.linux-foundation.org, peter.huangpeng@huawei.com,
        hangaohuai@huawei.com
Subject: Re: [RFC PATCH] virtio-mmio: support for multiple irqs
Message-ID: <20141106110929.GA16309@redhat.com>
References: <1415093712-15156-1-git-send-email-zhaoshenglong@huawei.com>
 <20141106093448.GA15417@redhat.com>
 <545B456E.5050308@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B456E.5050308@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:54:54PM +0800, Shannon Zhao wrote:
> On 2014/11/6 17:34, Michael S. Tsirkin wrote:
> > On Tue, Nov 04, 2014 at 05:35:12PM +0800, Shannon Zhao wrote:
> >> As the current virtio-mmio only support single irq,
> >> so some advanced features such as vhost-net with irqfd
> >> are not supported. And the net performance is not
> >> the best without vhost-net and irqfd supporting.
> >>
> >> This patch support virtio-mmio to request multiple
> >> irqs like virtio-pci. With this patch and qemu assigning
> >> multiple irqs for virtio-mmio device, it's ok to use
> >> vhost-net with irqfd on arm/arm64.
> >>
> >> As arm doesn't support msi-x now, we use GSI for
> >> multiple irq. In this patch we use "vm_try_to_find_vqs"
> >> to check whether multiple irqs are supported like
> >> virtio-pci.
> >>
> >> Is this the right direction? is there other ways to
> >> make virtio-mmio support multiple irq? Hope for feedback.
> >> Thanks.
> >>
> >> Signed-off-by: Shannon Zhao <zhaoshenglong@huawei.com>
> > 
> > 
> > So how does guest discover whether host device supports multiple IRQs?
> 
> Guest uses vm_try_to_find_vqs to check whether it can get multiple IRQs
> like virtio-pci uses vp_try_to_find_vqs. And within function
> vm_request_multiple_irqs, guest check whether the number of IRQs host
> device gives is equal to the number we want.

OK but how does host specify the number of IRQs for a device?
for pci this is done through the MSI-X capability register.

> 	for (i = 0; i < nirqs; i++) {
> 		irq = platform_get_irq(vm_dev->pdev, i);
> 		if (irq == -ENXIO)
> 			goto error;
> 	}
> 
> If we can't get the expected number of IRQs, return error and this try
> fails. Then guest will try two IRQS and single IRQ like virtio-pci.
> 
> > Could you please document the new interface?
> > E.g. send a patch for virtio spec.
> 
> Ok, I'll send it later. Thank you very much :)
> 
> Shannon
> 
> > I think this really should be controlled by hypervisor, per device.
> > I'm also tempted to make this a virtio 1.0 only feature.
> > 
> > 
> > 
> >> ---
> >>  drivers/virtio/virtio_mmio.c |  234 ++++++++++++++++++++++++++++++++++++------
> >>  1 files changed, 203 insertions(+), 31 deletions(-)
> >>
> >> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> >> index c600ccf..2b7d935 100644
> >> --- a/drivers/virtio/virtio_mmio.c
> >> +++ b/drivers/virtio/virtio_mmio.c
> >> @@ -122,6 +122,15 @@ struct virtio_mmio_device {
> >>  	/* a list of queues so we can dispatch IRQs */
> >>  	spinlock_t lock;
> >>  	struct list_head virtqueues;
> >> +
> >> +	/* multiple irq support */
> >> +	int single_irq_enabled;
> >> +	/* Number of available irqs */
> >> +	unsigned num_irqs;
> >> +	/* Used number of irqs */
> >> +	int used_irqs;
> >> +	/* Name strings for interrupts. */
> >> +	char (*vm_vq_names)[256];
> >>  };
> >>  
> >>  struct virtio_mmio_vq_info {
> >> @@ -229,33 +238,53 @@ static bool vm_notify(struct virtqueue *vq)
> >>  	return true;
> >>  }
> >>  
> >> +/* Handle a configuration change: Tell driver if it wants to know. */
> >> +static irqreturn_t vm_config_changed(int irq, void *opaque)
> >> +{
> >> +	struct virtio_mmio_device *vm_dev = opaque;
> >> +	struct virtio_driver *vdrv = container_of(vm_dev->vdev.dev.driver,
> >> +		struct virtio_driver, driver);
> >> +
> >> +	if (vdrv && vdrv->config_changed)
> >> +		vdrv->config_changed(&vm_dev->vdev);
> >> +	return IRQ_HANDLED;
> >> +}
> >> +
> >>  /* Notify all virtqueues on an interrupt. */
> >> -static irqreturn_t vm_interrupt(int irq, void *opaque)
> >> +static irqreturn_t vm_vring_interrupt(int irq, void *opaque)
> >>  {
> >>  	struct virtio_mmio_device *vm_dev = opaque;
> >>  	struct virtio_mmio_vq_info *info;
> >> -	struct virtio_driver *vdrv = container_of(vm_dev->vdev.dev.driver,
> >> -			struct virtio_driver, driver);
> >> -	unsigned long status;
> >> +	irqreturn_t ret = IRQ_NONE;
> >>  	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&vm_dev->lock, flags);
> >> +	list_for_each_entry(info, &vm_dev->virtqueues, node) {
> >> +		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
> >> +			ret = IRQ_HANDLED;
> >> +	}
> >> +	spin_unlock_irqrestore(&vm_dev->lock, flags);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/* Notify all virtqueues and handle a configuration
> >> + * change on an interrupt. */
> >> +static irqreturn_t vm_interrupt(int irq, void *opaque)
> >> +{
> >> +	struct virtio_mmio_device *vm_dev = opaque;
> >> +	unsigned long status;
> >>  	irqreturn_t ret = IRQ_NONE;
> >>  
> >>  	/* Read and acknowledge interrupts */
> >>  	status = readl(vm_dev->base + VIRTIO_MMIO_INTERRUPT_STATUS);
> >>  	writel(status, vm_dev->base + VIRTIO_MMIO_INTERRUPT_ACK);
> >>  
> >> -	if (unlikely(status & VIRTIO_MMIO_INT_CONFIG)
> >> -			&& vdrv && vdrv->config_changed) {
> >> -		vdrv->config_changed(&vm_dev->vdev);
> >> -		ret = IRQ_HANDLED;
> >> -	}
> >> +	if (unlikely(status & VIRTIO_MMIO_INT_CONFIG))
> >> +		return vm_config_changed(irq, opaque);
> >>  
> >> -	if (likely(status & VIRTIO_MMIO_INT_VRING)) {
> >> -		spin_lock_irqsave(&vm_dev->lock, flags);
> >> -		list_for_each_entry(info, &vm_dev->virtqueues, node)
> >> -			ret |= vring_interrupt(irq, info->vq);
> >> -		spin_unlock_irqrestore(&vm_dev->lock, flags);
> >> -	}
> >> +	if (likely(status & VIRTIO_MMIO_INT_VRING))
> >> +		return vm_vring_interrupt(irq, opaque);
> >>  
> >>  	return ret;
> >>  }
> >> @@ -284,18 +313,98 @@ static void vm_del_vq(struct virtqueue *vq)
> >>  	kfree(info);
> >>  }
> >>  
> >> -static void vm_del_vqs(struct virtio_device *vdev)
> >> +static void vm_free_irqs(struct virtio_device *vdev)
> >>  {
> >> +	int i;
> >>  	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
> >> +
> >> +	if (vm_dev->single_irq_enabled) {
> >> +		free_irq(platform_get_irq(vm_dev->pdev, 0), vm_dev);
> >> +		vm_dev->single_irq_enabled = 0;
> >> +	}
> >> +
> >> +	for (i = 0; i < vm_dev->used_irqs; ++i)
> >> +		free_irq(platform_get_irq(vm_dev->pdev, i), vm_dev);
> >> +
> >> +	vm_dev->num_irqs = 0;
> >> +	vm_dev->used_irqs = 0;
> >> +	kfree(vm_dev->vm_vq_names);
> >> +	vm_dev->vm_vq_names = NULL;
> >> +}
> >> +
> >> +static void vm_del_vqs(struct virtio_device *vdev)
> >> +{
> >>  	struct virtqueue *vq, *n;
> >>  
> >>  	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
> >>  		vm_del_vq(vq);
> >>  
> >> -	free_irq(platform_get_irq(vm_dev->pdev, 0), vm_dev);
> >> +	vm_free_irqs(vdev);
> >> +}
> >> +
> >> +static int vm_request_multiple_irqs(struct virtio_device *vdev, int nirqs,
> >> +		bool per_vq_irq)
> >> +{
> >> +	int err = -ENOMEM;
> >> +	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
> >> +	unsigned i, v;
> >> +	int irq = 0;
> >> +
> >> +	vm_dev->num_irqs = nirqs;
> >> +	vm_dev->used_irqs = 0;
> >> +
> >> +	vm_dev->vm_vq_names = kmalloc_array(nirqs, sizeof(*vm_dev->vm_vq_names),
> >> +				     GFP_KERNEL);
> >> +	if (!vm_dev->vm_vq_names)
> >> +		goto error;
> >> +
> >> +	for (i = 0; i < nirqs; i++) {
> >> +		irq = platform_get_irq(vm_dev->pdev, i);
> >> +		if (irq == -ENXIO)
> >> +			goto error;
> >> +	}
> >> +
> >> +	/* Set the irq used for configuration */
> >> +	v = vm_dev->used_irqs;
> >> +	snprintf(vm_dev->vm_vq_names[v], sizeof(*vm_dev->vm_vq_names),
> >> +		 "%s-config", dev_name(&vdev->dev));
> >> +	irq = platform_get_irq(vm_dev->pdev, v);
> >> +	err = request_irq(irq, vm_config_changed, 0,
> >> +		vm_dev->vm_vq_names[v], vm_dev);
> >> +	++vm_dev->used_irqs;
> >> +	if (err)
> >> +		goto error;
> >> +
> >> +	if (!per_vq_irq) {
> >> +		/* Shared irq for all VQs */
> >> +		v = vm_dev->used_irqs;
> >> +		snprintf(vm_dev->vm_vq_names[v], sizeof(*vm_dev->vm_vq_names),
> >> +			 "%s-virtqueues", dev_name(&vdev->dev));
> >> +		irq = platform_get_irq(vm_dev->pdev, v);
> >> +		err = request_irq(irq, vm_vring_interrupt, 0,
> >> +			vm_dev->vm_vq_names[v], vm_dev);
> >> +		if (err)
> >> +			goto error;
> >> +		++vm_dev->used_irqs;
> >> +	}
> >> +	return 0;
> >> +error:
> >> +	vm_free_irqs(vdev);
> >> +	return err;
> >>  }
> >>  
> >> +static int vm_request_single_irq(struct virtio_device *vdev)
> >> +{
> >> +	int err;
> >> +	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
> >> +	int irq = platform_get_irq(vm_dev->pdev, 0);
> >>  
> >> +	err = request_irq(irq, vm_interrupt, IRQF_SHARED,
> >> +		dev_name(&vdev->dev), vm_dev);
> >> +	if (!err)
> >> +		vm_dev->single_irq_enabled = 1;
> >> +	return err;
> >> +}
> >>  
> >>  static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
> >>  				  void (*callback)(struct virtqueue *vq),
> >> @@ -392,29 +501,92 @@ error_available:
> >>  	return ERR_PTR(err);
> >>  }
> >>  
> >> -static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> >> -		       struct virtqueue *vqs[],
> >> -		       vq_callback_t *callbacks[],
> >> -		       const char *names[])
> >> +static int vm_try_to_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> >> +			      struct virtqueue *vqs[],
> >> +			      vq_callback_t *callbacks[],
> >> +			      const char *names[],
> >> +			      bool use_multiple_irq,
> >> +			      bool per_vq_irq)
> >>  {
> >>  	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
> >> -	unsigned int irq = platform_get_irq(vm_dev->pdev, 0);
> >> -	int i, err;
> >> +	int i, err, nirqs, irq;
> >> +
> >> +	if (!use_multiple_irq) {
> >> +		/* Old style: one normal interrupt for change and all vqs. */
> >> +		err = vm_request_single_irq(vdev);
> >> +		if (err)
> >> +			goto error_request;
> >> +	} else {
> >> +		if (per_vq_irq) {
> >> +			/* Best option: one for change interrupt, one per vq. */
> >> +			nirqs = 1;
> >> +			for (i = 0; i < nvqs; ++i)
> >> +				if (callbacks[i])
> >> +					++nirqs;
> >> +		} else {
> >> +			/* Second best: one for change, shared for all vqs. */
> >> +			nirqs = 2;
> >> +		}
> >>  
> >> -	err = request_irq(irq, vm_interrupt, IRQF_SHARED,
> >> -			dev_name(&vdev->dev), vm_dev);
> >> -	if (err)
> >> -		return err;
> >> +		err = vm_request_multiple_irqs(vdev, nirqs, per_vq_irq);
> >> +		if (err)
> >> +			goto error_request;
> >> +	}
> >>  
> >> -	for (i = 0; i < nvqs; ++i) {
> >> +	for (i = 0; i < nvqs; i++) {
> >> +		if (!names[i]) {
> >> +			vqs[i] = NULL;
> >> +			continue;
> >> +		}
> >>  		vqs[i] = vm_setup_vq(vdev, i, callbacks[i], names[i]);
> >>  		if (IS_ERR(vqs[i])) {
> >> -			vm_del_vqs(vdev);
> >> -			return PTR_ERR(vqs[i]);
> >> +			err = PTR_ERR(vqs[i]);
> >> +			goto error_find;
> >> +		}
> >> +		if (!per_vq_irq || !callbacks[i])
> >> +			continue;
> >> +		/* allocate per-vq irq if available and necessary */
> >> +		snprintf(vm_dev->vm_vq_names[vm_dev->used_irqs],
> >> +			sizeof(*vm_dev->vm_vq_names),
> >> +			"%s-%s",
> >> +			dev_name(&vm_dev->vdev.dev), names[i]);
> >> +		irq = platform_get_irq(vm_dev->pdev, vm_dev->used_irqs);
> >> +		err = request_irq(irq, vring_interrupt, 0,
> >> +			vm_dev->vm_vq_names[vm_dev->used_irqs], vqs[i]);
> >> +		if (err) {
> >> +			vm_del_vq(vqs[i]);
> >> +			goto error_find;
> >>  		}
> >> +		++vm_dev->used_irqs;
> >>  	}
> >> -
> >>  	return 0;
> >> +error_find:
> >> +	vm_del_vqs(vdev);
> >> +
> >> +error_request:
> >> +	return err;
> >> +}
> >> +
> >> +static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> >> +		       struct virtqueue *vqs[],
> >> +		       vq_callback_t *callbacks[],
> >> +		       const char *names[])
> >> +{
> >> +	int err;
> >> +
> >> +	/* Try multiple irqs with one irq per queue. */
> >> +	err = vm_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names, true, true);
> >> +	if (!err)
> >> +		return 0;
> >> +	/* Fallback: multiple irqs with one irq for config,
> >> +	 * one shared for queues. */
> >> +	err = vm_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names,
> >> +				 true, false);
> >> +	if (!err)
> >> +		return 0;
> >> +	/* Finally fall back to regular single interrupts. */
> >> +	return vm_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names,
> >> +				  false, false);
> >>  }
> >>  
> >>  static const char *vm_bus_name(struct virtio_device *vdev)
> >> -- 
> >> 1.7.1
> > 
> > .
> > 
> 
> 
> -- 
> Shannon
