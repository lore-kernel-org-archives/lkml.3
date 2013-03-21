Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab3CUQfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab3CUQfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:35:31 -0400
Message-ID: <1363883719.2747.13.camel@ul30vt.home>
Subject: Re: [PATCH] iommu: add a function to find an iommu group by id
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Date: Thu, 21 Mar 2013 10:35:19 -0600
In-Reply-To: <1363852122-17974-1-git-send-email-aik@ozlabs.ru>
References: <1363852122-17974-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-21 at 18:48 +1100, Alexey Kardashevskiy wrote:
> As IOMMU groups are exposed to the user space by their numbers,
> the user space can use them in various kernel APIs so the kernel
> might need an API to find a group by its ID.
> 
> As an example, QEMU VFIO on PPC64 platform needs it to associate
> a logical bus number (LIOBN) with a specific IOMMU group in order
> to support in-kernel handling of DMA map/unmap requests.
> 
> The patch adds the iommu_group_find(id) function which performs
> such search.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  drivers/iommu/iommu.c |   26 ++++++++++++++++++++++++++
>  include/linux/iommu.h |    1 +
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index b0afd3d..6340cac 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -205,6 +205,32 @@ printk("%s %u grp %d\n", __func__, __LINE__, iommu_group_id(group));
>  }
>  EXPORT_SYMBOL_GPL(iommu_group_alloc);
>  
> +struct iommu_group *iommu_group_find(int id)
> +{
> +	struct kobject *group_kobj;
> +	struct iommu_group *grp;
> +	const char *name;
> +
> +	if (!iommu_group_kset)
> +		return NULL;
> +
> +	name = kasprintf(GFP_KERNEL, "%d", id);
> +	if (!name)
> +		return NULL;
> +
> +	group_kobj = kset_find_obj(iommu_group_kset, name);
> +	kfree(name);
> +
> +	if (!group_kobj)
> +		return NULL;
> +
> +	grp = container_of(group_kobj, struct iommu_group, kobj);
> +	BUG_ON(grp->id != id);
> +
> +	return grp;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_find);

Don't you need to do some reference counting here?  Otherwise there's no
guarantee the returned pointer is still valid by the time it's used.
The interface should probably be iommu_group_get_by_id().  Thanks,

Alex

> +
>  /**
>   * iommu_group_get_iommudata - retrieve iommu_data registered for a group
>   * @group: the group
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index f3b99e1..20281d5 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -113,6 +113,7 @@ struct iommu_ops {
>  extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
>  extern bool iommu_present(struct bus_type *bus);
>  extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
> +extern struct iommu_group *iommu_group_find(int id);
>  extern void iommu_domain_free(struct iommu_domain *domain);
>  extern int iommu_attach_device(struct iommu_domain *domain,
>  			       struct device *dev);



