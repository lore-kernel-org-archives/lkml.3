Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaDDPCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:02:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:52222 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaDDPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:02:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,795,1389744000"; 
   d="scan'208";a="116829393"
Message-ID: <533EC966.7030101@citrix.com>
Date: Fri, 4 Apr 2014 16:01:58 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] xen-blkback: only attach blkback if the required features
 are met
References: <1396622471-13114-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1396622471-13114-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 15:41, Roger Pau Monne wrote:
> Blkback cannot work properly on auto-translated guests if Xen doesn't
> update the IOMMU when performing grant maps/unmaps, so only attach if
> the newly introduced XENFEAT_hvm_gntmap_supports_iommu is found.

Can you explain the problem in more detail and which guest
configurations are affected?

This isn't a problem that is specific to blkback, but any backend that
grant maps and passes the foreign pages to a device so there needs to be
a generic solution.

Why can't this be fixed by having the swiotlb bounce foreign pages?

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

Why CONFIG_X86?

David
