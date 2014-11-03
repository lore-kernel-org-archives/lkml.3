Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaKCPrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:47:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42430 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaKCPrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:47:16 -0500
Message-ID: <5457A401.5040908@oracle.com>
Date: Mon, 03 Nov 2014 10:49:21 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Laszlo Ersek <lersek@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] xen/blkfront: improve protection against issuing unsupported
 REQ_FUA
References: <1414417478-20268-1-git-send-email-vkuznets@redhat.com> <54577368.9060000@redhat.com>
In-Reply-To: <54577368.9060000@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2014 07:22 AM, Laszlo Ersek wrote:
> On 10/27/14 14:44, Vitaly Kuznetsov wrote:
>> Guard against issuing unsupported REQ_FUA and REQ_FLUSH was introduced
>> in d11e61583 and was factored out into blkif_request_flush_valid() in
>> 0f1ca65ee. However:
>> 1) This check in incomplete. In case we negotiated to feature_flush = REQ_FLUSH
>>     and flush_op = BLKIF_OP_FLUSH_DISKCACHE (so FUA is unsupported) FUA request
>>     will still pass the check.
>> 2) blkif_request_flush_valid() is misnamed. It is bool but returns true when
>>     the request is invalid.
>> 3) When blkif_request_flush_valid() fails -EIO is being returned. It seems that
>>     -EOPNOTSUPP is more appropriate here.
>> Fix all of the above issues.
>>
>> This patch is based on the original patch by Laszlo Ersek and a comment by
>> Jeff Moyer.
>>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>   drivers/block/xen-blkfront.c | 14 ++++++++------
>>   1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index 5ac312f..2e6c103 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>> @@ -582,12 +582,14 @@ static inline void flush_requests(struct blkfront_info *info)
>>   		notify_remote_via_irq(info->irq);
>>   }
>>   
>> -static inline bool blkif_request_flush_valid(struct request *req,
>> -					     struct blkfront_info *info)
>> +static inline bool blkif_request_flush_invalid(struct request *req,
>> +					       struct blkfront_info *info)
>>   {
>>   	return ((req->cmd_type != REQ_TYPE_FS) ||
>> -		((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
>> -		!info->flush_op));
>> +		((req->cmd_flags & REQ_FLUSH) &&
>> +		 !(info->feature_flush & REQ_FLUSH)) ||
>> +		((req->cmd_flags & REQ_FUA) &&
>> +		 !(info->feature_flush & REQ_FUA)));

Somewhat unrelated to the patch, but I am wondering whether we actually 
need flush_op field at all as it seems that it is unambiguously defined 
by REQ_FLUSH/REQ_FUA.

-boris

>>   }
>>   
>>   /*
>> @@ -612,8 +614,8 @@ static void do_blkif_request(struct request_queue *rq)
>>   
>>   		blk_start_request(req);
>>   
>> -		if (blkif_request_flush_valid(req, info)) {
>> -			__blk_end_request_all(req, -EIO);
>> +		if (blkif_request_flush_invalid(req, info)) {
>> +			__blk_end_request_all(req, -EOPNOTSUPP);
>>   			continue;
>>   		}
>>   
>>
> Not sure if there has been some feedback yet (I can't see anything
> threaded with this message in my inbox).
>
> FWIW I consulted "Documentation/block/writeback_cache_control.txt" for
> this review. Apparently, REQ_FLUSH forces out "previously completed
> write requests", whereas REQ_FUA delays the IO completion signal for
> *this* request until "the data has been committed to non-volatile
> storage". So, indeed, support for REQ_FLUSH only does not guarantee that
> REQ_FUA can be served.
>
> Reviewed-by: Laszlo Ersek <lersek@redhat.com>
>
> Thanks
> Laszlo

