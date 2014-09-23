Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbaIWWlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbaIWWlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:41:21 -0400
Message-ID: <1411512059.24563.57.camel@ul30vt.home>
Subject: Re: [PATCHv7 06/26] vfio/iommu_type1: implement the
 VFIO_DMA_MAP_FLAG_NOEXEC flag
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com, open list <linux-kernel@vger.kernel.org>
Date: Tue, 23 Sep 2014 16:40:59 -0600
In-Reply-To: <1411483586-29304-7-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1411483586-29304-7-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 16:46 +0200, Antonios Motakis wrote:
> Some IOMMU drivers, such as the ARM SMMU driver, make available the
> IOMMU_NOEXEC flag, to set the page tables for a device as XN (execute never).
> This affects devices such as the ARM PL330 DMA Controller, which respects
> this flag and will refuse to fetch DMA instructions from memory where the
> XN flag has been set.
> 
> The flag can be used only if all IOMMU domains behind the container support
> the IOMMU_NOEXEC flag. Also, if any mappings are created with the flag, any
> new domains with devices will have to support it as well.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0734fbe..09e5064 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -81,6 +81,26 @@ struct vfio_group {
>  };
>  
>  /*
> + * This function returns true only if _all_ domains support the capability.
> + */
> +static int vfio_all_domains_have_iommu_noexec(struct vfio_iommu *iommu)

Rename to vfio_domains_have_iommu_noexec() for consistency with the
cache version.

> +{
> +	struct vfio_domain *d;
> +	int ret = 1;
> +
> +	mutex_lock(&iommu->lock);
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		if (!iommu_domain_has_cap(d->domain, IOMMU_CAP_NOEXEC)) {

Should we cache this in domain->prot like we do for IOMMU_CACHE?

> +			ret = 0;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&iommu->lock);
> +
> +	return ret;
> +}
> +
> +/*
>   * This code handles mapping and unmapping of user data buffers
>   * into DMA'ble space using the IOMMU
>   */
> @@ -546,6 +566,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		prot |= IOMMU_WRITE;
>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>  		prot |= IOMMU_READ;
> +	if (map->flags & VFIO_DMA_MAP_FLAG_NOEXEC) {
> +		if (!vfio_all_domains_have_iommu_noexec(iommu))
> +			return -EINVAL;
> +		prot |= IOMMU_NOEXEC;
> +	}
>  
>  	if (!prot || !size || (size | iova | vaddr) & mask)
>  		return -EINVAL;
> @@ -636,6 +661,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>  		dma = rb_entry(n, struct vfio_dma, node);
>  		iova = dma->iova;
>  
> +		/* if any of the mappings to be replayed has the NOEXEC flag
> +		 * set, then the new iommu domain must support it */

nit, please fix the comment style to match the rest of the file.

> +		if ((dma->prot | IOMMU_NOEXEC) &&
> +		    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_NOEXEC))
> +			return -EINVAL;
> +
>  		while (iova < dma->iova + dma->size) {
>  			phys_addr_t phys = iommu_iova_to_phys(d->domain, iova);
>  			size_t size;
> @@ -890,6 +921,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  			if (!iommu)
>  				return 0;
>  			return vfio_domains_have_iommu_cache(iommu);
> +		case VFIO_IOMMU_PROT_NOEXEC:
> +			if (!iommu)
> +				return 0;
> +			return vfio_all_domains_have_iommu_noexec(iommu);
>  		default:
>  			return 0;
>  		}
> @@ -913,7 +948,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
>  		struct vfio_iommu_type1_dma_map map;
>  		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
> -				VFIO_DMA_MAP_FLAG_WRITE;
> +				VFIO_DMA_MAP_FLAG_WRITE |
> +				VFIO_DMA_MAP_FLAG_NOEXEC;
>  
>  		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
>  



