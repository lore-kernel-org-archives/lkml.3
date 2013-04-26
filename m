Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab3DZHdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:33:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683Ab3DZHdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:33:23 -0400
Message-ID: <517A2DBD.3080506@suse.de>
Date: Fri, 26 Apr 2013 09:33:17 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, dwmw2@infradead.org, axboe@kernel.dk,
        shli@kernel.org, Paul.Clements@steeleye.com, npiggin@kernel.dk,
        neilb@suse.de, cjb@laptop.org, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcmvbkbc@gmail.com, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v2 0/9] fix max discard sectors limit
References: <1366389602-19313-1-git-send-email-linkinjeon@gmail.com> <1366487439.1993.9.camel@dabdike>
In-Reply-To: <1366487439.1993.9.camel@dabdike>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2013 09:50 PM, James Bottomley wrote:
> On Sat, 2013-04-20 at 01:40 +0900, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
>> commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 
>> (block: add plug for blkdev_issue_discard )
>>
>> For example,
>> 1) DISCARD rq-1 with size size 4GB
>> 2) DISCARD rq-2 with size size 1GB
>>
>> If these 2 discard requests get merged, final request size will be 5GB.
>>
>> In this case, request's __data_len field may overflow as it can store
>> max 4GB(unsigned int).
>>
>> This issue was observed while doing mkfs.f2fs on 5GB SD card:
>> https://lkml.org/lkml/2013/4/1/292
>>
>> # mkfs.f2fs /dev/mmcblk0p3
>> Info: sector size = 512
>> Info: total sectors = 11370496 (in 512bytes)
>> Info: zone aligned segment0 blkaddr: 512
>> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
>>
>> mkfs process gets stuck in D state and I see the following in the dmesg:
>>
>> [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
>> [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
>> [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
>> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
>> [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
>> [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
>> [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
>>
>> Few drivers(e.g. mmc, mtd..) set q->limits.max_discard_sectors
>> more than UINT_MAX >> 9 sectors which is incorrect and it may lead to overflow
>> of request's __data_len field if merged discard request's size exceeds 4GB.
>>
>> This patchset fixes this issue by updating helper function
>> blk_queue_max_discard_sectors which is used to set max_discard_sectors limit.
>>
>> This patchset also replaces "q->limits.max_discard_sector = max_discard_sectors"
>> with blk_queue_max_discard_sectors call in other drivers like mmc, mtd etc.
> 
> I really don't understand this explanation.  How can you be affected by
> the incorrect setting of q->limits.max_discard sectors when  n the
> blkdev_issue_discard() code you see:
> 
> 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >>
> 9);
> 
> ?
> 
> The problem is not that we issue discards bigger than __data_len can
> allow, the problem is that we merge them larger than __data_len will
> allow.  That means the merge code needs fixing to pay attention to
> max_discard_sectors, so isn't this the correct fix:
> 
> James
> 
> ---
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 78feda9..33f358f 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -838,7 +838,7 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
>  						     unsigned int cmd_flags)
>  {
>  	if (unlikely(cmd_flags & REQ_DISCARD))
> -		return q->limits.max_discard_sectors;
> +		return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
>  
>  	if (unlikely(cmd_flags & REQ_WRITE_SAME))
>  		return q->limits.max_write_same_sectors;
> 
> 
Patch works, and fixes the discard failing issue I've been pestering
mkp with at LSF. Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
