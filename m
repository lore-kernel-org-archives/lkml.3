Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaKTPh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:37:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbaKTPhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:37:25 -0500
Message-ID: <1416497837.27937.362.camel@ul30vt.home>
Subject: Re: [PATCH 1/1] vfio: put off the allocation of "minor" in
 vfio_create_group
From: Alex Williamson <alex.williamson@redhat.com>
To: Zhen Lei <thunder.leizhen@huawei.com>
Cc: KVM <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        Tianhong Ding <dingtianhong@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Date: Thu, 20 Nov 2014 08:37:17 -0700
In-Reply-To: <1416482702-10820-1-git-send-email-thunder.leizhen@huawei.com>
References: <1416482702-10820-1-git-send-email-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 19:25 +0800, Zhen Lei wrote:
> The next code fragment "list_for_each_entry" is not depend on "minor". With this
> patch, the free of "minor" in "list_for_each_entry" can be reduced, and there is
> no functional change.

A reasonable micro-optimization, but I'm curious if you're actually
seeing some measurable overhead from this.  It seems like we'd need to
have multiple devices, all within the same IOMMU group, all probed by
vfio-pci at the same time to exercise the race condition.  Thanks,

Alex

> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/vfio/vfio.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index f018d8d..737eb468 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -225,22 +225,21 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)
> 
>  	mutex_lock(&vfio.group_lock);
> 
> -	minor = vfio_alloc_group_minor(group);
> -	if (minor < 0) {
> -		vfio_group_unlock_and_free(group);
> -		return ERR_PTR(minor);
> -	}
> -
>  	/* Did we race creating this group? */
>  	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
>  		if (tmp->iommu_group == iommu_group) {
>  			vfio_group_get(tmp);
> -			vfio_free_group_minor(minor);
>  			vfio_group_unlock_and_free(group);
>  			return tmp;
>  		}
>  	}
> 
> +	minor = vfio_alloc_group_minor(group);
> +	if (minor < 0) {
> +		vfio_group_unlock_and_free(group);
> +		return ERR_PTR(minor);
> +	}
> +
>  	dev = device_create(vfio.class, NULL,
>  			    MKDEV(MAJOR(vfio.group_devt), minor),
>  			    group, "%d", iommu_group_id(iommu_group));
> --
> 1.8.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



