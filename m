Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161626Ab3FVBQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 21:16:44 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45192 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161523Ab3FVBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 21:16:42 -0400
Message-ID: <51C4FAF4.5090509@ozlabs.ru>
Date: Sat, 22 Jun 2013 11:16:36 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] vfio: Limit group opens
References: <20130621211144.8237.7370.stgit@bling.home>
In-Reply-To: <20130621211144.8237.7370.stgit@bling.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cool, thanks!

So we will need only this (to be called from KVM), and that will be it, right?

int vfio_group_iommu_id_from_file(struct file *filep)
...



On 06/22/2013 07:12 AM, Alex Williamson wrote:
> vfio_group_fops_open attempts to limit concurrent sessions by
> disallowing opens once group->container is set.  This really doesn't
> do what we want and allow for inconsistent behavior, for instance a
> group can be opened twice, then a container set giving the user two
> file descriptors to the group.  But then it won't allow more to be
> opened.  There's not much reason to have the group opened multiple
> times since most access is through devices or the container, so
> complete what the original code intended and only allow a single
> instance.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 6d78736..d30f44d 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -76,6 +76,7 @@ struct vfio_group {
>  	struct notifier_block		nb;
>  	struct list_head		vfio_next;
>  	struct list_head		container_next;
> +	atomic_t			opened;
>  };
>  
>  struct vfio_device {
> @@ -206,6 +207,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	atomic_set(&group->container_users, 0);
> +	atomic_set(&group->opened, 0);
>  	group->iommu_group = iommu_group;
>  
>  	group->nb.notifier_call = vfio_iommu_group_notifier;
> @@ -1236,12 +1238,22 @@ static long vfio_group_fops_compat_ioctl(struct file *filep,
>  static int vfio_group_fops_open(struct inode *inode, struct file *filep)
>  {
>  	struct vfio_group *group;
> +	int opened;
>  
>  	group = vfio_group_get_from_minor(iminor(inode));
>  	if (!group)
>  		return -ENODEV;
>  
> +	/* Do we need multiple instances of the group open?  Seems not. */
> +	opened = atomic_cmpxchg(&group->opened, 0, 1);
> +	if (opened) {
> +		vfio_group_put(group);
> +		return -EBUSY;
> +	}
> +
> +	/* Is something still in use from a previous open? */
>  	if (group->container) {
> +		atomic_dec(&group->opened);
>  		vfio_group_put(group);
>  		return -EBUSY;
>  	}
> @@ -1259,6 +1271,8 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
>  
>  	vfio_group_try_dissolve_container(group);
>  
> +	atomic_dec(&group->opened);
> +
>  	vfio_group_put(group);
>  
>  	return 0;
> 


-- 
Alexey
