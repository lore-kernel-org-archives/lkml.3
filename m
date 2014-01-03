Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaACNgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:36:42 -0500
Received: from smtp.citrix.com ([66.165.176.89]:44763 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaACNgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:36:41 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89531282"
Date: Fri, 3 Jan 2014 13:35:52 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] swiotlb: Don't DoS us with 'swiotlb buffer is full'
In-Reply-To: <1388505254-2986-1-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401031334240.8667@kaball.uk.xensource.com>
References: <1388505254-2986-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> There is no need for that so lets use ratelimiting.
> Also add some extra information to be helpful.
> 
> CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

lib/swiotlb.c: In function 'swiotlb_tbl_map_single':
lib/swiotlb.c:509:3: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'size_t' [-Wformat=]


>  lib/swiotlb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index e4399fa..7c97bd2 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -505,7 +505,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
>  
>  not_found:
>  	spin_unlock_irqrestore(&io_tlb_lock, flags);
> -	dev_warn(hwdev, "swiotlb buffer is full\n");
> +	if (printk_ratelimit())
> +		dev_warn(hwdev, "swiotlb buffer is full (sz: %ld bytes)\n", size);
>  	return SWIOTLB_MAP_ERROR;
>  found:
>  	spin_unlock_irqrestore(&io_tlb_lock, flags);
> -- 
> 1.8.3.1
> 
