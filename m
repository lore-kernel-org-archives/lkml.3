Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaAKJ4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 04:56:23 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:59173 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaAKJ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 04:56:16 -0500
Date: Sat, 11 Jan 2014 09:56:24 +0000
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Luigi Semenzato <semenzato@google.com>
Subject: Re: [PATCH -next] zram: do not pass rw argument to
 __zram_make_request()
Message-ID: <20140111095623.GA21479@gmail.com>
References: <20140109132343.GB2246@swordfish.minsk.epam.com>
 <20140110071445.GK1992@bbox>
 <20140110090059.GA2386@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110090059.GA2386@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 12:00:59PM +0300, Sergey Senozhatsky wrote:
> On (01/10/14 16:14), Minchan Kim wrote:
> > On Thu, Jan 09, 2014 at 04:23:43PM +0300, Sergey Senozhatsky wrote:
> > > Do not pass rw argument down the __zram_make_request() -> zram_bvec_rw()
> > > chain, decode it in zram_bvec_rw() instead. Besides, this is the place
> > > where we distinguish READ and WRITE bio data directions, so account zram
> > > RW stats here, instead of __zram_make_request(). This also allows to
> > > account a real number of zram READ/WRITE operations, not just requests
> > > (RW request may end up in a number of zram RW ops with separate
> > > locking, compression/decompression, slot free handling, etc).
> > 
> > Looks sane to me because other statistic variable accounts per bio, not
> > request. But it changes current statistic's semantic so they could be
> > regressed. Let's wait a bit for other's opinion.
> > 
> 
> Hello,
> 
> well, imho current zram stats are a bit meaningless and misleading. some data

