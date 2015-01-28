Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbbA1USM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:18:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45498 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbbA1USH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:18:07 -0500
Date: Wed, 28 Jan 2015 14:19:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "jroedel@suse.de" <jroedel@suse.de>
Subject: Re: [PATCH 02/15] iommu: Introduce iommu domain types
Message-ID: <20150128141934.GP1569@arm.com>
References: <1422316305-19216-1-git-send-email-joro@8bytes.org>
 <1422316305-19216-3-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422316305-19216-3-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

Thanks for posting this!

On Mon, Jan 26, 2015 at 11:51:32PM +0000, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> This allows to handle domains differently based on their
> type in the future. An IOMMU driver can implement certain
> optimizations for DMA-API domains for example.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/iommu.c |  5 +++--
>  include/linux/iommu.h | 11 ++++++++++-
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 684efc0..ab24d77 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -909,14 +909,15 @@ struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
>  	ops = bus->iommu_ops;
>  
>  	if (ops->domain_alloc)
> -		domain = ops->domain_alloc();
> +		domain = ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
>  	else
>  		domain = kzalloc(sizeof(*domain), GFP_KERNEL);
>  
>  	if (!domain)
>  		return NULL;
>  
> -	domain->ops = bus->iommu_ops;
> +	domain->ops  = bus->iommu_ops;
> +	domain->type = IOMMU_DOMAIN_UNMANAGED;
>  
>  	if (ops->domain_init && domain->ops->domain_init(domain))
>  		goto out_free;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 69d1d12..0b67f65 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -51,7 +51,16 @@ struct iommu_domain_geometry {
>  	bool force_aperture;       /* DMA only allowed in mappable range? */
>  };
>  
> +/* This are the possible domain-types */
> +enum iommu_domain_type {
> +	IOMMU_DOMAIN_DMA,	/* Domain used for DMA-API */
> +	IOMMU_DOMAIN_IDENTITY,	/* Identity mapped domain  */

What happens if somebody calls map or unmap on an identity-mapping domain?
Can we catch that in the IOMMU core before calling the IOMMU driver? That
also implies we need something extra to parameterise the attributes for
the mapping (e.g. cacheable, read-only) and also potentially the address
range.

> +	IOMMU_DOMAIN_UNMANAGED, /* Domain mappings are managed by a third party
> +				   user (like KVM or VFIO) */

We already have the domain attributes (iommu_attr) to describe features
of a domain. Is there really a need for this extra type, or can we extend
the attribute set and allow for domain allocation with attributes?

Will
