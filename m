Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaANLNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:13:08 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:48464 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaANLNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:13:05 -0500
Date: Tue, 14 Jan 2014 14:10:12 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] zram: rework reported to end-user zram statistics
Message-ID: <20140114111012.GC2180@swordfish.minsk.epam.com>
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389692260-4421-4-git-send-email-sergey.senozhatsky@gmail.com>
 <52D513BD.7000800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D513BD.7000800@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/14/14 11:38), Jerome Marchand wrote:
> On 01/14/2014 10:37 AM, Sergey Senozhatsky wrote:
> > 1) Introduce ZRAM_ATTR_RO macro to generate zram atomic64_t stats
> > `show' functions and reduce code duplication.
> > 
> > 2) Account and report back to user numbers of failed READ and WRITE
> > operations.
> > 
> > 3) Remove `good' and `bad' compressed sub-requests stats. RW request may
> > cause a number of RW sub-requests. zram used to account `good' compressed
> > sub-queries (with compressed size less than 50% of original size), `bad'
> > compressed sub-queries (with compressed size greater that 75% of original
> > size), leaving sub-requests with compression size between 50% and 75% of
> > original size not accounted and not reported.
> 
> That's weird: good/bad_compress are accounted, but it seems to me that
> they are to never used in any way. If so, there is indeed no reason to
> keep them.
> 
>
> > Account each sub-request
> > compression size so we can calculate real device compression ratio.
> 
> Your patch doesn't change the way pages_stored and compr[essed]_size
> are accounted. What does your patch change that allow us to calculate
> the "real" compression ratio?
> 
> > 
> > 4) reported zram stats:
> >   - num_writes  -- number of writes
> >   - num_reads  -- number of reads
> >   - pages_stored -- number of pages currently stored
> >   - compressed_size -- compressed size of pages stored
> 
> Wouldn't it be more practical to report the original and compressed
> data sizes using the same units as it is currently done?
> 

hm, do we really need pages_stored stats? what kind of unseful information it
shows to end user?.. perhaps, it's better to replace it with accounted passed
bvec->bv_len (as uncompressed_size).

	-ss

