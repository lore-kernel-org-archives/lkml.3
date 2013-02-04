Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3BDQ6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:58:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab3BDQ6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:58:15 -0500
Message-ID: <1359997090.11144.448.camel@bling.home>
Subject: Re: [PATCH v3 1/3] VFIO: Wrapper for getting reference to
 vfio_device from device
From: Alex Williamson <alex.williamson@redhat.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Feb 2013 09:58:10 -0700
In-Reply-To: <F9E001219150CB45BEDC82A650F360C9014AAEFD@G9W0717.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C9014AAEFD@G9W0717.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-03 at 14:10 +0000, Pandarathil, Vijaymohan R wrote:
> 	- Added vfio_device_get_from_dev() as wrapper to get
>           reference to vfio_device from struct device.
> 
> 	- Added vfio_device_data() as a wrapper to get device_data from
>           vfio_device.
> 
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  drivers/vfio/vfio.c  | 41 ++++++++++++++++++++++++++++++++---------
>  include/linux/vfio.h |  3 +++
>  2 files changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 12c264d..f0a78a2 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -407,12 +407,13 @@ static void vfio_device_release(struct kref *kref)
>  }
>  
>  /* Device reference always implies a group reference */
> -static void vfio_device_put(struct vfio_device *device)
> +void vfio_device_put(struct vfio_device *device)
>  {
>  	struct vfio_group *group = device->group;
>  	kref_put_mutex(&device->kref, vfio_device_release, &group->device_lock);
>  	vfio_group_put(group);
>  }
> +EXPORT_SYMBOL_GPL(vfio_device_put);
>  
>  static void vfio_device_get(struct vfio_device *device)
>  {
> @@ -642,8 +643,12 @@ int vfio_add_group_dev(struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(vfio_add_group_dev);
>  
> -/* Test whether a struct device is present in our tracking */
> -static bool vfio_dev_present(struct device *dev)
> +/**
> + * This does a get on the vfio_device from device.
> + * Callers of this function will have to call vfio_put_device() to
> + * remove the reference.
> + */
> +struct vfio_device *vfio_device_get_from_dev(struct device *dev)
>  {
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> @@ -651,25 +656,43 @@ static bool vfio_dev_present(struct device *dev)
>  
>  	iommu_group = iommu_group_get(dev);
>  	if (!iommu_group)
> -		return false;
> +		return NULL;
>  
>  	group = vfio_group_get_from_iommu(iommu_group);
>  	if (!group) {
>  		iommu_group_put(iommu_group);
> -		return false;
> +		return NULL;
>  	}
>  
>  	device = vfio_group_get_device(group, dev);
>  	if (!device) {
>  		vfio_group_put(group);
>  		iommu_group_put(iommu_group);
> -		return false;
> +		return NULL;

nit, this test isn't necesary, skipping the whole if block and falling
through to the return below is functionally the same.

>  	}
> -
> -	vfio_device_put(device);
>  	vfio_group_put(group);
>  	iommu_group_put(iommu_group);
> -	return true;
> +	return device;
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
> +

Let's add a comment here that the caller must hold a reference to the
vfio_device.  Thanks,

Alex

> +void *vfio_device_data(struct vfio_device *device)
> +{
> +	return device->device_data;
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_data);
> +
> +/* Test whether a struct device is present in our tracking */
> +static bool vfio_dev_present(struct device *dev)
> +{
> +	struct vfio_device *device;
> +
> +	device = vfio_device_get_from_dev(dev);
> +	if (device) {
> +		vfio_device_put(device);
> +		return true;
> +	} else
> +		return false;
>  }
>  
>  /*
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ab9e862..ac8d488 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -45,6 +45,9 @@ extern int vfio_add_group_dev(struct device *dev,
>  			      void *device_data);
>  
>  extern void *vfio_del_group_dev(struct device *dev);
> +extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
> +extern void vfio_device_put(struct vfio_device *device);
> +extern void *vfio_device_data(struct vfio_device *device);
>  
>  /**
>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks



