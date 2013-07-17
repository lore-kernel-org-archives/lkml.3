Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3GQJnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:43:23 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60973 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3GQJnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:43:22 -0400
MIME-Version: 1.0
In-Reply-To: <51E65577.7010403@samsung.com>
References: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com> <51E65577.7010403@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 17 Jul 2013 11:43:01 +0200
Message-ID: <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
Subject: Re: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek

 alloc_pages_exact returns pages of order 0, every single page is
filled into buf->pages, that then is used by vb2_dma_sg_mmap(), that
also expects order 0 pages (its loops increments in PAGE_SIZE). The
code has been tested on real HW.

Your concern is that that alloc_pages_exact splits the higher order pages?

Do you want that videobuf2-dma-sg to have support for higher order pages?


Best regards

PS: sorry for the duplicated post, previous one contained html parts
and was rejected by the list

On Wed, Jul 17, 2013 at 10:27 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
>
> On 7/15/2013 11:34 AM, Ricardo Ribalda Delgado wrote:
>>
>> Most DMA engines have limitations regarding the number of DMA segments
>> (sg-buffers) that they can handle. Videobuffers can easily spread through
>> houndreds of pages.
>>
>> In the previous aproach, the pages were allocated individually, this
>> could led to the creation houndreds of dma segments (sg-buffers) that
>> could not be handled by some DMA engines.
>>
>> This patch tries to minimize the number of DMA segments by using
>> alloc_pages_exact. In the worst case it will behave as before, but most
>> of the times it will reduce the number fo dma segments
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
>
> I like the idea, but the code doesn't seem to be correct. buf->pages array
> is
> needed for vb2_dma_sg_mmap() function to map pages to userspace. However in
> your
> code I don't see any place where you fill it with the pages of order higher
> than 0. AFAIR vm_insert_page() can handle compound pages, but
> alloc_pages_exact()
> splits such pages into a set of pages of order 0, so you need to change your
> code
> to correctly fill buf->pages array.
>
>
>> ---
>>   drivers/media/v4l2-core/videobuf2-dma-sg.c |   49
>> +++++++++++++++++++++-------
>>   1 file changed, 38 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> index 16ae3dc..67a94ab 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> @@ -42,10 +42,44 @@ struct vb2_dma_sg_buf {
>>     static void vb2_dma_sg_put(void *buf_priv);
>>   +static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
>> +               gfp_t gfp_flags)
>> +{
>> +       unsigned int last_page = 0;
>> +       void *vaddr = NULL;
>> +       unsigned int req_pages;
>> +
>> +       while (last_page < buf->sg_desc.num_pages) {
>> +               req_pages = buf->sg_desc.num_pages-last_page;
>> +               while (req_pages >= 1) {
>> +                       vaddr = alloc_pages_exact(req_pages*PAGE_SIZE,
>> +                               GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
>> +                       if (vaddr)
>> +                               break;
>> +                       req_pages >>= 1;
>> +               }
>> +               if (!vaddr) {
>> +                       while (--last_page >= 0)
>> +                               __free_page(buf->pages[last_page]);
>> +                       return -ENOMEM;
>> +               }
>> +               while (req_pages) {
>> +                       buf->pages[last_page] = virt_to_page(vaddr);
>> +                       sg_set_page(&buf->sg_desc.sglist[last_page],
>> +                                       buf->pages[last_page], PAGE_SIZE,
>> 0);
>> +                       vaddr += PAGE_SIZE;
>> +                       last_page++;
>> +                       req_pages--;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>   static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t
>> gfp_flags)
>>   {
>>         struct vb2_dma_sg_buf *buf;
>> -       int i;
>> +       int ret;
>>         buf = kzalloc(sizeof *buf, GFP_KERNEL);
>>         if (!buf)
>> @@ -69,14 +103,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx,
>> unsigned long size, gfp_t gfp_fla
>>         if (!buf->pages)
>>                 goto fail_pages_array_alloc;
>>   -     for (i = 0; i < buf->sg_desc.num_pages; ++i) {
>> -               buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
>> -                                          __GFP_NOWARN | gfp_flags);
>> -               if (NULL == buf->pages[i])
>> -                       goto fail_pages_alloc;
>> -               sg_set_page(&buf->sg_desc.sglist[i],
>> -                           buf->pages[i], PAGE_SIZE, 0);
>> -       }
>> +       ret = vb2_dma_sg_alloc_compacted(buf, gfp_flags);
>> +       if (ret)
>> +               goto fail_pages_alloc;
>>         buf->handler.refcount = &buf->refcount;
>>         buf->handler.put = vb2_dma_sg_put;
>> @@ -89,8 +118,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
>> long size, gfp_t gfp_fla
>>         return buf;
>>     fail_pages_alloc:
>> -       while (--i >= 0)
>> -               __free_page(buf->pages[i]);
>>         kfree(buf->pages);
>>     fail_pages_array_alloc:
>
>
> Best regards
> --
> Marek Szyprowski
> Samsung R&D Institute Poland
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ricardo Ribalda