> Jerome
> 
> >   - pages_zero  -- number of zero filled pages
> >   - failed_read -- number of failed reads
> >   - failed_writes -- can happen when memory is too low
> >   - invalid_io   -- non-page-aligned I/O requests
> >   - notify_free  -- number of swap slot free notifications
> >   - memory_used -- zs pool zs_get_total_size_bytes()
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> >  drivers/block/zram/zram_drv.c | 167 ++++++++++++------------------------------
> >  drivers/block/zram/zram_drv.h |  17 ++---
> >  2 files changed, 54 insertions(+), 130 deletions(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index 2a7682c..8bddaff 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -42,6 +42,17 @@ static struct zram *zram_devices;
> >  /* Module params (documentation at end) */
> >  static unsigned int num_devices = 1;
> >  
> > +#define ZRAM_ATTR_RO(name)						\
> > +static ssize_t zram_attr_##name##_show(struct device *d,		\
> > +				struct device_attribute *attr, char *b)	\
> > +{									\
> > +	struct zram *zram = dev_to_zram(d);				\
> > +	return sprintf(b, "%llu\n",					\
> > +		(u64)atomic64_read(&zram->stats.name));			\
> > +}									\
> > +static struct device_attribute dev_attr_##name =			\
> > +	__ATTR(name, S_IRUGO, zram_attr_##name##_show, NULL);
> > +
> >  static inline int init_done(struct zram *zram)
> >  {
> >  	return zram->meta != NULL;
> > @@ -52,97 +63,36 @@ static inline struct zram *dev_to_zram(struct device *dev)
> >  	return (struct zram *)dev_to_disk(dev)->private_data;
> >  }
> >  
> > -static ssize_t disksize_show(struct device *dev,
> > -		struct device_attribute *attr, char *buf)
> > -{
> > -	struct zram *zram = dev_to_zram(dev);
> > -
> > -	return sprintf(buf, "%llu\n", zram->disksize);
> > -}
> > -
> > -static ssize_t initstate_show(struct device *dev,
> > -		struct device_attribute *attr, char *buf)
> > -{
> > -	struct zram *zram = dev_to_zram(dev);
> > -
> > -	return sprintf(buf, "%u\n", init_done(zram));
> > -}
> > -
> > -static ssize_t num_reads_show(struct device *dev,
> > -		struct device_attribute *attr, char *buf)
> > -{
> > -	struct zram *zram = dev_to_zram(dev);
> > -
> > -	return sprintf(buf, "%llu\n",
> > -			(u64)atomic64_read(&zram->stats.num_reads));
> > -}
> > -
> > -static ssize_t num_writes_show(struct device *dev,
> > -		struct device_attribute *attr, char *buf)
> > -{
> > -	struct zram *zram = dev_to_zram(dev);
> > -
> > -	return sprintf(buf, "%llu\n",
> > -			(u64)atomic64_read(&zram->stats.num_writes));
> > -}
> > -
> > -static ssize_t invalid_io_show(struct device *dev,
> > -		struct device_attribute *attr, char *buf)
> > -{
> > -	struct zram *zram = dev_to_zram(dev);
> > -
> > -	return sprintf(buf, "%llu\n",
> > -			(u64)atomic64_read(&zram->stats.invalid_io));
> > -}
> > -
> > -static ssize_t notify_free_show(struct device *dev,
> > -		struct device_attribute *attr, char *buf)
> > -{
> > -	struct zram *zram = dev_to_zram(dev);
> > -
> > -	return sprintf(buf, "%llu\n",
> > -			(u64)atomic64_read(&zram->stats.notify_free));
> > -}
> > -
> > -static ssize_t zero_pages_show(struct device *dev,
> > -		struct device_attribute *attr, char *buf)
> > -{
> > -	struct zram *zram = dev_to_zram(dev);
> > -
> > -	return sprintf(buf, "%u\n", atomic_read(&zram->stats.pages_zero));
> > -}
> > -
> > -static ssize_t orig_data_size_show(struct device *dev,
> > +static ssize_t memory_used_show(struct device *dev,
> >  		struct device_attribute *attr, char *buf)
> >  {
> > +	u64 val = 0;
> >  	struct zram *zram = dev_to_zram(dev);
> > +	struct zram_meta *meta = zram->meta;
> >  
> > -	return sprintf(buf, "%llu\n",
> > -		(u64)(atomic_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
> > +	down_read(&zram->init_lock);
> > +	if (init_done(zram))
> > +		val = zs_get_total_size_bytes(meta->mem_pool);
> > +	up_read(&zram->init_lock);
> > +	return sprintf(buf, "%llu\n", val);
> >  }
> >  
> > -static ssize_t compr_data_size_show(struct device *dev,
> > +static ssize_t disksize_show(struct device *dev,
> >  		struct device_attribute *attr, char *buf)
> >  {
> >  	struct zram *zram = dev_to_zram(dev);
> > -
> > -	return sprintf(buf, "%llu\n",
> > -			(u64)atomic64_read(&zram->stats.compr_size));
> > +	return sprintf(buf, "%llu\n", zram->disksize);
> >  }
> >  
> > -static ssize_t mem_used_total_show(struct device *dev,
> > +static ssize_t initstate_show(struct device *dev,
> >  		struct device_attribute *attr, char *buf)
> >  {
> > -	u64 val = 0;
> > +	u32 val = 0;
> >  	struct zram *zram = dev_to_zram(dev);
> > -	struct zram_meta *meta = zram->meta;
> > -
> >  	down_read(&zram->init_lock);
> > -	if (init_done(zram))
> > -		val = zs_get_total_size_bytes(meta->mem_pool);
> > +	val = init_done(zram);
> >  	up_read(&zram->init_lock);
> > -
> > -	return sprintf(buf, "%llu\n", val);
> > +	return sprintf(buf, "%u\n", val);
> >  }
> >  
> >  /* flag operations needs meta->tb_lock */
> > @@ -293,7 +243,6 @@ static void zram_free_page(struct zram *zram, size_t index)
> >  {
> >  	struct zram_meta *meta = zram->meta;
> >  	unsigned long handle = meta->table[index].handle;
> > -	u16 size = meta->table[index].size;
> >  
> >  	if (unlikely(!handle)) {
> >  		/*
> > @@ -302,21 +251,15 @@ static void zram_free_page(struct zram *zram, size_t index)
> >  		 */
> >  		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
> >  			zram_clear_flag(meta, index, ZRAM_ZERO);
> > -			atomic_dec(&zram->stats.pages_zero);
> > +			atomic64_dec(&zram->stats.pages_zero);
> >  		}
> >  		return;
> >  	}
> >  
> > -	if (unlikely(size > max_zpage_size))
> > -		atomic_dec(&zram->stats.bad_compress);
> > -
> >  	zs_free(meta->mem_pool, handle);
> >  
> > -	if (size <= PAGE_SIZE / 2)
> > -		atomic_dec(&zram->stats.good_compress);
> > -
> > -	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
> > -	atomic_dec(&zram->stats.pages_stored);
> > +	atomic64_sub(meta->table[index].size, &zram->stats.compressed_size);
> > +	atomic64_dec(&zram->stats.pages_stored);
> >  
> >  	meta->table[index].handle = 0;
> >  	meta->table[index].size = 0;
> > @@ -362,7 +305,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> >  static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
> >  			  u32 index, int offset, struct bio *bio)
> >  {
> > -	int ret;
> > +	int ret = -EINVAL;
> >  	struct page *page;
> >  	unsigned char *user_mem, *uncmem = NULL;
> >  	struct zram_meta *meta = zram->meta;
> > @@ -406,6 +349,8 @@ out_cleanup:
> >  	kunmap_atomic(user_mem);
> >  	if (is_partial_io(bvec))
> >  		kfree(uncmem);
> > +	if (ret)
> > +		atomic64_inc(&zram->stats.failed_reads);
> >  	return ret;
> >  }
> >  
> > @@ -459,7 +404,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  		zram_set_flag(meta, index, ZRAM_ZERO);
> >  		write_unlock(&zram->meta->tb_lock);
> >  
> > -		atomic_inc(&zram->stats.pages_zero);
> > +		atomic64_inc(&zram->stats.pages_zero);
> >  		ret = 0;
> >  		goto out;
> >  	}
> > @@ -478,7 +423,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  	}
> >  
> >  	if (unlikely(clen > max_zpage_size)) {
> > -		atomic_inc(&zram->stats.bad_compress);
> >  		clen = PAGE_SIZE;
> >  		src = NULL;
> >  		if (is_partial_io(bvec))
> > @@ -516,11 +460,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
> >  	write_unlock(&zram->meta->tb_lock);
> >  
> >  	/* Update stats */
> > -	atomic64_add(clen, &zram->stats.compr_size);
> > -	atomic_inc(&zram->stats.pages_stored);
> > -	if (clen <= PAGE_SIZE / 2)
> > -		atomic_inc(&zram->stats.good_compress);
> > -
> > +	atomic64_add(clen, &zram->stats.compressed_size);
> > +	atomic64_inc(&zram->stats.pages_stored);
> >  out:
> >  	if (locked)
> >  		mutex_unlock(&meta->buffer_lock);
> > @@ -586,23 +527,8 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
> >  
> >  static void zram_init_device(struct zram *zram, struct zram_meta *meta)
> >  {
> > -	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
> > -		pr_info(
> > -		"There is little point creating a zram of greater than "
> > -		"twice the size of memory since we expect a 2:1 compression "
> > -		"ratio. Note that zram uses about 0.1%% of the size of "
> > -		"the disk when not in use so a huge zram is "
> > -		"wasteful.\n"
> > -		"\tMemory Size: %lu kB\n"
> > -		"\tSize you selected: %llu kB\n"
> > -		"Continuing anyway ...\n",
> > -		(totalram_pages << PAGE_SHIFT) >> 10, zram->disksize >> 10
> > -		);
> > -	}
> > -
> >  	/* zram devices sort of resembles non-rotational disks */
> >  	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
> > -
> >  	zram->meta = meta;
> >  	pr_debug("Initialization done!\n");
> >  }
> > @@ -774,14 +700,15 @@ static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
> >  		disksize_show, disksize_store);
> >  static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
> >  static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
> > -static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
> > -static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
> > -static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
> > -static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
> > -static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
> > -static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
> > -static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
> > -static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
> > +static DEVICE_ATTR(memory_used, S_IRUGO, memory_used_show, NULL);
> > +
> > +ZRAM_ATTR_RO(num_reads);
> > +ZRAM_ATTR_RO(num_writes);
> > +ZRAM_ATTR_RO(pages_stored);
> > +ZRAM_ATTR_RO(invalid_io);
> > +ZRAM_ATTR_RO(notify_free);
> > +ZRAM_ATTR_RO(pages_zero);
> > +ZRAM_ATTR_RO(compressed_size);
> >  
> >  static struct attribute *zram_disk_attrs[] = {
> >  	&dev_attr_disksize.attr,
> > @@ -789,12 +716,12 @@ static struct attribute *zram_disk_attrs[] = {
> >  	&dev_attr_reset.attr,
> >  	&dev_attr_num_reads.attr,
> >  	&dev_attr_num_writes.attr,
> > +	&dev_attr_pages_stored.attr,
> >  	&dev_attr_invalid_io.attr,
> >  	&dev_attr_notify_free.attr,
> > -	&dev_attr_zero_pages.attr,
> > -	&dev_attr_orig_data_size.attr,
> > -	&dev_attr_compr_data_size.attr,
> > -	&dev_attr_mem_used_total.attr,
> > +	&dev_attr_pages_zero.attr,
> > +	&dev_attr_compressed_size.attr,
> > +	&dev_attr_memory_used.attr,
> >  	NULL,
> >  };
> >  
> > diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> > index e81e9cd..277023d 100644
> > --- a/drivers/block/zram/zram_drv.h
> > +++ b/drivers/block/zram/zram_drv.h
> > @@ -64,22 +64,19 @@ enum zram_pageflags {
> >  struct table {
> >  	unsigned long handle;
> >  	u16 size;	/* object size (excluding header) */
> > -	u8 count;	/* object ref count (not yet used) */
> > -	u8 flags;
> > +	u16 flags;
> >  } __aligned(4);
> >  
> >  struct zram_stats {
> > -	atomic64_t compr_size;	/* compressed size of pages stored */
> > -	atomic64_t num_reads;	/* failed + successful */
> > -	atomic64_t num_writes;	/* --do-- */
> > -	atomic64_t failed_reads;	/* should NEVER! happen */
> > +	atomic64_t num_writes;	/* number of writes */
> > +	atomic64_t num_reads;	/* number of reads */
> > +	atomic64_t pages_stored;	/* no. of pages currently stored */
> > +	atomic64_t compressed_size;	/* compressed size of pages stored */
> > +	atomic64_t pages_zero;		/* no. of zero filled pages */
> > +	atomic64_t failed_reads;	/* no. of failed reads */
> >  	atomic64_t failed_writes;	/* can happen when memory is too low */
> >  	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
> >  	atomic64_t notify_free;	/* no. of swap slot free notifications */
> > -	atomic_t pages_zero;		/* no. of zero filled pages */
> > -	atomic_t pages_stored;	/* no. of pages currently stored */
> > -	atomic_t good_compress;	/* % of pages with compression ratio<=50% */
> > -	atomic_t bad_compress;	/* % of pages with compression ratio>=75% */
> >  };
> >  
> >  struct zram_meta {
> > 
> 
