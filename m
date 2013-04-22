Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3DVLwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab3DVLwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:52:37 -0400
Message-ID: <51752475.5080600@redhat.com>
Date: Mon, 22 Apr 2013 08:52:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Prabhakar lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH RFC] media: videobuf2: fix the length check for mmap
References: <1366364816-3567-1-git-send-email-prabhakar.csengg@gmail.com> <20130419081801.0af7ad73@redhat.com> <4764027.ER4TtP6hZT@avalon>
In-Reply-To: <4764027.ER4TtP6hZT@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 21-04-2013 19:38, Laurent Pinchart escreveu:
> Hi Mauro,
>
> On Friday 19 April 2013 08:18:01 Mauro Carvalho Chehab wrote:
>> Em Fri, 19 Apr 2013 15:16:56 +0530 Prabhakar lad escreveu:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>>  From commit 068a0df76023926af958a336a78bef60468d2033
>>> "[media] media: vb2: add length check for mmap"
>>> patch verifies that the mmap() size requested by userspace
>>> doesn't exceed the buffer size.
>>>
>>> As the mmap() size is rounded up to the next page boundary
>>> the check will fail for buffer sizes that are not multiple
>>> of the page size.
>>>
>>> This patch fixes the check by aligning the buffer size to page
>>> size during the check. Alongside fixes the vmalloc allocator
>>> to round up the size.
>>>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>>> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>>> ---
>>>
>>>   drivers/media/v4l2-core/videobuf2-core.c    |    2 +-
>>>   drivers/media/v4l2-core/videobuf2-vmalloc.c |    2 +-
>>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>>> b/drivers/media/v4l2-core/videobuf2-core.c index 58c1744..223fcd4 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>> @@ -1886,7 +1886,7 @@ int vb2_mmap(struct vb2_queue *q, struct
>>> vm_area_struct *vma)>
>>>   	vb = q->bufs[buffer];
>>>
>>> -	if (vb->v4l2_planes[plane].length < (vma->vm_end - vma->vm_start)) {
>>> +	if (PAGE_ALIGN(vb->v4l2_planes[plane].length) < (vma->vm_end -
>>> vma->vm_start)) {>
>>>   		dprintk(1, "Invalid length\n");
>>>   		return -EINVAL;
>>>   	
>>>   	}
>>
>> That is tricky, as it assumes that vb->v4l2_planes[plane].length was round
>> up to PAGE_SIZE at each memops driver, but the vb2 core doesn't enforce it.
>>
>> IMO, it would be cleaner to round vb->v4l2_planes[plane].length up
>> at VB2 core, before calling the memops alloc functions at the drivers.
>
> I don't think we should round vb->v4l2_planes[plane].length up. That variable
> stores the buffer length required by the driver, and will be used to perform
> size checks when importing a dmabuf buffer. We don't want to prevent a buffer
> large enough for the driver but not page size aligned to be imported.
>
> What we could do is round in the core the size passed to the alloc function,
> without storing the rounded value in vb->v4l2_planes[plane].length.
>
> And, reading down, I realize that this is exactly what you meant :-)

Yes. Touching at .length would have side effects, but touching at
buffer's .size seem ok and VB2 dma contig code already does that
with the current code.

> The proposed patch looks good to me.

Good.

