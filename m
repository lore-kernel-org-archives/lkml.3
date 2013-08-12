Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3HLMCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:02:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32716 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3HLMCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:02:17 -0400
Date: Mon, 12 Aug 2013 08:02:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH 3/3] xen-blkfront: revoke foreign access for
 grants not mapped by the backend
Message-ID: <20130812120209.GC2898@phenom.dumpdata.com>
References: <1375282844-4314-1-git-send-email-roger.pau@citrix.com>
 <1375282844-4314-4-git-send-email-roger.pau@citrix.com>
 <51FA3407.7050106@citrix.com>
 <20130809150837.GA5637@phenom.dumpdata.com>
 <5208BFDF.40308@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5208BFDF.40308@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 12:58:39PM +0200, Roger Pau Monné wrote:
> On 09/08/13 17:08, Konrad Rzeszutek Wilk wrote:
> > On Thu, Aug 01, 2013 at 11:10:15AM +0100, David Vrabel wrote:
> >> On 31/07/13 16:00, Roger Pau Monne wrote:
> >>> There's no need to keep the foreign access in a grant if it is not
> >>> persistently mapped by the backend. This allows us to free grants that
> >>> are not mapped by the backend, thus preventing blkfront from hoarding
> >>> all grants.
> >>>
> >>> The main effect of this is that blkfront will only persistently map
> >>> the same grants as the backend, and it will always try to use grants
> >>> that are already mapped by the backend. Also the number of persistent
> >>> grants in blkfront is the same as in blkback (and is controlled by the
> >>> value in blkback).
> >>>
> >>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> >>
> >> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> > 
> > Roger,
> > 
> > Could you repost patch #2 and #3 (as #1 is in v3.11-rc4) with the
> > comments and the Ack from Matt and Roger's Review-by tag addressed?
> 
> Done (I guess you meant the Reviewed-by tag from David), see below however.
> 
> > Thanks.
> >>
> >> But please see the documentation updates needed below.
> >>
> >>> --- a/drivers/block/xen-blkfront.c
> >>> +++ b/drivers/block/xen-blkfront.c
> >>> @@ -1016,13 +1016,38 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
> >>>  	}
> >>>  	/* Add the persistent grant into the list of free grants */
> >>>  	for (i = 0; i < nseg; i++) {
> >>> -		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
> >>> -		info->persistent_gnts_c++;
> >>> +		if (gnttab_query_foreign_access(s->grants_used[i]->gref)) {
> >>> +			/*
> >>> +			 * If the grant is still mapped by the backend (the
> >>> +			 * backend has chosen to make this grant persistent)
> >>> +			 * we add it at the head of the list, so it will be
> >>> +			 * reused first.
> >>> +			 */
> >>> +			list_add(&s->grants_used[i]->node, &info->persistent_gnts);
> >>> +			info->persistent_gnts_c++;
> >>> +		} else {
> >>> +			/*
> >>> +			 * If the grant is not mapped by the backend we end the
> >>> +			 * foreign access and add it to the tail of the list,
> >>> +			 * so it will not be picked again unless we run out of
> >>> +			 * persistent grants.
> >>> +			 */
> >>> +			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
> >>> +			s->grants_used[i]->gref = GRANT_INVALID_REF;
> >>> +			list_add_tail(&s->grants_used[i]->node, &info->persistent_gnts);
> >>> +		}
> >>
> >> Because you only reclaim grants when a request is completed, can you add
> >> text similar to the following to xen/include/public/io/blkif.h (and the
> >> Linux copy).
> >>
> >> feature-persistent:
> >> ...
> >>    When the backend driver needs to unmap a persistent grant it should
> >>    do so prior to completing a request that used that grant reference.
> >>    If a persistent grant is unmapped at any other time, the frontend
> >>    driver may not notice and may be unable to reclaim the grant
> >>    reference.
> >>
> 
> I've sent a patch to update the documentation about persistent grants in
> Xen source tree, but the Linux copy of blkif.h lacks any information
> about the blkif protocol extensions, so I have not added it there. If
> nobody else does it first (before I come back from vacation), I will
> send a patch to add the documentation about all the blkif extensions to
> the Linux copy of blkif.h (and of course add your comment about
> persistent grants unmap).

Please do. It would be good to resync that header file. Thanks.
