Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaLEJyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 04:54:06 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:60490 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaLEJyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 04:54:02 -0500
Date: Fri, 5 Dec 2014 10:53:54 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Nikhil Rao <nikhil.rao@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH RFC v2 3/4] virtio: allow finalize_features to fail
Message-ID: <20141205105354.2cf1bfc9@thinkpad-w530>
In-Reply-To: <1417718645-25678-3-git-send-email-mst@redhat.com>
References: <1417718645-25678-1-git-send-email-mst@redhat.com>
	<1417718645-25678-3-git-send-email-mst@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120509-0005-0000-0000-000002598F94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This will make it easy for transports to validate features and return
> failure.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_config.h          | 3 ++-
>  drivers/lguest/lguest_device.c         | 4 +++-
>  drivers/misc/mic/card/mic_virtio.c     | 4 +++-
>  drivers/remoteproc/remoteproc_virtio.c | 4 +++-
>  drivers/s390/kvm/kvm_virtio.c          | 4 +++-
>  drivers/s390/kvm/virtio_ccw.c          | 6 ++++--
>  drivers/virtio/virtio.c                | 4 +++-
>  drivers/virtio/virtio_mmio.c           | 4 +++-
>  drivers/virtio/virtio_pci.c            | 4 +++-
>  9 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 1fa5faa..7979f85 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -47,6 +47,7 @@
>   *	vdev: the virtio_device
>   *	This gives the final feature bits for the device: it can change
>   *	the dev->feature bits if it wants.
> + *	Returns 0 on success or error status

"Returns 0 on success, otherwise the error status."

>   * @bus_name: return the bus name associated with the device
>   *	vdev: the virtio_device
>   *      This returns a pointer to the bus name a la pci_name from which
> @@ -68,7 +69,7 @@ struct virtio_config_ops {
>  			const char *names[]);
>  	void (*del_vqs)(struct virtio_device *);
>  	u64 (*get_features)(struct virtio_device *vdev);
> -	void (*finalize_features)(struct virtio_device *vdev);
> +	int (*finalize_features)(struct virtio_device *vdev);
>  	const char *(*bus_name)(struct virtio_device *vdev);
>  	int (*set_vq_affinity)(struct virtqueue *vq, int cpu);
>  };

...

> 
>  static void virtio_ccw_get_config(struct virtio_device *vdev,
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 6b4c1113..7ddebbc 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -211,7 +211,9 @@ static int virtio_dev_probe(struct device *_d)
>  		if (device_features & (1ULL << i))
>  			__virtio_set_bit(dev, i);
> 
> -	dev->config->finalize_features(dev);
> +	err = dev->config->finalize_features(dev);
> +	if (err)
> +		goto err;
> 
>  	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>  		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> index aec1dae..5219210 100644
> --- a/drivers/virtio/virtio_mmio.c
> +++ b/drivers/virtio/virtio_mmio.c
> @@ -152,7 +152,7 @@ static u64 vm_get_features(struct virtio_device *vdev)
>  	return readl(vm_dev->base + VIRTIO_MMIO_HOST_FEATURES);
>  }
> 

Do we have to take care of fails in virtio_device_restore()?

Otherwise looks good to me.

David

