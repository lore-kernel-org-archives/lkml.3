Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3DZOrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:47:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21639 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab3DZOrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:47:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,559,1363132800"; 
   d="scan'208";a="21815112"
Message-ID: <517A938C.6060703@citrix.com>
Date: Fri, 26 Apr 2013 15:47:40 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] xen-blkback: allocate list of pending reqs in small chunks
References: <1366983947-54578-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1366983947-54578-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 14:45, Roger Pau Monne wrote:
> Allocate pending requests in smaller chunks instead of allocating them
> all at the same time.
> 
> This change also removes the global array of pending_reqs, it is no
> longer necessay.
> 
> Variables related to the grant mapping have been grouped into a struct
> called "grant_page", this allows to allocate them in smaller chunks,
> and also improves memory locality.
> 
[...]
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index afab208..2841c0f 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -127,22 +128,53 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>         blkif->free_pages_num = 0;
>         atomic_set(&blkif->persistent_gnt_in_use, 0);
> 
> -       blkif->pending_reqs = kcalloc(XEN_BLKIF_REQS,
> -                                     sizeof(blkif->pending_reqs[0]),
> -                                     GFP_KERNEL);
> -       if (!blkif->pending_reqs) {
> -               kmem_cache_free(xen_blkif_cachep, blkif);
> -               return ERR_PTR(-ENOMEM);
> -       }
>         INIT_LIST_HEAD(&blkif->pending_free);
> +
> +       pr_alert("sizeof req: %lu\n", sizeof(*req));

Stray pr_alert() here.

Looks good otherwise.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
