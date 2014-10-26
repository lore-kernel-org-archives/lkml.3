Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaJZMB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 08:01:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaJZMB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 08:01:26 -0400
Date: Sun, 26 Oct 2014 14:01:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "john.liuli" <john.liuli@huawei.com>
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        peter.huangpeng@huawei.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        n.nikolaev@virtualopensystems.com, yingshiuan.pan@gmail.com,
        remy.gauguey@cea.fr, joel.schopp@amd.com
Subject: Re: [RFC PATCH 1/2] Add a new register offset let interrupt reason
 available
Message-ID: <20141026120103.GC5497@redhat.com>
References: <1414225494-2208-1-git-send-email-john.liuli@huawei.com>
 <1414225494-2208-2-git-send-email-john.liuli@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414225494-2208-2-git-send-email-john.liuli@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 04:24:53PM +0800, john.liuli wrote:
> From: Li Liu <john.liuli@huawei.com>
> 
> Add a new register offset VIRTIO_MMIO_ISRMEM which help to
> estblish a shared memory region between virtio-mmio driver
> and qemu with two purposes:
> 
> 1.Guest virtio-mmio driver can get the interrupt reason.
> 2.Check irqfd enabled or not to register different irq handler.
> 
> Signed-off-by: Li Liu <john.liuli@huawei.com>
> ---
>  drivers/virtio/virtio_mmio.c |   21 ++++++++++++++++++++-
>  include/linux/virtio_mmio.h  |    3 +++
>  2 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index ef9a165..28ddb55 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -122,6 +122,8 @@ struct virtio_mmio_device {
>  	/* a list of queues so we can dispatch IRQs */
>  	spinlock_t lock;
>  	struct list_head virtqueues;
> +
> +	uint8_t *isr_mem;
>  };
>  
>  struct virtio_mmio_vq_info {
> @@ -443,6 +445,7 @@ static int virtio_mmio_probe(struct platform_device *pdev)
>  	struct virtio_mmio_device *vm_dev;
>  	struct resource *mem;
>  	unsigned long magic;
> +	int err;
>  
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!mem)
> @@ -481,6 +484,15 @@ static int virtio_mmio_probe(struct platform_device *pdev)
>  		return -ENXIO;
>  	}
>  
> +	vm_dev->isr_mem = alloc_pages_exact(PAGE_SIZE, GFP_KERNEL|__GFP_ZERO);
> +	if (vm_dev->isr_mem == NULL) {
> +		dev_err(&pdev->dev, "Allocate isr memory failed!\n");
> +		return -ENOMEM;
> +	}
> +
> +	writel(virt_to_phys(vm_dev->isr_mem),
> +	       vm_dev->base + VIRTIO_MMIO_ISRMEM);
> +

What happens to existing devices?
then might not expect writes at this address.

>  	vm_dev->vdev.id.device = readl(vm_dev->base + VIRTIO_MMIO_DEVICE_ID);
>  	vm_dev->vdev.id.vendor = readl(vm_dev->base + VIRTIO_MMIO_VENDOR_ID);
>  
> @@ -488,13 +500,20 @@ static int virtio_mmio_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, vm_dev);
>  
> -	return register_virtio_device(&vm_dev->vdev);
> +	err = register_virtio_device(&vm_dev->vdev);
> +	if (err) {
> +		free_pages_exact(vm_dev->isr_mem, PAGE_SIZE);
> +		vm_dev->isr_mem = NULL;
> +	}
> +
> +	return err;
>  }
>  
>  static int virtio_mmio_remove(struct platform_device *pdev)
>  {
>  	struct virtio_mmio_device *vm_dev = platform_get_drvdata(pdev);
>  
> +	free_pages_exact(vm_dev->isr_mem, PAGE_SIZE);
>  	unregister_virtio_device(&vm_dev->vdev);
>  
>  	return 0;
> diff --git a/include/linux/virtio_mmio.h b/include/linux/virtio_mmio.h
> index 5c7b6f0..b1e3ec7 100644
> --- a/include/linux/virtio_mmio.h
> +++ b/include/linux/virtio_mmio.h
> @@ -95,6 +95,9 @@
>  /* Device status register - Read Write */
>  #define VIRTIO_MMIO_STATUS		0x070
>  
> +/* Allocate ISRMEM for interrupt reason - Write Only */
> +#define VIRTIO_MMIO_ISRMEM		0x080
> +
>  /* The config space is defined by each driver as
>   * the per-driver configuration space - Read Write */
>  #define VIRTIO_MMIO_CONFIG		0x100
> -- 
> 1.7.9.5
> 
