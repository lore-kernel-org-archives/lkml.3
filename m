Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbbA1U2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:28:10 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45504 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbbA1U2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:28:07 -0500
Date: Wed, 28 Jan 2015 14:30:06 +0000
From: Will Deacon <will.deacon@arm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robin Murphy <Robin.Murphy@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "jroedel@suse.de" <jroedel@suse.de>
Subject: Re: [PATCH 2/5] iommu: Allocate a default domain for iommu groups
Message-ID: <20150128143006.GQ1569@arm.com>
References: <1422317339-22620-1-git-send-email-joro@8bytes.org>
 <1422317339-22620-3-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422317339-22620-3-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:08:56AM +0000, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The default domain will be used (if supported by the iommu
> driver) when the devices in the iommu group are not attached
> to any other domain.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/iommu.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 34636eb..8f33ddd3 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -76,6 +76,9 @@ struct iommu_group_attribute iommu_group_attr_##_name =		\
>  #define to_iommu_group(_kobj)		\
>  	container_of(_kobj, struct iommu_group, kobj)
>  
> +static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
> +						 enum iommu_domain_type type);
> +
>  static ssize_t iommu_group_attr_show(struct kobject *kobj,
>  				     struct attribute *__attr, char *buf)
>  {
> @@ -362,6 +365,17 @@ rename:
>  
>  	kobject_get(group->devices_kobj);
>  
> +	/*
> +	 * Try to allocate a default domain for the group, if this
> +	 * hasn't happened yet. This is not the best place to do that,
> +	 * it should happen in iommu_group_alloc(). But we have no
> +	 * iommu_ops there yet, so the allocation has to happen here for
> +	 * now.
> +	 */
> +	if (group->default_domain == NULL)
> +		group->default_domain = __iommu_domain_alloc(dev->bus,
> +							     IOMMU_DOMAIN_DMA);

Having a per-group domain is wasteful for IOMMUs that only support a modest
number of concurrent domains, so in reality I think we need to have one
domain per IOMMU instance. Is that possible?

One problem with the current per-bus approach is that __iommu_domain_alloc
can't figure out which IOMMU instance corresponds to the group.

Will
