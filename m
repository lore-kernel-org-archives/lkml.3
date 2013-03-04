Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab3CDUSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:18:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3CDUSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:18:20 -0500
Message-ID: <1362428295.2489.118.camel@bling.home>
Subject: Re: [PATCH v6 1/3] VFIO: Wrapper for getting reference to
 vfio_device from device
From: Alex Williamson <alex.williamson@redhat.com>
To: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Cc: gleb@redhat.com, bhelgaas@google.com, blauwirbel@gmail.com,
        lance.oritz@hp.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 04 Mar 2013 13:18:15 -0700
In-Reply-To: <1362208619-5028-2-git-send-email-vijaymohan.pandarathil@hp.com>
References: <1362208619-5028-1-git-send-email-vijaymohan.pandarathil@hp.com>
	 <1362208619-5028-2-git-send-email-vijaymohan.pandarathil@hp.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 01:16 -0600, Vijay Mohan Pandarathil wrote:
> 	- Added vfio_device_get_from_dev() as wrapper to get
>           reference to vfio_device from struct device.
> 
> 	- Added vfio_device_data() as a wrapper to get device_data from
>           vfio_device.
> 
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  drivers/vfio/vfio.c  | 27 ++++++++++++++++++++++++++-
>  include/linux/vfio.h |  3 +++
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 28e2d5b..eec6674 100644
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
> @@ -642,6 +643,30 @@ int vfio_add_group_dev(struct device *dev,
>  }
>  EXPORT_SYMBOL_GPL(vfio_add_group_dev);
>  
> +/**
> + * This does a get on the vfio_device from device.
> + * Callers of this function will have to call vfio_put_device() to
> + * remove the reference.
> + */

I think patch 2 is still racy, so let's try to improve this comment for
the next version as well.  The key is that the device is bound to a vfio
driver therefore the caller actually already has a reference to the
vfio_device.  Perhaps:

        Get a reference to the vfio_device for a device that is known to
        be bound to a vfio driver.  The driver implicitly holds a
        vfio_device reference between vfio_add_group_dev and
        vfio_del_group_dev.  We can therefore use drvdata to increment
        that reference from the struct device.  This additional
        reference must be released by calling vfio_device_put.

> +struct vfio_device *vfio_device_get_from_dev(struct device *dev)
> +{
> +	struct vfio_device *device = dev_get_drvdata(dev);
> +
> +	vfio_device_get(device);
> +
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
>  /* Given a referenced group, check if it contains the device */
>  static bool vfio_dev_present(struct vfio_group *group, struct device *dev)
>  {
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



