Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3HLK6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:58:42 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:26120 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3HLK6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:58:41 -0400
X-IronPort-AV: E=Sophos;i="4.89,861,1367971200"; 
   d="scan'208";a="7708730"
Message-ID: <5208BFDF.40308@citrix.com>
Date: Mon, 12 Aug 2013 12:58:39 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen-blkfront: revoke foreign access for
 grants not mapped by the backend
References: <1375282844-4314-1-git-send-email-roger.pau@citrix.com> <1375282844-4314-4-git-send-email-roger.pau@citrix.com> <51FA3407.7050106@citrix.com> <20130809150837.GA5637@phenom.dumpdata.com>
In-Reply-To: <20130809150837.GA5637@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/13 17:08, Konrad Rzeszutek Wilk wrote:
> On Thu, Aug 01, 2013 at 11:10:15AM +0100, David Vrabel wrote:
>> On 31/07/13 16:00, Roger Pau Monne wrote:
>>> There's no need to keep the foreign access in a grant if it is not
>>> persistently mapped by the backend. This allows us to free grants that
>>> are not mapped by the backend, thus preventing blkfront from hoarding
>>> all grants.
>>>
>>> The main effect of this is that blkfront will only persistently map
>>> the same grants as the backend, and it will always try to use grants
>>> that are already mapped by the backend. Also the number of persistent
>>> grants in blkfront is the same as in blkback (and is controlled by the
>>> value in blkback).
>>>
>>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>>
>> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> Roger,
> 
> Could you repost patch #2 and #3 (as #1 is in v3.11-rc4) with the
> comments and the Ack from Matt and Roger's Review-by tag addressed?

Done (I guess you meant the Reviewed-by tag from David), see below however.

> Thanks.
>>
>> But please see the documentation updates needed below.
>>
>>> --- a/drivers/block/xen-blkfront.c
>>> +++ b/drivers/block/xen-blkfront.c
>>> @@ -1016,13 +1016,38 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
>>>  	}
>>>  	/* Add the persistent grant into the list of free grants */
>>>  	for (i = 0; i < nseg; i++) {
>>> -		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
>>> -		info->persistent_gnts_c++;
>>> +		if (gnttab_query_foreign_access(s->grants_used[i]->gref)) {
>>> +			/*
>>> +			 * If the grant is still mapped by the backend (the
>>> +			 * backend has chosen to make this grant persistent)
>>> +			 * we add it at the head of the list, so it will be
>>> +			 * reused first.
>>> +			 */
>>> +			list_add(&s->grants_used[i]->node, &info->persistent_gnts);
>>> +			info->persistent_gnts_c++;
>>> +		} else {
>>> +			/*
>>> +			 * If the grant is not mapped by the backend we end the
>>> +			 * foreign access and add it to the tail of the list,
>>> +			 * so it will not be picked again unless we run out of
>>> +			 * persistent grants.
>>> +			 */
>>> +			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
>>> +			s->grants_used[i]->gref = GRANT_INVALID_REF;
>>> +			list_add_tail(&s->grants_used[i]->node, &info->persistent_gnts);
>>> +		}
>>
>> Because you only reclaim grants when a request is completed, can you add
>> text similar to the following to xen/include/public/io/blkif.h (and the
>> Linux copy).
>>
>> feature-persistent:
>> ...
>>    When the backend driver needs to unmap a persistent grant it should
>>    do so prior to completing a request that used that grant reference.
>>    If a persistent grant is unmapped at any other time, the frontend
>>    driver may not notice and may be unable to reclaim the grant
>>    reference.
>>

I've sent a patch to update the documentation about persistent grants in
Xen source tree, but the Linux copy of blkif.h lacks any information
about the blkif protocol extensions, so I have not added it there. If
nobody else does it first (before I come back from vacation), I will
send a patch to add the documentation about all the blkif extensions to
the Linux copy of blkif.h (and of course add your comment about
persistent grants unmap).

Roger.

