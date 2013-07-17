Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3GQOFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:05:52 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56673 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3GQOFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
References: <1373880874-9270-1-git-send-email-ricardo.ribalda@gmail.com>
 <51E65577.7010403@samsung.com> <CAPybu_3Je7+0Qh2OdptncnxC12G15Scad+A3yUeF898sVWKo8w@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 17 Jul 2013 16:05:29 +0200
Message-ID: <CAPybu_226ZWwEW-1AyaccMthLtmdWOjRts116RqMEk91o12TrQ@mail.gmail.com>
Subject: Re: [PATCH] videobuf2-dma-sg: Minimize the number of dma segments
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again

I have made some experiments and have replaced alloc_pages_exact with
alloc_pages of order N. Unfortunatelly vm_insert_page and vm_map_ram
does not work as expected.

vm_insert_page, only insert the PAGE_SIZE bytes of the higher order
page, if I try to add the other pages manually, the function returns
-22 due to count=0.
vm_map_ram is designed to work with exactly order 0 pages.

it works fine if I manually split the page, but the header file
suggest that function should not be called by the drivers... (although
this is not a device driver).

Here you can see my experiment in case you want to replicate it.


---
 drivers/media/v4l2-core/videobuf2-dma-sg.c |   89 ++++++++++++++++++++++------
 1 file changed, 72 insertions(+), 17 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 16ae3dc..bbb3680 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -24,6 +24,8 @@
 static int debug;
 module_param(debug, int, 0644);

+#define PAGE_SPLIT
+
 #define dprintk(level, fmt, arg...) \
  do { \
  if (debug >= level) \
@@ -42,10 +44,69 @@ struct vb2_dma_sg_buf {

 static void vb2_dma_sg_put(void *buf_priv);

+static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
+ gfp_t gfp_flags)
+{
+ unsigned int last_page = 0;
+ int size = buf->sg_desc.size;
+
+ while (size > 0) {
+ struct page *pages;
+ int order;
+#ifdef PAGE_SPLIT
+ int i;
+#endif
+
+ order = get_order(size);
+ /* Dont over allocate*/
+ if ((PAGE_SIZE << order) > size)
+ order--;
+
+ pages = NULL;
+ while (!pages) {
+ pages = alloc_pages(GFP_KERNEL | __GFP_ZERO |
+ __GFP_NOWARN | gfp_flags, order);
+ if (pages)
+ break;
+
+
+ if (order == 0)
+ while (--last_page >= 0) {
+ __free_pages(
+ buf->pages[last_page],
+ get_order(sg_dma_len
+ (&buf->sg_desc.sglist[last_page])));
+ return -ENOMEM;
+ }
+ order--;
+ }
+
+#ifdef PAGE_SPLIT
+ split_page(pages, order);
+ for (i = 0; i < (1<<order); i++) {
+ buf->pages[last_page] = pages + i;
+ sg_set_page(&buf->sg_desc.sglist[last_page],
+ buf->pages[last_page], PAGE_SIZE, 0);
+ last_page++;
+ }
+#else
+ buf->pages[last_page] = pages;
+ sg_set_page(&buf->sg_desc.sglist[last_page],
+ buf->pages[last_page], PAGE_SIZE << order, 0);
+ last_page++;
+#endif
+ size -= PAGE_SIZE << order;
+ }
+
+ buf->sg_desc.num_pages = last_page;
+
+ return 0;
+}
+
 static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
gfp_t gfp_flags)
 {
  struct vb2_dma_sg_buf *buf;
- int i;
+ int ret;

  buf = kzalloc(sizeof *buf, GFP_KERNEL);
  if (!buf)
@@ -69,14 +130,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx,
unsigned long size, gfp_t gfp_fla
  if (!buf->pages)
  goto fail_pages_array_alloc;

- for (i = 0; i < buf->sg_desc.num_pages; ++i) {
- buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
-   __GFP_NOWARN | gfp_flags);
- if (NULL == buf->pages[i])
- goto fail_pages_alloc;
- sg_set_page(&buf->sg_desc.sglist[i],
-    buf->pages[i], PAGE_SIZE, 0);
- }
+ ret = vb2_dma_sg_alloc_compacted(buf, gfp_flags);
+ if (ret)
+ goto fail_pages_alloc;

  buf->handler.refcount = &buf->refcount;
  buf->handler.put = vb2_dma_sg_put;
@@ -89,8 +145,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx,
unsigned long size, gfp_t gfp_fla
  return buf;

 fail_pages_alloc:
- while (--i >= 0)
- __free_page(buf->pages[i]);
  kfree(buf->pages);

 fail_pages_array_alloc:
@@ -111,9 +165,10 @@ static void vb2_dma_sg_put(void *buf_priv)
  buf->sg_desc.num_pages);
  if (buf->vaddr)
  vm_unmap_ram(buf->vaddr, buf->sg_desc.num_pages);
- vfree(buf->sg_desc.sglist);
  while (--i >= 0)
- __free_page(buf->pages[i]);
+ __free_pages(buf->pages[i], get_order(
+ sg_dma_len(&buf->sg_desc.sglist[i])));
+ vfree(buf->sg_desc.sglist);
  kfree(buf->pages);
  kfree(buf);
  }
