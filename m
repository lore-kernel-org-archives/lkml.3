Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbbADL0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 06:26:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbbADL0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 06:26:50 -0500
Date: Sun, 4 Jan 2015 13:26:41 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "open list:VIRTIO CORE, NET..." 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/2] virtio: don't free memory until the underlying
 struct device has been released
Message-ID: <20150104112641.GB4336@redhat.com>
References: <1420228060-18721-1-git-send-email-sasha.levin@oracle.com>
 <1420228060-18721-2-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420228060-18721-2-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 02:47:40PM -0500, Sasha Levin wrote:
> When releasing a virtio device, We can't free a struct virtio_device until the
> underlying struct device has been released, which might not happen immediately
> on device_unregister() even if that was the device's last reference.
> 
> Instead, free the memory only once we know the device is gone in the release
> callback.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>


Isn't this an old bug: do we need to copy stable on a fix?

What is the behaviour without this patch?
Is there a way to make this cause a crash?

> ---
>  drivers/virtio/virtio_pci_common.c |    9 ++++-----
>  drivers/virtio/virtio_pci_legacy.c |    1 -
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 59d3685..caa483d 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -423,11 +423,10 @@ int vp_set_vq_affinity(struct virtqueue *vq, int cpu)
>  
>  void virtio_pci_release_dev(struct device *_d)
>  {
> -	/*
> -	 * No need for a release method as we allocate/free
> -	 * all devices together with the pci devices.
> -	 * Provide an empty one to avoid getting a warning from core.
> -	 */
> +	struct virtio_device *vdev = dev_to_virtio(_d);
> +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> +
> +	kfree(vp_dev);
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index 913ca23..15e6e6d 100644
> --- a/drivers/virtio/virtio_pci_legacy.c
> +++ b/drivers/virtio/virtio_pci_legacy.c
> @@ -301,5 +301,4 @@ void virtio_pci_legacy_remove(struct pci_dev *pci_dev)
>  	pci_iounmap(pci_dev, vp_dev->ioaddr);
>  	pci_release_regions(pci_dev);
>  	pci_disable_device(pci_dev);
> -	kfree(vp_dev);
>  }


It seems inelegant to free a structure allocated in another file:
I think we should move this function to virtio_pci_legacy.
Will send a patch in a minute.





> -- 
> 1.7.10.4
