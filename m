Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaFEUsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:48:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaFEUsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:48:50 -0400
Message-ID: <1402001319.9207.252.camel@ul30vt.home>
Subject: Re: [RFC PATCH v6 07/20] vfio/iommu_type1: implement the
 VFIO_DMA_MAP_FLAG_NOEXEC flag
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org, open list <linux-kernel@vger.kernel.org>
Date: Thu, 05 Jun 2014 14:48:39 -0600
In-Reply-To: <1401987808-23596-8-git-send-email-a.motakis@virtualopensystems.com>
References: <1401987808-23596-1-git-send-email-a.motakis@virtualopensystems.com>
	 <1401987808-23596-8-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 19:03 +0200, Antonios Motakis wrote:
> Some IOMMU drivers, such as the ARM SMMU driver, make available the
> IOMMU_NOEXEC flag, to set the page tables for a device as XN (execute never).
> This affects devices such as the ARM PL330 DMA Controller, which respects
> this flag and will refuse to fetch DMA instructions from memory where the
> XN flag has been set.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 6673e7b..e2566fd 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -80,6 +80,24 @@ struct vfio_group {
>  	struct list_head	next;
>  };
>  
> +static int vfio_domains_have_cap_noexec(struct vfio_iommu *iommu)
> +{
> +	struct vfio_domain *d;
> +	int ret = 1;
> +
> +	mutex_lock(&iommu->lock);
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		if (!iommu_domain_has_cap(d->domain, IOMMU_CAP_NOEXEC)) {
> +			ret = 0;
> +			break;
> +		}
> +	}
> +	mutex_unlock(&iommu->lock);
> +
> +	return ret;
> +}
> +
> +
>  /*
>   * This code handles mapping and unmapping of user data buffers
>   * into DMA'ble space using the IOMMU
> @@ -542,6 +560,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		prot |= IOMMU_WRITE;
>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>  		prot |= IOMMU_READ;
> +	if (map->flags & VFIO_DMA_MAP_FLAG_NOEXEC) {
> +		if (!vfio_domains_have_cap_noexec(iommu))
> +			return -EINVAL;
> +		prot |= IOMMU_NOEXEC;
> +	}
>  
>  	if (!prot)
>  		return -EINVAL; /* No READ/WRITE? */
> @@ -899,6 +922,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  			if (!iommu)
>  				return 0;
>  			return vfio_domains_have_iommu_cache(iommu);
> +		case VFIO_IOMMU_PROT_NOEXEC:
> +			if (!iommu)
> +				return 0;
> +			return vfio_domains_have_cap_noexec(iommu);
>  		default:
>  			return 0;
>  		}
> @@ -922,7 +949,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  	} else if (cmd == VFIO_IOMMU_MAP_DMA) {
>  		struct vfio_iommu_type1_dma_map map;
>  		uint32_t mask = VFIO_DMA_MAP_FLAG_READ |
> -				VFIO_DMA_MAP_FLAG_WRITE;
> +				VFIO_DMA_MAP_FLAG_WRITE |
> +				VFIO_DMA_MAP_FLAG_NOEXEC;
>  
>  		minsz = offsetofend(struct vfio_iommu_type1_dma_map, size);
>  

This doesn't look complete.  What happens if we support NOEXEC, then we
add a group behind an IOMMU that doesn't support NOEXEC?  In one case we
attempt to use the same domain, which might imply the same IOMMU page
tables, but is the hardware going to support that?  In the other case we
create a new domain, then try to replay the mappings, including the
NOEXEC bit... what's that going to do?  Can we add a non-NOEXEC domain
to a container that was previously NOEXEC?  The point of changing the
flag from EXEC to NOEXEC was to make it enforceable, but doesn't that
mean we need to prevent that happening if we have NOEXEC mappings?

Something needs to happen in vfio_iommu_type1_attach_group() to figure
out what's allowed.  Also, vfio_domains_have_cap_noexec() should be
named vfio_domains_have_iommu_nexec() to match _iommu_cache() and
possibly they should both be wrappers to a common function if they end
up sharing similar implementations.  Thanks,

Alex

