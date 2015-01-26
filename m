Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbbAZKxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:53:37 -0500
Received: from smtp.citrix.com ([66.165.176.89]:7888 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbbAZKxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:53:34 -0500
X-IronPort-AV: E=Sophos;i="5.09,468,1418083200"; 
   d="scan'208";a="220551388"
Message-ID: <1422269607.27469.5.camel@citrix.com>
Subject: Re: [Xen-devel] [PATCH 2/2] swiotlb-xen: pass dev_addr to
 swiotlb_tbl_unmap_single
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <david.vrabel@citrix.com>, <stable@vger.kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Date: Mon, 26 Jan 2015 10:53:27 +0000
In-Reply-To: <1416589220-7720-2-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1411211657430.2675@kaball.uk.xensource.com>
	 <1416589220-7720-2-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 17:00 +0000, Stefano Stabellini wrote:
> Need to pass the pointer within the swiotlb internal buffer to the
> swiotlb library, that in the case of xen_unmap_single is dev_addr, not
> paddr.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: konrad.wilk@oracle.com
> CC: stable@vger.kernel.org

This went into mainline as 2c3fc8d26dd0 "swiotlb-xen: pass dev_addr to
swiotlb_tbl_unmap_single" but was reverted in dbdd74763f1f.

However it seems that 2c3fc8d26dd0 has made it into at least some stable
kernel trees:
        v3.18.3 as 2129c43d41e9
        v3.16.7-ckt4 as 94ab279b0c9a
        v3.14.29 as 3394691d34fc
        v3.10.65 as 81cb80b578c5
so it should be reverted there too. This is causing issues in the field
such as https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=776237.

v3.17, v3.15, v3.13.11-ckt14, v3.12.x, v3.11.x appear clean, I stopped
going backwards at v3.10.

Cheers,
Ian.

> ---
>  drivers/xen/swiotlb-xen.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 810ad41..5ea1e3c 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -451,7 +451,7 @@ static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
>  
>  	/* NOTE: We use dev_addr here, not paddr! */
>  	if (is_xen_swiotlb_buffer(dev_addr)) {
> -		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
> +		swiotlb_tbl_unmap_single(hwdev, dev_addr, size, dir);
>  		return;
>  	}
>  


