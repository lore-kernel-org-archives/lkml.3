Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3JMOpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 10:45:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab3JMOpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 10:45:49 -0400
Message-ID: <1381675529.2796.86.camel@ul30vt.home>
Subject: Re: [PATCH] VFIO: vfio_iommu_type1: fix bug caused by break in
 nested loop
From: Alex Williamson <alex.williamson@redhat.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, tech@virtualopensystems.com,
        agraf@suse.de, B08248@freescale.com
Date: Sun, 13 Oct 2013 08:45:29 -0600
In-Reply-To: <1381506452-2069-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1381506452-2069-1-git-send-email-a.motakis@virtualopensystems.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 17:47 +0200, Antonios Motakis wrote:
> In vfio_iommu_type1.c there is a bug in vfio_dma_do_map, when checking
> that pages are not already mapped. Since the check is being done in a
> for loop nested within the main loop, breaking out of it does not create
> the intended behavior. If the underlying IOMMU driver returns a non-NULL
> value, this will be ignored and mapping the DMA range will be attempted
> anyway, leading to unpredictable behavior.
> 
> This interracts badly with the ARM SMMU driver issue fixed in the patch
> that was submitted with the title:
> "[PATCH 2/2] ARM: SMMU: return NULL on error in arm_smmu_iova_to_phys"
> Both fixes are required in order to use the vfio_iommu_type1 driver
> with an ARM SMMU.
> 
> This patch refactors the function slightly, in order to also make this
> kind of bug less likely.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---

Thanks for fixing this.  Applied to my for-linus branch.  I'll try to
get this in for 3.12.  Thanks,

Alex

>  drivers/vfio/vfio_iommu_type1.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index fa72a71..023ba12 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -548,6 +548,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	long npage;
>  	int ret = 0, prot = 0;
>  	uint64_t mask;
> +	struct vfio_dma *dma = NULL;
> +	unsigned long pfn;
>  
>  	end = map->iova + map->size;
>  
> @@ -590,8 +592,6 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	}
>  
>  	for (iova = map->iova; iova < end; iova += size, vaddr += size) {
> -		struct vfio_dma *dma = NULL;
> -		unsigned long pfn;
>  		long i;
>  
>  		/* Pin a contiguous chunk of memory */
> @@ -600,16 +600,15 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		if (npage <= 0) {
>  			WARN_ON(!npage);
>  			ret = (int)npage;
> -			break;
> +			goto out;
>  		}
>  
>  		/* Verify pages are not already mapped */
>  		for (i = 0; i < npage; i++) {
>  			if (iommu_iova_to_phys(iommu->domain,
>  					       iova + (i << PAGE_SHIFT))) {
> -				vfio_unpin_pages(pfn, npage, prot, true);
>  				ret = -EBUSY;
> -				break;
> +				goto out_unpin;
>  			}
>  		}
>  
> @@ -619,8 +618,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		if (ret) {
>  			if (ret != -EBUSY ||
>  			    map_try_harder(iommu, iova, pfn, npage, prot)) {
> -				vfio_unpin_pages(pfn, npage, prot, true);
> -				break;
> +				goto out_unpin;
>  			}
>  		}
>  
> @@ -675,9 +673,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  			dma = kzalloc(sizeof(*dma), GFP_KERNEL);
>  			if (!dma) {
>  				iommu_unmap(iommu->domain, iova, size);
> -				vfio_unpin_pages(pfn, npage, prot, true);
>  				ret = -ENOMEM;
> -				break;
> +				goto out_unpin;
>  			}
>  
>  			dma->size = size;
> @@ -688,16 +685,21 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  		}
>  	}
>  
> -	if (ret) {
> -		struct vfio_dma *tmp;
> -		iova = map->iova;
> -		size = map->size;
> -		while ((tmp = vfio_find_dma(iommu, iova, size))) {
> -			int r = vfio_remove_dma_overlap(iommu, iova,
> -							&size, tmp);
> -			if (WARN_ON(r || !size))
> -				break;
> -		}
> +	WARN_ON(ret);
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +
> +out_unpin:
> +	vfio_unpin_pages(pfn, npage, prot, true);
> +
> +out:
> +	iova = map->iova;
> +	size = map->size;
> +	while ((dma = vfio_find_dma(iommu, iova, size))) {
> +		int r = vfio_remove_dma_overlap(iommu, iova,
> +						&size, dma);
> +		if (WARN_ON(r || !size))
> +			break;
>  	}
>  
>  	mutex_unlock(&iommu->lock);



