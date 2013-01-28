Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab3A1Ruv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:50:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab3A1Rus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:50:48 -0500
Message-ID: <1359395436.11144.240.camel@bling.home>
Subject: Re: [PATCH v2 1/3] VFIO: Wrappers for getting/putting reference to
 vfio_device
From: Alex Williamson <alex.williamson@redhat.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 28 Jan 2013 10:50:36 -0700
In-Reply-To: <F9E001219150CB45BEDC82A650F360C9014A7BD5@G9W0717.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C9014A7BD5@G9W0717.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 09:54 +0000, Pandarathil, Vijaymohan R wrote:
> 	- Added vfio_device_get_from_vdev(), vfio_device_put_vdev()
>           as wrappers to get/put reference to vfio_device from struct device.
> 
> 	- Added vfio_device_data() as a wrapper to get device_data from
>           vfio_device.
> 
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  drivers/vfio/vfio.c  | 47 +++++++++++++++++++++++++++++++++++++++++------
>  include/linux/vfio.h |  3 +++
>  2 files changed, 44 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 12c264d..c2ff1b2 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -642,8 +642,13 @@ int vfio_add_group_dev(struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(vfio_add_group_dev);
>  
> -/* Test whether a struct device is present in our tracking */
> -static bool vfio_dev_present(struct device *dev)
> +/**
> + * This does a get on the corresponding iommu_group,
> + * vfio_group and the vfio_device. Callers of this
> + * function will hae to call vfio_put_vdev() to

s/hae/have/

Note that your commit log and the patch don't agree on names.
vfio_device_get_from_dev vs vfio_device_get_from_vdev.  vfio_put_vdev vs
vfio_device_put_vdev.  Personally I think they should be:

vfio_device_get_from_dev
vfio_device_put

> + * remove the reference to all objects.

Why do we need to hold references to all the objects?  Holding a
reference to a vfio_device should implicitly hold the vfio_group, which
implicitly holds the iommu_group.  We have to get each to get to the
vfio_device, but once we hold of that reference I believe we can let the
others go.  Is this not the case?

> + */
> +void *vfio_device_get_from_dev(struct device *dev)

Return should be struct vfio_device*.  It doesn't have to be void to be
opaque.

>  {
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> @@ -651,25 +656,55 @@ static bool vfio_dev_present(struct device *dev)
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
>  	}
> +	return device;
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
> +
> +void *vfio_device_data(void *data)
> +{

Why wouldn't this take struct vfio_device*?  We're ignoring free type
checking errors even though the user should be treating the device as
opaque.

> +	struct vfio_device *device = data;
> +	return device->device_data;
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_data);
> +
> +void vfio_device_put_vdev(void *data)
> +{

This also should take a struct vfio_device* and be called
vfio_device_put().  If we fix the above extra reference holding then
it's just the existingvfio_device_put, which just needs to be exported.

> +	struct vfio_device *device = data;
> +	struct vfio_group *group = device->group;
> +	struct iommu_group *iommu_group = group->iommu_group;
>  
>  	vfio_device_put(device);
>  	vfio_group_put(group);
>  	iommu_group_put(iommu_group);
> -	return true;
> +	return;

Unnecessary explicit return.  Thanks,

Alex

> +}
> +EXPORT_SYMBOL_GPL(vfio_device_put_vdev);
> +
> +/* Test whether a struct device is present in our tracking */
> +static bool vfio_dev_present(struct device *dev)
> +{
> +	struct vfio_device *device;
> +
> +	device = vfio_device_get_from_dev(dev);
> +	if (device) {
> +		vfio_device_put_vdev(device);
> +		return true;
> +	} else
> +		return false;
>  }
>  
>  /*
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ab9e862..e550c09 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -45,6 +45,9 @@ extern int vfio_add_group_dev(struct device *dev,
>  			      void *device_data);
>  
>  extern void *vfio_del_group_dev(struct device *dev);
> +extern void *vfio_device_get_from_dev(struct device *dev);
> +extern void vfio_device_put_vdev(void *device);
> +extern void *vfio_device_data(void *device);
>  
>  /**
>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks



