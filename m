Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3DPLSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:18:40 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:42393 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3DPLSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:18:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] media: davinci: vpif: align the buffers size to page page size boundary
Date: Tue, 16 Apr 2013 13:18:43 +0200
Message-ID: <2933946.BRNjyJUSVm@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366109670-28030-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366109670-28030-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

(CC'ing Marek)

On Tuesday 16 April 2013 16:24:30 Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> with recent commit with id 068a0df76023926af958a336a78bef60468d2033
> which adds add length check for mmap, the application were failing to
> mmap the buffers.
> 
> This patch aligns the the buffer size to page size boundary for both
> capture and display driver so the it pass the check.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  Changes for v2:
>  1: Fixed a typo in commit message.
> 
>  drivers/media/platform/davinci/vpif_capture.c |    1 +
>  drivers/media/platform/davinci/vpif_display.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c
> b/drivers/media/platform/davinci/vpif_capture.c index 5f98df1..25981d6
> 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -183,6 +183,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
> *nbuffers = config_params.min_numbuffers;
> 
>  	*nplanes = 1;
> +	size = PAGE_ALIGN(size);

I wonder if that's the best fix.

The queue_setup operation is supposed to return the size required by the 
driver for each plane. Depending on the hardware requirements, that size might 
not be a multiple of the page size.

As we can't mmap() a fraction of a page, the allocated plane size needs to be 
rounded up to the next page boundary to allow mmap() support. The dma-contig 
and dma-sg allocators already do so in their alloc operation, but the vmalloc 
allocator doesn't.

The recent "media: vb2: add length check for mmap" patch verifies that the 
mmap() size requested by userspace doesn't exceed the buffer size. As the 
mmap() size is rounded up to the next page boundary the check will fail for 
buffer sizes that are not multiple of the page size.

Your fix will not result in overallocation (as the allocator already rounds 
the size up), but will prevent the driver from importing a buffer large enough 
for the hardware but not rounded up to the page size.

A better fix might be to round up the buffer size in the buffer size check at 
mmap() time, and fix the vmalloc allocator to round up the size. That the 
allocator, not drivers, is responsible for buffer size alignment should be 
documented in videobuf2-core.h.

>  	sizes[0] = size;
>  	alloc_ctxs[0] = common->alloc_ctx;
> 
> diff --git a/drivers/media/platform/davinci/vpif_display.c
> b/drivers/media/platform/davinci/vpif_display.c index 1b3fb5c..3414715
> 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -162,6 +162,7 @@ static int vpif_buffer_queue_setup(struct vb2_queue *vq,
> *nbuffers = config_params.min_numbuffers;
> 
>  	*nplanes = 1;
> +	size = PAGE_ALIGN(size);
>  	sizes[0] = size;
>  	alloc_ctxs[0] = common->alloc_ctx;
>  	return 0;

-- 
Regards,

Laurent Pinchart

