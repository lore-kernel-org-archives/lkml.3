Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab3BYPdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:33:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3BYPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:33:48 -0500
Message-ID: <1361806423.2532.26.camel@bling.home>
Subject: Re: [PATCH v5 1/3] VFIO: Wrapper for getting reference to
 vfio_device from device
From: Alex Williamson <alex.williamson@redhat.com>
To: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Cc: gleb@redhat.com, bhelgaas@google.com, blauwirbel@gmail.com,
        lance.oritz@hp.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 25 Feb 2013 08:33:43 -0700
In-Reply-To: <1361683516-31946-2-git-send-email-vijaymohan.pandarathil@hp.com>
References: <1361683516-31946-1-git-send-email-vijaymohan.pandarathil@hp.com>
	 <1361683516-31946-2-git-send-email-vijaymohan.pandarathil@hp.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-23 at 23:25 -0600, Vijay Mohan Pandarathil wrote:
> 	- Added vfio_device_get_from_dev() as wrapper to get
>           reference to vfio_device from struct device.
> 
> 	- Added vfio_device_data() as a wrapper to get device_data from
>           vfio_device.
> 
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  drivers/vfio/vfio.c  | 47 ++++++++++++++++++++++++++++++++++-------------
>  include/linux/vfio.h |  3 +++
>  2 files changed, 37 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 12c264d..863d1d3 100644
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

I cc'd you on a patch that changes vfio_dev_present to fix a bug where
the device to iommu group lookup has been shutdown.  Using it for this
purpose probably has the same bug.  That code is in my next branch and
in the most reset pull request to Linus.

I think instead the code becomes much more simple.  We're registering a
callback for a struct device for which vfio-pci is the driver.  During
driver release we disable that callback for the device.  Thus during the
callback, we know the device is owned by vfio-pci, which means that the
drvdata has what we need.  So I think vfio_device_get_from_dev() simply
becomes:

struct vfio_device *vfio_get_device_from_dev(struct device *dev)
{
       struct vfio_device *device = dev_get_drvdata(dev);

       vfio_device_get(device);

       return device;
}
EXPORT_SYMBOL_GPL(vfio_get_device_from_dev);

Thanks,
Alex

>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> @@ -651,25 +656,41 @@ static bool vfio_dev_present(struct device *dev)
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
> -	if (!device) {
> -		vfio_group_put(group);
> -		iommu_group_put(iommu_group);
> -		return false;
> -	}
> -
> -	vfio_device_put(device);
>  	vfio_group_put(group);
>  	iommu_group_put(iommu_group);
> -	return true;
> +	return device;
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
> +
> +/*
> + * Caller must hold a reference to the vfio_device
> + */
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



