Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaIXMlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:41:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54823 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaIXMlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:41:03 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-99-5422bbdcf1b5
Message-id: <5422BBDB.7050904@samsung.com>
Date: Wed, 24 Sep 2014 14:40:59 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, Fancy Fang <chen.fang@freescale.com>,
        m.chehab@samsung.com, viro@ZenIV.linux.org.uk
Cc: shawn.guo@freescale.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
References: <1410326937-31140-1-git-send-email-chen.fang@freescale.com>
 <540FF70E.9050203@xs4all.nl>
In-reply-to: <540FF70E.9050203@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xK7p3diuFGExfr2tx7NRaFotTk58x
	WVzeNYfNomfDVlaLi+vkLZa1tLFYnP97nNWB3ePf4X4mj74tqxg9Pm+S8zj19TO7x6Ynb5kC
	WKO4bFJSczLLUov07RK4Mo69/stccFK4ou3eL6YGxp/8XYwcHBICJhJfnmp2MXICmWISF+6t
	Z+ti5OIQEljKKLFj8X1WkISQwCdGie/7y0DqeQW0JM48FwEJswioSuz/+ZwFxGYTMJToetvF
	BmKLCsRILP24ByzOKyAo8WPyPTBbRKBGYuHBX0wgNrNAhMThm3/AbGGBVImTFzcwQaxKk5gz
	6yE7yCpOAU2JFZNyIcrNJL68PMwKYctLbF7zlnkCo8AsJBtmISmbhaRsASPzKkbR1NLkguKk
	9FwjveLE3OLSvHS95PzcTYyQ4P66g3HpMatDjAIcjEo8vBPFlUKEWBPLiitzDzFKcDArifCW
	7gIK8aYkVlalFuXHF5XmpBYfYmTi4JRqYMyeEbU+scq+JPPJVSuu9feTlty+IG1lam7PzMR1
	e/26/KyKXMNg/R3xtjuPrnH5uT3L4OyVVdFSOjunfVmZo8G5UF3WW+/frZgerdmTVlwsuvya
	4+qs3bHHXr4rlpgYpZ/zMu6VnjNbrIREg4xTz+sr2z7cK5/evvPvPiGfv0W7D17oiJKSX6vE
	UpyRaKjFXFScCABfBx1ETAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-09-10 09:00, Hans Verkuil wrote:
> On 09/10/14 07:28, Fancy Fang wrote:
>> When user requests V4L2_MEMORY_MMAP type buffers, the videobuf-core
>> will assign the corresponding offset to the 'boff' field of the
>> videobuf_buffer for each requested buffer sequentially. Later, user
>> may call mmap() to map one or all of the buffers with the 'offset'
>> parameter which is equal to its 'boff' value. Obviously, the 'offset'
>> value is only used to find the matched buffer instead of to be the
>> real offset from the buffer's physical start address as used by
>> vm_iomap_memory(). So, in some case that if the offset is not zero,
>> vm_iomap_memory() will fail.
> Is this just a fix for something that can fail theoretically, or do you
> actually have a case where this happens? I am very reluctant to make
> any changes to videobuf. Drivers should all migrate to vb2.
>
> I have CC-ed Marek as well since he knows a lot more about this stuff
> than I do.

I'm sorry for a delay, I was really busy with other things.

>> Signed-off-by: Fancy Fang <chen.fang@freescale.com>
>> ---
>>   drivers/media/v4l2-core/videobuf-dma-contig.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
>> index bf80f0f..8bd9889 100644
>> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
>> @@ -305,7 +305,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>>   	/* Try to remap memory */
>>   	size = vma->vm_end - vma->vm_start;
>>   	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> -	retval = vm_iomap_memory(vma, mem->dma_handle, size);
>> +	retval = remap_pfn_range(vma, vma->vm_start,
>> +				 mem->dma_handle >> PAGE_SHIFT,
>> +				 size, vma->vm_page_prot);
>>   	if (retval) {
>>   		dev_err(q->dev, "mmap: remap failed with error %d. ",
>>   			retval);

I think we don't need to revert the code to use remap_pfn_range() again 
(like
it was in pre v3.10 times). The simplest way will be to correctly fix
vma->vm_pgoff and set it to zero before calling vm_iomap_memory(). It is
done the same way in vb2_dma_contig.c:vb2_dc_mmap().

To sum up - please change your patch: keep vm_iomap_memory() call and add
"vma->vm_pgoff = 0;" line before it with suitable comment.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

