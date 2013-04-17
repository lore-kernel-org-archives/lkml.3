Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966459Ab3DQMtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 08:49:55 -0400
Received: from ams-iport-4.cisco.com ([144.254.224.147]:47733 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966162Ab3DQMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 08:49:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAICYblGQ/khL/2dsb2JhbABQgwaDZ71bgQUWdIIfAQEFIwRSEAsYAgImAgJXBgESiBSrBpJMgSONdweCM4ETA5cGkRSDDTo
X-IronPort-AV: E=Sophos;i="4.87,492,1363132800"; 
   d="scan'208";a="13384346"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] videobuf-dma-contig: remove support for cached mem
Date: Wed, 17 Apr 2013 14:49:47 +0200
User-Agent: KMail/1.13.7 (Linux/3.7-7.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20130417074300.33d05475@redhat.com> <1366201336-9481-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366201336-9481-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304171449.47850.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17 April 2013 14:22:15 Mauro Carvalho Chehab wrote:
> videobuf_queue_dma_contig_init_cached() is not used anywhere.
> Drop support for it, cleaning up the code a little bit.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Nice!

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 130 +++-----------------------
>  include/media/videobuf-dma-contig.h           |  10 --
>  2 files changed, 14 insertions(+), 126 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/media/v4l2-core/videobuf-dma-contig.c
> index 3a43ba0..67f572c 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> @@ -27,7 +27,6 @@ struct videobuf_dma_contig_memory {
>  	u32 magic;
>  	void *vaddr;
>  	dma_addr_t dma_handle;
> -	bool cached;
>  	unsigned long size;
>  };
>  
> @@ -43,26 +42,8 @@ static int __videobuf_dc_alloc(struct device *dev,
>  			       unsigned long size, gfp_t flags)
>  {
>  	mem->size = size;
> -	if (mem->cached) {
> -		mem->vaddr = alloc_pages_exact(mem->size, flags | GFP_DMA);
> -		if (mem->vaddr) {
> -			int err;
> -
> -			mem->dma_handle = dma_map_single(dev, mem->vaddr,
> -							 mem->size,
> -							 DMA_FROM_DEVICE);
> -			err = dma_mapping_error(dev, mem->dma_handle);
> -			if (err) {
> -				dev_err(dev, "dma_map_single failed\n");
> -
> -				free_pages_exact(mem->vaddr, mem->size);
> -				mem->vaddr = NULL;
> -				return err;
> -			}
> -		}
> -	} else
> -		mem->vaddr = dma_alloc_coherent(dev, mem->size,
> -						&mem->dma_handle, flags);
> +	mem->vaddr = dma_alloc_coherent(dev, mem->size,
> +					&mem->dma_handle, flags);
>  
>  	if (!mem->vaddr) {
>  		dev_err(dev, "memory alloc size %ld failed\n", mem->size);
> @@ -77,14 +58,7 @@ static int __videobuf_dc_alloc(struct device *dev,
>  static void __videobuf_dc_free(struct device *dev,
>  			       struct videobuf_dma_contig_memory *mem)
>  {
> -	if (mem->cached) {
> -		if (!mem->vaddr)
> -			return;
> -		dma_unmap_single(dev, mem->dma_handle, mem->size,
> -				 DMA_FROM_DEVICE);
> -		free_pages_exact(mem->vaddr, mem->size);
> -	} else
> -		dma_free_coherent(dev, mem->size, mem->vaddr, mem->dma_handle);
> +	dma_free_coherent(dev, mem->size, mem->vaddr, mem->dma_handle);
>  
>  	mem->vaddr = NULL;
>  }
> @@ -234,7 +208,7 @@ out_up:
>  	return ret;
>  }
>  
> -static struct videobuf_buffer *__videobuf_alloc_vb(size_t size, bool cached)
> +static struct videobuf_buffer *__videobuf_alloc(size_t size)
>  {
>  	struct videobuf_dma_contig_memory *mem;
>  	struct videobuf_buffer *vb;
> @@ -244,22 +218,11 @@ static struct videobuf_buffer *__videobuf_alloc_vb(size_t size, bool cached)
>  		vb->priv = ((char *)vb) + size;
>  		mem = vb->priv;
>  		mem->magic = MAGIC_DC_MEM;
> -		mem->cached = cached;
>  	}
>  
>  	return vb;
>  }
>  
> -static struct videobuf_buffer *__videobuf_alloc_uncached(size_t size)
> -{
> -	return __videobuf_alloc_vb(size, false);
> -}
> -
> -static struct videobuf_buffer *__videobuf_alloc_cached(size_t size)
> -{
> -	return __videobuf_alloc_vb(size, true);
> -}
> -
>  static void *__videobuf_to_vaddr(struct videobuf_buffer *buf)
>  {
>  	struct videobuf_dma_contig_memory *mem = buf->priv;
> @@ -310,19 +273,6 @@ static int __videobuf_iolock(struct videobuf_queue *q,
>  	return 0;
>  }
>  
> -static int __videobuf_sync(struct videobuf_queue *q,
> -			   struct videobuf_buffer *buf)
> -{
> -	struct videobuf_dma_contig_memory *mem = buf->priv;
> -	BUG_ON(!mem);
> -	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> -
> -	dma_sync_single_for_cpu(q->dev, mem->dma_handle, mem->size,
> -				DMA_FROM_DEVICE);
> -
> -	return 0;
> -}
> -
>  static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  				  struct videobuf_buffer *buf,
>  				  struct vm_area_struct *vma)
> @@ -331,8 +281,6 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  	struct videobuf_mapping *map;
>  	int retval;
>  	unsigned long size;
> -	unsigned long pos, start = vma->vm_start;
> -	struct page *page;
>  
>  	dev_dbg(q->dev, "%s\n", __func__);
>  
> @@ -359,43 +307,16 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>  	size = vma->vm_end - vma->vm_start;
>  	size = (size < mem->size) ? size : mem->size;
>  
> -	if (!mem->cached) {
> -		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -		retval = remap_pfn_range(vma, vma->vm_start,
> -			 mem->dma_handle >> PAGE_SHIFT,
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	retval = remap_pfn_range(vma, vma->vm_start,
> +				 mem->dma_handle >> PAGE_SHIFT,
>  				 size, vma->vm_page_prot);
> -		if (retval) {
> -			dev_err(q->dev, "mmap: remap failed with error %d. ",
> -								retval);
> -			dma_free_coherent(q->dev, mem->size,
> -					mem->vaddr, mem->dma_handle);
> -			goto error;
> -		}
> -	} else {
> -		pos = (unsigned long)mem->vaddr;
> -
> -		while (size > 0) {
> -			page = virt_to_page((void *)pos);
> -			if (NULL == page) {
> -				dev_err(q->dev, "mmap: virt_to_page failed\n");
> -				__videobuf_dc_free(q->dev, mem);
> -				goto error;
> -			}
> -			retval = vm_insert_page(vma, start, page);
> -			if (retval) {
> -				dev_err(q->dev, "mmap: insert failed with error %d\n",
> -					retval);
> -				__videobuf_dc_free(q->dev, mem);
> -				goto error;
> -			}
> -			start += PAGE_SIZE;
> -			pos += PAGE_SIZE;
> -
> -			if (size > PAGE_SIZE)
> -				size -= PAGE_SIZE;
> -			else
> -				size = 0;
> -		}
> +	if (retval) {
> +		dev_err(q->dev, "mmap: remap failed with error %d. ",
> +			retval);
> +		dma_free_coherent(q->dev, mem->size,
> +				  mem->vaddr, mem->dma_handle);
> +		goto error;
>  	}
>  
>  	vma->vm_ops = &videobuf_vm_ops;
> @@ -417,17 +338,8 @@ error:
>  
>  static struct videobuf_qtype_ops qops = {
>  	.magic		= MAGIC_QTYPE_OPS,
> -	.alloc_vb	= __videobuf_alloc_uncached,
> -	.iolock		= __videobuf_iolock,
> -	.mmap_mapper	= __videobuf_mmap_mapper,
> -	.vaddr		= __videobuf_to_vaddr,
> -};
> -
> -static struct videobuf_qtype_ops qops_cached = {
> -	.magic		= MAGIC_QTYPE_OPS,
> -	.alloc_vb	= __videobuf_alloc_cached,
> +	.alloc_vb	= __videobuf_alloc,
>  	.iolock		= __videobuf_iolock,
> -	.sync		= __videobuf_sync,
>  	.mmap_mapper	= __videobuf_mmap_mapper,
>  	.vaddr		= __videobuf_to_vaddr,
>  };
> @@ -447,20 +359,6 @@ void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
>  }
>  EXPORT_SYMBOL_GPL(videobuf_queue_dma_contig_init);
>  
> -void videobuf_queue_dma_contig_init_cached(struct videobuf_queue *q,
> -					   const struct videobuf_queue_ops *ops,
> -					   struct device *dev,
> -					   spinlock_t *irqlock,
> -					   enum v4l2_buf_type type,
> -					   enum v4l2_field field,
> -					   unsigned int msize,
> -					   void *priv, struct mutex *ext_lock)
> -{
> -	videobuf_queue_core_init(q, ops, dev, irqlock, type, field, msize,
> -				 priv, &qops_cached, ext_lock);
> -}
> -EXPORT_SYMBOL_GPL(videobuf_queue_dma_contig_init_cached);
> -
>  dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf)
>  {
>  	struct videobuf_dma_contig_memory *mem = buf->priv;
> diff --git a/include/media/videobuf-dma-contig.h b/include/media/videobuf-dma-contig.h
> index f473aeb..f0ed825 100644
> --- a/include/media/videobuf-dma-contig.h
> +++ b/include/media/videobuf-dma-contig.h
> @@ -26,16 +26,6 @@ void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
>  				    void *priv,
>  				    struct mutex *ext_lock);
>  
> -void videobuf_queue_dma_contig_init_cached(struct videobuf_queue *q,
> -					   const struct videobuf_queue_ops *ops,
> -					   struct device *dev,
> -					   spinlock_t *irqlock,
> -					   enum v4l2_buf_type type,
> -					   enum v4l2_field field,
> -					   unsigned int msize,
> -					   void *priv,
> -					   struct mutex *ext_lock);
> -
>  dma_addr_t videobuf_to_dma_contig(struct videobuf_buffer *buf);
>  void videobuf_dma_contig_free(struct videobuf_queue *q,
>  			      struct videobuf_buffer *buf);
> 