@@ -248,14 +303,14 @@ static int vb2_dma_sg_mmap(void *buf_priv,
struct vm_area_struct *vma)
  do {
  int ret;

- ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
+ ret = vm_insert_page(vma, uaddr, buf->pages[i]);
  if (ret) {
  printk(KERN_ERR "Remapping memory, error: %d\n", ret);
  return ret;
  }
-
- uaddr += PAGE_SIZE;
- usize -= PAGE_SIZE;
+ uaddr += sg_dma_len(&buf->sg_desc.sglist[i]);
+ usize -= sg_dma_len(&buf->sg_desc.sglist[i]);
+ i++;
  } while (usize > 0);


--
1.7.10.4



On Wed, Jul 17, 2013 at 11:43 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hi Marek
>
>  alloc_pages_exact returns pages of order 0, every single page is
> filled into buf->pages, that then is used by vb2_dma_sg_mmap(), that
> also expects order 0 pages (its loops increments in PAGE_SIZE). The
> code has been tested on real HW.
>
> Your concern is that that alloc_pages_exact splits the higher order pages?
>
> Do you want that videobuf2-dma-sg to have support for higher order pages?
>
>
> Best regards
>
> PS: sorry for the duplicated post, previous one contained html parts
> and was rejected by the list
>
> On Wed, Jul 17, 2013 at 10:27 AM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> Hello,
>>
>>
>> On 7/15/2013 11:34 AM, Ricardo Ribalda Delgado wrote:
>>>
>>> Most DMA engines have limitations regarding the number of DMA segments
>>> (sg-buffers) that they can handle. Videobuffers can easily spread through
>>> houndreds of pages.
>>>
>>> In the previous aproach, the pages were allocated individually, this
>>> could led to the creation houndreds of dma segments (sg-buffers) that
>>> could not be handled by some DMA engines.
>>>
>>> This patch tries to minimize the number of DMA segments by using
>>> alloc_pages_exact. In the worst case it will behave as before, but most
>>> of the times it will reduce the number fo dma segments
>>>
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>
>>
>> I like the idea, but the code doesn't seem to be correct. buf->pages array
>> is
>> needed for vb2_dma_sg_mmap() function to map pages to userspace. However in
>> your
>> code I don't see any place where you fill it with the pages of order higher
>> than 0. AFAIR vm_insert_page() can handle compound pages, but
>> alloc_pages_exact()
>> splits such pages into a set of pages of order 0, so you need to change your
>> code
>> to correctly fill buf->pages array.
>>
>>
>>> ---
>>>   drivers/media/v4l2-core/videobuf2-dma-sg.c |   49
>>> +++++++++++++++++++++-------
>>>   1 file changed, 38 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>>> b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>>> index 16ae3dc..67a94ab 100644
>>> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>>> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>>> @@ -42,10 +42,44 @@ struct vb2_dma_sg_buf {
>>>     static void vb2_dma_sg_put(void *buf_priv);
>>>   +static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
>>> +               gfp_t gfp_flags)
>>> +{
>>> +       unsigned int last_page = 0;
>>> +       void *vaddr = NULL;
>>> +       unsigned int req_pages;
>>> +
>>> +       while (last_page < buf->sg_desc.num_pages) {
>>> +               req_pages = buf->sg_desc.num_pages-last_page;
>>> +               while (req_pages >= 1) {
>>> +                       vaddr = alloc_pages_exact(req_pages*PAGE_SIZE,
>>> +                               GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
>>> +                       if (vaddr)
>>> +                               break;
>>> +                       req_pages >>= 1;
>>> +               }
>>> +               if (!vaddr) {
>>> +                       while (--last_page >= 0)
>>> +                               __free_page(buf->pages[last_page]);
>>> +                       return -ENOMEM;
>>> +               }
>>> +               while (req_pages) {
>>> +                       buf->pages[last_page] = virt_to_page(vaddr);
>>> +                       sg_set_page(&buf->sg_desc.sglist[last_page],
>>> +                                       buf->pages[last_page], PAGE_SIZE,
>>> 0);
>>> +                       vaddr += PAGE_SIZE;
>>> +                       last_page++;
>>> +                       req_pages--;
>>> +               }
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
>>>   static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t
>>> gfp_flags)
>>>   {
>>>         struct vb2_dma_sg_buf *buf;
>>> -       int i;
>>> +       int ret;
>>>         buf = kzalloc(sizeof *buf, GFP_KERNEL);
>>>         if (!buf)
>>> @@ -69,14 +103,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx,
>>> unsigned long size, gfp_t gfp_fla
>>>         if (!buf->pages)
>>>                 goto fail_pages_array_alloc;
>>>   -     for (i = 0; i < buf->sg_desc.num_pages; ++i) {
>>> -               buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO |
>>> -                                          __GFP_NOWARN | gfp_flags);
>>> -               if (NULL == buf->pages[i])
>>> -                       goto fail_pages_alloc;
>>> -               sg_set_page(&buf->sg_desc.sglist[i],
>>> -                           buf->pages[i], PAGE_SIZE, 0);
>>> -       }
>>> +       ret = vb2_dma_sg_alloc_compacted(buf, gfp_flags);
>>> +       if (ret)
>>> +               goto fail_pages_alloc;
>>>         buf->handler.refcount = &buf->refcount;
>>>         buf->handler.put = vb2_dma_sg_put;
>>> @@ -89,8 +118,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
>>> long size, gfp_t gfp_fla
>>>         return buf;
>>>     fail_pages_alloc:
>>> -       while (--i >= 0)
>>> -               __free_page(buf->pages[i]);
>>>         kfree(buf->pages);
>>>     fail_pages_array_alloc:
>>
>>
>> Best regards
>> --
>> Marek Szyprowski
>> Samsung R&D Institute Poland
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Ricardo Ribalda



-- 
Ricardo Ribalda
