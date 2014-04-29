Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083AbaD2Ifc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:35:32 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25534 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007AbaD2IfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:35:24 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-9a-535f6449ad25
Message-id: <535F6451.1030403@samsung.com>
Date: Tue, 29 Apr 2014 10:35:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, akpm@linux-foundation.org
Cc: aswin@hp.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 7/6] media: videobuf2-dma-sg: call find_vma with the
 mmap_sem held
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
 <1398708571.25549.10.camel@buesod1.americas.hpqcorp.net>
In-reply-to: <1398708571.25549.10.camel@buesod1.americas.hpqcorp.net>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xK7peKfHBBmddLOasX8Nm8ePpDnaL
	JfeFLc42vWG3uLxrDptFz4atrBb31vxntbi4Tt5iytuf7A6cHru27WTy2PRpErvHiRm/WTwe
	/3rJ5tG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZkxbMZCpYKFcxv7uFvYFxtUQXIyeHhICJ
	xPfl9xghbDGJC/fWs3UxcnEICSxllDj96SETSEJI4BOjxLWfGiA2r4CWRPOZVywgNouAqsTF
	OwvZQWw2AUOJrrddbCC2qECMxModR5gg6gUlfky+B1YvIuAoMePgfLB6ZoG7QDOXxYPYwgIR
	Ertn7mSE2FUt8ejsR1YQm1PAVeLTq0eMEPVmEo9a1jFD2PISm9e8ZZ7AKDALyYpZSMpmISlb
	wMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk+L/uYFx6zOoQowAHoxIP74MvccFCrIll
	xZW5hxglOJiVRHjzreKDhXhTEiurUovy44tKc1KLDzEycXBKNTAaLM7QX7DehCetuND/4Cnv
	3LhTr47eKdn2q2VGP3cOr1hsy5psx/vz/CLa5munK/2V/L/glVjdSbkDl7aySknrfvW+8cZP
	53V5cIr7B6vd+yzCrE03PPTZcDrl3w6uOt+FZXudNcUVGawaO4q2ML4vXqjgPXMOg3PwzM+p
	UyY2J2Wdd5x2basSS3FGoqEWc1FxIgDRkf3QXAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-04-28 20:09, Davidlohr Bueso wrote:
> Performing vma lookups without taking the mm->mmap_sem is asking
> for trouble. While doing the search, the vma in question can
> be modified or even removed before returning to the caller.
> Take the lock in order to avoid races while iterating through
> the vmacache and/or rbtree.
>
> Also do some very minor cleanup changes.
>
> This patch is only compile tested.

NACK.

mm->mmap_sem is taken by videobuf2-core to avoid AB-BA deadlock with v4l2 core lock. For more information, please check videobuf2-core.c. However you are right that this is a bit confusing and we need more comments about the place where mmap_sem is taken. Here is some background for this decision:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg38599.html
http://www.spinics.net/lists/linux-media/msg40225.html

> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> ---
> It would seem this is the last offending user.
> v4l2 is a maze but I believe that this is needed as I don't
> see the mmap_sem being taken by any callers of vb2_dma_sg_get_userptr().
>
>   drivers/media/v4l2-core/videobuf2-dma-sg.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index c779f21..2a21100 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -168,8 +168,9 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	unsigned long first, last;
>   	int num_pages_from_user;
>   	struct vm_area_struct *vma;
> +	struct mm_struct *mm = current->mm;
>   
> -	buf = kzalloc(sizeof *buf, GFP_KERNEL);
> +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
>   	if (!buf)
>   		return NULL;
>   
> @@ -178,7 +179,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	buf->offset = vaddr & ~PAGE_MASK;
>   	buf->size = size;
>   
> -	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
> +	first = (vaddr & PAGE_MASK) >> PAGE_SHIFT;
>   	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
>   	buf->num_pages = last - first + 1;
>   
> @@ -187,7 +188,8 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	if (!buf->pages)
>   		goto userptr_fail_alloc_pages;
>   
> -	vma = find_vma(current->mm, vaddr);
> +	down_write(&mm->mmap_sem);
> +	vma = find_vma(mm, vaddr);
>   	if (!vma) {
>   		dprintk(1, "no vma for address %lu\n", vaddr);
>   		goto userptr_fail_find_vma;
> @@ -218,7 +220,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   			buf->pages[num_pages_from_user] = pfn_to_page(pfn);
>   		}
>   	} else
> -		num_pages_from_user = get_user_pages(current, current->mm,
> +		num_pages_from_user = get_user_pages(current, mm,
>   					     vaddr & PAGE_MASK,
>   					     buf->num_pages,
>   					     write,
> @@ -233,6 +235,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   			buf->num_pages, buf->offset, size, 0))
>   		goto userptr_fail_alloc_table_from_pages;
>   
> +	up_write(&mm->mmap_sem);
>   	return buf;
>   
>   userptr_fail_alloc_table_from_pages:
> @@ -244,6 +247,7 @@ userptr_fail_get_user_pages:
>   			put_page(buf->pages[num_pages_from_user]);
>   	vb2_put_vma(buf->vma);
>   userptr_fail_find_vma:
> +	up_write(&mm->mmap_sem);
>   	kfree(buf->pages);
>   userptr_fail_alloc_pages:
>   	kfree(buf);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

