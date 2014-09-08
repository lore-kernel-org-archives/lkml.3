Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaIHQvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:51:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57907 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092AbaIHQvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:51:17 -0400
Date: Mon, 8 Sep 2014 17:51:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>, devicetree@vger.kernel.org
Subject: Re: [PATCH 04/12] iommu/arm-smmu: Convert to iommu_capable() API
 function
Message-ID: <20140908165136.GW26030@arm.com>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
 <1409914384-21191-5-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409914384-21191-5-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

[adding devicetree for the last paragraph]

On Fri, Sep 05, 2014 at 11:52:56AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/arm-smmu.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index ca18d6d..47c2cb6 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1515,20 +1515,37 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
>  	return __pfn_to_phys(pte_pfn(pte)) | (iova & ~PAGE_MASK);
>  }
>  
> -static int arm_smmu_domain_has_cap(struct iommu_domain *domain,
> -				   unsigned long cap)
> +static bool arm_smmu_capable(enum iommu_cap cap)
>  {
> -	struct arm_smmu_domain *smmu_domain = domain->priv;
> -	struct arm_smmu_device *smmu = smmu_domain->smmu;
> -	u32 features = smmu ? smmu->features : 0;
> +	struct arm_smmu_device *smmu;
> +	bool ret = false;
>  
>  	switch (cap) {
>  	case IOMMU_CAP_CACHE_COHERENCY:
> -		return features & ARM_SMMU_FEAT_COHERENT_WALK;
> +		/*
> +		 * Use ARM_SMMU_FEAT_COHERENT_WALK as an indicator on whether
> +		 * the SMMU can force coherency on the DMA transaction. If it
> +		 * supports COHERENT_WALK it must be behind a coherent
> +		 * interconnect.
> +		 * A domain can be attached to any SMMU, so to reliably support
> +		 * IOMMU_CAP_CACHE_COHERENCY all SMMUs in the system need to be
> +		 * behind a coherent interconnect.
> +		 */

I don't think we should rely on the SMMU's advertisement of the coherent
table walk to mean anything other than `the SMMU can emit cacheable page
table walks'. The actual walker is a separate observer, and could have a
different route to memory than transactions flowing through the SMMU.

In reality, all we can report here is what the SMMU (as opposed to the rest
of the system) is capable of. The SMMU can always emit cacheable
transactions for a master if a stage-1 translation is in use so, without
extending the device-tree binding, we should report true here
unconditionally.

An alternative is to extend the device-tree bindings to have something like
"dma-coherent" for the SMMU node, which would imply that the interconnect is
configured to honour snoops from the SMMU into the CPU caches. We might want
an additional property on top of that to indicate that the table walker is
also coherent (and we could check this against our ARM_SMMU_FEAT_COHERENT_WALK
flag)

Will
