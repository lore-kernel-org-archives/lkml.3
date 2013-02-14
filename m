Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637Ab3BNPC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:02:26 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:15454 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab3BNPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:02:24 -0500
X-IronPort-AV: E=Sophos;i="4.84,665,1355097600"; 
   d="scan'208";a="1465633"
Message-ID: <511CFC93.9070205@citrix.com>
Date: Thu, 14 Feb 2013 16:02:43 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH] xen-blkback: use balloon pages for persistent grants
References: <1360836729-17874-1-git-send-email-roger.pau@citrix.com> <20130214132318.GC2506@phenom.dumpdata.com>
In-Reply-To: <20130214132318.GC2506@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/13 14:23, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 14, 2013 at 11:12:09AM +0100, Roger Pau Monne wrote:
>> With current persistent grants implementation we are not freeing the
>> persistent grants after we disconnect the device. Since grant map
> 
> Can you explain this in more details please? Isn't gnttab_set_unmap_op
> in free_persistent_gnts doing the right job of putting in the right
> mfn in? And then we could free the page?

No, after gnttab_unmap_refs the page still points to the grant frame
mfn. All the users of grant frames either have an internal buffer of
pages that are reused (like blkback), or use balloon pages (like gntdev).

I could probably modify gnttab_map to store the mfn and set it back at
gnttab_unmap, but that will surely require more work than this simple fix.

> 
> 
>> operations change the mfn of the allocated page, and we can no longer
>> pass it to __free_page without setting the mfn to a sane value, use
>> balloon grant pages instead, as the gntdev device does.
> 
> 
> Wow. I did not realize that we leaving such a huge memory leak behind!
> But I guess that was never an issue as we would recycle those persistent
> grants to other domains.

No, we didn't recycle them AFAIK, we allocated them using alloc_page,
passed them to gnttab_map, used them, and when closing the backend we
only unmapped them, but they where never freed.

>>
>> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>> Cc: xen-devel@lists.xen.org
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> ---
>>  drivers/block/xen-blkback/blkback.c |    6 ++++--
>>  1 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
>> index c46824f..e6c2f6a 100644
>> --- a/drivers/block/xen-blkback/blkback.c
>> +++ b/drivers/block/xen-blkback/blkback.c
>> @@ -46,6 +46,7 @@
>>  #include <xen/xen.h>
>>  #include <asm/xen/hypervisor.h>
>>  #include <asm/xen/hypercall.h>
>> +#include <xen/balloon.h>
>>  #include "common.h"
>>  
>>  /*
>> @@ -239,6 +240,7 @@ static void free_persistent_gnts(struct rb_root *root, unsigned int num)
>>  			ret = gnttab_unmap_refs(unmap, NULL, pages,
>>  				segs_to_unmap);
>>  			BUG_ON(ret);
>> +			free_xenballooned_pages(segs_to_unmap, pages);
>>  			segs_to_unmap = 0;
>>  		}
>>  
>> @@ -527,8 +529,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>>  				GFP_KERNEL);
>>  			if (!persistent_gnt)
>>  				return -ENOMEM;
>> -			persistent_gnt->page = alloc_page(GFP_KERNEL);
>> -			if (!persistent_gnt->page) {
>> +			if (alloc_xenballooned_pages(1, &persistent_gnt->page,
>> +			    false)) {
>>  				kfree(persistent_gnt);
>>  				return -ENOMEM;
>>  			}
>> -- 
>> 1.7.7.5 (Apple Git-26)
>>

