Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab3AaJdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 04:33:38 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:49810 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab3AaJdc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 04:33:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>
Subject: RE: [PATCH 4/4] iommu: Add domain window handling functions
Thread-Topic: [PATCH 4/4] iommu: Add domain window handling functions
Thread-Index: AQHN/zLrYB1D+P6QpkSmyrL26r8TX5hi9HBA
Date: Thu, 31 Jan 2013 09:32:26 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D3670ED@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1359582228-21552-1-git-send-email-joro@8bytes.org>
 <1359582228-21552-5-git-send-email-joro@8bytes.org>
In-Reply-To: <1359582228-21552-5-git-send-email-joro@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.132.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Thursday, January 31, 2013 3:14 AM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Joerg
> Roedel
> Subject: [PATCH 4/4] iommu: Add domain window handling functions
> 
> Add the iommu_domain_wnd_enable() and iommu_domain_wnd_disable()
> functions to the IOMMU-API. These functions will be used to setup domains
> that are based on subwindows and not on paging.
> 
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> ---
>  drivers/iommu/iommu.c |   20 ++++++++++++++++++++
>  include/linux/iommu.h |   18 ++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c index
> ab9dafd..55ae3bf 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -852,6 +852,26 @@ size_t iommu_unmap(struct iommu_domain *domain,
> unsigned long iova, size_t size)  }  EXPORT_SYMBOL_GPL(iommu_unmap);
> 
> +
> +int iommu_domain_wnd_enable(struct iommu_domain *domain, u32 window,
> +			    unsigned long offset, size_t size) {
> +	if (unlikely(domain->ops->domain_wnd_enable == NULL))
> +		return -ENODEV;
> +
> +	return domain->ops->domain_wnd_enable(domain, window, offset,
> size); }
> +EXPORT_SYMBOL_GPL(iommu_domain_wnd_enable);
> +
> +void iommu_domain_wnd_disable(struct iommu_domain *domain, u32 window)
> +{
> +	if (unlikely(domain->ops->domain_wnd_disable == NULL))
> +		return;
> +
> +	return domain->ops->domain_wnd_disable(domain, window); }
> +EXPORT_SYMBOL_GPL(iommu_domain_wnd_disable);
> +
>  static int __init iommu_init(void)
>  {
>  	iommu_group_kset = kset_create_and_add("iommu_groups",
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> 26066f5..f01657e 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -90,6 +90,9 @@ struct iommu_ops {
>  		   phys_addr_t paddr, size_t size, int prot);
>  	size_t (*unmap)(struct iommu_domain *domain, unsigned long iova,
>  		     size_t size);
> +	int (*domain_wnd_enable)(struct iommu_domain *domain, u32 window,
> +				   unsigned long offset, size_t size);
> +	void (*domain_wnd_disable)(struct iommu_domain *domain, u32
> window);
>  	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
>  				    unsigned long iova);
>  	int (*domain_has_cap)(struct iommu_domain *domain, @@ -123,6 +126,9
> @@ extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
>  		     phys_addr_t paddr, size_t size, int prot);  extern
> size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>  		       size_t size);
> +extern int iommu_domain_wnd_enable(struct iommu_domain *domain, u32
> window,
> +				   unsigned long offset, size_t size); extern
> void
> +iommu_domain_wnd_disable(struct iommu_domain *domain, u32 window);
>  extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
>  				      unsigned long iova);
>  extern int iommu_domain_has_cap(struct iommu_domain *domain, @@ -240,6
> +246,18 @@ static inline int iommu_unmap(struct iommu_domain *domain,
> unsigned long iova,
>  	return -ENODEV;
>  }
> 
> +static inline int iommu_domain_wnd_enable(struct iommu_domain *domain,
> +					  u32 window, unsigned long offset,
> +					  size_t size)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline void iommu_domain_wnd_disable(struct iommu_domain *domain,
> +					    u32 window)
> +{
> +}
> +
>  static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain
> *domain,
>  					     unsigned long iova)
>  {
We would need a corresponding physical address in the iommu_domain_wnd_enable call. The sub windows can point to physically discontiguous locations. Also, although we support partial mappings where the sub window size < geometry_size/max_sub_windows, but the mapping would always start from the sub window base (sub window base address would be aligned to (geometry size)/max_sub_windows). The user of the API would have to ensure that the iova is aligned to the max sub window size. So, offset is not relevant in our case as it would always be zero. The size should be u64 in order to accommodate window sizes supported by PAMU.


int iommu_domain_wnd_enable(struct iommu_domain *domain, u32 window, phys_addr_t paddr, u64 size)

We need a mechanism to determine the maximum number of subwindows supported by PAMU. How about representing it in the iommu_domain structure:
struct  iommu_domain {
	struct iommu_ops *ops;
	void *priv;
	iommu_fault_handler_t handler;
	void *handler_token;
	struct iommu_domain_geometry geometry;
	u32 max_sub_windows; -----> maximum number of sub windows supported by the hardware.
}

Also, we would need to set the number of sub windows for a geometry, for that again we would need a new domain attribute (DOMAIN_ATTR_SUBWINDOWS).

-Varun


