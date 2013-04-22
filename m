Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3DVFdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:33:25 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:34968 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3DVFdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:33:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130419081801.0af7ad73@redhat.com>
References: <1366364816-3567-1-git-send-email-prabhakar.csengg@gmail.com> <20130419081801.0af7ad73@redhat.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 22 Apr 2013 11:03:02 +0530
Message-ID: <CA+V-a8tOK=6iqWzK0KhQaL45LvfFCcs67bfECZE9tE251+8iUA@mail.gmail.com>
Subject: Re: [PATCH RFC] media: videobuf2: fix the length check for mmap
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 4:48 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Fri, 19 Apr 2013 15:16:56 +0530
> Prabhakar lad <prabhakar.csengg@gmail.com> escreveu:
>
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> From commit 068a0df76023926af958a336a78bef60468d2033
>> "[media] media: vb2: add length check for mmap"
>> patch verifies that the mmap() size requested by userspace
>> doesn't exceed the buffer size.
>>
>> As the mmap() size is rounded up to the next page boundary
>> the check will fail for buffer sizes that are not multiple
>> of the page size.
>>
>> This patch fixes the check by aligning the buffer size to page
>> size during the check. Alongside fixes the vmalloc allocator
>> to round up the size.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
>> Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c    |    2 +-
>>  drivers/media/v4l2-core/videobuf2-vmalloc.c |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 58c1744..223fcd4 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1886,7 +1886,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>>
>>       vb = q->bufs[buffer];
>>
>> -     if (vb->v4l2_planes[plane].length < (vma->vm_end - vma->vm_start)) {
>> +     if (PAGE_ALIGN(vb->v4l2_planes[plane].length) < (vma->vm_end - vma->vm_start)) {
>>               dprintk(1, "Invalid length\n");
>>               return -EINVAL;
>>       }
>
> That is tricky, as it assumes that vb->v4l2_planes[plane].length was round
> up to PAGE_SIZE at each memops driver, but the vb2 core doesn't enforce it.
>
> IMO, it would be cleaner to round vb->v4l2_planes[plane].length up
> at VB2 core, before calling the memops alloc functions at the drivers.
>
> Also, VB2 is already complex enough to put it there without proper
> comments (and there's a minor codingstyle issue there: line is bigger
> than 80 cols).
>
>> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> index 313d977..bf3b95c 100644
>> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> @@ -44,7 +44,7 @@ static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_fl
>>               return NULL;
>>
>>       buf->size = size;
>> -     buf->vaddr = vmalloc_user(buf->size);
>> +     buf->vaddr = vmalloc_user(PAGE_ALIGN(buf->size));
>
> See? You needed to put an alignment here as well, not because vmalloc
> needs it, but because this is needed by VB2 core.
>
> Also, on the other drivers, buf->size is stored page aligned, while
> here, you're doing different, without any documented reason for doing
> that, instead of doing the same as on the other memops drivers.
>
> That mistake reflects, for example, when the driver prints the failure:
>
>         if (!buf->vaddr) {
>                 pr_debug("vmalloc of size %ld failed\n", buf->size);
>
> as it will show a different size than what you actually required.
> As those memory starving errors can also produce a dump at the mm
> core, the size there won't match the size on the above printed message.
>
> Also, it is a very bad idea to delegate the core's requirement of
> do page alignment from the core to the memops drivers, as other
> patches may change the logic there, or a new memops could be added,
> and the same problem will hit again (and unnoticed, as the check
> routine do page alignments).
>
>>       buf->handler.refcount = &buf->refcount;
>>       buf->handler.put = vb2_vmalloc_put;
>>       buf->handler.arg = buf;
>
> IMO, a cleaner version would be the following (untested) code.
>
> -
>
> [media] videobuf2: fix the length check for mmap
>
> Memory maps typically require that the buffer size to be page
> aligned. Currently, two memops drivers do such alignment
> internally, but videobuf-vmalloc doesn't.
>
> Also, the buffer overflow check doesn't take it into account.
>
> So, instead of doing it at each memops driver, enforce it at
> VB2 core.
>
> Reported-by: Prabhakar lad <prabhakar.csengg@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
Reported-and-tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar
