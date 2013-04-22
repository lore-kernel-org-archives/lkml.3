Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3DVM5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:57:48 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:57165 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3DVM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:57:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Prabhakar lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH RFC] media: videobuf2: fix the length check for mmap
Date: Mon, 22 Apr 2013 14:57:54 +0200
Message-ID: <2366802.YUrXa9z2HG@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130419081801.0af7ad73@redhat.com>
References: <1366364816-3567-1-git-send-email-prabhakar.csengg@gmail.com> <20130419081801.0af7ad73@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Friday 19 April 2013 08:18:01 Mauro Carvalho Chehab wrote:

[snip]

> [media] videobuf2: fix the length check for mmap
> 
> Memory maps typically require that the buffer size to be page

s/that the/the/

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

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 58c1744..7d833ee 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -54,10 +54,15 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  	void *mem_priv;
>  	int plane;
> 
> -	/* Allocate memory for all planes in this buffer */
> +	/*
> +	 * Allocate memory for all planes in this buffer
> +	 * NOTE: mmapped areas should be page aligned
> +	 */
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
> +
>  		mem_priv = call_memop(q, alloc, q->alloc_ctx[plane],
> -				      q->plane_sizes[plane], q->gfp_flags);
> +				      size, q->gfp_flags);
>  		if (IS_ERR_OR_NULL(mem_priv))
>  			goto free;
> 
> @@ -1852,6 +1857,7 @@ int vb2_mmap(struct vb2_queue *q, struct
> vm_area_struct *vma) struct vb2_buffer *vb;
>  	unsigned int buffer, plane;
>  	int ret;
> +	unsigned long length;
> 
>  	if (q->memory != V4L2_MEMORY_MMAP) {
>  		dprintk(1, "Queue is not currently set up for mmap\n");
> @@ -1886,8 +1892,15 @@ int vb2_mmap(struct vb2_queue *q, struct
> vm_area_struct *vma)
> 
>  	vb = q->bufs[buffer];
> 
> -	if (vb->v4l2_planes[plane].length < (vma->vm_end - vma->vm_start)) {
> -		dprintk(1, "Invalid length\n");
> +	/*
> +	 * MMAP requires page_aligned buffers.
> +	 * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
> +	 * so, we need to do the same here.
> +	 */
> +	length = PAGE_ALIGN(vb->v4l2_planes[plane].length);
> +	if (length < (vma->vm_end - vma->vm_start)) {
> +		dprintk(1,
> +			"MMAP invalid, as it would overflow buffer length\n");
>  		return -EINVAL;
>  	}
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index ae35d25..fd56f25
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -162,9 +162,6 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
> size, gfp_t gfp_flags) if (!buf)
>  		return ERR_PTR(-ENOMEM);
> 
> -	/* align image size to PAGE_SIZE */
> -	size = PAGE_ALIGN(size);
> -
>  	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
>  						GFP_KERNEL | gfp_flags);
>  	if (!buf->vaddr) {
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> b/drivers/media/v4l2-core/videobuf2-dma-sg.c index 59522b2..16ae3dc 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -55,7 +55,8 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
> long size, gfp_t gfp_fla buf->write = 0;
>  	buf->offset = 0;
>  	buf->sg_desc.size = size;
> -	buf->sg_desc.num_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	/* size is already page aligned */
> +	buf->sg_desc.num_pages = size >> PAGE_SHIFT;
> 
>  	buf->sg_desc.sglist = vzalloc(buf->sg_desc.num_pages *
>  				      sizeof(*buf->sg_desc.sglist));

-- 
Regards,

Laurent Pinchart

