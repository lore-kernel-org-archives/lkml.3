Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaDDQ7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:59:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42047 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaDDQ67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:58:59 -0400
Date: Fri, 4 Apr 2014 12:58:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] xen-blkback: only attach blkback if the required
 features are met
Message-ID: <20140404165851.GS19478@phenom.dumpdata.com>
References: <1396622471-13114-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1396622471-13114-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 04:41:11PM +0200, Roger Pau Monne wrote:
> Blkback cannot work properly on auto-translated guests if Xen doesn't
> update the IOMMU when performing grant maps/unmaps, so only attach if
> the newly introduced XENFEAT_hvm_gntmap_supports_iommu is found.

Could you point to the git commit that introduces it in the patch please?
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  drivers/block/xen-blkback/blkback.c |   12 ++++++++++++
>  include/xen/interface/features.h    |    6 ++++++
>  2 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 64c60ed..4c23ddd 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -1381,6 +1381,18 @@ static int __init xen_blkif_init(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> +#ifdef CONFIG_X86
> +	if (xen_feature(XENFEAT_auto_translated_physmap) &&
> +	    !xen_feature(XENFEAT_hvm_gntmap_supports_iommu)) {
> +		/*
> +		 * blkback cannot work properly on auto-translated guests
> +		 * if grant table mappings don't update the IOMMU entries.
> +		 */
> +		pr_debug(DRV_PFX "Disabling blkback because Xen is missing feature XENFEAT_hvm_gntmap_supports_iommu\n");
> +		return -ENODEV;
> +	}
> +#endif /* CONFIG_X86 */
> +
>  	rc = xen_blkif_interface_init();
>  	if (rc)
>  		goto failed_init;
> diff --git a/include/xen/interface/features.h b/include/xen/interface/features.h
> index 131a6cc..d1e0f23 100644
> --- a/include/xen/interface/features.h
> +++ b/include/xen/interface/features.h
> @@ -53,6 +53,12 @@
>  /* operation as Dom0 is supported */
>  #define XENFEAT_dom0                      11
>  
> +/*
> + * If set, GNTTABOP_map_grant_ref sets the proper IOMMU mappings so the
> + * resulting mapped page can be used for IO with hardware devices.
> + */
> +#define XENFEAT_hvm_gntmap_supports_iommu 12
> +
>  #define XENFEAT_NR_SUBMAPS 1
>  
>  #endif /* __XEN_PUBLIC_FEATURES_H__ */
> -- 
> 1.7.7.5 (Apple Git-26)
> 
