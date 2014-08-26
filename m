Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaHZTDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:03:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbaHZTDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:03:01 -0400
Message-ID: <1409079734.2906.129.camel@ul30vt.home>
Subject: Re: [RFC 5/9] VFIO: Extend external user API
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, joel.schopp@amd.com, kim.phillips@freescale.com,
        linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Date: Tue, 26 Aug 2014 13:02:14 -0600
In-Reply-To: <1408973264-30384-6-git-send-email-eric.auger@linaro.org>
References: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>
	 <1408973264-30384-6-git-send-email-eric.auger@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-25 at 15:27 +0200, Eric Auger wrote:
> New functions are added to be called from ARM KVM-VFIO device.
> 
> - vfio_device_get_external_user enables to get a vfio device from
>   its fd
> - vfio_device_put_external_user puts the vfio device
> - vfio_external_get_type enables to retrieve the type of the device
>   (PCI or platform)
> - vfio_external_get_base_device enables to get the
>   struct device*, useful to access the platform_device
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> ---
>  drivers/vfio/vfio.c  | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h |  4 ++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 8e84471..c93b9e4 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1401,6 +1401,41 @@ void vfio_group_put_external_user(struct vfio_group *group)
>  }
>  EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
>  
> +struct vfio_device *vfio_device_get_external_user(struct file *filep)
> +{
> +	struct vfio_device *vdev = filep->private_data;
> +
> +	if (filep->f_op != &vfio_device_fops)
> +		return ERR_PTR(-EINVAL);
> +
> +	vfio_device_get(vdev);
> +	return vdev;
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_get_external_user);
> +
> +void vfio_device_put_external_user(struct vfio_device *vdev)
> +{
> +	vfio_device_put(vdev);
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_put_external_user);
> +
> +int vfio_external_get_type(struct vfio_device *vdev)
> +{
> +	if (!strcmp(vdev->ops->name,  "vfio-platform"))
> +		return VFIO_DEVICE_FLAGS_PLATFORM;
> +	else if (!strcmp(vdev->ops->name,  "vfio-pci"))
> +		return VFIO_DEVICE_FLAGS_PCI;
> +	else
> +		return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(vfio_external_get_type);

Returning the bit of the flag we use in get_device_info looks rather
sloppy here.  Should we define a new enum for use with this?  Actually,
is this interface even necessary?  If we can get the struct device then
we can get the bus_type and keep vfio out of this.

For both of these last two, I like to use the convention that where
there is a "get" there is a matching "put".  These aren't reference
counting anything, so let's not use get in the name.

> +
> +struct device *vfio_external_get_base_device(struct vfio_device *vdev)
> +{
> +	return vdev->dev;
> +}
> +EXPORT_SYMBOL_GPL(vfio_external_get_base_device);
> +

Looks almost too simple, but reviewing the object lifecycles, this all
looks safe.  Thanks,

Alex

>  int vfio_external_user_iommu_id(struct vfio_group *group)
>  {
>  	return iommu_group_id(group->iommu_group);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ffe04ed..19e98eb 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -99,6 +99,10 @@ extern void vfio_group_put_external_user(struct vfio_group *group);
>  extern int vfio_external_user_iommu_id(struct vfio_group *group);
>  extern long vfio_external_check_extension(struct vfio_group *group,
>  					  unsigned long arg);
> +extern struct vfio_device *vfio_device_get_external_user(struct file *filep);
> +extern void vfio_device_put_external_user(struct vfio_device *vdev);
> +extern int vfio_external_get_type(struct vfio_device *vdev);
> +extern struct device *vfio_external_get_base_device(struct vfio_device *vdev);
>  
>  struct pci_dev;
>  #ifdef CONFIG_EEH



