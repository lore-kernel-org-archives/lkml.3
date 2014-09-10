Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaIJHBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:01:42 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2335 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIJHBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:01:41 -0400
Message-ID: <540FF70E.9050203@xs4all.nl>
Date: Wed, 10 Sep 2014 09:00:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Fancy Fang <chen.fang@freescale.com>, m.chehab@samsung.com,
        viro@ZenIV.linux.org.uk
CC: shawn.guo@freescale.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [media] videobuf-dma-contig: replace vm_iomap_memory()
 with remap_pfn_range().
References: <1410326937-31140-1-git-send-email-chen.fang@freescale.com>
In-Reply-To: <1410326937-31140-1-git-send-email-chen.fang@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/14 07:28, Fancy Fang wrote:
> When user requests V4L2_MEMORY_MMAP type buffers, the videobuf-core
> will assign the corresponding offset to the 'boff' field of the
> videobuf_buffer for each requested buffer sequentially. Later, user
> may call mmap() to map one or all of the buffers with the 'offset'
> parameter which is equal to its 'boff' value. Obviously, the 'offset'
> value is only used to find the matched buffer instead of to be the
> real offset from the buffer's physical start address as used by
> vm_iomap_memory(). So, in some case that if the offset is not zero,
> vm_iomap_memory() will fail.

Is this just a fix for something that can fail theoretically, or do you
actually have a case where this happens? I am very reluctant to make
any changes to videobuf. Drivers should all migrate to vb2.

I have CC-ed Marek as well since he knows a lot more about this stuff
than I do.

Regards,

	Hans

> 
> Signed-off-by: Fancy Fang <chen.fang@freescale.com>
> ---
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
> index bf80f0f..8bd9889 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -305,7 +305,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  	/* Try to remap memory */
>  	size = vma->vm_end - vma->vm_start;
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -	retval = vm_iomap_memory(vma, mem->dma_handle, size);
> +	retval = remap_pfn_range(vma, vma->vm_start,
> +				 mem->dma_handle >> PAGE_SHIFT,
> +				 size, vma->vm_page_prot);
>  	if (retval) {
>  		dev_err(q->dev, "mmap: remap failed with error %d. ",
>  			retval);
> 