Agreed and I wanted to look into that but I was hesitant about that
because there was some hurdle to enhance it during staying -staging.
(I guess you understand whant I'm saying. ;-) )

> simply makes a little sense, some data is not visible to end user at all, etc. my
> plan was to revisit it before 3.14 merge window (which is also the end of promotion,
> I guess). after 3.14 merge window we will not be able to change this easily.

Fair enough and we don't have any obstacle to prevent it any more
and it would be great if it would be done until mainlining.
Let's go ahead.

> 
> I was going to publish stats rework patch today. It removes code duplication
> and re-organizes end user visible stats. so here it is (w/o the proper commit
> message)
> 
> 	num_reads
> 	num_writes
> 	pages_stored
> 	invalid_io
> 	notify_free
> 	pages_zero
> 	compressed_size
> 	memory_used

Will review it when I go to the office.
Thanks!

> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> ---
> 
>  drivers/block/zram/zram_drv.c | 171 +++++++++++-------------------------------
>  drivers/block/zram/zram_drv.h |  15 ++--
>  2 files changed, 51 insertions(+), 135 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 798793f..234e703 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -42,6 +42,17 @@ static struct zram *zram_devices;
>  /* Module params (documentation at end) */
>  static unsigned int num_devices = 1;
>  
> +#define ZRAM_ATTR_RO(name)						\
> +static ssize_t zram_attr_##name##_show(struct device *d,		\
> +				struct device_attribute *attr, char *b)	\
> +{									\
> +	struct zram *zram = dev_to_zram(d);				\
> +	return sprintf(b, "%llu\n",					\
> +		(u64)atomic64_read(&zram->stats.name));			\
> +}									\
> +static struct device_attribute dev_attr_##name =			\
> +	__ATTR(name, S_IRUGO, zram_attr_##name##_show, NULL);
> +
>  static inline int init_done(struct zram *zram)
>  {
>  	return zram->meta != NULL;
> @@ -52,97 +63,31 @@ static inline struct zram *dev_to_zram(struct device *dev)
>  	return (struct zram *)dev_to_disk(dev)->private_data;
>  }
>  
> -static ssize_t disksize_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct zram *zram = dev_to_zram(dev);
> -
> -	return sprintf(buf, "%llu\n", zram->disksize);
> -}
> -
> -static ssize_t initstate_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct zram *zram = dev_to_zram(dev);
> -
> -	return sprintf(buf, "%u\n", init_done(zram));
> -}
> -
> -static ssize_t num_reads_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct zram *zram = dev_to_zram(dev);
> -
> -	return sprintf(buf, "%llu\n",
> -			(u64)atomic64_read(&zram->stats.num_reads));
> -}
> -
> -static ssize_t num_writes_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct zram *zram = dev_to_zram(dev);
> -
> -	return sprintf(buf, "%llu\n",
> -			(u64)atomic64_read(&zram->stats.num_writes));
> -}
> -
> -static ssize_t invalid_io_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct zram *zram = dev_to_zram(dev);
> -
> -	return sprintf(buf, "%llu\n",
> -			(u64)atomic64_read(&zram->stats.invalid_io));
> -}
> -
> -static ssize_t notify_free_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct zram *zram = dev_to_zram(dev);
> -
> -	return sprintf(buf, "%llu\n",
> -			(u64)atomic64_read(&zram->stats.notify_free));
> -}
> -
> -static ssize_t zero_pages_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct zram *zram = dev_to_zram(dev);
> -
> -	return sprintf(buf, "%u\n", zram->stats.pages_zero);
> -}
> -
> -static ssize_t orig_data_size_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> +static ssize_t memory_used_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> +	u64 val = 0;
>  	struct zram *zram = dev_to_zram(dev);
> +	struct zram_meta *meta = zram->meta;
>  
> -	return sprintf(buf, "%llu\n",
> -		(u64)(zram->stats.pages_stored) << PAGE_SHIFT);
> +	down_read(&zram->init_lock);
> +	if (init_done(zram))
> +		val = zs_get_total_size_bytes(meta->mem_pool);
> +	up_read(&zram->init_lock);
> +	return sprintf(buf, "%llu\n", val);
>  }
>  
> -static ssize_t compr_data_size_show(struct device *dev,
> +static ssize_t disksize_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct zram *zram = dev_to_zram(dev);
> -
> -	return sprintf(buf, "%llu\n",
> -			(u64)atomic64_read(&zram->stats.compr_size));
> +	return sprintf(buf, "%llu\n", zram->disksize);
>  }
>  
> -static ssize_t mem_used_total_show(struct device *dev,
> +static ssize_t initstate_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> -	u64 val = 0;
>  	struct zram *zram = dev_to_zram(dev);
> -	struct zram_meta *meta = zram->meta;
> -
> -	down_read(&zram->init_lock);
> -	if (init_done(zram))
> -		val = zs_get_total_size_bytes(meta->mem_pool);
> -	up_read(&zram->init_lock);
> -
> -	return sprintf(buf, "%llu\n", val);
> +	return sprintf(buf, "%u\n", init_done(zram));
>  }
>  
>  static int zram_test_flag(struct zram_meta *meta, u32 index,
> @@ -289,7 +234,6 @@ static void zram_free_page(struct zram *zram, size_t index)
>  {
>  	struct zram_meta *meta = zram->meta;
>  	unsigned long handle = meta->table[index].handle;
> -	u16 size = meta->table[index].size;
>  
>  	if (unlikely(!handle)) {
>  		/*
> @@ -298,21 +242,14 @@ static void zram_free_page(struct zram *zram, size_t index)
>  		 */
>  		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
>  			zram_clear_flag(meta, index, ZRAM_ZERO);
> -			zram->stats.pages_zero--;
> +			atomic64_dec(&zram->stats.pages_zero);
>  		}
>  		return;
>  	}
>  
> -	if (unlikely(size > max_zpage_size))
> -		zram->stats.bad_compress--;
> -
>  	zs_free(meta->mem_pool, handle);
> -
> -	if (size <= PAGE_SIZE / 2)
> -		zram->stats.good_compress--;
> -
> -	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
> -	zram->stats.pages_stored--;
> +	atomic64_sub(meta->table[index].size, &zram->stats.compressed_size);
> +	atomic64_dec(&zram->stats.pages_stored);
>  
>  	meta->table[index].handle = 0;
>  	meta->table[index].size = 0;
> @@ -352,7 +289,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
>  static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
>  			  u32 index, int offset, struct bio *bio)
>  {
> -	int ret;
> +	int ret = -EINVAL;
>  	struct page *page;
>  	unsigned char *user_mem, *uncmem = NULL;
>  	struct zram_meta *meta = zram->meta;
> @@ -393,6 +330,8 @@ out_cleanup:
>  	kunmap_atomic(user_mem);
>  	if (is_partial_io(bvec))
>  		kfree(uncmem);
> +	if (ret)
> +		atomic64_inc(&zram->stats.failed_reads);
>  	return ret;
>  }
>  
> @@ -440,7 +379,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  		/* Free memory associated with this sector now. */
>  		zram_free_page(zram, index);
>  
> -		zram->stats.pages_zero++;
> +		atomic64_inc(&zram->stats.pages_zero);
>  		zram_set_flag(meta, index, ZRAM_ZERO);
>  		ret = 0;
>  		goto out;
> @@ -469,7 +408,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	}
>  
>  	if (unlikely(clen > max_zpage_size)) {
> -		zram->stats.bad_compress++;
>  		clen = PAGE_SIZE;
>  		src = NULL;
>  		if (is_partial_io(bvec))
> @@ -503,17 +441,12 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  
>  	meta->table[index].handle = handle;
>  	meta->table[index].size = clen;
> -
>  	/* Update stats */
> -	atomic64_add(clen, &zram->stats.compr_size);
> -	zram->stats.pages_stored++;
> -	if (clen <= PAGE_SIZE / 2)
> -		zram->stats.good_compress++;
> -
> +	atomic64_add(clen, &zram->stats.compressed_size);
> +	atomic64_inc(&zram->stats.pages_stored);
>  out:
>  	if (is_partial_io(bvec))
>  		kfree(uncmem);
> -
>  	if (ret)
>  		atomic64_inc(&zram->stats.failed_writes);
>  	return ret;
> @@ -594,23 +527,8 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  
>  static void zram_init_device(struct zram *zram, struct zram_meta *meta)
>  {
> -	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
> -		pr_info(
> -		"There is little point creating a zram of greater than "
> -		"twice the size of memory since we expect a 2:1 compression "
> -		"ratio. Note that zram uses about 0.1%% of the size of "
> -		"the disk when not in use so a huge zram is "
> -		"wasteful.\n"
> -		"\tMemory Size: %lu kB\n"
> -		"\tSize you selected: %llu kB\n"
> -		"Continuing anyway ...\n",
> -		(totalram_pages << PAGE_SHIFT) >> 10, zram->disksize >> 10
> -		);
> -	}
> -
>  	/* zram devices sort of resembles non-rotational disks */
>  	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
> -
>  	zram->meta = meta;
>  	pr_debug("Initialization done!\n");
>  }
> @@ -803,14 +721,15 @@ static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
>  		disksize_show, disksize_store);
>  static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
>  static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
> -static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
> -static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
> -static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
> -static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
> -static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
> -static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
> -static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
> -static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
> +static DEVICE_ATTR(memory_used, S_IRUGO, memory_used_show, NULL);
> +
> +ZRAM_ATTR_RO(num_reads);
> +ZRAM_ATTR_RO(num_writes);
> +ZRAM_ATTR_RO(pages_stored);
> +ZRAM_ATTR_RO(invalid_io);
> +ZRAM_ATTR_RO(notify_free);
> +ZRAM_ATTR_RO(pages_zero);
> +ZRAM_ATTR_RO(compressed_size);
>  
>  static struct attribute *zram_disk_attrs[] = {
>  	&dev_attr_disksize.attr,
> @@ -818,12 +737,12 @@ static struct attribute *zram_disk_attrs[] = {
>  	&dev_attr_reset.attr,
>  	&dev_attr_num_reads.attr,
>  	&dev_attr_num_writes.attr,
> +	&dev_attr_pages_stored.attr,
>  	&dev_attr_invalid_io.attr,
>  	&dev_attr_notify_free.attr,
> -	&dev_attr_zero_pages.attr,
> -	&dev_attr_orig_data_size.attr,
> -	&dev_attr_compr_data_size.attr,
> -	&dev_attr_mem_used_total.attr,
> +	&dev_attr_pages_zero.attr,
> +	&dev_attr_compressed_size.attr,
> +	&dev_attr_memory_used.attr,
>  	NULL,
>  };
>  
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> index 1388bad..6b00d4d 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -64,8 +64,7 @@ enum zram_pageflags {
>  struct table {
>  	unsigned long handle;
>  	u16 size;	/* object size (excluding header) */
> -	u8 count;	/* object ref count (not yet used) */
> -	u8 flags;
> +	u16 flags;
>  } __aligned(4);
>  
>  /*
> @@ -73,17 +72,15 @@ struct table {
>   * All modifications to 32bit counter should be protected by zram->lock.
>   */
>  struct zram_stats {
> -	atomic64_t compr_size;	/* compressed size of pages stored */
> -	atomic64_t num_reads;	/* failed + successful */
> -	atomic64_t num_writes;	/* --do-- */
> +	atomic64_t num_writes;	/* number of writes */
> +	atomic64_t num_reads;	/* number of reads */
> +	atomic64_t pages_stored;	/* no. of pages currently stored */
> +	atomic64_t compressed_size;	/* compressed size of pages stored */
> +	atomic64_t pages_zero;		/* no. of zero filled pages */
>  	atomic64_t failed_reads;	/* should NEVER! happen */
>  	atomic64_t failed_writes;	/* can happen when memory is too low */
>  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
>  	atomic64_t notify_free;	/* no. of swap slot free notifications */
> -	u32 pages_zero;		/* no. of zero filled pages */
> -	u32 pages_stored;	/* no. of pages currently stored */
> -	u32 good_compress;	/* % of pages with compression ratio<=50% */
> -	u32 bad_compress;	/* % of pages with compression ratio>=75% */
>  };
>  
>  struct zram_meta {
> 