>> Also, VB2 is already complex enough to put it there without proper
>> comments (and there's a minor codingstyle issue there: line is bigger
>> than 80 cols).
>
> A comment is definitely a good idea.
>
>>> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c
>>> b/drivers/media/v4l2-core/videobuf2-vmalloc.c index 313d977..bf3b95c
>>> 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
>>> @@ -44,7 +44,7 @@ static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned
>>> long size, gfp_t gfp_fl>
>>>   		return NULL;
>>>   	
>>>   	buf->size = size;
>>>
>>> -	buf->vaddr = vmalloc_user(buf->size);
>>> +	buf->vaddr = vmalloc_user(PAGE_ALIGN(buf->size));
>>
>> See? You needed to put an alignment here as well, not because vmalloc
>> needs it, but because this is needed by VB2 core.
>>
>> Also, on the other drivers, buf->size is stored page aligned, while
>> here, you're doing different, without any documented reason for doing
>> that, instead of doing the same as on the other memops drivers.
>>
>> That mistake reflects, for example, when the driver prints the failure:
>>
>>          if (!buf->vaddr) {
>>                  pr_debug("vmalloc of size %ld failed\n", buf->size);
>>
>> as it will show a different size than what you actually required.
>> As those memory starving errors can also produce a dump at the mm
>> core, the size there won't match the size on the above printed message.
>>
>> Also, it is a very bad idea to delegate the core's requirement of
>> do page alignment from the core to the memops drivers, as other
>> patches may change the logic there, or a new memops could be added,
>> and the same problem will hit again (and unnoticed, as the check
>> routine do page alignments).
>
> Agreed. The memory allocator shouldn't need to guess the core requirements.
>
>>>   	buf->handler.refcount = &buf->refcount;
>>>   	buf->handler.put = vb2_vmalloc_put;
>>>   	buf->handler.arg = buf;
>>
>> IMO, a cleaner version would be the following (untested) code.
>>
>> -
>>
>> [media] videobuf2: fix the length check for mmap
>>
>> Memory maps typically require that the buffer size to be page
>> aligned. Currently, two memops drivers do such alignment
>> internally, but videobuf-vmalloc doesn't.
>>
>> Also, the buffer overflow check doesn't take it into account.
>>
>> So, instead of doing it at each memops driver, enforce it at
>> VB2 core.
>>
>> Reported-by: Prabhakar lad <prabhakar.csengg@gmail.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>> b/drivers/media/v4l2-core/videobuf2-core.c index 58c1744..7d833ee 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -54,10 +54,15 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>   	void *mem_priv;
>>   	int plane;
>>
>> -	/* Allocate memory for all planes in this buffer */
>> +	/*
>> +	 * Allocate memory for all planes in this buffer
>> +	 * NOTE: mmapped areas should be page aligned
>> +	 */
>>   	for (plane = 0; plane < vb->num_planes; ++plane) {
>> +		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
>> +
>>   		mem_priv = call_memop(q, alloc, q->alloc_ctx[plane],
>> -				      q->plane_sizes[plane], q->gfp_flags);
>> +				      size, q->gfp_flags);
>>   		if (IS_ERR_OR_NULL(mem_priv))
>>   			goto free;
>>
>> @@ -1852,6 +1857,7 @@ int vb2_mmap(struct vb2_queue *q, struct
>> vm_area_struct *vma) struct vb2_buffer *vb;
>>   	unsigned int buffer, plane;
>>   	int ret;
>> +	unsigned long length;
>>
>>   	if (q->memory != V4L2_MEMORY_MMAP) {
>>   		dprintk(1, "Queue is not currently set up for mmap\n");
>> @@ -1886,8 +1892,15 @@ int vb2_mmap(struct vb2_queue *q, struct
>> vm_area_struct *vma)
>>
>>   	vb = q->bufs[buffer];
>>
>> -	if (vb->v4l2_planes[plane].length < (vma->vm_end - vma->vm_start)) {
>> -		dprintk(1, "Invalid length\n");
>> +	/*
>> +	 * MMAP requires page_aligned buffers.
>> +	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
>> +	 * so, we need to do the same here.
>> +	 */
>> +	length = PAGE_ALIGN(vb->v4l2_planes[plane].length);
>> +	if (length < (vma->vm_end - vma->vm_start)) {
>> +		dprintk(1,
>> +			"MMAP invalid, as it would overflow buffer length\n");
>>   		return -EINVAL;
>>   	}
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index ae35d25..fd56f25
>> 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -162,9 +162,6 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
>> size, gfp_t gfp_flags) if (!buf)
>>   		return ERR_PTR(-ENOMEM);
>>
>> -	/* align image size to PAGE_SIZE */
>> -	size = PAGE_ALIGN(size);
>> -
>>   	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
>>   						GFP_KERNEL | gfp_flags);
>>   	if (!buf->vaddr) {
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> b/drivers/media/v4l2-core/videobuf2-dma-sg.c index 59522b2..16ae3dc 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> @@ -55,7 +55,8 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
>> long size, gfp_t gfp_fla buf->write = 0;
>>   	buf->offset = 0;
>>   	buf->sg_desc.size = size;
>> -	buf->sg_desc.num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> +	/* size is already page aligned */
>> +	buf->sg_desc.num_pages = size >> PAGE_SHIFT;
>>
>>   	buf->sg_desc.sglist = vzalloc(buf->sg_desc.num_pages *
>>   				      sizeof(*buf->sg_desc.sglist));

