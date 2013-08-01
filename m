Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3HAKKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:10:19 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27992 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3HAKKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:10:17 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="40707493"
Message-ID: <51FA3407.7050106@citrix.com>
Date: Thu, 1 Aug 2013 11:10:15 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen-blkfront: revoke foreign access for
 grants not mapped by the backend
References: <1375282844-4314-1-git-send-email-roger.pau@citrix.com> <1375282844-4314-4-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1375282844-4314-4-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/13 16:00, Roger Pau Monne wrote:
> There's no need to keep the foreign access in a grant if it is not
> persistently mapped by the backend. This allows us to free grants that
> are not mapped by the backend, thus preventing blkfront from hoarding
> all grants.
> 
> The main effect of this is that blkfront will only persistently map
> the same grants as the backend, and it will always try to use grants
> that are already mapped by the backend. Also the number of persistent
> grants in blkfront is the same as in blkback (and is controlled by the
> value in blkback).
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

But please see the documentation updates needed below.

> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1016,13 +1016,38 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>  	}
>  	/* Add the persistent grant into the list of free grants */
>  	for (i = 0; i < nseg; i++) {
> -		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
> -		info->persistent_gnts_c++;
> +		if (gnttab_query_foreign_access(s->grants_used[i]->gref)) {
> +			/*
> +			 * If the grant is still mapped by the backend (the
> +			 * backend has chosen to make this grant persistent)
> +			 * we add it at the head of the list, so it will be
> +			 * reused first.
> +			 */
> +			list_add(&s->grants_used[i]->node, &info->persistent_gnts);
> +			info->persistent_gnts_c++;
> +		} else {
> +			/*
> +			 * If the grant is not mapped by the backend we end the
> +			 * foreign access and add it to the tail of the list,
> +			 * so it will not be picked again unless we run out of
> +			 * persistent grants.
> +			 */
> +			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
> +			s->grants_used[i]->gref = GRANT_INVALID_REF;
> +			list_add_tail(&s->grants_used[i]->node, &info->persistent_gnts);
> +		}

Because you only reclaim grants when a request is completed, can you add
text similar to the following to xen/include/public/io/blkif.h (and the
Linux copy).

feature-persistent:
...
   When the backend driver needs to unmap a persistent grant it should
   do so prior to completing a request that used that grant reference.
   If a persistent grant is unmapped at any other time, the frontend
   driver may not notice and may be unable to reclaim the grant
   reference.

Thanks.

David
