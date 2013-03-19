Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab3CSP0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:26:10 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:33156 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3CSP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:26:08 -0400
X-IronPort-AV: E=Sophos;i="4.84,872,1355097600"; 
   d="scan'208";a="2657721"
Message-ID: <5148838E.8080808@citrix.com>
Date: Tue, 19 Mar 2013 16:26:06 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/5] xen-blkback: don't store dev_bus_addr
References: <1363625376-35612-1-git-send-email-roger.pau@citrix.com> <1363625376-35612-2-git-send-email-roger.pau@citrix.com> <20130319143217.GC32432@phenom.dumpdata.com> <51488A8C02000078000C6C20@nat28.tlf.novell.com> <20130319151000.GA8550@phenom.dumpdata.com>
In-Reply-To: <20130319151000.GA8550@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/13 16:10, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 19, 2013 at 02:55:56PM +0000, Jan Beulich wrote:
>>>>> On 19.03.13 at 15:32, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>>> On Mon, Mar 18, 2013 at 05:49:32PM +0100, Roger Pau Monne wrote:
>>>> dev_bus_addr returned in the grant ref map operation is the mfn of the
>>>> passed page, there's no need to store it in the persistent grant
>>>> entry, since we can always get it provided that we have the page.
>>>>
>>>> This reduces the memory overhead of persistent grants in blkback.
>>>
>>> I took this patch, but I redid it a bit:
>>>
>>> commit 1d4cb410befdb8b373c6fad604b39e0200e0bee0
>>> Author: Roger Pau Monne <roger.pau@citrix.com>
>>> Date:   Mon Mar 18 17:49:32 2013 +0100
>>>
>>>     xen-blkback: don't store dev_bus_addr
>>>     
>>>     dev_bus_addr returned in the grant ref map operation is the mfn of the
>>>     passed page, there's no need to store it in the persistent grant
>>>     entry, since we can always get it provided that we have the page.
>>>     
>>>     This reduces the memory overhead of persistent grants in blkback.
>>>     
>>>     While at it, rename the 'seg[i].buf' to be 'seg[i].offset' as
>>>     it makes much more sense - as we use that value in bio_add_page
>>>     which as the fourth argument expects the offset.
>>>     
>>>     We hadn't used the physical address as part of this at all.
>>>     
>>>     Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
>>>     Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>     Cc: xen-devel@lists.xen.org 
>>>     [v1: s/buf/offset/]
>>>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>>
>>> diff --git a/drivers/block/xen-blkback/blkback.c 
>>> b/drivers/block/xen-blkback/blkback.c
>>> index 2cf8381..061c202 100644
>>> --- a/drivers/block/xen-blkback/blkback.c
>>> +++ b/drivers/block/xen-blkback/blkback.c
>>> @@ -442,7 +442,7 @@ int xen_blkif_schedule(void *arg)
>>>  }
>>>  
>>>  struct seg_buf {
>>> -	unsigned long buf;
>>> +	unsigned long offset;
>>
>> If you touch this anyway, why don't you reduce the type to
>> "unsigned int", halving the overall structure size?
>>
>> Even more, the field seems pointless to me altogether, since ...
>>
>>>  	unsigned int nsec;
>>>  };
>>>  /*
>>> @@ -621,30 +621,21 @@ static int xen_blkbk_map(struct blkif_request *req,
>>>  				 * If this is a new persistent grant
>>>  				 * save the handler
>>>  				 */
>>> -				persistent_gnts[i]->handle = map[j].handle;
>>> -				persistent_gnts[i]->dev_bus_addr =
>>> -					map[j++].dev_bus_addr;
>>> +				persistent_gnts[i]->handle = map[j++].handle;
>>>  			}
>>>  			pending_handle(pending_req, i) =
>>>  				persistent_gnts[i]->handle;
>>>  
>>>  			if (ret)
>>>  				continue;
>>> -
>>> -			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
>>> -				(req->u.rw.seg[i].first_sect << 9);
>>>  		} else {
>>> -			pending_handle(pending_req, i) = map[j].handle;
>>> +			pending_handle(pending_req, i) = map[j++].handle;
>>>  			bitmap_set(pending_req->unmap_seg, i, 1);
>>>  
>>> -			if (ret) {
>>> -				j++;
>>> +			if (ret)
>>>  				continue;
>>> -			}
>>> -
>>> -			seg[i].buf = map[j++].dev_bus_addr |
>>> -				(req->u.rw.seg[i].first_sect << 9);
>>>  		}
>>> +		seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
>>
>> ... this uses "i" as index on both sides, so ...
>>
>>>  	}
>>>  	return ret;
>>>  }
>>> @@ -971,7 +962,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>>>  		       (bio_add_page(bio,
>>>  				     pages[i],
>>>  				     seg[i].nsec << 9,
>>> -				     seg[i].buf & ~PAGE_MASK) == 0)) {
>>> +				     seg[i].offset & ~PAGE_MASK) == 0)) {
>>
>> ... this one could as well use the original field.
>>
>> And the masking with ~PAGE_MASK is not pointless in any case.
> 
> Good point. In which might as well make the 'struct seg_buf' be an
> simple array of unsigned int.

I didn't do this because later on (when using indirect segments) I need
a place to store the offset, since I don't have the indirect segment
pages mapped during the whole operation, but I guess I could change that.

>>
>> Jan
>>
>>>  
>>>  			bio = bio_alloc(GFP_KERNEL, nseg-i);
>>>  			if (unlikely(bio == NULL))
>>> diff --git a/drivers/block/xen-blkback/common.h 
>>> b/drivers/block/xen-blkback/common.h
>>> index da78346..60103e2 100644
>>> --- a/drivers/block/xen-blkback/common.h
>>> +++ b/drivers/block/xen-blkback/common.h
>>> @@ -187,7 +187,6 @@ struct persistent_gnt {
>>>  	struct page *page;
>>>  	grant_ref_t gnt;
>>>  	grant_handle_t handle;
>>> -	uint64_t dev_bus_addr;
>>>  	struct rb_node node;
>>>  };
>>>  
>>>
>>> _______________________________________________
>>> Xen-devel mailing list
>>> Xen-devel@lists.xen.org 
>>> http://lists.xen.org/xen-devel 
>>
>>

