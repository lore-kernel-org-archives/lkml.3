Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3GKNsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:48:10 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3987 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab3GKNsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:48:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363132800"; 
   d="scan'208";a="34654229"
Message-ID: <51DEB795.3000602@citrix.com>
Date: Thu, 11 Jul 2013 14:48:05 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH RFC 4/4] xen-block: introduce a new request
 type to unmap grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>	<1373288607-1876-5-git-send-email-roger.pau@citrix.com>	<20130708194152.GJ4927@phenom.dumpdata.com> <51DD271B.3010408@citrix.com>
In-Reply-To: <51DD271B.3010408@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/13 10:19, Roger Pau Monné wrote:
> 
>>From 1ede72ba10a7ec13d57ba6d2af54e86a099d7125 Mon Sep 17 00:00:00 2001
> From: Roger Pau Monne <roger.pau@citrix.com>
> Date: Wed, 10 Jul 2013 10:22:19 +0200
> Subject: [PATCH RFC] xen-blkfront: revoke foreign access for grants not
>  mapped by the backend
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
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

Does this place in implicit requirement on the behaviour of the backend.
 i.e., the backend must persistently map the first N grants and always
unmap the remainder?  If so, this should be clearly documented.

It also seems odd to have the backend decide how much frontend resource
can be consumed at anyone time.  It's not clear how the backend is
supposed to know how many persistent grants it should hang on to.

David
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/block/xen-blkfront.c |   33 +++++++++++++++++++++++++++++----
>  1 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 3d445c0..6ba88c1 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1022,13 +1022,38 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
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
>  	}
>  	if (s->req.operation == BLKIF_OP_INDIRECT) {
>  		for (i = 0; i < INDIRECT_GREFS(nseg); i++) {
> -			list_add(&s->indirect_grants[i]->node, &info->persistent_gnts);
> -			info->persistent_gnts_c++;
> +			if (gnttab_query_foreign_access(s->indirect_grants[i]->gref)) {
> +				list_add(&s->indirect_grants[i]->node, &info->persistent_gnts);
> +				info->persistent_gnts_c++;
> +			} else {
> +				gnttab_end_foreign_access(s->indirect_grants[i]->gref, 0, 0UL);
> +				s->indirect_grants[i]->gref = GRANT_INVALID_REF;
> +				list_add_tail(&s->indirect_grants[i]->node,
> +				              &info->persistent_gnts);
> +			}
>  		}
>  	}
>  }

