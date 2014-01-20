Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaATImD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:42:03 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:37321 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaATImA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:42:00 -0500
Date: Mon, 20 Jan 2014 11:39:02 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] zram: introduce zram compressor operations struct
Message-ID: <20140120083902.GA2178@swordfish>
References: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389956657-5486-3-git-send-email-sergey.senozhatsky@gmail.com>
 <20140120051233.GC8155@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120051233.GC8155@bbox>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/20/14 14:12), Minchan Kim wrote:
> Date: Mon, 20 Jan 2014 14:12:33 +0900
> From: Minchan Kim <minchan@kernel.org>
> To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
>  linux-kernel@vger.kernel.org
> Subject: Re: [RFC PATCH 2/3] zram: introduce zram compressor operations
>  struct
> User-Agent: Mutt/1.5.21 (2010-09-15)
> 
> Hello Sergey,
> 

Hello Minchan,

> I reviewed this patchset and I suggest somethings.
> Please have a look and feedback to me. :)
> 
> 1. Let's define new file zram_comp.c
> 2. zram_comp includes following field
>    .create
>    .compress
>    .decompress.
>    .destroy
>    .name
> 
> 1) create/destroy
> Will set up necessary things like allocating buffer, lock init or other things
> might happen in future when initialization time.
> I have a plan to support multiple buffer to do compression/decompression in
> parallel so we could optimize write VS write path, too.
> 

I have a patch for this

> 2) compress/decompress
> 
> It's very clear.
> 
> 3) name field will be used for tell to user what's kinds of compression
> algorithm zram support.
> 

looks good. will start addressing


	-ss

> On Fri, Jan 17, 2014 at 02:04:16PM +0300, Sergey Senozhatsky wrote:
> > This is preparation patch to add LZ4 compression support.
> > 
> > struct zram_compress_ops defines common compress and decompress
> > prototypes. Use these ops->compress and ops->decompress callbacks
> > instead of direct LZO lzo1x_1_compress() and lzo1x_decompress_safe()
> > calls.
> > 
> > Compressor ops should be defined before zram meta allocation,
> > because the size of meta->compress_workmem depends on selected
> > compression algorithm.
> > 
> > Define LZO compressor ops and set it as the only one available
> > zram compressor at the moment.
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> >  drivers/block/zram/zram_drv.c | 20 +++++++++++++-------
> >  drivers/block/zram/zram_drv.h | 10 ++++++++++
> >  2 files changed, 23 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index 7124042..4f2c748 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -28,10 +28,9 @@
> >  #include <linux/device.h>
> >  #include <linux/genhd.h>
> >  #include <linux/highmem.h>
> > -#include <linux/slab.h>
> > -#include <linux/lzo.h>
> >  #include <linux/string.h>
> >  #include <linux/vmalloc.h>
> > +#include <linux/lzo.h>
> 
> Let's include zram_comps.h only and zram_comps.h includes other compression
> alrogithms header. If user don't want to support some compression
> alrogithm, it shouldn't be included.
> Of course, user can select kinds of compressor in configuration step.
> 
> >  
> >  #include "zram_drv.h"
> >  
> > @@ -42,6 +41,12 @@ static struct zram *zram_devices;
> >  /* Module params (documentation at end) */
> >  static unsigned int num_devices = 1;
> >  
> > +static struct zram_compress_ops lzo_compressor = {
> > +	.workmem_sz = LZO1X_MEM_COMPRESS,
> 
> workmem_sz should be part of compressor internal.
> 
> > +	.compress = lzo1x_1_compress,
> > +	.decompress = lzo1x_decompress_safe,
> > +};
> > +
> >  #define ZRAM_ATTR_RO(name)						\
> >  static ssize_t zram_attr_##name##_show(struct device *d,		\
> >  				struct device_attribute *attr, char *b)	\
> > @@ -166,14 +171,14 @@ static void zram_meta_free(struct zram_meta *meta)
> >  	kfree(meta);
> >  }
> >  
> > -static struct zram_meta *zram_meta_alloc(u64 disksize)
> > +static struct zram_meta *zram_meta_alloc(int workmem_sz, u64 disksize)
> >  {
> >  	size_t num_pages;
> >  	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
> >  	if (!meta)
> >  		goto out;
> >  
> > -	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
> > +	meta->compress_workmem = kzalloc(workmem_sz, GFP_KERNEL);
> 
> Instead of exposing compression internal stuff, let's call comp->create.
> 
> >  	if (!meta->compress_workmem)
> >  		goto free_meta;
> >  
> > @@ -301,7 +306,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> >  	if (size == PAGE_SIZE)
> >  		copy_page(mem, cmem);
> >  	else
> > -		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
> > +		ret = zram->ops->decompress(cmem, size, mem, &clen);
> >  	zs_unmap_object(meta->mem_pool, handle);
> >  	read_unlock(&meta->tb_lock);
> >  
> > @@ -420,7 +425,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  		goto out;
> >  	}
> >  
> > -	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
> > +	ret = zram->ops->compress(uncmem, PAGE_SIZE, src, &clen,
> >  			       meta->compress_workmem);
> 
> Ditto. compress_workmem should be part of compressor itself.
> 
> 
> >  	if (!is_partial_io(bvec)) {
> >  		kunmap_atomic(user_mem);
> > @@ -551,7 +556,7 @@ static ssize_t disksize_store(struct device *dev,
> >  	}
> >  
> >  	disksize = PAGE_ALIGN(disksize);
> > -	zram->meta = zram_meta_alloc(disksize);
> > +	zram->meta = zram_meta_alloc(zram->ops->workmem_sz, disksize);
> 
> So, we don't need zram->ops->workmem_sz.
> 
> >  
> >  	zram->disksize = disksize;
> >  	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
> > @@ -785,6 +790,7 @@ static int create_device(struct zram *zram, int device_id)
> >  		goto out_free_disk;
> >  	}
> >  
> > +	zram->ops = &lzo_compressor;
> 
> Let's define choose_compressor function with some argument
> so the result is following as
> 
> zram->comp = choose_compressor("lzo");
> 
> >  	zram->meta = NULL;
> >  	return 0;
> >  
> > diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> > index 1d5b1f5..5488682 100644
> > --- a/drivers/block/zram/zram_drv.h
> > +++ b/drivers/block/zram/zram_drv.h
> > @@ -88,8 +88,18 @@ struct zram_meta {
> >  	struct mutex buffer_lock; /* protect compress buffers */
> >  };
> >  
> > +/* compression/decompression functions and algorithm-specific workmem size */
> > +struct zram_compress_ops {
> > +	int (*compress)(const unsigned char *src, size_t src_len,
> > +			unsigned char *dst, size_t *dst_len, void *wrkmem);
> > +	int (*decompress)(const unsigned char *src, size_t src_len,
> > +			unsigned char *dst, size_t *dst_len);
> > +	long workmem_sz;
> > +};
> > +
> >  struct zram {
> >  	struct zram_meta *meta;
> > +	struct zram_compress_ops *ops;
> >  	struct request_queue *queue;
> >  	struct gendisk *disk;
> >  	/* Prevent concurrent execution of device init, reset and R/W request */
> > -- 
> > 1.8.5.3.493.gb139ac2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Kind regards,
> Minchan Kim
> 
