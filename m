Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312Ab3DQM5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:57:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626Ab3DQM5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:57:52 -0400
Date: Wed, 17 Apr 2013 09:56:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] videobuf-dma-contig: use vm_iomap_memory()
Message-ID: <20130417095657.1ab81623@redhat.com>
In-Reply-To: <1366201336-9481-2-git-send-email-mchehab@redhat.com>
References: <20130417074300.33d05475@redhat.com>
	<1366201336-9481-1-git-send-email-mchehab@redhat.com>
	<1366201336-9481-2-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 17 Apr 2013 09:22:16 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> vm_iomap_memory() provides a better end user interface than
> remap_pfn_range(), as it does the needed tests before doing
> mmap.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
> index 67f572c..7e6b209 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -303,14 +303,9 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  		goto error;
>  
>  	/* Try to remap memory */
> -
>  	size = vma->vm_end - vma->vm_start;
> -	size = (size < mem->size) ? size : mem->size;
> -
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -	retval = remap_pfn_range(vma, vma->vm_start,
> -				 mem->dma_handle >> PAGE_SHIFT,
> -				 size, vma->vm_page_prot);
> +	retval = vm_iomap_memory(vma, vma->vm_start, size);

Just to be sure, that changing from remap_pfn_range() to io_remap_pfn_range()
won't cause any side-effects, I double-checked that, for all drivers using
this code, that remap_pfn_range is equal to io_remap_pfn_range.

The Timberdale driver was a little trickier to check, as VIDEO_TIMBERDALE
doesn't depend on any architecture. However, this driver was submitted and
was known to work only on the Intel in-Vehicle Infotainment reference board
russelville. According with http://wiki.meego.com/In-vehicle, the
architecture for it is x86 (Intel Atom Z5xx).

In summary, those are the archs where this core driver is used, with the
corresponding drivers that make such usage:

powerpc:
	drivers/media/platform/fsl-viu.c

arm:
	drivers/media/platform/omap/omap_vout.c
	drivers/media/platform/omap/omap_vout_vrfb.c
	drivers/media/platform/soc_camera/mx1_camera.c
	drivers/media/platform/soc_camera/omap1_camera.c

sh:
	drivers/media/platform/sh_vou.c

x86:
	drivers/media/platform/timblogiw.c

-- 

Cheers,
Mauro
