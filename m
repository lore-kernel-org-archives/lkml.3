Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab3BEJOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:14:53 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:10845
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929Ab3BEJOr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:14:47 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>, Stuart Yoder <b08248@gmail.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: RE: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
Thread-Topic: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
Thread-Index: AQHOAto2wzGTacmHgEKF4kls7teXNphq9JTw
Date: Tue, 5 Feb 2013 09:14:40 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D373D2B@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
 <1359983924-28952-6-git-send-email-joro@8bytes.org>
In-Reply-To: <1359983924-28952-6-git-send-email-joro@8bytes.org>
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

Hi Joerg,
In case of PAMU, geometry would be meaningless without specifying the number of subwindows. If the API user specifies a geometry but fails to specify the number of required subwindows, we would assume a default (max supported) value, which may be incorrect. It's going to be really ugly. I think we should add the number of sub windows to the domain geometry. This parameter would be used in case of a window based iommu. So, a separate set_window API wouldn't be required.

We can still implement the get_windows API for getting the maximum number of subwindows supported by the window based IOMMU.

Regards
Varun

> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Monday, February 04, 2013 6:49 PM
> To: Sethi Varun-B16395; Stuart Yoder
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; Joerg
> Roedel
> Subject: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
> 
> This attribute can be used to set and get the number of subwindows on
> IOMMUs that are window-based.
> 
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> ---
>  drivers/iommu/iommu.c |   33 ++++++++++++++++++++++++++++++---
>  include/linux/iommu.h |    5 +++++
>  2 files changed, 35 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c index
> 0fdb7db..66402f7 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -891,6 +891,7 @@ int iommu_domain_get_attr(struct iommu_domain
> *domain,
>  	struct iommu_domain_geometry *geometry;
>  	bool *paging;
>  	int ret = 0;
> +	u32 *count;
> 
>  	switch (attr) {
>  	case DOMAIN_ATTR_GEOMETRY:
> @@ -902,6 +903,15 @@ int iommu_domain_get_attr(struct iommu_domain
> *domain,
>  		paging  = data;
>  		*paging = (domain->ops->pgsize_bitmap != 0UL);
>  		break;
> +	case DOMAIN_ATTR_WINDOWS:
> +		count = data;
> +
> +		if (domain->ops->domain_get_windows != NULL)
> +			*count = domain->ops->domain_get_windows(domain);
> +		else
> +			ret = -ENODEV;
> +
> +		break;
>  	default:
>  		if (!domain->ops->domain_get_attr)
>  			return -EINVAL;
> @@ -916,9 +926,26 @@ EXPORT_SYMBOL_GPL(iommu_domain_get_attr);
>  int iommu_domain_set_attr(struct iommu_domain *domain,
>  			  enum iommu_attr attr, void *data)
>  {
> -	if (!domain->ops->domain_set_attr)
> -		return -EINVAL;
> +	int ret = 0;
> +	u32 *count;
> +
> +	switch (attr) {
> +	case DOMAIN_ATTR_WINDOWS:
> +		count = data;
> +
> +		if (domain->ops->domain_set_windows != NULL)
> +			ret = domain->ops->domain_set_windows(domain, *count);
> +		else
> +			ret = -ENODEV;
> 
> -	return domain->ops->domain_set_attr(domain, attr, data);
> +		break;
> +	default:
> +		if (domain->ops->domain_set_attr == NULL)
> +			return -EINVAL;
> +
> +		ret = domain->ops->domain_set_attr(domain, attr, data);
> +	}
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_domain_set_attr);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h index
> 0cba2d8..8330df1 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -60,6 +60,7 @@ struct iommu_domain {
>  enum iommu_attr {
>  	DOMAIN_ATTR_GEOMETRY,
>  	DOMAIN_ATTR_PAGING,
> +	DOMAIN_ATTR_WINDOWS,
>  	DOMAIN_ATTR_MAX,
>  };
> 
> @@ -106,6 +107,10 @@ struct iommu_ops {
>  	int (*domain_window_enable)(struct iommu_domain *domain, u32
> wnd_nr,
>  				    phys_addr_t paddr, size_t size);
>  	void (*domain_window_disable)(struct iommu_domain *domain, u32
> wnd_nr);
> +	/* Set the numer of window per domain */
> +	int (*domain_set_windows)(struct iommu_domain *domain, u32
> w_count);
> +	/* Get the numer of window per domain */
> +	u32 (*domain_get_windows)(struct iommu_domain *domain);
> 
>  	unsigned long pgsize_bitmap;
>  };
> --
> 1.7.9.5
> 
> 


