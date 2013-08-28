Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3H1Pok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:44:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab3H1Poj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:44:39 -0400
Message-ID: <1377704672.10408.81.camel@ul30vt.home>
Subject: Re: [PATCH] vfio, iommu: Fixed interaction of VFIO_IOMMU_MAP_DMA
 with IOMMU address limits
From: Alex Williamson <alex.williamson@redhat.com>
To: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>
Cc: David.Woodhouse@intel.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Date: Wed, 28 Aug 2013 09:44:32 -0600
In-Reply-To: <1377597428-21480-1-git-send-email-jsteckli@os.inf.tu-dresden.de>
References: <1377597428-21480-1-git-send-email-jsteckli@os.inf.tu-dresden.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 11:57 +0200, Julian Stecklina wrote:
> The BUG_ON in drivers/iommu/intel-iommu.c:785 can be triggered from userspace via
> VFIO by calling the VFIO_IOMMU_MAP_DMA ioctl on a vfio device with any address
> beyond the addressing capabilities of the IOMMU. The problem is that the ioctl code
> calls iommu_iova_to_phys before it calls iommu_map. iommu_map handles the case that
> it gets addresses beyond the addressing capabilities of its IOMMU.
> intel_iommu_iova_to_phys does not.
> 
> This patch fixes iommu_iova_to_phys to return NULL for addresses beyond what the
> IOMMU can handle. This in turn causes the ioctl call to fail in iommu_map and
> (correctly) return EFAULT to the user with a helpful warning message in the kernel
> log.
> 
> Signed-off-by: Julian Stecklina <jsteckli@os.inf.tu-dresden.de>

Acked-by: Alex Williamson <alex.williamson@redhat.com>

> ---
>  drivers/iommu/intel-iommu.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index eec0d3e..61303db 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -782,7 +782,11 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
>  	int offset;
>  
>  	BUG_ON(!domain->pgd);
> -	BUG_ON(addr_width < BITS_PER_LONG && pfn >> addr_width);
> +
> +	if (addr_width < BITS_PER_LONG && pfn >> addr_width)
> +		/* Address beyond IOMMU's addressing capabilities. */
> +		return NULL;
> +
>  	parent = domain->pgd;
>  
>  	while (level > 0) {



