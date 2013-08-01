Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3HAOS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:18:57 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:60681 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab3HAOSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:18:55 -0400
X-IronPort-AV: E=Sophos;i="4.89,794,1367971200"; 
   d="scan'208";a="7368726"
Message-ID: <51FA6E4E.2080001@citrix.com>
Date: Thu, 1 Aug 2013 16:18:54 +0200
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen-blkback: use bigger array for batch gnt
 operations
References: <1375358934-6335-1-git-send-email-roger.pau@citrix.com> <51FA54EC.6030604@citrix.com>
In-Reply-To: <51FA54EC.6030604@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/13 14:30, David Vrabel wrote:
> On 01/08/13 13:08, Roger Pau Monne wrote:
>> Right now the maximum number of grant operations that can be batched
>> in a single request is BLKIF_MAX_SEGMENTS_PER_REQUEST (11). This was
>> OK before indirect descriptors because the maximum number of segments
>> in a request was 11, but with the introduction of indirect
>> descriptors the maximum number of segments in a request has been
>> increased past 11.
>>
>> The memory used by the structures that are passed in the hypercall was
>> allocated from the stack, but if we have to increase the size of the
>> array we can no longer use stack memory, so we have to pre-allocate
>> it.
>>
>> This patch increases the maximum size of batch grant operations and
>> replaces the use of stack memory with pre-allocated memory, that is
>> reserved when the blkback instance is initialized.
> [...]
>> --- a/drivers/block/xen-blkback/xenbus.c
>> +++ b/drivers/block/xen-blkback/xenbus.c
> [...]
>> @@ -148,6 +155,16 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>>  			if (!req->indirect_pages[j])
>>  				goto fail;
>>  		}
>> +		req->map = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->map[0]), GFP_KERNEL);
>> +		if (!req->map)
>> +			goto fail;
>> +		req->unmap = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->unmap[0]), GFP_KERNEL);
>> +		if (!req->unmap)
>> +			goto fail;
>> +		req->pages_to_gnt = kcalloc(GNT_OPERATIONS_SIZE, sizeof(req->pages_to_gnt[0]),
>> +		                            GFP_KERNEL);
>> +		if (!req->pages_to_gnt)
>> +			goto fail;
> 
> Do these need to be per-request? Or can they all share a common set of
> arrays?

No, we cannot share them unless we serialize the unmap of grants using a
spinlock (like we do when writing the reponse on the ring).

