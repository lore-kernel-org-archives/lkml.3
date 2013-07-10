Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3GJNyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 09:54:39 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61885 "EHLO
	smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3GJNyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 09:54:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,1036,1363132800"; 
   d="scan'208";a="580878472"
Message-ID: <51DD6792.8040502@amazon.de>
Date: Wed, 10 Jul 2013 15:54:26 +0200
From: "Egger, Christoph" <chegger@amazon.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH RFC 4/4] xen-block: introduce a new request
 type to unmap grants
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-5-git-send-email-roger.pau@citrix.com> <20130708194152.GJ4927@phenom.dumpdata.com> <51DD271B.3010408@citrix.com>
In-Reply-To: <51DD271B.3010408@citrix.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.07.13 11:19, Roger Pau Monné wrote:
> On 08/07/13 21:41, Konrad Rzeszutek Wilk wrote:
>> On Mon, Jul 08, 2013 at 03:03:27PM +0200, Roger Pau Monne wrote:
>>> Right now blkfront has no way to unmap grant refs, if using persistent
>>> grants once a grant is used blkfront cannot assure if blkback will
>>> have this grant mapped or not. To solve this problem, a new request
>>> type (BLKIF_OP_UNMAP) that allows requesting blkback to unmap certain
>>> grants is introduced.
>>
>> I don't think this is the right way of doing it. It is a new operation
>> (BLKIF_OP_UNMAP) that has nothing to do with READ/WRITE. All it is
>> is just some way for the frontend to say: unmap this grant if you can.
>>
>> As such I would think a better mechanism would be to have a new
>> grant mechanism that can say: 'I am done with this grant you can
>> remove it' - that is called to the hypervisor. The hypervisor
>> can then figure out whether it is free or not and lazily delete it.
>> (And the guest would be notified when it is freed).
> 
> I have a patch that I think implements something quite similar to what 
> you describe, but it doesn't require any new patch to the hypervisor 
> side. From blkfront we can check what grants blkback has chosen to 
> persistently map and only keep those.
> 
> This is different from my previous approach, were blkfront could 
> specifically request blkback to unmap certain grants, but it still 
> prevents blkfront from hoarding all grants (unless blkback is 
> persistently mapping every possible grant). With this patch the number 
> of persistent grants in blkfront will be the same as in blkback, so 
> basically the backend can control how many grants will be persistently 
> mapped. 

According to your blog
http://blog.xen.org/index.php/2012/11/23/improving-block-protocol-scalability-with-persistent-grants/
persistent grants in the frontend gives an benefit even when the backend does not support
persistent grants. Is this still the case with this patch?

Christoph


> ---
> From 1ede72ba10a7ec13d57ba6d2af54e86a099d7125 Mon Sep 17 00:00:00 2001
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
> 

