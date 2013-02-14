Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab3BNNX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:23:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37570 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735Ab3BNNX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:23:26 -0500
Date: Thu, 14 Feb 2013 08:23:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH] xen-blkback: use balloon pages for persistent grants
Message-ID: <20130214132318.GC2506@phenom.dumpdata.com>
References: <1360836729-17874-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1360836729-17874-1-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:12:09AM +0100, Roger Pau Monne wrote:
> With current persistent grants implementation we are not freeing the
> persistent grants after we disconnect the device. Since grant map

Can you explain this in more details please? Isn't gnttab_set_unmap_op
in free_persistent_gnts doing the right job of putting in the right
mfn in? And then we could free the page?


> operations change the mfn of the allocated page, and we can no longer
> pass it to __free_page without setting the mfn to a sane value, use
> balloon grant pages instead, as the gntdev device does.


Wow. I did not realize that we leaving such a huge memory leak behind!
But I guess that was never an issue as we would recycle those persistent
grants to other domains.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: xen-devel@lists.xen.org
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkback/blkback.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index c46824f..e6c2f6a 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -46,6 +46,7 @@
>  #include <xen/xen.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
> +#include <xen/balloon.h>
>  #include "common.h"
>  
>  /*
> @@ -239,6 +240,7 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
>  			ret = gnttab_unmap_refs(unmap, NULL, pages,
>  				segs_to_unmap);
>  			BUG_ON(ret);
> +			free_xenballooned_pages(segs_to_unmap, pages);
>  			segs_to_unmap = 0;
>  		}
>  
> @@ -527,8 +529,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>  				GFP_KERNEL);
>  			if (!persistent_gnt)
>  				return -ENOMEM;
> -			persistent_gnt->page = alloc_page(GFP_KERNEL);
> -			if (!persistent_gnt->page) {
> +			if (alloc_xenballooned_pages(1, &persistent_gnt->page,
> +			    false)) {
>  				kfree(persistent_gnt);
>  				return -ENOMEM;
>  			}
> -- 
> 1.7.7.5 (Apple Git-26)
> 
